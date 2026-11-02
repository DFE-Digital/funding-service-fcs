Feature: WrongDeliverablesInFeed 30199

@AcceptanceTest @Withdrawn20231002
Scenario: A812 Create and approve a 1920 ESDK contract with 16TR, ALLB and ALLF allocs. Check deliverable data written to Legal Contract CM feed (Bug fix 30199)
    Given there are no allocations marked as Under Termination for UKPRN '10017812' 
    And   there are no terminated or closed allocations for UKPRN '10017812' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017812' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017812' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-812      |
    | ALLB-812      |
    | ALLF-812      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-812      |
    | ALLB-812      |
    | ALLF-812      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN1920      |
    | ALLB1920          |
    | ALLF1920          |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017812' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017812 Co Ltd' with UKPRN '10017812' and OrgId 'ORG0017812' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017812' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017812 | 117812 | 10017812 Co Ltd | 0              | Locked Restructure    | Yes           | AA017812      | ?             | 8 Beaumont Gate        | Shenley Hill           | ?                      | ?                      | Radlett                | Hertfordshire          | WD7 7AR   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017812 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017812 | 10017812 Co Ltd      | ESFA-812             | EDSK-812       | 1                     | 01/08/2019        | 31/07/2020      | 98141.00      |                                       | Conditions of Funding (Grant) (College)    | 1920   | New          | ORG0017812 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription   | CRMIntent    | DeliveryOrg |
    | 10017812 | EDSK-812       | 16TR-812      | 16-18TRN          | 16-18TRN1920            | AY                      | 01/08/2019          | 31/07/2020        | 44660.00        |                                         |            |                         | New          |             |
    | 10017812 | EDSK-812       | ALLB-812      | ALLB              | ALLB1920                | AY                      | 01/08/2019          | 31/07/2020        | 28155.00        |                                         |            |                         | New          |             |
    | 10017812 | EDSK-812       | ALLF-812      | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 31/07/2020        | 25326.00        |                                         |            |                         | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                          | CRMIntent    | DeliveryOrg |
    | 10017812 | EDSK-812       | 16TR-812      | 1               | 0                     | 44660.00  | 29993.00  | 14667.00  | 4767.00  | 2503.00  | 907.00   | 2978.00  | 2202.00  | 4529.00  | 6915.00  | 5192.00  | 2962.00  | 4213.00  | 5147.00  | 2345.00  | Total 16-18 Traineeships Funding                | New          |             | 
    | 10017812 | EDSK-812       | 16TR-812      | 2               | 1                     | 19032.00  | 14195.00  | 4837.00   | 1285.00  | 1640.00  | 573.00   | 74.00    | 588.00   | 2747.00  | 3671.00  | 3617.00  | 1062.00  | 1324.00  | 1522.00  | 929.00   | 16-18 Traineeships Programme Funding            | New          |             | 
    | 10017812 | EDSK-812       | 16TR-812      | 3               | 1                     | 25628.00  | 15798.00  | 9830.00   | 3482.00  | 863.00   | 334.00   | 2904.00  | 1614.00  | 1782.00  | 3244.00  | 1575.00  | 1900.00  | 2889.00  | 3625.00  | 1416.00  | 16-18 Traineeships Bursary Funding              | New          |             | 
    | 10017812 | EDSK-812       | ALLB-812      | 1               | 0                     | 28155.00  | 19372.00  | 8783.00   | 3489.00  | 2580.00  | 1607.00  | 3544.00  | 1434.00  | 1345.00  | 3346.00  | 2027.00  | 3267.00  | 2264.00  | 2555.00  | 697.00   | Total Advanced Learner Loans Bursary Funding    | New          |             | 
    | 10017812 | EDSK-812       | ALLF-812      | 5               | 0                     | 25326.00  | 18468.00  | 6858.00   | 2786.00  | 3586.00  | 3151.00  | 754.00   | 542.00   | 2163.00  | 3719.00  | 1767.00  | 1204.00  | 928.00   | 1758.00  | 2968.00  | Advanced Learner Loans Facility                 | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-812' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-812'

    # Change the date
    Given the override date is '11/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-812' and actual ContractNumber 'EDSK-812'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-812' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017812 | EDSK-812           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017812 | ESFA-812           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '132' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '132' deliverable period rows in CRM linked to the latest version of contract 'EDSK-812'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 16TR-812        | 2201300          | Jul-20 | Reconciliation |
    | ALLB-812        | 2303800          | Jul-20 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '5' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription    | 
    | 10017812 | EDSK-812       | 1               | 16TR-812      | 1               | 0                     | 44660        | 0             | 0        | Total 16-18 Traineeships Funding               | ?                         |
    | 10017812 | EDSK-812       | 1               | 16TR-812      | 2               | 1                     | 19032        | 0             | 0        | 16-18 Traineeships Programme Funding           | ?                         |
    | 10017812 | EDSK-812       | 1               | 16TR-812      | 3               | 1                     | 25628        | 0             | 0        | 16-18 Traineeships Bursary Funding             | ?                         |
    | 10017812 | EDSK-812       | 1               | ALLB-812      | 1               | 0                     | 28155        | 0             | 0        | Total Advanced Learner Loans Bursary Funding   | ?                         |
    | 10017812 | EDSK-812       | 1               | ALLF-812      | 5               | 0                     | 25326        | 0             | 0        | Advanced Learner Loans Facility                | ?                         |


    # Tidy Up
    And   the override date is reset
        
@AcceptanceTest @Withdrawn20230118
Scenario: A680 Create and approve an NLAP2018 contract. NFA variation amendment. Publish and approve. Check deliverable data written to Legal Contract CM feed (Bug30433)
    # This runs green but is not needed as the bug was fixed by R88a before the problem was discovered. 
    #   A812 is all we need
    Given there are no allocations marked as Under Termination for UKPRN '10017680' 
    And   there are no terminated or closed allocations for UKPRN '10017680' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017680' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017680' 

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017680'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ANLP-680      |
    | YNLP-680      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ANLP-680      |
    | YNLP-680      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18NLAP2018     |
    | ANLAP2018         |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | NLAP-680       | 1                     | 0                        |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017680' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017680 Co Ltd' with UKPRN '10017680' and OrgId 'ORG0017680' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017680' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017680 | 117680 | 10017680 Co Ltd | 0              | Active                | Yes           | AA017680      | ?             | 36 Kings Street        | Covent Garden          | London                 | ?                      | ?                      | ?                      | WC2 8JS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017680 |




    # Change the date
    Given the override date is '01/12/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017680 | 10017680 Co Ltd      | ESFA-680             | NLAP-680       | 1                     | 01/01/2018        | 31/03/2021      | 144693.00     |                                       | Contract for Services                      | 2018   | New          | ORG0017680 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017680 | NLAP-680       | ANLP-680      | ANLAP             | ANLAP2018               | NONLEVY                 | 01/01/2018          | 31/03/2021        | 81019.00        |                                         |            |                                                             | New          |             |
    | 10017680 | NLAP-680       | YNLP-680      | 16-18NLAP         | 16-18NLAP2018           | NONLEVY                 | 01/01/2018          | 31/03/2021        | 63674.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | DeliverableDescription                         | CRMIntent    | DeliveryOrg |
    | 10017680 | NLAP-680       | ANLP-680      | 1               | 0                     | 81019.00  | 1228.00  | 1964.00  | 738.00   | 714.00   | 3506.00  | 2532.00  | 768.00   | 2359.00  | 3253.00  | 571.00   | 2952.00  | 492.00   | 3189.00  | 3481.00  | 1623.00  | 778.00   | 595.00   | 160.00   | 1465.00  | 1252.00  | 2873.00  | 729.00   | 2478.00  | 2898.00  | 2621.00  | 3451.00  | 3679.00  | 1030.00  | 2557.00  | 2660.00  | 3332.00  | 333.00   | 3664.00  | 2058.00  | 3174.00  | 808.00   | 2241.00  | 3609.00  | 3204.00  | Total Adult Non-Levy Apprenticeships Funding   | New          |             | 
    | 10017680 | NLAP-680       | YNLP-680      | 1               | 0                     | 63674.00  | 2294.00  | 846.00   | 1488.00  | 1528.00  | 1409.00  | 1765.00  | 697.00   | 199.00   | 712.00   | 2872.00  | 95.00    | 3741.00  | 1187.00  | 1449.00  | 1646.00  | 1053.00  | 2832.00  | 214.00   | 3386.00  | 2254.00  | 965.00   | 1132.00  | 2595.00  | 925.00   | 1251.00  | 2239.00  | 2975.00  | 767.00   | 1725.00  | 816.00   | 3544.00  | 1780.00  | 3371.00  | 3282.00  | 1582.00  | 263.00   | 1503.00  | 500.00   | 792.00   | Total 16-18 Non-Levy Apprenticeships Funding   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | NLAP-680       | 1                     | 0                        | 2017-12-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'NLAP-680' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NLAP-680'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-680' and actual ContractNumber 'NLAP-680'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-680' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017680 | NLAP-680           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2021      | ?             |
    | 10017680 | ESFA-680           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '390' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '390' deliverable period rows in CRM linked to the latest version of contract 'NLAP-680'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | YNLP-680        | 2240151          | Mar-21 | Reconciliation |
    | ANLP-680        | 2340151          | Mar-21 | Reconciliation |


    # Check deliverable data in the ContractManagement Legal feed
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                               | DeliverableDescription   | 
    | 10017680 | NLAP-680       | 1               | ANLP-680      | 1               | 0                     | 81019        | 0             | 0        | Total Adult Non-Levy Apprenticeships Funding  | ?                        |
    | 10017680 | NLAP-680       | 1               | YNLP-680      | 1               | 0                     | 63674        | 0             | 0        | Total 16-18 Non-Levy Apprenticeships Funding  | ?                        |




    # NFA

    # Execute a non-financial VARIATION amendment

    # Change the date
    Given the override date is '22/06/2020'

    # Issue a non-financial VARIATION amendment on v1 to create v2
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'NLAP-680' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'NLAP-680' for a non-financial VARIATION contract amendment
   
    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017680 | NLAP-680           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/01/2018        | 31/03/2021      | Variation     |
    | 10017680 | NLAP-680           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/01/2018        | 31/03/2021      | ?             |
    | 10017680 | ESFA-680           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2021      | ?             |

    # Publish the contract
    And   the latest version of contract 'NLAP-680' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-680' and actual ContractNumber 'NLAP-680'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-680' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017680 | NLAP-680           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2021      | Variation     |
    | 10017680 | NLAP-680           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/01/2018        | 31/03/2021      | ?             |
    | 10017680 | ESFA-680           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '390' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '390' deliverable period rows in CRM linked to the latest version of contract 'NLAP-680'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | YNLP-680        | 2240151          | Mar-21 | Reconciliation |
    | ANLP-680        | 2340151          | Mar-21 | Reconciliation |



    # Check deliverable data in the ContractManagement Legal feed
    And   the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                               | DeliverableDescription   | 
    | 10017680 | NLAP-680       | 2               | ANLP-680      | 1               | 0                     | 81019        | 0             | 0        | Total Adult Non-Levy Apprenticeships Funding  | ?                        |
    | 10017680 | NLAP-680       | 2               | YNLP-680      | 1               | 0                     | 63674        | 0             | 0        | Total 16-18 Non-Levy Apprenticeships Funding  | ?                        |


    # Tidy Up
    And   the override date is reset


