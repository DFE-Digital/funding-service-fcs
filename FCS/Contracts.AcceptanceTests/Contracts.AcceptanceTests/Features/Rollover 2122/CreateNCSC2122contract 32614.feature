Feature: CreateNCSC2122contract 32614

@AcceptanceTest @Withdrawn20230123
Scenario: A705 Bulk load a new NCS-C2122 contract. Publish and approve. Check docs, financials and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017705' 
    And   there are no terminated or closed allocations for UKPRN '10017705' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017705' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017705' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017705' 

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | NCS-C2122         |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017705' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017705 Co Ltd' with UKPRN '10017705' and OrgId 'ORG0017705' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017705' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017705 | 117705 | 10017705 Co Ltd | 0              | Active                | Yes           | AA017705      | ?             | 20 Bothwell Road       | ?                      | ?                      | ?                      | Hamilton               | South Lanarkshire      | ML3 0AY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017705 |




    # Change the date
    Given the override date is '01/03/2021'

    # Bulk file
    And   there are no files prefixed '10017705' in the Sharepoint 'NCS-2122-Input-Appendices' folder
    And   there are no files prefixed 'NCS FY 2122 01022021180409 v3_A705' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NCS FY 2122 01022021180409 v3_A705' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NCS FY 2122 01022021180409 v3_A705' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NCS FY 2122 01022021180409 v3_A705' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NCS FY 2122 01022021180409 v3_A705.xlsx' exists in the Datafiles folder and UKPRN '10017705' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017705' for FundingType 'NCS' and period '2122' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017705' for FundingType 'NCS' and period '2122'

    # Check the contents of the Appendices
    Then  the file named '10017705_[ContractNo]_v1.pdf' in Sharepoint location 'NCS-2122-Input-Appendices' contains the following lines in order
   #Then  the file named '10017705_NCS-705_v1.pdf' in Sharepoint location 'NCS-2122-Input-Appendices' contains the following lines in order
    """
    SCHEDULE 6
    Maximum Contract Value and Target
    Customer Volumes
    Maximum Contract Value
    2. This Schedule sets out the Maximum Contract Value for the supply of the
    Services under the Contract from 1 April 2021 – 31 March 2022.  Delivery
    3. The Maximum Contract Value in the Area for the period 1 April 2021 – 31 March
    2022 is £97,305. The Maximum Contract Value must be allocated in
    5. The Maximum Contract Value in the Area for the Contract Year starting on 1
    April 2022, and for each subsequent anniversary thereof, shall be as notified by
    Target Customer Volumes
    7. The Target Customer Volumes are as follows:
    Contract Year Target Customer Volumes
    01/04/21 – 31/03/22 1,600  
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017705_[ContractNo]_v1.pdf' in 'NCS-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A705.pdf'
   #And   Sharepoint file '<filename1.pdf>' in 'NCS-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A705.pdf'

    # Display Sharepoint filename
    And   message '10017705_[ContractNo]_v1.pdf' is written to the Output window

   #And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    #When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-705' and actual ContractNumber 'NCS-705'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017705 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017705 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'NCS-705'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_NCSC] | 2305310          | Mar-22 | Reconciliation |


    # Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | [ContractNo]   | [AllocRef_NCSC]    | 1               | 97305.00  | 6071.00  | 4192.00  | 9514.00  | 8404.00  | 10421.00 | 5376.00  | 9601.00  | 9461.00  | 8563.00  | 9945.00  | 11755.00 | 4002.00  | 
    | [ContractNo]   | [AllocRef_NCSC]    | 2               | 31606.00  | 875.00   | 201.00   | 4233.00  | 3354.00  | 4677.00  | 710.00   | 4022.00  | 3989.00  | 2773.00  | 1471.00  | 4062.00  | 1239.00  | 
    | [ContractNo]   | [AllocRef_NCSC]    | 3               | 65699.00  | 5196.00  | 3991.00  | 5281.00  | 5050.00  | 5744.00  | 4666.00  | 5579.00  | 5472.00  | 5790.00  | 8474.00  | 7693.00  | 2763.00  | 
    | [ContractNo]   | [AllocRef_NCSC]    | 4               | 37650.00  | 3798.00  | 2032.00  | 3692.00  | 2350.00  | 2740.00  | 254.00   | 4075.00  | 3830.00  | 3249.00  | 4994.00  | 4709.00  | 1927.00  | 
    | [ContractNo]   | [AllocRef_NCSC]    | 5               | 28049.00  | 1398.00  | 1959.00  | 1589.00  | 2700.00  | 3004.00  | 4412.00  | 1504.00  | 1642.00  | 2541.00  | 3480.00  | 2984.00  | 836.00   | 
    | [ContractNo]   | [AllocRef_NCSC]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PLANNED VOLUMES in CRM on the latest approved contract
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | [ContractNo]   | [AllocRef_NCSC]    | 1               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 2               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 3               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 4               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 5               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC]    | 6               | 1600      | 215      | 91       | 166      | 144      | 103      | 225      | 59       | 61       | 55       | 74       | 217      | 190      | 


    # Feed 

    # Test CRM details against same in ContractManagement feed (30447)
    And   the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '6' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                            | DeliverableDescription      | 
    | 10017705 | [ContractNo]   | 1               | [AllocRef_NCSC] | 1               | 0                     | 97305.00     | 0             | 0        | Total In The Community Funding             | ?                           |
    | 10017705 | [ContractNo]   | 1               | [AllocRef_NCSC] | 6               | 0                     | 0.00         | 1600          | 0        | Customers Accessing Service                | ?                           |
    | 10017705 | [ContractNo]   | 1               | [AllocRef_NCSC] | 2               | 1                     | 31606.00     | 0             | 0        | Customer Satisfaction                      | ?                           |
    | 10017705 | [ContractNo]   | 1               | [AllocRef_NCSC] | 3               | 1                     | 65699.00     | 0             | 0        | Career Management and Jobs and Learning    | ?                           |
    | 10017705 | [ContractNo]   | 1               | [AllocRef_NCSC] | 4               | 3                     | 37650.00     | 0             | 0        | Career Management                          | ?                           |
    | 10017705 | [ContractNo]   | 1               | [AllocRef_NCSC] | 5               | 3                     | 28049.00     | 0             | 0        | Jobs and Learning                          | ?                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
Scenario: A706 Create a new NCS-C2122 contract. Consume actuals. Run payment batch. Check financials, CDA and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017706' 
    And   there are no terminated or closed allocations for UKPRN '10017706' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017706' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017706' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017706' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | NCSC-706      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | NCSC-706      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | NCS-C2122         |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | NCS-706        | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017706'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017706' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017706 Co Ltd' with UKPRN '10017706' and OrgId 'ORG0017706' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017706' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017706 | 117706 | 10017706 Co Ltd | 0              | Active                | Yes           | AA017706      | ?             | 88 Ashburton Road      | ?                      | ?                      | ?                      | Hugglescote            | Coalville              | LE67 2HB  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017706 |




    # Change the date
    Given the override date is '01/03/2021'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017706 | 10017706 Co Ltd      | ESFA-706             | NCS-706        | 1                     | 01/04/2021        | 31/03/2022      | 61352.00      | North West                            | Contract for Services                      | 2122   | New          | ORG0017706 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName       | UoPCode    | AllocationDescription         | CRMIntent    | DeliveryOrg |
    | 10017706 | NCS-706        | NCSC-706      | NCS-C             | NCS-C2122               | FY                      | 01/04/2021          | 31/03/2022        | 61352.00        | North West    | 0000000105 |                               | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017706 | NCS-706        | NCSC-706      | 1               | 0                     | 61352.00  | 5113.00  | 7287.00  | 7184.00  | 2811.00  | 1125.00  | 8899.00  | 3102.00  | 6669.00  | 4352.00  | 3902.00  | 5252.00  | 5656.00  | Total In The Community Funding                                  | New          |             | 
    | 10017706 | NCS-706        | NCSC-706      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             | 
    | 10017706 | NCS-706        | NCSC-706      | 2               | 1                     | 17111.00  | 337.00   | 2210.00  | 3010.00  | 2575.00  | 178.00   | 2684.00  | 604.00   | 3143.00  | 208.00   | 628.00   | 352.00   | 1182.00  | Customer Satisfaction                                           | New          |             | 
    | 10017706 | NCS-706        | NCSC-706      | 3               | 1                     | 44241.00  | 4776.00  | 5077.00  | 4174.00  | 236.00   | 947.00   | 6215.00  | 2498.00  | 3526.00  | 4144.00  | 3274.00  | 4900.00  | 4474.00  | Career Management and Jobs and Learning                         | New          |             | 
    | 10017706 | NCS-706        | NCSC-706      | 4               | 3                     | 23420.00  | 2151.00  | 3203.00  | 3747.00  | 150.00   | 822.00   | 2507.00  | 2136.00  | 530.00   | 664.00   | 2981.00  | 3431.00  | 1098.00  | Career Management                                               | New          |             | 
    | 10017706 | NCS-706        | NCSC-706      | 5               | 3                     | 20821.00  | 2625.00  | 1874.00  | 427.00   | 86.00    | 125.00   | 3708.00  | 362.00   | 2996.00  | 3480.00  | 293.00   | 1469.00  | 3376.00  | Jobs and Learning                                               | New          |             | 

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | 
    | 10017706 | NCS-706        | NCSC-706      | 6               | 0        | 596     | 18       | 79       | 11       | 56       | 56       | 13       | 28       | 49       | 99       | 42       | 97       | 48       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | NCS-706        | 1                     | 0                        | 2021-03-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NCS-706'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-706' and actual ContractNumber 'NCS-706'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-706' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017706 | NCS-706            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017706 | ESFA-706           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'NCS-706'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | NCSC-706        | 2305310          | Mar-22 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '6' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                             | DeliverableDescription                                      | 
    | 10017706 | NCS-706        | 1               | NCSC-706      | 1               | 0                     | 61352.00     | 0             | 0        | Total In The Community Funding                              | ?                                                           |
    | 10017706 | NCS-706        | 1               | NCSC-706      | 6               | 0                     | 0.00         | 596           | 0        | Customers Accessing Service                                 | ?                                                           |
    | 10017706 | NCS-706        | 1               | NCSC-706      | 2               | 1                     | 17111.00     | 0             | 0        | Customer Satisfaction                                       | ?                                                           |
    | 10017706 | NCS-706        | 1               | NCSC-706      | 3               | 1                     | 44241.00     | 0             | 0        | Career Management and Jobs and Learning                     | ?                                                           |
    | 10017706 | NCS-706        | 1               | NCSC-706      | 4               | 3                     | 23420.00     | 0             | 0        | Career Management                                           | ?                                                           |
    | 10017706 | NCS-706        | 1               | NCSC-706      | 5               | 3                     | 20821.00     | 0             | 0        | Jobs and Learning                                           | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'NCS-706' agree with the most recent entry for this contract in the ContractManagement feed





#    # CDA
#    
#    # Change the date
#    Given the override date is '23/04/2021'
#
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version A706.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | NCS-706        | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version               | Suffix |
#    | NCS-C2122             | Latest Version        | A706   |
#
#    Then  a report named 'CDA Latest Version A706.csv' is created   
#    
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 4                 | 2021            | 2021/22       |              | 2625         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Apr              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 4                 | 2021            | 2021/22       |              | 0            |              | 18            |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   |                          |                   | Apr              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 4                 | 2021            | 2021/22       |              | 337          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Apr              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 4                 | 2021            | 2021/22       |              | 2151         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Apr              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 5                 | 2021            | 2021/22       |              | 1874         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | May              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 5                 | 2021            | 2021/22       |              | 2210         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | May              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 5                 | 2021            | 2021/22       |              | 0            |              | 79            |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   |                          |                   | May              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 5                 | 2021            | 2021/22       |              | 3203         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | May              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 6                 | 2021            | 2021/22       |              | 427          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Jun              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 6                 | 2021            | 2021/22       |              | 3010         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Jun              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 6                 | 2021            | 2021/22       |              | 3747         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Jun              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 6                 | 2021            | 2021/22       |              | 0            |              | 11            |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   |                          |                   | Jun              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 7                 | 2021            | 2021/22       |              | 86           |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Jul              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 7                 | 2021            | 2021/22       |              | 0            |              | 56            |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   |                          |                   | Jul              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 7                 | 2021            | 2021/22       |              | 2575         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Jul              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 7                 | 2021            | 2021/22       |              | 150          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Jul              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 8                 | 2021            | 2021/22       |              | 178          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Aug              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 8                 | 2021            | 2021/22       |              | 822          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Aug              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 8                 | 2021            | 2021/22       |              | 0            |              | 56            |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   |                          |                   | Aug              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 8                 | 2021            | 2021/22       |              | 125          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Aug              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 9                 | 2021            | 2021/22       |              | 2507         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Sep              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 9                 | 2021            | 2021/22       |              | 2684         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Sep              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 9                 | 2021            | 2021/22       |              | 3708         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Sep              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 9                 | 2021            | 2021/22       |              | 0            |              | 13            |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   |                          |                   | Sep              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 10                | 2021            | 2021/22       |              | 0            |              | 28            |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   |                          |                   | Oct              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 10                | 2021            | 2021/22       |              | 2136         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Oct              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 10                | 2021            | 2021/22       |              | 604          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Oct              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 10                | 2021            | 2021/22       |              | 362          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Oct              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 11                | 2021            | 2021/22       |              | 3143         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Nov              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 11                | 2021            | 2021/22       |              | 0            |              | 49            |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   |                          |                   | Nov              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 11                | 2021            | 2021/22       |              | 530          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Nov              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 11                | 2021            | 2021/22       |              | 2996         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Nov              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 12                | 2021            | 2021/22       |              | 664          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Dec              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 12                | 2021            | 2021/22       |              | 208          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Dec              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 12                | 2021            | 2021/22       |              | 3480         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Dec              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 12                | 2021            | 2021/22       |              | 0            |              | 99            |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   |                          |                   | Dec              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 1                 | 2022            | 2021/22       |              | 628          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Jan              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 1                 | 2022            | 2021/22       |              | 2981         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Jan              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 1                 | 2022            | 2021/22       |              | 293          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Jan              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 1                 | 2022            | 2021/22       |              | 0            |              | 42            |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   |                          |                   | Jan              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 2                 | 2022            | 2021/22       |              | 352          |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Feb              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 2                 | 2022            | 2021/22       |              | 0            |              | 97            |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   |                          |                   | Feb              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 2                 | 2022            | 2021/22       |              | 1469         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Feb              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 2                 | 2022            | 2021/22       |              | 3431         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Feb              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customer Satisfaction                                           | Total In The Community Funding                                  | 3                 | 2022            | 2021/22       |              | 1182         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Mar              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Customers Accessing Service                                     |                                                                 | 3                 | 2022            | 2021/22       |              | 0            |              | 48            |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   |                          |                   | Mar              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Jobs and Learning                                               | Career Management and Jobs and Learning                         | 3                 | 2022            | 2021/22       |              | 3376         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Mar              |
#    | NCS-C2122               | 10017706 | 10017706 Co Ltd             |               |                             | NCSC-706                 | NCS-706        | ESFA-706                | 01/04/2021                  | 31/03/2022                | 1                     | Approved       | Approved                |                                                      | Career Management                                               | Career Management and Jobs and Learning                         | 3                 | 2022            | 2021/22       |              | 1098         |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            | North West        |        |                   | 2305310                  | 2305310           | Mar              |
   
  
    
    
    
    # Add actuals to the contract

    # Change the date
    Given the override date is '04/05/2021'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017706'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Apr 2021
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202104 | NCS-C2122               | NCSC-706                 | 0000000105 | 2               | 0            | 3162.95     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202104 | NCS-C2122               | NCSC-706                 | 0000000105 | 4               | 0            | 1289.63     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202104 | NCS-C2122               | NCSC-706                 | 0000000105 | 5               | 0            | 2362.20     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202105 | NCS-C2122               | NCSC-706                 | 0000000105 | 2               | 0            | 2680.34     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202105 | NCS-C2122               | NCSC-706                 | 0000000105 | 4               | 0            | 1637.09     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202105 | NCS-C2122               | NCSC-706                 | 0000000105 | 5               | 0            | 3177.07     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202106 | NCS-C2122               | NCSC-706                 | 0000000105 | 2               | 0            | 2295.24     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202106 | NCS-C2122               | NCSC-706                 | 0000000105 | 4               | 0            | 3420.22     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202106 | NCS-C2122               | NCSC-706                 | 0000000105 | 5               | 0            | 1925.51     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202107 | NCS-C2122               | NCSC-706                 | 0000000105 | 2               | 0            | 2212.71     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202107 | NCS-C2122               | NCSC-706                 | 0000000105 | 4               | 0            | 3010.60     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202107 | NCS-C2122               | NCSC-706                 | 0000000105 | 5               | 0            | 2032.29     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202108 | NCS-C2122               | NCSC-706                 | 0000000105 | 2               | 0            | 1339.90     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202108 | NCS-C2122               | NCSC-706                 | 0000000105 | 4               | 0            | 2542.72     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202108 | NCS-C2122               | NCSC-706                 | 0000000105 | 5               | 0            | 526.06      |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202109 | NCS-C2122               | NCSC-706                 | 0000000105 | 2               | 0            | 1594.40     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202109 | NCS-C2122               | NCSC-706                 | 0000000105 | 4               | 0            | 752.99      |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202109 | NCS-C2122               | NCSC-706                 | 0000000105 | 5               | 0            | 930.13      |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202110 | NCS-C2122               | NCSC-706                 | 0000000105 | 2               | 0            | 3108.77     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202110 | NCS-C2122               | NCSC-706                 | 0000000105 | 4               | 0            | 1436.45     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202110 | NCS-C2122               | NCSC-706                 | 0000000105 | 5               | 0            | 2381.37     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202111 | NCS-C2122               | NCSC-706                 | 0000000105 | 2               | 0            | 3306.45     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202111 | NCS-C2122               | NCSC-706                 | 0000000105 | 4               | 0            | 1420.45     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202111 | NCS-C2122               | NCSC-706                 | 0000000105 | 5               | 0            | 904.43      |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202112 | NCS-C2122               | NCSC-706                 | 0000000105 | 2               | 0            | 1793.27     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202112 | NCS-C2122               | NCSC-706                 | 0000000105 | 4               | 0            | 2548.20     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202112 | NCS-C2122               | NCSC-706                 | 0000000105 | 5               | 0            | 2187.82     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202201 | NCS-C2122               | NCSC-706                 | 0000000105 | 2               | 0            | 649.52      |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202201 | NCS-C2122               | NCSC-706                 | 0000000105 | 4               | 0            | 541.42      |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202201 | NCS-C2122               | NCSC-706                 | 0000000105 | 5               | 0            | 3278.47     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202202 | NCS-C2122               | NCSC-706                 | 0000000105 | 2               | 0            | 3297.82     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202202 | NCS-C2122               | NCSC-706                 | 0000000105 | 4               | 0            | 1442.14     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202202 | NCS-C2122               | NCSC-706                 | 0000000105 | 5               | 0            | 3120.83     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202203 | NCS-C2122               | NCSC-706                 | 0000000105 | 2               | 0            | 1293.51     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202203 | NCS-C2122               | NCSC-706                 | 0000000105 | 4               | 0            | 2717.94     |
    | NCS2122        | N09                  | ORG0017706     | CM             | 202203 | NCS-C2122               | NCSC-706                 | 0000000105 | 5               | 0            | 510.99      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


    # Check financials

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | NCS-706        | NCSC-706           | 1               | 0.00      | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-706        | NCSC-706           | 2               | 3162.95   | 3162.95  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-706        | NCSC-706           | 3               | 0.00      | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-706        | NCSC-706           | 4               | 1289.63   | 1289.63  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-706        | NCSC-706           | 5               | 2362.20   | 2362.20  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-706        | NCSC-706           | 6               | 0.00      | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | NCS-706        | NCSC-706           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-706        | NCSC-706           | 2               | 3162.95   | 3162.95  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-706        | NCSC-706           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-706        | NCSC-706           | 4               | 1289.63   | 1289.63  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-706        | NCSC-706           | 5               | 2362.20   | 2362.20  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-706        | NCSC-706           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | NCS-706        | NCSC-706           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-706        | NCSC-706           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-706        | NCSC-706           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-706        | NCSC-706           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-706        | NCSC-706           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-706        | NCSC-706           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | NCS-706        | NCSC-706           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-706        | NCSC-706           | 2               | 3162.95   | 3162.95  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-706        | NCSC-706           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-706        | NCSC-706           | 4               | 1289.63   | 1289.63  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-706        | NCSC-706           | 5               | 2362.20   | 2362.20  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-706        | NCSC-706           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Apr-21    | May-21    | Jun-21    | Jul-21    | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    |
    | 10017706 | NCS-706        | NCSC-706           | 2305310                  | 6814.78   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Apr-21    | May-21    | Jun-21    | Jul-21    | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    |
    | 10017706 | NCS-706        | NCSC-706           | 2305310                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 





    # Payment Batch for NCS-C2122

    # Change the date
    Given the override date is '11/05/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'NCS-C2122' AccountingPaymentPeriod '202101' CensusEndDate '11/05/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | NCSC-706                 | 202104 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | NCS-C2122                  | 202104               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | NCS-C2122                  | 202104               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'NCS-C2122' PaymentPeriod '202101' CensusEndDate '11/05/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A706.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'NCS-C2122' PaymentPeriod '202101' CensusEndDate '11/05/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | NCSC                   | 2021          | 01             | 11          | ?       | NCSC-706      | 6814.78         | RECONCILIATION   | NCS Adult Core                     | 2021-05-21 | 2021-04-01   | 2022-03-31 | ?              | 10017706 | 2305310    |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'NCS-C2122' AccountingPaymentPeriod '202101' and CensusEndDate '11/05/2021'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                          |
    | Payment Requests for Funding Stream Period NCS-C2122 for Payment Period 202101 have been generated as of Census End Date/Time 2021-05-11T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | NCS-C2122           | 202101        | 2021-05-11T22:00:00Z  | 1                | 6814.78    |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | NCSC      | 01/04/2021   | 31/03/2022 | 11/05/2021    | 21/05/2021 | 2021          | 01             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017706  | 10017706       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | NCSC-706   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2305310    | RECONCILIATION | NCS Adult Core                | 6814.78         |


    # Tidy Up
    And   the override date is reset
       
