Feature: MainstreamAPPS 33761

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run45
Scenario: A508 Create and approve a 2021 Mainstream APPS contract. Bulk load a new amendment 2122 Mainstream APPS contract. Check docs then publish and approve. Non-financial amendment then check docs. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017508' 
    And   there are no terminated or closed allocations for UKPRN '10017508' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017508' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017508' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | APPS-508      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | APPS-508      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | APPS2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | MAIN-508       | 1                     | 0                        |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017508' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017508 Co Ltd' with UKPRN '10017508' and OrgId 'ORG0017508' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017508' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017508 | 117508 | 10017508 Co Ltd | 0              | Active                | Yes           | AA017508      | ?             | 9 Bottisham Close      | Lower Earley           | ?                      | ?                      | Reading                | Berkshire              | RG6 4ED   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017508 |

    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription   | ContractType                            | Period | CRMIntent    | OrgId      |
    | 10017508 | 10017508 Co Ltd      | ESFA-508             | MAIN-508       | 1                     | 01/08/2020        | 31/07/2021      | 27998.00      |                       | Contract for Services                   | 2021   | New          | ORG0017508 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription   | CRMIntent    | DeliveryOrg |
    | 10017508 | MAIN-508       | APPS-508      | APPS              | APPS2021                | AY                      | 01/08/2020          | 31/07/2021        | 27998.00        |                                         |            |                         | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                     | CRMIntent    | DeliveryOrg |
    | 10017508 | MAIN-508       | APPS-508      | 1               | 0                     | 27998.00  | 16737.00  | 11261.00  | 124.00   | 3167.00  | 455.00   | 1191.00  | 3666.00  | 3642.00  | 2733.00  | 1759.00  | 3696.00  | 1586.00  | 2480.00  | 3499.00  | Apprenticeships Carry-In Total Funding     | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'MAIN-508' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'MAIN-508'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-508' and actual ContractNumber 'MAIN-508'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-508' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017508 | MAIN-508           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017508 | ESFA-508           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '288' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '288' deliverable period rows in CRM linked to the latest version of contract 'MAIN-508'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | APPS-508        | 2240100          | Jul-20 | Reconciliation |




    # Change the date
    Given the override date is '01/07/2021'

    # Bulk file - New Amendment to add 2021 Mainstream APPS contract 
    And   there are no files prefixed '10017508' in the Sharepoint 'MAIN-2122-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 2122 10062021092215 v3_A508' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 2122 10062021092215 v3_A508' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 2122 10062021092215 v3_A508' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 2122 10062021092215 v3_A508' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 2122 10062021092215 v3_A508.xlsx' exists in the Datafiles folder and UKPRN '10017508' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017508' for FundingType 'MAIN' and period '2122' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017508' for FundingType 'MAIN' and period '2122'

    # Check the contents of the Appendices
    Then  the file named '10017508_[ContractNo]_v1.pdf' in Sharepoint location 'MAIN-2122-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017508 Co Ltd UKPRN: 10017508
    Master Contract Number: ESFA-508
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    Apprenticeships Carry-In [AllocRef_APPS] £34,243 £15,757 £50,000
    Total Funding for this contract: £50,000

    Funding Agreement Apprenticeships Carry-In
    Provider: 10017508 Co Ltd UKPRN: 10017508
    Master Contract Number: ESFA-508 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Apprenticeships Carry-In £50,000 £5,537 £4,878 £3,127 £3,269 £4,760 £3,081 £5,505 £4,086 £4,453 £4,401 £3,447 £3,456
    Total Funding £50,000 £5,537 £4,878 £3,127 £3,269 £4,760 £3,081 £5,505 £4,086 £4,453 £4,401 £3,447 £3,456
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """


    # Change the date
    Given the override date is '11/07/2021'

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017508_[ContractNo]_v1.pdf' in 'MAIN-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A508.pdf'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'MAIN-508' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-508' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017508 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017508 | ESFA-508           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '288' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_APPS] | 2240100          | Jul-22 | Reconciliation |




    # Execute a NON-FINANCIAL amendment and check docs

    # Change the date
    Given the override date is '21/09/2021'

    # Issue a non-financial VARIATION amendment on v1 to create v2
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017508 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017508 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017508 | ESFA-508           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017508' for FundingType 'MAIN' and period '2122' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017508' for FundingType 'MAIN' and period '2122'

    # Check the contents of the Appendices. Same docs as v1
    Then  the file named '10017508_[ContractNo]_v2.pdf' in Sharepoint location 'MAIN-2122-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017508 Co Ltd UKPRN: 10017508
    Master Contract Number: ESFA-508
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    Apprenticeships Carry-In [AllocRef_APPS] £34,243 £15,757 £50,000
    Total Funding for this contract: £50,000

    Funding Agreement Apprenticeships Carry-In
    Provider: 10017508 Co Ltd UKPRN: 10017508
    Master Contract Number: ESFA-508 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Apprenticeships Carry-In £50,000 £5,537 £4,878 £3,127 £3,269 £4,760 £3,081 £5,505 £4,086 £4,453 £4,401 £3,447 £3,456
    Total Funding £50,000 £5,537 £4,878 £3,127 £3,269 £4,760 £3,081 £5,505 £4,086 £4,453 £4,401 £3,447 £3,456
    Ref (for internal use only):  [ContractNo] v2
    Page 1 of 1 of this Funding Agreement
    """


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run45
Scenario: A509 Create and approve a new 2122 Mainstream APPS contract. Consume actuals. Cap. Create PoA payment. Check CRM, CDA, Financials and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017509' 
    And   there are no terminated or closed allocations for UKPRN '10017509' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017509' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017509' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | APPS-509      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | APPS-509      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | APPS2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | MAIN-509       | 1                     | 0                        |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017509' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017509 Co Ltd' with UKPRN '10017509' and OrgId 'ORG0017509' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017509' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status    | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017509 | 117509 | 10017509 Co Ltd | 0              | Active    | Yes           | AA017509      | ?             | 4 Fullbridge House     | Fullbridge             | ?                      | ?                      | Maldon                 | Essex                  | CM9 4LA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017509 |




    # Change the date
    Given the override date is '01/07/2021'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017509 | 10017509 Co Ltd      | ESFA-509             | MAIN-509       | 1                     | 01/08/2021        | 31/07/2022      | 27998.00      |                                       | Contract for Services                      | 2122   | New          | ORG0017509 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017509 | MAIN-509       | APPS-509      | APPS              | APPS2122                | AY                      | 01/08/2021          | 31/07/2022        | 27998.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017509 | MAIN-509       | APPS-509      | 1               | 0                     | 27998.00  | 16737.00  | 11261.00  | 124.00   | 3167.00  | 455.00   | 1191.00  | 3666.00  | 3642.00  | 2733.00  | 1759.00  | 3696.00  | 1586.00  | 2480.00  | 3499.00  | Apprenticeships Carry-In Total Funding                          | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | MAIN-509       | 1                     | 0                        | 2021-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'MAIN-509' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'MAIN-509'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-509' and actual ContractNumber 'MAIN-509'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-509' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017509 | MAIN-509           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017509 | ESFA-509           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '288' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '288' deliverable period rows in CRM linked to the latest version of contract 'MAIN-509'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | APPS-509        | 2240100          | Jul-22 | Reconciliation |




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/09/2021'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017509'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2021
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS52               | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 8               | 0            | 1010.09     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 9               | 0            | 495.60      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 10              | 0            | 480.03      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 22              | 0            | 566.31      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 23              | 0            | 101.29      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 24              | 0            | 977.40      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 8               | 0            | 518.39      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 9               | 0            | 550.04      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 10              | 0            | 203.78      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 22              | 0            | 858.97      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 23              | 0            | 656.65      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 24              | 0            | 1136.36     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 8               | 0            | 1391.46     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 9               | 0            | 1406.06     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 10              | 0            | 1035.06     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 22              | 0            | 1292.11     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 23              | 0            | 201.31      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 24              | 0            | 495.17      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 8               | 0            | 761.60      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 9               | 0            | 280.79      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 10              | 0            | 680.32      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 22              | 0            | 1472.95     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 23              | 0            | 733.92      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 24              | 0            | 396.98      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 8               | 0            | 582.28      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 9               | 0            | 1365.47     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 10              | 0            | 1211.19     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 22              | 0            | 250.68      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 23              | 0            | 314.68      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 24              | 0            | 437.72      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 8               | 0            | 1135.97     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 9               | 0            | 1001.69     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 10              | 0            | 1035.64     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 22              | 0            | 902.94      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 23              | 0            | 606.10      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 24              | 0            | 343.98      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 8               | 0            | 300.69      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 9               | 0            | 381.94      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 10              | 0            | 896.57      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 22              | 0            | 840.11      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 23              | 0            | 659.74      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 24              | 0            | 1112.57     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 8               | 0            | 631.38      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 9               | 0            | 405.52      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 10              | 0            | 403.87      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 22              | 0            | 1309.03     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 23              | 0            | 705.46      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 24              | 0            | 1343.00     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 8               | 0            | 1462.30     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 9               | 0            | 871.23      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 10              | 0            | 1156.49     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 22              | 0            | 126.99      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 23              | 0            | 849.13      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 24              | 0            | 444.25      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 8               | 0            | 1186.79     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 9               | 0            | 1338.01     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 10              | 0            | 660.38      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 22              | 0            | 827.64      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 23              | 0            | 935.21      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 24              | 0            | 1146.97     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 8               | 0            | 220.74      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 9               | 0            | 1334.81     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 10              | 0            | 799.02      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 22              | 0            | 549.63      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 23              | 0            | 1180.48     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 24              | 0            | 1302.41     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 8               | 0            | 1105.75     |
    | APPS           | APPS52               | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 9               | 0            | 750.91      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 10              | 0            | 362.35      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 22              | 0            | 549.71      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 23              | 0            | 735.05      |
    | APPS           | APPS52               | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 24              | 0            | 299.27      |
    #
    | ILR2122        | R01                  | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 2               | 0            | 1158.43     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 3               | 0            | 188.00      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 4               | 0            | 290.63      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 5               | 0            | 971.13      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 6               | 0            | 1477.00     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 7               | 0            | 979.91      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 11              | 0            | 1422.11     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 12              | 0            | 1405.18     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 13              | 0            | 239.43      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 14              | 0            | 648.80      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 15              | 0            | 896.83      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 16              | 0            | 886.82      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 17              | 0            | 1427.08     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 18              | 0            | 1338.17     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 19              | 0            | 421.82      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 20              | 0            | 682.49      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202108 | APPS2122                | APPS-509                 | ?          | 21              | 0            | 278.08      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 2               | 0            | 621.01      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 3               | 0            | 1415.64     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 4               | 0            | 124.07      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 5               | 0            | 634.36      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 6               | 0            | 1059.18     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 7               | 0            | 130.19      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 11              | 0            | 1443.24     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 12              | 0            | 438.35      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 13              | 0            | 512.76      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 14              | 0            | 1322.73     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 15              | 0            | 955.83      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 16              | 0            | 1380.01     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 17              | 0            | 999.47      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 18              | 0            | 1477.59     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 19              | 0            | 196.27      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 20              | 0            | 693.58      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202109 | APPS2122                | APPS-509                 | ?          | 21              | 0            | 1104.01     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 2               | 0            | 378.16      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 3               | 0            | 601.91      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 4               | 0            | 104.55      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 5               | 0            | 1337.46     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 6               | 0            | 428.74      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 7               | 0            | 1347.39     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 11              | 0            | 1126.48     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 12              | 0            | 1446.63     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 13              | 0            | 726.38      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 14              | 0            | 329.02      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 15              | 0            | 707.89      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 16              | 0            | 873.45      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 17              | 0            | 1282.80     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 18              | 0            | 1099.20     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 19              | 0            | 1229.14     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 20              | 0            | 964.34      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202110 | APPS2122                | APPS-509                 | ?          | 21              | 0            | 596.20      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 2               | 0            | 550.73      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 3               | 0            | 1249.30     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 4               | 0            | 529.60      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 5               | 0            | 573.23      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 6               | 0            | 751.23      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 7               | 0            | 603.02      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 11              | 0            | 152.75      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 12              | 0            | 600.79      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 13              | 0            | 127.49      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 14              | 0            | 247.42      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 15              | 0            | 1249.96     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 16              | 0            | 367.92      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 17              | 0            | 399.87      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 18              | 0            | 1058.97     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 19              | 0            | 1279.35     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 20              | 0            | 237.70      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202111 | APPS2122                | APPS-509                 | ?          | 21              | 0            | 1266.64     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 2               | 0            | 180.30      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 3               | 0            | 500.43      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 4               | 0            | 569.12      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 5               | 0            | 1038.37     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 6               | 0            | 317.19      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 7               | 0            | 683.47      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 11              | 0            | 1388.90     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 12              | 0            | 422.34      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 13              | 0            | 1185.34     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 14              | 0            | 1368.84     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 15              | 0            | 1013.44     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 16              | 0            | 1056.88     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 17              | 0            | 1107.29     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 18              | 0            | 676.37      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 19              | 0            | 620.66      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 20              | 0            | 195.70      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202112 | APPS2122                | APPS-509                 | ?          | 21              | 0            | 359.30      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 2               | 0            | 664.81      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 3               | 0            | 771.88      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 4               | 0            | 1142.39     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 5               | 0            | 668.22      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 6               | 0            | 441.13      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 7               | 0            | 1083.69     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 11              | 0            | 234.66      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 12              | 0            | 858.35      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 13              | 0            | 819.92      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 14              | 0            | 249.81      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 15              | 0            | 778.81      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 16              | 0            | 1248.33     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 17              | 0            | 932.76      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 18              | 0            | 613.02      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 19              | 0            | 734.04      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 20              | 0            | 1398.01     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202201 | APPS2122                | APPS-509                 | ?          | 21              | 0            | 787.58      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 2               | 0            | 486.98      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 3               | 0            | 346.88      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 4               | 0            | 1005.32     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 5               | 0            | 1378.09     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 6               | 0            | 828.12      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 7               | 0            | 335.54      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 11              | 0            | 1153.17     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 12              | 0            | 943.07      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 13              | 0            | 1057.51     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 14              | 0            | 424.26      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 15              | 0            | 306.29      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 16              | 0            | 1375.85     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 17              | 0            | 832.77      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 18              | 0            | 1027.74     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 19              | 0            | 458.13      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 20              | 0            | 983.57      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202202 | APPS2122                | APPS-509                 | ?          | 21              | 0            | 769.90      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 2               | 0            | 1085.46     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 3               | 0            | 1027.71     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 4               | 0            | 196.65      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 5               | 0            | 715.17      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 6               | 0            | 446.08      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 7               | 0            | 106.52      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 11              | 0            | 628.12      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 12              | 0            | 1167.01     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 13              | 0            | 1201.84     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 14              | 0            | 255.40      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 15              | 0            | 282.99      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 16              | 0            | 847.86      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 17              | 0            | 972.89      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 18              | 0            | 651.39      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 19              | 0            | 317.64      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 20              | 0            | 226.08      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202203 | APPS2122                | APPS-509                 | ?          | 21              | 0            | 541.68      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 2               | 0            | 784.61      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 3               | 0            | 949.21      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 4               | 0            | 1187.80     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 5               | 0            | 637.36      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 6               | 0            | 305.13      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 7               | 0            | 514.92      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 11              | 0            | 1458.77     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 12              | 0            | 470.12      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 13              | 0            | 619.89      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 14              | 0            | 481.53      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 15              | 0            | 576.27      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 16              | 0            | 815.58      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 17              | 0            | 1239.52     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 18              | 0            | 1004.63     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 19              | 0            | 611.03      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 20              | 0            | 449.17      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202204 | APPS2122                | APPS-509                 | ?          | 21              | 0            | 675.23      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 2               | 0            | 1038.07     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 3               | 0            | 238.98      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 4               | 0            | 1330.49     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 5               | 0            | 485.71      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 6               | 0            | 193.30      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 7               | 0            | 363.25      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 11              | 0            | 137.70      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 12              | 0            | 1273.97     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 13              | 0            | 948.80      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 14              | 0            | 285.97      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 15              | 0            | 1151.92     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 16              | 0            | 434.22      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 17              | 0            | 1409.38     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 18              | 0            | 1230.19     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 19              | 0            | 1491.51     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 20              | 0            | 1448.81     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202205 | APPS2122                | APPS-509                 | ?          | 21              | 0            | 1015.59     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 2               | 0            | 411.68      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 3               | 0            | 496.55      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 4               | 0            | 1134.98     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 5               | 0            | 1003.13     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 6               | 0            | 860.94      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 7               | 0            | 1063.20     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 11              | 0            | 1041.85     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 12              | 0            | 1012.16     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 13              | 0            | 594.93      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 14              | 0            | 127.98      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 15              | 0            | 997.23      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 16              | 0            | 246.72      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 17              | 0            | 339.02      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 18              | 0            | 502.29      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 19              | 0            | 1404.55     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 20              | 0            | 384.11      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202206 | APPS2122                | APPS-509                 | ?          | 21              | 0            | 398.88      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 2               | 0            | 656.65      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 3               | 0            | 289.65      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 4               | 0            | 434.22      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 5               | 0            | 682.30      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 6               | 0            | 255.17      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 7               | 0            | 497.75      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 11              | 0            | 348.94      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 12              | 0            | 1071.11     |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 13              | 0            | 439.88      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 14              | 0            | 440.25      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 15              | 0            | 781.53      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 16              | 0            | 743.02      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 17              | 0            | 265.11      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 18              | 0            | 591.67      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 19              | 0            | 395.99      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 20              | 0            | 643.53      |
    | ILR2122        | R01                  | ORG0017509     | CM             | 202207 | APPS2122                | APPS-509                 | ?          | 21              | 0            | 481.87      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check MonitoringDeliverables.HeldReportedActualGroup (Only used for APPS contracts) Is the data showing as unprocessed ?
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS2122' OrgId 'ORG0017509' and Collection 'R01' marked as unprocessed
    And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS2122' OrgId 'ORG0017509' and Collection 'APPS52' marked as unprocessed

    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    When  MonthEnd processing has completed and the processing of held data is triggered

    And wait '10' seconds





    # Check CRM financials

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | MAIN-509       | APPS-509           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 2               | 1158.43   | 1158.43  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 3               | 188.00    | 188.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 4               | 290.63    | 290.63   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 5               | 971.13    | 971.13   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 6               | 1477.00   | 1477.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 7               | 979.91    | 979.91   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 8               | 1010.09   | 1010.09  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 9               | 495.60    | 495.60   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 10              | 480.03    | 480.03   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 11              | 1422.11   | 1422.11  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 12              | 1405.18   | 1405.18  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 13              | 239.43    | 239.43   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 14              | 648.80    | 648.80   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 15              | 896.83    | 896.83   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 16              | 886.82    | 886.82   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 17              | 1427.08   | 1427.08  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 18              | 1338.17   | 1338.17  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 19              | 421.82    | 421.82   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 20              | 682.49    | 682.49   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 21              | 278.08    | 278.08   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 22              | 566.31    | 566.31   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 23              | 101.29    | 101.29   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-509       | APPS-509           | 24              | 977.40    | 977.40   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | MAIN-509       | APPS-509           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 2               | 1158.43   | 1158.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 3               | 188.00    | 188.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 4               | 290.63    | 290.63   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 5               | 971.13    | 971.13   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 6               | 1477.00   | 1477.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 7               | 979.91    | 979.91   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 8               | 1010.09   | 1010.09  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 9               | 495.60    | 495.60   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 10              | 480.03    | 480.03   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 11              | 1422.11   | 1422.11  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 12              | 1405.18   | 1405.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 13              | 239.43    | 239.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 14              | 648.80    | 648.80   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 15              | 896.83    | 896.83   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 16              | 886.82    | 886.82   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 17              | 1427.08   | 1427.08  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 18              | 1338.17   | 1338.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 19              | 421.82    | 421.82   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 20              | 682.49    | 682.49   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 21              | 278.08    | 278.08   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 22              | 566.31    | 566.31   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 23              | 101.29    | 101.29   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 24              | 977.40    | 977.40   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | MAIN-509       | APPS-509           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 2               | -130.17   | -130.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 3               | -21.13    | -21.13   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 4               | -32.66    | -32.66   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 5               | -109.12   | -109.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 6               | -165.97   | -165.97  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 8               | -113.50   | -113.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 9               | -55.69    | -55.69   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 11              | -159.80   | -159.80  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 12              | -157.90   | -157.90  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 13              | -26.90    | -26.90   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 14              | -72.90    | -72.90   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 15              | -100.77   | -100.77  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 16              | -99.65    | -99.65   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 17              | -160.36   | -160.36  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 19              | -47.40    | -47.40   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 20              | -76.69    | -76.69   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 21              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 22              | -63.64    | -63.64   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 23              | -11.38    | -11.38   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 24              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | MAIN-509       | APPS-509           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 2               | 1028.26   | 1028.26  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 3               | 166.87    | 166.87   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 4               | 257.97    | 257.97   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 5               | 862.01    | 862.01   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 6               | 1311.03   | 1311.03  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 7               | 979.91    | 979.91   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 8               | 896.59    | 896.59   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 9               | 439.91    | 439.91   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 10              | 480.03    | 480.03   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 11              | 1262.31   | 1262.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 12              | 1247.28   | 1247.28  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 13              | 212.53    | 212.53   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 14              | 575.90    | 575.90   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 15              | 796.06    | 796.06   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 16              | 787.17    | 787.17   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 17              | 1266.72   | 1266.72  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 18              | 1338.17   | 1338.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 19              | 374.42    | 374.42   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 20              | 605.80    | 605.80   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 21              | 278.08    | 278.08   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 22              | 502.67    | 502.67   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 23              | 89.91     | 89.91    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-509       | APPS-509           | 24              | 977.40    | 977.40   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    | Apr-22    | May-22    | Jun-22    | Jul-22    |
    | 10017509 | MAIN-509       | APPS-509           | 2240100                  | 4085.19   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017509 | MAIN-509       | APPS-509           | 2240150                  | 1505.69   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017509 | MAIN-509       | APPS-509           | 2240160                  | 480.03    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017509 | MAIN-509       | APPS-509           | 2240170                  | 979.91    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017509 | MAIN-509       | APPS-509           | 2340100                  | 8030.56   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017509 | MAIN-509       | APPS-509           | 2340150                  | 667.60    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017509 | MAIN-509       | APPS-509           | 2340160                  | 977.40    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017509 | MAIN-509       | APPS-509           | 2340170                  | 1616.25   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    | Apr-22    | May-22    | Jun-22    | Jul-22    |
    | 10017509 | MAIN-509       | APPS-509           | 2240100                  | -459.05   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017509 | MAIN-509       | APPS-509           | 2240150                  | -169.19   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017509 | MAIN-509       | APPS-509           | 2240160                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017509 | MAIN-509       | APPS-509           | 2240170                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017509 | MAIN-509       | APPS-509           | 2340100                  | -902.37   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017509 | MAIN-509       | APPS-509           | 2340150                  | -75.02    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017509 | MAIN-509       | APPS-509           | 2340160                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017509 | MAIN-509       | APPS-509           | 2340170                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 





#    # Run the CDA report 
#    Given there is no CDA report named 'CDA Latest Version A509.csv'
#
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version               | Suffix |
#    | APPS2122              | Latest Version        | A509   |
#
#    Then  a report named 'CDA Latest Version A509.csv' is created
#
#    # Check the contents of the CDA report for Aug-21
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 16-18 Apprenticeships Learner Support                | 16-18 Apprenticeships Learner Support                           | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 290.63       |               |              | Yes                | 0.00           | 0.00             | 290.63                | -32.66         | 257.97          |             | No            |                   |        |                   | 2240100                  | 2240100           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 16-18 Apprenticeships Learning Support               | 16-18 Apprenticeships Learning Support                          | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 188          |               |              | Yes                | 0.00           | 0.00             | 188.00                | -21.13         | 166.87          |             | No            |                   |        |                   | 2240100                  | 2240100           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 16-18 Apprenticeships Programme Funding              | 16-18 Apprenticeships Programme Funding                         | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 1158.43      |               |              | Yes                | 0.00           | 0.00             | 1158.43               | -130.17        | 1028.26         |             | No            |                   |        |                   | 2240100                  | 2240100           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 16-18 Non-Levy Additional Payments for Employers     | 16-18 Non-Levy Additional Payments for Employers                | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 480.03       |               |              | Yes                | 0.00           | 0.00             | 480.03                | 0.00           | 480.03          |             | No            |                   |        |                   | 2240160                  | 2240160           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 16-18 Non-Levy Apprenticeships Learning Support      | 16-18 Non-Levy Apprenticeships Learning Support                 | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 495.6        |               |              | Yes                | 0.00           | 0.00             | 495.60                | -55.69         | 439.91          |             | No            |                   |        |                   | 2240150                  | 2240150           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 16-18 Non-Levy Apprenticeships Programme Funding     | 16-18 Non-Levy Apprenticeships Programme Funding                | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 1010.09      |               |              | Yes                | 0.00           | 0.00             | 1010.09               | -113.50        | 896.59          |             | No            |                   |        |                   | 2240150                  | 2240150           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 16-18 Trailblazer Additional Payments for Employers  | 16-18 Trailblazer Additional Payments for Employers             | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 979.91       |               |              | Yes                | 0.00           | 0.00             | 979.91                | 0.00           | 979.91          |             | No            |                   |        |                   | 2240170                  | 2240170           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 16-18 Trailblazer Apprenticeships Learning Support   | 16-18 Trailblazer Apprenticeships Learning Support              | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 1477         |               |              | Yes                | 0.00           | 0.00             | 1477.00               | -165.97        | 1311.03         |             | No            |                   |        |                   | 2240100                  | 2240100           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 16-18 Trailblazer Apprenticeships Programme Funding  | 16-18 Trailblazer Apprenticeships Programme Funding             | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 971.13       |               |              | Yes                | 0.00           | 0.00             | 971.13                | -109.12        | 862.01          |             | No            |                   |        |                   | 2240100                  | 2240100           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 19+ Apprenticeships Learner Support                  | 19+ Apprenticeships Learner Support                             | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 239.43       |               |              | Yes                | 0.00           | 0.00             | 239.43                | -26.90         | 212.53          |             | No            |                   |        |                   | 2340100                  | 2340100           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 19+ Non-Levy Additional Payments for Employers       | 19+ Non-Levy Additional Payments for Employers                  | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 977.4        |               |              | Yes                | 0.00           | 0.00             | 977.40                | 0.00           | 977.40          |             | No            |                   |        |                   | 2340160                  | 2340160           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 19+ Non-Levy Apprenticeships Learning Support        | 19+ Non-Levy Apprenticeships Learning Support                   | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 101.29       |               |              | Yes                | 0.00           | 0.00             | 101.29                | -11.38         | 89.91           |             | No            |                   |        |                   | 2340150                  | 2340150           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 19+ Non-Levy Apprenticeships Programme Funding       | 19+ Non-Levy Apprenticeships Programme Funding                  | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 566.31       |               |              | Yes                | 0.00           | 0.00             | 566.31                | -63.64         | 502.67          |             | No            |                   |        |                   | 2340150                  | 2340150           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 19-23 Apprenticeships Learning Support               | 19-23 Apprenticeships Learning Support                          | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 1405.18      |               |              | Yes                | 0.00           | 0.00             | 1405.18               | -157.90        | 1247.28         |             | No            |                   |        |                   | 2340100                  | 2340100           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 19-23 Apprenticeships Programme Funding              | 19-23 Apprenticeships Programme Funding                         | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 1422.11      |               |              | Yes                | 0.00           | 0.00             | 1422.11               | -159.80        | 1262.31         |             | No            |                   |        |                   | 2340100                  | 2340100           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 19-23 Trailblazer Additional Payments for Employers  | 19-23 Trailblazer Additional Payments for Employers             | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 1338.17      |               |              | Yes                | 0.00           | 0.00             | 1338.17               | 0.00           | 1338.17         |             | No            |                   |        |                   | 2340170                  | 2340170           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 19-23 Trailblazer Apprenticeships Learning Support   | 19-23 Trailblazer Apprenticeships Learning Support              | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 1427.08      |               |              | Yes                | 0.00           | 0.00             | 1427.08               | -160.36        | 1266.72         |             | No            |                   |        |                   | 2340100                  | 2340100           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 19-23 Trailblazer Apprenticeships Programme Funding  | 19-23 Trailblazer Apprenticeships Programme Funding             | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 886.82       |               |              | Yes                | 0.00           | 0.00             | 886.82                | -99.65         | 787.17          |             | No            |                   |        |                   | 2340100                  | 2340100           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 24+ Apprenticeships Learning Support                 | 24+ Apprenticeships Learning Support                            | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 896.83       |               |              | Yes                | 0.00           | 0.00             | 896.83                | -100.77        | 796.06          |             | No            |                   |        |                   | 2340100                  | 2340100           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 24+ Apprenticeships Programme Funding                | 24+ Apprenticeships Programme Funding                           | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 648.8        |               |              | Yes                | 0.00           | 0.00             | 648.80                | -72.90         | 575.90          |             | No            |                   |        |                   | 2340100                  | 2340100           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 24+ Trailblazer Additional Payments for Employers    | 24+ Trailblazer Additional Payments for Employers               | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 278.08       |               |              | Yes                | 0.00           | 0.00             | 278.08                | 0.00           | 278.08          |             | No            |                   |        |                   | 2340170                  | 2340170           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 24+ Trailblazer Apprenticeships Learning Support     | 24+ Trailblazer Apprenticeships Learning Support                | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 682.49       |               |              | Yes                | 0.00           | 0.00             | 682.49                | -76.69         | 605.80          |             | No            |                   |        |                   | 2340100                  | 2340100           | Aug              |
#    | APPS2122                | 10017509 | 10017509 Co Ltd             |               |                             | APPS-509                 | MAIN-509       | ESFA-509                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                | 24+ Trailblazer Apprenticeships Programme Funding    | 24+ Trailblazer Apprenticeships Programme Funding               | Apprenticeships Carry-In Total Funding                          | 8                 | 2021            | 2021/22       |              | 0            | 421.82       |               |              | Yes                | 0.00           | 0.00             | 421.82                | -47.40         | 374.42          |             | No            |                   |        |                   | 2340100                  | 2340100           | Aug              |




    
    # Payment Batch for APPS2122

    # Change the date
    Given the override date is '08/09/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'APPS2122' AccountingPaymentPeriod '202105' CensusEndDate '08/09/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | APPS-509                 | 202108 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | APPS2122                   | 202108               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | APPS2122                   | 202108               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'APPS2122' PaymentPeriod '202105' CensusEndDate '08/09/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A509.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'APPS2122' PaymentPeriod '202105' CensusEndDate '08/09/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription   | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | APPS                   | 2021          | 05             | 08          | ?       | APPS-509      | 4085.19         | RECONCILIATION   | 16-18 Apps              | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017509 | 2240100    |
    | APPS                   | 2021          | 05             | 08          | ?       | APPS-509      | 1505.69         | RECONCILIATION   | 16-18NonLevy Apps       | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017509 | 2240150    |
    | APPS                   | 2021          | 05             | 08          | ?       | APPS-509      | 480.03          | RECONCILIATION   | 16-18NonLevy AppsEmp    | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017509 | 2240160    |
    | APPS                   | 2021          | 05             | 08          | ?       | APPS-509      | 979.91          | RECONCILIATION   | 16-18 Apps Tblz Emp     | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017509 | 2240170    |
    | APPS                   | 2021          | 05             | 08          | ?       | APPS-509      | 8030.56         | RECONCILIATION   | 19+ Apps                | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017509 | 2340100    |
    | APPS                   | 2021          | 05             | 08          | ?       | APPS-509      | 667.60          | RECONCILIATION   | 19+NonLevy Apps         | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017509 | 2340150    |
    | APPS                   | 2021          | 05             | 08          | ?       | APPS-509      | 977.40          | RECONCILIATION   | 19+NonLevy AppsEmp      | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017509 | 2340160    |
    | APPS                   | 2021          | 05             | 08          | ?       | APPS-509      | 1616.25         | RECONCILIATION   | 19+ Apps Tblz Emp       | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017509 | 2340170    |
    #
    | APPS                   | 2021          | 05             | 08          | ?       | APPS-509      | -459.05         | CAPPING          | 16-18 Apps              | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017509 | 2240100    |
    | APPS                   | 2021          | 05             | 08          | ?       | APPS-509      | -169.19         | CAPPING          | 16-18NonLevy Apps       | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017509 | 2240150    |
    | APPS                   | 2021          | 05             | 08          | ?       | APPS-509      | -902.37         | CAPPING          | 19+ Apps                | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017509 | 2340100    |
    | APPS                   | 2021          | 05             | 08          | ?       | APPS-509      | -75.02          | CAPPING          | 19+NonLevy Apps         | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017509 | 2340150    |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'APPS2122' AccountingPaymentPeriod '202105' and CensusEndDate '08/09/2021'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                              |
    | Payment Requests for Funding Stream Period APPS2122 for Payment Period 202105 have been generated as of Census End Date/Time 2021-09-08T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | APPS2122            | 202105        | 2021-09-08T22:00:00Z  | 12               | 16737.00   |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | APPS      | 01/08/2021   | 31/07/2022 | 08/09/2021    | 20/09/2021 | 2021          | 05             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription  | AggregatedValue |
    | ORG0017509  | 10017509       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-509   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240100    | RECONCILIATION | 16-18 Apps             | 4085.19         |
    | ORG0017509  | 10017509       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-509   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240150    | RECONCILIATION | 16-18NonLevy Apps      | 1505.69         |
    | ORG0017509  | 10017509       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-509   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240160    | RECONCILIATION | 16-18NonLevy AppsEmp   | 480.03          |
    | ORG0017509  | 10017509       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-509   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240170    | RECONCILIATION | 16-18 Apps Tblz Emp    | 979.91          |
    | ORG0017509  | 10017509       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-509   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340100    | RECONCILIATION | 19+ Apps               | 8030.56         |
    | ORG0017509  | 10017509       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-509   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340150    | RECONCILIATION | 19+NonLevy Apps        | 667.60          |
    | ORG0017509  | 10017509       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-509   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340160    | RECONCILIATION | 19+NonLevy AppsEmp     | 977.40          |
    | ORG0017509  | 10017509       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-509   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340170    | RECONCILIATION | 19+ Apps Tblz Emp      | 1616.25         |
    #
    | ORG0017509  | 10017509       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-509   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240100    | CAPPING        | 16-18 Apps             | -459.05         |
    | ORG0017509  | 10017509       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-509   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240150    | CAPPING        | 16-18NonLevy Apps      | -169.19         |
    | ORG0017509  | 10017509       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-509   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340100    | CAPPING        | 19+ Apps               | -902.37         |
    | ORG0017509  | 10017509       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-509   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340150    | CAPPING        | 19+NonLevy Apps        | -75.02          |


     # Tidy Up
     And   the override date is reset
    
