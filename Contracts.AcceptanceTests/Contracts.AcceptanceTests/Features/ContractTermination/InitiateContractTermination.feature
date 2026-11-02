Feature: InitiateContractTermination

@AcceptanceTest @Withdrawn20200604
@UiTest
@ContractTermination
@Long2Run @Long2Run890
Scenario: A890 Create and approve an 1819 Mainstream contract with 16-18TRN (PoA), AEBC (PoP) and APPS (PoA) allocations. Request contract termination with a valid set of contract-level options. Check termination status and values in CRM. Reject request and re-check CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017890' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there are no notifications of type 'Contract Termination Initiation Rejected'

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16TR-890      |
    | AEC-890       |
    | APPS-890      |

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for this provider
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017890'

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017890' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017890 Co Ltd' with UKPRN '10017890' and OrgId 'ORG0017890' and has 'FCS1 Test' as a manager 
    And   UPIN '117890' is associated with UKPRN '10017890' in the CRM Organisation table 
 
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017890 | 117890 | 10017890 Co Ltd | 0              | Active | Yes           | AA017890      | ?             | 2 Stratfield Saye      | 20-22 Wellington Road  | ?                      | ?                      | ?                      | ?                      | BH8 8JN   |

    # Put data in the CRM Organisation table J057
    And   the following Organisations exist in CRM
    | UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017890 | 117890 | 10017890 Co Ltd | Active | AA017890      | ?             | 2 Stratfield Saye      | 20-22 Wellington Road  | ?                      | ?                      | ?                      | ?                      | BH8 8JN   |




    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017890 | 10017890 Co Ltd      | ESFA-890             | MAIN-890       | 1                     | 01/08/2018        | 31/07/2019      | 110395.00     |                                | Contract for Services | 1819   | New          | ORG0017890 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017890 | MAIN-890       | 16TR-890      | 16-18TRN          | 16-18TRN1819            | AY                      | 01/08/2018          | 31/07/2019        | 40447.00        |                         |            |                                                             | New          |             |
    | 10017890 | MAIN-890       | AEC-890       | AEBC              | AEBC1819                | AY                      | 01/08/2018          | 31/07/2019        | 47780.00        |                         |            |                                                             | New          |             |
    | 10017890 | MAIN-890       | APPS-890      | APPS              | APPS1819                | AY                      | 01/08/2018          | 30/06/2019        | 22168.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017890 | MAIN-890       | 16TR-890      | 1               | 0                     | 40447.00  | 1675.00  | 5803.00  | 1688.00  | 3568.00  | 4804.00  | 2209.00  | 4346.00  | 3308.00  | 2799.00  | 3637.00  | 876.00   | 5734.00  | Total 16-18 Traineeships Funding                                | New          |             |
    | 10017890 | MAIN-890       | 16TR-890      | 2               | 1                     | 24699.00  | 876.00   | 2213.00  | 1395.00  | 3291.00  | 1819.00  | 755.00   | 2581.00  | 2816.00  | 2322.00  | 2944.00  | 648.00   | 3039.00  | 16-18 Traineeships Programme Funding                            | New          |             |
    | 10017890 | MAIN-890       | 16TR-890      | 3               | 1                     | 15748.00  | 799.00   | 3590.00  | 293.00   | 277.00   | 2985.00  | 1454.00  | 1765.00  | 492.00   | 477.00   | 693.00   | 228.00   | 2695.00  | 16-18 Traineeships Bursary Funding                              | New          |             |
    | 10017890 | MAIN-890       | AEC-890       | 1               | 0                     | 47780.00  | 2130.00  | 3771.00  | 2389.00  | 2850.00  | 6508.00  | 5854.00  | 4152.00  | 4987.00  | 5578.00  | 1452.00  | 3767.00  | 4342.00  | Adult Education Budget Total Funding                            | New          |             |
    | 10017890 | MAIN-890       | AEC-890       | 13              | 1                     | 25619.00  | 2022.00  | 2126.00  | 852.00   | 1782.00  | 2812.00  | 2834.00  | 1526.00  | 3392.00  | 2890.00  | 377.00   | 2398.00  | 2688.00  | Community Learning                                              | New          |             |
    | 10017890 | MAIN-890       | AEC-890       | 14              | 1                     | 22161.00  | 108.00   | 1645.00  | 1537.00  | 1068.00  | 3696.00  | 3020.00  | 2626.00  | 1595.00  | 2768.00  | 1075.00  | 1369.00  | 1654.00  | Other AEB Funding                                               | New          |             |
    | 10017890 | MAIN-890       | APPS-890      | 1               | 0                     | 22168.00  | 3547.00  | 499.00   | 2440.00  | 1337.00  | 436.00   | 736.00   | 337.00   | 1651.00  | 3600.00  | 2056.00  | 5529.00  | ?        | Apprenticeships Carry-In Total Funding                          | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract 'MAIN-890' is in a state of 'Published to Provider'

    # Change the date
    And   the override date is '03/07/2018'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-890' and actual ContractNumber 'MAIN-890'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-890' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017890 | MAIN-890           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017890 | ESFA-890           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Change the date
    Given the override date is '15/09/2018'

	# Request termination of the contract via the CRM UI
	When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-890' Version '1' SubVersion '0' with the following options
	| DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments  |
	| 01/10/2018               | 31/12/2018              | Yes                         | Provider in Liquidation | Terminating contract |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | 16TR-890         | 01/10/2018                  | 31/12/2018                |
    | AEC-890          | 01/10/2018                  | 31/12/2018                |
    | APPS-890         | 01/10/2018                  | 31/12/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
    And   the user forwards the termination request for manager approval via UI
#   And   the user forwards the termination request for manager approval via SDK

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017890 | MAIN-890       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017890 | ESFA-890       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
	| ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason  | TerminationComments  |
	| MAIN-890       | 1                     | 0                        | 31/12/2018              | Yes                         | Deactivated UKPRN  | Terminating contract |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
	| AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
	| 16TR-890         | 1                     | 0                        | 01/10/2018        | 31/12/2018                |
	| AEC-890          | 1                     | 0                        | 01/10/2018        | 31/12/2018                |
	| APPS-890         | 1                     | 0                        | 01/10/2018        | 31/12/2018                |



	# Manager rejects termination request (23810)
	When  CRM user 'FCS5 Test' rejects the termination request for Contract 'MAIN-890' Version '1' SubVersion '0' with free-text reason 'Termination requested in error'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus  | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017890 | MAIN-890       | 1                     | 0                        | Approved       | Approved           | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017890 | ESFA-890       | 1                     | 0                        | Draft          | ?                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check that the termination approval TASK is marked as completed
    Then  the following Tasks are present against version '1' of contract 'MAIN-890' for provider '10017890'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017890 - 10017890 Co Ltd      | MAIN-890       | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Check the WORKFLOW HISTORY
    And   the workflow history on contract 'MAIN-890' version '1' includes the following
    | Action                        | CompletedBy     | Comment                         |
    | Reject Termination Initiation | FCS5 Test       | Termination requested in error  |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationReason       | TerminationComments  |
    | MAIN-890       | 1                     | 0                        | ?                       | ?                       | ?                    |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
	| 16TR-890         | 1                     | 0                        | ?                 | ?                         |
	| AEC-890          | 1                     | 0                        | ?                 | ?                         |
	| APPS-890         | 1                     | 0                        | ?                 | ?                         |

    # Check that a rejection NOTIFICATION has been created and sent to the user initiating the termination
	And   there is '1' notification of type 'Contract Termination Initiation Rejected' owned by user 'FCS8 Test' which matches the following
    | Status | NotificationName                                     | NotificationText                                                                                                                           |
    | New    | Contract Termination Initiation Rejected - MAIN-890  | Termination initiation for contract MAIN-890 v1 for provider 10017890 (10017890 Co Ltd) has been rejected - Termination requested in error |
	

	# Tidy up
	And   the override date is reset
	
@AcceptanceTest @Withdrawn20200604
@UiTest
@ContractTermination
Scenario: A891 Create and approve an 1819 Mainstream contract with 16-18TRN (PoA), AEBC (PoP) and APPS (PoA) allocations. Request contract termination with a valid set of allocation-level options. Check termination status and values in CRM. Reject request and re-check CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017891' 
	And   there are no notifications of type 'Contract Termination Initiation Rejected'
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16TR-891      |
    | AEC-891       |
    | APPS-891      |

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for this provider
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017891'

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017891' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017891 Co Ltd' with UKPRN '10017891' and OrgId 'ORG0017891' and has 'FCS1 Test' as a manager 
    And   UPIN '117891' is associated with UKPRN '10017891' in the CRM Organisation table 
 
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017891 | 117891 | 10017891 Co Ltd | 0              | Active | Yes           | AA017891      | ?             | 76 Moorfield Road      | Denham Green           | ?                      | ?                      | Uxbridge               | Middlesex              | UB9 5NF   |

    # Put data in the CRM Organisation table J057
    And   the following Organisations exist in CRM
    | UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017891 | 117891 | 10017891 Co Ltd | Active | AA017891      | ?             | 76 Moorfield Road      | Denham Green           | ?                      | ?                      | Uxbridge               | Middlesex              | UB9 5NF   |




    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017891 | 10017891 Co Ltd      | ESFA-891             | MAIN-891       | 1                     | 01/08/2018        | 31/07/2019      | 110395.00     |                                | Contract for Services | 1819   | New          | ORG0017891 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017891 | MAIN-891       | 16TR-891      | 16-18TRN          | 16-18TRN1819            | AY                      | 01/08/2018          | 31/07/2019        | 40447.00        |                         |            |                                                             | New          |             |
    | 10017891 | MAIN-891       | AEC-891       | AEBC              | AEBC1819                | AY                      | 01/08/2018          | 31/07/2019        | 47780.00        |                         |            |                                                             | New          |             |
    | 10017891 | MAIN-891       | APPS-891      | APPS              | APPS1819                | AY                      | 01/08/2018          | 30/06/2019        | 22168.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017891 | MAIN-891       | 16TR-891      | 1               | 0                     | 40447.00  | 1675.00  | 5803.00  | 1688.00  | 3568.00  | 4804.00  | 2209.00  | 4346.00  | 3308.00  | 2799.00  | 3637.00  | 876.00   | 5734.00  | Total 16-18 Traineeships Funding                                | New          |             |
    | 10017891 | MAIN-891       | 16TR-891      | 2               | 1                     | 24699.00  | 876.00   | 2213.00  | 1395.00  | 3291.00  | 1819.00  | 755.00   | 2581.00  | 2816.00  | 2322.00  | 2944.00  | 648.00   | 3039.00  | 16-18 Traineeships Programme Funding                            | New          |             |
    | 10017891 | MAIN-891       | 16TR-891      | 3               | 1                     | 15748.00  | 799.00   | 3590.00  | 293.00   | 277.00   | 2985.00  | 1454.00  | 1765.00  | 492.00   | 477.00   | 693.00   | 228.00   | 2695.00  | 16-18 Traineeships Bursary Funding                              | New          |             |
    | 10017891 | MAIN-891       | AEC-891       | 1               | 0                     | 47780.00  | 2130.00  | 3771.00  | 2389.00  | 2850.00  | 6508.00  | 5854.00  | 4152.00  | 4987.00  | 5578.00  | 1452.00  | 3767.00  | 4342.00  | Adult Education Budget Total Funding                            | New          |             |
    | 10017891 | MAIN-891       | AEC-891       | 13              | 1                     | 25619.00  | 2022.00  | 2126.00  | 852.00   | 1782.00  | 2812.00  | 2834.00  | 1526.00  | 3392.00  | 2891.00  | 377.00   | 2398.00  | 2688.00  | Community Learning                                              | New          |             |
    | 10017891 | MAIN-891       | AEC-891       | 14              | 1                     | 22161.00  | 108.00   | 1645.00  | 1537.00  | 1068.00  | 3696.00  | 3020.00  | 2626.00  | 1595.00  | 2768.00  | 1075.00  | 1369.00  | 1654.00  | Other AEB Funding                                               | New          |             |
    | 10017891 | MAIN-891       | APPS-891      | 1               | 0                     | 22168.00  | 3547.00  | 499.00   | 2440.00  | 1337.00  | 436.00   | 736.00   | 337.00   | 1651.00  | 3600.00  | 2056.00  | 5529.00  | ?        | Apprenticeships Carry-In Total Funding                          | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract 'MAIN-891' is in a state of 'Published to Provider'

    # Change the date
    And   the override date is '03/07/2018'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-891' and actual ContractNumber 'MAIN-891'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-891' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017891 | MAIN-891           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017891 | ESFA-891           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Change the date
    Given the override date is '15/09/2018'

	# Request termination of the contract via the CRM UI
	When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-891' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments  |
    | 01/10/2018               | 31/12/2018              | No                          | Provider in Liquidation | Terminating contract |

	And   with the following allocation termination options
	| AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
	| 16TR-891         | 01/11/2018                  | 08/11/2018                |
	| AEC-891          | 01/12/2018                  | 08/12/2018                |
	| APPS-891         | 01/10/2018                  | 31/12/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
    And   the user forwards the termination request for manager approval via UI
#   And   the user forwards the termination request for manager approval via SDK

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017891 | MAIN-891       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017891 | ESFA-891       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
	| ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments  |
	| MAIN-891       | 1                     | 0                        | 31/12/2018              | Terminating contract |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
	| AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
	| 16TR-891         | 1                     | 0                        | 01/11/2018        | 08/11/2018                |
	| AEC-891          | 1                     | 0                        | 01/12/2018        | 08/12/2018                |
	| APPS-891         | 1                     | 0                        | 01/10/2018        | 31/12/2018                |



	# Manager rejects termination request (23810)
	When  CRM user 'FCS5 Test' rejects the termination request for Contract 'MAIN-891' Version '1' SubVersion '0' with free-text reason 'Termination request inappropriate'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus  | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017891 | MAIN-891       | 1                     | 0                        | Approved       | Approved           | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017891 | ESFA-891       | 1                     | 0                        | Draft          | ?                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check that the termination approval TASK is marked as completed
    Then  the following Tasks are present against version '1' of contract 'MAIN-891' for provider '10017891'
    | Task                                       | Description                     | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017891 - 10017891 Co Ltd      | MAIN-891       | FCS5 Test                 | Contract Managers Team   | Completed       | Completed        |

    # Check the WORKFLOW HISTORY
    And   the workflow history on contract 'MAIN-891' version '1' includes the following
    | Action                        | CompletedBy     | Comment                            |
    | Reject Termination Initiation | FCS5 Test       | Termination request inappropriate  |

    # Check CONTRACT termination values in CRM
    And   the following contract termination values are present in CRM
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationReason       | TerminationComments  |
    | MAIN-891       | 1                     | 0                        | ?                       | ?                       | ?                    |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
    | 16TR-891         | 1                     | 0                        | ?                 | ?                         |
    | AEC-891          | 1                     | 0                        | ?                 | ?                         |
    | APPS-891         | 1                     | 0                        | ?                 | ?                         |

    # Check that a rejection NOTIFICATION has been created and sent to the user initiating the termination
   #And   there are notifications of type 'Contract Termination Initiation Rejected' owned by the 'Document Management Team' as follows
#    And   there are notifications of type 'Contract Termination Initiation Rejected' owned by the user 'FCS8 Test' as follows
	And   there is '1' notification of type 'Contract Termination Initiation Rejected' owned by user 'FCS8 Test' which matches the following
    | Status | NotificationName                                     | NotificationText                                                                                                                              |
    | New    | Contract Termination Initiation Rejected - MAIN-891  | Termination initiation for contract MAIN-891 v1 for provider 10017891 (10017891 Co Ltd) has been rejected - Termination request inappropriate |
	

	# Tidy up
	And   the override date is reset

@AcceptanceTest @Withdrawn20200604
@UiTest
@Long2Run @Long2Run890
@ContractTermination
Scenario: A892 Create and approve an 1819 Mainstream contract with 16-18TRN (PoA), AEBC (PoP) and APPS (PoA) allocations. Request contract termination with a variety of invalid contract and allocation-level options. Check UI validation rules CVR1, CVR2, CVR3, CVR4, CVR5, CAVR1, CAVR2, CAVR3, CAVR4, CAVR5, CAFV1, CAFV2.
    Given there is no Contract, Task or Workflow data for UKPRN '10017892' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16TR-892      |
    | AEC-892       |
    | APPS-892      |

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for this provider
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017892'

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017892' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017892 Co Ltd' with UKPRN '10017892' and OrgId 'ORG0017892' and has 'FCS1 Test' as a manager 
    And   UPIN '117892' is associated with UKPRN '10017892' in the CRM Organisation table 
 
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017892 | 117892 | 10017892 Co Ltd | 0              | Active | Yes           | AA017892      | ?             | 504 Bunyan Court       | Barbican               | London                 | ?                      | ?                      | ?                      | EC2Y 8DH  |

    # Put data in the CRM Organisation table J057
    And   the following Organisations exist in CRM
    | UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017892 | 117892 | 10017892 Co Ltd | Active | AA017892      | ?             | 504 Bunyan Court       | Barbican               | London                 | ?                      | ?                      | ?                      | EC2Y 8DH  |




    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017892 | 10017892 Co Ltd      | ESFA-892             | MAIN-892       | 1                     | 01/08/2018        | 31/07/2019      | 110395.00     |                                | Contract for Services | 1819   | New          | ORG0017892 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017892 | MAIN-892       | 16TR-892      | 16-18TRN          | 16-18TRN1819            | AY                      | 01/08/2018          | 31/07/2019        | 40447.00        |                         |            |                                                             | New          |             |
    | 10017892 | MAIN-892       | AEC-892       | AEBC              | AEBC1819                | AY                      | 01/08/2018          | 31/07/2019        | 47780.00        |                         |            |                                                             | New          |             |
    | 10017892 | MAIN-892       | APPS-892      | APPS              | APPS1819                | AY                      | 01/08/2018          | 30/06/2019        | 22168.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017892 | MAIN-892       | 16TR-892      | 1               | 0                     | 40447.00  | 1675.00  | 5803.00  | 1688.00  | 3568.00  | 4804.00  | 2209.00  | 4346.00  | 3308.00  | 2799.00  | 3637.00  | 876.00   | 5734.00  | Total 16-18 Traineeships Funding                                | New          |             |
    | 10017892 | MAIN-892       | 16TR-892      | 2               | 1                     | 24699.00  | 876.00   | 2213.00  | 1395.00  | 3291.00  | 1819.00  | 755.00   | 2581.00  | 2816.00  | 2322.00  | 2944.00  | 648.00   | 3039.00  | 16-18 Traineeships Programme Funding                            | New          |             |
    | 10017892 | MAIN-892       | 16TR-892      | 3               | 1                     | 15748.00  | 799.00   | 3590.00  | 293.00   | 277.00   | 2985.00  | 1454.00  | 1765.00  | 492.00   | 477.00   | 693.00   | 228.00   | 2695.00  | 16-18 Traineeships Bursary Funding                              | New          |             |
    | 10017892 | MAIN-892       | AEC-892       | 1               | 0                     | 47780.00  | 2130.00  | 3771.00  | 2389.00  | 2850.00  | 6508.00  | 5854.00  | 4152.00  | 4987.00  | 5578.00  | 1452.00  | 3767.00  | 4342.00  | Adult Education Budget Total Funding                            | New          |             |
    | 10017892 | MAIN-892       | AEC-892       | 13              | 1                     | 25619.00  | 2022.00  | 2126.00  | 852.00   | 1782.00  | 2812.00  | 2834.00  | 1526.00  | 3392.00  | 2892.00  | 377.00   | 2398.00  | 2688.00  | Community Learning                                              | New          |             |
    | 10017892 | MAIN-892       | AEC-892       | 14              | 1                     | 22161.00  | 108.00   | 1645.00  | 1537.00  | 1068.00  | 3696.00  | 3020.00  | 2626.00  | 1595.00  | 2768.00  | 1075.00  | 1369.00  | 1654.00  | Other AEB Funding                                               | New          |             |
    | 10017892 | MAIN-892       | APPS-892      | 1               | 0                     | 22168.00  | 3547.00  | 499.00   | 2440.00  | 1337.00  | 436.00   | 736.00   | 337.00   | 1651.00  | 3600.00  | 2056.00  | 5529.00  | ?        | Apprenticeships Carry-In Total Funding                          | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract 'MAIN-892' is in a state of 'Published to Provider'

    # Change the date
    And   the override date is '03/07/2018'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-892' and actual ContractNumber 'MAIN-892'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-892' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017892 | MAIN-892           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017892 | ESFA-892           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    



    # Change the date
    Given the override date is '15/09/2018'




    ## Ensure rule CVR1 is enforced ##
    
    # Request termination of the contract without a Default Stop New Starts Date but with a Contract Termination Date
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-892' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate |
    | ?                        | 31/12/2018              |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
    And   the user forwards the termination request for manager approval via UI
#   And   the user forwards the termination request for manager approval via SDK

    Then  the contract termination has failed with the following validation errors
    | ValidationError                                                                                    |
    | The default Stop New Starts Date must be specified if Contract Termination Date has been specified |




    ## Ensure rule CVR2 is enforced ##

    # Request termination of the contract with a Contract Termination Date later than the Contract End Date
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-892' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate |
    | 01/10/2018               | 01/08/2019              |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
    And   the user forwards the termination request for manager approval via UI
#   And   the user forwards the termination request for manager approval via SDK

    Then  the contract termination has failed with the following validation errors
    | ValidationError                                                        |
    | Contract Termination Date must not be later than the Contract End Date |




    ## Ensure rule CVR3 is enforced ##

    # Request termination of the contract with a Default Stop New Starts Date later than the Contract Termination Date
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-892' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate |
    | 01/10/2018               | 30/09/2018              |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
    And   the user forwards the termination request for manager approval via UI
#   And   the user forwards the termination request for manager approval via SDK

    Then  the contract termination has failed with the following validation errors
    | ValidationError                                                                       |
    | The default Stop New Starts Date must not be later than the Contract Termination Date |




    ## Ensure rule CVR4 is enforced ##

    # Request termination of the contract with a Default Stop New Starts Date later than the Contract End Date
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-892' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate |
    | 01/08/2019               | ?                       |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
    And   the user forwards the termination request for manager approval via UI
#   And   the user forwards the termination request for manager approval via SDK

    Then  the contract termination has failed with the following validation errors
    | ValidationError                                                               |
    | The default Stop New Starts Date must not be later than the Contract End Date |




    # The following rule was removed as part of story 25209

#    ## Ensure rule CVR5 is enforced ##
#
#    # Request termination of the contract with a Default Stop New Starts Date prior to 01/08/2018
#    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-892' Version '1' SubVersion '0' with the following options
#    | DefaultStopNewStartsDate | ContractTerminationDate |
#    | 31/07/2018               | ?                       |
#
#    # Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#    And   the user forwards the termination request for manager approval via UI
#    And   the user forwards the termination request for manager approval via SDK
#
#    Then  the contract termination has failed with the following validation errors
#    | ValidationError                                                           |
#    | The default Stop New Starts Date must not be earlier than 1st August 2018 |




    ## Ensure rule CAVR1 is enforced ##

    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-892' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate |
    | ?                        | ?                       |

    # Request termination of the allocation without a Stop New Starts Date but with a Termination Date
    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | APPS-892         | ?                           | 31/12/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
    And   the user forwards the termination request for manager approval via UI
#   And   the user forwards the termination request for manager approval via SDK

    Then  the contract termination has failed with the following validation errors
    | ValidationError                                                                                           |
    | A contract allocation's Stop New Starts Date must be specified if its Termination Date has been specified |




    ## Ensure rule CAVR2 is enforced ##

    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-892' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate |
    | ?                        | ?                       |

    # Request termination of the allocation with a Termination Date later than the allocation end date
    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | APPS-892         | 01/10/2018                  | 01/07/2019                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
    And   the user forwards the termination request for manager approval via UI
#   And   the user forwards the termination request for manager approval via SDK

    Then  the contract termination has failed with the following validation errors
    | ValidationError                                                                             |
    | Any contract allocation's Termination Date must not be later than the allocation's End Date |




    ## Ensure rule CAVR3 is enforced ##

    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-892' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate |
    | 01/10/2018               | 31/12/2018              |

    # Request termination of the allocation with a Termination Date later than the contract Termination Date
    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | APPS-892         | 01/10/2018                  | 01/01/2019                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
    And   the user forwards the termination request for manager approval via UI
#   And   the user forwards the termination request for manager approval via SDK

    Then  the contract termination has failed with the following validation errors
    | ValidationError                                                                                 |
    | Any contract allocation's Termination Date must not be later than the Contract Termination Date |




    ## Ensure rule CAVR4 is enforced ##

    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-892' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate |
    | ?                        | ?                       |

    # Request termination of the allocation with a Stop New Starts Date later than the Termination Date
    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | APPS-892         | 01/10/2018                  | 30/09/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
    And   the user forwards the termination request for manager approval via UI
#   And   the user forwards the termination request for manager approval via SDK

    Then  the contract termination has failed with the following validation errors
    | ValidationError                                                                                         |
    | Any contract allocation's Stop New Starts Date must not be later than the allocation's Termination Date |




    # The following rule was removed as part of story 25209
    
#    ## Ensure rule CAVR5 is enforced ##
#
#    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-892' Version '1' SubVersion '0' with the following options
#    | DefaultStopNewStartsDate | ContractTerminationDate |
#    | ?                        | ?                       |
#
#    # Request termination of the allocation with a Stop New Starts Date earlier than 01/08/2018
#    And   with the following allocation termination options
#    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
#    | APPS-892         | 31/07/2018                  | 30/09/2018                |
#
#	 # Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#    And   the user forwards the termination request for manager approval via UI
#    And   the user forwards the termination request for manager approval via SDK
#
#    Then  the contract termination has failed with the following validation errors
#    | ValidationError                                                |
#    | Stop New Starts Dates must not be earlier than 1st August 2018 |




    ## Ensure rule CAFV1 is enforced ##

    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-892' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate |
    | 01/10/2018               | 31/12/2018              |

    # Request termination of a specific allocation without specifying (or using the contract) Stop New Starts Date and Termination Date
    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | APPS-892         | ?                           | ?                         |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
    And   the user forwards the termination request for manager approval via UI
#   And   the user forwards the termination request for manager approval via SDK

    Then  the contract termination has failed with the following validation errors
    | ValidationError                                                                                                                             |
    | Stop New Starts Dates and Termination Dates must be specified for every contract allocation if Contract Termination Date has been specified |
    



    ## Ensure rule CAFV2 is enforced ##

    # Request termination without specifying Stop New Starts Dates or Termination Dates at both contract and allocation level
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-892' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate |
    | ?                        | ?                       |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
    And   the user forwards the termination request for manager approval via UI
#   And   the user forwards the termination request for manager approval via SDK

    Then  the contract termination has failed with the following validation errors
    | ValidationError                                                                                |
    | At least one contract allocation must have either a Stop New Starts Date or a Termination Date |



    # Tidy up
    And   the override date is reset
    
