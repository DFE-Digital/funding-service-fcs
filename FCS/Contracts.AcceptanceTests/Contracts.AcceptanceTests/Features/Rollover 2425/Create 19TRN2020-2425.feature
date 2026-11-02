Feature: Create 19TRN2020-2425

@AcceptanceTest @Complete
@Long2Run @Long2Run123
Scenario: AK021 Create 19-24 Traineeships contracts linked by Master for 20/21, 21/22 , 22/23 and 23/24. Bulk load a NewAmendment for 24/25. Approve. Check docs, CRM and Feed 

    # 1. Create and approve 20/21 contract
    # 2. Create and approve 21/22 contract linked to 20/21 by Master
    # 3. Create and approve 22/23 contract linked to  Master
    # 4. Bulk load 'New Amendment' for 23/24. Publish and approve
    # Check docs, CRM and Feed

    Given there are no allocations marked as Under Termination for UKPRN '10010021' 
    And   there are no terminated or closed allocations for UKPRN '10010021' 
    And   there is no Contract, Task or Workflow data for UKPRN '10010021' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10010021' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10010021' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 19TL-121      |
    | 19TR-121      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 19TL-121      |
    | 19TR-121      |
    | 19TL-1211     |

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
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10010021'

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | 19TR20-121     | 1                     | 0                        |
    | 19TR20-1201    | 1                     | 0                        |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10010021' 
    And   there is no caseload advisor for UKPRN '10010021' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10010021 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10010021' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10010021 Co Ltd' with UKPRN '10010021' and OrgId 'ORG0010021' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10010021 | 110021 | 10010021 Co Ltd | 0              | Active                | Yes           | AA010021      | ?             | 345 The Meadway        | Tilehurst              | ?                      | ?                      | Reading                | Berkshire              | RG30 4NU  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10010021 |


    




    # Part 1: Create and approve 20/21 contract
    
    # Change the date
    Given the override date is '01/01/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '19TR20-020'
    And   there are no details in ContractManagement.CreatedContract for '19TR20-121'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10010021 | 10010021 Co Ltd      | ESFA-121             | 19TR20-121     | 1                     | 01/02/2021        | 31/07/2021      | 22463.00      |                                       | Contract for Services                      | 2021   | New          | ORG0010021 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10010021 | 19TR20-121     | 19TL-121      | 19TRN2020-LS      | 19TRN2020-LS2021        | AY                      | 01/02/2021          | 31/07/2021        | 10876.00        |                                         |            |                                                             | New          |             |
    | 10010021 | 19TR20-121     | 19TR-121      | 19TRN2020         | 19TRN2020-2021          | AY                      | 01/02/2021          | 31/07/2021        | 11587.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10010021 | 19TR20-121     | 19TL-121      | 1               | 0                     | 10876.00  | 1746.00  | 1089.00  | 2077.00  | 2813.00  | 1588.00  | 1563.00  | 19-24 Traineeships Learner Support Total Funding                | New          |             | 
    | 10010021 | 19TR20-121     | 19TR-121      | 1               | 0                     | 11587.00  | 2038.00  | 1065.00  | 3002.00  | 892.00   | 1786.00  | 2804.00  | 19-24 Traineeships Total Funding                                | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 19TR20-121     | 1                     | 0                        | 2021-01-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-121'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-121' and ContractNumber '19TR20-121' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-121' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010021 | 19TR20-121         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/02/2021        | 31/07/2021      | ?             |
    | 10010021 | ESFA-121           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-121' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract '19TR20-121'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 19TR-121        | 2355800          | Jul-21 | Reconciliation |
    | 19TL-121        | 2355875          | Jul-21 | Reconciliation |

    Then wait '10' seconds

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10010021 | 19TR20-121     | 1               | 19TL-121      | 1               | 0                     | 10876.00     | 0             | 0        | 19-24 Traineeships Learner Support Total Funding                | ?                                                           |
    | 10010021 | 19TR20-121     | 1               | 19TR-121      | 1               | 0                     | 11587.00     | 0             | 0        | 19-24 Traineeships Total Funding                                | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-121' agree with the most recent entry for this contract in the ContractManagement feed

# Part 2: Create and approve 21/22 contract linked to 20/21 by Master

    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '19TR20-121'
    And   there are no details in ContractManagement.CreatedContract for '19TR20-1211'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10010021 | 10010021 Co Ltd      | ESFA-121             | 19TR20-1211    | 1                     | 01/08/2021        | 31/07/2022      | 44392.00      |                                       | Contract for Services                      | 2122   | New          | ORG0018020 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10010021 | 19TR20-1211    | 19TR-1211     | 19TRN2020         | 19TRN2020-2122          | AY                      | 01/08/2021          | 31/07/2022        | 44392.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription               | CRMIntent    | DeliveryOrg |
    | 10010021 | 19TR20-1211    | 19TR-1211     | 1               | 0                     | 44392.00  | 29439.00  | 14953.00  | 5969.00  | 2663.00  | 1477.00  | 2316.00  | 5464.00  | 3423.00  | 4862.00  | 3265.00  | 1634.00  | 4560.00  | 6887.00  | 1872.00  | 19-24 Traineeships Total Funding     | New          |             | 
    | 10010021 | 19TR20-1211    | 19TR-1211     | 4               | 1                     | 20345.00  | 15336.00  | 5009.00   | 3328.00  | 2577.00  | 1129.00  | 1771.00  | 1811.00  | 1692.00  | 2048.00  | 980.00   | 481.00   | 995.00   | 3155.00  | 378.00   | 19-24 Traineeships                   | New          |             | 
    | 10010021 | 19TR20-1211    | 19TR-1211     | 5               | 1                     | 24047.00  | 14103.00  | 9944.00   | 2641.00  | 86.00    | 348.00   | 545.00   | 3653.00  | 1731.00  | 2814.00  | 2285.00  | 1153.00  | 3565.00  | 3732.00  | 1494.00  | 19-24 Traineeships Learner Support   | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 19TR20-1211    | 1                     | 0                        | 2021-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-1211'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-121' and ContractNumber '19TR20-1211' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-1211' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010021 | 19TR20-1211        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10010021 | ESFA-121           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-1211' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract '19TR20-1211'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 19TR-1211       | 100934           | Jul-22 | Reconciliation |

    Then wait '10' seconds

#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                          | DeliverableDescription    | 
    | 10010021 | 19TR20-1211    | 1               | 19TR-1211     | 1               | 0                     | 44392.00     | 0             | 0        | 19-24 Traineeships Total Funding         | ?                         |
    | 10010021 | 19TR20-1211    | 1               | 19TR-1211     | 4               | 1                     | 20345.00     | 0             | 0        | 19-24 Traineeships                       | ?                         |
    | 10010021 | 19TR20-1211    | 1               | 19TR-1211     | 5               | 1                     | 24047.00     | 0             | 0        | 19-24 Traineeships Learner Support       | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-1211' agree with the most recent entry for this contract in the ContractManagement feed

    
# Part 3: Create and approve 22/23 contract linked to Master

    # Change the date
    Given the override date is '01/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '19TR20-121'
    And   there are no details in ContractManagement.CreatedContract for '19TR20-1212'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10010021 | 10010021 Co Ltd      | ESFA-121             | 19TR20-1212    | 1                     | 01/08/2022        | 31/07/2023      | 46392.00      |                                       | Contract for Services                      | 2223   | New          | ORG0018020 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10010021 | 19TR20-1212    | 19TR-1212     | 19TRN2020         | 19TRN2020-2223          | AY                      | 01/08/2022          | 31/07/2023        | 44392.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableDescription               | CRMIntent    | DeliveryOrg |
    | 10010021 | 19TR20-1212    | 19TR-1212     | 1               | 0                     | 46392.00  | 29439.00  | 14953.00  | 7969.00  | 2663.00  | 1477.00  | 2316.00  | 5464.00  | 3423.00  | 4862.00  | 3265.00  | 1634.00  | 4560.00  | 6887.00  | 1872.00  | 19-24 Traineeships Total Funding     | New          |             | 
    | 10010021 | 19TR20-1212    | 19TR-1212     | 4               | 1                     | 21345.00  | 15336.00  | 5009.00   | 4328.00  | 2577.00  | 1129.00  | 1771.00  | 1811.00  | 1692.00  | 2048.00  | 980.00   | 481.00   | 995.00   | 3155.00  | 378.00   | 19-24 Traineeships                   | New          |             | 
    | 10010021 | 19TR20-1212    | 19TR-1212     | 5               | 1                     | 25047.00  | 14103.00  | 9944.00   | 3641.00  | 86.00    | 348.00   | 545.00   | 3653.00  | 1731.00  | 2814.00  | 2285.00  | 1153.00  | 3565.00  | 3732.00  | 1494.00  | 19-24 Traineeships Learner Support   | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 19TR20-1212    | 1                     | 0                        | 2023-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-1212'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-121' and ContractNumber '19TR20-1212' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-1212' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010021 | 19TR20-1212        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10010021 | 19TR20-1211        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10010021 | ESFA-121           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-1212' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract '19TR20-1212'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 19TR-1212       | 100934           | Jul-23 | Reconciliation |

    Then wait '10' seconds

#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
   Then  the Legal Contract CM feed contains the following '3' deliverables
   | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                          | DeliverableDescription    | 
   | 10010021 | 19TR20-1212    | 1               | 19TR-1212     | 1               | 0                     | 46392.00     | 0             | 0        | 19-24 Traineeships Total Funding         | ?                         |
   | 10010021 | 19TR20-1212    | 1               | 19TR-1212     | 4               | 1                     | 21345.00     | 0             | 0        | 19-24 Traineeships                       | ?                         |
   | 10010021 | 19TR20-1212    | 1               | 19TR-1212     | 5               | 1                     | 25047.00     | 0             | 0        | 19-24 Traineeships Learner Support       | ?                         |

   # Test CRM details against same in ContractManagement feed (30447)
   Then  the details in CRM for version '1' of contract '19TR20-1212' agree with the most recent entry for this contract in the ContractManagement feed




    

    # Part 4: Create and approve 23/24 contract linked to Master

    # Change the date
    Given the override date is '01/07/2023'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '19TR20-121'
    And   there are no details in ContractManagement.CreatedContract for '19TR20-1213'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10010021 | 10010021 Co Ltd      | ESFA-121             | 19TR20-1213    | 1                     | 01/08/2023        | 31/07/2024      | 46392.00      |                                       | Contract for Services                      | 2324   | New          | ORG0010021 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10010021 | 19TR20-1213    | 19TR-1213     | 19TRN2020         | 19TRN2020-2324          | AY                      | 01/08/2023          | 31/07/2024        | 44392.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableDescription               | CRMIntent    | DeliveryOrg |
    | 10010021 | 19TR20-1213    | 19TR-1213     | 1               | 0                     | 48392.00  | 29439.00  | 14953.00  | 9969.00  | 2663.00  | 1477.00  | 2316.00  | 5464.00  | 3423.00  | 4862.00  | 3265.00  | 1634.00  | 4560.00  | 6887.00  | 1872.00  | 19-24 Traineeships Total Funding     | New          |             | 
    | 10010021 | 19TR20-1213    | 19TR-1213     | 4               | 1                     | 22345.00  | 15336.00  | 5009.00   | 5328.00  | 2577.00  | 1129.00  | 1771.00  | 1811.00  | 1692.00  | 2048.00  | 980.00   | 481.00   | 995.00   | 3155.00  | 378.00   | 19-24 Traineeships                   | New          |             | 
    | 10010021 | 19TR20-1213    | 19TR-1213     | 5               | 1                     | 26047.00  | 14103.00  | 9944.00   | 4641.00  | 86.00    | 348.00   | 545.00   | 3653.00  | 1731.00  | 2814.00  | 2285.00  | 1153.00  | 3565.00  | 3732.00  | 1494.00  | 19-24 Traineeships Learner Support   | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 19TR20-1213    | 1                     | 0                        | 2022-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-1213'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-121' and ContractNumber '19TR20-1213' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-1212' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010021 | 19TR20-1213        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10010021 | 19TR20-1212        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10010021 | 19TR20-1211        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10010021 | ESFA-121           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-1213' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract '19TR20-1213'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 19TR-1213       | 2355800           | Jul-24 | Reconciliation |

    Then wait '10' seconds

#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                          | DeliverableDescription    | 
    | 10010021 | 19TR20-1213    | 1               | 19TR-1213     | 1               | 0                     | 48392.00     | 0             | 0        | 19-24 Traineeships Total Funding         | ?                         |
    | 10010021 | 19TR20-1213    | 1               | 19TR-1213     | 4               | 1                     | 22345.00     | 0             | 0        | 19-24 Traineeships                       | ?                         |
    | 10010021 | 19TR20-1213    | 1               | 19TR-1213     | 5               | 1                     | 26047.00     | 0             | 0        | 19-24 Traineeships Learner Support       | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-1213' agree with the most recent entry for this contract in the ContractManagement feed

    
        # Part 4: Bulk load 'New Amendment' for 24/25. Publish and approve

    # Change the date
    Given the override date is '01/07/2024'

    # Bulk file (New Amendment)
    And   there are no files prefixed '10010021' in the Sharepoint '19TRN2020-2425-Input-Appendices' folder
    And   there are no files prefixed '19TRN2020 AY 2425 16052023092059 v3_Ak021' in the Sharepoint 'Input' folder
    And   there are no files prefixed '19TRN2020 AY 2425 16052023092059 v3_Ak021' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '19TRN2020 AY 2425 16052023092059 v3_Ak021' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '19TRN2020 AY 2425 16052023092059 v3_Ak021' in the Sharepoint 'Reports' folder
    And   spreadsheet '19TRN2020 AY 2425 16052023092059 v3_AK021.xlsx' exists in the Datafiles folder and UKPRN '10010021' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10010021' for FundingType '19TRN2020' and period '2425' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10010021' for FundingType '19TRN2020' and period '2425'

#Check the contents of the Appendices (SoF, TAC, Sch1, Sch2, FA, Sch3ON)
   #Then  the file named '10010021_[ContractNo]_v1.pdf' in Sharepoint location '19TRN2020-2425-Input-Appendices' contains the following lines in order
Then  the file named '10010021_[ContractNo]_v1.pdf' in Sharepoint location '19TRN2020-2425-Input-Appendices' contains the following lines in order
   """
   SUMMARY OF FUNDING
   Organisation Name: 10010021 Co Ltd UKPRN: 10010021
   Master Contract Number: ESFA-121
   Allocation
   1 February 2021 to 31 July 2021 Contract Ref Feb 21 - Mar 21 Apr 21 - Jul 21 Total
   19 to 24 Traineeships - 2020 Procurement 19TR-121 £3,103 £8,484 £11,587
   19 to 24 Traineeships - 2020 Procurement - Learner Support 19TL-121 £2,835 £8,041 £10,876
   Total: £22,463
   Allocation
   1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
   19 to 24 Traineeships - 2020 Procurement 19TR-1211 £29,439 £14,953 £44,392
   of which Learner Support £14,103 £9,944 £24,047
   Total: £44,392
   Allocation
   1 August 2022 to 31 July 2023 Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 Total
   19 to 24 Traineeships - 2020 Procurement 19TR-1212 £31,439 £14,953 £46,392
   of which Learner Support £15,103 £9,944 £25,047
   Total: £46,392

   Allocation
   1 August 2023 to 31 July 2024 Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 Total
   19 to 24 Traineeships - 2020 Procurement 19TR-1213 £33,439 £14,953 £48,392
   of which Learner Support £16,103 £9,944 £26,047
   Total: £48,392
   1 August 2024 to 31 July 2025 Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 Total
   19 to 24 Traineeships - 2020 Procurement [AllocRef_19TR] £65,351 £28,397 £93,748
   of which Learner Support £42,187 £17,495 £59,682
   Total: £93,748

   Total Funding for this contract: £255,387
   Summary of Funding – Page 1
   Agreement Type Contract for Services
   Funding for 19 to 24 Traineeships
   Master Contract Number ESFA-121
   This Contract is made on the date the Contract is digitally signed by the
   Contractor on the Manage Your Education & Skills Funding Service between:
   10010021 Co Ltd THE SECRETARY OF STATE FOR
   345 The Meadway EDUCATION
   Tilehurst DEPARTMENT FOR EDUCATION
   Reading 20 GREAT SMITH STREET
   AND
   Berkshire LONDON
   RG30 4NU SW1P 3BT
   Company No: AA010021
   Hereinafter called Hereinafter called
   the Contractor the Department
   19 to 24 Traineeships
   Version 6 – July 2024 – Page 2
   19 to 24 Traineeships
   Version 6 – July 2024 – Page 77

   SCHEDULE 1: SPECIFICATION & MONITORING
   19 TO 24-YEAR-OLD PROCURED ADULT EDUCATION BUDGET
   TRAINEESHIPS SPECIFICATION
   19 to 24 Traineeships Schedule 1
   Version 5 – July 2024 – Page 1
   19 to 24 Traineeships Schedule 1
   Version 5 – July 2024 – Page 13

   SCHEDULE 2: PAYMENT
   19 to 24 Traineeships Schedule 2
   Version 6 – July 2024 – Page 1
   19 to 24 Traineeships Schedule 2
   Version 6 – July 2024 – Page 2

   SCHEDULE 2
   Funding Agreement – 19 to 24 Traineeships - 2020 Procurement
   Provider: 10010021 Co Ltd UKPRN: 10010021
   Master Contract Number: ESFA-121 Start Date: 01/08/2024 End Date: 31/07/2025
   Contract Ref: [AllocRef_19TR]
   Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
   19 to 24 Traineeships - 2020 Procurement £93,748 £1,726 £4,485 £12,605 £9,985 £5,674 £14,878 £6,895 £9,103 £2,479 £610 £14,167 £11,141
   of which Learner Support £59,682 £353 £3,771 £5,692 £7,880 £5,045 £7,710 £5,555 £6,181 £2,190 £374 £7,933 £6,998
   Total Funding £93,748 £1,726 £4,485 £12,605 £9,985 £5,674 £14,878 £6,895 £9,103 £2,479 £610 £14,167 £11,141

   SCHEDULE 3: CHANGE CONTROL PROCEDURE
   19 to 24 Traineeships Schedule 3
   Version 5 – July 2024 – Page 1
   
   SCHEDULE 4: TUPE
   19 to 24 Traineeships Schedule 4
   Version 5 – July 2024 – Page 1
   19 to 24 Traineeships Schedule 4
   Version 5 – July 2024 – Page 21
   
   SCHEDULE 5: UK GDPR AND DATA PROTECTION
   19 to 24 Traineeships Schedule 5
   Version 5 – July 2024 – Page 1
   19 to 24 Traineeships Schedule 5
   Version 5 – July 2024 – Page 2
   
   SCHEDULE 6: SECURITY & DEPARTMENT POLICIES
   19 to 24 Traineeships Schedule 6
   Version 5 – July 2024 – Page 1
   19 to 24 Traineeships Schedule 6
   Version 5 – July 2024 – Page 8
   
   SCHEDULE 7: EXIT ARRANGEMENTS
   19 to 24 Traineeships Schedule 7
   Version 5 – July 2024 – Page 1
   19 to 24 Traineeships Schedule 7
   Version 5 – July 2024 – Page 5
   
   SCHEDULE 8: SUBCONTRACTING
   19 to 24 Traineeships Schedule 8
   Version 5 – July 2024 – Page 1
   19 to 24 Traineeships Schedule 8
   Version 5 – July 2024 – Page 5
   
   SCHEDULE 9: CONTRACTOR’S RESPONSE/PROPOSALS
   19 to 24 Traineeships Schedule 9
   Version 5 – July 2024 – Page 1

   """




    

    


    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10010021_[ContractNo]_v1.pdf' in '19TRN2020-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK021.pdf'

    # Display Sharepoint filename
    And   message '10010021_[ContractNo]_v1.pdf' is written to the Output window


    # Publish and approve

    # Change the date
    Given the override date is '06/07/2024'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-121' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010021 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10010021 | 19TR20-1213	    | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
	| 10010021 | 19TR20-1212	    | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10010021 | 19TR20-1211        | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10010021 | ESFA-121           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_19TR] | 2355800          | Jul-25 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                       | DeliverableDescription     | 
    | 10010021 | [ContractNo]   | 1               | [AllocRef_19TR] | 1               | 0                     | 93748.00     | 0             | 0        | 19-24 Traineeships Total Funding      | ?                          |
    | 10010021 | [ContractNo]   | 1               | [AllocRef_19TR] | 4               | 1                     | 34066.00     | 0             | 0        | 19-24 Traineeships                    | ?                          |
    | 10010021 | [ContractNo]   | 1               | [AllocRef_19TR] | 5               | 1                     | 59682.00     | 0             | 0        | 19-24 Traineeships Learner Support    | ?                          |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

   
    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   |
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
  
   

    # Part 7: Add 23/24 actuals and check financials in CRM and PaaS

    # Add actuals to the contract for 19TRN2020-2324

    # Change the date
    Given the override date is '04/09/2024'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0010021'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202408 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 2               | 0            | 574.70      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202408 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 3               | 0            | 458.03      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202408 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 6               | 0            | 929.43      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202408 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 7               | 0            | 947.96      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202408 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 8               | 0            | 1203.59     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202408 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 9               | 0            | 674.97      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202408 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 10              | 0            | 530.40      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202409 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 2               | 0            | 452.25      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202409 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 3               | 0            | 581.63      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202409 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 6               | 0            | 430.54      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202409 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 7               | 0            | 407.05      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202409 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 8               | 0            | 1204.67     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202409 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 9               | 0            | 1239.75     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202409 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 10              | 0            | 1272.68     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202410 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 2               | 0            | 993.75      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202410 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 3               | 0            | 417.79      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202410 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 6               | 0            | 993.24      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202410 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 7               | 0            | 1396.04     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202410 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 8               | 0            | 284.63      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202410 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 9               | 0            | 1374.80     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202410 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 10              | 0            | 695.78      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202411 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 2               | 0            | 1130.28     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202411 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 3               | 0            | 1118.83     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202411 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 6               | 0            | 323.91      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202411 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 7               | 0            | 1055.75     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202411 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 8               | 0            | 1240.86     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202411 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 9               | 0            | 1278.10     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202411 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 10              | 0            | 1185.53     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202412 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 2               | 0            | 1015.18     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202412 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 3               | 0            | 292.31      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202412 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 6               | 0            | 1396.98     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202412 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 7               | 0            | 571.63      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202412 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 8               | 0            | 1441.15     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202412 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 9               | 0            | 1074.04     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202412 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 10              | 0            | 685.44      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202501 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 2               | 0            | 617.93      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202501 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 3               | 0            | 379.70      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202501 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 6               | 0            | 1088.52     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202501 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 7               | 0            | 464.05      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202501 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 8               | 0            | 878.34      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202501 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 9               | 0            | 1122.23     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202501 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 10              | 0            | 852.22      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202502 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 2               | 0            | 511.65      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202502 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 3               | 0            | 532.00      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202502 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 6               | 0            | 584.39      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202502 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 7               | 0            | 1258.76     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202502 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 8               | 0            | 725.45      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202502 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 9               | 0            | 902.85      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202502 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 10              | 0            | 497.53      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202503 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 2               | 0            | 1254.74     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202503 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 3               | 0            | 593.77      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202503 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 6               | 0            | 791.63      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202503 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 7               | 0            | 1412.58     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202503 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 8               | 0            | 828.04      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202503 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 9               | 0            | 1481.11     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202503 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 10              | 0            | 870.40      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202504 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 2               | 0            | 766.41      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202504 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 3               | 0            | 558.56      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202504 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 6               | 0            | 475.86      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202504 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 7               | 0            | 889.60      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202504 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 8               | 0            | 1260.86     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202504 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 9               | 0            | 1481.56     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202504 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 10              | 0            | 800.47      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202505 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 2               | 0            | 947.59      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202505 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 3               | 0            | 803.99      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202505 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 6               | 0            | 263.33      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202505 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 7               | 0            | 1284.04     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202505 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 8               | 0            | 572.63      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202505 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 9               | 0            | 264.12      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202505 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 10              | 0            | 939.64      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202506 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 2               | 0            | 1147.53     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202506 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 3               | 0            | 617.47      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202506 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 6               | 0            | 286.17      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202506 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 7               | 0            | 716.34      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202506 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 8               | 0            | 1351.41     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202506 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 9               | 0            | 466.33      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202506 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 10              | 0            | 920.55      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202507 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 2               | 0            | 1082.79     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202507 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 3               | 0            | 1255.81     |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202507 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 6               | 0            | 554.48      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202507 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 7               | 0            | 314.63      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202507 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 8               | 0            | 487.52      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202507 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 9               | 0            | 593.15      |
    | ILR2425        | R01                  | ORG0010021     | CM             | 202507 | 19TRN2020-2425          | [AllocRef_19TR]          | ?          | 10              | 0            | 1450.22     |
                                                                                                                   
    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25  | Jun-25   | Jul-25   |
    | [ContractNo]   | [AllocRef_19TR]    | 1               | 93,748.00 | 1726.00  | 4485.00  | 12605.00 | 9985.00  | 5674.00  | 14878.00 | 6895.00  | 9103.00  | 2479.00  | 610.00   | 14167.00 | 11141.00 | 
    | [ContractNo]   | [AllocRef_19TR]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 4               | 34066.00  | 1373.00  | 714.00   | 6913.00  | 2105.00  | 629.00   | 7168.00  | 1340.00  | 2922.00  | 289.00   | 236.00   | 6234.00  | 4143.00  | 
    | [ContractNo]   | [AllocRef_19TR]    | 5               | 59682.00  | 353.00   | 3771.00  | 5692.00  | 7880.00  | 5045.00  | 7710.00  | 5555.00  | 6181.00  | 2190.00  | 374.00   | 7933.00  | 6998.00  | 
    | [ContractNo]   | [AllocRef_19TR]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25  | Jun-25   | Jul-25   |
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
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25  | Jun-25   | Jul-25   |
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
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25  | Jun-25   | Jul-25   |
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
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-24    | Sep-24    | Oct-24    | Nov-24    | Dec-24    | Jan-25    | Feb-25    | Mar-25    | Apr-25    | May-25    | Jun-25    | Jul-25   | 
    | 10018021 | [ContractNo]   | [AllocRef_19TR]    | 100932                   | 929.43    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10018021 | [ContractNo]   | [AllocRef_19TR]    | 100933                   | 947.96    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10018021 | [ContractNo]   | [AllocRef_19TR]    | 100934                   | 1203.59   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10018021 | [ContractNo]   | [AllocRef_19TR]    | 100935                   | 674.97    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10018021 | [ContractNo]   | [AllocRef_19TR]    | 100936                   | 530.40    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10018021 | [ContractNo]   | [AllocRef_19TR]    | 2355800                  | 574.70    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10018021 | [ContractNo]   | [AllocRef_19TR]    | 2355860                  | 458.03    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 



   



    # Tidy Up
    Given the override date is reset

