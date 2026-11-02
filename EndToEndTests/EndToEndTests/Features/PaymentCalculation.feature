Feature: PaymentCalculation
	In order to pay a provider
	As the FCS service
	I want to calculate payments based on imported summarised actuals

@mytag
Scenario: Payment Calculation
	Given approved contract abc123 ready for payment
	And summarised actuals for period 1 in FCS system
	When the payment calculation is invoked
	Then payments are added to the contract period 1
