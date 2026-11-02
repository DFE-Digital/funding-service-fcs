Feature: Feature Variables
	Tests for Feature Variable transformation

Background:
	Given feature variable '[ContractNo]' is set to 'MAIN-1234'
	And   feature variable '[AllocRef]' is set to 'ALLB-5678'

@AcceptanceTest @Complete
Scenario: T001 Tooling - Transform feature variable in step
	Then parameter 'MAIN-1234' is equal to parameter '[ContractNo]' 

@AcceptanceTest @Complete
Scenario: T002 Tooling - Transform feature variable inside other text in step
	Then parameter 'Contract: MAIN-1234' is equal to parameter 'Contract: [ContractNo]'

@AcceptanceTest @Complete
Scenario: T003 Tooling - Transform multiple feature variables inside other text in step
	Then parameter 'Contract: MAIN-1234, Allocation: ALLB-5678' is equal to parameter 'Contract: [ContractNo], Allocation: [AllocRef]'

@AcceptanceTest @Complete
Scenario: T004 Tooling - Transform empty string to empty string without effect in step
	Then parameter '' is equal to parameter ''

@AcceptanceTest @Complete
Scenario: T005 Tooling - Transform feature variable in table
	Then  the following table of values are equal
	| Expected  | Actual       |
	| MAIN-1234 | [ContractNo] |

@AcceptanceTest @Complete
Scenario: T006 Tooling - Transform feature variable inside other text in table
	Then  the following table of values are equal
	| Expected            | Actual                 |
	| Contract: MAIN-1234 | Contract: [ContractNo] |

@AcceptanceTest @Complete
Scenario: T007 Tooling - Transform multiple feature variables inside other text in table
	Then  the following table of values are equal
	| Expected                                   | Actual                                         |
	| Contract: MAIN-1234, Allocation: ALLB-5678 | Contract: [ContractNo], Allocation: [AllocRef] |

@AcceptanceTest @Complete
Scenario: T008 Tooling - Transform empty string to empty string without effect in table
	Then  the following table of values are equal
	| Expected | Actual |
	|          |        |
