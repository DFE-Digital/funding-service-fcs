Feature: AmendContract
	In order to change an approved contract
	As an Allocations Manager
	I want to upload an allocations file

@mytag
Scenario: AmendContract
	Given allocations file contract abc123
	And approved contract abc123 version 1
	When the file is imported
	Then the contact is amended to version 2
