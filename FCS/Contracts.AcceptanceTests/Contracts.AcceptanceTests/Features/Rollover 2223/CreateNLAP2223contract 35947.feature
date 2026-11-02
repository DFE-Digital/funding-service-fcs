Feature: CreateNLAP2223contract 35947

@AcceptanceTest @Withdrawn20230221 
@Long2Run @Long2Run123
Scenario: A210 Bulk import a new 51mth NLAP2018 contract inc NLAPFundingConfig but no related Levy contract. Bulk amend to add 12mths for 22/23. Check docs. Actuals and Payment Batch

    # A210 has been replaced by A224

    # 1. Bulk import and approve an NLAP 2018 contract with six FSPs > contract v1
    # 2. Bulk amend contract v1 to extend contract and alloc dates (ANLP and YNLP) by 12mths > contract v2 
    # 3. Consume actuals and check financials
    # 4. Payment batch for 16-18NLAP2018
    # 5. Payment batch for ANLAP2018

    Given there are no allocations marked as Under Termination for UKPRN '10017210' 
    And   there are no terminated or closed allocations for UKPRN '10017210' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017210' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017210' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017210' 

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017210'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18NLAP2018     |
    | 16-18NLAP-AS2019  |
    | 16-18NLAP-PRS2020 |
    | ANLAP2018         |
    | ANLAP-AS2019      |
    | ANLAP-PRS2020     |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | NLAP-210       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017210'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017210' 
    And   there is no caseload advisor for UKPRN '10017210' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017210 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017210' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017210 Co Ltd' with UKPRN '10017210' and OrgId 'ORG0017210' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017210 | 117210 | 10017210 Co Ltd | 0              | Active                | Yes           | AA017210      | ?             | 60a North Street       | ?                      | ?                      | ?                      | Chichester             | West Sussex            | PO19 1NB  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017210 |


   
   

    # Part 1: Bulk import and approve an NLAP 2018 contract with six FSPs > contract v1
    
    # Change the date
    Given the override date is '23/01/2018'

    # Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   the following NLAP NewStarts profile values exist in config
    | UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
 #  | 10017210 | 15354.00           | 8276.00            | 22134.00                             | 11908.00                             |
    | 10017210 | 0.00               | 8276.00            | 22134.00                             | 11908.00                             |

    # Bulk file to create a Jan-18 to Mar-22 contract (51mths)
    And   there are no files prefixed '10017210' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 13122021144759 v3_A210' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 13122021144759 v3_A210' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 13122021144759 v3_A210' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 13122021144759 v3_A210' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 13122021144759 v3_A210.xlsx' exists in the Datafiles folder and UKPRN '10017210' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017210' for FundingType 'NLA' and period '2018' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017210' for FundingType 'NLA' and period '2018'

    # Check the contents of the Appendices  No FA for 16-18NLAP-AS2019 or ANLAP-AS2019 (27004)
    Then  the file named '10017210_[ContractNo]_v1.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Apr 22 to Mar 23 Apr 23 to Mar 24 Total
    16-18 Non-Levy Apprenticeships [AllocRef_YNLP] £14,263 £55,934 £55,183 £60,764 £44,109 £230,253
    of which New Starts £0 £0
    16-18 Non-Levy Apprenticeships £16,372 £0 £16,372
    (Employer on Apprenticeship Service)
    16-18 Non-Levy Provider Relief [AllocRef_YNLP] £99,814 £99,814
    Schemes
    of which Provider Relief Scheme 1 £47,969 £47,969
    (April to June 2020)
    of which Provider Relief Scheme 2 £51,845 £51,845
    (July to October 2020)
    Adult Non-Levy Apprenticeships [AllocRef_ANLP] £11,247 £42,570 £49,769 £47,399 £50,868 £201,853
    of which New Starts £8,276 £8,276
    Adult Non-Levy Apprenticeships £11,094 £0 £11,094
    (Employer on Apprenticeship Service)
    Adult Non-Levy Provider Relief [AllocRef_ANLP] £122,436 £122,436
    Schemes
    of which Provider Relief Scheme 1 £62,201 £62,201
    (April to June 2020)
    of which Provider Relief Scheme 2 £60,235 £60,235
    (July to October 2020)
    Total: £681,822
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2022
    Contract Ref: [AllocRef_YNLP]
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    16-18 Non-Levy Apprenticeships £230,253 £477 £7,769 £6,017
    Total Funding £230,253 £477 £7,769 £6,017
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 5 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2022
    Contract Ref: [AllocRef_YNLP]
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    16-18 Non-Levy Apprenticeships £1,209 £7,684 £6,272 £444 £2,026 £7,344 £7,291 £5,338 £3,247 £7,408 £2,875 £4,796
    Total Funding £1,209 £7,684 £6,272 £444 £2,026 £7,344 £7,291 £5,338 £3,247 £7,408 £2,875 £4,796
    Ref (for internal use only):  [ContractNo] v1
    Page 2 of 5 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2022
    Contract Ref: [AllocRef_YNLP]
    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    16-18 Non-Levy Apprenticeships £6,984 £4,149 £6,814 £4,659 £5,285 £1,294 £7,429 £7,037 £6,102 £954 £497 £3,979
    Total Funding £6,984 £4,149 £6,814 £4,659 £5,285 £1,294 £7,429 £7,037 £6,102 £954 £497 £3,979
    Ref (for internal use only):  [ContractNo] v1
    Page 3 of 5 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2022
    Contract Ref: [AllocRef_YNLP]
    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    16-18 Non-Levy Apprenticeships £7,323 £3,130 £4,032 £3,437 £5,221 £5,710 £7,971 £3,300 £3,522 £4,966 £6,474 £5,678
    Total Funding £7,323 £3,130 £4,032 £3,437 £5,221 £5,710 £7,971 £3,300 £3,522 £4,966 £6,474 £5,678
    Ref (for internal use only):  [ContractNo] v1
    Page 4 of 5 of this Funding Agreement

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2022
    Contract Ref: [AllocRef_YNLP]
    Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    16-18 Non-Levy Apprenticeships £2,228 £4,626 £7,493 £2,620 £5,561 £4,691 £3,077 £7,918 £1,346 £1,431 £1,177 £1,941
    Total Funding £2,228 £4,626 £7,493 £2,620 £5,561 £4,691 £3,077 £7,918 £1,346 £1,431 £1,177 £1,941
    Ref (for internal use only):  [ContractNo] v1
    Page 5 of 5 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships - Provider Relief Schemes
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/04/2020 End Date: 31/03/2021
    Contract Ref: [AllocRef_YNLP]
    Cash (£) Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    16-18 Non-Levy Apprenticeships - Provider Relief £47,969 £3,377 £5,840 £6,403 £6,827 £5,553 £1,424 £3,749 £2,613 £182 £5,363 £5,723 £915
    Scheme 1 (April to June 2020)
    16-18 Non-Levy Apprenticeships - Provider Relief £51,845 £5,278 £5,978 £150 £1,732 £4,938 £6,997 £5,044 £2,953 £7,114 £2,581 £2,390 £6,690
    Scheme 2 (July to October 2020)
    Total Funding £99,814 £8,655 £11,818 £6,553 £8,559 £10,491 £8,421 £8,793 £5,566 £7,296 £7,944 £8,113 £7,605
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2022
    Contract Ref: [AllocRef_ANLP]
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    Adult Non-Levy Apprenticeships £201,853 £5,341 £55 £5,851
    Total Funding £201,853 £5,341 £55 £5,851
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 5 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2022
    Contract Ref: [AllocRef_ANLP]
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    Adult Non-Levy Apprenticeships £6,477 £2,486 £6,510 £278 £7,295 £2,146 £1,689 £5,171 £565 £4,322 £3,113 £2,518
    Total Funding £6,477 £2,486 £6,510 £278 £7,295 £2,146 £1,689 £5,171 £565 £4,322 £3,113 £2,518
    Ref (for internal use only):  [ContractNo] v1
    Page 2 of 5 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2022
    Contract Ref: [AllocRef_ANLP]
    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    Adult Non-Levy Apprenticeships £4,302 £6,902 £1,212 £4,492 £2,603 £4,047 £7,666 £6,870 £3,420 £3,707 £735 £3,813
    Total Funding £4,302 £6,902 £1,212 £4,492 £2,603 £4,047 £7,666 £6,870 £3,420 £3,707 £735 £3,813
    Ref (for internal use only):  [ContractNo] v1
    Page 3 of 5 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2022
    Contract Ref: [AllocRef_ANLP]
    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    Adult Non-Levy Apprenticeships £4,641 £5,883 £4,269 £1,159 £2,539 £2,624 £2,369 £3,133 £6,680 £7,719 £872 £5,511
    Total Funding £4,641 £5,883 £4,269 £1,159 £2,539 £2,624 £2,369 £3,133 £6,680 £7,719 £872 £5,511
    Ref (for internal use only):  [ContractNo] v1
    Page 4 of 5 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2022
    Contract Ref: [AllocRef_ANLP]
    Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    Adult Non-Levy Apprenticeships £7,497 £7,380 £1,891 £2,454 £2,878 £1,604 £5,426 £7,751 £6,615 £4,184 £1,414 £1,774
    Total Funding £7,497 £7,380 £1,891 £2,454 £2,878 £1,604 £5,426 £7,751 £6,615 £4,184 £1,414 £1,774
    Ref (for internal use only):  [ContractNo] v1
    Page 5 of 5 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships - Provider Relief Schemes
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/04/2020 End Date: 31/03/2021
    Contract Ref: [AllocRef_ANLP]
    Cash (£) Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    Adult Non-Levy Apprenticeships - Provider Relief Scheme £62,201 £1,980 £4,039 £7,925 £7,946 £4,156 £5,462 £7,384 £3,732 £6,736 £3,562 £7,246 £2,033
    1 (April to June 2020)
    Adult Non-Levy Apprenticeships - Provider Relief Scheme £60,235 £5,993 £2,065 £3,784 £2,850 £5,653 £3,084 £6,566 £4,071 £5,717 £6,619 £6,025 £7,808
    2 (July to October 2020)
    Total Funding £122,436 £7,973 £6,104 £11,709 £10,796 £9,809 £8,546 £13,950 £7,803 £12,453 £10,181 £13,271 £9,841
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017210_[ContractNo]_v1.pdf' in 'NLA-2018-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A210_v1.pdf'

    
    
    
    
    # Publish and approve the contract

    #Change the date
    Given the override date is '25/01/2018'

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
    | 10017210 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2022      | ?             |
    | 10017210 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2022      | ?             |

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_YNLP] | 2240151          | Mar-22 | Reconciliation |
    | [AllocRef_YNLP] | 2240161          | Mar-22 | Reconciliation |
    | [AllocRef_YNLP] | 2240162          | Mar-22 | Reconciliation |
    | [AllocRef_ANLP] | 2340151          | Mar-22 | Reconciliation |
    | [AllocRef_ANLP] | 2340161          | Mar-22 | Reconciliation |
    | [AllocRef_ANLP] | 2340162          | Mar-22 | Reconciliation |





    # Part 2: Bulk amend contract v1 to extend contract and alloc dates by 12mths > contract v2 

    # Change the date
    Given the override date is '17/02/2022'

    # Bulk file to add 12mths to the contract and both of the 2018 allocs (Note: Bulk file includes [parameters])
    And   there are no files prefixed '10017210' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 13122021144801 v3_A210_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 13122021144801 v3_A210_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 13122021144801 v3_A210_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 13122021144801 v3_A210_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 13122021144801 v3_A210_1.xlsx' exists in the Datafiles folder and UKPRN '10017210' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017210' for FundingType 'NLA' and period '2018' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017210' for FundingType 'NLA' and period '2018'

    # Check the contents of the Appendices  No FA for 16-18NLAP-AS2019 or ANLAP-AS2019 (27004)
    Then  the file named '10017210_[ContractNo]_v2.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Apr 22 to Mar 23 Apr 23 to Mar 24 Total
    16-18 Non-Levy Apprenticeships [AllocRef_YNLP] £14,263 £55,934 £55,183 £60,764 £44,109 £44,117 £274,370
    of which New Starts £0 £0
    16-18 Non-Levy Apprenticeships £16,372 £0 £16,372
    (Employer on Apprenticeship Service)
    16-18 Non-Levy Provider Relief [AllocRef_YNLP] £99,814 £99,814
    Schemes
    of which Provider Relief Scheme 1 £47,969 £47,969
    (April to June 2020)
    of which Provider Relief Scheme 2 £51,845 £51,845
    (July to October 2020)
    Adult Non-Levy Apprenticeships [AllocRef_ANLP] £11,247 £42,570 £49,769 £47,399 £50,868 £37,312 £239,165
    of which New Starts £8,276 £8,276
    Adult Non-Levy Apprenticeships £11,094 £0 £11,094
    (Employer on Apprenticeship Service)
    Adult Non-Levy Provider Relief [AllocRef_ANLP] £122,436 £122,436
    Schemes
    of which Provider Relief Scheme 1 £62,201 £62,201
    (April to June 2020)
    of which Provider Relief Scheme 2 £60,235 £60,235
    (July to October 2020)
    Total: £763,251
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_YNLP]
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    16-18 Non-Levy Apprenticeships £274,370 £477 £7,769 £6,017
    Total Funding £274,370 £477 £7,769 £6,017
    Ref (for internal use only):  [ContractNo] v2
    Page 1 of 6 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_YNLP]
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    16-18 Non-Levy Apprenticeships £1,209 £7,684 £6,272 £444 £2,026 £7,344 £7,291 £5,338 £3,247 £7,408 £2,875 £4,796
    Total Funding £1,209 £7,684 £6,272 £444 £2,026 £7,344 £7,291 £5,338 £3,247 £7,408 £2,875 £4,796
    Ref (for internal use only):  [ContractNo] v2
    Page 2 of 6 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_YNLP]
    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    16-18 Non-Levy Apprenticeships £6,984 £4,149 £6,814 £4,659 £5,285 £1,294 £7,429 £7,037 £6,102 £954 £497 £3,979
    Total Funding £6,984 £4,149 £6,814 £4,659 £5,285 £1,294 £7,429 £7,037 £6,102 £954 £497 £3,979
    Ref (for internal use only):  [ContractNo] v2
    Page 3 of 6 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_YNLP]
    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    16-18 Non-Levy Apprenticeships £7,323 £3,130 £4,032 £3,437 £5,221 £5,710 £7,971 £3,300 £3,522 £4,966 £6,474 £5,678
    Total Funding £7,323 £3,130 £4,032 £3,437 £5,221 £5,710 £7,971 £3,300 £3,522 £4,966 £6,474 £5,678
    Ref (for internal use only):  [ContractNo] v2
    Page 4 of 6 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_YNLP]
    Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    16-18 Non-Levy Apprenticeships £2,228 £4,626 £7,493 £2,620 £5,561 £4,691 £3,077 £7,918 £1,346 £1,431 £1,177 £1,941
    Total Funding £2,228 £4,626 £7,493 £2,620 £5,561 £4,691 £3,077 £7,918 £1,346 £1,431 £1,177 £1,941
    Ref (for internal use only):  [ContractNo] v2
    Page 5 of 6 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_YNLP]
    Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    16-18 Non-Levy Apprenticeships £1,056 £3,480 £2,590 £3,638 £6,524 £7,773 £6,211 £3,045 £2,350 £2,370 £2,192 £2,888
    Total Funding £1,056 £3,480 £2,590 £3,638 £6,524 £7,773 £6,211 £3,045 £2,350 £2,370 £2,192 £2,888
    Ref (for internal use only):  [ContractNo] v2
    Page 6 of 6 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships - Provider Relief Schemes
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/04/2020 End Date: 31/03/2021
    Contract Ref: [AllocRef_YNLP]
    Cash (£) Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    16-18 Non-Levy Apprenticeships - Provider Relief £47,969 £3,377 £5,840 £6,403 £6,827 £5,553 £1,424 £3,749 £2,613 £182 £5,363 £5,723 £915
    Scheme 1 (April to June 2020)
    16-18 Non-Levy Apprenticeships - Provider Relief £51,845 £5,278 £5,978 £150 £1,732 £4,938 £6,997 £5,044 £2,953 £7,114 £2,581 £2,390 £6,690
    Scheme 2 (July to October 2020)
    Total Funding £99,814 £8,655 £11,818 £6,553 £8,559 £10,491 £8,421 £8,793 £5,566 £7,296 £7,944 £8,113 £7,605
    Ref (for internal use only):  [ContractNo] v2
    Page 1 of 1 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_ANLP]
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    Adult Non-Levy Apprenticeships £239,165 £5,341 £55 £5,851
    Total Funding £239,165 £5,341 £55 £5,851
    Ref (for internal use only):  [ContractNo] v2
    Page 1 of 6 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_ANLP]
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    Adult Non-Levy Apprenticeships £6,477 £2,486 £6,510 £278 £7,295 £2,146 £1,689 £5,171 £565 £4,322 £3,113 £2,518
    Total Funding £6,477 £2,486 £6,510 £278 £7,295 £2,146 £1,689 £5,171 £565 £4,322 £3,113 £2,518
    Ref (for internal use only):  [ContractNo] v2
    Page 2 of 6 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_ANLP]
    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    Adult Non-Levy Apprenticeships £4,302 £6,902 £1,212 £4,492 £2,603 £4,047 £7,666 £6,870 £3,420 £3,707 £735 £3,813
    Total Funding £4,302 £6,902 £1,212 £4,492 £2,603 £4,047 £7,666 £6,870 £3,420 £3,707 £735 £3,813
    Ref (for internal use only):  [ContractNo] v2
    Page 3 of 6 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_ANLP]
    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    Adult Non-Levy Apprenticeships £4,641 £5,883 £4,269 £1,159 £2,539 £2,624 £2,369 £3,133 £6,680 £7,719 £872 £5,511
    Total Funding £4,641 £5,883 £4,269 £1,159 £2,539 £2,624 £2,369 £3,133 £6,680 £7,719 £872 £5,511
    Ref (for internal use only):  [ContractNo] v2
    Page 4 of 6 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_ANLP]
    Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    Adult Non-Levy Apprenticeships £7,497 £7,380 £1,891 £2,454 £2,878 £1,604 £5,426 £7,751 £6,615 £4,184 £1,414 £1,774
    Total Funding £7,497 £7,380 £1,891 £2,454 £2,878 £1,604 £5,426 £7,751 £6,615 £4,184 £1,414 £1,774
    Ref (for internal use only):  [ContractNo] v2
    Page 5 of 6 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_ANLP]
    Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    Adult Non-Levy Apprenticeships £1,255 £2,268 £3,362 £5,900 £1,989 £1,901 £4,342 £2,868 £3,256 £2,001 £5,843 £2,327
    Total Funding £1,255 £2,268 £3,362 £5,900 £1,989 £1,901 £4,342 £2,868 £3,256 £2,001 £5,843 £2,327
    Ref (for internal use only):  [ContractNo] v2
    Page 6 of 6 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships - Provider Relief Schemes
    Provider: 10017210 Co Ltd UKPRN: 10017210
    Master Contract Ref: [MasterContractNo] Start Date: 01/04/2020 End Date: 31/03/2021
    Contract Ref: [AllocRef_ANLP]
    Cash (£) Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    Adult Non-Levy Apprenticeships - Provider Relief Scheme £62,201 £1,980 £4,039 £7,925 £7,946 £4,156 £5,462 £7,384 £3,732 £6,736 £3,562 £7,246 £2,033
    1 (April to June 2020)
    Adult Non-Levy Apprenticeships - Provider Relief Scheme £60,235 £5,993 £2,065 £3,784 £2,850 £5,653 £3,084 £6,566 £4,071 £5,717 £6,619 £6,025 £7,808
    2 (July to October 2020)
    Total Funding £122,436 £7,973 £6,104 £11,709 £10,796 £9,809 £8,546 £13,950 £7,803 £12,453 £10,181 £13,271 £9,841
    Ref (for internal use only):  [ContractNo] v2
    Page 1 of 1 of this Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017210_[ContractNo]_v2.pdf' in 'NLA-2018-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A210_v2.pdf'


    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017210 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2023      | Variation     |
    | 10017210 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/01/2018        | 31/03/2022      | ?             |
    | 10017210 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2022      | ?             |

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_YNLP] | 2240151          | Mar-23 | Reconciliation |
    | [AllocRef_YNLP] | 2240161          | Mar-23 | Reconciliation |
    | [AllocRef_YNLP] | 2240162          | Mar-23 | Reconciliation |
    | [AllocRef_ANLP] | 2340151          | Mar-23 | Reconciliation |
    | [AllocRef_ANLP] | 2340161          | Mar-23 | Reconciliation |
    | [AllocRef_ANLP] | 2340162          | Mar-23 | Reconciliation |





    # Part 3: Consume actuals and check financials
    
    # Add actuals to the contract

    # Change the date
    Given the override date is '04/02/2023'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Jan 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode   | DeliverableCode | ActualVolume | ActualValue |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202208 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 2               | 0            | 1083.52     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202208 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 3               | 0            | 1230.21     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202208 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 4               | 0            | 224.05      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202208 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 5               | 0            | 653.31      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202209 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 2               | 0            | 395.64      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202209 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 3               | 0            | 1490.87     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202209 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 4               | 0            | 1001.00     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202209 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 5               | 0            | 995.66      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202210 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 2               | 0            | 1499.00     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202210 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 3               | 0            | 539.54      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202210 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 4               | 0            | 1328.75     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202210 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 5               | 0            | 941.09      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202211 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 2               | 0            | 626.73      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202211 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 3               | 0            | 1014.31     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202211 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 4               | 0            | 1080.57     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202211 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 5               | 0            | 1307.26     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202212 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 2               | 0            | 1013.34     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202212 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 3               | 0            | 1349.14     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202212 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 4               | 0            | 142.05      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202212 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 5               | 0            | 1474.91     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202301 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 2               | 0            | 404.09      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202301 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 3               | 0            | 1045.78     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202301 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 4               | 0            | 795.46      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202301 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 5               | 0            | 634.75      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202302 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 2               | 0            | 1314.36     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202302 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 3               | 0            | 695.61      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202302 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 4               | 0            | 654.11      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202302 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 5               | 0            | 784.34      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202303 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 2               | 0            | 638.98      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202303 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 3               | 0            | 951.56      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202303 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 4               | 0            | 1346.75     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202303 | 16-18NLAP2018           | [AllocRef_YNLP]          |           | 5               | 0            | 274.92      |
    #
    | ILR2223        | R06                  | ORG0017210     | CM             | 202208 | ANLAP2018               | [AllocRef_ANLP]          |           | 2               | 0            | 611.71      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202208 | ANLAP2018               | [AllocRef_ANLP]          |           | 3               | 0            | 449.95      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202208 | ANLAP2018               | [AllocRef_ANLP]          |           | 4               | 0            | 751.93      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202208 | ANLAP2018               | [AllocRef_ANLP]          |           | 5               | 0            | 308.35      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202209 | ANLAP2018               | [AllocRef_ANLP]          |           | 2               | 0            | 514.49      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202209 | ANLAP2018               | [AllocRef_ANLP]          |           | 3               | 0            | 1082.36     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202209 | ANLAP2018               | [AllocRef_ANLP]          |           | 4               | 0            | 982.39      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202209 | ANLAP2018               | [AllocRef_ANLP]          |           | 5               | 0            | 583.93      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202210 | ANLAP2018               | [AllocRef_ANLP]          |           | 2               | 0            | 1336.94     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202210 | ANLAP2018               | [AllocRef_ANLP]          |           | 3               | 0            | 1017.53     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202210 | ANLAP2018               | [AllocRef_ANLP]          |           | 4               | 0            | 1319.41     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202210 | ANLAP2018               | [AllocRef_ANLP]          |           | 5               | 0            | 895.29      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202211 | ANLAP2018               | [AllocRef_ANLP]          |           | 2               | 0            | 985.61      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202211 | ANLAP2018               | [AllocRef_ANLP]          |           | 3               | 0            | 673.22      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202211 | ANLAP2018               | [AllocRef_ANLP]          |           | 4               | 0            | 1297.20     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202211 | ANLAP2018               | [AllocRef_ANLP]          |           | 5               | 0            | 277.29      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202212 | ANLAP2018               | [AllocRef_ANLP]          |           | 2               | 0            | 1043.46     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202212 | ANLAP2018               | [AllocRef_ANLP]          |           | 3               | 0            | 638.10      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202212 | ANLAP2018               | [AllocRef_ANLP]          |           | 4               | 0            | 1337.29     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202212 | ANLAP2018               | [AllocRef_ANLP]          |           | 5               | 0            | 702.87      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202301 | ANLAP2018               | [AllocRef_ANLP]          |           | 2               | 0            | 1279.18     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202301 | ANLAP2018               | [AllocRef_ANLP]          |           | 3               | 0            | 1343.59     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202301 | ANLAP2018               | [AllocRef_ANLP]          |           | 4               | 0            | 932.88      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202301 | ANLAP2018               | [AllocRef_ANLP]          |           | 5               | 0            | 1329.93     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202302 | ANLAP2018               | [AllocRef_ANLP]          |           | 2               | 0            | 106.56      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202302 | ANLAP2018               | [AllocRef_ANLP]          |           | 3               | 0            | 285.77      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202302 | ANLAP2018               | [AllocRef_ANLP]          |           | 4               | 0            | 1383.22     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202302 | ANLAP2018               | [AllocRef_ANLP]          |           | 5               | 0            | 1498.19     |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202303 | ANLAP2018               | [AllocRef_ANLP]          |           | 2               | 0            | 993.93      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202303 | ANLAP2018               | [AllocRef_ANLP]          |           | 3               | 0            | 797.27      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202303 | ANLAP2018               | [AllocRef_ANLP]          |           | 4               | 0            | 478.00      |
    | ILR2223        | R06                  | ORG0017210     | CM             | 202303 | ANLAP2018               | [AllocRef_ANLP]          |           | 5               | 0            | 1276.09     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


    # Check CRM and PaaS financials inc subnominals

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   |
    | [ContractNo]   | [AllocRef_ANLP]    | 2               | 5771.39   | 611.71   | 514.49   | 1336.94  | 985.61   | 1043.46  | 1279.18  | 
    | [ContractNo]   | [AllocRef_ANLP]    | 3               | 5204.75   | 449.95   | 1082.36  | 1017.53  | 673.22   | 638.10   | 1343.59  | 
    | [ContractNo]   | [AllocRef_ANLP]    | 4               | 6621.10   | 751.93   | 982.39   | 1319.41  | 1297.20  | 1337.29  | 932.88   | 
    | [ContractNo]   | [AllocRef_ANLP]    | 5               | 4097.66   | 308.35   | 583.93   | 895.29   | 277.29   | 702.87   | 1329.93  | 
    #
    | [ContractNo]   | [AllocRef_YNLP]    | 2               | 5022.32   | 1083.52  | 395.64   | 1499.00  | 626.73   | 1013.34  | 404.09   | 
    | [ContractNo]   | [AllocRef_YNLP]    | 3               | 6669.85   | 1230.21  | 1490.87  | 539.54   | 1014.31  | 1349.14  | 1045.78  | 
    | [ContractNo]   | [AllocRef_YNLP]    | 4               | 4571.88   | 224.05   | 1001.00  | 1328.75  | 1080.57  | 142.05   | 795.46   | 
    | [ContractNo]   | [AllocRef_YNLP]    | 5               | 6006.98   | 653.31   | 995.66   | 941.09   | 1307.26  | 1474.91  | 634.75   | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   |
    | [ContractNo]   | [AllocRef_ANLP]    | 2               | 5771.39   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5771.39  | 
    | [ContractNo]   | [AllocRef_ANLP]    | 3               | 5204.75   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5204.75  | 
    | [ContractNo]   | [AllocRef_ANLP]    | 4               | 6621.10   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6621.10  | 
    | [ContractNo]   | [AllocRef_ANLP]    | 5               | 4097.66   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4097.66  | 
    #
    | [ContractNo]   | [AllocRef_YNLP]    | 2               | 5022.32   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5022.32  | 
    | [ContractNo]   | [AllocRef_YNLP]    | 3               | 6669.85   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6669.85  | 
    | [ContractNo]   | [AllocRef_YNLP]    | 4               | 4571.88   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4571.88  | 
    | [ContractNo]   | [AllocRef_YNLP]    | 5               | 6006.98   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6006.98  | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   |
    | [ContractNo]   | [AllocRef_ANLP]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ANLP]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ANLP]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ANLP]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_YNLP]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_YNLP]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_YNLP]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_YNLP]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   |
    | [ContractNo]   | [AllocRef_ANLP]    | 2               | 5771.39   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5771.39  | 
    | [ContractNo]   | [AllocRef_ANLP]    | 3               | 5204.75   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5204.75  | 
    | [ContractNo]   | [AllocRef_ANLP]    | 4               | 6621.10   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6621.10  | 
    | [ContractNo]   | [AllocRef_ANLP]    | 5               | 4097.66   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4097.66  | 
    #
    | [ContractNo]   | [AllocRef_YNLP]    | 2               | 5022.32   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5022.32  | 
    | [ContractNo]   | [AllocRef_YNLP]    | 3               | 6669.85   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6669.85  | 
    | [ContractNo]   | [AllocRef_YNLP]    | 4               | 4571.88   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4571.88  | 
    | [ContractNo]   | [AllocRef_YNLP]    | 5               | 6006.98   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6006.98  | 

    And wait '20' seconds
    
    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Jan-23    |
    | 10017210 | [ContractNo]   | [AllocRef_ANLP]    | 2340151                  | 10976.14  | 
    | 10017210 | [ContractNo]   | [AllocRef_ANLP]    | 2340161                  | 6621.10   | 
    | 10017210 | [ContractNo]   | [AllocRef_ANLP]    | 2340162                  | 4097.66   | 
    #
    | 10017210 | [ContractNo]   | [AllocRef_YNLP]    | 2240151                  | 11692.17  | 
    | 10017210 | [ContractNo]   | [AllocRef_YNLP]    | 2240161                  | 4571.88   | 
    | 10017210 | [ContractNo]   | [AllocRef_YNLP]    | 2240162                  | 6006.98   | 





    # Part 4: Payment batch for 16-18NLAP2018
    
    # Change the date
    Given the override date is '08/02/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '16-18NLAP2018' AccountingPaymentPeriod '202210' CensusEndDate '08/02/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_YNLP]          | 202301 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 16-18NLAP2018              | 202301               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 16-18NLAP2018              | 202301               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18NLAP2018' PaymentPeriod '202210' CensusEndDate '08/02/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A210_1.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18NLAP2018' PaymentPeriod '202210' CensusEndDate '08/02/2023' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef   | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | YNLP                   | 2022          | 10             | 08          | ?       | [AllocRef_YNLP] | 11692.17        | RECONCILIATION   | 16-18 NLAP                         | 2023-02-20 | 2018-01-01   | 2024-03-31 | ?              | 10017210 | 2240151    |
    | YNLP                   | 2022          | 10             | 08          | ?       | [AllocRef_YNLP] | 4571.88         | RECONCILIATION   | 16-18 NLAP Employer                | 2023-02-20 | 2018-01-01   | 2024-03-31 | ?              | 10017210 | 2240161    |
    | YNLP                   | 2022          | 10             | 08          | ?       | [AllocRef_YNLP] | 6006.98         | RECONCILIATION   | 16-18NonLevy AppsInd               | 2023-02-20 | 2018-01-01   | 2024-03-31 | ?              | 10017210 | 2240162    |


 
 
 
    # Part 5: Payment batch for ANLAP2018

    # Change the date
    Given the override date is '08/02/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ANLAP2018' AccountingPaymentPeriod '202210' CensusEndDate '08/02/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_ANLP]          | 202301 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ANLAP2018                  | 202301               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ANLAP2018                  | 202301               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ANLAP2018' PaymentPeriod '202210' CensusEndDate '08/02/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A210_1.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ANLAP2018' PaymentPeriod '202210' CensusEndDate '08/02/2023' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef   | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | ANLP                   | 2022          | 10             | 08          | ?       | [AllocRef_ANLP] | 10976.14        | RECONCILIATION   | 19+ NLAP                           | 2023-02-20 | 2018-01-01   | 2024-03-31 | ?              | 10017210 | 2340151    |
    | ANLP                   | 2022          | 10             | 08          | ?       | [AllocRef_ANLP] | 6621.10         | RECONCILIATION   | 19+ NLAP Employer                  | 2023-02-20 | 2018-01-01   | 2024-03-31 | ?              | 10017210 | 2340161    |
    | ANLP                   | 2022          | 10             | 08          | ?       | [AllocRef_ANLP] | 4097.66         | RECONCILIATION   | 19+NonLevy AppsInd                 | 2023-02-20 | 2018-01-01   | 2024-03-31 | ?              | 10017210 | 2340162    |


    # Tidy Up
    Given the override date is reset

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017210'

@AcceptanceTest @Manual
Scenario: A349 Bulk create an NLAP contract without NLAP NewStarts config
    Given there are no allocations marked as Under Termination for UKPRN '10017349' 
    And   there are no terminated or closed allocations for UKPRN '10017349' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017349' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017349' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017349' 

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017349'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18NLAP2018     |
    | 16-18NLAP-AS2019  |
    | ANLAP2018         |
    | ANLAP-AS2019      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | NLAP-349       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017349'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017349' 
    And   there is no caseload advisor for UKPRN '10017349' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017349 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017349' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017349 Co Ltd' with UKPRN '10017349' and OrgId 'ORG0017349' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017349 | 117349 | 10017349 Co Ltd | 0              | In Administration     | Yes           | AA017349      | ?             | 20 Shepherds Road      | ?                      | ?                      | ?                      | Watford                | Hertfordshire          | WD1 7HX   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017349 |





    # Bulk load a new contract 

    # Change the date
    Given the override date is '23/01/2019'

 #  # Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
 #  And   the following NLAP NewStarts profile values exist in config
 #  | UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
 #  | 10017349 | 0.00               | 0.00               | 0.00                                 | 0.00                                 |

    # Bulk file
    And   there are no files prefixed '10017349' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 07042022113410 v3_A349' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 07042022113410 v3_A349' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 07042022113410 v3_A349' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 07042022113410 v3_A349' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 07042022113410 v3_A349.xlsx' exists in the Datafiles folder and UKPRN '10017349' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017349' for FundingType 'NLA' and period '2018' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017349' for FundingType 'NLA' and period '2018'

    # Check the contents of the Appendices
    Then  the file named '10017349_[ContractNo]_v1.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
   #Then  the file named '10017349_NLAP-349_v1.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017349 Co Ltd UKPRN: 10017349
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Apr 22 to Mar 23 Total
    16-18 Non-Levy Apprenticeships [AllocRef_YNLP] £14,530 £52,523 £54,247 £35,976 £51,126 £60,435 £268,837
    of which New Starts £0 £0
    16-18 Non-Levy Apprenticeships £25,950 £0 £25,950
    (Employer on Apprenticeship Service)
    Adult Non-Levy Apprenticeships [AllocRef_ANLP] £16,713 £44,595 £45,955 £53,154 £42,832 £46,303 £249,552
    of which New Starts £0 £0
    Adult Non-Levy Apprenticeships £19,547 £0 £19,547
    (Employer on Apprenticeship Service)
    Total: £563,886
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017349 Co Ltd UKPRN: 10017349
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_YNLP]
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    16-18 Non-Levy Apprenticeships £268,837 £5,866 £5,208 £3,456
    Total Funding £268,837 £5,866 £5,208 £3,456
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 6 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017349 Co Ltd UKPRN: 10017349
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_YNLP]
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    16-18 Non-Levy Apprenticeships £6,599 £5,123 £3,711 £5,834 £7,416 £5,278 £5,226 £3,272 £1,181 £5,343 £809 £2,731
    Total Funding £6,599 £5,123 £3,711 £5,834 £7,416 £5,278 £5,226 £3,272 £1,181 £5,343 £809 £2,731
    Ref (for internal use only):  [ContractNo] v1
    Page 2 of 6 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017349 Co Ltd UKPRN: 10017349
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_YNLP]
    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    16-18 Non-Levy Apprenticeships £4,918 £2,083 £4,748 £2,593 £3,220 £7,179 £5,363 £4,971 £4,037 £6,839 £6,382 £1,914
    Total Funding £4,918 £2,083 £4,748 £2,593 £3,220 £7,179 £5,363 £4,971 £4,037 £6,839 £6,382 £1,914
    Ref (for internal use only):  [ContractNo] v1
    Page 3 of 6 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017349 Co Ltd UKPRN: 10017349
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_YNLP]
    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    16-18 Non-Levy Apprenticeships £5,258 £1,064 £1,966 £1,372 £3,155 £3,644 £5,905 £1,234 £1,457 £2,900 £4,409 £3,612
    Total Funding £5,258 £1,064 £1,966 £1,372 £3,155 £3,644 £5,905 £1,234 £1,457 £2,900 £4,409 £3,612
    Ref (for internal use only):  [ContractNo] v1
    Page 4 of 6 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017349 Co Ltd UKPRN: 10017349
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_YNLP]
    Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    16-18 Non-Levy Apprenticeships £162 £2,561 £5,428 £555 £3,495 £2,625 £1,011 £5,852 £7,232 £7,317 £7,062 £7,826
    Total Funding £162 £2,561 £5,428 £555 £3,495 £2,625 £1,011 £5,852 £7,232 £7,317 £7,062 £7,826
    Ref (for internal use only):  [ContractNo] v1
    Page 5 of 6 of this Funding Agreement

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017349 Co Ltd UKPRN: 10017349
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_YNLP]
    Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    16-18 Non-Levy Apprenticeships £5,533 £4,461 £5,565 £2,253 £4,239 £4,122 £6,585 £7,147 £7,571 £6,298 £2,168 £4,493
    Total Funding £5,533 £4,461 £5,565 £2,253 £4,239 £4,122 £6,585 £7,147 £7,571 £6,298 £2,168 £4,493
    Ref (for internal use only):  [ContractNo] v1
    Page 6 of 6 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017349 Co Ltd UKPRN: 10017349
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_ANLP]
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    Adult Non-Levy Apprenticeships £249,552 £7,047 £7,747 £1,919
    Total Funding £249,552 £7,047 £7,747 £1,919
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 6 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017349 Co Ltd UKPRN: 10017349
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_ANLP]
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    Adult Non-Levy Apprenticeships £3,500 £6,707 £815 £6,812 £4,721 £932 £4,349 £4,159 £507 £5,623 £337 £6,133
    Total Funding £3,500 £6,707 £815 £6,812 £4,721 £932 £4,349 £4,159 £507 £5,623 £337 £6,133
    Ref (for internal use only):  [ContractNo] v1
    Page 2 of 6 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017349 Co Ltd UKPRN: 10017349
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_ANLP]
    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    Adult Non-Levy Apprenticeships £6,760 £2,768 £6,792 £560 £7,577 £2,428 £1,971 £5,453 £847 £4,604 £3,395 £2,800
    Total Funding £6,760 £2,768 £6,792 £560 £7,577 £2,428 £1,971 £5,453 £847 £4,604 £3,395 £2,800
    Ref (for internal use only):  [ContractNo] v1
    Page 3 of 6 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017349 Co Ltd UKPRN: 10017349
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_ANLP]
    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    Adult Non-Levy Apprenticeships £4,584 £7,184 £1,494 £4,774 £2,885 £4,329 £7,949 £7,152 £3,702 £3,989 £1,017 £4,095
    Total Funding £4,584 £7,184 £1,494 £4,774 £2,885 £4,329 £7,949 £7,152 £3,702 £3,989 £1,017 £4,095
    Ref (for internal use only):  [ContractNo] v1
    Page 4 of 6 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017349 Co Ltd UKPRN: 10017349
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_ANLP]
    Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    Adult Non-Levy Apprenticeships £4,923 £6,165 £4,551 £1,441 £2,821 £2,906 £2,651 £3,415 £6,962 £50 £1,154 £5,793
    Total Funding £4,923 £6,165 £4,551 £1,441 £2,821 £2,906 £2,651 £3,415 £6,962 £50 £1,154 £5,793
    Ref (for internal use only):  [ContractNo] v1
    Page 5 of 6 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017349 Co Ltd UKPRN: 10017349
    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2023
    Contract Ref: [AllocRef_ANLP]
    Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    Adult Non-Levy Apprenticeships £7,779 £7,662 £2,173 £2,736 £3,160 £1,887 £5,708 £82 £6,897 £4,467 £1,696 £2,056
    Total Funding £7,779 £7,662 £2,173 £2,736 £3,160 £1,887 £5,708 £82 £6,897 £4,467 £1,696 £2,056
    Ref (for internal use only):  [ContractNo] v1
    Page 6 of 6 of this Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017349_[ContractNo]_v1.pdf' in 'NLA-2018-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A349.pdf'
   #And   Sharepoint file '<filename1.pdf>' in 'NLA-2018-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A349.pdf'



    # Tidy Up
    Given the override date is reset
    
    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017349'

    # Clear down ContractRequest.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table

