Feature: ApproveContract
	In order to pay a provider
	As a Contract Advisor
	I want to approve a contract

@mytag
Scenario: Approve a contract
	Given contract abc123 version 1
	When the Contract Advisor approves the contract
	Then the contract state is Approved
