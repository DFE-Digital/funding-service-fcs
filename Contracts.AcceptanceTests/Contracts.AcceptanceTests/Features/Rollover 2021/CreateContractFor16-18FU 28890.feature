Feature: CreateContractFor16-18FU 28890

@AcceptanceTest @Withdrawn20220222
Scenario: A063 Bulk load a new 2021 16-18FU contract. Check docs then publish and approve. Non-financial amendment then check docs. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017063' 
    And   there are no terminated or closed allocations for UKPRN '10017063' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017063' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017063' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18FU2021       |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017063' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017063 Co Ltd' with UKPRN '10017063' and OrgId 'ORG0017063' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017063' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017063 | 117063 | 10017063 Co Ltd | 0              | Active                | Yes           | AA017063      | ?             | 412 Midsummer Rd       | ?                      | ?                      | ?                      | ?                      | ?                      | MK9 2EA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017063 |




    # Change the date
    Given the override date is '23/03/2020'

    # Bulk file
    And   there are no files prefixed '10017063' in the Sharepoint '16-18FU-2021-Input-Appendices' folder
    And   there are no files prefixed '16-18FU FY 2021 21022020133148 v3_A063' in the Sharepoint 'Input' folder
    And   there are no files prefixed '16-18FU FY 2021 21022020133148 v3_A063' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '16-18FU FY 2021 21022020133148 v3_A063' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '16-18FU FY 2021 21022020133148 v3_A063' in the Sharepoint 'Reports' folder
    And   spreadsheet '16-18FU FY 2021 21022020133148 v3_A063.xlsx' exists in the Datafiles folder and UKPRN '10017063' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017063' for FundingType '16-18FU' and period '2021' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017063' for FundingType '16-18FU' and period '2021'

    # Check the contents of the Appendices
    And   the file named '10017063_' & '[ContractNo]' & '_v1.pdf' created in Sharepoint location '16-18FU-2021-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017063 Co Ltd UKPRN: 10017063
    Master Contract Number: [MasterContractNo] Start Date: 01/04/2020 End Date: 31/03/2021
    Contract Ref: [AllocRef_16FU]
    Cash (£) Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    16-18 Education at an Adolescent Forensic Unit £33,835 £0 £0 £9,018 £0 £0 £8,273 £0 £0 £10,345 £0 £0 £6,199
    Total Funding £33,835 £0 £0 £9,018 £0 £0 £8,273 £0 £0 £10,345 £0 £0 £6,199
    16-18 Education at an Adolescent Forensic Unit – [AllocRef_16FU] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017063_[ContractNo]_v1.pdf' in '16-18FU-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A063_1.pdf'




    # Publish and approve
	
	# Change the date
    Given the override date is '28/03/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for actual MasterContractNumber 'ESFA-063' and actual ContractNumber '1618FU-063' and Version '1' 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017063 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017063 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract '1618FU-063'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_16FU] | 2430670          | Mar-21 | Profile        |




	# Check CRM financials

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | [ContractNo]   | [AllocRef_16FU]    | 1               | 33835.00  | 0.00     | 0.00     | 9018.00  | 0.00     | 0.00     | 8273.00  | 0.00     | 0.00     | 10345.00 | 0.00     | 0.00     | 6199.00  | 




	
	# Create non-financial amendment and check doc

	# Change the date
    Given the override date is '30/03/2020'

    # Attempt a non-financial VARIATION amendment request on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017063 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2020        | 31/03/2021      | Variation     |
    | 10017063 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017063 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the contents of the Appendices (Only the version number should have changed)
    And   the file named '10017063_' & '[ContractNo]' & '_v2.pdf' created in Sharepoint location '16-18FU-2021-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017063 Co Ltd UKPRN: 10017063
    Master Contract Number: [MasterContractNo] Start Date: 01/04/2020 End Date: 31/03/2021
    Contract Ref: [AllocRef_16FU]
    Cash (£) Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    16-18 Education at an Adolescent Forensic Unit £33,835 £0 £0 £9,018 £0 £0 £8,273 £0 £0 £10,345 £0 £0 £6,199
    Total Funding £33,835 £0 £0 £9,018 £0 £0 £8,273 £0 £0 £10,345 £0 £0 £6,199
    16-18 Education at an Adolescent Forensic Unit – [AllocRef_16FU] – Page 1 Ref (for internal use only):  [ContractNo] v2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017063_[ContractNo]_v2.pdf' in '16-18FU-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A063_2.pdf'


    # Tidy up
    And   the override date is reset
  
@AcceptanceTest @Withdrawn20220222
Scenario: A064 Create and approve a new 2021 16-18FU contract. Bulk amend and approve. Create PoP payment. Check CRM, CDA, Financials and feeds
    Given there are no allocations marked as Under Termination for UKPRN '10017064' 
    And   there are no terminated or closed allocations for UKPRN '10017064' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017064' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017064' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16FU-064      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16FU-064      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18FU2021       |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017064' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017064 Co Ltd' with UKPRN '10017064' and OrgId 'ORG0017064' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017064' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017064 | 117064 | 10017064 Co Ltd | 0              | Provider Under Change | Yes           | AA017064      | ?             | 231a Union Street      | Aberdeen               | ?                      | ?                      | ?                      | ?                      | AB11 6BQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017064 |




    # Change the date
    Given the override date is '01/03/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017064 | 10017064 Co Ltd      | ESFA-064             | 1618FU-064     | 1                     | 01/04/2020        | 31/03/2021      | 6562.00       |                                       | Contract for Services                      | 2021   | New          | ORG0017064 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017064 | 1618FU-064     | 16FU-064      | 16-18FU           | 16-18FU2021             | FY                      | 01/04/2020          | 31/03/2021        | 6562.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017064 | 1618FU-064     | 16FU-064      | 1               | 0                     | 6562.00   | 0.00     | 0.00     | 1455.00  | 0.00     | 0.00     | 798.00   | 0.00     | 0.00     | 1786.00  | 0.00     | 0.00     | 2523.00  | 16-18 Education at an Adolescent Forensic Unit                  | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract '1618FU-064' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '1618FU-064'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-064' and actual ContractNumber '1618FU-064'

    # Check that the contract is now approved
    Then  the latest version of contract '1618FU-064' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017064 | 1618FU-064         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2020        | 31/03/2021      | ?             |
    | 10017064 | ESFA-064           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract '1618FU-064'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | 16FU-064      | 2430670          | Mar-21 | Profile        |




	# Amend the contract

    # Change the date
    Given the override date is '28/03/2020'

    # Bulk file
    And   there are no files prefixed '10017064' in the Sharepoint '16-18FU-2021-Input-Appendices' folder
    And   there are no files prefixed '16-18FU FY 2021 21022020133222 v3_A064' in the Sharepoint 'Input' folder
    And   there are no files prefixed '16-18FU FY 2021 21022020133222 v3_A064' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '16-18FU FY 2021 21022020133222 v3_A064' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '16-18FU FY 2021 21022020133222 v3_A064' in the Sharepoint 'Reports' folder
    And   spreadsheet '16-18FU FY 2021 21022020133222 v3_A064.xlsx' exists in the Datafiles folder and UKPRN '10017064' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

   #And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'




	# Change the date
    Given the override date is '29/03/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '1618FU-064'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-064' and actual ContractNumber '1618FU-064'

    # Check that the contract is now approved
    Then  the latest version of contract '1618FU-064' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017064 | 1618FU-064         | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2020        | 31/03/2021      | Variation     |
    | 10017064 | 1618FU-064         | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/04/2020        | 31/03/2021      | ?             |
    | 10017064 | ESFA-064           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2020        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract '1618FU-064'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | 16FU-064      | 2430670          | Mar-21 | Profile        |




	# Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | 1618FU-064     | 16FU-064           | 1               | 32153.00  | 0.00     | 0.00     | 8276.00  | 0.00     | 0.00     | 7310.00  | 0.00     | 0.00     | 7474.00  | 0.00     | 0.00     | 9093.00  | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef    | ProfileSubnominal  | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | 10017064 | 1618FU-064     | 16FU-064         | 2430670            | 0.00     | 0.00     | 8276.00  | 0.00     | 0.00     | 7310.00  | 0.00     | 0.00     | 7474.00  | 0.00     | 0.00     | 9093.00  | 




	# Payment Batch for Jun-20 for 16-18FU2021 (PoP payment)

    # Change the date
    Given the override date is '04/06/2020 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '16-18FU2021' AccountingPaymentPeriod '202003' CensusEndDate '04/06/2020' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | 16FU-064                 | 202006 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 16-18FU2021                | 202006               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 16-18FU2021                | 202006               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18FU2021' PaymentPeriod '202003' CensusEndDate '04/06/2020' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A064.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18FU2021' PaymentPeriod '202003' CensusEndDate '04/06/2020' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | 16FU                   | 2020          | 03             | 04          | ?       | 16FU-064      | 8276.00         | PROFILE          | Forensic Unit          | 2020-06-24 | 2020-04-01   | 2021-03-31 | ?              | 10017064 | 2430670    |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    And   there is an item on the Payment feed for FundingStreamPeriod '16-18FU2021' AccountingPaymentPeriod '202003' and CensusEndDate '04/06/2020'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                 |
    | Payment Requests for Funding Stream Period 16-18FU2021 for Payment Period 202003 have been generated as of Census End Date/Time 2020-06-04T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | 16-18FU2021         | 202003        | 2020-06-04T22:00:00Z  | 1                | 8276.00    |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | 16FU      | 01/04/2020   | 31/03/2021 | 04/06/2020    | 24/06/2020 | 2020          | 03             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName     | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription  | AggregatedValue |
    | ORG0017064  | 10017064       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | 16FU-064   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?           | ?                | ?               | ?                   | 2430670    | PROFILE        | Forensic Unit          | 8276.00         |




	# Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | 1618FU-064     | 16FU-064           | 1               | 32153.00  | 0.00     | 0.00     | 8276.00  | 0.00     | 0.00     | 7310.00  | 0.00     | 0.00     | 7474.00  | 0.00     | 0.00     | 9093.00  | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef    | ProfileSubnominal  | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | 10017064 | 1618FU-064     | 16FU-064         | 2430670            | 0.00     | 0.00     | 8276.00  | 0.00     | 0.00     | 7310.00  | 0.00     | 0.00     | 7474.00  | 0.00     | 0.00     | 9093.00  | 




      
#    # CDA
#    
#    # Check the contents of the CDA report
#    Given there is no CDA report named 'CDA Last Approved Version A064.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | 1618FU-064     | 2                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod  | Version            | Suffix |
#    | 16-18FU2021          | Latest Version     | A064   |
#
#    Then  a report named 'CDA Latest Version A064.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | 16-18FU2021             | 10017064 | 10017064 Co Ltd             |               |                             | 16FU-064                 | 1618FU-064     | ESFA-064                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 4                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2430670           |                          |                   | Apr              |
#    | 16-18FU2021             | 10017064 | 10017064 Co Ltd             |               |                             | 16FU-064                 | 1618FU-064     | ESFA-064                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 5                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2430670           |                          |                   | May              |
#    | 16-18FU2021             | 10017064 | 10017064 Co Ltd             |               |                             | 16FU-064                 | 1618FU-064     | ESFA-064                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 6                 | 2020            | 2020/21       |              | 8276         |              |               |              | Yes                | 8276.00        | 0.00             | 0.00                  | 0.00           | 8276.00         |             | Yes           |                   |        | 2430670           |                          |                   | Jun              |
#    | 16-18FU2021             | 10017064 | 10017064 Co Ltd             |               |                             | 16FU-064                 | 1618FU-064     | ESFA-064                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 7                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2430670           |                          |                   | Jul              |
#    | 16-18FU2021             | 10017064 | 10017064 Co Ltd             |               |                             | 16FU-064                 | 1618FU-064     | ESFA-064                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 8                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2430670           |                          |                   | Aug              |
#    | 16-18FU2021             | 10017064 | 10017064 Co Ltd             |               |                             | 16FU-064                 | 1618FU-064     | ESFA-064                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 9                 | 2020            | 2020/21       |              | 7310         |              |               |              | Yes                | 7310.00        | 0.00             | 0.00                  | 0.00           | 7310.00         |             | No            |                   |        | 2430670           |                          |                   | Sep              |
#    | 16-18FU2021             | 10017064 | 10017064 Co Ltd             |               |                             | 16FU-064                 | 1618FU-064     | ESFA-064                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 10                | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2430670           |                          |                   | Oct              |
#    | 16-18FU2021             | 10017064 | 10017064 Co Ltd             |               |                             | 16FU-064                 | 1618FU-064     | ESFA-064                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 11                | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2430670           |                          |                   | Nov              |
#    | 16-18FU2021             | 10017064 | 10017064 Co Ltd             |               |                             | 16FU-064                 | 1618FU-064     | ESFA-064                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 12                | 2020            | 2020/21       |              | 7474         |              |               |              | Yes                | 7474.00        | 0.00             | 0.00                  | 0.00           | 7474.00         |             | No            |                   |        | 2430670           |                          |                   | Dec              |
#    | 16-18FU2021             | 10017064 | 10017064 Co Ltd             |               |                             | 16FU-064                 | 1618FU-064     | ESFA-064                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 1                 | 2021            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2430670           |                          |                   | Jan              |
#    | 16-18FU2021             | 10017064 | 10017064 Co Ltd             |               |                             | 16FU-064                 | 1618FU-064     | ESFA-064                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 2                 | 2021            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2430670           |                          |                   | Feb              |
#    | 16-18FU2021             | 10017064 | 10017064 Co Ltd             |               |                             | 16FU-064                 | 1618FU-064     | ESFA-064                | 01/04/2020                  | 31/03/2021                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 3                 | 2021            | 2020/21       |              | 9093         |              |               |              | Yes                | 9093.00        | 0.00             | 0.00                  | 0.00           | 9093.00         |             | No            |                   |        | 2430670           |                          |                   | Mar              |

	   	 
	# Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20220222
Scenario: A598 Create and approve an AEBC-ASCL1920(PoP) contract. Consume actuals and check CRM and PaaS
    Given there are no allocations marked as Under Termination for UKPRN '10017598' 
    And   there are no terminated or closed allocations for UKPRN '10017598' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017598' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017598' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-598      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-598      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-ASCL1920     |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017598' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017598 Co Ltd' with UKPRN '10017598' and OrgId 'ORG0017598' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017598' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017598 | 117598 | 10017598 Co Ltd | 0              | Active                | Yes           | AA017598      | ?             | 36 Kings Street        | Covent Garden          | London                 | ?                      | ?                      | ?                      | WC2 8JS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017598 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017598 | 10017598 Co Ltd      | ESFA-598             | EDSK-598       | 1                     | 01/08/2019        | 31/07/2020      | 40602.00      |                                       | Conditions of Funding (Grant) (SPI)        | 1920   | New          | ORG0017598 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017598 | EDSK-598       | AECA-598      | AEBC-ASCL         | AEBC-ASCL1920           | AY                      | 01/08/2019          | 31/07/2020        | 40602.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017598 | EDSK-598       | AECA-598      | 1               | 0                     | 40602.00  | 26381.00  | 14221.00  | 2945.00  | 2930.00  | 3958.00  | 4576.00  | 3705.00  | 2614.00  | 1206.00  | 4447.00  | 2125.00  | 4640.00  | 3513.00  | 3943.00  | Adult Education Budget Total Funding                            | New          |             | 
    | 10017598 | EDSK-598       | AECA-598      | 2               | 1                     | 19654.00  | 15843.00  | 3811.00   | 1684.00  | 2672.00  | 3408.00  | 2183.00  | 2158.00  | 1249.00  | 276.00   | 2213.00  | 103.00   | 997.00   | 2015.00  | 696.00   | Adult Skills Total Funding                                      | New          |             | 
    | 10017598 | EDSK-598       | AECA-598      | 5               | 1                     | 20948.00  | 10538.00  | 10410.00  | 1261.00  | 258.00   | 550.00   | 2393.00  | 1547.00  | 1365.00  | 930.00   | 2234.00  | 2022.00  | 3643.00  | 1498.00  | 3247.00  | Community Learning                                              | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-598' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-598'

    # Change the date
    Given the override date is '11/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-598' and actual ContractNumber 'EDSK-598'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-598' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017598 | EDSK-598           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017598 | ESFA-598           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '60' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '60' deliverable period rows in CRM linked to the latest version of contract 'EDSK-598'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | AECA-598      | 2371175          | Jul-20 | Reconciliation |



    # Add actuals to the contract

    # Change the date
    Given the override date is '04/09/2019'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1920        | R02                  | ORG0017598     | CM             | 201908 | AEBC-ASCL1920           | AECA-598                 | ?          | 3               | 0            | 552.67      |
    | ILR1920        | R02                  | ORG0017598     | CM             | 201908 | AEBC-ASCL1920           | AECA-598                 | ?          | 4               | 0            | 976.55      |
    #
    | ILR1920        | R02                  | ORG0017598     | CM             | 201909 | AEBC-ASCL1920           | AECA-598                 | ?          | 3               | 0            | 1745.83     |
    | ILR1920        | R02                  | ORG0017598     | CM             | 201909 | AEBC-ASCL1920           | AECA-598                 | ?          | 4               | 0            | 2109.02     |
    | ILR1920        | R02                  | ORG0017598     | CM             | 201910 | AEBC-ASCL1920           | AECA-598                 | ?          | 3               | 0            | 2325.16     |
    | ILR1920        | R02                  | ORG0017598     | CM             | 201910 | AEBC-ASCL1920           | AECA-598                 | ?          | 4               | 0            | 1303.39     |
    | ILR1920        | R02                  | ORG0017598     | CM             | 201911 | AEBC-ASCL1920           | AECA-598                 | ?          | 3               | 0            | 1157.54     |
    | ILR1920        | R02                  | ORG0017598     | CM             | 201911 | AEBC-ASCL1920           | AECA-598                 | ?          | 4               | 0            | 1122.25     |
    | ILR1920        | R02                  | ORG0017598     | CM             | 201912 | AEBC-ASCL1920           | AECA-598                 | ?          | 3               | 0            | 1465.36     |
    | ILR1920        | R02                  | ORG0017598     | CM             | 201912 | AEBC-ASCL1920           | AECA-598                 | ?          | 4               | 0            | 1168.03     |
    | ILR1920        | R02                  | ORG0017598     | CM             | 202001 | AEBC-ASCL1920           | AECA-598                 | ?          | 3               | 0            | 1832.77     |
    | ILR1920        | R02                  | ORG0017598     | CM             | 202001 | AEBC-ASCL1920           | AECA-598                 | ?          | 4               | 0            | 914.08      |
    | ILR1920        | R02                  | ORG0017598     | CM             | 202002 | AEBC-ASCL1920           | AECA-598                 | ?          | 3               | 0            | 1362.35     |
    | ILR1920        | R02                  | ORG0017598     | CM             | 202002 | AEBC-ASCL1920           | AECA-598                 | ?          | 4               | 0            | 2084.62     |
    | ILR1920        | R02                  | ORG0017598     | CM             | 202003 | AEBC-ASCL1920           | AECA-598                 | ?          | 3               | 0            | 1985.40     |
    | ILR1920        | R02                  | ORG0017598     | CM             | 202003 | AEBC-ASCL1920           | AECA-598                 | ?          | 4               | 0            | 674.07      |
    | ILR1920        | R02                  | ORG0017598     | CM             | 202004 | AEBC-ASCL1920           | AECA-598                 | ?          | 3               | 0            | 1953.70     |
    | ILR1920        | R02                  | ORG0017598     | CM             | 202004 | AEBC-ASCL1920           | AECA-598                 | ?          | 4               | 0            | 1221.63     |
    | ILR1920        | R02                  | ORG0017598     | CM             | 202005 | AEBC-ASCL1920           | AECA-598                 | ?          | 3               | 0            | 2366.16     |
    | ILR1920        | R02                  | ORG0017598     | CM             | 202005 | AEBC-ASCL1920           | AECA-598                 | ?          | 4               | 0            | 2481.33     |
    | ILR1920        | R02                  | ORG0017598     | CM             | 202006 | AEBC-ASCL1920           | AECA-598                 | ?          | 3               | 0            | 808.33      |
    | ILR1920        | R02                  | ORG0017598     | CM             | 202006 | AEBC-ASCL1920           | AECA-598                 | ?          | 4               | 0            | 753.56      |
    | ILR1920        | R02                  | ORG0017598     | CM             | 202007 | AEBC-ASCL1920           | AECA-598                 | ?          | 3               | 0            | 1307.89     |
    | ILR1920        | R02                  | ORG0017598     | CM             | 202007 | AEBC-ASCL1920           | AECA-598                 | ?          | 4               | 0            | 968.56      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check CRM and PaaS

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-598       | AECA-598           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-598       | AECA-598           | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-598       | AECA-598           | 3               | 552.67    | 552.67   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-598       | AECA-598           | 4               | 976.55    | 976.55   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-598       | AECA-598           | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-598       | AECA-598           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-598       | AECA-598           | 2               | 19654.00  | 1684.00  | 2672.00  | 3408.00  | 2183.00  | 2158.00  | 1249.00  | 276.00   | 2213.00  | 103.00   | 997.00   | 2015.00  | 696.00   | 
    | EDSK-598       | AECA-598           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-598       | AECA-598           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-598       | AECA-598           | 5               | 20948.00  | 1261.00  | 258.00   | 550.00   | 2393.00  | 1547.00  | 1365.00  | 930.00   | 2234.00  | 2022.00  | 3643.00  | 1498.00  | 3247.00  | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-598       | AECA-598           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-598       | AECA-598           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-598       | AECA-598           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-598       | AECA-598           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-598       | AECA-598           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-598       | AECA-598           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-598       | AECA-598           | 2               | 19654.00  | 1684.00  | 2672.00  | 3408.00  | 2183.00  | 2158.00  | 1249.00  | 276.00   | 2213.00  | 103.00   | 997.00   | 2015.00  | 696.00   | 
    | EDSK-598       | AECA-598           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-598       | AECA-598           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-598       | AECA-598           | 5               | 20948.00  | 1261.00  | 258.00   | 550.00   | 2393.00  | 1547.00  | 1365.00  | 930.00   | 2234.00  | 2022.00  | 3643.00  | 1498.00  | 3247.00  | 



    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    | Jan-20    | Feb-20    | Mar-20    | Apr-20    | May-20    | Jun-20    | Jul-20    |
    | 10017598 | EDSK-598       | AECA-598           | 2371110                  | 1684.00   | 2672.00   | 3408.00   | 2183.00   | 2158.00   | 1249.00   | 276.00    | 2213.00   | 103.00    | 997.00    | 2015.00   | 696.00    | 
    | 10017598 | EDSK-598       | AECA-598           | 2371130                  | 1261.00   | 258.00    | 550.00    | 2393.00   | 1547.00   | 1365.00   | 930.00    | 2234.00   | 2022.00   | 3643.00   | 1498.00   | 3247.00   | 

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    | Jan-20    | Feb-20    | Mar-20    | Apr-20    | May-20    | Jun-20    | Jul-20    |
    | 10017598 | EDSK-598       | AECA-598           | 2371175                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 



    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber    | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | AECA-598            | 1             | 1               | 201908 | 2              | 0             | 2945.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECA-598            | 1             | 2               | 201908 | 2              | 0             | 1684.00      | 1684.00              | 0.00                | 0.00                   | 0.00                        | 1684.00          | ?            | ?           |
    | AECA-598            | 1             | 3               | 201908 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 552.67      |
    | AECA-598            | 1             | 4               | 201908 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 976.55      |
    | AECA-598            | 1             | 5               | 201908 | 2              | 0             | 1261.00      | 1261.00              | 0.00                | 0.00                   | 0.00                        | 1261.00          | ?            | ?           |


    # Tidy Up
    And   the override date is reset 
      
