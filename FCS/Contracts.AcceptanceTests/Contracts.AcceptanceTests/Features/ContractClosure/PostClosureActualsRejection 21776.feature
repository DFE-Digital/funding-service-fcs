Feature: PostClosureActualsRejection 21776

@AcceptanceTest @Withdrawn20230118
@ContractClosure
Scenario: A838 Create and approve an ESF1420 contract. Successfully request and approve contract closure. Consume but reject DCFS format actuals. Check CRM and PaaS
    Given there is no Contract, Task or Workflow data for UKPRN '10017838' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    And   there is no data in the PerformanceManagement.ContractAllocation or ContractAllocationDeliverable tables for the following providers 
    | UKPRN    | 
    | 10017838 | 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ESF-838       |

    # Change the date 
    And   the override date is '16/07/2017' 

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017838' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017838 Co Ltd' with UKPRN '10017838' and OrgId 'ORG0017838' and has 'FCS1 Test' as a manager 
    And   UPIN '117838' is associated with UKPRN '10017838' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017838 | 117838 | 10017838 Co Ltd | 0              | Active | Yes           | AA017838      | ?             | 

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017838 | 10017838 Co Ltd      | ESFA-838             | ESIF-838       | 1                     | 01/08/2017        | 31/07/2018      | 58053.00      | Contract for Services | 1420   | New          | ORG0017838 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName  | UoPCode  | AllocationDescription | CRMIntent  | LEPName                           | LEPCode | LotReference | TenderSpecificationReference | TenderAwardReference          | InvestmentPriority    | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017838 | ESIF-838       | ESF-838       | ESF 201420        | ESF                     | 01/08/2017          | 31/07/2018        | 58053.00        |          |          |                       | New        | Leicester and Leicestershire LEP  | E37021  | 00-1         | TSS_20125                    | 20125/23-415-00-1/10017838    | 1.4 Active Inclusion  | 777\SD\7838     | Job Seekers Fund    | SSR                | Transition     | 1.07                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription       | CRMIntent    | DeliveryOrg |
    | 10017838 | ESIF-838       | ESF-838       | 2               | 0                     |          | 29175.00  | 5000.00  | 132.00   | 1278.00  | 462.00   | 650.00   | 3046.00  | 2355.00  | 662.00   | 4709.00  | 2769.00  | 4527.00  | 3585.00  | RQ01 Regulated Learning      | New          |             |
    | 10017838 | ESIF-838       | ESF-838       | 3               | 0                     |          | 28878.00  | 509.00   | 1167.00  | 4080.00  | 2736.00  | 2155.00  | 2003.00  | 787.00   | 21.00    | 3230.00  | 3949.00  | 3273.00  | 4968.00  | NR01 Non Regulated Activity  | New          |             |

    And   the contract exists in CRM 
    # Contract status is now at 'Awaiting Documentation' 

    ## Check that the deliverables have all been created in CRM
    #Then   there are '24' deliverable periods in CRM linked to the latest version of contract 'ESIF-838' and allocation 'ESF-838'
 
    # Publish the contract 
    And   the latest version of contract 'ESIF-838' is in a state of 'Published to Provider' 
 
    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-838' and actual ContractNumber 'ESIF-838' 
 
    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017838 | ESIF-838           | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017838 | ESFA-838           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017838 | ESIF-838           | 1                     | ESF-838       | 01/08/2017          | 31/07/2018        |

    ## Check that the deliverables count has not changed in CRM
    #And    there are '24' deliverable periods in CRM linked to the latest version of contract 'ESIF-838' and allocation 'ESF-838'

    # Check Atom feed data for an ItemType zero (Approval) message. (Essentially just waiting for the payment schedule to be persisted)
    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version '1' of actual contract number 'ESIF-838'
    And   the ItemType '0' event for version '1' of actual contract number 'ESIF-838' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Check the ADP feed for a category 0 (new approval) messages. (Essentially just waiting for the payment schedule to be persisted)
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events 
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | AllocationNumber | ContractVersionNumber |
    | NewContractAllocationApproved     | 0      | ESIF-838       | ESF-838          | 1                     | 
	



    # Change the date 
    And   the override date is '12/08/2018' 

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract 'ESIF-838' for provider '10017838'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017838 | ESIF-838           | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017838 | ESFA-838           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017838 | ESIF-838           | 1                     | ESF-838       | 01/08/2017          | 31/07/2018        |
 
    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract 'ESIF-838' for provider '10017838'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017838 - 10017838 Co Ltd | ESIF-838  | FCS1 Test | Contract Managers Team | Open  | Not Started |
    
    # Check the WORKFLOW HISTORY
    And   the workflow history on contract 'ESIF-838' version '1' includes the following
    | Action                        | CompletedBy     | Comment                        |
    | Closure Initiation Successful | CRM Integration | ?                              |
    | Initiate Contract Closure     | FCS2 Test       | ?                              | 




    # Change the date 
    And   the override date is '03/08/2018' 

    # Approve closure of the contract. This should succeed
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract 'ESIF-838' for provider '10017838'
   #When  a request is raised by Manager 'FCS1 Test' to Reject Closure of version '1' of contract 'ESIF-838' for provider '10017838'

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract 'ESIF-838' for provider '10017838'
    | Task                     | Description                | Regarding | Owner      | Assigned Team          | State     | Status    |
    | Confirm Closure Approval | 10017838 - 10017838 Co Ltd | ESIF-838  | FCS1 Test | Contract Managers Team | Completed | Completed |

    # Check CONTRACT version, status and dates in CRM. The contract end date should have been set
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017838 | ESIF-838           | 1                     | 0                        | Closed           | Closed                    | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017838 | ESFA-838           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM. The allocation end date should have been set
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017838 | ESIF-838       | 1                     | ESF-838       | 01/08/2017          | 31/07/2018        |

    # Check the WORKFLOW HISTORY
    And   the workflow history on contract 'ESIF-838' version '1' includes the following
    | Action                        | CompletedBy      | Comment                       | 
    | Contract Closure Successful   | CRM Integration  | ?                             | 
    | Approve Closure               | FCS1 Test        | ?                             | 
    | Closure Initiation Successful | CRM Integration  | ?                             | 
    | Initiate Contract Closure     | FCS2 Test        | ?                             | 

    # Check the ACTUALS in CRM
    And   the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-838       | ESF-838         | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-838       | ESF-838         | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the PROFILE PAYMENTS in CRM
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-838       | ESF-838         | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-838       | ESF-838         | 3               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the BALANCING PAYMENTS in CRM
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-838       | ESF-838         | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-838       | ESF-838         | 3               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-838       | ESF-838         | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-838       | ESF-838         | 3               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-838       | ESF-838         | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-838       | ESF-838         | 3               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-838       | ESF-838         | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-838       | ESF-838         | 3               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-838       | ESF-838         | 2               | 29175.00 | 5000.00  | 132.00   | 1278.00  | 462.00   | 650.00   | 3046.00  | 2355.00  | 662.00   | 4709.00  | 2769.00  | 4527.00  | 3585.00  | 
    | ESIF-838       | ESF-838         | 3               | 28878.00 | 509.00   | 1167.00  | 4080.00  | 2736.00  | 2155.00  | 2003.00  | 787.00   | 21.00    | 3230.00  | 3949.00  | 3273.00  | 4968.00  | 

    # Check the PLANNED VOLUMES in CRM
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-838       | ESF-838         | 2               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | ESIF-838       | ESF-838         | 3               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber    | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | ESF-838             | 1             | 2               | 201708 | 2              | 0             | 5000.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 2               | 201709 | 2              | 0             | 132.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 2               | 201710 | 2              | 0             | 1278.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 2               | 201711 | 2              | 0             | 462.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 2               | 201712 | 2              | 0             | 650.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 2               | 201801 | 2              | 0             | 3046.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 2               | 201802 | 2              | 0             | 2355.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 2               | 201803 | 2              | 0             | 662.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 2               | 201804 | 2              | 0             | 4709.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 2               | 201805 | 2              | 0             | 2769.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 2               | 201806 | 2              | 0             | 4527.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 2               | 201807 | 2              | 0             | 3585.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
	| ESF-838             | 1             | 3               | 201708 | 2              | 0             | 509.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 3               | 201709 | 2              | 0             | 1167.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 3               | 201710 | 2              | 0             | 4080.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 3               | 201711 | 2              | 0             | 2736.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 3               | 201712 | 2              | 0             | 2155.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 3               | 201801 | 2              | 0             | 2003.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 3               | 201802 | 2              | 0             | 787.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 3               | 201803 | 2              | 0             | 21.00        | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 3               | 201804 | 2              | 0             | 3230.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 3               | 201805 | 2              | 0             | 3949.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 3               | 201806 | 2              | 0             | 3273.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838             | 1             | 3               | 201807 | 2              | 0             | 4968.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |






    # Change the date 
    Given the override date is '06/08/2018' 

    # Consume DCFS format actuals 
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | ESF            | ESF11                | ORG0017838     | CM             | 201708 | ESF1420                 | ESF-838                  |         | 2               | 0            | 1682.00     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201709 | ESF1420                 | ESF-838                  |         | 2               | 0            | 290.10      | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201710 | ESF1420                 | ESF-838                  |         | 2               | 0            | 1740.00     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201711 | ESF1420                 | ESF-838                  |         | 2               | 0            | 2204.87     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201712 | ESF1420                 | ESF-838                  |         | 2               | 0            | 1740.54     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201801 | ESF1420                 | ESF-838                  |         | 2               | 0            | 1324.02     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201802 | ESF1420                 | ESF-838                  |         | 2               | 0            | 861.08      | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201803 | ESF1420                 | ESF-838                  |         | 2               | 0            | 1422.66     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201804 | ESF1420                 | ESF-838                  |         | 2               | 0            | 2946.73     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201805 | ESF1420                 | ESF-838                  |         | 2               | 0            | 9781.20     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201806 | ESF1420                 | ESF-838                  |         | 2               | 0            | 1000.50     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201807 | ESF1420                 | ESF-838                  |         | 2               | 0            | 600.67      | 
    #
    | ESF            | ESF11                | ORG0017838     | CM             | 201708 | ESF1420                 | ESF-838                  |         | 3               | 0            | 5768.00     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201709 | ESF1420                 | ESF-838                  |         | 3               | 0            | 354.40      | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201710 | ESF1420                 | ESF-838                  |         | 3               | 0            | 6134.98     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201711 | ESF1420                 | ESF-838                  |         | 3               | 0            | 3214.22     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201712 | ESF1420                 | ESF-838                  |         | 3               | 0            | 5340.54     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201801 | ESF1420                 | ESF-838                  |         | 3               | 0            | 1347.12     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201802 | ESF1420                 | ESF-838                  |         | 3               | 0            | 886.28      | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201803 | ESF1420                 | ESF-838                  |         | 3               | 0            | 3562.34     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201804 | ESF1420                 | ESF-838                  |         | 3               | 0            | 2065.99     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201805 | ESF1420                 | ESF-838                  |         | 3               | 0            | 1881.30     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201806 | ESF1420                 | ESF-838                  |         | 3               | 0            | 1490.02     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201807 | ESF1420                 | ESF-838                  |         | 3               | 0            | 588.69      | 
    #
    | ESF            | ESF11                | ORG0017838     | CM             | 201708 | ESF1420                 | ESF-838                  |         | 8               | 0            | 2984.20     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201709 | ESF1420                 | ESF-838                  |         | 8               | 0            | 230.13      | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201710 | ESF1420                 | ESF-838                  |         | 8               | 0            | 1440.40     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201711 | ESF1420                 | ESF-838                  |         | 8               | 0            | 2254.57     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201712 | ESF1420                 | ESF-838                  |         | 8               | 0            | 5746.64     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201801 | ESF1420                 | ESF-838                  |         | 8               | 0            | 1425.06     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201802 | ESF1420                 | ESF-838                  |         | 8               | 0            | 841.38      | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201803 | ESF1420                 | ESF-838                  |         | 8               | 0            | 1552.86     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201804 | ESF1420                 | ESF-838                  |         | 8               | 0            | 2244.93     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201805 | ESF1420                 | ESF-838                  |         | 8               | 0            | 1451.20     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201806 | ESF1420                 | ESF-838                  |         | 8               | 0            | 1546.22     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201807 | ESF1420                 | ESF-838                  |         | 8               | 0            | 1800.47     | 
    #
    | ESF            | ESF11                | ORG0017838     | CM             | 201708 | ESF1420                 | ESF-838                  |         | 9               | 0            | 1643.00     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201709 | ESF1420                 | ESF-838                  |         | 9               | 0            | 2923.19     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201710 | ESF1420                 | ESF-838                  |         | 9               | 0            | 6740.10     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201711 | ESF1420                 | ESF-838                  |         | 9               | 0            | 2544.67     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201712 | ESF1420                 | ESF-838                  |         | 9               | 0            | 1870.24     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201801 | ESF1420                 | ESF-838                  |         | 9               | 0            | 1774.92     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201802 | ESF1420                 | ESF-838                  |         | 9               | 0            | 813.00      | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201803 | ESF1420                 | ESF-838                  |         | 9               | 0            | 1762.39     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201804 | ESF1420                 | ESF-838                  |         | 9               | 0            | 2176.57     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201805 | ESF1420                 | ESF-838                  |         | 9               | 0            | 1881.50     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201806 | ESF1420                 | ESF-838                  |         | 9               | 0            | 1220.00     | 
    | ESF            | ESF11                | ORG0017838     | CM             | 201807 | ESF1420                 | ESF-838                  |         | 9               | 0            | 888.61      | 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

	# The actuals should not be processed into CRM. CRM and PaaS figures should be unchanged from earlier

    # Check the ACTUALS in CRM
    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-838       | ESF-838         | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-838       | ESF-838         | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the PROFILE PAYMENTS in CRM
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-838       | ESF-838         | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-838       | ESF-838         | 3               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the BALANCING PAYMENTS in CRM
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-838       | ESF-838         | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-838       | ESF-838         | 3               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-838       | ESF-838         | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-838       | ESF-838         | 3               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-838       | ESF-838         | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-838       | ESF-838         | 3               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-838       | ESF-838         | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-838       | ESF-838         | 3               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-838       | ESF-838         | 2               | 29175.00 | 5000.00  | 132.00   | 1278.00  | 462.00   | 650.00   | 3046.00  | 2355.00  | 662.00   | 4709.00  | 2769.00  | 4527.00  | 3585.00  | 
    | ESIF-838       | ESF-838         | 3               | 28878.00 | 509.00   | 1167.00  | 4080.00  | 2736.00  | 2155.00  | 2003.00  | 787.00   | 21.00    | 3230.00  | 3949.00  | 3273.00  | 4968.00  | 

    # Check the PLANNED VOLUMES in CRM
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-838       | ESF-838         | 2               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | ESIF-838       | ESF-838         | 3               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | ESF-838          | 1             | 2               | 201708 | 2              | 0             | 5000.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 2               | 201709 | 2              | 0             | 132.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 2               | 201710 | 2              | 0             | 1278.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 2               | 201711 | 2              | 0             | 462.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 2               | 201712 | 2              | 0             | 650.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 2               | 201801 | 2              | 0             | 3046.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 2               | 201802 | 2              | 0             | 2355.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 2               | 201803 | 2              | 0             | 662.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 2               | 201804 | 2              | 0             | 4709.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 2               | 201805 | 2              | 0             | 2769.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 2               | 201806 | 2              | 0             | 4527.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 2               | 201807 | 2              | 0             | 3585.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
     #
    | ESF-838          | 1             | 3               | 201708 | 2              | 0             | 509.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 3               | 201709 | 2              | 0             | 1167.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 3               | 201710 | 2              | 0             | 4080.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 3               | 201711 | 2              | 0             | 2736.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 3               | 201712 | 2              | 0             | 2155.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 3               | 201801 | 2              | 0             | 2003.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 3               | 201802 | 2              | 0             | 787.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 3               | 201803 | 2              | 0             | 21.00        | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 3               | 201804 | 2              | 0             | 3230.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 3               | 201805 | 2              | 0             | 3949.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 3               | 201806 | 2              | 0             | 3273.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-838          | 1             | 3               | 201807 | 2              | 0             | 4968.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |

    # Tidy up
    And   the override date is reset
   
@AcceptanceTest @Complete 
@PublishNewLevyContract @ContractClosure
Scenario: A839 Create and approve a Levy contract. Successfully request and approve contract closure. Consume but reject payment instructions. Check CRM and PaaS
    Given there is no Contract, Task or Workflow data for UKPRN '10017839'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017839 Co Ltd' with UKPRN '10017839' and OrgId 'ORG0017839' and has 'FCS1 Test' as a manager
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017839'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017839'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
	And   there are no entries in the DCFS stub table
    And   there are no DAS engagement events stored in FCS
   
   # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017839'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017839 Co Ltd' with UKPRN '10017839' and OrgId 'ORG0017839' and has 'FCS1 Test' as a manager
    And   UPIN '117839' is associated with UKPRN '10017839' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017839 | 117839 | 10017839 Co Ltd | 0              | Active |




    # Change the date 
    Given the override date is '16/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42864 | INITIATED | 2017-09-15T18:03:12.2539 | 10017839   | 28913             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017839'
    And   there is only one Levy contract in CRM for UKPRN '10017839' with a status of 'Draft'

    # Check the contract has been created ok
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017839 | 10017839 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017839 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017839 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
    | 10017839 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription              | 
    | 10017839 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships    | 
    | 10017839 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships    | 
    | 10017839 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017839 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017839' for FundingType 'LEVY' and period '1799'

    ## Check deliverable period count prior to approval
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Change the date 
    Given the override date is '02/02/2021'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    ## Check deliverable period count after approval
    #Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # After approval there should be a Feb-21 deliverable period for each of deliverables 1 through 14 for each allocation
    Then  the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Feb-21   | DeliverableDescription                               | 
    | 10017839 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017839 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017839 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017839 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017839 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017839 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017839 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017839 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017839 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017839 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017839 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017839 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017839 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017839 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017839 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017839 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017839 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017839 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017839 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017839 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017839 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017839 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017839 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017839 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017839 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017839 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017839 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017839 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017839 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 02/02/2021        | ?               | ?             |
    | 10017839 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017839 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 02/02/2021          | ?                 |
    | 10017839 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 02/02/2021          | ?                 |




    # Change the date 
    Given the override date is '11/07/2021' 

    # Request closure of the contract. This should succeed
    When  a request is raised by Advisor 'FCS2 Test' to close version '1' of contract '[ContractNo]' for provider '10017839'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017839 | [ContractNo]       | 1                     | 0                        | Approved         | Awaiting Closure Approval | True          | True                | 02/02/2021        | ?               | ?             |
    | 10017839 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017839 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 02/02/2021          | ?                 |
    | 10017839 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 02/02/2021          | ?                 |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017839'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State | Status      |
    | Confirm Closure Approval | 10017839 - 10017839 Co Ltd | [ContractNo] | FCS1 Test  | Contract Managers Team | Open  | Not Started |
  
    # Check that the workflow history includes two new entries
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy      | Comment                           | 
    | Closure Initiation Successful | CRM Integration  | ?                                 | 
    | Initiate Contract Closure     | FCS2 Test        | ?                                 | 




    # Change the date 
    Given the override date is '22/07/2021' 

    # Approve closure of the contract. This should succeed 
    When  a request is raised by Manager 'FCS1 Test' to Approve Closure of version '1' of contract '[ContractNo]' for provider '10017839'

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017839'
    | Task                     | Description                | Regarding    | Owner      | Assigned Team          | State     | Status      |
    | Confirm Closure Approval | 10017839 - 10017839 Co Ltd | [ContractNo] | FCS1 Test | Contract Managers Team | Completed | Completed   |

    # Check that the CONTRACT version, status and dates in CRM have not changed
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017839 | [ContractNo]       | 1                     | 0                        | Closed         | Closed                    | True          | True                | 02/02/2021        | 22/07/2021      | ?             |
    | 10017839 | [MasterContractNo] | 1                     | 0                        | Draft          | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check that the ALLOCATION dates in CRM have not changed
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017839 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 02/02/2021          | 22/07/2021        |
    | 10017839 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 02/02/2021          | 22/07/2021        |

    # Check WORKFLOW HISTORY
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                        | CompletedBy      | Comment                           | 
    | Contract Closure Successful   | CRM Integration  | ?                                 | 
    | Approve Closure               | FCS1 Test        | ?                                 | 
    | Closure Initiation Successful | CRM Integration  | ?                                 |
    | Initiate Contract Closure     | FCS2 Test        | ?                                 | 



    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Feb-21   |
    | [ContractNo]   | [AllocRef_LEVY] | 1               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 2               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 3               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 4               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 5               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 6               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 7               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 8               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 9               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 10              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 11              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 12              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 13              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 14              | 0.00     | ?        | 
	#
    | [ContractNo]   | [AllocRef_NLA]  | 1               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 2               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 3               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 4               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 5               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 6               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 7               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 8               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 9               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 10              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 11              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 12              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 13              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 14              | 0.00     | ?        | 


    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualValue |
    | [AllocRef_LEVY]  | 1             | 1               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 2               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 3               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 4               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 5               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 6               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 7               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 8               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 9               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 10              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 11              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 12              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 13              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 14              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
	#
    | [AllocRef_NLA]   | 1             | 1               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 2               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 3               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 4               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 5               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 6               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 7               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 8               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 9               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 10              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 11              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 12              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 13              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 14              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |




    # Change the date
    Given the override date is '04/08/2021'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull DCFS PoI 'actuals' from DCFS for July 21
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS53               | ORG0017839     | CM             | 202107 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 417.41      |
    | APPS           | APPS53               | ORG0017839     | CM             | 202107 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 421.21      |
    | APPS           | APPS53               | ORG0017839     | CM             | 202107 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 105.55      |
    | APPS           | APPS53               | ORG0017839     | CM             | 202107 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 0.00        |
    | APPS           | APPS53               | ORG0017839     | CM             | 202107 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 267.05      |
    | APPS           | APPS53               | ORG0017839     | CM             | 202107 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1168.10     |
    | APPS           | APPS53               | ORG0017839     | CM             | 202107 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 228.41      |
    | APPS           | APPS53               | ORG0017839     | CM             | 202107 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 0.00        |
    | APPS           | APPS53               | ORG0017839     | CM             | 202107 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 260.74      |
    | APPS           | APPS53               | ORG0017839     | CM             | 202107 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 0.00        |
    | APPS           | APPS53               | ORG0017839     | CM             | 202107 | LEVY1799                | [AllocRef_LEVY]          |         | 13              | 0            | 0.00        |
    | APPS           | APPS53               | ORG0017839     | CM             | 202107 | LEVY1799                | [AllocRef_LEVY]          |         | 14              | 0            | 0.00        |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the NET AMOUNTS in CRM have not changed
    Then  the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Feb-21   |
    | [ContractNo]   | [AllocRef_LEVY] | 1               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 2               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 3               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 4               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 5               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 6               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 7               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 8               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 9               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 10              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 11              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 12              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 13              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 14              | 0.00     | ?        | 
	#
    | [ContractNo]   | [AllocRef_NLA]  | 1               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 2               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 3               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 4               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 5               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 6               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 7               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 8               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 9               | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 10              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 11              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 12              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 13              | 0.00     | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 14              | 0.00     | ?        | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table have not changed
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualValue |
    | [AllocRef_LEVY]  | 1             | 1               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 2               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 3               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 4               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 5               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 6               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 7               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 8               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 9               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 10              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 11              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 12              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 13              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 14              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |


    # Tidy up
    Then  the override date is reset

