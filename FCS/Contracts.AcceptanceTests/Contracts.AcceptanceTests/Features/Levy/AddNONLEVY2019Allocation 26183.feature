Feature: AddNONLEVY2019Allocation 26183

@AcceptanceTest @Withdrawn20200420
Scenario: A125 Create and approve a Levy contract with one alloc. Inject POI actuals. Check CRM. Apply notification amendment to add a NonLevy2019 alloc. Inject POI actuals. Check Docs and CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017125' 
    And   there are no terminated or closed allocations for UKPRN '10017125' 
	And   there is no Contract, Task or Workflow data for contract 'APPLEVY-125' and master contract 'ESFA-125'
    And   there is no Contract, Task or Workflow data for UKPRN '10017125' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017125' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017125' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017125' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017125' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table 
    And   there are no DAS engagement events stored in FCS 
	And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017125' 

	# Clear down all subnominal data from PaaS for an FSP
	And   there is no Subnominal data in PaaS for the following FSPs
	| FSP         |
	| LEVY1799    |
	| NONLEVY2019 |

    # Remove the provider from RoATP (ContractManagement.RoATPProvider) 
    And   there is no data on RoATP for the following providers 
    | Ukprn    | 
    | 10017125 | 
 



    # Add the provider to RoATP (ContractManagement.RoATPProvider) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not.  
    And   the following providers exist on RoATP  
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |  
    | 10017125 | 10017125 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
	
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017125' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017125 Co Ltd' with UKPRN '10017125' and OrgId 'ORG0017125' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017125' 
 



    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017125 | 117125 | 10017125 Co Ltd | 0              | Provider Under Change | Yes           | AA017125      | ?             | 95 Church Way          | Iffley Village         | Oxford                 | ?                      | ?                      | ?                      | OX4 4EG   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017125 |

 


    # Change the date 
    Given the override date is '16/09/2017' 
 
    # Inject data into the stub 
   #And   the following Levy event data is available in the DAS agreement stub 
	And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 42125 | INITIATED | 2017-09-15T18:03:12.2125 | 10017125   | 28125             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017125' 
    Then  there is only one Levy contract in CRM for UKPRN '10017125' with a status of 'Draft' 

    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Internally Approved    | Yes           | No                  | 1                     | 

    # Retrieve parameters from CRM 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017125' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017125' 
    When  I retrieve the latest contract details from CRM for provider '10017125' for FundingType 'LEVY' and period '1799' 
 
	# Publish the contract (This is needed because the injection step above leaves the contract in the wrong state)
    Given the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'




    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017125 | 10017125 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017125 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017125 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017125 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017125 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
 
    # Check deliverable period count prior to approval 
    And   there are '2' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017125 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/05/2017        | ?               | ?             |
    | 10017125 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |




    # Change the date 
    Given the override date is '06/01/2018' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 
 
    # Check deliverable period count after approval 
    Then  there are '14' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # After approval there should be a Jan-18 deliverable period for each of deliverables 1 through 14 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef   | DeliverableCode | ParentDeliverableCode | Total    | Jan-18   | DeliverableDescription                           |
    | 10017125 | LEVY              | [AllocRef_LEVY] | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                 | 
    | 10017125 | LEVY              | [AllocRef_LEVY] | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                         | 
    | 10017125 | LEVY              | [AllocRef_LEVY] | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                         | 
    | 10017125 | LEVY              | [AllocRef_LEVY] | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support    | 
    | 10017125 | LEVY              | [AllocRef_LEVY] | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other               | 
    | 10017125 | LEVY              | [AllocRef_LEVY] | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers   | 
    | 10017125 | LEVY              | [AllocRef_LEVY] | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals | 
    | 10017125 | LEVY              | [AllocRef_LEVY] | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                 | 
    | 10017125 | LEVY              | [AllocRef_LEVY] | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                         | 
    | 10017125 | LEVY              | [AllocRef_LEVY] | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                         | 
    | 10017125 | LEVY              | [AllocRef_LEVY] | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support    | 
    | 10017125 | LEVY              | [AllocRef_LEVY] | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other               | 
    | 10017125 | LEVY              | [AllocRef_LEVY] | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers   | 
    | 10017125 | LEVY              | [AllocRef_LEVY] | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals | 
 
    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017125 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 06/01/2018        | ?               | ?             | 
    | 10017125 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 
 
    # Check ALLOCATION dates in CRM 
    And   the following allocation values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate | 
    | 10017125 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 06/01/2018          | ?                 | 

#    # Check the WORKFLOW HISTORY for v1
#    Then  the workflow history on contract '[ContractNo]' version '1' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Confirm Receipt of Digital Signature           | CRM Integration     | ?                                |
#    | Document Published For Digital Sign Off        | CRM Integration     | ?                                |
#    | Skip Review and Internal Approval              | CRM Integration     | ?                                |




    # Add PoI 'actuals' to the contract

    # Change the date
    Given the override date is '04/06/2018'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017125'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull DCFS PoI actuals from DC for May 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS13               | ORG0017125     | CM             | 201805 | LEVY1799                | [AllocRef_LEVY]          |            | 2               | 0            | 1496.42     |
    | APPS           | APPS13               | ORG0017125     | CM             | 201805 | LEVY1799                | [AllocRef_LEVY]          |            | 3               | 0            | 1286.86     |
    | APPS           | APPS13               | ORG0017125     | CM             | 201805 | LEVY1799                | [AllocRef_LEVY]          |            | 4               | 0            | 980.63      |
    | APPS           | APPS13               | ORG0017125     | CM             | 201805 | LEVY1799                | [AllocRef_LEVY]          |            | 5               | 0            | 766.51      |
    | APPS           | APPS13               | ORG0017125     | CM             | 201805 | LEVY1799                | [AllocRef_LEVY]          |            | 6               | 0            | 1219.76     |
    | APPS           | APPS13               | ORG0017125     | CM             | 201805 | LEVY1799                | [AllocRef_LEVY]          |            | 8               | 0            | 1389.82     |
    | APPS           | APPS13               | ORG0017125     | CM             | 201805 | LEVY1799                | [AllocRef_LEVY]          |            | 9               | 0            | 402.77      |
    | APPS           | APPS13               | ORG0017125     | CM             | 201805 | LEVY1799                | [AllocRef_LEVY]          |            | 10              | 0            | 857.07      |
    | APPS           | APPS13               | ORG0017125     | CM             | 201805 | LEVY1799                | [AllocRef_LEVY]          |            | 11              | 0            | 627.14      |
    | APPS           | APPS13               | ORG0017125     | CM             | 201805 | LEVY1799                | [AllocRef_LEVY]          |            | 12              | 0            | 280.50      |
    | APPS           | APPS13               | ORG0017125     | CM             | 201805 | LEVY1799                | [AllocRef_LEVY]          |            | 13              | 0            | 142.16      |
    | APPS           | APPS13               | ORG0017125     | CM             | 201805 | LEVY1799                | [AllocRef_LEVY]          |            | 14              | 0            | 154.44      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the NET AMOUNTS in CRM
    Then  the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Jan-18   |
    | [ContractNo]   | [AllocRef_LEVY] | 1               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 7               | 0.00      | ?        | 

    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Jan-18   | May-18   |
    | [ContractNo]   | [AllocRef_LEVY] | 2               | 1496.42   | ?        | 1496.42  | 
    | [ContractNo]   | [AllocRef_LEVY] | 3               | 1286.86   | ?        | 1286.86  | 
    | [ContractNo]   | [AllocRef_LEVY] | 4               | 980.63    | ?        | 980.63   | 
    | [ContractNo]   | [AllocRef_LEVY] | 5               | 766.51    | ?        | 766.51   | 
    | [ContractNo]   | [AllocRef_LEVY] | 6               | 1219.76   | ?        | 1219.76  | 
    | [ContractNo]   | [AllocRef_LEVY] | 8               | 1389.82   | ?        | 1389.82  | 
    | [ContractNo]   | [AllocRef_LEVY] | 9               | 402.77    | ?        | 402.77   | 
    | [ContractNo]   | [AllocRef_LEVY] | 10              | 857.07    | ?        | 857.07   | 
    | [ContractNo]   | [AllocRef_LEVY] | 11              | 627.14    | ?        | 627.14   | 
    | [ContractNo]   | [AllocRef_LEVY] | 12              | 280.50    | ?        | 280.50   | 
    | [ContractNo]   | [AllocRef_LEVY] | 13              | 142.16    | ?        | 142.16   | 
    | [ContractNo]   | [AllocRef_LEVY] | 14              | 154.44    | ?        | 154.44   | 

    # Check deliverable period count in CRM
    And   there are '26' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 

    # Check the RECONCILIATION subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2240110         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 1496.42         |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2240120         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 1286.86         |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2240130         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 1747.14         |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2240140         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 1219.76         |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2240142         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 142.16          |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2340110         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 1389.82         |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2340120         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 402.77          |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2340130         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 1484.21         |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2340140         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 280.50          |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2340142         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 154.44          |




    # Amend the contract to add a NONLEVY2019 allocation
	
	# Change the date
	Given the override date is '01/08/2019'

	# Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
	
	# Issue a contract amendment request on v1 to create v2, adding a NONLEVY2019 allocation. (Singleton, Notification and Yes)
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017125 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Approved  | Notification  | Yes                      | Yes                          | 

    # Check the CONTRACT version, status and dates in CRM.  Contract should have auto-approved
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017125 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 06/01/2018        | ?               | Notification  |
    | 10017125 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 06/01/2018        | ?               | ?             |
    | 10017125 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Retrieve parameters from CRM 
    #When  I retrieve the latest EFA contract details from CRM for provider '10017125' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017125' 
     When  I retrieve the latest contract details from CRM for provider '10017125' for FundingType 'LEVY' and period '1799' 

#   # Check the WORKFLOW HISTORY for v2
#    Then  the workflow history on contract '[ContractNo]' version '2' includes the following
#    | Action                                         | CompletedBy         | Comment                          |
#    | Automatically Approved                         | CRM Integration     | ?                                |
#    | Document Published With Auto Approve           | CRM Integration     | ?                                |
#    | Skip Review and Internal Approval              | CRM Integration     | ?                                |

    # Check that the Contract Allocation has been created correctly in CRM
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType       |
    | 10017125 | [ContractNo]       | [AllocRef_NLA]        | ?                             | 0.00            | ?             | ?                | 01/08/2019 | ?          | NONLEVY       | NONLEVY2019         | Contract Allocation |

    # Check that the Contract Deliverables have been created correctly in CRM
    And   the following Contract Deliverables exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | DeliverableCode | DisplayOrder | ParentDeliverableCode | ContractDeliverableName                              | ContractDeliverableDescription       | PlannedValue | PlannedVolume | UnitCost |
    | 10017125 | [ContractNo]       | [AllocRef_NLA]        | 1               | 1            | ?                     | Total 16-18 Non-Levy Apprenticeships                 | ?                                    | 0.00         | 0             | 0        |
    | 10017125 | [ContractNo]       | [AllocRef_NLA]        | 2               | 2            | 1                     | 16-18 Non-Levy - Levy Funded                         | ?                                    | ?            | ?             | ?        |
    | 10017125 | [ContractNo]       | [AllocRef_NLA]        | 3               | 3            | 1                     | 16-18 Non-Levy - Co-Invested                         | ?                                    | ?            | ?             | ?        |
    | 10017125 | [ContractNo]       | [AllocRef_NLA]        | 4               | 4            | 1                     | 16-18 Non-Levy - Agency Funded - Learning Support    | ?                                    | ?            | ?             | ?        |
    | 10017125 | [ContractNo]       | [AllocRef_NLA]        | 5               | 5            | 1                     | 16-18 Non-Levy - Agency Funded - Other               | ?                                    | ?            | ?             | ?        |
    | 10017125 | [ContractNo]       | [AllocRef_NLA]        | 6               | 6            | 1                     | 16-18 Non-Levy - Additional Payments for Employers   | ?                                    | ?            | ?             | ?        |
    | 10017125 | [ContractNo]       | [AllocRef_NLA]        | 7               | 7            | 1                     | 16-18 Non-Levy - Additional Payments for Individuals | ?                                    | ?            | ?             | ?        |
    | 10017125 | [ContractNo]       | [AllocRef_NLA]        | 8               | 8            | ?                     | Total Adult Non-Levy Apprenticeships                 | ?                                    | 0.00         | 0             | 0        |
    | 10017125 | [ContractNo]       | [AllocRef_NLA]        | 9               | 9            | 8                     | Adult Non-Levy - Levy Funded                         | ?                                    | ?            | ?             | ?        |
    | 10017125 | [ContractNo]       | [AllocRef_NLA]        | 10              | 10           | 8                     | Adult Non-Levy - Co-Invested                         | ?                                    | ?            | ?             | ?        |
    | 10017125 | [ContractNo]       | [AllocRef_NLA]        | 11              | 11           | 8                     | Adult Non-Levy - Agency Funded - Learning Support    | ?                                    | ?            | ?             | ?        |
    | 10017125 | [ContractNo]       | [AllocRef_NLA]        | 12              | 12           | 8                     | Adult Non-Levy - Agency Funded - Other               | ?                                    | ?            | ?             | ?        |
    | 10017125 | [ContractNo]       | [AllocRef_NLA]        | 13              | 13           | 8                     | Adult Non-Levy - Additional Payments for Employers   | ?                                    | ?            | ?             | ?        |
    | 10017125 | [ContractNo]       | [AllocRef_NLA]        | 14              | 14           | 8                     | Adult Non-Levy - Additional Payments for Individuals | ?                                    | ?            | ?             | ?        |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '40' deliverable period rows in CRM linked to the latest version of contract 'LEVY-125'
    And   there are '40' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Retrieve parameters from CRM 
   #And   I retrieve the latest EFA contract details from CRM for provider '10017125' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017125' 
    And   I retrieve the latest contract details from CRM for provider '10017125' for FundingType 'LEVY' and period '1799' 

    # Check Contract documentation (16390)
    And   a file named '10017125_' & '[ContractNo]' & '_v2.pdf' does not exist in sharepoint location 'LEVY-1799-Input-Appendices'
    And   a file named '10017125_' & '[ContractNo]' & '_v2.pdf' exists in sharepoint location 'LEVY-1799-Output-Documents for Publication'

   #And   the generated ts&cs document in sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
	And   the file named '10017125_' & '[ContractNo]' & '_v2.pdf' created in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order
    """
    THIS VARIATION is made on the date the Variation is digitally signed by the Training
    Provider on the “Manage your education and skills funding service” and shall be
    deemed to be effective from 1 April 2022 (“the Variation Date”).
    BETWEEN: -
    (1) THE SECRETARY OF STATE FOR EDUCATION DEPARTMENT FOR
    EDUCATION 20 Great Smith Street London SW1P 3BT (“the Department”);
    and
    (2) 10017125 Co Ltd Company No: AA017125 (10017125) whose registered office
    is situated at 95 Church Way, Iffley Village, Oxford, OX4 4EG (“the Training
    Provider”).
    RECITALS: -
    (A) The Department and the Training Provider entered into an Apprenticeship
    Agreement for the provision of Apprenticeship Training with the Department’s
    reference number of ESFA-125 ("Original Agreement").
    (B) The Department and the Training Provider have agreed to vary the terms of the
    Original Agreement as set out in this Variation.
    (C) The Department’s reference number for this Variation is Winter 2022, Version
    4.1.
    """

    # Save a copy of the output
   #Then  Sharepoint file '10017nnn_[ContractNo]_v1.pdf' in 'xxx-nnnn-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017nnn_[ContractNo]_v1.pdf'
    Then  Sharepoint file '10017125_[ContractNo]_v2.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as '10017125_LEVY-125_v2.pdf'

	# Clear out all evidence of the contract doc after checking it is ok
	Given there are no files prefixed '10017125' in the Sharepoint 'LEVY-1799-Input-Appendices' folder
	And   there are no files prefixed '10017125' in the Sharepoint 'LEVY-1799-Output-Documents for Publication' folder




    # Add PoI 'actuals' to the contract

    # Change the date
    Given the override date is '04/09/2019'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017125'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull DCFS PoI actuals from DC for Non-Levy for Aug 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS28               | ORG0017125     | CM             | 201908 | NONLEVY2019             | [AllocRef_NLA]           |            | 2               | 0            | 546.74      |
    | APPS           | APPS28               | ORG0017125     | CM             | 201908 | NONLEVY2019             | [AllocRef_NLA]           |            | 3               | 0            | 766.63      |
    | APPS           | APPS28               | ORG0017125     | CM             | 201908 | NONLEVY2019             | [AllocRef_NLA]           |            | 4               | 0            | 687.89      |
    | APPS           | APPS28               | ORG0017125     | CM             | 201908 | NONLEVY2019             | [AllocRef_NLA]           |            | 5               | 0            | 762.18      |
    | APPS           | APPS28               | ORG0017125     | CM             | 201908 | NONLEVY2019             | [AllocRef_NLA]           |            | 9               | 0            | 408.52      |
    | APPS           | APPS28               | ORG0017125     | CM             | 201908 | NONLEVY2019             | [AllocRef_NLA]           |            | 10              | 0            | 357.52      |
    | APPS           | APPS28               | ORG0017125     | CM             | 201908 | NONLEVY2019             | [AllocRef_NLA]           |            | 11              | 0            | 627.66      |
    | APPS           | APPS28               | ORG0017125     | CM             | 201908 | NONLEVY2019             | [AllocRef_NLA]           |            | 12              | 0            | 230.83      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check deliverable period count in CRM. It should not have changed because the 'actuals' are for the same month as the approval month (Aug-19)
   #And   there are '40' deliverable period rows in CRM linked to the latest version of contract 'LEVY-125'
    Then  there are '40' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
	
    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   |
    | [ContractNo]   | [AllocRef_NLA]  | 1               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]  | 2               | 546.74    | 546.74   | 
    | [ContractNo]   | [AllocRef_NLA]  | 3               | 766.63    | 766.63   | 
    | [ContractNo]   | [AllocRef_NLA]  | 4               | 687.89    | 687.89   | 
    | [ContractNo]   | [AllocRef_NLA]  | 5               | 762.18    | 762.18   | 
    | [ContractNo]   | [AllocRef_NLA]  | 6               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]  | 7               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]  | 8               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]  | 9               | 408.52    | 408.52   | 
    | [ContractNo]   | [AllocRef_NLA]  | 10              | 357.52    | 357.52   | 
    | [ContractNo]   | [AllocRef_NLA]  | 11              | 627.66    | 627.66   | 
    | [ContractNo]   | [AllocRef_NLA]  | 12              | 230.83    | 230.83   | 
    | [ContractNo]   | [AllocRef_NLA]  | 13              | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]  | 14              | 0.00      | 0.00     | 
	
    # Check the RECONCILIATION subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017125 | ORG0017125 | [AllocRef_NLA]    | 2240200         | NONLEVY2019                | 201908               | RECONCILIATION  | CM             | False       | 546.74          |
    | 10017125 | ORG0017125 | [AllocRef_NLA]    | 2240210         | NONLEVY2019                | 201908               | RECONCILIATION  | CM             | False       | 766.63          |
    | 10017125 | ORG0017125 | [AllocRef_NLA]    | 2240220         | NONLEVY2019                | 201908               | RECONCILIATION  | CM             | False       | 1450.07         |
    | 10017125 | ORG0017125 | [AllocRef_NLA]    | 2340200         | NONLEVY2019                | 201908               | RECONCILIATION  | CM             | False       | 408.52          |
    | 10017125 | ORG0017125 | [AllocRef_NLA]    | 2340210         | NONLEVY2019                | 201908               | RECONCILIATION  | CM             | False       | 357.52          |
    | 10017125 | ORG0017125 | [AllocRef_NLA]    | 2340220         | NONLEVY2019                | 201908               | RECONCILIATION  | CM             | False       | 858.49          |




	# Issue a Notification amendment again with the 'AddNonLevy2019Allocation' indicator set to Yes. 
	#   The contract should be amended but another NONLEVY2019 should not be added

	# Change the date
	Given the override date is '06/09/2019'

	# Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
	
	# Issue a contract amendment request on v2 to create v3, adding a NONLEVY2019 allocation. (Singleton, Notification and Yes) This should not update the contract
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017125 | [MasterContractNo]   | [ContractNo]   | 2       | Approved | Approved  | Notification  | Yes                      | Yes                          | 

	And   wait '20' seconds

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017125 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                  | True          | True                | 06/01/2018        | ?               | Notification  |
    | 10017125 | [ContractNo]       | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 06/01/2018        | ?               | Notification  |
    | 10017125 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 06/01/2018        | ?               | ?             |
    | 10017125 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check that the Contract Allocation details have not changed in CRM
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType       |
    | 10017125 | [ContractNo]       | [AllocRef_LEVY]       | ?                             | 0.00            | ?             | ?                | 06/01/2018 | ?          | LEVY          | LEVY1799            | Contract Allocation |



	# Issue a Notification amendment again with the 'AddNonLevy2019Allocation' indicator set to No. 
	#   The contract should be amended but without creating another NONLEVY2019. Dummy doc output

	# Change the date
	Given the override date is '07/09/2019'

	# Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
	
	# Issue a contract amendment request on v2 to create v3, adding a NONLEVY2019 allocation. (Singleton, Notification and No) This should update the contract
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017125 | [MasterContractNo]   | [ContractNo]   | 2       | Approved | Approved  | Notification  | No                       | Yes                          | 

    # Check the CONTRACT version, status and dates in CRM.  Contract version and state details should not have changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017125 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                  | True          | True                | 06/01/2018        | ?               | Notification  |
    | 10017125 | [ContractNo]       | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 06/01/2018        | ?               | Notification  |
    | 10017125 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 06/01/2018        | ?               | ?             |
    | 10017125 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

     # Retrieve parameters from CRM 
    #When  I retrieve the latest EFA contract details from CRM for provider '10017125' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017125' 
     When  I retrieve the latest contract details from CRM for provider '10017125' for FundingType 'LEVY' and period '1799' 
	 
    # Check deliverable period count in CRM for v3. It should be the same as v2
   #And   there are '40' deliverable period rows in CRM linked to the latest version of contract 'LEVY-125'
    Then  there are '40' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Check Contract documentation (16390)
    And   a file named '10017125_' & '[ContractNo]' & '_v3.pdf' does not exist in sharepoint location 'LEVY-1799-Input-Appendices'
    And   a file named '10017125_' & '[ContractNo]' & '_v3.pdf' exists in sharepoint location 'LEVY-1799-Output-Documents for Publication'

   #And   the generated ts&cs document in sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
	And   the file named '10017125_' & '[ContractNo]' & '_v3.pdf' created in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order
    """
    THIS VARIATION is made on the date the Variation is digitally signed by the Training
    Provider on the “Manage your education and skills funding service” and shall be
    deemed to be effective from 1 April 2022 (“the Variation Date”).
    BETWEEN: -
    (1) THE SECRETARY OF STATE FOR EDUCATION DEPARTMENT FOR
    EDUCATION 20 Great Smith Street London SW1P 3BT (“the Department”);
    and
    (2) 10017125 Co Ltd Company No: AA017125 (10017125) whose registered office
    is situated at 95 Church Way, Iffley Village, Oxford, OX4 4EG (“the Training
    Provider”).
    RECITALS: -
    (A) The Department and the Training Provider entered into an Apprenticeship
    Agreement for the provision of Apprenticeship Training with the Department’s
    reference number of ESFA-125 ("Original Agreement").
    (B) The Department and the Training Provider have agreed to vary the terms of the
    Original Agreement as set out in this Variation.
    (C) The Department’s reference number for this Variation is Winter 2022, Version
    4.1.
    """

    # Save a copy of the output
   #Then  Sharepoint file '10017nnn_[ContractNo]_v1.pdf' in 'xxx-nnnn-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017nnn_[ContractNo]_v1.pdf'
    Then  Sharepoint file '10017125_[ContractNo]_v3.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as '10017125_LEVY-125_v3.pdf'




	# Check Reconciliation Subnominal Aggregations in CRM and PaaS

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef   | ReconciliationSubnominal | May-18    |
    | [ContractNo]   | [AllocRef_LEVY] | 2240110                  | 1496.42   | 
    | [ContractNo]   | [AllocRef_LEVY] | 2240120                  | 1286.86   | 
    | [ContractNo]   | [AllocRef_LEVY] | 2240130                  | 1747.14   | 
    | [ContractNo]   | [AllocRef_LEVY] | 2240140                  | 1219.76   | 
    | [ContractNo]   | [AllocRef_LEVY] | 2240142                  | 142.16    | 
    | [ContractNo]   | [AllocRef_LEVY] | 2340110                  | 1389.82   | 
    | [ContractNo]   | [AllocRef_LEVY] | 2340120                  | 402.77    | 
    | [ContractNo]   | [AllocRef_LEVY] | 2340130                  | 1484.21   | 
    | [ContractNo]   | [AllocRef_LEVY] | 2340140                  | 280.50    | 
    | [ContractNo]   | [AllocRef_LEVY] | 2340142                  | 154.44    | 

    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef   | ReconciliationSubnominal | Aug-19    |
    | [ContractNo]   | [AllocRef_NLA]  | 2240200                  | 546.74    | 
    | [ContractNo]   | [AllocRef_NLA]  | 2240210                  | 766.63    | 
    | [ContractNo]   | [AllocRef_NLA]  | 2240220                  | 1450.07   | 
    | [ContractNo]   | [AllocRef_NLA]  | 2340200                  | 408.52    | 
    | [ContractNo]   | [AllocRef_NLA]  | 2340210                  | 357.52    | 
    | [ContractNo]   | [AllocRef_NLA]  | 2340220                  | 858.49    | 

    # Check the RECONCILIATION subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2240110         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 1496.42         |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2240120         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 1286.86         |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2240130         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 1747.14         |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2240140         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 1219.76         |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2240142         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 142.16          |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2340110         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 1389.82         |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2340120         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 402.77          |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2340130         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 1484.21         |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2340140         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 280.50          |
    | 10017125 | ORG0017125 | [AllocRef_LEVY]   | 2340142         | LEVY1799                   | 201805               | RECONCILIATION  | CM             | False       | 154.44          |
    #
    | 10017125 | ORG0017125 | [AllocRef_NLA]    | 2240200         | NONLEVY2019                | 201908               | RECONCILIATION  | CM             | False       | 546.74          |
    | 10017125 | ORG0017125 | [AllocRef_NLA]    | 2240210         | NONLEVY2019                | 201908               | RECONCILIATION  | CM             | False       | 766.63          |
    | 10017125 | ORG0017125 | [AllocRef_NLA]    | 2240220         | NONLEVY2019                | 201908               | RECONCILIATION  | CM             | False       | 1450.07         |
    | 10017125 | ORG0017125 | [AllocRef_NLA]    | 2340200         | NONLEVY2019                | 201908               | RECONCILIATION  | CM             | False       | 408.52          |
    | 10017125 | ORG0017125 | [AllocRef_NLA]    | 2340210         | NONLEVY2019                | 201908               | RECONCILIATION  | CM             | False       | 357.52          |
    | 10017125 | ORG0017125 | [AllocRef_NLA]    | 2340220         | NONLEVY2019                | 201908               | RECONCILIATION  | CM             | False       | 858.49          |




	# Check the CM and ADP feeds for approval events

    # Check contents of the ContractManagement.AtomFeedItem (CM) feed for a Type 0 (Approval) event messages for v1 and v2
   #And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version 'n' of actual contract number 'APPLEVY-125'
    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version '1' of contract number '[ContractNo]'
	And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version '2' of contract number '[ContractNo]'

    # Contract Schema check
   #And   the ItemType '0' event for version 'n' of actual contract number 'APPLEVY-125' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema
    And   the ItemType '0' event for version '1' of contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema
	And   the ItemType '0' event for version '2' of contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema
   

    # Check AllocationDelivery.AllocationDeliveryEntry (ADP) feed for type 0 (New Approval) and type 1 (Amendment Approval) events
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events 
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | AllocationNumber | ContractVersionNumber |
    | NewContractAllocationApproved     | 0      | [ContractNo]   | [AllocRef_LEVY]  | 1                     |
    #
    | AmendedContractAllocationApproved | 1      | [ContractNo]   | [AllocRef_LEVY]  | 2                     |
    | AmendedContractAllocationApproved | 1      | [ContractNo]   | [AllocRef_NLA]   | 2                     |


	# Tidy Up
	Then  the override date is reset
	   
	   