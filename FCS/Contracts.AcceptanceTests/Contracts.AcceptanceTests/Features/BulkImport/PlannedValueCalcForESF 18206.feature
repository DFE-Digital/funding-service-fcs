Feature: PlannedValueCalcForESF 18206

@AcceptanceTest @Withdrawn20230123
Scenario: A841 Create new ESF contract with UnitCost * Volume <> Value. Fail (DBR-018)
    Given there is no contract data for any UKPRNs beginning with '10017841'
    And   there are no files prefixed '10017841_ESIF' in the Sharepoint 'ESF-1420-Input-Appendices' folder
	And   there are no files prefixed 'ESF ESF 1420 08022017113231 v2_A841' in the Sharepoint 'Processed' folder
	And   there are no files prefixed 'ESF ESF 1420 08022017113231 v2_A841' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 08022017113231 v2_A841.xlsx' exists in the Datafiles folder and UKPRN '10017841' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Fail' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   '[Deliverable] Value does not equal Unit Cost x Volume' is displayed in field 'J2' on the 'Contract' tab of the result report

@AcceptanceTest @Withdrawn20230123
Scenario: A842 Create new ESF contract with Value and Volume but no UnitCost. Fail (DBR-017)
    Given there is no contract data for any UKPRNs beginning with '10017842'
    And   there are no files prefixed '10017842_ESIF' in the Sharepoint 'ESF-1420-Input-Appendices' folder
	And   there are no files prefixed 'ESF ESF 1420 08022017113613 v2_A842' in the Sharepoint 'Processed' folder
	And   there are no files prefixed 'ESF ESF 1420 08022017113613 v2_A842' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 08022017113613 v2_A842.xlsx' exists in the Datafiles folder and UKPRN '10017842' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Fail' is displayed in field 'J2' on the 'Contract' tab of the result report
   #And   '[Deliverable] Value does not equal Unit Cost x Volume' is displayed in field 'J2' on the 'Contract' tab of the result report
	And   '[Deliverable] Deliverable Unit Cost must be the same for each deliverable period for the same deliverable for the same funding stream code' is displayed in field 'J2' on the 'Contract' tab of the result report

@AcceptanceTest @Withdrawn20230123
Scenario: A843 Create new ESF contract with Value and UnitCost but no Volume. Fail (DBR-016)
    Given there is no contract data for any UKPRNs beginning with '10017843'
    And   there are no files prefixed '10017843_ESIF' in the Sharepoint 'ESF-1420-Input-Appendices' folder
	And   there are no files prefixed 'ESF ESF 1420 08022017114143 v2_A843' in the Sharepoint 'Processed' folder
	And   there are no files prefixed 'ESF ESF 1420 08022017114143 v2_A843' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 08022017114143 v2_A843.xlsx' exists in the Datafiles folder and UKPRN '10017843' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Fail' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   '[Deliverable] Value does not equal Unit Cost x Volume' is displayed in field 'J2' on the 'Contract' tab of the result report

