Feature: Mainstream-Apps2526

@AcceptanceTest @Complate
@Long2Run @Long2Run123
Scenario: AK036 Bulk load and approve a new Mainstream APPS2526 contract. NFA. Check docs. Check financials, CDA and feed 
    Given there are no allocations marked as Under Termination for UKPRN '10010036' 
    And   there are no terminated or closed allocations for UKPRN '10010036' 
    And   there is no Contract, Task or Workflow data for UKPRN '10010036' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10010036' 
 

     # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10010036' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | APPS-036      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | APPS-036      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | APPS2526          |



    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | MAIN-036       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10010036'





    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10010036' 
    And   there is no caseload advisor for UKPRN '10010036' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10010036 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10010036' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10010036 Co Ltd' with UKPRN '10010036' and OrgId 'ORG0010036' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10010036 | 110036 | 10010036 Co Ltd | 0              | Active                | Yes           | AA010036      | ?             | 5 William Street       | ?                      | ?                      | Little Shame           | Windsor                | Berkshire              | SL4 1BB   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10010036 |



    
    # Change the date
    Given the override date is '01/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'MAIN-036'
    And   there are no details in ContractManagement.CreatedContract for 'MAIN-036'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10010036 | 10010036 Co Ltd      | DFE-036             | MAIN-036       | 1                     | 01/08/2022        | 31/07/2023      | 26607.00      |                                       | Contract for Services                      | 2223   | New          | ORG0018022 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10010036 | MAIN-036       | APPS-036      | APPS              | APPS2223                | AY                      | 01/08/2022          | 31/07/2023        | 26607.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableDescription                                                          | CRMIntent    | DeliveryOrg |
    | 10010036 | MAIN-036       | APPS-036      | 1               | 0                     | 26607.00  | 17886.00  | 8721.00   | 610.00   | 3624.00  | 2967.00  | 254.00   | 991.00   | 3466.00  | 3442.00  | 2532.00  | 1559.00  | 3496.00  | 1386.00  | 2280.00  | Apprenticeships Carry-In Total Funding                                          | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | MAIN-036       | 1                     | 0                        | 2022-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'MAIN-036'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber 'MAIN-036' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'DFE-036' and ContractNumber 'MAIN-036' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-036' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010036 | MAIN-036           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10010036 |DFE-036           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract 'MAIN-036' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check the deliverable count in CRM includes all the monitoring deliverables
#   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number 'MAIN-036'
#    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'MAIN-036'
#
#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | APPS-036        | 2240100          | Jul-24 | Reconciliation |
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '1' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
#    | 10010036 | MAIN-036       | 1               | APPS-036      | 1               | 0                     | 26607.00     | 0             | 0        | Apprenticeships Carry-In Total Funding                          | ?                                                           |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    #Then  the details in CRM for version '1' of contract 'MAIN-036' agree with the most recent entry for this contract in the ContractManagement feed
#
#

#   Given the override date is reset


    # Bulk load a new APPS2324 alloc on a Mainstream contract
    
    # Change the date
    Given the override date is '22/07/2023'
    
    # Bulk file
    And   there are no files prefixed '10010036' in the Sharepoint 'MAIN-2324-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 2324 05092023163722 v3_AK036' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 2324 05092023163722 v3_AK036' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 2324 05092023163722 v3_AK036' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 2324 05092023163722 v3_AK036' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 2324 05092023163722 v3_AK036.xlsx' exists in the Datafiles folder and UKPRN '10010036' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10010036' for FundingType 'MAIN' and period '2324' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10010036' for FundingType 'MAIN' and period '2324'

    # Check the contents of the Appendices (SoF and FA only)
    Then  the file named '10010036_[ContractNo]_v1.pdf' in Sharepoint location 'MAIN-2324-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING 2023/24
    Organisation Name: 10010036 Co Ltd UKPRN: 10010036
    Master Contract Number: DFE-036
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Apprenticeships Carry-In [AllocRef_APPS] £52,717 £17,282 £69,999
    Total Funding for this contract: £69,999
    Funding Agreement Apprenticeships Carry-In
    Provider: 10010036 Co Ltd UKPRN: 10010036
    Master Contract Number: DFE-036 Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Apprenticeships Carry-In £69,999 £4,946 £7,137 £6,612 £5,201 £7,324 £8,954 £6,273 £6,270 £4,266 £2,875 £6,337 £3,804
    Total Funding £69,999 £4,946 £7,137 £6,612 £5,201 £7,324 £8,954 £6,273 £6,270 £4,266 £2,875 £6,337 £3,804
    Page 1 of 1 of this Funding Agreement
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-07-23 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10010036_[ContractNo]_v1.pdf' in 'MAIN-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'Ak036.pdf'
 
 


    # Publish and approve the contract

    Given the override date is '25/07/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010036 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    #
    | 10010036 | MAIN-036           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10010036 | DFE-036           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check the deliverable count in CRM includes all the monitoring deliverables
#    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
#
#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | [AllocRef_APPS] | 2240100          | Jul-24 | Reconciliation |
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '1' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                         | DeliverableDescription   | 
#    | 10010036 | [ContractNo]   | 1               | [AllocRef_APPS] | 1               | 0                     | 69999.00     | 0             | 0        | Apprenticeships Carry-In Total Funding  | ?                        |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract 'MAIN-036' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the PLANNED VALUES on deliverable 1 in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_APPS]    | 1               | 69999.00  | 52717.00 | 17282.00 | 4946.00  | 7137.00  | 6612.00  | 5201.00  | 7324.00  | 8954.00  | 6273.00  | 6270.00  | 4266.00  | 2875.00  | 6337.00  | 3804.00  | 
 


     # Bulk load a new APPS2425 alloc on a Mainstream contract
    
    # Change the date
    Given the override date is '22/05/2024'
    
    # Bulk file
    And   there are no files prefixed '10010036' in the Sharepoint 'MAIN-2425-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 2425 25062024080035 v3_AK036' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 2425 25062024080035 v3_AK036' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 2425 25062024080035 v3_AK036' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 2425 25062024080035 v3_AK036' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 2425 25062024080035 v3_AK036.xlsx' exists in the Datafiles folder and UKPRN '10010036' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10010036' for FundingType 'MAIN' and period '2425' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10010036' for FundingType 'MAIN' and period '2425'

    # Check the contents of the Appendices (SoF and FA only)
    Then  the file named '10010036_[ContractNo]_v1.pdf' in Sharepoint location 'MAIN-2425-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING 2024/25
    Organisation Name: 10010036 Co Ltd UKPRN: 10010036
    Master Contract Number: DFE-036
    Allocation
    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
    Apprenticeships Carry-In [AllocRef_APPS] £21,200 £13,000 £34,200
    Total Funding for this contract: £34,200
    Funding Agreement Apprenticeships Carry-In
    Provider: 10010036 Co Ltd UKPRN: 10010036
    Master Contract Number: DFE-036 Start Date: 01/08/2024 End Date: 31/07/2025
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
    Apprenticeships Carry-In £34,200 £2,300 £2,400 £2,500 £2,600 £2,700 £2,800 £2,900 £3,000 £3,100 £3,200 £3,300 £3,400
    Total Funding £34,200 £2,300 £2,400 £2,500 £2,600 £2,700 £2,800 £2,900 £3,000 £3,100 £3,200 £3,300 £3,400
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2024-05-22 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10010036_[ContractNo]_v1.pdf' in 'MAIN-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK036_v3.pdf'
 
 


    # Publish and approve the contract

    Given the override date is '25/07/2024'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'DFE-036' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010036 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10010036 | DFE-036           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check the deliverable count in CRM includes all the monitoring deliverables
#    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
#
#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | [AllocRef_APPS] | 2240100          | Jul-24 | Reconciliation |
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '1' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                         | DeliverableDescription   | 
#    | 10010036 | [ContractNo]   | 1               | [AllocRef_APPS] | 1               | 0                     | 69999.00     | 0             | 0        | Apprenticeships Carry-In Total Funding  | ?                        |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract 'MAIN-036' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the PLANNED VALUES on deliverable 1 in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   |
    | [ContractNo]   | [AllocRef_APPS]    | 1               | 34200.00  | 21200.00 | 13000.00 | 2300.00  | 2400.00  | 2500.00  | 2600.00  | 2700.00  | 2800.00  | 2900.00  | 3000.00  | 3100.00  | 3200.00  | 3300.00  | 3400.00  | 
 


     # Bulk load a new APPS2526 alloc on a Mainstream contract
    
    # Change the date
    Given the override date is '22/05/2025'
    
    # Bulk file
    And   there are no files prefixed '10010036' in the Sharepoint 'MAIN-2526-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 2526 15062024080035 v3_AK036' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 2526 15062024080035 v3_AK036' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 2526 15062024080035 v3_AK036' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 2526 15062024080035 v3_AK036' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 2526 15062024080035 v3_AK036.xlsx' exists in the Datafiles folder and UKPRN '10010036' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10010036' for FundingType 'MAIN' and period '2526' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10010036' for FundingType 'MAIN' and period '2526'

    # Check the contents of the Appendices (SoF and FA only)
    Then  the file named '10010036_[ContractNo]_v1.pdf' in Sharepoint location 'MAIN-2526-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING 2025/26
    Organisation Name: 10010036 Co Ltd UKPRN: 10010036
    Master Contract Number: DFE-036
    Allocation
    Contract Ref Aug 25 - Mar 26 Apr 26 - Jul 26 2025/26 Total
    Apprenticeships Carry-In [AllocRef_APPS] £21,200 £13,000 £34,200
    Total Funding for this contract: £34,200
    Funding Agreement Apprenticeships Carry-In
    Provider: 10010036 Co Ltd UKPRN: 10010036
    Master Contract Number: DFE-036 Start Date: 01/08/2025 End Date: 31/07/2026
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2025 Sep 2025 Oct 2025 Nov 2025 Dec 2025 Jan 2026 Feb 2026 Mar 2026 Apr 2026 May 2026 Jun 2026 Jul 2026
    Apprenticeships Carry-In £34,200 £2,300 £2,400 £2,500 £2,600 £2,700 £2,800 £2,900 £3,000 £3,100 £3,200 £3,300 £3,400
    Total Funding £34,200 £2,300 £2,400 £2,500 £2,600 £2,700 £2,800 £2,900 £3,000 £3,100 £3,200 £3,300 £3,400
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2025-05-22 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10010036_[ContractNo]_v1.pdf' in 'MAIN-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK036_v4.pdf'
 
 


    # Publish and approve the contract

    Given the override date is '25/07/2025'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'DFE-036' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010036 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2025        | 31/07/2026      | ?             |
    | 10010036 | DFE-036           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check the deliverable count in CRM includes all the monitoring deliverables
#    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
#
#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | [AllocRef_APPS] | 2240100          | Jul-25 | Reconciliation |
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '1' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                         | DeliverableDescription   | 
#    | 10010036 | [ContractNo]   | 1               | [AllocRef_APPS] | 1               | 0                     | 69999.00     | 0             | 0        | Apprenticeships Carry-In Total Funding  | ?                        |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract 'MAIN-036' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the PLANNED VALUES on deliverable 1 in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-25   | Sep-25  | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   |
    | [ContractNo]   | [AllocRef_APPS]    | 1               | 34200.00  | 21200.00 | 13000.00 | 2300.00  | 2400.00  | 2500.00  | 2600.00  | 2700.00  | 2800.00  | 2900.00  | 3000.00  | 3100.00  | 3200.00  | 3300.00  | 3400.00  | 
 


     # Part 5: Add 25/26 actuals and check financials in CRM and PaaS

    
    # Add actuals to the contract for APPS2526

    # Change the date
    Given the override date is '04/09/2025'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0010036'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2022
   And   the following closed collections are available in DCFS 
   | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber        | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
   | APPS           | APPS100               | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 343.56      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 322.38      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 168.11      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 846.86      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 875.31      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 458.34      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 516.63      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 682.09      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 477.18      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 480.01      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 119.73      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 418.47      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 381.10      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 979.14      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1139.69     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 1356.61     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 1322.71     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1236.33     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1272.19     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 1396.93     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 238.20      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 730.41      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 418.21      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 224.05      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1311.28     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 997.86      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 705.86      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 641.13      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 769.94      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 842.12      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1262.28     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 454.26      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1433.43     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 293.02      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 335.48      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 106.84      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1009.04     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 716.13      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 566.30      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 863.95      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 339.06      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1072.13     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 610.19      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 546.70      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 797.59      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 126.17      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 1109.12     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 816.66      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 637.45      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 407.33      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1213.47     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 810.21      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 1487.05     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1317.87     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1053.89     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 922.87      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1197.25     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 992.68      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 363.19      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1343.76     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1038.26     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 1308.67     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 248.18      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 939.89      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 646.48      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 644.08      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1111.61     |
   | APPS           | APPS100               | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 690.60      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 321.43      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 987.94      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 923.94      |
   | APPS           | APPS100               | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 471.91      |
   #
   | ILR2526        | R01                  | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
   | ILR2526        | R01                  | ORG0010036     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |


    Then wait '30' seconds

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

#    # Check MonitoringDeliverables.HeldReportedActualGroup (Only used for APPS contracts) Is the data showing as unprocessed ?
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS2526' OrgId 'ORG0010036' and Collection 'APPS100' marked as unprocessed
   #And   there is '1' row on table HeldReportedActualGroup for FSP 'ILR2526' OrgId 'ORG0010036' and Collection 'R01' marked as unprocessed
#
#    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    When  MonthEnd processing has completed and the processing of held data is triggered
#


    # Check Financials

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   |
   
    | [ContractNo]   | [AllocRef_APPS]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 2               | 872.56    | 872.56   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 3               | 1399.35   | 1399.35  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 4               | 845.33    | 845.33   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 5               | 390.89    | 390.89   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 6               | 1016.17   | 1016.17  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 7               | 216.91    | 216.91   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 8               | 343.56    | 343.56   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 9               | 322.38    | 322.38   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 10              | 168.11    | 168.11   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 11              | 1397.45   | 1397.45  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 12              | 1070.04   | 1070.04  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 13              | 722.26    | 722.26   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 14              | 418.13    | 418.13   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 15              | 385.36    | 385.36   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 16              | 1481.64   | 1481.64  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 17              | 711.43    | 711.43   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 18              | 1328.71   | 1328.71  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 19              | 969.41    | 969.41   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 20              | 1332.19   | 1332.19  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 21              | 901.73    | 901.73   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 22              | 846.86    | 846.86   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 23              | 875.31    | 875.31   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 24              | 458.34    | 458.34   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 



     # Payment Batch for APPS2526(PoA)

    # Change the date
    Given the override date is '08/09/2025 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'APPS2526' AccountingPaymentPeriod '202505' CensusEndDate '08/09/2025' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_APPS]          | 202508 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | APPS2526                   | 202508               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | APPS2526                   | 202508               | Completed |


#
#
#
#    # Part 10: Create Consolidated Payment Summary rpt
#   
#    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
#    #Given the override date is '06/01/2023 10:00'
#
#   Given there are no files prefixed '2025-08 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
#   
#   When  a Consolidated Payment Summary Report is created in Sharepoint for '11/01/2023'
#    # Check the above report manually
#	
#
#   When a Grant Funding Consolidated Payment Summary Report is created in Sharepoint for '03/08/2025'
#    # Check the above report manually
#



        # Consolidated payment summary report

   
    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    Given the override date is '08/09/2025 10:00'

    Given there are no files prefixed '2025-08 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
   
    When  a Consolidated Payment Summary Report is created in Sharepoint for '08/09/2025'
    # Check the above report manually


    
        # Run the CDA report for APPS FSPs
    Given the override date is '08/09/2025'
    Given there is no CDA report named 'CDA Latest Version AK036.csv'
    And   the following ADF Pipeline run
    And   the following CDA report is run
    | FundingStreamPeriod   | Version         | Suffix |
    | APPS2526              | Latest Version  | AK036   |
 
    Then  a report named 'CDA Latest Version AK036.csv' is created




    # Tidy Up
   Given the override date is reset




@AcceptanceTest @Complete
@Long2Run @Long2Run123
Scenario: AK037 Bulk load a new draft EDSK2526 contract with several FSPs. Publish and approve. Check docs, CRM PaaS and Feed
    Given there are no allocations marked as Under Termination for UKPRN '10010037' 
    And   there are no terminated or closed allocations for UKPRN '10010037' 
    And   there is no Contract, Task or Workflow data for UKPRN '10010037' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10010037' 
 
#    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
#    Given there is no data in the ContractRequest.FundingAllocationRelease table 
#
#    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
#    And   there is no data in the CFS stub
#    And   there is no data in the Funding Allocation PaaS tables
 
    
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    ## Clear down ContractRequest.FundingAllocationRelease table (J146) 
    #And   there is no data in the ContractRequest.FundingAllocationRelease table 

    
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10010037' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLBC2526		    |
    | ALLF2526		    |
    | APPS2526		    |

#    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
#    And   there are no Sector-based Work Academies profile values in config for UKPRN '10010037'
#
#    # Set the 'base' timestamp for each of the 22\23 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
#    And   the following document templates have Upload timestamps as indicated 
#    | DocumentTemplateName                              | UploadTimestamp         | 
#    | SOF_EDSK_2022-08-01.docx                          | 2023-04-01 12:00:00.000 | 
#    #  
#    | EDSK2526_TAC_CFS_ITP_2022-08-01.docx              | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_TAC_COFG_COLLEGE_2022-08-01.docx         | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_TAC_COFG_EMPLOYER_2022-08-01.docx        | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_TAC_COFG_HEI_2022-08-01.docx             | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_TAC_COFG_LA_2022-08-01.docx              | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_TAC_COFG_NMSS_2022-08-01.docx            | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_TAC_COFG_SPI_2022-08-01.docx             | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_TAC_COFG_TRUST_2022-08-01.docx           | 2023-04-01 12:00:00.000 | 
#    #  
#    | EDSK2223_S1_1618TRN_CFS_2022-08-01.docx           | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_1618TRN_COFG_2022-08-01.docx          | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_1619ED_COLLEGE_2022-08-01.docx        | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_1619ED_HEI_2022-08-01.docx            | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_1619ED_ITP_2022-08-01.docx            | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_1619ED_LA_2022-08-01.docx             | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_1619ED_NMSS_2022-08-01.docx           | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_1619ED_SPI_2022-08-01.docx            | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_AEB_COFG_2022-08-01.docx              | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_LOANS_CFS_2022-08-01.docx             | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_LOANS_COFG_2022-08-01.docx            | 2023-04-01 12:00:00.000 | 
#    #  
#    | EDSK2223_S2_1618TRN_CFS_2022-08-01.docx           | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S2_1618TRN_COFG_2022-08-01.docx          | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S2_1618TRNME_CFS_2022-08-01.docx         | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S2_1618TRNME_COFG_2022-08-01.docx        | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S2_1619ED_CFS_2022-08-01.docx            | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S2_1619ED_COFG_2022-08-01.docx           | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S2_1619ED_NMSS_2022-08-01.docx           | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S2_AEB_COFG_2022-08-01.docx              | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S2_LOANS_CFS_2022-08-01.docx             | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S2_LOANS_COFG_2022-08-01.docx            | 2023-04-01 12:00:00.000 | 
#    #  
#    | FA_EDSK2223_2022-08-01.docx                       | 2023-04-01 12:00:00.000 | 
#    #  
#    | EDSK2223_S3ON_CFS_ITP_2022-08-01.docx             | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S3ON_COFG_COLLEGE_2022-08-01.docx        | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S3ON_COFG_EMPLOYER_2022-08-01.docx       | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S3ON_COFG_LA_TRUST_HEI_2022-08-01.docx   | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S3ON_COFG_NMSS_2022-08-01.docx           | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S3ON_COFG_SPI_2022-08-01.docx            | 2023-04-01 12:00:00.000 | 
#


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10010037' 
    And   there is no caseload advisor for UKPRN '10010037' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10010037 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10010037' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10010037 Co Ltd' with UKPRN '10010037' and OrgId 'ORG0010037' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10010037 | 110037 | 10010037 Co Ltd | 0              | In Administration     | Yes           | AA010037      | ?             | 9 Ronaldshaw Park      | Ayr                    | ?                      | ?                      | ?                      | ?                      | KA7 2TJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10010037 |





    # Change the date
    Given the override date is '16/07/2025'

    # Bulk file for new [Conditions of Funding (Grant) (College)] contract
    And   there are no files prefixed '10010037' in the Sharepoint 'EDSK-2526-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2526 12062024105948 v1_AK037' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2526 12062024105948 v1_AK037' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2526 12062024105948 v1_AK037' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2526 12062024105948 v1_AK037' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2526 12062024105948 v1_AK037.xlsx' exists in the Datafiles folder and UKPRN '10010037' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10010037' for FundingType 'EDSK' and period '2526' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10010037' for FundingType 'EDSK' and period '2526'

    # Check the contents of the Appendices
#    Then  the file named '10010037_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2526-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING 2025/25
#    Organisation Name: 10010037 Co Ltd UKPRN: 10010037
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    Contract Ref Aug 25 - Mar 26 Apr 26 - Jul 26 2025/26 Total
#    Advanced Learner Loans Facility [AllocRef_ALLF] £25,775 £12,005 £37,780
#    Advanced Learner Loans Bursary [AllocRef_ALLC] £40,174 £21,996 £62,170
#    Apprenticeships Carry-In [AllocRef_APPS] £22,284 £12,005 £34,289
#    Total Funding for this contract: £134,239
#    Summary of Funding – Page 1
#    Agreement Type Conditions of Funding (Grant) (Local Authorities)
#    Funding Period 1 August 2025 to 31 July 2026
#    Between the Secretary of State for Education
#    And 10010037 Co Ltd
#    Advanced Learner Loans
#    Funding for
#    Apprenticeships Carry-In
#    ACCEPTANCE BY THE PROVIDER
#    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
#    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
#    THE PROVIDER REPRESENTS AND WARRANTS THAT THE PROVIDER HAS
#    READ AND UNDERSTOOD THIS AGREEMENT, THE PROVIDER AGREES TO BE
#    BOUND BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO
#    ACCEPT THIS AGREEMENT AND LEGALLY BIND THE PROVIDER.
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    EDSK Conditions of Funding (Grant) (Local Authorities)
#    Version 2 - July 2025 - Page 1
#    This Agreement is made on the date the Agreement is digitally signed by the
#    Provider on the Manage Your Education & Skills Funding Service between:
#    10010037 Co Ltd THE SECRETARY OF STATE FOR
#    9 Ronaldshaw Park EDUCATION
#    Ayr DEPARTMENT FOR EDUCATION
#    KA7 2TJ 20 GREAT SMITH STREET
#    AND
#    LONDON
#    SW1P 3BT
#    Company No: AA018053
#    Hereinafter called Hereinafter called
#    the Provider the Department
#    EDSK Conditions of Funding (Grant) (Local Authorities)
#    Version 2 - July 2025 - Page 60
#
#
#    SCHEDULE 1: DEFINITIONS
#    Schedule 1
#    Version 2 - July 2025 - Page 1
#
#    SCHEDULE 2: SPECIFICATION & MONITORING
#    ADVANCED LEARNER LOANS SPECIFICATION
#    Schedule 2: Advanced Learner Loans 
#    Version 2 – July 2025 – Page 1
#
#
#    SCHEDULE 2: SPECIFICATION & MONITORING
#    APPRENTICESHIPS CARRY-IN SPECIFICATION
#    Schedule 2: Apprenticeships Carry-In
#    Version 1 – July 2025 – Page 1
#
#  
#
#    SCHEDULE 3: PAYMENT
#    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
#    Funding Agreement – Advanced Learner Loans Facility
#    Provider: 10010037 Co Ltd UKPRN: 10010037
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2025 End Date: 31/07/2026
#    Contract Ref: [AllocRef_ALLF]
#    Cash (£) Aug 2025 Sep 2025 Oct 2025 Nov 2025 Dec 2025 Jan 2026 Feb 2026 Mar 2026 Apr 2026 May 2026 Jun 2026 Jul 2026
#    Advanced Learner Loans Facility £37,780 £6,510 £2,041 £5,385 £1,192 £2,094 £1,499 £3,283 £3,771 £6,032 £1,361 £1,584 £3,028
#    Total Funding £37,780 £6,510 £2,041 £5,385 £1,192 £2,094 £1,499 £3,283 £3,771 £6,032 £1,361 £1,584 £3,028
#    Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
#    
#    ADVANCED LEARNER LOANS
#    Funding Agreement – Advanced Learner Loans Bursary
#    Provider: 10010037 Co Ltd UKPRN: 10010037
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2025 End Date: 31/07/2026
#    Contract Ref: [AllocRef_ALLC]
#    Cash (£) Aug 2025 Sep 2025 Oct 2025 Nov 2025 Dec 2025 Jan 2026 Feb 2026 Mar 2026 Apr 2026 May 2026 Jun 2026 Jul 2026
#    Advanced Learner Loans Bursary Funding £62,170 £6,951 £5,200 £391 £6,866 £5,454 £7,578 £1,208 £6,526 £6,969 £5,016 £2,925 £7,086
#    Total Funding £62,170 £6,951 £5,200 £391 £6,866 £5,454 £7,578 £1,208 £6,526 £6,969 £5,016 £2,925 £7,086
#    Advanced Learner Loans – Funding Agreement [AllocRef_ALLC] – Page 1 Ref (for internal use only):  [ContractNo] v1
#    
#    APPRENTICESHIPS CARRY-IN
#    Funding Agreement – Apprenticeships Carry-In
#    Provider: 10010037 Co Ltd UKPRN: 10010037
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2025 End Date: 31/07/2026
#    Contract Ref: [AllocRef_APPS]
#    Cash (£) Aug 2025 Sep 2025 Oct 2025 Nov 2025 Dec 2025 Jan 2026 Feb 2026 Mar 2026 Apr 2026 May 2026 Jun 2026 Jul 2026
#    Apprenticeships Carry-In £34,289 £678 £2,041 £5,385 £1,192 £4,435 £1,499 £3,283 £3,771 £6,032 £1,361 £1,584 £3,028
#    Total Funding £34,289 £678 £2,041 £5,385 £1,192 £4,435 £1,499 £3,283 £3,771 £6,032 £1,361 £1,584 £3,028
#    Apprenticeships Carry-In – Funding Agreement [AllocRef_APPS] – Page 1 Ref (for internal use only):  [ContractNo] v1
#
#
#    SCHEDULE 4: UK GDPR/DATA PROTECTION
#    Schedule 4
#    Version 2 – July 2025 – Page 1
#
#    SCHEDULE 5: SECURITY & DEPARTMENT POLICIES
#    Schedule 5
#    Version 2 – July 2025 – Page 1
#
#    SCHEDULE 6: EXIT ARRANGEMENTS
#    Schedule 6
#    Version 2 – July 2025 – Page 1
#
#    SCHEDULE 7: SUBCONTRACTING
#    Schedule 7
#    Version 2 – July 2025 – Page 1
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
    
    And   Sharepoint file '10010037_[ContractNo]_v1.pdf' in 'EDSK-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as '10010037_[ContractNo]_v1.pdf'


    # Part 4: Publish and approve 25/26 v1 and check feed

    # Change the date
    Given the override date is '29/07/2025'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010037 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2025        | 31/07/2026      | ?             |
    | 10010037 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |


    # Part 5: Add Actuals for 25/26 then check CRM

    # Add actuals to the contract for ALLBC2526, ALLF2526, APPS2526

  # Add actuals to the contract for APPS2526

  # Change the date
  Given the override date is '04/09/2025'

  # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
  And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0010037'

  # Clear down the stub
  And   there are no entries in the DCFS stub table

  # Month end is not running
  And   the PaaS MonthEndIsRunning indicator is set to 'False'

  # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
  And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

  # Pull actuals from DC for Aug 2022
 And   the following closed collections are available in DCFS 
 | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber        | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
 | APPS           | APPS100               | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 343.56      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 322.38      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 168.11      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 846.86      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 875.31      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 458.34      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 516.63      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 682.09      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 477.18      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 480.01      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 119.73      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 418.47      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 381.10      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 979.14      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1139.69     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 1356.61     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 1322.71     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1236.33     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1272.19     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 1396.93     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 238.20      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 730.41      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 418.21      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 224.05      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1311.28     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 997.86      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 705.86      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 641.13      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 769.94      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 842.12      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1262.28     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 454.26      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1433.43     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 293.02      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 335.48      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 106.84      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1009.04     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 716.13      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 566.30      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 863.95      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 339.06      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1072.13     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 610.19      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 546.70      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 797.59      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 126.17      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 1109.12     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 816.66      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 637.45      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 407.33      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1213.47     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 810.21      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 1487.05     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1317.87     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1053.89     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 922.87      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1197.25     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 992.68      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 363.19      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1343.76     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1038.26     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 1308.67     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 248.18      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 939.89      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 646.48      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 644.08      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1111.61     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 690.60      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 321.43      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 987.94      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 923.94      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 471.91      |
 #
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |


   


    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service
     Then wait '30' seconds

    #    # Check MonitoringDeliverables.HeldReportedActualGroup (Only used ILR2526 APPS contracts) Is the data showing as unprocessed ?
   # Then  there is '1' row on table HeldReportedActualGroup for FSP 'ILR2526' OrgId 'ORG0010037' and Collection 'R02' marked as unprocessed
   #And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS' OrgId 'ORG0010037' and Collection 'APPS100' marked as unprocessed
#
#    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    When  MonthEnd processing has completed and the processing of held data is triggered
#
    # Check financials

# # Check the ACTUAL VALUES in CRM on the latest approved contract
 Then  the Actuals Value Data is as follows
 | ContractNumber | AllocationRef 	  | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   |
 | [ContractNo]   | [AllocRef_APPS]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 2               | 872.56    | 872.56   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 3               | 1399.35   | 1399.35  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 4               | 845.33    | 845.33   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 5               | 390.89    | 390.89   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 6               | 1016.17   | 1016.17  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 7               | 216.91    | 216.91   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 8               | 343.56    | 343.56   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 9               | 322.38    | 322.38   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 10              | 168.11    | 168.11   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 11              | 1397.45   | 1397.45  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 12              | 1070.04   | 1070.04  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 13              | 722.26    | 722.26   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 14              | 418.13    | 418.13   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 15              | 385.36    | 385.36   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 16              | 1481.64   | 1481.64  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 17              | 711.43    | 711.43   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 18              | 1328.71   | 1328.71  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 19              | 969.41    | 969.41   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 20              | 1332.19   | 1332.19  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 21              | 901.73    | 901.73   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 22              | 846.86    | 846.86   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 23              | 875.31    | 875.31   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 24              | 458.34    | 458.34   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

 And   the Reconciliation Data is calculated as follows 
 | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   |
 | [ContractNo]   | [AllocRef_APPS]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 2               | 872.56    | 872.56   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 3               | 1399.35   | 1399.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 4               | 845.33    | 845.33   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 5               | 390.89    | 390.89   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 6               | 1016.17   | 1016.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 7               | 216.91    | 216.91   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 8               | 343.56    | 343.56   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 9               | 322.38    | 322.38   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 10              | 168.11    | 168.11   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 11              | 1397.45   | 1397.45  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 12              | 1070.04   | 1070.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 13              | 722.26    | 722.26   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 14              | 418.13    | 418.13   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 15              | 385.36    | 385.36   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 16              | 1481.64   | 1481.64  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 17              | 711.43    | 711.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 18              | 1328.71   | 1328.71  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 19              | 969.41    | 969.41   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 20              | 1332.19   | 1332.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 21              | 901.73    | 901.73   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 22              | 846.86    | 846.86   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 23              | 875.31    | 875.31   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 24              | 458.34    | 458.34   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

 # Check the CAPPING AMOUNTS in CRM on the latest approved contract
 And   the Capping Amounts are calculated as follows 
 | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   |
 | [ContractNo]   | [AllocRef_APPS]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 14              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 15              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 16              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 19              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 20              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 21              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 22              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 23              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 24              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

 # Check the NET AMOUNTS in CRM on the latest approved contract
 And   the Net Payments are calculated as follows 
 | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   |
 | [ContractNo]   | [AllocRef_APPS]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 2               | 872.56    | 872.56   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 3               | 1399.35   | 1399.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 4               | 845.33    | 845.33   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 5               | 390.89    | 390.89   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 6               | 1016.17   | 1016.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 7               | 216.91    | 216.91   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 8               | 343.56    | 343.56   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 9               | 322.38    | 322.38   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 10              | 168.11    | 168.11   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 11              | 1397.45   | 1397.45  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 12              | 1070.04   | 1070.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 13              | 722.26    | 722.26   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 14              | 418.13    | 418.13   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 15              | 385.36    | 385.36   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 16              | 1481.64   | 1481.64  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 17              | 711.43    | 711.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 18              | 1328.71   | 1328.71  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 19              | 969.41    | 969.41   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 20              | 1332.19   | 1332.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 21              | 901.73    | 901.73   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 22              | 846.86    | 846.86   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 23              | 875.31    | 875.31   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 24              | 458.34    | 458.34   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

