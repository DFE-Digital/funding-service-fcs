Feature: FilesWithLotsOfData
   Load files with lots of data and then tidy up
#5000 new contracts and 5000 Amemendments to new contracts should be uploaded in 15 hours 
#100 contracts to be processed in 540 seconds

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P001 Feature_BulkLoad_New_Test_Load 50 new 24 + contracts in 270 seconds
    Given an excel spreadsheet '24+LOANS AY 1516 20042015133551 UKPRNct50.xlsx' exist at 'DataFiles\Performance' containing '50' contracts
    And   the contract data is now removed for ukprn beginning with '50010'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a file '24+LOANS AY 1516 20042015133551 UKPRNct50.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 540 seconds
    And   the total time taken is less than 270 seconds

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P001a Feature_BulkLoad_New_Test_Load 25 new 24 + contracts in 135 seconds
    Given an excel spreadsheet '24+LOANS AY 1516 20042015133551 UKPRNct25.xlsx' exist at 'DataFiles\Performance' containing '25' contracts
    And   the contract data is now removed for ukprn beginning with '50010'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a file '24+LOANS AY 1516 20042015133551 UKPRNct25.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 270 seconds
    And   the total time taken is less than 135 seconds

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P001b Feature_BulkLoad_New_Test_Load 100 new 24 + contracts in 540 seconds
    Given an excel spreadsheet '24+LOANS AY 1516 20042015133551 UKPRNct100.xlsx' exist at 'DataFiles\Performance' containing '100' contracts
    And   the contract data is now removed for ukprn beginning with '50010'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a file '24+LOANS AY 1516 20042015133551 UKPRNct100.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 1080 seconds
    And   the total time taken is less than 540 seconds

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P001c Feature_BulkLoad_New_Test_Load 200 new 24 + contracts in 1080 seconds
    Given an excel spreadsheet '24+LOANS AY 1516 20042015133551 UKPRNct200.xlsx' exist at 'DataFiles\Performance' containing '200' contracts
    And   the contract data is now removed for ukprn beginning with '50010'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a file '24+LOANS AY 1516 20042015133551 UKPRNct200.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 2160 seconds
    And   the total time taken is less than 1080 seconds
     
@PerformanceDaily
#@PerformanceWeekly
@ReportPerformance
Scenario: P002 Bulk load 25 new 1516 mainstream contracts in 135 seconds  
    Given an excel spreadsheet 'MAIN AY 1516 10042015154100 BUPerformance25.xlsx' exist at 'DataFiles\Performance' containing '25' contracts
    And   there is no contract data for any UKPRNs beginning with '50010'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a file 'MAIN AY 1516 10042015154100 BUPerformance25.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 270 seconds
    And   the total time taken is less than 200 seconds

@PerformanceDaily
#@PerformanceWeekly
@ReportPerformance
Scenario: P002a Bulk load 50 new 1516 mainstream contracts in 270 seconds  
    Given an excel spreadsheet 'MAIN AY 1516 10042015154100 BUPerformance50.xlsx' exists in 'DataFiles\Performance' containing '50' contracts
    And   there is no contract data for any UKPRNs beginning with '50010'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a file 'MAIN AY 1516 10042015154100 BUPerformance50.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 540 seconds
    And   the total time taken is less than 400 seconds

@PerformanceDaily
#@PerformanceWeekly
@ReportPerformance
Scenario: P002b Bulk load 100 new 1516 mainstream contracts in 540 seconds   
    Given an excel spreadsheet 'MAIN AY 1516 10042015154100 BUPerformance100.xlsx' exist at 'DataFiles\Performance' containing '100' contracts
    And   there is no contract data for any UKPRNs beginning with '50010'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a file 'MAIN AY 1516 10042015154100 BUPerformance100.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 1080 seconds
    And   the total time taken is less than 540 seconds

@PerformanceDaily
#@PerformanceWeekly
@ReportPerformance
Scenario: P002c Bulk load 200 new 1516 mainstream contracts in 1080 seconds  
    Given an excel spreadsheet 'MAIN AY 1516 10042015154100 BUPerformance200.xlsx' exist at 'DataFiles\Performance' containing '200' contracts
    And   there is no contract data for any UKPRNs beginning with '50010'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a file 'MAIN AY 1516 10042015154100 BUPerformance200.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 2160 seconds
    And   the total time taken is less than 1080 seconds

#@PerformanceDaily
@PerformanceWeekly
@ReportPerformance
Scenario: P002d Bulk load 500 new 1516 mainstream contracts in 2700 seconds  
    Given an excel spreadsheet 'MAIN AY 1516 10042015154100 BUPerformance500.xlsx' exist at 'DataFiles\Performance' containing '500' contracts
    And   there is no contract data for any UKPRNs beginning with '5001'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a file 'MAIN AY 1516 10042015154100 BUPerformance500.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 5400 seconds
    And   the total time taken is less than 2700 seconds

#@PerformanceDaily
@PerformanceWeekly
@ReportPerformance
Scenario: P002e Bulk load 1000 new 1617 mainstream contracts in 5400 seconds  
    Given an excel spreadsheet 'MAIN AY 1617 10042015154100 BUPerformance1000.xlsx' exist at 'DataFiles\Performance' containing '1000' contracts
    And   there is no contract data for any UKPRNs beginning with '5001'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a file 'MAIN AY 1617 10042015154100 BUPerformance1000.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 10800 seconds
    And   the total time taken is less than 5400 seconds

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P002f Feature_BulkLoad_New_Test_Load 50 new ESF contracts in 270 seconds 
    Given an excel spreadsheet 'ESF ESF 1420 10042015154100 ESFPerformance50.xlsx' exist at 'DataFiles\Performance' containing '50' contracts
    And   the contract data is now removed for ukprn beginning with '50010'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a file 'ESF AY 1516 10042015154100 ESFPerformance50.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 540 seconds
    And   the total time taken is less than 270 seconds
	
#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P003 Feature_BulkLoad_New_Test_Load 20 new EOP contracts in 108 seconds
    Given an excel spreadsheet 'EOP EOP 1517 27082015151111 PerfBulkLoad20.xlsx' exist at 'DataFiles\Performance' containing '20' contracts
    And   the contract data is now removed for ukprn beginning with '50010'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a file 'EOP EOP 1517 27082015151111 PerfBulkLoad20.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 216 seconds
    And   the total time taken is less than 108 seconds

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P003a Feature_BulkLoad_New_Test_Load 25 new EOP contracts in 135 seconds
    Given an excel spreadsheet 'EOP EOP 1517 27082015151111 PerfBulkLoad25.xlsx' exist at 'DataFiles\Performance' containing '25' contracts
    And   the contract data is now removed for ukprn beginning with '50010'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a file 'EOP EOP 1517 27082015151111 PerfBulkLoad25.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 270 seconds
    And   the total time taken is less than 135 seconds

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P003b Feature_BulkLoad_New_Test_Load 50 new EOP contracts in 270 seconds
    Given an excel spreadsheet 'EOP EOP 1517 27082015151111 PerfBulkLoad50.xlsx' exist at 'DataFiles\Performance' containing '50' contracts
    And   the contract data is now removed for ukprn beginning with '50010'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a file 'EOP EOP 1517 27082015151111 PerfBulkLoad50.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 540 seconds
    And   the total time taken is less than 270 seconds

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P003c Feature_BulkLoad_New_Test_Load 100 new EOP contracts in 540 seconds
    Given an excel spreadsheet 'EOP EOP 1517 27082015151111 PerfBulkLoad100.xlsx' exist at 'DataFiles\Performance' containing '100' contracts
    And   the contract data is now removed for ukprn beginning with '50010'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a file 'EOP EOP 1517 27082015151111 PerfBulkLoad100.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 1080 seconds
    And   the total time taken is less than 540 seconds

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P003d Feature_BulkLoad_New_Test_Load 200 new EOP contracts in 1080 seconds
    Given an excel spreadsheet 'EOP EOP 1517 27082015151111 PerfBulkLoad200.xlsx' exist at 'DataFiles\Performance' containing '200' contracts
    And   the contract data is now removed for ukprn beginning with '5001'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a file 'EOP EOP 1517 27082015151111 PerfBulkLoad200.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
    And   a results report excel spreadsheet is generated in the storage less than 2160 seconds
    And   the total time taken is less than 1080 seconds

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P012 Feature_BulkLoad_New_Test_Load a contract with more than 1000 deliverable periods
    Given an excel spreadsheet 'MAIN AY 1516 10042015161524 OLASS138_1000_Deliverables.xlsx' exist at 'DataFiles\Performance'	
    And   the contract data is now removed for ukprn beginning with '50010'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  a results report excel spreadsheet is generated in the storage less than 600 seconds
