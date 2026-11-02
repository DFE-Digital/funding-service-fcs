Feature: Pay50percentOverDeliveryOnAEB-CSO2021 35417

@AcceptanceTest @Withdrawn20231002
Scenario: A730 Create and approve a 2021 AEB contract with AEB-CSO2021 alloc. Consume actuals and cap in both envelopes. Check financials. Amend and check financials
    Given there are no allocations marked as Under Termination for UKPRN '10017730' 
    And   there are no terminated or closed allocations for UKPRN '10017730' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017730' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017730' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017730' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AESO-730      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AESO-730      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-CSO2021       |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP-730       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017730'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017730' 
    And   there is no caseload advisor for UKPRN '10017730' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017730 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017730' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017730 Co Ltd' with UKPRN '10017730' and OrgId 'ORG0017730' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017730 | 117730 | 10017730 Co Ltd | 0              | In Administration     | Yes           | AA017730      | ?             | 14 Daisy Way           | High Lane              | ?                      | ?                      | Stockport              | Cheshire               | SK6 8EF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017730 |





    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP-730'
    And   there are no details in ContractManagement.CreatedContract for 'AEBP-730'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017730 | 10017730 Co Ltd      | ESFA-730             | AEBP-730       | 1                     | 01/08/2020        | 31/07/2021      | 46778.00      |                                       | Procured                                   | 2021   | New          | ORG0017730 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017730 | AEBP-730       | AESO-730      | AEB-CSO           | AEB-CSO2021             | AY                      | 01/08/2020          | 31/07/2021        | 46778.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017730 | AEBP-730       | AESO-730      | 1               | 0                     | 46778.00  | 31028.00  | 15750.00  | 2513.00  | 3986.00  | 5235.00  | 6169.00  | 3368.00  | 2404.00  | 2577.00  | 4776.00  | 1881.00  | 5883.00  | 5962.00  | 2024.00  | COVID-19 Skills Offer Total Funding                             | New          |             | 
    | 10017730 | AEBP-730       | AESO-730      | 2               | 1                     | 29181.00  | 21226.00  | 7955.00   | 2143.00  | 3290.00  | 3551.00  | 3749.00  | 3156.00  | 1234.00  | 2316.00  | 1787.00  | 656.00   | 3067.00  | 3235.00  | 997.00   | High Value Courses for School and College Leavers Funding       | New          |             | 
    | 10017730 | AEBP-730       | AESO-730      | 5               | 1                     | 17597.00  | 9802.00   | 7795.00   | 370.00   | 696.00   | 1684.00  | 2420.00  | 212.00   | 1170.00  | 261.00   | 2989.00  | 1225.00  | 2816.00  | 2727.00  | 1027.00  | National Skills Fund Level 3 Offer for 24 year old and over     | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-730'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-730' and actual ContractNumber 'AEBP-730'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-730' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017730 | AEBP-730           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017730 | ESFA-730           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP-730' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'AEBP-730'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AESO-730        | 2372092          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10017730 | AEBP-730       | 1               | AESO-730      | 1               | 0                     | 46778.00     | 0             | 0        | COVID-19 Skills Offer Total Funding                             | ?                                                           |
    | 10017730 | AEBP-730       | 1               | AESO-730      | 2               | 1                     | 29181.00     | 0             | 0        | High Value Courses for School and College Leavers Funding       | ?                                                           |
    | 10017730 | AEBP-730       | 1               | AESO-730      | 5               | 1                     | 17597.00     | 0             | 0        | National Skills Fund Level 3 Offer for 24 year old and over     | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP-730' agree with the most recent entry for this contract in the ContractManagement feed






    # Add actuals to the contract for February 2021

    # Change the date
    Given the override date is '04/03/2021'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017730'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Feb 2021
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202008 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 3523.72     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202008 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 2000.51     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202009 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 3048.45     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202009 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 1282.15     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202010 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 3011.04     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202010 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 3846.91     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202011 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 3334.23     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202011 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 1699.96     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202012 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 1682.17     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202012 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 2809.81     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202101 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 1266.56     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202101 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 3189.82     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202102 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 3102.01     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202102 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 2632.08     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202103 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 2304.38     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202103 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 2312.45     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202104 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 2775.86     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202104 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 4235.29     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202105 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 2370.47     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202105 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 3236.99     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202106 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 3383.83     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202106 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 2016.61     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202107 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 6960.86     |
    | ILR2021        | R07                  | ORG0017730     | CM             | 202107 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 4412.84     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-730       | AESO-730           | 1               | 46778.00  | 2513.00  | 3986.00  | 5235.00  | 6169.00  | 3368.00  | 2404.00  | 2577.00  | 4776.00  | 1881.00  | 5883.00  | 5962.00  | 2024.00  | 
    | AEBP-730       | AESO-730           | 2               | 29181.00  | 2143.00  | 3290.00  | 3551.00  | 3749.00  | 3156.00  | 1234.00  | 2316.00  | 1787.00  | 656.00   | 3067.00  | 3235.00  | 997.00   | 
    | AEBP-730       | AESO-730           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 5               | 17597.00  | 370.00   | 696.00   | 1684.00  | 2420.00  | 212.00   | 1170.00  | 261.00   | 2989.00  | 1225.00  | 2816.00  | 2727.00  | 1027.00  | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-730       | AESO-730           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-730       | AESO-730           | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-730       | AESO-730           | 3               | 18968.18  | 3523.72  | 3048.45  | 3011.04  | 3334.23  | 1682.17  | 1266.56  | 3102.01  | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-730       | AESO-730           | 4               | 17461.24  | 2000.51  | 1282.15  | 3846.91  | 1699.96  | 2809.81  | 3189.82  | 2632.08  | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-730       | AESO-730           | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-730       | AESO-730           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 3               | 18968.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 18968.18 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 4               | 17461.24  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 17461.24 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-730       | AESO-730           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 3               | -2812.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2812.43 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 4               | -2588.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2588.99 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-730       | AESO-730           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 3               | 16155.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16155.75 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 4               | 14872.25  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14872.25 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '60' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '60' deliverable period rows in CRM linked to the latest version of contract 'AEBP-730'





    # Add actuals to the contract for July 2021

    # Change the date
    Given the override date is '04/08/2021'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017730'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jul 2021
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202008 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 3523.72     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202008 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 2000.51     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202009 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 3048.45     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202009 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 1282.15     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202010 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 3011.04     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202010 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 3846.91     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202011 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 3334.23     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202011 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 1699.96     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202012 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 1682.17     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202012 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 2809.81     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202101 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 1266.56     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202101 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 3189.82     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202102 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 3102.01     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202102 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 2632.08     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202103 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 2304.38     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202103 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 2312.45     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202104 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 2775.86     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202104 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 4235.29     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202105 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 2370.47     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202105 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 3236.99     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202106 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 3383.83     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202106 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 2016.61     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202107 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 6960.86     |
    | ILR2021        | R12                  | ORG0017730     | CM             | 202107 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 4412.84     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-730       | AESO-730           | 1               | 46778.00  | 2513.00  | 3986.00  | 5235.00  | 6169.00  | 3368.00  | 2404.00  | 2577.00  | 4776.00  | 1881.00  | 5883.00  | 5962.00  | 2024.00  | 
    | AEBP-730       | AESO-730           | 2               | 29181.00  | 2143.00  | 3290.00  | 3551.00  | 3749.00  | 3156.00  | 1234.00  | 2316.00  | 1787.00  | 656.00   | 3067.00  | 3235.00  | 997.00   | 
    | AEBP-730       | AESO-730           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 5               | 17597.00  | 370.00   | 696.00   | 1684.00  | 2420.00  | 212.00   | 1170.00  | 261.00   | 2989.00  | 1225.00  | 2816.00  | 2727.00  | 1027.00  | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-730       | AESO-730           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-730       | AESO-730           | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-730       | AESO-730           | 3               | 36763.58  | 3523.72  | 3048.45  | 3011.04  | 3334.23  | 1682.17  | 1266.56  | 3102.01  | 2304.38  | 2775.86  | 2370.47  | 3383.83  | 6960.86  | 
    | AEBP-730       | AESO-730           | 4               | 33675.42  | 2000.51  | 1282.15  | 3846.91  | 1699.96  | 2809.81  | 3189.82  | 2632.08  | 2312.45  | 4235.29  | 3236.99  | 2016.61  | 4412.84  | 
    | AEBP-730       | AESO-730           | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-730       | AESO-730           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 3               | 39576.01  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 18968.18 | 0.00     | 0.00     | 0.00     | 0.00     | 20607.83 | 
    | AEBP-730       | AESO-730           | 4               | 36264.41  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 17461.24 | 0.00     | 0.00     | 0.00     | 0.00     | 18803.17 | 
    | AEBP-730       | AESO-730           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21    |
    | AEBP-730       | AESO-730           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | AEBP-730       | AESO-730           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | AEBP-730       | AESO-730           | 3               | -15194.68 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2812.43 | 0.00     | 0.00     | 0.00     | 0.00     | -12382.25 | 
    | AEBP-730       | AESO-730           | 4               | -13867.74 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2588.99 | 0.00     | 0.00     | 0.00     | 0.00     | -11278.75 | 
    | AEBP-730       | AESO-730           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-730       | AESO-730           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 3               | 24381.33  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16155.75 | 0.00     | 0.00     | 0.00     | 0.00     | 8225.58  | 
    | AEBP-730       | AESO-730           | 4               | 22396.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14872.25 | 0.00     | 0.00     | 0.00     | 0.00     | 7524.42  | 
    | AEBP-730       | AESO-730           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '60' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '60' deliverable period rows in CRM linked to the latest version of contract 'AEBP-730'





    # Add actuals to the contract for September 2021 (R14)

    # Change the date
    Given the override date is '18/10/2021'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017730'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2021
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202008 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 3523.72     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202008 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 2000.51     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202009 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 3048.45     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202009 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 1282.15     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202010 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 3011.04     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202010 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 3846.91     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202011 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 3334.23     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202011 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 1699.96     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202012 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 1682.17     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202012 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 2809.81     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202101 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 1266.56     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202101 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 3189.82     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202102 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 3102.01     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202102 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 2632.08     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202103 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 2304.38     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202103 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 2312.45     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202104 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 2775.86     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202104 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 4235.29     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202105 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 2370.47     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202105 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 3236.99     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202106 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 3383.83     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202106 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 2016.61     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202107 | AEB-CSO2021             | AESO-730                 | ?          | 3               | 0            | 6960.86     |
    | ILR2021        | R14                  | ORG0017730     | CM             | 202107 | AEB-CSO2021             | AESO-730                 | ?          | 4               | 0            | 4412.84     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   |
    | AEBP-730       | AESO-730           | 1               | 46778.00  | 2513.00  | 3986.00  | 5235.00  | 6169.00  | 3368.00  | 2404.00  | 2577.00  | 4776.00  | 1881.00  | 5883.00  | 5962.00  | 2024.00  | ?        | 
    | AEBP-730       | AESO-730           | 2               | 29181.00  | 2143.00  | 3290.00  | 3551.00  | 3749.00  | 3156.00  | 1234.00  | 2316.00  | 1787.00  | 656.00   | 3067.00  | 3235.00  | 997.00   | ?        | 
    | AEBP-730       | AESO-730           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | AEBP-730       | AESO-730           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | AEBP-730       | AESO-730           | 5               | 17597.00  | 370.00   | 696.00   | 1684.00  | 2420.00  | 212.00   | 1170.00  | 261.00   | 2989.00  | 1225.00  | 2816.00  | 2727.00  | 1027.00  | ?        | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   |
    | AEBP-730       | AESO-730           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-730       | AESO-730           | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-730       | AESO-730           | 3               | 36763.58  | 3523.72  | 3048.45  | 3011.04  | 3334.23  | 1682.17  | 1266.56  | 3102.01  | 2304.38  | 2775.86  | 2370.47  | 3383.83  | 6960.86  | ?        | 
    | AEBP-730       | AESO-730           | 4               | 33675.42  | 2000.51  | 1282.15  | 3846.91  | 1699.96  | 2809.81  | 3189.82  | 2632.08  | 2312.45  | 4235.29  | 3236.99  | 2016.61  | 4412.84  | ?        | 
    | AEBP-730       | AESO-730           | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   |
    | AEBP-730       | AESO-730           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 3               | 51958.26  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 18968.18 | 0.00     | 0.00     | 0.00     | 0.00     | 20607.83 | 12382.25 | 
    | AEBP-730       | AESO-730           | 4               | 47543.16  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 17461.24 | 0.00     | 0.00     | 0.00     | 0.00     | 18803.17 | 11278.75 | 
    | AEBP-730       | AESO-730           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21    | Oct-21   |
    | AEBP-730       | AESO-730           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 
    | AEBP-730       | AESO-730           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 
    | AEBP-730       | AESO-730           | 3               | -15336.64 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2812.43 | 0.00     | 0.00     | 0.00     | 0.00     | -12382.25 | -141.96  | 
    | AEBP-730       | AESO-730           | 4               | -13997.78 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2588.99 | 0.00     | 0.00     | 0.00     | 0.00     | -11278.75 | -130.04  | 
    | AEBP-730       | AESO-730           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   |
    | AEBP-730       | AESO-730           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 3               | 36621.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16155.75 | 0.00     | 0.00     | 0.00     | 0.00     | 8225.58  | 12240.29 | 
    | AEBP-730       | AESO-730           | 4               | 33545.38  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14872.25 | 0.00     | 0.00     | 0.00     | 0.00     | 7524.42  | 11148.71 | 
    | AEBP-730       | AESO-730           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '65' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '65' deliverable period rows in CRM linked to the latest version of contract 'AEBP-730'





    # Amend contract adding £100 to each of d2 and d5

    # Change the date
    Given the override date is '15/11/2021'

    # Bulk file
    And   there are no files prefixed '10017730' in the Sharepoint 'AEB-2021-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 2021 11102021151536 v3_A730' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 2021 11102021151536 v3_A730' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 2021 11102021151536 v3_A730' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 2021 11102021151536 v3_A730' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 2021 11102021151536 v3_A730.xlsx' exists in the Datafiles folder and UKPRN '10017730' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-730'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-730' and actual ContractNumber 'AEBP-730'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-730' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017730 | AEBP-730           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017730 | AEBP-730           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017730 | ESFA-730           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'AEBP-730' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '70' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '70' deliverable period rows in CRM linked to the latest version of contract 'AEBP-730'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AESO-730        | 2372092          | Nov-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription    | 
    | 10017730 | AEBP-730       | 2               | AESO-730      | 1               | 0                     | 46978.00     | 0             | 0        | COVID-19 Skills Offer Total Funding                             | ?                         |
    | 10017730 | AEBP-730       | 2               | AESO-730      | 2               | 1                     | 29281.00     | 0             | 0        | High Value Courses for School and College Leavers Funding       | ?                         |
    | 10017730 | AEBP-730       | 2               | AESO-730      | 5               | 1                     | 17697.00     | 0             | 0        | National Skills Fund Level 3 Offer for 24 year old and over     | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'AEBP-730' agree with the most recent entry for this contract in the ContractManagement feed


    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   | Nov-21   |
    | AEBP-730       | AESO-730           | 1               | 46978.00  | 2513.00  | 3986.00  | 5235.00  | 6169.00  | 3368.00  | 2404.00  | 2577.00  | 4776.00  | 1881.00  | 5883.00  | 5962.00  | 2224.00  | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 2               | 29281.00  | 2143.00  | 3290.00  | 3551.00  | 3749.00  | 3156.00  | 1234.00  | 2316.00  | 1787.00  | 656.00   | 3067.00  | 3235.00  | 1097.00  | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 5               | 17697.00  | 370.00   | 696.00   | 1684.00  | 2420.00  | 212.00   | 1170.00  | 261.00   | 2989.00  | 1225.00  | 2816.00  | 2727.00  | 1127.00  | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   | Nov-21   |
    | AEBP-730       | AESO-730           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-730       | AESO-730           | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-730       | AESO-730           | 3               | 36763.58  | 3523.72  | 3048.45  | 3011.04  | 3334.23  | 1682.17  | 1266.56  | 3102.01  | 2304.38  | 2775.86  | 2370.47  | 3383.83  | 6960.86  | ?        | ?        | 
    | AEBP-730       | AESO-730           | 4               | 33675.42  | 2000.51  | 1282.15  | 3846.91  | 1699.96  | 2809.81  | 3189.82  | 2632.08  | 2312.45  | 4235.29  | 3236.99  | 2016.61  | 4412.84  | ?        | ?        | 
    | AEBP-730       | AESO-730           | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   | Nov-21   |
    | AEBP-730       | AESO-730           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 3               | 52100.22  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 18968.18 | 0.00     | 0.00     | 0.00     | 0.00     | 20607.83 | 12382.25 | 141.96   | 
    | AEBP-730       | AESO-730           | 4               | 47673.20  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 17461.24 | 0.00     | 0.00     | 0.00     | 0.00     | 18803.17 | 11278.75 | 130.04   | 
    | AEBP-730       | AESO-730           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   | Nov-21   |
    | AEBP-730       | AESO-730           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 3               | -15336.64 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2812.43 | 0.00     | 0.00     | 0.00     | 0.00     | -12382.25| -141.96  | 0.00     | 
    | AEBP-730       | AESO-730           | 4               | -13997.78 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2588.99 | 0.00     | 0.00     | 0.00     | 0.00     | -11278.75| -130.04  | 0.00     | 
    | AEBP-730       | AESO-730           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | Oct-21   | Nov-21   |
    | AEBP-730       | AESO-730           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-730       | AESO-730           | 3               | 36763.58  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16155.75 | 0.00     | 0.00     | 0.00     | 0.00     | 8225.58  | 12240.29 | 141.96   | 
    | AEBP-730       | AESO-730           | 4               | 33675.42  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14872.25 | 0.00     | 0.00     | 0.00     | 0.00     | 7524.42  | 11148.71 | 130.04   | 
    | AEBP-730       | AESO-730           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Tidy Up
 #   Given the override date is reset
  
