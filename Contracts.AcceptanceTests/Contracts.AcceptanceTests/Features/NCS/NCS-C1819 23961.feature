Feature: NCS-C1819 23961

@AcceptanceTest @Withdrawn20210702
@Long2Run @Long2Run45
Scenario: A596SLD Create a new 1819 NCS contract with an NCS-C allocation. Bulk update draft. Approve. Consume actuals and create PoA payment files. Amend and approve. Check CRM, Financials, PaaS, CM Feed, ADP feed and Payment feed
    Given there is no Contract, Task or Workflow data for UKPRN '10017596' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | NCSC-596      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017596' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017596 Co Ltd' with UKPRN '10017596' and OrgId 'ORG0017596' and has 'FCS1 Test' as a manager 
    And   UPIN '117596' is associated with UKPRN '10017596' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017596 | 117596 | 10017596 Co Ltd | 0              | Active | Yes           | AA017596      | ?             | 




    # Change the date
    Given the override date is '01/09/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017596 | 10017596 Co Ltd      | ESFA-596             | NCS-596        | 1                     | 01/10/2018        | 31/03/2019      | 47717.00      | North East and Cumbria         | Contract for Services | 1819   | New          | ORG0017596 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017596 | NCS-596        | NCSC-596      | NCS-C             | NCS-C1819               | NCS                     | 01/10/2018          | 31/03/2019        | 47717.00        | North East and Cumbria  | 0000000106 |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017596 | NCS-596        | NCSC-596      | 1               | 0                     | 47717.00  | 8393.00  | 9747.00  | 7652.00  | 6536.00  | 7919.00  | 7470.00  | Total In The Community Funding                                  | New          |             |
    | 10017596 | NCS-596        | NCSC-596      | 2               | 1                     | 18468.00  | 2635.00  | 3277.00  | 3317.00  | 3198.00  | 3554.00  | 2487.00  | Customer Satisfaction                                           | New          |             |
    | 10017596 | NCS-596        | NCSC-596      | 3               | 1                     | 29249.00  | 5758.00  | 6470.00  | 4335.00  | 3338.00  | 4365.00  | 4983.00  | Career Management and Jobs and Learning                         | New          |             |
    | 10017596 | NCS-596        | NCSC-596      | 4               | 3                     | 14248.00  | 2339.00  | 2853.00  | 1311.00  | 2236.00  | 2181.00  | 3328.00  | Career Management                                               | New          |             |
    | 10017596 | NCS-596        | NCSC-596      | 5               | 3                     | 15001.00  | 3419.00  | 3617.00  | 3024.00  | 1102.00  | 2184.00  | 1655.00  | Jobs and Learning                                               | New          |             |
    | 10017596 | NCS-596        | NCSC-596      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | DeliverableCode | AllocationRef | UnitCost | Total   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | 
    | 10017596 | NCS-596        | 6               | NCSC-596      | 48       | 274     | 19       | 47       | 80       | 24       | 57       | 47       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'




    # Change the date
    Given the override date is '05/09/2018'

	# Month end is not running
	And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Bulk import to execute an update draft
    And   there are no files prefixed '10017596_NCS' in the Sharepoint 'NCS-1819-Input-Appendices' folder
    And   there are no files prefixed 'NCS NCS 1819 14082018141008 v2_A596' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NCS NCS 1819 14082018141008 v2_A596' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NCS NCS 1819 14082018141008 v2_A596.xlsx' exists in the Datafiles folder and UKPRN '10017596' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Change the date
    Given the override date is '07/09/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NCS-596' is in a state of 'Published to Provider'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017596 | NCS-596            | 1                     | 1                        | Draft            | Published to Provider     | True          | False               | 01/10/2018        | 31/03/2019      | ?             |
    | 10017596 | NCS-596            | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/10/2018        | 31/03/2019      | ?             |
    | 10017596 | ESFA-596           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |




    # Change the date
    Given the override date is '09/09/2018'

	# Month end is not running
	And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-596' and actual ContractNumber 'NCS-596'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-596' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017596 | NCS-596            | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/10/2018        | 31/03/2019      | ?             |
    | 10017596 | NCS-596            | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/10/2018        | 31/03/2019      | ?             |
    | 10017596 | ESFA-596           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'NCS-596'



    # Change the date
    Given the override date is '04/02/2019'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017596'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And  there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Jan 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | NCS1819        | N06                  | ORG0017596     | CM             | 201810 | NCS-C1819               | NCSC-596                 | 0000000106 | 2               | 0            | 1454.48     |
    | NCS1819        | N06                  | ORG0017596     | CM             | 201810 | NCS-C1819               | NCSC-596                 | 0000000106 | 4               | 0            | 1315.51     |
    | NCS1819        | N06                  | ORG0017596     | CM             | 201810 | NCS-C1819               | NCSC-596                 | 0000000106 | 5               | 0            | 1098.63     |
    | NCS1819        | N06                  | ORG0017596     | CM             | 201811 | NCS-C1819               | NCSC-596                 | 0000000106 | 2               | 0            | 1463.11     |
    | NCS1819        | N06                  | ORG0017596     | CM             | 201811 | NCS-C1819               | NCSC-596                 | 0000000106 | 4               | 0            | 790.69      |
    | NCS1819        | N06                  | ORG0017596     | CM             | 201811 | NCS-C1819               | NCSC-596                 | 0000000106 | 5               | 0            | 1457.41     |
    | NCS1819        | N06                  | ORG0017596     | CM             | 201812 | NCS-C1819               | NCSC-596                 | 0000000106 | 2               | 0            | 971.33      |
    | NCS1819        | N06                  | ORG0017596     | CM             | 201812 | NCS-C1819               | NCSC-596                 | 0000000106 | 4               | 0            | 1299.85     |
    | NCS1819        | N06                  | ORG0017596     | CM             | 201812 | NCS-C1819               | NCSC-596                 | 0000000106 | 5               | 0            | 465.97      |
    | NCS1819        | N06                  | ORG0017596     | CM             | 201901 | NCS-C1819               | NCSC-596                 | 0000000106 | 2               | 0            | 1025.07     |
    | NCS1819        | N06                  | ORG0017596     | CM             | 201901 | NCS-C1819               | NCSC-596                 | 0000000106 | 4               | 0            | 1237.83     |
    | NCS1819        | N06                  | ORG0017596     | CM             | 201901 | NCS-C1819               | NCSC-596                 | 0000000106 | 5               | 0            | 1141.91     |
    | NCS1819        | N06                  | ORG0017596     | CM             | 201902 | NCS-C1819               | NCSC-596                 | 0000000106 | 2               | 0            | 765.12      |
    | NCS1819        | N06                  | ORG0017596     | CM             | 201902 | NCS-C1819               | NCSC-596                 | 0000000106 | 4               | 0            | 1001.59     |
    | NCS1819        | N06                  | ORG0017596     | CM             | 201902 | NCS-C1819               | NCSC-596                 | 0000000106 | 5               | 0            | 436.34      |
    | NCS1819        | N06                  | ORG0017596     | CM             | 201903 | NCS-C1819               | NCSC-596                 | 0000000106 | 2               | 0            | 912.13      |
    | NCS1819        | N06                  | ORG0017596     | CM             | 201903 | NCS-C1819               | NCSC-596                 | 0000000106 | 4               | 0            | 1307.13     |
    | NCS1819        | N06                  | ORG0017596     | CM             | 201903 | NCS-C1819               | NCSC-596                 | 0000000106 | 5               | 0            | 167.52      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # This bit checks that there is something in PaaS. In essence, a 'wait' before proceeding with the batch
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017596 | ORG0017596 | NCSC-596          | 2305310         | NCS-C1819                  | 201901               | RECONCILIATION  | CM             | False       | 13721.79        |
    



	# Change the date
    Given the override date is '13/02/2019 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'NCS-C1819' AccountingPaymentPeriod '201810' CensusEndDate '13/02/2019' and LinkCodeSuffix 'A'

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | NCS-C1819                  | 201901               |                      | A              | NotStarted |

#    # Coda.AccountCode
#    And   the following configuration exists in the Account Codes table
#    | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#    | 10017596 | NCS-C1819                  | CODA596   | 8115000      | 01/08/1990           | 31/08/2020         |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | NCS-C1819                  | 201901               | Completed |

#    # File created in Maytech FTP folder for 'NCS In the Community 18-19'
#    And   Payment file 'NCSC20181013A.pay' is created in the FTP Folder
#
#    # Decrypt the payment file to the Output window and save a decrypted version to Datafiles/Downloads
#    Given there is an encrypted file called 'NCSC20181013A.pay' in the Maytech FTP folder decrypt it then save it to 'DataFiles/Downloads'
#
#    # Check the contents of the payment file
#    Then  the following details are present in payment file 'NCSC20181013A.pay'
#    | LinkCode    | CompanyCode | Element1 | Element2 | Element3 | Element4 | Element5 | Element6   | Element7 | Element8 | Year | Period | Date       | Amount   | Dc   | LineType | Doc     | Desc                            | DueDate    | Tax | Extref1                       | Extref2     | Extref3      | Extref4 | Extref5  | Extref6 | Num   | DocLineNo |
#    | NCSC181013A | SFA         | AAA20    | +        | 8115000  | CODA596  | 02       | NCSC-596   | ?        | ?        | 2018 | 10     | 13/02/2019 | 13721.79 | 160  | 157      | NCSCR   | NCS Adult Core Rec Feb19        | 26/02/2019 | ?   | NCSC RECONCILIATION 2018/19   | NCSC181013A | ?            | ?       | 10017596 | 2305310 | 1     | 1         |
#    | NCSC181013A | SFA         | AAA20    | +        | 2305310  | 5000     | 02       | NCSC-596   | ?        | ?        | 2018 | 10     | 13/02/2019 | 13721.79 | 161  | 158      | NCSCR   | NCS Adult Core Rec Feb19        | 26/02/2019 | VIO | NCSC RECONCILIATION 2018/19   | NCSC181013A | ?            | ?       | 10017596 | CODA596 | 1     | 2         |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'NCS-C1819' PaymentPeriod '201810' CensusEndDate '13/02/2019' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A596.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'NCS-C1819' PaymentPeriod '201810' CensusEndDate '13/02/2019' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | NCSC                   | 2018          | 10             | 13          | ?       | NCSC-596      | 13721.79        | RECONCILIATION   | NCS Adult Core                     | 2019-02-26 | 2018-10-01   | 2019-03-31 | ?              | 10017596 | 2305310    |


    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    And   there is an item on the Payment feed for FundingStreamPeriod 'NCS-C1819' AccountingPaymentPeriod '201810' and CensusEndDate '13/02/2019'

    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                               |
    | Payment Requests for Funding Stream Period NCS-C1819 for Payment Period 201810 have been generated as of Census End Date/Time 2019-02-13T22:00:00Z. |

    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate        | PaymentLineCount | TotalValue |
    | NCS-C1819           | 201810        | 2019-02-13T22:00:00Z | 1                | 13721.79   |

    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | NCSC      | 01/10/2018   | 31/03/2019 | 13/02/2019    | 26/02/2019 | 2018          | 10             |

    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017596  | 10017596       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | NCSC-596   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2305310    | RECONCILIATION | NCS Adult Core                | 13721.79        |


   # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-596        | NCSC-596        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NCS-596        | NCSC-596        | 2               | 4913.99  | 1454.48  | 1463.11  | 971.33   | 1025.07  | ?        | ?        | 
    | NCS-596        | NCSC-596        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NCS-596        | NCSC-596        | 4               | 4643.88  | 1315.51  | 790.69   | 1299.85  | 1237.83  | ?        | ?        | 
    | NCS-596        | NCSC-596        | 5               | 4163.92  | 1098.63  | 1457.41  | 465.97   | 1141.91  | ?        | ?        | 
    | NCS-596        | NCSC-596        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-596        | NCSC-596        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NCS-596        | NCSC-596        | 2               | 4913.99  | 0.00     | 0.00     | 0.00     | 4913.99  | ?        | ?        | 
    | NCS-596        | NCSC-596        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NCS-596        | NCSC-596        | 4               | 4643.88  | 0.00     | 0.00     | 0.00     | 4643.88  | ?        | ?        | 
    | NCS-596        | NCSC-596        | 5               | 4163.92  | 0.00     | 0.00     | 0.00     | 4163.92  | ?        | ?        | 
    | NCS-596        | NCSC-596        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-596        | NCSC-596        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NCS-596        | NCSC-596        | 2               | 4913.99  | 0.00     | 0.00     | 0.00     | 4913.99  | ?        | ?        | 
    | NCS-596        | NCSC-596        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NCS-596        | NCSC-596        | 4               | 4643.88  | 0.00     | 0.00     | 0.00     | 4643.88  | ?        | ?        | 
    | NCS-596        | NCSC-596        | 5               | 4163.92  | 0.00     | 0.00     | 0.00     | 4163.92  | ?        | ?        | 
    | NCS-596        | NCSC-596        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-596        | NCSC-596        | 1               | 53460.00 | 11434.00 | 7826.00  | 8750.00  | 7210.00  | 9656.00  | 8584.00  | 
    | NCS-596        | NCSC-596        | 2               | 18769.00 | 2791.00  | 4874.00  | 2262.00  | 2824.00  | 2454.00  | 3564.00  | 
    | NCS-596        | NCSC-596        | 3               | 34691.00 | 8643.00  | 2952.00  | 6488.00  | 4386.00  | 7202.00  | 5020.00  | 
    | NCS-596        | NCSC-596        | 4               | 14645.00 | 3869.00  | 326.00   | 2368.00  | 3432.00  | 4331.00  | 319.00   | 
    | NCS-596        | NCSC-596        | 5               | 20046.00 | 4774.00  | 2626.00  | 4120.00  | 954.00   | 2871.00  | 4701.00  | 
    | NCS-596        | NCSC-596        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PLANNED VOLUMES in CRM
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-596        | NCSC-596        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-596        | NCSC-596        | 2               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-596        | NCSC-596        | 3               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-596        | NCSC-596        | 4               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-596        | NCSC-596        | 5               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-596        | NCSC-596        | 6               | 883      | 216      | 176      | 97       | 132      | 134      | 128      | 

    # Check the RECONCILIATION subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017596 | ORG0017596 | NCSC-596          | 2305310         | NCS-C1819                  | 201810               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017596 | ORG0017596 | NCSC-596          | 2305310         | NCS-C1819                  | 201811               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017596 | ORG0017596 | NCSC-596          | 2305310         | NCS-C1819                  | 201812               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017596 | ORG0017596 | NCSC-596          | 2305310         | NCS-C1819                  | 201901               | RECONCILIATION  | CM             | True        | 13721.79        |


    # Check AllocationDelivery.AllocationDeliveryEntry (ADP) feed for ActualsReceived and PaymentPosted events
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events 
    | AllocationDeliveryEntryCategory     | ADCode | ContractNumber | AllocationNumber | ContractVersionNumber |
    | ContractAllocationActualsReceived   | 2      | NCS-596        | NCSC-596         | 1                     |
    | ContractAllocationPaymentReceived   | 3      | NCS-596        | NCSC-596         | 1                     |
	
	


	# Change the date
    Given the override date is '15/02/2019'

    # Bulk import to amend the contract and create v2
    And   there are no files prefixed '10017596_NCS' in the Sharepoint 'NCS-1819-Input-Appendices' folder
    And   there are no files prefixed 'NCS NCS 1819 14082018152322 v2_A596_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NCS NCS 1819 14082018152322 v2_A596_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NCS NCS 1819 14082018152322 v2_A596_1.xlsx' exists in the Datafiles folder and UKPRN '10017596' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NCS-596' is in a state of 'Published to Provider'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017596 | NCS-596            | 2                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/10/2018        | 31/03/2019      | Variation     |
    | 10017596 | NCS-596            | 1                     | 1                        | Approved         | Approved                  | False         | True                | 01/10/2018        | 31/03/2019      | ?             |
    | 10017596 | NCS-596            | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/10/2018        | 31/03/2019      | ?             |
    | 10017596 | ESFA-596           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |


    # Change the date
    Given the override date is '19/02/2019'

	# Month end is not running
	And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-596' and actual ContractNumber 'NCS-596'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-596' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017596 | NCS-596            | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/10/2018        | 31/03/2019      | Variation     |
    | 10017596 | NCS-596            | 1                     | 1                        | Replaced         | Approved                  | False         | False               | 01/10/2018        | 31/03/2019      | ?             |
    | 10017596 | NCS-596            | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/10/2018        | 31/03/2019      | ?             |
    | 10017596 | ESFA-596           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'NCS-596'


   # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-596        | NCSC-596        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NCS-596        | NCSC-596        | 2               | 4913.99  | 1454.48  | 1463.11  | 971.33   | 1025.07  | 0.00     | ?        | 
    | NCS-596        | NCSC-596        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NCS-596        | NCSC-596        | 4               | 4643.88  | 1315.51  | 790.69   | 1299.85  | 1237.83  | 0.00     | ?        | 
    | NCS-596        | NCSC-596        | 5               | 4163.92  | 1098.63  | 1457.41  | 465.97   | 1141.91  | 0.00     | ?        | 
    | NCS-596        | NCSC-596        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-596        | NCSC-596        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NCS-596        | NCSC-596        | 2               | 4913.99  | 0.00     | 0.00     | 0.00     | 4913.99  | 0.00     | ?        | 
    | NCS-596        | NCSC-596        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NCS-596        | NCSC-596        | 4               | 4643.88  | 0.00     | 0.00     | 0.00     | 4643.88  | 0.00     | ?        | 
    | NCS-596        | NCSC-596        | 5               | 4163.92  | 0.00     | 0.00     | 0.00     | 4163.92  | 0.00     | ?        | 
    | NCS-596        | NCSC-596        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
	
    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-596        | NCSC-596        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NCS-596        | NCSC-596        | 2               | 4913.99  | 0.00     | 0.00     | 0.00     | 4913.99  | 0.00     | ?        | 
    | NCS-596        | NCSC-596        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 
    | NCS-596        | NCSC-596        | 4               | 4643.88  | 0.00     | 0.00     | 0.00     | 4643.88  | 0.00     | ?        | 
    | NCS-596        | NCSC-596        | 5               | 4163.92  | 0.00     | 0.00     | 0.00     | 4163.92  | 0.00     | ?        | 
    | NCS-596        | NCSC-596        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | 	
	
    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-596        | NCSC-596        | 1               | 52711.00 | 11566.00 | 5646.00  | 10612.00 | 11446.00 | 7800.00  | 5641.00  | 
    | NCS-596        | NCSC-596        | 2               | 13189.00 | 2525.00  | 1999.00  | 3242.00  | 1556.00  | 1322.00  | 2545.00  | 
    | NCS-596        | NCSC-596        | 3               | 39522.00 | 9041.00  | 3647.00  | 7370.00  | 9890.00  | 6478.00  | 3096.00  | 
    | NCS-596        | NCSC-596        | 4               | 18895.00 | 4267.00  | 1324.00  | 2368.00  | 5613.00  | 4235.00  | 1088.00  | 
    | NCS-596        | NCSC-596        | 5               | 20627.00 | 4774.00  | 2323.00  | 5002.00  | 4277.00  | 2243.00  | 2008.00  | 
    | NCS-596        | NCSC-596        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PLANNED VOLUMES in CRM
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-596        | NCSC-596        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-596        | NCSC-596        | 2               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-596        | NCSC-596        | 3               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-596        | NCSC-596        | 4               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-596        | NCSC-596        | 5               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-596        | NCSC-596        | 6               | 1029     | 432      | 51       | 242      | 67       | 108      | 129      | 	
	
    # Check the RECONCILIATION subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017596 | ORG0017596 | NCSC-596          | 2305310         | NCS-C1819                  | 201810               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017596 | ORG0017596 | NCSC-596          | 2305310         | NCS-C1819                  | 201811               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017596 | ORG0017596 | NCSC-596          | 2305310         | NCS-C1819                  | 201812               | RECONCILIATION  | CM             | False       | 0.00            |
    | 10017596 | ORG0017596 | NCSC-596          | 2305310         | NCS-C1819                  | 201901               | RECONCILIATION  | CM             | True        | 13721.79        |
    | 10017596 | ORG0017596 | NCSC-596          | 2305310         | NCS-C1819                  | 201902               | RECONCILIATION  | CM             | False       | 0.00            |
	

    # Check CM feed data for ItemType zero (Approval) messages for v1 and v2
    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version '1' of actual contract number 'NCS-596'
    And   the ItemType '0' event for version '1' of actual contract number 'NCS-596' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version '2' of actual contract number 'NCS-596'
    And   the ItemType '0' event for version '2' of actual contract number 'NCS-596' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema




    # Check that the subnominal details are carried forward from v2 to v3 when a non-financial amendment is approved (28464)
   
    # Change the date
    Given the override date is '22/02/2019'

    # Issue a non-financial VARIATION amendment on v2 to create v3 then check subnominal details on the deliverable periods for v3
   #When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'NCS-596' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'NCS-596' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017596 | NCS-596            | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/10/2018        | 31/03/2019      | Variation     |
    | 10017596 | NCS-596            | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/10/2018        | 31/03/2019      | Variation     |
    | 10017596 | NCS-596            | 1                     | 1                        | Replaced         | Approved                  | False         | False               | 01/10/2018        | 31/03/2019      | ?             |
    | 10017596 | NCS-596            | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/10/2018        | 31/03/2019      | ?             |

	# Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the latest version of contract 'NCS-596' is in a state of 'Published to Provider'
	
	# Month end is not running
	And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '3' actual MasterContractNumber 'ESFA-596' and actual ContractNumber 'NCS-596'

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-596        | NCSC-596        | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-596        | NCSC-596        | 2               | 4913.99   | 1454.48  | 1463.11  | 971.33   | 1025.07  | 0.00     | 0.00     | 
    | NCS-596        | NCSC-596        | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-596        | NCSC-596        | 4               | 4643.88   | 1315.51  | 790.69   | 1299.85  | 1237.83  | 0.00     | 0.00     | 
    | NCS-596        | NCSC-596        | 5               | 4163.92   | 1098.63  | 1457.41  | 465.97   | 1141.91  | 0.00     | 0.00     | 
    | NCS-596        | NCSC-596        | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-596        | NCSC-596        | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-596        | NCSC-596        | 2               | 4913.99   | 0.00     | 0.00     | 0.00     | 4913.99  | 0.00     | 0.00     | 
    | NCS-596        | NCSC-596        | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NCS-596        | NCSC-596        | 4               | 4643.88   | 0.00     | 0.00     | 0.00     | 4643.88  | 0.00     | 0.00     | 
    | NCS-596        | NCSC-596        | 5               | 4163.92   | 0.00     | 0.00     | 0.00     | 4163.92  | 0.00     | 0.00     | 
    | NCS-596        | NCSC-596        | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

	 
    # Tidy up
	 Then  the override date is reset
	  
@AcceptanceTest @Withdrawn20210702
Scenario: A868 Bulk load a new 1819 NCS contract with NCS-C and NCS-DEV allocations. Check docs. Publish and approve then check CRM financials
    Given there is no Contract, Task or Workflow data for UKPRN '10017868'

    # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017868' 
#   And   caseload advisor 'FCS2 Test' is assigned to provider '10017868 Co Ltd' with UKPRN '10017868' and OrgId 'ORG0017868' and has 'FCS1 Test' as a manager 
#   And   UPIN '117868' is associated with UKPRN '10017868' in the CRM Organisation table 
 
   # Put data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017868 | 117868 | 10017868 Co Ltd | 0              | Active | Yes           | AA017868      | ?             | 14 Daisy Way           | High Lane              | ?                      | ?                      | Stockport              | Cheshire               | SK6 8EF   |

#   # Put data in the CRM Organisation table J057
#   And   the following Organisations exist in CRM
#   | UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
#   | 10017868 | 117868 | 10017868 Co Ltd | Active | AA017868      | ?             | 14 Daisy Way           | High Lane              | ?                      | ?                      | Stockport              | Cheshire               | SK6 8EF   |

    # Change the date
    Given the override date is '22/01/2019'

    # Bulk import to create a new NCS-C1819 contract
    And   there are no files prefixed '10017868_NCS' in the Sharepoint 'NCS-1819-Input-Appendices' folder
    And   there are no files prefixed 'NCS NCS 1819 19122018181817 v2_A868' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NCS NCS 1819 19122018181817 v2_A868' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NCS NCS 1819 19122018181817 v2_A868.xlsx' exists in the Datafiles folder and UKPRN '10017868' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017868' for FundingType 'NCS' and period '1819' and Delivery Organisation '10178681'
    And   I retrieve the latest contract details from CRM for provider '10017868' for FundingType 'NCS' and period '1819'

    # Check the contents of the Appendices
    And   a file for this contract exists in sharepoint location 'NCS-1819-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 6
    Maximum Contract Value and Target
    Customer Volumes
    Maximum Contract Value
    1. In this Schedule, where the context admits, defined terms shall have the
    meaning given to them in Clause 1 of the Terms and Conditions.
    2. This Schedule sets out the Maximum Contract Value for the supply of the
    Services under the Contract from 1 October 2018 – 31 March 2019.  Delivery
    against this Contract shall start on 1 October 2018. For the avoidance of doubt,
    the Prime Contractor may not seek to invoice the ESFA in respect of any
    services supplied prior to the Services Start Date of 1 October 2018.
    3. The Maximum Contract Value in the Area for the period 1 October 2018 – 31
    March 2019 is £80,539. The Maximum Contract Value must be allocated in
    accordance with the principles set out in the Funding Rules.
    4. The Maximum Contract Value has been calculated to include inflation during the
    Contract Period and will not be increased to reflect inflationary rate rises during
    the Contract Period.
    5. The Maximum Contract Value in the Area for the Contract Year starting on 1
    April 2019, and for each subsequent anniversary thereof, shall be as notified by
    the ESFA to the Prime Contractor as soon as is practicable at the beginning of
    each calendar year, with final allocations confirmed at the beginning of May
    each year.
    6. This Schedule supplements the obligations on the Prime Contractor in the
    Terms and Conditions and the Funding Rules.
    Target Customer Volumes
    7. The Target Customer Volumes are as follows:
    Contract Year Target Customer Volumes
    01/10/18 – 31/03/19 920
    01/04/19 – 31/03/20 TBC
    01/04/20 – 31/03/21 TBC

	Schedule 6A: National Careers Service
	50 Plus Futures
	10017868 CO LTD
	Activity and Payments 1 January 2019 – 31 March 2019
	Payment Proportion
	Activity Description Total Cost
	Date of Payment
	Initial activity set out in the agreed 50
	February
	Plus Futures costed plan in Appendix 32.5% £6,916
	2019
	1 of Schedule 6A.
	Payment based on all activity up to
	28 February 2019 as outlined within
	Appendix 1 of Schedule 6A and
	March 2019 32.5% £6,916
	receipt of monthly progress reports
	for 1 January 2019 – 28 February
	2019
	Payment based on all activity up to
	31 March 2019 as outlined within
	Appendix 1 of Schedule 6A and April 2019 35% £7,448
	receipt of monthly progress reports
	for 1 January 2019 – 31 March 2019
	Total Payable 1 January 2019 – 30
	100% £21,280
	April 2019
	The financial amounts set out in this table are for delivery from 1 January 2019 – 31
	March 2019 and the activities are set out in the National Careers Service 50 Plus
	Futures costed plan in Appendix 1 of Schedule 6A.
	The Prime Contractor must submit a costed 50 Plus Futures plan to the ESFA by 18
	December 2018.
	Payments will be made based on the evidence criteria set out in;
     the 50 Plus Futures costed plan for activity described in Appendix 1 of Schedule
    6A; and
     upon receipt of the progress reports as outlined for the requisite payment
    """

	# Assign Zoe as the caseload advisor for this provider - without creating an Org in CRM
	# Note: Use where bulk import creates the contract\provider and put it after the doc check
    Given caseload advisor 'FCS2 Test' is assigned to UKPRN '10017868' 

   #And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    Then  the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017868 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/10/2018        | 31/03/2019      | ?             |
    | 10017868 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |
   
	# Month end is not running
	And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Inject an SFS contract approval message.
   #When  an AEB contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved in CRM
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017868 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/10/2018        | 31/03/2019      | ?             |
    | 10017868 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable counts in CRM 
   #And   there are 'nnn' deliverable periods in CRM linked to the latest version of contract 'xxxx-868' and allocation 'xxxx-868' 
   #And   there are 'nnn' deliverable period rows in CRM linked to the latest version of contract 'xxxx-868' 
    And   there are '42' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 

    # Check the data in the CRM Organisation table J060
    And   the CRM Organisation table contains the following values
    | UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017868 | 117868 | 10017868 Co Ltd | Active | AA017868      | ?             | 14 Daisy Way           | High Lane              | ?                      | ?                      | Stockport              | Cheshire               | SK6 8EF   |




    # Check Financials in CRM
    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017868' for FundingType 'NCS' and period '1819' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017868' for FundingType 'NCS' and period '1819'

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | [ContractNo]   | [AllocRef_NCSV] | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 3               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 6               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | [ContractNo]   | [AllocRef_NCSV] | 1               | 21280.00  | 0.00     | 0.00     | 0.00     | 6916.00  | 6916.00  | 7448.00  | 
    | [ContractNo]   | [AllocRef_NCSC] | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | [ContractNo]   | [AllocRef_NCSV] | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NCSC] | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | [ContractNo]   | [AllocRef_NCSV] | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NCSC] | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | [ContractNo]   | [AllocRef_NCSV] | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NCSC] | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | [ContractNo]   | [AllocRef_NCSV] | 1               | 21280.00  | 0.00     | 0.00     | 0.00     | 6916.00  | 6916.00  | 7448.00  | 
    | [ContractNo]   | [AllocRef_NCSC] | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NCSC] | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NCSC] | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NCSC] | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | [ContractNo]   | [AllocRef_NCSV] | 1               | 21280.00  | 0.00     | 0.00     | 0.00     | 6916.00  | 6916.00  | 7448.00  | 
    | [ContractNo]   | [AllocRef_NCSC] | 1               | 59259.00  | 11859.00 | 10194.00 | 11245.00 | 10723.00 | 8343.00  | 6895.00  | 
    | [ContractNo]   | [AllocRef_NCSC] | 2               | 15834.00  | 3931.00  | 937.00   | 4969.00  | 4090.00  | 461.00   | 1446.00  | 
    | [ContractNo]   | [AllocRef_NCSC] | 3               | 43425.00  | 7928.00  | 9257.00  | 6276.00  | 6633.00  | 7882.00  | 5449.00  | 
    | [ContractNo]   | [AllocRef_NCSC] | 4               | 21966.00  | 4757.00  | 4724.00  | 3508.00  | 2206.00  | 4797.00  | 1974.00  | 
    | [ContractNo]   | [AllocRef_NCSC] | 5               | 21459.00  | 3171.00  | 4533.00  | 2768.00  | 4427.00  | 3085.00  | 3475.00  | 
    | [ContractNo]   | [AllocRef_NCSC] | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PLANNED VOLUMES in CRM on the latest approved contract
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | [ContractNo]   | [AllocRef_NCSV] | 1               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC] | 1               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC] | 2               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC] | 3               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC] | 4               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC] | 5               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 
    | [ContractNo]   | [AllocRef_NCSC] | 6               | 920       | 88       | 243      | 233      | 209      | 79       | 68       | 



    # Tidy up
    Given the override date is reset

@AcceptanceTest @Withdrawn20210702
Scenario: A869 Create and approve new 1819 NCS contract with an NCS-C allocation. Bulk amend to add an NCS-DEV allocation and approve. Check Financials
    Given there is no Contract, Task or Workflow data for UKPRN '10017869' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | NCSC-869      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017869' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017869 Co Ltd' with UKPRN '10017869' and OrgId 'ORG0017869' and has 'FCS1 Test' as a manager 
    And   UPIN '117869' is associated with UKPRN '10017869' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017869 | 117869 | 10017869 Co Ltd | 0              | Active | Yes           | AA017869      | ?             | 9 Merchants Place      | ?                      | ?                      | ?                      | Reading                | Berkshire              | RG1 1DP   |

    # Change the date
    Given the override date is '01/09/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017869 | 10017869 Co Ltd      | ESFA-869             | NCS-869        | 1                     | 01/10/2018        | 31/03/2019      | 47717.00      | East Midlands and Northamptonshire | Contract for Services | 1819   | New          | ORG0017869 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                             | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017869 | NCS-869        | NCSC-869      | NCS-C             | NCS-C1819               | NCS                     | 01/10/2018          | 31/03/2019        | 47717.00        | East Midlands and Northamptonshire  | 0000000102 |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017869 | NCS-869        | NCSC-869      | 1               | 0                     | 47717.00  | 8393.00  | 9747.00  | 7652.00  | 6536.00  | 7919.00  | 7470.00  | Total In The Community Funding                                  | New          |             |
    | 10017869 | NCS-869        | NCSC-869      | 2               | 1                     | 18468.00  | 2635.00  | 3277.00  | 3317.00  | 3198.00  | 3554.00  | 2487.00  | Customer Satisfaction                                           | New          |             |
    | 10017869 | NCS-869        | NCSC-869      | 3               | 1                     | 29249.00  | 5758.00  | 6470.00  | 4335.00  | 3338.00  | 4365.00  | 4983.00  | Career Management and Jobs and Learning                         | New          |             |
    | 10017869 | NCS-869        | NCSC-869      | 4               | 3                     | 14248.00  | 2339.00  | 2853.00  | 1311.00  | 2236.00  | 2181.00  | 3328.00  | Career Management                                               | New          |             |
    | 10017869 | NCS-869        | NCSC-869      | 5               | 3                     | 15001.00  | 3419.00  | 3617.00  | 3024.00  | 1102.00  | 2184.00  | 1655.00  | Jobs and Learning                                               | New          |             |
    | 10017869 | NCS-869        | NCSC-869      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | DeliverableCode | AllocationRef | UnitCost | Total   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | 
    | 10017869 | NCS-869        | 6               | NCSC-869      | 0        | 274     | 19       | 47       | 80       | 24       | 57       | 47       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NCS-869' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-869' and actual ContractNumber 'NCS-869'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-869' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017869 | NCS-869            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/10/2018        | 31/03/2019      | ?             |
    | 10017869 | ESFA-869           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'NCS-869'




    # Change the date
    Given the override date is '05/02/2019'

    # Bulk import to amend contract to add an NCS-DEV allocation
    And   there are no files prefixed '10017869_NCS' in the Sharepoint 'NCS-1819-Input-Appendices' folder
    And   there are no files prefixed 'NCS NCS 1819 21122018094054 v2_A869' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NCS NCS 1819 21122018094054 v2_A869' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NCS NCS 1819 21122018094054 v2_A869.xlsx' exists in the Datafiles folder and UKPRN '10017869' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Change the date
    Given the override date is '07/02/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NCS-869' is in a state of 'Published to Provider'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017869 | NCS-869            | 2                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/10/2018        | 31/03/2019      | Variation     |
    | 10017869 | NCS-869            | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/10/2018        | 31/03/2019      | ?             |
    | 10017869 | ESFA-869           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |




    # Change the date
    Given the override date is '09/02/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-869' and actual ContractNumber 'NCS-869'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-869' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017869 | NCS-869            | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/10/2018        | 31/03/2019      | Variation     |
    | 10017869 | NCS-869            | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/10/2018        | 31/03/2019      | ?             |
    | 10017869 | ESFA-869           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '42' deliverable period rows in CRM linked to the latest version of contract 'NCS-869'

    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017869' for FundingType 'NCS' and period '1819'


    # Check the PROFILE PAYMENTS in CRM
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-869        | [AllocRef_NCSV]| 1               | 14080.00 | 0.00     | 0.00     | 0.00     | 4576.00  | 4576.00  | 4928.00  | 
    #
    | NCS-869        | NCSC-869        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NCS-869        | NCSC-869        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NCS-869        | NCSC-869        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NCS-869        | NCSC-869        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NCS-869        | NCSC-869        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 
    | NCS-869        | NCSC-869        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | 

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-869        | [AllocRef_NCSV]| 1               | 14080.00 | 0.00     | 0.00     | 0.00     | 4576.00  | 4576.00  | 4928.00  | 
    #
    | NCS-869        | NCSC-869        | 1               | 55792.00 | 12107.00 | 10441.00 | 6541.00  | 10970.00 | 8590.00  | 7143.00  | 
    | NCS-869        | NCSC-869        | 2               | 11376.00 | 4014.00  | 1019.00  | 100.00   | 4172.00  | 543.00   | 1528.00  | 
    | NCS-869        | NCSC-869        | 3               | 44416.00 | 8093.00  | 9422.00  | 6441.00  | 6798.00  | 8047.00  | 5615.00  | 
    | NCS-869        | NCSC-869        | 4               | 22463.00 | 4840.00  | 4807.00  | 3591.00  | 2288.00  | 4880.00  | 2057.00  | 
    | NCS-869        | NCSC-869        | 5               | 21953.00 | 3253.00  | 4615.00  | 2850.00  | 4510.00  | 3167.00  | 3558.00  | 
    | NCS-869        | NCSC-869        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PLANNED VOLUMES in CRM
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-869        | [AllocRef_NCSV]| 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    #
    | NCS-869        | NCSC-869        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-869        | NCSC-869        | 2               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-869        | NCSC-869        | 3               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-869        | NCSC-869        | 4               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-869        | NCSC-869        | 5               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-869        | NCSC-869        | 6               | 939      | 91       | 246      | 236      | 213      | 82       | 71       | 

    # Check the PROFILE subnominal aggregations in PaaS
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017869 | ORG0017869 | [AllocRef_NCSV]| 2305330         | NCS-DEV1819                | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10017869 | ORG0017869 | [AllocRef_NCSV]| 2305330         | NCS-DEV1819                | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10017869 | ORG0017869 | [AllocRef_NCSV]| 2305330         | NCS-DEV1819                | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10017869 | ORG0017869 | [AllocRef_NCSV]| 2305330         | NCS-DEV1819                | 201901               | PROFILE         | CM             | False       | 4576.00         |
    | 10017869 | ORG0017869 | [AllocRef_NCSV]| 2305330         | NCS-DEV1819                | 201902               | PROFILE         | CM             | False       | 4576.00         |
    | 10017869 | ORG0017869 | [AllocRef_NCSV]| 2305330         | NCS-DEV1819                | 201903               | PROFILE         | CM             | False       | 4928.00         |



    # Tidy up
    Given the override date is reset
  
@AcceptanceTest @Withdrawn20210702
Scenario: A870 Create and approve new 1819 NCS contract with NCS-C and NCS-DEV allocations. Create PoP payment files. Check CRM, Financials, PaaS and Payment Feed
    Given there are no allocations marked as Under Termination for UKPRN '10017870' 
    And   there are no terminated or closed allocations for UKPRN '10017870' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017870' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | NCSC-870      |
    | NCSV-870      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017870' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017870 Co Ltd' with UKPRN '10017870' and OrgId 'ORG0017870' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017870 | 117870 | 10017870 Co Ltd | 0              | Locked Restructure    | Yes           | AA017870      | ?             | 5 Queens Street        | Norwich                | Norfolk                | ?                      | ?                      | ?                      | NR2 4SG   |

    # Put the same Provider data in the CRM Organisation table J057
    And   the following Organisations exist in CRM
    | OrgId      | UKPRN    | UPIN   | Name            | Status                | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | ORG0017870 | 10017870 | 117870 | 10017870 Co Ltd | Locked Restructure    | AA017870      | 17870         | 5 Queens Street        | Norwich                | Norfolk                | ?                      | ?                      | ?                      | NR2 4SG   |




    # Change the date
    Given the override date is '01/09/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017870 | 10017870 Co Ltd      | ESFA-870             | NCS-870        | 1                     | 01/10/2018        | 31/03/2019      | 52686.00      |                                | Contract for Services | 1819   | New          | ORG0017870 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017870 | NCS-870        | NCSC-870      | NCS-C             | NCS-C1819               | NCS                     | 01/10/2018          | 31/03/2019        | 37126.00        | West Midlands and Staffordshire         | 0000000104 |                                                             | New          |             |
    | 10017870 | NCS-870        | NCSV-870      | NCS-DEV           | NCS-DEV1819             | NCS                     | 01/10/2018          | 31/03/2019        | 15560.00        | West Midlands and Staffordshire         | 0000000104 |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017870 | NCS-870        | NCSC-870      | 1               | 0                     | 37126.00  | 7779.00  | 6441.00  | 4790.00  | 8990.00  | 2809.00  | 6317.00  | Total In The Community Funding                                  | New          |             |
    | 10017870 | NCS-870        | NCSC-870      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             |
    | 10017870 | NCS-870        | NCSC-870      | 2               | 1                     | 10805.00  | 1486.00  | 1684.00  | 1091.00  | 2870.00  | 251.00   | 3423.00  | Customer Satisfaction                                           | New          |             |
    | 10017870 | NCS-870        | NCSC-870      | 3               | 1                     | 26321.00  | 6293.00  | 4757.00  | 3699.00  | 6120.00  | 2558.00  | 2894.00  | Career Management and Jobs and Learning                         | New          |             |
    | 10017870 | NCS-870        | NCSC-870      | 4               | 3                     | 12841.00  | 2874.00  | 1584.00  | 1752.00  | 3215.00  | 1545.00  | 1871.00  | Career Management                                               | New          |             |
    | 10017870 | NCS-870        | NCSC-870      | 5               | 3                     | 13480.00  | 3419.00  | 3173.00  | 1947.00  | 2905.00  | 1013.00  | 1023.00  | Jobs and Learning                                               | New          |             |
    #
    | 10017870 | NCS-870        | NCSV-870      | 1               | 0                     | 15560.00  | 0.00     | 0.00     | 0.00     | 5057.00  | 5057.00  | 5446.00  | 50 Plus Futures                                                 | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | DeliverableCode | AllocationRef | UnitCost | Total   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | 
    | 10017870 | NCS-870        | 6               | NCSC-870      | 0        | 260     | 97       | 18       | 31       | 84       | 16       | 14       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/09/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NCS-870' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/09/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-870' and actual ContractNumber 'NCS-870'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-870' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017870 | NCS-870            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/10/2018        | 31/03/2019      | ?             |
    | 10017870 | ESFA-870           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '42' deliverable period rows in CRM linked to the latest version of contract 'NCS-870'


    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-870        | NCSC-870        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-870        | NCSC-870        | 2               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-870        | NCSC-870        | 3               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-870        | NCSC-870        | 4               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-870        | NCSC-870        | 5               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-870        | NCSC-870        | 6               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | NCS-870        | NCSV-870        | 1               | 15560.00 | 0.00     | 0.00     | 0.00     | 5057.00  | 5057.00  | 5446.00  | 

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-870        | NCSC-870        | 1               | 37126.00 | 7779.00  | 6441.00  | 4790.00  | 8990.00  | 2809.00  | 6317.00  | 
    | NCS-870        | NCSC-870        | 2               | 10805.00 | 1486.00  | 1684.00  | 1091.00  | 2870.00  | 251.00   | 3423.00  | 
    | NCS-870        | NCSC-870        | 3               | 26321.00 | 6293.00  | 4757.00  | 3699.00  | 6120.00  | 2558.00  | 2894.00  | 
    | NCS-870        | NCSC-870        | 4               | 12841.00 | 2874.00  | 1584.00  | 1752.00  | 3215.00  | 1545.00  | 1871.00  | 
    | NCS-870        | NCSC-870        | 5               | 13480.00 | 3419.00  | 3173.00  | 1947.00  | 2905.00  | 1013.00  | 1023.00  | 
    | NCS-870        | NCSC-870        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | NCS-870        | NCSV-870        | 1               | 15560.00 | 0.00     | 0.00     | 0.00     | 5057.00  | 5057.00  | 5446.00  | 

    # Check the PLANNED VOLUMES in CRM
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NCS-870        | NCSC-870        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-870        | NCSC-870        | 2               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-870        | NCSC-870        | 3               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-870        | NCSC-870        | 4               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-870        | NCSC-870        | 5               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-870        | NCSC-870        | 6               | 260      | 97       | 18       | 31       | 84       | 16       | 14       | 
    #
    | NCS-870        | NCSV-870        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 

    # Check the PROFILE subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017870 | ORG0017870 | NCSV-870          | 2305330         | NCS-DEV1819                | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10017870 | ORG0017870 | NCSV-870          | 2305330         | NCS-DEV1819                | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10017870 | ORG0017870 | NCSV-870          | 2305330         | NCS-DEV1819                | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10017870 | ORG0017870 | NCSV-870          | 2305330         | NCS-DEV1819                | 201901               | PROFILE         | CM             | False       | 5057.00         |
    | 10017870 | ORG0017870 | NCSV-870          | 2305330         | NCS-DEV1819                | 201902               | PROFILE         | CM             | False       | 5057.00         |
    | 10017870 | ORG0017870 | NCSV-870          | 2305330         | NCS-DEV1819                | 201903               | PROFILE         | CM             | False       | 5446.00         | 




    # Change the date
    Given the override date is '12/02/2019 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017870' for FundingType 'NCS' and period '1819'
	
    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    # Note: PaymentPeriod is the accounting year and month, eg for April 2018 the value would be 201801 not 201804
    And   there is no data in the Payment feed for FundingStreamPeriod 'NCS-DEV1819' AccountingPaymentPeriod '201810' CensusEndDate '12/02/2019' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaaS. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | NCSV-870                 | 201901 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | NCS-DEV1819                | 201901               |                      | A              | NotStarted |

#    # Coda.AccountCode
#    And   the following configuration exists in the Account Codes table
#    | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#    | 10017870 | NCS-DEV1819                | CODA870   | 8113000      | 01/08/1990           | 31/08/2020         |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | NCS-DEV1819                | 201901               | Completed |

#    # File created in Maytech FTP folder for 'NCS Development 18-19'
#    And   Payment file 'NCSV20181012A.pay' is created in the FTP Folder
#
#
#
#    # Decrypt the payment file to the Output window and save a decrypted version to Datafiles/Downloads
#    Given there is an encrypted file called 'NCSV20181012A.pay' in the Maytech FTP folder decrypt it then save it to 'DataFiles/Downloads'
#
#    # Check the contents of the payment file
#    Then  the following details are present in payment file 'NCSV20181012A.pay'
#    | LinkCode    | CompanyCode | Element1 | Element2 | Element3 | Element4 | Element5 | Element6   | Element7 | Element8 | Year | Period | Date       | Amount     | Dc   | LineType | Doc     | Desc                            | DueDate    | Tax | Extref1                       | Extref2     | Extref3      | Extref4                     | Extref5  | Extref6 | Num   | DocLineNo |
#    | NCSV181012A | SFA         | AAA20    | +        | 8113000  | CODA870  | 02       | NCSV-870   | ?        | ?        | 2018 | 10     | 12/02/2019 | 5057.00    | 160  | 157      | NCSVP   | NCS Development Prf Feb19       | 26/02/2019 | ?   | NCSV PROFILE 2018/19          | NCSV181012A | ?            | ?                           | 10017870 | 2305330 | 1     | 1         |
#    | NCSV181012A | SFA         | AAA20    | +        | 2305330  | 5000     | 02       | NCSV-870   | ?        | ?        | 2018 | 10     | 12/02/2019 | 5057.00    | 161  | 158      | NCSVP   | NCS Development Prf Feb19       | 26/02/2019 | VIO | NCSV PROFILE 2018/19          | NCSV181012A | ?            | ?                           | 10017870 | CODA870 | 1     | 2         |



    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'NCS-DEV1819' PaymentPeriod '201810' CensusEndDate '12/02/2019' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A870.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'NCS-DEV1819' PaymentPeriod '201810' CensusEndDate '12/02/2019' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | NCSV                   | 2018          | 10             | 12          | ?       | NCSV-870      | 5057.00         | PROFILE          | NCS Development                    | 2019-02-26 | 2018-10-01   | 2019-03-31 | ?              | 10017870 | 2305330    |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    And   there is an item on the Payment feed for FundingStreamPeriod 'NCS-DEV1819' AccountingPaymentPeriod '201810' and CensusEndDate '12/02/2019'

    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                 |
    | Payment Requests for Funding Stream Period NCS-DEV1819 for Payment Period 201810 have been generated as of Census End Date/Time 2019-02-12T22:00:00Z. |

#   And   the Payment feed item SUMMARY is as follows
#   | FundingStreamPeriod | PaymentPeriod | CensusEndDate        | PaymentLineCount | TotalValue |
#   | NCS-DEV1819         | 201810        | 2019-02-12T22:00:00Z | 1                | 5057.00    |

    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | NCSV      | 01/10/2018   | 31/03/2019 | 12/02/2019    | 26/02/2019 | 2018          | 10             |

    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017870  | 10017870       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | NCSV-870   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2305330    | PROFILE        | NCS Development               | 5057.00         |



    # Tidy up
    Given the override date is reset
	  
	    