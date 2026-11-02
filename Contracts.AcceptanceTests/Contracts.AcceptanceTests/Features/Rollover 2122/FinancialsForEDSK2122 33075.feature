Feature: FinancialsForEDSK2122 33075

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run67
Scenario: A645 Create a new 2122 EDSK contract with three PoA allocations: 16-18TRN2122, ALLB2122 and APPS2122. CDA. Consume actuals. Payment batch. Check CRM PaaS and CM Feed
    
    # 1. Create a 2122 EDSK contract with 16-18TRN2122, ALLB2122 and APPS2122 allocations
    # 2. Publish and approve
    # 3. Check CRM and Feed
    # 4. Run CDA
    # 5. Consume actuals and check financials
    # 6. Run Payment Batch  
    
    Given there are no allocations marked as Under Termination for UKPRN '10017645' 
    And   there are no terminated or closed allocations for UKPRN '10017645' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017645' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017645' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017645' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-645      |
    | ALLB-645      |
    | APPS-645      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-645      |
    | ALLB-645      |
    | APPS-645      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2122      |
    | ALLB2122          |
    | APPS2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-645       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017645'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017645' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017645 Co Ltd' with UKPRN '10017645' and OrgId 'ORG0017645' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017645' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017645 | 117645 | 10017645 Co Ltd | 0              | Active                | Yes           | AA017645      | ?             | 17 Barton Arcade       | Deansgate              | Manchester             | ?                      | ?                      | ?                      | M3 2BW    |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017645 |





    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-645'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-645'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017645 | 10017645 Co Ltd      | ESFA-645             | EDSK-645       | 1                     | 01/08/2021        | 31/07/2022      | 94629.00      |                                       | Conditions of Funding (Grant) (LA)         | 2122   | New          | ORG0017645 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017645 | EDSK-645       | 16TR-645      | 16-18TRN          | 16-18TRN2122            | AY                      | 01/08/2021          | 31/07/2022        | 49134.00        |                                         |            |                                                             | New          |             |
    | 10017645 | EDSK-645       | ALLB-645      | ALLB              | ALLB2122                | AY                      | 01/08/2021          | 31/07/2022        | 24128.00        |                                         |            |                                                             | New          |             |
    | 10017645 | EDSK-645       | APPS-645      | APPS              | APPS2122                | AY                      | 01/08/2021          | 31/07/2022        | 21367.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017645 | EDSK-645       | 16TR-645      | 1               | 0                     | 49134.00  | 37332.00  | 11802.00  | 4073.00  | 4879.00  | 5180.00  | 5260.00  | 1322.00  | 5734.00  | 3599.00  | 7285.00  | 911.00   | 4246.00  | 3377.00  | 3268.00  | Total 16-18 Traineeships Funding                                | New          |             | 
    | 10017645 | EDSK-645       | 16TR-645      | 2               | 1                     | 27491.00  | 19054.00  | 8437.00   | 1148.00  | 3718.00  | 2428.00  | 2596.00  | 358.00   | 2389.00  | 2714.00  | 3703.00  | 738.00   | 2230.00  | 3189.00  | 2280.00  | 16-18 Traineeships Programme Funding                            | New          |             | 
    | 10017645 | EDSK-645       | 16TR-645      | 3               | 1                     | 21643.00  | 18278.00  | 3365.00   | 2925.00  | 1161.00  | 2752.00  | 2664.00  | 964.00   | 3345.00  | 885.00   | 3582.00  | 173.00   | 2016.00  | 188.00   | 988.00   | 16-18 Traineeships Bursary Funding                              | New          |             | 
    | 10017645 | EDSK-645       | ALLB-645      | 1               | 0                     | 24128.00  | 17467.00  | 6661.00   | 2168.00  | 3472.00  | 3260.00  | 1180.00  | 2736.00  | 784.00   | 221.00   | 3646.00  | 775.00   | 1985.00  | 3038.00  | 863.00   | Total Advanced Learner Loans Bursary Funding                    | New          |             | 
    | 10017645 | EDSK-645       | APPS-645      | 1               | 0                     | 21367.00  | 14394.00  | 6973.00   | 1099.00  | 1771.00  | 3456.00  | 3085.00  | 1479.00  | 1613.00  | 229.00   | 1662.00  | 2047.00  | 2625.00  | 1874.00  | 427.00   | Apprenticeships Carry-In Total Funding                          | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-645       | 1                     | 0                        | 2021-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-645'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-645' and actual ContractNumber 'EDSK-645'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-645' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017645 | EDSK-645           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017645 | ESFA-645           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-645' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '372' deliverable period rows in CRM linked to the latest version of contract 'EDSK-645'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 16TR-645        | 2201300          | Jul-22 | Reconciliation |
    | ALLB-645        | 2303800          | Jul-22 | Reconciliation |
    | APPS-645        | 2240100          | Jul-22 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '5' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                 | DeliverableDescription       | 
    | 10017645 | EDSK-645       | 1               | 16TR-645      | 1               | 0                     | 49134.00     | 0             | 0        | Total 16-18 Traineeships Funding                | ?                            |
    | 10017645 | EDSK-645       | 1               | 16TR-645      | 2               | 1                     | 27491.00     | 0             | 0        | 16-18 Traineeships Programme Funding            | ?                            |
    | 10017645 | EDSK-645       | 1               | 16TR-645      | 3               | 1                     | 21643.00     | 0             | 0        | 16-18 Traineeships Bursary Funding              | ?                            |
    | 10017645 | EDSK-645       | 1               | ALLB-645      | 1               | 0                     | 24128.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding    | ?                            |
    | 10017645 | EDSK-645       | 1               | APPS-645      | 1               | 0                     | 21367.00     | 0             | 0        | Apprenticeships Carry-In Total Funding          | ?                            |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-645' agree with the most recent entry for this contract in the ContractManagement feed





#    # CDA
#
#    # Change the date
#    Given the override date is '03/07/2021'
#
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version A645.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | EDSK-645       | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod    | Version               | Suffix |
#    | APPS2122               | Latest Version        | A645   |
#
#    Then  a report named 'CDA Latest Version A645.csv' is created
#
#    # Check the contents of the profile deliverable for APPS2122 on the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | APPS2122                | 10017645 | 10017645 Co Ltd             |               |                             | APPS-645                 | EDSK-645       | ESFA-645                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                          |                                                                 | 8                 | 2021            | 2021/22       |              | 1099         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | APPS2122                | 10017645 | 10017645 Co Ltd             |               |                             | APPS-645                 | EDSK-645       | ESFA-645                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                          |                                                                 | 9                 | 2021            | 2021/22       |              | 1771         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | APPS2122                | 10017645 | 10017645 Co Ltd             |               |                             | APPS-645                 | EDSK-645       | ESFA-645                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                          |                                                                 | 10                | 2021            | 2021/22       |              | 3456         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | APPS2122                | 10017645 | 10017645 Co Ltd             |               |                             | APPS-645                 | EDSK-645       | ESFA-645                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                          |                                                                 | 11                | 2021            | 2021/22       |              | 3085         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | APPS2122                | 10017645 | 10017645 Co Ltd             |               |                             | APPS-645                 | EDSK-645       | ESFA-645                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                          |                                                                 | 12                | 2021            | 2021/22       |              | 1479         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | APPS2122                | 10017645 | 10017645 Co Ltd             |               |                             | APPS-645                 | EDSK-645       | ESFA-645                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                          |                                                                 | 1                 | 2022            | 2021/22       |              | 1613         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | APPS2122                | 10017645 | 10017645 Co Ltd             |               |                             | APPS-645                 | EDSK-645       | ESFA-645                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                          |                                                                 | 2                 | 2022            | 2021/22       |              | 229          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | APPS2122                | 10017645 | 10017645 Co Ltd             |               |                             | APPS-645                 | EDSK-645       | ESFA-645                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                          |                                                                 | 3                 | 2022            | 2021/22       |              | 1662         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | APPS2122                | 10017645 | 10017645 Co Ltd             |               |                             | APPS-645                 | EDSK-645       | ESFA-645                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                          |                                                                 | 4                 | 2022            | 2022/23       |              | 2047         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | APPS2122                | 10017645 | 10017645 Co Ltd             |               |                             | APPS-645                 | EDSK-645       | ESFA-645                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                          |                                                                 | 5                 | 2022            | 2022/23       |              | 2625         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | APPS2122                | 10017645 | 10017645 Co Ltd             |               |                             | APPS-645                 | EDSK-645       | ESFA-645                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                          |                                                                 | 6                 | 2022            | 2022/23       |              | 1874         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | APPS2122                | 10017645 | 10017645 Co Ltd             |               |                             | APPS-645                 | EDSK-645       | ESFA-645                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Apprenticeships Carry-In Total Funding                          |                                                                 | 7                 | 2022            | 2022/23       |              | 427          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |





    # Add actuals to the contract

    # Change the date
    Given the override date is '04/10/2021'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017645'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2021
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | 16-18TRN2122            | 16TR-645                 | ?          | 2               | 0            | 2781.20     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | 16-18TRN2122            | 16TR-645                 | ?          | 3               | 0            | 1791.16     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | 16-18TRN2122            | 16TR-645                 | ?          | 2               | 0            | 2249.11     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | 16-18TRN2122            | 16TR-645                 | ?          | 3               | 0            | 958.62      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | 16-18TRN2122            | 16TR-645                 | ?          | 2               | 0            | 2189.38     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | 16-18TRN2122            | 16TR-645                 | ?          | 3               | 0            | 2341.11     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | 16-18TRN2122            | 16TR-645                 | ?          | 2               | 0            | 2588.35     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | 16-18TRN2122            | 16TR-645                 | ?          | 3               | 0            | 1286.19     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | 16-18TRN2122            | 16TR-645                 | ?          | 2               | 0            | 2233.36     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | 16-18TRN2122            | 16TR-645                 | ?          | 3               | 0            | 1941.64     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | 16-18TRN2122            | 16TR-645                 | ?          | 2               | 0            | 2901.81     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | 16-18TRN2122            | 16TR-645                 | ?          | 3               | 0            | 1313.14     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | 16-18TRN2122            | 16TR-645                 | ?          | 2               | 0            | 2062.95     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | 16-18TRN2122            | 16TR-645                 | ?          | 3               | 0            | 1033.98     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | 16-18TRN2122            | 16TR-645                 | ?          | 2               | 0            | 1443.90     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | 16-18TRN2122            | 16TR-645                 | ?          | 3               | 0            | 791.89      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | 16-18TRN2122            | 16TR-645                 | ?          | 2               | 0            | 874.07      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | 16-18TRN2122            | 16TR-645                 | ?          | 3               | 0            | 2170.97     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | 16-18TRN2122            | 16TR-645                 | ?          | 2               | 0            | 1384.33     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | 16-18TRN2122            | 16TR-645                 | ?          | 3               | 0            | 2728.98     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | 16-18TRN2122            | 16TR-645                 | ?          | 2               | 0            | 1600.23     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | 16-18TRN2122            | 16TR-645                 | ?          | 3               | 0            | 1192.75     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | 16-18TRN2122            | 16TR-645                 | ?          | 2               | 0            | 1280.72     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | 16-18TRN2122            | 16TR-645                 | ?          | 3               | 0            | 1467.13     |
    #
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | ALLB2122                | ALLB-645                 | ?          | 2               | 0            | 1077.45     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | ALLB2122                | ALLB-645                 | ?          | 3               | 0            | 862.81      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | ALLB2122                | ALLB-645                 | ?          | 4               | 0            | 1288.04     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | ALLB2122                | ALLB-645                 | ?          | 2               | 0            | 2318.44     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | ALLB2122                | ALLB-645                 | ?          | 3               | 0            | 1758.95     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | ALLB2122                | ALLB-645                 | ?          | 4               | 0            | 1092.34     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | ALLB2122                | ALLB-645                 | ?          | 2               | 0            | 1577.37     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | ALLB2122                | ALLB-645                 | ?          | 3               | 0            | 1516.67     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | ALLB2122                | ALLB-645                 | ?          | 4               | 0            | 2165.62     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | ALLB2122                | ALLB-645                 | ?          | 2               | 0            | 1668.25     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | ALLB2122                | ALLB-645                 | ?          | 3               | 0            | 2261.96     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | ALLB2122                | ALLB-645                 | ?          | 4               | 0            | 2426.00     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | ALLB2122                | ALLB-645                 | ?          | 2               | 0            | 748.37      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | ALLB2122                | ALLB-645                 | ?          | 3               | 0            | 187.74      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | ALLB2122                | ALLB-645                 | ?          | 4               | 0            | 500.15      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | ALLB2122                | ALLB-645                 | ?          | 2               | 0            | 521.37      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | ALLB2122                | ALLB-645                 | ?          | 3               | 0            | 2232.38     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | ALLB2122                | ALLB-645                 | ?          | 4               | 0            | 1825.39     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | ALLB2122                | ALLB-645                 | ?          | 2               | 0            | 1918.28     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | ALLB2122                | ALLB-645                 | ?          | 3               | 0            | 1873.83     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | ALLB2122                | ALLB-645                 | ?          | 4               | 0            | 1154.48     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | ALLB2122                | ALLB-645                 | ?          | 2               | 0            | 1520.58     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | ALLB2122                | ALLB-645                 | ?          | 3               | 0            | 2048.12     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | ALLB2122                | ALLB-645                 | ?          | 4               | 0            | 2038.02     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | ALLB2122                | ALLB-645                 | ?          | 2               | 0            | 2000.79     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | ALLB2122                | ALLB-645                 | ?          | 3               | 0            | 365.08      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | ALLB2122                | ALLB-645                 | ?          | 4               | 0            | 1964.43     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | ALLB2122                | ALLB-645                 | ?          | 2               | 0            | 1539.67     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | ALLB2122                | ALLB-645                 | ?          | 3               | 0            | 1544.08     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | ALLB2122                | ALLB-645                 | ?          | 4               | 0            | 990.47      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | ALLB2122                | ALLB-645                 | ?          | 2               | 0            | 522.44      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | ALLB2122                | ALLB-645                 | ?          | 3               | 0            | 363.10      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | ALLB2122                | ALLB-645                 | ?          | 4               | 0            | 581.39      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | ALLB2122                | ALLB-645                 | ?          | 2               | 0            | 1155.69     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | ALLB2122                | ALLB-645                 | ?          | 3               | 0            | 1595.34     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | ALLB2122                | ALLB-645                 | ?          | 4               | 0            | 238.74      |
    #
    | APPS           | APPS53               | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 8               | 0            | 1133.35     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 9               | 0            | 1403.47     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 10              | 0            | 223.54      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 22              | 0            | 234.52      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 23              | 0            | 900.47      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 24              | 0            | 1268.46     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 8               | 0            | 679.49      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 9               | 0            | 463.88      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 10              | 0            | 1370.74     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 22              | 0            | 932.61      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 23              | 0            | 212.19      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 24              | 0            | 1040.35     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 8               | 0            | 1067.68     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 9               | 0            | 712.84      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 10              | 0            | 408.35      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 22              | 0            | 791.29      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 23              | 0            | 1146.64     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 24              | 0            | 1430.60     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 8               | 0            | 1341.19     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 9               | 0            | 284.51      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 10              | 0            | 341.69      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 22              | 0            | 1371.15     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 23              | 0            | 892.34      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 24              | 0            | 1062.66     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 8               | 0            | 1462.52     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 9               | 0            | 593.03      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 10              | 0            | 1423.71     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 22              | 0            | 1027.49     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 23              | 0            | 1441.20     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 24              | 0            | 1387.40     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 8               | 0            | 1399.34     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 9               | 0            | 1374.38     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 10              | 0            | 1329.20     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 22              | 0            | 687.39      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 23              | 0            | 1357.31     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 24              | 0            | 1276.59     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 8               | 0            | 1244.20     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 9               | 0            | 1027.53     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 10              | 0            | 431.58      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 22              | 0            | 1319.72     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 23              | 0            | 1266.92     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 24              | 0            | 853.05      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 8               | 0            | 223.92      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 9               | 0            | 286.01      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 10              | 0            | 1288.10     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 22              | 0            | 579.32      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 23              | 0            | 625.71      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 24              | 0            | 688.80      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 8               | 0            | 1205.26     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 9               | 0            | 601.21      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 10              | 0            | 189.86      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 22              | 0            | 656.83      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 23              | 0            | 1469.68     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 24              | 0            | 1052.46     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 8               | 0            | 1052.71     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 9               | 0            | 168.65      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 10              | 0            | 1183.18     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 22              | 0            | 515.00      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 23              | 0            | 205.82      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 24              | 0            | 637.00      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 8               | 0            | 745.09      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 9               | 0            | 678.46      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 10              | 0            | 717.95      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 22              | 0            | 643.16      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 23              | 0            | 649.03      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 24              | 0            | 149.39      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 8               | 0            | 906.84      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 9               | 0            | 421.34      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 10              | 0            | 629.86      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 22              | 0            | 1210.77     |
    | APPS           | APPS53               | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 23              | 0            | 661.17      |
    | APPS           | APPS53               | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 24              | 0            | 1093.07     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 2               | 0            | 560.51      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 3               | 0            | 131.25      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 4               | 0            | 1112.37     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 5               | 0            | 1451.56     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 6               | 0            | 298.89      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 7               | 0            | 224.65      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 11              | 0            | 456.50      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 12              | 0            | 696.04      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 13              | 0            | 1284.73     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 14              | 0            | 1459.29     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 15              | 0            | 1326.20     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 16              | 0            | 116.20      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 17              | 0            | 1486.47     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 18              | 0            | 217.30      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 19              | 0            | 312.44      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 20              | 0            | 926.56      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202108 | APPS2122                | APPS-645                 | ?          | 21              | 0            | 498.13      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 2               | 0            | 604.12      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 3               | 0            | 236.52      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 4               | 0            | 1050.76     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 5               | 0            | 786.23      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 6               | 0            | 907.76      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 7               | 0            | 371.85      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 11              | 0            | 656.03      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 12              | 0            | 886.58      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 13              | 0            | 1408.23     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 14              | 0            | 1015.90     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 15              | 0            | 1037.53     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 16              | 0            | 151.21      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 17              | 0            | 1336.93     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 18              | 0            | 1412.00     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 19              | 0            | 1052.71     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 20              | 0            | 1045.27     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202109 | APPS2122                | APPS-645                 | ?          | 21              | 0            | 385.96      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 2               | 0            | 821.26      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 3               | 0            | 905.72      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 4               | 0            | 593.82      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 5               | 0            | 567.60      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 6               | 0            | 1344.48     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 7               | 0            | 681.74      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 11              | 0            | 378.80      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 12              | 0            | 1423.57     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 13              | 0            | 1293.92     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 14              | 0            | 631.39      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 15              | 0            | 1485.83     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 16              | 0            | 1184.46     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 17              | 0            | 115.29      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 18              | 0            | 405.12      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 19              | 0            | 1201.13     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 20              | 0            | 1079.13     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202110 | APPS2122                | APPS-645                 | ?          | 21              | 0            | 859.56      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 2               | 0            | 1437.52     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 3               | 0            | 1258.39     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 4               | 0            | 194.03      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 5               | 0            | 404.82      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 6               | 0            | 1281.75     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 7               | 0            | 1035.61     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 11              | 0            | 482.63      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 12              | 0            | 1028.23     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 13              | 0            | 893.90      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 14              | 0            | 902.02      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 15              | 0            | 924.75      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 16              | 0            | 1327.81     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 17              | 0            | 1067.38     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 18              | 0            | 314.93      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 19              | 0            | 435.94      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 20              | 0            | 1494.38     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202111 | APPS2122                | APPS-645                 | ?          | 21              | 0            | 617.25      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 2               | 0            | 466.63      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 3               | 0            | 1126.90     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 4               | 0            | 533.37      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 5               | 0            | 514.65      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 6               | 0            | 281.21      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 7               | 0            | 712.79      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 11              | 0            | 836.79      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 12              | 0            | 1371.15     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 13              | 0            | 1161.51     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 14              | 0            | 672.65      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 15              | 0            | 505.01      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 16              | 0            | 1273.09     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 17              | 0            | 885.91      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 18              | 0            | 758.77      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 19              | 0            | 1418.68     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 20              | 0            | 966.02      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202112 | APPS2122                | APPS-645                 | ?          | 21              | 0            | 455.29      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 2               | 0            | 856.04      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 3               | 0            | 860.59      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 4               | 0            | 989.05      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 5               | 0            | 1489.86     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 6               | 0            | 391.36      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 7               | 0            | 287.57      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 11              | 0            | 559.21      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 12              | 0            | 1176.02     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 13              | 0            | 893.00      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 14              | 0            | 452.36      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 15              | 0            | 1005.83     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 16              | 0            | 163.26      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 17              | 0            | 499.94      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 18              | 0            | 1075.44     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 19              | 0            | 1154.92     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 20              | 0            | 1011.08     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202201 | APPS2122                | APPS-645                 | ?          | 21              | 0            | 1421.31     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 2               | 0            | 866.95      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 3               | 0            | 1463.54     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 4               | 0            | 1385.74     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 5               | 0            | 945.72      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 6               | 0            | 698.56      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 7               | 0            | 104.20      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 11              | 0            | 207.25      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 12              | 0            | 1000.64     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 13              | 0            | 125.33      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 14              | 0            | 599.20      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 15              | 0            | 1346.23     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 16              | 0            | 1261.80     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 17              | 0            | 1257.63     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 18              | 0            | 205.02      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 19              | 0            | 870.71      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 20              | 0            | 1012.54     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202202 | APPS2122                | APPS-645                 | ?          | 21              | 0            | 382.91      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 2               | 0            | 1046.70     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 3               | 0            | 1243.08     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 4               | 0            | 1353.18     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 5               | 0            | 937.70      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 6               | 0            | 602.20      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 7               | 0            | 666.95      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 11              | 0            | 760.42      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 12              | 0            | 229.40      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 13              | 0            | 736.80      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 14              | 0            | 984.01      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 15              | 0            | 796.70      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 16              | 0            | 308.21      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 17              | 0            | 287.44      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 18              | 0            | 520.90      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 19              | 0            | 969.57      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 20              | 0            | 988.95      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202203 | APPS2122                | APPS-645                 | ?          | 21              | 0            | 597.14      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 2               | 0            | 1286.11     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 3               | 0            | 941.09      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 4               | 0            | 222.97      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 5               | 0            | 199.31      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 6               | 0            | 1116.83     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 7               | 0            | 287.17      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 11              | 0            | 420.03      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 12              | 0            | 1052.23     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 13              | 0            | 175.83      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 14              | 0            | 1406.97     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 15              | 0            | 1120.17     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 16              | 0            | 1123.28     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 17              | 0            | 798.38      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 18              | 0            | 182.26      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 19              | 0            | 415.53      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 20              | 0            | 1323.45     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202204 | APPS2122                | APPS-645                 | ?          | 21              | 0            | 689.03      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 2               | 0            | 786.81      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 3               | 0            | 922.34      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 4               | 0            | 191.63      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 5               | 0            | 468.58      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 6               | 0            | 1445.76     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 7               | 0            | 702.69      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 11              | 0            | 129.05      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 12              | 0            | 370.91      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 13              | 0            | 144.96      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 14              | 0            | 1336.45     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 15              | 0            | 1383.61     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 16              | 0            | 1489.86     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 17              | 0            | 690.44      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 18              | 0            | 943.13      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 19              | 0            | 584.21      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 20              | 0            | 376.07      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202205 | APPS2122                | APPS-645                 | ?          | 21              | 0            | 917.67      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 2               | 0            | 153.78      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 3               | 0            | 825.25      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 4               | 0            | 783.96      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 5               | 0            | 851.00      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 6               | 0            | 1432.85     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 7               | 0            | 1100.90     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 11              | 0            | 568.47      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 12              | 0            | 1413.03     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 13              | 0            | 350.03      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 14              | 0            | 1489.53     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 15              | 0            | 1332.06     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 16              | 0            | 683.97      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 17              | 0            | 1002.21     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 18              | 0            | 288.02      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 19              | 0            | 221.45      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 20              | 0            | 311.02      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202206 | APPS2122                | APPS-645                 | ?          | 21              | 0            | 985.26      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 2               | 0            | 1296.25     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 3               | 0            | 274.66      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 4               | 0            | 1067.76     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 5               | 0            | 515.96      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 6               | 0            | 451.34      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 7               | 0            | 117.73      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 11              | 0            | 163.50      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 12              | 0            | 703.89      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 13              | 0            | 812.13      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 14              | 0            | 811.69      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 15              | 0            | 102.67      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 16              | 0            | 773.24      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 17              | 0            | 1293.50     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 18              | 0            | 449.39      |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 19              | 0            | 1094.20     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 20              | 0            | 1234.74     |
    | ILR2122        | R02                  | ORG0017645     | CM             | 202207 | APPS2122                | APPS-645                 | ?          | 21              | 0            | 1150.74     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-645       | 16TR-645           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | 16TR-645           | 2               | 5030.31   | 2781.20  | 2249.11  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | 16TR-645           | 3               | 2749.78   | 1791.16  | 958.62   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | EDSK-645       | ALLB-645           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | ALLB-645           | 2               | 3395.89   | 1077.45  | 2318.44  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | ALLB-645           | 3               | 2621.76   | 862.81   | 1758.95  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | ALLB-645           | 4               | 2380.38   | 1288.04  | 1092.34  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-645       | 16TR-645           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | 16TR-645           | 2               | 5030.31   | 0.00     | 5030.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | 16TR-645           | 3               | 2749.78   | 0.00     | 2749.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-645       | ALLB-645           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | ALLB-645           | 2               | 3395.89   | 0.00     | 3395.89  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | ALLB-645           | 3               | 2621.76   | 0.00     | 2621.76  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | ALLB-645           | 4               | 2380.38   | 0.00     | 2380.38  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-645       | 16TR-645           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | 16TR-645           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | 16TR-645           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-645       | ALLB-645           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | ALLB-645           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | ALLB-645           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | ALLB-645           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-645       | 16TR-645           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | 16TR-645           | 2               | 5030.31   | 0.00     | 5030.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | 16TR-645           | 3               | 2749.78   | 0.00     | 2749.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-645       | ALLB-645           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | ALLB-645           | 2               | 3395.89   | 0.00     | 3395.89  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | ALLB-645           | 3               | 2621.76   | 0.00     | 2621.76  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | ALLB-645           | 4               | 2380.38   | 0.00     | 2380.38  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes any held actuals
    When  MonthEnd processing has completed and the processing of held data is triggered

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-645       | APPS-645           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 2               | 1164.63   | 560.51   | 604.12   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 3               | 367.77    | 131.25   | 236.52   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 4               | 2163.13   | 1112.37  | 1050.76  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 5               | 2237.79   | 1451.56  | 786.23   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 6               | 1206.65   | 298.89   | 907.76   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 7               | 596.50    | 224.65   | 371.85   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 8               | 1812.84   | 1133.35  | 679.49   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 9               | 1867.35   | 1403.47  | 463.88   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 10              | 1594.28   | 223.54   | 1370.74  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 11              | 1112.53   | 456.50   | 656.03   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 12              | 1582.62   | 696.04   | 886.58   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 13              | 2692.96   | 1284.73  | 1408.23  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 14              | 2475.19   | 1459.29  | 1015.90  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 15              | 2363.73   | 1326.20  | 1037.53  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 16              | 267.41    | 116.20   | 151.21   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 17              | 2823.40   | 1486.47  | 1336.93  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 18              | 1629.30   | 217.30   | 1412.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 19              | 1365.15   | 312.44   | 1052.71  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 20              | 1971.83   | 926.56   | 1045.27  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 21              | 884.09    | 498.13   | 385.96   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 22              | 1167.13   | 234.52   | 932.61   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 23              | 1112.66   | 900.47   | 212.19   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-645       | APPS-645           | 24              | 2308.81   | 1268.46  | 1040.35  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-645       | APPS-645           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 2               | 1164.63   | 0.00     | 1164.63  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 3               | 367.77    | 0.00     | 367.77   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 4               | 2163.13   | 0.00     | 2163.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 5               | 2237.79   | 0.00     | 2237.79  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 6               | 1206.65   | 0.00     | 1206.65  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 7               | 596.50    | 0.00     | 596.50   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 8               | 1812.84   | 0.00     | 1812.84  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 9               | 1867.35   | 0.00     | 1867.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 10              | 1594.28   | 0.00     | 1594.28  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 11              | 1112.53   | 0.00     | 1112.53  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 12              | 1582.62   | 0.00     | 1582.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 13              | 2692.96   | 0.00     | 2692.96  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 14              | 2475.19   | 0.00     | 2475.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 15              | 2363.73   | 0.00     | 2363.73  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 16              | 267.41    | 0.00     | 267.41   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 17              | 2823.40   | 0.00     | 2823.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 18              | 1629.30   | 0.00     | 1629.30  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 19              | 1365.15   | 0.00     | 1365.15  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 20              | 1971.83   | 0.00     | 1971.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 21              | 884.09    | 0.00     | 884.09   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 22              | 1167.13   | 0.00     | 1167.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 23              | 1112.66   | 0.00     | 1112.66  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 24              | 2308.81   | 0.00     | 2308.81  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-645       | APPS-645           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 2               | -875.73   | 0.00     | -875.73  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 3               | -276.54   | 0.00     | -276.54  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 4               | -1626.54  | 0.00     | -1626.54 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 5               | -1682.68  | 0.00     | -1682.68 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 6               | -907.33   | 0.00     | -907.33  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 8               | -1363.14  | 0.00     | -1363.14 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 9               | -1404.13  | 0.00     | -1404.13 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 11              | -836.55   | 0.00     | -836.55  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 12              | -1190.03  | 0.00     | -1190.03 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 13              | -2024.94  | 0.00     | -2024.94 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 14              | -1861.19  | 0.00     | -1861.19 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 15              | -1777.38  | 0.00     | -1777.38 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 16              | -201.08   | 0.00     | -201.08  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 17              | -2123.02  | 0.00     | -2123.02 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 19              | -1026.51  | 0.00     | -1026.51 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 20              | -1482.69  | 0.00     | -1482.69 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 21              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 22              | -877.61   | 0.00     | -877.61  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 23              | -836.65   | 0.00     | -836.65  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 24              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-645       | APPS-645           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 2               | 288.90    | 0.00     | 288.90   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 3               | 91.23     | 0.00     | 91.23    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 4               | 536.59    | 0.00     | 536.59   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 5               | 555.11    | 0.00     | 555.11   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 6               | 299.32    | 0.00     | 299.32   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 7               | 596.50    | 0.00     | 596.50   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 8               | 449.70    | 0.00     | 449.70   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 9               | 463.22    | 0.00     | 463.22   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 10              | 1594.28   | 0.00     | 1594.28  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 11              | 275.98    | 0.00     | 275.98   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 12              | 392.59    | 0.00     | 392.59   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 13              | 668.02    | 0.00     | 668.02   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 14              | 614.00    | 0.00     | 614.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 15              | 586.35    | 0.00     | 586.35   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 16              | 66.33     | 0.00     | 66.33    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 17              | 700.38    | 0.00     | 700.38   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 18              | 1629.30   | 0.00     | 1629.30  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 19              | 338.64    | 0.00     | 338.64   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 20              | 489.14    | 0.00     | 489.14   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 21              | 884.09    | 0.00     | 884.09   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 22              | 289.52    | 0.00     | 289.52   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 23              | 276.01    | 0.00     | 276.01   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-645       | APPS-645           | 24              | 2308.81   | 0.00     | 2308.81  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017645 | ORG0017645 | 16TR-645          | 2201300         | 16-18TRN2122               | 202109               | RECONCILIATION  | CM             | False       | 5030.31         |
    | 10017645 | ORG0017645 | 16TR-645          | 2201350         | 16-18TRN2122               | 202109               | RECONCILIATION  | CM             | False       | 2749.78         |
    #
    | 10017645 | ORG0017645 | ALLB-645          | 2303800         | ALLB2122                   | 202109               | RECONCILIATION  | CM             | False       | 8398.03         |
    #
    | 10017645 | ORG0017645 | APPS-645          | 2240100         | APPS2122                   | 202109               | RECONCILIATION  | CM             | False       | 7139.97         |
    | 10017645 | ORG0017645 | APPS-645          | 2240150         | APPS2122                   | 202109               | RECONCILIATION  | CM             | False       | 3680.19         |
    | 10017645 | ORG0017645 | APPS-645          | 2240160         | APPS2122                   | 202109               | RECONCILIATION  | CM             | False       | 1594.28         |
    | 10017645 | ORG0017645 | APPS-645          | 2240170         | APPS2122                   | 202109               | RECONCILIATION  | CM             | False       | 596.50          |
    | 10017645 | ORG0017645 | APPS-645          | 2340100         | APPS2122                   | 202109               | RECONCILIATION  | CM             | False       | 16654.82        |
    | 10017645 | ORG0017645 | APPS-645          | 2340150         | APPS2122                   | 202109               | RECONCILIATION  | CM             | False       | 2279.79         |
    | 10017645 | ORG0017645 | APPS-645          | 2340160         | APPS2122                   | 202109               | RECONCILIATION  | CM             | False       | 2308.81         |
    | 10017645 | ORG0017645 | APPS-645          | 2340170         | APPS2122                   | 202109               | RECONCILIATION  | CM             | False       | 2513.39         |

    # Check the CAPPING subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017645 | ORG0017645 | APPS-645          | 2240100         | APPS2122                   | 202109               | CAPPING         | CM             | False       | -5368.82        |
    | 10017645 | ORG0017645 | APPS-645          | 2240150         | APPS2122                   | 202109               | CAPPING         | CM             | False       | -2767.27        |
    | 10017645 | ORG0017645 | APPS-645          | 2340100         | APPS2122                   | 202109               | CAPPING         | CM             | False       | -12523.39       |
    | 10017645 | ORG0017645 | APPS-645          | 2340150         | APPS2122                   | 202109               | CAPPING         | CM             | False       | -1714.26        |





    # Payment Batch for 16-18TRN2122

    # Change the date
    Given the override date is '08/10/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '16-18TRN2122' AccountingPaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | 16TR-645                 | 202109 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 16-18TRN2122               | 202109               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 16-18TRN2122               | 202109               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18TRN2122' PaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A645_16-18TRN.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18TRN2122' PaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | 16TR                   | 2021          | 06             | 08          | ?       | 16TR-645      | 5030.31         | RECONCILIATION   | 16-18Traineeships                  | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017645 | 2201300    |
    | 16TR                   | 2021          | 06             | 08          | ?       | 16TR-645      | 2749.78         | RECONCILIATION   | 16-18TraineeshipBurs               | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017645 | 2201350    |





    # Payment Batch for ALLB2122


    # Change the date
    Given the override date is '08/10/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ALLB2122' AccountingPaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | ALLB-645                 | 202109 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ALLB2122                   | 202109               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ALLB2122                   | 202109               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLB2122' PaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A645_ALLB.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLB2122' PaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | LBT                    | 2021          | 06             | 08          | ?       | ALLB-645      | 8398.03         | RECONCILIATION   | Adv LL Bursary                     | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017645 | 2303800    |





    # Payment Batch for APPS2122


    # Change the date
    Given the override date is '08/10/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'APPS2122' AccountingPaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | APPS-645                 | 202109 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | APPS2122                   | 202109               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | APPS2122                   | 202109               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'APPS2122' PaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A645_APPS.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'APPS2122' PaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | APPS                   | 2021          | 06             | 08          | ?       | APPS-645      | -5368.82        | CAPPING          | 16-18 Apps                         | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017645 | 2240100    |
    | APPS                   | 2021          | 06             | 08          | ?       | APPS-645      | -2767.27        | CAPPING          | 16-18NonLevy Apps                  | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017645 | 2240150    |
    | APPS                   | 2021          | 06             | 08          | ?       | APPS-645      | -12523.39       | CAPPING          | 19+ Apps                           | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017645 | 2340100    |
    | APPS                   | 2021          | 06             | 08          | ?       | APPS-645      | -1714.26        | CAPPING          | 19+NonLevy Apps                    | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017645 | 2340150    |
    #
    | APPS                   | 2021          | 06             | 08          | ?       | APPS-645      | 7139.97         | RECONCILIATION   | 16-18 Apps                         | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017645 | 2240100    |
    | APPS                   | 2021          | 06             | 08          | ?       | APPS-645      | 3680.19         | RECONCILIATION   | 16-18NonLevy Apps                  | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017645 | 2240150    |
    | APPS                   | 2021          | 06             | 08          | ?       | APPS-645      | 1594.28         | RECONCILIATION   | 16-18NonLevy AppsEmp               | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017645 | 2240160    |
    | APPS                   | 2021          | 06             | 08          | ?       | APPS-645      | 596.50          | RECONCILIATION   | 16-18 Apps Tblz Emp                | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017645 | 2240170    |
    | APPS                   | 2021          | 06             | 08          | ?       | APPS-645      | 16654.82        | RECONCILIATION   | 19+ Apps                           | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017645 | 2340100    |
    | APPS                   | 2021          | 06             | 08          | ?       | APPS-645      | 2279.79         | RECONCILIATION   | 19+NonLevy Apps                    | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017645 | 2340150    |
    | APPS                   | 2021          | 06             | 08          | ?       | APPS-645      | 2308.81         | RECONCILIATION   | 19+NonLevy AppsEmp                 | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017645 | 2340160    |
    | APPS                   | 2021          | 06             | 08          | ?       | APPS-645      | 2513.39         | RECONCILIATION   | 19+ Apps Tblz Emp                  | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017645 | 2340170    |


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run67
Scenario: A646 Create a new 2122 EDSK contract with one Contracting, two Delivery Orgs and three PoP allocations: AEBC-19TRN2122, AEBC-NSF2122 and ALLBC2122. Payment batch. Check CRM PaaS and CM Feed
    Given there is no Contract, Task or Workflow data for UKPRN '10017646' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017646' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017646' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECT-646      |
    | ALLC-646      |
    | NSFC-646      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECT-646      |
    | ALLC-646      |
    | NSFC-646      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-19TRN2122    |
    | AEBC-NSF2122      |
    | ALLBC2122         |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-646       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017646'



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017646' 
    And   there is no Organisation data for UKPRN '10040263' 
    And   there is no Organisation data for UKPRN '10040271' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017646 Co Ltd' with UKPRN '10017646' and OrgId 'ORG0017646' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017646 | 117646 | 10017646 Co Ltd | 0              | Active                | Yes           | AA017646      | ?             | 1 Bell Street          | ?                      | ?                      | ?                      | Maidenhead             | Berkshire              | SL6 1BU   |
    | 10040263 | 140263 | 10040263 Co Ltd | 0              | Active                | Yes           | AA040263      | ?             | 2 Bell Street          | ?                      | ?                      | ?                      | Maidenhead             | Berkshire              | SL6 1BU   |
    | 10040271 | 140271 | 10040271 Co Ltd | 0              | Active                | Yes           | AA040271      | ?             | 3 Bell Street          | ?                      | ?                      | ?                      | Maidenhead             | Berkshire              | SL6 1BU   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017646 |
    | 10040263 |
    | 10040271 |




    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-646'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017646 | 10017646 Co Ltd      | ESFA-646             | EDSK-646       | 1                     | 01/08/2021        | 31/07/2022      | 115851.00     |                                       | Conditions of Funding (Grant) (NMSS)       | 2122   | New          | ORG0017646 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017646 | EDSK-646       | AECT-6461     | AEBC-19TRN        | AEBC-19TRN2122          | AY                      | 01/08/2021          | 31/07/2022        | 30774.00        |                                         |            |                                                             | New          | 10017646    |
    | 10017646 | EDSK-646       | ALLC-6461     | ALLBC             | ALLBC2122               | AY                      | 01/08/2021          | 31/07/2022        | 20630.00        |                                         |            |                                                             | New          | 10017646    |
    | 10017646 | EDSK-646       | NSFC-6461     | AEBC-NSF          | AEBC-NSF2122            | AY                      | 01/08/2021          | 31/07/2022        | 27545.00        |                                         |            |                                                             | New          | 10017646    |
    #
    | 10017646 | EDSK-646       | AECT-6462     | AEBC-19TRN        | AEBC-19TRN2122          | AY                      | 01/08/2021          | 31/07/2022        | 24093.00        |                                         |            |                                                             | New          | 10040263    |
    | 10017646 | EDSK-646       | NSFC-6462     | AEBC-NSF          | AEBC-NSF2122            | AY                      | 01/08/2021          | 31/07/2022        | 21314.00        |                                         |            |                                                             | New          | 10040263    |
    #
    | 10017646 | EDSK-646       | ALLC-6463     | ALLBC             | ALLBC2122               | AY                      | 01/08/2021          | 31/07/2022        | 19040.00        |                                         |            |                                                             | New          | 10040271    |
 
    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017646 | EDSK-646       | AECT-6461     | 1               | 0                     | 30774.00  | 19040.00  | 11734.00  | 494.00   | 1230.00  | 3705.00  | 3681.00  | 2772.00  | 1798.00  | 3735.00  | 1625.00  | 2519.00  | 3538.00  | 2218.00  | 3459.00  | 19-24 Traineeships Total Funding                                | New          | 10017646    | 
    | 10017646 | EDSK-646       | ALLC-6461     | 1               | 0                     | 20630.00  | 13184.00  | 7446.00   | 2807.00  | 3098.00  | 1240.00  | 395.00   | 213.00   | 3479.00  | 1082.00  | 870.00   | 2490.00  | 346.00   | 2095.00  | 2515.00  | Total Advanced Learner Loans Bursary Funding                    | New          | 10017646    | 
    | 10017646 | EDSK-646       | NSFC-6461     | 1               | 0                     | 27545.00  | 18449.00  | 9096.00   | 2469.00  | 3299.00  | 3527.00  | 878.00   | 2405.00  | 2508.00  | 3181.00  | 182.00   | 3512.00  | 1906.00  | 3022.00  | 656.00   | National Skills Fund Total Funding                              | New          | 10017646    | 
    | 10017646 | EDSK-646       | NSFC-6461     | 2               | 1                     | 27545.00  | 18449.00  | 9096.00   | 2469.00  | 3299.00  | 3527.00  | 878.00   | 2405.00  | 2508.00  | 3181.00  | 182.00   | 3512.00  | 1906.00  | 3022.00  | 656.00   | Level 3 Offer for 24 year olds and over                         | New          | 10017646    |  
    #                                                                                                                                                                                                                                                                                                                                                
    | 10017646 | EDSK-646       | AECT-6462     | 1               | 0                     | 24093.00  | 13930.00  | 10163.00  | 2560.00  | 1493.00  | 994.00   | 1508.00  | 3667.00  | 890.00   | 836.00   | 1982.00  | 2244.00  | 2442.00  | 1849.00  | 3628.00  | 19-24 Traineeships Total Funding                                | New          | 10040263    | 
    | 10017646 | EDSK-646       | NSFC-6462     | 1               | 0                     | 21314.00  | 15200.00  | 6114.00   | 1161.00  | 188.00   | 2125.00  | 3716.00  | 3627.00  | 1927.00  | 608.00   | 1848.00  | 845.00   | 1137.00  | 2980.00  | 1152.00  | National Skills Fund Total Funding                              | New          | 10040263    | 
    | 10017646 | EDSK-646       | NSFC-6462     | 2               | 1                     | 21314.00  | 15200.00  | 6114.00   | 1161.00  | 188.00   | 2125.00  | 3716.00  | 3627.00  | 1927.00  | 608.00   | 1848.00  | 845.00   | 1137.00  | 2980.00  | 1152.00  | Level 3 Offer for 24 year olds and over                         | New          | 10040263    | 
    #
    | 10017646 | EDSK-646       | ALLC-6463     | 1               | 0                     | 19040.00  | 11218.00  | 7822.00   | 1589.00  | 1974.00  | 2552.00  | 1801.00  | 354.00   | 996.00   | 1035.00  | 917.00   | 1272.00  | 2923.00  | 3407.00  | 220.00   | Total Advanced Learner Loans Bursary Funding                    | New          | 10040271    | 
 
    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-646'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-646' and actual ContractNumber 'EDSK-646'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-646' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017646 | EDSK-646           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017646 | ESFA-646           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-646' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '264' deliverable period rows in CRM linked to the latest version of contract 'EDSK-646'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECT-6461       | 2355700          | Jul-22 | Profile        |
    | NSFC-6462       | 100945           | Jul-22 | Profile        |
    | ALLC-6463       | 2303900          | Jul-22 | Profile        |

    ## Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    #Then  the Legal Contract CM feed contains the following '4' deliverables
    #| UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    #| 10017646 | EDSK-646       | 1               | AECT-6461     | 1               | 0                     | 30774.00     | 0             | 0        | 19-24 Traineeships Total Funding                                | ?                                                           |
    #| 10017646 | EDSK-646       | 1               | ALLC-646      | 1               | 0                     | 20630.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding                    | ?                                                           |
    #| 10017646 | EDSK-646       | 1               | NSFC-646      | 1               | 0                     | 27545.00     | 0             | 0        | National Skills Fund Total Funding                              | ?                                                           |
    #| 10017646 | EDSK-646       | 1               | NSFC-646      | 2               | 1                     | 27545.00     | 0             | 0        | Level 3 Offer for 24 year olds and over                         | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-646' agree with the most recent entry for this contract in the ContractManagement feed



    
    
#    # CDA
#
#    # Change the date
#    Given the override date is '09/07/2021'
#
#    # Run the CDA report
#    And  there is no CDA report named 'CDA Latest Version A646.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | EDSK-646       | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version               | Suffix |
#    | AEBC-NSF2122          | Latest Version        | A646   |
#
#    Then  a report named 'CDA Latest Version A646.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | AEBC-NSF2122            | 10017646 | 10017646 Co Ltd             | 10017646      | 10017646 Co Ltd             | NSFC-6461                | EDSK-646       | ESFA-646                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 8                 | 2021            | 2021/22       |              | 2469         |              |               |              | Yes                | 2469.00        | 0.00             | 0.00                  | 0.00           | 2469.00         |             | No            |                   |        | 100945            | 100946                   |                   | Aug              |
#    | AEBC-NSF2122            | 10017646 | 10017646 Co Ltd             | 10017646      | 10017646 Co Ltd             | NSFC-6461                | EDSK-646       | ESFA-646                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 9                 | 2021            | 2021/22       |              | 3299         |              |               |              | Yes                | 3299.00        |                  | 0.00                  | 0.00           | 3299.00         |             | No            |                   |        | 100945            | 100946                   |                   | Sep              |
#    | AEBC-NSF2122            | 10017646 | 10017646 Co Ltd             | 10017646      | 10017646 Co Ltd             | NSFC-6461                | EDSK-646       | ESFA-646                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 10                | 2021            | 2021/22       |              | 3527         |              |               |              | Yes                | 3527.00        |                  | 0.00                  | 0.00           | 3527.00         |             | No            |                   |        | 100945            | 100946                   |                   | Oct              |
#    | AEBC-NSF2122            | 10017646 | 10017646 Co Ltd             | 10017646      | 10017646 Co Ltd             | NSFC-6461                | EDSK-646       | ESFA-646                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 11                | 2021            | 2021/22       |              | 878          |              |               |              | Yes                | 878.00         |                  | 0.00                  | 0.00           | 878.00          |             | No            |                   |        | 100945            | 100946                   |                   | Nov              |
#    | AEBC-NSF2122            | 10017646 | 10017646 Co Ltd             | 10017646      | 10017646 Co Ltd             | NSFC-6461                | EDSK-646       | ESFA-646                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 12                | 2021            | 2021/22       |              | 2405         |              |               |              | Yes                | 2405.00        |                  | 0.00                  | 0.00           | 2405.00         |             | No            |                   |        | 100945            | 100946                   |                   | Dec              |
#    | AEBC-NSF2122            | 10017646 | 10017646 Co Ltd             | 10017646      | 10017646 Co Ltd             | NSFC-6461                | EDSK-646       | ESFA-646                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 1                 | 2022            | 2021/22       |              | 2508         |              |               |              | Yes                | 2508.00        |                  | 0.00                  | 0.00           | 2508.00         |             | No            |                   |        | 100945            | 100946                   |                   | Jan              |
#    | AEBC-NSF2122            | 10017646 | 10017646 Co Ltd             | 10017646      | 10017646 Co Ltd             | NSFC-6461                | EDSK-646       | ESFA-646                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 2                 | 2022            | 2021/22       |              | 3181         |              |               |              | Yes                | 3181.00        |                  | 0.00                  | 0.00           | 3181.00         |             | No            |                   |        | 100945            | 100946                   |                   | Feb              |
#    | AEBC-NSF2122            | 10017646 | 10017646 Co Ltd             | 10017646      | 10017646 Co Ltd             | NSFC-6461                | EDSK-646       | ESFA-646                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 3                 | 2022            | 2021/22       |              | 182          |              |               |              | Yes                | 182.00         |                  | 0.00                  | 0.00           | 182.00          |             | No            |                   |        | 100945            | 100946                   |                   | Mar              |
#    | AEBC-NSF2122            | 10017646 | 10017646 Co Ltd             | 10017646      | 10017646 Co Ltd             | NSFC-6461                | EDSK-646       | ESFA-646                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 4                 | 2022            | 2022/23       |              | 3512         |              |               |              | Yes                | 3512.00        |                  | 0.00                  | 0.00           | 3512.00         |             | No            |                   |        | 100945            | 100946                   |                   | Apr              |
#    | AEBC-NSF2122            | 10017646 | 10017646 Co Ltd             | 10017646      | 10017646 Co Ltd             | NSFC-6461                | EDSK-646       | ESFA-646                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 5                 | 2022            | 2022/23       |              | 1906         |              |               |              | Yes                | 1906.00        |                  | 0.00                  | 0.00           | 1906.00         |             | No            |                   |        | 100945            | 100946                   |                   | May              |
#    | AEBC-NSF2122            | 10017646 | 10017646 Co Ltd             | 10017646      | 10017646 Co Ltd             | NSFC-6461                | EDSK-646       | ESFA-646                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 6                 | 2022            | 2022/23       |              | 3022         |              |               |              | Yes                | 3022.00        |                  | 0.00                  | 0.00           | 3022.00         |             | No            |                   |        | 100945            | 100946                   |                   | Jun              |
#    | AEBC-NSF2122            | 10017646 | 10017646 Co Ltd             | 10017646      | 10017646 Co Ltd             | NSFC-6461                | EDSK-646       | ESFA-646                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 7                 | 2022            | 2022/23       |              | 656          |              |               |              | Yes                | 656.00         |                  | 0.00                  | 0.00           | 656.00          |             | No            |                   |        | 100945            | 100946                   |                   | Jul              |
     




    # Payment Batch for AEBC-19TRN2122 (PoP)

    # Change the date
    Given the override date is '05/08/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEBC-19TRN2122' AccountingPaymentPeriod '202105' CensusEndDate '05/08/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | AECT-6461                | 202108 |
    | AECT-6462                | 202108 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEBC-19TRN2122             | 202108               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEBC-19TRN2122             | 202108               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEBC-19TRN2122' PaymentPeriod '202105' CensusEndDate '05/08/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A646_19TRN.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEBC-19TRN2122' PaymentPeriod '202105' CensusEndDate '05/08/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AECT                   | 2021          | 05             | 05          | ?       | AECT-6461     | 494.00          | PROFILE          | 19-24TrnGrant                      | 2021-08-19 | 2021-08-01   | 2022-07-31 | ?              | 10017646 | 2355700    |
    | AECT                   | 2021          | 05             | 05          | ?       | AECT-6462     | 2560.00         | PROFILE          | 19-24TrnGrant                      | 2021-08-19 | 2021-08-01   | 2022-07-31 | ?              | 10040263 | 2355700    |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'AEBC-19TRN2122' AccountingPaymentPeriod '202105' and CensusEndDate '05/08/2021'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                    |
    | Payment Requests for Funding Stream Period AEBC-19TRN2122 for Payment Period 202105 have been generated as of Census End Date/Time 2021-08-05T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | AEBC-19TRN2122      | 202105        | 2021-08-05T22:00:00Z  | 2                | 3054.00    |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | AECT      | 01/08/2021   | 31/07/2022 | 05/08/2021    | 19/08/2021 | 2021          | 05             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017646  | 10017646       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AECT-6461  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355700    | PROFILE        | 19-24TrnGrant                 | 494.00          |
    | ORG0040263  | 10040263       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AECT-6462  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355700    | PROFILE        | 19-24TrnGrant                 | 2560.00         |





    # Payment Batch starts here for AEBC-NSF2122 (PoP)

    # Change the date
    Given the override date is '05/08/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEBC-NSF2122' AccountingPaymentPeriod '202105' CensusEndDate '05/08/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | NSFC-6461                | 202108 |
    | NSFC-6462                | 202108 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEBC-NSF2122               | 202108               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEBC-NSF2122               | 202108               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEBC-NSF2122' PaymentPeriod '202105' CensusEndDate '05/08/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A646.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEBC-NSF2122' PaymentPeriod '202105' CensusEndDate '05/08/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | NSFC                   | 2021          | 05             | 05          | ?       | NSFC-6461     | 2469.00         | PROFILE          | NSF L3 Offer                       | 2021-08-19 | 2021-08-01   | 2022-07-31 | ?              | 10017646 | 100945     |
    | NSFC                   | 2021          | 05             | 05          | ?       | NSFC-6462     | 1161.00         | PROFILE          | NSF L3 Offer                       | 2021-08-19 | 2021-08-01   | 2022-07-31 | ?              | 10040263 | 100945     |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'AEBC-NSF2122' AccountingPaymentPeriod '202105' and CensusEndDate '05/08/2021'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                  |
    | Payment Requests for Funding Stream Period AEBC-NSF2122 for Payment Period 202105 have been generated as of Census End Date/Time 2021-08-05T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | AEBC-NSF2122        | 202105        | 2021-08-05T22:00:00Z  | 2                | 3630.00    |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | NSFC      | 01/08/2021   | 31/07/2022 | 05/08/2021    | 19/08/2021 | 2021          | 05             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017646  | 10017646       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | NSFC-6461  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100945     | PROFILE        | NSF L3 Offer                  | 2469.00         |
    | ORG0040263  | 10040263       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | NSFC-6461  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100945     | PROFILE        | NSF L3 Offer                  | 1161.00         |





    # Payment Batch starts here for ALLBC2122 (PoP)

    # Change the date
    Given the override date is '05/08/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ALLBC2122' AccountingPaymentPeriod '202105' CensusEndDate '05/08/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | ALLC-6461                | 202108 |
    | ALLC-6463                | 202108 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ALLBC2122                  | 202108               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ALLBC2122                  | 202108               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLBC2122' PaymentPeriod '202105' CensusEndDate '05/08/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A646.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLBC2122' PaymentPeriod '202105' CensusEndDate '05/08/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | LBCO                   | 2021          | 05             | 05          | ?       | ALLC-6461     | 2807.00         | PROFILE          | Adv LL Bursary                     | 2021-08-19 | 2021-08-01   | 2022-07-31 | ?              | 10017646 | 2303900    |
    | LBCO                   | 2021          | 05             | 05          | ?       | ALLC-6463     | 1589.00         | PROFILE          | Adv LL Bursary                     | 2021-08-19 | 2021-08-01   | 2022-07-31 | ?              | 10040271 | 2303900    |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'ALLBC2122' AccountingPaymentPeriod '202105' and CensusEndDate '05/08/2021'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                               |
    | Payment Requests for Funding Stream Period ALLBC2122 for Payment Period 202105 have been generated as of Census End Date/Time 2021-08-05T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | ALLBC2122           | 202105        | 2021-08-05T22:00:00Z  | 2                | 4396.00    |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | LBCO      | 01/08/2021   | 31/07/2022 | 05/08/2021    | 19/08/2021 | 2021          | 05             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017646  | 10017646       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | ALLC-6461  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2303900    | PROFILE        | Adv LL Bursary                | 2807.00         |
    | ORG0040271  | 10040271       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | ALLC-6463  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2303900    | PROFILE        | Adv LL Bursary                | 1589.00         |


    # Tidy Up
    Given the override date is reset   

        