Feature: CreateFE-CTFContracts 41519


@AcceptanceTest @Complete
Scenario: S044 Bulk load a new FE-CTF2425 contract. Publish and approve. Check docs. Payment batch. Check financials and feed. CDA
	 Given there is no Contract, Task or Workflow data for UKPRN '10018044' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018044' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | FE-CTF2425        |

    # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
    And   there is no Subnominal data in CRM for the following subnominal codes
    | SubnominalCode |
    | 101302         |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018044'

   
    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018044' 
    And   there is no caseload advisor for UKPRN '10018044' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018044 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10036143' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018044 Co Ltd' with UKPRN '10018044' and OrgId 'ORG0018044' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018044 | 1018044| 10018044 Co Ltd | 0              | Active                | Yes           | A1018044      | ?             | 5 Buckingham Court     | Rectory Lane           | ?                      | ?                      | Loughton               | Essex                  | IG10 2QZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018044 |





    # Bulk load a new FECTF contract for 23/24

    # Change the date
    Given the override date is '01/03/2024'

    # Bulk file
    And   there are no files prefixed '10018044' in the Sharepoint 'FE-CTF-2425-Input-Appendices' folder
    And   there are no files prefixed 'FE-CTF FY 2425 22022024121144 v3_S044' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'FE-CTF FY 2425 22022024121144 v3_S044' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'FE-CTF FY 2425 22022024121144 v3_S044' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'FE-CTF FY 2425 22022024121144 v3_S044' in the Sharepoint 'Reports' folder
    And   spreadsheet 'FE-CTF FY 2425 22022024121144 v3_S044.xlsx' exists in the Datafiles folder and UKPRN '10018044' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017015' for FundingType 'FE-CTF' and period '2425' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10018044' for FundingType 'FE-CTF' and period '2425'

    # Check the contents of the Appendices
    Then  the file named '10018044_[ContractNo]_v1.pdf' in Sharepoint location 'FE-CTF-2425-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10018044 Co Ltd UKPRN: 10018044
    Master Contract Number: [MasterContractNo] Start Date: 01/04/2024 End Date: 31/03/2025
    Contract Ref: [AllocRef_FECT]
    Cash (£) Apr 2024 May 2024 Jun 2024 Jul 2024 Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025
    Further Education Capital Transformation Fund £33,240 £1,304 £645 £6,845 £2,036 £560 £7,099 £1,272 £2,853 £220 £167 £6,165 £4,074
    Allocation
    Total Funding £33,240 £1,304 £645 £6,845 £2,036 £560 £7,099 £1,272 £2,853 £220 £167 £6,165 £4,074
    Further Education Capital Transformation Fund Allocation – [AllocRef_FECT] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018044_[ContractNo]_v1.pdf' in 'FE-CTF-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S044.pdf'

   #And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'





    # Publish and Approve the contract

    # Change the Date
    Given the override date is '02/08/2024'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018044 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/04/2024        | 31/03/2025      | ?             |
    | 10018044 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2024        | 31/03/2025      | ?             |

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018044 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2024        | 31/03/2025      | ?             |
    | 10018044 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2024        | 31/03/2025      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_FECT] | 101302           | Mar-25 | Profile        |




    # Check financials in CRM

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
    | [ContractNo]   | [AllocRef_FECT]    | 1               | 33240.00  | 1304.00  | 645.00   | 6845.00  | 2036.00  | 560.00   | 7099.00  | 1272.00  | 2853.00  | 220.00   | 167.00   | 6165.00  | 4074.00  | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
    | [ContractNo]   | [AllocRef_FECT]    | 1               | 10830.00  | ?        | ?        | ?        | ?        | 10830.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
    | [ContractNo]   | [AllocRef_FECT]    | 1               | 33240.00  | 0.00     | 0.00     | 0.00     | 0.00     | 11390.00 | 7099.00  | 1272.00  | 2853.00  | 220.00   | 167.00   | 6165.00  | 4074.00  | 





    # Payment Batch starts here for FE-CTF2425 (PoP)

    # Change the date
    Given the override date is '02/08/2024 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'FE-CTF2425' AccountingPaymentPeriod '202405' CensusEndDate '02/08/2024' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_FECT]          | 202408 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | FE-CTF2425                 | 202408               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | FE-CTF2425                 | 202408               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'FE-CTF2425' PaymentPeriod '202405' CensusEndDate '02/08/2024' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S044.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'FE-CTF2425' PaymentPeriod '202405' CensusEndDate '02/08/2024' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription   | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | FECT                   | 2024          | 05             | 02          | ?       | [AllocRef_FECT]   | 11390.00        | PROFILE          | CapitalTransform        | 2024-08-20 | 2024-04-01   | 2025-03-31 | ?              | 10018044 | 101302     |

