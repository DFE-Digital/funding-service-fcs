Feature: CreateProcuredNonLevyContract 20496

@AcceptanceTest @Withdrawn20230123
Scenario: A395 Bulk load a new 15mth NLAP2018 contract (Jan18-Mar19). Check docs, CRM and PaaS. Publish and approve
    Given there are no allocations marked as Under Termination for UKPRN '10017395' 
    And   there are no terminated or closed allocations for UKPRN '10017395' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017395' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017395' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017395' 

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017395'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18NLAP2018     |
    | ANLAP2018         |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017395' 
    And   there is no caseload advisor for UKPRN '10017395' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017395 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017395' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017395 Co Ltd' with UKPRN '10017395' and OrgId 'ORG0017395' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017395 | 117395 | 10017395 Co Ltd | 0              | Active                | Yes           | AA017395      | ?             | 14 Woolton Lodge       | Woolton Hill           | ?                      | ?                      | Newbury                | Berkshire              | RG20 9SU  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017395 |
  
  


 #  # Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
 #  Given the following NLAP NewStarts profile values exist in config
 #  | UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
 #  | 10017395 | 0.00               | 0.00               | 0.00                                 | 0.00                                 |

    
    # Change the date
    Given the override date is '15/12/2017'

    # Bulk file
    And   there are no files prefixed '10017395' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 03112017114156 v2_A395' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 03112017114156 v2_A395' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 03112017114156 v2_A395' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 03112017114156 v2_A395' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 03112017114156 v2_A395.xlsx' exists in the Datafiles folder and UKPRN '10017395' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve Master Contract Number, Contract Number and Allocation References from CRM
    When  I retrieve the latest contract details from CRM for provider '10017395' for FundingType 'NLA' and period '2018'

    # Check the docs (SoF & FA)
    Then  the file named '10017395_[ContractNo]_v1.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017395 Co Ltd UKPRN: 10017395
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Apr 22 to Mar 23 Total
    16-18 Non-Levy Apprenticeships [AllocRef_YNLP] £10,801 £36,415 £0 £47,216
    of which New Starts £0 £0
    Adult Non-Levy Apprenticeships [AllocRef_ANLP] £7,607 £33,263 £0 £40,870
    of which New Starts £0 £0
    Total: £88,086

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017395 Co Ltd UKPRN: 10017395
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2019
    Contract Ref: [AllocRef_YNLP]
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    16-18 Non-Levy Apprenticeships £47,216 £4,366 £3,873 £2,562
    Total Funding £47,216 £4,366 £3,873 £2,562
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 2 of this Funding Agreement

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017395 Co Ltd UKPRN: 10017395
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2019
    Contract Ref: [AllocRef_YNLP]
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    16-18 Non-Levy Apprenticeships £4,914 £3,809 £2,753 £4,342 £5,525 £3,555 £3,515 £2,053 £488 £3,603 £210 £1,648
    Total Funding £4,914 £3,809 £2,753 £4,342 £5,525 £3,555 £3,515 £2,053 £488 £3,603 £210 £1,648
    Ref (for internal use only):  [ContractNo] v1
    Page 2 of 2 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017395 Co Ltd UKPRN: 10017395
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2019
    Contract Ref: [AllocRef_ANLP]
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    Adult Non-Levy Apprenticeships £40,870 £3,285 £1,164 £3,158
    Total Funding £40,870 £3,285 £1,164 £3,158
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 2 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017395 Co Ltd UKPRN: 10017395
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2019
    Contract Ref: [AllocRef_ANLP]
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    Adult Non-Levy Apprenticeships £1,545 £2,014 £4,977 £3,619 £3,325 £2,626 £4,723 £4,381 £1,036 £3,540 £401 £1,076
    Total Funding £1,545 £2,014 £4,977 £3,619 £3,325 £2,626 £4,723 £4,381 £1,036 £3,540 £401 £1,076
    Ref (for internal use only):  [ContractNo] v1
    Page 2 of 2 of this Funding Agreement
    """

    # Contract status is now at 'Awaiting Documentation'

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017395_[ContractNo]_v1.pdf' in 'NLA-2018-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A395.pdf'





    # Change the date
    Given the override date is '17/12/2017'
    
    # Publish the contract
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'
   
    # Inject an SFS contract approval message.
   #When  an AEB contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved in CRM
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the deliverable counts in CRM 
    And   there are '150' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017395 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017395 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |





    # Check financials in CRM and PaaS

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | [ContractNo]   | [AllocRef_ANLP] | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ANLP] | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ANLP] | 3               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ANLP] | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ANLP] | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | [ContractNo]   | [AllocRef_YNLP] | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_YNLP] | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_YNLP] | 3               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_YNLP] | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_YNLP] | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | [ContractNo]   | [AllocRef_ANLP] | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ANLP] | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ANLP] | 3               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ANLP] | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ANLP] | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | [ContractNo]   | [AllocRef_YNLP] | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_YNLP] | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_YNLP] | 3               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_YNLP] | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_YNLP] | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | [ContractNo]   | [AllocRef_ANLP] | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ANLP] | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ANLP] | 3               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ANLP] | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ANLP] | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | [ContractNo]   | [AllocRef_YNLP] | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_YNLP] | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_YNLP] | 3               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_YNLP] | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_YNLP] | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | [ContractNo]   | [AllocRef_ANLP] | 1               | 40870.00  | 3285.00  | 1164.00  | 3158.00  | 1545.00  | 2014.00  | 4977.00  | 3619.00  | 3325.00  | 2626.00  | 4723.00  | 4381.00  | 1036.00  | 3540.00  | 401.00   | 1076.00  | 
    | [ContractNo]   | [AllocRef_ANLP] | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ANLP] | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ANLP] | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ANLP] | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_YNLP] | 1               | 47216.00  | 4366.00  | 3873.00  | 2562.00  | 4914.00  | 3809.00  | 2753.00  | 4342.00  | 5525.00  | 3555.00  | 3515.00  | 2053.00  | 488.00   | 3603.00  | 210.00   | 1648.00  | 
    | [ContractNo]   | [AllocRef_YNLP] | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_YNLP] | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_YNLP] | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_YNLP] | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | [AllocRef_ANLP]  | 1             | 1               | 201801 | 2              | 0             | 3285.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 2               | 201801 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 3               | 201801 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 4               | 201801 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 5               | 201801 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 1               | 201802 | 2              | 0             | 1164.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 2               | 201802 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 3               | 201802 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 4               | 201802 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 5               | 201802 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 1               | 201803 | 2              | 0             | 3158.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 2               | 201803 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 3               | 201803 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 4               | 201803 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 5               | 201803 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 1               | 201804 | 2              | 0             | 1545.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 2               | 201804 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 3               | 201804 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 4               | 201804 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 5               | 201804 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 1               | 201805 | 2              | 0             | 2014.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 2               | 201805 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 3               | 201805 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 4               | 201805 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 5               | 201805 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 1               | 201806 | 2              | 0             | 4977.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 2               | 201806 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 3               | 201806 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 4               | 201806 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 5               | 201806 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 1               | 201807 | 2              | 0             | 3619.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 2               | 201807 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 3               | 201807 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 4               | 201807 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 5               | 201807 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 1               | 201808 | 2              | 0             | 3325.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 2               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 3               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 4               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 5               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 1               | 201809 | 2              | 0             | 2626.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 2               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 3               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 4               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 5               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 1               | 201810 | 2              | 0             | 4723.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 2               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 3               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 4               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 5               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 1               | 201811 | 2              | 0             | 4381.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 2               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 3               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 4               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 5               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 1               | 201812 | 2              | 0             | 1036.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 2               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 3               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 4               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 5               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 1               | 201901 | 2              | 0             | 3540.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 2               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 3               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 4               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 5               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 1               | 201902 | 2              | 0             | 401.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 2               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 3               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 4               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 5               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 1               | 201903 | 2              | 0             | 1076.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 2               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 3               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 4               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_ANLP]  | 1             | 5               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | [AllocRef_YNLP]  | 1             | 1               | 201801 | 2              | 0             | 4366.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 2               | 201801 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 3               | 201801 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 4               | 201801 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 5               | 201801 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 1               | 201802 | 2              | 0             | 3873.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 2               | 201802 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 3               | 201802 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 4               | 201802 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 5               | 201802 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 1               | 201803 | 2              | 0             | 2562.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 2               | 201803 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 3               | 201803 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 4               | 201803 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 5               | 201803 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 1               | 201804 | 2              | 0             | 4914.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 2               | 201804 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 3               | 201804 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 4               | 201804 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 5               | 201804 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 1               | 201805 | 2              | 0             | 3809.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 2               | 201805 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 3               | 201805 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 4               | 201805 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 5               | 201805 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 1               | 201806 | 2              | 0             | 2753.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 2               | 201806 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 3               | 201806 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 4               | 201806 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 5               | 201806 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 1               | 201807 | 2              | 0             | 4342.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 2               | 201807 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 3               | 201807 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 4               | 201807 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 5               | 201807 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 1               | 201808 | 2              | 0             | 5525.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 2               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 3               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 4               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 5               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 1               | 201809 | 2              | 0             | 3555.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 2               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 3               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 4               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 5               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 1               | 201810 | 2              | 0             | 3515.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 2               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 3               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 4               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 5               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 1               | 201811 | 2              | 0             | 2053.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 2               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 3               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 4               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 5               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 1               | 201812 | 2              | 0             | 488.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 2               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 3               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 4               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 5               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 1               | 201901 | 2              | 0             | 3603.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 2               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 3               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 4               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 5               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 1               | 201902 | 2              | 0             | 210.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 2               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 3               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 4               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 5               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 1               | 201903 | 2              | 0             | 1648.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 2               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 3               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 4               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | [AllocRef_YNLP]  | 1             | 5               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
Scenario: A396 Create a new two-allocation 2018 procured NLA contract. Update draft then publish and approve.  Check CRM, PaaS and AtomFeeds
    Given there is no Contract, Task or Workflow data for UKPRN '10017396'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
	And   the Allocation Delivery Monitoring Service atom feed is empty

	# Remove all trace of NLAP config values for Lifetime and NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017396'

    # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017396'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017396 Co Ltd' with UKPRN '10017396' and OrgId 'ORG0017396' and has 'FCS1 Test' as a manager
    And   UPIN '117396' is associated with UKPRN '10017396' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017396 | 117396 | 10017396 Co Ltd | 0              | Active |

    # Change the date
    And   the override date is '08/12/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017396 | 10017396 Co Ltd      | ESFA-396             | NLAP-396       | 1                     | 01/01/2018        | 31/03/2019      | 32636.00      | Contract for Services | 2018   | New          | ORG0017396 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent    |
    | 10017396 | NLAP-396       | YNLP-396      | 16-18NLAP         | NONLEVY                 | 01/01/2018          | 31/03/2019        | 13690.00        |         |         |                       | New          |
    | 10017396 | NLAP-396       | ANLP-396      | ANLAP             | NONLEVY                 | 01/01/2018          | 31/03/2019        | 18946.00        |         |         |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                        | CRMIntent    |
    | 10017396 | NLAP-396       | YNLP-396      | 1               | 0                     | 13690.00 | 1284.00  | 1157.00  | 884.00   | 1012.00  | 674.00   | 139.00   | 609.00   | 2448.00  | 152.00   | 976.00   | 912.00   | 1225.00  | 389.00   | 1186.00  | 643.00   | Total Adult Non-Levy Apprenticeships Funding  | New          |
    | 10017396 | NLAP-396       | ANLP-396      | 1               | 0                     | 18946.00 | 1572.00  | 1355.00  | 390.00   | 2347.00  | 1636.00  | 1265.00  | 976.00   | 268.00   | 1960.00  | 1149.00  | 1884.00  | 1490.00  | 2082.00  | 46.00    | 526.00   | Total 16-18 Non-Levy Apprenticeships Funding  | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check that the deliverables have all been created in CRM
    Then  there are '15' deliverable periods in CRM linked to the latest version of contract 'NLAP-396' and allocation 'YNLP-396'
    And   there are '15' deliverable periods in CRM linked to the latest version of contract 'NLAP-396' and allocation 'ANLP-396'

    # Change the date
    And   the override date is '10/12/2017'

	# Cleardown for the Update Draft
	Given there are no files prefixed 'NLA NONLEVY 2018 06112017080053 v2_A396' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 06112017080053 v2_A396' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 06112017080053 v2_A396' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 06112017080053 v2_A396' in the Sharepoint 'Reports' folder
   
    # Process the bulk file
    And   spreadsheet 'NLA NONLEVY 2018 06112017080053 v2_A396.xlsx' exists in the Datafiles folder and UKPRN '10017396' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is present in cell 'J2' of the 'Contract' tab of the results report

    # Check that the deliverables have all been created in CRM
    Then  there are '15' deliverable periods in CRM linked to the latest version of contract 'NLAP-396' and allocation 'YNLP-396'
    And   there are '15' deliverable periods in CRM linked to the latest version of contract 'NLAP-396' and allocation 'ANLP-396'

    # Publish the contract
    And   the latest version of contract 'NLAP-396' is in a state of 'Published to Provider'

    # Change the date
    And   the override date is '12/12/2017'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-396' and actual ContractNumber 'NLAP-396'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-396' is in status 'Approved'

    # Check the deliverable count in CRM has increased to reflect the addition of monitoring deliverables 
    And   there are '75' deliverable periods in CRM linked to the latest version of contract 'NLAP-396' and allocation 'YNLP-396'
    And   there are '75' deliverable periods in CRM linked to the latest version of contract 'NLAP-396' and allocation 'ANLP-396'

	# Check the values in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   |
    | NLAP-396       | ANLP-396        | 1               | 3654.00  | 1532.00  | 3526.00  | 1913.00  | 2382.00  | 5346.00  | 3987.00  | 3693.00  | 2994.00  | 5091.00  | 4750.00  | 1405.00  | 3908.00  | 769.00   | 1444.00  | 
    | NLAP-396       | ANLP-396        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NLAP-396       | ANLP-396        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NLAP-396       | ANLP-396        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NLAP-396       | YNLP-396        | 1               | 4734.00  | 4241.00  | 2930.00  | 5282.00  | 4177.00  | 3121.00  | 4710.00  | 5894.00  | 3923.00  | 3884.00  | 2422.00  | 857.00   | 3971.00  | 578.00   | 2016.00  | 
    | NLAP-396       | YNLP-396        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NLAP-396       | YNLP-396        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NLAP-396       | YNLP-396        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | ANLP-396         | 1             | 1               | 201801 | 2              | 0             | 3654.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ANLP-396         | 1             | 1               | 201802 | 2              | 0             | 1532.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ANLP-396         | 1             | 1               | 201803 | 2              | 0             | 3526.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ANLP-396         | 1             | 1               | 201804 | 2              | 0             | 1913.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ANLP-396         | 1             | 1               | 201805 | 2              | 0             | 2382.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ANLP-396         | 1             | 1               | 201806 | 2              | 0             | 5346.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ANLP-396         | 1             | 1               | 201807 | 2              | 0             | 3987.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ANLP-396         | 1             | 1               | 201808 | 2              | 0             | 3693.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ANLP-396         | 1             | 1               | 201809 | 2              | 0             | 2994.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ANLP-396         | 1             | 1               | 201810 | 2              | 0             | 5091.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ANLP-396         | 1             | 1               | 201811 | 2              | 0             | 4750.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ANLP-396         | 1             | 1               | 201812 | 2              | 0             | 1405.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ANLP-396         | 1             | 1               | 201901 | 2              | 0             | 3908.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ANLP-396         | 1             | 1               | 201902 | 2              | 0             | 769.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ANLP-396         | 1             | 1               | 201903 | 2              | 0             | 1444.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | YNLP-396         | 1             | 1               | 201801 | 2              | 0             | 4734.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | YNLP-396         | 1             | 1               | 201802 | 2              | 0             | 4241.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | YNLP-396         | 1             | 1               | 201803 | 2              | 0             | 2930.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | YNLP-396         | 1             | 1               | 201804 | 2              | 0             | 5282.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | YNLP-396         | 1             | 1               | 201805 | 2              | 0             | 4177.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | YNLP-396         | 1             | 1               | 201806 | 2              | 0             | 3121.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | YNLP-396         | 1             | 1               | 201807 | 2              | 0             | 4710.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | YNLP-396         | 1             | 1               | 201808 | 2              | 0             | 5894.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | YNLP-396         | 1             | 1               | 201809 | 2              | 0             | 3923.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | YNLP-396         | 1             | 1               | 201810 | 2              | 0             | 3884.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | YNLP-396         | 1             | 1               | 201811 | 2              | 0             | 2422.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | YNLP-396         | 1             | 1               | 201812 | 2              | 0             | 857.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | YNLP-396         | 1             | 1               | 201901 | 2              | 0             | 3971.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | YNLP-396         | 1             | 1               | 201902 | 2              | 0             | 578.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | YNLP-396         | 1             | 1               | 201903 | 2              | 0             | 2016.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |

    # Check CM feed for an an ItemType zero (Approval) event
    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version '1' of actual contract number 'NLAP-396'
    And   the ItemType '0' event for version '1' of actual contract number 'NLAP-396' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Check the ADP feed for category 0 (new approval) events
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events 
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | AllocationNumber | ContractVersionNumber |
    | NewContractAllocationApproved     | 0      | NLAP-396       | ANLP-396         | 1                     | 
    | NewContractAllocationApproved     | 0      | NLAP-396       | YNLP-396         | 1                     | 

    # Tidy up
    And   the override date is reset
