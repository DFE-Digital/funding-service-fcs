Feature: CreateContract
	In order to create a contract
	As an Allocations Manager
	I want to upload an allocations file

@mytag
Scenario: Add two numbers
	Given create contract allocations file
	When the create contract allocations file is imported
	Then the contact abc1 is created at version 1
