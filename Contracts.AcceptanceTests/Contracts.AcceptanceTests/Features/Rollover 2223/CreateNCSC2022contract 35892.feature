Feature: CreateNCSC2022contract 35892

@AcceptanceTest @Complete
@ADP
Scenario: A631 Bulk create and approve a new NCS-C2022 contract with a Master linked to NCS-C2122. Check CRM, PaaS and docs plus CM and ADP feeds
    Given there are no allocations marked as Under Termination for UKPRN '10017631' 
    And   there are no terminated or closed allocations for UKPRN '10017631' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017631' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017631' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017631' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | NCSC-631      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | NCSC-631      |
    
    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | NCS-C2022         |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017631'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017631' 
    And   there is no caseload advisor for UKPRN '10017631' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017631 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017631' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017631 Co Ltd' with UKPRN '10017631' and OrgId 'ORG0017631' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017631 | 117631 | 10017631 Co Ltd | 0              | Active                | Yes           | AA017631      | ?             | 49 Station Approach    | West Byfleet           | Surrey                 | ?                      | ?                      | ?                      | KT14 6NE  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017631 |



    # Part 2: Create and approve NCS-C2122 contract

    # Change the date
    Given the override date is '01/03/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'NCS-631'
    And   there are no details in ContractManagement.CreatedContract for 'NCS-631'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017631 | 10017631 Co Ltd      | ESFA-631             | NCS-631        | 1                     | 01/04/2021        | 31/03/2022      | 59504.00      | North West                            | Contract for Services                      | 2122   | New          | ORG0017631 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                     | CRMIntent    | DeliveryOrg |
    | 10017631 | NCS-631        | NCSC-631      | NCS-C             | NCS-C2122               | FY                      | 01/04/2021          | 31/03/2022        | 59504.00        | North West                              | 0000000105 |                                           | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | DeliverableDescription                      | CRMIntent    | DeliveryOrg |
    | 10017631 | NCS-631        | NCSC-631      | 1               | 0                     | 59504.00  | 3894.00  | 4709.00  | 3247.00  | 3933.00  | 4590.00  | 3602.00  | 7551.00  | 8776.00  | 4116.00  | 5026.00  | 2297.00  | 7763.00  | Total In The Community Funding              | New          |             | 
    | 10017631 | NCS-631        | NCSC-631      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                 | New          |             | 
    | 10017631 | NCS-631        | NCSC-631      | 2               | 1                     | 21764.00  | 1630.00  | 2144.00  | 603.00   | 1527.00  | 1472.00  | 2619.00  | 2881.00  | 3078.00  | 2485.00  | 563.00   | 1645.00  | 1117.00  | Customer Satisfaction                       | New          |             | 
    | 10017631 | NCS-631        | NCSC-631      | 3               | 1                     | 37740.00  | 2264.00  | 2565.00  | 2644.00  | 2406.00  | 3118.00  | 983.00   | 4670.00  | 5698.00  | 1631.00  | 4463.00  | 652.00   | 6646.00  | Career Management and Jobs and Learning     | New          |             | 
    | 10017631 | NCS-631        | NCSC-631      | 4               | 3                     | 16825.00  | 1891.00  | 601.00   | 769.00   | 2231.00  | 561.00   | 887.00   | 1876.00  | 2612.00  | 403.00   | 1362.00  | 452.00   | 3180.00  | Career Management                           | New          |             | 
    | 10017631 | NCS-631        | NCSC-631      | 5               | 3                     | 20915.00  | 373.00   | 1964.00  | 1875.00  | 175.00   | 2557.00  | 96.00    | 2794.00  | 3086.00  | 1228.00  | 3101.00  | 200.00   | 3466.00  | Jobs and Learning                           | New          |             | 

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | 
    | 10017631 | NCS-631        | NCSC-631      | 6               | 0        | 654     | 53       | 81       | 22       | 58       | 91       | 81       | 63       | 27       | 43       | 44       | 41       | 50       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | NCS-631        | 1                     | 0                        | 2021-03-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NCS-631'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
  # When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-631' and actual ContractNumber 'NCS-631'
    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-631' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017631 | NCS-631            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017631 | ESFA-631           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'NCS-631' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'NCS-631'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | NCSC-631        | 2305310          | Mar-22 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '6' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10017631 | NCS-631        | 1               | NCSC-631      | 1               | 0                     | 59504.00     | 0             | 0        | Total In The Community Funding                                  | ?                                                           |
    | 10017631 | NCS-631        | 1               | NCSC-631      | 6               | 0                     | 0.00         | 654           | 0        | Customers Accessing Service                                     | ?                                                           |
    | 10017631 | NCS-631        | 1               | NCSC-631      | 2               | 1                     | 21764.00     | 0             | 0        | Customer Satisfaction                                           | ?                                                           |
    | 10017631 | NCS-631        | 1               | NCSC-631      | 3               | 1                     | 37740.00     | 0             | 0        | Career Management and Jobs and Learning                         | ?                                                           |
    | 10017631 | NCS-631        | 1               | NCSC-631      | 4               | 3                     | 16825.00     | 0             | 0        | Career Management                                               | ?                                                           |
    | 10017631 | NCS-631        | 1               | NCSC-631      | 5               | 3                     | 20915.00     | 0             | 0        | Jobs and Learning                                               | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'NCS-631' agree with the most recent entry for this contract in the ContractManagement feed





    # Part 3: Bulk file to create a new NCS-C2022 contract linked to NCS-C2122 by Master

    # Change the date
    Given the override date is '01/03/2022'

    # Bulk file (New Amendment)
    And   there are no files prefixed '10017631' in the Sharepoint 'NCS-2022-Input-Appendices' folder
    And   there are no files prefixed 'NCS NCS 2022 09022022161022 v3_A631' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NCS NCS 2022 09022022161022 v3_A631' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NCS NCS 2022 09022022161022 v3_A631' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NCS NCS 2022 09022022161022 v3_A631' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NCS NCS 2022 09022022161022 v3_A631.xlsx' exists in the Datafiles folder and UKPRN '10017631' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017631' for FundingType 'NCS' and period '2022' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017631' for FundingType 'NCS' and period '2022'

    # Check the contents of the Appendices
    Then  the file named '10017631_[ContractNo]_v1.pdf' in Sharepoint location 'NCS-2022-Input-Appendices' contains the following lines in order
    """
    SCHEDULE 6
    Maximum Contract Value and Target
    Customer Volumes
    Maximum Contract Value
    2. This Schedule sets out the Maximum Contract Value for the supply of the
    Services under the Contract from 1 April 2022 – 30 September 2022.  Delivery
    3. The Maximum Contract Value in the Area for the period 1 April 2022 – 30
    September 2022 is £48,857. The Maximum Contract Value must be allocated in
    accordance with the principles set out in the Funding Rules.

    Target Customer Volumes
    7. The Target Customer Volumes are as follows:
    Contract Year Target Customer Volumes
    01/04/22 – 30/09/22 1,006  
    """

     #And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'
    
    # Display Sharepoint filename
    And   message '10017631_[ContractNo]_v1.pdf' is written to the Output window

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017631_[ContractNo]_v1.pdf' in 'NCS-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A631.pdf'


    
    
    
    # Publish and approve the contract

    # Change the date
    Given the override date is '12/03/2022'

    # Publish the contract
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'  
    
    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-631' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017631 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2022        | 30/09/2022      | ?             |
    | 10017631 | NCS-631            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017631 | ESFA-631           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'


    # Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   |
    | [ContractNo]   | [AllocRef_NCSC]    | 1               | 48857.00  | 5813.00  | 8595.00  | 10149.00 | 5488.00  | 8563.00  | 10249.00 | 
    | [ContractNo]   | [AllocRef_NCSC]    | 2               | 16292.00  | 2074.00  | 1578.00  | 4381.00  | 924.00   | 2709.00  | 4626.00  | 
    | [ContractNo]   | [AllocRef_NCSC]    | 3               | 32565.00  | 3739.00  | 7017.00  | 5768.00  | 4564.00  | 5854.00  | 5623.00  | 
    | [ContractNo]   | [AllocRef_NCSC]    | 4               | 20291.00  | 964.00   | 4910.00  | 2973.00  | 3832.00  | 3885.00  | 3727.00  | 
    | [ContractNo]   | [AllocRef_NCSC]    | 5               | 12274.00  | 2775.00  | 2107.00  | 2795.00  | 732.00   | 1969.00  | 1896.00  | 
    | [ContractNo]   | [AllocRef_NCSC]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PLANNED VOLUMES in CRM on the latest approved contract
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   |
    | [ContractNo]   | [AllocRef_NCSC]    | 1               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 2               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 3               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 4               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 5               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 6               | 1006      | 201      | 212      | 179      | 175      | 134      | 105      | 



    # Check CM feed
    
    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '6' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                            | DeliverableDescription    | 
    | 10017631 | [ContractNo]   | 1               | [AllocRef_NCSC] | 1               | 0                     | 48857.00     | 0             | 0        | Total In The Community Funding             | ?                         |
    | 10017631 | [ContractNo]   | 1               | [AllocRef_NCSC] | 6               | 0                     | 0.00         | 1006          | 0        | Customers Accessing Service                | ?                         |
    | 10017631 | [ContractNo]   | 1               | [AllocRef_NCSC] | 2               | 1                     | 16292.00     | 0             | 0        | Customer Satisfaction                      | ?                         |
    | 10017631 | [ContractNo]   | 1               | [AllocRef_NCSC] | 3               | 1                     | 32565.00     | 0             | 0        | Career Management and Jobs and Learning    | ?                         |
    | 10017631 | [ContractNo]   | 1               | [AllocRef_NCSC] | 4               | 3                     | 20291.00     | 0             | 0        | Career Management                          | ?                         |
    | 10017631 | [ContractNo]   | 1               | [AllocRef_NCSC] | 5               | 3                     | 12274.00     | 0             | 0        | Jobs and Learning                          | ?                         |

 


#    # CDA
#    
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Last Approved Version A631.csv'
#
#    Then  the contracts are in the replicated CRM database as follows
#    | ContractNumber | ContractVersionNumber |
#    | [ContractNo]   | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version                 | Suffix |
#    | NCS-C2022             | Last Approved Version   | A631   |
#
#    Then  a report named 'CDA Last Approved Version A631.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 4                 | 2022            | 2022/23       |              | 964          |              |               |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Apr              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 5                 | 2022            | 2022/23       |              | 4910         |              |               |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | May              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 6                 | 2022            | 2022/23       |              | 2973         |              |               |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Jun              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 7                 | 2022            | 2022/23       |              | 3832         |              |               |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Jul              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 8                 | 2022            | 2022/23       |              | 3885         |              |               |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Aug              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 9                 | 2022            | 2022/23       |              | 3727         |              |               |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Sep              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 4                 | 2022            | 2022/23       |              | 2074         |              |               |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Apr              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 5                 | 2022            | 2022/23       |              | 1578         |              |               |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | May              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 6                 | 2022            | 2022/23       |              | 4381         |              |               |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Jun              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 7                 | 2022            | 2022/23       |              | 924          |              |               |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Jul              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 8                 | 2022            | 2022/23       |              | 2709         |              |               |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Aug              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 9                 | 2022            | 2022/23       |              | 4626         |              |               |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Sep              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 4                 | 2022            | 2022/23       |              | 0            |              | 201           |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Apr              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 5                 | 2022            | 2022/23       |              | 0            |              | 212           |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | May              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 6                 | 2022            | 2022/23       |              | 0            |              | 179           |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Jun              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 7                 | 2022            | 2022/23       |              | 0            |              | 175           |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Jul              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 8                 | 2022            | 2022/23       |              | 0            |              | 134           |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Aug              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 9                 | 2022            | 2022/23       |              | 0            |              | 105           |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Sep              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 4                 | 2022            | 2022/23       |              | 2775         |              |               |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Apr              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 5                 | 2022            | 2022/23       |              | 2107         |              |               |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | May              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 6                 | 2022            | 2022/23       |              | 2795         |              |               |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Jun              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 7                 | 2022            | 2022/23       |              | 732          |              |               |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Jul              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 8                 | 2022            | 2022/23       |              | 1969         |              |               |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Aug              |
#    | NCS-C2022               | 10017631 | 10017631 Co Ltd             |               |                             | [AllocRef_NCSC]          | [ContractNo]   | ESFA-631                | 01/04/2022                  | 30/09/2022                | 1                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 9                 | 2022            | 2022/23       |              | 1896         |              |               |              | No                 |                |                  |                       |                | 0.00            |             | No            | North West        |        |                   |                          |                   | Sep              |



    # ADP Feed (See A184)

    # Check all activity has completed
    When  there are no messages left in the system

    # Contract Schema check
   #And   the ItemType '0' event for version 'n' of actual contract number 'APPLEVY-125' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema
    Then  the ItemType '0' event for version '1' of contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema
   
    # Check that the relevant events are on the ADP feed
    And   the ADP feed includes the following values
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | ContractVersionNumber | SubVersionNumber | AllocationNumber | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    | NewContractAllocationApproved     | 0      | [ContractNo]   | 1                     | 0                | [AllocRef_NCSC]  | ?                         | ?                            | 

    # Check the ADP feed event header information
    And   the Allocation Delivery feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                        | CategoryLabel                        | Title                                                                               |
    | 10017631 | [ContractNo]   | 1               | 0                  | NewContractAllocationApproved       | New Contract Allocation Approved     | New Contract [ContractNo]: 1.0 with Allocation [AllocRef_NCSC] was Approved         |

 #  There is no payment-related data for this contract so nothing in the feed. As such, the following step fails. Check details in feed MANUALLY 
 #
 #  # Check financials on the ADP feed
 #  And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
 #  | AllocationDeliveryEntryCategory   | ContractNumber | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
 #  | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 1               | 202204 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
 #  | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 2               | 202204 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
 #  | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 3               | 202204 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
 #  | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 4               | 202204 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
 #  | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 5               | 202204 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
 #  | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 6               | 202204 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
 #
 #  # Check PLANNED volume details on the AllocationDelivery.AllocationDeliveryEvent (ADP) feed (This step needs the step above to have run first)
 #  And   the planned volume details on the 'NewContractAllocationApproved' event on the ADP feed for version '1' of contract allocation '[AllocRef_NCSC]' are as follows
 #  | DeliverableCode | Period | PlannedVolume |
 #  | 6               | 202204 | 201           |
 #  | 6               | 202205 | 212           |
 #  | 6               | 202206 | 179           |
 #  | 6               | 202207 | 175           |
 #  | 6               | 202208 | 134           |
 #  | 6               | 202209 | 105           |

    # Check Planned data on the ADP feed (J158)
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Planned data  
    | AllocationDeliveryEntryCategory   | ContractNumber | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 1               | 202204 | 5813.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 1               | 202205 | 8595.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 1               | 202206 | 10149.00     | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 1               | 202207 | 5488.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 1               | 202208 | 8563.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 1               | 202209 | 10249.00     | 0             |
    #
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 2               | 202204 | 2074.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 2               | 202205 | 1578.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 2               | 202206 | 4381.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 2               | 202207 | 924.00       | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 2               | 202208 | 2709.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 2               | 202209 | 4626.00      | 0             |
    #
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 3               | 202204 | 3739.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 3               | 202205 | 7017.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 3               | 202206 | 5768.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 3               | 202207 | 4564.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 3               | 202208 | 5854.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 3               | 202209 | 5623.00      | 0             |
    #
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 4               | 202204 | 964.00       | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 4               | 202205 | 4910.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 4               | 202206 | 2973.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 4               | 202207 | 3832.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 4               | 202208 | 3885.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 4               | 202209 | 3727.00      | 0             |
    #
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 5               | 202204 | 2775.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 5               | 202205 | 2107.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 5               | 202206 | 2795.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 5               | 202207 | 732.00       | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 5               | 202208 | 1969.00      | 0             |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 5               | 202209 | 1896.00      | 0             |
    #
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 6               | 202204 | 0            | 201           |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 6               | 202205 | 0            | 212           |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 6               | 202206 | 0            | 179           |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 6               | 202207 | 0            | 175           |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 6               | 202208 | 0            | 134           |
    | NewContractAllocationApproved     | [ContractNo]   | 1             | [AllocRef_NCSC]  | 6               | 202209 | 0            | 105           |


    # Tidy Up
    Given the override date is reset

