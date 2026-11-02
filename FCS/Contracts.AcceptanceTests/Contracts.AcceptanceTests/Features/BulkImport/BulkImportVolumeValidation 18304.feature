Feature: BulkImportVolumeValidation 18304

@AcceptanceTest @Withdrawn20230123
Scenario: A976 Bulk upload failure on a new ESF contract. Volume greater than 1 but with non-zero decimal value (RSR-003b)
    Given there is no contract data for any UKPRNs beginning with '10017976'
    And   there are no files prefixed '10017976_ESIF' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 17022017133109 v2_A976' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 17022017133109 v2_A976' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 17022017133109 v2_A976.xlsx' exists in the Datafiles folder and UKPRN '10017976' is present in cell 'A2' of the Contract tab
   
    # Drop file into Input folder

    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder

    # Check the file has failed and no contracts have been created in CRM

    And   'Failed' is displayed in field 'N2' on the 'Deliverable' tab of the result report file
    And   '[Deliverable] Volume must be a whole number' is displayed in field 'N2' on the 'Deliverable' tab of the result report file
    And   there are no contracts in CRM for UKPRN '10017976'

