Feature: Notify of Contract Amendment Approval against Draft Reconciliation (15023)

@AcceptanceTest @Withdrawn20211005
@FundingClaim
Scenario: A290 Amendment approved against a 1516 Mainstream contract where there are no funding claim reconciliations associated with any contract allocations under the contract - no notification should be issued
	# clear down
    Given there is no data in the CRM funding claim reconciliation tables 
    And the override date is '01/08/2015'
	And   there is no Contract, Task or Workflow data for UKPRN '10017290'
	And   there are no notifications of type 'Amendment Approval'
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | CL-290        |
	And   there is no Organisation data for UKPRN '10017290'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Acme Training Ltd' with UKPRN '10017290' and OrgId 'ORG0017290' and has 'FCS1 Test' as a manager
	
	# create approved contract
	And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017290 | Acme Training Ltd    | SFA-290              | MAIN-290       | 1                     | 01/08/2015        | 31/07/2016      | 2007.00       | Contract for Services | 1516   | New          | ORG0017290 |
    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName             | UoPCode | AllocationDescription  | CRMIntent    |
    | 10017290 | MAIN-290       | CL-290        | CL                | AY                      | 01/08/2015          | 31/07/2016        | 2007.00         |                     |         |                        | New          |
    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total    | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16   | DeliverableDescription                            | CRMIntent    |
    | MAIN-290       | CL-290        | 1               | 0                     | 2007.00  | 229.00   | 228.00   | 238.00   | 125.00   | 103.00   | 82.00    | 90.00    | 167.00   | 229.00   | 207.00   | 65.00    | 244.00   | Community Learning                                | New          |
	And   the contract exists in CRM

    And   the latest version of contract 'MAIN-290' is in a state of 'Published to Provider'
    And   approval is initiated for contract with master contract number 'SFA-290' and contract number 'MAIN-290' and version number '1'
    And   the status and sub-status of the latest version of contract 'MAIN-290' are changed to 'Approved'
    And   the latest version of contract 'MAIN-290' is marked as the last approved version
	
	And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017290 | Acme Training Ltd    | SFA-290              | MAIN-290       | 2                     | 01/08/2015        | 31/07/2016      | 2107.00       | Contract for Services | 1516   | New          | ORG0017290 |
    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName             | UoPCode | AllocationDescription  | CRMIntent    |
    | 10017290 | MAIN-290       | CL-290        | CL                | AY                      | 01/08/2015          | 31/07/2016        | 2107.00         |                     |         |                        | New          |
    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total    | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16   | DeliverableDescription                            | CRMIntent    |
    | MAIN-290       | CL-290        | 1               | 0                     | 2107.00  | 329.00   | 228.00   | 238.00   | 125.00   | 103.00   | 82.00    | 90.00    | 167.00   | 229.00   | 207.00   | 65.00    | 244.00   | Community Learning                                | New          |
	And   the amended contract exists in CRM with an Amendment Type of 'Variation'

    And   the latest version of contract 'MAIN-290' is in a state of 'Published to Provider'
    
	When  approval is initiated for contract with master contract number 'SFA-290' and contract number 'MAIN-290' and version number '2'
    
	Then  the status and sub-status of the latest version of contract 'MAIN-290' are changed to 'Approved'
    And   the latest version of contract 'MAIN-290' is marked as the last approved version
	
	# assert notification is not created
	And   a new notification for 'Amendment Approval-Allocation CL-290 - Community Learning' is not sent with Notification Type 'Amendment Approval'

@AcceptanceTest @Withdrawn20211005
@FundingClaim
Scenario: A292 Amendment approved against a 1516 Mainstream contract where there are 1 or more funding claim reconciliations in a status of 'Published' associated with contract allocations under the contract - no notifications should be issued
	# clear down
    Given there is no data in the CRM funding claim reconciliation tables
	And the override date is '01/08/2015'
    And   there is no Contract, Task or Workflow data for UKPRN '10017292'
	And   there are no notifications of type 'Amendment Approval'
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | CL-292        |    
	And   there is no Organisation data for UKPRN '10017292'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Acme Training Ltd' with UKPRN '10017292' and OrgId 'ORG0017292' and has 'FCS1 Test' as a manager
	
	# create approved contract
	And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017292 | Acme Training Ltd    | SFA-292              | MAIN-292       | 1                     | 01/08/2015        | 31/07/2016      | 2007.00       | Contract for Services | 1516   | New          | ORG0017292 |
    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName             | UoPCode | AllocationDescription  | CRMIntent    |
    | 10017292 | MAIN-292       | CL-292        | CL                | AY                      | 01/08/2015          | 31/07/2016        | 2007.00         |                     |         |                        | New          |
    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total    | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16   | DeliverableDescription                            | CRMIntent    |
    | MAIN-292       | CL-292        | 1               | 0                     | 2007.00  | 229.00   | 228.00   | 238.00   | 125.00   | 103.00   | 82.00    | 90.00    | 167.00   | 229.00   | 207.00   | 65.00    | 244.00   | Community Learning                                | New          |
	And   the contract exists in CRM

    And   the latest version of contract 'MAIN-292' is in a state of 'Published to Provider'
    And   approval is initiated for contract with master contract number 'SFA-292' and contract number 'MAIN-292' and version number '1'
    And   the status and sub-status of the latest version of contract 'MAIN-292' are changed to 'Approved'
    And   the latest version of contract 'MAIN-292' is marked as the last approved version

	# create published funding claim reconciliation
    And   funding claim reconciliation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | Status     |
    | 10017292 | 1516          | Final            | CL1516              | 1                  | 2007.00      | 1929.40      | 0.00                        | 0.00                | 1929.40          | Published  |
	And funding claim reconciliation allocation data is present in the CRM funding claim reconciliation allocation tables as follows
	| UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue |
	| 10017292 | 1516          | Final            | CL1516              | MAIN-292       | 1                     | 0                        | CL-292        | 3486.00      | 3493.20      | 0.00                        | 0.00                | 3493.20          |

	# amend contract
	And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017292 | Acme Training Ltd    | SFA-292              | MAIN-292       | 2                     | 01/08/2015        | 31/07/2016      | 2107.00       | Contract for Services | 1516   | New          | ORG0017292 |
    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName             | UoPCode | AllocationDescription  | CRMIntent    |
    | 10017292 | MAIN-292       | CL-292        | CL                | AY                      | 01/08/2015          | 31/07/2016        | 2107.00         |                     |         |                        | New          |
    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total    | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16   | DeliverableDescription                            | CRMIntent    |
    | MAIN-292       | CL-292        | 1               | 0                     | 2107.00  | 329.00   | 228.00   | 238.00   | 125.00   | 103.00   | 82.00    | 90.00    | 167.00   | 229.00   | 207.00   | 65.00    | 244.00   | Community Learning                                | New          |
	And   the amended contract exists in CRM with an Amendment Type of 'Variation'

    And   the latest version of contract 'MAIN-292' is in a state of 'Published to Provider'
    
	When  approval is initiated for contract with master contract number 'SFA-292' and contract number 'MAIN-292' and version number '2'
    
	Then  the status and sub-status of the latest version of contract 'MAIN-292' are changed to 'Approved'
    And   the latest version of contract 'MAIN-292' is marked as the last approved version
	
	# assert notification is not created
	And   a new notification for 'Amendment Approval-Allocation CL-292 - Community Learning' is not sent with Notification Type 'Amendment Approval'

