Feature: SFS Publication
	A Lead manager should be able to bulk select and initiate Publish contract
	And the files is moved from the output folder to doc Library 

@AcceptanceTest @Complete
@SFS
@PublishFilesToSharepointLibrary
@DocMove
Scenario: B038 DOCMOVE5_Ensure workflow is directed back to Contract Manager with sub-Status 'Awaiting Internal Approval' with task is created on rejection by Lead manager 
	Given there is no Contract, Task or Workflow data for UKPRN '22228786'
    And   there is no Organisation data for UKPRN '22228786'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'DOCMOVER2 Ltd' with UKPRN '22228786' and OrgId 'ORG2228786' and has 'FCS1 Test' as a manager
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName     | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 22228786 | DOCMOVER2 Ltd | SFA-786              | MAIN-786       | 1                     | 01/08/2015        | 31/07/2016      | 1795.00       | Contract for Services | 1516   | New       | ORG2228786 |
	And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent |
    | 22228786 | MAIN-786       | CL-786        | CL                | AY                      | 01/08/2015          | 31/07/2016        | 1795.00         |         |         |                       | New       |
	And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 | DeliverableDescription | CRMIntent |
    | MAIN-786       | CL-786        | 1               | 0                     | 53.00  | 44.00  | 34.00  | 26.00  | 744.00 | 12.00  | 14.00  | 47.00  | 739.00 | 24.00  | 36.00  | 22.00  | Community Learning     | New       |
	And  the contract exists in CRM
	And  the contract status is set to 'Draft'
	And  the contract sub-status is updated to 'Internally Approved' for contract 'MAIN-786'
	And  the contract task owner is updated to 'Lead Manager Team' for contract 'MAIN-786'
	When the latest version of contract 'MAIN-786' is 'Revert back to Awaiting Internal Approval'
	Then the contract sub-status is now set to 'Awaiting Internal Approval'
	Then  the following Tasks are present against version '1' of contract 'MAIN-786' for provider '22228786'
    | Task                       | Description              | Regarding   | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval  | 22228786 - DOCMOVER2 Ltd |  MAIN-786   | FCS1 Test			      | Contract Managers Team   | Open            | Not Started      |
	#And a new Task record for contract 'MAIN-786' is created as follows
	#| Task                      | Description              | Regarding | Assigned Team          | Owner      |
	#| Confirm Internal Approval | 22228786 - DOCMOVER2 Ltd | MAIN-786  | Contract Managers Team | FCS1 Test |

