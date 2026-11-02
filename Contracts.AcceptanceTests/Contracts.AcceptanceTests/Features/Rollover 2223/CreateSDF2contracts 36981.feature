Feature: CreateSDF2contracts 36981

@AcceptanceTest @Withdrawn20231002
Scenario: A794 Bulk load a new 22/23 SDFII contract. Publish and approve. Amend and approve. Check docs, CRM, CDA, PaaS and feed

    # 1. Bulk file to create a new SDFII2223 contract. Check docs
    # 2. Publish and approve. Check financials and feed
    # 3. Bulk variation amendment. Check docs
    # 4. Publish and approve. Check financials and feed
    # 5. CDA

    Given there are no allocations marked as Under Termination for UKPRN '10017794' 
    And   there are no terminated or closed allocations for UKPRN '10017794' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017794' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017794' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017794' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | SDFII-794     |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | SDFII-794     |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | SDFII2223         |

    # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
    And   there is no Subnominal data in CRM for the following subnominal codes
    | SubnominalCode |
    | 2888882        |
    | 2888883        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017794'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017794' 
    And   there is no caseload advisor for UKPRN '10017794' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017794 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017794' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017794 Co Ltd' with UKPRN '10017794' and OrgId 'ORG0017794' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017794 | 117794 | 10017794 Co Ltd | 0              | Active                | Yes           | AA017794      | ?             | 39 Brimfield Road      | Watts Wood             | ?                      | ?                      | Purfleet               | Essex                  | RM19 1RQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017794 |





    # Part 1: Bulk file to create a new SDFII2223 contract
    
    # Change the date
    Given the override date is '01/07/2022'

    # Bulk file
    And   there are no files prefixed '10017794' in the Sharepoint 'SDFII-2223-Input-Appendices' folder
    And   there are no files prefixed 'SDFII FY 2223 30052022132313 v3_A794' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SDFII FY 2223 30052022132313 v3_A794' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SDFII FY 2223 30052022132313 v3_A794' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SDFII FY 2223 30052022132313 v3_A794' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SDFII FY 2223 30052022132313 v3_A794.xlsx' exists in the Datafiles folder and UKPRN '10017794' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017794' for FundingType 'SDFII' and period '2223' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017794' for FundingType 'SDFII' and period '2223'

    # Check the contents of the Appendices
    Then  the file named '10017794_[ContractNo]_v1.pdf' in Sharepoint location 'SDFII-2223-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017794 Co Ltd UKPRN: 10017794
    Master Contract Number: [MasterContractNo] Start Date: 01/04/2022 End Date: 31/03/2023
    Contract Ref: [AllocRef_SDFII]
    Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    Strategic Development Fund II - Capital £41,838 £0 £0 £0 £7,502 £6,026 £4,615 £6,738 £368 £5,686 £5,634 £3,680 £1,589
    Strategic Development Fund II - Resource £21,119 £0 £0 £0 £1,326 £2,491 £1,156 £3,001 £3,628 £2,587 £2,883 £1,491 £2,556
    Total Funding £62,957 £0 £0 £0 £8,828 £8,517 £5,771 £9,739 £3,996 £8,273 £8,517 £5,171 £4,145
    Strategic Development Fund II – [AllocRef_SDFII] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-01 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017794_[ContractNo]_v1.pdf' in 'SDFII-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A794.pdf'



    # Part 2: Publish and approve. Check financials and feed

    # Change the date
    Given the override date is '02/07/2022'

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
    | 10017794 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2022        | 31/03/2023      | ?             |
    | 10017794 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2022        | 31/03/2023      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef     | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_SDFII]  | 2888882          | Mar-23 | Profile        |
    | [AllocRef_SDFII]  | 2888883          | Mar-23 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                             | DeliverableDescription     | 
    | 10017794 | [ContractNo]   | 1               | [AllocRef_SDFII] | 1               | 0                     | 41838.00     | 0             | 0        | Strategic Development Fund II - Capital     | ?                          |
    | 10017794 | [ContractNo]   | 1               | [AllocRef_SDFII] | 2               | 0                     | 21119.00     | 0             | 0        | Strategic Development Fund II - Resource    | ?                          |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed


    # Check financials and feed

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | [ContractNo]   | [AllocRef_SDFII]   | 1               | 41838.00  | 0.00     | 0.00     | 0.00     | 7502.00  | 6026.00  | 4615.00  | 6738.00  | 368.00   | 5686.00  | 5634.00  | 3680.00  | 1589.00  | 
    | [ContractNo]   | [AllocRef_SDFII]   | 2               | 21119.00  | 0.00     | 0.00     | 0.00     | 1326.00  | 2491.00  | 1156.00  | 3001.00  | 3628.00  | 2587.00  | 2883.00  | 1491.00  | 2556.00  | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | [ContractNo]   | [AllocRef_SDFII]   | 1               | 41838.00  | ?        | ?        | ?        | 7502.00  | 6026.00  | 4615.00  | 6738.00  | 368.00   | 5686.00  | 5634.00  | 3680.00  | 1589.00  | 
    | [ContractNo]   | [AllocRef_SDFII]   | 2               | 21119.00  | ?        | ?        | ?        | 1326.00  | 2491.00  | 1156.00  | 3001.00  | 3628.00  | 2587.00  | 2883.00  | 1491.00  | 2556.00  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | [ContractNo]   | [AllocRef_SDFII]   | 1               | 41838.00  | 0.00     | 0.00     | 0.00     | 7502.00  | 6026.00  | 4615.00  | 6738.00  | 368.00   | 5686.00  | 5634.00  | 3680.00  | 1589.00  | 
    | [ContractNo]   | [AllocRef_SDFII]   | 2               | 21119.00  | 0.00     | 0.00     | 0.00     | 1326.00  | 2491.00  | 1156.00  | 3001.00  | 3628.00  | 2587.00  | 2883.00  | 1491.00  | 2556.00  | 

 
    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Apr-22    | May-22    | Jun-22    | Jul-22    | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    |
    | 10017794 | [ContractNo]   | [AllocRef_SDFII]   | 2888883                  | 0.00      | 0.00      | 0.00      | 7502.00   | 6026.00   | 4615.00   | 6738.00   | 368.00    | 5686.00   | 5634.00   | 3680.00   | 1589.00   | 
    | 10017794 | [ContractNo]   | [AllocRef_SDFII]   | 2888882                  | 0.00      | 0.00      | 0.00      | 1326.00   | 2491.00   | 1156.00   | 3001.00   | 3628.00   | 2587.00   | 2883.00   | 1491.00   | 2556.00   | 





    # Part 3: Bulk variation amendment. Check docs
    
    # Change the date
    Given the override date is '30/04/2024'

    # Bulk file (Variation amendment)
    And   there are no files prefixed '10017794' in the Sharepoint 'SDFII-2223-Input-Appendices' folder
    And   there are no files prefixed 'SDFII FY 2223 30052022132334 v3_A794a' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SDFII FY 2223 30052022132334 v3_A794a' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SDFII FY 2223 30052022132334 v3_A794a' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SDFII FY 2223 30052022132334 v3_A794a' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SDFII FY 2223 30052022132334 v3_A794a.xlsx' exists in the Datafiles folder and UKPRN '10017794' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017794' for FundingType 'SDFII' and period '2223' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017794' for FundingType 'SDFII' and period '2223'

    # Check the contents of the Appendices
    Then  the file named '10017794_[ContractNo]_v2.pdf' in Sharepoint location 'SDFII-2223-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017794 Co Ltd UKPRN: 10017794
    Master Contract Number: [MasterContractNo] Start Date: 01/04/2022 End Date: 31/03/2023
    Contract Ref: [AllocRef_SDFII]
    Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    Strategic Development Fund II - Capital £50,000 £0 £0 £0 £7,366 £6,974 £4,394 £6,719 £7,626 £5,669 £5,822 £3,685 £1,745
    Strategic Development Fund II - Resource £25,000 £0 £0 £0 £5,554 £2,657 £1,336 £2,568 £3,432 £2,391 £2,723 £1,464 £2,875
   Total Funding £75,000 £0 £0 £0 £12,920 £9,631 £5,730 £9,287 £11,058 £8,060 £8,545 £5,149 £4,620
    Strategic Development Fund II – [AllocRef_SDFII] – Page 1 Ref (for internal use only):  [ContractNo] v2
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2024-04-30 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017794_[ContractNo]_v2.pdf' in 'SDFII-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A794a.pdf'



    # Part 4: Publish and approve. Check financials and feed

    # Change the date
    Given the override date is '01/05/2024'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017794 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2022        | 31/03/2023      | Variation     |
    | 10017794 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/04/2022        | 31/03/2023      | ?             |
    | 10017794 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2022        | 31/03/2023      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef     | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_SDFII]  | 2888882          | Mar-23 | Profile        |
    | [AllocRef_SDFII]  | 2888883          | Mar-23 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                             | DeliverableDescription     | 
    | 10017794 | [ContractNo]   | 2               | [AllocRef_SDFII] | 1               | 0                     | 50000.00     | 0             | 0        | Strategic Development Fund II - Capital     | ?                          |
    | 10017794 | [ContractNo]   | 2               | [AllocRef_SDFII] | 2               | 0                     | 25000.00     | 0             | 0        | Strategic Development Fund II - Resource    | ?                          |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed


    # Check financials and feed

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | [ContractNo]   | [AllocRef_SDFII]   | 1               | 50000.00  | 0.00     | 0.00     | 0.00     | 7366.00  | 6974.00  | 4394.00  | 6719.00  | 7626.00  | 5669.00  | 5822.00  | 3685.00  | 1745.00  | 
    | [ContractNo]   | [AllocRef_SDFII]   | 2               | 25000.00  | 0.00     | 0.00     | 0.00     | 5554.00  | 2657.00  | 1336.00  | 2568.00  | 3432.00  | 2391.00  | 2723.00  | 1464.00  | 2875.00  | 
#
#    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
#    And   the Profile Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
#    | [ContractNo]   | [AllocRef_SDFII]   | 1               | 50136.00  | ?        | ?        | ?        | 7502.00  | 6974.00  | 4394.00  | 6719.00  | 7626.00  | 5669.00  | 5822.00  | 3685.00  | 1745.00  | 
#    | [ContractNo]   | [AllocRef_SDFII]   | 2               | 20772.00  | ?        | ?        | ?        | 1326.00  | 2657.00  | 1336.00  | 2568.00  | 3432.00  | 2391.00  | 2723.00  | 1464.00  | 2875.00  | 
#
#    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
#    And   the Balancing Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
#    | [ContractNo]   | [AllocRef_SDFII]   | 1               | -136.00   | ?        | ?        | ?        | 0.00     | -136.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_SDFII]   | 2               | 4228.00   | ?        | ?        | ?        | 0.00     | 4228.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#
#    # Check the NET AMOUNTS in CRM on the latest approved contract
#    And   the Net Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
#    | [ContractNo]   | [AllocRef_SDFII]   | 1               | 50000.00  | 0.00     | 0.00     | 0.00     | 7502.00  | 6838.00  | 4394.00  | 6719.00  | 7626.00  | 5669.00  | 5822.00  | 3685.00  | 1745.00  | 
#    | [ContractNo]   | [AllocRef_SDFII]   | 2               | 25000.00  | 0.00     | 0.00     | 0.00     | 1326.00  | 6885.00  | 1336.00  | 2568.00  | 3432.00  | 2391.00  | 2723.00  | 1464.00  | 2875.00  | 
#
# 
#    # Check the PROFILE subnominal aggregations in CRM
#    And   the Profile Subnominal Amounts are calculated as follows
#    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Apr-22    | May-22    | Jun-22    | Jul-22    | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    |
#    | 10017794 | [ContractNo]   | [AllocRef_SDFII]   | 2888883                  | 0.00      | 0.00      | 0.00      | 7502.00   | 6838.00   | 4394.00   | 6719.00   | 7626.00   | 5669.00   | 5822.00   | 3685.00   | 1745.00   | 
#    | 10017794 | [ContractNo]   | [AllocRef_SDFII]   | 2888882                  | 0.00      | 0.00      | 0.00      | 1326.00   | 6885.00   | 1336.00   | 2568.00   | 3432.00   | 2391.00   | 2723.00   | 1464.00   | 2875.00   | 
#

#
#    # Check ADP
#
#    # Check all activity has completed
#    When  there are no messages left in the system
#
#    # Check financials on the ADP feed for v1 (v1 is latest approved. v2 is Draft)
#    Then  the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
#    | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 1               | 202204 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 1               | 202205 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 1               | 202206 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 1               | 202207 | ?           | 7502.00        | 0.00             | 0.00                  | 0.00           | 7502.00    |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 1               | 202208 | ?           | 6026.00        | 0.00             | 0.00                  | 0.00           | 6026.00    |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 1               | 202209 | ?           | 4615.00        | 0.00             | 0.00                  | 0.00           | 4615.00    |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 1               | 202210 | ?           | 6738.00        | 0.00             | 0.00                  | 0.00           | 6738.00    |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 1               | 202211 | ?           | 368.00         | 0.00             | 0.00                  | 0.00           | 368.00     |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 1               | 202212 | ?           | 5686.00        | 0.00             | 0.00                  | 0.00           | 5686.00    |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 1               | 202301 | ?           | 5634.00        | 0.00             | 0.00                  | 0.00           | 5634.00    |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 1               | 202302 | ?           | 3680.00        | 0.00             | 0.00                  | 0.00           | 3680.00    |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 1               | 202303 | ?           | 1589.00        | 0.00             | 0.00                  | 0.00           | 1589.00    |
#    #
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 2               | 202204 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 2               | 202205 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 2               | 202206 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 2               | 202207 | ?           | 1326.00        | 0.00             | 0.00                  | 0.00           | 1326.00    |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 2               | 202208 | ?           | 2491.00        | 0.00             | 0.00                  | 0.00           | 2491.00    |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 2               | 202209 | ?           | 1156.00        | 0.00             | 0.00                  | 0.00           | 1156.00    |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 2               | 202210 | ?           | 3001.00        | 0.00             | 0.00                  | 0.00           | 3001.00    |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 2               | 202211 | ?           | 3628.00        | 0.00             | 0.00                  | 0.00           | 3628.00    |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 2               | 202212 | ?           | 2587.00        | 0.00             | 0.00                  | 0.00           | 2587.00    |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 2               | 202301 | ?           | 2883.00        | 0.00             | 0.00                  | 0.00           | 2883.00    |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 2               | 202302 | ?           | 1491.00        | 0.00             | 0.00                  | 0.00           | 1491.00    |
#    | [ContractNo]       | 1             | [AllocRef_SDFII] | 2               | 202303 | ?           | 2556.00        | 0.00             | 0.00                  | 0.00           | 2556.00    |
#
#
#   




    # Part 5: Payment Batch for SDFII2223 for Sep 22. Check feed

    # Change the date
    Given the override date is '02/05/2024 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'SDFII2223' AccountingPaymentPeriod '202402' CensusEndDate '02/05/2024' and LinkCodeSuffix 'R'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    |  [AllocRef_SDFII]        | 202405 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | SDFII2223                  | 202405               |                      | R              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | SDFII2223                  | 202405               | Completed |

    ## Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    #And   the Payment feed xml for FundingStreamPeriod 'SDFII2223' PaymentPeriod '202402' CensusEndDate '02/05/2024' and LinkCodeSuffix 'R' is decrypted and saved to 'DataFiles/Downloads' as 'A794a.xml'

#    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'SDFII2223' PaymentPeriod '202206' CensusEndDate '02/09/2022' and LinkCodeSuffix 'A' includes the following values
#    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    | SDF2                   | 2022          | 06             | 02          | ?       | SDFII-795     | 7523.00         | PROFILE          | SDFII Capital          | 2022-09-16 | 2022-04-01   | 2023-03-31 | ?              | 10017795 | 2888883    |
#    | SDF2                   | 2022          | 06             | 02          | ?       | SDFII-795     | 116.000         | PROFILE          | SDFII Resource         | 2022-09-16 | 2022-04-01   | 2023-03-31 | ?              | 10017795 | 2888882    |
#
#
#
#    # Retrieve data from the Payment Feed and check for specific items and values (23926)
#    Then  there is an item on the Payment feed for FundingStreamPeriod 'SDFII2223' AccountingPaymentPeriod '202206' and CensusEndDate '02/09/2022'
#
#    # Title details
#    And   the Payment feed item TITLE is as follows
#    | Title                                                                                                                                                          |
#    | Payment Requests for Funding Stream Period SDFII2223 for Payment Period 202206 have been generated as of Census End Date/Time 2022-09-02T22:00:00Z. |
#
#    # Summary details
#    And   the Payment feed item SUMMARY is as follows
#    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
#    | SDFII2223           | 202206        | 2022-09-02T22:00:00Z  | 2                | 7639.00    |
#
#    # PaymentPeriod details
#    And   the Payment feed item PaymentPeriod details are as follows
#    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
#    | ESFA   | SDF2      | 01/04/2022   | 31/03/2023 | 02/09/2022    | 16/09/2022 | 2022          | 06             |
#
#    # PaymentDetails
#    And   the Payment feed item PaymentDetails are as follows
#    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
#    | ORG0017795  | 10017795       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | SDFII-795  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2888883    | PROFILE        | SDFII Capital                 | 7523.00         |
#    | ORG0017795  | 10017795       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | SDFII-795  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2888882    | PROFILE        | SDFII Resource                | 116.00          |




    # Part 5: CDA
    
    # Change the date
    Given the override date is '03/05/2024'

    # Run the CDA report
    Given there is no CDA report named 'CDA Last Approved Version A794.csv'
    Given there is no CDA report named 'CDA Latest Version A794.csv'

    #And   the following contracts are in the replicated CRM database
    #| ContractNumber | ContractVersionNumber |
    #| [ContractNo]   | 2                     |

    When  the following CDA report is run
    | FundingStreamPeriod   | Version               | Suffix |
    | SDFII2223             | Last Approved Version | A794   |
    | SDFII2223             | Latest Version        | A794   |

    Then  a report named 'CDA Last Approved Version A794.csv' is created
    Then  a report named 'CDA Latest Version A794.csv' is created

    # Check the contents of the CDA report
    #And   the following rows are present in the report
    #| FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus  | DeliverableDescription  | Deliverable                               | DeliverableParent   | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Capital   |                     | 4                 | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888883           |                          |                   | Apr              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Capital   |                     | 5                 | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888883           |                          |                   | May              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Capital   |                     | 6                 | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888883           |                          |                   | Jun              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Capital   |                     | 7                 | 2022            | 2022/23       |              | 7366         |              | 0             |              | Yes                | 7502.00        | 0.00             | 0.00                  | 0.00           | 7502.00         |             | No            |                   |        | 2888883           |                          |                   | Jul              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Capital   |                     | 8                 | 2022            | 2022/23       |              | 6974         |              | 0             |              | Yes                | 6974.00        | -136.00          | 0.00                  | 0.00           | 6838.00         |             | No            |                   |        | 2888883           |                          |                   | Aug              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Capital   |                     | 9                 | 2022            | 2022/23       |              | 4394         |              | 0             |              | Yes                | 4394.00        |                  | 0.00                  | 0.00           | 4394.00         |             | No            |                   |        | 2888883           |                          |                   | Sep              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Capital   |                     | 10                | 2022            | 2022/23       |              | 6719         |              | 0             |              | Yes                | 6719.00        |                  | 0.00                  | 0.00           | 6719.00         |             | No            |                   |        | 2888883           |                          |                   | Oct              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Capital   |                     | 11                | 2022            | 2022/23       |              | 7626         |              | 0             |              | Yes                | 7626.00        |                  | 0.00                  | 0.00           | 7626.00         |             | No            |                   |        | 2888883           |                          |                   | Nov              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Capital   |                     | 12                | 2022            | 2022/23       |              | 5669         |              | 0             |              | Yes                | 5669.00        |                  | 0.00                  | 0.00           | 5669.00         |             | No            |                   |        | 2888883           |                          |                   | Dec              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Capital   |                     | 1                 | 2023            | 2022/23       |              | 5822         |              | 0             |              | Yes                | 5822.00        |                  | 0.00                  | 0.00           | 5822.00         |             | No            |                   |        | 2888883           |                          |                   | Jan              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Capital   |                     | 2                 | 2023            | 2022/23       |              | 3685         |              | 0             |              | Yes                | 3685.00        |                  | 0.00                  | 0.00           | 3685.00         |             | No            |                   |        | 2888883           |                          |                   | Feb              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Capital   |                     | 3                 | 2023            | 2022/23       |              | 1745         |              | 0             |              | Yes                | 1745.00        |                  | 0.00                  | 0.00           | 1745.00         |             | No            |                   |        | 2888883           |                          |                   | Mar              |
    ##
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Resource  |                     | 4                 | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888882           |                          |                   | Apr              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Resource  |                     | 5                 | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888882           |                          |                   | May              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Resource  |                     | 6                 | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888882           |                          |                   | Jun              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Resource  |                     | 7                 | 2022            | 2022/23       |              | 5554         |              | 0             |              | Yes                | 1326.00        | 0.00             | 0.00                  | 0.00           | 1326.00         |             | No            |                   |        | 2888882           |                          |                   | Jul              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Resource  |                     | 8                 | 2022            | 2022/23       |              | 2657         |              | 0             |              | Yes                | 2657.00        | 4228.00          | 0.00                  | 0.00           | 6885.00         |             | No            |                   |        | 2888882           |                          |                   | Aug              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Resource  |                     | 9                 | 2022            | 2022/23       |              | 1336         |              | 0             |              | Yes                | 1336.00        |                  | 0.00                  | 0.00           | 1336.00         |             | No            |                   |        | 2888882           |                          |                   | Sep              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Resource  |                     | 10                | 2022            | 2022/23       |              | 2568         |              | 0             |              | Yes                | 2568.00        |                  | 0.00                  | 0.00           | 2568.00         |             | No            |                   |        | 2888882           |                          |                   | Oct              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Resource  |                     | 11                | 2022            | 2022/23       |              | 3432         |              | 0             |              | Yes                | 3432.00        |                  | 0.00                  | 0.00           | 3432.00         |             | No            |                   |        | 2888882           |                          |                   | Nov              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Resource  |                     | 12                | 2022            | 2022/23       |              | 2391         |              | 0             |              | Yes                | 2391.00        |                  | 0.00                  | 0.00           | 2391.00         |             | No            |                   |        | 2888882           |                          |                   | Dec              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Resource  |                     | 1                 | 2023            | 2022/23       |              | 2723         |              | 0             |              | Yes                | 2723.00        |                  | 0.00                  | 0.00           | 2723.00         |             | No            |                   |        | 2888882           |                          |                   | Jan              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Resource  |                     | 2                 | 2023            | 2022/23       |              | 1464         |              | 0             |              | Yes                | 1464.00        |                  | 0.00                  | 0.00           | 1464.00         |             | No            |                   |        | 2888882           |                          |                   | Feb              |
    #| SDFII2223               | 10017794 | 10017794 Co Ltd             |               |                             | [AllocRef_SDFII]         | [ContractNo]   | [MasterContractNo]      | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved           |                         | Strategic Development Fund II - Resource  |                     | 3                 | 2023            | 2022/23       |              | 2875         |              | 0             |              | Yes                | 2875.00        |                  | 0.00                  | 0.00           | 2875.00         |             | No            |                   |        | 2888882           |                          |                   | Mar              |



    # Part 10: Create Consolidated Payment Summary rpt
   
    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    #Given the override date is '06/01/2023 10:00'

   Given there are no files prefixed '2024-05 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
   
   When  a Consolidated Payment Summary Report is created in Sharepoint for '03/05/2024'
    # Check the above report manually


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Complete
Scenario: A795 Create a new 22/23 SDFII contract. Update Draft. Approve. NFA. Payment Batch. Check docs, CRM, PaaS and feed

    # 1. Create a draft 22/23 contract
    # 2. Bulk Update Draft to create v1.1 and check docs
    # 3. Publish and approve. Check financials
    # 4. Non Financial Variation amendment to create draft v2. Check docs
    # 5. Payment Batch for SDFII2223 for Sep 22. Check feed
    # 6. Consolidated Payment Summary Report

    Given there are no allocations marked as Under Termination for UKPRN '10017795' 
    And   there are no terminated or closed allocations for UKPRN '10017795' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017795' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017795' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017795' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | SDFII-795     |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | SDFII-795     |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | SDFII2223         |

    # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
    And   there is no Subnominal data in CRM for the following subnominal codes
    | SubnominalCode |
    | 2888882        |
    | 2888883        |


    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | SDF2-795       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017795'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017795' 
    And   there is no caseload advisor for UKPRN '10017795' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017795 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017795' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017795 Co Ltd' with UKPRN '10017795' and OrgId 'ORG0017795' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017795 | 117795 | 10017795 Co Ltd | 0              | Active                | Yes           | AA017795      | ?             | 37a Star Street        | ?                      | ?                      | ?                      | Ware                   | Hertfordshire          | SG12 7AA  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017795 |





    # Part 1: Create a draft 22/23 contract
    
    # Change the date
    Given the override date is '01/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'SDF2-795'
    And   there are no details in ContractManagement.CreatedContract for 'SDF2-795'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017795 | 10017795 Co Ltd      | ESFA-795             | SDF2-795       | 1                     | 01/04/2022        | 31/03/2023      | 39160.00      |                                       | Contract for Services                      | 2223   | New          | ORG0017795 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017795 | SDF2-795       | SDFII-795     | SDFII             | SDFII2223               | FY                      | 01/04/2022          | 31/03/2023        | 39160.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017795 | SDF2-795       | SDFII-795     | 1               | 0                     | 21623.00  | 1737.00  | 1050.00  | 393.00   | 1381.00  | 2117.00  | 892.00   | 867.00   | 3659.00  | 2686.00  | 922.00   | 2512.00  | 3407.00  | Strategic Development Fund II - Capital                         | New          |             | 
    | 10017795 | SDF2-795       | SDFII-795     | 2               | 0                     | 17537.00  | 1646.00  | 327.00   | 1567.00  | 564.00   | 856.00   | 2699.00  | 1854.00  | 1671.00  | 1236.00  | 2541.00  | 2328.00  | 248.00   | Strategic Development Fund II - Resource                        | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | SDF2-795       | 1                     | 0                        | 2022-07-01 09:12:35.000 |





    # Part 2: Bulk Update Draft to create v1.1 and check docs
    
    # Change the date
    Given the override date is '11/07/2022'

    # Bulk file (Update Draft)
    And   there are no files prefixed '10017795' in the Sharepoint 'SDFII-2223-Input-Appendices' folder
    And   there are no files prefixed 'SDFII FY 2223 31052022091440 v3_A795' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SDFII FY 2223 31052022091440 v3_A795' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SDFII FY 2223 31052022091440 v3_A795' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SDFII FY 2223 31052022091440 v3_A795' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SDFII FY 2223 31052022091440 v3_A795.xlsx' exists in the Datafiles folder and UKPRN '10017795' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017795' for FundingType 'SDFII' and period '2223' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017795' for FundingType 'SDFII' and period '2223'

    # Check the contents of the Appendices
   #Then  the file named '10017795_[ContractNo]_v1.pdf' in Sharepoint location 'SDFII-2223-Input-Appendices' contains the following lines in order
    Then  the file named '10017795_SDF2-795_v1.pdf' in Sharepoint location 'SDFII-2223-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017795 Co Ltd UKPRN: 10017795
    Master Contract Number: ESFA-795 Start Date: 01/04/2022 End Date: 31/03/2023
    Contract Ref: SDFII-795
    Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    Strategic Development Fund II - Capital £25,000 £0 £0 £0 £0 £984 £7,523 £1,396 £3,277 £644 £592 £6,086 £4,498
    Strategic Development Fund II - Resource £15,000 £0 £0 £0 £0 £5,400 £116 £1,910 £1,536 £2,545 £1,802 £337 £1,354
    Total Funding £40,000 £0 £0 £0 £0 £6,384 £7,639 £3,306 £4,813 £3,189 £2,394 £6,423 £5,852
    Strategic Development Fund II – SDFII-795 – Page 1 Ref (for internal use only):  SDF2-795 v1
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | SDF2-795       | 1                     | 1                        | 2022-07-01 09:12:35.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017795_[ContractNo]_v1.pdf' in 'SDFII-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A795.pdf'





    # Part 3: Publish and approve. Check financials

    Given the override date is '13/07/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'SDF2-795'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-795' and ContractNumber 'SDF2-795' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'SDF2-795' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017795 | SDF2-795           | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/04/2022        | 31/03/2023      | ?             |
    | 10017795 | SDF2-795           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/04/2022        | 31/03/2023      | ?             |
    | 10017795 | ESFA-795           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2022        | 31/03/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'SDF2-795' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'SDF2-795'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | SDFII-795       | 2888883          | Mar-23 | Profile        |
    | SDFII-795       | 2888882          | Mar-23 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                              | DeliverableDescription    | 
    | 10017795 | SDF2-795       | 1               | SDFII-795     | 1               | 0                     | 25000.00     | 0             | 0        | Strategic Development Fund II - Capital      | ?                         |
    | 10017795 | SDF2-795       | 1               | SDFII-795     | 2               | 0                     | 15000.00     | 0             | 0        | Strategic Development Fund II - Resource     | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'SDF2-795' agree with the most recent entry for this contract in the ContractManagement feed

    
    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | SDF2-795       | SDFII-795          | 1               | 25000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 984.00   | 7523.00  | 1396.00  | 3277.00  | 644.00   | 592.00   | 6086.00  | 4498.00  | 
    | SDF2-795       | SDFII-795          | 2               | 15000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5400.00  | 116.00   | 1910.00  | 1536.00  | 2545.00  | 1802.00  | 337.00   | 1354.00  | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | SDF2-795       | SDFII-795          | 1               | 25000.00  | ?        | ?        | ?        | ?        | 984.00   | 7523.00  | 1396.00  | 3277.00  | 644.00   | 592.00   | 6086.00  | 4498.00  | 
    | SDF2-795       | SDFII-795          | 2               | 15000.00  | ?        | ?        | ?        | ?        | 5400.00  | 116.00   | 1910.00  | 1536.00  | 2545.00  | 1802.00  | 337.00   | 1354.00  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | SDF2-795       | SDFII-795          | 1               | 25000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 984.00   | 7523.00  | 1396.00  | 3277.00  | 644.00   | 592.00   | 6086.00  | 4498.00  | 
    | SDF2-795       | SDFII-795          | 2               | 15000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 5400.00  | 116.00   | 1910.00  | 1536.00  | 2545.00  | 1802.00  | 337.00   | 1354.00  | 


    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal  | Apr-22    | May-22    | Jun-22    | Jul-22    | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    |
    | 10017795 | SDF2-795       | SDFII-795          | 2888883            | 0.00      | 0.00      | 0.00      | 0.00      | 984.00    | 7523.00   | 1396.00   | 3277.00   | 644.00    | 592.00    | 6086.00   | 4498.00   | 
    | 10017795 | SDF2-795       | SDFII-795          | 2888882            | 0.00      | 0.00      | 0.00      | 0.00      | 5400.00   | 116.00    | 1910.00   | 1536.00   | 2545.00   | 1802.00   | 337.00    | 1354.00   | 





    # Part 4: Non Financial Variation amendment to create draft v2. Check docs
    
    # Change the date
    Given the override date is '17/07/2022'

    # Initiate non-financial amendment request on v1 to create v2
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '1' of contract 'SDF2-795' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '1' of contract 'SDF2-795' for a non-financial VARIATION contract amendment

    # Check that the deliverables have all been created in CRM
    Then  there are '24' deliverable periods in CRM linked to the latest version of contract 'SDF2-795' and allocation 'SDFII-795'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017795 | SDF2-795           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2022        | 31/03/2023      | Variation     |
    | 10017795 | SDF2-795           | 1                     | 1                        | Approved         | Approved                  | False         | True                | 01/04/2022        | 31/03/2023      | ?             |
    | 10017795 | SDF2-795           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/04/2022        | 31/03/2023      | ?             |
    | 10017795 | ESFA-795           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2022        | 31/03/2023      | ?             |

    # Check the contents of the Appendices (Only the contract version number should have changed)
   #Then  the file named '10017795_[ContractNo]_v2.pdf' in Sharepoint location 'SDFII-2223-Input-Appendices' contains the following lines in order
    Then  the file named '10017795_SDF2-795_v2.pdf' in Sharepoint location 'SDFII-2223-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017795 Co Ltd UKPRN: 10017795
    Master Contract Number: ESFA-795 Start Date: 01/04/2022 End Date: 31/03/2023
    Contract Ref: SDFII-795
    Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    Strategic Development Fund II - Capital £25,000 £0 £0 £0 £0 £984 £7,523 £1,396 £3,277 £644 £592 £6,086 £4,498
    Strategic Development Fund II - Resource £15,000 £0 £0 £0 £0 £5,400 £116 £1,910 £1,536 £2,545 £1,802 £337 £1,354
    Total Funding £40,000 £0 £0 £0 £0 £6,384 £7,639 £3,306 £4,813 £3,189 £2,394 £6,423 £5,852
    Strategic Development Fund II – SDFII-795 – Page 1 Ref (for internal use only):  SDF2-795 v2
    """

   # Contract is now at Awaiting Documentation
    
    
  
  

    # Part 5: Payment Batch for SDFII2223 for Sep 22. Check feed

    # Change the date
    Given the override date is '02/09/2022 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'SDFII2223' AccountingPaymentPeriod '202206' CensusEndDate '02/09/2022' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | SDFII-795                | 202209 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | SDFII2223                  | 202209               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | SDFII2223                  | 202209               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SDFII2223' PaymentPeriod '202206' CensusEndDate '02/09/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A795.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SDFII2223' PaymentPeriod '202206' CensusEndDate '02/09/2022' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | SDF2                   | 2022          | 06             | 02          | ?       | SDFII-795     | 7523.00         | PROFILE          | SDFII Capital          | 2022-09-16 | 2022-04-01   | 2023-03-31 | ?              | 10017795 | 2888883    |
    | SDF2                   | 2022          | 06             | 02          | ?       | SDFII-795     | 116.000         | PROFILE          | SDFII Resource         | 2022-09-16 | 2022-04-01   | 2023-03-31 | ?              | 10017795 | 2888882    |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'SDFII2223' AccountingPaymentPeriod '202206' and CensusEndDate '02/09/2022'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                          |
    | Payment Requests for Funding Stream Period SDFII2223 for Payment Period 202206 have been generated as of Census End Date/Time 2022-09-02T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | SDFII2223           | 202206        | 2022-09-02T22:00:00Z  | 2                | 7639.00    |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | DFE   | SDF2      | 01/04/2022   | 31/03/2023 | 02/09/2022    | 16/09/2022 | 2022          | 06             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017795  | 10017795       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | SDFII-795  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2888883    | PROFILE        | SDFII Capital                 | 7523.00         |
    | ORG0017795  | 10017795       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | SDFII-795  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2888882    | PROFILE        | SDFII Resource                | 116.00          |



    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check financials on the ADP feed
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
    | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
    | SDF2-795           | 1             | SDFII-795        | 1               | 202204 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | SDF2-795           | 1             | SDFII-795        | 1               | 202205 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | SDF2-795           | 1             | SDFII-795        | 1               | 202206 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | SDF2-795           | 1             | SDFII-795        | 1               | 202207 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | SDF2-795           | 1             | SDFII-795        | 1               | 202208 | ?           | 984.00         | 0.00             | 0.00                  | 0.00           | 984.00     |
    | SDF2-795           | 1             | SDFII-795        | 1               | 202209 | ?           | 7523.00        | 0.00             | 0.00                  | 0.00           | 7523.00    |
    | SDF2-795           | 1             | SDFII-795        | 1               | 202210 | ?           | 1396.00        | 0.00             | 0.00                  | 0.00           | 1396.00    |
    | SDF2-795           | 1             | SDFII-795        | 1               | 202211 | ?           | 3277.00        | 0.00             | 0.00                  | 0.00           | 3277.00    |
    | SDF2-795           | 1             | SDFII-795        | 1               | 202212 | ?           | 644.00         | 0.00             | 0.00                  | 0.00           | 644.00     |
    | SDF2-795           | 1             | SDFII-795        | 1               | 202301 | ?           | 592.00         | 0.00             | 0.00                  | 0.00           | 592.00     |
    | SDF2-795           | 1             | SDFII-795        | 1               | 202302 | ?           | 6086.00        | 0.00             | 0.00                  | 0.00           | 6086.00    |
    | SDF2-795           | 1             | SDFII-795        | 1               | 202303 | ?           | 4498.00        | 0.00             | 0.00                  | 0.00           | 4498.00    |
    #                                                                                            
    | SDF2-795           | 1             | SDFII-795        | 2               | 202204 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | SDF2-795           | 1             | SDFII-795        | 2               | 202205 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | SDF2-795           | 1             | SDFII-795        | 2               | 202206 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | SDF2-795           | 1             | SDFII-795        | 2               | 202207 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | SDF2-795           | 1             | SDFII-795        | 2               | 202208 | ?           | 5400.00        | 0.00             | 0.00                  | 0.00           | 5400.00    |
    | SDF2-795           | 1             | SDFII-795        | 2               | 202209 | ?           | 116.00         | 0.00             | 0.00                  | 0.00           | 116.00     |
    | SDF2-795           | 1             | SDFII-795        | 2               | 202210 | ?           | 1910.00        | 0.00             | 0.00                  | 0.00           | 1910.00    |
    | SDF2-795           | 1             | SDFII-795        | 2               | 202211 | ?           | 1536.00        | 0.00             | 0.00                  | 0.00           | 1536.00    |
    | SDF2-795           | 1             | SDFII-795        | 2               | 202212 | ?           | 2545.00        | 0.00             | 0.00                  | 0.00           | 2545.00    |
    | SDF2-795           | 1             | SDFII-795        | 2               | 202301 | ?           | 1802.00        | 0.00             | 0.00                  | 0.00           | 1802.00    |
    | SDF2-795           | 1             | SDFII-795        | 2               | 202302 | ?           | 337.00         | 0.00             | 0.00                  | 0.00           | 337.00     |
    | SDF2-795           | 1             | SDFII-795        | 2               | 202303 | ?           | 1354.00        | 0.00             | 0.00                  | 0.00           | 1354.00    |



    # Part 6: Consolidated Payment Summary Report

    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    When a Consolidated Payment Summary Report is created in Sharepoint for '18/09/2022'
    # Check the above report manually


    # Tidy Up
 #  Given the override date is reset

