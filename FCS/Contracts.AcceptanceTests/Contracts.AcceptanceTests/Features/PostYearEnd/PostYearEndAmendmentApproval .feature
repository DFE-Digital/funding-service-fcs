Feature: PostYearEndAmendmentApproval 

@AcceptanceTest @Withdrawn20231002
@ADP
Scenario: A028 Create and approve a AEBC-19TRN1920 (PoP) EDSK contract. Bulk amend and approve in the post-year-end period. Check CRM financials
    Given there are no allocations marked as Under Termination for UKPRN '10017028' 
    And   there are no terminated or closed allocations for UKPRN '10017028' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017028' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017028' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECT-028      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECT-028      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-19TRN1920    |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017028' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017028 Co Ltd' with UKPRN '10017028' and OrgId 'ORG0017028' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017028' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017028 | 117028 | 10017028 Co Ltd | 0              | Active                | Yes           | AA017028      | ?             | 4 St John's Court      | Moulsham Street        | ?                      | ?                      | Chelmsford             | Essex                  | CM2 0JD   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017028 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                         | Period | CRMIntent    | OrgId      |
    | 10017028 | 10017028 Co Ltd      | ESFA-028             | EDSK-028       | 1                     | 01/08/2019        | 31/07/2020      | 23871.00      |                                       | Conditions of Funding (Grant) (HEI)  | 1920   | New          | ORG0017028 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017028 | EDSK-028       | AECT-028      | AEBC-19TRN        | AEBC-19TRN1920          | AY                      | 01/08/2019          | 31/07/2020        | 23871.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription               | CRMIntent    | DeliveryOrg |
    | 10017028 | EDSK-028       | AECT-028      | 1               | 0                     | 23871.00  | 17358.00  | 6513.00   | 2274.00  | 3420.00  | 2699.00  | 2897.00  | 2304.00  | 382.00   | 2447.00  | 935.00   | 787.00   | 3198.00  | 2383.00  | 145.00   | 19-24 Traineeships Total Funding     | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '23/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-028' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-028'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-028' and actual ContractNumber 'EDSK-028'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-028' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017028 | EDSK-028           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017028 | ESFA-028           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables (3x12)
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'EDSK-028'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type |
    | AECT-028      | 2355700          | Jul-20 | Profile      |


    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    Then  the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-028       | AECT-028           | 1               | 23871.00  | 2274.00  | 3420.00  | 2699.00  | 2897.00  | 2304.00  | 382.00   | 2447.00  | 935.00   | 787.00   | 3198.00  | 2383.00  | 145.00   | 
    | EDSK-028       | AECT-028           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-028       | AECT-028           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-028       | AECT-028           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-028       | AECT-028           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-028       | AECT-028           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | 
    | EDSK-028       | AECT-028           | 1               | 28298.00  | 2274.00  | 3420.00  | 2699.00  | 2897.00  | 2304.00  | 382.00   | 2447.00  | 935.00   | 787.00   | 3198.00  | 2383.00  | 145.00   |  
    | EDSK-028       | AECT-028           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |  
    | EDSK-028       | AECT-028           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |  

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-028       | AECT-028           | 1               | 23871.00  | 2274.00  | 3420.00  | 2699.00  | 2897.00  | 2304.00  | 382.00   | 2447.00  | 935.00   | 787.00   | 3198.00  | 2383.00  | 145.00   | 
    | EDSK-028       | AECT-028           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-028       | AECT-028           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 




    # Bulk amend 

    # Change the date
    Given the override date is '18/10/2020'

    # Bulk file (Profile increases from £23,871 to £28,298)
    And   there are no files prefixed '10017028' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 01042020151809 v3_A028' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 1920 01042020151809 v3_A028' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 01042020151809 v3_A028' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 01042020151809 v3_A028' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 01042020151809 v3_A028.xlsx' exists in the Datafiles folder and UKPRN '10017028' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

	# Change the date
    Given the override date is '20/10/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-028'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-028' and actual ContractNumber 'EDSK-028'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-028' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017028 | EDSK-028           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017028 | EDSK-028           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017028 | ESFA-028           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
	
    # Check the deliverable count in CRM includes all the monitoring deliverables (3x13)
    And   there are '39' deliverable period rows in CRM linked to the latest version of contract 'EDSK-028'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type |
    | AECT-028      | 2355700          | Nov-20 | Profile      |



    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Nov-20   |
    | EDSK-028       | AECT-028           | 1               | 23871.00  | 2274.00  | 3420.00  | 2699.00  | 2897.00  | 2304.00  | 382.00   | 2447.00  | 935.00   | 787.00   | 3198.00  | 2383.00  | 145.00   | 0.00     | 
    | EDSK-028       | AECT-028           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-028       | AECT-028           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Nov-20   |
    | EDSK-028       | AECT-028           | 1               | 4427.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4427.00  | 
    | EDSK-028       | AECT-028           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-028       | AECT-028           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Nov-20   |
    | EDSK-028       | AECT-028           | 1               | 28298.00  | 2274.00  | 3420.00  | 2699.00  | 2897.00  | 2304.00  | 382.00   | 2447.00  | 935.00   | 787.00   | 3198.00  | 2383.00  | 145.00   | 4427.00  | 
    | EDSK-028       | AECT-028           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-028       | AECT-028           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Nov-20   |
    | EDSK-028       | AECT-028           | 1               | 28298.00  | 3626.00  | 1603.00  | 2794.00  | 1269.00  | 1858.00  | 1981.00  | 1611.00  | 1930.00  | 1877.00  | 4923.00  | 2832.00  | 1994.00  | 0.00     | 
    | EDSK-028       | AECT-028           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-028       | AECT-028           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 





    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check that certain entries have not been written to the AllocationDelivery.AllocationDeliveryEntry table
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '2' event for version '2' of contract number 'EDSK-028' and allocation number 'AECT-028'
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '3' event for version '2' of contract number 'EDSK-028' and allocation number 'AECT-028'
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '4' event for version '2' of contract number 'EDSK-028' and allocation number 'AECT-028'


    # Check that the relevant events are on the ADP feed
    Then  the ADP feed includes the following values
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber     | ContractVersionNumber | SubVersionNumber | AllocationNumber | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    | NewContractAllocationApproved     | 0      | EDSK-028           | 1                     | 0                | AECT-028         | ?                         | ?                            |
    | AmendedContractAllocationApproved | 1      | EDSK-028           | 2                     | 0                | AECT-028         | ?                         | ?                            |


    # Check the ADP feed event header information
    And   the Allocation Delivery feed includes the following event information
    | UKPRN    | ContractNumber     | ContractVersion | ContractSubVersion | CategoryTerm                        | CategoryLabel                        | Title                                                                               |
    | 10017028 | EDSK-028           | 1               | 0                  | NewContractAllocationApproved       | New Contract Allocation Approved     | New Contract EDSK-028: 1.0 with Allocation AECT-028 was Approved                    |
    | 10017028 | EDSK-028           | 2               | 0                  | AmendedContractAllocationApproved   | Amended Contract Allocation Approved | Amendment to Contract EDSK-028: 2.0 with Allocation AECT-028 was Approved           |


    # Check financials on the ADP feed
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 201908 | ?           | 2274.00        | 0.00             | 0.00                  | 0.00           | 2274.00    |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 201909 | ?           | 3420.00        | 0.00             | 0.00                  | 0.00           | 3420.00    |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 201910 | ?           | 2699.00        | 0.00             | 0.00                  | 0.00           | 2699.00    |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 201911 | ?           | 2897.00        | 0.00             | 0.00                  | 0.00           | 2897.00    |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 201912 | ?           | 2304.00        | 0.00             | 0.00                  | 0.00           | 2304.00    |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 202001 | ?           | 382.00         | 0.00             | 0.00                  | 0.00           | 382.00     |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 202002 | ?           | 2447.00        | 0.00             | 0.00                  | 0.00           | 2447.00    |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 202003 | ?           | 935.00         | 0.00             | 0.00                  | 0.00           | 935.00     |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 202004 | ?           | 787.00         | 0.00             | 0.00                  | 0.00           | 787.00     |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 202005 | ?           | 3198.00        | 0.00             | 0.00                  | 0.00           | 3198.00    |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 202006 | ?           | 2383.00        | 0.00             | 0.00                  | 0.00           | 2383.00    |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 202007 | ?           | 145.00         | 0.00             | 0.00                  | 0.00           | 145.00     |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 202011 | ?           | 0.00           | 4427.00          | 0.00                  | 0.00           | 4427.00    |
    #
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 2               | 201908 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 2               | 201909 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 2               | 201910 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 2               | 201911 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 2               | 201912 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 2               | 202001 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 2               | 202002 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 2               | 202003 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 2               | 202004 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 2               | 202005 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 2               | 202006 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 2               | 202007 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 2               | 202011 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 3               | 201908 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 3               | 201909 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 3               | 201910 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 3               | 201911 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 3               | 201912 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 3               | 202001 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 3               | 202002 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 3               | 202003 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 3               | 202004 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 3               | 202005 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 3               | 202006 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 3               | 202007 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 3               | 202011 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |


    # Check Planned data on the ADP feed
    And   the Allocation Delivery Monitoring Service atom feed contains the following Planned data
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 201908 | 3626.00      | 0             |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 201909 | 1603.00      | 0             |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 201910 | 2794.00      | 0             |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 201911 | 1269.00      | 0             |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 201912 | 1858.00      | 0             |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 202001 | 1981.00      | 0             |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 202002 | 1611.00      | 0             |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 202003 | 1930.00      | 0             |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 202004 | 1877.00      | 0             |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 202005 | 4923.00      | 0             |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 202006 | 2832.00      | 0             |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 202007 | 1994.00      | 0             |
    | AmendedContractAllocationApproved | EDSK-028           | 2             | AECT-028         | 1               | 202011 | 0.00         | 0             |




    # Tidy Up
	And   the override date is reset
	 
@AcceptanceTest @InProgress
Scenario: A029 Create and approve an APPS1920 (PoA) EDSK contract. Consume actuals in Jun-20 (in-year) and Oct-20 (post-year-end). Check CRM financials
    Given there are no allocations marked as Under Termination for UKPRN '10017029' 
    And   there are no terminated or closed allocations for UKPRN '10017029' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017029' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017029' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | APPS-029      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | APPS-029      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | APPS1920          |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017029' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017029 Co Ltd' with UKPRN '10017029' and OrgId 'ORG0017029' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017029' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017029 | 117029 | 10017029 Co Ltd | 0              | Active                | Yes           | AA017029      | ?             | 32 Chobham Road        | Knaphill               | Woking                 | Surrey                 | ?                      | ?                      | GU21 2SX  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017029 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017029 | 10017029 Co Ltd      | ESFA-029             | EDSK-029       | 1                     | 01/08/2019        | 31/07/2020      | 23199.00      |                                       | Conditions of Funding (Grant) (LA)         | 1920   | New          | ORG0017029 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017029 | EDSK-029       | APPS-029      | APPS              | APPS1920                | AY                      | 01/08/2019          | 31/07/2020        | 23199.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017029 | EDSK-029       | APPS-029      | 1               | 0                     | 23199.00  | 16973.00  | 6226.00   | 1363.00  | 2351.00  | 3087.00  | 1861.00  | 1837.00  | 928.00   | 3655.00  | 1891.00  | 3482.00  | 676.00   | 1694.00  | 374.00   | Apprenticeships Carry-In Total Funding                          | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-029' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-029'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-029' and actual ContractNumber 'EDSK-029'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-029' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017029 | EDSK-029           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017029 | ESFA-029           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '288' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '288' deliverable period rows in CRM linked to the latest version of contract 'EDSK-029'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | APPS-029      | 2240100          | Jul-20 | Reconciliation |	  
	| APPS-029      | 2340160          | Jul-20 | Capping        |




    # Add actuals to the contract (In-year)

    # Change the date
    Given the override date is '04/07/2020'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017029'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jun 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS38               | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 814.15      |
    | APPS           | APPS38               | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 352.49      |
    | APPS           | APPS38               | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 827.16      |
    | APPS           | APPS38               | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 996.54      |
    | APPS           | APPS38               | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 520.78      |
    | APPS           | APPS38               | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 1413.42     |
    | APPS           | APPS38               | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 251.98      |
    | APPS           | APPS38               | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 849.37      |
    | APPS           | APPS38               | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 1330.42     |
    | APPS           | APPS38               | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 1030.16     |
    | APPS           | APPS38               | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 1214.79     |
    | APPS           | APPS38               | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 271.83      |
    | APPS           | APPS38               | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 680.35      |
    | APPS           | APPS38               | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 678.35      |
    | APPS           | APPS38               | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 1126.22     |
    | APPS           | APPS38               | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 119.54      |
    | APPS           | APPS38               | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 1341.28     |
    | APPS           | APPS38               | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 1233.42     |
    | APPS           | APPS38               | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 597.47      |
    | APPS           | APPS38               | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 1446.35     |
    | APPS           | APPS38               | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 1289.16     |
    | APPS           | APPS38               | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 1154.98     |
    | APPS           | APPS38               | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 487.25      |
    | APPS           | APPS38               | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 363.69      |
    | APPS           | APPS38               | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 727.09      |
    | APPS           | APPS38               | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 621.18      |
    | APPS           | APPS38               | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 698.55      |
    | APPS           | APPS38               | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 1450.05     |
    | APPS           | APPS38               | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 1057.24     |
    | APPS           | APPS38               | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 413.12      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 725.61      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 710.23      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 1402.62     |
    | APPS           | APPS38               | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 1149.20     |
    | APPS           | APPS38               | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 550.73      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 1084.81     |
    | APPS           | APPS38               | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 1079.05     |
    | APPS           | APPS38               | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 1469.49     |
    | APPS           | APPS38               | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 491.20      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 309.45      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 1016.97     |
    | APPS           | APPS38               | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 770.10      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 1396.12     |
    | APPS           | APPS38               | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 124.34      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 1333.38     |
    | APPS           | APPS38               | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 887.63      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 993.30      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 433.52      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 653.65      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 1133.42     |
    | APPS           | APPS38               | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 386.16      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 814.27      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 1383.43     |
    | APPS           | APPS38               | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 678.01      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 1100.56     |
    | APPS           | APPS38               | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 976.49      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 1330.52     |
    | APPS           | APPS38               | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 1285.52     |
    | APPS           | APPS38               | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 1081.71     |
    | APPS           | APPS38               | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 172.06      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 1076.75     |
    | APPS           | APPS38               | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 597.96      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 841.01      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 1154.26     |
    | APPS           | APPS38               | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 499.83      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 1169.68     |
    | APPS           | APPS38               | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 152.97      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 487.08      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 1245.27     |
    | APPS           | APPS38               | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 251.67      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 702.05      |
    | APPS           | APPS38               | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 204.63      |
    #
	| ILR1920        | R11                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 1148.21     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 926.02      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 679.54      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 220.55      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 205.30      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 1190.22     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 930.46      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 887.29      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 1296.64     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 191.56      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 250.38      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 305.58      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 1457.54     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 611.55      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 832.38      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 383.75      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 300.49      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 200.20      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 1463.84     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 647.15      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 387.02      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 460.49      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 873.36      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 797.46      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 949.53      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 282.68      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 1427.62     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 822.12      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 363.20      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 1128.74     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 578.28      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 1453.69     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 367.86      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 1366.66     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 858.82      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 779.21      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 839.87      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 754.87      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 631.43      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 999.61      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 513.98      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 1076.62     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 583.89      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 139.03      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 855.23      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 124.33      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 776.46      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 904.26      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 480.77      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 1433.98     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 838.70      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 294.06      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 1131.82     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 569.45      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 516.39      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 558.58      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 1395.47     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 1156.97     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 568.43      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 908.67      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 576.59      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 469.42      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 1213.64     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 775.34      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 119.69      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 560.75      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 927.69      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 619.07      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 1180.84     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 150.32      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 1189.97     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 289.21      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 1149.46     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 857.33      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 380.44      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 533.37      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 320.25      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 1185.11     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 626.54      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 656.75      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 515.10      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 655.58      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 1000.03     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 731.56      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 1254.90     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 1493.60     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 863.88      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 1356.37     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 481.40      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 861.29      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 769.15      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 965.49      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 1229.19     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 242.48      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 901.88      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 488.35      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 447.46      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 1177.07     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 1279.92     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 1358.88     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 571.95      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 1345.35     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 899.83      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 1074.87     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 446.78      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 802.44      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 1433.78     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 307.35      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 596.36      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 162.63      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 1476.38     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 559.97      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 447.24      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 533.79      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 941.58      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 778.38      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 1499.99     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 1001.68     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 209.55      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 1309.58     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 1051.07     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 664.38      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 1023.54     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 1211.32     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 264.74      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 1016.67     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 736.75      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 111.46      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 1394.91     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 284.35      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 909.24      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 417.39      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 1156.96     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 708.68      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 854.76      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 1475.33     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 1249.74     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 780.71      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 1337.66     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 1079.72     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 1027.31     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 425.66      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 219.72      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 132.67      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 320.92      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 937.34      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 1057.11     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 653.27      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 1210.85     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 1062.45     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 1047.17     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 1336.96     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 348.23      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 435.00      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 325.33      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 464.91      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 1227.02     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 560.72      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 412.00      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 563.44      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 205.77      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 551.35      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 209.41      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 813.36      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 879.62      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 209.07      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 748.51      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 1009.32     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 802.05      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 660.88      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 485.81      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 269.22      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 956.84      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 1142.94     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 750.32      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 293.61      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 179.91      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 334.97      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 340.36      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 574.99      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 1131.24     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 844.65      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 270.48      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 957.25      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 1216.64     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 1441.92     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 468.29      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 345.01      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 659.74      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 843.40      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 1021.39     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 1363.03     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 1123.83     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 446.81      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 974.19      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 1365.53     |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 483.67      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 415.27      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 274.82      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 595.60      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 547.47      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 311.70      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 672.01      |
    | ILR1920        | R11                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 894.62      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check MonitoringDeliverables.HeldReportedActualGroup (Only used for APPS contracts) Is the data showing as unprocessed ?
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS1920' OrgId 'ORG0017029' and Collection 'R11' marked as unprocessed
    And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS1920' OrgId 'ORG0017029' and Collection 'APPS38' marked as unprocessed

    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    When  MonthEnd processing has completed and the processing of held data is triggered



    # Check CRM 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-029       | APPS-029           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-029       | APPS-029           | 2               | 9555.69   | 1148.21  | 200.20   | 858.82   | 294.06   | 1180.84  | 1493.60  | 899.83   | 1309.58  | 1249.74  | 435.00   | 485.81   | ?        | 
    | EDSK-029       | APPS-029           | 3               | 8816.29   | 926.02   | 1463.84  | 779.21   | 1131.82  | 150.32   | 863.88   | 1074.87  | 1051.07  | 780.71   | 325.33   | 269.22   | ?        | 
    | EDSK-029       | APPS-029           | 4               | 9152.92   | 679.54   | 647.15   | 839.87   | 569.45   | 1189.97  | 1356.37  | 446.78   | 664.38   | 1337.66  | 464.91   | 956.84   | ?        | 
    | EDSK-029       | APPS-029           | 5               | 7925.10   | 220.55   | 387.02   | 754.87   | 516.39   | 289.21   | 481.40   | 802.44   | 1023.54  | 1079.72  | 1227.02  | 1142.94  | ?        | 
    | EDSK-029       | APPS-029           | 6               | 8850.00   | 205.30   | 460.49   | 631.43   | 558.58   | 1149.46  | 861.29   | 1433.78  | 1211.32  | 1027.31  | 560.72   | 750.32   | ?        | 
    | EDSK-029       | APPS-029           | 7               | 7788.50   | 1190.22  | 873.36   | 999.61   | 1395.47  | 857.33   | 769.15   | 307.35   | 264.74   | 425.66   | 412.00   | 293.61   | ?        | 
    | EDSK-029       | APPS-029           | 8               | 9102.78   | 814.15   | 251.98   | 680.35   | 597.47   | 727.09   | 725.61   | 1079.05  | 1396.12  | 653.65   | 1100.56  | 1076.75  | ?        | 
    | EDSK-029       | APPS-029           | 9               | 8959.67   | 352.49   | 849.37   | 678.35   | 1446.35  | 621.18   | 710.23   | 1469.49  | 124.34   | 1133.42  | 976.49   | 597.96   | ?        | 
    | EDSK-029       | APPS-029           | 10              | 11056.40  | 827.16   | 1330.42  | 1126.22  | 1289.16  | 698.55   | 1402.62  | 491.20   | 1333.38  | 386.16   | 1330.52  | 841.01   | ?        | 
    | EDSK-029       | APPS-029           | 11              | 7320.90   | 930.46   | 797.46   | 513.98   | 1156.97  | 380.44   | 965.49   | 596.36   | 1016.67  | 219.72   | 563.44   | 179.91   | ?        | 
    | EDSK-029       | APPS-029           | 12              | 6817.22   | 887.29   | 949.53   | 1076.62  | 568.43   | 533.37   | 1229.19  | 162.63   | 736.75   | 132.67   | 205.77   | 334.97   | ?        | 
    | EDSK-029       | APPS-029           | 13              | 6435.08   | 1296.64  | 282.68   | 583.89   | 908.67   | 320.25   | 242.48   | 1476.38  | 111.46   | 320.92   | 551.35   | 340.36   | ?        | 
    | EDSK-029       | APPS-029           | 14              | 8098.41   | 191.56   | 1427.62  | 139.03   | 576.59   | 1185.11  | 901.88   | 559.97   | 1394.91  | 937.34   | 209.41   | 574.99   | ?        | 
    | EDSK-029       | APPS-029           | 15              | 7245.34   | 250.38   | 822.12   | 855.23   | 469.42   | 626.54   | 488.35   | 447.24   | 284.35   | 1057.11  | 813.36   | 1131.24  | ?        | 
    | EDSK-029       | APPS-029           | 16              | 6931.53   | 305.58   | 363.20   | 124.33   | 1213.64  | 656.75   | 447.46   | 533.79   | 909.24   | 653.27   | 879.62   | 844.65   | ?        | 
    | EDSK-029       | APPS-029           | 17              | 8879.62   | 1457.54  | 1128.74  | 776.46   | 775.34   | 515.10   | 1177.07  | 941.58   | 417.39   | 1210.85  | 209.07   | 270.48   | ?        | 
    | EDSK-029       | APPS-029           | 18              | 8852.83   | 611.55   | 578.28   | 904.26   | 119.69   | 655.58   | 1279.92  | 778.38   | 1156.96  | 1062.45  | 748.51   | 957.25   | ?        | 
    | EDSK-029       | APPS-029           | 19              | 11168.30  | 832.38   | 1453.69  | 480.77   | 560.75   | 1000.03  | 1358.88  | 1499.99  | 708.68   | 1047.17  | 1009.32  | 1216.64  | ?        | 
    | EDSK-029       | APPS-029           | 20              | 9854.16   | 383.75   | 367.86   | 1433.98  | 927.69   | 731.56   | 571.95   | 1001.68  | 854.76   | 1336.96  | 802.05   | 1441.92  | ?        | 
    | EDSK-029       | APPS-029           | 21              | 8887.45   | 300.49   | 1366.66  | 838.70   | 619.07   | 1254.90  | 1345.35  | 209.55   | 1475.33  | 348.23   | 660.88   | 468.29   | ?        | 
    | EDSK-029       | APPS-029           | 22              | 10351.60  | 996.54   | 1030.16  | 119.54   | 1154.98  | 1450.05  | 1149.20  | 309.45   | 887.63   | 814.27   | 1285.52  | 1154.26  | ?        | 
    | EDSK-029       | APPS-029           | 23              | 10147.31  | 520.78   | 1214.79  | 1341.28  | 487.25   | 1057.24  | 550.73   | 1016.97  | 993.30   | 1383.43  | 1081.71  | 499.83   | ?        | 
    | EDSK-029       | APPS-029           | 24              | 8003.66   | 1413.42  | 271.83   | 1233.42  | 363.69   | 413.12   | 1084.81  | 770.10   | 433.52   | 678.01   | 172.06   | 1169.68  | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Jul-20   |
    | EDSK-029       | APPS-029           | 1               | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 2               | 9555.69   | 9555.69  | 0.00     | 
    | EDSK-029       | APPS-029           | 3               | 8816.29   | 8816.29  | 0.00     | 
    | EDSK-029       | APPS-029           | 4               | 9152.92   | 9152.92  | 0.00     | 
    | EDSK-029       | APPS-029           | 5               | 7925.10   | 7925.10  | 0.00     | 
    | EDSK-029       | APPS-029           | 6               | 8850.00   | 8850.00  | 0.00     | 
    | EDSK-029       | APPS-029           | 7               | 7788.50   | 7788.50  | 0.00     | 
    | EDSK-029       | APPS-029           | 8               | 9102.78   | 9102.78  | 0.00     | 
    | EDSK-029       | APPS-029           | 9               | 8959.67   | 8959.67  | 0.00     | 
    | EDSK-029       | APPS-029           | 10              | 11056.40  | 11056.40 | 0.00     | 
    | EDSK-029       | APPS-029           | 11              | 7320.90   | 7320.90  | 0.00     | 
    | EDSK-029       | APPS-029           | 12              | 6817.22   | 6817.22  | 0.00     | 
    | EDSK-029       | APPS-029           | 13              | 6435.08   | 6435.08  | 0.00     | 
    | EDSK-029       | APPS-029           | 14              | 8098.41   | 8098.41  | 0.00     | 
    | EDSK-029       | APPS-029           | 15              | 7245.34   | 7245.34  | 0.00     | 
    | EDSK-029       | APPS-029           | 16              | 6931.53   | 6931.53  | 0.00     | 
    | EDSK-029       | APPS-029           | 17              | 8879.62   | 8879.62  | 0.00     | 
    | EDSK-029       | APPS-029           | 18              | 8852.83   | 8852.83  | 0.00     | 
    | EDSK-029       | APPS-029           | 19              | 11168.30  | 11168.30 | 0.00     | 
    | EDSK-029       | APPS-029           | 20              | 9854.16   | 9854.16  | 0.00     | 
    | EDSK-029       | APPS-029           | 21              | 8887.45   | 8887.45  | 0.00     | 
    | EDSK-029       | APPS-029           | 22              | 10351.60  | 10351.60 | 0.00     | 
    | EDSK-029       | APPS-029           | 23              | 10147.31  | 10147.31 | 0.00     | 
    | EDSK-029       | APPS-029           | 24              | 8003.66   | 8003.66  | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Jul-20   |
    | EDSK-029       | APPS-029           | 1               | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 2               | -9555.69  | -9555.69 | 0.00     | 
    | EDSK-029       | APPS-029           | 3               | -8816.29  | -8816.29 | 0.00     | 
    | EDSK-029       | APPS-029           | 4               | -9152.92  | -9152.92 | 0.00     | 
    | EDSK-029       | APPS-029           | 5               | -7925.10  | -7925.10 | 0.00     | 
    | EDSK-029       | APPS-029           | 6               | -8850.00  | -8850.00 | 0.00     | 
    | EDSK-029       | APPS-029           | 7               | -3818.50  | -3818.50 | 0.00     | 
    | EDSK-029       | APPS-029           | 8               | -9102.78  | -9102.78 | 0.00     | 
    | EDSK-029       | APPS-029           | 9               | -8959.67  | -8959.67 | 0.00     | 
    | EDSK-029       | APPS-029           | 10              | -5291.80  | -5291.80 | 0.00     | 
    | EDSK-029       | APPS-029           | 11              | -7320.90  | -7320.90 | 0.00     | 
    | EDSK-029       | APPS-029           | 12              | -6817.22  | -6817.22 | 0.00     | 
    | EDSK-029       | APPS-029           | 13              | -6435.08  | -6435.08 | 0.00     | 
    | EDSK-029       | APPS-029           | 14              | -8098.41  | -8098.41 | 0.00     | 
    | EDSK-029       | APPS-029           | 15              | -7245.34  | -7245.34 | 0.00     | 
    | EDSK-029       | APPS-029           | 16              | -6931.53  | -6931.53 | 0.00     | 
    | EDSK-029       | APPS-029           | 17              | -8879.62  | -8879.62 | 0.00     | 
    | EDSK-029       | APPS-029           | 18              | -4139.60  | -4139.60 | 0.00     | 
    | EDSK-029       | APPS-029           | 19              | -11168.30 | -11168.30| 0.00     | 
    | EDSK-029       | APPS-029           | 20              | -9854.16  | -9854.16 | 0.00     | 
    | EDSK-029       | APPS-029           | 21              | -4332.03  | -4332.03 | 0.00     | 
    | EDSK-029       | APPS-029           | 22              | -10351.60 | -10351.60| 0.00     | 
    | EDSK-029       | APPS-029           | 23              | -10147.31 | -10147.31| 0.00     | 
    | EDSK-029       | APPS-029           | 24              | -3807.92  | -3807.92 | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Jul-20   |
    | EDSK-029       | APPS-029           | 1               | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 2               | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 3               | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 4               | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 5               | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 6               | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 7               | 3970.00   | 3970.00  | 0.00     | 
    | EDSK-029       | APPS-029           | 8               | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 9               | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 10              | 5764.60   | 5764.60  | 0.00     | 
    | EDSK-029       | APPS-029           | 11              | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 12              | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 13              | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 14              | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 15              | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 16              | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 17              | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 18              | 4713.23   | 4713.23  | 0.00     | 
    | EDSK-029       | APPS-029           | 19              | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 20              | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 21              | 4555.42   | 4555.42  | 0.00     | 
    | EDSK-029       | APPS-029           | 22              | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 23              | 0.00      | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 24              | 4195.74   | 4195.74  | 0.00     | 


	# Check CRM Subnominal Aggregations

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Jun-20    | Jul-20    |
    | 10017029 | MAIN-029       | APPS-029           | 2240100                  | 44300.00  | 0.00      | 
    | 10017029 | MAIN-029       | APPS-029           | 2240150                  | 18062.45  | 0.00      | 
    | 10017029 | MAIN-029       | APPS-029           | 2240160                  | 11056.40  | 0.00      | 
    | 10017029 | MAIN-029       | APPS-029           | 2240170                  | 7788.50   | 0.00      | 
    | 10017029 | MAIN-029       | APPS-029           | 2340100                  | 72750.56  | 0.00      | 
    | 10017029 | MAIN-029       | APPS-029           | 2340150                  | 20498.91  | 0.00      | 
    | 10017029 | MAIN-029       | APPS-029           | 2340160                  | 8003.66   | 0.00      | 
    | 10017029 | MAIN-029       | APPS-029           | 2340170                  | 17740.28  | 0.00      | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Jun-20    | Jul-20    |
    | 10017029 | MAIN-029       | APPS-029           | 2240100                  | -44300.00 | 0.00      | 
    | 10017029 | MAIN-029       | APPS-029           | 2240150                  | -18062.45 | 0.00      | 
    | 10017029 | MAIN-029       | APPS-029           | 2240160                  | -5291.80  | 0.00      | 
    | 10017029 | MAIN-029       | APPS-029           | 2240170                  | -3818.50  | 0.00      | 
    | 10017029 | MAIN-029       | APPS-029           | 2340100                  | -72750.56 | 0.00      | 
    | 10017029 | MAIN-029       | APPS-029           | 2340150                  | -20498.91 | 0.00      | 
    | 10017029 | MAIN-029       | APPS-029           | 2340160                  | -3807.92  | 0.00      | 
    | 10017029 | MAIN-029       | APPS-029           | 2340170                  | -8471.63  | 0.00      | 




    # Add actuals to the contract (Post-Year-End)

    # Change the date
    Given the override date is '20/10/2020'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017029'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Oct 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS39               | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 814.15      |
    | APPS           | APPS39               | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 352.49      |
    | APPS           | APPS39               | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 827.16      |
    | APPS           | APPS39               | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 996.54      |
    | APPS           | APPS39               | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 520.78      |
    | APPS           | APPS39               | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 1413.42     |
    | APPS           | APPS39               | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 251.98      |
    | APPS           | APPS39               | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 849.37      |
    | APPS           | APPS39               | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 1330.42     |
    | APPS           | APPS39               | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 1030.16     |
    | APPS           | APPS39               | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 1214.79     |
    | APPS           | APPS39               | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 271.83      |
    | APPS           | APPS39               | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 680.35      |
    | APPS           | APPS39               | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 678.35      |
    | APPS           | APPS39               | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 1126.22     |
    | APPS           | APPS39               | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 119.54      |
    | APPS           | APPS39               | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 1341.28     |
    | APPS           | APPS39               | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 1233.42     |
    | APPS           | APPS39               | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 597.47      |
    | APPS           | APPS39               | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 1446.35     |
    | APPS           | APPS39               | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 1289.16     |
    | APPS           | APPS39               | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 1154.98     |
    | APPS           | APPS39               | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 487.25      |
    | APPS           | APPS39               | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 363.69      |
    | APPS           | APPS39               | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 727.09      |
    | APPS           | APPS39               | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 621.18      |
    | APPS           | APPS39               | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 698.55      |
    | APPS           | APPS39               | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 1450.05     |
    | APPS           | APPS39               | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 1057.24     |
    | APPS           | APPS39               | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 413.12      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 725.61      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 710.23      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 1402.62     |
    | APPS           | APPS39               | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 1149.20     |
    | APPS           | APPS39               | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 550.73      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 1084.81     |
    | APPS           | APPS39               | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 1079.05     |
    | APPS           | APPS39               | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 1469.49     |
    | APPS           | APPS39               | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 491.20      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 309.45      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 1016.97     |
    | APPS           | APPS39               | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 770.10      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 1396.12     |
    | APPS           | APPS39               | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 124.34      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 1333.38     |
    | APPS           | APPS39               | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 887.63      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 993.30      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 433.52      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 653.65      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 1133.42     |
    | APPS           | APPS39               | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 386.16      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 814.27      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 1383.43     |
    | APPS           | APPS39               | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 678.01      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 1100.56     |
    | APPS           | APPS39               | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 976.49      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 1330.52     |
    | APPS           | APPS39               | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 1285.52     |
    | APPS           | APPS39               | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 1081.71     |
    | APPS           | APPS39               | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 172.06      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 1076.75     |
    | APPS           | APPS39               | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 597.96      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 841.01      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 1154.26     |
    | APPS           | APPS39               | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 499.83      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 1169.68     |
    | APPS           | APPS39               | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 8               | 0            | 152.97      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 9               | 0            | 487.08      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 10              | 0            | 1245.27     |
    | APPS           | APPS39               | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 22              | 0            | 251.67      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 23              | 0            | 702.05      |
    | APPS           | APPS39               | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 24              | 0            | 204.63      |
    #
	| ILR1920        | R12                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 148.21      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 926.02      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 679.54      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 220.55      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 205.30      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 190.22      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 930.46      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 887.29      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 1296.64     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 191.56      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 250.38      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 305.58      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 457.54      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 611.55      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 832.38      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 383.75      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201908 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 300.49      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 200.20      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 463.84      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 647.15      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 387.02      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 460.49      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 873.36      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 797.46      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 949.53      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 282.68      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 427.62      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 822.12      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 363.20      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 128.74      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 578.28      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 453.69      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 367.86      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201909 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 366.66      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 858.82      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 779.21      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 839.87      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 754.87      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 631.43      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 999.61      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 513.98      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 1076.62     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 583.89      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 139.03      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 855.23      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 124.33      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 776.46      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 904.26      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 480.77      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 433.98      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201910 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 838.70      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 294.06      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 131.82      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 569.45      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 516.39      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 558.58      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 395.47      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 156.97      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 568.43      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 908.67      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 576.59      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 469.42      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 213.64      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 775.34      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 119.69      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 560.75      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 927.69      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201911 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 619.07      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 180.84      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 150.32      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 1189.97     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 289.21      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 149.46      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 857.33      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 380.44      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 533.37      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 320.25      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 185.11      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 626.54      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 656.75      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 515.10      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 655.58      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 999.03      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 731.56      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 201912 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 254.90      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 493.60      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 863.88      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 356.37      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 481.40      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 861.29      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 769.15      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 965.49      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 229.19      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 242.48      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 901.88      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 488.35      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 447.46      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 177.07      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 279.92      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 358.88      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 571.95      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202001 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 1345.35     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 899.83      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 1074.87     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 446.78      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 802.44      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 1433.78     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 307.35      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 596.36      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 162.63      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 1476.38     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 559.97      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 447.24      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 533.79      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 941.58      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 778.38      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 1499.99     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 1001.68     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202002 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 209.55      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 1309.58     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 1051.07     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 664.38      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 1023.54     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 1211.32     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 264.74      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 1016.67     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 736.75      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 111.46      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 1394.91     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 284.35      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 909.24      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 417.39      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 1156.96     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 708.68      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 854.76      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202003 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 1475.33     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 1249.74     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 780.71      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 1337.66     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 1079.72     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 1027.31     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 425.66      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 219.72      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 132.67      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 320.92      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 937.34      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 1057.11     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 653.27      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 1210.85     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 1062.45     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 1047.17     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 1336.96     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202004 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 348.23      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 435.00      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 325.33      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 464.91      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 1227.02     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 560.72      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 412.00      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 563.44      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 205.77      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 551.35      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 209.41      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 813.36      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 879.62      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 209.07      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 748.51      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 1009.32     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 802.05      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202005 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 660.88      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 485.81      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 269.22      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 956.84      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 1142.94     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 750.32      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 293.61      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 179.91      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 334.97      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 340.36      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 574.99      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 1131.24     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 844.65      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 270.48      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 957.25      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 1216.64     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 1441.92     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202006 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 468.29      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 2               | 0            | 345.01      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 3               | 0            | 659.74      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 4               | 0            | 843.40      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 5               | 0            | 1021.39     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 6               | 0            | 1363.03     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 7               | 0            | 1123.83     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 11              | 0            | 446.81      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 12              | 0            | 974.19      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 13              | 0            | 1365.53     |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 14              | 0            | 483.67      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 15              | 0            | 415.27      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 16              | 0            | 274.82      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 17              | 0            | 595.60      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 18              | 0            | 547.47      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 19              | 0            | 311.70      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 20              | 0            | 672.01      |
    | ILR1920        | R12                  | ORG0017029     | CM             | 202007 | APPS1920                | APPS-029                 | ?          | 21              | 0            | 894.62      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check MonitoringDeliverables.HeldReportedActualGroup (Only used for APPS contracts) Is the data showing as unprocessed ?
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS1920' OrgId 'ORG0017029' and Collection 'R12' marked as unprocessed
    And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS1920' OrgId 'ORG0017029' and Collection 'APPS39' marked as unprocessed

    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    When  MonthEnd processing has completed and the processing of held data is triggered



	# Check CRM

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Oct-20   |
    | EDSK-029       | APPS-029           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-029       | APPS-029           | 2               | 6900.70   | 148.21   | 200.20   | 858.82   | 294.06   | 180.84   | 493.60   | 899.83   | 1309.58  | 1249.74  | 435.00   | 485.81   | 345.01   | ?        | 
    | EDSK-029       | APPS-029           | 3               | 7476.03   | 926.02   | 463.84   | 779.21   | 131.82   | 150.32   | 863.88   | 1074.87  | 1051.07  | 780.71   | 325.33   | 269.22   | 659.74   | ?        | 
    | EDSK-029       | APPS-029           | 4               | 8996.32   | 679.54   | 647.15   | 839.87   | 569.45   | 1189.97  | 356.37   | 446.78   | 664.38   | 1337.66  | 464.91   | 956.84   | 843.40   | ?        | 
    | EDSK-029       | APPS-029           | 5               | 8946.49   | 220.55   | 387.02   | 754.87   | 516.39   | 289.21   | 481.40   | 802.44   | 1023.54  | 1079.72  | 1227.02  | 1142.94  | 1021.39  | ?        | 
    | EDSK-029       | APPS-029           | 6               | 9213.03   | 205.30   | 460.49   | 631.43   | 558.58   | 149.46   | 861.29   | 1433.78  | 1211.32  | 1027.31  | 560.72   | 750.32   | 1363.03  | ?        | 
    | EDSK-029       | APPS-029           | 7               | 6912.33   | 190.22   | 873.36   | 999.61   | 395.47   | 857.33   | 769.15   | 307.35   | 264.74   | 425.66   | 412.00   | 293.61   | 1123.83  | ?        | 
    | EDSK-029       | APPS-029           | 8               | 9255.75   | 814.15   | 251.98   | 680.35   | 597.47   | 727.09   | 725.61   | 1079.05  | 1396.12  | 653.65   | 1100.56  | 1076.75  | 152.97   | ?        | 
    | EDSK-029       | APPS-029           | 9               | 9446.75   | 352.49   | 849.37   | 678.35   | 1446.35  | 621.18   | 710.23   | 1469.49  | 124.34   | 1133.42  | 976.49   | 597.96   | 487.08   | ?        | 
    | EDSK-029       | APPS-029           | 10              | 12301.67  | 827.16   | 1330.42  | 1126.22  | 1289.16  | 698.55   | 1402.62  | 491.20   | 1333.38  | 386.16   | 1330.52  | 841.01   | 1245.27  | ?        | 
    | EDSK-029       | APPS-029           | 11              | 6767.71   | 930.46   | 797.46   | 513.98   | 156.97   | 380.44   | 965.49   | 596.36   | 1016.67  | 219.72   | 563.44   | 179.91   | 446.81   | ?        | 
    | EDSK-029       | APPS-029           | 12              | 6791.41   | 887.29   | 949.53   | 1076.62  | 568.43   | 533.37   | 229.19   | 162.63   | 736.75   | 132.67   | 205.77   | 334.97   | 974.19   | ?        | 
    | EDSK-029       | APPS-029           | 13              | 7800.61   | 1296.64  | 282.68   | 583.89   | 908.67   | 320.25   | 242.48   | 1476.38  | 111.46   | 320.92   | 551.35   | 340.36   | 1365.53  | ?        | 
    | EDSK-029       | APPS-029           | 14              | 6582.08   | 191.56   | 427.62   | 139.03   | 576.59   | 185.11   | 901.88   | 559.97   | 1394.91  | 937.34   | 209.41   | 574.99   | 483.67   | ?        | 
    | EDSK-029       | APPS-029           | 15              | 7660.61   | 250.38   | 822.12   | 855.23   | 469.42   | 626.54   | 488.35   | 447.24   | 284.35   | 1057.11  | 813.36   | 1131.24  | 415.27   | ?        | 
    | EDSK-029       | APPS-029           | 16              | 6206.35   | 305.58   | 363.20   | 124.33   | 213.64   | 656.75   | 447.46   | 533.79   | 909.24   | 653.27   | 879.62   | 844.65   | 274.82   | ?        | 
    | EDSK-029       | APPS-029           | 17              | 6475.22   | 457.54   | 128.74   | 776.46   | 775.34   | 515.10   | 177.07   | 941.58   | 417.39   | 1210.85  | 209.07   | 270.48   | 595.60   | ?        | 
    | EDSK-029       | APPS-029           | 18              | 8400.30   | 611.55   | 578.28   | 904.26   | 119.69   | 655.58   | 279.92   | 778.38   | 1156.96  | 1062.45  | 748.51   | 957.25   | 547.47   | ?        | 
    | EDSK-029       | APPS-029           | 19              | 9479.00   | 832.38   | 453.69   | 480.77   | 560.75   | 999.03   | 358.88   | 1499.99  | 708.68   | 1047.17  | 1009.32  | 1216.64  | 311.70   | ?        | 
    | EDSK-029       | APPS-029           | 20              | 9526.17   | 383.75   | 367.86   | 433.98   | 927.69   | 731.56   | 571.95   | 1001.68  | 854.76   | 1336.96  | 802.05   | 1441.92  | 672.01   | ?        | 
    | EDSK-029       | APPS-029           | 21              | 7782.07   | 300.49   | 366.66   | 838.70   | 619.07   | 254.90   | 1345.35  | 209.55   | 1475.33  | 348.23   | 660.88   | 468.29   | 894.62   | ?        | 
    | EDSK-029       | APPS-029           | 22              | 10603.27  | 996.54   | 1030.16  | 119.54   | 1154.98  | 1450.05  | 1149.20  | 309.45   | 887.63   | 814.27   | 1285.52  | 1154.26  | 251.67   | ?        | 
    | EDSK-029       | APPS-029           | 23              | 10849.36  | 520.78   | 1214.79  | 1341.28  | 487.25   | 1057.24  | 550.73   | 1016.97  | 993.30   | 1383.43  | 1081.71  | 499.83   | 702.05   | ?        | 
    | EDSK-029       | APPS-029           | 24              | 8208.29   | 1413.42  | 271.83   | 1233.42  | 363.69   | 413.12   | 1084.81  | 770.10   | 433.52   | 678.01   | 172.06   | 1169.68  | 204.63   | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Jul-20   | Oct-20   |
    | EDSK-029       | APPS-029           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 2               | 16456.39  | 9555.69  | 0.00     | 6900.70  | 
    | EDSK-029       | APPS-029           | 3               | 16292.32  | 8816.29  | 0.00     | 7476.03  | 
    | EDSK-029       | APPS-029           | 4               | 18149.24  | 9152.92  | 0.00     | 8996.32  | 
    | EDSK-029       | APPS-029           | 5               | 16871.59  | 7925.10  | 0.00     | 8946.49  | 
    | EDSK-029       | APPS-029           | 6               | 18063.03  | 8850.00  | 0.00     | 9213.03  | 
    | EDSK-029       | APPS-029           | 7               | 10730.83  | 7788.50  | 0.00     | 2942.33  | 
    | EDSK-029       | APPS-029           | 8               | 18358.53  | 9102.78  | 0.00     | 9255.75  | 
    | EDSK-029       | APPS-029           | 9               | 18406.42  | 8959.67  | 0.00     | 9446.75  | 
    | EDSK-029       | APPS-029           | 10              | 17593.47  | 11056.40 | 0.00     | 6537.07  | 
    | EDSK-029       | APPS-029           | 11              | 14088.61  | 7320.90  | 0.00     | 6767.71  | 
    | EDSK-029       | APPS-029           | 12              | 13608.63  | 6817.22  | 0.00     | 6791.41  | 
    | EDSK-029       | APPS-029           | 13              | 14235.69  | 6435.08  | 0.00     | 7800.61  | 
    | EDSK-029       | APPS-029           | 14              | 14680.49  | 8098.41  | 0.00     | 6582.08  | 
    | EDSK-029       | APPS-029           | 15              | 14905.95  | 7245.34  | 0.00     | 7660.61  | 
    | EDSK-029       | APPS-029           | 16              | 13137.88  | 6931.53  | 0.00     | 6206.35  | 
    | EDSK-029       | APPS-029           | 17              | 15354.84  | 8879.62  | 0.00     | 6475.22  | 
    | EDSK-029       | APPS-029           | 18              | 12539.90  | 8852.83  | 0.00     | 3687.07  | 
    | EDSK-029       | APPS-029           | 19              | 20647.30  | 11168.30 | 0.00     | 9479.00  | 
    | EDSK-029       | APPS-029           | 20              | 19380.33  | 9854.16  | 0.00     | 9526.17  | 
    | EDSK-029       | APPS-029           | 21              | 12114.10  | 8887.45  | 0.00     | 3226.65  | 
    | EDSK-029       | APPS-029           | 22              | 20954.87  | 10351.60 | 0.00     | 10603.27 | 
    | EDSK-029       | APPS-029           | 23              | 20996.67  | 10147.31 | 0.00     | 10849.36 | 
    | EDSK-029       | APPS-029           | 24              | 12016.21  | 8003.66  | 0.00     | 4012.55  | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Jul-20   | Oct-20   |
    | EDSK-029       | APPS-029           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 2               | -16456.39 | -9555.69 | 0.00     | -6900.70 | 
    | EDSK-029       | APPS-029           | 3               | -16292.32 | -8816.29 | 0.00     | -7476.03 | 
    | EDSK-029       | APPS-029           | 4               | -18149.24 | -9152.92 | 0.00     | -8996.32 | 
    | EDSK-029       | APPS-029           | 5               | -16871.59 | -7925.10 | 0.00     | -8946.49 | 
    | EDSK-029       | APPS-029           | 6               | -18063.03 | -8850.00 | 0.00     | -9213.03 | 
    | EDSK-029       | APPS-029           | 7               | -7058.41  | -3818.50 | 0.00     | -3239.91 | 
    | EDSK-029       | APPS-029           | 8               | -18358.53 | -9102.78 | 0.00     | -9255.75 | 
    | EDSK-029       | APPS-029           | 9               | -18406.42 | -8959.67 | 0.00     | -9446.75 | 
    | EDSK-029       | APPS-029           | 10              | -11031.04 | -5291.80 | 0.00     | -5739.24 | 
    | EDSK-029       | APPS-029           | 11              | -14088.61 | -7320.90 | 0.00     | -6767.71 | 
    | EDSK-029       | APPS-029           | 12              | -13608.63 | -6817.22 | 0.00     | -6791.41 | 
    | EDSK-029       | APPS-029           | 13              | -14235.69 | -6435.08 | 0.00     | -7800.61 | 
    | EDSK-029       | APPS-029           | 14              | -14680.49 | -8098.41 | 0.00     | -6582.08 | 
    | EDSK-029       | APPS-029           | 15              | -14905.95 | -7245.34 | 0.00     | -7660.61 | 
    | EDSK-029       | APPS-029           | 16              | -13137.88 | -6931.53 | 0.00     | -6206.35 | 
    | EDSK-029       | APPS-029           | 17              | -15354.84 | -8879.62 | 0.00     | -6475.22 | 
    | EDSK-029       | APPS-029           | 18              | -8150.03  | -4139.60 | 0.00     | -4010.43 | 
    | EDSK-029       | APPS-029           | 19              | -20647.30 | -11168.30| 0.00     | -9479.00 | 
    | EDSK-029       | APPS-029           | 20              | -19380.33 | -9854.16 | 0.00     | -9526.17 | 
    | EDSK-029       | APPS-029           | 21              | -7958.40  | -4332.03 | 0.00     | -3626.37 | 
    | EDSK-029       | APPS-029           | 22              | -20954.87 | -10351.60| 0.00     | -10603.27| 
    | EDSK-029       | APPS-029           | 23              | -20996.67 | -10147.31| 0.00     | -10849.36| 
    | EDSK-029       | APPS-029           | 24              | -7597.63  | -3807.92 | 0.00     | -3789.71 | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Jul-20   | Oct-20   |
    | EDSK-029       | APPS-029           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 7               | 3672.42   | 3970.00  | 0.00     | -297.58  | 
    | EDSK-029       | APPS-029           | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 10              | 6562.43   | 5764.60  | 0.00     | 797.83   | 
    | EDSK-029       | APPS-029           | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 14              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 15              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 16              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 18              | 4389.87   | 4713.23  | 0.00     | -323.36  | 
    | EDSK-029       | APPS-029           | 19              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 20              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 21              | 4155.70   | 4555.42  | 0.00     | -399.72  | 
    | EDSK-029       | APPS-029           | 22              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 23              | 0.00      | 0.00     | 0.00     | 0.00     | 
    | EDSK-029       | APPS-029           | 24              | 4418.58   | 4195.74  | 0.00     | 222.84   | 


	# Check CRM Subnominal Aggregations

    # Check the RECONCILIATION subnominal aggregations in CRM
	And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Jun-20    | Jul-20    | Oct-20    |
    | 10017029 | MAIN-029       | APPS-029           | 2240100                  | 44300.00  | 0.00      | 41532.57  | 
    | 10017029 | MAIN-029       | APPS-029           | 2240150                  | 18062.45  | 0.00      | 18702.50  | 
    | 10017029 | MAIN-029       | APPS-029           | 2240160                  | 11056.40  | 0.00      | 6537.07   | 
    | 10017029 | MAIN-029       | APPS-029           | 2240170                  | 7788.50   | 0.00      | 2942.33   | 
    | 10017029 | MAIN-029       | APPS-029           | 2340100                  | 72750.56  | 0.00      | 67289.16  | 
    | 10017029 | MAIN-029       | APPS-029           | 2340150                  | 20498.91  | 0.00      | 21452.63  | 
    | 10017029 | MAIN-029       | APPS-029           | 2340160                  | 8003.66   | 0.00      | 4012.55   | 
    | 10017029 | MAIN-029       | APPS-029           | 2340170                  | 17740.28  | 0.00      | 6913.72   | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Jun-20    | Jul-20    | Oct-20    |
    | 10017029 | MAIN-029       | APPS-029           | 2240100                  | -44300.00 | 0.00      | -41532.57 | 
    | 10017029 | MAIN-029       | APPS-029           | 2240150                  | -18062.45 | 0.00      | -18702.50 | 
    | 10017029 | MAIN-029       | APPS-029           | 2240160                  | -5291.80  | 0.00      | -5739.24  | 
    | 10017029 | MAIN-029       | APPS-029           | 2240170                  | -3818.50  | 0.00      | -3239.91  | 
    | 10017029 | MAIN-029       | APPS-029           | 2340100                  | -72750.56 | 0.00      | -67289.16 | 
    | 10017029 | MAIN-029       | APPS-029           | 2340150                  | -20498.91 | 0.00      | -21452.63 | 
    | 10017029 | MAIN-029       | APPS-029           | 2340160                  | -3807.92  | 0.00      | -3789.71  | 
    | 10017029 | MAIN-029       | APPS-029           | 2340170                  | -8471.63  | 0.00      | -7636.80  | 



    # Tidy up
    And   the override date is reset
	     
		   