Feature: Create Skill Bootcamps to validate 2 new deliverables for SB & SB-PAA and also validate new collection types 37141


    @AcceptanceTest @Complete
Scenario: S635 Bulk load a Skills Bootcamp Pathway (SB-PAA2022) contract for 22/23 to validate 2 new deliverables. Publish and approve. Check docs. Push actuals for new collection. Generate payments. 

    Given there are no allocations marked as Under Termination for UKPRN '10017635' 
    And   there are no terminated or closed allocations for UKPRN '10017635' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017635' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017635' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017635' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | SB-PAA2022        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017635'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017635' 
    And   there is no caseload advisor for UKPRN '10017635' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017635 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017635' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017635 Co Ltd' with UKPRN '10017635' and OrgId 'ORG0017635' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017635 | 117635 | 10017635 Co Ltd | 0              | In Administration     | Yes           | AA017635      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017635 |





    # Change the date
    Given the override date is '01/07/2022'

    # Bulk file (UoP = W3L6)
    And   there are no files prefixed '10017635' in the Sharepoint 'SB-2022-Input-Appendices' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S635' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S635' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S635' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S635' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SB SB 2022 15072022094413 v3_S635.xlsx' exists in the Datafiles folder and UKPRN '10017635' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017635' for FundingType 'SB' and period '2022'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    Then  the file named '10017635_[ContractNo]_v1.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017635 Co Ltd UKPRN: 10017635
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 30/09/2023
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £36,923.00
    of which Analysing Data (leading to Data Technician) [AllocRef_SBA]-18 £4,122.00 180 £34,567.00
    of which Pathway to Apprenticeship [AllocRef_SBA]-19 £234.00 120 £2,356.00
    Total Funding for this contract: £36,923.00
    Summary of Funding – Page 1

    Agreement Type Contract for Services
    Funding Period 1 August 2022 to 30 September 2023
    Between the Secretary of State for Education
    And 10017635 Co Ltd
    Funding for Skills Bootcamps Wave 3
    Master Contract Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    Ceri D’Mello, Deputy Director, Head of Commercial – Skills Category Commercial Directorate,
    Operations Group
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service
    between:
    10017635 Co Ltd THE SECRETARY OF STATE FOR
    46 The Avenue EDUCATION
    Bournemouth DEPARTMENT FOR EDUCATION
    Dorset 20 GREAT SMITH STREET
    AND
    BH9 2UW LONDON
    SW1P 3BT
    Company No: AA017635
    Hereinafter called Hereinafter called
    the “Contractor” the “DFE”
    each a “Party” and together the “Parties”.
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 2
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 40
    
    Schedule 1
    The Specification
    Skills Bootcamps Wave 3 Schedule 1 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 1 Version 1 (August 2022) - Page 12
    
    Schedule 2
    Financials
    Payment triggers
    Learners not currently in Completion of 5 Successful completion Recording of a successful
    Skills Bootcamps Wave 3 Schedule 2 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 2 Version 1 (August 2022) - Page 4
    
    Schedule 3
    Skills Bootcamps Wave 3 Schedule 3 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 7 Version 1 (August 2022) - Page 1
    """

    # There should not be a Funding Agreement
    And   the pdf file does not contain the following text
    """
    Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017635_[ContractNo]_v1.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S635.pdf'

    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017635 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 30/09/2023      | ?             |
    | 10017635 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 30/09/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed


    
    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_SBA]  | 101139           | Sep-23 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef  | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                                      | DeliverableDescription   | 
	| 10017635 | [ContractNo]   | 1               | [AllocRef_SBA] | 18              | 0                     | 34567.00     | 180           | 4122.00  | Apprenticeship Paths - Analysing Data (leading to Data Technician)                   | ?                        |
	| 10017635 | [ContractNo]   | 1               | [AllocRef_SBA] | 19              | 0                     | 2356.00      | 120           | 234.00   | Apprenticeship Paths - Pathway to Apprenticeship			                          | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed


    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check Planned data on the ADP feed for Aug-22
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Planned data
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume | 
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 18              | 202208 | 34567.00	  | 180           |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 19              | 202208 | 2356.00	  | 120           |



    # Add actuals to the contract for SB-PAA2022

    # Change the date
    Given the override date is '04/09/2022'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017635'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2022 (Four deliverables)
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | SB             | SB01                 | ORG0017635     | CM             | 202208 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 18              | 0            | 8229.83     |
    | SB             | SB01                 | ORG0017635     | CM             | 202208 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 19              | 0            | 1479.98     |
    | SB             | SB01                 | ORG0017635     | CM             | 202209 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 18              | 0            | 547.07      |
    | SB             | SB01                 | ORG0017635     | CM             | 202209 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 19              | 0            | 552.44      |
    | SB             | SB01                 | ORG0017635     | CM             | 202210 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 18              | 0            | 1002.62     |
    | SB             | SB01                 | ORG0017635     | CM             | 202210 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 19              | 0            | 648.52      |
    | SB             | SB01                 | ORG0017635     | CM             | 202211 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 18              | 0            | 554.29      |
    | SB             | SB01                 | ORG0017635     | CM             | 202211 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 19              | 0            | 472.80      |
    | SB             | SB01                 | ORG0017635     | CM             | 202212 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 18              | 0            | 349.64      |
    | SB             | SB01                 | ORG0017635     | CM             | 202212 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 19              | 0            | 410.80      |
    | SB             | SB01                 | ORG0017635     | CM             | 202301 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 18              | 0            | 1151.67     |
    | SB             | SB01                 | ORG0017635     | CM             | 202301 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 19              | 0            | 751.60      |
    | SB             | SB01                 | ORG0017635     | CM             | 202302 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 18              | 0            | 1327.16     |
    | SB             | SB01                 | ORG0017635     | CM             | 202302 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 19              | 0            | 1473.01     |
    | SB             | SB01                 | ORG0017635     | CM             | 202303 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 18              | 0            | 1397.43     |
    | SB             | SB01                 | ORG0017635     | CM             | 202303 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 19              | 0            | 1089.18     |
    | SB             | SB01                 | ORG0017635     | CM             | 202304 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 18              | 0            | 1401.61     |
    | SB             | SB01                 | ORG0017635     | CM             | 202304 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 19              | 0            | 810.83      |
    | SB             | SB01                 | ORG0017635     | CM             | 202305 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 18              | 0            | 1072.44     |
    | SB             | SB01                 | ORG0017635     | CM             | 202305 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 19              | 0            | 267.86      |
    | SB             | SB01                 | ORG0017635     | CM             | 202306 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 18              | 0            | 324.56      |
    | SB             | SB01                 | ORG0017635     | CM             | 202306 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 19              | 0            | 1044.52     |
    | SB             | SB01                 | ORG0017635     | CM             | 202307 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 18              | 0            | 1305.26     |
    | SB             | SB01                 | ORG0017635     | CM             | 202307 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 19              | 0            | 527.04      |
    | SB             | SB01                 | ORG0017635     | CM             | 202308 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 18              | 0            | 757.78      |
    | SB             | SB01                 | ORG0017635     | CM             | 202308 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 19              | 0            | 1063.84     |
    | SB             | SB01                 | ORG0017635     | CM             | 202309 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 18              | 0            | 1447.09     |
    | SB             | SB01                 | ORG0017635     | CM             | 202309 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 19              | 0            | 688.12      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 18              | 8229.83   | 8229.83  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 19              | 1479.98   | 1479.98  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 18              | 8229.83   | 8229.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 19              | 1479.98   | 1479.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                   £ 9709.81

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 19              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 18              | 8229.83   | 8229.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 19              | 1479.98   | 1479.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                   £ 9709.81



    # Payment Batch for SB-PAA2022(PoA)

    # Change the date
    Given the override date is '08/09/2022 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'SB-PAA2022' AccountingPaymentPeriod '202205' CensusEndDate '08/09/2022' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_SBA]           | 202208 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | SB-PAA2022                 | 202208               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | SB-PAA2022                 | 202208               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SB-PAA2022' PaymentPeriod '202205' CensusEndDate '08/09/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A635.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SB-PAA2022' PaymentPeriod '202205' CensusEndDate '08/09/2022' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | SBPA                   | 2022          | 05             | 08          | ?       | [AllocRef_SBA]    | 9709.81         | RECONCILIATION   | Skills Bootcamps       | 2022-09-20 | 2022-08-01   | 2025-07-31| ?              | 10017635 | 101139     |


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    | Apr-23    | May-23    | Jun-23    | Jul-23    | Aug-23    | Sep-23    |
    | 10017635 | [ContractNo]   | [AllocRef_SBA]     | 101139                   | 9709.81   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 


    # Tidy Up
    Given the override date is reset
	

    
    @AcceptanceTest @Complete
Scenario: S636 Bulk load a Skills Bootcamp  (SB2022) contract for 22/23 to validate 2 new deliverables. Publish and approve. Check docs. Push actuals for new collection. Generate payments.
    Given there are no allocations marked as Under Termination for UKPRN '10017636' 
    And   there are no terminated or closed allocations for UKPRN '10017636' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017636' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017636' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017636' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP           |
    | SB2022        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017636'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017636' 
    And   there is no caseload advisor for UKPRN '10017636' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017636 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017636' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017636 Co Ltd' with UKPRN '10017636' and OrgId 'ORG0017636' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017636 | 117636 | 10017636 Co Ltd | 0              | In Administration     | Yes           | AA017636      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017636 |





    # Change the date
    Given the override date is '01/07/2022'

    # Bulk file (UoP = W3L6)
    And   there are no files prefixed '10017636' in the Sharepoint 'SB-2022-Input-Appendices' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S636' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S636' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S636' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S636' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SB SB 2022 15072022094413 v3_S636.xlsx' exists in the Datafiles folder and UKPRN '10017636' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017636' for FundingType 'SB' and period '2022'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    Then  the file named '10017636_[ContractNo]_v1.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017636 Co Ltd UKPRN: 10017636
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 30/09/2023
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £599,730.00
    of which Bay Electech - Electronic Skills Programme 2 [AllocRef_SB]-238 £1,000.00 100 £23,000.00
    of which Trade Skills Development Centre [AllocRef_SB]-239 £2,000.00 23 £46,000.00
    Total Funding for this contract: £599,730.00
    Summary of Funding – Page 1

    Agreement Type Contract for Services
    Funding Period 1 August 2022 to 30 September 2023
    Between the Secretary of State for Education
    And 10017636 Co Ltd
    Funding for Skills Bootcamps Wave 3
    Master Contract Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    Ceri D’Mello, Deputy Director, Head of Commercial – Skills Category Commercial Directorate,
    Operations Group
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service
    between:
    10017636 Co Ltd THE SECRETARY OF STATE FOR
    46 The Avenue EDUCATION
    Bournemouth DEPARTMENT FOR EDUCATION
    Dorset 20 GREAT SMITH STREET
    AND
    BH9 2UW LONDON
    SW1P 3BT
    Company No: AA017636
    Hereinafter called Hereinafter called
    the “Contractor” the “DFE”
    each a “Party” and together the “Parties”.
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 2
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 40
    
    Schedule 1
    The Specification
    Skills Bootcamps Wave 3 Schedule 1 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 1 Version 1 (August 2022) - Page 12
    
    Schedule 2
    Financials
    Payment triggers
    Learners not currently in Completion of 5 Successful completion Recording of a successful
    Skills Bootcamps Wave 3 Schedule 2 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 2 Version 1 (August 2022) - Page 4
    
    Schedule 3
    Skills Bootcamps Wave 3 Schedule 3 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 7 Version 1 (August 2022) - Page 1
    """

    # There should not be a Funding Agreement
    And   the pdf file does not contain the following text
    """
    Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017636_[ContractNo]_v1.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S636.pdf'

    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017636 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 30/09/2023      | ?             |
    | 10017636 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 30/09/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

	
	
    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check Planned data on the ADP feed for Aug-22
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Planned data
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume | 
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 72              | 202208 | 155550.00	  | 60            |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 112             | 202208 | 40800.00	  | 40            |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 115             | 202208 | 150150.00	  | 60            |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 189             | 202208 | 184230.00	  | 60            |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 238             | 202208 | 23000.00	  | 100           |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 239             | 202208 | 46000.00	  | 23            |



    # Add actuals to the contract for SB2022

    # Change the date
    Given the override date is '04/09/2022'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017636'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2022 (Four deliverables)
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode  | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | SB             | SB01                  | ORG0017636     | CM             | 202208 | SB2022   	             | [AllocRef_SB]            | W3L1       | 72              | 0            | 8229.83     |
    | SB             | SB01                  | ORG0017636     | CM             | 202208 | SB2022                 | [AllocRef_SB]            | W3L1       | 112             | 0            | 1479.98     |
    | SB             | SB01                  | ORG0017636     | CM             | 202208 | SB2022           	     | [AllocRef_SB]            | W3L1       | 115             | 0            | 547.07      |
    | SB             | SB01                  | ORG0017636     | CM             | 202208 | SB2022             	 | [AllocRef_SB]            | W3L1       | 189             | 0            | 552.44      |
    | SB             | SB01                  | ORG0017636     | CM             | 202208 | SB2022              	 | [AllocRef_SB]            | W3L1       | 238             | 0            | 1002.62     |
    | SB             | SB01                  | ORG0017636     | CM             | 202208 | SB2022              	 | [AllocRef_SB]            | W3L1       | 239             | 0            | 648.52      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SB]      | 72              | 8229.83   | 8229.83  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 112             | 1479.98   | 1479.98  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 115             | 547.07    | 547.07   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 189             | 552.44    | 552.44   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 238             | 1002.62   | 1002.62  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 239             | 648.52    | 648.52   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 



    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SB]      | 72              | 8229.83   | 8229.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 112             | 1479.98   | 1479.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 115             | 547.07    | 547.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 189             | 552.44    | 552.44   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 238             | 1002.62   | 1002.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 239             | 648.52    | 648.52   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                   £ 12460.46

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SB]      | 72              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 112             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 115             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 189             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 238             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 239             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SB]      | 72              | 8229.83   | 8229.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 112             | 1479.98   | 1479.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 115             | 547.07    | 547.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 189             | 552.44    | 552.44   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 238             | 1002.62   | 1002.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 239             | 648.52    | 648.52   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                   £ 12460.46



    # Payment Batch for SB2022(PoA)

    # Change the date
    Given the override date is '08/09/2022 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'SB2022' AccountingPaymentPeriod '202205' CensusEndDate '08/09/2022' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_SB]            | 202208 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | SB2022               		 | 202208               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | SB2022                 	 | 202208               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SB2022' PaymentPeriod '202205' CensusEndDate '08/09/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A636.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SB2022' PaymentPeriod '202205' CensusEndDate '08/09/2022' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue   | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | SB                     | 2022          | 05             | 08          | ?       | [AllocRef_SB]     | 12460.46          | RECONCILIATION   | Skills Bootcamps       | 2022-09-20 | 2022-08-01   | 2025-07-31| ?              | 10017636 | 101139     |


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef     | ReconciliationSubnominal | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    | Apr-23    | May-23    | Jun-23    | Jul-23    | Aug-23    | Sep-23    |
    | 10017636 | [ContractNo]   | [AllocRef_SB]     | 101139                   | 12460.46  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 


    # Tidy Up
    Given the override date is reset
	
	
    
    @AcceptanceTest @Complete
Scenario: S637 Bulk load a Skills Bootcamp  (SB2022) contract for 22/23 to validate negative scenarios Actuals with collection type SB. Generate payments. 
    Given there are no allocations marked as Under Termination for UKPRN '10017637' 
    And   there are no terminated or closed allocations for UKPRN '10017637' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017637' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017637' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017637' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | SB2022 	        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017637'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017637' 
    And   there is no caseload advisor for UKPRN '10017637' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017637 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017637' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017637 Co Ltd' with UKPRN '10017637' and OrgId 'ORG0017637' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017637 | 117637 | 10017637 Co Ltd | 0              | In Administration     | Yes           | AA017637      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | TH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017637 |





    # Change the date
    Given the override date is '01/09/2022'

    # Bulk file (UoP = W3L6)
    And   there are no files prefixed '10017637' in the Sharepoint 'SB-2022-Input-Appendices' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S637' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S637' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S637' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S637' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SB SB 2022 15072022094413 v3_S637.xlsx' exists in the Datafiles folder and UKPRN '10017637' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017637' for FundingType 'SB' and period '2022'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    Then  the file named '10017637_[ContractNo]_v1.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017637 Co Ltd UKPRN: 10017637
    Master Contract Number: [MasterContractNo] Start Date: 01/10/2022 End Date: 28/02/2023
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £1,330,536.68
	of which Advanced Engineering and Materials Testing [AllocRef_SB]-1 £322.40 479 £154,429.60
	of which Cloud [AllocRef_SB]-3 £3.23 455 £124,319.65
	of which Cloud computing (AWS Certified Cloud Practitioner) [AllocRef_SB]-6 £333.06 389 £129,560.34
	of which Building Information Modelling (BIM) Level 4 [AllocRef_SB]-14 £392.89 363 £142,619.07
	of which Introduction to Construction Site Management [AllocRef_SB]-22 £343.72 378 £129,926.16
	of which Commercial Drylining Skills Boot Camp, [AllocRef_SB]-31 £403.55 352 £142,049.60
    Unemployed Pathway
    of which Data Analyst [AllocRef_SB]-72 £462.37 436 £201,593.32
    of which DevOps [AllocRef_SB]-94 £113.20 450 £50,940.00
    of which Extended Reality (Games) [AllocRef_SB]-129 £472.03 274 £129,336.22
    of which Coding Skills Bootcamp [AllocRef_SB]-196 £123.60 249 £30,776.40
    of which Care (Senior Care Workers, Nursing [AllocRef_SB]-212 £183.43 374 £68,602.82
    Auxiliaries/Assistants)
    of which Welding and Coding Skills Bootcamp [AllocRef_SB]-237 £133.25 198 £26,383.50
    Total Funding for this contract: £1,330,536.68
    Summary of Funding – Page 1
        
    Agreement Type Contract for Services
    Funding Period 1 August 2022 to 28 February 2023
    Between the Secretary of State for Education
    And 10017637 Co Ltd
    Funding for Skills Bootcamps Wave 3
    Master Contract Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    Ceri D’Mello, Deputy Director, Head of Commercial – Skills Category Commercial Directorate,
    Operations Group
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service
    between:
    10017637 Co Ltd THE SECRETARY OF STATE FOR
    46 The Avenue EDUCATION
    Bournemouth DEPARTMENT FOR EDUCATION
    Dorset 20 GREAT SMITH STREET
    AND
    TH9 2UW LONDON
    SW1P 3BT
    Company No: AA017637
    Hereinafter called Hereinafter called
    the “Contractor” the “DFE”
    each a “Party” and together the “Parties”.
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 2
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 40
    
    Schedule 1
    The Specification
    Skills Bootcamps Wave 3 Schedule 1 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 1 Version 1 (August 2022) - Page 12
    
    Schedule 2
    Financials
    Payment triggers
    Learners not currently in Completion of 5 Successful completion Recording of a successful
    Skills Bootcamps Wave 3 Schedule 2 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 2 Version 1 (August 2022) - Page 4
    
    Schedule 3
    Skills Bootcamps Wave 3 Schedule 3 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 7 Version 1 (August 2022) - Page 1
    """



    # There should not be a Funding Agreement
    And   the pdf file does not contain the following text
    """
    Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017637_[ContractNo]_v1.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S637.pdf'

    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017637 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/10/2022        | 28/02/2023      | ?             |
    | 10017637 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2022        | 28/02/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed


    
    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '60' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_SB]   | 101139           | Feb-23 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '12' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef  | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                                      | DeliverableDescription   | 
	| 10017637 | [ContractNo]   | 1               | [AllocRef_SB] | 1               | 0                     | 154429.60    | 479           | 322.40  | Advanced Manufacturing - Advanced Engineering and Materials Testing                   | ?                        |
	| 10017637 | [ContractNo]   | 1               | [AllocRef_SB] | 3               | 0                     | 124319.65    | 455           | 3.23    | Cloud - Cloud												                          | ?                        |
	| 10017637 | [ContractNo]   | 1               | [AllocRef_SB] | 6               | 0                     | 129560.34    | 389           | 333.06  | Cloud - Cloud computing (AWS Certified Cloud Practitioner)			                  | ?                        |
	| 10017637 | [ContractNo]   | 1               | [AllocRef_SB] | 14              | 0                     | 142619.07    | 363           | 392.89  | Computer Aided Design - Building Information Modelling (BIM) Level 4                  | ?                        |
	| 10017637 | [ContractNo]   | 1               | [AllocRef_SB] | 22              | 0                     | 129926.16    | 378           | 343.72  | Construction Management - Introduction to Construction Site Management                | ?                        |
	| 10017637 | [ContractNo]   | 1               | [AllocRef_SB] | 31              | 0                     | 142049.60    | 352           | 403.55  | Construction Trades - Commercial Drylining Skills Boot Camp, Unemployed Pathway       | ?                        |
	| 10017637 | [ContractNo]   | 1               | [AllocRef_SB] | 72              | 0                     | 201593.32    | 436           | 462.37  | Data - Data Analyst													                  | ?                        |
	| 10017637 | [ContractNo]   | 1               | [AllocRef_SB] | 94              | 0                     | 50940.00     | 450           | 113.20  | DevOps - DevOps                   													  | ?                        |
	| 10017637 | [ContractNo]   | 1               | [AllocRef_SB] | 129             | 0                     | 129336.22    | 274           | 472.03  | Games - Extended Reality											                  | ?                        |
	| 10017637 | [ContractNo]   | 1               | [AllocRef_SB] | 196             | 0                     | 30776.40     | 249           | 123.60  | Software Engineering - Coding Skills Bootcamp                   					  | ?                        |
	| 10017637 | [ContractNo]   | 1               | [AllocRef_SB] | 212             | 0                     | 68602.82     | 374           | 183.43  | Technical Bespoke - Care (Senior Care Workers, Nursing Auxiliaries/Assistants)        | ?                        |
	| 10017637 | [ContractNo]   | 1               | [AllocRef_SB] | 237             | 0                     | 26383.50     | 198           | 133.25  | Welding - Welding and Coding Skills Bootcamp                   						  | ?                        |

	
	

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed


    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check Planned data on the ADP feed for Oct-22
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Planned data
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume | 
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]   | 1              | 202210 | 21278.40	  | 66           |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]   | 3              | 202210 | 24044.24	  | 88           |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]   | 6              | 202210 | 23314.20	  | 70           |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]   | 14             | 202210 | 36145.88	  | 92           |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]   | 22             | 202210 | 39184.08	  | 114          |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]   | 31             | 202210 | 38740.80	  | 96           |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]   | 72             | 202210 | 54097.29	  | 117          |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]   | 94             | 202210 | 15734.80	  | 139          |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]   | 129            | 202210 | 5192.33	  | 11           |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]   | 196            | 202210 | 17674.80	  | 143          |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]   | 212            | 202210 | 2751.45	  | 15           |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]   | 237            | 202210 | 4930.25	  | 37           |
	



    # Add actuals to the contract for SB2022

    # Change the date
    Given the override date is '04/11/2022'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017637'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep, Oct and Nov 2022 (12 deliverables)
    And  the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | SB        | SB03                  | ORG0017637     | CM             | 202209 | SB2022              | [AllocRef_SB]           | W3L7       | 1              | 0            | 547.07      |
    | SB        | SB03                  | ORG0017637     | CM             | 202209 | SB2022              | [AllocRef_SB]           | W3L7       | 3              | 0            | 552.44      |
    | SB        | SB03                  | ORG0017637     | CM             | 202209 | SB2022              | [AllocRef_SB]           | W3L7       | 6              | 0            | 652.44      |
    | SB        | SB03                  | ORG0017637     | CM             | 202209 | SB2022              | [AllocRef_SB]           | W3L7       | 14             | 0            | 752.44      |
    | SB        | SB03                  | ORG0017637     | CM             | 202209 | SB2022              | [AllocRef_SB]           | W3L7       | 22             | 0            | 852.44      |
    | SB        | SB03                  | ORG0017637     | CM             | 202209 | SB2022              | [AllocRef_SB]           | W3L7       | 31             | 0            | 952.44      |
    | SB        | SB03                  | ORG0017637     | CM             | 202209 | SB2022              | [AllocRef_SB]           | W3L7       | 72             | 0            | 1052.44     |
    | SB        | SB03                  | ORG0017637     | CM             | 202209 | SB2022              | [AllocRef_SB]           | W3L7       | 94             | 0            | 1152.44     |
    | SB        | SB03                  | ORG0017637     | CM             | 202209 | SB2022              | [AllocRef_SB]           | W3L7       | 129            | 0            | 1252.44     |
    | SB        | SB03                  | ORG0017637     | CM             | 202209 | SB2022              | [AllocRef_SB]           | W3L7       | 196            | 0            | 1352.44     |
    | SB        | SB03                  | ORG0017637     | CM             | 202209 | SB2022              | [AllocRef_SB]           | W3L7       | 212            | 0            | 1452.44     |
    | SB        | SB03                  | ORG0017637     | CM             | 202209 | SB2022              | [AllocRef_SB]           | W3L7       | 237            | 0            | 1552.44     |
	#
    | SB        | SB03                  | ORG0017637     | CM             | 202210 | SB2022              | [AllocRef_SB]           | W3L7       | 1              | 100          | 547.00      |
    | SB        | SB03                  | ORG0017637     | CM             | 202210 | SB2022              | [AllocRef_SB]           | W3L7       | 3              | 100          | 552.00      |
    | SB        | SB03                  | ORG0017637     | CM             | 202210 | SB2022              | [AllocRef_SB]           | W3L7       | 6              | 100          | 652.00      |
    | SB        | SB03                  | ORG0017637     | CM             | 202210 | SB2022              | [AllocRef_SB]           | W3L7       | 14             | 100          | 752.00      |
    | SB        | SB03                  | ORG0017637     | CM             | 202210 | SB2022              | [AllocRef_SB]           | W3L7       | 22             | 100          | 852.00      |
    | SB        | SB03                  | ORG0017637     | CM             | 202210 | SB2022              | [AllocRef_SB]           | W3L7       | 31             | 0            | 952.00      |
    | SB        | SB03                  | ORG0017637     | CM             | 202210 | SB2022              | [AllocRef_SB]           | W3L7       | 72             | 0            | 152.00      |
    | SB        | SB03                  | ORG0017637     | CM             | 202210 | SB2022              | [AllocRef_SB]           | W3L7       | 94             | 0            | 1152.00      |
    | SB        | SB03                  | ORG0017637     | CM             | 202210 | SB2022              | [AllocRef_SB]           | W3L7       | 129            | 0            | 1252.00      |
    | SB        | SB03                  | ORG0017637     | CM             | 202210 | SB2022              | [AllocRef_SB]           | W3L7       | 196            | 0            | 1352.00      |
    | SB        | SB03                  | ORG0017637     | CM             | 202210 | SB2022              | [AllocRef_SB]           | W3L7       | 212            | 0            | 1452.00      |
    | SB        | SB03                  | ORG0017637     | CM             | 202210 | SB2022              | [AllocRef_SB]           | W3L7       | 237            | 0            | 153.00      |
    | SB        | SB03                  | ORG0017637     | CM             | 202210 | SB2022              | [AllocRef_SB]           | W3L7       | 238            | 0            | 2345.00      |
    | SB        | SB03                  | ORG0017637     | CM             | 202210 | SB2022              | [AllocRef_SB]           | W3L7       | 239            | 0            | 1534.00      |
	#
    | SB        | SB03                  | ORG0017637     | CM             | 202211 | SB2022              | [AllocRef_SB]           | W3L7       | 1              | 0            | 999.07      |
    | SB        | SB03                  | ORG0017637     | CM             | 202211 | SB2022              | [AllocRef_SB]           | W3L7       | 3              | 0            | 552.44      |
    | SB        | SB03                  | ORG0017637     | CM             | 202211 | SB2022              | [AllocRef_SB]           | W3L7       | 6              | 0            | 652.44      |
    | SB        | SB03                  | ORG0017637     | CM             | 202211 | SB2022              | [AllocRef_SB]           | W3L7       | 14             | 0            | 752.44      |
    | SB        | SB03                  | ORG0017637     | CM             | 202211 | SB2022              | [AllocRef_SB]           | W3L7       | 22             | 0            | 852.44      |
    | SB        | SB03                  | ORG0017637     | CM             | 202211 | SB2022              | [AllocRef_SB]           | W3L7       | 31             | 0            | 952.44      |
    | SB        | SB03                  | ORG0017637     | CM             | 202211 | SB2022              | [AllocRef_SB]           | W3L7       | 72             | 0            | 152.44      |
    | SB        | SB03                  | ORG0017637     | CM             | 202211 | SB2022              | [AllocRef_SB]           | W3L7       | 94             | 0            | 1152.44      |
    | SB        | SB03                  | ORG0017637     | CM             | 202211 | SB2022              | [AllocRef_SB]           | W3L7       | 129            | 0            | 1252.44      |
    | SB        | SB03                  | ORG0017637     | CM             | 202211 | SB2022              | [AllocRef_SB]           | W3L7       | 196            | 0            | 1352.44      |
    | SB        | SB03                  | ORG0017637     | CM             | 202211 | SB2022              | [AllocRef_SB]           | W3L7       | 212            | 0            | 142.44      |
    | SB        | SB03                  | ORG0017637     | CM             | 202211 | SB2022              | [AllocRef_SB]           | W3L7       | 237            | 0            | 155.44      |



    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total   | Oct-22  | Nov-22   | Dec-22   | Jan-23   | Feb-23   |
    | [ContractNo]   | [AllocRef_SB]      | 1              | 547.00   | 547.00  | ?        | ?        | ?        | ?        |  
    | [ContractNo]   | [AllocRef_SB]      | 3              | 552.00   | 552.00  | ?        | ?        | ?        | ?        |  
    | [ContractNo]   | [AllocRef_SB]      | 6              | 652.00   | 652.00  | ?        | ?        | ?        | ?        |  
    | [ContractNo]   | [AllocRef_SB]      | 14             | 752.00   | 752.00  | ?        | ?        | ?        | ?        |  
    | [ContractNo]   | [AllocRef_SB]      | 22             | 852.00   | 852.00  | ?        | ?        | ?        | ?        |  
    | [ContractNo]   | [AllocRef_SB]      | 31             | 952.00   | 952.00  | ?        | ?        | ?        | ?        |  
    | [ContractNo]   | [AllocRef_SB]      | 72             | 152.00   | 152.00  | ?        | ?        | ?        | ?        |  
    | [ContractNo]   | [AllocRef_SB]      | 94             | 1152.00  | 1152.00 | ?        | ?        | ?        | ?        |  
    | [ContractNo]   | [AllocRef_SB]      | 129            | 1252.00  | 1252.00 | ?        | ?        | ?        | ?        |  
    | [ContractNo]   | [AllocRef_SB]      | 196            | 1352.00  | 1352.00 | ?        | ?        | ?        | ?        |  
    | [ContractNo]   | [AllocRef_SB]      | 212            | 1452.00  | 1452.00 | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 237            | 153.00   | 153.00  | ?        | ?        | ?        | ?        |  
	
     # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total   | Oct-22  | Nov-22   | Dec-22   | Jan-23   | Feb-23   |
    | [ContractNo]   | [AllocRef_SB]      | 1              | 547.00   | 547.00  | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 3              | 552.00   | 552.00  | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 6              | 652.00   | 652.00  | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 14             | 752.00   | 752.00  | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 22             | 852.00   | 852.00  | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 31             | 952.00   | 952.00  | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 72             | 152.00   | 152.00  | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 94             | 1152.00  | 1152.00 | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 129            | 1252.00  | 1252.00 | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 196            | 1352.00  | 1352.00 | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 212            | 1452.00  | 1452.00 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 237            | 153.00   | 153.00  | 0.00     | 0.00     | 0.00     | 0.00     |  
    #                                                                 £ 9820.00

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total   | Oct-22  | Nov-22   | Dec-22   | Jan-23   | Feb-23   |
    | [ContractNo]   | [AllocRef_SB]      | 1              | 0.00     | 0.00    | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 3              | 0.00     | 0.00    | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 6              | 0.00     | 0.00    | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 14             | 0.00     | 0.00    | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 22             | 0.00     | 0.00    | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 31             | 0.00     | 0.00    | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 72             | 0.00     | 0.00    | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 94             | 0.00     | 0.00    | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 129            | 0.00     | 0.00    | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 196            | 0.00     | 0.00    | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 212            | 0.00     | 0.00    | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 237            | 0.00     | 0.00    | 0.00     | 0.00     | 0.00     | 0.00     |  
   
    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total   | Oct-22  | Nov-22   | Dec-22   | Jan-23   | Feb-23   |
    | [ContractNo]   | [AllocRef_SB]      | 1              | 547.00   | 547.00  | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 3              | 552.00   | 552.00  | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 6              | 652.00   | 652.00  | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 14             | 752.00   | 752.00  | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 22             | 852.00   | 852.00  | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 31             | 952.00   | 952.00  | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 72             | 152.00   | 152.00  | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 94             | 1152.00  | 1152.00 | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 129            | 1252.00  | 1252.00 | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 196            | 1352.00  | 1352.00 | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SB]      | 212            | 1452.00  | 1452.00 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 237            | 153.00   | 153.00  | 0.00     | 0.00     | 0.00     | 0.00     |  
    #                                                                 £ 9820.00



    # Payment Batch for SB2022(PoA)

    # Change the date
    Given the override date is '08/11/2022 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'SB2022' AccountingPaymentPeriod '202207' CensusEndDate '08/11/2022' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_SB]            | 202210 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | SB2022               		 | 202210               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | SB2022                 	 | 202210               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SB2022' PaymentPeriod '202207' CensusEndDate '08/11/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A637.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SB2022' PaymentPeriod '202207' CensusEndDate '08/11/2022' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue   | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | SB                     | 2022          | 07             | 10          | ?       | [AllocRef_SB]     | 9820.00           | RECONCILIATION   | Skills Bootcamps       | 2022-11-18 | 2022-08-01   | 2025-07-31| ?              | 10017637 | 101139     |


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef     | ReconciliationSubnominal  | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    |
    | 10017637 | [ContractNo]   | [AllocRef_SB]     | 101139                    | 9820.00   | 0.00      | 0.00      | 0.00      | 0.00      |



    # Tidy Up
    Given the override date is reset
	