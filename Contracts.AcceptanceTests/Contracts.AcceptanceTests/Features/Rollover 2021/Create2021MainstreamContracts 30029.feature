Feature: Create2021MainstreamContracts 30029

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run890
Scenario: A072 Create and approve a 1920 Mainstream APPS contract. Bulk load a new amendment 2021 Mainstream APPS contract. Check docs then publish and approve. Non-financial amendment then check docs. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017072' 
    And   there are no terminated or closed allocations for UKPRN '10017072' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017072' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017072' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | APPS-072      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | APPS-072      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | APPS2021          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | MAIN-072       | 1                     | 0                        |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017072' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017072 Co Ltd' with UKPRN '10017072' and OrgId 'ORG0017072' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017072' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017072 | 117072 | 10017072 Co Ltd | 0              | Active                | Yes           | AA017072      | ?             | 9 Bottisham Close      | Lower Earley           | ?                      | ?                      | Reading                | Berkshire              | RG6 4ED   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017072 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription   | ContractType                            | Period | CRMIntent    | OrgId      |
    | 10017072 | 10017072 Co Ltd      | ESFA-072             | MAIN-072       | 1                     | 01/08/2019        | 31/07/2020      | 27998.00      |                       | Contract for Services                   | 1920   | New          | ORG0017072 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription   | CRMIntent    | DeliveryOrg |
    | 10017072 | MAIN-072       | APPS-072      | APPS              | APPS2021                | AY                      | 01/08/2020          | 31/07/2021        | 27998.00        |                                         |            |                         | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                     | CRMIntent    | DeliveryOrg |
    | 10017072 | MAIN-072       | APPS-072      | 1               | 0                     | 27998.00  | 16737.00  | 11261.00  | 124.00   | 3167.00  | 455.00   | 1191.00  | 3666.00  | 3642.00  | 2733.00  | 1759.00  | 3696.00  | 1586.00  | 2480.00  | 3499.00  | Apprenticeships Carry-In Total Funding     | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'MAIN-072' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'MAIN-072'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-072' and actual ContractNumber 'MAIN-072'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-072' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017072 | MAIN-072           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017072 | ESFA-072           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '288' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '288' deliverable period rows in CRM linked to the latest version of contract 'MAIN-072'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | APPS-072        | 2240100          | Jul-19 | Reconciliation |




    # Change the date
    Given the override date is '01/07/2020'

    # Bulk file - New Amendment to add 2021 Mainstream APPS contract 
    And   there are no files prefixed '10017072' in the Sharepoint 'MAIN-2021-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 2021 29062020081306 v3_A072' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 2021 29062020081306 v3_A072' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 2021 29062020081306 v3_A072' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 2021 29062020081306 v3_A072' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 2021 29062020081306 v3_A072.xlsx' exists in the Datafiles folder and UKPRN '10017072' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017072' for FundingType 'MAIN' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017072' for FundingType 'MAIN' and period '2021'

    # Check the contents of the Appendices
    Then  the file named '10017072_[ContractNo]_v1.pdf' in Sharepoint location 'MAIN-2021-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017072 Co Ltd UKPRN: 10017072
    Master Contract Number: ESFA-072
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    Apprenticeships Carry-In [AllocRef_APPS] £34,243 £15,757 £50,000
    Total Funding for this contract: £50,000

    Funding Agreement Apprenticeships Carry-In
    Provider: 10017072 Co Ltd UKPRN: 10017072
    Master Contract Number: ESFA-072 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    Apprenticeships Carry-In £50,000 £5,537 £4,878 £3,127 £3,269 £4,760 £3,081 £5,505 £4,086 £4,453 £4,401 £3,447 £3,456
    Total Funding £50,000 £5,537 £4,878 £3,127 £3,269 £4,760 £3,081 £5,505 £4,086 £4,453 £4,401 £3,447 £3,456
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """


    # Change the date
    Given the override date is '11/07/2020'

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017072_[ContractNo]_v1.pdf' in 'MAIN-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A072.pdf'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'MAIN-072' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-072' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017072 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017072 | ESFA-072           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '288' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_APPS] | 2240100          | Jul-21 | Reconciliation |




    # Execute a NON-FINANCIAL amendment and check docs

    # Change the date
    Given the override date is '21/09/2020'

    # Issue a non-financial VARIATION amendment on v1 to create v2
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017072 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017072 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017072 | ESFA-072           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017072' for FundingType 'MAIN' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017072' for FundingType 'MAIN' and period '2021'

    # Check the contents of the Appendices. Same docs as v1
    Then  the file named '10017072_[ContractNo]_v2.pdf' in Sharepoint location 'MAIN-2021-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017072 Co Ltd UKPRN: 10017072
    Master Contract Number: ESFA-072
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    Apprenticeships Carry-In [AllocRef_APPS] £34,243 £15,757 £50,000
    Total Funding for this contract: £50,000

    Funding Agreement Apprenticeships Carry-In
    Provider: 10017072 Co Ltd UKPRN: 10017072
    Master Contract Number: ESFA-072 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    Apprenticeships Carry-In £50,000 £5,537 £4,878 £3,127 £3,269 £4,760 £3,081 £5,505 £4,086 £4,453 £4,401 £3,447 £3,456
    Total Funding £50,000 £5,537 £4,878 £3,127 £3,269 £4,760 £3,081 £5,505 £4,086 £4,453 £4,401 £3,447 £3,456
    Ref (for internal use only):  [ContractNo] v2
    Page 1 of 1 of this Funding Agreement
    """


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20220309
@Long2Run @Long2Run890
Scenario: A073 Create and approve a new 2021 Mainstream contract. Consume actuals. Cap. Create PoA payment. Check CRM, CDA, Financials and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017073' 
    And   there are no terminated or closed allocations for UKPRN '10017073' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017073' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017073' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | APPS-073      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | APPS-073      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | APPS2021          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | MAIN-073       | 1                     | 0                        |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017073' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017073 Co Ltd' with UKPRN '10017073' and OrgId 'ORG0017073' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017073' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017073 | 117073 | 10017073 Co Ltd | 0              | Provider Under Change | Yes           | AA017073      | ?             | 4 Fullbridge House     | Fullbridge             | ?                      | ?                      | Maldon                 | Essex                  | CM9 4LA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017073 |




    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017073 | 10017073 Co Ltd      | ESFA-073             | MAIN-073       | 1                     | 01/08/2020        | 31/07/2021      | 27998.00      |                                       | Contract for Services                      | 2021   | New          | ORG0017073 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017073 | MAIN-073       | APPS-073      | APPS              | APPS2021                | AY                      | 01/08/2020          | 31/07/2021        | 27998.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017073 | MAIN-073       | APPS-073      | 1               | 0                     | 27998.00  | 16737.00  | 11261.00  | 124.00   | 3167.00  | 455.00   | 1191.00  | 3666.00  | 3642.00  | 2733.00  | 1759.00  | 3696.00  | 1586.00  | 2480.00  | 3499.00  | Apprenticeships Carry-In Total Funding                          | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | MAIN-073       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'MAIN-073' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'MAIN-073'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-073' and actual ContractNumber 'MAIN-073'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-073' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017073 | MAIN-073           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017073 | ESFA-073           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '288' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '288' deliverable period rows in CRM linked to the latest version of contract 'MAIN-073'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | APPS-073        | 2240100          | Jul-21 | Reconciliation |




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/09/2020'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017073'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS40               | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 8               | 0            | 1010.09     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 9               | 0            | 495.60      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 10              | 0            | 480.03      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 22              | 0            | 566.31      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 23              | 0            | 101.29      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 24              | 0            | 977.40      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 8               | 0            | 518.39      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 9               | 0            | 550.04      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 10              | 0            | 203.78      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 22              | 0            | 858.97      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 23              | 0            | 656.65      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 24              | 0            | 1136.36     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 8               | 0            | 1391.46     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 9               | 0            | 1406.06     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 10              | 0            | 1035.06     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 22              | 0            | 1292.11     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 23              | 0            | 201.31      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 24              | 0            | 495.17      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 8               | 0            | 761.60      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 9               | 0            | 280.79      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 10              | 0            | 680.32      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 22              | 0            | 1472.95     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 23              | 0            | 733.92      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 24              | 0            | 396.98      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 8               | 0            | 582.28      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 9               | 0            | 1365.47     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 10              | 0            | 1211.19     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 22              | 0            | 250.68      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 23              | 0            | 314.68      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 24              | 0            | 437.72      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 8               | 0            | 1135.97     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 9               | 0            | 1001.69     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 10              | 0            | 1035.64     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 22              | 0            | 902.94      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 23              | 0            | 606.10      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 24              | 0            | 343.98      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 8               | 0            | 300.69      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 9               | 0            | 381.94      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 10              | 0            | 896.57      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 22              | 0            | 840.11      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 23              | 0            | 659.74      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 24              | 0            | 1112.57     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 8               | 0            | 631.38      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 9               | 0            | 405.52      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 10              | 0            | 403.87      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 22              | 0            | 1309.03     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 23              | 0            | 705.46      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 24              | 0            | 1343.00     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 8               | 0            | 1462.30     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 9               | 0            | 871.23      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 10              | 0            | 1156.49     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 22              | 0            | 126.99      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 23              | 0            | 849.13      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 24              | 0            | 444.25      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 8               | 0            | 1186.79     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 9               | 0            | 1338.01     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 10              | 0            | 660.38      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 22              | 0            | 827.64      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 23              | 0            | 935.21      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 24              | 0            | 1146.97     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 8               | 0            | 220.74      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 9               | 0            | 1334.81     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 10              | 0            | 799.02      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 22              | 0            | 549.63      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 23              | 0            | 1180.48     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 24              | 0            | 1302.41     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 8               | 0            | 1105.75     |
    | APPS           | APPS40               | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 9               | 0            | 750.91      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 10              | 0            | 362.35      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 22              | 0            | 549.71      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 23              | 0            | 735.05      |
    | APPS           | APPS40               | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 24              | 0            | 299.27      |
    #
    | ILR2021        | R01                  | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 2               | 0            | 1158.43     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 3               | 0            | 188.00      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 4               | 0            | 290.63      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 5               | 0            | 971.13      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 6               | 0            | 1477.00     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 7               | 0            | 979.91      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 11              | 0            | 1422.11     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 12              | 0            | 1405.18     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 13              | 0            | 239.43      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 14              | 0            | 648.80      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 15              | 0            | 896.83      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 16              | 0            | 886.82      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 17              | 0            | 1427.08     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 18              | 0            | 1338.17     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 19              | 0            | 421.82      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 20              | 0            | 682.49      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202008 | APPS2021                | APPS-073                 | ?          | 21              | 0            | 278.08      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 2               | 0            | 621.01      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 3               | 0            | 1415.64     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 4               | 0            | 124.07      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 5               | 0            | 634.36      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 6               | 0            | 1059.18     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 7               | 0            | 130.19      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 11              | 0            | 1443.24     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 12              | 0            | 438.35      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 13              | 0            | 512.76      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 14              | 0            | 1322.73     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 15              | 0            | 955.83      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 16              | 0            | 1380.01     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 17              | 0            | 999.47      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 18              | 0            | 1477.59     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 19              | 0            | 196.27      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 20              | 0            | 693.58      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202009 | APPS2021                | APPS-073                 | ?          | 21              | 0            | 1104.01     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 2               | 0            | 378.16      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 3               | 0            | 601.91      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 4               | 0            | 104.55      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 5               | 0            | 1337.46     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 6               | 0            | 428.74      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 7               | 0            | 1347.39     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 11              | 0            | 1126.48     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 12              | 0            | 1446.63     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 13              | 0            | 726.38      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 14              | 0            | 329.02      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 15              | 0            | 707.89      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 16              | 0            | 873.45      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 17              | 0            | 1282.80     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 18              | 0            | 1099.20     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 19              | 0            | 1229.14     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 20              | 0            | 964.34      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202010 | APPS2021                | APPS-073                 | ?          | 21              | 0            | 596.20      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 2               | 0            | 550.73      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 3               | 0            | 1249.30     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 4               | 0            | 529.60      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 5               | 0            | 573.23      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 6               | 0            | 751.23      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 7               | 0            | 603.02      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 11              | 0            | 152.75      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 12              | 0            | 600.79      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 13              | 0            | 127.49      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 14              | 0            | 247.42      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 15              | 0            | 1249.96     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 16              | 0            | 367.92      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 17              | 0            | 399.87      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 18              | 0            | 1058.97     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 19              | 0            | 1279.35     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 20              | 0            | 237.70      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202011 | APPS2021                | APPS-073                 | ?          | 21              | 0            | 1266.64     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 2               | 0            | 180.30      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 3               | 0            | 500.43      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 4               | 0            | 569.12      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 5               | 0            | 1038.37     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 6               | 0            | 317.19      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 7               | 0            | 683.47      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 11              | 0            | 1388.90     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 12              | 0            | 422.34      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 13              | 0            | 1185.34     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 14              | 0            | 1368.84     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 15              | 0            | 1013.44     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 16              | 0            | 1056.88     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 17              | 0            | 1107.29     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 18              | 0            | 676.37      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 19              | 0            | 620.66      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 20              | 0            | 195.70      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202012 | APPS2021                | APPS-073                 | ?          | 21              | 0            | 359.30      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 2               | 0            | 664.81      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 3               | 0            | 771.88      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 4               | 0            | 1142.39     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 5               | 0            | 668.22      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 6               | 0            | 441.13      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 7               | 0            | 1083.69     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 11              | 0            | 234.66      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 12              | 0            | 858.35      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 13              | 0            | 819.92      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 14              | 0            | 249.81      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 15              | 0            | 778.81      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 16              | 0            | 1248.33     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 17              | 0            | 932.76      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 18              | 0            | 613.02      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 19              | 0            | 734.04      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 20              | 0            | 1398.01     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202101 | APPS2021                | APPS-073                 | ?          | 21              | 0            | 787.58      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 2               | 0            | 486.98      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 3               | 0            | 346.88      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 4               | 0            | 1005.32     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 5               | 0            | 1378.09     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 6               | 0            | 828.12      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 7               | 0            | 335.54      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 11              | 0            | 1153.17     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 12              | 0            | 943.07      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 13              | 0            | 1057.51     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 14              | 0            | 424.26      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 15              | 0            | 306.29      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 16              | 0            | 1375.85     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 17              | 0            | 832.77      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 18              | 0            | 1027.74     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 19              | 0            | 458.13      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 20              | 0            | 983.57      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202102 | APPS2021                | APPS-073                 | ?          | 21              | 0            | 769.90      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 2               | 0            | 1085.46     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 3               | 0            | 1027.71     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 4               | 0            | 196.65      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 5               | 0            | 715.17      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 6               | 0            | 446.08      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 7               | 0            | 106.52      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 11              | 0            | 628.12      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 12              | 0            | 1167.01     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 13              | 0            | 1201.84     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 14              | 0            | 255.40      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 15              | 0            | 282.99      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 16              | 0            | 847.86      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 17              | 0            | 972.89      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 18              | 0            | 651.39      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 19              | 0            | 317.64      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 20              | 0            | 226.08      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202103 | APPS2021                | APPS-073                 | ?          | 21              | 0            | 541.68      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 2               | 0            | 784.61      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 3               | 0            | 949.21      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 4               | 0            | 1187.80     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 5               | 0            | 637.36      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 6               | 0            | 305.13      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 7               | 0            | 514.92      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 11              | 0            | 1458.77     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 12              | 0            | 470.12      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 13              | 0            | 619.89      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 14              | 0            | 481.53      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 15              | 0            | 576.27      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 16              | 0            | 815.58      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 17              | 0            | 1239.52     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 18              | 0            | 1004.63     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 19              | 0            | 611.03      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 20              | 0            | 449.17      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202104 | APPS2021                | APPS-073                 | ?          | 21              | 0            | 675.23      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 2               | 0            | 1038.07     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 3               | 0            | 238.98      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 4               | 0            | 1330.49     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 5               | 0            | 485.71      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 6               | 0            | 193.30      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 7               | 0            | 363.25      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 11              | 0            | 137.70      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 12              | 0            | 1273.97     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 13              | 0            | 948.80      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 14              | 0            | 285.97      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 15              | 0            | 1151.92     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 16              | 0            | 434.22      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 17              | 0            | 1409.38     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 18              | 0            | 1230.19     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 19              | 0            | 1491.51     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 20              | 0            | 1448.81     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202105 | APPS2021                | APPS-073                 | ?          | 21              | 0            | 1015.59     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 2               | 0            | 411.68      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 3               | 0            | 496.55      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 4               | 0            | 1134.98     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 5               | 0            | 1003.13     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 6               | 0            | 860.94      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 7               | 0            | 1063.20     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 11              | 0            | 1041.85     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 12              | 0            | 1012.16     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 13              | 0            | 594.93      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 14              | 0            | 127.98      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 15              | 0            | 997.23      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 16              | 0            | 246.72      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 17              | 0            | 339.02      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 18              | 0            | 502.29      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 19              | 0            | 1404.55     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 20              | 0            | 384.11      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202106 | APPS2021                | APPS-073                 | ?          | 21              | 0            | 398.88      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 2               | 0            | 656.65      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 3               | 0            | 289.65      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 4               | 0            | 434.22      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 5               | 0            | 682.30      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 6               | 0            | 255.17      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 7               | 0            | 497.75      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 11              | 0            | 348.94      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 12              | 0            | 1071.11     |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 13              | 0            | 439.88      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 14              | 0            | 440.25      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 15              | 0            | 781.53      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 16              | 0            | 743.02      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 17              | 0            | 265.11      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 18              | 0            | 591.67      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 19              | 0            | 395.99      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 20              | 0            | 643.53      |
    | ILR2021        | R01                  | ORG0017073     | CM             | 202107 | APPS2021                | APPS-073                 | ?          | 21              | 0            | 481.87      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check MonitoringDeliverables.HeldReportedActualGroup (Only used for APPS contracts) Is the data showing as unprocessed ?
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS2021' OrgId 'ORG0017073' and Collection 'R01' marked as unprocessed
    And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS2021' OrgId 'ORG0017073' and Collection 'APPS40' marked as unprocessed

    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    When  MonthEnd processing has completed and the processing of held data is triggered




    # Check CRM financials

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | MAIN-073       | APPS-073           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 2               | 1158.43   | 1158.43  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 3               | 188.00    | 188.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 4               | 290.63    | 290.63   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 5               | 971.13    | 971.13   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 6               | 1477.00   | 1477.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 7               | 979.91    | 979.91   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 8               | 1010.09   | 1010.09  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 9               | 495.60    | 495.60   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 10              | 480.03    | 480.03   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 11              | 1422.11   | 1422.11  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 12              | 1405.18   | 1405.18  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 13              | 239.43    | 239.43   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 14              | 648.80    | 648.80   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 15              | 896.83    | 896.83   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 16              | 886.82    | 886.82   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 17              | 1427.08   | 1427.08  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 18              | 1338.17   | 1338.17  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 19              | 421.82    | 421.82   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 20              | 682.49    | 682.49   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 21              | 278.08    | 278.08   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 22              | 566.31    | 566.31   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 23              | 101.29    | 101.29   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-073       | APPS-073           | 24              | 977.40    | 977.40   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | MAIN-073       | APPS-073           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 2               | 1158.43   | 1158.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 3               | 188.00    | 188.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 4               | 290.63    | 290.63   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 5               | 971.13    | 971.13   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 6               | 1477.00   | 1477.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 7               | 979.91    | 979.91   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 8               | 1010.09   | 1010.09  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 9               | 495.60    | 495.60   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 10              | 480.03    | 480.03   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 11              | 1422.11   | 1422.11  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 12              | 1405.18   | 1405.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 13              | 239.43    | 239.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 14              | 648.80    | 648.80   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 15              | 896.83    | 896.83   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 16              | 886.82    | 886.82   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 17              | 1427.08   | 1427.08  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 18              | 1338.17   | 1338.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 19              | 421.82    | 421.82   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 20              | 682.49    | 682.49   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 21              | 278.08    | 278.08   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 22              | 566.31    | 566.31   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 23              | 101.29    | 101.29   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 24              | 977.40    | 977.40   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | MAIN-073       | APPS-073           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 2               | -130.17   | -130.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 3               | -21.13    | -21.13   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 4               | -32.66    | -32.66   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 5               | -109.12   | -109.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 6               | -165.97   | -165.97  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 8               | -113.50   | -113.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 9               | -55.69    | -55.69   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 11              | -159.80   | -159.80  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 12              | -157.90   | -157.90  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 13              | -26.90    | -26.90   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 14              | -72.90    | -72.90   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 15              | -100.77   | -100.77  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 16              | -99.65    | -99.65   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 17              | -160.36   | -160.36  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 19              | -47.40    | -47.40   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 20              | -76.69    | -76.69   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 21              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 22              | -63.64    | -63.64   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 23              | -11.38    | -11.38   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 24              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | MAIN-073       | APPS-073           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 2               | 1028.26   | 1028.26  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 3               | 166.87    | 166.87   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 4               | 257.97    | 257.97   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 5               | 862.01    | 862.01   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 6               | 1311.03   | 1311.03  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 7               | 979.91    | 979.91   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 8               | 896.59    | 896.59   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 9               | 439.91    | 439.91   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 10              | 480.03    | 480.03   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 11              | 1262.31   | 1262.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 12              | 1247.28   | 1247.28  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 13              | 212.53    | 212.53   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 14              | 575.90    | 575.90   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 15              | 796.06    | 796.06   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 16              | 787.17    | 787.17   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 17              | 1266.72   | 1266.72  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 18              | 1338.17   | 1338.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 19              | 374.42    | 374.42   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 20              | 605.80    | 605.80   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 21              | 278.08    | 278.08   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 22              | 502.67    | 502.67   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 23              | 89.91     | 89.91    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-073       | APPS-073           | 24              | 977.40    | 977.40   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    |
    | 10017073 | MAIN-073       | APPS-073           | 2240100                  | 4085.19   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017073 | MAIN-073       | APPS-073           | 2240150                  | 1505.69   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017073 | MAIN-073       | APPS-073           | 2240160                  | 480.03    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017073 | MAIN-073       | APPS-073           | 2240170                  | 979.91    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017073 | MAIN-073       | APPS-073           | 2340100                  | 8030.56   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017073 | MAIN-073       | APPS-073           | 2340150                  | 667.60    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017073 | MAIN-073       | APPS-073           | 2340160                  | 977.40    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017073 | MAIN-073       | APPS-073           | 2340170                  | 1616.25   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    |
    | 10017073 | MAIN-073       | APPS-073           | 2240100                  | -459.05   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017073 | MAIN-073       | APPS-073           | 2240150                  | -169.19   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017073 | MAIN-073       | APPS-073           | 2240160                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017073 | MAIN-073       | APPS-073           | 2240170                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017073 | MAIN-073       | APPS-073           | 2340100                  | -902.37   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017073 | MAIN-073       | APPS-073           | 2340150                  | -75.02    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017073 | MAIN-073       | APPS-073           | 2340160                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017073 | MAIN-073       | APPS-073           | 2340170                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 




#    # Run the CDA report 
#    Given there is no CDA report named 'CDA Latest Version A073.csv'
#
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version               | Suffix |
#    | APPS2021              | Latest Version        | A073   |
#
#    Then  a report named 'CDA Latest Version A073.csv' is created
#
#    # Check the contents of the CDA report for Aug-20
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | APPS2021                | 10017073 | 10017073 Co Ltd             |               |                             | APPS-073                 | MAIN-073       | ESFA-073                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 16-18 Trailblazer Additional Payments for Employers  | 16-18 Trailblazer Additional Payments for Employers             | Apprenticeships Carry-In Total Funding                          | 8                 | 2020            | 2020/21       |              | 0            | 979.91       |               |              | Yes                | 0.00           | 0.00             | 979.91                | 0.00           | 979.91          |             | No            |                   |        |                   | 2240170                  | 2240170           | Aug              |
#    | APPS2021                | 10017073 | 10017073 Co Ltd             |               |                             | APPS-073                 | MAIN-073       | ESFA-073                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 16-18 Trailblazer Apprenticeships Learning Support   | 16-18 Trailblazer Apprenticeships Learning Support              | Apprenticeships Carry-In Total Funding                          | 8                 | 2020            | 2020/21       |              | 0            | 1477         |               |              | Yes                | 0.00           | 0.00             | 1477.00               | -165.97        | 1311.03         |             | No            |                   |        |                   | 2240100                  | 2240100           | Aug              |
#    | APPS2021                | 10017073 | 10017073 Co Ltd             |               |                             | APPS-073                 | MAIN-073       | ESFA-073                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 16-18 Trailblazer Apprenticeships Programme Funding  | 16-18 Trailblazer Apprenticeships Programme Funding             | Apprenticeships Carry-In Total Funding                          | 8                 | 2020            | 2020/21       |              | 0            | 971.13       |               |              | Yes                | 0.00           | 0.00             | 971.13                | -109.12        | 862.01          |             | No            |                   |        |                   | 2240100                  | 2240100           | Aug              |
#    | APPS2021                | 10017073 | 10017073 Co Ltd             |               |                             | APPS-073                 | MAIN-073       | ESFA-073                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 19+ Apprenticeships Learner Support                  | 19+ Apprenticeships Learner Support                             | Apprenticeships Carry-In Total Funding                          | 8                 | 2020            | 2020/21       |              | 0            | 239.43       |               |              | Yes                | 0.00           | 0.00             | 239.43                | -26.90         | 212.53          |             | No            |                   |        |                   | 2340100                  | 2340100           | Aug              |
#    | APPS2021                | 10017073 | 10017073 Co Ltd             |               |                             | APPS-073                 | MAIN-073       | ESFA-073                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 19+ Non-Levy Additional Payments for Employers       | 19+ Non-Levy Additional Payments for Employers                  | Apprenticeships Carry-In Total Funding                          | 8                 | 2020            | 2020/21       |              | 0            | 977.4        |               |              | Yes                | 0.00           | 0.00             | 977.40                | 0.00           | 977.40          |             | No            |                   |        |                   | 2340160                  | 2340160           | Aug              |
#    | APPS2021                | 10017073 | 10017073 Co Ltd             |               |                             | APPS-073                 | MAIN-073       | ESFA-073                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 19+ Non-Levy Apprenticeships Learning Support        | 19+ Non-Levy Apprenticeships Learning Support                   | Apprenticeships Carry-In Total Funding                          | 8                 | 2020            | 2020/21       |              | 0            | 101.29       |               |              | Yes                | 0.00           | 0.00             | 101.29                | -11.38         | 89.91           |             | No            |                   |        |                   | 2340150                  | 2340150           | Aug              |
#    | APPS2021                | 10017073 | 10017073 Co Ltd             |               |                             | APPS-073                 | MAIN-073       | ESFA-073                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 19+ Non-Levy Apprenticeships Programme Funding       | 19+ Non-Levy Apprenticeships Programme Funding                  | Apprenticeships Carry-In Total Funding                          | 8                 | 2020            | 2020/21       |              | 0            | 566.31       |               |              | Yes                | 0.00           | 0.00             | 566.31                | -63.64         | 502.67          |             | No            |                   |        |                   | 2340150                  | 2340150           | Aug              |
#    | APPS2021                | 10017073 | 10017073 Co Ltd             |               |                             | APPS-073                 | MAIN-073       | ESFA-073                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 19-23 Apprenticeships Learning Support               | 19-23 Apprenticeships Learning Support                          | Apprenticeships Carry-In Total Funding                          | 8                 | 2020            | 2020/21       |              | 0            | 1405.18      |               |              | Yes                | 0.00           | 0.00             | 1405.18               | -157.90        | 1247.28         |             | No            |                   |        |                   | 2340100                  | 2340100           | Aug              |
#    | APPS2021                | 10017073 | 10017073 Co Ltd             |               |                             | APPS-073                 | MAIN-073       | ESFA-073                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 19-23 Apprenticeships Programme Funding              | 19-23 Apprenticeships Programme Funding                         | Apprenticeships Carry-In Total Funding                          | 8                 | 2020            | 2020/21       |              | 0            | 1422.11      |               |              | Yes                | 0.00           | 0.00             | 1422.11               | -159.80        | 1262.31         |             | No            |                   |        |                   | 2340100                  | 2340100           | Aug              |
#    | APPS2021                | 10017073 | 10017073 Co Ltd             |               |                             | APPS-073                 | MAIN-073       | ESFA-073                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 19-23 Trailblazer Additional Payments for Employers  | 19-23 Trailblazer Additional Payments for Employers             | Apprenticeships Carry-In Total Funding                          | 8                 | 2020            | 2020/21       |              | 0            | 1338.17      |               |              | Yes                | 0.00           | 0.00             | 1338.17               | 0.00           | 1338.17         |             | No            |                   |        |                   | 2340170                  | 2340170           | Aug              |
#    | APPS2021                | 10017073 | 10017073 Co Ltd             |               |                             | APPS-073                 | MAIN-073       | ESFA-073                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 19-23 Trailblazer Apprenticeships Learning Support   | 19-23 Trailblazer Apprenticeships Learning Support              | Apprenticeships Carry-In Total Funding                          | 8                 | 2020            | 2020/21       |              | 0            | 1427.08      |               |              | Yes                | 0.00           | 0.00             | 1427.08               | -160.36        | 1266.72         |             | No            |                   |        |                   | 2340100                  | 2340100           | Aug              |
#    | APPS2021                | 10017073 | 10017073 Co Ltd             |               |                             | APPS-073                 | MAIN-073       | ESFA-073                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 19-23 Trailblazer Apprenticeships Programme Funding  | 19-23 Trailblazer Apprenticeships Programme Funding             | Apprenticeships Carry-In Total Funding                          | 8                 | 2020            | 2020/21       |              | 0            | 886.82       |               |              | Yes                | 0.00           | 0.00             | 886.82                | -99.65         | 787.17          |             | No            |                   |        |                   | 2340100                  | 2340100           | Aug              |
#    | APPS2021                | 10017073 | 10017073 Co Ltd             |               |                             | APPS-073                 | MAIN-073       | ESFA-073                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 24+ Apprenticeships Learning Support                 | 24+ Apprenticeships Learning Support                            | Apprenticeships Carry-In Total Funding                          | 8                 | 2020            | 2020/21       |              | 0            | 896.83       |               |              | Yes                | 0.00           | 0.00             | 896.83                | -100.77        | 796.06          |             | No            |                   |        |                   | 2340100                  | 2340100           | Aug              |
#    | APPS2021                | 10017073 | 10017073 Co Ltd             |               |                             | APPS-073                 | MAIN-073       | ESFA-073                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 24+ Apprenticeships Programme Funding                | 24+ Apprenticeships Programme Funding                           | Apprenticeships Carry-In Total Funding                          | 8                 | 2020            | 2020/21       |              | 0            | 648.8        |               |              | Yes                | 0.00           | 0.00             | 648.80                | -72.90         | 575.90          |             | No            |                   |        |                   | 2340100                  | 2340100           | Aug              |
#    | APPS2021                | 10017073 | 10017073 Co Ltd             |               |                             | APPS-073                 | MAIN-073       | ESFA-073                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 24+ Trailblazer Additional Payments for Employers    | 24+ Trailblazer Additional Payments for Employers               | Apprenticeships Carry-In Total Funding                          | 8                 | 2020            | 2020/21       |              | 0            | 278.08       |               |              | Yes                | 0.00           | 0.00             | 278.08                | 0.00           | 278.08          |             | No            |                   |        |                   | 2340170                  | 2340170           | Aug              |
#    | APPS2021                | 10017073 | 10017073 Co Ltd             |               |                             | APPS-073                 | MAIN-073       | ESFA-073                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 24+ Trailblazer Apprenticeships Learning Support     | 24+ Trailblazer Apprenticeships Learning Support                | Apprenticeships Carry-In Total Funding                          | 8                 | 2020            | 2020/21       |              | 0            | 682.49       |               |              | Yes                | 0.00           | 0.00             | 682.49                | -76.69         | 605.80          |             | No            |                   |        |                   | 2340100                  | 2340100           | Aug              |
#    | APPS2021                | 10017073 | 10017073 Co Ltd             |               |                             | APPS-073                 | MAIN-073       | ESFA-073                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 24+ Trailblazer Apprenticeships Programme Funding    | 24+ Trailblazer Apprenticeships Programme Funding               | Apprenticeships Carry-In Total Funding                          | 8                 | 2020            | 2020/21       |              | 0            | 421.82       |               |              | Yes                | 0.00           | 0.00             | 421.82                | -47.40         | 374.42          |             | No            |                   |        |                   | 2340100                  | 2340100           | Aug              |



    
    # Payment Batch for APPS2021

    # Change the date
    Given the override date is '08/09/2020 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'APPS2021' AccountingPaymentPeriod '202005' CensusEndDate '08/09/2020' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | APPS-073                 | 202008 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | APPS2021                   | 202008               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | APPS2021                   | 202008               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'APPS2021' PaymentPeriod '202005' CensusEndDate '08/09/2020' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A073.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'APPS2021' PaymentPeriod '202005' CensusEndDate '08/09/2020' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription   | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | APPS                   | 2020          | 05             | 08          | ?       | APPS-073      | 4085.19         | RECONCILIATION   | 16-18 Apps              | 2020-09-18 | 2020-08-01   | 2021-07-31 | ?              | 10017073 | 2240100    |
    | APPS                   | 2020          | 05             | 08          | ?       | APPS-073      | 1505.69         | RECONCILIATION   | 16-18NonLevy Apps       | 2020-09-18 | 2020-08-01   | 2021-07-31 | ?              | 10017073 | 2240150    |
    | APPS                   | 2020          | 05             | 08          | ?       | APPS-073      | 480.03          | RECONCILIATION   | 16-18NonLevy AppsEmp    | 2020-09-18 | 2020-08-01   | 2021-07-31 | ?              | 10017073 | 2240160    |
    | APPS                   | 2020          | 05             | 08          | ?       | APPS-073      | 979.91          | RECONCILIATION   | 16-18 Apps Tblz Emp     | 2020-09-18 | 2020-08-01   | 2021-07-31 | ?              | 10017073 | 2240170    |
    | APPS                   | 2020          | 05             | 08          | ?       | APPS-073      | 8030.56         | RECONCILIATION   | 19+ Apps                | 2020-09-18 | 2020-08-01   | 2021-07-31 | ?              | 10017073 | 2340100    |
    | APPS                   | 2020          | 05             | 08          | ?       | APPS-073      | 667.60          | RECONCILIATION   | 19+NonLevy Apps         | 2020-09-18 | 2020-08-01   | 2021-07-31 | ?              | 10017073 | 2340150    |
    | APPS                   | 2020          | 05             | 08          | ?       | APPS-073      | 977.40          | RECONCILIATION   | 19+NonLevy AppsEmp      | 2020-09-18 | 2020-08-01   | 2021-07-31 | ?              | 10017073 | 2340160    |
    | APPS                   | 2020          | 05             | 08          | ?       | APPS-073      | 1616.25         | RECONCILIATION   | 19+ Apps Tblz Emp       | 2020-09-18 | 2020-08-01   | 2021-07-31 | ?              | 10017073 | 2340170    |
    #
    | APPS                   | 2020          | 05             | 08          | ?       | APPS-073      | -459.05         | CAPPING          | 16-18 Apps              | 2020-09-18 | 2020-08-01   | 2021-07-31 | ?              | 10017073 | 2240100    |
    | APPS                   | 2020          | 05             | 08          | ?       | APPS-073      | -169.19         | CAPPING          | 16-18NonLevy Apps       | 2020-09-18 | 2020-08-01   | 2021-07-31 | ?              | 10017073 | 2240150    |
    | APPS                   | 2020          | 05             | 08          | ?       | APPS-073      | -902.37         | CAPPING          | 19+ Apps                | 2020-09-18 | 2020-08-01   | 2021-07-31 | ?              | 10017073 | 2340100    |
    | APPS                   | 2020          | 05             | 08          | ?       | APPS-073      | -75.02          | CAPPING          | 19+NonLevy Apps         | 2020-09-18 | 2020-08-01   | 2021-07-31 | ?              | 10017073 | 2340150    |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'APPS2021' AccountingPaymentPeriod '202005' and CensusEndDate '08/09/2020'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                              |
    | Payment Requests for Funding Stream Period APPS2021 for Payment Period 202005 have been generated as of Census End Date/Time 2020-09-08T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | APPS2021            | 202005        | 2020-09-08T22:00:00Z  | 12               | 16737.00   |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | APPS      | 01/08/2020   | 31/07/2021 | 08/09/2020    | 18/09/2020 | 2020          | 05             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription  | AggregatedValue |
    | ORG0017073  | 10017073       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-073   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240100    | RECONCILIATION | 16-18 Apps             | 4085.19         |
    | ORG0017073  | 10017073       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-073   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240150    | RECONCILIATION | 16-18NonLevy Apps      | 1505.69         |
    | ORG0017073  | 10017073       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-073   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240160    | RECONCILIATION | 16-18NonLevy AppsEmp   | 480.03          |
    | ORG0017073  | 10017073       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-073   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240170    | RECONCILIATION | 16-18 Apps Tblz Emp    | 979.91          |
    | ORG0017073  | 10017073       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-073   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340100    | RECONCILIATION | 19+ Apps               | 8030.56         |
    | ORG0017073  | 10017073       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-073   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340150    | RECONCILIATION | 19+NonLevy Apps        | 667.60          |
    | ORG0017073  | 10017073       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-073   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340160    | RECONCILIATION | 19+NonLevy AppsEmp     | 977.40          |
    | ORG0017073  | 10017073       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-073   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340170    | RECONCILIATION | 19+ Apps Tblz Emp      | 1616.25         |
    #
    | ORG0017073  | 10017073       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-073   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240100    | CAPPING        | 16-18 Apps             | -459.05         |
    | ORG0017073  | 10017073       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-073   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240150    | CAPPING        | 16-18NonLevy Apps      | -169.19         |
    | ORG0017073  | 10017073       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-073   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340100    | CAPPING        | 19+ Apps               | -902.37         |
    | ORG0017073  | 10017073       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-073   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340150    | CAPPING        | 19+NonLevy Apps        | -75.02          |


     # Tidy Up
     And   the override date is reset
     
 