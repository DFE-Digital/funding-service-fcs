Feature: AEBP1920ProviderRelief 30464

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run890
Scenario: A821 Create and approve 1920 and 2021 AEBP contracts with AEB-AS allocs. Bulk amend to add AEB-PRS to 1920. Approve then bulk amend to add AEB-PRS to 2021. Approve then NFA. Check docs along the way
    Given there are no allocations marked as Under Termination for UKPRN '10017821' 
    And   there are no terminated or closed allocations for UKPRN '10017821' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017821' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-821      |
    | AEBA-996      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |  
    | AEBA-821      |
    | AEBA-996      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-AS1920        |
    | AEB-AS2021        |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP-821       | 1                     | 0                        |
    | AEBP-996       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017821'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017821' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017821 Co Ltd' with UKPRN '10017821' and OrgId 'ORG0017821' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017821' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017821 | 117821 | 10017821 Co Ltd | 0              | Active                | Yes           | AA017821      | ?             | 5 Alton House          | Gatehouse Way          | ?                      | ?                      | Alyesbury              | Buckinghamshire        | HP19 8HN  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017821 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract for 1920
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017821 | 10017821 Co Ltd      | ESFA-821             | AEBP-821       | 1                     | 01/08/2019        | 31/07/2020      | 19202.00      |                                       | Procured                                   | 1920   | New          | ORG0017821 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017821 | AEBP-821       | AEBA-821      | AEB-AS            | AEB-AS1920              | AY                      | 01/08/2019          | 31/07/2020        | 27202.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017821 | AEBP-821       | AEBA-821      | 1               | 0                     | 19202.00  | 18872.00  | 8330.00   | 1241.00  | 8584.00  | 1572.00  | 2308.00  | 1083.00  | 1058.00  | 149.00   | 2877.00  | 1113.00  | 2704.00  | 3598.00  | 915.00   | Adult Skills Total Funding                                      | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP-821       | 1                     | 0                        | 2019-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'AEBP-821' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-821'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-821' and actual ContractNumber 'AEBP-821'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-821' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017821 | AEBP-821           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017821 | ESFA-821           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'AEBP-821'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AEBA-821        | 2372010          | Jul-20 | Reconciliation |




    # Change the date
    Given the override date is '01/07/2020'

    # Upsert the provider config values for Sector-based Work Academies for a specific UKPRN and FSP (DocumentsDomain.ContractReferenceConfig) (30680)
    And   the following Sector-based Work Academies profile values exist in config
    | UKPRN    | FSPCode       | Aug20-Mar21 | Apr21-Jul21 |
    | 10017821 | AEB-AS2021    | 875.00      | 425.00      |

    # Create contract for 2021
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017821 | 10017821 Co Ltd      | ESFA-821             | AEBP-996       | 1                     | 01/08/2020        | 31/07/2021      | 15699.00      |                                       | Procured                                   | 2021   | New          | ORG0017996 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017821 | AEBP-996       | AEBA-996      | AEB-AS            | AEB-AS2021              | AY                      | 01/08/2020          | 31/07/2021        | 15699.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017821 | AEBP-996       | AEBA-996      | 1               | 0                     | 15699.00  | 8788.00   | 6911.00   | 196.00   | 616.00   | 339.00   | 1170.00  | 2380.00  | 3433.00  | 275.00   | 379.00   | 1051.00  | 2736.00  | 2365.00  | 759.00   | Adult Skills Total Funding                                      | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP-996       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'AEBP-996' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-996'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-821' and actual ContractNumber 'AEBP-996'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-996' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017821 | AEBP-996           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017821 | ESFA-821           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'AEBP-996'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AEBA-996        | 2372010          | Jul-21 | Reconciliation |




    # Add Provider Relief FSP for 1920 by bulk amendment
    
    # Change the date
    Given the override date is '09/09/2020'
    
    # Bulk file to add AEB-PRS1920
    And   there are no files prefixed '10017821' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1920 18082020090026 v3_A821' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 1920 18082020090026 v3_A821' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1920 18082020090026 v3_A821' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1920 18082020090026 v3_A821' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1920 18082020090026 v3_A821.xlsx' exists in the Datafiles folder and UKPRN '10017821' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017821' for FundingType 'AEB' and period '1920' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017821' for FundingType 'AEB' and period '1920'

    # Check the contents of the Appendices (SoF plus FA for 1920)
   #Then  the file named '10017821_[ContractNo]_v1.pdf' in Sharepoint location 'AEB-1920-Input-Appendices' contains the following lines in order
    Then  the file named '10017821_AEBP-821_v2.pdf' in Sharepoint location 'AEB-1920-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017821 Co Ltd UKPRN: 10017821
    Master Contract Number: ESFA-821
    Allocation
    1 August 2019 to 31 July 2020 Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 Total
    ESFA AEB - Adult Skills AEBA-821 £18,872 £8,330 £27,202
    ESFA AEB - Provider Relief Schemes AEBA-821 £0 £3,627 £3,627
    of which Provider Relief Scheme 1 (April to June 2020) £0 £2,594 £2,594
    of which Provider Relief Scheme 2 (July 2020) £0 £1,033 £1,033
    Total: £30,829
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    ESFA AEB - Adult Skills AEBA-996 £8,788 £6,911 £15,699
    Total: £15,699
    Total Funding for this contract: £46,528

    Funding Agreement ESFA-Funded Adult Education Budget - Provider Relief Schemes
    Provider: 10017821 Co Ltd UKPRN: 10017821
    Master Contract Number: ESFA-821 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: AEBA-821
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Provider Relief Scheme 1 (April to June £2,594 £0 £0 £0 £0 £0 £0 £0 £0 £1,075 £450 £1,069 £0
    2020)
    ESFA AEB - Provider Relief Scheme 2 (July 2020) £1,033 £0 £0 £0 £0 £0 £0 £0 £0 £0 £0 £0 £1,033
    Total Funding £3,627 £0 £0 £0 £0 £0 £0 £0 £0 £1,075 £450 £1,069 £1,033
    Ref (for internal use only):  AEBP-821 v2
    Page 1 of 1 of this Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   #And   Sharepoint file '10017821_[ContractNo]_v2.pdf' in 'AEB-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '<filename2>.pdf'
    And   Sharepoint file '10017821_AEBP-821_v2.pdf' in 'AEB-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A821v2.pdf'




    # Change the date
    Given the override date is '12/09/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'AEBP-821' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-821'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-821' and actual ContractNumber 'AEBP-821'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-821' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017821 | AEBP-821           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017821 | AEBP-821           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017821 | ESFA-821           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables ((5x12) + 3 = 63)
   #And   there are '63' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '63' deliverable period rows in CRM linked to the latest version of contract 'AEBP-821'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AEBA-821        | 2372010          | Jul-21 | Reconciliation |




    # Add Provider Relief FSP for 2021 by bulk amendment
    
    # Change the date
    Given the override date is '22/10/2020'
    
    # Bulk file to add AEB-PRS2021
    And   there are no files prefixed '10017821' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 2021 18082020090413 v3_A821_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 2021 18082020090413 v3_A821_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 2021 18082020090413 v3_A821_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 2021 18082020090413 v3_A821_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 2021 18082020090413 v3_A821_1.xlsx' exists in the Datafiles folder and UKPRN '10017821' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017821' for FundingType 'AEB' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017821' for FundingType 'AEB' and period '2021'

    # Check the contents of the Appendices (SoF plus FA for 2021)
   #Then  the file named '10017821_[ContractNo]_v2.pdf' in Sharepoint location 'AEB-2021-Input-Appendices' contains the following lines in order
    Then  the file named '10017821_AEBP-996_v2.pdf' in Sharepoint location 'AEB-2021-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017821 Co Ltd UKPRN: 10017821
    Master Contract Number: ESFA-821
    Allocation
    1 August 2019 to 31 July 2020 Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 Total
    ESFA AEB - Adult Skills AEBA-821 £18,872 £8,330 £27,202
    ESFA AEB - Provider Relief Schemes AEBA-821 £0 £3,627 £3,627
    of which Provider Relief Scheme 1 (April to June 2020) £0 £2,594 £2,594
    of which Provider Relief Scheme 2 (July 2020) £0 £1,033 £1,033
    Total: £30,829
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    ESFA AEB - Adult Skills AEBA-996 £8,788 £6,911 £15,699
    of which Sector-based Work Academies £875 £425 £1,300
    ESFA AEB - Provider Relief Schemes AEBA-996 £4,517 £0 £4,517
    of which Provider Relief Scheme 2 (August to October 2020) £4,517 £0 £4,517
    Total: £20,216
    Total Funding for this contract: £51,045
    
    Funding Agreement ESFA-Funded Adult Education Budget - Provider Relief Schemes
    Provider: 10017821 Co Ltd UKPRN: 10017821
    Master Contract Number: ESFA-821 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: AEBA-996
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - Provider Relief Scheme 2 (August to £4,517 £1,025 £1,488 £2,004 £0 £0 £0 £0 £0 £0 £0 £0 £0
    October 2020)
    Total Funding £4,517 £1,025 £1,488 £2,004 £0 £0 £0 £0 £0 £0 £0 £0 £0
    Ref (for internal use only):  AEBP-996 v2
    Page 1 of 1 of this Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017821_AEBP-996_v2.pdf' in 'AEB-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A996v2.pdf'



    # Change the date
    Given the override date is '23/10/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'AEBP-821' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-996'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-821' and actual ContractNumber 'AEBP-996'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-996' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017821 | AEBP-996           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017821 | AEBP-996           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017821 | ESFA-821           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables ((5x12) + 3 = 63)
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'AEBP-996'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AEBA-996        | 2372010          | Jul-21 | Reconciliation |




    # Execute a NON-FINANCIAL amendment on 2021 AEBP and check docs

    # Change the date
    Given the override date is '26/10/2020'

    # Issue a non-financial NOTIFICATION amendment on v2 to create v3
   #When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'AEBP-996' for a non-financial VARIATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'AEBP-996' for a non-financial NOTIFICATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017821 | AEBP-996           | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Notification  |
    | 10017821 | AEBP-996           | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017821 | AEBP-996           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017821 | ESFA-821           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |


    # Retrieve parameters
   #And  I retrieve the latest EFA contract details from CRM for provider '10017821' for FundingType 'AEB' and period '2021' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017821' for FundingType 'AEB' and period '2021'

    # Check the contents of the Appendices 
    Then  the file named '10017821_AEBP-996_v3.pdf' in Sharepoint location 'AEB-2021-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017821 Co Ltd UKPRN: 10017821
    Master Contract Number: ESFA-821
    Allocation
    1 August 2019 to 31 July 2020 Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 Total
    ESFA AEB - Adult Skills AEBA-821 £18,872 £8,330 £27,202
    ESFA AEB - Provider Relief Schemes AEBA-821 £0 £3,627 £3,627
    of which Provider Relief Scheme 1 (April to June 2020) £0 £2,594 £2,594
    of which Provider Relief Scheme 2 (July 2020) £0 £1,033 £1,033
    Total: £30,829
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    ESFA AEB - Adult Skills AEBA-996 £8,788 £6,911 £15,699
    of which Sector-based Work Academies £875 £425 £1,300
    ESFA AEB - Provider Relief Schemes AEBA-996 £4,517 £0 £4,517
    of which Provider Relief Scheme 2 (August to October 2020) £4,517 £0 £4,517
    Total: £20,216
    Total Funding for this contract: £51,045
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017821_AEBP-996_v3.pdf' in 'AEB-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A996v3.pdf'


    # Tidy Up
    Given the override date is reset

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017821'

@AcceptanceTest @Manual @ok
Scenario: A053 Create a 2021 AEBP contract with just an AEB-PRS2021 alloc. Check docs. (To help with manual checking)
    Given there are no allocations marked as Under Termination for UKPRN '10017053' 
    And   there are no terminated or closed allocations for UKPRN '10017053' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017053' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017053' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEAL-053      |
    | AEBR-053      |
    | AERS-053      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEAL-053      |
    | AEBR-053      |
    | AERS-053      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-PRS2021       |
    | AEB-19TRN2021     |
    | AEB-ASLS2021      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP-053       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017053'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017053' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017053 Co Ltd' with UKPRN '10017053' and OrgId 'ORG0017053' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017053' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017053 | 117053 | 10017053 Co Ltd | 0              | Provider Under Change | Yes           | AA017053      | ?             | 1 Wellington Square    | Ayr                    | ?                      | ?                      | ?                      | ?                      | KA7 1EN   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017053 |




    # Bulk file
    And   there are no files prefixed '10017053' in the Sharepoint 'AEB-2021-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 2021 24082020155417 v3_A053' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 2021 24082020155417 v3_A053' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 2021 24082020155417 v3_A053' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 2021 24082020155417 v3_A053' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 2021 24082020155417 v3_A053.xlsx' exists in the Datafiles folder and UKPRN '10017053' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017053' for FundingType 'AEB' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017053' for FundingType 'AEB' and period '2021'

    # Check the contents of the Appendices
    Then  the file named '10017053_[ContractNo]_v1.pdf' in Sharepoint location 'AEB-2021-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017053 Co Ltd UKPRN: 10017053
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AEBR] £38,290 £19,522 £57,812
    ESFA AEB - Adult Skills Learner Support [AllocRef_AEAL] £30,618 £15,686 £46,304
    ESFA AEB - Provider Relief Schemes £29,623 £15,995 £45,618
    of which Provider Relief Scheme 2 (August to October 2020) £29,623 £15,995 £45,618
    Total: £149,734
    Total Funding for this contract: £149,734
    
    Funding Agreement ESFA-Funded Adult Education Budget - 19 to 24 Traineeships
    Provider: 10017053 Co Ltd UKPRN: 10017053
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_AEBR]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - 19 to 24 Traineeships £57,812 £7,149 £3,020 £5,345 £4,209 £1,778 £6,959 £7,319 £2,511 £6,874 £7,574 £1,746 £3,328
    Total Funding £57,812 £7,149 £3,020 £5,345 £4,209 £1,778 £6,959 £7,319 £2,511 £6,874 £7,574 £1,746 £3,328
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    
    Funding Agreement ESFA-Funded Adult Education Budget - Adult Skills Learner Support
    Provider: 10017053 Co Ltd UKPRN: 10017053
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_AEAL]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - Adult Skills Learner Support £46,304 £3,927 £5,986 £4,033 £1,942 £6,103 £1,570 £1,379 £5,678 £2,844 £5,509 £3,353 £3,980
    Total Funding £46,304 £3,927 £5,986 £4,033 £1,942 £6,103 £1,570 £1,379 £5,678 £2,844 £5,509 £3,353 £3,980
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    
    Funding Agreement ESFA-Funded Adult Education Budget - Provider Relief Schemes
    Provider: 10017053 Co Ltd UKPRN: 10017053
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref:
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - Provider Relief Scheme 2 (August to £45,618 £1,232 £4,705 £5,469 £3,176 £2,104 £3,208 £7,847 £1,882 £1,764 £4,227 £4,790 £5,214
    October 2020)
    Total Funding £45,618 £1,232 £4,705 £5,469 £3,176 £2,104 £3,208 £7,847 £1,882 £1,764 £4,227 £4,790 £5,214
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement 
    """

    # Tidy Up
    And   the override date is reset
       
@AcceptanceTest @Withdrawn20220309
Scenario: A058 Create and approve 2021 AEBP contract with AEB-AS alloc. Bulk amend to add short AEB-PRS alloc then check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017058' 
    And   there are no terminated or closed allocations for UKPRN '10017058' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017058' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-058      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |  
    | AEBA-058      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-AS2021        |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP-058       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017058'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017058' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017058 Co Ltd' with UKPRN '10017058' and OrgId 'ORG0017058' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017058' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017058 | 117058 | 10017058 Co Ltd | 0              | Active                | Yes           | AA017058      | ?             | 5 Alton House          | Gatehouse Way          | ?                      | ?                      | Alyesbury              | Buckinghamshire        | HP19 8HN  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017058 |




    # Change the date
    Given the override date is '01/07/2020'

    # Upsert the provider config values for Sector-based Work Academies for a specific UKPRN and FSP (DocumentsDomain.ContractReferenceConfig) (30680)
    And   the following Sector-based Work Academies profile values exist in config
    | UKPRN    | FSPCode       | Aug20-Mar21 | Apr21-Jul21 |
    | 10017058 | AEB-AS2021    | 875.00      | 425.00      |

    # Create contract for 2021
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017058 | 10017058 Co Ltd      | ESFA-058             | AEBP-058       | 1                     | 01/08/2020        | 31/07/2021      | 15699.00      |                                       | Procured                                   | 2021   | New          | ORG0017058 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017058 | AEBP-058       | AEBA-058      | AEB-AS            | AEB-AS2021              | AY                      | 01/08/2020          | 31/07/2021        | 15699.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017058 | AEBP-058       | AEBA-058      | 1               | 0                     | 15699.00  | 8788.00   | 6911.00   | 196.00   | 616.00   | 339.00   | 1170.00  | 2380.00  | 3433.00  | 275.00   | 379.00   | 1051.00  | 2736.00  | 2365.00  | 759.00   | Adult Skills Total Funding                                      | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP-058       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'AEBP-058' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-058'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-058' and actual ContractNumber 'AEBP-058'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-058' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017058 | AEBP-058           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017058 | ESFA-058           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'AEBP-058'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AEBA-058        | 2372010          | Jul-21 | Reconciliation |




    # Add Provider Relief FSP by bulk amendment
    
    # Change the date
    Given the override date is '22/10/2020'
    
    # Bulk file to add AEB-PRS2021
    And   there are no files prefixed '10017058' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 2021 09092020115818 v3_A058' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 2021 09092020115818 v3_A058' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 2021 09092020115818 v3_A058' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 2021 09092020115818 v3_A058' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 2021 09092020115818 v3_A058.xlsx' exists in the Datafiles folder and UKPRN '10017058' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017058' for FundingType 'AEB' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017058' for FundingType 'AEB' and period '2021'

    # Check the contents of the Appendices (SoF plus FA for PRS. No FA for AEB-AS2021 because it has not changed)
   #Then  the file named '10017058_[ContractNo]_v2.pdf' in Sharepoint location 'AEB-2021-Input-Appendices' contains the following lines in order
    Then  the file named '10017058_AEBP-058_v2.pdf' in Sharepoint location 'AEB-2021-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017058 Co Ltd UKPRN: 10017058
    Master Contract Number: ESFA-058
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    ESFA AEB - Adult Skills AEBA-058 £8,788 £6,911 £15,699
    of which Sector-based Work Academies £875 £425 £1,300
    ESFA AEB - Provider Relief Schemes AEBA-058 £5,453 £0 £5,453
    of which Provider Relief Scheme 2 (August to October 2020) £5,453 £0 £5,453
    Total: £21,152
    Total Funding for this contract: £21,152

    Funding Agreement ESFA-Funded Adult Education Budget - Provider Relief Schemes
    Provider: 10017058 Co Ltd UKPRN: 10017058
    Master Contract Number: ESFA-058 Start Date: 01/09/2020 End Date: 31/10/2020
    Contract Ref: AEBA-058
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - Provider Relief Scheme 2 (August to £5,453 £3,602 £1,851
    October 2020)
    Total Funding £5,453 £3,602 £1,851
    Ref (for internal use only):  AEBP-058 v2
    Page 1 of 1 of this Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017058_AEBP-058_v2.pdf' in 'AEB-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A058v2.pdf'


    # Tidy Up
    Given the override date is reset

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017058'

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run890
Scenario: A887 Create and approve a 2018 NLAP contract with 16-18 and Adult allocs. Bulk amend twice. Add AS2019 then PRS2020 allocs. Approve then NFA. Check docs along the way
    Given there are no allocations marked as Under Termination for UKPRN '10017887' 
    And   there are no terminated or closed allocations for UKPRN '10017887' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017887' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017887' 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017887' 

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017887'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ANLP-887      |
    | YNLP-887      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ANLP-887      |
    | YNLP-887      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | 16-18NLAP2018  |
    | ANLAP2018      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | NLAP-887       | 1                     | 0                        |


     

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017887' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017887 Co Ltd' with UKPRN '10017887' and OrgId 'ORG0017887' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017887' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017887 | 117887 | 10017887 Co Ltd | 0              | Active                | Yes           | AA017887      | ?             | 20 Birklands Park      | ?                      | ?                      | ?                      | St.Albans              | Hertfordshire          | AL1 1TS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017887 |




    # Change the date
    Given the override date is '01/12/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017887 | 10017887 Co Ltd      | ESFA-887             | NLAP-887       | 1                     | 01/01/2018        | 31/03/2021      | 153883.00     |                                       | Contract for Services                      | 2018   | New          | ORG0017887 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017887 | NLAP-887       | ANLP-887      | ANLAP             | ANLAP2018               | NONLEVY                 | 01/01/2018          | 31/03/2021        | 78769.00        |                                         |            |                                                             | New          |             |
    | 10017887 | NLAP-887       | YNLP-887      | 16-18NLAP         | 16-18NLAP2018           | NONLEVY                 | 01/01/2018          | 31/03/2021        | 75114.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | DeliverableDescription                       | CRMIntent    | DeliveryOrg |
    | 10017887 | NLAP-887       | ANLP-887      | 1               | 0                     | 78769.00  | 1360.00  | 2096.00  | 870.00   | 846.00   | 3638.00  | 2664.00  | 900.00   | 2491.00  | 3386.00  | 703.00   | 3084.00  | 624.00   | 3321.00  | 3613.00  | 1755.00  | 910.00   | 727.00   | 292.00   | 1597.00  | 1384.00  | 3005.00  | 861.00   | 2610.00  | 3030.00  | 2753.00  | 3583.00  | 110.00   | 1162.00  | 2689.00  | 2793.00  | 3465.00  | 466.00   | 95.00    | 2190.00  | 3306.00  | 940.00   | 2373.00  | 3741.00  | 3336.00  | Total Adult Non-Levy Apprenticeships Funding | New          |             | 
    | 10017887 | NLAP-887       | YNLP-887      | 1               | 0                     | 75114.00  | 3156.00  | 1709.00  | 2351.00  | 2390.00  | 2272.00  | 2628.00  | 1560.00  | 1061.00  | 1575.00  | 3734.00  | 958.00   | 903.00   | 2050.00  | 2311.00  | 2509.00  | 1916.00  | 3695.00  | 1076.00  | 547.00   | 3117.00  | 1827.00  | 1995.00  | 3458.00  | 1788.00  | 2114.00  | 3102.00  | 137.00   | 1630.00  | 2588.00  | 1679.00  | 706.00   | 2643.00  | 532.00   | 444.00   | 2445.00  | 1125.00  | 2366.00  | 1363.00  | 1654.00  | Total 16-18 Non-Levy Apprenticeships Funding | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | NLAP-887       | 1                     | 0                        | 2017-12-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'NLAP-887' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NLAP-887'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-887' and actual ContractNumber 'NLAP-887'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-887' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017887 | NLAP-887           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2021      | ?             |
    | 10017887 | ESFA-887           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '390' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '390' deliverable period rows in CRM linked to the latest version of contract 'NLAP-887'

#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | YNLP-887        | 2240151          | Mar-21 | Reconciliation |
#    | ANLP-887        | 2340151          | Mar-21 | Reconciliation |
       



    # Add both 'Employer on App Service' allocs by bulk import amendment

    # Change the date
    Given the override date is '23/07/2019'

    # Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   the following NLAP NewStarts profile values exist in config
    | UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
    | 10017887 | 6550.00            | 11625.00           | 4325.00                              | 5415.00                              |


    # Bulk file
    And   there are no files prefixed '10017887' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 19082020100711 v3_A887a' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 19082020100711 v3_A887a' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 19082020100711 v3_A887a' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 19082020100711 v3_A887a' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 19082020100711 v3_A887a.xlsx' exists in the Datafiles folder and UKPRN '10017887' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017887' for FundingType 'NLA' and period '2018' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017887' for FundingType 'NLA' and period '2018'

    # Check the contents of the SoF (Note: the FA is not generated for Employer on App Services allocs. See 27004)
   #Then  the file named '10017887_[ContractNo]_v2.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    Then  the file named '10017887_NLAP-887_v2.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Number: ESFA-887
    Allocation
    Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Apr 22 to Mar 23 Total
    16-18 Non-Levy Apprenticeships YNLP-887 £7,216 £23,951 £24,772 £19,175 £75,114
    of which New Starts £6,550 £6,550
    16-18 Non-Levy Apprenticeships £29,031 £40,460 £69,491
    (Employer on Apprenticeship Service)
    Adult Non-Levy Apprenticeships ANLP-887 £4,326 £27,025 £20,862 £26,556 £78,769
    of which New Starts £11,625 £11,625
    Adult Non-Levy Apprenticeships £34,614 £33,430 £68,044
    (Employer on Apprenticeship Service)
    Total: £291,418
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    Then  Sharepoint file '10017887_NLAP-887_v2.pdf' in 'NLA-2018-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A887v2.pdf'




    # Change the date
    Given the override date is '24/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NLAP-887'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-887' and actual ContractNumber 'NLAP-887'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-887' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017887 | NLAP-887           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2021      | Variation     |
    | 10017887 | NLAP-887           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/01/2018        | 31/03/2021      | ?             |
    | 10017887 | ESFA-887           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables (5x39)+(5x39)+(2x12)+(2x12)=438 
    And   there are '430' deliverable period rows in CRM linked to the latest version of contract 'NLAP-887'

#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | YNLP-887        | 2240151          | Mar-21 | Reconciliation |
#    | ANLP-887        | 2340151          | Mar-21 | Reconciliation |




    # Add both PRS allocs by bulk import amendment
    
    # Change the date
    Given the override date is '26/09/2020'

    # Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   the following NLAP NewStarts profile values exist in config
    | UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
    | 10017887 | 6565.00            | 11415.00           | 4285.00                              | 5602.00                              |


    # Bulk file
    And   there are no files prefixed '10017887' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 19082020100110 v3_A887' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 19082020100110 v3_A887' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 19082020100110 v3_A887' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 19082020100110 v3_A887' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 19082020100110 v3_A887.xlsx' exists in the Datafiles folder and UKPRN '10017887' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017887' for FundingType 'NLA' and period '2018'

    # Check the contents of the SoF and FAs
    #  (Note: the FA is not generated for Employer on App Services allocs. See 27004)
   #Then  the file named '10017887_[ContractNo]_v3.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    Then  the file named '10017887_NLAP-887_v3.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Number: ESFA-887
    Allocation
    Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Apr 22 to Mar 23 Total
    16-18 Non-Levy Apprenticeships YNLP-887 £7,216 £23,951 £24,772 £19,175 £75,114
    of which New Starts £6,565 £6,565
    16-18 Non-Levy Apprenticeships £29,031 £40,460 £69,491
    (Employer on Apprenticeship Service)
    16-18 Non-Levy Provider Relief Schemes YNLP-887 £12,455 £12,455
    of which Provider Relief Scheme 1 £6,036 £6,036
    (April to June 2020)
    of which Provider Relief Scheme 2 £6,419 £6,419
    (July to October 2020)
    Adult Non-Levy Apprenticeships ANLP-887 £4,326 £27,025 £20,862 £26,556 £78,769
    of which New Starts £11,415 £11,415
    Adult Non-Levy Apprenticeships £34,614 £33,430 £68,044
    (Employer on Apprenticeship Service)
    Adult Non-Levy Provider Relief Schemes ANLP-887 £7,605 £7,605
    of which Provider Relief Scheme 1 £4,020 £4,020
    (April to June 2020)
    of which Provider Relief Scheme 2 £3,585 £3,585
    (July to October 2020)
    Total: £311,478
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: YNLP-887
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    16-18 Non-Levy Apprenticeships £75,114 £3,156 £1,709 £2,351
    Total Funding £75,114 £3,156 £1,709 £2,351
    Ref (for internal use only):  NLAP-887 v3
    Page 1 of 4 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: YNLP-887
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    16-18 Non-Levy Apprenticeships £2,390 £2,272 £2,628 £1,560 £1,061 £1,575 £3,734 £958 £903 £2,050 £2,311 £2,509
    Total Funding £2,390 £2,272 £2,628 £1,560 £1,061 £1,575 £3,734 £958 £903 £2,050 £2,311 £2,509
    Ref (for internal use only):  NLAP-887 v3
    Page 2 of 4 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: YNLP-887
    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    16-18 Non-Levy Apprenticeships £1,916 £3,695 £1,076 £547 £3,117 £1,827 £1,995 £3,458 £1,788 £2,114 £3,102 £137
    Total Funding £1,916 £3,695 £1,076 £547 £3,117 £1,827 £1,995 £3,458 £1,788 £2,114 £3,102 £137
    Ref (for internal use only):  NLAP-887 v3
    Page 3 of 4 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: YNLP-887
    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    16-18 Non-Levy Apprenticeships £1,630 £2,588 £1,679 £706 £2,643 £532 £444 £2,445 £1,125 £2,366 £1,363 £1,654
    Total Funding £1,630 £2,588 £1,679 £706 £2,643 £532 £444 £2,445 £1,125 £2,366 £1,363 £1,654
    Ref (for internal use only):  NLAP-887 v3
    Page 4 of 4 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships - Provider Relief Schemes
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/04/2020 End Date: 31/03/2021
    Contract Ref: YNLP-887
    Cash (£) Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    16-18 Non-Levy Apprenticeships - Provider Relief £6,036 £2,368 £1,710 £1,958 £0 £0 £0 £0 £0 £0 £0 £0 £0
    Scheme 1 (April to June 2020)
    16-18 Non-Levy Apprenticeships - Provider Relief £6,419 £0 £0 £0 £975 £1,090 £1,755 £2,599 £0 £0 £0 £0 £0
    Scheme 2 (July to October 2020)
    Total Funding £12,455 £2,368 £1,710 £1,958 £975 £1,090 £1,755 £2,599 £0 £0 £0 £0 £0
    Ref (for internal use only):  NLAP-887 v3
    Page 1 of 1 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: ANLP-887
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    Adult Non-Levy Apprenticeships £78,769 £1,360 £2,096 £870
    Total Funding £78,769 £1,360 £2,096 £870
    Ref (for internal use only):  NLAP-887 v3
    Page 1 of 4 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: ANLP-887
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    Adult Non-Levy Apprenticeships £846 £3,638 £2,664 £900 £2,491 £3,386 £703 £3,084 £624 £3,321 £3,613 £1,755
    Total Funding £846 £3,638 £2,664 £900 £2,491 £3,386 £703 £3,084 £624 £3,321 £3,613 £1,755
    Ref (for internal use only):  NLAP-887 v3
    Page 2 of 4 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: ANLP-887
    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    Adult Non-Levy Apprenticeships £910 £727 £292 £1,597 £1,384 £3,005 £861 £2,610 £3,030 £2,753 £3,583 £110
    Total Funding £910 £727 £292 £1,597 £1,384 £3,005 £861 £2,610 £3,030 £2,753 £3,583 £110
    Ref (for internal use only):  NLAP-887 v3
    Page 3 of 4 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: ANLP-887
    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    Adult Non-Levy Apprenticeships £1,162 £2,689 £2,793 £3,465 £466 £95 £2,190 £3,306 £940 £2,373 £3,741 £3,336
    Total Funding £1,162 £2,689 £2,793 £3,465 £466 £95 £2,190 £3,306 £940 £2,373 £3,741 £3,336
    Ref (for internal use only):  NLAP-887 v3
    Page 4 of 4 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships - Provider Relief Schemes
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/04/2020 End Date: 31/03/2021
    Contract Ref: ANLP-887
    Cash (£) Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    Adult Non-Levy Apprenticeships - Provider Relief Scheme £4,020 £1,484 £1,027 £1,509 £0 £0 £0 £0 £0 £0 £0 £0 £0
    1 (April to June 2020)
    Adult Non-Levy Apprenticeships - Provider Relief Scheme £3,585 £0 £0 £0 £1,158 £205 £1,072 £1,150 £0 £0 £0 £0 £0
    2 (July to October 2020)
    Total Funding £7,605 £1,484 £1,027 £1,509 £1,158 £205 £1,072 £1,150 £0 £0 £0 £0 £0
    Ref (for internal use only):  NLAP-887 v3
    Page 1 of 1 of this Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017887_NLAP-887_v3.pdf' in 'NLA-2018-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A887v3.pdf'



    # Change the date
    Given the override date is '28/09/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'NLAP-887' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NLAP-887'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '3' actual MasterContractNumber 'ESFA-887' and actual ContractNumber 'NLAP-887'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-887' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017887 | NLAP-887           | 3                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2021      | Variation     |
    | 10017887 | NLAP-887           | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/01/2018        | 31/03/2021      | Variation     |
    | 10017887 | NLAP-887           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/01/2018        | 31/03/2021      | ?             |
    | 10017887 | ESFA-887           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables (5x39)+(5x39)+(2x12)+(2x12)=438 
    And   there are '478' deliverable period rows in CRM linked to the latest version of contract 'NLAP-887'

#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | YNLP-887        | 2240151          | Mar-21 | Reconciliation |
#    | ANLP-887        | 2340151          | Mar-21 | Reconciliation |




    # Execute a NON-FINANCIAL amendment and check docs

    # Change the date
    Given the override date is '16/10/2020'

    # Issue a non-financial VARIATION amendment on v3 to create v4
    When  a request is raised by advisor 'FCS2 Test' against version '3' subversion '0' of contract 'NLAP-887' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017887 | NLAP-887           | 4                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/01/2018        | 31/03/2021      | Variation     |
    | 10017887 | NLAP-887           | 3                     | 0                        | Approved         | Approved                  | False         | True                | 01/01/2018        | 31/03/2021      | Variation     |
    | 10017887 | NLAP-887           | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/01/2018        | 31/03/2021      | Variation     |
    | 10017887 | NLAP-887           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/01/2018        | 31/03/2021      | ?             |
    | 10017887 | ESFA-887           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2021      | ?             |



    # Retrieve parameters
   #And  I retrieve the latest EFA contract details from CRM for provider '10017887' for FundingType 'NLA' and period '2018' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017887' for FundingType 'NLA' and period '2018'

    # Check the contents of the SoF and FAs
    #  (Note: the FA is not generated for Employer on App Services allocs. See 27004)
   #Then  the file named '10017887_[ContractNo]_v4.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    Then  the file named '10017887_NLAP-887_v4.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Number: ESFA-887
    Allocation
    Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Apr 22 to Mar 23 Total
    16-18 Non-Levy Apprenticeships YNLP-887 £7,216 £23,951 £24,772 £19,175 £75,114
    of which New Starts £6,565 £6,565
    16-18 Non-Levy Apprenticeships £29,031 £40,460 £69,491
    (Employer on Apprenticeship Service)
    16-18 Non-Levy Provider Relief Schemes YNLP-887 £12,455 £12,455
    of which Provider Relief Scheme 1 £6,036 £6,036
    (April to June 2020)
    of which Provider Relief Scheme 2 £6,419 £6,419
    (July to October 2020)
    Adult Non-Levy Apprenticeships ANLP-887 £4,326 £27,025 £20,862 £26,556 £78,769
    of which New Starts £11,415 £11,415
    Adult Non-Levy Apprenticeships £34,614 £33,430 £68,044
    (Employer on Apprenticeship Service)
    Adult Non-Levy Provider Relief Schemes ANLP-887 £7,605 £7,605
    of which Provider Relief Scheme 1 £4,020 £4,020
    (April to June 2020)
    of which Provider Relief Scheme 2 £3,585 £3,585
    (July to October 2020)
    Total: £311,478
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: YNLP-887
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    16-18 Non-Levy Apprenticeships £75,114 £3,156 £1,709 £2,351
    Total Funding £75,114 £3,156 £1,709 £2,351
    Ref (for internal use only):  NLAP-887 v4
    Page 1 of 4 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: YNLP-887
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    16-18 Non-Levy Apprenticeships £2,390 £2,272 £2,628 £1,560 £1,061 £1,575 £3,734 £958 £903 £2,050 £2,311 £2,509
    Total Funding £2,390 £2,272 £2,628 £1,560 £1,061 £1,575 £3,734 £958 £903 £2,050 £2,311 £2,509
    Ref (for internal use only):  NLAP-887 v4
    Page 2 of 4 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: YNLP-887
    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    16-18 Non-Levy Apprenticeships £1,916 £3,695 £1,076 £547 £3,117 £1,827 £1,995 £3,458 £1,788 £2,114 £3,102 £137
    Total Funding £1,916 £3,695 £1,076 £547 £3,117 £1,827 £1,995 £3,458 £1,788 £2,114 £3,102 £137
    Ref (for internal use only):  NLAP-887 v4
    Page 3 of 4 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: YNLP-887
    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    16-18 Non-Levy Apprenticeships £1,630 £2,588 £1,679 £706 £2,643 £532 £444 £2,445 £1,125 £2,366 £1,363 £1,654
    Total Funding £1,630 £2,588 £1,679 £706 £2,643 £532 £444 £2,445 £1,125 £2,366 £1,363 £1,654
    Ref (for internal use only):  NLAP-887 v4
    Page 4 of 4 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships - Provider Relief Schemes
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/04/2020 End Date: 31/03/2021
    Contract Ref: YNLP-887
    Cash (£) Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    16-18 Non-Levy Apprenticeships - Provider Relief £6,036 £2,368 £1,710 £1,958 £0 £0 £0 £0 £0 £0 £0 £0 £0
    Scheme 1 (April to June 2020)
    16-18 Non-Levy Apprenticeships - Provider Relief £6,419 £0 £0 £0 £975 £1,090 £1,755 £2,599 £0 £0 £0 £0 £0
    Scheme 2 (July to October 2020)
    Total Funding £12,455 £2,368 £1,710 £1,958 £975 £1,090 £1,755 £2,599 £0 £0 £0 £0 £0
    Ref (for internal use only):  NLAP-887 v4
    Page 1 of 1 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: ANLP-887
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    Adult Non-Levy Apprenticeships £78,769 £1,360 £2,096 £870
    Total Funding £78,769 £1,360 £2,096 £870
    Ref (for internal use only):  NLAP-887 v4
    Page 1 of 4 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: ANLP-887
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    Adult Non-Levy Apprenticeships £846 £3,638 £2,664 £900 £2,491 £3,386 £703 £3,084 £624 £3,321 £3,613 £1,755
    Total Funding £846 £3,638 £2,664 £900 £2,491 £3,386 £703 £3,084 £624 £3,321 £3,613 £1,755
    Ref (for internal use only):  NLAP-887 v4
    Page 2 of 4 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: ANLP-887
    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    Adult Non-Levy Apprenticeships £910 £727 £292 £1,597 £1,384 £3,005 £861 £2,610 £3,030 £2,753 £3,583 £110
    Total Funding £910 £727 £292 £1,597 £1,384 £3,005 £861 £2,610 £3,030 £2,753 £3,583 £110
    Ref (for internal use only):  NLAP-887 v4
    Page 3 of 4 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: ANLP-887
    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    Adult Non-Levy Apprenticeships £1,162 £2,689 £2,793 £3,465 £466 £95 £2,190 £3,306 £940 £2,373 £3,741 £3,336
    Total Funding £1,162 £2,689 £2,793 £3,465 £466 £95 £2,190 £3,306 £940 £2,373 £3,741 £3,336
    Ref (for internal use only):  NLAP-887 v4
    Page 4 of 4 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships - Provider Relief Schemes
    Provider: 10017887 Co Ltd UKPRN: 10017887
    Master Contract Ref: ESFA-887 Start Date: 01/04/2020 End Date: 31/03/2021
    Contract Ref: ANLP-887
    Cash (£) Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    Adult Non-Levy Apprenticeships - Provider Relief Scheme £4,020 £1,484 £1,027 £1,509 £0 £0 £0 £0 £0 £0 £0 £0 £0
    1 (April to June 2020)
    Adult Non-Levy Apprenticeships - Provider Relief Scheme £3,585 £0 £0 £0 £1,158 £205 £1,072 £1,150 £0 £0 £0 £0 £0
    2 (July to October 2020)
    Total Funding £7,605 £1,484 £1,027 £1,509 £1,158 £205 £1,072 £1,150 £0 £0 £0 £0 £0
    Ref (for internal use only):  NLAP-887 v4
    Page 1 of 1 of this Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017887_NLAP-887_v4.pdf' in 'NLA-2018-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A887v4.pdf'


    # Tidy Up
    And   the override date is reset
    
    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017887'
  
@AcceptanceTest @Manual @ok
Scenario: A052 Create a 2018 NLAP contract with NLAP2018 and PRS2020 allocs only. Check docs. (To help with manual checking)
    Given there are no allocations marked as Under Termination for UKPRN '10017052' 
    And   there are no terminated or closed allocations for UKPRN '10017052' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017052' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017052' 

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017052'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ANLR-052      |
    | YNLR-052      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ANLR-052      |
    | YNLR-052      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18NLAP-PRS2020 |
    | ANLAP-PRS2020     |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | NLAP-052       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017052'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017052' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017052 Co Ltd' with UKPRN '10017052' and OrgId 'ORG0017052' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017052' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017052 | 117052 | 10017052 Co Ltd | 0              | Locked Restructure    | Yes           | AA017052      | ?             | 27 Linford Wood        | Linford Forum          | Rockingham Drive       | Milton Keynes          | ?                      | ?                      | MK14 6LY  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017052 |



    # Change the date
    Given the override date is '01/09/2020'

    # Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   the following NLAP NewStarts profile values exist in config
    | UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
    | 10017052 | 550.00             | 2625.00            | 1325.00                              | 3015.00                              |



    # Bulk file to create NLAP contract with NLAP2018 and PRS2020 allocs
    And   there are no files prefixed '10017052' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 24082020143300 v3_A052' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 24082020143300 v3_A052' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 24082020143300 v3_A052' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 24082020143300 v3_A052' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 24082020143300 v3_A052.xlsx' exists in the Datafiles folder and UKPRN '10017052' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017052' for FundingType 'NLA' and period '2018' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017052' for FundingType 'NLA' and period '2018'

    # Check the contents of the Appendices
    Then  the file named '10017052_[ContractNo]_v1.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017052 Co Ltd UKPRN: 10017052
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Total
    16-18 Non-Levy Apprenticeships [AllocRef_YNLP] £0 £0 £0 £45,742 £45,742
    of which New Starts £550 £550
    16-18 Non-Levy Provider Relief Schemes [AllocRef_YNLP] £0 £0 £0 £28,192 £28,192
    of which Provider Relief Scheme 1 £0 £0 £0 £12,738 £12,738
    (April to June 2020)
    of which Provider Relief Scheme 2 £0 £0 £0 £15,454 £15,454
    (July to October 2020)
    Adult Non-Levy Apprenticeships [AllocRef_ANLP] £0 £0 £0 £49,389 £49,389
    of which New Starts £2,625 £2,625
    Adult Non-Levy Provider Relief Schemes [AllocRef_ANLP] £0 £0 £0 £26,933 £26,933
    of which Provider Relief Scheme 1 £0 £0 £0 £11,240 £11,240
    (April to June 2020)
    of which Provider Relief Scheme 2 £0 £0 £0 £15,693 £15,693
    (July to October 2020)
    Total: £150,256
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017052 Co Ltd UKPRN: 10017052
    Master Contract Ref: [MasterContractNo] Start Date: 01/04/2020 End Date: 31/03/2021
    Contract Ref: [AllocRef_YNLP]
    Cash (£) Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    16-18 Non-Levy Apprenticeships £45,742
    Total Funding £45,742
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 2 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017052 Co Ltd UKPRN: 10017052
    Master Contract Ref: [MasterContractNo] Start Date: 01/04/2020 End Date: 31/03/2021
    Contract Ref: [AllocRef_YNLP]
    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    16-18 Non-Levy Apprenticeships £1,839 £2,539 £4,662 £4,132 £1,499 £3,558 £7,444 £7,465 £3,675 £262 £2,184 £6,483
    Total Funding £1,839 £2,539 £4,662 £4,132 £1,499 £3,558 £7,444 £7,465 £3,675 £262 £2,184 £6,483
    Ref (for internal use only):  [ContractNo] v1
    Page 2 of 2 of this Funding Agreement
    
    Funding Agreement 16-18 Non-Levy Apprenticeships - Provider Relief Schemes
    Provider: 10017052 Co Ltd UKPRN: 10017052
    Master Contract Ref: [MasterContractNo] Start Date: 01/04/2020 End Date: 31/03/2021
    Contract Ref: [AllocRef_YNLP]
    Cash (£) Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    16-18 Non-Levy Apprenticeships - Provider Relief £12,738 £5,134 £1,960 £5,644 £0 £0 £0 £0 £0 £0 £0 £0 £0
    Scheme 1 (April to June 2020)
    16-18 Non-Levy Apprenticeships - Provider Relief £15,454 £0 £0 £0 £2,478 £5,079 £7,340 £557 £0 £0 £0 £0 £0
    Scheme 2 (July to October 2020)
    Total Funding £28,192 £5,134 £1,960 £5,644 £2,478 £5,079 £7,340 £557 £0 £0 £0 £0 £0
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017052 Co Ltd UKPRN: 10017052
    Master Contract Ref: [MasterContractNo] Start Date: 01/04/2020 End Date: 31/03/2021
    Contract Ref: [AllocRef_ANLP]
    Cash (£) Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    Adult Non-Levy Apprenticeships £49,389
    Total Funding £49,389
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 2 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017052 Co Ltd UKPRN: 10017052
    Master Contract Ref: [MasterContractNo] Start Date: 01/04/2020 End Date: 31/03/2021
    Contract Ref: [AllocRef_ANLP]
    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    Adult Non-Levy Apprenticeships £7,228 £4,255 £5,222 £211 £1,453 £7,790 £4,680 £3,948 £4,033 £3,778 £4,542 £2,249
    Total Funding £7,228 £4,255 £5,222 £211 £1,453 £7,790 £4,680 £3,948 £4,033 £3,778 £4,542 £2,249
    Ref (for internal use only):  [ContractNo] v1
    Page 2 of 2 of this Funding Agreement
    
    Funding Agreement Adult Non-Levy Apprenticeships - Provider Relief Schemes
    Provider: 10017052 Co Ltd UKPRN: 10017052
    Master Contract Ref: [MasterContractNo] Start Date: 01/04/2020 End Date: 31/03/2021
    Contract Ref: [AllocRef_ANLP]
    Cash (£) Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    Adult Non-Levy Apprenticeships - Provider Relief Scheme £11,240 £2,168 £3,272 £5,800 £0 £0 £0 £0 £0 £0 £0 £0 £0
    1 (April to June 2020)
    Adult Non-Levy Apprenticeships - Provider Relief Scheme £15,693 £0 £0 £0 £5,205 £3,729 £2,318 £4,441 £0 £0 £0 £0 £0
    2 (July to October 2020)
    Total Funding £26,933 £2,168 £3,272 £5,800 £5,205 £3,729 £2,318 £4,441 £0 £0 £0 £0 £0
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """

    # Tidy Up
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017052'
    And   the override date is reset
    
    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017052'
        
@AcceptanceTest @Complete
Scenario: A888 Create and approve a Levy contract with both allocs. Create and approve a 2018 NLAP contract with 16-18 and Adult allocs. Bulk amend to add AS2019 allocs. Approve then NFA. Check x-ref alloc usage on NLAP docs.
    Given there are no allocations marked as Under Termination for UKPRN '10017888' 
    And   there are no terminated or closed allocations for UKPRN '10017888' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017888' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017888' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017888' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table 
    And   there are no DAS engagement events stored in FCS 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017888' 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017888' 

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017888'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ANAS-888      |
    | ANLP-888      |
    | ANLR-888      |
    | YNAS-888      |
    | YNLP-888      |
    | YNLR-888      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ANAS-888      |
    | ANLP-888      |
    | YNAS-888      |
    | YNLP-888      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | LEVY1799          |
    | NONLEVY2019       |
    | 16-18NLAP2018     |
    | 16-18NLAP-AS2019  |
    | 16-18NLAP-PRS2020 |
    | ANLAP2018         |
    | ANLAP-AS2019      |
    | ANLAP-PRS2020     |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | NLAP-888       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017888'

 
 
 
    # Remove the provider from RoATP (ContractManagement.RoATPProvider) 
    And   there is no data on RoATP for the following providers 
    | Ukprn    | 
    | 10017888 | 
 
    # Add the provider to RoATP (ContractManagement.RoATPProvider) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017888 | 10017888 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 
 
 
 
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017888' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017888 Co Ltd' with UKPRN '10017888' and OrgId 'ORG0017888' and has 'FCS1 Test' as a manager 
 
    # Put data in the PaaS Organisation table (Organisation.Organisation) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017888 | 117888 | 10017888 Co Ltd | 0              | Active                | Yes           | AA017888      | ?             | 36 Kings Street        | Covent Garden          | London                 | ?                      | ?                      | ?                      | WC2 8JS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017888 |

 
 
 
    # Change the date 
    Given the override date is '16/03/2019' 
 
    # Inject data into the stub to create a contract with two allocations 
   #And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation 
    And   the following Levy event data is available in the DAS agreement stub 
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 62888 | INITIATED | 2019-03-15T18:03:12.2888 | 10017888   | 28888             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017888' 
    Then  there is only one Levy contract in CRM for UKPRN '10017888' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017888' for FundingType 'LEVY' and period '1799' 
 
 
 
 
 
    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017888 | 10017888 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017888 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017888 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017888 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017888 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017888 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017888 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017888 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 
 
    And   there are no open tasks for the contract 
    And   there is no contract owner assigned to the latest version of the contract 
 
    ## Check deliverable period count prior to approval 
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
 

 
    # Change the date 
    Given the override date is '08/05/2020' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 
 
    ## Check deliverable period count after approval 
    #Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # After approval there should be a May-20 deliverable period for each of deliverables 1 through 14 for each allocation 
    Then  the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-20   | DeliverableDescription                               | 
    | 10017888 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017888 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017888 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017888 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017888 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017888 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017888 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017888 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017888 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017888 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017888 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017888 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017888 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017888 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
    # 
    | 10017888 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017888 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017888 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017888 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017888 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017888 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017888 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017888 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017888 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017888 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017888 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017888 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017888 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017888 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 
 
    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017888 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 08/05/2020        | ?               | ?             | 
    | 10017888 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 
 
    # Check ALLOCATION dates in CRM 
    And   the following allocation values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | 
    | 10017888 | [ContractNo]       | 1                     | [AllocRef_LEVY]     | 08/05/2020          | ?                 | 
    | 10017888 | [ContractNo]       | 1                     | [AllocRef_NLA]      | 08/05/2020          | ?                 | 
 
 


    # Inject the NLAP contract including AS2019 allocs
    
    # Change the date
    Given the override date is '12/05/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                  | Period | CRMIntent    | OrgId      |
    | 10017888 | 10017888 Co Ltd      | ESFA-888             | NLAP-888       | 1                     | 01/06/2020        | 31/03/2021      | 82366.00      |                                       | Procured                      | 2018   | New          | ORG0017888 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                        | CRMIntent    | DeliveryOrg |
    | 10017888 | NLAP-888       | ANAS-888      | ANLAP-AS          | ANLAP-AS2019            | NONLEVY                 | 01/06/2020          | 31/03/2021        | 16600.00        |                                         |            |                                              | New          |             |
    | 10017888 | NLAP-888       | ANLP-888      | ANLAP             | ANLAP2018               | NONLEVY                 | 01/06/2020          | 31/03/2021        | 23313.00        |                                         |            |                                              | New          |             |
    | 10017888 | NLAP-888       | YNAS-888      | 16-18NLAP-AS      | 16-18NLAP-AS2019        | NONLEVY                 | 01/06/2020          | 31/03/2021        | 18047.00        |                                         |            |                                              | New          |             |
    | 10017888 | NLAP-888       | YNLP-888      | 16-18NLAP         | 16-18NLAP2018           | NONLEVY                 | 01/06/2020          | 31/03/2021        | 24406.00        |                                         |            |                                              | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | DeliverableDescription                                              | CRMIntent    | DeliveryOrg |
    | 10017888 | NLAP-888       | ANAS-888      | 1               | 0                     | 16600.00  | 2984.00  | 1285.00  | 2683.00  | 1205.00  | 2920.00  | 494.00   | 2337.00  | 509.00   | 1309.00  | 874.00   | Adult Non-Levy Apprenticeships (Employer on Apprenticeship Service) | New          |             | 
    | 10017888 | NLAP-888       | ANLP-888      | 1               | 0                     | 23313.00  | 2509.00  | 1313.00  | 2934.00  | 1772.00  | 2538.00  | 2958.00  | 2682.00  | 3512.00  | 1021.00  | 2074.00  | Total Adult Non-Levy Apprenticeships Funding                        | New          |             | 
    | 10017888 | NLAP-888       | YNAS-888      | 1               | 0                     | 18047.00  | 1525.00  | 1628.00  | 2300.00  | 284.00   | 3615.00  | 2009.00  | 2142.00  | 759.00   | 1208.00  | 2577.00  | 16-18 Non-Levy Apprenticeships (Employer on Apprenticeship Service) | New          |             | 
    | 10017888 | NLAP-888       | YNLP-888      | 1               | 0                     | 24406.00  | 2358.00  | 1607.00  | 159.00   | 3519.00  | 3559.00  | 3440.00  | 95.00    | 2729.00  | 3213.00  | 3727.00  | Total 16-18 Non-Levy Apprenticeships Funding                        | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | NLAP-888       | 1                     | 0                        | 2020-05-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'NLAP-888' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NLAP-888'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-888' and actual ContractNumber 'NLAP-888'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-888' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017888 | NLAP-888           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/06/2020        | 31/03/2021      | ?             |
    | 10017888 | ESFA-888           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/06/2020        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '120' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    #And   there are '120' deliverable period rows in CRM linked to the latest version of contract 'NLAP-888'

#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | YNLP-888        | 2240151          | Mar-21 | Reconciliation |
#    | ANLP-888        | 2340151          | Mar-21 | Reconciliation |




    # Bulk amend to add PRS allocs

    # Change the date
    Given the override date is '01/10/2020'

    # Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   the following NLAP NewStarts profile values exist in config
    | UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
    | 10017888 | 1250.00            | 1875.00            | 500.00                               | 600.00                               |


    # Bulk file
    And   there are no files prefixed '10017888' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 04092020134339 v3_A888' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 04092020134339 v3_A888' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 04092020134339 v3_A888' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 04092020134339 v3_A888' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 04092020134339 v3_A888.xlsx' exists in the Datafiles folder and UKPRN '10017888' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017888' for FundingType 'LEVY' and period '1799' 

    # Check the contents of the SoF to check that x-ref from Levy contract is showing
    #  (Note: the FA is not generated for Employer on App Services allocs. See 27004)
    #Then  the file named '10017888_NLAP-888_v2.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    #"""
    #APPENDIX 1 – SUMMARY OF FUNDING
    #Organisation Name: 10017888 Co Ltd UKPRN: 10017888
    #Master Contract Number: ESFA-888
    #Allocation
    #Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Apr 22 to Mar 23 Apr 23 to Mar 24 Apr 24 to Mar 25 Total
    #16-18 Non-Levy Apprenticeships YNLP-888 £24,406 £24,406
    #of which New Starts £1,250 £1,250
    #16-18 Non-Levy Apprenticeships NLA-84018 £18,047 £18,047
    #(Employer on Apprenticeship
    #Service)
    #16-18 Non-Levy Provider Relief YNLP-888 £19,086 £19,086
    #Schemes
    #of which Provider Relief £2,123 £2,123
    #Scheme 1 (April to June 2020)
    #of which Provider Relief £16,963 £16,963
    #Scheme 2 (July to October
    #2020)
    #Adult Non-Levy Apprenticeships ANLP-888 £23,313 £23,313
    #of which New Starts £1,875 £1,875
    #Adult Non-Levy Apprenticeships NLA-84018 £16,600 £16,600
    #(Employer on Apprenticeship
    #Service)
    #Adult Non-Levy Provider Relief ANLP-888 £20,550 £20,550
    #Schemes
    #of which Provider Relief £3,125 £3,125
    #Scheme 1 (April to June 2020)
    #of which Provider Relief £17,425 £17,425
    #Scheme 2 (July to October
    #2020)
    #Total: £122,002
    #"""



    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017888_NLAP-888_v2.pdf' in 'NLA-2018-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A888v2.pdf'


    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NLAP-888'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-888' and actual ContractNumber 'NLAP-888'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-888' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017888 | NLAP-888           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/06/2020        | 31/03/2021      | Variation     |
    | 10017888 | NLAP-888           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/06/2020        | 31/03/2021      | ?             |
    | 10017888 | ESFA-888           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/06/2020        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '160' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '160' deliverable period rows in CRM linked to the latest version of contract 'NLAP-888'

#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | YNLP-888        | 2240151          | Mar-21 | Reconciliation |
#    | ANLP-888        | 2340151          | Mar-21 | Reconciliation |




    # Execute a NON-FINANCIAL amendment and check docs

    # Change the date
    Given the override date is '22/10/2020'

    # Issue a non-financial VARIATION amendment on v2 to create v3
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'NLAP-888' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017888 | NLAP-888           | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/06/2020        | 31/03/2021      | Variation     |
    | 10017888 | NLAP-888           | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/06/2020        | 31/03/2021      | Variation     |
    | 10017888 | NLAP-888           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/06/2020        | 31/03/2021      | ?             |
    | 10017888 | ESFA-888           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/06/2020        | 31/03/2021      | ?             |



    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017888' for FundingType 'LEVY' and period '1799' 

    ## Check the contents of the SoF to check that x-ref from Levy contract is showing
    ##  (Note: the FA is not generated for Employer on App Services allocs. See 27004)
    #Then  the file named '10017888_NLAP-888_v3.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    #"""
    #APPENDIX 1 – SUMMARY OF FUNDING
    #Organisation Name: 10017888 Co Ltd UKPRN: 10017888
    #Master Contract Number: ESFA-888
    #Allocation
    #Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Apr 22 to Mar 23 Apr 23 to Mar 24 Total
    #16-18 Non-Levy Apprenticeships YNLP-888 £24,406 £24,406
    #of which New Starts £1,250 £1,250
    #16-18 Non-Levy Apprenticeships [AllocRef_NLA] £18,047 £18,047
    #(Employer on Apprenticeship 
    #Service)
    #16-18 Non-Levy Provider Relief YNLP-888 £19,086 £19,086
    #Schemes
    #of which Provider Relief Scheme 1 £2,123 £2,123
    #(April to June 2020)
    #of which Provider Relief Scheme 2 £16,963 £16,963
    #(July to October 2020)
    #Adult Non-Levy Apprenticeships ANLP-888 £23,313 £23,313
    #of which New Starts £1,875 £1,875
    #Adult Non-Levy Apprenticeships [AllocRef_NLA] £16,600 £16,600
    #(Employer on Apprenticeship 
    #Service)
    #Adult Non-Levy Provider Relief ANLP-888 £20,550 £20,550
    #Schemes
    #of which Provider Relief Scheme 1 £3,125 £3,125
    #(April to June 2020)
    #of which Provider Relief Scheme 2 £17,425 £17,425
    #(July to October 2020)
    #Total: £122,002
    #"""


     # Tidy Up
     Given the override date is reset
      
     # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
     And   there is no NLAP NewStarts profile data in config for UKPRN '10017888'
     
@AcceptanceTest @Complete
Scenario: A059 Create and approve a 2018 NLAP contract with 16-18 and Adult allocs. Bulk amend to add short PRS2021 allocs. Check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017059' 
    And   there are no terminated or closed allocations for UKPRN '10017059' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017059' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017059' 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017059' 

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017059'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ANLP-059      |
    | YNLP-059      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ANLP-059      |
    | YNLP-059      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | 16-18NLAP2018  |
    | ANLAP2018      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | NLAP-059       | 1                     | 0                        |


     

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017059' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017059 Co Ltd' with UKPRN '10017059' and OrgId 'ORG0017059' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017059' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017059 | 117059 | 10017059 Co Ltd | 0              | Active                | Yes           | AA017059      | ?             | 20 Birklands Park      | ?                      | ?                      | ?                      | St.Albans              | Hertfordshire          | AL1 1TS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017059 |




    # Change the date
    Given the override date is '01/12/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017059 | 10017059 Co Ltd      | ESFA-059             | NLAP-059       | 1                     | 01/01/2018        | 31/03/2021      | 153883.00     |                                       | Contract for Services                      | 2018   | New          | ORG0017059 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017059 | NLAP-059       | ANLP-059      | ANLAP             | ANLAP2018               | NONLEVY                 | 01/01/2018          | 31/03/2021        | 78769.00        |                                         |            |                                                             | New          |             |
    | 10017059 | NLAP-059       | YNLP-059      | 16-18NLAP         | 16-18NLAP2018           | NONLEVY                 | 01/01/2018          | 31/03/2021        | 75114.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | DeliverableDescription                       | CRMIntent    | DeliveryOrg |
    | 10017059 | NLAP-059       | ANLP-059      | 1               | 0                     | 78769.00  | 1360.00  | 2096.00  | 870.00   | 846.00   | 3638.00  | 2664.00  | 900.00   | 2491.00  | 3386.00  | 703.00   | 3084.00  | 624.00   | 3321.00  | 3613.00  | 1755.00  | 910.00   | 727.00   | 292.00   | 1597.00  | 1384.00  | 3005.00  | 861.00   | 2610.00  | 3030.00  | 2753.00  | 3583.00  | 110.00   | 1162.00  | 2689.00  | 2793.00  | 3465.00  | 466.00   | 95.00    | 2190.00  | 3306.00  | 940.00   | 2373.00  | 3741.00  | 3336.00  | Total Adult Non-Levy Apprenticeships Funding | New          |             | 
    | 10017059 | NLAP-059       | YNLP-059      | 1               | 0                     | 75114.00  | 3156.00  | 1709.00  | 2351.00  | 2390.00  | 2272.00  | 2628.00  | 1560.00  | 1061.00  | 1575.00  | 3734.00  | 958.00   | 903.00   | 2050.00  | 2311.00  | 2509.00  | 1916.00  | 3695.00  | 1076.00  | 547.00   | 3117.00  | 1827.00  | 1995.00  | 3458.00  | 1788.00  | 2114.00  | 3102.00  | 137.00   | 1630.00  | 2588.00  | 1679.00  | 706.00   | 2643.00  | 532.00   | 444.00   | 2445.00  | 1125.00  | 2366.00  | 1363.00  | 1654.00  | Total 16-18 Non-Levy Apprenticeships Funding | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | NLAP-059       | 1                     | 0                        | 2017-12-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'NLAP-059' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NLAP-059'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-059' and actual ContractNumber 'NLAP-059'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-059' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017059 | NLAP-059           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2021      | ?             |
    | 10017059 | ESFA-059           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '390' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '390' deliverable period rows in CRM linked to the latest version of contract 'NLAP-059'

#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | YNLP-059        | 2240151          | Mar-21 | Reconciliation |
#    | ANLP-059        | 2340151          | Mar-21 | Reconciliation |
       



    # Add both PRS allocs by bulk import amendment. Short period allocs
    
    # Change the date
    Given the override date is '26/09/2020'

    # Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   the following NLAP NewStarts profile values exist in config
    | UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
    | 10017059 | 6565.00            | 11415.00           | 4285.00                              | 5602.00                              |


    # Bulk file
    And   there are no files prefixed '10017059' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 19082020100110 v3_A059' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 19082020100110 v3_A059' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 19082020100110 v3_A059' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 19082020100110 v3_A059' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 19082020100110 v3_A059.xlsx' exists in the Datafiles folder and UKPRN '10017059' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    ## Retrieve parameters
    #When  I retrieve the latest contract details from CRM for provider '10017059' for FundingType 'NLA' and period '2018'

    # Check the contents of the SoF and FAs
    #  (Note: the FA is not generated for Employer on App Services allocs. See 27004)
   #Then  the file named '10017059_[ContractNo]_v2.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
#    Then  the file named '10017059_NLAP-059_v2.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
#    """
#    APPENDIX 1 – SUMMARY OF FUNDING
#    Organisation Name: 10017059 Co Ltd UKPRN: 10017059
#    Master Contract Number: ESFA-059
#    Allocation
#    Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Apr 22 to Mar 23 Apr 23 to Mar 24 Apr 24 to Mar 25 Total
#    16-18 Non-Levy Apprenticeships YNLP-059 £7,216 £23,951 £24,772 £19,175 £75,114
#    of which New Starts £6,565 £6,565
#    16-18 Non-Levy Provider Relief YNLP-059 £12,455 £12,455
#    Schemes
#    of which Provider Relief Scheme 1 £6,036 £6,036
#    (April to June 2020)
#    of which Provider Relief Scheme 2 £6,419 £6,419
#    (July to October 2020)
#    Adult Non-Levy Apprenticeships ANLP-059 £4,326 £27,025 £20,862 £26,556 £78,769
#    of which New Starts £11,415 £11,415
#    Adult Non-Levy Provider Relief ANLP-059 £7,605 £7,605
#    Schemes
#    of which Provider Relief Scheme 1 £4,020 £4,020
#    (April to June 2020)
#    of which Provider Relief Scheme 2 £3,585 £3,585
#    (July to October 2020)
#    Total: £173,943
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships
#    Page 1 of 4 of this Funding Agreement
#    Page 2 of 4 of this Funding Agreement
#    Page 3 of 4 of this Funding Agreement
#    Page 4 of 4 of this Funding Agreement
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships - Provider Relief Schemes
#    Page 1 of 1 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships
#    Page 1 of 4 of this Funding Agreement
#    Page 2 of 4 of this Funding Agreement
#    Page 3 of 4 of this Funding Agreement
#    Page 4 of 4 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships - Provider Relief Schemes
#    Page 1 of 1 of this Funding Agreement
#    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017059_NLAP-059_v2.pdf' in 'NLA-2018-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A059v2.pdf'


    # Tidy Up
    And   the override date is reset
    
    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017059'
  
