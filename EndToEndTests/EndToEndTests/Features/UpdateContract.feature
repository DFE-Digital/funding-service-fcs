Feature: UpdateContract
	In order to correct a draft contract
	As an Allocations Manager
	I want to upload an allocations file

@mytag
Scenario: Update contract
	Given update contract allocations file for contract abc123
	And draft contract abc123 version 2
	When the update file is imported
	Then the contact is updated
