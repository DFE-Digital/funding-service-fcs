Feature: CreateMultiplyContracts 41521 48241

@AcceptanceTest @Complete
Scenario: S043 Create and approve a new MULT2425 contract. Bulk amend and approve. PoP payment batch. CPSR. Check financials and feed
    Given there are no allocations marked as Under Termination for UKPRN '10018043' 
    And   there are no terminated or closed allocations for UKPRN '10018043' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018043' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018043' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018043' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | MULT-043      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | MULT-043      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | MULT2425          |

    # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
    And   there is no Subnominal data in CRM for the following subnominal codes
    | SubnominalCode |
    | 101085         |


    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | MLT-043        | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018043'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018043' 
    And   there is no caseload advisor for UKPRN '10018043' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018043 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018043' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018043 Co Ltd' with UKPRN '10018043' and OrgId 'ORG0018043' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018043 | 118043 | 10018043 Co Ltd | 0              | Active                | Yes           | AA018043      | ?             | 9 Ronaldshaw Park      | Ayr                    | ?                      | ?                      | ?                      | ?                      | KA7 2TJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018043 |





    # Change the date
    Given the override date is '01/03/2024'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'MLT-043'
    And   there are no details in ContractManagement.CreatedContract for 'MLT-043'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018043 | 10018043 Co Ltd      | ESFA-043             | MLT-043        | 1                     | 01/04/2024        | 31/03/2025      | 18300.00      |                                       | Contract for Services                      | 2425   | New          | ORG0018043 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018043 | MLT-043        | MULT-043      | MULT              | MULT2425                | FY                      | 01/04/2024          | 31/03/2025        | 18300.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | DeliverableDescription                                                          | CRMIntent    | DeliveryOrg |
    | 10018043 | MLT-043        | MULT-043      | 1               | 0                     | 18300.00  | 1460.00  | 773.00   | 116.00   | 1104.00  | 1840.00  | 615.00   | 590.00   | 3382.00  | 2409.00  | 645.00   | 2236.00  | 3130.00  | Multiply                                                                        | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'MLT-043'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-043' and ContractNumber 'MLT-043' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'MLT-043' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018043 | MLT-043            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2024        | 31/03/2025      | ?             |
    | 10018043 | ESFA-043           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2024        | 31/03/2025      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'MLT-043' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'MLT-043'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | MULT-043        | 101085           | Mar-23 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                                     | DeliverableDescription                                      | 
    | 10018043 | MLT-043        | 1               | MULT-043      | 1               | 0                     | 18300.00     | 0             | 0        | Multiply                                                                            | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'MLT-043' agree with the most recent entry for this contract in the ContractManagement feed


    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check Planned data on the ADP feed
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Planned data
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume |
    | NewContractAllocationApproved     | MLT-043            | 1             | MULT-043         | 1               | 202404 | 1460.00      | 0             |
    | NewContractAllocationApproved     | MLT-043            | 1             | MULT-043         | 1               | 202405 | 773.00       | 0             |
    | NewContractAllocationApproved     | MLT-043            | 1             | MULT-043         | 1               | 202406 | 116.00       | 0             |
    | NewContractAllocationApproved     | MLT-043            | 1             | MULT-043         | 1               | 202407 | 1104.00      | 0             |
    | NewContractAllocationApproved     | MLT-043            | 1             | MULT-043         | 1               | 202408 | 1840.00      | 0             |
    | NewContractAllocationApproved     | MLT-043            | 1             | MULT-043         | 1               | 202409 | 615.00       | 0             |
    | NewContractAllocationApproved     | MLT-043            | 1             | MULT-043         | 1               | 202410 | 590.00       | 0             |
    | NewContractAllocationApproved     | MLT-043            | 1             | MULT-043         | 1               | 202411 | 3382.00      | 0             |
    | NewContractAllocationApproved     | MLT-043            | 1             | MULT-043         | 1               | 202412 | 2409.00      | 0             |
    | NewContractAllocationApproved     | MLT-043            | 1             | MULT-043         | 1               | 202501 | 645.00       | 0             |
    | NewContractAllocationApproved     | MLT-043            | 1             | MULT-043         | 1               | 202502 | 2236.00      | 0             |
    | NewContractAllocationApproved     | MLT-043            | 1             | MULT-043         | 1               | 202503 | 3130.00      | 0             |





    # Bulk variation amendment
    
    # Change the date
    Given the override date is '23/08/2022'

    # Bulk file to amend contract and reduce funding to £0 during Apr-Aug
    And   there are no files prefixed '10018043' in the Sharepoint 'MULT-2425-Input-Appendices' folder
    And   there are no files prefixed 'MULT FY 2425 01022024123903 v3_S043' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MULT FY 2425 01022024123903 v3_S043' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MULT FY 2425 01022024123903 v3_S043' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MULT FY 2425 01022024123903 v3_S043' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MULT FY 2425 01022024123903 v3_S043.xlsx' exists in the Datafiles folder and UKPRN '10018043' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10018043' for FundingType 'MULT' and period '2425' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10018043' for FundingType 'MULT' and period '2425'

    # Check the contents of the Appendices
    Then  the file named '10018043_MLT-043_v2.pdf' in Sharepoint location 'MULT-2425-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10018043 Co Ltd UKPRN: 10018043
    Master Contract Number: ESFA-043 Start Date: 01/04/2024 End Date: 31/03/2025
    Contract Ref: MULT-043
    Cash (£) Apr 2024 May 2024 Jun 2024 Jul 2024 Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025
    Multiply £36,000 £0 £0 £0 £0 £0 £8,462 £3,585 £5,122 £2,534 £2,481 £7,428 £6,388
    Total Funding £36,000 £0 £0 £0 £0 £0 £8,462 £3,585 £5,122 £2,534 £2,481 £7,428 £6,388
    Multiply – MULT-043 – Page 1 Ref (for internal use only):  MLT-043 v2
    """

 #  # There should not be a ...
 #  And   the pdf file does not contain the following text
 #  """
 #  Blah Blah 
 #  """


    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'MLT-043'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-043' and ContractNumber 'MLT-043' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract 'MLT-043' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018043 | MLT-043            | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2024        | 31/03/2025      | Variation     |
    | 10018043 | MLT-043            | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/04/2024        | 31/03/2025      | ?             |
    | 10018043 | ESFA-043           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2024        | 31/03/2025      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'MLT-043' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'MLT-043'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | MULT-043        | 101085           | Mar-23 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                                     | DeliverableDescription                                      | 
    | 10018043 | MLT-043        | 2               | MULT-043      | 1               | 0                     | 36000.00     | 0             | 0        | Multiply                                                                            | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'MLT-043' agree with the most recent entry for this contract in the ContractManagement feed


    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check Planned data on the ADP feed
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Planned data
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume |
    | AmendedContractAllocationApproved | MLT-043            | 2             | MULT-043         | 1               | 202404 | 0.00         | 0             |
    | AmendedContractAllocationApproved | MLT-043            | 2             | MULT-043         | 1               | 202405 | 0.00         | 0             |
    | AmendedContractAllocationApproved | MLT-043            | 2             | MULT-043         | 1               | 202406 | 0.00         | 0             |
    | AmendedContractAllocationApproved | MLT-043            | 2             | MULT-043         | 1               | 202407 | 0.00         | 0             |
    | AmendedContractAllocationApproved | MLT-043            | 2             | MULT-043         | 1               | 202408 | 0.00         | 0             |
    | AmendedContractAllocationApproved | MLT-043            | 2             | MULT-043         | 1               | 202409 | 8462.00      | 0             |
    | AmendedContractAllocationApproved | MLT-043            | 2             | MULT-043         | 1               | 202410 | 3585.00      | 0             |
    | AmendedContractAllocationApproved | MLT-043            | 2             | MULT-043         | 1               | 202411 | 5122.00      | 0             |
    | AmendedContractAllocationApproved | MLT-043            | 2             | MULT-043         | 1               | 202412 | 2534.00      | 0             |
    | AmendedContractAllocationApproved | MLT-043            | 2             | MULT-043         | 1               | 202501 | 2481.00      | 0             |
    | AmendedContractAllocationApproved | MLT-043            | 2             | MULT-043         | 1               | 202502 | 7428.00      | 0             |
    | AmendedContractAllocationApproved | MLT-043            | 2             | MULT-043         | 1               | 202503 | 6388.00      | 0             |



    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
    | MLT-043        | MULT-043           | 1               | 36000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8462.00  | 3585.00  | 5122.00  | 2534.00  | 2481.00  | 7428.00  | 6388.00  | 
#
#    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
#    And   the Profile Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
#    | MLT-043        | MULT-043           | 1               | 41293.00  | 1460.00  | 773.00   | 116.00   | 1104.00  | 1840.00  | 8462.00  | 3585.00  | 5122.00  | 2534.00  | 2481.00  | 7428.00  | 6388.00  | 
#
#   # Check the BALANCING PAYMENTS in CRM on the latest approved contract
#    And   the Balancing Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
#    | MLT-043        | MULT-043           | 1               | -5293.00  | 0.00     | ?        | ?        | ?        | ?        | -5293.00 | ?        | ?        | ?        | ?        | ?        | ?        | 
#
#    # Check the NET AMOUNTS in CRM on the latest approved contract
#    And   the Net Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
#    | MLT-043        | MULT-043           | 1               | 36000.00  | 1460.00  | 773.00   | 116.00   | 1104.00  | 1840.00  | 3169.00  | 3585.00  | 5122.00  | 2534.00  | 2481.00  | 7428.00  | 6388.00  | 
#
#
#    # Check the PROFILE subnominal aggregations in CRM
#    And   the Profile Subnominal Amounts are calculated as follows
#     | UKPRN    | ContractNumber | AllocationRef  | ProfileSubnominal    | Apr-24    | May-24    | Jun-24    | Jul-24    | Aug-24    | Sep-24    | Oct-24    | Nov-24    | Dec-24   |  Jan-25    | Feb-25    | Mar-25   |
#    | 10018043 | MLT-043        | MULT-043       | 101085               | 1460.00   | 773.00    | 116.00    | 1104.00   | 1840.00   | 3169.00   | 3585.00   | 5122.00   | 2534.00   | 2481.00   | 7428.00   | 6388.00   | 



#
#
#    # Payment Batch for MULT2425(PoP)
#
#    # Change the date
#    Given the override date is '03/09/2024 22:05'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod 'MULT2425' AccountingPaymentPeriod '202406' CensusEndDate '03/09/2024' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | MULT-043                 | 202409 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | MULT2425                   | 202409               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | MULT2425                   | 202409               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'MULT2425' PaymentPeriod '202406' CensusEndDate '03/09/2024' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S043.xml'
#
##    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
##    And   the Payment feed xml for FundingStreamPeriod 'MULT2425' PaymentPeriod '202206' CensusEndDate '02/09/2022' and LinkCodeSuffix 'A' includes the following values
##    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
##    | MULT                   | 2024          | 06             | 03          | ?       | MULT-043          | 3169.00         | PROFILE          | Multiply                           | 2022-09-16 | 2022-04-01   | 2023-03-31 | ?              | 10018043 | 101085     |
##
#
#


    # Payment Batch for MULT2425(PoP)

    # Change the date
    Given the override date is '04/08/2025 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'MULT2425' AccountingPaymentPeriod '202505' CensusEndDate '04/08/2025' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    #And   the following allocation periods are present in the subnominal aggregation PaaS table
    #| ContractAllocationNumber | Period |
    #| MULT-043                 | 202508 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | MULT2425                   | 202508               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | MULT2425                   | 202508               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'MULT2425' PaymentPeriod '202505' CensusEndDate '04/08/2025' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S043.xml'

#    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'MULT2425' PaymentPeriod '202206' CensusEndDate '02/09/2022' and LinkCodeSuffix 'A' includes the following values
#    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    | MULT                   | 2024          | 06             | 03          | ?       | MULT-043          | 3169.00         | PROFILE          | Multiply                           | 2022-09-16 | 2022-04-01   | 2023-03-31 | ?              | 10018043 | 101085     |
#




    # Create Consolidated Payment Summary rpt
   
    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    When a Consolidated Payment Summary Report is created in Sharepoint for '12/08/2025'
    
    # Copy\Save a named Sharepoint file to a named folder\filename
 #  And  Sharepoint file '2024-09 Payments.xlsx' in 'Consolidated Payment Summary' is copied to 'Datafiles/Downloads' as 'S043_CPSR.xlsx'
    
    # Check the above report manually


    # Tidy Up
    Given the override date is reset
   
