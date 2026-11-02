Feature: DeletionFailure 21733

@AcceptanceTest @Withdrawn20231002
Scenario: A811 Create and approve a 1920 NLG contract. Attempt to delete contract. Fail. Check CRM and notification
    Given there are no allocations marked as Under Termination for UKPRN '10017811' 
    And   there are no terminated or closed allocations for UKPRN '10017811' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017811' 
	And   there are no notifications of type 'Contract Deletion Failed'
	And   there are no notifications of type 'Approval Received'
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017811' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | NLG-811       |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | NLG1920        |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017811' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017811 Co Ltd' with UKPRN '10017811' and OrgId 'ORG0017811' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017811' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017811 | 117811 | 10017811 Co Ltd | 0              | Active                | Yes           | AA017811      | ?             | 32a Park Lane          | ?                      | ?                      | ?                      | Poynton                | Cheshire               | SK12 1RE  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017811 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017811 | 10017811 Co Ltd      | ESFA-811             | NONLG-811      | 1                     | 01/08/2019        | 31/07/2020      | 44337.00      |                                    | Contract for Services                      | 1920   | New          | ORG0017811 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017811 | NONLG-811      | NLG-811       | NLG               | NLG1920                 | AY                      | 01/08/2019          | 31/07/2020        | 44337.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017811 | NONLG-811      | NLG-811       | 101             | 0                     | 16705.00  | 725.00   | 67.00    | 1056.00  | 1792.00  | 566.00   | 542.00   | 3334.00  | 2360.00  | 596.00   | 2187.00  | 3081.00  | 399.00   | Principals Reference Group (PRG)                                | New          |             |
    | 10017811 | NONLG-811      | NLG-811       | 102             | 0                     | 27632.00  | 1155.00  | 2395.00  | 1392.00  | 1684.00  | 3527.00  | 2682.00  | 2499.00  | 2064.00  | 3369.00  | 3156.00  | 1076.00  | 2633.00  | National Leaders of Further Education (NLFE)                    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'NONLG-811' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NONLG-811'




    # Change the date
    Given the override date is '17/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-811' and actual ContractNumber 'NONLG-811'

    # Check that the contract is now approved
    Then  the latest version of contract 'NONLG-811' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017811 | NONLG-811          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017811 | ESFA-811           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'NONLG-811'




    # Attempt to delete the contract. This should fail and create a Notification

    # Trigger WF28 in CRM to issue a contract delete request 
   #When  a request is initiated in CRM to delete the following contracts
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017811 | NONLG-811      | 1                     | 0                  |

    # Check that a deletion Failure Notification has been created and sent to the right User
#   Then  there is '1' notification of type 'Contract Deletion Failed' owned by team 'Document Management Team' which matches the following
    Then  there is '1' notification of type 'Contract Deletion Failed' owned by user 'FCS2 Test' which matches the following
    | Status | NotificationName                            | NotificationText                                                                                                                                                                         |
    | New    | Draft Contract Deletion Failed - NONLG-811  | Contract NONLG-811 v1 for provider 10017811 (10017811 Co Ltd) cannot be deleted - it must be in 'Draft' status with a substatus of 'Awaiting Documentation', 'Unassigned' or 'In Review' |

    # Check the CONTRACT version, status and dates in CRM. This should not have changed
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017811 | NONLG-811          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017811 | ESFA-811           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |


    # Tidy up
    And   the override date is reset

