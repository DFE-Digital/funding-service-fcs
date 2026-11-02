Feature: Create2021NLGcontracts 29976

@AcceptanceTest @Withdrawn20230123
Scenario: A751 Bulk load a new 2021 NLG contract. Check docs then publish and approve. Non-financial amendment then check docs. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017751' 
    And   there are no terminated or closed allocations for UKPRN '10017751' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017751' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017751' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | NLG-751       |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | NLG-751       |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | NLG2021           |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017751' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017751 Co Ltd' with UKPRN '10017751' and OrgId 'ORG0017751' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017751' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017751 | 117751 | 10017751 Co Ltd | 0              | Active                | Yes           | AA017751      | ?             | 29 Church Street       | Basingstoke            | ?                      | ?                      | ?                      | ?                      | RG21 7QQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017751 |




    # Change the date
    Given the override date is '23/07/2020'

    # Bulk file
    And   there are no files prefixed '10017751' in the Sharepoint 'NLG-2021-Input-Appendices' folder
    And   there are no files prefixed 'NLG AY 2021 27052020081731 v3_A751' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLG AY 2021 27052020081731 v3_A751' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLG AY 2021 27052020081731 v3_A751' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLG AY 2021 27052020081731 v3_A751' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLG AY 2021 27052020081731 v3_A751.xlsx' exists in the Datafiles folder and UKPRN '10017751' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017751' for FundingType 'NLG' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017751' for FundingType 'NLG' and period '2021'

    # Check the contents of the Appendices
    Then  the file named '10017751_[ContractNo]_v1.pdf' in Sharepoint location 'NLG-2021-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017751 Co Ltd UKPRN: 10017751
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_NLG]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    Principals Reference Group (PRG) £46,674 £2,100 £5,243 £3,767 £2,355 £4,478 £6,060 £5,539 £5,486 £3,532 £1,441 £5,603 £1,070
    National Leaders of Further Education (NLFE) £58,185 £2,991 £5,178 £2,343 £5,008 £2,853 £3,480 £7,439 £5,623 £5,231 £4,297 £7,099 £6,643
    Isles of Scilly: Boarding and Accommodation Grant £48,606 £2,174 £5,518 £2,445 £3,347 £2,753 £4,536 £5,025 £7,286 £2,615 £2,837 £4,281 £5,789
    Total Funding £153,465 £7,265 £15,939 £8,555 £10,710 £10,084 £14,076 £18,003 £18,395 £11,378 £8,575 £16,983 £13,502
    20/21 Non-learning Grants – [AllocRef_NLG] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017751_[ContractNo]_v1.pdf' in 'NLG-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A751.pdf'

    # Display Sharepoint filename
    And   message '10017751_[ContractNo]_v1.pdf' is written to the Output window




    # Change the date
    Given the override date is '25/07/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'NONLG-751' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-751' and actual ContractNumber 'NONLG-751'
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017751 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017751 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'NONLG-751'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_NLG]  | 2208100          | Jul-21 | Profile        |
    | [AllocRef_NLG]  | 2208200          | Jul-21 | Profile        |
    | [AllocRef_NLG]  | 2202070          | Jul-21 | Profile        |



    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | [ContractNo]   | [AllocRef_NLG]     | 101             | 46674.00  | 2100.00  | 5243.00  | 3767.00  | 2355.00  | 4478.00  | 6060.00  | 5539.00  | 5486.00  | 3532.00  | 1441.00  | 5603.00  | 1070.00  | 
    | [ContractNo]   | [AllocRef_NLG]     | 102             | 58185.00  | 2991.00  | 5178.00  | 2343.00  | 5008.00  | 2853.00  | 3480.00  | 7439.00  | 5623.00  | 5231.00  | 4297.00  | 7099.00  | 6643.00  | 
    | [ContractNo]   | [AllocRef_NLG]     | 116             | 48606.00  | 2174.00  | 5518.00  | 2445.00  | 3347.00  | 2753.00  | 4536.00  | 5025.00  | 7286.00  | 2615.00  | 2837.00  | 4281.00  | 5789.00  | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | [ContractNo]   | [AllocRef_NLG]     | 101             | 46674.00  | 2100.00  | 5243.00  | 3767.00  | 2355.00  | 4478.00  | 6060.00  | 5539.00  | 5486.00  | 3532.00  | 1441.00  | 5603.00  | 1070.00  | 
    | [ContractNo]   | [AllocRef_NLG]     | 102             | 58185.00  | 2991.00  | 5178.00  | 2343.00  | 5008.00  | 2853.00  | 3480.00  | 7439.00  | 5623.00  | 5231.00  | 4297.00  | 7099.00  | 6643.00  | 
    | [ContractNo]   | [AllocRef_NLG]     | 116             | 48606.00  | 2174.00  | 5518.00  | 2445.00  | 3347.00  | 2753.00  | 4536.00  | 5025.00  | 7286.00  | 2615.00  | 2837.00  | 4281.00  | 5789.00  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | [ContractNo]   | [AllocRef_NLG]     | 101             | 46674.00  | 2100.00  | 5243.00  | 3767.00  | 2355.00  | 4478.00  | 6060.00  | 5539.00  | 5486.00  | 3532.00  | 1441.00  | 5603.00  | 1070.00  | 
    | [ContractNo]   | [AllocRef_NLG]     | 102             | 58185.00  | 2991.00  | 5178.00  | 2343.00  | 5008.00  | 2853.00  | 3480.00  | 7439.00  | 5623.00  | 5231.00  | 4297.00  | 7099.00  | 6643.00  | 
    | [ContractNo]   | [AllocRef_NLG]     | 116             | 48606.00  | 2174.00  | 5518.00  | 2445.00  | 3347.00  | 2753.00  | 4536.00  | 5025.00  | 7286.00  | 2615.00  | 2837.00  | 4281.00  | 5789.00  | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    |
    | 10017751 | [ContractNo]   | [AllocRef_NLG]     | 2202070                  | 2174.00   | 5518.00   | 2445.00   | 3347.00   | 2753.00   | 4536.00   | 5025.00   | 7286.00   | 2615.00   | 2837.00   | 4281.00   | 5789.00   | 
    | 10017751 | [ContractNo]   | [AllocRef_NLG]     | 2208100                  | 2100.00   | 5243.00   | 3767.00   | 2355.00   | 4478.00   | 6060.00   | 5539.00   | 5486.00   | 3532.00   | 1441.00   | 5603.00   | 1070.00   | 
    | 10017751 | [ContractNo]   | [AllocRef_NLG]     | 2208200                  | 2991.00   | 5178.00   | 2343.00   | 5008.00   | 2853.00   | 3480.00   | 7439.00   | 5623.00   | 5231.00   | 4297.00   | 7099.00   | 6643.00   | 

    # Check the PROFILE subnominal aggregations in PaaS
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2202070         | NLG2021                    | 202008               | PROFILE         | CM             | False       | 2174.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2202070         | NLG2021                    | 202009               | PROFILE         | CM             | False       | 5518.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2202070         | NLG2021                    | 202010               | PROFILE         | CM             | False       | 2445.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2202070         | NLG2021                    | 202011               | PROFILE         | CM             | False       | 3347.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2202070         | NLG2021                    | 202012               | PROFILE         | CM             | False       | 2753.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2202070         | NLG2021                    | 202101               | PROFILE         | CM             | False       | 4536.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2202070         | NLG2021                    | 202102               | PROFILE         | CM             | False       | 5025.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2202070         | NLG2021                    | 202103               | PROFILE         | CM             | False       | 7286.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2202070         | NLG2021                    | 202104               | PROFILE         | CM             | False       | 2615.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2202070         | NLG2021                    | 202105               | PROFILE         | CM             | False       | 2837.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2202070         | NLG2021                    | 202106               | PROFILE         | CM             | False       | 4281.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2202070         | NLG2021                    | 202107               | PROFILE         | CM             | False       | 5789.00         |
    #
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208100         | NLG2021                    | 202008               | PROFILE         | CM             | False       | 2100.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208100         | NLG2021                    | 202009               | PROFILE         | CM             | False       | 5243.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208100         | NLG2021                    | 202010               | PROFILE         | CM             | False       | 3767.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208100         | NLG2021                    | 202011               | PROFILE         | CM             | False       | 2355.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208100         | NLG2021                    | 202012               | PROFILE         | CM             | False       | 4478.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208100         | NLG2021                    | 202101               | PROFILE         | CM             | False       | 6060.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208100         | NLG2021                    | 202102               | PROFILE         | CM             | False       | 5539.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208100         | NLG2021                    | 202103               | PROFILE         | CM             | False       | 5486.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208100         | NLG2021                    | 202104               | PROFILE         | CM             | False       | 3532.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208100         | NLG2021                    | 202105               | PROFILE         | CM             | False       | 1441.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208100         | NLG2021                    | 202106               | PROFILE         | CM             | False       | 5603.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208100         | NLG2021                    | 202107               | PROFILE         | CM             | False       | 1070.00         |
    #
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208200         | NLG2021                    | 202008               | PROFILE         | CM             | False       | 2991.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208200         | NLG2021                    | 202009               | PROFILE         | CM             | False       | 5178.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208200         | NLG2021                    | 202010               | PROFILE         | CM             | False       | 2343.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208200         | NLG2021                    | 202011               | PROFILE         | CM             | False       | 5008.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208200         | NLG2021                    | 202012               | PROFILE         | CM             | False       | 2853.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208200         | NLG2021                    | 202101               | PROFILE         | CM             | False       | 3480.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208200         | NLG2021                    | 202102               | PROFILE         | CM             | False       | 7439.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208200         | NLG2021                    | 202103               | PROFILE         | CM             | False       | 5623.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208200         | NLG2021                    | 202104               | PROFILE         | CM             | False       | 5231.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208200         | NLG2021                    | 202105               | PROFILE         | CM             | False       | 4297.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208200         | NLG2021                    | 202106               | PROFILE         | CM             | False       | 7099.00         |
    | 10017751 | ORG0017751 | [AllocRef_NLG]    | 2208200         | NLG2021                    | 202107               | PROFILE         | CM             | False       | 6643.00         |




    # Create non-financial amendment and check doc

    # Change the date
    Given the override date is '02/09/2020'

    # Attempt a non-financial VARIATION amendment request on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017751 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017751 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017751 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the contents of the Appendices (Same as v1, but now v2)
    Then  the file named '10017751_[ContractNo]_v2.pdf' in Sharepoint location 'NLG-2021-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017751 Co Ltd UKPRN: 10017751
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_NLG]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    Principals Reference Group (PRG) £46,674 £2,100 £5,243 £3,767 £2,355 £4,478 £6,060 £5,539 £5,486 £3,532 £1,441 £5,603 £1,070
    National Leaders of Further Education (NLFE) £58,185 £2,991 £5,178 £2,343 £5,008 £2,853 £3,480 £7,439 £5,623 £5,231 £4,297 £7,099 £6,643
    Isles of Scilly: Boarding and Accommodation Grant £48,606 £2,174 £5,518 £2,445 £3,347 £2,753 £4,536 £5,025 £7,286 £2,615 £2,837 £4,281 £5,789
    Total Funding £153,465 £7,265 £15,939 £8,555 £10,710 £10,084 £14,076 £18,003 £18,395 £11,378 £8,575 £16,983 £13,502
    20/21 Non-learning Grants – [AllocRef_NLG] – Page 1 Ref (for internal use only):  [ContractNo] v2
    """


    # Tidy Up
    And the override date is reset
       
@AcceptanceTest @Withdrawn20230123
Scenario: A752 Create and approve a new 2021 NLG contract. Bulk amend and approve. Check CRM and financials
    Given there are no allocations marked as Under Termination for UKPRN '10017752' 
    And   there are no terminated or closed allocations for UKPRN '10017752' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017752' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017752' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | NLG-752       |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | NLG-752       |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | NLG2021           |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017752' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017752 Co Ltd' with UKPRN '10017752' and OrgId 'ORG0017752' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017752' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017752 | 117752 | 10017752 Co Ltd | 0              | Locked Restructure    | Yes           | AA017752      | ?             | 52 Park Street         | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 3PT  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017752 |




    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017752 | 10017752 Co Ltd      | ESFA-752             | NONLG-752      | 1                     | 01/08/2020        | 31/07/2021      | 62678.00      |                                       | Contract for Services                      | 2021   | New          | ORG0017752 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017752 | NONLG-752      | NLG-752       | NLG               | NLG2021                 | AY                      | 01/08/2020          | 31/07/2021        | 62678.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017752 | NONLG-752      | NLG-752       | 101             | 0                     | 28181.00  | 18092.00  | 10089.00  | 3531.00  | 2874.00  | 162.00   | 898.00   | 3373.00  | 3349.00  | 2439.00  | 1466.00  | 3403.00  | 1293.00  | 2187.00  | 3206.00  | Principals Reference Group (PRG)                                | New          |             | 
    | 10017752 | NONLG-752      | NLG-752       | 102             | 0                     | 18801.00  | 13978.00  | 4823.00   | 2578.00  | 117.00   | 2815.00  | 3107.00  | 1249.00  | 404.00   | 221.00   | 3487.00  | 1091.00  | 878.00   | 2499.00  | 355.00   | National Leaders of Further Education (NLFE)                    | New          |             | 
    | 10017752 | NONLG-752      | NLG-752       | 116             | 0                     | 15696.00  | 7629.00   | 8067.00   | 297.00   | 717.00   | 440.00   | 1271.00  | 1498.00  | 2550.00  | 376.00   | 480.00   | 1152.00  | 1854.00  | 1483.00  | 3578.00  | Isles of Scilly: Boarding and Accommodation Grant               | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'NONLG-752' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NONLG-752'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-752' and actual ContractNumber 'NONLG-752'

    # Check that the contract is now approved
    Then  the latest version of contract 'NONLG-752' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017752 | NONLG-752          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017752 | ESFA-752           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'NONLG-752'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | NLG-752         | 2208100          | Jul-21 | Profile        |
    | NLG-752         | 2208200          | Jul-21 | Profile        |
    | NLG-752         | 2202070          | Jul-21 | Profile        |




    # Amend the contracts financials

    # Change the date
    Given the override date is '12/07/2020'

    # Bulk file
    And   there are no files prefixed '10017752' in the Sharepoint 'NLG-2021-Input-Appendices' folder
    And   there are no files prefixed 'NLG AY 2021 28052020110742 v3_A752' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLG AY 2021 28052020110742 v3_A752' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLG AY 2021 28052020110742 v3_A752' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLG AY 2021 28052020110742 v3_A752' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLG AY 2021 28052020110742 v3_A752.xlsx' exists in the Datafiles folder and UKPRN '10017752' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

   #And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'




    # Change the date
    Given the override date is '31/07/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NONLG-752'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-752' and actual ContractNumber 'NONLG-752'

    # Check that the contract is now approved
    Then  the latest version of contract 'NONLG-752' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017752 | NONLG-752          | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017752 | NONLG-752          | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017752 | ESFA-752           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'NONLG-752'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | NLG-752         | 2208100          | Jul-21 | Profile        |
    | NLG-752         | 2208200          | Jul-21 | Profile        |
    | NLG-752         | 2202070          | Jul-21 | Profile        |




    # Check CRM financials (FCS calculates payments for NLG2021 but does not generate them)

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | NONLG-752      | NLG-752            | 101             | 15922.00  | 814.00   | 155.00   | 1355.00  | 1546.00  | 1070.00  | 1610.00  | 782.00   | 1475.00  | 1842.00  | 1790.00  | 1787.00  | 1696.00  | 
    | NONLG-752      | NLG-752            | 102             | 22517.00  | 1907.00  | 1324.00  | 2246.00  | 1482.00  | 2598.00  | 1312.00  | 2108.00  | 1734.00  | 3743.00  | 1927.00  | 1535.00  | 601.00   | 
    | NONLG-752      | NLG-752            | 116             | 28561.00  | 3400.00  | 2946.00  | 1428.00  | 1822.00  | 1579.00  | 1481.00  | 1837.00  | 7670.00  | 208.00   | 2469.00  | 1749.00  | 1972.00  | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | NONLG-752      | NLG-752            | 101             | 15922.00  | 814.00   | 155.00   | 1355.00  | 1546.00  | 1070.00  | 1610.00  | 782.00   | 1475.00  | 1842.00  | 1790.00  | 1787.00  | 1696.00  | 
    | NONLG-752      | NLG-752            | 102             | 22517.00  | 1907.00  | 1324.00  | 2246.00  | 1482.00  | 2598.00  | 1312.00  | 2108.00  | 1734.00  | 3743.00  | 1927.00  | 1535.00  | 601.00   | 
    | NONLG-752      | NLG-752            | 116             | 28561.00  | 3400.00  | 2946.00  | 1428.00  | 1822.00  | 1579.00  | 1481.00  | 1837.00  | 7670.00  | 208.00   | 2469.00  | 1749.00  | 1972.00  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | NONLG-752      | NLG-752            | 101             | 15922.00  | 814.00   | 155.00   | 1355.00  | 1546.00  | 1070.00  | 1610.00  | 782.00   | 1475.00  | 1842.00  | 1790.00  | 1787.00  | 1696.00  | 
    | NONLG-752      | NLG-752            | 102             | 22517.00  | 1907.00  | 1324.00  | 2246.00  | 1482.00  | 2598.00  | 1312.00  | 2108.00  | 1734.00  | 3743.00  | 1927.00  | 1535.00  | 601.00   | 
    | NONLG-752      | NLG-752            | 116             | 28561.00  | 3400.00  | 2946.00  | 1428.00  | 1822.00  | 1579.00  | 1481.00  | 1837.00  | 7670.00  | 208.00   | 2469.00  | 1749.00  | 1972.00  | 




#    # Check the contents of the CDA report
#    Given there is no CDA report named 'CDA Last Approved Version A752.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | NONLG-752      | 2                     |
#
#   #When  the following CDA reports are run
#    When  the following CDA report is run
#    | FundingStreamPeriod  | Version               | Suffix |
#    | NLG2021              | Last Approved Version | A752   |
#
#    Then  a report named 'CDA Last Approved Version A752.csv' is created
#
#    # Check the contents of the CDA report for Aug
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | NLG2021                 | 10017752 | 10017752 Co Ltd             |               |                             | NLG-752                  | NONLG-752      | ESFA-752                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Principals Reference Group (PRG)                                |                                                                 | 8                 | 2020            | 2020/21       |              | 814          |              |               |              | Yes                | 814.00         | 0.00             | 0.00                  | 0.00           | 814.00          |             | No            |                   |        | 2208100           |                          |                   | Aug              |
#    | NLG2021                 | 10017752 | 10017752 Co Ltd             |               |                             | NLG-752                  | NONLG-752      | ESFA-752                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | National Leaders of Further Education (NLFE)                    |                                                                 | 8                 | 2020            | 2020/21       |              | 1907         |              |               |              | Yes                | 1907.00        | 0.00             | 0.00                  | 0.00           | 1907.00         |             | No            |                   |        | 2208200           |                          |                   | Aug              |
#    | NLG2021                 | 10017752 | 10017752 Co Ltd             |               |                             | NLG-752                  | NONLG-752      | ESFA-752                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Isles of Scilly: Boarding and Accommodation Grant               |                                                                 | 8                 | 2020            | 2020/21       |              | 3400         |              |               |              | Yes                | 3400.00        | 0.00             | 0.00                  | 0.00           | 3400.00         |             | No            |                   |        | 2202070           |                          |                   | Aug              |


    # Tidy Up
    And   the override date is reset  
      