Feature: Extend1920AEBPactivity 35001

@AcceptanceTest @Withdrawn20230118
Scenario: A405 Create and approve a 1920 AEB contract. Cap. Amend in Sep-21. Increase AEB-PRS funding and match-reduce AEB-19TRN and AEB-AS funding. Check financials and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017405' 
    And   there are no terminated or closed allocations for UKPRN '10017405' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017405' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017405' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017405' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-405      |
    | AEBR-405      |
    | AERS-405      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-405      |
    | AEBR-405      |
    | AERS-405      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-19TRN1920     |
    | AEB-AS1920        |
    | AEB-PRS1920       |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP-405       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017405'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017405' 
    And   there is no caseload advisor for UKPRN '10017405' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017405 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017405' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017405 Co Ltd' with UKPRN '10017405' and OrgId 'ORG0017405' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017405 | 117405 | 10017405 Co Ltd | 0              | Provider Under Change | Yes           | AA017405      | ?             | 1a Chapeltown          | Pudsey                 | ?                      | ?                      | Leeds                  | West Yorkshire         | LS28 7RZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017405 |





    # Change the date
    Given the override date is '01/07/2019'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP-405'
    And   there are no details in ContractManagement.CreatedContract for 'AEBP-405'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017405 | 10017405 Co Ltd      | ESFA-405             | AEBP-405       | 1                     | 01/08/2019        | 31/07/2020      | 99359.00      |                                       | Procured                                   | 1920   | New          | ORG0017405 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017405 | AEBP-405       | AEBA-405      | AEB-AS            | AEB-AS1920              | AY                      | 01/08/2019          | 31/07/2020        | 27594.00        |                                         |            |                                                             | New          |             |
    | 10017405 | AEBP-405       | AEBR-405      | AEB-19TRN         | AEB-19TRN1920           | AY                      | 01/08/2019          | 31/07/2020        | 25103.00        |                                         |            |                                                             | New          |             |
    | 10017405 | AEBP-405       | AERS-405      | AEB-PRS           | AEB-PRS1920             | AY                      | 01/08/2019          | 31/07/2020        | 46662.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017405 | AEBP-405       | AEBA-405      | 1               | 0                     | 27594.00  | 17536.00  | 10058.00  | 4470.00  | 1459.00  | 2195.00  | 969.00   | 945.00   | 3736.00  | 2763.00  | 999.00   | 2590.00  | 3484.00  | 801.00   | 3183.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017405 | AEBP-405       | AEBR-405      | 1               | 0                     | 25103.00  | 18242.00  | 6861.00   | 3149.00  | 2146.00  | 2438.00  | 580.00   | 3436.00  | 3253.00  | 2818.00  | 422.00   | 209.00   | 1830.00  | 3387.00  | 1435.00  | 19-24 Traineeships Total Funding                                | New          |             | 
    | 10017405 | AEBP-405       | AERS-405      | 1               | 0                     | 21531.00  | 14377.00  | 7154.00   | 1454.00  | 1177.00  | 2007.00  | 2235.00  | 3287.00  | 1113.00  | 1216.00  | 1888.00  | 2590.00  | 2220.00  | 614.00   | 1730.00  | AEB Provider Relief Scheme 1 (April to June 2020)               | New          |             | 
    | 10017405 | AEBP-405       | AERS-405      | 2               | 0                     | 25131.00  | 16700.00  | 8431.00   | 2664.00  | 396.00   | 1764.00  | 1359.00  | 608.00   | 2862.00  | 3504.00  | 3543.00  | 3425.00  | 79.00    | 2713.00  | 2214.00  | AEB Provider Relief Scheme 2 (July 2020)                        | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP-405       | 1                     | 0                        | 2019-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-405'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-405' and actual ContractNumber 'AEBP-405'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-405' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017405 | AEBP-405           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017405 | ESFA-405           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP-405' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'AEBP-405'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AEBR-405        | 2355800          | Jul-20 | Reconciliation |
    | AEBA-405        | 2372010          | Jul-20 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '4' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                     | DeliverableDescription    | 
    | 10017405 | AEBP-405       | 1               | AEBA-405      | 1               | 0                     | 27594.00     | 0             | 0        | Adult Skills Total Funding                          | ?                         |
    | 10017405 | AEBP-405       | 1               | AEBR-405      | 1               | 0                     | 25103.00     | 0             | 0        | 19-24 Traineeships Total Funding                    | ?                         |
    | 10017405 | AEBP-405       | 1               | AERS-405      | 1               | 0                     | 21531.00     | 0             | 0        | AEB Provider Relief Scheme 1 (April to June 2020)   | ?                         |
    | 10017405 | AEBP-405       | 1               | AERS-405      | 2               | 0                     | 25131.00     | 0             | 0        | AEB Provider Relief Scheme 2 (July 2020)            | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP-405' agree with the most recent entry for this contract in the ContractManagement feed





    # Add actuals to the contract

    # Change the date
    Given the override date is '04/08/2020'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017405'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jul 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201908 | AEB-19TRN1920           | AEBR-405                 | ?          | 2               | 0            | 1524.32     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201908 | AEB-19TRN1920           | AEBR-405                 | ?          | 3               | 0            | 207.27      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201909 | AEB-19TRN1920           | AEBR-405                 | ?          | 2               | 0            | 1366.74     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201909 | AEB-19TRN1920           | AEBR-405                 | ?          | 3               | 0            | 657.17      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201910 | AEB-19TRN1920           | AEBR-405                 | ?          | 2               | 0            | 798.03      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201910 | AEB-19TRN1920           | AEBR-405                 | ?          | 3               | 0            | 1482.73     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201911 | AEB-19TRN1920           | AEBR-405                 | ?          | 2               | 0            | 2275.51     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201911 | AEB-19TRN1920           | AEBR-405                 | ?          | 3               | 0            | 2250.34     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201912 | AEB-19TRN1920           | AEBR-405                 | ?          | 2               | 0            | 2485.18     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201912 | AEB-19TRN1920           | AEBR-405                 | ?          | 3               | 0            | 646.44      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202001 | AEB-19TRN1920           | AEBR-405                 | ?          | 2               | 0            | 1034.00     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202001 | AEB-19TRN1920           | AEBR-405                 | ?          | 3               | 0            | 950.94      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202002 | AEB-19TRN1920           | AEBR-405                 | ?          | 2               | 0            | 880.05      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202002 | AEB-19TRN1920           | AEBR-405                 | ?          | 3               | 0            | 896.69      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202003 | AEB-19TRN1920           | AEBR-405                 | ?          | 2               | 0            | 1003.59     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202003 | AEB-19TRN1920           | AEBR-405                 | ?          | 3               | 0            | 1506.17     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202004 | AEB-19TRN1920           | AEBR-405                 | ?          | 2               | 0            | 547.40      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202004 | AEB-19TRN1920           | AEBR-405                 | ?          | 3               | 0            | 1120.55     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202005 | AEB-19TRN1920           | AEBR-405                 | ?          | 2               | 0            | 1979.32     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202005 | AEB-19TRN1920           | AEBR-405                 | ?          | 3               | 0            | 462.11      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202006 | AEB-19TRN1920           | AEBR-405                 | ?          | 2               | 0            | 655.17      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202006 | AEB-19TRN1920           | AEBR-405                 | ?          | 3               | 0            | 1995.41     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202007 | AEB-19TRN1920           | AEBR-405                 | ?          | 2               | 0            | 485.24      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202007 | AEB-19TRN1920           | AEBR-405                 | ?          | 3               | 0            | 2077.87     |
    #
    | ILR1920        | R12                  | ORG0017405     | CM             | 201908 | AEB-AS1920              | AEBA-405                 | ?          | 2               | 0            | 732.35      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201908 | AEB-AS1920              | AEBA-405                 | ?          | 3               | 0            | 2215.56     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201909 | AEB-AS1920              | AEBA-405                 | ?          | 2               | 0            | 1094.73     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201909 | AEB-AS1920              | AEBA-405                 | ?          | 3               | 0            | 1164.57     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201910 | AEB-AS1920              | AEBA-405                 | ?          | 2               | 0            | 1251.76     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201910 | AEB-AS1920              | AEBA-405                 | ?          | 3               | 0            | 1543.76     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201911 | AEB-AS1920              | AEBA-405                 | ?          | 2               | 0            | 975.78      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201911 | AEB-AS1920              | AEBA-405                 | ?          | 3               | 0            | 2149.47     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201912 | AEB-AS1920              | AEBA-405                 | ?          | 2               | 0            | 1137.91     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 201912 | AEB-AS1920              | AEBA-405                 | ?          | 3               | 0            | 2287.78     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202001 | AEB-AS1920              | AEBA-405                 | ?          | 2               | 0            | 261.34      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202001 | AEB-AS1920              | AEBA-405                 | ?          | 3               | 0            | 864.99      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202002 | AEB-AS1920              | AEBA-405                 | ?          | 2               | 0            | 1999.77     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202002 | AEB-AS1920              | AEBA-405                 | ?          | 3               | 0            | 801.96      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202003 | AEB-AS1920              | AEBA-405                 | ?          | 2               | 0            | 1844.59     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202003 | AEB-AS1920              | AEBA-405                 | ?          | 3               | 0            | 462.80      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202004 | AEB-AS1920              | AEBA-405                 | ?          | 2               | 0            | 2388.57     |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202004 | AEB-AS1920              | AEBA-405                 | ?          | 3               | 0            | 513.80      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202005 | AEB-AS1920              | AEBA-405                 | ?          | 2               | 0            | 599.30      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202005 | AEB-AS1920              | AEBA-405                 | ?          | 3               | 0            | 552.88      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202006 | AEB-AS1920              | AEBA-405                 | ?          | 2               | 0            | 980.66      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202006 | AEB-AS1920              | AEBA-405                 | ?          | 3               | 0            | 375.53      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202007 | AEB-AS1920              | AEBA-405                 | ?          | 2               | 0            | 525.12      |
    | ILR1920        | R12                  | ORG0017405     | CM             | 202007 | AEB-AS1920              | AEBA-405                 | ?          | 3               | 0            | 1567.55     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


    # Check CRM and PaaS

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-405       | AEBA-405           | 1               | 27594.00  | 4470.00  | 1459.00  | 2195.00  | 969.00   | 945.00   | 3736.00  | 2763.00  | 999.00   | 2590.00  | 3484.00  | 801.00   | 3183.00  | 
    | AEBP-405       | AEBA-405           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-405       | AEBA-405           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-405       | AEBR-405           | 1               | 25103.00  | 3149.00  | 2146.00  | 2438.00  | 580.00   | 3436.00  | 3253.00  | 2818.00  | 422.00   | 209.00   | 1830.00  | 3387.00  | 1435.00  | 
    | AEBP-405       | AEBR-405           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-405       | AEBR-405           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-405       | AERS-405           | 1               | 21531.00  | 1454.00  | 1177.00  | 2007.00  | 2235.00  | 3287.00  | 1113.00  | 1216.00  | 1888.00  | 2590.00  | 2220.00  | 614.00   | 1730.00  | 
    | AEBP-405       | AERS-405           | 2               | 25131.00  | 2664.00  | 396.00   | 1764.00  | 1359.00  | 608.00   | 2862.00  | 3504.00  | 3543.00  | 3425.00  | 79.00    | 2713.00  | 2214.00  | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-405       | AEBA-405           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-405       | AEBA-405           | 2               | 13791.88  | 732.35   | 1094.73  | 1251.76  | 975.78   | 1137.91  | 261.34   | 1999.77  | 1844.59  | 2388.57  | 599.30   | 980.66   | 525.12   | 
    | AEBP-405       | AEBA-405           | 3               | 14500.65  | 2215.56  | 1164.57  | 1543.76  | 2149.47  | 2287.78  | 864.99   | 801.96   | 462.80   | 513.80   | 552.88   | 375.53   | 1567.55  | 
    #
    | AEBP-405       | AEBR-405           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-405       | AEBR-405           | 2               | 15034.55  | 1524.32  | 1366.74  | 798.03   | 2275.51  | 2485.18  | 1034.00  | 880.05   | 1003.59  | 547.40   | 1979.32  | 655.17   | 485.24   | 
    | AEBP-405       | AEBR-405           | 3               | 14253.69  | 207.27   | 657.17   | 1482.73  | 2250.34  | 646.44   | 950.94   | 896.69   | 1506.17  | 1120.55  | 462.11   | 1995.41  | 2077.87  | 
    #
    | AEBP-405       | AERS-405           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-405       | AERS-405           | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-405       | AEBA-405           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-405       | AEBA-405           | 2               | 13791.88  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13791.88 | 
    | AEBP-405       | AEBA-405           | 3               | 14500.65  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14500.65 | 
    #
    | AEBP-405       | AEBR-405           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-405       | AEBR-405           | 2               | 15034.55  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 15034.55 | 
    | AEBP-405       | AEBR-405           | 3               | 14253.69  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14253.69 | 
    #
    | AEBP-405       | AERS-405           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-405       | AERS-405           | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-405       | AEBA-405           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-405       | AEBA-405           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-405       | AEBA-405           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP-405       | AEBR-405           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-405       | AEBR-405           | 2               | -859.80   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -859.80  | 
    | AEBP-405       | AEBR-405           | 3               | -815.14   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -815.14  | 
    #
    | AEBP-405       | AERS-405           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-405       | AERS-405           | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | AEBP-405       | AEBA-405           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-405       | AEBA-405           | 2               | 13791.88  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13791.88 | 
    | AEBP-405       | AEBA-405           | 3               | 14500.65  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14500.65 | 
    #
    | AEBP-405       | AEBR-405           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-405       | AEBR-405           | 2               | 14174.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14174.75 | 
    | AEBP-405       | AEBR-405           | 3               | 13438.55  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13438.55 | 
    #
    | AEBP-405       | AERS-405           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-405       | AERS-405           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 





    # Amend contract. Increase profile on AEB-PRS d2 by £5,000. Reduce profile on AEB-19TRN by £3,000. Reduce profile on AEB-AS by £2,000

    # Change the date
    Given the override date is '08/09/2021'

    # Bulk amendment
    And   there are no files prefixed '10017405' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1920 23082021175820 v3_A405' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 1920 23082021175820 v3_A405' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1920 23082021175820 v3_A405' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1920 23082021175820 v3_A405' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1920 23082021175820 v3_A405.xlsx' exists in the Datafiles folder and UKPRN '10017405' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017405' for FundingType 'AEB' and period '1920' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017405' for FundingType 'AEB' and period '1920'

    # Check the contents of the Appendices
   #Then  the file named '10017405_[ContractNo]_v2.pdf' in Sharepoint location 'AEB-1920-Input-Appendices' contains the following lines in order
    Then  the file named '10017405_AEBP-405_v2.pdf' in Sharepoint location 'AEB-1920-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017405 Co Ltd UKPRN: 10017405
    Master Contract Number: ESFA-405
    Allocation
    1 August 2019 to 31 July 2020 Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 Total
    ESFA AEB - 19 to 24 Traineeships AEBR-405 £9,231 £12,872 £22,103
    ESFA AEB - Adult Skills AEBA-405 £15,073 £10,521 £25,594
    ESFA AEB - Provider Relief Schemes AEBA-405 £38,938 £12,724 £51,662
    of which Provider Relief Scheme 1 (April to June 2020) £14,377 £7,154 £21,531
    of which Provider Relief Scheme 2 (July 2020) £24,561 £5,570 £30,131
    Total: £99,359
    Total Funding for this contract: £99,359
    
    Funding Agreement ESFA-Funded Adult Education Budget - 19 to 24 Traineeships
    Provider: 10017405 Co Ltd UKPRN: 10017405
    Master Contract Number: ESFA-405 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: AEBR-405
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - 19 to 24 Traineeships £22,103 £964 £306 £2,005 £1,528 £222 £760 £932 £2,514 £1,532 £1,779 £5,826 £3,735
    Total Funding £22,103 £964 £306 £2,005 £1,528 £222 £760 £932 £2,514 £1,532 £1,779 £5,826 £3,735
    Ref (for internal use only):  AEBP-405 v2
    Page 1 of 1 of this Funding Agreement
    
    Funding Agreement ESFA-Funded Adult Education Budget - Adult Skills
    Provider: 10017405 Co Ltd UKPRN: 10017405
    Master Contract Number: ESFA-405 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: AEBA-405
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills £25,594 £571 £988 £909 £546 £5,262 £2,927 £1,472 £2,398 £2,407 £591 £308 £7,215
    Total Funding £25,594 £571 £988 £909 £546 £5,262 £2,927 £1,472 £2,398 £2,407 £591 £308 £7,215
    Ref (for internal use only):  AEBP-405 v2
    Page 1 of 1 of this Funding Agreement
    
    Funding Agreement ESFA-Funded Adult Education Budget - Provider Relief Schemes
    Provider: 10017405 Co Ltd UKPRN: 10017405
    Master Contract Number: ESFA-405 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: AEBA-405
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Provider Relief Scheme 1 (April to June £21,531 £1,454 £1,177 £2,007 £2,235 £3,287 £1,113 £1,216 £1,888 £2,590 £2,220 £614 £1,730
    2020)
    ESFA AEB - Provider Relief Scheme 2 (July 2020) £30,131 £7,695 £1,252 £2,500 £2,350 £749 £1,615 £2,717 £5,683 £813 £3,199 £89 £1,469
    Total Funding £51,662 £9,149 £2,429 £4,507 £4,585 £4,036 £2,728 £3,933 £7,571 £3,403 £5,419 £703 £3,199
    Ref (for internal use only):  AEBP-405 v2
    Page 1 of 1 of this Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   #And   Sharepoint file '10017405_AEBP-405_v2.pdf' in 'AEB-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A405_v2.pdf'

    # Display Sharepoint filename
    And   message '10017405_AEBP-405_v2.pdf' is written to the Output window




@AcceptanceTest @Withdrawn20230118
Scenario: A406
    Given there are no allocations marked as Under Termination for UKPRN '10017406' 
    And   there are no terminated or closed allocations for UKPRN '10017406' 
    Given there is no Funding Allocation Workflow History data in CRM for UKPRN '10017406'
    And   there is no Funding Allocation data in CRM for UKPRN '10017406'
    And   there is no Contract, Task or Workflow data for UKPRN '10017406' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017406' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017406' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16ED-406      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16ED-406      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 1619ED2122        |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-406       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017406'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017406' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017406 Co Ltd' with UKPRN '10017406' and OrgId 'ORG0017406' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017406' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017406 | 117406 | 10017406 Co Ltd | 0              | Provider Under Change | Yes           | AA017406      | ?             | 26 The Forbury         | ?                      | ?                      | ?                      | Reading                | Berkshire              | RG1 3EJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017406 |





    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-406'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-406'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                   | Period | CRMIntent    | OrgId      |
    | 10017406 | 10017406 Co Ltd      | ESFA-406             | EDSK-406       | 1                     | 01/08/2021        | 31/07/2022      | 13614.38      |                                       | Contract for Services (ITP)    | 2122   | New          | ORG0017406 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017406 | EDSK-406       | 16ED-406      | 1619ED            | 1619ED2122              | AY                      | 01/08/2021          | 31/07/2022        | 13614.38        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017406 | EDSK-406       | 16ED-406      | 149             | 0                     | 6990.97   | 6848.44   | 142.53    | 0.00     | 0.00     | 0.00     | 2579.89  | 3046.75  | 659.40   | 562.40   | 0.00     | 0.00     | 0.00     | 0.00     | 142.53   | 16-19 High Value Courses School and College Leavers Uplift      | New          |             | 
    | 10017406 | EDSK-406       | 16ED-406      | 151             | 0                     | 6623.41   | 6623.41   | 0.00      | 0.00     | 1000.66  | 1326.55  | 2874.16  | 0.00     | 1422.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | SSF High Value Courses School and College Leavers Uplift        | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'



    # Populate the stub with 1619 (02IPP) data

    # Change the date 
    Given the override date is '02/07/2021'

    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
    And   there is no data in the CFS stub
    And   there is no data in the Funding Allocation PaaS tables
    
    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile (J126)
    And   there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                 |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)  |

    # Funding Allocation 
    And   the following Funding Allocation data is in the CFS stub
    | groupingReason | UKPRN    | FundingId                                             | FundingVersion | AllocationFundingStreamCode | AllocationPeriodId | TotalFundingValue |
    | Contracting    | 10017406 | 1619-AS-2122-Contract-Provider-10017406-2_5           | 2_5            | 1619                        | AS-2122            | 24033.00          |
 
    # Provider Funding Allocation
    And   the following Provider Funding Agreement data is present in the CFS stub
    | ProviderFundingId          | ProviderFundingVersion | FundingId                                             | DeliveryUKPRN | ProviderType | ProviderSubType | ProviderFundingTotalValue |
    | 1619-AS-2122-10017406-2_5  | 2_5                    | 1619-AS-2122-Contract-Provider-10017406-2_5           | 10017406      | Furth        | 02IPP           | 24033.00                  |
 
    # Funding Allocation Line (aka Deliverable)
    And   the following Funding Allocation Line data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | FundingLineValue | FundingLineType |
    | 1619-AS-2122-10017406-2_5  | 1619-010        | 24033.00         | Payment         |
 
    # Funding Allocation Profile Period
    And   the following Funding Allocation Profile Period data is present in the CFS stub
    | ProviderFundingId          | FundingLineCode | DistributionPeriodId | ProfilePeriodTypeValue | ProfilePeriodYear | ProfilePeriodProfileValue |
    | 1619-AS-2122-10017406-2_5  | 1619-010        | FY-2122              | August                 | 2021              | 5808.00                   |
    | 1619-AS-2122-10017406-2_5  | 1619-010        | FY-2122              | December               | 2021              | 3115.00                   |
    | 1619-AS-2122-10017406-2_5  | 1619-010        | FY-2122              | February               | 2022              | 4253.00                   |
    | 1619-AS-2122-10017406-2_5  | 1619-010        | FY-2122              | May                    | 2022              | 5904.00                   |
    | 1619-AS-2122-10017406-2_5  | 1619-010        | FY-2122              | June                   | 2022              | 4953.00                   |
 
 
 
 
 
    # Consume stub data
 
    # Change the date 
    Given the override date is '05/07/2021'

    # Read stub and process into CRM
    When  the feed-reading process is started and the CFS stub data is processed into CRM

    # Capture the Release Group parameter value (J127)
   #Given the Release Groups for the following Contracting Profiles have been saved
    Given the Release Group for the following Contracting Profile has been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2122        | 16-19ED2122  | Contract for Services (ITP)             | CfS_ITP                   |

    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup      |
    | 10017406 | 10017406 Co Ltd  | 1619-AS-2122-Contract-Provider-10017406-2_5             | 2_5            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Scheduling        | Awaiting Release  | 24033.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         | [CfS_ITP]         |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017406-2_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check the state of a Release Group in CRM (J129)
    And   Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 1               | 24033.00        |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017406 | 1619-AS-2122-Contract-Provider-10017406-2_5             | 2_5            | AS-2122 | 1619                        | 24033.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'AwaitingRelease'





    # Release a Release Group (32953)

    # Change the date 
    Given the override date is '08/07/2021'

    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the following Release Groups together
    When  a request is triggered to release the following Release Group
    | ReleaseGroup      |
    | [CfS_ITP]         |

    # Write the following values to the output window
    And   message 'ReleaseGroup CfS_ITP = [CfS_ITP]' is written to the Output window

    # Check the state of a Release Group (J129)  (The count and value are unchanged)
    Then  Release Group '[CfS_ITP]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Released          | 1               | 24033.00        |

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017406' for FundingType 'EDSK' and period '2122'
   #When  I retrieve the latest EFA contract details from CRM for provider '10017406' for FundingType 'EDSK' and period '2122' and Delivery Organisation '?' 

    # Check the CRM Funding Allocations data (J125) Contract No and version added and Status\Substatus updated
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                | ReleaseGroup    |
    | 10017406 | 10017406 Co Ltd  | 1619-AS-2122-Contract-Provider-10017406-2_5             | 2_5            | Education & Skills Funding | AY2122  | Contract for Services (ITP)              | 1619                        | 16-19ED2122     | Released          | Released          | 24033.00    | [ContractNo]  | 1                 | CRM Integration       | CRMDeploy CRMDeploy   | ?                         | [CfS_ITP]       |

    # Check the CRM Funding Allocation Workflow History data
    And   the following Funding Allocation Workflow History data is present in CRM
    | FundingId                                               | Action                          | CompletedBy       | NewStatus          | NewSubStatus                    | PreviousStatus | PreviousSubStatus               | Comment                       |
    | 1619-AS-2122-Contract-Provider-10017406-2_5             | Release Successful              | CRM Integration   | Released           | Released                        | Scheduling     | Awaiting Release                | ?                             |
    | 1619-AS-2122-Contract-Provider-10017406-2_5             | Record Imported                 | CRM Integration   | Scheduling         | Awaiting Release                | ?              | ?                               | ?                             |

    # Check PaaS FundingAllocation.FundingAllocation (J131)
    And   the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                               | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup    | Status            | SubStatus                         |
    | 10017406 | 1619-AS-2122-Contract-Provider-10017406-2_5             | 2_5            | AS-2122 | 1619                        | 24033.00    | [CfS_ITP]       | ?                 | ?                                 |

    # Check PaaS FundingAllocation.Contract
    And   the following Funding Allocations and Contracts are linked in PaaS
    | FundingId                                               | ContractNo   | ContractVersion | ContractSubVersion | IsCreatedInCrm |
    | 1619-AS-2122-Contract-Provider-10017406-2_5             | [ContractNo] | 1               | 1                  | Yes            |

    # Check PaaS FundingAllocation.ReleaseGroup
    And   Release Group '[CfS_ITP]' in FundingAllocation.ReleaseGroup has a status of 'Released'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017406 | [ContractNo]       | 1                     | 1                        | Draft            | Awaiting Documentation                   | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017406 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the Contract and Master Contract have been created correctly in CRM
    And   the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType                            | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation |
    | 10017406 | [ContractNo]       | Education & Skills Funding             | Contract      | Draft          | Awaiting Documentation  | 37647.38      | 1                     | 1                        | 01/08/2021        | 31/07/2022      | True          | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2122 | ?               | 10017406 Co Ltd  | Active | Document Management Team  | ?                      |
    | 10017406 | [MasterContractNo] | Education & Skills Funding             | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2021        | 31/07/2022      | False         | False               | ?             | Contract for Services (ITP)               | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017406 Co Ltd  | Active | CRM Integration           | ?                      |

    # Check that the Contract Allocations have been created correctly in CRM
    And   the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017406 | [ContractNo]       | [AllocRef_16ED]       | ?                             | 37647.38        | ?             | ?                | 01/08/2021 | 31/07/2022 | 1619ED        | 1619ED2122          | Contract Allocation   | ?                        |

    # Check that the Contract Deliverables and Deliverable Periods have been created correctly in CRM
    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableName                                               | DeliverableDescription   |
    | EDSK-406       | 16ED-406           | 125             | 24033.00  | 5808.00  | 0.00     | 0.00     | 0.00     | 3115.00  | 0.00     | 4253.00  | 0.00     | 0.00     | 5904.00  | 4953.00  | 0.00     | Teacher's Pension Scheme 1619                                 |                          |
    | EDSK-406       | 16ED-406           | 149             | 6990.97   | 0.00     | 0.00     | 0.00     | 2579.89  | 3046.75  | 659.40   | 562.40   | 0.00     | 0.00     | 0.00     | 0.00     | 142.53   | 16-19 High Value Courses School and College Leavers Uplift    |                          |
    | EDSK-406       | 16ED-406           | 151             | 6623.41   | 0.00     | 1000.66  | 1326.55  | 2874.16  | 0.00     | 1422.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | SSF High Value Courses School and College Leavers Uplift      |                          |
    
    # Contract status is now at 'Awaiting Documentation' 



