Feature: PaddingAndTrimmingNCSUoPCodes 18087

@AcceptanceTest @Withdrawn20230123
Scenario: A833 Bulk upload a new 4-allocation 1718 NCS contract with an unrecognised UoP. CABR-006
    Given there is no contract data for any UKPRNs beginning with '10017833'
    And   there are no files prefixed 'NCS FY 1718 26012017142825 v2_A833' in the Sharepoint 'Processed' folder
    And   spreadsheet 'NCS FY 1718 26012017142825 v2_A833.xlsx' exists in the Datafiles folder and UKPRN '10017833' is present in cell 'A2' of the Contract tab

    # Change the date
	And   the override date is '12/01/2018'
 
    When  the file is copied to the Sharepoint 'Input' folder
	Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is present in cell 'J2' of the 'Contract' tab of the results report
    And   '[Contract Allocation] UoP must be valid for the Funding Stream Period' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   there is '1' file prefixed 'NCS FY 1718 26012017142825 v2_A833' in the Sharepoint 'Processed' folder

@AcceptanceTest @Withdrawn20200717
Scenario: A834 Bulk upload a new 4-allocation 1718 NCS contract with a numeric UoP larger than 10 digits. CABR-006
   Given there is no contract data for any UKPRNs beginning with '10017834'
    And   there are no files prefixed 'NCS FY 1718 26012017142833 v2_A834' in the Sharepoint 'Processed' folder
    And   spreadsheet 'NCS FY 1718 26012017142833 v2_A834.xlsx' exists in the Datafiles folder and UKPRN '10017834' is present in cell 'A2' of the Contract tab

    # Change the date
	And   the override date is '12/01/2018'
 
    When  the file is copied to the Sharepoint 'Input' folder
	Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is present in cell 'J2' of the 'Contract' tab of the results report
    And   '[Contract Allocation] UoP must be valid for the Funding Stream Period' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   there is '1' file prefixed 'NCS FY 1718 26012017142833 v2_A834' in the Sharepoint 'Processed' folder

@AcceptanceTest @Withdrawn20200717
Scenario: A835 Bulk upload a new 4-allocation 1718 NCS contract with an alphanum UoP. CABR-006
    Given there is no contract data for any UKPRNs beginning with '10017835'
    And   there are no files prefixed 'NCS FY 1718 26012017142839 v2_A835' in the Sharepoint 'Processed' folder
    And   spreadsheet 'NCS FY 1718 26012017142839 v2_A835.xlsx' exists in the Datafiles folder and UKPRN '10017835' is present in cell 'A2' of the Contract tab

    # Change the date
	And   the override date is '12/01/2018'
 
    When  the file is copied to the Sharepoint 'Input' folder
	Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is present in cell 'J2' of the 'Contract' tab of the results report
    And   '[Contract Allocation] UoP must be valid for the Funding Stream Period' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   there is '1' file prefixed 'NCS FY 1718 26012017142839 v2_A835' in the Sharepoint 'Processed' folder

