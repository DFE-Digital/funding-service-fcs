Feature: CreateNCSContract 17529

@AcceptanceTest @Withdrawn20200717
Scenario: A694 Bulk import to create two new four-allocation 1718 NCS contracts for the same UoP but for different providers (No deliverable 6)
	Given there is no Contract, Task or Workflow data for UKPRN '10017694' 
	And   there is no Contract, Task or Workflow data for UKPRN '10017695' 
    And   there are no files prefixed 'NCS FY 1718 18012017112938 v2_A694' in the Sharepoint 'Processed' folder
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017694 Co Ltd' with UKPRN '10017694' and OrgId 'ORG0017694' and has 'FCS1 Test' as a manager
	And   caseload advisor 'FCS2 Test' is assigned to provider '10017695 Co Ltd' with UKPRN '10017695' and OrgId 'ORG0017695' and has 'FCS1 Test' as a manager

    # Change the date
	And   the override date is '12/01/2018'
  
	When  spreadsheet 'NCS FY 1718 18012017112938 v2_A694.xlsx' exists in the Datafiles folder and UKPRN '10017694' is present in cell 'A2' of the Contract tab
    And   the file is copied to the Sharepoint 'Input' folder
	Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is present in cell 'J2' of the 'Contract' tab of the results report
    And   there is '1' file prefixed 'NCS FY 1718 18012017112938 v2_A694' in the Sharepoint 'Processed' folder

@AcceptanceTest @Withdrawn20200717
Scenario: A696 Bulk import of a new four-allocation 1718 NCS contract with a wholly unrecognised UoP. CABR-006 (No Deliverable 6)
    Given there is no contract data for any UKPRNs beginning with '10017696'
    And   there are no files prefixed 'NCS FY 1718 18012017115650 v2_A696' in the Sharepoint 'Processed' folder
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017696 Co Ltd' with UKPRN '10017696' and OrgId 'ORG0017696' and has 'FCS1 Test' as a manager
	And   spreadsheet 'NCS FY 1718 18012017115650 v2_A696.xlsx' exists in the Datafiles folder and UKPRN '10017696' is present in cell 'A2' of the Contract tab

    # Change the date
	And   the override date is '12/01/2018'
	
    When  the file is copied to the Sharepoint 'Input' folder
	Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is present in cell 'J2' of the 'Contract' tab of the results report
    And   '[Contract Allocation] UoP must be valid for the Funding Stream Period' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   there is '1' file prefixed 'NCS FY 1718 18012017115650 v2_A696' in the Sharepoint 'Processed' folder

@AcceptanceTest @Withdrawn20200717
Scenario: A697 Bulk import of a new four-allocation 1718 NCS contract with a valid OLASS UoP. CABR-006 (No Deliverable 6)
    Given there is no contract data for any UKPRNs beginning with '10017697'
    And   there are no files prefixed 'NCS FY 1718 18012017124712 v2_A697' in the Sharepoint 'Processed' folder
	And   caseload advisor 'FCS2 Test' is assigned to provider '10017697 Co Ltd' with UKPRN '10017697' and OrgId 'ORG0017697' and has 'FCS1 Test' as a manager
    And   spreadsheet 'NCS FY 1718 18012017124712 v2_A697.xlsx' exists in the Datafiles folder and UKPRN '10017697' is present in cell 'A2' of the Contract tab

    # Change the date
	And   the override date is '12/01/2018'
	
    When  the file is copied to the Sharepoint 'Input' folder
	Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is present in cell 'J2' of the 'Contract' tab of the results report
    And   '[Contract Allocation] UoP must be valid for the Funding Stream Period' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   there is '1' file prefixed 'NCS FY 1718 18012017124712 v2_A697' in the Sharepoint 'Processed' folder

@AcceptanceTest @Withdrawn20200717
Scenario: A698 Bulk import of a new four-allocation 1718 NCS contract without a valid NCS UoP. CABR-024 (No Deliverable 6)
    Given there is no contract data for any UKPRNs beginning with '10017698'
    And   there are no files prefixed 'NCS FY 1718 18012017125211 v2_A698' in the Sharepoint 'Processed' folder
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017698 Co Ltd' with UKPRN '10017698' and OrgId 'ORG0017698' and has 'FCS1 Test' as a manager
    And   spreadsheet 'NCS FY 1718 18012017125211 v2_A698.xlsx' exists in the Datafiles folder and UKPRN '10017698' is present in cell 'A2' of the Contract tab

    # Change the date
	And   the override date is '12/01/2018'
	
    When  the file is copied to the Sharepoint 'Input' folder
	Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
	And   'Failed' is present in cell 'J2' of the 'Contract' tab of the results report
    And   '[Contract Allocation] UoP must be valid for the Funding Stream Period' is displayed in field 'J2' on the 'Contract' tab of the result report
	And   there is '1' file prefixed 'NCS FY 1718 18012017125211 v2_A698' in the Sharepoint 'Processed' folder

@AcceptanceTest @Withdrawn20230123
Scenario: A699 Bulk import of a new 1617 Mainstream AEBTO-LS allocation with a valid NCS UoP. CABR-006 (No deliverable 6)
    Given there is no contract data for any UKPRNs beginning with '10017699'
    And   there are no files prefixed 'MAIN AY 1617 18012017125758 v2_A699' in the Sharepoint 'Processed' folder
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017699 Co Ltd' with UKPRN '10017699' and OrgId 'ORG0017699' and has 'FCS1 Test' as a manager
    And   spreadsheet 'MAIN AY 1617 18012017125758 v2_A699.xlsx' exists in the Datafiles folder and UKPRN '10017699' is present in cell 'A2' of the Contract tab

    # Change the date
	And   the override date is '12/01/2017'
	
    When  the file is copied to the Sharepoint 'Input' folder
	Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is present in cell 'J2' of the 'Contract' tab of the results report
	And   '[Contract Allocation] UoP must be valid for the Funding Stream Period' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   there is '1' file prefixed 'MAIN AY 1617 18012017125758 v2_A699' in the Sharepoint 'Processed' folder

