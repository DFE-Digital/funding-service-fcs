Feature: NegativeActualVolumesESF 14972

@AcceptanceTest @Withdrawn20240103
Scenario: A444 Consume positive and negative DCFS-format actuals on an approved ESF contract. Vary and approve. Consume actuals again. Check actuals are carried forward to v2. Create payment files and check payment feed
    Given there are no allocations marked as Under Termination for UKPRN '10017444' 
    And   there are no terminated or closed allocations for UKPRN '10017444' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017444' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ESF-444       |
 



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017444' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017444 Co Ltd' with UKPRN '10017444' and OrgId 'ORG0017444' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017444' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017444 | 117444 | 10017444 Co Ltd | 0              | Active                | Yes           | AA017444      | ?             | 52 Park Street         | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 3PT  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017444 |

    


	# Create contract
	And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                           | Period | CRMIntent | OrgId      |
    | 10017444 | 10017444 Co Ltd      | ESFA-444             | ESIF-444       | 1                     |  01/04/2018       |  30/09/2018     | 57228.00      | Conditions of Funding (Grant) Employer | 1420   | New       | ORG0017444 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription      | CRMIntent | LEPName             | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference        | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType     |
    | 10017444 | ESIF-444       | ESF-444       | ESF 201420        | ESF                     | 01/04/2018          | 30/09/2018        | 57228.00        |         |         | Funding for the unemployed | New       | Gloucestershire LEP | E37011  | TSS_20125                    | 00-01        | 20125/23-413-00-01/10017444 | 1.4 Active Inclusion | 333\SD\7253     | Job seekers fund    | SSR                | Less Developed |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Apr-18   | May-18   | Jun-18  | Jul-18  | Aug-18   | Sep-18   | DeliverableDescription           | CRMIntent | 
    | ESIF-444       | ESF-444       | 1               | 0                     | 27       | 2484.00  | 432.00   | 945.00  | 1026.00 | 513.00   | 972.00   | ST01 Learner Assessment and Plan | New       | 
    | ESIF-444       | ESF-444       | 2               | 0                     |          | 1633.00  | 3878.00  | 1625.00 | 3791.00 | 3123.00  | 7724.00  | RQ01 Regulated Learning          | New       | 
    | ESIF-444       | ESF-444       | 3               | 0                     |          | 4241.00  | 1009.00  | 9643.00 | 1956.00 | 3390.00  | 1121.00  | NR01 Non Regulated Activity      | New       | 
    | ESIF-444       | ESF-444       | 4               | 0                     | 33       | 1782.00  | 594.00   | 528.00  | 1551.00 | 1749.00  | 1518.00  | FS01 Additional Programme Cost   | New       | 

    And   the draft contract deliverable volume details are as follows 
    | ContractNumber | DeliverableCode | AllocationRef | Apr-18 | May-18 | Jun-18 | Jul-18 | Aug-18 | Sep-18 |
    | ESIF-444       | 1               | ESF-444       | 92     | 16     | 35     | 38     | 19     | 36     |
    | ESIF-444       | 4               | ESF-444       | 54     | 18     | 16     | 47     | 53     | 46     |

    And   the contract exists in CRM
	# Contract status is now at 'Awaiting Documentation'

    And   the latest version of contract 'ESIF-444' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '20/03/2018'

	# Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-444' and actual ContractNumber 'ESIF-444'

    # Check that the contract is now approved
    Then  the latest version of contract 'ESIF-444' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017444 | ESIF-444           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2018        | 30/09/2018      | ?             |
    | 10017444 | ESFA-444           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2018        | 30/09/2018      | ?             |

#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef | Subnominal Code  | Period | Payment Type   |
#    | ESF-444       | 2671114          | Sep-18 | Reconciliation |
#    | ESF-444       | 2671114          | Sep-18 | Capping        |




    # Change the date
    Given the override date is '06/05/2018'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Clear down PaaS summarised actuals before the first pull of actuals
    And   there are no entries in the summarised actuals PaaS table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

	# Pull actuals from DC for Apr 2018
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | ESF            | ESF09                | ORG0017444     | CM             | 201804 | ESF1420                 | ESF-444                  |         | 1               | -29          | -1682       | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201805 | ESF1420                 | ESF-444                  |         | 1               | 5            | 290         | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201806 | ESF1420                 | ESF-444                  |         | 1               | 30           | 1740        | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201807 | ESF1420                 | ESF-444                  |         | 1               | 38           | 2204        | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201808 | ESF1420                 | ESF-444                  |         | 1               | 30           | 1740        | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201809 | ESF1420                 | ESF-444                  |         | 1               | 94           | 5452        | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201804 | ESF1420                 | ESF-444                  |         | 2               | 0            | 4214        | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201805 | ESF1420                 | ESF-444                  |         | 2               | 0            | 1720        | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201806 | ESF1420                 | ESF-444                  |         | 2               | 0            | 1204        | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201807 | ESF1420                 | ESF-444                  |         | 2               | 0            | 688         | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201808 | ESF1420                 | ESF-444                  |         | 2               | 0            | 731         | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201809 | ESF1420                 | ESF-444                  |         | 2               | 0            | 2795        | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201804 | ESF1420                 | ESF-444                  |         | 3               | 0            | 1763        | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201805 | ESF1420                 | ESF-444                  |         | 3               | 0            | 1763        | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201806 | ESF1420                 | ESF-444                  |         | 3               | 0            | 3053        | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201807 | ESF1420                 | ESF-444                  |         | 3               | 0            | 1419        | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201808 | ESF1420                 | ESF-444                  |         | 3               | 0            | 2709        | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201809 | ESF1420                 | ESF-444                  |         | 3               | 0            | 903         | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201804 | ESF1420                 | ESF-444                  |         | 4               | 19           | 703         | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201805 | ESF1420                 | ESF-444                  |         | 4               | 58           | 2146        | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201806 | ESF1420                 | ESF-444                  |         | 4               | 8            | 296         | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201807 | ESF1420                 | ESF-444                  |         | 4               | 46           | 1702        | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201808 | ESF1420                 | ESF-444                  |         | 4               | 90           | 3330        | 
    | ESF            | ESF09                | ORG0017444     | CM             | 201809 | ESF1420                 | ESF-444                  |         | 4               | 26           | 962         | 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check actuals Value in CRM
    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-444       | ESF-444       | 1               | -1682.00 | ?        | ?        | ?        | ?        | ?        |
    | ESIF-444       | ESF-444       | 2               | 4214.00  | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-444       | ESF-444       | 3               | 1763.00  | ?        | ?        | ?        | ?        | ?        |
    | ESIF-444       | ESF-444       | 4               | 703.00   | ?        | ?        | ?        | ?        | ?        |

	# Check actuals Volume in CRM
    And   the Actuals Volume Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | 
    | ESIF-444       | ESF-444       | 1               | -29      | ?        | ?        | ?        | ?        | ?        |
    | ESIF-444       | ESF-444       | 4               | 19       | ?        | ?        | ?        | ?        | ?        |




    # Change the date
    Given the override date is '06/06/2018'

	# Clear down the stub
    And   there are no entries in the DCFS stub table

	# Pull actuals from DC for May 2018
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | ESF            | ESF10                | ORG0017444     | CM             | 201804 | ESF1420                 | ESF-444                  |         | 1               | 78           | 4524        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201805 | ESF1420                 | ESF-444                  |         | 1               | 38           | 2204        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201806 | ESF1420                 | ESF-444                  |         | 1               | 29           | 1682        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201807 | ESF1420                 | ESF-444                  |         | 1               | 92           | 5336        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201808 | ESF1420                 | ESF-444                  |         | 1               | 63           | 3654        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201809 | ESF1420                 | ESF-444                  |         | 1               | 63           | 3654        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201804 | ESF1420                 | ESF-444                  |         | 2               | 0            | 1849        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201805 | ESF1420                 | ESF-444                  |         | 2               | 0            | 430         | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201806 | ESF1420                 | ESF-444                  |         | 2               | 0            | 2408        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201807 | ESF1420                 | ESF-444                  |         | 2               | 0            | 2967        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201808 | ESF1420                 | ESF-444                  |         | 2               | 0            | 3913        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201809 | ESF1420                 | ESF-444                  |         | 2               | 0            | 3569        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201804 | ESF1420                 | ESF-444                  |         | 3               | 0            | 129         | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201805 | ESF1420                 | ESF-444                  |         | 3               | 0            | 2322        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201806 | ESF1420                 | ESF-444                  |         | 3               | 0            | 3913        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201807 | ESF1420                 | ESF-444                  |         | 3               | 0            | 1849        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201808 | ESF1420                 | ESF-444                  |         | 3               | 0            | 2924        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201809 | ESF1420                 | ESF-444                  |         | 3               | 0            | 2150        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201804 | ESF1420                 | ESF-444                  |         | 4               | 51           | 1887        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201805 | ESF1420                 | ESF-444                  |         | 4               | -46          | -1702       | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201806 | ESF1420                 | ESF-444                  |         | 4               | 35           | 1295        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201807 | ESF1420                 | ESF-444                  |         | 4               | 41           | 1517        | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201808 | ESF1420                 | ESF-444                  |         | 4               | 27           | 999         | 
    | ESF            | ESF10                | ORG0017444     | CM             | 201809 | ESF1420                 | ESF-444                  |         | 4               | 6            | 222         | 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-444       | ESF-444       | 1               | 4524.00  | 2204.00  | ?        | ?        | ?        | ?        |
    | ESIF-444       | ESF-444       | 2               | 1849.00  | 430.00   | ?        | ?        | ?        | ?        | 
    | ESIF-444       | ESF-444       | 3               | 129.00   | 2322.00  | ?        | ?        | ?        | ?        |
    | ESIF-444       | ESF-444       | 4               | 1887.00  | -1702.00 | ?        | ?        | ?        | ?        |

    And   the Actuals Volume Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | 
    | ESIF-444       | ESF-444       | 1               | 78       | 38       | ?        | ?        | ?        | ?        |
    | ESIF-444       | ESF-444       | 4               | 51       | -46      | ?        | ?        | ?        | ?        |

    And   the override date is reset




    # Create contract v2
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                           | Period | CRMIntent | OrgId      |
    | 10017444 | 10017444 Co Ltd      | ESFA-444             | ESIF-444       | 2                     |  01/04/2018       |  30/09/2018     | 57228.00      | Conditions of Funding (Grant) Employer | 1420   | Amendment | ORG0017444 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription      | CRMIntent | LEPName             | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference        | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType     |
    | 10017444 | ESIF-444       | ESF-444       | ESF 201420        | ESF                     | 01/04/2018          | 30/09/2018        | 57228.00        |         |         | Funding for the unemployed | Amendment | Gloucestershire LEP | E37011  | TSS_20125                    | 00-01        | 20125/23-413-00-01/10017444 | 1.5 CLLD             | 333\SD\7253     | Job seekers fund    | SSR                | Transition     |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Apr-18   | May-18   | Jun-18  | Jul-18  | Aug-18   | Sep-18   | DeliverableDescription           | CRMIntent |
    | ESIF-444       | ESF-444       | 1               | 0                     | 27       | 2484.00  | 432.00   | 945.00  | 1026.00 | 513.00   | 972.00   | ST01 Learner Assessment and Plan | Amendment | 
    | ESIF-444       | ESF-444       | 2               | 0                     |          | 1633.00  | 3878.00  | 1625.00 | 3791.00 | 3123.00  | 7724.00  | RQ01 Regulated Learning          | Amendment | 
    | ESIF-444       | ESF-444       | 3               | 0                     |          | 4241.00  | 1009.00  | 9643.00 | 1956.00 | 3390.00  | 1121.00  | NR01 Non Regulated Activity      | Amendment | 
    | ESIF-444       | ESF-444       | 4               | 0                     | 33       | 1782.00  | 594.00   | 528.00  | 1551.00 | 1749.00  | 1518.00  | FS01 Additional Programme Cost   | Amendment | 

    And   the draft contract deliverable volume details are as follows 
    | ContractNumber | DeliverableCode | AllocationRef | Apr-18 | May-18 | Jun-18 | Jul-18 | Aug-18 | Sep-18 | 
    | ESIF-444       | 1               | ESF-444       | 92     | 16     | 35     | 38     | 19     | 36     | 
    | ESIF-444       | 4               | ESF-444       | 54     | 18     | 16     | 47     | 53     | 46     | 
	
    And   the amended contract exists in CRM
    And   the latest version of contract 'ESIF-444' is in a state of 'Published to Provider'
    And   the override date is '16/06/2018'
    And   the latest version of contract 'ESIF-444' is approved
    And   the status and sub-status of the latest version of contract 'ESIF-444' are changed to 'Approved'
    And   the latest version of contract 'ESIF-444' is marked as the last approved version




    # Change the date
    Given the override date is '06/07/2018'

	# Clear down the stub
    And   there are no entries in the DCFS stub table

    # Pull actuals from DC for June 2018
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | ESF            | ESF11                | ORG0017444     | CM             | 201804 | ESF1420                 | ESF-444                  |         | 1               | 25           | 1450        | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201805 | ESF1420                 | ESF-444                  |         | 1               | 97           | 5626        | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201806 | ESF1420                 | ESF-444                  |         | 1               | 7            | 406         | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201807 | ESF1420                 | ESF-444                  |         | 1               | 39           | 2262        | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201808 | ESF1420                 | ESF-444                  |         | 1               | 37           | 2146        | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201809 | ESF1420                 | ESF-444                  |         | 1               | 49           | 2842        | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201804 | ESF1420                 | ESF-444                  |         | 2               | 0            | 688         | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201805 | ESF1420                 | ESF-444                  |         | 2               | 0            | 2021        | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201806 | ESF1420                 | ESF-444                  |         | 2               | 0            | 1118        | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201807 | ESF1420                 | ESF-444                  |         | 2               | 0            | 2709        | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201808 | ESF1420                 | ESF-444                  |         | 2               | 0            | 2322        | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201809 | ESF1420                 | ESF-444                  |         | 2               | 0            | 688         | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201804 | ESF1420                 | ESF-444                  |         | 3               | 0            | 3999        | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201805 | ESF1420                 | ESF-444                  |         | 3               | 0            | 2795        | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201806 | ESF1420                 | ESF-444                  |         | 3               | 0            | 2193        | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201807 | ESF1420                 | ESF-444                  |         | 3               | 0            | 1677        | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201808 | ESF1420                 | ESF-444                  |         | 3               | 0            | 473         | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201809 | ESF1420                 | ESF-444                  |         | 3               | 0            | 3354        | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201804 | ESF1420                 | ESF-444                  |         | 4               | 46           | 1702        | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201805 | ESF1420                 | ESF-444                  |         | 4               | 75           | 2775        | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201806 | ESF1420                 | ESF-444                  |         | 4               | 60           | 2220        | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201807 | ESF1420                 | ESF-444                  |         | 4               | 83           | 3071        | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201808 | ESF1420                 | ESF-444                  |         | 4               | 2            | 74          | 
    | ESF            | ESF11                | ORG0017444     | CM             | 201809 | ESF1420                 | ESF-444                  |         | 4               | 21           | 777         | 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-444       | ESF-444       | 1               | 1450.00  | 5626.00  | 406.00   | ?        | ?        | ?        |
    | ESIF-444       | ESF-444       | 2               | 688.00   | 2021.00  | 1118.00  | ?        | ?        | ?        | 
    | ESIF-444       | ESF-444       | 3               | 3999.00  | 2795.00  | 2193.00  | ?        | ?        | ?        |
    | ESIF-444       | ESF-444       | 4               | 1702.00  | 2775.00  | 2220.00  | ?        | ?        | ?        |

    And   the Actuals Volume Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | 
    | ESIF-444       | ESF-444       | 1               | 25       | 97       | 7        | ?        | ?        | ?        |
    | ESIF-444       | ESF-444       | 4               | 46       | 75       | 60       | ?        | ?        | ?        |




    # Change the date
    Given the override date is '06/08/2018'

	# Clear down the stub
    And   there are no entries in the DCFS stub table

    # DCFS Summarised Actuals for July 2018
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | ESF            | ESF12                | ORG0017444     | CM             | 201804 | ESF1420                 | ESF-444                  |         | 1               | 8            | 464         | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201805 | ESF1420                 | ESF-444                  |         | 1               | 11           | 638         | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201806 | ESF1420                 | ESF-444                  |         | 1               | 33           | 1914        | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201807 | ESF1420                 | ESF-444                  |         | 1               | 13           | 754         | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201808 | ESF1420                 | ESF-444                  |         | 1               | 1            | 58          | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201809 | ESF1420                 | ESF-444                  |         | 1               | 54           | 3132        | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201804 | ESF1420                 | ESF-444                  |         | 2               | 0            | 2838        | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201805 | ESF1420                 | ESF-444                  |         | 2               | 0            | 2322        | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201806 | ESF1420                 | ESF-444                  |         | 2               | 0            | 3526        | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201807 | ESF1420                 | ESF-444                  |         | 2               | 0            | 387         | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201808 | ESF1420                 | ESF-444                  |         | 2               | 0            | 860         | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201809 | ESF1420                 | ESF-444                  |         | 2               | 0            | 2924        | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201804 | ESF1420                 | ESF-444                  |         | 3               | 0            | 1935        | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201805 | ESF1420                 | ESF-444                  |         | 3               | 0            | 1548        | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201806 | ESF1420                 | ESF-444                  |         | 3               | 0            | 645         | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201807 | ESF1420                 | ESF-444                  |         | 3               | 0            | 3010        | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201808 | ESF1420                 | ESF-444                  |         | 3               | 0            | 3956        | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201809 | ESF1420                 | ESF-444                  |         | 3               | 0            | 2279        | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201804 | ESF1420                 | ESF-444                  |         | 4               | -9           | -333        | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201805 | ESF1420                 | ESF-444                  |         | 4               | -76          | -2812       | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201806 | ESF1420                 | ESF-444                  |         | 4               | -40          | -1480       | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201807 | ESF1420                 | ESF-444                  |         | 4               | 46           | 1702        | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201808 | ESF1420                 | ESF-444                  |         | 4               | 49           | 1813        | 
    | ESF            | ESF12                | ORG0017444     | CM             | 201809 | ESF1420                 | ESF-444                  |         | 4               | 21           | 777         | 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-444       | ESF-444       | 1               | 3770.00  | 464.00   | 638.00   | 1914.00  | 754.00   | ?        | ?        |
    | ESIF-444       | ESF-444       | 2               | 9073.00  | 2838.00  | 2322.00  | 3526.00  | 387.00   | ?        | ?        | 
    | ESIF-444       | ESF-444       | 3               | 7138.00  | 1935.00  | 1548.00  | 645.00   | 3010.00  | ?        | ?        |
    | ESIF-444       | ESF-444       | 4               | -2923.00 | -333.00  | -2812.00 | -1480.00 | 1702.00  | ?        | ?        |

    And   the Actuals Volume Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | Total  | Apr-18 | May-18 | Jun-18 | Jul-18 | Aug-18 | Sep-18 |
    | ESIF-444       | ESF-444       | 1               | 65     | 8      | 11     | 33     | 13     | ?      | ?      |
    | ESIF-444       | ESF-444       | 2               | 0      | 0      | 0      | 0      | 0      | ?      | ?      |
    | ESIF-444       | ESF-444       | 3               | 0      | 0      | 0      | 0      | 0      | ?      | ?      |
	| ESIF-444       | ESF-444       | 4               | -79    | -9     | -76    | -40    | 46     | ?      | ?      |

	# Check the ACTUAL totals in CRM at deliverable level rather than deliverable period level have been carried forward to the approved v2 (20222)
    And   the Actuals Data is stored in CRM at deliverable level against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | ActualValue | ActualVolume |
    | ESIF-444       | ESF-444       | 1               | 3770.00     | 65           | 
    | ESIF-444       | ESF-444       | 2               | 9073.00     | 0            |  
    | ESIF-444       | ESF-444       | 3               | 7138.00     | 0            | 
    | ESIF-444       | ESF-444       | 4               | -2923.00    | -79          | 




    # Change the date
    Given the override date is '07/08/2018 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ESF1420' PaymentPeriod '201804' CensusEndDate '07/08/2018' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaaS. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | ESF-444                  | 201807 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ESF1420                    | 201807               |                      | A              | NotStarted |

#    # Coda.AccountCode
#    And   the following configuration exists in the Account Codes table
#    | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#    | 10017444 | ESF1420                    | CODA444   | 8115000      | 01/08/1990           | 31/08/2020         |
    
    When  the Payment Generation Batch run is started

#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | ESF1420                    | 201807               | Completed |
#
#    # File created in Maytech FTP folder for 'European Social Fund 2014-20'
#    And   Payment file 'ESFC20180407A.pay' is created in the FTP Folder
#
#    # Decrypt the payment file to the Output window and save a decrypted version to Datafiles/Downloads
#    Given there is an encrypted file called 'ESFC20180407A.pay' in the Maytech FTP folder decrypt it then save it to 'DataFiles/Downloads'
#
#	# Note: Only actuals for July appear in the payment file
#    Then  the following details are present in payment file 'ESFC20180407A.pay'
#    | LinkCode    | CompanyCode | Element1 | Element2 | Element3 | Element4 | Element5 | Element6   | Element7 | Element8 | Year | Period | Date       | Amount   | Dc   | LineType | Doc     | Desc                            | DueDate    | Tax | Extref1                       | Extref2     | Extref3      | Extref4 | Extref5  | Extref6 | Num   | DocLineNo |
#    | ESFC180407A | SFA         | E37011   | +        | 8115000  | CODA444  | 02       | ESF-444    | ?        | ?        | 2018 | 04     | 07/08/2018 | 8825.00  | 161  | 157      | ESFCR   | ESF1420 IP1.4LessDev Rec Aug18  | 24/08/2018 | ?   | ESF RECONCILIATION 2014/23    | ESFC180407A | 333\SD\7253  | ?       | 10017444 | 2671114 | 1     | 1         |
#    | ESFC180407A | SFA         | E37011   | +        | 2671114  | 5000     | 02       | ESF-444    | ?        | ?        | 2018 | 04     | 07/08/2018 | 8825.00  | 160  | 158      | ESFCR   | ESF1420 IP1.4LessDev Rec Aug18  | 24/08/2018 | VIO | ESF RECONCILIATION 2014/23    | ESFC180407A | 333\SD\7253  | ?       | 10017444 | CODA444 | 1     | 2         |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    Then  the Payment feed xml for FundingStreamPeriod 'ESF1420' PaymentPeriod '201804' CensusEndDate '07/08/2018' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A444.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ESF1420' PaymentPeriod '201804' CensusEndDate '07/08/2018' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | ESFC                   | 2018          | 04             | 07          | E37011  | ESF-444       | -8825.00        | RECONCILIATION   | ESF1420 IP1.4LessDev               | 2018-08-24 | 2014-08-01   | 2023-12-31 | 333\SD\7253    | 10017444 | 2671114    |


	# Tidy up
    And   the override date is reset

