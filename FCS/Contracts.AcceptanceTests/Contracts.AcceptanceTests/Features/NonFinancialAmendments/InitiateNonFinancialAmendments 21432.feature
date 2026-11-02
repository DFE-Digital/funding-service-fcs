Feature: InitiateNonFinancialAmendments 21432

@AcceptanceTest @Withdrawn20230123
Scenario: A800 Create but do not approve an ESF1420 contract. Initiate a non-financial variation amendment mid-term. Fail: Not Approved\Approved. Check CRM, workflow history and notifications 
    Given there is no Contract, Task or Workflow data for UKPRN '10017800' 
	And   there are no notifications of type 'Non-Financial Contract Amendment Failed'
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ESF-800       |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017800' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017800 Co Ltd' with UKPRN '10017800' and OrgId 'ORG0017800' and has 'FCS1 Test' as a manager 
    And   UPIN '117800' is associated with UKPRN '10017800' in the CRM Organisation table 
 
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017800 | 117800 | 10017800 Co Ltd | 0              | Active | Yes           | AA017800      | ?             | 9 Challoner Court      | Merchants Landing      | ?                      | ?                      | Bristol                | Avon                   | BS1 4RG   |

    # Put data in the CRM Organisation table J057
    And   the following Organisations exist in CRM
    | UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017800 | 117800 | 10017800 Co Ltd | Active | AA017800      | ?             | 9 Challoner Court      | Merchants Landing      | ?                      | ?                      | Bristol                | Avon                   | BS1 4RG   |




    # Change the date
    And   the override date is '15/08/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017800 | 10017800 Co Ltd      | ESFA-800             | ESIF-800       | 1                     | 01/08/2017        | 31/07/2018      | 140136.00     | Contract for Services | 1420   | New          | ORG0017800 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference | TenderAwardReference          | InvestmentPriority                                                    | AgreementNumber | ActivityDescription | SpecificationTitle                | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017800 | ESIF-800       | ESF-800       | ESF 201420        | ESF                     | 01/08/2017          | 31/07/2018        | 140136.00       |                         |            |                                                             | New          | Leicester and Leicestershire LEP            | E37021       | 00-1         | TSS_20125                    | 20125/23-415-00-1/10017800    | 1.4 Active Inclusion                                                  | 777\SD\7800     | Job Seekers Fund    | SSR                               | Transition     | 1.07                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                  | CRMIntent    | DeliveryOrg |
    | 10017800 | ESIF-800       | ESF-800       | 2               | 0                     |          | 32409.00  | 979.00   | 993.00   | 3887.00  | 2472.00  | 2488.00  | 1789.00  | 2304.00  | 1820.00  | 5693.00  | 5880.00  | 2420.00  | 1684.00  | RQ01 Regulated Learning                                 | New          |             |
    | 10017800 | ESIF-800       | ESF-800       | 3               | 0                     |          | 33245.00  | 2759.00  | 5437.00  | 1583.00  | 4716.00  | 2286.00  | 4282.00  | 1971.00  | 3807.00  | 1261.00  | 1132.00  | 3509.00  | 502.00   | NR01 Non Regulated Activity                             | New          |             |
    | 10017800 | ESIF-800       | ESF-800       | 8               | 0                     |          | 39497.00  | 4173.00  | 5484.00  | 5013.00  | 155.00   | 3269.00  | 1752.00  | 5518.00  | 3798.00  | 3773.00  | 2582.00  | 605.00   | 3375.00  | SD01 Specification Defined Deliverable (with Description)| New          |             |
    | 10017800 | ESIF-800       | ESF-800       | 9               | 0                     |          | 34985.00  | 2441.00  | 1633.00  | 352.00   | 1478.00  | 5875.00  | 5499.00  | 2593.00  | 4074.00  | 3025.00  | 3092.00  | 2789.00  | 2134.00  | SD02 Specification Defined Deliverable (with Description)| New          |             |

    And   the contract exists in CRM 
    # Contract status is now at 'Awaiting Documentation' 

    # Check the deliverable count in CRM 
    Then  there are '48' deliverable period rows in CRM linked to the latest version of contract 'ESIF-800'
    And   there are '48' deliverable periods in CRM linked to the latest version of contract 'ESIF-800' and allocation 'ESF-800'

    # Change the date 
    And   the override date is '22/09/2018' 

    # Initiate non-financial amendment request on v1 to create v2. This should fail
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'ESIF-800' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'ESIF-800' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017800 | ESIF-800           | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017800 | ESFA-800           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the WORKFLOW HISTORY for v1
    And   the workflow history on contract 'ESIF-800' version '1' includes the following
    | Action                                    | CompletedBy      | Comment      |
    | Initiate Non-Financial Amendment (Vary)   | FCS2 Test        | ?            |
    | Non-Financial Amendment Initiation Failed | CRM Integration  | ?            |

    # Check that a NOTIFICATION has been created and sent to the initiating User 
	And   there is '1' notification of type 'Non-Financial Contract Amendment Failed' owned by user 'FCS2 Test' which matches the following 
    | Status | NotificationName                                    | NotificationText                                                                                                                                                                  |
    | New    | Non-Financial Contract Amendment Failed - ESIF-800  | Contract ESIF-800 v1 for provider 10017800 (10017800 Co Ltd) cannot be amended - It must be in a status of "Approved" and a substatus of either "Approved", "Modified" or "Under Termination" |

    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run890
Scenario: A807 Create and approve v1 of a 1718 16-18Apps contract. Consume DCFS-format actuals. Create v2 then withdraw. Initiate a non-financial variation amendment mid-term on v1 to create v3. Approve v3. Check CRM, financials, tasks, workflow history, notifications, feeds and PaaS
    Given there is no Contract, Task or Workflow data for UKPRN '10017807'
	And   there are no notifications of type 'Approval Received'
    And   there are no entries in the DCFS stub table
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16AP-807      |

    # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017807'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017807 Co Ltd' with UKPRN '10017807' and OrgId 'ORG0017807' and has 'FCS1 Test' as a manager
    And   UPIN '117807' is associated with UKPRN '10017807' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017807 | 117807 | 10017807 Co Ltd | 0              | Active |
 
    # Change the date
    And   the override date is '20/07/2017'

	# Create contract
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName        | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017807 | 10017807 Co Ltd  | ESFA-807             | MAIN-807       | 1                     |  01/08/2017       |  31/07/2018     | 80904.00      | Contract for Services | 1718   | New          | ORG0017807 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName             | UoPCode | AllocationDescription  | CRMIntent    |
    | 10017807 | MAIN-807       | 16AP-807      | 16-18 APPS        | AY                      |  01/08/2017         |  31/07/2018       | 80904.00        |                     |         |                        | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                               | CRMIntent    |
    | MAIN-807       | 16AP-807      | 2               | 0                     | 6443.00  | 6613.00  | 6184.00  | 7471.00  | 6851.00  | 5238.00  | 5740.00  | 5494.00  | 9709.00  | 4879.00  | 9179.00  | 7103.00  | 16-18 Apprenticeships Total Funding                  | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM is 12 (1 alloc * 1 deliverable line * 12 mths)
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'MAIN-807'

    # Publish the contract
    And   the latest version of contract 'MAIN-807' is in a state of 'Published to Provider'

    # Change the date
    And   the override date is '22/07/2017'

    # Ensure month end is not marked as running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    
    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-807' and actual ContractNumber 'MAIN-807'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017807 | MAIN-807           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017807 | ESFA-807           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM is now 72 (1 alloc * 6 deliverable lines * 12 mths)
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'MAIN-807'

    # Change the date
    And   the override date is '05/09/2017'

    # DCFS Summarised Actuals for August 2017
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201708 | 16-18APPS1718           | 16AP-807                 |         | 6               | 0            | 1385.00     |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201709 | 16-18APPS1718           | 16AP-807                 |         | 6               | 0            | 107.00      |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201710 | 16-18APPS1718           | 16AP-807                 |         | 6               | 0            | 189.00      |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201711 | 16-18APPS1718           | 16AP-807                 |         | 6               | 0            | 42.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201712 | 16-18APPS1718           | 16AP-807                 |         | 6               | 0            | 65.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201801 | 16-18APPS1718           | 16AP-807                 |         | 6               | 0            | 73.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201802 | 16-18APPS1718           | 16AP-807                 |         | 6               | 0            | 24.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201803 | 16-18APPS1718           | 16AP-807                 |         | 6               | 0            | 67.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201804 | 16-18APPS1718           | 16AP-807                 |         | 6               | 0            | 122.00      |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201805 | 16-18APPS1718           | 16AP-807                 |         | 6               | 0            | 4.00        |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201806 | 16-18APPS1718           | 16AP-807                 |         | 6               | 0            | 197.00      |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201807 | 16-18APPS1718           | 16AP-807                 |         | 6               | 0            | 144.00      |
    #
    | ILR1718        | R01                  | ORG0017807     | CM             | 201708 | 16-18APPS1718           | 16AP-807                 |         | 7               | 0            | 1953.00     |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201709 | 16-18APPS1718           | 16AP-807                 |         | 7               | 0            | 154.00      |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201710 | 16-18APPS1718           | 16AP-807                 |         | 7               | 0            | 57.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201711 | 16-18APPS1718           | 16AP-807                 |         | 7               | 0            | 89.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201712 | 16-18APPS1718           | 16AP-807                 |         | 7               | 0            | 146.00      |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201801 | 16-18APPS1718           | 16AP-807                 |         | 7               | 0            | 61.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201802 | 16-18APPS1718           | 16AP-807                 |         | 7               | 0            | 212.00      |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201803 | 16-18APPS1718           | 16AP-807                 |         | 7               | 0            | 51.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201804 | 16-18APPS1718           | 16AP-807                 |         | 7               | 0            | 144.00      |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201805 | 16-18APPS1718           | 16AP-807                 |         | 7               | 0            | 27.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201806 | 16-18APPS1718           | 16AP-807                 |         | 7               | 0            | 43.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201807 | 16-18APPS1718           | 16AP-807                 |         | 7               | 0            | 101.00      |
    #
    | ILR1718        | R01                  | ORG0017807     | CM             | 201708 | 16-18APPS1718           | 16AP-807                 |         | 8               | 0            | 713.00      |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201709 | 16-18APPS1718           | 16AP-807                 |         | 8               | 0            | 98.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201710 | 16-18APPS1718           | 16AP-807                 |         | 8               | 0            | 134.00      |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201711 | 16-18APPS1718           | 16AP-807                 |         | 8               | 0            | 91.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201712 | 16-18APPS1718           | 16AP-807                 |         | 8               | 0            | 12.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201801 | 16-18APPS1718           | 16AP-807                 |         | 8               | 0            | 36.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201802 | 16-18APPS1718           | 16AP-807                 |         | 8               | 0            | 36.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201803 | 16-18APPS1718           | 16AP-807                 |         | 8               | 0            | 193.00      |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201804 | 16-18APPS1718           | 16AP-807                 |         | 8               | 0            | 120.00      |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201805 | 16-18APPS1718           | 16AP-807                 |         | 8               | 0            | 71.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201806 | 16-18APPS1718           | 16AP-807                 |         | 8               | 0            | 10.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201807 | 16-18APPS1718           | 16AP-807                 |         | 8               | 0            | 82.00       |
    #
    | ILR1718        | R01                  | ORG0017807     | CM             | 201708 | 16-18APPS1718           | 16AP-807                 |         | 9               | 0            | 634.00      |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201709 | 16-18APPS1718           | 16AP-807                 |         | 9               | 0            | 190.00      |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201710 | 16-18APPS1718           | 16AP-807                 |         | 9               | 0            | 37.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201711 | 16-18APPS1718           | 16AP-807                 |         | 9               | 0            | 78.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201712 | 16-18APPS1718           | 16AP-807                 |         | 9               | 0            | 38.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201801 | 16-18APPS1718           | 16AP-807                 |         | 9               | 0            | 115.00      |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201802 | 16-18APPS1718           | 16AP-807                 |         | 9               | 0            | 51.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201803 | 16-18APPS1718           | 16AP-807                 |         | 9               | 0            | 64.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201804 | 16-18APPS1718           | 16AP-807                 |         | 9               | 0            | 51.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201805 | 16-18APPS1718           | 16AP-807                 |         | 9               | 0            | 218.00      |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201806 | 16-18APPS1718           | 16AP-807                 |         | 9               | 0            | 38.00       |
    | ILR1718        | R01                  | ORG0017807     | CM             | 201807 | 16-18APPS1718           | 16AP-807                 |         | 9               | 0            | 152.00      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUALS in CRM
    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-807       | 16AP-807        | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 6               | 1385.00  | 1385.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 7               | 1953.00  | 1953.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 8               | 713.00   | 713.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 9               | 634.00   | 634.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 10              | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-807       | 16AP-807        | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 6               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 7               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 8               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 9               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 10              | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-807       | 16AP-807        | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 6               | 1385.00  | 1385.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 7               | 1953.00  | 1953.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 8               | 713.00   | 713.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 9               | 634.00   | 634.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 10              | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-807       | 16AP-807        | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 6               | 1385.00  | 1385.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 7               | 1953.00  | 1953.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 8               | 713.00   | 713.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 9               | 634.00   | 634.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-807       | 16AP-807        | 10              | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-807       | 16AP-807        | 2               | 80904.00 | 6443.00  | 6613.00  | 6184.00  | 7471.00  | 6851.00  | 5238.00  | 5740.00  | 5494.00  | 9709.00  | 4879.00  | 9179.00  | 7103.00  | 
    | MAIN-807       | 16AP-807        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 7               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 8               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 9               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 10              | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualValue |
    | 16AP-807         | 1             | 2               | 201708 | 2              | 0             | 6443.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-807         | 1             | 2               | 201709 | 2              | 0             | 6613.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-807         | 1             | 2               | 201710 | 2              | 0             | 6184.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-807         | 1             | 2               | 201711 | 2              | 0             | 7471.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-807         | 1             | 2               | 201712 | 2              | 0             | 6851.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-807         | 1             | 2               | 201801 | 2              | 0             | 5238.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-807         | 1             | 2               | 201802 | 2              | 0             | 5740.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-807         | 1             | 2               | 201803 | 2              | 0             | 5494.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-807         | 1             | 2               | 201804 | 2              | 0             | 9709.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-807         | 1             | 2               | 201805 | 2              | 0             | 4879.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-807         | 1             | 2               | 201806 | 2              | 0             | 9179.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-807         | 1             | 2               | 201807 | 2              | 0             | 7103.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16AP-807         | 1             | 6               | 201708 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1385.00                     | 1385.00          | 1385.00     |
    | 16AP-807         | 1             | 7               | 201708 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1953.00                     | 1953.00          | 1953.00     |
    | 16AP-807         | 1             | 8               | 201708 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 713.00                      | 713.00           | 713.00      |
    | 16AP-807         | 1             | 9               | 201708 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 634.00                      | 634.00           | 634.00      |

    # Create and publish v2 of the contract but don't approve it
    Given there are no files prefixed '10017807_MAIN-807' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1718 01032018151653 v2_A807' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1718 01032018151653 v2_A807' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1718 01032018151653 v2_A807' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 01032018151653 v2_A807' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 1718 01032018151653 v2_A807.xlsx' exists in the Datafiles folder and UKPRN '10017807' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Publish the contract
    When  the latest version of contract 'MAIN-807' is in a state of 'Published to Provider'

    # Change the date
    And   the override date is '26/10/2017'

    # Withdraw v2
    When  the next action performed on the latest version of contract 'MAIN-807' is 'Withdraw On Behalf Of Provider' with reason 'Reason for withdrawal for test' by 'FCS1 Test'
    Then  the contract sub-status is now set to 'Withdrawn By Provider'
    And   the contract status is now set to 'Withdrawn'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017807 | MAIN-807           | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017807 | MAIN-807           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017807 | ESFA-807           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Change the date
    And   the override date is '12/03/2018'

    # Initiate non-financial amendment request on v1 to create v3
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'MAIN-807' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'MAIN-807' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017807 | MAIN-807           | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017807 | MAIN-807           | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017807 | MAIN-807           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017807 | ESFA-807           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017807 | MAIN-807           | 3                     | 16AP-807      | 01/08/2017          | 31/07/2018        |

    # Check ALLOCATION details in CRM
    And   the draft contract allocations on the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription    | LEPName               | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference        | InvestmentPriority                                        | AgreementNumber | ActivityDescription      | SpecificationTitle | RegionType     | 
    | 10017807 | MAIN-807       | 16AP-807      | 16-18 APPS        | AY                      | 01/08/2017          | 31/07/2018        | 80904.00        |         |         |                          |                       |         |                              |              |                             |                                                           |                 |                          |                    |                |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '3' of contract 'MAIN-807' for provider '10017807'
    | Task                     | Description                                       | Regarding | Owner                    | Assigned Team  | State | Status      |
    | Initiate Document Merge  | 10017807 - 10017807 Co Ltd Awaiting documentation | MAIN-807  | Document Management Team | ?              | Open  | Not Started |
    
    # Check the WORKFLOW HISTORY for v1
    And   the workflow history on contract 'MAIN-807' version '1' includes the following
    | Action                                  | CompletedBy     | Comment                        |
    | Initiate Non-Financial Amendment (Vary) | FCS2 Test       | ?                              |

    # Check the WORKFLOW HISTORY for v3
    And   the workflow history on contract 'MAIN-807' version '3' includes the following
    | Action                           | CompletedBy      | Comment                        |
    | Non-Financial Amendment Created  | CRM Integration  | ?                              |

    # Change the date
    And   the override date is '14/03/2018'

    # Publish the contract
    When  the latest version of contract 'MAIN-807' is in a state of 'Published to Provider'
    
    # Change the date
    And   the override date is '08/04/2018'

	# Ensure the PaaS month-end-is-running indicator is not set
	And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message
    And   a contract approval message is received from SFS for version '3' actual MasterContractNumber 'ESFA-807' and actual ContractNumber 'MAIN-807'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017807 | MAIN-807           | 3                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017807 | MAIN-807           | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017807 | MAIN-807           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017807 | ESFA-807           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check CONTRACT details in CRM 
    And   the draft contract header on the latest version of the contract is as follows
    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType             | Period   | 
    | 10017087 | ESFA-807             | MAIN-807       | 3                     | 01/08/2017        | 31/07/2018      | 80904.00      | Contract for Services    | 1718     | 

    # Check the deliverable count in CRM is now 72 (1 alloc * 6 deliverable lines * 12 mths)
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'MAIN-807'




    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-807       | 16AP-807        | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 6               | 1385.00   | 1385.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 7               | 1953.00   | 1953.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 8               | 713.00    | 713.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 9               | 634.00    | 634.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-807       | 16AP-807        | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 6               | 1385.00   | 1385.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 7               | 1953.00   | 1953.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 8               | 713.00    | 713.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 9               | 634.00    | 634.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-807       | 16AP-807        | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 6               | 1385.00   | 1385.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 7               | 1953.00   | 1953.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 8               | 713.00    | 713.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 9               | 634.00    | 634.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-807       | 16AP-807        | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef   | ReconciliationSubnominal | Aug-17    | Sep-17    | Oct-17    | Nov-17    | Dec-17    | Jan-18    | Feb-18    | Mar-18    | Apr-18    | May-18    | Jun-18    | Jul-18    |
    | MAIN-807       | 16AP-807        | 2240100                  | 4685.00   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 



    # Check that an Approval NOTIFICATION has been created and sent to the Document Management Team
	And   there is '1' notification of type 'Approval Received' owned by team 'Document Management Team' which matches the following 
    | Status | NotificationName             | NotificationText                                                                                               |
    | New    | Approval Received-MAIN-807   | The contract : MAIN-807 - Version : 3 for UKPRN : 10017807 has been approved by the provider : 10017807 Co Ltd |

    # Check CM feed data for an ItemType 2 (Withdrawal) message for v2
    And   the ContractManagement.AtomFeedItem table contains one ItemType '2' event for version '2' of actual contract number 'MAIN-807'
    And   the ItemType '2' event for version '2' of actual contract number 'MAIN-807' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Check CM feed data for an ItemType zero (Approval) message for v3
    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version '3' of actual contract number 'MAIN-807'
    And   the ItemType '0' event for version '3' of actual contract number 'MAIN-807' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Check the ADP feed for category 1 (amendment approval) message
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events 
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | AllocationNumber | ContractVersionNumber |
    | AmendedContractAllocationApproved | 1      | MAIN-807       | 16AP-807         | 3                     | 


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Complete
@ADP
Scenario: A809 Create and approve a 2018 NLAP contract. Initiate a non-financial notification amendment mid-term. Check CRM, tasks and workflow history
    Given there is no Contract, Task or Workflow data for UKPRN '10017809' 

    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017210' 

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017210'
    
    And   there is no Subnominal data for the following contract allocations 
    | AllocationRef | 
    | ANLP-809      | 
    | YNLP-809      |
 

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017809' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017809 Co Ltd' with UKPRN '10017809' and OrgId 'ORG0017809' and has 'FCS1 Test' as a manager 
    And   UPIN '117809' is associated with UKPRN '10017809' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017809 | 117809 | 10017809 Co Ltd | 0              | Active | Yes           | AA017809      | ?             | 



    # Create and approve NLAP contract

    # Change the date
    And   the override date is '13/12/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017809 | 10017809 Co Ltd      | ESFA-809             | NLAP-809       | 1                     | 01/01/2018        | 31/03/2019      | 40247.00      | Contract for Services | 2018   | New          | ORG0017809 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent    |
    | 10017809 | NLAP-809       | ANLP-809      | ANLAP             | NONLEVY                 | 01/01/2018          | 31/03/2019        | 21494.00        |         |         |                       | New          |
    | 10017809 | NLAP-809       | YNLP-809      | 16-18NLAP         | NONLEVY                 | 01/01/2018          | 31/03/2019        | 18753.00        |         |         |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                        | CRMIntent    |
    | 10017809 | NLAP-809       | ANLP-809      | 1               | 0                     | 21494.00 | 2066.00  | 1681.00  | 1805.00  | 2492.00  | 849.00   | 1238.00  | 1032.00  | 1738.00  | 447.00   | 1057.00  | 1358.00  | 2037.00  | 1352.00  | 1069.00  | 1273.00  | Total 16-18 Non-Levy Apprenticeships Funding  | New          |
    | 10017809 | NLAP-809       | YNLP-809      | 1               | 0                     | 18753.00 | 2309.00  | 1551.00  | 869.00   | 373.00   | 1200.00  | 548.00   | 2485.00  | 326.00   | 72.00    | 863.00   | 1369.00  | 2308.00  | 1346.00  | 1016.00  | 2118.00  | Total Adult Non-Levy Apprenticeships Funding  | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check that the deliverables have all been created in CRM
    Then  there are '15' deliverable periods in CRM linked to the latest version of contract 'NLAP-809' and allocation 'ANLP-809'
    And   there are '15' deliverable periods in CRM linked to the latest version of contract 'NLAP-809' and allocation 'YNLP-809'

    # Publish the contract
    And   the latest version of contract 'NLAP-809' is in a state of 'Published to Provider'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-809' and actual ContractNumber 'NLAP-809'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-809' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017809 | NLAP-809           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017809 | ESFA-809           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM has increased to reflect the addition of monitoring deliverables 
    And   there are '75' deliverable periods in CRM linked to the latest version of contract 'NLAP-809' and allocation 'ANLP-809'
    And   there are '75' deliverable periods in CRM linked to the latest version of contract 'NLAP-809' and allocation 'YNLP-809'



    # NFA amendment

    # Change the date
    Given the override date is '09/02/2019'

    # Initiate non-financial amendment request on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'NLAP-809' for a non-financial NOTIFICATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'NLAP-809' for a non-financial VARIATION contract amendment

   # Check the state of the Amendment in Progress indicator. At this point it should be True
    Then  the value of the CRM Amendment Creation in Progress indicator on version '1' subversion '0' of contract 'NLAP-809' is 'True'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017809 | NLAP-809           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/01/2018        | 31/03/2019      | Notification  |
    | 10017809 | NLAP-809           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017809 | ESFA-809           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Check that the deliverables have all been created in CRM
    And   there are '15' deliverable periods in CRM linked to the latest version of contract 'NLAP-809' and allocation 'ANLP-809'
    And   there are '15' deliverable periods in CRM linked to the latest version of contract 'NLAP-809' and allocation 'YNLP-809'

    # Check the WORKFLOW HISTORY for v1
    And   the workflow history on contract 'NLAP-809' version '1' includes the following
    | Action                                    | CompletedBy     | Comment                        |
    | Initiate Non-Financial Amendment (Notify) | FCS2 Test       | ?                              |

    # Check the WORKFLOW HISTORY for v2
    And   the workflow history on contract 'NLAP-809' version '2' includes the following
    | Action                                    | CompletedBy     | Comment                        |
    | Non-Financial Amendment Created           | CRM Integration | ?                              |

    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '2' of contract 'NLAP-809' for provider '10017809'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Initiate Document Merge          | 10017809 - 10017809 Co Ltd Awaiting documentation           | NLAP-809       | Document Management Team  | ?                        | Open            | Not Started      |

   # Check the state of the Amendment in Progress indicator. At this point it should be False
    And   the value of the CRM Amendment Creation in Progress indicator on version '1' subversion '0' of contract 'NLAP-809' is 'False'




    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check that certain entries have not been written to the AllocationDelivery.AllocationDeliveryEntry table
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '1' event for version '1' of contract number 'NLAP-809' and allocation number 'ANLP-809'
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '2' event for version '1' of contract number 'NLAP-809' and allocation number 'ANLP-809'
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '3' event for version '1' of contract number 'NLAP-809' and allocation number 'ANLP-809'
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '4' event for version '1' of contract number 'NLAP-809' and allocation number 'ANLP-809'
    #
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '1' event for version '1' of contract number 'NLAP-809' and allocation number 'YNLP-809'
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '2' event for version '1' of contract number 'NLAP-809' and allocation number 'YNLP-809'
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '3' event for version '1' of contract number 'NLAP-809' and allocation number 'YNLP-809'
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '4' event for version '1' of contract number 'NLAP-809' and allocation number 'YNLP-809'

    # Check that the relevant events are on the ADP feed
    Then  the ADP feed includes the following values
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber     | ContractVersionNumber | SubVersionNumber | AllocationNumber | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    | NewContractAllocationApproved     | 0      | NLAP-809           | 1                     | 0                | ANLP-809         | ?                         | ?                            |
    | NewContractAllocationApproved     | 0      | NLAP-809           | 1                     | 0                | YNLP-809         | ?                         | ?                            |

    # Check the ADP feed event header information
    And   the Allocation Delivery feed includes the following event information
    | UKPRN    | ContractNumber     | ContractVersion | ContractSubVersion | CategoryTerm                        | CategoryLabel                        | Title                                                                               |
    | 10017809 | NLAP-809           | 1               | 0                  | NewContractAllocationApproved       | New Contract Allocation Approved     | New Contract NLAP-809: 1.0 with Allocation ANLP-809 was Approved                    |
    | 10017809 | NLAP-809           | 1               | 0                  | NewContractAllocationApproved       | New Contract Allocation Approved     | New Contract NLAP-809: 1.0 with Allocation YNLP-809 was Approved                    |


    # Check Planned data on the ADP feed
    And   the Allocation Delivery Monitoring Service atom feed contains the following Planned data
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume |
    | NewContractAllocationApproved     | NLAP-809           | 1             | ANLP-809         | 1               | 201801 | 2066.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | ANLP-809         | 1               | 201802 | 1681.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | ANLP-809         | 1               | 201803 | 1805.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | ANLP-809         | 1               | 201804 | 2492.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | ANLP-809         | 1               | 201805 | 849.00       | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | ANLP-809         | 1               | 201806 | 1238.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | ANLP-809         | 1               | 201807 | 1032.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | ANLP-809         | 1               | 201808 | 1738.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | ANLP-809         | 1               | 201809 | 447.00       | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | ANLP-809         | 1               | 201810 | 1057.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | ANLP-809         | 1               | 201811 | 1358.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | ANLP-809         | 1               | 201812 | 2037.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | ANLP-809         | 1               | 201901 | 1352.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | ANLP-809         | 1               | 201902 | 1069.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | ANLP-809         | 1               | 201903 | 1273.00      | 0             |
    #
    | NewContractAllocationApproved     | NLAP-809           | 1             | YNLP-809         | 1               | 201801 | 2309.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | YNLP-809         | 1               | 201802 | 1551.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | YNLP-809         | 1               | 201803 | 869.00       | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | YNLP-809         | 1               | 201804 | 373.00       | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | YNLP-809         | 1               | 201805 | 1200.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | YNLP-809         | 1               | 201806 | 548.00       | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | YNLP-809         | 1               | 201807 | 2485.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | YNLP-809         | 1               | 201808 | 326.00       | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | YNLP-809         | 1               | 201809 | 72.00        | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | YNLP-809         | 1               | 201810 | 863.00       | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | YNLP-809         | 1               | 201811 | 1369.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | YNLP-809         | 1               | 201812 | 2308.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | YNLP-809         | 1               | 201901 | 1346.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | YNLP-809         | 1               | 201902 | 1016.00      | 0             |
    | NewContractAllocationApproved     | NLAP-809           | 1             | YNLP-809         | 1               | 201903 | 2118.00      | 0             |


    # Tidy up
    And   the override date is reset

 