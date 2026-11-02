Feature: DuplicateContracts 30021


@AcceptanceTest @Withdrawn20230118
Scenario: A710x Look for duplicates contracts and/or allocations
    # Are there duplicate contracts in CRM? (Operations.DuplicateContract) J081
	When  the Duplicate Contract monitoring job is run

@AcceptanceTest @Withdrawn20230118
Scenario: A710y Cleardown CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017710' 

@AcceptanceTest @Withdrawn20230118
Scenario: A710 Manual data set-up. Create duplicate contracts in CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017710' 
    And   there are no terminated or closed allocations for UKPRN '10017710' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017710' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017110' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017710' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | NCSC-710      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | NCSC-710      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | NCS-C2021         |




    # Set organisation 
    Given there is no Organisation data for UKPRN '10017710' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017710 | 117710 | 10017710 Co Ltd | 0              | Active                | Yes           | AA017710      | ?             | 100 Harley Street      | London                 | ?                      | ?                      | ?                      | ?                      | W1N 1AF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017710 |




    # Change the date
    Given the override date is '01/03/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType           | Period | CRMIntent    | OrgId      |
    | 10017710 | 10017710 Co Ltd      | ESFA-710             | NCS-710        | 1                     | 01/04/2020        | 30/03/2021      | 64302.00      | East of England and Buckinghamshire   | Contract for Services  | 2021   | New          | ORG0017710 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription    | CRMIntent    | DeliveryOrg |
    | 10017710 | NCS-710        | NCSC-710      | NCS-C             | NCS-C2021               | NCS                     | 01/04/2020          | 30/03/2021        | 64302.00        | East of England and Buckinghamshire     | 0000000101 |                          | New          |             |
    | 10017710 | NCS-710        | NCSC-710      | NCS-C             | NCS-C2021               | NCS                     | 01/04/2020          | 30/03/2021        | 64302.00        | East of England and Buckinghamshire     | 0000000101 |                          | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | DeliverableDescription                     | CRMIntent    | DeliveryOrg |
    | 10017710 | NCS-710        | NCSC-710      | 1               | 0                     | 64302.00  | 5104.00  | 5256.00  | 7746.00  | 5711.00  | 8868.00  | 5063.00  | 5374.00  | 3689.00  | 4060.00  | 5666.00  | 4550.00  | 3215.00  | Total In The Community Funding             | New          |             | 
    | 10017710 | NCS-710        | NCSC-710      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                | New          |             | 
    | 10017710 | NCS-710        | NCSC-710      | 2               | 1                     | 23499.00  | 3016.00  | 2013.00  | 2304.00  | 446.00   | 3302.00  | 3119.00  | 2685.00  | 288.00   | 76.00    | 1696.00  | 3253.00  | 1301.00  | Customer Satisfaction                      | New          |             | 
    | 10017710 | NCS-710        | NCSC-710      | 3               | 1                     | 40803.00  | 2088.00  | 3243.00  | 5442.00  | 5265.00  | 5566.00  | 1944.00  | 2689.00  | 3401.00  | 3984.00  | 3970.00  | 1297.00  | 1914.00  | Career Management and Jobs and Learning    | New          |             | 
    | 10017710 | NCS-710        | NCSC-710      | 4               | 3                     | 19407.00  | 1277.00  | 1000.00  | 1830.00  | 2058.00  | 3110.00  | 936.00   | 1039.00  | 1711.00  | 2413.00  | 2043.00  | 437.00   | 1553.00  | Career Management                          | New          |             | 
    | 10017710 | NCS-710        | NCSC-710      | 5               | 3                     | 21396.00  | 811.00   | 2243.00  | 3612.00  | 3207.00  | 2456.00  | 1008.00  | 1650.00  | 1690.00  | 1571.00  | 1927.00  | 860.00   | 361.00   | Jobs and Learning                          | New          |             | 

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | 
    | 10017710 | NCS-710        | NCSC-710      | 6               | 0        | 718     | 74       | 57       | 82       | 100      | 70       | 69       | 47       | 23       | 70       | 19       | 41       | 66       |

    And   the contract exists in CRM

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus    | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017710 | NCS-710            | 1                     | 0                        | Draft            | Unassigned           | True          | False               | 01/04/2020        | 30/03/2021      | ?             |
    | 10017710 | ESFA-710           | 1                     | 0                        | Draft            | ?                    | False         | False               | 01/04/2020        | 30/03/2021      | ?             |


#
#    # Create the contract a second time
#    And   the contract exists in CRM
#
#    # Create the contract a third time
#    And   the contract exists in CRM
#
#
#
#
#	# Wait for the replicated database to catch up and find the duplicates
#	Then  there are '2' duplicate contracts in the replicated CRM database as follows
#    | ContractNumber | ContractVersionNumber | ContractSubVersion |
#    | NCS-710        | 1                     | 0                  |
#
#    # Check for duplicate contracts in Operations.DuplicateContract J081
#	When  the Duplicate Contract monitoring job is run
#
#
#    # Check Dashboard manually
#
#
#    # Tidy up
#    Then  the override date is reset  
      
        