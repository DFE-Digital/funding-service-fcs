Feature: BulkImportFileStuck 5076

@AcceptanceTest @Complete 
@ValidationContractFileCheck
Scenario: A183 Process a same-name 1617 Mainstream file which fails syntax validation twice (E2)
    Given a file prefixed 'MAIN AY 1617 09122016000000 v2_10040044_ct1_16-18APPS_MissingContractTab.xlsx' exists in 'DataFiles\BusinessRules'
    And   there are no files prefixed 'MAIN AY 1617 09122016000000 v2_10040044_ct1_16-18APPS_MissingContractTab' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1617 09122016000000 v2_10040044_ct1_16-18APPS_MissingContractTab' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1617 09122016000000 v2_10040044_ct1_16-18APPS_MissingContractTab' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1617 09122016000000 v2_10040044_ct1_16-18APPS_MissingContractTab' in the Sharepoint 'Reports' folder

   # Drop the file into Input folder
    When  the file is copied to the Sharepoint 'Input' folder

   # Check where the files have gone and what has been created
    Then  there are '0' files prefixed 'MAIN AY 1617 09122016000000 v2_10040044_ct1_16-18APPS_MissingContractTab' in the Sharepoint 'Input' folder
    And   there are '0' files prefixed 'MAIN AY 1617 09122016000000 v2_10040044_ct1_16-18APPS_MissingContractTab' in the Sharepoint 'Processing' folder
    And   there is '1' file prefixed 'MAIN AY 1617 09122016000000 v2_10040044_ct1_16-18APPS_MissingContractTab' in the Sharepoint 'Processed' folder and marked as Rejected
    And   there is '1' file prefixed 'MAIN AY 1617 09122016000000 v2_10040044_ct1_16-18APPS_MissingContractTab' in the Sharepoint 'Reports' folder and suffixed 'Syntax Report.txt' and marked as Rejected
    And   there are '0' files prefixed 'MAIN AY 1617 09122016000000 v2_10040044_ct1_16-18APPS_MissingContractTab' in the Sharepoint 'Reports' folder and suffixed 'Results Report.xlsx' and marked as Rejected

   # Drop the file into the Input folder a second time
    When  the file is copied to the Sharepoint 'Input' folder

   # Check where the files have gone and what has been created
    Then  there are '0' files prefixed 'MAIN AY 1617 09122016000000 v2_10040044_ct1_16-18APPS_MissingContractTab' in the Sharepoint 'Input' folder
    And   there are '0' files prefixed 'MAIN AY 1617 09122016000000 v2_10040044_ct1_16-18APPS_MissingContractTab' in the Sharepoint 'Processing' folder
    And   there are '2' files prefixed 'MAIN AY 1617 09122016000000 v2_10040044_ct1_16-18APPS_MissingContractTab' in the Sharepoint 'Processed' folder and marked as Rejected
    And   there are '2' files prefixed 'MAIN AY 1617 09122016000000 v2_10040044_ct1_16-18APPS_MissingContractTab' in the Sharepoint 'Reports' folder and suffixed 'Syntax Report.txt' and marked as Rejected
    And   there are '0' files prefixed 'MAIN AY 1617 09122016000000 v2_10040044_ct1_16-18APPS_MissingContractTab' in the Sharepoint 'Reports' folder and suffixed 'Results Report.xlsx' and marked as Rejected
