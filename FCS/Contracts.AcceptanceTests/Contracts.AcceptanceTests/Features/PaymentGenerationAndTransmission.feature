@PaymentGenerationAndTransmission
@#Feature4357_Payment_Generation_&_Transmission
Feature: Payment Generation & Transmission
	Payment Generation Service batch run for a funding stream period/calendar period due for payment.

@AcceptanceTest @Withdrawn20200505
Scenario: B041 PG1_ESF_Payment run is successful for FSP/Calendar Period when Census End Date/Time is before today and Status is 'NotStarted' (PoP, PoA & Capping)
		Given the below Subnominal Aggregations exist in the data store
		| UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type   | AggregatedValue |
		| 40404011 | ORG0400001 | ESFC-01           | 2306800         | ESF1420                    | 201604               | RECONCILIATION | 7000.00         |
		| 40404011 | ORG0400001 | ESFC-01           | 2306600         | ESF1420                    | 201604               | CAPPING        | -100.00         |
		#And   Files are deleted from PTS Sharepoint folder
		#And   Files and folder are deleted from FTP Server
		# PaymentGeneration.PaymentBatchFeedItem
		And   there is no data in the Payment feed for FundingStreamPeriod 'ESF1420' PaymentPeriod '201601' CensusEndDate '09/05/2016' and LinkCodeSuffix 'A'
		And the below configuration exists in the Payment Timetable
		| Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
		| ESF1420                    | 201604               |                      | A              | NotStarted |
		And the override date is '05/09/2016 22:01'
#		And the below configuration exists in the Account Codes table
#		| Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#		| 40404011 | ESF1420                    | CODA511   | 8113000      | 01/08/1990           | 31/08/2020         |
		And the below ESF Allocation exist in the data store
		| Contract Number | Allocation Number | Agreement Number | LEP Code | LEP Name			 |
		| ESFIF-462       | ESFC-01           |       10345678901| E37038   | Worcestershire LEP |
		When the Payment Generation Batch run is started
		Then there is an entry in the Payment Timetable
		| Funding Stream Period Code | Calendar Year/Period | Status    |
		| ESF1420                    | 201604               | Completed |
#		#And   Payment file 'ESFC20160109A.pay' is created in PTS Sharepoint Folder for Funding Stream Period Code 'ESF1420' and Period '201604'
#		And   Payment file 'ESFC20160109A.pay' is created in the Ftp Folder
#		And the following data exists in the payment file
#		| LineType | LinkCode    | Company Code | Element 1 | Element 2 | Element 3 | Element 4 | ExternalRef 3 | Amount  | Subnominal Short Description | Element 25 |
#		| 157      | ESFC160109A | SFA          | E37038    | +         | 8113000   | CODA511   | 10345678901   | 100.00  | Adult Skills Cap May16       | 2306600    |
#		| 158      | ESFC160109A | SFA          | E37038    | +         | 2306600   | 5000      | 10345678901   | 100.00  | Adult Skills Cap May16       | CODA511    |
#		| 157      | ESFC160109A | SFA          | E37038    | +         | 8113000   | CODA511   | 10345678901   | 7000.00 | 19+ Apps Rec May16           | 2306800    |
#		| 158      | ESFC160109A | SFA          | E37038    | +         | 2306800   | 5000      | 10345678901   | 7000.00 | 19+ Apps Rec May16           | CODA511    |
#		#And   Payment file 'ESFC20160109A.nat' is created in PTS Sharepoint Folder for Funding Stream Period Code 'ESF1420' and Period '201604'
#		And   Payment file 'ESFC20160109A.nat' is created in the Ftp Folder
#		And the following data exists in the Summary file
#		| Payment File Name  | Number of Payment Instructions | Value of Payment Instruction | Error File Name | Number of Payment Error | Value of Payment Error |
#		| ESFC20160109A.pay  | 2                              | 6900.00                      | N/A             | 0                       | 0.00                   |
		And there is an entry in the Payment History Table
		| Funding Stream Period Code | Period | Description                                   |
		| ESF1420                    | 201604 | Payment timetable status changed to Completed |

@AcceptanceTest @Withdrawn20200505
Scenario: B043 PG5_Ensure Payment run is triggered, dummy account code generated and error file produced if there is missing Account Code, and Payment Instruction file generated for record with Account Code
		Given the below Subnominal Aggregations exist in the data store
		| UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type | AggregatedValue |
		| 40404005 | ORG0400005 | 16AP-05           | 2201300         | 16-18APPS1516              | 201508               | PROFILE      | 2000.00         |
		| 40404006 | ORG0400006 | 16AP-06           | 2201060         | 16-18APPS1516              | 201508               | PROFILE      | 1000.00         |
		| 40404001 | ORG0400001 | 16AP-07           | 2201065         | 16-18APPS1516              | 201508               | PROFILE      | 25000.00        |
		| 40404002 | ORG0400002 | 16AP-08           | 2201350         | 16-18APPS1516              | 201508               | PROFILE      | 7000.00         |
		#And   Files are deleted from PTS Sharepoint folder
		#And   Files and folder are deleted from FTP Server
		# PaymentGeneration.PaymentBatchFeedItem
		And   there is no data in the Payment feed for FundingStreamPeriod '16-18APPS1516' PaymentPeriod '201505' CensusEndDate '03/08/2015' and LinkCodeSuffix 'A'
		And the below configuration exists in the Payment Timetable
		| Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
		| 16-18APPS1516              | 201508               | 03/08/2015 09:15     | A              | NotStarted |
#		And the below configuration exists in the Account Codes table
#		| Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#		| 40404001 | 16-18APPS1516              | CODA501   | 8115000      | 01/08/2015           | 31/08/2016         |
#		| 40404002 | 16-18APPS1516              | CODA502   | 8115000      | 01/08/2015           | 31/08/2016         |
		When the Payment Generation Batch run is started
		Then there is an entry in the Payment Timetable
		| Funding Stream Period Code | Calendar Year/Period | Status    |
		| 16-18APPS1516              | 201508               | Completed |
#		#And   Payment file 'AP1620150503A.err' is created in PTS Sharepoint Folder for Funding Stream Period Code '16-18APPS1516' and Period '201508'
#		And   Payment file 'AP1620150503A.err' is created in the Ftp Folder
#		And the following data exists in the payment file
#		| LineType | LinkCode    | Company Code | Element 1 | Element 2 | Element 3 | Element 4 | Amount  | Subnominal Short Description   | Element 25 |
#		| 157      | AP16150503A | SFA          | ALC40     | +         | 8115000   | PZZZ99    | 2000.00 | 16-18Traineeships Prf Sep15    | 2201300    |
#		| 158      | AP16150503A | SFA          | ALC40     | +         | 2201300   | 5000      | 2000.00 | 16-18Traineeships Prf Sep15    | PZZZ99     |
#		| 157      | AP16150503A | SFA          | ALC40     | +         | 8115000   | PZZZ99    | 1000.00 | 16-18Apps LngSupport Prf Sep15 | 2201060    |
#		| 158      | AP16150503A | SFA          | ALC40     | +         | 2201060   | 5000      | 1000.00 | 16-18Apps LngSupport Prf Sep15 | PZZZ99     |
#		#And   Payment file 'AP1620150503A.pay' is created in PTS Sharepoint Folder for Funding Stream Period Code '16-18APPS1516' and Period '201508'
#		And   Payment file 'AP1620150503A.pay' is created in the Ftp Folder
#		And the following data exists in the payment file
#		| LineType | LinkCode    | Company Code | Element 1 | Element 2 | Element 3 | Element 4 | Amount   | Subnominal Short Description    | Element 25 |
#		| 157      | AP16150503A | SFA          | ALC40     | +         | 8115000   | CODA501   | 25000.00 | 16-18AppsLrnrSupport Prf Sep15  | 2201065    |
#		| 158      | AP16150503A | SFA          | ALC40     | +         | 2201065   | 5000      | 25000.00 | 16-18AppsLrnrSupport Prf Sep15  | CODA501    |
#		| 157      | AP16150503A | SFA          | ALC40     | +         | 8115000   | CODA502   | 7000.00  | 16-18TraineeshipBurs Prf Sep15  | 2201350    |
#		| 158      | AP16150503A | SFA          | ALC40     | +         | 2201350   | 5000      | 7000.00  | 16-18TraineeshipBurs Prf Sep15  | CODA502    |
#		#And   Payment file 'AP1620150503A.nat' is created in PTS Sharepoint Folder for Funding Stream Period Code '16-18APPS1516' and Period '201508'
#		And   Payment file 'AP1620150503A.nat' is created in the Ftp Folder
#   	And the following data exists in the Summary file
#       | Payment File Name | Number of Payment Instructions | Value of Payment Instruction | Error File Name   | Number of Payment Error | Value of Payment Error |
#		| AP1620150503A.pay | 2                              | 32000.00                     | AP1620150503A.err | 2                       | 3000.00                |
		And there is an entry in the Payment History Table
		| Funding Stream Period Code | Period | Description                                   |
		| 16-18APPS1516              | 201508 | Payment timetable status changed to Completed | 

@AcceptanceTest @Withdrawn20200505
Scenario: B044 PG6_Ensure Payment Re-run can be triggered for a completed/failed run and Linkcode Suffix is only updated for the completed run
		Given there is no data in the Payment feed for the following
		| Funding Stream Period Code | Payment Period | Census End Date | Link Code Suffix |
		| 16-18APPS1516              | 201505         | 03/08/2015      | A                |
		| 16-18APPS1516              | 201505         | 03/08/2015      | B                |
		| ASTO1516                   | 201505         | 03/08/2015      | A                |
		| ASTO1516                   | 201505         | 03/08/2015      | B                |

		And the below Subnominal Aggregations exist in the data store
		| UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type | AggregatedValue |
		| 40404005 | ORG0004005 | 16AP-05           | 2201300         | 16-18APPS1516              | 201508               | PROFILE      | 2000.00         |
		| 40404001 | 04001      | ASTO-01           | 2306860         | ASTO1516                   | 201508               | PROFILE      | 3000.00         |
		
		And the below configuration exists in the Payment Timetable
		| Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | Status     | LinkCodeSuffix |
		| 16-18APPS1516              | 201508               | 03/08/2015 09:15     | NotStarted | A              |
		| ASTO1516                   | 201508               | 03/08/2015 09:15     | NotStarted | A              |
		
#		And the below configuration exists in the Account Codes table
#		| Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#		| 40404005 | 16-18APPS1516              | CODA505   | 8113000      | 01/08/2015           | 31/08/2015         |
#		| 40404001 | ASTO1516                   | CODA501   | 8113000      | 01/08/2015           | 31/08/2015         |
		
		When the Payment Generation Batch run is started

		Then there is an entry in the Payment Timetable
		# ASTO1516 run will fail because the OrgId has an invalid format
		| Funding Stream Period Code | Calendar Year/Period | Status    |
		| 16-18APPS1516              | 201508               | Completed |
		| ASTO1516		             | 201508               | Failed	|
		
		And the below configuration exists in the Payment Timetable
		| Funding Stream Period Code | Calendar Year/Period | Status    | LinkCodeSuffix |
		| 16-18APPS1516              | 201508               | Completed | B              |
		| ASTO1516                   | 201508               | Failed    | A              |
		
		When the Payment Timetable Status is updated
		| Funding Stream Period Code | Calendar Year/Period | LinkCodeSuffix | Status     |
		| 16-18APPS1516              | 201508               | B              | NotStarted |
		| ASTO1516                   | 201508               | A              | NotStarted | 
		
		And the Payment Generation Batch run is started
		
#		#Then   Payment file 'AP1620150503B.pay' is created in PTS Sharepoint Folder for Funding Stream Period Code '16-18APPS1516' and Period '201508'
#		Then   Payment file 'AP1620150503B.pay' is created in the Ftp Folder
#		
#		And the following data exists in the payment file
#		| LineType | LinkCode    | Company Code | Element 1 | Element 2 | Element 3 | Element 4 | Amount  | Subnominal Short Description  | Element 25 |
#		| 157      | AP16150503B | SFA          | ALC40     | +         | 8113000   | CODA505   | 2000.00 | 16-18Traineeships Prf Sep15   | 2201300    |
#		| 158      | AP16150503B | SFA          | ALC40     | +         | 2201300   | 5000      | 2000.00 | 16-18Traineeships Prf Sep15   | CODA505    |
#		
#		#Then   Payment file 'AP1620150503B.nat' is created in PTS Sharepoint Folder for Funding Stream Period Code '16-18APPS1516' and Period '201508'
#		Then   Payment file 'AP1620150503B.nat' is created in the Ftp Folder
#		
#		And the following data exists in the Summary file
#		| Payment File Name | Number of Payment Instructions | Value of Payment Instruction | Error File Name | Number of Payment Error | Value of Payment Error |
#		| AP1620150503B.pay | 1                              | 2000.00                      | N/A             | 0                       | 0.00                   |
#		
		Then the below configuration exists in the Payment Timetable
		| Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | Status    | LinkCodeSuffix |
		| 16-18APPS1516              | 201508               | 03/08/2015 09:15     | Completed | C              |
		| ASTO1516                   | 201508               | 03/08/2015 09:15     | Failed    | A              | 
		
		And there is an entry in the Payment History Table
		| Funding Stream Period Code | Period | Description										|
		| 16-18APPS1516              | 201508 | Payment timetable status changed to Completed	|
		| ASTO1516		             | 201508 | Payment timetable status changed to Failed		|

		# Tidy
		And the following configuration is set in the Payment Timetable
		| Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | Status     | LinkCodeSuffix |
		| 16-18APPS1516              | 201508               | 07/09/2015 22:00     | Completed  | C              |
		| ASTO1516                   | 201508               | 07/09/2015 22:00     | Completed  | A              |
