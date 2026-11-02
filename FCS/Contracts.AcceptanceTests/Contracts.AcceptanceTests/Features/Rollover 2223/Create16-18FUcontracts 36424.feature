Feature: Create16-18FUcontracts 36424

@AcceptanceTest @Withdrawn25072024
Scenario: A978 Bulk load a new 2223 16-18FU contract. Check docs then publish and approve. Non-financial amendment then check docs. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017978' 
    And   there are no terminated or closed allocations for UKPRN '10017978' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017978' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017978' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18FU2223       |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017978' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017978 Co Ltd' with UKPRN '10017978' and OrgId 'ORG0017978' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017978' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017978 | 117978 | 10017978 Co Ltd | 0              | Active                | Yes           | AA017978      | ?             | 85 Bridge Road         | Hampton Court          | Surrey                 | ?                      | ?                      | ?                      | KT8 9HH   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017978 |




    # Change the date
    Given the override date is '01/03/2022'

    # Bulk file
    And   there are no files prefixed '10017978' in the Sharepoint '16-18FU-2223-Input-Appendices' folder
    And   there are no files prefixed '16-18FU FY 2223 21022022073458 v3_A978' in the Sharepoint 'Input' folder
    And   there are no files prefixed '16-18FU FY 2223 21022022073458 v3_A978' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '16-18FU FY 2223 21022022073458 v3_A978' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '16-18FU FY 2223 21022022073458 v3_A978' in the Sharepoint 'Reports' folder
    And   spreadsheet '16-18FU FY 2223 21022022073458 v3_A978.xlsx' exists in the Datafiles folder and UKPRN '10017978' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017978' for FundingType '16-18FU' and period '2223' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017978' for FundingType '16-18FU' and period '2223'

    # Check the contents of the Appendices
    And   the file named '10017978_[ContractNo]_v1.pdf' in Sharepoint location '16-18FU-2223-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017978 Co Ltd UKPRN: 10017978
    Master Contract Number: [MasterContractNo] Start Date: 01/04/2022 End Date: 31/03/2023
    Contract Ref: [AllocRef_16FU]
    Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    16-18 Education at an Adolescent Forensic Unit £50,000 £4,772 £4,113 £2,361 £5,504 £4,028 £2,616 £4,739 £5,320 £3,688 £3,635 £1,682 £7,542
    Total Funding £50,000 £4,772 £4,113 £2,361 £5,504 £4,028 £2,616 £4,739 £5,320 £3,688 £3,635 £1,682 £7,542
    16-18 Education at an Adolescent Forensic Unit – [AllocRef_16FU] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017978_[ContractNo]_v1.pdf' in '16-18FU-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A978_1.pdf'




    # Publish and approve
	
	# Change the date
    Given the override date is '03/03/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for actual MasterContractNumber 'ESFA-978' and actual ContractNumber '1618FU-978' and Version '1' 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017978 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2022        | 31/03/2023      | ?             |
    | 10017978 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2022        | 31/03/2023      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract '1618FU-978'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_16FU] | 2430670          | Mar-23 | Profile        |




	# Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | [ContractNo]   | [AllocRef_16FU]    | 1               | 50000.00  | 4772.00  | 4113.00  | 2361.00  | 5504.00  | 4028.00  | 2616.00  | 4739.00  | 5320.00  | 3688.00  | 3635.00  | 1682.00  | 7542.00  | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | [ContractNo]   | [AllocRef_16FU]    | 1               | 50000.00  | 4772.00  | 4113.00  | 2361.00  | 5504.00  | 4028.00  | 2616.00  | 4739.00  | 5320.00  | 3688.00  | 3635.00  | 1682.00  | 7542.00  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | [ContractNo]   | [AllocRef_16FU]    | 1               | 50000.00  | 4772.00  | 4113.00  | 2361.00  | 5504.00  | 4028.00  | 2616.00  | 4739.00  | 5320.00  | 3688.00  | 3635.00  | 1682.00  | 7542.00  | 

    


	
	# Create non-financial amendment and check doc

	# Change the date
    Given the override date is '30/03/2022'

    # Attempt a non-financial VARIATION amendment request on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017978 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2022        | 31/03/2023      | Variation     |
    | 10017978 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/04/2022        | 31/03/2023      | ?             |
    | 10017978 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2022        | 31/03/2023      | ?             |

    # Check the contents of the Appendices (Only the version number should have changed)
    And   the file named '10017978_[ContractNo]_v2.pdf' in Sharepoint location '16-18FU-2223-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017978 Co Ltd UKPRN: 10017978
    Master Contract Number: [MasterContractNo] Start Date: 01/04/2022 End Date: 31/03/2023
    Contract Ref: [AllocRef_16FU]
    Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    16-18 Education at an Adolescent Forensic Unit £50,000 £4,772 £4,113 £2,361 £5,504 £4,028 £2,616 £4,739 £5,320 £3,688 £3,635 £1,682 £7,542
    Total Funding £50,000 £4,772 £4,113 £2,361 £5,504 £4,028 £2,616 £4,739 £5,320 £3,688 £3,635 £1,682 £7,542
    16-18 Education at an Adolescent Forensic Unit – [AllocRef_16FU] – Page 1 Ref (for internal use only):  [ContractNo] v2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017978_[ContractNo]_v2.pdf' in '16-18FU-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A978_2.pdf'


    # Tidy up
    And   the override date is reset
  
@AcceptanceTest @Withdrawn_09Apr24
Scenario: A979 Create and approve a new 2223 16-18FU contract. Bulk amend and approve. Create PoP payment. Check CRM, CDA, Financials and feeds
    Given there are no allocations marked as Under Termination for UKPRN '10017979' 
    And   there are no terminated or closed allocations for UKPRN '10017979' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017979' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017979' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16FU-979      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16FU-979      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18FU2223       |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017979' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017979 Co Ltd' with UKPRN '10017979' and OrgId 'ORG0017979' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017979' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017979 | 117979 | 10017979 Co Ltd | 0              | Provider Under Change | Yes           | AA017979      | ?             | 3 Grays Heaven Road    | Aberfeldy              | ?                      | ?                      | ?                      | ?                      | AB11 6BQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017979 |




    # Change the date
    Given the override date is '01/03/2022'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017979 | 10017979 Co Ltd      | ESFA-979             | 1618FU-979     | 1                     | 01/04/2022        | 31/03/2023      | 6562.00       |                                       | Contract for Services                      | 2223   | New          | ORG0017979 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                            | CRMIntent    | DeliveryOrg |
    | 10017979 | 1618FU-979     | 16FU-979      | 16-18FU           | 16-18FU2223             | FY                      | 01/04/2022          | 31/03/2023        | 6562.00         |                                         |            |                                                  | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | DeliverableDescription                            | CRMIntent    | DeliveryOrg |
    | 10017979 | 1618FU-979     | 16FU-979      | 1               | 0                     | 6562.00   | 0.00     | 0.00     | 1455.00  | 0.00     | 0.00     | 798.00   | 0.00     | 0.00     | 1786.00  | 0.00     | 0.00     | 2523.00  | 16-18 Education at an Adolescent Forensic Unit    | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract '1618FU-979' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '1618FU-979'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-979' and actual ContractNumber '1618FU-979'

    # Check that the contract is now approved
    Then  the latest version of contract '1618FU-979' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017979 | 1618FU-979         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2022        | 31/03/2023      | ?             |
    | 10017979 | ESFA-979           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2022        | 31/03/2023      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract '1618FU-979'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | 16FU-979      | 2430670          | Mar-23 | Profile        |




	# Amend the contract

    # Change the date
    Given the override date is '28/03/2023'

    # Bulk file
    And   there are no files prefixed '10017979' in the Sharepoint '16-18FU-2021-Input-Appendices' folder
    And   there are no files prefixed '16-18FU FY 2223 21022022081938 v3_A979' in the Sharepoint 'Input' folder
    And   there are no files prefixed '16-18FU FY 2223 21022022081938 v3_A979' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '16-18FU FY 2223 21022022081938 v3_A979' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '16-18FU FY 2223 21022022081938 v3_A979' in the Sharepoint 'Reports' folder
    And   spreadsheet '16-18FU FY 2223 21022022081938 v3_A979.xlsx' exists in the Datafiles folder and UKPRN '10017979' is present in cell 'A2' of the Contract tab
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
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '1618FU-979'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-979' and actual ContractNumber '1618FU-979'

    # Check that the contract is now approved
    Then  the latest version of contract '1618FU-979' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017979 | 1618FU-979         | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2022        | 31/03/2023      | Variation     |
    | 10017979 | 1618FU-979         | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/04/2022        | 31/03/2023      | ?             |
    | 10017979 | ESFA-979           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2022        | 31/03/2023      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract '1618FU-979'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | 16FU-979      | 2430670          | Mar-23 | Profile        |




	# Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | 1618FU-979     | 16FU-979           | 1               | 66666.00  | 5449.00  | 3790.00  | 6990.00  | 6181.00  | 4723.00  | 7245.00  | 7417.00  | 2998.00  | 5365.00  | 5979.00  | 6310.00  | 4219.00  | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | 1618FU-979     | 16FU-979           | 1               | 66666.00  | 5449.00  | 3790.00  | 6990.00  | 6181.00  | 4723.00  | 7245.00  | 7417.00  | 2998.00  | 5365.00  | 5979.00  | 6310.00  | 4219.00  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | 1618FU-979     | 16FU-979           | 1               | 66666.00  | 5449.00  | 3790.00  | 6990.00  | 6181.00  | 4723.00  | 7245.00  | 7417.00  | 2998.00  | 5365.00  | 5979.00  | 6310.00  | 4219.00  | 


    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef    | ProfileSubnominal  | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | 10017979 | 1618FU-979     | 16FU-979         | 2430670            | 5449.00  | 3790.00  | 6990.00  | 6181.00  | 4723.00  | 7245.00  | 7417.00  | 2998.00  | 5365.00  | 5979.00  | 6310.00  | 4219.00  | 




	# Payment Batch for Jan-23 for 16-18FU2223 (PoP payment)

    # Change the date
    Given the override date is '04/01/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '16-18FU2223' AccountingPaymentPeriod '202210' CensusEndDate '04/01/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | 16FU-979                 | 202301 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 16-18FU2223                | 202301               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 16-18FU2223                | 202301               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18FU2223' PaymentPeriod '202210' CensusEndDate '04/01/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A979.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18FU2223' PaymentPeriod '202210' CensusEndDate '04/01/2023' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | 16FU                   | 2022          | 10             | 04          | ?       | 16FU-979      | 5979.00         | PROFILE          | Forensic Unit          | 2023-01-18 | 2022-04-01   | 2023-03-31 | ?              | 10017979 | 2430670    |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    And   there is an item on the Payment feed for FundingStreamPeriod '16-18FU2223' AccountingPaymentPeriod '202210' and CensusEndDate '04/01/2023'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                 |
    | Payment Requests for Funding Stream Period 16-18FU2223 for Payment Period 202210 have been generated as of Census End Date/Time 2023-01-04T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | 16-18FU2223         | 202210        | 2023-01-04T22:00:00Z  | 1                | 5979.00    |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | 16FU      | 01/04/2022   | 31/03/2023 | 04/01/2023    | 18/01/2023 | 2022          | 10             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName     | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription  | AggregatedValue |
    | ORG0017979  | 10017979       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | 16FU-979   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?           | ?                | ?               | ?                   | 2430670    | PROFILE        | Forensic Unit          | 5979.00         |





	# Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | 1618FU-979     | 16FU-979           | 1               | 66666.00  | 5449.00  | 3790.00  | 6990.00  | 6181.00  | 4723.00  | 7245.00  | 7417.00  | 2998.00  | 5365.00  | 5979.00  | 6310.00  | 4219.00  | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | 1618FU-979     | 16FU-979           | 1               | 66666.00  | 5449.00  | 3790.00  | 6990.00  | 6181.00  | 4723.00  | 7245.00  | 7417.00  | 2998.00  | 5365.00  | 5979.00  | 6310.00  | 4219.00  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | 1618FU-979     | 16FU-979           | 1               | 66666.00  | 5449.00  | 3790.00  | 6990.00  | 6181.00  | 4723.00  | 7245.00  | 7417.00  | 2998.00  | 5365.00  | 5979.00  | 6310.00  | 4219.00  | 


    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef    | ProfileSubnominal  | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | 10017979 | 1618FU-979     | 16FU-979         | 2430670            | 5449.00  | 3790.00  | 6990.00  | 6181.00  | 4723.00  | 7245.00  | 7417.00  | 2998.00  | 5365.00  | 5979.00  | 6310.00  | 4219.00  | 





    # CDA
    
    # Check the contents of the CDA report
    Given there is no CDA report named 'CDA Latest Version A979.csv'

    And   the following contracts are in the replicated CRM database
    | ContractNumber | ContractVersionNumber |
    | 1618FU-979     | 2                     |

    When  the following CDA report is run
    | FundingStreamPeriod  | Version               | Suffix |
    | 16-18FU2223          | Latest Version        | A979   |

    Then  a report named 'CDA Latest Version A979.csv' is created

    # Check the contents of the CDA report
    And   the following rows are present in the report
    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
    | 16-18FU2223             | 10017979 | 10017979 Co Ltd             |               |                             | 16FU-979                 | 1618FU-979     | ESFA-979                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 4                 | 2022            | 2022/23       |              | 5449         |              | 0             |              | Yes                | 5449.00        | 0.00             | 0.00                  | 0.00           | 5449.00         |             | No            |                   |        | 2430670           |                          |                   | Apr              |
    | 16-18FU2223             | 10017979 | 10017979 Co Ltd             |               |                             | 16FU-979                 | 1618FU-979     | ESFA-979                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 5                 | 2022            | 2022/23       |              | 3790         |              | 0             |              | Yes                | 3790.00        |                  | 0.00                  | 0.00           | 3790.00         |             | No            |                   |        | 2430670           |                          |                   | May              |
    | 16-18FU2223             | 10017979 | 10017979 Co Ltd             |               |                             | 16FU-979                 | 1618FU-979     | ESFA-979                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 6                 | 2022            | 2022/23       |              | 6990         |              | 0             |              | Yes                | 6990.00        |                  | 0.00                  | 0.00           | 6990.00         |             | No            |                   |        | 2430670           |                          |                   | Jun              |
    | 16-18FU2223             | 10017979 | 10017979 Co Ltd             |               |                             | 16FU-979                 | 1618FU-979     | ESFA-979                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 7                 | 2022            | 2022/23       |              | 6181         |              | 0             |              | Yes                | 6181.00        |                  | 0.00                  | 0.00           | 6181.00         |             | No            |                   |        | 2430670           |                          |                   | Jul              |
    | 16-18FU2223             | 10017979 | 10017979 Co Ltd             |               |                             | 16FU-979                 | 1618FU-979     | ESFA-979                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 8                 | 2022            | 2022/23       |              | 4723         |              | 0             |              | Yes                | 4723.00        |                  | 0.00                  | 0.00           | 4723.00         |             | No            |                   |        | 2430670           |                          |                   | Aug              |
    | 16-18FU2223             | 10017979 | 10017979 Co Ltd             |               |                             | 16FU-979                 | 1618FU-979     | ESFA-979                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 9                 | 2022            | 2022/23       |              | 7245         |              | 0             |              | Yes                | 7245.00        |                  | 0.00                  | 0.00           | 7245.00         |             | No            |                   |        | 2430670           |                          |                   | Sep              |
    | 16-18FU2223             | 10017979 | 10017979 Co Ltd             |               |                             | 16FU-979                 | 1618FU-979     | ESFA-979                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 10                | 2022            | 2022/23       |              | 7417         |              | 0             |              | Yes                | 7417.00        |                  | 0.00                  | 0.00           | 7417.00         |             | No            |                   |        | 2430670           |                          |                   | Oct              |
    | 16-18FU2223             | 10017979 | 10017979 Co Ltd             |               |                             | 16FU-979                 | 1618FU-979     | ESFA-979                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 11                | 2022            | 2022/23       |              | 2998         |              | 0             |              | Yes                | 2998.00        |                  | 0.00                  | 0.00           | 2998.00         |             | No            |                   |        | 2430670           |                          |                   | Nov              |
    | 16-18FU2223             | 10017979 | 10017979 Co Ltd             |               |                             | 16FU-979                 | 1618FU-979     | ESFA-979                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 12                | 2022            | 2022/23       |              | 5365         |              | 0             |              | Yes                | 5365.00        |                  | 0.00                  | 0.00           | 5365.00         |             | No            |                   |        | 2430670           |                          |                   | Dec              |
    | 16-18FU2223             | 10017979 | 10017979 Co Ltd             |               |                             | 16FU-979                 | 1618FU-979     | ESFA-979                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 1                 | 2023            | 2022/23       |              | 5979         |              | 0             |              | Yes                | 5979.00        |                  | 0.00                  | 0.00           | 5979.00         |             | Yes           |                   |        | 2430670           |                          |                   | Jan              |
    | 16-18FU2223             | 10017979 | 10017979 Co Ltd             |               |                             | 16FU-979                 | 1618FU-979     | ESFA-979                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 2                 | 2023            | 2022/23       |              | 6310         |              | 0             |              | Yes                | 6310.00        |                  | 0.00                  | 0.00           | 6310.00         |             | No            |                   |        | 2430670           |                          |                   | Feb              |
    | 16-18FU2223             | 10017979 | 10017979 Co Ltd             |               |                             | 16FU-979                 | 1618FU-979     | ESFA-979                | 01/04/2022                  | 31/03/2023                | 2                     | Approved       | Approved                |                                                      | 16-18 Education at an Adolescent Forensic Unit                  |                                                                 | 3                 | 2023            | 2022/23       |              | 4219         |              | 0             |              | Yes                | 4219.00        |                  | 0.00                  | 0.00           | 4219.00         |             | No            |                   |        | 2430670           |                          |                   | Mar              |

	   	 
	# Tidy Up
    Given the override date is reset

