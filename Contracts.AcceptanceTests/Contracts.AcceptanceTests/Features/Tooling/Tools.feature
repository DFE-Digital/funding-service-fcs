Feature: Tools
	Tools to help run system tasks in test environments

@Tooling
Scenario: T014 Trigger processing of staged ESF49 collection 
	Given the override date is '10/02/2020 12:47'
	And the PaaS MonthEndIsRunning indicator is set to 'False'

	When month-end processing is started
	And staged actuals collection type 'ESF' with return code 'ESF49' is processed	

@Tooling
Scenario: T015 Inject DAS events and trigger processing
	Given DAS events are created for the following UKPRNs
	| UKPRN    |
	| 10000108 |
	
	When  processing of provider not found DAS events is triggered