Feature: Create19-24Traineeships 39250

@AcceptanceTest @Withdrawn20251024
@Long2Run @Long2Run123
Scenario: S020 Create 19-24 Traineeships contracts linked by Master for 20/21, 21/22 and 22/23. Bulk load a NewAmendment for 23/24. Approve. Check docs, CRM and Feed 

    # 1. Create and approve 20/21 contract
    # 2. Create and approve 21/22 contract linked to 20/21 by Master
    # 3. Create and approve 22/23 contract linked to  Master
    # 4. Bulk load 'New Amendment' for 23/24. Publish and approve
    # Check docs, CRM and Feed

    Given there are no allocations marked as Under Termination for UKPRN '10018020' 
    And   there are no terminated or closed allocations for UKPRN '10018020' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018020' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018020' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018020' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 19TL-020      |
    | 19TR-020      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 19TL-020      |
    | 19TR-020      |
    | 19TL-0201     |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 19TRN2020-2021    |
    | 19TRN2020-LS2021  |
    | 19TRN2020-LS2021  |
    | 19TRN2020-2122    |
    | 19TRN2020-2223    |
    | 19TRN2020-2324    |


    ## Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
    #And   there is no Subnominal data in CRM for the following subnominal codes
    #| SubnominalCode |
    #| 2207010        |
    #| 2355800        |
    #| 2355860        |
    #| 2355816        |
    #| 2355870        |
    #| 2355875        |
    #| 100932         |
    #| 100933         |
    #| 100934         |
    #| 100935         |
    #| 100936         |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018020'

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | 19TR20-020     | 1                     | 0                        |
    | 19TR20-0201    | 1                     | 0                        |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018020' 
    And   there is no caseload advisor for UKPRN '10018020' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018020 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018020' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018020 Co Ltd' with UKPRN '10018020' and OrgId 'ORG0018020' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018020 | 118020 | 10018020 Co Ltd | 0              | Active                | Yes           | AA018020      | ?             | 345 The Meadway        | Tilehurst              | ?                      | ?                      | Reading                | Berkshire              | RG30 4NU  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018020 |





    # Part 1: Create and approve 20/21 contract
    
    # Change the date
    Given the override date is '01/01/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '19TR20-020'
    And   there are no details in ContractManagement.CreatedContract for '19TR20-020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018020 | 10018020 Co Ltd      | ESFA-020             | 19TR20-020     | 1                     | 01/02/2021        | 31/07/2021      | 22463.00      |                                       | Contract for Services                      | 2021   | New          | ORG0018020 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018020 | 19TR20-020     | 19TL-020      | 19TRN2020-LS      | 19TRN2020-LS2021        | AY                      | 01/02/2021          | 31/07/2021        | 10876.00        |                                         |            |                                                             | New          |             |
    | 10018020 | 19TR20-020     | 19TR-020      | 19TRN2020         | 19TRN2020-2021          | AY                      | 01/02/2021          | 31/07/2021        | 11587.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10018020 | 19TR20-020     | 19TL-020      | 1               | 0                     | 10876.00  | 1746.00  | 1089.00  | 2077.00  | 2813.00  | 1588.00  | 1563.00  | 19-24 Traineeships Learner Support Total Funding                | New          |             | 
    | 10018020 | 19TR20-020     | 19TR-020      | 1               | 0                     | 11587.00  | 2038.00  | 1065.00  | 3002.00  | 892.00   | 1786.00  | 2804.00  | 19-24 Traineeships Total Funding                                | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 19TR20-020     | 1                     | 0                        | 2021-01-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-020' and ContractNumber '19TR20-020' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-020' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018020 | 19TR20-020         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/02/2021        | 31/07/2021      | ?             |
    | 10018020 | ESFA-020           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-020' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract '19TR20-020'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 19TR-020        | 2355800          | Jul-21 | Reconciliation |
    | 19TL-020        | 2355875          | Jul-21 | Reconciliation |

    Then wait '10' seconds

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10018020 | 19TR20-020     | 1               | 19TL-020      | 1               | 0                     | 10876.00     | 0             | 0        | 19-24 Traineeships Learner Support Total Funding                | ?                                                           |
    | 10018020 | 19TR20-020     | 1               | 19TR-020      | 1               | 0                     | 11587.00     | 0             | 0        | 19-24 Traineeships Total Funding                                | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-020' agree with the most recent entry for this contract in the ContractManagement feed





    # Part 2: Create and approve 21/22 contract linked to 20/21 by Master

    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '19TR20-020'
    And   there are no details in ContractManagement.CreatedContract for '19TR20-0201'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018020 | 10018020 Co Ltd      | ESFA-020             | 19TR20-0201    | 1                     | 01/08/2021        | 31/07/2022      | 44392.00      |                                       | Contract for Services                      | 2122   | New          | ORG0018020 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018020 | 19TR20-0201    | 19TR-0201     | 19TRN2020         | 19TRN2020-2122          | AY                      | 01/08/2021          | 31/07/2022        | 44392.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription               | CRMIntent    | DeliveryOrg |
    | 10018020 | 19TR20-0201    | 19TR-0201     | 1               | 0                     | 44392.00  | 29439.00  | 14953.00  | 5969.00  | 2663.00  | 1477.00  | 2316.00  | 5464.00  | 3423.00  | 4862.00  | 3265.00  | 1634.00  | 4560.00  | 6887.00  | 1872.00  | 19-24 Traineeships Total Funding     | New          |             | 
    | 10018020 | 19TR20-0201    | 19TR-0201     | 4               | 1                     | 20345.00  | 15336.00  | 5009.00   | 3328.00  | 2577.00  | 1129.00  | 1771.00  | 1811.00  | 1692.00  | 2048.00  | 980.00   | 481.00   | 995.00   | 3155.00  | 378.00   | 19-24 Traineeships                   | New          |             | 
    | 10018020 | 19TR20-0201    | 19TR-0201     | 5               | 1                     | 24047.00  | 14103.00  | 9944.00   | 2641.00  | 86.00    | 348.00   | 545.00   | 3653.00  | 1731.00  | 2814.00  | 2285.00  | 1153.00  | 3565.00  | 3732.00  | 1494.00  | 19-24 Traineeships Learner Support   | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 19TR20-0201    | 1                     | 0                        | 2021-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-0201'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-020' and ContractNumber '19TR20-0201' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-0201' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018020 | 19TR20-0201        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10018020 | ESFA-020           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-0201' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract '19TR20-0201'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 19TR-0201       | 100934           | Jul-22 | Reconciliation |

    Then wait '10' seconds

#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '3' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                          | DeliverableDescription    | 
#    | 10018020 | 19TR20-0201    | 1               | 19TR-0201     | 1               | 0                     | 44392.00     | 0             | 0        | 19-24 Traineeships Total Funding         | ?                         |
#    | 10018020 | 19TR20-0201    | 1               | 19TR-0201     | 4               | 1                     | 20345.00     | 0             | 0        | 19-24 Traineeships                       | ?                         |
#    | 10018020 | 19TR20-0201    | 1               | 19TR-0201     | 5               | 1                     | 24047.00     | 0             | 0        | 19-24 Traineeships Learner Support       | ?                         |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract '19TR20-0201' agree with the most recent entry for this contract in the ContractManagement feed
#


    # Part 3: Create and approve 22/23 contract linked to Master

    # Change the date
    Given the override date is '01/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '19TR20-020'
    And   there are no details in ContractManagement.CreatedContract for '19TR20-0202'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018020 | 10018020 Co Ltd      | ESFA-020             | 19TR20-0202    | 1                     | 01/08/2022        | 31/07/2023      | 46392.00      |                                       | Contract for Services                      | 2223   | New          | ORG0018020 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018020 | 19TR20-0202    | 19TR-0202     | 19TRN2020         | 19TRN2020-2223          | AY                      | 01/08/2022          | 31/07/2023        | 44392.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableDescription               | CRMIntent    | DeliveryOrg |
    | 10018020 | 19TR20-0202    | 19TR-0202     | 1               | 0                     | 46392.00  | 29439.00  | 14953.00  | 5969.00  | 2663.00  | 1477.00  | 2316.00  | 5464.00  | 3423.00  | 4862.00  | 3265.00  | 1634.00  | 4560.00  | 6887.00  | 1872.00  | 19-24 Traineeships Total Funding     | New          |             | 
    | 10018020 | 19TR20-0202    | 19TR-0202     | 4               | 1                     | 21345.00  | 15336.00  | 5009.00   | 4328.00  | 2577.00  | 1129.00  | 1771.00  | 1811.00  | 1692.00  | 2048.00  | 980.00   | 481.00   | 995.00   | 3155.00  | 378.00   | 19-24 Traineeships                   | New          |             | 
    | 10018020 | 19TR20-0202    | 19TR-0202     | 5               | 1                     | 25047.00  | 14103.00  | 9944.00   | 3641.00  | 86.00    | 348.00   | 545.00   | 3653.00  | 1731.00  | 2814.00  | 2285.00  | 1153.00  | 3565.00  | 3732.00  | 1494.00  | 19-24 Traineeships Learner Support   | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 19TR20-0202    | 1                     | 0                        | 2022-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-0202'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-020' and ContractNumber '19TR20-0202' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-0202' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018020 | 19TR20-0202        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10018020 | 19TR20-0201        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10018020 | ESFA-020           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-0202' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract '19TR20-0202'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 19TR-0202       | 100934           | Jul-22 | Reconciliation |

    Then wait '10' seconds

#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '3' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                          | DeliverableDescription    | 
#    | 10018020 | 19TR20-0202    | 1               | 19TR-0202     | 1               | 0                     | 46392.00     | 0             | 0        | 19-24 Traineeships Total Funding         | ?                         |
#    | 10018020 | 19TR20-0202    | 1               | 19TR-0202     | 4               | 1                     | 21345.00     | 0             | 0        | 19-24 Traineeships                       | ?                         |
#    | 10018020 | 19TR20-0202    | 1               | 19TR-0202     | 5               | 1                     | 25047.00     | 0             | 0        | 19-24 Traineeships Learner Support       | ?                         |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract '19TR20-0202' agree with the most recent entry for this contract in the ContractManagement feed


    # Part 4: Bulk load 'New Amendment' for 23/24. Publish and approve

    # Change the date
    Given the override date is '01/07/2023'

    # Bulk file (New Amendment)
    And   there are no files prefixed '10018020' in the Sharepoint '19TRN2020-2324-Input-Appendices' folder
    And   there are no files prefixed '19TRN2020 AY 2324 16052023092059 v3_S020' in the Sharepoint 'Input' folder
    And   there are no files prefixed '19TRN2020 AY 2324 16052023092059 v3_S020' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '19TRN2020 AY 2324 16052023092059 v3_S020' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '19TRN2020 AY 2324 16052023092059 v3_S020' in the Sharepoint 'Reports' folder
    And   spreadsheet '19TRN2020 AY 2324 16052023092059 v3_S020.xlsx' exists in the Datafiles folder and UKPRN '10018020' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10018020' for FundingType '19TRN2020' and period '2324' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10018020' for FundingType '19TRN2020' and period '2324'

    # Check the contents of the Appendices (SoF, TAC, Sch1, Sch2, FA, Sch3ON)
    Then  the file named '10018020_[ContractNo]_v1.pdf' in Sharepoint location '19TRN2020-2324-Input-Appendices' contains the following lines in order
   #Then  the file named '10018020_19TR20-020_v1.pdf' in Sharepoint location '19TRN2020-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10018020 Co Ltd UKPRN: 10018020
    Master Contract Number: ESFA-020
    Allocation
    1 February 2021 to 31 July 2021 Contract Ref Feb 21 - Mar 21 Apr 21 - Jul 21 Total
    19 to 24 Traineeships - 2020 Procurement 19TR-020 £3,103 £8,484 £11,587
    19 to 24 Traineeships - 2020 Procurement - Learner Support 19TL-020 £2,835 £8,041 £10,876
    Total: £22,463
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    19 to 24 Traineeships - 2020 Procurement 19TR-0201 £29,439 £14,953 £44,392
    of which Learner Support £14,103 £9,944 £24,047
    Total: £44,392
    Allocation
    1 August 2022 to 31 July 2023 Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 Total
    19 to 24 Traineeships - 2020 Procurement 19TR-0202 £31,439 £14,953 £46,392
    of which Learner Support £15,103 £9,944 £25,047
    Total: £46,392
    Allocation
    1 August 2023 to 31 July 2024 Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 Total
    19 to 24 Traineeships - 2020 Procurement [AllocRef_19TR] £65,351 £28,397 £93,748
    of which Learner Support £42,187 £17,495 £59,682
    Total: £93,748
    Total Funding for this contract: £206,995
    Summary of Funding – Page 1
    Agreement Type Contract for Services
    st st
    Funding Period 1 February 2021 to 31 July 2024
    Funding for 19 to 24 Traineeships
    Master Contract Number ESFA-020
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10018020 Co Ltd THE SECRETARY OF STATE FOR
    345 The Meadway EDUCATION
    Tilehurst DEPARTMENT FOR EDUCATION
    Reading 20 GREAT SMITH STREET
    AND
    Berkshire LONDON
    RG30 4NU SW1P 3BT
    Company No: AA018020
    Hereinafter called Hereinafter called
    the Contractor the Department
    Version 5 (July 2023) Page 2
    Version 5 (July 2023) Page 77

    SCHEDULE 1: SPECIFICATION & MONITORING
    19 TO 24-YEAR-OLD PROCURED ADULT EDUCATION BUDGET
    TRAINEESHIPS SPECIFICATION
    Schedule 1 Version 4 (July 2023) – Page 1
    Schedule 1 Version 4 (July 2023) – Page 13

    SCHEDULE 2: PAYMENT
    Schedule 2 Version 5 (July 2023) – Page 1
    Schedule 2 Version 5 (July 2023) – Page 2

    19 TO 24 TRAINEESHIPS - 2020 PROCUREMENT
    Funding Agreement – 19 to 24 Traineeships - 2020 Procurement
    Provider: 10018020 Co Ltd UKPRN: 10018020
    Master Contract Number: ESFA-020 Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_19TR]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    19 to 24 Traineeships - 2020 Procurement £93,748 £1,726 £4,485 £12,605 £9,985 £5,674 £14,878 £6,895 £9,103 £2,479 £610 £14,167 £11,141
    of which Learner Support £59,682 £353 £3,771 £5,692 £7,880 £5,045 £7,710 £5,555 £6,181 £2,190 £374 £7,933 £6,998
    Total Funding £93,748 £1,726 £4,485 £12,605 £9,985 £5,674 £14,878 £6,895 £9,103 £2,479 £610 £14,167 £11,141

    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    Schedule 3 Version 4 (July 2023) – Page 1

    SCHEDULE 4: TUPE
    Schedule 4 Version 4 (July 2023) – Page 1
    Schedule 4 Version 4 (July 2023) – Page 22

    SCHEDULE 5: UK GDPR AND DATA PROTECTION
    Schedule 5 Version 4 (July 2023) – Page 1
    Schedule 5 Version 4 (July 2023) – Page 2

    SCHEDULE 6: SECURITY & DEPARTMENT POLICIES
    Schedule 6 Version 4 (July 2023) – Page 1
    Schedule 6 Version 4 (July 2023) – Page 8

    SCHEDULE 7: EXIT ARRANGEMENTS
    Schedule 7 Version 4 (July 2023) – Page 1
    Schedule 7 Version 4 (July 2023) – Page 5

    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018020_[ContractNo]_v1.pdf' in '19TRN2020-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S020.pdf'

    # Display Sharepoint filename
    And   message '10018020_[ContractNo]_v1.pdf' is written to the Output window


    # Publish and approve

    # Change the date
    Given the override date is '06/07/2023'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-020' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018020 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018020 | 19TR20-0202	    | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10018020 | 19TR20-0201        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10018020 | ESFA-020           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_19TR] | 2355800          | Jul-24 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                       | DeliverableDescription     | 
    | 10018020 | [ContractNo]   | 1               | [AllocRef_19TR] | 1               | 0                     | 93748.00     | 0             | 0        | 19-24 Traineeships Total Funding      | ?                          |
    | 10018020 | [ContractNo]   | 1               | [AllocRef_19TR] | 4               | 1                     | 34066.00     | 0             | 0        | 19-24 Traineeships                    | ?                          |
    | 10018020 | [ContractNo]   | 1               | [AllocRef_19TR] | 5               | 1                     | 59682.00     | 0             | 0        | 19-24 Traineeships Learner Support    | ?                          |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

   
    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_19TR]    | 1               | 93748.00  | 1726.00  | 4485.00  | 12605.00 | 9985.00  | 5674.00  | 14878.00 | 6895.00  | 9103.00  | 2479.00  | 610.00   | 14167.00 | 11141.00 | 
    | [ContractNo]   | [AllocRef_19TR]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 4               | 34066.00  | 1373.00  | 714.00   | 6913.00  | 2105.00  | 629.00   | 7168.00  | 1340.00  | 2922.00  | 289.00   | 236.00   | 6234.00  | 4143.00  | 
    | [ContractNo]   | [AllocRef_19TR]    | 5               | 59682.00  | 353.00   | 3771.00  | 5692.00  | 7880.00  | 5045.00  | 7710.00  | 5555.00  | 6181.00  | 2190.00  | 374.00   | 7933.00  | 6998.00  | 
    | [ContractNo]   | [AllocRef_19TR]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    
    # Tidy up
    Given the override date is reset
    

@AcceptanceTest @Withdrawn20260521
@Long2Run @Long2Run123
Scenario: S021 Create draft 19-24 Traineeships contract. Bulk add 23/24 and fail: MBR-005. Approve 22/23. Bulk load 23/24. NFA, CDA. Add actuals. Payment batch. Check docs and feed
  
    #  1. Create an approved 21/22 19-24 Traineeships contract
    #  2. Create a draft 22/23 19-24 Traineeships contract
    #  3. Attempt to add a 23/24 contract by bulk upload (New Amendment) but fail (MBR-005)
    #  4. Publish and approve 22/23 contract and check feed
    #  4. Bulk file (again) to add 23/24 contract linked to Master. Check docs and doc parts
    #  5. Attempt NFA against approved 22/23 contract but fail (MBR-005) because 23/24 is in draft 
    #  6. Publish and approve 23/24 contract. Check feed and financials
    #  7. Add 23/24 actuals and check financials in CRM and PaaS
    #  8. CDA
    #  9. Payment Batch for 19TRN2020-2324 and check feed
    # 10. Create Consolidated Payment Summary rpt

    Given there are no allocations marked as Under Termination for UKPRN '10018021' 
    And   there are no terminated or closed allocations for UKPRN '10018021' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018021' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018021' 
    And   there are no notifications in CRM of type 'Non-Financial Contract Amendment Failed' for UKPRN '10018021'
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018021' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 19TR-021      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 19TR-021      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 19TRN2020-2122    |
    | 19TRN2020-2223    |
    | 19TRN2020-2324    |


    ## Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
    #And   there is no Subnominal data in CRM for the following subnominal codes
    #| SubnominalCode |
    #| 100932         |
    #| 100933         |
    #| 100934         |
    #| 100935         |
    #| 100936         |
    #| 2355800        |
    #| 2355816        |
    #| 2333860        |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | 19TR20-021     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018021'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018021' 
    And   there is no caseload advisor for UKPRN '10018021' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018021 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018021' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018021 Co Ltd' with UKPRN '10018021' and OrgId 'ORG0018021' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018021 | 118021 | 10018021 Co Ltd | 0              | Provider Under Change | Yes           | AA018021      | ?             | 171 High Street        | ?                      | ?                      | ?                      | Rickmansworth          | Hertfordshire          | WD3 1AY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018021 |





    # Part 1: Create a draft 21/22 19-24 Traineeships contract

    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '19TR20-021'
    And   there are no details in ContractManagement.CreatedContract for '19TR20-021'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018021 | 10018021 Co Ltd      | ESFA-021             | 19TR20-021     | 1                     | 01/08/2021        | 31/07/2022      | 51128.00      |                                       | Contract for Services                      | 2122   | New          | ORG0018021 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018021 | 19TR20-021     | 19TR-021      | 19TRN2020         | 19TRN2020-2122          | AY                      | 01/08/2021          | 31/07/2022        | 51128.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10018021 | 19TR20-021     | 19TR-021      | 1               | 0                     | 51128.00  | 33601.00  | 17527.00  | 4421.00  | 3646.00  | 5972.00  | 4659.00  | 6635.00  | 4407.00  | 1955.00  | 1906.00  | 3789.00  | 2825.00  | 5716.00  | 5197.00  | 19-24 Traineeships Total Funding                                | New          |             | 
    | 10018021 | 19TR20-021     | 19TR-021      | 4               | 1                     | 24904.00  | 15580.00  | 9324.00   | 3434.00  | 247.00   | 2406.00  | 3331.00  | 3276.00  | 722.00   | 983.00   | 1181.00  | 588.00   | 2367.00  | 3449.00  | 2920.00  | 19-24 Traineeships                                              | New          |             | 
    | 10018021 | 19TR20-021     | 19TR-021      | 5               | 1                     | 26224.00  | 18021.00  | 8203.00   | 987.00   | 3399.00  | 3566.00  | 1328.00  | 3359.00  | 3685.00  | 972.00   | 725.00   | 3201.00  | 458.00   | 2267.00  | 2277.00  | 19-24 Traineeships Learner Support                              | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 19TR20-021     | 1                     | 0                        | 2021-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-021'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-021' and ContractNumber '19TR20-021' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-021' has a substatus of 'Approved'


    # Part 2. Create a draft 22/23 19-24 Traineeships contract


    # Change the date
    Given the override date is '01/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '19TR20-021'
    And   there are no details in ContractManagement.CreatedContract for '19TR20-0212'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018021 | 10018021 Co Ltd      | ESFA-021             | 19TR20-0212    | 1                     | 01/08/2022        | 31/07/2023      | 51128.00      |                                       | Contract for Services                      | 2223   | New          | ORG0018021 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018021 | 19TR20-0212    | 19TR-0212     | 19TRN2020         | 19TRN2020-2223          | AY                      | 01/08/2022          | 31/07/2023        | 51128.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10018021 | 19TR20-0212    | 19TR-0212     | 1               | 0                     | 51128.00  | 33601.00  | 17527.00  | 4421.00  | 3646.00  | 5972.00  | 4659.00  | 6635.00  | 4407.00  | 1955.00  | 1906.00  | 3789.00  | 2825.00  | 5716.00  | 5197.00  | 19-24 Traineeships Total Funding                                | New          |             | 
    | 10018021 | 19TR20-0212    | 19TR-0212     | 4               | 1                     | 24904.00  | 15580.00  | 9324.00   | 3434.00  | 247.00   | 2406.00  | 3331.00  | 3276.00  | 722.00   | 983.00   | 1181.00  | 588.00   | 2367.00  | 3449.00  | 2920.00  | 19-24 Traineeships                                              | New          |             | 
    | 10018021 | 19TR20-0212    | 19TR-0212     | 5               | 1                     | 26224.00  | 18021.00  | 8203.00   | 987.00   | 3399.00  | 3566.00  | 1328.00  | 3359.00  | 3685.00  | 972.00   | 725.00   | 3201.00  | 458.00   | 2267.00  | 2277.00  | 19-24 Traineeships Learner Support                              | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 19TR20-0212    | 1                     | 0                        | 2022-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-0212'


    

    # Part 3: Attempt to add a 23/24 contract by bulk upload (New Amendment) but fail (MBR-005)

    # Change the date
    Given the override date is '02/07/2023'

    # Bulk file
    And   there are no files prefixed '10018021' in the Sharepoint '19TRN2020-2324-Input-Appendices' folder
    And   there are no files prefixed '19TRN2020 AY 2324 24052023172258 v3_S021' in the Sharepoint 'Input' folder
    And   there are no files prefixed '19TRN2020 AY 2324 24052023172258 v3_S021' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '19TRN2020 AY 2324 24052023172258 v3_S021' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '19TRN2020 AY 2324 24052023172258 v3_S021' in the Sharepoint 'Reports' folder
    And   spreadsheet '19TRN2020 AY 2324 24052023172258 v3_S021.xlsx' exists in the Datafiles folder and UKPRN '10018021' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # MBR-005
    And   '[Contract] This Master Contract cannot have more than one associated Contract in a draft status at the same time' is displayed in field 'J2' on the 'Contract' tab of the result report
 

    


    # Part 3: Publish and approve 22/23 contract and check feed

    # Change the date
    Given the override date is '03/07/2023'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-021' and ContractNumber '19TR20-0212' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-0212' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018021 | 19TR20-0212        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10018021 | 19TR20-021         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10018021 | ESFA-021           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-0212' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract '19TR20-0212'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 19TR-0212       | 100934           | Jul-22 | Reconciliation |

#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '3' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                       | DeliverableDescription     | 
#    | 10018021 | 19TR20-0212    | 1               | 19TR-0212     | 1               | 0                     | 51128.00     | 0             | 0        | 19-24 Traineeships Total Funding      | ?                          |
#    | 10018021 | 19TR20-0212    | 1               | 19TR-0212     | 4               | 1                     | 24904.00     | 0             | 0        | 19-24 Traineeships                    | ?                          |
#    | 10018021 | 19TR20-0212    | 1               | 19TR-0212     | 5               | 1                     | 26224.00     | 0             | 0        | 19-24 Traineeships Learner Support    | ?                          |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract '19TR20-0212' agree with the most recent entry for this contract in the ContractManagement feed
#




    # Part 4: Bulk file (again) to add 22/23 contract linked to 21/22 by Master. Check docs and doc parts

    # Change the date
    Given the override date is '04/07/2022'

    # Bulk file
    And   there are no files prefixed '10018021' in the Sharepoint '19TRN2020-2324-Input-Appendices' folder
    And   there are no files prefixed '19TRN2020 AY 2324 24052023172258 v3_S021' in the Sharepoint 'Input' folder
    And   there are no files prefixed '19TRN2020 AY 2324 24052023172258 v3_S021' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '19TRN2020 AY 2324 24052023172258 v3_S021' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '19TRN2020 AY 2324 24052023172258 v3_S021' in the Sharepoint 'Reports' folder
    And   spreadsheet '19TRN2020 AY 2324 24052023172258 v3_S021.xlsx' exists in the Datafiles folder and UKPRN '10018021' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10018021' for FundingType '19TRN2020' and period '2324' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10018021' for FundingType '19TRN2020' and period '2324'

    ## Check the contents of the Appendices
    #Then  the file named '10017394_[ContractNo]_v1.pdf' in Sharepoint location '19TRN2020-2324-Input-Appendices' contains the following lines in order
#   #Then  the file named '10017394_19TR20-394_v1.pdf' in Sharepoint location '19TRN2020-2122-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING
#    Organisation Name: 10018021 Co Ltd UKPRN: 10018021
#    Master Contract Number: ESFA-021
#    Allocation
#    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
#    19 to 24 Traineeships - 2020 Procurement 19TR-021 £33,601 £17,527 £51,128
#    of which Learner Support £18,021 £8,203 £26,224
#    Total: £51,128
#    Allocation
#    1 August 2022 to 31 July 2023 Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 Total
#    19 to 24 Traineeships - 2020 Procurement [AllocRef_19TR] £65,945 £27,389 £93,334
#    of which Learner Support £41,180 £16,991 £58,171
#    Total: £93,334
#    Total Funding for this contract: £144,462
#    Summary of Funding – Page 1
#    
#    Agreement Type Contract for Services
#    Funding Period 1 February 2021 to 31 July 2023
#    Between the Secretary of State for Education
#    And 10018021 Co Ltd
#    Funding for 19 to 24 Traineeships
#    Master Contract Number ESFA-021
#    ACCEPTANCE BY THE CONTRACTOR
#    BY ACCEPTING THIS CONTRACT VIA THE MANAGE YOUR EDUCATION &
#    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF
#    OF THE CONTRACTOR REPRESENTS AND WARRANTS THAT THE
#    CONTRACTOR HAS READ AND UNDERSTOOD THIS CONTRACT, THE
#    CONTRACTOR AGREES TO BE BOUND BY THIS CONTRACT AND THAT
#    HE/SHE IS DULY AUTHORISED TO ACCEPT THIS CONTRACT AND LEGALLY
#    BIND THE CONTRACTOR.
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    Version 4 (July 2022) Page 1
#    This Contract is made on the date the Contract is digitally signed by the
#    Contractor on the Manage Your Education & Skills Funding Service between:
#    10018021 Co Ltd THE SECRETARY OF STATE FOR
#    171 High Street EDUCATION
#    Rickmansworth DEPARTMENT FOR EDUCATION
#    Hertfordshire 20 GREAT SMITH STREET
#    AND
#    WD3 1AY LONDON
#    SW1P 3BT
#    Company No: AA018021
#    Hereinafter called Hereinafter called
#    the Contractor the Department
#    Version 4 (July 2022) Page 2
#    Version 4 (July 2022) Page 77
#
#    SCHEDULE 1: SPECIFICATION & MONITORING
#    19 TO 24-YEAR-OLD PROCURED ADULT EDUCATION BUDGET
#    TRAINEESHIPS SPECIFICATION
#    Schedule 1 Version 3 (July 2022) – Page 1
#    Schedule 1 Version 3 (July 2022) – Page 14
#    
#    SCHEDULE 2: PAYMENT
#    19-24-YEAR-OLD PROCURED ADULT EDUCATION BUDGET
#    TRAINEESHIPS
#    5. The Department will pay the Contractor on the 16 Working Day of each
#    month.
#    Schedule 2 Version 4 (February 2023) – Page 1
#    Schedule 2 Version 4 (February 2023) – Page 2
#
#    SCHEDULE 2
#    Funding Agreement – 19 to 24 Traineeships - 2020 Procurement
#    Provider: 10018021 Co Ltd UKPRN: 10018021
#    Master Contract Number: ESFA-021 Start Date: 01/08/2022 End Date: 31/07/2023
#    Contract Ref: [AllocRef_19TR]
#    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
#    19 to 24 Traineeships - 2020 Procurement £93,334 £4,082 £4,233 £12,354 £9,733 £5,422 £14,626 £6,644 £8,851 £2,227 £358 £13,915 £10,889
#    of which Learner Support £58,171 £228 £3,645 £5,566 £7,754 £4,919 £7,584 £5,429 £6,055 £2,064 £248 £7,807 £6,872
#    Total Funding £93,334 £4,082 £4,233 £12,354 £9,733 £5,422 £14,626 £6,644 £8,851 £2,227 £358 £13,915 £10,889
#    Schedule 2 – Funding Agreement [AllocRef_19TR] – Page 1 Ref (for internal use only):  [ContractNo] v1
#    
#    SCHEDULE 3: CHANGE CONTROL PROCEDURE
#    Schedule 3 Version 3 (July 2022) – Page 1
#    Schedule 9 Version 3 (July 2022) – Page 1
#    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    Then   Sharepoint file '10018021_[ContractNo]_v1.pdf' in '19TRN2020-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S021.pdf'

    # Display Sharepoint filename
    And   message '10018021_[ContractNo]_v1.pdf' is written to the Output window

    # 22/23 contract is at Draft\Awaiting Documentation


    
    # Part 5: Attempt NFA against approved 22/23 contract but fail (MBR-005) because 23/24 is in draft 

    # Change the date
    Given the override date is '10/07/2023'

    # Attempt to issue a non-financial VARIATION amendment on v1
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '19TR20-0212' for a non-financial VARIATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '19TR20-021' for a non-financial NOTIFICATION contract amendment

    # Check that a notification for MBR-005 has been created and sent to the initiating User 
    Then  there is '1' notification of type 'Non-Financial Contract Amendment Failed' owned by user 'FCS2 Test' which match the following
    | Status | NotificationName                                       | NotificationText                                                                                                                                                                                      |
    | New    | Non-Financial Contract Amendment Failed - 19TR20-0212  | Contract 19TR20-0212 v1 for provider 10018021 (10018021 Co Ltd) cannot be amended - A draft amendment already exists (or has been initiated) for another contract associated with this Master Contract |

    # Check the CONTRACT version, status and dates in CRM {F6}   19TR20-021 contract for 22/23 has not been amended because of above.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018021 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018021 | 19TR20-0212        | 1                     | 0                        | Approved         | Approved				                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10018021 | 19TR20-021         | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10018021 | ESFA-021           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 6: Publish and approve 23/24 contract. Check feed and financials

    # Change the date
    Given the override date is '12/07/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-021' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018021 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018021 | 19TR20-0212        | 1                     | 0                        | Approved         | Approved				                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10018021 | 19TR20-021         | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10018021 | ESFA-021           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_19TR] | 2355800          | Jul-24 | Reconciliation |
    | [AllocRef_19TR] | 100936           | Jul-24 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                      | DeliverableDescription   | 
    | 10018021 | [ContractNo]   | 1               | [AllocRef_19TR] | 1               | 0                     | 93334.00     | 0             | 0        | 19-24 Traineeships Total Funding     | ?                        |
    | 10018021 | [ContractNo]   | 1               | [AllocRef_19TR] | 4               | 1                     | 35163.00     | 0             | 0        | 19-24 Traineeships                   | ?                        |
    | 10018021 | [ContractNo]   | 1               | [AllocRef_19TR] | 5               | 1                     | 58171.00     | 0             | 0        | 19-24 Traineeships Learner Support   | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_19TR]    | 1               | 93334.00  | 4082.00  | 4233.00  | 12354.00 | 9733.00  | 5422.00  | 14626.00 | 6644.00  | 8851.00  | 2227.00  | 358.00   | 13915.00 | 10889.00 | 
    | [ContractNo]   | [AllocRef_19TR]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 4               | 35163.00  | 3854.00  | 588.00   | 6788.00  | 1979.00  | 503.00   | 7042.00  | 1215.00  | 2796.00  | 163.00   | 110.00   | 6108.00  | 4017.00  | 
    | [ContractNo]   | [AllocRef_19TR]    | 5               | 58171.00  | 228.00   | 3645.00  | 5566.00  | 7754.00  | 4919.00  | 7584.00  | 5429.00  | 6055.00  | 2064.00  | 248.00   | 7807.00  | 6872.00  | 
    | [ContractNo]   | [AllocRef_19TR]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 





    # Part 7: Add 23/24 actuals and check financials in CRM and PaaS

    # Add actuals to the contract for 19TRN2020-2324

    # Change the date
    Given the override date is '04/09/2023'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018021'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202308 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 2               | 0            | 574.70      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202308 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 3               | 0            | 458.03      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202308 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 6               | 0            | 929.43      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202308 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 7               | 0            | 947.96      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202308 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 8               | 0            | 1203.59     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202308 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 9               | 0            | 674.97      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202308 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 10              | 0            | 530.40      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202309 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 2               | 0            | 452.25      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202309 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 3               | 0            | 581.63      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202309 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 6               | 0            | 430.54      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202309 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 7               | 0            | 407.05      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202309 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 8               | 0            | 1204.67     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202309 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 9               | 0            | 1239.75     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202309 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 10              | 0            | 1272.68     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202310 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 2               | 0            | 993.75      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202310 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 3               | 0            | 417.79      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202310 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 6               | 0            | 993.24      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202310 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 7               | 0            | 1396.04     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202310 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 8               | 0            | 284.63      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202310 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 9               | 0            | 1374.80     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202310 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 10              | 0            | 695.78      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202311 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 2               | 0            | 1130.28     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202311 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 3               | 0            | 1118.83     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202311 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 6               | 0            | 323.91      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202311 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 7               | 0            | 1055.75     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202311 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 8               | 0            | 1240.86     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202311 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 9               | 0            | 1278.10     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202311 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 10              | 0            | 1185.53     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202312 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 2               | 0            | 1015.18     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202312 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 3               | 0            | 292.31      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202312 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 6               | 0            | 1396.98     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202312 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 7               | 0            | 571.63      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202312 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 8               | 0            | 1441.15     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202312 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 9               | 0            | 1074.04     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202312 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 10              | 0            | 685.44      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202401 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 2               | 0            | 617.93      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202401 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 3               | 0            | 379.70      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202401 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 6               | 0            | 1088.52     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202401 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 7               | 0            | 464.05      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202401 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 8               | 0            | 878.34      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202401 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 9               | 0            | 1122.23     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202401 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 10              | 0            | 852.22      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202402 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 2               | 0            | 511.65      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202402 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 3               | 0            | 532.00      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202402 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 6               | 0            | 584.39      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202402 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 7               | 0            | 1258.76     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202402 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 8               | 0            | 725.45      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202402 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 9               | 0            | 902.85      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202402 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 10              | 0            | 497.53      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202403 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 2               | 0            | 1254.74     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202403 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 3               | 0            | 593.77      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202403 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 6               | 0            | 791.63      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202403 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 7               | 0            | 1412.58     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202403 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 8               | 0            | 828.04      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202403 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 9               | 0            | 1481.11     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202403 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 10              | 0            | 870.40      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202404 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 2               | 0            | 766.41      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202404 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 3               | 0            | 558.56      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202404 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 6               | 0            | 475.86      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202404 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 7               | 0            | 889.60      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202404 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 8               | 0            | 1260.86     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202404 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 9               | 0            | 1481.56     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202404 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 10              | 0            | 800.47      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202405 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 2               | 0            | 947.59      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202405 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 3               | 0            | 803.99      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202405 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 6               | 0            | 263.33      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202405 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 7               | 0            | 1284.04     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202405 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 8               | 0            | 572.63      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202405 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 9               | 0            | 264.12      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202405 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 10              | 0            | 939.64      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202406 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 2               | 0            | 1147.53     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202406 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 3               | 0            | 617.47      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202406 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 6               | 0            | 286.17      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202406 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 7               | 0            | 716.34      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202406 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 8               | 0            | 1351.41     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202406 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 9               | 0            | 466.33      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202406 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 10              | 0            | 920.55      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202407 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 2               | 0            | 1082.79     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202407 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 3               | 0            | 1255.81     |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202407 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 6               | 0            | 554.48      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202407 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 7               | 0            | 314.63      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202407 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 8               | 0            | 487.52      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202407 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 9               | 0            | 593.15      |
    | ILR2324        | R01                  | ORG0018021     | CM             | 202407 | 19TRN2020-2324          | [AllocRef_19TR]          | ?          | 10              | 0            | 1450.22     |
                                                                                                                   
    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_19TR]    | 1               | 93334.00  | 4082.00  | 4233.00  | 12354.00 | 9733.00  | 5422.00  | 14626.00 | 6644.00  | 8851.00  | 2227.00  | 358.00   | 13915.00 | 10889.00 | 
    | [ContractNo]   | [AllocRef_19TR]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 4               | 35163.00  | 3854.00  | 588.00   | 6788.00  | 1979.00  | 503.00   | 7042.00  | 1215.00  | 2796.00  | 163.00   | 110.00   | 6108.00  | 4017.00  | 
    | [ContractNo]   | [AllocRef_19TR]    | 5               | 58171.00  | 228.00   | 3645.00  | 5566.00  | 7754.00  | 4919.00  | 7584.00  | 5429.00  | 6055.00  | 2064.00  | 248.00   | 7807.00  | 6872.00  | 
    | [ContractNo]   | [AllocRef_19TR]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_19TR]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 2               | 574.70    | 574.70   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 3               | 458.03    | 458.03   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 6               | 929.43    | 929.43   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 7               | 947.96    | 947.96   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 8               | 1203.59   | 1203.59  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 9               | 674.97    | 674.97   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 10              | 530.40    | 530.40   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_19TR]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 2               | 574.70    | 574.70   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 3               | 458.03    | 458.03   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 6               | 929.43    | 929.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 7               | 947.96    | 947.96   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 8               | 1203.59   | 1203.59  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 9               | 674.97    | 674.97   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 10              | 530.40    | 530.40   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_19TR]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 2               | 574.70    | 574.70   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 3               | 458.03    | 458.03   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 6               | 929.43    | 929.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 7               | 947.96    | 947.96   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 8               | 1203.59   | 1203.59  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 9               | 674.97    | 674.97   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 10              | 530.40    | 530.40   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-23    | Sep-23    | Oct-23    | Nov-23    | Dec-23    | Jan-24    | Feb-24    | Mar-24    | Apr-24    | May-24    | Jun-24    | Jul-24   | 
    | 10018021 | [ContractNo]   | [AllocRef_19TR]    | 100932                   | 929.43    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10018021 | [ContractNo]   | [AllocRef_19TR]    | 100933                   | 947.96    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10018021 | [ContractNo]   | [AllocRef_19TR]    | 100934                   | 1203.59   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10018021 | [ContractNo]   | [AllocRef_19TR]    | 100935                   | 674.97    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10018021 | [ContractNo]   | [AllocRef_19TR]    | 100936                   | 530.40    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10018021 | [ContractNo]   | [AllocRef_19TR]    | 2355800                  | 574.70    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10018021 | [ContractNo]   | [AllocRef_19TR]    | 2355860                  | 458.03    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 





#    # Part 8: CDA
#    
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version S021.csv'
#
#    Then  the contracts are in the replicated CRM database as follows
#    | ContractNumber | ContractVersionNumber |
#    | [ContractNo]   | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version               | Suffix |
#    | 19TRN2020-2324        | Latest Version        | S021   |
#
#    Then  a report named 'CDA Latest Version S021.csv' is created
#    # Check the above report manually

#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 8                 | 2023            | 2022/23       |              | 3854         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 9                 | 2023            | 2022/23       |              | 588          |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 10                | 2023            | 2022/23       |              | 6788         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 11                | 2023            | 2022/23       |              | 1979         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 12                | 2023            | 2022/23       |              | 503          |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 1                 | 2024            | 2022/23       |              | 7042         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 2                 | 2024            | 2022/23       |              | 1215         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 3                 | 2024            | 2022/23       |              | 2796         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 4                 | 2024            | 2023/24       |              | 163          |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 5                 | 2024            | 2023/24       |              | 110          |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 6                 | 2024            | 2023/24       |              | 6108         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 7                 | 2024            | 2023/24       |              | 4017         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 19+ Hardship                      | 19-24 Traineeships 19+ Hardship                                 | 19-24 Traineeships Learner Support                              | 8                 | 2023            | 2022/23       |              | 0            | 929.43       | 0             |              | Yes                | 0.00           | 0.00             | 929.43                | 0.00           | 929.43          |             | No            |                   |        |                   | 100932                   | 2355816           | Aug              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 19+ Hardship                      | 19-24 Traineeships 19+ Hardship                                 | 19-24 Traineeships Learner Support                              | 9                 | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100932                   | 2355816           | Sep              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 19+ Hardship                      | 19-24 Traineeships 19+ Hardship                                 | 19-24 Traineeships Learner Support                              | 10                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100932                   | 2355816           | Oct              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 19+ Hardship                      | 19-24 Traineeships 19+ Hardship                                 | 19-24 Traineeships Learner Support                              | 11                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100932                   | 2355816           | Nov              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 19+ Hardship                      | 19-24 Traineeships 19+ Hardship                                 | 19-24 Traineeships Learner Support                              | 12                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100932                   | 2355816           | Dec              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 19+ Hardship                      | 19-24 Traineeships 19+ Hardship                                 | 19-24 Traineeships Learner Support                              | 1                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100932                   | 2355816           | Jan              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 19+ Hardship                      | 19-24 Traineeships 19+ Hardship                                 | 19-24 Traineeships Learner Support                              | 2                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100932                   | 2355816           | Feb              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 19+ Hardship                      | 19-24 Traineeships 19+ Hardship                                 | 19-24 Traineeships Learner Support                              | 3                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100932                   | 2355816           | Mar              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 19+ Hardship                      | 19-24 Traineeships 19+ Hardship                                 | 19-24 Traineeships Learner Support                              | 4                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100932                   | 2355816           | Apr              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 19+ Hardship                      | 19-24 Traineeships 19+ Hardship                                 | 19-24 Traineeships Learner Support                              | 5                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100932                   | 2355816           | May              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 19+ Hardship                      | 19-24 Traineeships 19+ Hardship                                 | 19-24 Traineeships Learner Support                              | 6                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100932                   | 2355816           | Jun              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 19+ Hardship                      | 19-24 Traineeships 19+ Hardship                                 | 19-24 Traineeships Learner Support                              | 7                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100932                   | 2355816           | Jul              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 20+ Childcare                     | 19-24 Traineeships 20+ Childcare                                | 19-24 Traineeships Learner Support                              | 8                 | 2023            | 2022/23       |              | 0            | 947.96       | 0             |              | Yes                | 0.00           | 0.00             | 947.96                | 0.00           | 947.96          |             | No            |                   |        |                   | 100933                   | 2355816           | Aug              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 20+ Childcare                     | 19-24 Traineeships 20+ Childcare                                | 19-24 Traineeships Learner Support                              | 9                 | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100933                   | 2355816           | Sep              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 20+ Childcare                     | 19-24 Traineeships 20+ Childcare                                | 19-24 Traineeships Learner Support                              | 10                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100933                   | 2355816           | Oct              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 20+ Childcare                     | 19-24 Traineeships 20+ Childcare                                | 19-24 Traineeships Learner Support                              | 11                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100933                   | 2355816           | Nov              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 20+ Childcare                     | 19-24 Traineeships 20+ Childcare                                | 19-24 Traineeships Learner Support                              | 12                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100933                   | 2355816           | Dec              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 20+ Childcare                     | 19-24 Traineeships 20+ Childcare                                | 19-24 Traineeships Learner Support                              | 1                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100933                   | 2355816           | Jan              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 20+ Childcare                     | 19-24 Traineeships 20+ Childcare                                | 19-24 Traineeships Learner Support                              | 2                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100933                   | 2355816           | Feb              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 20+ Childcare                     | 19-24 Traineeships 20+ Childcare                                | 19-24 Traineeships Learner Support                              | 3                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100933                   | 2355816           | Mar              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 20+ Childcare                     | 19-24 Traineeships 20+ Childcare                                | 19-24 Traineeships Learner Support                              | 4                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100933                   | 2355816           | Apr              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 20+ Childcare                     | 19-24 Traineeships 20+ Childcare                                | 19-24 Traineeships Learner Support                              | 5                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100933                   | 2355816           | May              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 20+ Childcare                     | 19-24 Traineeships 20+ Childcare                                | 19-24 Traineeships Learner Support                              | 6                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100933                   | 2355816           | Jun              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships 20+ Childcare                     | 19-24 Traineeships 20+ Childcare                                | 19-24 Traineeships Learner Support                              | 7                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100933                   | 2355816           | Jul              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Administration Expenditure        | 19-24 Traineeships Administration Expenditure                   | 19-24 Traineeships Learner Support                              | 8                 | 2023            | 2022/23       |              | 0            | 674.97       | 0             |              | Yes                | 0.00           | 0.00             | 674.97                | 0.00           | 674.97          |             | No            |                   |        |                   | 100935                   | 2355816           | Aug              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Administration Expenditure        | 19-24 Traineeships Administration Expenditure                   | 19-24 Traineeships Learner Support                              | 9                 | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100935                   | 2355816           | Sep              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Administration Expenditure        | 19-24 Traineeships Administration Expenditure                   | 19-24 Traineeships Learner Support                              | 10                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100935                   | 2355816           | Oct              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Administration Expenditure        | 19-24 Traineeships Administration Expenditure                   | 19-24 Traineeships Learner Support                              | 11                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100935                   | 2355816           | Nov              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Administration Expenditure        | 19-24 Traineeships Administration Expenditure                   | 19-24 Traineeships Learner Support                              | 12                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100935                   | 2355816           | Dec              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Administration Expenditure        | 19-24 Traineeships Administration Expenditure                   | 19-24 Traineeships Learner Support                              | 1                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100935                   | 2355816           | Jan              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Administration Expenditure        | 19-24 Traineeships Administration Expenditure                   | 19-24 Traineeships Learner Support                              | 2                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100935                   | 2355816           | Feb              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Administration Expenditure        | 19-24 Traineeships Administration Expenditure                   | 19-24 Traineeships Learner Support                              | 3                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100935                   | 2355816           | Mar              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Administration Expenditure        | 19-24 Traineeships Administration Expenditure                   | 19-24 Traineeships Learner Support                              | 4                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100935                   | 2355816           | Apr              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Administration Expenditure        | 19-24 Traineeships Administration Expenditure                   | 19-24 Traineeships Learner Support                              | 5                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100935                   | 2355816           | May              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Administration Expenditure        | 19-24 Traineeships Administration Expenditure                   | 19-24 Traineeships Learner Support                              | 6                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100935                   | 2355816           | Jun              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Administration Expenditure        | 19-24 Traineeships Administration Expenditure                   | 19-24 Traineeships Learner Support                              | 7                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100935                   | 2355816           | Jul              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships COVID-19 Response (ICT)           | 19-24 Traineeships COVID-19 Response (ICT)                      | 19-24 Traineeships Learner Support                              | 8                 | 2023            | 2022/23       |              | 0            | 530.4        | 0             |              | Yes                | 0.00           | 0.00             | 530.40                | 0.00           | 530.40          |             | No            |                   |        |                   | 100936                   | 2355816           | Aug              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships COVID-19 Response (ICT)           | 19-24 Traineeships COVID-19 Response (ICT)                      | 19-24 Traineeships Learner Support                              | 9                 | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100936                   | 2355816           | Sep              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships COVID-19 Response (ICT)           | 19-24 Traineeships COVID-19 Response (ICT)                      | 19-24 Traineeships Learner Support                              | 10                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100936                   | 2355816           | Oct              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships COVID-19 Response (ICT)           | 19-24 Traineeships COVID-19 Response (ICT)                      | 19-24 Traineeships Learner Support                              | 11                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100936                   | 2355816           | Nov              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships COVID-19 Response (ICT)           | 19-24 Traineeships COVID-19 Response (ICT)                      | 19-24 Traineeships Learner Support                              | 12                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100936                   | 2355816           | Dec              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships COVID-19 Response (ICT)           | 19-24 Traineeships COVID-19 Response (ICT)                      | 19-24 Traineeships Learner Support                              | 1                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100936                   | 2355816           | Jan              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships COVID-19 Response (ICT)           | 19-24 Traineeships COVID-19 Response (ICT)                      | 19-24 Traineeships Learner Support                              | 2                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100936                   | 2355816           | Feb              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships COVID-19 Response (ICT)           | 19-24 Traineeships COVID-19 Response (ICT)                      | 19-24 Traineeships Learner Support                              | 3                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100936                   | 2355816           | Mar              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships COVID-19 Response (ICT)           | 19-24 Traineeships COVID-19 Response (ICT)                      | 19-24 Traineeships Learner Support                              | 4                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100936                   | 2355816           | Apr              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships COVID-19 Response (ICT)           | 19-24 Traineeships COVID-19 Response (ICT)                      | 19-24 Traineeships Learner Support                              | 5                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100936                   | 2355816           | May              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships COVID-19 Response (ICT)           | 19-24 Traineeships COVID-19 Response (ICT)                      | 19-24 Traineeships Learner Support                              | 6                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100936                   | 2355816           | Jun              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships COVID-19 Response (ICT)           | 19-24 Traineeships COVID-19 Response (ICT)                      | 19-24 Traineeships Learner Support                              | 7                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100936                   | 2355816           | Jul              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 8                 | 2023            | 2022/23       |              | 228          |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 9                 | 2023            | 2022/23       |              | 3645         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 10                | 2023            | 2022/23       |              | 5566         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 11                | 2023            | 2022/23       |              | 7754         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 12                | 2023            | 2022/23       |              | 4919         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 1                 | 2024            | 2022/23       |              | 7584         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 2                 | 2024            | 2022/23       |              | 5429         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 3                 | 2024            | 2022/23       |              | 6055         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 4                 | 2024            | 2023/24       |              | 2064         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 5                 | 2024            | 2023/24       |              | 248          |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 6                 | 2024            | 2023/24       |              | 7807         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 7                 | 2024            | 2023/24       |              | 6872         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships                                              | 8                 | 2023            | 2022/23       |              | 0            | 458.03       | 0             |              | Yes                | 0.00           | 0.00             | 458.03                | 0.00           | 458.03          |             | No            |                   |        |                   | 2355860                  | 2355816           | Aug              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships                                              | 9                 | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355860                  | 2355816           | Sep              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships                                              | 10                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355860                  | 2355816           | Oct              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships                                              | 11                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355860                  | 2355816           | Nov              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships                                              | 12                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355860                  | 2355816           | Dec              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships                                              | 1                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355860                  | 2355816           | Jan              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships                                              | 2                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355860                  | 2355816           | Feb              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships                                              | 3                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355860                  | 2355816           | Mar              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships                                              | 4                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355860                  | 2355816           | Apr              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships                                              | 5                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355860                  | 2355816           | May              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships                                              | 6                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355860                  | 2355816           | Jun              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships                                              | 7                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355860                  | 2355816           | Jul              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships                                              | 8                 | 2023            | 2022/23       |              | 0            | 574.7        | 0             |              | Yes                | 0.00           | 0.00             | 574.70                | 0.00           | 574.70          |             | No            |                   |        |                   | 2355800                  | 2355816           | Aug              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships                                              | 9                 | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355800                  | 2355816           | Sep              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships                                              | 10                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355800                  | 2355816           | Oct              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships                                              | 11                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355800                  | 2355816           | Nov              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships                                              | 12                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355800                  | 2355816           | Dec              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships                                              | 1                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355800                  | 2355816           | Jan              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships                                              | 2                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355800                  | 2355816           | Feb              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships                                              | 3                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355800                  | 2355816           | Mar              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships                                              | 4                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355800                  | 2355816           | Apr              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships                                              | 5                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355800                  | 2355816           | May              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships                                              | 6                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355800                  | 2355816           | Jun              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships                                              | 7                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355800                  | 2355816           | Jul              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Residential Access Fund           | 19-24 Traineeships Residential Access Fund                      | 19-24 Traineeships Learner Support                              | 8                 | 2023            | 2022/23       |              | 0            | 1203.59      | 0             |              | Yes                | 0.00           | 0.00             | 1203.59               | 0.00           | 1203.59         |             | No            |                   |        |                   | 100934                   | 2355816           | Aug              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Residential Access Fund           | 19-24 Traineeships Residential Access Fund                      | 19-24 Traineeships Learner Support                              | 9                 | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100934                   | 2355816           | Sep              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Residential Access Fund           | 19-24 Traineeships Residential Access Fund                      | 19-24 Traineeships Learner Support                              | 10                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100934                   | 2355816           | Oct              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Residential Access Fund           | 19-24 Traineeships Residential Access Fund                      | 19-24 Traineeships Learner Support                              | 11                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100934                   | 2355816           | Nov              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Residential Access Fund           | 19-24 Traineeships Residential Access Fund                      | 19-24 Traineeships Learner Support                              | 12                | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100934                   | 2355816           | Dec              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Residential Access Fund           | 19-24 Traineeships Residential Access Fund                      | 19-24 Traineeships Learner Support                              | 1                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100934                   | 2355816           | Jan              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Residential Access Fund           | 19-24 Traineeships Residential Access Fund                      | 19-24 Traineeships Learner Support                              | 2                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100934                   | 2355816           | Feb              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Residential Access Fund           | 19-24 Traineeships Residential Access Fund                      | 19-24 Traineeships Learner Support                              | 3                 | 2024            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100934                   | 2355816           | Mar              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Residential Access Fund           | 19-24 Traineeships Residential Access Fund                      | 19-24 Traineeships Learner Support                              | 4                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100934                   | 2355816           | Apr              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Residential Access Fund           | 19-24 Traineeships Residential Access Fund                      | 19-24 Traineeships Learner Support                              | 5                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100934                   | 2355816           | May              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Residential Access Fund           | 19-24 Traineeships Residential Access Fund                      | 19-24 Traineeships Learner Support                              | 6                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100934                   | 2355816           | Jun              |
#    | 19TRN2020-2324          | 10018021 | 10018021 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-021                | 01/08/2023                  | 31/07/2024                | 1                     | Approved       | Approved                | 19-24 Traineeships Residential Access Fund           | 19-24 Traineeships Residential Access Fund                      | 19-24 Traineeships Learner Support                              | 7                 | 2024            | 2023/24       |              | 0            |              | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100934                   | 2355816           | Jul              |
#
#
#


    # Part 9: Payment Batch for 19TRN2020-2324

    # Change the date
    Given the override date is '08/09/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '19TRN2020-2324' AccountingPaymentPeriod '202305' CensusEndDate '08/09/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_19TR]          | 202308 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 19TRN2020-2324             | 202308               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 19TRN2020-2324             | 202308               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '19TRN2020-2324' PaymentPeriod '202305' CensusEndDate '08/09/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S021.xml'

#    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    And   the Payment feed xml for FundingStreamPeriod '19TRN2020-2324' PaymentPeriod '202305' CensusEndDate '08/09/2023' and LinkCodeSuffix 'A' includes the following values
#    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    | 19TR                   | 2023          | 05             | 08          | ?       | [AllocRef_19TR]  | 929.43          | RECONCILIATION   | 19-24Trn19+Hardship                | 2023-09-22 | 2023-08-01   | 2024-07-31 | ?              | 10018021 | 100932     |
#    | 19TR                   | 2023          | 05             | 08          | ?       | [AllocRef_19TR]  | 947.96          | RECONCILIATION   | 19-24Trn20+Childcare               | 2023-09-22 | 2023-08-01   | 2024-07-31 | ?              | 10018021 | 100933     |
#    | 19TR                   | 2023          | 05             | 08          | ?       | [AllocRef_19TR]  | 1203.59         | RECONCILIATION   | 19-24TrnRsdntlAccess               | 2023-09-22 | 2023-08-01   | 2024-07-31 | ?              | 10018021 | 100934     |
#    | 19TR                   | 2023          | 05             | 08          | ?       | [AllocRef_19TR]  | 674.97          | RECONCILIATION   | 19-24TrnAdminExp                   | 2023-09-22 | 2023-08-01   | 2024-07-31 | ?              | 10018021 | 100935     |
#    | 19TR                   | 2023          | 05             | 08          | ?       | [AllocRef_19TR]  | 530.40          | RECONCILIATION   | 19-24TrnC19Response                | 2023-09-22 | 2023-08-01   | 2024-07-31 | ?              | 10018021 | 100936     |
#    | 19TR                   | 2023          | 05             | 08          | ?       | [AllocRef_19TR]  | 574.70          | RECONCILIATION   | 19-24 Traineeships                 | 2023-09-22 | 2023-08-01   | 2024-07-31 | ?              | 10018021 | 2355800    |
#    | 19TR                   | 2023          | 05             | 08          | ?       | [AllocRef_19TR]  | 458.03          | RECONCILIATION   | 19-24TraineeshpsLngS               | 2023-09-22 | 2023-08-01   | 2024-07-31 | ?              | 10018021 | 2355860    |
#


    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod '19TRN2020-2324' AccountingPaymentPeriod '202305' and CensusEndDate '08/09/2023'
#
#    # Title details
#    And   the Payment feed item TITLE is as follows
#    | Title                                                                                                                                                          |
#    | Payment Requests for Funding Stream Period 19TRN2020-2324 for Payment Period 202305 have been generated as of Census End Date/Time 2023-09-08T22:00:00Z.       |
#
#    # Summary details
#    And   the Payment feed item SUMMARY is as follows
#    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
#    | 19TRN2020-2324      | 202305        | 2023-09-08T22:00:00Z  | 7                | 5319.08    |
#
#    # PaymentPeriod details
#    And   the Payment feed item PaymentPeriod details are as follows
#    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
#    | ESFA   | 19TR      | 01/08/2023   | 31/07/2024 | 08/09/2023    | 22/09/2023 | 2023          | 05             |
#
#    # PaymentDetails
#    And   the Payment feed item PaymentDetails are as follows
#    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef         | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
#    | ORG0018021  | 10018021       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_19TR]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100932     | RECONCILIATION | 19-24Trn19+Hardship           | 929.43          |
#    | ORG0018021  | 10018021       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_19TR]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100933     | RECONCILIATION | 19-24Trn20+Childcare          | 947.96          |
#    | ORG0018021  | 10018021       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_19TR]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100934     | RECONCILIATION | 19-24TrnRsdntlAccess          | 1203.59         |
#    | ORG0018021  | 10018021       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_19TR]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100935     | RECONCILIATION | 19-24TrnAdminExp              | 674.97          |
#    | ORG0018021  | 10018021       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_19TR]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100936     | RECONCILIATION | 19-24TrnC19Response           | 530.40          |
#    | ORG0018021  | 10018021       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_19TR]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355800    | RECONCILIATION | 19-24 Traineeships            | 574.70          |
#    | ORG0018021  | 10018021       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_19TR]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355860    | RECONCILIATION | 19-24TraineeshpsLngS          | 458.03          |
#
#
#    # Check ADP
#
#    # Check all activity has completed
#    When  there are no messages left in the system
#
#    # Check financials on the ADP feed for Aug-23
#    Then  the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
#    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_19TR]  | 1               | 202308 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_19TR]  | 2               | 202308 | 574.70      | 0.00           | 0.00             | 574.70                | 0.00           | 574.70     |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_19TR]  | 3               | 202308 | 458.03      | 0.00           | 0.00             | 458.03                | 0.00           | 458.03     |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_19TR]  | 4               | 202308 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_19TR]  | 5               | 202308 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_19TR]  | 6               | 202308 | 929.43      | 0.00           | 0.00             | 929.43                | 0.00           | 929.43     |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_19TR]  | 7               | 202308 | 947.96      | 0.00           | 0.00             | 947.96                | 0.00           | 947.96     |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_19TR]  | 8               | 202308 | 1203.59     | 0.00           | 0.00             | 1203.59               | 0.00           | 1203.59    |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_19TR]  | 9               | 202308 | 674.97      | 0.00           | 0.00             | 674.97                | 0.00           | 674.97     |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_19TR]  | 10              | 202308 | 530.40      | 0.00           | 0.00             | 530.40                | 0.00           | 530.40     |


     Then wait '30' seconds
       
    # Create Consolidated Payment Summary rpt
   
    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    #Given the override date is '06/01/2023 10:00'

   Given there are no files prefixed '2023-09 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
   
   When  a Consolidated Payment Summary Report is created in Sharepoint for '09/09/2023'
    # Check the above report manually



    # Tidy Up
    Given the override date is reset
       
