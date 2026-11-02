@AcceptanceTest
#TFS ID - 67
@#Feature67_Review_&_Release_Contract
Feature: Contract Review
	
#TFS User Story 386 - View Summary of Contract Allocations

Scenario: View summary of Contract Allocation(s) on contracts details view non-editable
	Given I am logged in as a Contract Adviser 'Sarah Smith' in the system
	And a contract exists with multiple contract allocations
	When I am on Contract Details page
	Then Contract Allocation Summary should be displayed in a table as follows
	| Contract Allocation Ref  | Funding Stream <Contract Allocation> | Contract Allocation Description | Contract Allocation Value (£) | Start Date | End Date | 
	And the column is sorted by Contract allocation reference and Start date

#TFS USer Story - 73 - View Details of a Contract Allocation

Scenario: View details of a contract allocation for a contract 
	Given I am logged in as a Contract Adviser 'Sarah Smith' in the system
	And a contract exists with multiple contract allocations
	When I select a contract allocation 
	Then details of Contract Allocation view should be displayed with following fields:
	| Field                         | Source     |
	| Contract Number               | Contract   |
	| Provider                      | Contract   |
	| Contract Owner                | Contract   |
	| Contract Status               | Contract   |
	| Sub Status                    | Contract   |
	| Version                       | Contract   |
	| Latest Version                | Contract   |
	| Last Approved Version         | Contract   |
	| Funding Stream                | Allocation |
	| Contract Allocation Value (£) | Allocation |
	| Funding Stream Period         | Allocation |
	| Start Date                    | Allocation |
	| End Date                      | Allocation |
	And Deliverables Summary should be displayed in a table as follows
	| Deliverable  | Planned Value (£)  | Planned Volume | 
	And Deliverable Summary is sorted by column Display Order (D)


#TFS USer Story - 74 - View Details of a Deliverable Line for a Contract Allocation
#@UserStory74

Scenario: View Details of a Deliverable Line for a Contract Allocation
	Given I am on a Contract Allocation details page 
	And the Contract Allocation is associated with multiple Deliverables
	When I select a Deliverable
	Then details of Deliverable is displayed with following fields:
	| Field                         | Source          |
	| Contract Number               | Contract        |
	| Provider                      | Contract        |
	| Contract Owner                | Contract        |
	| Contract Status               | Contract        |
	| Sub Status                    | Contract        |
	| Version                       | Contract        |
	| Latest Version                | Contract        |
	| Last Approved Version         | Contract        |
	| Contract Allocation Ref       | Allocation      |
	| Funding Stream                | Allocation      |
	| Contract Allocation Value (£) | Allocation      |
	| Funding Stream Period         | Allocation      |
	| Start Date                    | Allocation      |
	| End Date                      | Allocation      |
	| Deliverable Description       | Deliverable     |
	| Total Planned Value (£)       | Deliverable     |
	| Total Planned Volume          | Deliverable     |
	| Planning Unit                 | FSP Deliverable |
	And Deliverables Values should be displayed in a table as follows
	| Period | Planned Value (£)  | Planned Volume |
	And Deliverable Summary is sorted by Period
