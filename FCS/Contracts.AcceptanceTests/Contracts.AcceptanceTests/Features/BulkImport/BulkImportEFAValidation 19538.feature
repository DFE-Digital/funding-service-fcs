Feature: BulkImportEFAValidation 19538

@AcceptanceTest @Withdrawn20200717
@RSR007
Scenario: A328 Ensure RSR007 detects the presence of a Delivery Organisation on a new 1718 Mainstream contract
	Given there is no Contract, Task or Workflow data for UKPRN '10017328'

	# Change the date 
    And   the override date is '21/07/2017' 

	# Cleardown prior to bulk import
	And   there are no files prefixed 'MAIN AY 1718 22042016155603 RSR007' in the Sharepoint 'Processed' folder
	And   there are no files prefixed 'MAIN AY 1718 22042016155603 RSR007' in the Sharepoint 'Reports' folder

	# Bulk import to create a new contract
	And   an excel spreadsheet 'MAIN AY 1718 22042016155603 RSR007.xlsx' exist at 'DataFiles\BusinessRules'
	When  the file for syntax validation is copied from the source location to the 'Input'
	Then  I should see a file for syntax validation success report
	And   a results report excel spreadsheet is generated in the storage 
	And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

	# RSR007 failure message(s)
	And   '[Contract Allocation] Delivery Organisations cannot be specified for Funding Type: MAIN Funding Period: AY1718 contracts' is displayed in field 'X2' on the 'Contract Allocation' tab of the result report
	And   '[Deliverable] Delivery Organisations cannot be specified for Funding Type: MAIN Funding Period: AY1718 contracts' is displayed in field 'O2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20200717
@RSR008
Scenario: A329 Ensure RSR008 detects the absence of a Delivery Organisation on a new 1718 EFA(1619F) contract
    Given there is no Contract, Task or Workflow data for UKPRN '10017329'

    # Change the date 
    And   the override date is '17/07/2017' 

    # Cleardown prior to bulk import
    And   there are no files prefixed '1619FUND AY 1718 13062017093545 v3_RSR008' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 13062017093545 v3_RSR008' in the Sharepoint 'Reports' folder

    # Bulk import to create a new contract
    And   an excel spreadsheet '1619FUND AY 1718 13062017093545 v3_RSR008.xlsx' exist at 'DataFiles\BusinessRules'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  I should see a file for syntax validation success report
    And   a results report excel spreadsheet is generated in the storage 
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # RSR008 failure message(s)
    And   '[Contract Allocation] If Delivery Organisations are applicable, they must be specified against all Contract Allocations and Deliverables for the Contract' is displayed in field 'X3' on the 'Contract Allocation' tab of the result report
    And   '[Deliverable] If Delivery Organisations are applicable, they must be specified against all Contract Allocations and Deliverables for the Contract' is displayed in field 'O2' on the 'Deliverable' tab of the result report

@AcceptanceTest @Withdrawn20200717
@RSR008
Scenario: A330 Ensure RSR008 detects the absence of a Delivery Organisation on a new 1718 EFA(1619F) deliverable
    Given there is no Contract, Task or Workflow data for UKPRN '10017330'

    # Change the date 
    And   the override date is '12/07/2017' 

    # Cleardown prior to bulk import
    And   there are no files prefixed '1619FUND AY 1718 13062017093548 v3_RSR008' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 13062017093548 v3_RSR008' in the Sharepoint 'Reports' folder

    # Bulk import to create a new contract
    And   an excel spreadsheet '1619FUND AY 1718 13062017093548 v3_RSR008.xlsx' exist at 'DataFiles\BusinessRules'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  I should see a file for syntax validation success report
    And   a results report excel spreadsheet is generated in the storage 
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # RSR008 failure message(s)
    And   '[Contract Allocation] If Delivery Organisations are applicable, they must be specified against all Contract Allocations and Deliverables for the Contract' is displayed in field 'X3' on the 'Contract Allocation' tab of the result report
    And   '[Deliverable] If Delivery Organisations are applicable, they must be specified against all Contract Allocations and Deliverables for the Contract' is displayed in field 'O2' on the 'Deliverable' tab of the result report

