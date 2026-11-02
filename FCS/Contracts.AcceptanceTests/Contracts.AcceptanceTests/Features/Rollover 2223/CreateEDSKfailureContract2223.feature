Feature: CreateEDSKfailureContract2223

A short summary of the feature

@AcceptanceTest @Withdrawn20230118
Scenario: A284 Bulk load a new 2223 EDSK contract with an ATLP allocation. ContractType is Conditions of Funding (Grant) (Trust). No Delivery Org. Check docs then merge
    Given there are no allocations marked as Under Termination for UKPRN '10064284' 
    And   there are no terminated or closed allocations for UKPRN '10064284' 
    And   there is no Contract, Task or Workflow data for UKPRN '10064284' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty  

    And   there are no files prefixed 'EDSK AY 2223 16082022000001 TLEVELS' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2223 16082022000001 TLEVELS' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2223 16082022000001 TLEVELS.xlsx' exists in the Datafiles folder and UKPRN '10064284' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
     
