@#Feature656_Contract_Data_Load__New_Contracts
Feature: Contract Bulk Upload File Validation
	If there are any errors on the bulk upload file 
	then it should fail to process and error message is populated

@ContractBulkUploadFileValidation @FSR006
@AcceptanceTest @Withdrawn20221104
Scenario: E078 Funding Type Code not valid (FSR006)
			Period Type Code not valid	
			Period not valid
Given an excel spreadsheet exists named '32+LOANS BA 2434 10022015152601 94122226.xlsx' with a UKPRN '94122226'
And the Funding Type Code is '32+LOANS'
And the Period Type Code is 'BA'
And the Period is '2434'
When the file is copied from the source location to the 'NServiceBus Location'
Then an error message is returned 'Funding Type specified is not a valid Funding Type'
And error message is returned 'Period Type specified is not a valid Period Type'
And error message is returned 'Period specified is not a valid Period'
And the file is not processed

@ContractBulkUploadFileValidation  @FSR005a
@AcceptanceTest @Withdrawn20221104
Scenario: E079 Funding Type Code in file name not same as Funding Type in 'Control Sheet' tab (FSR005a)
Given an excel spreadsheet exists named 'MAIN AY 1516 10022015152601 94122225.xlsx' with a UKPRN '94122225'
And the Funding Type Code is '24+LOANS'
When the file is copied from the source location to the 'NServiceBus Location'
Then an error message is returned 'Funding Type Code in file name should match the Funding Type Code in the 'Control Sheet' tab'
And the file is not processed

@ContractBulkUploadFileValidation  @FSR009
@AcceptanceTest @Withdrawn20221104
Scenario: E080 Funding Type, Period Type, Period Combination not valid (FSR009)
Given an excel spreadsheet exists named '24+LOANS EOF 1317 10022015152601 94122227.xlsx' with a UKPRN '94122227'
And the Funding Type Code is '24+LOANS'
And the Period Type Code is 'EOF'
And the Period is '1317'
When the file is copied from the source location to the 'NServiceBus Location'
Then an error message is returned 'The combination of Funding Type, Period Type and Period is not a valid combination'
And the file is not processed
			
