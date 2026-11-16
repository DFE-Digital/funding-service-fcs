Feature: Create New Contract Numbers
	When I upload an excel file with new contracts
	As a CRM user
	I want to be able to see new contract numbers generated in CRM

@mytag
Scenario: Capture the latest Mainstream contract number from CRM
	Given a Mainstrean contract exists with a contract number within CRM
	When I query the lastest Mainstream contract from the CRM database
	Then the latest Mainstream contract number is returned

Scenario: Create a new Mainstream contract with a new contract number witn an existing UKPRN
	Given that an excel spreadsheet exists with a UKPRN of 'UKPRN001'
	And a Funding Type of 'Mainstream'
	When I upload the spreadsheet into CRM
	Then a new contract number is generated in Format: <MAIN>-<n>
	And will increment by 1 from the latest contract number	

Scenario: Create a 2nd new Mainstream contract with a new contract number
	Given that an excel spreadsheet exists with a UKPRN of 'UKPRN002'
	And a Funding Type of 'Mainstream'
	When I upload the spreadsheet into CRM
	Then a new contract number is generated in Format: <MAIN>-<n>
	And will increment by 1 from the latest contract number	

Scenario: Capture the latest ESF contract number from CRM
	Given an ESF contract exists with a contract number within CRM
	When I query the lastest ESF contract from the CRM database
	Then the latest ESF contract number is returned

Scenario: Create a new ESF contract with a new contract number
	Given that an excel spreadsheet exists with a UKPRN of 'UKPRN003'
	And a Funding Type of 'ESF'
	When I upload the spreadsheet into CRM
	Then a new contract number is generated in Format: <ESF>-<n>

Scenario: Capture the latest AGE contract number from CRM
	Given an AGE contract exists with a contract number within CRM
	When I query the lastest AGE contract from the CRM database
	Then the latest AGE contract number is returned

Scenario: Create a new AGE contract with a new contract number
	Given that an excel spreadsheet exists with a UKPRN of 'UKPRN003'
	And a Funding Type of 'AGE'
	When I upload the spreadsheet into CRM
	Then a new contract number is generated in Format: <AGE>-<n>

Scenario: Capture the latest 24+ Loans Facility contract number from CRM
	Given a 24+ Loans Facility contract exists with a contract number within CRM
	When I query the lastest 24+ Loans Facility contract from the CRM database
	Then the latest 24+ Loans Facility contract number is returned

Scenario: Create a new 24+ Loans Facility contract with a new contract number
	Given that an excel spreadsheet exists with a UKPRN of 'UKPRN003'
	And a Funding Type of '24+ Loans Facility'
	When I upload the spreadsheet into CRM
	Then a new contract number is generated in Format: <24+ALLF>-<n>

Scenario: Capture the latest EOP contract number from CRM
	Given an EOP contract exists with a contract number within CRM
	When I query the lastest EOP contract from the CRM database
	Then the latest EOP contract number is returned

Scenario: Create a new EOP contract with a new contract number
	Given that an excel spreadsheet exists with a UKPRN of 'UKPRN003'
	And a Funding Type of 'EOP'
	When I upload the spreadsheet into CRM
	Then a new contract number is generated in Format: <EOP>-<n>

Scenario: Capture the latest EOF contract number from CRM
	Given an EOF contract exists with a contract number within CRM
	When I query the lastest EOF contract from the CRM database
	Then the latest EOF contract number is returned

Scenario: Create a new EOF contract with a new contract number
	Given that an excel spreadsheet exists with a UKPRN of 'UKPRN003'
	And a Funding Type of 'EOF'
	When I upload the spreadsheet into CRM
	Then a new contract number is generated in Format: <EOF>-<n>