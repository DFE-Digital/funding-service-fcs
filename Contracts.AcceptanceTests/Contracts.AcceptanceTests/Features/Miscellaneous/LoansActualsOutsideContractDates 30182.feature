Feature: LoansActualsOutsideContractDates 30182

@AcceptanceTest @Manual
Scenario: A051 Create and aprove a 2021 EDSK contract for ALLF. Consume actuals for 2021, 2122 and 2223. (To help with manual checking)
    Given there are no allocations marked as Under Termination for UKPRN '10017051' 
    And   there are no terminated or closed allocations for UKPRN '10017051' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017051' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017051' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLB-051      |
    | ALLF-051      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ALLB-051      |
    | ALLF-051      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLB2021          |
    | ALLF2021          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-051       | 1                     | 0                        |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017051' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017051 Co Ltd' with UKPRN '10017051' and OrgId 'ORG0017051' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017051' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017051 | 117051 | 10017051 Co Ltd | 0              | Active                | Yes           | AA017051      | ?             | 1 Ashley Cout          | The High Street        | ?                      | ?                      | West Dryton            | Middlesex              | UB7 7DN   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017051 |




    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017051 | 10017051 Co Ltd      | ESFA-051             | EDSK-051       | 1                     | 01/08/2020        | 31/07/2021      | 45865.00      |                                       | Contract for Services (ITP)                | 2021   | New          | ORG0017051 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017051 | EDSK-051       | ALLB-051      | ALLB              | ALLB2021                | AY                      | 01/08/2020          | 31/07/2021        | 21313.00        |                                         |            |                                                             | New          |             |
    | 10017051 | EDSK-051       | ALLF-051      | ALLF              | ALLF2021                | AY                      | 01/08/2020          | 31/07/2021        | 24552.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017051 | EDSK-051       | ALLB-051      | 1               | 0                     | 21313.00  | 11499.00  | 9814.00   | 3644.00  | 235.00   | 2078.00  | 250.00   | 1050.00  | 615.00   | 1920.00  | 1707.00  | 3328.00  | 1184.00  | 2933.00  | 2369.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             | 
    | 10017051 | EDSK-051       | ALLF-051      | 5               | 0                     | 24552.00  | 17032.00  | 7520.00   | 2263.00  | 3093.00  | 603.00   | 1655.00  | 3182.00  | 2303.00  | 2975.00  | 958.00   | 588.00   | 2683.00  | 2816.00  | 1433.00  | Advanced Learner Loans Facility                                 | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-051       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-051' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-051'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-051' and actual ContractNumber 'EDSK-051'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-051' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017051 | EDSK-051           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017051 | ESFA-051           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'EDSK-051'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | ALLB-051        | 2303800          | Jul-21 | Reconciliation |




    # Change the date
    Given the override date is '23/08/2020'

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-051       | 1                     | 0                        | 




    # Pull three years actuals from DC for the contract

    # Change the date
    Given the override date is '04/10/2020'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017051'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ALLF           | A02                  | ORG0017051     | CM             | 202008 | ALLF2021                | ALLF-051                 | ?          | 2               | 0            | 2323.73     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202008 | ALLF2021                | ALLF-051                 | ?          | 6               | 0            | 2282.16     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202008 | ALLF2021                | ALLF-051                 | ?          | 7               | 0            | 305.55      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202009 | ALLF2021                | ALLF-051                 | ?          | 2               | 0            | 1589.31     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202009 | ALLF2021                | ALLF-051                 | ?          | 6               | 0            | 1326.18     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202009 | ALLF2021                | ALLF-051                 | ?          | 7               | 0            | 801.14      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202010 | ALLF2021                | ALLF-051                 | ?          | 2               | 0            | 1969.47     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202010 | ALLF2021                | ALLF-051                 | ?          | 6               | 0            | 734.85      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202010 | ALLF2021                | ALLF-051                 | ?          | 7               | 0            | 1677.63     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202011 | ALLF2021                | ALLF-051                 | ?          | 2               | 0            | 2182.56     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202011 | ALLF2021                | ALLF-051                 | ?          | 6               | 0            | 717.99      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202011 | ALLF2021                | ALLF-051                 | ?          | 7               | 0            | 1210.96     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202012 | ALLF2021                | ALLF-051                 | ?          | 2               | 0            | 1084.25     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202012 | ALLF2021                | ALLF-051                 | ?          | 6               | 0            | 2057.80     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202012 | ALLF2021                | ALLF-051                 | ?          | 7               | 0            | 206.93      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202101 | ALLF2021                | ALLF-051                 | ?          | 2               | 0            | 1200.21     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202101 | ALLF2021                | ALLF-051                 | ?          | 6               | 0            | 1548.36     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202101 | ALLF2021                | ALLF-051                 | ?          | 7               | 0            | 2369.98     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202102 | ALLF2021                | ALLF-051                 | ?          | 2               | 0            | 1956.94     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202102 | ALLF2021                | ALLF-051                 | ?          | 6               | 0            | 490.62      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202102 | ALLF2021                | ALLF-051                 | ?          | 7               | 0            | 255.83      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202103 | ALLF2021                | ALLF-051                 | ?          | 2               | 0            | 311.41      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202103 | ALLF2021                | ALLF-051                 | ?          | 6               | 0            | 141.00      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202103 | ALLF2021                | ALLF-051                 | ?          | 7               | 0            | 1713.21     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202104 | ALLF2021                | ALLF-051                 | ?          | 2               | 0            | 263.65      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202104 | ALLF2021                | ALLF-051                 | ?          | 6               | 0            | 1861.18     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202104 | ALLF2021                | ALLF-051                 | ?          | 7               | 0            | 971.99      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202105 | ALLF2021                | ALLF-051                 | ?          | 2               | 0            | 179.44      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202105 | ALLF2021                | ALLF-051                 | ?          | 6               | 0            | 187.41      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202105 | ALLF2021                | ALLF-051                 | ?          | 7               | 0            | 2322.54     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202106 | ALLF2021                | ALLF-051                 | ?          | 2               | 0            | 1890.07     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202106 | ALLF2021                | ALLF-051                 | ?          | 6               | 0            | 718.77      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202106 | ALLF2021                | ALLF-051                 | ?          | 7               | 0            | 1288.76     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202107 | ALLF2021                | ALLF-051                 | ?          | 2               | 0            | 1060.48     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202107 | ALLF2021                | ALLF-051                 | ?          | 6               | 0            | 150.26      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202107 | ALLF2021                | ALLF-051                 | ?          | 7               | 0            | 1516.10     |
    # 
    | ALLF           | A02                  | ORG0017051     | CM             | 202108 | ALLF2122                | ALLF-051                 | ?          | 2               | 0            | 2323.73     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202108 | ALLF2122                | ALLF-051                 | ?          | 6               | 0            | 2282.16     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202108 | ALLF2122                | ALLF-051                 | ?          | 7               | 0            | 305.55      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202109 | ALLF2122                | ALLF-051                 | ?          | 2               | 0            | 1589.31     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202109 | ALLF2122                | ALLF-051                 | ?          | 6               | 0            | 1326.18     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202109 | ALLF2122                | ALLF-051                 | ?          | 7               | 0            | 801.14      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202110 | ALLF2122                | ALLF-051                 | ?          | 2               | 0            | 1969.47     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202110 | ALLF2122                | ALLF-051                 | ?          | 6               | 0            | 734.85      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202110 | ALLF2122                | ALLF-051                 | ?          | 7               | 0            | 1677.63     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202111 | ALLF2122                | ALLF-051                 | ?          | 2               | 0            | 2182.56     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202111 | ALLF2122                | ALLF-051                 | ?          | 6               | 0            | 717.99      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202111 | ALLF2122                | ALLF-051                 | ?          | 7               | 0            | 1210.96     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202112 | ALLF2122                | ALLF-051                 | ?          | 2               | 0            | 1084.25     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202112 | ALLF2122                | ALLF-051                 | ?          | 6               | 0            | 2057.80     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202112 | ALLF2122                | ALLF-051                 | ?          | 7               | 0            | 206.93      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202201 | ALLF2122                | ALLF-051                 | ?          | 2               | 0            | 1200.21     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202201 | ALLF2122                | ALLF-051                 | ?          | 6               | 0            | 1548.36     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202201 | ALLF2122                | ALLF-051                 | ?          | 7               | 0            | 2369.98     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202202 | ALLF2122                | ALLF-051                 | ?          | 2               | 0            | 1956.94     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202202 | ALLF2122                | ALLF-051                 | ?          | 6               | 0            | 490.62      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202202 | ALLF2122                | ALLF-051                 | ?          | 7               | 0            | 255.83      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202203 | ALLF2122                | ALLF-051                 | ?          | 2               | 0            | 311.41      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202203 | ALLF2122                | ALLF-051                 | ?          | 6               | 0            | 141.00      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202203 | ALLF2122                | ALLF-051                 | ?          | 7               | 0            | 1713.21     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202204 | ALLF2122                | ALLF-051                 | ?          | 2               | 0            | 263.65      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202204 | ALLF2122                | ALLF-051                 | ?          | 6               | 0            | 1861.18     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202204 | ALLF2122                | ALLF-051                 | ?          | 7               | 0            | 971.99      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202205 | ALLF2122                | ALLF-051                 | ?          | 2               | 0            | 179.44      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202205 | ALLF2122                | ALLF-051                 | ?          | 6               | 0            | 187.41      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202205 | ALLF2122                | ALLF-051                 | ?          | 7               | 0            | 2322.54     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202206 | ALLF2122                | ALLF-051                 | ?          | 2               | 0            | 1890.07     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202206 | ALLF2122                | ALLF-051                 | ?          | 6               | 0            | 718.77      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202206 | ALLF2122                | ALLF-051                 | ?          | 7               | 0            | 1288.76     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202207 | ALLF2122                | ALLF-051                 | ?          | 2               | 0            | 1060.48     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202207 | ALLF2122                | ALLF-051                 | ?          | 6               | 0            | 150.26      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202207 | ALLF2122                | ALLF-051                 | ?          | 7               | 0            | 1516.10     |
    # 
    | ALLF           | A02                  | ORG0017051     | CM             | 202208 | ALLF2223                | ALLF-051                 | ?          | 2               | 0            | 2323.73     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202208 | ALLF2223                | ALLF-051                 | ?          | 6               | 0            | 2282.16     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202208 | ALLF2223                | ALLF-051                 | ?          | 7               | 0            | 305.55      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202209 | ALLF2223                | ALLF-051                 | ?          | 2               | 0            | 1589.31     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202209 | ALLF2223                | ALLF-051                 | ?          | 6               | 0            | 1326.18     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202209 | ALLF2223                | ALLF-051                 | ?          | 7               | 0            | 801.14      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202210 | ALLF2223                | ALLF-051                 | ?          | 2               | 0            | 1969.47     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202210 | ALLF2223                | ALLF-051                 | ?          | 6               | 0            | 734.85      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202210 | ALLF2223                | ALLF-051                 | ?          | 7               | 0            | 1677.63     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202211 | ALLF2223                | ALLF-051                 | ?          | 2               | 0            | 2182.56     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202211 | ALLF2223                | ALLF-051                 | ?          | 6               | 0            | 717.99      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202211 | ALLF2223                | ALLF-051                 | ?          | 7               | 0            | 1210.96     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202212 | ALLF2223                | ALLF-051                 | ?          | 2               | 0            | 1084.25     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202212 | ALLF2223                | ALLF-051                 | ?          | 6               | 0            | 2057.80     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202212 | ALLF2223                | ALLF-051                 | ?          | 7               | 0            | 206.93      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202301 | ALLF2223                | ALLF-051                 | ?          | 2               | 0            | 1200.21     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202301 | ALLF2223                | ALLF-051                 | ?          | 6               | 0            | 1548.36     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202301 | ALLF2223                | ALLF-051                 | ?          | 7               | 0            | 2369.98     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202302 | ALLF2223                | ALLF-051                 | ?          | 2               | 0            | 1956.94     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202302 | ALLF2223                | ALLF-051                 | ?          | 6               | 0            | 490.62      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202302 | ALLF2223                | ALLF-051                 | ?          | 7               | 0            | 255.83      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202303 | ALLF2223                | ALLF-051                 | ?          | 2               | 0            | 311.41      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202303 | ALLF2223                | ALLF-051                 | ?          | 6               | 0            | 141.00      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202303 | ALLF2223                | ALLF-051                 | ?          | 7               | 0            | 1713.21     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202304 | ALLF2223                | ALLF-051                 | ?          | 2               | 0            | 263.65      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202304 | ALLF2223                | ALLF-051                 | ?          | 6               | 0            | 1861.18     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202304 | ALLF2223                | ALLF-051                 | ?          | 7               | 0            | 971.99      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202305 | ALLF2223                | ALLF-051                 | ?          | 2               | 0            | 179.44      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202305 | ALLF2223                | ALLF-051                 | ?          | 6               | 0            | 187.41      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202305 | ALLF2223                | ALLF-051                 | ?          | 7               | 0            | 2322.54     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202306 | ALLF2223                | ALLF-051                 | ?          | 2               | 0            | 1890.07     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202306 | ALLF2223                | ALLF-051                 | ?          | 6               | 0            | 718.77      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202306 | ALLF2223                | ALLF-051                 | ?          | 7               | 0            | 1288.76     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202307 | ALLF2223                | ALLF-051                 | ?          | 2               | 0            | 1060.48     |
    | ALLF           | A02                  | ORG0017051     | CM             | 202307 | ALLF2223                | ALLF-051                 | ?          | 6               | 0            | 150.26      |
    | ALLF           | A02                  | ORG0017051     | CM             | 202307 | ALLF2223                | ALLF-051                 | ?          | 7               | 0            | 1516.10     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



  # Then check stuff 



 #   # Tidy up
 #   Then  the override date is reset

