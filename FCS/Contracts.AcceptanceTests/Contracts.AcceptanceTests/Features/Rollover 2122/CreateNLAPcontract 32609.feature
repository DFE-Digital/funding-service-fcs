Feature: CreateNLAPcontract 32609

@AcceptanceTest @Complete
Scenario: A704 Bulk import a new NLAP contract for 21/22 with NLAPFundingConfig but no related Levy contract. Check docs and CRM financials
    Given there are no allocations marked as Under Termination for UKPRN '10017704' 
    And   there are no terminated or closed allocations for UKPRN '10017704' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017704' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017704' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017704' 

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017704'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ANAS-704      |
    | ANLP-704      |
    | YNAS-704      |
    | YNLP-704      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ANAS-704      |
    | ANLP-704      |
    | YNAS-704      |
    | YNLP-704      |

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
    | NLAP-704       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017704'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017704' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017704 Co Ltd' with UKPRN '10017704' and OrgId 'ORG0017704' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017704' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017704 | 117704 | 10017704 Co Ltd | 0              | Active                | Yes           | AA017704      | ?             | 1 Wellington Square    | Ayr                    | ?                      | ?                      | ?                      | ?                      | KA7 1EN   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017704 |




    # Change the date
    Given the override date is '01/12/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017704 | 10017704 Co Ltd      | ESFA-704             | NLAP-704       | 1                     | 01/01/2019        | 31/03/2021      | 202868.00     |                                       | Contract for Services                      | 2018   | New          | ORG0017704 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017704 | NLAP-704       | ANAS-704      | ANLAP-AS          | ANLAP-AS2019            | NONLEVY                 | 01/01/2019          | 31/03/2021        | 52757.00        |                                         |            |                                                             | New          |             |
    | 10017704 | NLAP-704       | ANLP-704      | ANLAP             | ANLAP2018               | NONLEVY                 | 01/01/2019          | 31/03/2021        | 52326.00        |                                         |            |                                                             | New          |             |
    | 10017704 | NLAP-704       | YNAS-704      | 16-18NLAP-AS      | 16-18NLAP-AS2019        | NONLEVY                 | 01/01/2019          | 31/03/2021        | 53022.00        |                                         |            |                                                             | New          |             |
    | 10017704 | NLAP-704       | YNLP-704      | 16-18NLAP         | 16-18NLAP2018           | NONLEVY                 | 01/01/2019          | 31/03/2021        | 44763.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | DeliverableDescription                                               | CRMIntent    | DeliveryOrg |
    | 10017704 | NLAP-704       | ANAS-704      | 1               | 0                     | 52757.00  | 1243.00  | 1979.00  | 754.00   | 729.00   | 3521.00  | 2547.00  | 783.00   | 2374.00  | 3269.00  | 586.00   | 2967.00  | 507.00   | 3204.00  | 3496.00  | 1638.00  | 793.00   | 610.00   | 176.00   | 1480.00  | 1267.00  | 2888.00  | 744.00   | 2493.00  | 2913.00  | 2636.00  | 3466.00  | 3694.00  | Adult Non-Levy Apprenticeships (Employer on Apprenticeship Service)  | New          |             | 
    | 10017704 | NLAP-704       | ANLP-704      | 1               | 0                     | 52326.00  | 183.00   | 1710.00  | 1813.00  | 2485.00  | 3187.00  | 2817.00  | 1211.00  | 2327.00  | 3662.00  | 1394.00  | 2762.00  | 2357.00  | 1606.00  | 158.00   | 801.00   | 840.00   | 722.00   | 1077.00  | 3711.00  | 3212.00  | 3726.00  | 2184.00  | 3108.00  | 3054.00  | 499.00   | 761.00   | 959.00   | Total Adult Non-Levy Apprenticeships Funding                         | New          |             | 
    | 10017704 | NLAP-704       | YNAS-704      | 1               | 0                     | 53022.00  | 1969.00  | 3748.00  | 1130.00  | 601.00   | 3170.00  | 1881.00  | 2048.00  | 3511.00  | 1841.00  | 2167.00  | 3155.00  | 190.00   | 1683.00  | 2641.00  | 1732.00  | 759.00   | 2696.00  | 586.00   | 497.00   | 2498.00  | 1179.00  | 2419.00  | 1416.00  | 1708.00  | 3551.00  | 1723.00  | 2523.00  | 16-18 Non-Levy Apprenticeships (Employer on Apprenticeship Service)  | New          |             | 
    | 10017704 | NLAP-704       | YNLP-704      | 1               | 0                     | 44763.00  | 2780.00  | 383.00   | 171.00   | 1792.00  | 3348.00  | 1396.00  | 833.00   | 556.00   | 1387.00  | 2597.00  | 3650.00  | 1475.00  | 596.00   | 1268.00  | 2953.00  | 2582.00  | 976.00   | 1110.00  | 3427.00  | 1159.00  | 1545.00  | 2123.00  | 1372.00  | 3625.00  | 566.00   | 606.00   | 487.00   | Total 16-18 Non-Levy Apprenticeships Funding                         | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | NLAP-704       | 1                     | 0                        | 2018-12-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NLAP-704'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-704' and actual ContractNumber 'NLAP-704'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-704' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017704 | NLAP-704           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2019        | 31/03/2021      | ?             |
    | 10017704 | ESFA-704           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2019        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '324' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
   Then  there are '324' deliverable period rows in CRM linked to the latest version of contract 'NLAP-704'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | YNLP-704        | 2240151          | Mar-21 | Reconciliation |
    | ANLP-704        | 2340151          | Mar-21 | Reconciliation |


 


    # Bulk amend to add 12 months to the contract

    # Change the date
    Given the override date is '07/02/2021'

    # Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   the following NLAP NewStarts profile values exist in config
    | UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
    | 10017704 | 756.00             | 317.00             | 605.00                               | 887.00                               |


    # Bulk file
    And   there are no files prefixed '10017704' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 25012021145418 v3_A704' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 25012021145418 v3_A704' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 25012021145418 v3_A704' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 25012021145418 v3_A704' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 25012021145418 v3_A704.xlsx' exists in the Datafiles folder and UKPRN '10017704' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017704' for FundingType 'NLA' and period '2018' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017704' for FundingType 'NLA' and period '2018'

    # Check the contents of the Appendices
   #Then  the file named '10017704_[ContractNo]_v2.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    #Then  the file named '10017704_NLAP-704_v2.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    #"""
    #APPENDIX 1 – SUMMARY OF FUNDING
    #Organisation Name: 10017704 Co Ltd UKPRN: 10017704
    #Master Contract Number: ESFA-704
    #Allocation
    #Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Apr 22 to Mar 23 Apr 23 to Mar 24 Apr 24 to Mar 25 Apr 25 to Mar 26 Apr 26 to Mar 27 Total
    #16-18 Non-Levy Apprenticeships YNLP-704 £3,334 £21,851 £19,578 £58,474 £103,237
    #of which New Starts £756 £756
    #16-18 Non-Levy Apprenticeships £6,847 £24,620 £21,555 £37,582 £90,604
    #(Employer on Apprenticeship 
    #Service)
    #Adult Non-Levy Apprenticeships ANLP-704 £3,706 £24,767 £23,853 £49,490 £101,816
    #of which New Starts £317 £317
    #Adult Non-Levy Apprenticeships £3,976 £25,621 £23,160 £52,906 £105,663
    #(Employer on Apprenticeship 
    #Service)
    #Total: £401,320
    #
    #Funding Agreement 16-18 Non-Levy Apprenticeships
    #Provider: 10017704 Co Ltd UKPRN: 10017704
    #Master Contract Ref: ESFA-704 Start Date: 01/01/2019 End Date: 31/03/2022
    #Contract Ref: YNLP-704
    #Cash (£) Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    #16-18 Non-Levy Apprenticeships £103,237 £2,780 £383 £171
    #Total Funding £103,237 £2,780 £383 £171
    #Ref (for internal use only):  NLAP-704 v2
    #Page 1 of 4 of this Funding Agreement
    #
    #Funding Agreement 16-18 Non-Levy Apprenticeships
    #Provider: 10017704 Co Ltd UKPRN: 10017704
    #Master Contract Ref: ESFA-704 Start Date: 01/01/2019 End Date: 31/03/2022
    #Contract Ref: YNLP-704
    #Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    #16-18 Non-Levy Apprenticeships £1,792 £3,348 £1,396 £833 £556 £1,387 £2,597 £3,650 £1,475 £596 £1,268 £2,953
    #Total Funding £1,792 £3,348 £1,396 £833 £556 £1,387 £2,597 £3,650 £1,475 £596 £1,268 £2,953
    #Ref (for internal use only):  NLAP-704 v2
    #Page 2 of 4 of this Funding Agreement
    #
    #Funding Agreement 16-18 Non-Levy Apprenticeships
    #Provider: 10017704 Co Ltd UKPRN: 10017704
    #Master Contract Ref: ESFA-704 Start Date: 01/01/2019 End Date: 31/03/2022
    #Contract Ref: YNLP-704
    #Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    #16-18 Non-Levy Apprenticeships £2,582 £976 £1,110 £3,427 £1,159 £1,545 £2,123 £1,372 £3,625 £566 £606 £487
    #Total Funding £2,582 £976 £1,110 £3,427 £1,159 £1,545 £2,123 £1,372 £3,625 £566 £606 £487
    #Ref (for internal use only):  NLAP-704 v2
    #Page 3 of 4 of this Funding Agreement
    #
    #Funding Agreement 16-18 Non-Levy Apprenticeships
    #Provider: 10017704 Co Ltd UKPRN: 10017704
    #Master Contract Ref: ESFA-704 Start Date: 01/01/2019 End Date: 31/03/2022
    #Contract Ref: YNLP-704
    #Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    #16-18 Non-Levy Apprenticeships £1,169 £4,927 £5,829 £5,234 £7,018 £7,507 £1,817 £5,097 £5,319 £6,763 £320 £7,474
    #Total Funding £1,169 £4,927 £5,829 £5,234 £7,018 £7,507 £1,817 £5,097 £5,319 £6,763 £320 £7,474
    #Ref (for internal use only):  NLAP-704 v2
    #Page 4 of 4 of this Funding Agreement
    #
    #Funding Agreement Adult Non-Levy Apprenticeships
    #Provider: 10017704 Co Ltd UKPRN: 10017704
    #Master Contract Ref: ESFA-704 Start Date: 01/01/2019 End Date: 31/03/2022
    #Contract Ref: ANLP-704
    #Cash (£) Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    #Adult Non-Levy Apprenticeships £101,816 £183 £1,710 £1,813
    #Total Funding £101,816 £183 £1,710 £1,813
    #Ref (for internal use only):  NLAP-704 v2
    #Page 1 of 4 of this Funding Agreement
    #
    #Funding Agreement Adult Non-Levy Apprenticeships
    #Provider: 10017704 Co Ltd UKPRN: 10017704
    #Master Contract Ref: ESFA-704 Start Date: 01/01/2019 End Date: 31/03/2022
    #Contract Ref: ANLP-704
    #Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    #Adult Non-Levy Apprenticeships £2,485 £3,187 £2,817 £1,211 £2,327 £3,662 £1,394 £2,762 £2,357 £1,606 £158 £801
    #Total Funding £2,485 £3,187 £2,817 £1,211 £2,327 £3,662 £1,394 £2,762 £2,357 £1,606 £158 £801
    #Ref (for internal use only):  NLAP-704 v2
    #Page 2 of 4 of this Funding Agreement
    #
    #Funding Agreement Adult Non-Levy Apprenticeships
    #Provider: 10017704 Co Ltd UKPRN: 10017704
    #Master Contract Ref: ESFA-704 Start Date: 01/01/2019 End Date: 31/03/2022
    #Contract Ref: ANLP-704
    #Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    #Adult Non-Levy Apprenticeships £840 £722 £1,077 £3,711 £3,212 £3,726 £2,184 £3,108 £3,054 £499 £761 £959
    #Total Funding £840 £722 £1,077 £3,711 £3,212 £3,726 £2,184 £3,108 £3,054 £499 £761 £959
    #Ref (for internal use only):  NLAP-704 v2
    #Page 3 of 4 of this Funding Agreement
    #
    #Funding Agreement Adult Non-Levy Apprenticeships
    #Provider: 10017704 Co Ltd UKPRN: 10017704
    #Master Contract Ref: ESFA-704 Start Date: 01/01/2019 End Date: 31/03/2022
    #Contract Ref: ANLP-704
    #Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    #Adult Non-Levy Apprenticeships £7,423 £7,306 £1,818 £268 £693 £7,370 £3,241 £7,678 £4,430 £4,111 £1,340 £3,812
    #Total Funding £7,423 £7,306 £1,818 £268 £693 £7,370 £3,241 £7,678 £4,430 £4,111 £1,340 £3,812
    #Ref (for internal use only):  NLAP-704 v2
    #Page 4 of 4 of this Funding Agreement
    #"""

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NLAP-704'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-704' and actual ContractNumber 'NLAP-704'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-704' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017704 | NLAP-704           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2019        | 31/03/2022      | Variation     |
    | 10017704 | NLAP-704           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/01/2019        | 31/03/2021      | ?             |
    | 10017704 | ESFA-704           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2019        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '468' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
   Then  there are '468' deliverable period rows in CRM linked to the latest version of contract 'NLAP-704'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | YNLP-704        | 2240151          | Mar-22 | Reconciliation |
    | ANLP-704        | 2340151          | Mar-22 | Reconciliation |





    # Actuals


    # Add actuals to the contract

    # Change the date
    Given the override date is '04/07/2021'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017704'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jun 2021
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201808 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 229.16      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201808 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 628.24      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201808 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 325.07      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201808 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 1264.90     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201809 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 1416.92     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201809 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 1058.88     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201809 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 1401.46     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201809 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 1080.83     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201810 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 183.93      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201810 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 663.43      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201810 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 1220.97     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201810 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 472.82      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201811 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 206.34      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201811 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 751.05      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201811 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 843.61      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201811 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 898.39      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201812 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 1399.11     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201812 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 1314.30     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201812 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 1079.19     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201812 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 365.63      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201901 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 1425.46     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201901 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 701.03      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201901 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 671.68      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201901 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 280.10      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201902 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 356.22      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201902 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 1236.23     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201902 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 433.62      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201902 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 1441.69     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201903 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 1479.24     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201903 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 1193.90     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201903 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 730.49      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201903 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 391.48      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201904 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 1258.70     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201904 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 1118.96     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201904 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 715.03      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201904 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 108.69      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201905 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 644.53      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201905 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 699.08      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201905 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 711.72      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201905 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 1457.45     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201906 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 1331.82     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201906 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 186.60      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201906 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 751.05      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201906 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 583.73      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201907 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 970.08      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201907 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 770.38      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201907 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 853.97      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201907 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 662.25      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201908 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 1322.76     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201908 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 1097.67     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201908 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 266.19      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201908 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 193.28      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201909 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 1376.49     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201909 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 1145.99     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201909 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 1242.67     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201909 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 1249.57     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201910 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 600.55      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201910 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 845.02      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201910 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 581.85      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201910 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 1273.19     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201911 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 1156.23     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201911 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 448.46      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201911 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 1110.15     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201911 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 622.41      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201912 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 656.14      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201912 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 1255.91     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201912 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 1116.28     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 201912 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 668.64      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202001 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 673.66      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202001 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 1084.74     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202001 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 935.61      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202001 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 843.20      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202002 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 202.29      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202002 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 1291.96     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202002 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 1484.61     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202002 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 234.25      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202003 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 665.02      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202003 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 146.11      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202003 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 345.13      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202003 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 933.69      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202004 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 1473.70     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202004 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 549.15      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202004 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 798.86      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202004 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 533.97      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202005 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 138.40      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202005 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 1308.29     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202005 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 211.65      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202005 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 375.04      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202006 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 1126.87     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202006 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 1357.87     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202006 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 1167.92     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202006 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 141.15      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202007 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 1273.80     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202007 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 131.30      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202007 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 555.00      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202007 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 1207.79     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202008 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 740.25      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202008 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 1082.86     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202008 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 1397.55     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202008 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 538.50      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202009 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 323.05      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202009 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 159.60      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202009 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 1241.88     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202009 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 331.82      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202010 | 16-18NLAP2018           | YNLP-704                 | ?          | 2               | 0            | 514.13      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202010 | 16-18NLAP2018           | YNLP-704                 | ?          | 3               | 0            | 1223.24     |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202010 | 16-18NLAP2018           | YNLP-704                 | ?          | 4               | 0            | 490.37      |
    | ILR2018        | R11                  | ORG0017704     | CM             | 202010 | 16-18NLAP2018           | YNLP-704                 | ?          | 5               | 0            | 1218.12     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


    # Check CRM financials

    # Check the RECONCILIATION subnominal aggregations in CRM
    Then   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | May-21    | Jun-21    | Jul-21    | 
    | 10017704 | NLAP-704       | ANLP-704           | 2340151                  | 0.00      | 0.00      | 0.00      | 
    | 10017704 | NLAP-704       | ANLP-704           | 2340161                  | 0.00      | 0.00      | 0.00      | 
    | 10017704 | NLAP-704       | ANLP-704           | 2340162                  | 0.00      | 0.00      | 0.00      | 
    #
    | 10017704 | NLAP-704       | YNLP-704           | 2240151                  | 0.00      | 38743.74  | 0.00      | 
    | 10017704 | NLAP-704       | YNLP-704           | 2240161                  | 0.00      | 17813.28  | 0.00      | 
    | 10017704 | NLAP-704       | YNLP-704           | 2240162                  | 0.00      | 15290.01  | 0.00      | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | May-21    | Jun-21    | Jul-21    | 
    | 10017704 | NLAP-704       | ANLP-704           | 2340151                  | 0.00      | 0.00      | 0.00      | 
    | 10017704 | NLAP-704       | ANLP-704           | 2340161                  | 0.00      | 0.00      | 0.00      | 
    | 10017704 | NLAP-704       | ANLP-704           | 2340162                  | 0.00      | 0.00      | 0.00      | 
    #
    | 10017704 | NLAP-704       | YNLP-704           | 2240151                  | 0.00      | -26468.97 | 0.00      | 
    | 10017704 | NLAP-704       | YNLP-704           | 2240161                  | 0.00      | -615.06   | 0.00      | 
    | 10017704 | NLAP-704       | YNLP-704           | 2240162                  | 0.00      | 0.00      | 0.00      | 


    # Tidy Up
    And   the override date is reset

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017704'

