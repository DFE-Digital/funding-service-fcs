Feature: FE Reclassification Capital Allocations 23-24

@AcceptanceTest @Withdrawn20251024
Scenario: S015 Create and Update draft v1 FY2324 FE-RCA Contract. Publish and Approve. Bulk amend variation v2 and verify docs. Run payment batch and generate reports.
    Given there are no allocations marked as Under Termination for UKPRN '10018015' 
    And   there are no terminated or closed allocations for UKPRN '10018015' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018015' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018015' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | FERA-8015     |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | FERA-8015     |


    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | FE-RCA2324        |

	

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | FERCA-8015     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018015'



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10018015' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018015 Co Ltd' with UKPRN '10018015' and OrgId 'ORG0018015' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10018015' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018015 | 118015 | 10018015 Co Ltd | 0              | In Administration     | Yes           | AA018015      | ?             | 96 West Yard           | Camden Lock Place      | Chalk Farm Road        | London                 | ?                      | ?                      | NW1 8AF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018015 |



    # Change the date
    Given the override date is '22/02/2023'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                              | Period | CRMIntent    | OrgId      |
    | 10018015 | 10018015 Co Ltd      | ESFA-18015           | FERCA-8015     | 1                     | 01/04/2023        | 31/03/2024      | 19607.00     |                                       | Contract for Services				        | 2324   | New          | ORG0018015 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName    | UoPCode  | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018015 | FERCA-8015	    | FERA-8015   	| FE-RCA     	    | FE-RCA2324        	  | FY                      | 01/04/2023          | 31/03/2024        | 19607.00        |            |        	|                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | DeliverableDescription            | CRMIntent    | DeliveryOrg |
    | 10018015 | FERCA-8015     | FERA-8015     | 1             | 0                     | 19607.00  | 10877.00  | 8730.00   | 138.00   | 1126.00  | 1862.00  | 637.00   | 612.00   | 3404.00  | 2431.00  | 667.00   | 2258.00  | 3152.00  | 469.00   | 2851.00  | Capital Funding for the FE Sector Following Reclassification | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | FERCA-8015     | 1                     | 0                        | 2023-02-22 15:43:08.000 |


    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018015 | FERCA-8015         | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2023        | 31/03/2024      | ?             |
    | 10018015 | ESFA-18015         | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2023        | 31/03/2024      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'FERCA-8015'

 


    # Bulk Update Draft the FE-RCA 23/24 contract and check docs

    Given the override date is '27/02/2023'

    # Bulk file 'Update Draft' amendment
    And   there are no files prefixed '10018015' in the Sharepoint 'FE-RCA-2324-Input-Appendices' folder
    And   there are no files prefixed 'FE-RCA FY 2324 30102022164257 v1_S015a' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'FE-RCA FY 2324 30102022164257 v1_S015a' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'FE-RCA FY 2324 30102022164257 v1_S015a' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'FE-RCA FY 2324 30102022164257 v1_S015a' in the Sharepoint 'Reports' folder
    And   spreadsheet 'FE-RCA FY 2324 30102022164257 v1_S015a.xlsx' exists in the Datafiles folder and UKPRN '10018015' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018015' for FundingType 'FE-RCA' and period '2324'

    # Check the contents of the Appendices (All doc parts should be present)
    Then  the file named '10018015_FERCA-8015_v1.pdf' in Sharepoint location 'FE-RCA-2324-Input-Appendices' contains the following lines in order
    """ 
    Annex H – Grant payment schedule
    Provider: 10018015 Co Ltd UKPRN: 10018015
    Master Contract Number: ESFA-18015 Start Date: 01/04/2023 End Date: 31/03/2024
    Contract Ref: FERA-8015
    Cash (£) Apr 2023 May 2023 Jun 2023 Jul 2023 Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024
    Further Education Reclassification Capital Allocation £53,863 £4,208 £7,553 £3,359 £4,261 £3,666 £5,450 £5,939 £249 £3,529 £3,751 £5,195 £6,703
    Total Funding £53,863 £4,208 £7,553 £3,359 £4,261 £3,666 £5,450 £5,939 £249 £3,529 £3,751 £5,195 £6,703
    Further Education Reclassification Capital Allocation – FERA-8015 – Page 1 Ref (for internal use only):  FERCA-8015 v1
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | FERCA-8015      | 1                     | 0                        | 2023-02-27 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018015_FERCA-8015_v1.pdf' in 'FE-RCA-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S015_v1.pdf'

    

    # Publish and approve v1

    Given the override date is '01/03/2023'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'FERCA-8015'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-18015' and ContractNumber 'FERCA-8015' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'FERCA-8015' has a substatus of 'Approved'
      


      
    # Bulk amend the FE-RCA alloc 23/24 contract and check v2 docs

    Given the override date is '01/04/2023'

    # Bulk file 'Revised New' amendment
    And   there are no files prefixed '10018015' in the Sharepoint 'FE-RCA-2324-Input-Appendices' folder
    And   there are no files prefixed 'FE-RCA FY 2324 10112022164257 v1_S015b' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'FE-RCA FY 2324 10112022164257 v1_S015b' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'FE-RCA FY 2324 10112022164257 v1_S015b' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'FE-RCA FY 2324 10112022164257 v1_S015b' in the Sharepoint 'Reports' folder
    And   spreadsheet 'FE-RCA FY 2324 10112022164257 v1_S015b.xlsx' exists in the Datafiles folder and UKPRN '10018015' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018015' for FundingType 'FE-RCA' and period '2324'

    # Check the contents of the Appendices (All doc parts should be present)
    Then  the file named '10018015_FERCA-8015_v2.pdf' in Sharepoint location 'FE-RCA-2324-Input-Appendices' contains the following lines in order
    """ 
    Annex H – Grant payment schedule
    Provider: 10018015 Co Ltd UKPRN: 10018015
    Master Contract Number: ESFA-18015 Start Date: 01/04/2023 End Date: 31/03/2024
    Contract Ref: FERA-8015
    Cash (£) Apr 2023 May 2023 Jun 2023 Jul 2023 Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024
    Further Education Reclassification Capital Allocation £327,623 £22,297 £43,515 £33,805 £24,095 £38,480 £49,269 £31,288 £30,928 £17,622 £3,596 £31,647 £1,079
    Total Funding £327,623 £22,297 £43,515 £33,805 £24,095 £38,480 £49,269 £31,288 £30,928 £17,622 £3,596 £31,647 £1,079
    Further Education Reclassification Capital Allocation – FERA-8015 – Page 1 Ref (for internal use only):  FERCA-8015 v2
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | FERCA-8015     | 2                     | 0                        | 2023-04-01 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018015_FERCA-8015_v2.pdf' in 'FE-RCA-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S015_v2.pdf'

    
#    # CDA
#    
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version S015.csv'
##
##    Then  the contracts are in the replicated CRM database as follows
##    | ContractNumber | ContractVersionNumber |
##    | [ContractNo]   | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version               | Suffix |
#    | FE-RCA2324            | Latest Version        | S015   |
#
#    Then  a report named 'CDA Latest Version S015.csv' is created
#	# Check the above report manually


    # Payment Batch for FE-RCA2324

    # Change the date
#    Given the override date is '04/04/2023 22:05'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod 'FE-RCA2324' AccountingPaymentPeriod '202301' CensusEndDate '04/04/2023' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | [AllocRef_FERA]          | 202304 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | FE-RCA2324             | 202304               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | FE-RCA2324             | 202304               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'FE-RCA2324' PaymentPeriod '202301' CensusEndDate '04/04/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S015.xml'


#
#
#    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'FE-RCA2324' PaymentPeriod '202301' CensusEndDate '08/09/2022' and LinkCodeSuffix 'A' includes the following values
#    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_FERA]  | 929.43          | RECONCILIATION   | 19-24Trn19+Hardship                | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 100932     |
#    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_FERA]  | 947.96          | RECONCILIATION   | 19-24Trn20+Childcare               | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 100933     |
#    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_FERA]  | 1203.59         | RECONCILIATION   | 19-24TrnRsdntlAccess               | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 100934     |
#    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_FERA]  | 674.97          | RECONCILIATION   | 19-24TrnAdminExp                   | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 100935     |
#    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_FERA]  | 530.40          | RECONCILIATION   | 19-24TrnC19Response                | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 100936     |
#    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_FERA]  | 574.70          | RECONCILIATION   | 19-24 Traineeships                 | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 2355800    |
#    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_FERA]  | 458.03          | RECONCILIATION   | 19-24TraineeshpsLngS               | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 2355860    |
#



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
   # Then  there is an item on the Payment feed for FundingStreamPeriod 'FE-RCA2324' AccountingPaymentPeriod '202301' and CensusEndDate '04/04/2023'

#
#    # Title details
#    And   the Payment feed item TITLE is as follows
#    | Title                                                                                                                                                          |
#    | Payment Requests for Funding Stream Period FE-RCA2324 for Payment Period 202301 have been generated as of Census End Date/Time 2022-09-08T22:00:00Z.       |
#
#
#    # Summary details
#    And   the Payment feed item SUMMARY is as follows
#    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
#    | FE-RCA2324      | 202301        | 2022-09-08T22:00:00Z  | 7                | 5319.08    |
#
#    # PaymentPeriod details
#    And   the Payment feed item PaymentPeriod details are as follows
#    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
#    | ESFA   | 19TR      | 01/08/2022   | 31/07/2023 | 08/09/2022    | 20/09/2022 | 2022          | 05             |
#
#    # PaymentDetails
#    And   the Payment feed item PaymentDetails are as follows
#    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef         | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
#    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_FERA]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100932     | RECONCILIATION | 19-24Trn19+Hardship           | 929.43          |
#    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_FERA]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100933     | RECONCILIATION | 19-24Trn20+Childcare          | 947.96          |
#    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_FERA]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100934     | RECONCILIATION | 19-24TrnRsdntlAccess          | 1203.59         |
#    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_FERA]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100935     | RECONCILIATION | 19-24TrnAdminExp              | 674.97          |
#    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_FERA]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100936     | RECONCILIATION | 19-24TrnC19Response           | 530.40          |
#    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_FERA]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355800    | RECONCILIATION | 19-24 Traineeships            | 574.70          |
#    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_FERA]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355860    | RECONCILIATION | 19-24TraineeshpsLngS          | 458.03          |
#
#
#    # Check ADP
#
#    # Check all activity has completed
#    When  there are no messages left in the system
#
#    # Check financials on the ADP feed for Aug-22
#    Then  the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
#    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FERA]  | 1               | 202301 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FERA]  | 2               | 202301 | 574.70      | 0.00           | 0.00             | 574.70                | 0.00           | 574.70     |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FERA]  | 3               | 202301 | 458.03      | 0.00           | 0.00             | 458.03                | 0.00           | 458.03     |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FERA]  | 4               | 202301 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FERA]  | 5               | 202301 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FERA]  | 6               | 202301 | 929.43      | 0.00           | 0.00             | 929.43                | 0.00           | 929.43     |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FERA]  | 7               | 202301 | 947.96      | 0.00           | 0.00             | 947.96                | 0.00           | 947.96     |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FERA]  | 8               | 202301 | 1203.59     | 0.00           | 0.00             | 1203.59               | 0.00           | 1203.59    |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FERA]  | 9               | 202301 | 674.97      | 0.00           | 0.00             | 674.97                | 0.00           | 674.97     |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FERA]  | 10              | 202301 | 530.40      | 0.00           | 0.00             | 530.40                | 0.00           | 530.40     |
#
#





#   #  Part 10: Create Consolidated Payment Summary rpt
#   
#   #  Set the override date, run the ESFA Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
#   Given there are no files prefixed '2023-04 Grant funding.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
#
#   When a Grant Funding Consolidated Payment Summary Report is created in Sharepoint for '05/04/2023'
#    # Check the above report manually

    
   


