Feature: Create1618FU2122contract 32665

@AcceptanceTest @Withdrawn20220309
Scenario: A077 Bulk load a new 2122 16-18FU contract. Check docs then publish and approve. Non-financial amendment then check docs. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017077' 
    And   there are no terminated or closed allocations for UKPRN '10017077' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017077' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Clear down actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017077' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18FU2122       |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017077' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017077 Co Ltd' with UKPRN '10017077' and OrgId 'ORG0017077' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017077' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017077 | 117077 | 10017077 Co Ltd | 0              | Active                | Yes           | AA017077      | ?             | 412 Midsummer Rd       | ?                      | ?                      | ?                      | ?                      | ?                      | MK9 2EA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017077 |




    # Change the date
    Given the override date is '23/03/2021'

    # Bulk file
    And   there are no files prefixed '10017077' in the Sharepoint '16-18FU-2122-Input-Appendices' folder
    And   there are no files prefixed '16-18FU FY 2122 21022021133148 v3_A077' in the Sharepoint 'Input' folder
    And   there are no files prefixed '16-18FU FY 2122 21022021133148 v3_A077' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '16-18FU FY 2122 21022021133148 v3_A077' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '16-18FU FY 2122 21022021133148 v3_A077' in the Sharepoint 'Reports' folder
    And   spreadsheet '16-18FU FY 2122 21022021133148 v3_A077.xlsx' exists in the Datafiles folder and UKPRN '10017077' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017077' for FundingType '16-18FU' and period '2122' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017077' for FundingType '16-18FU' and period '2122'

    # Check the contents of the Appendices
    And   the file named '10017077_[ContractNo]_v1.pdf' in Sharepoint location '16-18FU-2122-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017077 Co Ltd UKPRN: 10017077
    Master Contract Number: [MasterContractNo] Start Date: 01/04/2021 End Date: 31/03/2022
    Contract Ref: [AllocRef_16FU]
    Cash (£) Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    16-18 Education at an Adolescent Forensic Unit £33,835 £0 £0 £9,018 £0 £0 £8,273 £0 £0 £10,345 £0 £0 £6,199
    Total Funding £33,835 £0 £0 £9,018 £0 £0 £8,273 £0 £0 £10,345 £0 £0 £6,199
    16-18 Education at an Adolescent Forensic Unit – [AllocRef_16FU] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017077_[ContractNo]_v1.pdf' in '16-18FU-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A077_1.pdf'




    # Publish and approve
	
	# Change the date
    Given the override date is '28/03/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for actual MasterContractNumber 'ESFA-077' and actual ContractNumber '1618FU-077' and Version '1' 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017077 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017077 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract '1618FU-077'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_16FU] | 2430670          | Mar-22 | Profile        |




	# Check CRM financials

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | [ContractNo]   | [AllocRef_16FU]    | 1               | 33835.00  | 0.00     | 0.00     | 9018.00  | 0.00     | 0.00     | 8273.00  | 0.00     | 0.00     | 10345.00 | 0.00     | 0.00     | 6199.00  | 




	
	# Create non-financial amendment and check doc

	# Change the date
    Given the override date is '30/03/2021'

    # Attempt a non-financial VARIATION amendment request on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017077 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017077 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017077 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the contents of the Appendices (Only the version number should have changed)
    And   the file named '10017077_[ContractNo]_v2.pdf' in Sharepoint location '16-18FU-2122-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017077 Co Ltd UKPRN: 10017077
    Master Contract Number: [MasterContractNo] Start Date: 01/04/2021 End Date: 31/03/2022
    Contract Ref: [AllocRef_16FU]
    Cash (£) Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    16-18 Education at an Adolescent Forensic Unit £33,835 £0 £0 £9,018 £0 £0 £8,273 £0 £0 £10,345 £0 £0 £6,199
    Total Funding £33,835 £0 £0 £9,018 £0 £0 £8,273 £0 £0 £10,345 £0 £0 £6,199
    16-18 Education at an Adolescent Forensic Unit – [AllocRef_16FU] – Page 1 Ref (for internal use only):  [ContractNo] v2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017077_[ContractNo]_v2.pdf' in '16-18FU-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A077_2.pdf'


    # Tidy up
    And   the override date is reset
     
@AcceptanceTest @Withdrawn20220309
Scenario: A078 Create and approve a new 2122 16-18FU contract. Bulk amend and approve. Create PoP payment. Check CRM, CDA, Financials and feeds
    Given there are no allocations marked as Under Termination for UKPRN '10017078' 
    And   there are no terminated or closed allocations for UKPRN '10017078' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017078' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017078' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017078' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16FU-078      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16FU-078      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18FU2122       |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | 1618FU-078     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017078'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017078' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017078 Co Ltd' with UKPRN '10017078' and OrgId 'ORG0017078' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017078' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017078 | 117078 | 10017078 Co Ltd | 0              | Provider Under Change | Yes           | AA017078      | ?             | 231a Union Street      | Aberdeen               | ?                      | ?                      | ?                      | ?                      | AB11 6BQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017078 |




    # Change the date
    Given the override date is '01/03/2021'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017078 | 10017078 Co Ltd      | ESFA-078             | 1618FU-078     | 1                     | 01/04/2021        | 31/03/2022      | 6562.00       |                                       | Contract for Services                      | 2122   | New          | ORG0017078 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017078 | 1618FU-078     | 16FU-078      | 16-18FU           | 16-18FU2122             | FY                      | 01/04/2021          | 31/03/2022        | 6562.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017078 | 1618FU-078     | 16FU-078      | 1               | 0                     | 6562.00   | 0.00     | 0.00     | 1455.00  | 0.00     | 0.00     | 798.00   | 0.00     | 0.00     | 1786.00  | 0.00     | 0.00     | 2523.00  | 16-18 Education at an Adolescent Forensic Unit                  | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract '1618FU-078' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '1618FU-078'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-078' and actual ContractNumber '1618FU-078'

    # Check that the contract is now approved
    Then  the latest version of contract '1618FU-078' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017078 | 1618FU-078         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017078 | ESFA-078           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract '1618FU-078'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | 16FU-078      | 2430670          | Mar-22 | Profile        |




	# Amend the contract

    # Change the date
    Given the override date is '28/03/2021'

    # Bulk file
    And   there are no files prefixed '10017078' in the Sharepoint '16-18FU-2122-Input-Appendices' folder
    And   there are no files prefixed '16-18FU FY 2122 21022021133222 v3_A078' in the Sharepoint 'Input' folder
    And   there are no files prefixed '16-18FU FY 2122 21022021133222 v3_A078' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '16-18FU FY 2122 21022021133222 v3_A078' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '16-18FU FY 2122 21022021133222 v3_A078' in the Sharepoint 'Reports' folder
    And   spreadsheet '16-18FU FY 2122 21022021133222 v3_A078.xlsx' exists in the Datafiles folder and UKPRN '10017078' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

   #And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'




	# Change the date
    Given the override date is '29/03/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '1618FU-078'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-078' and actual ContractNumber '1618FU-078'

    # Check that the contract is now approved
    Then  the latest version of contract '1618FU-078' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017078 | 1618FU-078         | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017078 | 1618FU-078         | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/04/2021        | 31/03/2022      | ?             |
    | 10017078 | ESFA-078           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract '1618FU-078'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | 16FU-078      | 2430670          | Mar-22 | Profile        |




	# Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | 1618FU-078     | 16FU-078           | 1               | 32153.00  | 0.00     | 0.00     | 8276.00  | 0.00     | 0.00     | 7310.00  | 0.00     | 0.00     | 7474.00  | 0.00     | 0.00     | 9093.00  | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef    | ProfileSubnominal  | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | 10017078 | 1618FU-078     | 16FU-078         | 2430670            | 0.00     | 0.00     | 8276.00  | 0.00     | 0.00     | 7310.00  | 0.00     | 0.00     | 7474.00  | 0.00     | 0.00     | 9093.00  | 




	# Payment Batch for Jun-21 for 16-18FU2122 (PoP payment)

    # Change the date
    Given the override date is '04/06/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '16-18FU2122' AccountingPaymentPeriod '202103' CensusEndDate '04/06/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | 16FU-078                 | 202106 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 16-18FU2122                | 202106               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 16-18FU2122                | 202106               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18FU2122' PaymentPeriod '202103' CensusEndDate '04/06/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A078.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18FU2122' PaymentPeriod '202103' CensusEndDate '04/06/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | 16FU                   | 2021          | 03             | 04          | ?       | 16FU-078      | 8276.00         | PROFILE          | Forensic Unit          | 2021-06-24 | 2021-04-01   | 2022-03-31 | ?              | 10017078 | 2430670    |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    And   there is an item on the Payment feed for FundingStreamPeriod '16-18FU2122' AccountingPaymentPeriod '202103' and CensusEndDate '04/06/2021'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                 |
    | Payment Requests for Funding Stream Period 16-18FU2122 for Payment Period 202103 have been generated as of Census End Date/Time 2021-06-04T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | 16-18FU2122         | 202103        | 2021-06-04T22:00:00Z  | 1                | 8276.00    |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | 16FU      | 01/04/2021   | 31/03/2022 | 04/06/2021    | 24/06/2021 | 2021          | 03             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName     | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription  | AggregatedValue |
    | ORG0017078  | 10017078       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | 16FU-078   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?           | ?                | ?               | ?                   | 2430670    | PROFILE        | Forensic Unit          | 8276.00         |




	# Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | 1618FU-078     | 16FU-078           | 1               | 32153.00  | 0.00     | 0.00     | 8276.00  | 0.00     | 0.00     | 7310.00  | 0.00     | 0.00     | 7474.00  | 0.00     | 0.00     | 9093.00  | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef    | ProfileSubnominal  | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | 10017078 | 1618FU-078     | 16FU-078         | 2430670            | 0.00     | 0.00     | 8276.00  | 0.00     | 0.00     | 7310.00  | 0.00     | 0.00     | 7474.00  | 0.00     | 0.00     | 9093.00  | 




    
#    # CDA
#    
#    # Check the contents of the CDA report
#    Given there is no CDA report named 'CDA Last Approved Version A078.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | 1618FU-078     | 2                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod  | Version            | Suffix |
#    | 16-18FU2122          | Latest Version     | A078   |
#
#    Then  a report named 'CDA Latest Version A078.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | 16-18FU2122             | 10017078 | 10017078 Co Ltd             |               |                             | 16FU-078                 | 1618FU-078     | ESFA-078                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 4                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2430670           |                          |                   | Apr              |
#    | 16-18FU2122             | 10017078 | 10017078 Co Ltd             |               |                             | 16FU-078                 | 1618FU-078     | ESFA-078                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 5                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2430670           |                          |                   | May              |
#    | 16-18FU2122             | 10017078 | 10017078 Co Ltd             |               |                             | 16FU-078                 | 1618FU-078     | ESFA-078                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 6                 | 2021            | 2021/22       |              | 8276         |              |               |              | Yes                | 8276.00        | 0.00             | 0.00                  | 0.00           | 8276.00         |             | Yes           |                   |        | 2430670           |                          |                   | Jun              |
#    | 16-18FU2122             | 10017078 | 10017078 Co Ltd             |               |                             | 16FU-078                 | 1618FU-078     | ESFA-078                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 7                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2430670           |                          |                   | Jul              |
#    | 16-18FU2122             | 10017078 | 10017078 Co Ltd             |               |                             | 16FU-078                 | 1618FU-078     | ESFA-078                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 8                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2430670           |                          |                   | Aug              |
#    | 16-18FU2122             | 10017078 | 10017078 Co Ltd             |               |                             | 16FU-078                 | 1618FU-078     | ESFA-078                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 9                 | 2021            | 2021/22       |              | 7310         |              |               |              | Yes                | 7310.00        | 0.00             | 0.00                  | 0.00           | 7310.00         |             | No            |                   |        | 2430670           |                          |                   | Sep              |
#    | 16-18FU2122             | 10017078 | 10017078 Co Ltd             |               |                             | 16FU-078                 | 1618FU-078     | ESFA-078                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 10                | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2430670           |                          |                   | Oct              |
#    | 16-18FU2122             | 10017078 | 10017078 Co Ltd             |               |                             | 16FU-078                 | 1618FU-078     | ESFA-078                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 11                | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2430670           |                          |                   | Nov              |
#    | 16-18FU2122             | 10017078 | 10017078 Co Ltd             |               |                             | 16FU-078                 | 1618FU-078     | ESFA-078                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 12                | 2021            | 2021/22       |              | 7474         |              |               |              | Yes                | 7474.00        | 0.00             | 0.00                  | 0.00           | 7474.00         |             | No            |                   |        | 2430670           |                          |                   | Dec              |
#    | 16-18FU2122             | 10017078 | 10017078 Co Ltd             |               |                             | 16FU-078                 | 1618FU-078     | ESFA-078                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 1                 | 2022            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2430670           |                          |                   | Jan              |
#    | 16-18FU2122             | 10017078 | 10017078 Co Ltd             |               |                             | 16FU-078                 | 1618FU-078     | ESFA-078                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 2                 | 2022            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2430670           |                          |                   | Feb              |
#    | 16-18FU2122             | 10017078 | 10017078 Co Ltd             |               |                             | 16FU-078                 | 1618FU-078     | ESFA-078                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 3                 | 2022            | 2021/22       |              | 9093         |              |               |              | Yes                | 9093.00        | 0.00             | 0.00                  | 0.00           | 9093.00         |             | No            |                   |        | 2430670           |                          |                   | Mar              |

	   	 
	# Tidy Up
    And   the override date is reset
