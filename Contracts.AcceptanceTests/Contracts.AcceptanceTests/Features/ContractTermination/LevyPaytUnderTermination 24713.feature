Feature: LevyPaytUnderTermination 24713

@AcceptanceTest @Complete 
@Long2Run @Long2Run45
Scenario: A488SLD Create and approve a Levy contract. Initiate termination (without amendment) and approve initiation. Consume payment instructions before and after termination date: success. Check CRM and PaaS
    Given there are no allocations marked as Under Termination for UKPRN '10017488' 
    And   there are no terminated or closed allocations for UKPRN '10017488' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017488' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017488' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017488' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017488' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017488' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
	And   there are no entries in the DCFS stub table
    And   there are no DAS engagement events stored in FCS 
	And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017488'
 
    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017488' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017488 Co Ltd' with UKPRN '10017488' and OrgId 'ORG0017488' and has 'FCS1 Test' as a manager 
    And   UPIN '117488' is associated with UKPRN '10017488' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | 
    | 10017488 | 117488 | 10017488 Co Ltd | 0              | Active | 
 



    # Remove the provider from RoATP (ContractManagement.RoATPProvider)
    And   there is no data on RoATP for the following providers
    | Ukprn    |
    | 10017488 |

    # Add the provider to RoATP (ContractManagement.RoATPProvider)
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017488 | 10017488 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 



    # Change the date 
    Given the override date is '16/09/2017' 
 
    # Inject data into the stub 
    And   the following Levy event data is available in the DAS agreement stub 
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 42488 | INITIATED | 2017-09-15T18:03:12.2488 | 10017488   | 28488             | 
 
    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017488'
    Then  there is only one Levy contract in CRM for UKPRN '10017488' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 

    # Retrieve parameters from CRM  
   #When  I retrieve the latest EFA contract details from CRM for provider '10017488' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017488' 
    And   I retrieve the latest contract details from CRM for provider '10017488' for FundingType 'LEVY' and period '1799' 




    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017488 | 10017488 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017488 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017488 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017488 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017488 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017488 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017488 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017488 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 
 
    And   there are no open tasks for the contract 
    And   there is no contract owner assigned to the latest version of the contract 
 
    ## Check deliverable period count prior to approval 
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 



    # Change the date 
    Given the override date is '06/01/2021' 
 
    # Approve the contract (15397)
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    
    ## Check deliverable period count after approval 
    #Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # After approval there should be a Jan-21 deliverable period for each of deliverables 1 through 14 for each allocation
    Then the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Jan-21   | DeliverableDescription                               | 
    | 10017488 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017488 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017488 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017488 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017488 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017488 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017488 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017488 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017488 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017488 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017488 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017488 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017488 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017488 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017488 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017488 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017488 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017488 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017488 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017488 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017488 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017488 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017488 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017488 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017488 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017488 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017488 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017488 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 
 
    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017488 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 06/01/2021        | ?               | ?             |
    | 10017488 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |
 
 


    # Initiate a TERMINATION.

    # Change the date
    Given the override date is '28/10/2021'

    # Request termination of the contract via the CRM SDK
    When  CRM user 'FCS8 Test' initiates contract termination for Contract '[ContractNo]' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | TerminationReason       | TerminationComments     |
    | 30/11/2021               | 15/12/2021              | Provider Change         | Police involvement      |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | [AllocRef_LEVY]  | 30/11/2021                  | 15/12/2021                |
    | [AllocRef_NLA]   | 30/11/2021                  | 15/12/2021                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract '[ContractNo]' for UKPRN '10017488'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017488 - 10017488 Co Ltd     | [ContractNo]   | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017488 | [ContractNo]        | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 06/01/2021        | ?               | ?             |
    | 10017488 | [MasterContractNo]  | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    


    # Approve the Termination Initiation

    # Change the date
    Given the override date is '31/10/2021'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017488' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017488 | [ContractNo]        | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 06/01/2021        | ?               | ?             |
    | 10017488 | [MasterContractNo]  | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |




	# Inject PoI 'actuals' BEFORE the Termination date (15/12/2021). These should be processed into CRM\PaaS (24713)
	
    # Change the date
    Given the override date is '04/12/2021'

	# Clear down the actuals 
	And   there are no entries in the DCFS stub table

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull DCFS PoI actuals for Nov 2021
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS55               | ORG0017488     | CM             | 202111 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 225.76      |
    | APPS           | APPS55               | ORG0017488     | CM             | 202111 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 103.51      |
    | APPS           | APPS55               | ORG0017488     | CM             | 202111 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 617.09      |
    | APPS           | APPS55               | ORG0017488     | CM             | 202111 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 450.11      |
    | APPS           | APPS55               | ORG0017488     | CM             | 202111 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 89.25       |
    | APPS           | APPS55               | ORG0017488     | CM             | 202111 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1013.88     |
    | APPS           | APPS55               | ORG0017488     | CM             | 202111 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 649.16      |
    | APPS           | APPS55               | ORG0017488     | CM             | 202111 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 500.01      |
    | APPS           | APPS55               | ORG0017488     | CM             | 202111 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 101.51      |
    | APPS           | APPS55               | ORG0017488     | CM             | 202111 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 2.00        |
    | APPS           | APPS55               | ORG0017488     | CM             | 202111 | LEVY1799                | [AllocRef_LEVY]          |         | 13              | 0            | 944.45      |
    | APPS           | APPS55               | ORG0017488     | CM             | 202111 | LEVY1799                | [AllocRef_LEVY]          |         | 14              | 0            | 882.23      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check deliverable period count
    Then  there are '46' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 

 #   # Check the count of deliverable periods in PaaS (26)
 #   And   there is '1' deliverable period on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '1'
 #   And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '2'
 #   And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '3'
 #   And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '4'
 #   And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '5'
 #   And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '6'
 #   And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '13'
	#And   there is '1' deliverable period on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '7'
 #   And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '8'
 #   And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '9'
 #   And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '10'
 #   And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '11'
 #   And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '12'
 #   And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '14'




    # Inject PoI 'actuals' AFTER the Termination date (15/12/2021). These should be processed into CRM\PaaS (24713)
	
    # Change the date
    Given the override date is '04/06/2022'

	# Clear down the actuals 
	And   there are no entries in the DCFS stub table

    # Pull DCFS PoI actuals for May 2022
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS62               | ORG0017488     | CM             | 202205 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 317.41      |
    | APPS           | APPS62               | ORG0017488     | CM             | 202205 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 421.29      |
    | APPS           | APPS62               | ORG0017488     | CM             | 202205 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 105.55      |
    | APPS           | APPS62               | ORG0017488     | CM             | 202205 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 810.00      |
    | APPS           | APPS62               | ORG0017488     | CM             | 202205 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 267.05      |
    | APPS           | APPS62               | ORG0017488     | CM             | 202205 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1168.13     |
    | APPS           | APPS62               | ORG0017488     | CM             | 202205 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 228.41      |
    | APPS           | APPS62               | ORG0017488     | CM             | 202205 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 405.00      |
    | APPS           | APPS62               | ORG0017488     | CM             | 202205 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 260.77      |
    | APPS           | APPS62               | ORG0017488     | CM             | 202205 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 8.00        |
    | APPS           | APPS62               | ORG0017488     | CM             | 202205 | LEVY1799                | [AllocRef_LEVY]          |         | 13              | 0            | 260.94      |
    | APPS           | APPS62               | ORG0017488     | CM             | 202205 | LEVY1799                | [AllocRef_LEVY]          |         | 14              | 0            | 823.00      |
	
    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check deliverable period count 
    Then  there are '58' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 

 #   # Check the count of deliverable periods in PaaS (38)
 #   And   there is '1' deliverable period on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '1'
 #   And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '2'
 #   And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '3'
 #   And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '4'
 #   And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '5'
 #   And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '6'
 #   And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '13'
	#And   there is '1' deliverable period on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '7'
 #   And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '8'
 #   And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '9'
 #   And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '10'
 #   And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '11'
 #   And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '12'
 #   And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef_LEVY]' for DeliverableCode '14'


    # Tidy up
    And   the override date is reset 

@AcceptanceTest @Complete
Scenario: A489 Create and approve a Levy contract. Initiate termination (without amendment) but don’t approve the initiation. Consume payment instructions before and after termination date: success. Complete termination. Consume payment instructions after termination date: reject. Check CRM and PaaS
    Given there are no allocations marked as Under Termination for UKPRN '10017489' 
    And   there are no terminated or closed allocations for UKPRN '10017489' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017489' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017489' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017489' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017489' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017489' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table
    And   there are no DAS engagement events stored in FCS 
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017489'
 
    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017489' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017489 Co Ltd' with UKPRN '10017489' and OrgId 'ORG0017489' and has 'FCS1 Test' as a manager 
    And   UPIN '117489' is associated with UKPRN '10017489' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | 
    | 10017489 | 117489 | 10017489 Co Ltd | 0              | Active | 
 
    # Set RoATP data (needed for amendment checks) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017489 | 10017489 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 



    # Change the date 
    Given the override date is '16/09/2017' 
 
    # Inject data into the stub 
   #And   the following Levy event data is available in the DAS agreement stub 
    And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 42489 | INITIATED | 2017-09-15T18:03:12.2489 | 10017489   | 28489             | 
 
    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017489'
    Then  there is only one Levy contract in CRM for UKPRN '10017489' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    #And   the latest version of the contract has the following settings 
    #| Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    #| Draft  | Internally Approved    | Yes           | No                  | 1                     | 

    # Retrieve parameters from CRM  
   #When  I retrieve the latest EFA contract details from CRM for provider '10017489' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017489' 
#   And   I retrieve the latest contract details from CRM for provider '10017489' for FundingType 'LEVY' and period '1799' 

    # Publish the contract (This is needed because the injection step above leaves the contract in the wrong state)
    Given the latest version of contract 'APPLEVY-489' is in a state of 'Published to Provider'



 
    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017489 | 10017489 Co Ltd      | LEVY        | ESFA-489             | APPLEVY-489    | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017489 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017489 | LEVY              | LEVY1799                | APPLEVY-489    | LEVY-489            | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017489 | LEVY              | LEVY-489            | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017489 | LEVY              | LEVY-489            | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
 
    # Check deliverable period count 
    And   there are '2' deliverable period rows in CRM linked to the latest version of contract number 'APPLEVY-489' 

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017489 | APPLEVY-489        | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/05/2017        | ?               | ?             |
    | 10017489 | ESFA-489           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |



 
    # Change the date 
    Given the override date is '04/01/2018'  
	
	# Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-489' and ContractNumber 'APPLEVY-489' and Version '1' 
 
    # Check deliverable period count after approval 
    Then  there are '14' deliverable period rows in CRM linked to the latest version of contract number 'APPLEVY-489' 
 
    # After approval there should be a Jan-18 deliverable period for each of deliverables 1 through 14 for each allocation
    Then   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Jan-18   | DeliverableDescription                               | 
    | 10017489 | LEVY              | LEVY-489            | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017489 | LEVY              | LEVY-489            | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017489 | LEVY              | LEVY-489            | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017489 | LEVY              | LEVY-489            | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017489 | LEVY              | LEVY-489            | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017489 | LEVY              | LEVY-489            | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017489 | LEVY              | LEVY-489            | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017489 | LEVY              | LEVY-489            | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017489 | LEVY              | LEVY-489            | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017489 | LEVY              | LEVY-489            | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017489 | LEVY              | LEVY-489            | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017489 | LEVY              | LEVY-489            | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017489 | LEVY              | LEVY-489            | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017489 | LEVY              | LEVY-489            | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
 
    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017489 | APPLEVY-489        | 1                     | 0                        | Approved         | Approved               | True          | True                | 04/01/2018        | ?               | ?             | 
    | 10017489 | ESFA-489           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 
 
 


    # Initiate a TERMINATION.

    # Change the date
    Given the override date is '01/09/2018'

    # Request termination of the contract 
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'APPLEVY-489' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | TerminationReason       | TerminationComments     |
    | 02/10/2018               | 13/10/2018              | Provider Change         | Police involvement      |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | LEVY-489         | 02/10/2018                  | 13/10/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'APPLEVY-489' for UKPRN '10017489'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017489 - 10017489 Co Ltd     | APPLEVY-489    | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017489 | APPLEVY-489         | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 04/01/2018        | ?               | ?             |
    | 10017489 | ESFA-489            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |

    


    # Inject PoI 'actuals' BEFORE the Termination date (13/10/2018). These should be processed into CRM\PaaS (24713)
	
    # Change the date
    Given the override date is '04/10/2018'

    # Clear down the actuals 
    And   there are no entries in the DCFS stub table

    # Pull DCFS PoI actuals for Sep 2018
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS17               | ORG0017489     | CM             | 201809 | LEVY1799                | LEVY-489                 |         | 2               | 0            | 225.76      |
    | APPS           | APPS17               | ORG0017489     | CM             | 201809 | LEVY1799                | LEVY-489                 |         | 3               | 0            | 103.51      |
    | APPS           | APPS17               | ORG0017489     | CM             | 201809 | LEVY1799                | LEVY-489                 |         | 4               | 0            | 617.09      |
    | APPS           | APPS17               | ORG0017489     | CM             | 201809 | LEVY1799                | LEVY-489                 |         | 5               | 0            | 450.11      |
    | APPS           | APPS17               | ORG0017489     | CM             | 201809 | LEVY1799                | LEVY-489                 |         | 6               | 0            | 89.25       |
    | APPS           | APPS17               | ORG0017489     | CM             | 201809 | LEVY1799                | LEVY-489                 |         | 8               | 0            | 1013.88     |
    | APPS           | APPS17               | ORG0017489     | CM             | 201809 | LEVY1799                | LEVY-489                 |         | 9               | 0            | 649.16      |
    | APPS           | APPS17               | ORG0017489     | CM             | 201809 | LEVY1799                | LEVY-489                 |         | 10              | 0            | 500.01      |
    | APPS           | APPS17               | ORG0017489     | CM             | 201809 | LEVY1799                | LEVY-489                 |         | 11              | 0            | 101.51      |
    | APPS           | APPS17               | ORG0017489     | CM             | 201809 | LEVY1799                | LEVY-489                 |         | 12              | 0            | 2.00        |
    | APPS           | APPS17               | ORG0017489     | CM             | 201809 | LEVY1799                | LEVY-489                 |         | 13              | 0            | 944.45      |
    | APPS           | APPS17               | ORG0017489     | CM             | 201809 | LEVY1799                | LEVY-489                 |         | 14              | 0            | 882.23      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check deliverable period count  
    Then  there are '26' deliverable period rows in CRM linked to the latest version of contract number 'APPLEVY-489' 

    # Check the count of deliverable periods in PaaS (26)
    And   there is '1' deliverable period on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '1'
    And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '2'
    And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '3'
    And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '4'
    And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '5'
    And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '6'
    And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '13'
    And   there is '1' deliverable period on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '7'
    And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '8'
    And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '9'
    And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '10'
    And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '11'
    And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '12'
    And   there are '2' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '14'




    # Inject PoI 'actuals' AFTER the Termination date (13/12/2018). These should be processed into CRM\PaaS (24713)
	
    # Change the date
    Given the override date is '04/03/2019'

    # Clear down the actuals 
    And   there are no entries in the DCFS stub table

    # Pull DCFS PoI actuals for Feb 2019
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS22               | ORG0017489     | CM             | 201902 | LEVY1799                | LEVY-489                 |         | 2               | 0            | 316.81      |
    | APPS           | APPS22               | ORG0017489     | CM             | 201902 | LEVY1799                | LEVY-489                 |         | 3               | 0            | 433.79      |
    | APPS           | APPS22               | ORG0017489     | CM             | 201902 | LEVY1799                | LEVY-489                 |         | 4               | 0            | 969.55      |
    | APPS           | APPS22               | ORG0017489     | CM             | 201902 | LEVY1799                | LEVY-489                 |         | 5               | 0            | 472.10      |
    | APPS           | APPS22               | ORG0017489     | CM             | 201902 | LEVY1799                | LEVY-489                 |         | 6               | 0            | 492.45      |
    | APPS           | APPS22               | ORG0017489     | CM             | 201902 | LEVY1799                | LEVY-489                 |         | 8               | 0            | 1306.12     |
    | APPS           | APPS22               | ORG0017489     | CM             | 201902 | LEVY1799                | LEVY-489                 |         | 9               | 0            | 8264.78     |
    | APPS           | APPS22               | ORG0017489     | CM             | 201902 | LEVY1799                | LEVY-489                 |         | 10              | 0            | 1833.25     |
    | APPS           | APPS22               | ORG0017489     | CM             | 201902 | LEVY1799                | LEVY-489                 |         | 11              | 0            | 1608.45     |
    | APPS           | APPS22               | ORG0017489     | CM             | 201902 | LEVY1799                | LEVY-489                 |         | 12              | 0            | 65.20       |
    | APPS           | APPS22               | ORG0017489     | CM             | 201902 | LEVY1799                | LEVY-489                 |         | 13              | 0            | 676.84      |
    | APPS           | APPS22               | ORG0017489     | CM             | 201902 | LEVY1799                | LEVY-489                 |         | 14              | 0            | 242.99      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check deliverable period count 
    Then  there are '38' deliverable period rows in CRM linked to the latest version of contract number 'APPLEVY-489' 

    # Check the count of deliverable periods in PaaS (38)
    And   there is '1' deliverable period on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '1'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '2'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '3'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '4'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '5'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '6'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '13'
    And   there is '1' deliverable period on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '7'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '8'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '9'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '10'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '11'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '12'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '14'




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '20/03/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'APPLEVY-489' for provider '10017489' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017489 | APPLEVY-489         | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 04/01/2018        | ?               | ?             |
    | 10017489 | ESFA-489            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |




    # Complete the Termination

    # Change the date (This is ignored by CRM)
    Given the override date is '06/04/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination (23893)
#   When  CRM user 'FCS8 Test' completes the termination request for Contract 'APPLEVY-489' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' completes the termination request for Contract 'APPLEVY-489' Version '1' SubVersion '0' via SDK

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017489 | APPLEVY-489         | 1                     | 0                        | Closed         | Terminated                               | True          | True                | 04/01/2018        | 13/10/2018      | ?             |
    | 10017489 | ESFA-489            | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |




    # Inject PoI 'actuals' AFTER the Termination date (10/12/2018). These should be be ignored (24713)
	
    # Change the date
    Given the override date is '04/06/2019'

    # Clear down the actuals 
    And   there are no entries in the DCFS stub table

    # Pull DCFS PoI actuals for May 2019
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS25               | ORG0017489     | CM             | 201905 | LEVY1799                | LEVY-489                 |         | 2               | 0            | 786.88      |
    | APPS           | APPS25               | ORG0017489     | CM             | 201905 | LEVY1799                | LEVY-489                 |         | 3               | 0            | 173.79      |
    | APPS           | APPS25               | ORG0017489     | CM             | 201905 | LEVY1799                | LEVY-489                 |         | 4               | 0            | 559.56      |
    | APPS           | APPS25               | ORG0017489     | CM             | 201905 | LEVY1799                | LEVY-489                 |         | 5               | 0            | 409.16      |
    | APPS           | APPS25               | ORG0017489     | CM             | 201905 | LEVY1799                | LEVY-489                 |         | 6               | 0            | 411.55      |
    | APPS           | APPS25               | ORG0017489     | CM             | 201905 | LEVY1799                | LEVY-489                 |         | 8               | 0            | 2256.62     |
    | APPS           | APPS25               | ORG0017489     | CM             | 201905 | LEVY1799                | LEVY-489                 |         | 9               | 0            | 1004.78     |
    | APPS           | APPS25               | ORG0017489     | CM             | 201905 | LEVY1799                | LEVY-489                 |         | 10              | 0            | 2533.45     |
    | APPS           | APPS25               | ORG0017489     | CM             | 201905 | LEVY1799                | LEVY-489                 |         | 11              | 0            | 1008.55     |
    | APPS           | APPS25               | ORG0017489     | CM             | 201905 | LEVY1799                | LEVY-489                 |         | 12              | 0            | 98.50       |
    | APPS           | APPS25               | ORG0017489     | CM             | 201905 | LEVY1799                | LEVY-489                 |         | 13              | 0            | 104.64      |
    | APPS           | APPS25               | ORG0017489     | CM             | 201905 | LEVY1799                | LEVY-489                 |         | 14              | 0            | 108.79      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check deliverable period count hasn't changed
    Then  there are '38' deliverable period rows in CRM linked to the latest version of contract number 'APPLEVY-489' 

    # Check the count of deliverable periods in PaaS (38)
    And   there is '1' deliverable period on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '1'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '2'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '3'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '4'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '5'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '6'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '13'
    And   there is '1' deliverable period on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '7'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '8'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '9'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '10'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '11'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '12'
    And   there are '3' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'LEVY-489' for DeliverableCode '14'


    # Tidy up
    And   the override date is reset 
	  
	   