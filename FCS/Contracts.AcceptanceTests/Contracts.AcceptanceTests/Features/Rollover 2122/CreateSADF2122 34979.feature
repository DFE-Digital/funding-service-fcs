Feature: CreateSADF2122 34979

@AcceptanceTest @Withdrawn25072024
Scenario: A626 Bulk load a new SADF2122 contract. Publish and approve. Check docs, financials and CM feed. Bulk load SADF2233. Publish and approve. Check docs, financials and CM feed.
    
    # Part 1: Bulk load a new SADF2122 contract and check docs
    # Part 2: Publish and approve 21/22 contract
    # Part 3: Check financials and feed
    # Part 4: Bulk New Amendment to extend SADF contract into 22/23. Check docs
    # Part 5: Publish and approve 22/23 contract
    # Part 6: Check financials and feed
  
    Given there are no allocations marked as Under Termination for UKPRN '10017626' 
    And   there are no terminated or closed allocations for UKPRN '10017626' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017626' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017626' 
 
#    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
#    Given there is no data in the ContractManagement.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017626' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | SADF-626      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | SADF-626      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | SADF2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | SAD-626        | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017626'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017626' 
    And   there is no caseload advisor for UKPRN '10017626' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017626 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017626' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017626 Co Ltd' with UKPRN '10017626' and OrgId 'ORG0017626' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017626 | 117626 | 10017626 Co Ltd | 0              | Active                | Yes           | AA017626      | ?             | 2 Forest Lawns         | 33 Orchard Road        | Bromley                | ?                      | ?                      | ?                      | BR1 2TG   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017626 |





    # Part 1: Bulk load a new SADF2122 contract and check docs
    
    # Change the date
    Given the override date is '01/09/2021'

    # Bulk file
    And   there are no files prefixed '10017626' in the Sharepoint 'SADF-2122-Input-Appendices' folder
    And   there are no files prefixed 'SADF FY 2122 31082021160043 v3_A626' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SADF FY 2122 31082021160043 v3_A626' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SADF FY 2122 31082021160043 v3_A626' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SADF FY 2122 31082021160043 v3_A626' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SADF FY 2122 31082021160043 v3_A626.xlsx' exists in the Datafiles folder and UKPRN '10017626' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017626' for FundingType 'SADF' and period '2122' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017626' for FundingType 'SADF' and period '2122'

    # Check the contents of the Appendices
    Then  the file named '10017626_[ContractNo]_v1.pdf' in Sharepoint location 'SADF-2122-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017626 Co Ltd UKPRN: 10017626
    Master Contract Number: [MasterContractNo] Start Date: 01/04/2021 End Date: 31/03/2022
    Contract Ref: [AllocRef_SADF]
    Cash (£) Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    Skills Accelerator Development Fund - Capital £30,000 £0 £0 £0 £0 £0 £0 £16,405 £0 £0 £13,595 £0 £0
    Skills Accelerator Development Fund - Resource £10,000 £0 £0 £0 £0 £0 £0 £3,879 £0 £0 £6,121 £0 £0
    Total Funding £40,000 £0 £0 £0 £0 £0 £0 £20,284 £0 £0 £19,716 £0 £0
    Skills Accelerator Development Fund – [AllocRef_SADF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017626_[ContractNo]_v1.pdf' in 'SADF-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A626.pdf'

    # Display Sharepoint filename
    And   message '10017626_[ContractNo]_v1.pdf' is written to the Output window





    # Part 2: Publish and approve 21/22 contract
    
    # Change the date
    Given the override date is '02/09/2021'
   
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
    | 10017626 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017626 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_SADF] | 100802           | Mar-22 | Profile        |
    | [AllocRef_SADF] | 2888881          | Mar-22 | Profile        |




    # Part 3: Check financials and feed

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | [ContractNo]   | [AllocRef_SADF]    | 1               | 30000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16405.00 | 0.00     | 0.00     | 13595.00 | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SADF]    | 2               | 10000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3879.00  | 0.00     | 0.00     | 6121.00  | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | [ContractNo]   | [AllocRef_SADF]    | 1               | 30000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16405.00 | 0.00     | 0.00     | 13595.00 | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SADF]    | 2               | 10000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3879.00  | 0.00     | 0.00     | 6121.00  | 0.00     | 0.00     | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal  | Apr-21    | May-21    | Jun-21    | Jul-21    | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    |
    | 10017626 | [ContractNo]   | [AllocRef_SADF]    | 100802             | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 3879.00   | 0.00      | 0.00      | 6121.00   | 0.00      | 0.00      | 
    | 10017626 | [ContractNo]   | [AllocRef_SADF]    | 2888881            | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 16405.00  | 0.00      | 0.00      | 13595.00  | 0.00      | 0.00      | 


    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                 | DeliverableDescription   | 
    | 10017626 | [ContractNo]   | 1               | [AllocRef_SADF] | 1               | 0                     | 30000.00     | 0             | 0        | Skills Accelerator Development Fund - Capital   | ?                        |
    | 10017626 | [ContractNo]   | 1               | [AllocRef_SADF] | 2               | 0                     | 10000.00     | 0             | 0        | Skills Accelerator Development Fund - Resource  | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed





    # Part 4: Bulk New Amendment to extend SADF contract into 22/23

    # Change the date
    Given the override date is '01/03/2022'

    # Bulk file (New amendment)
    And   there are no files prefixed '10017626' in the Sharepoint 'SADF-2223-Input-Appendices' folder
    And   there are no files prefixed 'SADF FY 2223 22022022103041 v3_A626' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SADF FY 2223 22022022103041 v3_A626' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SADF FY 2223 22022022103041 v3_A626' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SADF FY 2223 22022022103041 v3_A626' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SADF FY 2223 22022022103041 v3_A626.xlsx' exists in the Datafiles folder and UKPRN '10017626' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017626' for FundingType 'SADF' and period '2223' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017626' for FundingType 'SADF' and period '2223'

    # Check the contents of the Appendices
    Then  the file named '10017626_[ContractNo]_v1.pdf' in Sharepoint location 'SADF-2223-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017626 Co Ltd UKPRN: 10017626
    Master Contract Number: [MasterContractNo] Start Date: 01/04/2022 End Date: 31/03/2023
    Contract Ref: [AllocRef_SADF]
    Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    Skills Accelerator Development Fund - Capital £35,000 £2,660 £2,002 £250 £3,393 £1,917 £1,886 £2,628 £4,210 £1,577 £1,524 £7,522 £5,431
    Skills Accelerator Development Fund - Resource £25,000 £1,641 £5,059 £1,980 £1,217 £1,333 £1,047 £4,509 £1,469 £3,477 £1,662 £1,269 £337
    Total Funding £60,000 £4,301 £7,061 £2,230 £4,610 £3,250 £2,933 £7,137 £5,679 £5,054 £3,186 £8,791 £5,768
    Skills Accelerator Development Fund – [AllocRef_SADF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017626_[ContractNo]_v1.pdf' in 'SADF-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A626a.pdf'
   #And   Sharepoint file '<filename1.pdf>' in 'SADF-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A626.pdf'

    # Display Sharepoint filename
    And   message '10017626_[ContractNo]_v1.pdf' is written to the Output window





    # Part 5: Publish and approve 22/23 contract
    
    # Change the date
    Given the override date is '05/03/2022'
   
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
    | 10017626 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2022        | 31/03/2023      | ?             |
    | 10017626 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_SADF] | 100802           | Mar-23 | Profile        |
    | [AllocRef_SADF] | 2888881          | Mar-23 | Profile        |





    # Part 6: Check financials and feed
        
    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | [ContractNo]   | [AllocRef_SADF]    | 1               | 35000.00  | 2660.00  | 2002.00  | 250.00   | 3393.00  | 1917.00  | 1886.00  | 2628.00  | 4210.00  | 1577.00  | 1524.00  | 7522.00  | 5431.00  | 
    | [ContractNo]   | [AllocRef_SADF]    | 2               | 25000.00  | 1641.00  | 5059.00  | 1980.00  | 1217.00  | 1333.00  | 1047.00  | 4509.00  | 1469.00  | 3477.00  | 1662.00  | 1269.00  | 337.00   | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | [ContractNo]   | [AllocRef_SADF]    | 1               | 35000.00  | 2660.00  | 2002.00  | 250.00   | 3393.00  | 1917.00  | 1886.00  | 2628.00  | 4210.00  | 1577.00  | 1524.00  | 7522.00  | 5431.00  | 
    | [ContractNo]   | [AllocRef_SADF]    | 2               | 25000.00  | 1641.00  | 5059.00  | 1980.00  | 1217.00  | 1333.00  | 1047.00  | 4509.00  | 1469.00  | 3477.00  | 1662.00  | 1269.00  | 337.00   | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | [ContractNo]   | [AllocRef_SADF]    | 1               | 35000.00  | 2660.00  | 2002.00  | 250.00   | 3393.00  | 1917.00  | 1886.00  | 2628.00  | 4210.00  | 1577.00  | 1524.00  | 7522.00  | 5431.00  | 
    | [ContractNo]   | [AllocRef_SADF]    | 2               | 25000.00  | 1641.00  | 5059.00  | 1980.00  | 1217.00  | 1333.00  | 1047.00  | 4509.00  | 1469.00  | 3477.00  | 1662.00  | 1269.00  | 337.00   | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef     | ProfileSubnominal | Apr-22    | May-22    | Jun-22    | Jul-22    | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    |
    | 10017626 | [ContractNo]   | [AllocRef_SADF]   | 2888881           | 2660.00   | 2002.00   | 250.00    | 3393.00   | 1917.00   | 1886.00   | 2628.00   | 4210.00   | 1577.00   | 1524.00   | 7522.00   | 5431.00   | 
    | 10017626 | [ContractNo]   | [AllocRef_SADF]   | 100802            | 1641.00   | 5059.00   | 1980.00   | 1217.00   | 1333.00   | 1047.00   | 4509.00   | 1469.00   | 3477.00   | 1662.00   | 1269.00   | 337.00    | 


    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                 | DeliverableDescription   | 
    | 10017626 | [ContractNo]   | 1               | [AllocRef_SADF] | 1               | 0                     | 35000.00     | 0             | 0        | Skills Accelerator Development Fund - Capital   | ?                        |
    | 10017626 | [ContractNo]   | 1               | [AllocRef_SADF] | 2               | 0                     | 25000.00     | 0             | 0        | Skills Accelerator Development Fund - Resource  | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed


    # Tidy Up
    Given the override date is reset

#    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
#    Given there is no data in the ContractManagement.FundingAllocationRelease table

@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run67
Scenario: A627 Create and approve a SADF2122 contract. Amend and approve. Check docs. CDA. Payment batch. Check financials and feed. Add SADF2223. NFA. Payment batch. Check financials and feed

    # 1. Create and approve a SADF2122 contract
    # 2. Check CM feed
    # 3. Bulk amend contract and check docs
    # 4. Publish and approve 21/22 contract v2
    # 5. Check CM feed
    # 6. CDA for 21/22
    # 7. Payment Batch for SADF2122
    # 8. Check financials and feed
    # 9. Bulk New Amendment to add SADF2223    
    # 10. Publish and approve 22/23 contract v1 
    # 11. NFA to create 22/23 v2 and check docs
    # 12. Publish and approve 22/23 contract v2
    # 13. Payment Batch for SADF2223
    # 14. Check financials and feed
    # 15. CDA for 22/23

    Given there are no allocations marked as Under Termination for UKPRN '10017627' 
    And   there are no terminated or closed allocations for UKPRN '10017627' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017627' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017627' 
 
#    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
#    Given there is no data in the ContractManagement.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017627' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | SADF-627      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | SADF-627      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | SADF2122          |
    | SADF2223          |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017627'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017627' 
    And   there is no caseload advisor for UKPRN '10017627' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017627 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017627' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017627 Co Ltd' with UKPRN '10017627' and OrgId 'ORG0017627' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017627 | 117627 | 10017627 Co Ltd | 0              | In Administration     | Yes           | AA017627      | ?             | 1 Church Mews          | ?                      | ?                      | ?                      | Clophill               | Bedfordshire           | MK45 4BQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017627 |





    # Part1 : Create and approve a SADF2122 contract

    # Change the date
    Given the override date is '01/09/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'SAD-627'
    And   there are no details in ContractManagement.CreatedContract for 'SAD-627'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017627 | 10017627 Co Ltd      | ESFA-627             | SAD-627        | 1                     | 01/04/2021        | 31/03/2022      | 15896.00      |                                       | Contract for Services                      | 2122   | New          | ORG0017627 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017627 | SAD-627        | SADF-627      | SADF              | SADF2122                | FY                      | 01/04/2021          | 31/03/2022        | 15896.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017627 | SAD-627        | SADF-627      | 1               | 0                     | 12707.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6697.00  | 0.00     | 0.00     | 6010.00  | 0.00     | 0.00     | Skills Accelerator Development Fund - Capital                   | New          |             | 
    | 10017627 | SAD-627        | SADF-627      | 2               | 0                     | 3189.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2951.00  | 0.00     | 0.00     | 238.00   | 0.00     | 0.00     | Skills Accelerator Development Fund - Resource                  | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | SAD-627        | 1                     | 0                        | 2021-09-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'SAD-627'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-627' and actual ContractNumber 'SAD-627'

    # Check that the contract is now approved
    Then  the latest version of contract 'SAD-627' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017627 | SAD-627            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017627 | ESFA-627           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'SAD-627'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | SADF-627        | 2888881          | Mar-22 | Profile        |
    | SADF-627        | 100802           | Mar-22 | Profile        |

    
    
    
    
    # Part 2: Check CM Feed

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'SAD-627' agree with the most recent entry for this contract in the ContractManagement feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                   | DeliverableDescription       | 
    | 10017627 | SAD-627        | 1               | SADF-627      | 1               | 0                     | 12707.00     | 0             | 0        | Skills Accelerator Development Fund - Capital     | ?                            |
    | 10017627 | SAD-627        | 1               | SADF-627      | 2               | 0                     | 3189.00      | 0             | 0        | Skills Accelerator Development Fund - Resource    | ?                            |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'SAD-627' agree with the most recent entry for this contract in the ContractManagement feed





    # Part 3: Bulk amend contract and check docs 

    # Change the date
    Given the override date is '13/09/2021'

    # Bulk file
    And   there are no files prefixed '10017627' in the Sharepoint 'SADF-2122-Input-Appendices' folder
    And   there are no files prefixed 'SADF FY 2122 01092021092540 v3_A627' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SADF FY 2122 01092021092540 v3_A627' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SADF FY 2122 01092021092540 v3_A627' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SADF FY 2122 01092021092540 v3_A627' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SADF FY 2122 01092021092540 v3_A627.xlsx' exists in the Datafiles folder and UKPRN '10017627' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the contents of the Appendices
    Then  the file named '10017627_SAD-627_v2.pdf' in Sharepoint location 'SADF-2122-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017627 Co Ltd UKPRN: 10017627
    Master Contract Number: ESFA-627 Start Date: 01/04/2021 End Date: 31/03/2022
    Contract Ref: SADF-627
    Cash (£) Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    Skills Accelerator Development Fund - Capital £25,000 £0 £0 £0 £0 £0 £0 £11,348 £0 £0 £13,652 £0 £0
    Skills Accelerator Development Fund - Resource £10,000 £0 £0 £0 £0 £0 £0 £3,423 £0 £0 £6,577 £0 £0
    Total Funding £35,000 £0 £0 £0 £0 £0 £0 £14,771 £0 £0 £20,229 £0 £0
    Skills Accelerator Development Fund – SADF-627 – Page 1 Ref (for internal use only):  SAD-627 v2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017627_SAD-627_v2.pdf' in 'SADF-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A627.pdf'





    # Part 4: Publish and approve contract v2
    
    # Change the date
    Given the override date is '15/09/2021'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'SAD-627'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-627' and actual ContractNumber 'SAD-627'

    # Check that the contract is now approved
    Then  the latest version of contract 'SAD-627' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017627 | SAD-627            | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017627 | SAD-627            | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/04/2021        | 31/03/2022      | ?             |
    | 10017627 | ESFA-627           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'SAD-627' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'SAD-627'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | SADF-627        | 2888881          | Mar-22 | Profile        |
    | SADF-627        | 100802           | Mar-22 | Profile        |



    # Part 5: Check CM feed
    
    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                    | DeliverableDescription    | 
    | 10017627 | SAD-627        | 2               | SADF-627      | 1               | 0                     | 25000.00     | 0             | 0        | Skills Accelerator Development Fund - Capital      | ?                         |
    | 10017627 | SAD-627        | 2               | SADF-627      | 2               | 0                     | 10000.00     | 0             | 0        | Skills Accelerator Development Fund - Resource     | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'SAD-627' agree with the most recent entry for this contract in the ContractManagement feed





    # Part 6: CDA for 21/22

    # Change the date 
    Given the override date is '20/09/2021'
  
    # Check the contents of the CDA report
    Given there is no CDA report named 'CDA Last Approved Version A627.csv'

    #And   the following contracts are in the replicated CRM database
    #| ContractNumber | ContractVersionNumber |
    #| SAD-627        | 2                     |

   #When  the following CDA reports are run
    When  the following CDA report is run
    | FundingStreamPeriod  | Version               | Suffix |
    | SADF2122             | Last Approved Version | A627   |

    Then  a report named 'CDA Last Approved Version A627.csv' is created

    # Check the contents of the CDA report
    #And   the following rows are present in the report
    #| FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 4                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888881           |                          |                   | Apr              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 5                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888881           |                          |                   | May              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 6                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888881           |                          |                   | Jun              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 7                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888881           |                          |                   | Jul              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 8                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888881           |                          |                   | Aug              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 9                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888881           |                          |                   | Sep              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 10                | 2021            | 2021/22       |              | 11348        |              |               |              | Yes                | 11348.00       | 0.00             | 0.00                  | 0.00           | 11348.00        |             | No            |                   |        | 2888881           |                          |                   | Oct              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 11                | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888881           |                          |                   | Nov              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 12                | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888881           |                          |                   | Dec              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 1                 | 2022            | 2021/22       |              | 13652        |              |               |              | Yes                | 13652.00       |                  | 0.00                  | 0.00           | 13652.00        |             | No            |                   |        | 2888881           |                          |                   | Jan              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 2                 | 2022            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888881           |                          |                   | Feb              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 3                 | 2022            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888881           |                          |                   | Mar              |
    ##
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 4                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100802            |                          |                   | Apr              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 5                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100802            |                          |                   | May              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 6                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100802            |                          |                   | Jun              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 7                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100802            |                          |                   | Jul              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 8                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100802            |                          |                   | Aug              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 9                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100802            |                          |                   | Sep              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 10                | 2021            | 2021/22       |              | 3423         |              |               |              | Yes                | 3423.00        | 0.00             | 0.00                  | 0.00           | 3423.00         |             | No            |                   |        | 100802            |                          |                   | Oct              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 11                | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100802            |                          |                   | Nov              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 12                | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100802            |                          |                   | Dec              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 1                 | 2022            | 2021/22       |              | 6577         |              |               |              | Yes                | 6577.00        |                  | 0.00                  | 0.00           | 6577.00         |             | No            |                   |        | 100802            |                          |                   | Jan              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 2                 | 2022            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100802            |                          |                   | Feb              |
    #| SADF2122                | 10017627 | 10017627 Co Ltd             |               |                             | SADF-627                 | SAD-627        | ESFA-627                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 3                 | 2022            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100802            |                          |                   | Mar              |





    # Part 7: Payment Batch for SADF2122

    # Change the date
    Given the override date is '04/10/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'SADF2122' AccountingPaymentPeriod '202107' CensusEndDate '04/10/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | SADF-627                 | 202110 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | SADF2122                   | 202110               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | SADF2122                   | 202110               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SADF2122' PaymentPeriod '202107' CensusEndDate '04/10/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A627.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SADF2122' PaymentPeriod '202107' CensusEndDate '04/10/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription   | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | SADF                   | 2021          | 07             | 04          | ?       | SADF-627      | 11348.00        | PROFILE          | SADF Capital            | 2021-10-18 | 2021-04-01   | 2022-03-31 | ?              | 10017627 | 2888881    |
    | SADF                   | 2021          | 07             | 04          | ?       | SADF-627      | 3423.00         | PROFILE          | SADF Resource           | 2021-10-18 | 2021-04-01   | 2022-03-31 | ?              | 10017627 | 100802     |





    # Part 8: Check financials and feed
    
    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'SADF2122' AccountingPaymentPeriod '202107' and CensusEndDate '04/10/2021'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                              |
    | Payment Requests for Funding Stream Period SADF2122 for Payment Period 202107 have been generated as of Census End Date/Time 2021-10-04T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | SADF2122            | 202107        | 2021-10-04T22:00:00Z  | 2                | 14771.00   |
    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | SADF      | 01/04/2021   | 31/03/2022 | 04/10/2021    | 18/10/2021 | 2021          | 07             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017627  | 10017627       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | SADF-627   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2888881    | PROFILE        | SADF Capital                  | 11348.00        |
    | ORG0017627  | 10017627       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | SADF-627   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100802     | PROFILE        | SADF Resource                 | 3423.00         |


    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | SAD-627        | SADF-627           | 1               | 25000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 11348.00 | 0.00     | 0.00     | 13652.00 | 0.00     | 0.00     | 
    | SAD-627        | SADF-627           | 2               | 10000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3423.00  | 0.00     | 0.00     | 6577.00  | 0.00     | 0.00     | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | SAD-627        | SADF-627           | 1               | 25000.00  | ?        | ?        | ?        | ?        | ?        | 0.00     | 11348.00 | 0.00     | 0.00     | 13652.00 | 0.00     | 0.00     | 
    | SAD-627        | SADF-627           | 2               | 10000.00  | ?        | ?        | ?        | ?        | ?        | 0.00     | 3423.00  | 0.00     | 0.00     | 6577.00  | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | SAD-627        | SADF-627           | 1               | 25000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 11348.00 | 0.00     | 0.00     | 13652.00 | 0.00     | 0.00     | 
    | SAD-627        | SADF-627           | 2               | 10000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3423.00  | 0.00     | 0.00     | 6577.00  | 0.00     | 0.00     | 


    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef    | ProfileSubnominal  | Apr-21    | May-21    | Jun-21    | Jul-21    | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    |
    | 10017627 | SAD-627        | SADF-627         | 2888881            | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 11348.00  | 0.00      | 0.00      | 13652.00  | 0.00      | 0.00      | 
    | 10017627 | SAD-627        | SADF-627         | 100802             | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 3423.00   | 0.00      | 0.00      | 6577.00   | 0.00      | 0.00      | 





    # Part 9: Bulk New Amendment to add SADF2223    

    # Change the date
    Given the override date is '01/03/2022'

    # Bulk file
    And   there are no files prefixed '10017627' in the Sharepoint 'SADF-2223-Input-Appendices' folder
    And   there are no files prefixed 'SADF FY 2223 22022022132927 v3_A627' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SADF FY 2223 22022022132927 v3_A627' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SADF FY 2223 22022022132927 v3_A627' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SADF FY 2223 22022022132927 v3_A627' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SADF FY 2223 22022022132927 v3_A627.xlsx' exists in the Datafiles folder and UKPRN '10017627' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017627' for FundingType 'SADF' and period '2223' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017627' for FundingType 'SADF' and period '2223'

    # Check the contents of the Appendices
    Then  the file named '10017627_[ContractNo]_v1.pdf' in Sharepoint location 'SADF-2223-Input-Appendices' contains the following lines in order
    """   
    Annex H – Grant payment schedule
    Provider: 10017627 Co Ltd UKPRN: 10017627
    Master Contract Number: ESFA-627 Start Date: 01/04/2022 End Date: 31/03/2023
    Contract Ref: [AllocRef_SADF]
    Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    Skills Accelerator Development Fund - Capital £54,731 £5,245 £4,586 £2,835 £5,977 £4,501 £3,090 £5,213 £6,794 £4,162 £4,109 £2,155 £6,064
    Skills Accelerator Development Fund - Resource £45,269 £4,226 £7,644 £1,302 £3,801 £471 £3,136 £7,981 £1,607 £5,567 £3,751 £3,359 £2,424
    Total Funding £100,000 £9,471 £12,230 £4,137 £9,778 £4,972 £6,226 £13,194 £8,401 £9,729 £7,860 £5,514 £8,488
    Skills Accelerator Development Fund – [AllocRef_SADF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017627_[ContractNo]_v1.pdf' in 'SADF-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A627a.pdf'





    # Part 10: Publish and approve 22/23 contract v1 

    # Change the date
    Given the override date is '03/03/2022'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
   #When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-627' and actual ContractNumber '[ContractNo]'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017627 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2022        | 31/03/2023      | ?             |
    | 10017627 | ESFA-627           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'SAD-627'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_SADF] | 2888881          | Mar-23 | Profile        |
    | [AllocRef_SADF] | 100802           | Mar-23 | Profile        |





    # Part 11: NFA to create 22/23 v2 and check docs

    # Change the date
    Given the override date is '12/03/2022'

    # Issue a non-financial amendment on v1 to create v2
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

 #  # Write the following values to the output window
 #  And   message 'ContractNo = [ContractNo]' is written to the Output window
 #  And   message 'AllocRef_SADF = [AllocRef_SADF]' is written to the Output window

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017627 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2022        | 31/03/2023      | Variation     |
    | 10017627 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/04/2022        | 31/03/2023      | ?             |
    | 10017627 | ESFA-627           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the contents of the Appendices (Only the version number will change)
    Then  the file named '10017627_[ContractNo]_v2.pdf' in Sharepoint location 'SADF-2223-Input-Appendices' contains the following lines in order
    """   
    Annex H – Grant payment schedule
    Provider: 10017627 Co Ltd UKPRN: 10017627
    Master Contract Number: ESFA-627 Start Date: 01/04/2022 End Date: 31/03/2023
    Contract Ref: [AllocRef_SADF]
    Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    Skills Accelerator Development Fund - Capital £54,731 £5,245 £4,586 £2,835 £5,977 £4,501 £3,090 £5,213 £6,794 £4,162 £4,109 £2,155 £6,064
    Skills Accelerator Development Fund - Resource £45,269 £4,226 £7,644 £1,302 £3,801 £471 £3,136 £7,981 £1,607 £5,567 £3,751 £3,359 £2,424
    Total Funding £100,000 £9,471 £12,230 £4,137 £9,778 £4,972 £6,226 £13,194 £8,401 £9,729 £7,860 £5,514 £8,488
    Skills Accelerator Development Fund – [AllocRef_SADF] – Page 1 Ref (for internal use only):  [ContractNo] v2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017627_[ContractNo]_v2.pdf' in 'SADF-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A627b.pdf'





    # Part 12: Publish and approve 22/23 contract v2

    # Change the date
    Given the override date is '13/03/2022'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
   #When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-627' and actual ContractNumber '[ContractNo]'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017627 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2022        | 31/03/2023      | Variation     |
    | 10017627 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/04/2022        | 31/03/2023      | ?             |
    | 10017627 | ESFA-627           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'SAD-627'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_SADF] | 2888881          | Mar-23 | Profile        |
    | [AllocRef_SADF] | 100802           | Mar-23 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                   | DeliverableDescription       | 
    | 10017627 | [ContractNo]   | 2               | [AllocRef_SADF] | 1               | 0                     | 54731.00     | 0             | 0        | Skills Accelerator Development Fund - Capital     | ?                            |
    | 10017627 | [ContractNo]   | 2               | [AllocRef_SADF] | 2               | 0                     | 45269.00     | 0             | 0        | Skills Accelerator Development Fund - Resource    | ?                            |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed




   
    # Part 13: Payment Batch for SADF2223

    # Change the date
    Given the override date is '04/10/2022 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'SADF2223' AccountingPaymentPeriod '202207' CensusEndDate '04/10/2022' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_SADF]          | 202210 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | SADF2223                   | 202210               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | SADF2223                   | 202210               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SADF2223' PaymentPeriod '202207' CensusEndDate '04/10/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A627.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SADF2223' PaymentPeriod '202207' CensusEndDate '04/10/2022' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef   | AggregatedValue | PaymentType      | SubnominalDescription   | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | SADF                   | 2022          | 07             | 04          | ?       | [AllocRef_SADF] | 5213.00         | PROFILE          | SADF Capital            | 2022-10-18 | 2022-04-01   | 2023-03-31 | ?              | 10017627 | 2888881    |
    | SADF                   | 2022          | 07             | 04          | ?       | [AllocRef_SADF] | 7981.00         | PROFILE          | SADF Resource           | 2022-10-18 | 2022-04-01   | 2023-03-31 | ?              | 10017627 | 100802     |



    
    
    # Part 14: Check financials and feed

    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'SADF2223' AccountingPaymentPeriod '202207' and CensusEndDate '04/10/2022'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                              |
    | Payment Requests for Funding Stream Period SADF2223 for Payment Period 202207 have been generated as of Census End Date/Time 2022-10-04T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | SADF2223            | 202207        | 2022-10-04T22:00:00Z  | 2                | 13194.00   |
    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | SADF      | 01/04/2022   | 31/03/2023 | 04/10/2022    | 18/10/2022 | 2022          | 07             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef        | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017627  | 10017627       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_SADF] | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2888881    | PROFILE        | SADF Capital                  | 5213.00         |
    | ORG0017627  | 10017627       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_SADF] | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100802     | PROFILE        | SADF Resource                 | 7981.00         |



    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | [ContractNo]   | [AllocRef_SADF]    | 1               | 54731.00  | 5245.00  | 4586.00  | 2835.00  | 5977.00  | 4501.00  | 3090.00  | 5213.00  | 6794.00  | 4162.00  | 4109.00  | 2155.00  | 6064.00  | 
    | [ContractNo]   | [AllocRef_SADF]    | 2               | 45269.00  | 4226.00  | 7644.00  | 1302.00  | 3801.00  | 471.00   | 3136.00  | 7981.00  | 1607.00  | 5567.00  | 3751.00  | 3359.00  | 2424.00  | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | [ContractNo]   | [AllocRef_SADF]    | 1               | 54731.00  | 5245.00  | 4586.00  | 2835.00  | 5977.00  | 4501.00  | 3090.00  | 5213.00  | 6794.00  | 4162.00  | 4109.00  | 2155.00  | 6064.00  | 
    | [ContractNo]   | [AllocRef_SADF]    | 2               | 45269.00  | 4226.00  | 7644.00  | 1302.00  | 3801.00  | 471.00   | 3136.00  | 7981.00  | 1607.00  | 5567.00  | 3751.00  | 3359.00  | 2424.00  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | [ContractNo]   | [AllocRef_SADF]    | 1               | 54731.00  | 5245.00  | 4586.00  | 2835.00  | 5977.00  | 4501.00  | 3090.00  | 5213.00  | 6794.00  | 4162.00  | 4109.00  | 2155.00  | 6064.00  | 
    | [ContractNo]   | [AllocRef_SADF]    | 2               | 45269.00  | 4226.00  | 7644.00  | 1302.00  | 3801.00  | 471.00   | 3136.00  | 7981.00  | 1607.00  | 5567.00  | 3751.00  | 3359.00  | 2424.00  | 


    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef    | ProfileSubnominal  | Apr-22    | May-22    | Jun-22    | Jul-22    | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    |
    | 10017627 | [ContractNo]   | [AllocRef_SADF]  | 2888881            | 5245.00   | 4586.00   | 2835.00   | 5977.00   | 4501.00   | 3090.00   | 5213.00   | 6794.00   | 4162.00   | 4109.00   | 2155.00   | 6064.00   | 
    | 10017627 | [ContractNo]   | [AllocRef_SADF]  | 100802             | 4226.00   | 7644.00   | 1302.00   | 3801.00   | 471.00    | 3136.00   | 7981.00   | 1607.00   | 5567.00   | 3751.00   | 3359.00   | 2424.00   | 





    # Part 15: CDA for 22/23
    
    # Change the date 
    Given the override date is '22/10/2022'
  
    # Check the contents of the CDA report
    Given there is no CDA report named 'CDA Latest Version A627a.csv'

    #And   the following contracts are in the replicated CRM database
    #| ContractNumber | ContractVersionNumber |
    #| [ContractNo]   | 2                     |

   #When  the following CDA reports are run
    When  the following CDA report is run
    | FundingStreamPeriod  | Version               | Suffix |
    | SADF2223             | Latest Version        | A627a  |

    Then  a report named 'CDA Latest Version A627a.csv' is created

    # Check the contents of the CDA report
   # And   the following rows are present in the report
   # | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
   # | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 4                 | 2022            | 2022/23       |              | 5245         |              | 0             |              | Yes                | 5245.00        | 0.00             | 0.00                  | 0.00           | 5245.00         |             | No            |                   |        | 2888881           |                          |                   | Apr              |
   # | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 5                 | 2022            | 2022/23       |              | 4586         |              | 0             |              | Yes                | 4586.00        |                  | 0.00                  | 0.00           | 4586.00         |             | No            |                   |        | 2888881           |                          |                   | May              |
   # | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 6                 | 2022            | 2022/23       |              | 2835         |              | 0             |              | Yes                | 2835.00        |                  | 0.00                  | 0.00           | 2835.00         |             | No            |                   |        | 2888881           |                          |                   | Jun              |
   # | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 7                 | 2022            | 2022/23       |              | 5977         |              | 0             |              | Yes                | 5977.00        |                  | 0.00                  | 0.00           | 5977.00         |             | No            |                   |        | 2888881           |                          |                   | Jul              |
   # | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 8                 | 2022            | 2022/23       |              | 4501         |              | 0             |              | Yes                | 4501.00        |                  | 0.00                  | 0.00           | 4501.00         |             | No            |                   |        | 2888881           |                          |                   | Aug              |
   # | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 9                 | 2022            | 2022/23       |              | 3090         |              | 0             |              | Yes                | 3090.00        |                  | 0.00                  | 0.00           | 3090.00         |             | No            |                   |        | 2888881           |                          |                   | Sep              |
  #  | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 10                | 2022            | 2022/23       |              | 5213         |              | 0             |              | Yes                | 5213.00        |                  | 0.00                  | 0.00           | 5213.00         |             | Yes           |                   |        | 2888881           |                          |                   | Oct              |
  #  | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 11                | 2022            | 2022/23       |              | 6794         |              | 0             |              | Yes                | 6794.00        |                  | 0.00                  | 0.00           | 6794.00         |             | No            |                   |        | 2888881           |                          |                   | Nov              |
  #  | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 12                | 2022            | 2022/23       |              | 4162         |              | 0             |              | Yes                | 4162.00        |                  | 0.00                  | 0.00           | 4162.00         |             | No            |                   |        | 2888881           |                          |                   | Dec              |
  #  | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 1                 | 2023            | 2022/23       |              | 4109         |              | 0             |              | Yes                | 4109.00        |                  | 0.00                  | 0.00           | 4109.00         |             | No            |                   |        | 2888881           |                          |                   | Jan              |
  #  | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 2                 | 2023            | 2022/23       |              | 2155         |              | 0             |              | Yes                | 2155.00        |                  | 0.00                  | 0.00           | 2155.00         |             | No            |                   |        | 2888881           |                          |                   | Feb              |
  #  | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Capital                   |                                                                 | 3                 | 2023            | 2022/23       |              | 6064         |              | 0             |              | Yes                | 6064.00        |                  | 0.00                  | 0.00           | 6064.00         |             | No            |                   |        | 2888881           |                          |                   | Mar              |
  #  | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 4                 | 2022            | 2022/23       |              | 4226         |              | 0             |              | Yes                | 4226.00        | 0.00             | 0.00                  | 0.00           | 4226.00         |             | No            |                   |        | 100802            |                          |                   | Apr              |
  #  | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 5                 | 2022            | 2022/23       |              | 7644         |              | 0             |              | Yes                | 7644.00        |                  | 0.00                  | 0.00           | 7644.00         |             | No            |                   |        | 100802            |                          |                   | May              |
  #  | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 6                 | 2022            | 2022/23       |              | 1302         |              | 0             |              | Yes                | 1302.00        |                  | 0.00                  | 0.00           | 1302.00         |             | No            |                   |        | 100802            |                          |                   | Jun              |
  #  | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 7                 | 2022            | 2022/23       |              | 3801         |              | 0             |              | Yes                | 3801.00        |                  | 0.00                  | 0.00           | 3801.00         |             | No            |                   |        | 100802            |                          |                   | Jul              |
  #  | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 8                 | 2022            | 2022/23       |              | 471          |              | 0             |              | Yes                | 471.00         |                  | 0.00                  | 0.00           | 471.00          |             | No            |                   |        | 100802            |                          |                   | Aug              |
  #  | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 9                 | 2022            | 2022/23       |              | 3136         |              | 0             |              | Yes                | 3136.00        |                  | 0.00                  | 0.00           | 3136.00         |             | No            |                   |        | 100802            |                          |                   | Sep              |
  #  | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 10                | 2022            | 2022/23       |              | 7981         |              | 0             |              | Yes                | 7981.00        |                  | 0.00                  | 0.00           | 7981.00         |             | Yes           |                   |        | 100802            |                          |                   | Oct              |
  #  | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 11                | 2022            | 2022/23       |              | 1607         |              | 0             |              | Yes                | 1607.00        |                  | 0.00                  | 0.00           | 1607.00         |             | No            |                   |        | 100802            |                          |                   | Nov              |
  #  | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 12                | 2022            | 2022/23       |              | 5567         |              | 0             |              | Yes                | 5567.00        |                  | 0.00                  | 0.00           | 5567.00         |             | No            |                   |        | 100802            |                          |                   | Dec              |
  #  | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 1                 | 2023            | 2022/23       |              | 3751         |              | 0             |              | Yes                | 3751.00        |                  | 0.00                  | 0.00           | 3751.00         |             | No            |                   |        | 100802            |                          |                   | Jan              |
  #  | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 2                 | 2023            | 2022/23       |              | 3359         |              | 0             |              | Yes                | 3359.00        |                  | 0.00                  | 0.00           | 3359.00         |             | No            |                   |        | 100802            |                          |                   | Feb              |
  #  | SADF2223                | 10017627 | 10017627 Co Ltd             |               |                             | [AllocRef_SADF]          | [ContractNo]   | ESFA-627                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | Skills Accelerator Development Fund - Resource                  |                                                                 | 3                 | 2023            | 2022/23       |              | 2424         |              | 0             |              | Yes                | 2424.00        |                  | 0.00                  | 0.00           | 2424.00         |             | No            |                   |        | 100802            |                          |                   | Mar              |


    # Tidy Up
    Given the override date is reset
    
@AcceptanceTest @Withdrawn20230118
Scenario: A628 Create a draft SADF2122 contract then attempt a bulk NewAmendment to create a SADF2223 contract. Flip and repeat. Fail MBR-005
    
    # 1. Create a draft 21/22 contract
    # 2. Bulk New Amendment to create a SAD 22/23 contract with linked Master. Fail MBR-005
    # 3. Publish and approve 21/22 contract
    # 4. Bulk New Amendment to create a SAD 22/23 contract with linked Master (again). Success
    # 5. Bulk amend 21/22 contract while 22/23 contract is in draft. Fail MBR-005
      
    Given there are no allocations marked as Under Termination for UKPRN '10017628' 
    And   there are no terminated or closed allocations for UKPRN '10017628' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017628' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017628' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017628' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | SADF-628      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | SADF-628      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | SADF2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | SAD-628        | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017628'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017628' 
    And   there is no caseload advisor for UKPRN '10017628' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017628 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017628' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017628 Co Ltd' with UKPRN '10017628' and OrgId 'ORG0017628' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017628 | 117628 | 10017628 Co Ltd | 0              | Locked Restructure    | Yes           | AA017628      | ?             | 41 Send Barns Lane     | Send                   | Woking                 | ?                      | ?                      | Surrey                 | GU23 7BS  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017628 |





    # Part 1: Create a draft 21/22 contract
    
    # Change the date
    Given the override date is '01/03/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'SAD-628'
    And   there are no details in ContractManagement.CreatedContract for 'SAD-628'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017628 | 10017628 Co Ltd      | ESFA-628             | SAD-628        | 1                     | 01/04/2021        | 31/03/2022      | 7828.00       |                                       | Contract for Services                      | 2122   | New          | ORG0017628 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017628 | SAD-628        | SADF-628      | SADF              | SADF2122                | FY                      | 01/04/2021          | 31/03/2022        | 7828.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017628 | SAD-628        | SADF-628      | 1               | 0                     | 3259.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1973.00  | 0.00     | 0.00     | 1286.00  | 0.00     | 0.00     | Skills Accelerator Development Fund - Capital                   | New          |             | 
    | 10017628 | SAD-628        | SADF-628      | 2               | 0                     | 4569.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3641.00  | 0.00     | 0.00     | 928.00   | 0.00     | 0.00     | Skills Accelerator Development Fund - Resource                  | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | SAD-628        | 1                     | 0                        | 2021-03-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'SAD-628'





    # Part 2: Bulk New Amendment to create a SAD 22/23 contract with linked Master. Fail MBR-005

    # Change the date
    Given the override date is '01/03/2022'

    # Bulk 'New Amendment' file
    And   there are no files prefixed '10017628' in the Sharepoint 'SADF-2223-Input-Appendices' folder
    And   there are no files prefixed 'SADF FY 2223 06042022143402 v3_A628' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SADF FY 2223 06042022143402 v3_A628' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SADF FY 2223 06042022143402 v3_A628' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SADF FY 2223 06042022143402 v3_A628' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SADF FY 2223 06042022143402 v3_A628.xlsx' exists in the Datafiles folder and UKPRN '10017628' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
  # And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # MBR-005
    And   '[Contract] This Master Contract cannot have more than one associated Contract in a draft status at the same time.' is displayed in field 'J2' on the 'Contract' tab of the result report





    # Part 3: Publish and approve 21/22 contract  

    # Change the date
    Given the override date is '02/03/2022'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'SAD-628'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message for 21/22 contract
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-628'' and ContractNumber 'SAD-628' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'SAD-628' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017628 | SAD-628            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017628 | ESFA-628           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'SAD-628'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | SADF-628        | 2888881          | Mar-22 | Profile        |





    # Part 4: Bulk New Amendment to create a SAD 22/23 contract with linked Master (again). Success
  
    # Change the date
    Given the override date is '01/04/2022'

    # Bulk 'New Amendment' file (Second attempt)
    And   there are no files prefixed '10017628' in the Sharepoint 'SADF-2223-Input-Appendices' folder
    And   there are no files prefixed 'SADF FY 2223 06042022143403 v3_A628' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SADF FY 2223 06042022143403 v3_A628' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SADF FY 2223 06042022143403 v3_A628' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SADF FY 2223 06042022143403 v3_A628' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SADF FY 2223 06042022143404 v3_A628.xlsx' exists in the Datafiles folder and UKPRN '10017628' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    
    # Contract is now 'Draft\Awaiting Documentation'
  
  



    # Part 5: Bulk amend 21/22 contract while 22/23 contract is in draft. Fail MBR-005

    # Change the date
    Given the override date is '01/04/2022'

    And   there are no files prefixed '10017628' in the Sharepoint 'SADF-2122-Input-Appendices' folder
    And   there are no files prefixed 'SADF FY 2122 06042022143404 v3_A628' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SADF FY 2122 06042022143404 v3_A628' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SADF FY 2122 06042022143404 v3_A628' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SADF FY 2122 06042022143404 v3_A628' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SADF FY 2122 06042022143404 v3_A628.xlsx' exists in the Datafiles folder and UKPRN '10017628' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
  # And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # MBR-005
    And   '[Contract] This Master Contract cannot have more than one associated Contract in a draft status at the same time.' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Tidy up
    Given the override date is reset

