Feature: CODAControlCodeOverride 18427

@AcceptanceTest @Withdrawn20240103
@PaymentScheduleTests @PaymentGenerationAndTransmission
@ADP
Scenario: A184SLD Create and approve an ESF contract. Amend and approve. Consume actuals. Run payment batch. Check CRM, PaaS, ADP feed and Payment feed. Terminate (without amendment) and confirm. Consume and reject actuals post-termination. Check CRM and PaaS
    Given there are no allocations marked as Under Termination for UKPRN '10017184' 
	And   there are no terminated or closed allocations for UKPRN '10017184'
	And   there is no Contract, Task or Workflow data for UKPRN '10017184'
   #And   Files are deleted from PTS Sharepoint folder
   #And   Files and folder are deleted from FTP Server
    And   the Allocation Delivery Monitoring Service atom feed is empty
    And   there are no entries in the DCFS stub table
    And   the Contract Management atom feed is empty 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ESF-184       |
 
    And   there is no Organisation data for UKPRN '10017184'
    And   the override date is reset 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017184 Co Ltd' with UKPRN '10017184' and OrgId 'ORG0017184' and has 'FCS1 Test' as a manager
    
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName          | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                           | Period | CRMIntent | OrgId      |
    | 10017184 | 10017184 Co Ltd    | ESFA-184             | ESIF-184       | 1                     |  01/04/2018       |  30/09/2018     | 57228.00      | Conditions of Funding (Grant) Employer | 1420   | New       | ORG0017184 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription      | CRMIntent | LEPName             | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference        | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType     |
    | 10017184 | ESIF-184       | ESF-184       | ESF 201420        | ESF                     | 01/04/2018          | 30/09/2018        | 57228.00        |         |         | Funding for the unemployed | New       | Gloucestershire LEP | E37011  | TSS_20125                    | 00-01        | 20125/23-413-00-01/10017184 | 1.4 Active Inclusion | 08SESF01AAA     | Job Seekers Fund    | SSR                | Less Developed |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Apr-18   | May-18   | Jun-18  | Jul-18  | Aug-18   | Sep-18   | DeliverableDescription           | CRMIntent | 
    | ESIF-184       | ESF-184       | 1               | 0                     | 27       | 2484.00  | 432.00   | 945.00  | 1026.00 | 513.00   | 972.00   | ST01 Learner Assessment and Plan | New       | 
    | ESIF-184       | ESF-184       | 2               | 0                     |          | 1633.00  | 3878.00  | 1625.00 | 3791.00 | 3123.00  | 7724.00  | RQ01 Regulated Learning          | New       | 
    | ESIF-184       | ESF-184       | 3               | 0                     |          | 4241.00  | 1009.00  | 9643.00 | 1956.00 | 3390.00  | 1121.00  | NR01 Non Regulated Activity      | New       | 
    | ESIF-184       | ESF-184       | 4               | 0                     | 33       | 1782.00  | 594.00   | 528.00  | 1551.00 | 1749.00  | 1518.00  | FS01 Additional Programme Cost   | New       | 

    And   the draft contract deliverable volume details are as follows 
    | ContractNumber | DeliverableCode | AllocationRef | Apr-18 | May-18 | Jun-18 | Jul-18 | Aug-18 | Sep-18 |
    | ESIF-184       | 1               | ESF-184       | 92     | 16     | 35     | 38     | 19     | 36     |
    | ESIF-184       | 4               | ESF-184       | 54     | 18     | 16     | 47     | 53     | 46     |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
   #And   the latest version of contract 'ESIF-184' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'ESIF-184'

    # Check the deliverable count in CRM (4 deliverables x 6 months = 24)
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'ESIF-184'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
  # When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-184' and actual ContractNumber 'ESIF-184'

    # Check the deliverable count in CRM has not changed 
    Then  there are '24' deliverable period rows in CRM linked to the latest version of contract 'ESIF-184'

    # Check that the contract is now approved
    And   the latest version of contract 'ESIF-184' is in status 'Approved'

    # Check deliverable data in the ContractManagement Legal feed (Unit cost not present after contract injection)
    And   the Legal Contract CM feed contains the following '4' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                         | DeliverableDescription    | 
    | 10017184 | ESIF-184       | 1               | ESF-184       | 1               | 0                     | 6372         | 236           | 0        | ST01 Learner Assessment and Plan        | ?                         |
    | 10017184 | ESIF-184       | 1               | ESF-184       | 2               | 0                     | 21774        | 0             | 0        | RQ01 Regulated Learning                 | ?                         |
    | 10017184 | ESIF-184       | 1               | ESF-184       | 3               | 0                     | 21360        | 0             | 0        | NR01 Non Regulated Activity             | ?                         |
    | 10017184 | ESIF-184       | 1               | ESF-184       | 4               | 0                     | 7722         | 234           | 0        | FS01 Additional Programme Cost          | ?                         |




    # Bulk amend contract

    # Change the date
    Given the override date is '14/04/2018'

    # Clear down CM Atom feed
    And   the Contract Management atom feed is empty

    # Bulk amendment
    Given there are no files prefixed '10017184_ESIF-184' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 16052017165945 v2_A184' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 16052017165945 v2_A184' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 16052017165945 v2_A184.xlsx' exists in the Datafiles folder and UKPRN '10017184' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Publish version 2 of the contract
    And   the latest version of contract 'ESIF-184' is in a state of 'Published to Provider'

    # Check the deliverable count in CRM (4 deliverables x 6 months = 24)
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'ESIF-184'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-184' and actual ContractNumber 'ESIF-184'

    # Check the deliverable count in CRM has not changed 
    Then  there are '24' deliverable period rows in CRM linked to the latest version of contract 'ESIF-184'

    # Check that the contract is now approved
    And   the latest version of contract 'ESIF-184' is in status 'Approved'

    # Check deliverable data in the ContractManagement Legal feed (Unit cost not present after contract injection but should be after bulk)
    And   the Legal Contract CM feed contains the following '4' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                         | DeliverableDescription    | 
    | 10017184 | ESIF-184       | 2               | ESF-184       | 1               | 0                     | 48101        | 467           | 103      | ST01 Learner Assessment and Plan        | ?                         |
    | 10017184 | ESIF-184       | 2               | ESF-184       | 2               | 0                     | 6018         | 0             | 0        | RQ01 Regulated Learning                 | ?                         |
    | 10017184 | ESIF-184       | 2               | ESF-184       | 3               | 0                     | 8007         | 0             | 0        | NR01 Non Regulated Activity             | ?                         |
    | 10017184 | ESIF-184       | 2               | ESF-184       | 4               | 0                     | 29784        | 438           | 68       | FS01 Additional Programme Cost          | ?                         |




    # Change the date
    Given the override date is '06/05/2018'

	And there are no entries in the summarised actuals PaaS table

	# Consume actuals and create payment files
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | ESF            | ESF09                | ORG0017184     | CM             | 201804 | ESF1420                 | ESF-184                  |         | 1               | -29          | -1682.00    | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201805 | ESF1420                 | ESF-184                  |         | 1               | 5            | 290.00      | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201806 | ESF1420                 | ESF-184                  |         | 1               | 30           | 1740.00     | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201807 | ESF1420                 | ESF-184                  |         | 1               | 38           | 2204.00     | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201808 | ESF1420                 | ESF-184                  |         | 1               | 30           | 1740.00     | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201809 | ESF1420                 | ESF-184                  |         | 1               | 94           | 5452.00     | 
	#
    | ESF            | ESF09                | ORG0017184     | CM             | 201804 | ESF1420                 | ESF-184                  |         | 2               | 0            | 4214.00     | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201805 | ESF1420                 | ESF-184                  |         | 2               | 0            | 1720.00     | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201806 | ESF1420                 | ESF-184                  |         | 2               | 0            | 1204.00     | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201807 | ESF1420                 | ESF-184                  |         | 2               | 0            | 688.00      | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201808 | ESF1420                 | ESF-184                  |         | 2               | 0            | 731.00      | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201809 | ESF1420                 | ESF-184                  |         | 2               | 0            | 2795.00     | 
	#
    | ESF            | ESF09                | ORG0017184     | CM             | 201804 | ESF1420                 | ESF-184                  |         | 3               | 0            | 1763.00     | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201805 | ESF1420                 | ESF-184                  |         | 3               | 0            | 1763.00     | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201806 | ESF1420                 | ESF-184                  |         | 3               | 0            | 3053.00     | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201807 | ESF1420                 | ESF-184                  |         | 3               | 0            | 1419.00     | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201808 | ESF1420                 | ESF-184                  |         | 3               | 0            | 2709.00     | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201809 | ESF1420                 | ESF-184                  |         | 3               | 0            | 903.00      | 
	#
    | ESF            | ESF09                | ORG0017184     | CM             | 201804 | ESF1420                 | ESF-184                  |         | 4               | 19           | 703.00      | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201805 | ESF1420                 | ESF-184                  |         | 4               | 58           | 2146.00     | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201806 | ESF1420                 | ESF-184                  |         | 4               | 8            | 296.00      | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201807 | ESF1420                 | ESF-184                  |         | 4               | 46           | 1702.00     | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201808 | ESF1420                 | ESF-184                  |         | 4               | 90           | 3330.00     | 
    | ESF            | ESF09                | ORG0017184     | CM             | 201809 | ESF1420                 | ESF-184                  |         | 4               | 26           | 962.00      | 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check that the actuals value data has arrived in CRM
	Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-184       | ESF-184       | 1               | -1682.00 | ?        | ?        | ?        | ?        | ?        |
    | ESIF-184       | ESF-184       | 2               | 4214.00  | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-184       | ESF-184       | 3               | 1763.00  | ?        | ?        | ?        | ?        | ?        |
    | ESIF-184       | ESF-184       | 4               | 703.00   | ?        | ?        | ?        | ?        | ?        |

    # Check that the actuals volume data has arrived in CRM
    And   the Actuals Volume Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-184       | ESF-184       | 1               | -29      | ?        | ?        | ?        | ?        | ?        |
    | ESIF-184       | ESF-184       | 4               | 19       | ?        | ?        | ?        | ?        | ?        |

    # Check that the actuals have arrived in PAAS
    And   the PaymentSchedule.DeliverablePayment table contains the following values
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | ESF-184          | 1             | 1               | 201804 | 2              | 92            | 2484.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-184          | 1             | 2               | 201804 | 2              | 0             | 1633.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-184          | 1             | 3               | 201804 | 2              | 0             | 4241.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-184          | 1             | 4               | 201804 | 2              | 54            | 1782.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | ESF-184          | 2             | 1               | 201804 | 2              | 75            | 7725.00      | 0.00                 | 0.00                | 0.00                   | -1682.00                    | -1682.00         | -29          | -1682.00    |
    | ESF-184          | 2             | 2               | 201804 | 2              | 0             | 1190.00      | 0.00                 | 0.00                | 0.00                   | 4214.00                     | 4214.00          | 0            | 4214.00     |
    | ESF-184          | 2             | 3               | 201804 | 2              | 0             | 1785.00      | 0.00                 | 0.00                | 0.00                   | 1763.00                     | 1763.00          | 0            | 1763.00     |
    | ESF-184          | 2             | 4               | 201804 | 2              | 139           | 9452.00      | 0.00                 | 0.00                | 0.00                   | 703.00                      | 703.00           | 19           | 703.00      |

    # Payment file creation. Set dates
    Given the override date is '08/05/2018 22:05'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
	# Note: PaymentPeriod is the accounting year and month, eg for April 2018 the value would be 201801 not 201804
    And   there is no data in the Payment feed for FundingStreamPeriod 'ESF1420' PaymentPeriod '201801' CensusEndDate '08/05/2018' and LinkCodeSuffix 'A'

    # PaymentGeneration.PaymentTimetable
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ESF1420                    | 201804               |                      | A              | NotStarted |

#   # Coda.AccountCode
#   And   the following configuration exists in the Account Codes table
#   | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#   | 10017184 | ESF1420                    | CODA184   | 8116000      | 01/08/1990           | 31/12/2020         |
   
    And   the following allocation periods are present in the subnominal aggregation PaaS table
	| ContractAllocationNumber | Period |
    | ESF-184                  | 201804 |

	When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ESF1420                    | 201804               | Completed |

#	# File created in Maytech FTP folder for 'European Social Fund'
#	And   Payment file 'ESFC20180108A.pay' is created in the FTP Folder
#
#   # Decrypt the payment file to the Output window and save a decrypted version to Datafiles/Downloads
#   Given there is an encrypted file called 'ESFC20180108A.pay' in the Maytech FTP folder decrypt it then save it to 'DataFiles/Downloads'
#
#   Then  the following details are present in payment file 'ESFC20180108A.pay'
#   | LinkCode    | CompanyCode | Element1 | Element2 | Element3 | Element4 | Element5 | Element6 | Element7 | Element8 | Year | Period | Date       | Amount   | Dc   | LineType | Doc     | Desc                            | DueDate    | Tax | Extref1                       | Extref2     | Extref3      | Extref4 | Extref5  | Extref6 | Num   | DocLineNo |
#   | ESFC180108A | SFA         | E37011   | +        | 8116000  | CODA184  | 02       | ESF-184  | ?        | ?        | 2018 | 01     | 08/05/2018 | 4998.00  | 160  | 157      | ESFCR   | ESF1420 IP1.4LessDev Rec May18  | 25/05/2018 | ?   | ESF RECONCILIATION 2014/23    | ESFC180108A | 08SESF01AAA  | ?       | 10017184 | 2671114 | 1     | 1         |
#   | ESFC180108A | SFA         | E37011   | +        | 2671114  | 5000     | 02       | ESF-184  | ?        | ?        | 2018 | 01     | 08/05/2018 | 4998.00  | 161  | 158      | ESFCR   | ESF1420 IP1.4LessDev Rec May18  | 25/05/2018 | VIO | ESF RECONCILIATION 2014/23    | ESFC180108A | 08SESF01AAA  | ?       | 10017184 | CODA184 | 1     | 2         |

	# Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data in Datafiles/Downloads folder (19014)
    Then  the Payment feed xml for FundingStreamPeriod 'ESF1420' PaymentPeriod '201801' CensusEndDate '08/05/2018' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A184.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ESF1420' PaymentPeriod '201801' CensusEndDate '08/05/2018' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | ESFC                   | 2018          | 01             | 08          | E37011  | ESF-184       | 4998.00         | RECONCILIATION   | ESF1420 IP1.4LessDev               | 2018-05-25 | 2014-08-01   | 2023-12-31 | 08SESF01AAA    | 10017184 | 2671114    |

    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'ESF1420' AccountingPaymentPeriod '201801' and CensusEndDate '08/05/2018'

    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                             |
    | Payment Requests for Funding Stream Period ESF1420 for Payment Period 201801 have been generated as of Census End Date/Time 2018-05-08T22:00:00Z. |

    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate        | PaymentLineCount | TotalValue |
    | ESF1420             | 201801        | 2018-05-08T22:00:00Z | 1                | 4998.00    |

    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | ESFC      | 01/08/2014   | 31/12/2023 | 08/05/2018    | 25/05/2018 | 2018          | 01             |

    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017184  | 10017184       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | ESF-184    | 2       | TSS_20125     | SSR             | 00-01  | SSR     | 20125/23-413-00-01/10017184  | Job Seekers Fund              | 1.4 Active Inclusion          | E37011  | Gloucestershire LEP           | Less Developed   | 08SESF01AAA     | 1.01                | 2671114    | RECONCILIATION | ESF1420 IP1.4LessDev          | 4998.00         |

#   # Check that payment files have not been created in the Maytech FTP folder (22121)
#   And   Payment file 'ESFC20180108A.nat' is not present on the Maytech FTP server
#   And   Payment file 'ESFC20180108A.pay' is not present on the Maytech FTP server
#   And   Payment file 'ESFC20180108A.err' is not present on the Maytech FTP server
#   # It is possible that the payment files could be created AFTER this check is done. Check manually


    # Check AllocationDelivery.AllocationDeliveryEntry (ADP) feed for ActualsReceived and PaymentReceived events
    And     the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events 
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | AllocationNumber | ContractVersionNumber |
    | NewContractAllocationApproved     | 0      | ESIF-184       | ESF-184          | 1                     |
    | AmendedContractAllocationApproved | 1      | ESIF-184       | ESF-184          | 2                     |
    | ContractAllocationActualsReceived | 2      | ESIF-184       | ESF-184          | 2                     |
    | ContractAllocationPaymentReceived | 3      | ESIF-184       | ESF-184          | 2                     |


    # Check planned and actual VOLUME details in the zipped xml in the ADP feed (18259)

    # Check PLANNED volume details on the AllocationDelivery.AllocationDeliveryEvent (ADP) feed 
    And   the planned volume details on the 'NewContractAllocationApproved' event on the ADP feed for version '1' of contract allocation 'ESF-184' are as follows
    | DeliverableCode | Period | PlannedVolume |
    | 1               | 201804 | 92            |
    | 1               | 201805 | 16            |
    | 1               | 201806 | 35            |
    | 1               | 201807 | 38            |
    | 1               | 201808 | 19            |
    | 1               | 201809 | 36            |
	#
	| 4               | 201804 | 54            |
    | 4               | 201805 | 18            |
    | 4               | 201806 | 16            |
    | 4               | 201807 | 47            |
    | 4               | 201808 | 53            |
    | 4               | 201809 | 46            |

    And   the planned volume details on the 'AmendedContractAllocationApproved' event on the ADP feed for version '2' of contract allocation 'ESF-184' are as follows
	| DeliverableCode | Period | PlannedVolume |
    | 1               | 201804 | 75            |
    | 1               | 201805 | 48            |
    | 1               | 201806 | 89            |
    | 1               | 201807 | 118           |
    | 1               | 201808 | 69            |
    | 1               | 201809 | 68            |
	#
	| 4               | 201804 | 139           |
    | 4               | 201805 | 6             |
    | 4               | 201806 | 145           |
    | 4               | 201807 | 29            |
    | 4               | 201808 | 38            |
    | 4               | 201809 | 81            |

    And   the planned volume details on the 'ContractAllocationActualsReceived' event on the ADP feed for version '2' of contract allocation 'ESF-184' are as follows
	| DeliverableCode | Period | PlannedVolume |
    | 1               | 201804 | 75            |
    | 1               | 201805 | 48            |
    | 1               | 201806 | 89            |
    | 1               | 201807 | 118           |
    | 1               | 201808 | 69            |
    | 1               | 201809 | 68            |
	#
	| 4               | 201804 | 139           |
    | 4               | 201805 | 6             |
    | 4               | 201806 | 145           |
    | 4               | 201807 | 29            |
    | 4               | 201808 | 38            |
    | 4               | 201809 | 81            |

    And   the planned volume details on the 'ContractAllocationPaymentReceived' event on the ADP feed for version '2' of contract allocation 'ESF-184' are as follows
	| DeliverableCode | Period | PlannedVolume |
    | 1               | 201804 | 75            |
    | 1               | 201805 | 48            |
    | 1               | 201806 | 89            |
    | 1               | 201807 | 118           |
    | 1               | 201808 | 69            |
    | 1               | 201809 | 68            |
	#
	| 4               | 201804 | 139           |
    | 4               | 201805 | 6             |
    | 4               | 201806 | 145           |
    | 4               | 201807 | 29            |
    | 4               | 201808 | 38            |
    | 4               | 201809 | 81            |

    # Check ACTUAL volume details on the AllocationDelivery.AllocationDeliveryEvent (ADP) feed 
    And   the actual volume details on the 'ContractAllocationActualsReceived' event on the ADP feed for version '2' of contract allocation 'ESF-184' are as follows
	| DeliverableCode | Period | ActualVolume |
    | 1               | 201804 | -29          |
    | 4               | 201804 | 19           |

    And   the actual volume details on the 'ContractAllocationPaymentReceived' event on the ADP feed for version '2' of contract allocation 'ESF-184' are as follows
	| DeliverableCode | Period | ActualVolume |
    | 1               | 201804 | -29          |
    | 4               | 201804 | 19           |

	
	
	
	# Initiate a TERMINATION

    # Change the date
    Given the override date is '02/08/2018'

    # Request termination of the contract via the CRM SDK
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'ESIF-184' Version '2' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 12/08/2018               | 27/08/2018              | No                          | Deactivated UKPRN       | Company sold            |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ESF-184          | 03/08/2018                  | 18/08/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '2' of contract 'ESIF-184' for UKPRN '10017184'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017184 - 10017184 Co Ltd     | ESIF-184       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017184 | ESIF-184           | 2                     | 0                        | Approved         | Awaiting Termination Initiation Approval  | True          | True                | 01/04/2018        | 30/09/2018      | Variation     |
    | 10017184 | ESIF-184           | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/04/2018        | 30/09/2018      | ?             |
    | 10017184 | ESFA-184           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/04/2018        | 30/09/2018      | ?             |



    # Approve the Termination initiation

    # Change the date
    Given the override date is '13/08/2018'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '2' of contract 'ESIF-184' for provider '10017184' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017184 | ESIF-184           | 2                     | 0                        | Approved         | Under Termination                         | True          | True                | 01/04/2018        | 30/09/2018      | Variation     |
    | 10017184 | ESIF-184           | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/04/2018        | 30/09/2018      | ?             |
    | 10017184 | ESFA-184           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/04/2018        | 30/09/2018      | ?             |



    # Complete the Termination

    # Change the date (Termination date is 27/08/2018)
    Given the override date is '02/09/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination (23893)
#   When  CRM user 'FCS8 Test' completes the termination request for Contract 'ESIF-184' Version '2' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' completes the termination request for Contract 'ESIF-184' Version '2' SubVersion '0' via SDK

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017184 | ESIF-184           | 2                     | 0                        | Closed           | Terminated                                | True          | True                | 01/04/2018        | 30/09/2018      | Variation     |
    | 10017184 | ESIF-184           | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/04/2018        | 30/09/2018      | ?             |
    | 10017184 | ESFA-184           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/04/2018        | 30/09/2018      | ?             |



	# Consume actuals after the termination date. These should be ignored (23975)

    # Check the deliverable period count in CRM BEFORE pulling data for Sep 2018
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract number 'ESIF-184'

   # Check the ACTUAL VALUES in CRM BEFORE pulling data for Sep 2018
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-184       | ESF-184         | 1               | -1682.00 | -1682.00 | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | ESIF-184       | ESF-184         | 2               | 4214.00  | 4214.00  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | ESIF-184       | ESF-184         | 3               | 1763.00  | 1763.00  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | ESIF-184       | ESF-184         | 4               | 703.00   | 703.00   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM BEFORE pulling data for Sep 2018
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-184       | ESF-184         | 1               | -1682.00 | -1682.00 | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | ESIF-184       | ESF-184         | 2               | 4214.00  | 4214.00  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | ESIF-184       | ESF-184         | 3               | 1763.00  | 1763.00  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | ESIF-184       | ESF-184         | 4               | 703.00   | 703.00   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 

    # Check the NET AMOUNTS in CRM BEFORE pulling data for Sep 2018
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-184       | ESF-184         | 1               | -1682.00 | -1682.00 | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | ESIF-184       | ESF-184         | 2               | 4214.00  | 4214.00  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | ESIF-184       | ESF-184         | 3               | 1763.00  | 1763.00  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | ESIF-184       | ESF-184         | 4               | 703.00   | 703.00   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 



	# Change the date
    Given the override date is '04/10/2018'

    # Consume actuals and create payment files
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | ESF            | ESF24                | ORG0017184     | CM             | 201804 | ESF1420                 | ESF-184                  |         | 1               | -13          | -1300.00    | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201805 | ESF1420                 | ESF-184                  |         | 1               | 5            | 500.00      | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201806 | ESF1420                 | ESF-184                  |         | 1               | 30           | 3000.00     | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201807 | ESF1420                 | ESF-184                  |         | 1               | 38           | 3800.00     | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201808 | ESF1420                 | ESF-184                  |         | 1               | 30           | 3000.00     | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201809 | ESF1420                 | ESF-184                  |         | 1               | 94           | 9400.00     | 
    #
    | ESF            | ESF24                | ORG0017184     | CM             | 201804 | ESF1420                 | ESF-184                  |         | 2               | 0            | 1099.00     | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201805 | ESF1420                 | ESF-184                  |         | 2               | 0            | 1432.00     | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201806 | ESF1420                 | ESF-184                  |         | 2               | 0            | 2341.00     | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201807 | ESF1420                 | ESF-184                  |         | 2               | 0            | 981.00      | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201808 | ESF1420                 | ESF-184                  |         | 2               | 0            | 476.00      | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201809 | ESF1420                 | ESF-184                  |         | 2               | 0            | 1845.00     | 
    #
    | ESF            | ESF24                | ORG0017184     | CM             | 201804 | ESF1420                 | ESF-184                  |         | 3               | 0            | 1006.00     | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201805 | ESF1420                 | ESF-184                  |         | 3               | 0            | 2156.00     | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201806 | ESF1420                 | ESF-184                  |         | 3               | 0            | 2155.00     | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201807 | ESF1420                 | ESF-184                  |         | 3               | 0            | 3104.00     | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201808 | ESF1420                 | ESF-184                  |         | 3               | 0            | 1000.00     | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201809 | ESF1420                 | ESF-184                  |         | 3               | 0            | 625.00      | 
    #
    | ESF            | ESF24                | ORG0017184     | CM             | 201804 | ESF1420                 | ESF-184                  |         | 4               | 10           | 800.00      | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201805 | ESF1420                 | ESF-184                  |         | 4               | 15           | 1200.00     |
    | ESF            | ESF24                | ORG0017184     | CM             | 201806 | ESF1420                 | ESF-184                  |         | 4               | 12           | 960.00      | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201807 | ESF1420                 | ESF-184                  |         | 4               | 20           | 1600.00     | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201808 | ESF1420                 | ESF-184                  |         | 4               | 25           | 2000.00     | 
    | ESF            | ESF24                | ORG0017184     | CM             | 201809 | ESF1420                 | ESF-184                  |         | 4               | 30           | 2400.00     | 

    # Pull actuals from new Submit Learner Data (SLD) interface (24329)
    When  the FCT system polls the SLD service

    # Check the deliverable period count in CRM AFTER pulling data for Sep 2018
    Then  there are '24' deliverable period rows in CRM linked to the latest version of contract number 'ESIF-184'

   # Check the ACTUAL VALUES in CRM AFTER pulling data for Sep 2018
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-184       | ESF-184         | 1               | -1682.00 | -1682.00 | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | ESIF-184       | ESF-184         | 2               | 4214.00  | 4214.00  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | ESIF-184       | ESF-184         | 3               | 1763.00  | 1763.00  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | ESIF-184       | ESF-184         | 4               | 703.00   | 703.00   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM AFTER pulling data for Sep 2018
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-184       | ESF-184         | 1               | -1682.00 | -1682.00 | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | ESIF-184       | ESF-184         | 2               | 4214.00  | 4214.00  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | ESIF-184       | ESF-184         | 3               | 1763.00  | 1763.00  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | ESIF-184       | ESF-184         | 4               | 703.00   | 703.00   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 

    # Check the NET AMOUNTS in CRM AFTER pulling data for Sep 2018
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-184       | ESF-184         | 1               | -1682.00 | -1682.00 | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | ESIF-184       | ESF-184         | 2               | 4214.00  | 4214.00  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | ESIF-184       | ESF-184         | 3               | 1763.00  | 1763.00  | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | ESIF-184       | ESF-184         | 4               | 703.00   | 703.00   | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 



    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system
    
    # Check that the relevant events are on the ADP feed
    Then  the ADP feed includes the following values
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | ContractVersionNumber | SubVersionNumber | AllocationNumber | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    | NewContractAllocationApproved     | 0      | ESIF-184       | 1                     | 0                | ESF-184          | ?                         | ?                            | 
    | AmendedContractAllocationApproved | 1      | ESIF-184       | 2                     | 0                | ESF-184          | ?                         | ?                            | 
    | ContractAllocationActualsReceived | 2      | ESIF-184       | 2                     | 0                | ESF-184          | ?                         | ?                            | 
    | ContractAllocationPaymentReceived | 3      | ESIF-184       | 2                     | 0                | ESF-184          | ?                         | ?                            | 
    | ContractAllocationActualsUpdated  | 4      | ESIF-184       | 2                     | 0                | ESF-184          | ?                         | ?                            | 

    # Check the ADP feed event header information
    And   the Allocation Delivery feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                        | CategoryLabel                        | Title                                                                               |
    | 10017184 | ESIF-184       | 1               | 0                  | NewContractAllocationApproved       | New Contract Allocation Approved     | New Contract ESIF-184: 1.0 with Allocation ESF-184 was Approved                     |
    | 10017184 | ESIF-184       | 2               | 0                  | AmendedContractAllocationApproved   | Amended Contract Allocation Approved | Amendment to Contract ESIF-184: 2.0 with Allocation ESF-184 was Approved            |
    | 10017184 | ESIF-184       | 2               | 0                  | ContractAllocationActualsReceived   | Contract Allocation Actuals Received | Actuals for Allocation ESF-184 of Contract ESIF-184: 2.0 have been received         |
    | 10017184 | ESIF-184       | 2               | 0                  | ContractAllocationPaymentReceived   | Contract Allocation Payment Posted   | Payment for Allocation ESF-184 of Contract ESIF-184: 2.0 have been posted           |
    | 10017184 | ESIF-184       | 2               | 0                  | ContractAllocationActualsUpdated    | Contract Allocation Actuals Updated  | Actuals for Allocation ESF-184 of Contract ESIF-184: 2.0 have been updated          |

    # Check financials on the ADP feed
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
    | AllocationDeliveryEntryCategory   | ContractNumber | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 1               | 201804 | -1682.00    | 0.00           | 0.00             | -1682.00              | 0.00           | -1682.00   |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 1               | 201805 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 1               | 201806 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 1               | 201807 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 1               | 201808 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 1               | 201809 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 2               | 201804 | 4214.00     | 0.00           | 0.00             | 4214.00               | 0.00           | 4214.00    |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 2               | 201805 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 2               | 201806 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 2               | 201807 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 2               | 201808 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 2               | 201809 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 3               | 201804 | 1763.00     | 0.00           | 0.00             | 1763.00               | 0.00           | 1763.00    |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 3               | 201805 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 3               | 201806 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 3               | 201807 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 3               | 201808 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 3               | 201809 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 4               | 201804 | 703.00      | 0.00           | 0.00             | 703.00                | 0.00           | 703.00     |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 4               | 201805 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 4               | 201806 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 4               | 201807 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 4               | 201808 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsUpdated  | ESIF-184       | 2             | ESF-184          | 4               | 201809 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |

    # Check Planned data on the ADP feed
    And   the Allocation Delivery Monitoring Service atom feed contains the following Planned data   
    | AllocationDeliveryEntryCategory   | ContractNumber | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 1               | 201804 | 7725.00      | 75            |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 1               | 201805 | 4944.00      | 48            |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 1               | 201806 | 9167.00      | 89            |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 1               | 201807 | 12154.00     | 118           |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 1               | 201808 | 7107.00      | 69            |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 1               | 201809 | 7004.00      | 68            |
    #
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 2               | 201804 | 1190.00      | 0             |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 2               | 201805 | 2278.00      | 0             |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 2               | 201806 | 357.00       | 0             |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 2               | 201807 | 1054.00      | 0             |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 2               | 201808 | 136.00       | 0             |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 2               | 201809 | 1003.00      | 0             |
    #
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 3               | 201804 | 1785.00      | 0             |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 3               | 201805 | 1190.00      | 0             |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 3               | 201806 | 1071.00      | 0             |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 3               | 201807 | 765.00       | 0             |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 3               | 201808 | 1666.00      | 0             |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 3               | 201809 | 1530.00      | 0             |
    #
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 4               | 201804 | 9452.00      | 139           |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 4               | 201805 | 408.00       | 6             |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 4               | 201806 | 9860.00      | 145           |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 4               | 201807 | 1972.00      | 29            |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 4               | 201808 | 2584.00      | 38            |
    | AmendedContractAllocationApproved | ESIF-184       | 2             | ESF-184          | 4               | 201809 | 5508.00      | 81            |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Complete
@ADP
Scenario: A200 Create and approve an ESF contract. Consume actuals. Amend and approve. Check values and volumes have been carried forward to v2 in CRM and PaaS
    Given there is no Contract, Task or Workflow data for UKPRN '10017200'
    And   the Allocation Delivery Monitoring Service atom feed is empty
	And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there are no entries in the DCFS stub table

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ESF-200       |
 
    And   there is no Organisation data for UKPRN '10017200'
    And   the override date is reset 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017200 Co Ltd' with UKPRN '10017200' and OrgId 'ORG0017200' and has 'FCS1 Test' as a manager
    
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName          | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType                           | Period | CRMIntent | OrgId      |
    | 10017200 | 10017200 Co Ltd    | ESFA-200             | ESIF-200       | 1                     |  01/04/2018       |  30/09/2018     | 57228.00      | Conditions of Funding (Grant) Employer | 1420   | New       | ORG0017200 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription      | CRMIntent | LEPName             | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference        | InvestmentPriority   | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType     |
    | 10017200 | ESIF-200       | ESF-200       | ESF 201420        | ESF                     | 01/04/2018          | 30/09/2018        | 57228.00        |         |         | Funding for the unemployed | New       | Gloucestershire LEP | E37011  | TSS_20125                    | 00-01        | 20125/23-413-00-01/10017200 | 1.4 Active Inclusion | 08SESF01AAA     | Job Seekers Fund    | SSR                | Less Developed |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Apr-18   | May-18   | Jun-18  | Jul-18  | Aug-18   | Sep-18   | DeliverableDescription           | CRMIntent | 
    | ESIF-200       | ESF-200       | 1               | 0                     | 27       | 2484.00  | 432.00   | 945.00  | 1026.00 | 513.00   | 972.00   | ST01 Learner Assessment and Plan | New       | 
    | ESIF-200       | ESF-200       | 2               | 0                     |          | 1633.00  | 3878.00  | 1625.00 | 3791.00 | 3123.00  | 7724.00  | RQ01 Regulated Learning          | New       | 
    | ESIF-200       | ESF-200       | 3               | 0                     |          | 4241.00  | 1009.00  | 9643.00 | 1956.00 | 3390.00  | 1121.00  | NR01 Non Regulated Activity      | New       | 
    | ESIF-200       | ESF-200       | 4               | 0                     | 33       | 1782.00  | 594.00   | 528.00  | 1551.00 | 1749.00  | 1518.00  | FS01 Additional Programme Cost   | New       | 

    And   the draft contract deliverable volume details are as follows 
    | ContractNumber | DeliverableCode | AllocationRef | Apr-18 | May-18 | Jun-18 | Jul-18 | Aug-18 | Sep-18 |
    | ESIF-200       | 1               | ESF-200       | 92     | 16     | 35     | 38     | 19     | 36     |
    | ESIF-200       | 4               | ESF-200       | 54     | 18     | 16     | 47     | 53     | 46     |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract 'ESIF-200' is in a state of 'Published to Provider'

    # Check the deliverable count in CRM (4 deliverables x 6 months = 24)
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'ESIF-200'

    # Change the date
    And   the override date is '11/04/2018'

    # Inject an SFS contract approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-200' and actual ContractNumber 'ESIF-200'

    Then  the status and sub-status of the latest version of contract 'ESIF-200' are changed to 'Approved'
    And   the latest version of contract 'ESIF-200' is marked as the last approved version
    And   the latest version of contract 'ESIF-200' is in status 'Approved'

    # Check the deliverable count in CRM has not changed 
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'ESIF-200'
  
    # Consume actuals
    Given the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | ESF            | ESF09                | ORG0017200     | CM             | 201804 | ESF1420                 | ESF-200                  |         | 1               | -29          | -1682.00    | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201805 | ESF1420                 | ESF-200                  |         | 1               | 5            | 290.00      | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201806 | ESF1420                 | ESF-200                  |         | 1               | 30           | 1740.00     | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201807 | ESF1420                 | ESF-200                  |         | 1               | 38           | 2204.00     | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201808 | ESF1420                 | ESF-200                  |         | 1               | 30           | 1740.00     | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201809 | ESF1420                 | ESF-200                  |         | 1               | 94           | 5452.00     | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201804 | ESF1420                 | ESF-200                  |         | 2               | 0            | 4214.00     | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201805 | ESF1420                 | ESF-200                  |         | 2               | 0            | 1720.00     | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201806 | ESF1420                 | ESF-200                  |         | 2               | 0            | 1204.00     | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201807 | ESF1420                 | ESF-200                  |         | 2               | 0            | 688.00      | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201808 | ESF1420                 | ESF-200                  |         | 2               | 0            | 731.00      | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201809 | ESF1420                 | ESF-200                  |         | 2               | 0            | 2795.00     | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201804 | ESF1420                 | ESF-200                  |         | 3               | 0            | 1763.00     | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201805 | ESF1420                 | ESF-200                  |         | 3               | 0            | 1763.00     | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201806 | ESF1420                 | ESF-200                  |         | 3               | 0            | 3053.00     | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201807 | ESF1420                 | ESF-200                  |         | 3               | 0            | 1419.00     | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201808 | ESF1420                 | ESF-200                  |         | 3               | 0            | 2709.00     | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201809 | ESF1420                 | ESF-200                  |         | 3               | 0            | 903.00      | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201804 | ESF1420                 | ESF-200                  |         | 4               | 19           | 703.00      | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201805 | ESF1420                 | ESF-200                  |         | 4               | 58           | 2146.00     | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201806 | ESF1420                 | ESF-200                  |         | 4               | 8            | 296.00      | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201807 | ESF1420                 | ESF-200                  |         | 4               | 46           | 1702.00     | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201808 | ESF1420                 | ESF-200                  |         | 4               | 90           | 3330.00     | 
    | ESF            | ESF09                | ORG0017200     | CM             | 201809 | ESF1420                 | ESF-200                  |         | 4               | 26           | 962.00      | 



    # Change the date
    Given the override date is '06/05/2018'
        
    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

   # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-200       | ESF-200         | 1               | -1682.00 | -1682.00 | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 2               | 4214.00  | 4214.00  | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 3               | 1763.00  | 1763.00  | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 4               | 703.00   | 703.00   | ?        | ?        | ?        | ?        | ?        | 

    # Check the PROFILE PAYMENTS in CRM
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-200       | ESF-200         | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the BALANCING PAYMENTS in CRM
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-200       | ESF-200         | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-200       | ESF-200         | 1               | -1682.00 | -1682.00 | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 2               | 4214.00  | 4214.00  | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 3               | 1763.00  | 1763.00  | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 4               | 703.00   | 703.00   | ?        | ?        | ?        | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-200       | ESF-200         | 1               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 3               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 4               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-200       | ESF-200         | 1               | -1682.00 | -1682.00 | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 2               | 4214.00  | 4214.00  | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 3               | 1763.00  | 1763.00  | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 4               | 703.00   | 703.00   | ?        | ?        | ?        | ?        | ?        | 

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-200       | ESF-200         | 1               | 6372.00  | 2484.00  | 432.00   | 945.00   | 1026.00  | 513.00   | 972.00   | 
    | ESIF-200       | ESF-200         | 2               | 21774.00 | 1633.00  | 3878.00  | 1625.00  | 3791.00  | 3123.00  | 7724.00  | 
    | ESIF-200       | ESF-200         | 3               | 21360.00 | 4241.00  | 1009.00  | 9643.00  | 1956.00  | 3390.00  | 1121.00  | 
    | ESIF-200       | ESF-200         | 4               | 7722.00  | 1782.00  | 594.00   | 528.00   | 1551.00  | 1749.00  | 1518.00  | 

    # Check the PLANNED VOLUMES in CRM
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-200       | ESF-200         | 1               | 236      | 92       | 16       | 35       | 38       | 19       | 36       | 
    | ESIF-200       | ESF-200         | 2               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | ESIF-200       | ESF-200         | 3               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | ESIF-200       | ESF-200         | 4               | 234      | 54       | 18       | 16       | 47       | 53       | 46       | 

    # Check the ACTUAL VOLUMES in CRM
    Then  the Actuals Volume Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-200       | ESF-200         | 1               | -29      | -29      | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 2               | 0        | 0        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 3               | 0        | 0        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 4               | 19       | 19       | ?        | ?        | ?        | ?        | ?        | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | ESF-200          | 1             | 1               | 201804 | 2              | 92            | 2484.00      | 0.00                 | 0.00                | 0.00                   | -1682.00                    | -1682.00         | -29          | -1682.00    |
    | ESF-200          | 1             | 2               | 201804 | 2              | 0             | 1633.00      | 0.00                 | 0.00                | 0.00                   | 4214.00                     | 4214.00          | 0            | 4214.00     |
    | ESF-200          | 1             | 3               | 201804 | 2              | 0             | 4241.00      | 0.00                 | 0.00                | 0.00                   | 1763.00                     | 1763.00          | 0            | 1763.00     |
    | ESF-200          | 1             | 4               | 201804 | 2              | 54            | 1782.00      | 0.00                 | 0.00                | 0.00                   | 703.00                      | 703.00           | 19           | 703.00      |


    # Change the date
    And   the override date is '12/06/2018'

    # Bulk amend contract to create v2
    Given there are no files prefixed '10017200_ESIF-200' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 07082018165945 v2_A200' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 07082018165945 v2_A200' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 07082018165945 v2_A200.xlsx' exists in the Datafiles folder and UKPRN '10017200' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Publish version 2 of the contract
    And   the latest version of contract 'ESIF-200' is in a state of 'Published to Provider'

	# Monthend is not running
	And   the PaaS MonthEndIsRunning indicator is set to 'False'

	# Check publication has happened
	Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017200 | ESIF-200           | 2                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/04/2018        | 30/09/2018      | Variation     |
    | 10017200 | ESIF-200           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/04/2018        | 30/09/2018      | ?             |
    | 10017200 | ESFA-200           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2018        | 30/09/2018      | ?             |

#    # Inject an SFS approval message
#    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-200' and actual ContractNumber 'ESIF-200'

	# Inject an SFS approval message
	When  contract approval messages arrive for the following contracts
    | MasterContractNumber | ContractNumber | Version |
    | ESFA-200             | ESIF-200       | 2       | 

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017200 | ESIF-200           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2018        | 30/09/2018      | Variation     |
    | 10017200 | ESIF-200           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/04/2018        | 30/09/2018      | ?             |
    | 10017200 | ESFA-200           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2018        | 30/09/2018      | ?             |

   # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-200       | ESF-200         | 1               | -1682.00 | -1682.00 | 0.00     | 0.00     | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 2               | 4214.00  | 4214.00  | 0.00     | 0.00     | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 3               | 1763.00  | 1763.00  | 0.00     | 0.00     | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 4               | 703.00   | 703.00   | 0.00     | 0.00     | ?        | ?        | ?        | 

    # Check the PROFILE PAYMENTS in CRM
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-200       | ESF-200         | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 2               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 3               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 4               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 

    # Check the BALANCING PAYMENTS in CRM
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-200       | ESF-200         | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 2               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 3               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 4               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-200       | ESF-200         | 1               | -1682.00 | -1682.00 | 0.00     | 0.00     | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 2               | 4214.00  | 4214.00  | 0.00     | 0.00     | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 3               | 1763.00  | 1763.00  | 0.00     | 0.00     | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 4               | 703.00   | 703.00   | 0.00     | 0.00     | ?        | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-200       | ESF-200         | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 2               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 3               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 4               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-200       | ESF-200         | 1               | -1682.00 | -1682.00 | 0.00     | 0.00     | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 2               | 4214.00  | 4214.00  | 0.00     | 0.00     | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 3               | 1763.00  | 1763.00  | 0.00     | 0.00     | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 4               | 703.00   | 703.00   | 0.00     | 0.00     | ?        | ?        | ?        | 

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-200       | ESF-200         | 1               | 48101.00 | 7725.00  | 4944.00  | 9167.00  | 12154.00 | 7107.00  | 7004.00  | 
    | ESIF-200       | ESF-200         | 2               | 6018.00  | 1190.00  | 2278.00  | 357.00   | 1054.00  | 136.00   | 1003.00  | 
    | ESIF-200       | ESF-200         | 3               | 8007.00  | 1785.00  | 1190.00  | 1071.00  | 765.00   | 1666.00  | 1530.00  | 
    | ESIF-200       | ESF-200         | 4               | 29784.00 | 9452.00  | 408.00   | 9860.00  | 1972.00  | 2584.00  | 5508.00  | 

    # Check the PLANNED VOLUMES in CRM
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-200       | ESF-200         | 1               | 467      | 75       | 48       | 89       | 118      | 69       | 68       | 
    | ESIF-200       | ESF-200         | 2               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | ESIF-200       | ESF-200         | 3               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | ESIF-200       | ESF-200         | 4               | 438      | 139      | 6        | 145      | 29       | 38       | 81       | 

    # Check the ACTUAL VOLUMES in CRM
    Then  the Actuals Volume Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | ESIF-200       | ESF-200         | 1               | -29      | -29      | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 2               | 0        | 0        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 3               | 0        | 0        | ?        | ?        | ?        | ?        | ?        | 
    | ESIF-200       | ESF-200         | 4               | 19       | 19       | ?        | ?        | ?        | ?        | ?        | 

    # Check the ACTUAL totals in CRM at deliverable level rather than deliverable period level (24295)
    And  the Actuals Data is stored in CRM at deliverable level against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | ActualValue | ActualVolume |
    | ESIF-200       | ESF-200       | 1               | -1682.00    | -29          |
    | ESIF-200       | ESF-200       | 2               | 4214.00     | 0            |
    | ESIF-200       | ESF-200       | 3               | 1763.00     | 0            |
    | ESIF-200       | ESF-200       | 4               | 703.00      | 19           |
	
	# Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | ESF-200          | 1             | 1               | 201804 | 2              | 92            | 2484.00      | 0.00                 | 0.00                | 0.00                   | -1682.00                    | -1682.00         | -29          | -1682.00    |
    | ESF-200          | 1             | 2               | 201804 | 2              | 0             | 1633.00      | 0.00                 | 0.00                | 0.00                   | 4214.00                     | 4214.00          | 0            | 4214.00     |
    | ESF-200          | 1             | 3               | 201804 | 2              | 0             | 4241.00      | 0.00                 | 0.00                | 0.00                   | 1763.00                     | 1763.00          | 0            | 1763.00     |
    | ESF-200          | 1             | 4               | 201804 | 2              | 54            | 1782.00      | 0.00                 | 0.00                | 0.00                   | 703.00                      | 703.00           | 19           | 703.00      |
    #
    | ESF-200          | 2             | 1               | 201804 | 2              | 75            | 7725.00      | 0.00                 | 0.00                | 0.00                   | -1682.00                    | -1682.00         | -29          | -1682.00    |
    | ESF-200          | 2             | 2               | 201804 | 2              | 0             | 1190.00      | 0.00                 | 0.00                | 0.00                   | 4214.00                     | 4214.00          | 0            | 4214.00     |
    | ESF-200          | 2             | 3               | 201804 | 2              | 0             | 1785.00      | 0.00                 | 0.00                | 0.00                   | 1763.00                     | 1763.00          | 0            | 1763.00     |
    | ESF-200          | 2             | 4               | 201804 | 2              | 139           | 9452.00      | 0.00                 | 0.00                | 0.00                   | 703.00                      | 703.00           | 19           | 703.00      |


    # Test Actual Value and Volume in CM feed

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'ESIF-200' agree with the most recent entry for this contract in the ContractManagement feed





    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check that certain ActualsUpdated rows are absent from the AllocationDelivery.AllocationDeliveryEntry table
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '3' event for version '2' of contract number 'ESIF-200' and allocation number 'ESF-200'
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '4' event for version '2' of contract number 'ESIF-200' and allocation number 'ESF-200'

    # Check that the relevant events are on the ADP feed
    Then  the ADP feed includes the following values
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | ContractVersionNumber | SubVersionNumber | AllocationNumber | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    | NewContractAllocationApproved     | 0      | ESIF-200       | 1                     | 0                | ESF-200          | ?                         | ?                            |
    | ContractAllocationActualsReceived | 2      | ESIF-200       | 1                     | 0                | ESF-200          | ?                         | ?                            |
    | AmendedContractAllocationApproved | 1      | ESIF-200       | 2                     | 0                | ESF-200          | ?                         | ?                            |

    # Check the ADP feed event header information
    And   the Allocation Delivery feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                        | CategoryLabel                        | Title                                                                               |
    | 10017200 | ESIF-200       | 1               | 0                  | NewContractAllocationApproved       | New Contract Allocation Approved     | New Contract ESIF-200: 1.0 with Allocation ESF-200 was Approved                     |
    | 10017200 | ESIF-200       | 1               | 0                  | ContractAllocationActualsReceived   | Contract Allocation Actuals Received | Actuals for Allocation ESF-200 of Contract ESIF-200: 1.0 have been received         |
    | 10017200 | ESIF-200       | 2               | 0                  | AmendedContractAllocationApproved   | Amended Contract Allocation Approved | Amendment to Contract ESIF-200: 2.0 with Allocation ESF-200 was Approved            |

    # Check financials on the ADP feed
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
    | AllocationDeliveryEntryCategory   | ContractNumber | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 1               | 201804 | -1682.00    | 0.00           | 0.00             | -1682.00              | 0.00           | -1682.00   |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 1               | 201805 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 1               | 201806 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 1               | 201807 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 1               | 201808 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 1               | 201809 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 2               | 201804 | 4214.00     | 0.00           | 0.00             | 4214.00               | 0.00           | 4214.00    |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 2               | 201805 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 2               | 201806 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 2               | 201807 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 2               | 201808 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 2               | 201809 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 3               | 201804 | 1763.00     | 0.00           | 0.00             | 1763.00               | 0.00           | 1763.00    |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 3               | 201805 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 3               | 201806 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 3               | 201807 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 3               | 201808 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 3               | 201809 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 4               | 201804 | 703.00      | 0.00           | 0.00             | 703.00                | 0.00           | 703.00     |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 4               | 201805 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 4               | 201806 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 4               | 201807 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 4               | 201808 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | ESIF-200       | 1             | ESF-200          | 4               | 201809 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |

    # Check Planned data on the ADP feed
    And   the Allocation Delivery Monitoring Service atom feed contains the following Planned data
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 1               | 201804 | 7725.00      | 75            |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 1               | 201805 | 4944.00      | 48            |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 1               | 201806 | 9167.00      | 89            |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 1               | 201807 | 12154.00     | 118           |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 1               | 201808 | 7107.00      | 69            |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 1               | 201809 | 7004.00      | 68            |
    #
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 2               | 201804 | 1190.00      | 0             |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 2               | 201805 | 2278.00      | 0             |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 2               | 201806 | 357.00       | 0             |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 2               | 201807 | 1054.00      | 0             |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 2               | 201808 | 136.00       | 0             |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 2               | 201809 | 1003.00      | 0             |
    #
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 3               | 201804 | 1785.00      | 0             |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 3               | 201805 | 1190.00      | 0             |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 3               | 201806 | 1071.00      | 0             |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 3               | 201807 | 765.00       | 0             |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 3               | 201808 | 1666.00      | 0             |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 3               | 201809 | 1530.00      | 0             |
    #
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 4               | 201804 | 9452.00      | 139           |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 4               | 201805 | 408.00       | 6             |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 4               | 201806 | 9860.00      | 145           |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 4               | 201807 | 1972.00      | 29            |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 4               | 201808 | 2584.00      | 38            |
    | AmendedContractAllocationApproved | ESIF-200           | 2             | ESF-200          | 4               | 201809 | 5508.00      | 81            |


    # Tidy up
    And   the override date is reset

     