Feature: LiveBugIncorrectSoFvalues 37211

@AcceptanceTest @Withdrawn20231002
Scenario: A581 Live Bug: Create and approve an 1819 AEB contract with AEB-TOL1819 alloc. Consume actuals. Bulk amend 2x post-year-end. Check financials

    # Note: Need to check ContractManagement.ApprovedContractAllocation manually

    Given there are no allocations marked as Under Termination for UKPRN '10017581' 
    And   there are no terminated or closed allocations for UKPRN '10017581' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017581' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017581' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017581' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBT-581      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBT-581      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-TOL1819       |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP-581       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017581'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017581' 
    And   there is no caseload advisor for UKPRN '10017581' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017581 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017581' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017581 Co Ltd' with UKPRN '10017581' and OrgId 'ORG0017581' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017581 | 117581 | 10017581 Co Ltd | 0              | Active                | Yes           | AA017581      | ?             | 16 Chaucer Grove       | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 2XZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017581 |





    # Change the date
    Given the override date is '01/07/2018'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP-581'
    And   there are no details in ContractManagement.CreatedContract for 'AEBP-581'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017581 | 10017581 Co Ltd      | ESFA-581             | AEBP-581       | 1                     | 01/08/2018        | 31/07/2019      | 27815.00      |                                       | Procured                                   | 1819   | New          | ORG0017581 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017581 | AEBP-581       | AEBT-581      | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 27815.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017581 | AEBP-581       | AEBT-581      | 1               | 0                     | 27815.00  | 17193.00  | 10622.00  | 1252.00  | 2493.00  | 1489.00  | 1781.00  | 3624.00  | 1796.00  | 2596.00  | 2162.00  | 3466.00  | 3253.00  | 1173.00  | 2730.00  | Adult Education - Traineeships and Other Learning Total Funding | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP-581       | 1                     | 0                        | 2018-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-581'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-581' and ContractNumber 'AEBP-581' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-581' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017581 | AEBP-581           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017581 | ESFA-581           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'AEBP-581'





    # Add actuals to the contract for AEB-TOL1819

    # Change the date
    Given the override date is '04/07/2019'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017581'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jun 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201808 | AEB-TOL1819             | AEBT-581                 | ?          | 2               | 0            | 1073.72     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201808 | AEB-TOL1819             | AEBT-581                 | ?          | 3               | 0            | 2254.33     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201808 | AEB-TOL1819             | AEBT-581                 | ?          | 4               | 0            | 2422.54     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201808 | AEB-TOL1819             | AEBT-581                 | ?          | 5               | 0            | 237.87      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201808 | AEB-TOL1819             | AEBT-581                 | ?          | 6               | 0            | 281.94      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201809 | AEB-TOL1819             | AEBT-581                 | ?          | 2               | 0            | 1529.47     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201809 | AEB-TOL1819             | AEBT-581                 | ?          | 3               | 0            | 2497.67     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201809 | AEB-TOL1819             | AEBT-581                 | ?          | 4               | 0            | 2110.71     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201809 | AEB-TOL1819             | AEBT-581                 | ?          | 5               | 0            | 968.71      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201809 | AEB-TOL1819             | AEBT-581                 | ?          | 6               | 0            | 353.35      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201810 | AEB-TOL1819             | AEBT-581                 | ?          | 2               | 0            | 1573.50     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201810 | AEB-TOL1819             | AEBT-581                 | ?          | 3               | 0            | 2040.84     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201810 | AEB-TOL1819             | AEBT-581                 | ?          | 4               | 0            | 705.46      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201810 | AEB-TOL1819             | AEBT-581                 | ?          | 5               | 0            | 761.65      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201810 | AEB-TOL1819             | AEBT-581                 | ?          | 6               | 0            | 2092.94     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201811 | AEB-TOL1819             | AEBT-581                 | ?          | 2               | 0            | 649.51      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201811 | AEB-TOL1819             | AEBT-581                 | ?          | 3               | 0            | 178.47      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201811 | AEB-TOL1819             | AEBT-581                 | ?          | 4               | 0            | 245.53      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201811 | AEB-TOL1819             | AEBT-581                 | ?          | 5               | 0            | 932.50      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201811 | AEB-TOL1819             | AEBT-581                 | ?          | 6               | 0            | 857.17      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201812 | AEB-TOL1819             | AEBT-581                 | ?          | 2               | 0            | 376.38      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201812 | AEB-TOL1819             | AEBT-581                 | ?          | 3               | 0            | 189.12      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201812 | AEB-TOL1819             | AEBT-581                 | ?          | 4               | 0            | 2489.81     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201812 | AEB-TOL1819             | AEBT-581                 | ?          | 5               | 0            | 2221.02     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201812 | AEB-TOL1819             | AEBT-581                 | ?          | 6               | 0            | 377.63      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201901 | AEB-TOL1819             | AEBT-581                 | ?          | 2               | 0            | 507.03      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201901 | AEB-TOL1819             | AEBT-581                 | ?          | 3               | 0            | 1171.04     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201901 | AEB-TOL1819             | AEBT-581                 | ?          | 4               | 0            | 672.42      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201901 | AEB-TOL1819             | AEBT-581                 | ?          | 5               | 0            | 538.06      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201901 | AEB-TOL1819             | AEBT-581                 | ?          | 6               | 0            | 2081.83     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201902 | AEB-TOL1819             | AEBT-581                 | ?          | 2               | 0            | 478.51      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201902 | AEB-TOL1819             | AEBT-581                 | ?          | 3               | 0            | 854.51      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201902 | AEB-TOL1819             | AEBT-581                 | ?          | 4               | 0            | 1478.30     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201902 | AEB-TOL1819             | AEBT-581                 | ?          | 5               | 0            | 201.53      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201902 | AEB-TOL1819             | AEBT-581                 | ?          | 6               | 0            | 1498.09     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201903 | AEB-TOL1819             | AEBT-581                 | ?          | 2               | 0            | 259.63      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201903 | AEB-TOL1819             | AEBT-581                 | ?          | 3               | 0            | 1271.36     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201903 | AEB-TOL1819             | AEBT-581                 | ?          | 4               | 0            | 197.16      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201903 | AEB-TOL1819             | AEBT-581                 | ?          | 5               | 0            | 1586.78     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201903 | AEB-TOL1819             | AEBT-581                 | ?          | 6               | 0            | 366.81      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201904 | AEB-TOL1819             | AEBT-581                 | ?          | 2               | 0            | 430.07      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201904 | AEB-TOL1819             | AEBT-581                 | ?          | 3               | 0            | 2480.20     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201904 | AEB-TOL1819             | AEBT-581                 | ?          | 4               | 0            | 860.14      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201904 | AEB-TOL1819             | AEBT-581                 | ?          | 5               | 0            | 1579.35     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201904 | AEB-TOL1819             | AEBT-581                 | ?          | 6               | 0            | 294.63      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201905 | AEB-TOL1819             | AEBT-581                 | ?          | 2               | 0            | 180.07      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201905 | AEB-TOL1819             | AEBT-581                 | ?          | 3               | 0            | 2079.85     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201905 | AEB-TOL1819             | AEBT-581                 | ?          | 4               | 0            | 1162.21     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201905 | AEB-TOL1819             | AEBT-581                 | ?          | 5               | 0            | 2020.07     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201905 | AEB-TOL1819             | AEBT-581                 | ?          | 6               | 0            | 1381.70     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201906 | AEB-TOL1819             | AEBT-581                 | ?          | 2               | 0            | 1541.17     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201906 | AEB-TOL1819             | AEBT-581                 | ?          | 3               | 0            | 1379.62     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201906 | AEB-TOL1819             | AEBT-581                 | ?          | 4               | 0            | 1363.74     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201906 | AEB-TOL1819             | AEBT-581                 | ?          | 5               | 0            | 1562.97     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201906 | AEB-TOL1819             | AEBT-581                 | ?          | 6               | 0            | 2160.46     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201907 | AEB-TOL1819             | AEBT-581                 | ?          | 2               | 0            | 1432.49     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201907 | AEB-TOL1819             | AEBT-581                 | ?          | 3               | 0            | 872.89      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201907 | AEB-TOL1819             | AEBT-581                 | ?          | 4               | 0            | 2232.22     |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201907 | AEB-TOL1819             | AEBT-581                 | ?          | 5               | 0            | 762.66      |
    | AEB1819        | AEB11                | ORG0017581     | CM             | 201907 | AEB-TOL1819             | AEBT-581                 | ?          | 6               | 0            | 1995.99     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-581       | AEBT-581           | 1               | 27815.00  | 17193.00 | 10622.00 | 1252.00  | 2493.00  | 1489.00  | 1781.00  | 3624.00  | 1796.00  | 2596.00  | 2162.00  | 3466.00  | 3253.00  | 1173.00  | 2730.00  | 
    | AEBP-581       | AEBT-581           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-581       | AEBT-581           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-581       | AEBT-581           | 2               | 8599.06   | 1073.72  | 1529.47  | 1573.50  | 649.51   | 376.38   | 507.03   | 478.51   | 259.63   | 430.07   | 180.07   | 1541.17  | ?        | 
    | AEBP-581       | AEBT-581           | 3               | 16397.01  | 2254.33  | 2497.67  | 2040.84  | 178.47   | 189.12   | 1171.04  | 854.51   | 1271.36  | 2480.20  | 2079.85  | 1379.62  | ?        | 
    | AEBP-581       | AEBT-581           | 4               | 13708.02  | 2422.54  | 2110.71  | 705.46   | 245.53   | 2489.81  | 672.42   | 1478.30  | 197.16   | 860.14   | 1162.21  | 1363.74  | ?        | 
    | AEBP-581       | AEBT-581           | 5               | 12610.51  | 237.87   | 968.71   | 761.65   | 932.50   | 2221.02  | 538.06   | 201.53   | 1586.78  | 1579.35  | 2020.07  | 1562.97  | ?        | 
    | AEBP-581       | AEBT-581           | 6               | 11746.55  | 281.94   | 353.35   | 2092.94  | 857.17   | 377.63   | 2081.83  | 1498.09  | 366.81   | 294.63   | 1381.70  | 2160.46  | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-581       | AEBT-581           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 2               | 8599.06   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8599.06  | 0.00     | 
    | AEBP-581       | AEBT-581           | 3               | 16397.01  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16397.01 | 0.00     | 
    | AEBP-581       | AEBT-581           | 4               | 13708.02  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13708.02 | 0.00     | 
    | AEBP-581       | AEBT-581           | 5               | 12610.51  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12610.51 | 0.00     | 
    | AEBP-581       | AEBT-581           | 6               | 11746.55  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 11746.55 | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-581       | AEBT-581           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 2               | -4879.89  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4879.89 | 0.00     | 
    | AEBP-581       | AEBT-581           | 3               | -9093.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -9093.83 | 0.00     | 
    | AEBP-581       | AEBT-581           | 4               | -7784.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -7784.17 | 0.00     | 
    | AEBP-581       | AEBT-581           | 5               | -6925.47  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6925.47 | 0.00     | 
    | AEBP-581       | AEBT-581           | 6               | -6562.79  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6562.79 | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-581       | AEBT-581           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 2               | 3719.17   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3719.17  | 0.00     | 
    | AEBP-581       | AEBT-581           | 3               | 7303.18   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7303.18  | 0.00     | 
    | AEBP-581       | AEBT-581           | 4               | 5923.85   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5923.85  | 0.00     | 
    | AEBP-581       | AEBT-581           | 5               | 5685.04   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5685.04  | 0.00     | 
    | AEBP-581       | AEBT-581           | 6               | 5183.76   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5183.76  | 0.00     | 





    # Bulk amend in Jan 2020, several months after the contract end date

    # Change the date
    Given the override date is '06/01/2020'

    # Bulk file
    And   there are no files prefixed '10017581' in the Sharepoint 'AEB-1819-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1819 07062022121950 v3_A581' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 1819 07062022121950 v3_A581' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1819 07062022121950 v3_A581' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1819 07062022121950 v3_A581' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1819 07062022121950 v3_A581.xlsx' exists in the Datafiles folder and UKPRN '10017581' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check SoF and FA
    Then  the file named '10017581_AEBP-581_v2.pdf' in Sharepoint location 'AEB-1819-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017581 Co Ltd UKPRN: 10017581
    Master Contract Number: ESFA-581
    Allocation
    1 August 2018 to 31 July 2019 Contract Ref Aug 18 - Mar 19 Apr 19 - Jul 19 Total
    Adult Education Budget - Traineeships and Other Learning AEBT-581 £27,047 £12,953 £40,000
    Total: £40,000
    Total Funding for this contract: £40,000
    
    Funding Agreement Adult Education Budget - Traineeships and Other Learning
    Provider: 10017581 Co Ltd UKPRN: 10017581
    Master Contract Ref: ESFA-581 Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: AEBT-581
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Adult Education - Traineeships and Other Learning £40,000 £1,883 £1,224 £7,224 £2,615 £1,139 £7,679 £1,851 £3,432 £800 £754 £6,745 £4,654
    Total Funding £40,000 £1,883 £1,224 £7,224 £2,615 £1,139 £7,679 £1,851 £3,432 £800 £754 £6,745 £4,654
    Ref (for internal use only):  AEBP-581 v2
    Page 1 of 1 of this Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017581_AEBP-581_v2.pdf' in 'AEB-1819-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A581v2.pdf'





    # Publish and approve

    # Change the date
    Given the override date is '07/01/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-581'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-581' and ContractNumber 'AEBP-581' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-581' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017581 | AEBP-581           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017581 | AEBP-581           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017581 | ESFA-581           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM
    And   there are '78' deliverable period rows in CRM linked to the latest version of contract 'AEBP-581'





    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Feb-20   |
    | AEBP-581       | AEBT-581           | 1               | 40000.00  | 27047.00 | 12953.00 | 1883.00  | 1224.00  | 7224.00  | 2615.00  | 1139.00  | 7679.00  | 1851.00  | 3432.00  | 800.00   | 754.00   | 6745.00  | 4654.00  | 0.00     | 
    | AEBP-581       | AEBT-581           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Feb-20   |
    | AEBP-581       | AEBT-581           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-581       | AEBT-581           | 2               | 8599.06   | 1073.72  | 1529.47  | 1573.50  | 649.51   | 376.38   | 507.03   | 478.51   | 259.63   | 430.07   | 180.07   | 1541.17  | ?        | ?        | 
    | AEBP-581       | AEBT-581           | 3               | 16397.01  | 2254.33  | 2497.67  | 2040.84  | 178.47   | 189.12   | 1171.04  | 854.51   | 1271.36  | 2480.20  | 2079.85  | 1379.62  | ?        | ?        | 
    | AEBP-581       | AEBT-581           | 4               | 13708.02  | 2422.54  | 2110.71  | 705.46   | 245.53   | 2489.81  | 672.42   | 1478.30  | 197.16   | 860.14   | 1162.21  | 1363.74  | ?        | ?        | 
    | AEBP-581       | AEBT-581           | 5               | 12610.51  | 237.87   | 968.71   | 761.65   | 932.50   | 2221.02  | 538.06   | 201.53   | 1586.78  | 1579.35  | 2020.07  | 1562.97  | ?        | ?        | 
    | AEBP-581       | AEBT-581           | 6               | 11746.55  | 281.94   | 353.35   | 2092.94  | 857.17   | 377.63   | 2081.83  | 1498.09  | 366.81   | 294.63   | 1381.70  | 2160.46  | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Feb-20   |
    | AEBP-581       | AEBT-581           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 2               | 13478.95  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8599.06  | 0.00     | 4879.89  | 
    | AEBP-581       | AEBT-581           | 3               | 25490.84  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16397.01 | 0.00     | 9093.83  | 
    | AEBP-581       | AEBT-581           | 4               | 21492.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13708.02 | 0.00     | 7784.17  | 
    | AEBP-581       | AEBT-581           | 5               | 19535.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12610.51 | 0.00     | 6925.47  | 
    | AEBP-581       | AEBT-581           | 6               | 18309.34  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 11746.55 | 0.00     | 6562.79  | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Feb-20   |
    | AEBP-581       | AEBT-581           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 2               | -8022.89  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4879.89 | 0.00     | -3143.00 | 
    | AEBP-581       | AEBT-581           | 3               | -15091.70 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -9093.83 | 0.00     | -5997.87 | 
    | AEBP-581       | AEBT-581           | 4               | -12794.42 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -7784.17 | 0.00     | -5010.25 | 
    | AEBP-581       | AEBT-581           | 5               | -11539.79 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6925.47 | 0.00     | -4614.32 | 
    | AEBP-581       | AEBT-581           | 6               | -10858.50 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6562.79 | 0.00     | -4295.71 | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Feb-20   |
    | AEBP-581       | AEBT-581           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 2               | 5456.06   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3719.17  | 0.00     | 1736.89  | 
    | AEBP-581       | AEBT-581           | 3               | 10399.14  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7303.18  | 0.00     | 3095.96  | 
    | AEBP-581       | AEBT-581           | 4               | 8697.77   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5923.85  | 0.00     | 2773.92  | 
    | AEBP-581       | AEBT-581           | 5               | 7996.19   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5685.04  | 0.00     | 2311.15  | 
    | AEBP-581       | AEBT-581           | 6               | 7450.84   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5183.76  | 0.00     | 2267.08  | 





    # Bulk amend again in Feb 2020

    # Change the date
    Given the override date is '06/02/2020'

    # Bulk file
    And   there are no files prefixed '10017581' in the Sharepoint 'AEB-1819-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1819 07062022121955 v3_A581' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 1819 07062022121955 v3_A581' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1819 07062022121955 v3_A581' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1819 07062022121955 v3_A581' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1819 07062022121955 v3_A581.xlsx' exists in the Datafiles folder and UKPRN '10017581' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check SoF and FA
    Then  the file named '10017581_AEBP-581_v3.pdf' in Sharepoint location 'AEB-1819-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017581 Co Ltd UKPRN: 10017581
    Master Contract Number: ESFA-581
    Allocation
    1 August 2018 to 31 July 2019 Contract Ref Aug 18 - Mar 19 Apr 19 - Jul 19 Total
    Adult Education Budget - Traineeships and Other Learning AEBT-581 £24,526 £12,974 £37,500
    Total: £37,500
    Total Funding for this contract: £37,500
    
    Funding Agreement Adult Education Budget - Traineeships and Other Learning
    Provider: 10017581 Co Ltd UKPRN: 10017581
    Master Contract Ref: ESFA-581 Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: AEBT-581
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Adult Education - Traineeships and Other Learning £37,500 £1,903 £1,086 £7,150 £2,767 £1,030 £5,735 £1,648 £3,207 £679 £867 £6,907 £4,521
    Total Funding £37,500 £1,903 £1,086 £7,150 £2,767 £1,030 £5,735 £1,648 £3,207 £679 £867 £6,907 £4,521
    Ref (for internal use only):  AEBP-581 v3
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017581_AEBP-581_v3.pdf' in 'AEB-1819-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A581v3.pdf'





    # Publish and approve

    # Change the date
    Given the override date is '07/02/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-581'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-581' and ContractNumber 'AEBP-581' and Version '3'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-581' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017581 | AEBP-581           | 3                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017581 | AEBP-581           | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017581 | AEBP-581           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017581 | ESFA-581           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM
    And   there are '84' deliverable period rows in CRM linked to the latest version of contract 'AEBP-581'





    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Feb-20   | Mar-20   |
    | AEBP-581       | AEBT-581           | 1               | 37500.00  | 24526.00 | 12974.00 | 1903.00  | 1086.00  | 7150.00  | 2767.00  | 1030.00  | 5735.00  | 1648.00  | 3207.00  | 679.00   | 867.00   | 6907.00  | 4521.00  | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Feb-20   | Mar-20   |
    | AEBP-581       | AEBT-581           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-581       | AEBT-581           | 2               | 8599.06   | 1073.72  | 1529.47  | 1573.50  | 649.51   | 376.38   | 507.03   | 478.51   | 259.63   | 430.07   | 180.07   | 1541.17  | ?        | ?        | ?        | 
    | AEBP-581       | AEBT-581           | 3               | 16397.01  | 2254.33  | 2497.67  | 2040.84  | 178.47   | 189.12   | 1171.04  | 854.51   | 1271.36  | 2480.20  | 2079.85  | 1379.62  | ?        | ?        | ?        | 
    | AEBP-581       | AEBT-581           | 4               | 13708.02  | 2422.54  | 2110.71  | 705.46   | 245.53   | 2489.81  | 672.42   | 1478.30  | 197.16   | 860.14   | 1162.21  | 1363.74  | ?        | ?        | ?        | 
    | AEBP-581       | AEBT-581           | 5               | 12610.51  | 237.87   | 968.71   | 761.65   | 932.50   | 2221.02  | 538.06   | 201.53   | 1586.78  | 1579.35  | 2020.07  | 1562.97  | ?        | ?        | ?        | 
    | AEBP-581       | AEBT-581           | 6               | 11746.55  | 281.94   | 353.35   | 2092.94  | 857.17   | 377.63   | 2081.83  | 1498.09  | 366.81   | 294.63   | 1381.70  | 2160.46  | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Feb-20   | Mar-20   |
    | AEBP-581       | AEBT-581           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 2               | 16621.95  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8599.06  | 0.00     | 4879.89  | 3143.00  | 
    | AEBP-581       | AEBT-581           | 3               | 31488.71  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16397.01 | 0.00     | 9093.83  | 5997.87  | 
    | AEBP-581       | AEBT-581           | 4               | 26502.44  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13708.02 | 0.00     | 7784.17  | 5010.25  | 
    | AEBP-581       | AEBT-581           | 5               | 24150.30  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12610.51 | 0.00     | 6925.47  | 4614.32  | 
    | AEBP-581       | AEBT-581           | 6               | 22605.05  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 11746.55 | 0.00     | 6562.79  | 4295.71  | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Feb-20   | Mar-20   |
    | AEBP-581       | AEBT-581           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 2               | -11545.39 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4879.89 | 0.00     | -3143.00 | -3522.50 | 
    | AEBP-581       | AEBT-581           | 3               | -21702.54 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -9093.83 | 0.00     | -5997.87 | -6610.84 | 
    | AEBP-581       | AEBT-581           | 4               | -18412.24 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -7784.17 | 0.00     | -5010.25 | -5617.82 | 
    | AEBP-581       | AEBT-581           | 5               | -16589.74 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6925.47 | 0.00     | -4614.32 | -5049.95 | 
    | AEBP-581       | AEBT-581           | 6               | -15618.53 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6562.79 | 0.00     | -4295.71 | -4760.03 | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Feb-20   | Mar-20   |
    | AEBP-581       | AEBT-581           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-581       | AEBT-581           | 2               | 5076.56   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3719.17  | 0.00     | 1736.89  | -379.50  | 
    | AEBP-581       | AEBT-581           | 3               | 9786.17   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 7303.18  | 0.00     | 3095.96  | -612.97  | 
    | AEBP-581       | AEBT-581           | 4               | 8090.20   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5923.85  | 0.00     | 2773.92  | -607.57  | 
    | AEBP-581       | AEBT-581           | 5               | 7560.56   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5685.04  | 0.00     | 2311.15  | -435.63  | 
    | AEBP-581       | AEBT-581           | 6               | 6986.52   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5183.76  | 0.00     | 2267.08  | -464.32  | 



    # Note: Need to check ContractManagement.ApprovedContractAllocation manually
 
    # These are the figures generated before the code fix
    # ContractNo Ver AllocRef TotalPlannedValue PlannedValueEnvelope1 PlannedValueEnvelope2
    # AEBP-581    1  AEBT-581   27815            17193                 10622
    # AEBP-581    2  AEBT-581   40000            27047                 12953
    # AEBP-581    3  AEBT-581   37500            24526                     0
 
    # These are the figures which should be generated
    # ContractNo Ver AllocRef TotalPlannedValue PlannedValueEnvelope1 PlannedValueEnvelope2
    # AEBP-581    1  AEBT-581   27815            17193                 10622
    # AEBP-581    2  AEBT-581   40000            27047                 12953
    # AEBP-581    3  AEBT-581   37500            24526                 12974
    # 
       




    # Bulk new amendment to add a 19/20 contract to the same Master

    # Change the date
    Given the override date is '01/07/2021'

    # Bulk file
    And   there are no files prefixed '10017581' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1920 07062022154836 v3_A581' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 1920 07062022154836 v3_A581' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1920 07062022154836 v3_A581' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1920 07062022154836 v3_A581' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1920 07062022154836 v3_A581.xlsx' exists in the Datafiles folder and UKPRN '10017581' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017581' for FundingType 'AEB' and period '1920' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017581' for FundingType 'AEB' and period '1920'

    # Check SoF and FA
    Then  the file named '10017581_[ContractNo]_v1.pdf' in Sharepoint location 'AEB-1920-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017581 Co Ltd UKPRN: 10017581
    Master Contract Number: ESFA-581
    Allocation
    1 August 2018 to 31 July 2019 Contract Ref Aug 18 - Mar 19 Apr 19 - Jul 19 Total
    Adult Education Budget - Traineeships and Other Learning AEBT-581 £24,526 £12,974 £37,500
    Total: £37,500
    Allocation
    1 August 2019 to 31 July 2020 Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 Total
    ESFA AEB - Adult Skills [AllocRef_AEBA] £35,377 £17,008 £52,385
    Total: £52,385
    Total Funding for this contract: £89,885
    
    Funding Agreement ESFA-Funded Adult Education Budget - Adult Skills
    Provider: 10017581 Co Ltd UKPRN: 10017581
    Master Contract Number: ESFA-581 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AEBA]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills £52,385 £4,887 £4,228 £2,477 £5,619 £4,143 £2,732 £4,855 £6,436 £3,803 £3,751 £1,797 £7,657
    Total Funding £52,385 £4,887 £4,228 £2,477 £5,619 £4,143 £2,732 £4,855 £6,436 £3,803 £3,751 £1,797 £7,657
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017581_[ContractNo]_v1.pdf' in 'AEB-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A581a.pdf'


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Withdrawn20231002
Scenario: A407 Live Bug: Create and approve short contract for AEB-AS2122 using just Envelope2. Bulk add a short contract for AEB-AS2223 using just Envelope1. Check docs

    # 1. Create and approve a 3mth 21/22 AEBP contract (01/05/2022 to 31/07/2022) envelope 2 only
    # 2. Bulk New Amendment to add a linked 5mth 22/23 contract (01/08/2022 to 31/12/2022) envelope 1 only
    # 3. Check SoF doc
    # 4. Approve 22/23
    # 5. Bulk variation amendment on 21/22 contract (no change to duration, just financials)
    # 6. Check SoF doc

    Given there are no allocations marked as Under Termination for UKPRN '10017407' 
    And   there are no terminated or closed allocations for UKPRN '10017407' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017407' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017407' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017407' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-407      |
    | NSF-407       |
    | STFI-407      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-407      |
    | NSF-407       |
    | STFI-407      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-AS2122        |
    | AEB-NSF2122       |
    | STFI2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP21-407     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017407'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017407' 
    And   there is no caseload advisor for UKPRN '10017407' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017407 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017407' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017407 Co Ltd' with UKPRN '10017407' and OrgId 'ORG0017407' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017407 | 117407 | 10017407 Co Ltd | 0              | Active                | Yes           | AA017407      | ?             | 32a Park Lane          | ?                      | ?                      | ?                      | Poynton                | Cheshire               | SK12 1RE  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017407 |





    # Change the date
    Given the override date is '01/04/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP21-407'
    And   there are no details in ContractManagement.CreatedContract for 'AEBP21-407'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017407 | 10017407 Co Ltd      | ESFA-407             | AEBP21-407     | 1                     | 01/05/2022        | 31/07/2022      | 36919.00      |                                       | Contract for Services                      | 2122   | New          | ORG0017407 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017407 | AEBP21-407     | AEBA-407      | AEB-AS            | AEB-AS2122              | AY                      | 01/05/2022          | 31/07/2022        | 8171.00         |                                         |            |                                                             | New          |             |
    | 10017407 | AEBP21-407     | NSF-407       | AEB-NSF           | AEB-NSF2122             | AY                      | 01/05/2022          | 31/07/2022        | 13769.00        |                                         |            |                                                             | New          |             |
    | 10017407 | AEBP21-407     | STFI-407      | STFI              | STFI2122                | AY                      | 01/05/2022          | 31/07/2022        | 14979.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017407 | AEBP21-407     | AEBA-407      | 1               | 0                     | 8171.00   | 4606.00  | 1869.00  | 1696.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017407 | AEBP21-407     | AEBA-407      | 4               | 1                     | 4495.00   | 3061.00  | 349.00   | 1085.00  | Adult Skills                                                    | New          |             | 
    | 10017407 | AEBP21-407     | AEBA-407      | 5               | 1                     | 3676.00   | 1545.00  | 1520.00  | 611.00   | Adult Skills Learner Support                                    | New          |             | 
    | 10017407 | AEBP21-407     | NSF-407       | 1               | 0                     | 13769.00  | 3763.00  | 3017.00  | 6989.00  | National Skills Fund Total Funding                              | New          |             | 
    | 10017407 | AEBP21-407     | NSF-407       | 2               | 1                     | 8590.00   | 3509.00  | 1745.00  | 3336.00  | Level 3 Offer for 24 year olds and over                         | New          |             | 
    | 10017407 | AEBP21-407     | NSF-407       | 5               | 1                     | 5179.00   | 254.00   | 1272.00  | 3653.00  | National Skills Fund Learner Support                            | New          |             | 
    | 10017407 | AEBP21-407     | STFI-407      | 1               | 0                     | 4362.00   | 792.00   | 3490.00  | 80.00    | Short Term Funding Initiative 1                                 | New          |             | 
    | 10017407 | AEBP21-407     | STFI-407      | 2               | 0                     | 1427.00   | 1100.00  | 255.00   | 72.00    | Short Term Funding Initiative 2                                 | New          |             | 
    | 10017407 | AEBP21-407     | STFI-407      | 3               | 0                     | 3445.00   | 2817.00  | 420.00   | 208.00   | Short Term Funding Initiative 3                                 | New          |             | 
    | 10017407 | AEBP21-407     | STFI-407      | 4               | 0                     | 5745.00   | 2762.00  | 617.00   | 2366.00  | Short Term Funding Initiative 4                                 | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP21-407     | 1                     | 0                        | 2022-04-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP21-407'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-407' and ContractNumber 'AEBP21-407' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP21-407' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017407 | AEBP21-407         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/05/2022        | 31/07/2022      | ?             |
    | 10017407 | ESFA-407           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2022        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP21-407' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables (32 x 3mths)
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'AEBP21-407'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AEBA-407        | 2372010          | Jul-22 | Reconciliation |
    | NSF-407         | 100942           | Jul-22 | Reconciliation |
    | STFI-407        | 2374010          | Jul-22 | Reconciliation |




    # Create a linked 22/23 contract and check docs

    # Change the date
    Given the override date is '23/07/2022'

    # Bulk file (New Amendment) Contract duration 5mths
    And   there are no files prefixed '10017407' in the Sharepoint 'AEB2021-2223-Input-Appendices' folder
    And   there are no files prefixed 'AEB2021 AY 2223 09062022120830 v3_A407' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB2021 AY 2223 09062022120830 v3_A407' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB2021 AY 2223 09062022120830 v3_A407' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB2021 AY 2223 09062022120830 v3_A407' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB2021 AY 2223 09062022120830 v3_A407.xlsx' exists in the Datafiles folder and UKPRN '10017407' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017407' for FundingType 'AEB2021' and period '2223'

    # Check the contents of the Appendices
    Then  the file named '10017407_[ContractNo]_v1.pdf' in Sharepoint location 'AEB2021-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017407 Co Ltd UKPRN: 10017407
    Master Contract Number: ESFA-407
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) AEBA-407 £0 £8,171 £8,171
    of which Learner Support £0 £3,676 £3,676
    ESFA AEB - National Skills Fund (procured from Aug 2021) NSF-407 £0 £13,769 £13,769
    of which Level 3 Offer for 24 year olds and over £0 £8,590 £8,590
    of which Learner Support £0 £5,179 £5,179
    ESFA AEB - Short Term Funding Initiatives (procured from
    STFI-407 £0 £14,979 £14,979
    Aug 2021)
    of which Short Term Funding Initiative 1 £0 £4,362 £4,362
    of which Short Term Funding Initiative 2 £0 £1,427 £1,427
    of which Short Term Funding Initiative 3 £0 £3,445 £3,445
    of which Short Term Funding Initiative 4 £0 £5,745 £5,745
    Total: £36,919

    Allocation
    1 August 2022 to 31 July 2023 Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) [AllocRef_AEBA] £45,840 £0 £45,840
    of which Learner Support £34,008 £0 £34,008
    ESFA AEB - National Skills Fund (procured from Aug 2021) [AllocRef_NSF] £56,167 £0 £56,167
    of which Level 3 Free Courses for Jobs £23,248 £0 £23,248
    of which Learner Support £32,919 £0 £32,919
    ESFA AEB - Short Term Funding Initiatives (procured from
    [AllocRef_STFI] £81,511 £0 £81,511
    Aug 2021)
    of which Short Term Funding Initiative 1 £18,767 £0 £18,767
    of which Short Term Funding Initiative 2 £23,480 £0 £23,480
    of which Short Term Funding Initiative 3 £19,149 £0 £19,149
    of which Short Term Funding Initiative 4 £20,115 £0 £20,115
    Total: £183,518

    Total Funding for this contract: £220,437
    Summary of Funding – Page 1
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-23 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017407_[ContractNo]_v1.pdf' in 'AEB2021-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A407.pdf'




    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'


    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017407 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/12/2022      | ?             |
    #
    | 10017407 | AEBP21-407         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/05/2022        | 31/07/2022      | ?             |
    | 10017407 | ESFA-407           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2022        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables (32 x 5mths)
    And   there are '160' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_AEBA] | 2372010          | Jul-22 | Reconciliation |
    | [AllocRef_NSF]  | 100942           | Jul-22 | Reconciliation |
    | [AllocRef_STFI] | 2374010          | Jul-22 | Reconciliation |





    # Amend the 21/22 contract and check docs again

    # Change the date
    Given the override date is '24/07/2022'

    # Bulk file (Variation Amendment)
    And   there are no files prefixed '10017407' in the Sharepoint 'AEB2021-2122-Input-Appendices' folder
    And   there are no files prefixed 'AEB2021 AY 2122 09062022133843 v3_A407' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB2021 AY 2122 09062022133843 v3_A407' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB2021 AY 2122 09062022133843 v3_A407' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB2021 AY 2122 09062022133843 v3_A407' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB2021 AY 2122 09062022133843 v3_A407.xlsx' exists in the Datafiles folder and UKPRN '10017407' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017407' for FundingType 'AEB2021' and period '2223'

    # Check the contents of the Appendices
    Then  the file named '10017407_AEBP21-407_v2.pdf' in Sharepoint location 'AEB2021-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017407 Co Ltd UKPRN: 10017407
    Master Contract Number: ESFA-407
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) AEBA-407 £0 £21,494 £21,494
    of which Learner Support £0 £13,167 £13,167
    ESFA AEB - National Skills Fund (procured from Aug 2021) NSF-407 £0 £21,027 £21,027
    of which Level 3 Offer for 24 year olds and over £0 £15,025 £15,025
    of which Learner Support £0 £6,002 £6,002
    ESFA AEB - Short Term Funding Initiatives (procured from
    STFI-407 £0 £68,436 £68,436
    Aug 2021)
    of which Short Term Funding Initiative 1 £0 £20,292 £20,292
    of which Short Term Funding Initiative 2 £0 £15,014 £15,014
    of which Short Term Funding Initiative 3 £0 £16,725 £16,725
    of which Short Term Funding Initiative 4 £0 £16,405 £16,405
    Total: £110,957

    Allocation
    1 August 2022 to 31 July 2023 Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) [AllocRef_AEBA] £45,840 £0 £45,840
    of which Learner Support £34,008 £0 £34,008
    ESFA AEB - National Skills Fund (procured from Aug 2021) [AllocRef_NSF] £56,167 £0 £56,167
    of which Level 3 Free Courses for Jobs £23,248 £0 £23,248
    of which Learner Support £32,919 £0 £32,919
    ESFA AEB - Short Term Funding Initiatives (procured from
    [AllocRef_STFI] £81,511 £0 £81,511
    Aug 2021)
    of which Short Term Funding Initiative 1 £18,767 £0 £18,767
    of which Short Term Funding Initiative 2 £23,480 £0 £23,480
    of which Short Term Funding Initiative 3 £19,149 £0 £19,149
    of which Short Term Funding Initiative 4 £20,115 £0 £20,115
    Total: £183,518

    Total Funding for this contract: £294,475
    Summary of Funding – Page 1
    """



    # Tidy Up
    Given the override date is reset

