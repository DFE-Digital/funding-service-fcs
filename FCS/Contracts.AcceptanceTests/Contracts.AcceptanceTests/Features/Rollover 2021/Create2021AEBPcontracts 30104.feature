Feature: Create2021AEBPcontracts 30104

@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run67
Scenario: A711 Create and approve 1718, 1819 and 1920 AEBP contracts under a joint master. Bulk add a 2021 AEBP contract. Approve. Check docs, CRM, PaaS and CM feed
    Given there are no allocations marked as Under Termination for UKPRN '10017711' 
    And   there are no terminated or closed allocations for UKPRN '10017711' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017711' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017711' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBC-1711     |
    | AEBL-1711     |
    | AEBT-1711     |
    | AEBC-2711     |
    | AEBL-2711     |
    | AEBT-2711     |
    | AEAL-3711     |
    | AEBA-3711     |
    | AEBC-3711     |
    | AEBR-3711     |
    | AETL-3711     |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBC-1711     |
    | AEBL-1711     |
    | AEBT-1711     |
    | AEBC-2711     |
    | AEBL-2711     |
    | AEBT-2711     |
    | AEAL-3711     |
    | AEBA-3711     |
    | AEBC-3711     |
    | AEBR-3711     |
    | AETL-3711     |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | AEB-CL1718     |
    | AEB-LS1718     |
    | AEB-TOL1718    |
    | AEB-CL1819     |
    | AEB-LS1819     |
    | AEB-TOL1819    |
    | AEB-AS1920     |
    | AEB-CL1920     |
    | AEB-19TRN1920  |
    | AEB-19TRLS1920 |
    | AEB-ASLS1920   |
    | AEB-19TRLS2021 |
    | AEB-19TRN2021  |
    | AEB-AS2021     |
    | AEB-ASLS2021   |
    | STFI2021       |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    Given there are no Sector-based Work Academies profile values in config for UKPRN '10017711'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017711' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017711 Co Ltd' with UKPRN '10017711' and OrgId 'ORG0017711' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017711' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017711 | 117711 | 10017711 Co Ltd | 0              | In Administration     | Yes           | AA017711      | ?             | 116a High Street       | ?                      | ?                      | ?                      | Hoddesdon              | Hertfordshire          | EN11 8HD  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017711 |


 

    # Change the date
    Given the override date is '01/12/2017'

    # Create 1718 contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017711 | 10017711 Co Ltd      | ESFA-711             | AEBP-1711      | 1                     | 01/08/2017        | 31/07/2018      | 65756.00      |                                       | Contract for Services                      | 1718   | New          | ORG0017711 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017711 | AEBP-1711      | AEBC-1711     | AEB-CL            | AEB-CL1718              | AY                      | 01/08/2017          | 31/07/2018        | 19137.00        |                                         |            |                                                             | New          |             |
    | 10017711 | AEBP-1711      | AEBL-1711     | AEB-LS            | AEB-LS1718              | AY                      | 01/08/2017          | 31/07/2018        | 24090.00        |                                         |            |                                                             | New          |             |
    | 10017711 | AEBP-1711      | AEBT-1711     | AEB-TOL           | AEB-TOL1718             | AY                      | 01/08/2017          | 31/07/2018        | 22529.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017711 | AEBP-1711      | AEBC-1711     | 1               | 0                     | 19137.00  | 11736.00  | 7401.00   | 646.00   | 1792.00  | 1071.00  | 1269.00  | 676.00   | 2455.00  | 819.00   | 3008.00  | 2859.00  | 1570.00  | 755.00   | 2217.00  | Adult Education Budget - Community Learning                     | New          |             | 
    | 10017711 | AEBP-1711      | AEBL-1711     | 1               | 0                     | 24090.00  | 14382.00  | 9708.00   | 2019.00  | 1362.00  | 2351.00  | 3087.00  | 1861.00  | 1837.00  | 928.00   | 937.00   | 2874.00  | 3482.00  | 675.00   | 2677.00  | Adult Education Budget - Learner Support                        | New          |             | 
    | 10017711 | AEBP-1711      | AEBT-1711     | 1               | 0                     | 22529.00  | 13996.00  | 8533.00   | 484.00   | 2707.00  | 721.00   | 1996.00  | 2856.00  | 2011.00  | 1828.00  | 1393.00  | 2698.00  | 2485.00  | 405.00   | 2945.00  | Adult Education - Traineeships and Other Learning Total Funding | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'AEBP-1711' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-1711'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-711' and actual ContractNumber 'AEBP-1711'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-1711' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017711 | AEBP-1711          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017711 | ESFA-711           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'AEBP-1711'




    # Change the date
    Given the override date is '01/07/2018'

    # Create 1819 contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017711 | 10017711 Co Ltd      | ESFA-711             | AEBP-2711      | 1                     | 01/08/2018        | 31/07/2019      | 72032.00      |                                       | Contract for Services                      | 1819   | New          | ORG0017711 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017711 | AEBP-2711      | AEBC-2711     | AEB-CL            | AEB-CL1819              | AY                      | 01/08/2018          | 31/07/2019        | 24744.00        |                                         |            |                                                             | New          |             |
    | 10017711 | AEBP-2711      | AEBL-2711     | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 24591.00        |                                         |            |                                                             | New          |             |
    | 10017711 | AEBP-2711      | AEBT-2711     | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 22697.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017711 | AEBP-2711      | AEBC-2711     | 1               | 0                     | 24744.00  | 15348.00  | 9396.00   | 155.00   | 891.00   | 2384.00  | 3342.00  | 2433.00  | 1460.00  | 3397.00  | 1286.00  | 1198.00  | 3199.00  | 1879.00  | 3120.00  | Adult Education Budget - Community Learning                     | New          |             | 
    | 10017711 | AEBP-2711      | AEBL-2711     | 1               | 0                     | 24591.00  | 16151.00  | 8440.00   | 2375.00  | 2667.00  | 809.00   | 2682.00  | 3482.00  | 3047.00  | 651.00   | 438.00   | 2059.00  | 3616.00  | 1664.00  | 1101.00  | Adult Education Budget - Learner Support                        | New          |             | 
    | 10017711 | AEBP-2711      | AEBT-2711     | 1               | 0                     | 22697.00  | 15796.00  | 6901.00   | 2109.00  | 2939.00  | 448.00   | 1501.00  | 3027.00  | 2148.00  | 2820.00  | 804.00   | 433.00   | 2528.00  | 2662.00  | 1278.00  | Adult Education - Traineeships and Other Learning Total Funding | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'AEBP-711' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-2711'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-711' and actual ContractNumber 'AEBP-2711'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-2711' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017711 | AEBP-1711          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017711 | AEBP-2711          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017711 | ESFA-711           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'AEBP-2711'




    # Change the date
    Given the override date is '01/07/2019'

    # Create 1920 contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017711 | 10017711 Co Ltd      | ESFA-711             | AEBP-3711      | 1                     | 01/08/2019        | 31/07/2020      | 118512.00     |                                       | Contract for Services                      | 1920   | New          | ORG0017711 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017711 | AEBP-3711      | AEAL-3711     | AEB-ASLS          | AEB-ASLS1920            | AY                      | 01/08/2019          | 31/07/2020        | 26458.00        |                                         |            |                                                             | New          |             |
    | 10017711 | AEBP-3711      | AEBA-3711     | AEB-AS            | AEB-AS1920              | AY                      | 01/08/2019          | 31/07/2020        | 20254.00        |                                         |            |                                                             | New          |             |
    | 10017711 | AEBP-3711      | AEBC-3711     | AEB-CL            | AEB-CL1920              | AY                      | 01/08/2019          | 31/07/2020        | 22765.00        |                                         |            |                                                             | New          |             |
    | 10017711 | AEBP-3711      | AEBR-3711     | AEB-19TRN         | AEB-19TRN1920           | AY                      | 01/08/2019          | 31/07/2020        | 29391.00        |                                         |            |                                                             | New          |             |
    | 10017711 | AEBP-3711      | AETL-3711     | AEB-19TRLS        | AEB-19TRLS1920          | AY                      | 01/08/2019          | 31/07/2020        | 19644.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017711 | AEBP-3711      | AEAL-3711     | 1               | 0                     | 26458.00  | 15835.00  | 10623.00  | 2383.00  | 2580.00  | 1987.00  | 65.00    | 2131.00  | 619.00   | 3188.00  | 2882.00  | 2067.00  | 3529.00  | 2842.00  | 2185.00  | Adult Education Budget - Adult Skills Learner Support           | New          |             | 
    | 10017711 | AEBP-3711      | AEBA-3711     | 1               | 0                     | 20254.00  | 14494.00  | 5760.00   | 2701.00  | 3437.00  | 2212.00  | 2187.00  | 1278.00  | 305.00   | 2242.00  | 132.00   | 1026.00  | 2044.00  | 725.00   | 1965.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017711 | AEBP-3711      | AEBC-3711     | 1               | 0                     | 22765.00  | 14606.00  | 8159.00   | 2059.00  | 2351.00  | 493.00   | 3349.00  | 3166.00  | 2731.00  | 335.00   | 122.00   | 1743.00  | 3300.00  | 1348.00  | 1768.00  | Adult Education Budget - Community Learning                     | New          |             | 
    | 10017711 | AEBP-3711      | AEBR-3711     | 1               | 0                     | 29391.00  | 20914.00  | 8477.00   | 2315.00  | 3145.00  | 3372.00  | 724.00   | 2250.00  | 2354.00  | 3026.00  | 3728.00  | 3357.00  | 1751.00  | 2868.00  | 501.00   | 19-24 Traineeships Total Funding                                | New          |             | 
    | 10017711 | AEBP-3711      | AETL-3711     | 1               | 0                     | 19644.00  | 10058.00  | 9586.00   | 858.00   | 2227.00  | 1822.00  | 1071.00  | 3324.00  | 265.00   | 305.00   | 186.00   | 542.00   | 3176.00  | 2677.00  | 3191.00  | Adult Education Budget - 19-24 Traineeships Learner Support     | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'AEBP-711' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-3711'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-711' and actual ContractNumber 'AEBP-3711'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-3711' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017711 | AEBP-1711          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017711 | AEBP-2711          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017711 | AEBP-3711          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017711 | ESFA-711           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '108' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '108' deliverable period rows in CRM linked to the latest version of contract 'AEBP-3711'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AEBA-3711       | 2372010          | Jul-20 | Reconciliation |
    | AEBC-3711       | 2372030          | Jul-20 | Profile        |
    | AEBR-3711       | 2355800          | Jul-20 | Reconciliation |
    | AETL-3711       | 2355875          | Jul-20 | Profile        |
    | AEAL-3711       | 2372165          | Jul-20 | Profile        |




    # Upsert the provider config values for Sector-based Work Academies for a specific UKPRN and FSP (DocumentsDomain.ContractReferenceConfig) (30680)
    Given the following Sector-based Work Academies profile values exist in config
    | UKPRN    | FSPCode       | Aug20-Mar21 | Apr21-Jul21 |
    | 10017711 | AEB-AS2021    | 2121.00     | 250.00      |
    
    
    
    
    # Bulk load a new 2021 AEBP contract with shared Master

    # Change the date
    Given the override date is '23/07/2020'

    # Bulk file (New Amendment)
    And   there are no files prefixed '10017711' in the Sharepoint 'AEB-2021-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 2021 16062020142654 v3_A711' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 2021 16062020142654 v3_A711' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 2021 16062020142654 v3_A711' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 2021 16062020142654 v3_A711' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 2021 16062020142654 v3_A711.xlsx' exists in the Datafiles folder and UKPRN '10017711' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017711' for FundingType 'AEB' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017711' for FundingType 'AEB' and period '2021'

    # Check the contents of the Appendices
    Then  the file named '10017711_[ContractNo]_v1.pdf' in Sharepoint location 'AEB-2021-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017711 Co Ltd UKPRN: 10017711
    Master Contract Number: ESFA-711
    Allocation
    1 November 2017 to 31 July 2018 Contract Ref Nov 17 - Mar 18 Apr 18 - Jul 18 Total
    Adult Education Budget - Traineeships and Other Learning AEBT-1711 £13,996 £8,533 £22,529
    Adult Education Budget - Community Learning AEBC-1711 £11,736 £7,401 £19,137
    Adult Education Budget - Learner Support AEBL-1711 £14,382 £9,708 £24,090
    Total: £65,756
    Allocation
    1 August 2018 to 31 July 2019 Contract Ref Aug 18 - Mar 19 Apr 19 - Jul 19 Total
    Adult Education Budget - Traineeships and Other Learning AEBT-2711 £15,796 £6,901 £22,697
    Adult Education Budget - Community Learning AEBC-2711 £15,348 £9,396 £24,744
    Adult Education Budget - Learner Support AEBL-2711 £16,151 £8,440 £24,591
    Total: £72,032
    Allocation
    1 August 2019 to 31 July 2020 Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 Total
    ESFA AEB - 19 to 24 Traineeships AEBR-3711 £20,914 £8,477 £29,391
    ESFA AEB - Adult Skills AEBA-3711 £14,494 £5,760 £20,254
    ESFA AEB - Community Learning AEBC-3711 £14,606 £8,159 £22,765
    ESFA AEB - 19 to 24 Traineeships Learner Support AETL-3711 £10,058 £9,586 £19,644
    ESFA AEB - Adult Skills Learner Support AEAL-3711 £15,835 £10,623 £26,458
    Total: £118,512
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AEBR] £40,309 £8,604 £48,913
    ESFA AEB - Adult Skills [AllocRef_AEBA] £20,629 £11,187 £31,816
    of which Sector-based Work Academies £2,121 £250 £2,371
    ESFA AEB - COVID-19 Skills Offer [AllocRef_AESO] £36,562 £33,188 £69,750
    of which High Value Courses for School and College 
    £36,562 £18,188 £54,750
    Leavers
    of which National Skills Fund Level 3 Offer for 24 year old
    £0 £15,000 £15,000
    and over

    ESFA AEB - 19 to 24 Traineeships Learner Support [AllocRef_AETL] £42,142 £12,440 £54,582
    ESFA AEB - Adult Skills Learner Support [AllocRef_AEAL] £39,934 £17,177 £57,111
    ESFA AEB - Short Term Funding Initiatives [AllocRef_STFI] £125,139 £43,950 £169,089
    of which Short Term Funding Initiative 1 £43,311 £8,646 £51,957
    of which Short Term Funding Initiative 2 £22,581 £10,207 £32,788
    of which Short Term Funding Initiative 3 £29,927 £11,767 £41,694
    of which Short Term Funding Initiative 4 £29,320 £13,330 £42,650
    Total: £431,261
    Total Funding for this contract: £687,561
    
    Funding Agreement ESFA-Funded Adult Education Budget - 19 to 24 Traineeships
    Provider: 10017711 Co Ltd UKPRN: 10017711
    Master Contract Number: ESFA-711 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_AEBR]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - 19 to 24 Traineeships £48,913 £2,106 £5,524 £7,445 £1,682 £6,798 £1,512 £7,308 £7,934 £3,943 £2,127 £1,734 £800
    Total Funding £48,913 £2,106 £5,524 £7,445 £1,682 £6,798 £1,512 £7,308 £7,934 £3,943 £2,127 £1,734 £800
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - Adult Skills
    Provider: 10017711 Co Ltd UKPRN: 10017711
    Master Contract Number: ESFA-711 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_AEBA]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - Adult Skills £31,816 £3,969 £3,512 £1,650 £4,994 £801 £1,703 £1,108 £2,892 £3,381 £5,642 £971 £1,193
    Total Funding £31,816 £3,969 £3,512 £1,650 £4,994 £801 £1,703 £1,108 £2,892 £3,381 £5,642 £971 £1,193
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - COVID-19 Skills Offer
    Provider: 10017711 Co Ltd UKPRN: 10017711
    Master Contract Number: ESFA-711 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_AESO]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - High Value Courses for School and £54,750 £3,843 £3,329 £7,087 £7,989 £7,394 £1,227 £1,716 £3,977 £7,257 £7,479 £972 £2,480
    College Leavers
    ESFA AEB - National Skills Fund Level 3 Offer for 24 £15,000 £0 £0 £0 £0 £0 £0 £0 £0 £2,177 £2,437 £2,946 £7,440
    year old and over
    Total Funding £69,750 £3,843 £3,329 £7,087 £7,989 £7,394 £1,227 £1,716 £3,977 £9,434 £9,916 £3,918 £9,920
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - 19 to 24 Traineeships Learner Support
    Provider: 10017711 Co Ltd UKPRN: 10017711
    Master Contract Number: ESFA-711 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_AETL]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - 19 to 24 Traineeships Learner Support £54,582 £5,733 £5,074 £3,322 £6,465 £4,989 £3,577 £5,700 £7,282 £4,649 £4,596 £2,643 £552
    Total Funding £54,582 £5,733 £5,074 £3,322 £6,465 £4,989 £3,577 £5,700 £7,282 £4,649 £4,596 £2,643 £552
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - Adult Skills Learner Support
    Provider: 10017711 Co Ltd UKPRN: 10017711
    Master Contract Number: ESFA-711 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_AEAL]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - Adult Skills Learner Support £57,111 £6,990 £547 £7,701 £4,252 £6,650 £1,566 £4,644 £7,584 £6,715 £5,101 £1,991 £3,370
    Total Funding £57,111 £6,990 £547 £7,701 £4,252 £6,650 £1,566 £4,644 £7,584 £6,715 £5,101 £1,991 £3,370
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - Short Term Funding Initiatives
    Provider: 10017711 Co Ltd UKPRN: 10017711
    Master Contract Number: ESFA-711 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_STFI]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    Short Term Funding Initiative 1 £51,957 £2,204 £7,862 £6,790 £7,894 £4,582 £6,567 £6,450 £962 £1,525 £1,949 £675 £4,497
    Short Term Funding Initiative 2 £32,788 £6,822 £5,686 £3,255 £485 £845 £3,988 £400 £1,100 £3,223 £4,805 £60 £2,119
    Short Term Funding Initiative 3 £41,694 £166 £6,026 £2,236 £5,654 £5,463 £1,812 £6,928 £1,642 £7,437 £113 £4,072 £145
    Short Term Funding Initiative 4 £42,650 £1,864 £930 £3,733 £3,276 £6,758 £2,151 £5,909 £4,699 £4,105 £5,888 £538 £2,799
    Total Funding £169,089 £11,056 £20,504 £16,014 £17,309 £17,648 £14,518 £19,687 £8,403 £16,290 £12,755 £5,345 £9,560
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """

    # There should not be a zero value entry in the doc for Sector-based Work Academies (30680)
    And   the pdf file does not contain the following text
    """
    of which Sector-based Work Academies £0 £0 £0
    """


    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017711_[ContractNo]_v1.pdf' in 'AEB-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A711.pdf'




    # Change the date
    Given the override date is '30/07/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-711' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017711 | AEBP-1711          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017711 | AEBP-2711          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017711 | AEBP-3711          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017711 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017711 | ESFA-711           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check deliverable data in the ContractManagement Legal feed
    And   the Legal Contract CM feed contains the following '11' deliverables
    | UKPRN    | ContractNumber  | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                              | DeliverableDescription  | 
    | 10017711 | [ContractNo]    | 1               | [AllocRef_AEAL] | 1               | 0                     | 57111        | 0             | 0        | Adult Education Budget - Adult Skills Learner Support        | ?                       |
    | 10017711 | [ContractNo]    | 1               | [AllocRef_AEBA] | 1               | 0                     | 31816        | 0             | 0        | Adult Skills Total Funding                                   | ?                       |
    | 10017711 | [ContractNo]    | 1               | [AllocRef_AEBR] | 1               | 0                     | 48913        | 0             | 0        | 19-24 Traineeships Total Funding                             | ?                       |
    | 10017711 | [ContractNo]    | 1               | [AllocRef_AESO] | 1               | 0                     | 69750        | 0             | 0        | COVID-19 Skills Offer Total Funding                          | ?                       |
    | 10017711 | [ContractNo]    | 1               | [AllocRef_AESO] | 2               | 1                     | 54750        | 0             | 0        | High Value Courses for School and College Leavers Funding    | ?                       |
    | 10017711 | [ContractNo]    | 1               | [AllocRef_AESO] | 5               | 1                     | 15000        | 0             | 0        | National Skills Fund Level 3 Offer for 24 year old and over  | ?                       |
    | 10017711 | [ContractNo]    | 1               | [AllocRef_AETL] | 1               | 0                     | 54582        | 0             | 0        | Adult Education Budget - 19-24 Traineeships Learner Support  | ?                       |
    | 10017711 | [ContractNo]    | 1               | [AllocRef_STFI] | 1               | 0                     | 51957        | 0             | 0        | Short Term Funding Initiative 1                              | ?                       |
    | 10017711 | [ContractNo]    | 1               | [AllocRef_STFI] | 2               | 0                     | 32788        | 0             | 0        | Short Term Funding Initiative 2                              | ?                       |
    | 10017711 | [ContractNo]    | 1               | [AllocRef_STFI] | 3               | 0                     | 41694        | 0             | 0        | Short Term Funding Initiative 3                              | ?                       |
    | 10017711 | [ContractNo]    | 1               | [AllocRef_STFI] | 4               | 0                     | 42650        | 0             | 0        | Short Term Funding Initiative 4                              | ?                       |




    # Check Financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | [ContractNo]   | [AllocRef_AEAL]    | 1               | 57111.00  | 39934.00 | 17177.00 | 6990.00  | 547.00   | 7701.00  | 4252.00  | 6650.00  | 1566.00  | 4644.00  | 7584.00  | 6715.00  | 5101.00  | 1991.00  | 3370.00  | 
    | [ContractNo]   | [AllocRef_AEBA]    | 1               | 31816.00  | 39934.00 | 17177.00 | 3969.00  | 3512.00  | 1650.00  | 4994.00  | 801.00   | 1703.00  | 1108.00  | 2892.00  | 3381.00  | 5642.00  | 971.00   | 1193.00  | 
    | [ContractNo]   | [AllocRef_AEBR]    | 1               | 48913.00  | 40309.00 | 8604.00  | 2106.00  | 5524.00  | 7445.00  | 1682.00  | 6798.00  | 1512.00  | 7308.00  | 7934.00  | 3943.00  | 2127.00  | 1734.00  | 800.00   | 
    | [ContractNo]   | [AllocRef_AESO]    | 1               | 69750.00  | 36562.00 | 33188.00 | 3843.00  | 3329.00  | 7087.00  | 7989.00  | 7394.00  | 1227.00  | 1716.00  | 3977.00  | 9434.00  | 9916.00  | 3918.00  | 9920.00  | 
    | [ContractNo]   | [AllocRef_AESO]    | 2               | 54750.00  | 36562.00 | 18188.00 | 3843.00  | 3329.00  | 7087.00  | 7989.00  | 7394.00  | 1227.00  | 1716.00  | 3977.00  | 7257.00  | 7479.00  | 972.00   | 2480.00  | 
    | [ContractNo]   | [AllocRef_AESO]    | 5               | 15000.00  | 0.00     | 15000.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2177.00  | 2437.00  | 2946.00  | 7440.00  | 
    | [ContractNo]   | [AllocRef_AETL]    | 1               | 54582.00  | 42142.00 | 12440.00 | 5733.00  | 5074.00  | 3322.00  | 6465.00  | 4989.00  | 3577.00  | 5700.00  | 7282.00  | 4649.00  | 4596.00  | 2643.00  | 552.00   | 
    | [ContractNo]   | [AllocRef_STFI]    | 1               | 51957.00  | 43311.00 | 8646.00  | 2204.00  | 7862.00  | 6790.00  | 7894.00  | 4582.00  | 6567.00  | 6450.00  | 962.00   | 1525.00  | 1949.00  | 675.00   | 4497.00  | 
    | [ContractNo]   | [AllocRef_STFI]    | 2               | 32788.00  | 22581.00 | 10207.00 | 6822.00  | 5686.00  | 3255.00  | 485.00   | 845.00   | 3988.00  | 400.00   | 1100.00  | 3223.00  | 4805.00  | 60.00    | 2119.00  | 
    | [ContractNo]   | [AllocRef_STFI]    | 3               | 41694.00  | 29927.00 | 11767.00 | 166.00   | 6026.00  | 2236.00  | 5654.00  | 5463.00  | 1812.00  | 6928.00  | 1642.00  | 7437.00  | 113.00   | 4072.00  | 145.00   | 
    | [ContractNo]   | [AllocRef_STFI]    | 4               | 42650.00  | 29320.00 | 13330.00 | 1864.00  | 930.00   | 3733.00  | 3276.00  | 6758.00  | 2151.00  | 5909.00  | 4699.00  | 4105.00  | 5888.00  | 538.00   | 2799.00  | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | [ContractNo]   | [AllocRef_AEAL]    | 1               | 57111.00  | 6990.00  | 547.00   | 7701.00  | 4252.00  | 6650.00  | 1566.00  | 4644.00  | 7584.00  | 6715.00  | 5101.00  | 1991.00  | 3370.00  | 
    | [ContractNo]   | [AllocRef_AETL]    | 1               | 54582.00  | 5733.00  | 5074.00  | 3322.00  | 6465.00  | 4989.00  | 3577.00  | 5700.00  | 7282.00  | 4649.00  | 4596.00  | 2643.00  | 552.00   | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | [ContractNo]   | [AllocRef_AEAL]    | 1               | 57111.00  | 6990.00  | 547.00   | 7701.00  | 4252.00  | 6650.00  | 1566.00  | 4644.00  | 7584.00  | 6715.00  | 5101.00  | 1991.00  | 3370.00  | 
    | [ContractNo]   | [AllocRef_AETL]    | 1               | 54582.00  | 5733.00  | 5074.00  | 3322.00  | 6465.00  | 4989.00  | 3577.00  | 5700.00  | 7282.00  | 4649.00  | 4596.00  | 2643.00  | 552.00   | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    |
    | 10017711 | [ContractNo]   | [AllocRef_AEAL]    | 2372165           | 6990.00   | 547.00    | 7701.00   | 4252.00   | 6650.00   | 1566.00   | 4644.00   | 7584.00   | 6715.00   | 5101.00   | 1991.00   | 3370.00   | 
    | 10017711 | [ContractNo]   | [AllocRef_AETL]    | 2355870           | 5733.00   | 5074.00   | 3322.00   | 6465.00   | 4989.00   | 3577.00   | 5700.00   | 7282.00   | 4649.00   | 4596.00   | 2643.00   | 552.00    | 


    # Tidy Up
    Given the override date is reset

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017711'
         
@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run67 
Scenario: A712 Create a draft 1920 AEBP contract. Attempt a bulk new amendment for 2021. Fail: MBR-005. Approve 1920. Create and approve 2021 with linked master. Consume actuals. Cap 10%. Check CRM. Process PoP and PoA payments. Check feed and CDA
    Given there are no allocations marked as Under Termination for UKPRN '10017712' 
    And   there are no terminated or closed allocations for UKPRN '10017712' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017712' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017712' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-712      |
    | AEBR-712      |
    | AEAL-1712     |
    | AEBA-1712     |
    | AEBR-1712     |
    | AETL-1712     |
    | STFI-1712     |
    | AESO-1712     |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-712      |
    | AEBR-712      |
    | AEAL-1712     |
    | AEBA-1712     |
    | AEBR-1712     |
    | AETL-1712     |
    | STFI-1712     |
    | AESO-1712     |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | AEB-AS1920     |
    | AEB-19TRN1920  |
    | AEB-19TRLS2021 |
    | AEB-19TRN2021  |
    | AEB-AS2021     |
    | AEB-ASLS2021   |
    | STFI2021       |
    | AEB-CSO2021    |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017712' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017712 Co Ltd' with UKPRN '10017712' and OrgId 'ORG0017712' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017712' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017712 | 117712 | 10017712 Co Ltd | 0              | Active                | Yes           | AA017712      | ?             | 15 Wildgoose Drive     | ?                      | ?                      | ?                      | Horsham                | West Sussex            | RH12 1TU  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017712 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create a 1920 contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017712 | 10017712 Co Ltd      | ESFA-712             | AEBP-712       | 1                     | 01/08/2019        | 31/07/2020      | 40078.00      |                                       | Contract for Services                      | 1920   | New          | ORG0017712 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017712 | AEBP-712       | AEBA-712      | AEB-AS            | AEB-AS1920              | AY                      | 01/08/2019          | 31/07/2020        | 20101.00        |                                         |            |                                                             | New          |             |
    | 10017712 | AEBP-712       | AEBR-712      | AEB-19TRN         | AEB-19TRN1920           | AY                      | 01/08/2019          | 31/07/2020        | 19977.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017712 | AEBP-712       | AEBA-712      | 1               | 0                     | 20101.00  | 12315.00  | 7786.00   | 1032.00  | 978.00   | 2124.00  | 2386.00  | 2584.00  | 1991.00  | 69.00    | 1151.00  | 622.00   | 3192.00  | 1902.00  | 2070.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017712 | AEBP-712       | AEBR-712      | 1               | 0                     | 19977.00  | 14699.00  | 5278.00   | 1166.00  | 3197.00  | 3523.00  | 810.00   | 563.00   | 3039.00  | 296.00   | 2105.00  | 2115.00  | 351.00   | 959.00   | 1853.00  | 19-24 Traineeships Total Funding                                | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'AEBP-712' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-712'




    # Attempt to bulk create a 2021 EDSK contract while the 1920 contract is in draft. Fail MBR-005

    # Change the date
    Given the override date is '23/07/2020'

    # Bulk file (New Amendment)
    And   there are no files prefixed '10017712' in the Sharepoint 'AEB-2021-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 2021 17062020122450 v3_A712' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 2021 17062020122450 v3_A712' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 2021 17062020122450 v3_A712' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 2021 17062020122450 v3_A712' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 2021 17062020122450 v3_A712.xlsx' exists in the Datafiles folder and UKPRN '10017712' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

   # MBR-005
    And   '[Contract] This Master Contract cannot have more than one associated Contract in a draft status at the same time' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Approve the 1920 contract 
    
    # Change the date
    Given the override date is '24/07/2020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   # When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-712' and actual ContractNumber 'AEBP-712'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-712' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017712 | AEBP-712           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017712 | ESFA-712           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'AEBP-712'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AEBA-712        | 2372010          | Jul-20 | Reconciliation |
    | AEBR-712        | 2355800          | Jul-20 | Reconciliation |      
    



    # Create and approve 2021 contract
    
    # Change the date
    Given the override date is '01/07/2020'

    # Create a 2021 contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription   | ContractType            | Period | CRMIntent    | OrgId      |
    | 10017712 | 10017712 Co Ltd      | ESFA-712             | AEBP-1712      | 1                     | 01/08/2020        | 31/07/2021      | 191550.00     |                       | Contract for Services   | 2021   | New          | ORG0017712 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName     | UoPCode    | AllocationDescription   | CRMIntent    | DeliveryOrg |
    | 10017712 | AEBP-1712      | AEAL-1712     | AEB-ASLS          | AEB-ASLS2021            | AY                      | 01/08/2020          | 31/07/2021        | 22764.00        |             |            |                         | New          |             |
    | 10017712 | AEBP-1712      | AEBA-1712     | AEB-AS            | AEB-AS2021              | AY                      | 01/08/2020          | 31/07/2021        | 19996.00        |             |            |                         | New          |             |
    | 10017712 | AEBP-1712      | AEBR-1712     | AEB-19TRN         | AEB-19TRN2021           | AY                      | 01/08/2020          | 31/07/2021        | 21620.00        |             |            |                         | New          |             |
    | 10017712 | AEBP-1712      | AETL-1712     | AEB-19TRLS        | AEB-19TRLS2021          | AY                      | 01/08/2020          | 31/07/2021        | 27746.00        |             |            |                         | New          |             |
    | 10017712 | AEBP-1712      | STFI-1712     | STFI              | STFI2021                | AY                      | 01/08/2020          | 31/07/2021        | 83338.00        |             |            |                         | New          |             |
    | 10017712 | AEBP-1712      | AESO-1712     | AEB-CSO           | AEB-CSO2021             | AY                      | 01/08/2020          | 31/07/2021        | 16086.00        |             |            |                         | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017712 | AEBP-1712      | AEAL-1712     | 1               | 0                     | 22764.00  | 15450.00  | 7314.00   | 1682.00  | 1405.00  | 2235.00  | 3446.00  | 797.00   | 2324.00  | 1444.00  | 2117.00  | 100.00   | 3431.00  | 1825.00  | 1958.00  | Adult Education Budget - Adult Skills Learner Support           | New          |             | 
    | 10017712 | AEBP-1712      | AEBA-1712     | 1               | 0                     | 19996.00  | 12370.00  | 7626.00   | 3633.00  | 1365.00  | 1751.00  | 2329.00  | 1578.00  | 130.00   | 772.00   | 812.00   | 693.00   | 1049.00  | 2700.00  | 3184.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017712 | AEBP-1712      | AEBR-1712     | 1               | 0                     | 21620.00  | 14109.00  | 7511.00   | 1344.00  | 3504.00  | 727.00   | 672.00   | 1819.00  | 2080.00  | 2278.00  | 1685.00  | 3464.00  | 845.00   | 316.00   | 2886.00  | 19-24 Traineeships Total Funding                                | New          |             | 
    | 10017712 | AEBP-1712      | AETL-1712     | 1               | 0                     | 27746.00  | 17865.00  | 9881.00   | 2640.00  | 2807.00  | 569.00   | 2600.00  | 2926.00  | 213.00   | 3668.00  | 2442.00  | 3400.00  | 1508.00  | 1518.00  | 3455.00  | Adult Education Budget - 19-24 Traineeships Learner Support     | New          |             | 
    | 10017712 | AEBP-1712      | STFI-1712     | 1               | 0                     | 19519.00  | 12317.00  | 7202.00   | 959.00   | 302.00   | 1290.00  | 2026.00  | 801.00   | 776.00   | 3568.00  | 2595.00  | 831.00   | 2422.00  | 3316.00  | 633.00   | Short Term Funding Initiative 1                                 | New          |             | 
    | 10017712 | AEBP-1712      | STFI-1712     | 2               | 0                     | 19153.00  | 12980.00  | 6173.00   | 2916.00  | 455.00   | 3153.00  | 3445.00  | 1587.00  | 741.00   | 559.00   | 124.00   | 1428.00  | 1216.00  | 2837.00  | 692.00   | Short Term Funding Initiative 2                                 | New          |             | 
    | 10017712 | AEBP-1712      | STFI-1712     | 3               | 0                     | 25866.00  | 20578.00  | 5288.00   | 3304.00  | 3723.00  | 3447.00  | 576.00   | 803.00   | 1856.00  | 3383.00  | 3486.00  | 457.00   | 1159.00  | 788.00   | 2884.00  | Short Term Funding Initiative 3                                 | New          |             | 
    | 10017712 | AEBP-1712      | STFI-1712     | 4               | 0                     | 18800.00  | 14556.00  | 4244.00   | 2726.00  | 360.00   | 1792.00  | 3161.00  | 2756.00  | 2005.00  | 557.00   | 1199.00  | 1239.00  | 1120.00  | 1476.00  | 409.00   | Short Term Funding Initiative 4                                 | New          |             | 
    | 10017712 | AEBP-1712      | AESO-1712     | 1               | 0                     | 16086.00  | 10029.00  | 6057.00   | 2395.00  | 918.00   | 2633.00  | 206.00   | 2049.00  | 221.00   | 1021.00  | 586.00   | 1891.00  | 695.00   | 2316.00  | 1155.00  | High Value Courses for School and College Leavers Funding       | New          |             | 
    | 10017712 | AEBP-1712      | AESO-1712     | 2               | 1                     | 16086.00  | 10029.00  | 6057.00   | 2395.00  | 918.00   | 2633.00  | 206.00   | 2049.00  | 221.00   | 1021.00  | 586.00   | 1891.00  | 695.00   | 2316.00  | 1155.00  | High Value Courses for School and College Leavers Funding       | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'AEBP-712' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-1712'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-712' and actual ContractNumber 'AEBP-1712'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-1712' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017712 | AEBP-1712          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017712 | ESFA-712           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AETL-1712       | 2355875          | Jul-21 | Reconciliation |
    | AEBR-1712       | 2355800          | Jul-21 | Reconciliation |
    | AEBA-1712       | 2372010          | Jul-21 | Reconciliation |
    | AEAL-1712       | 2372175          | Jul-21 | Reconciliation |
    | STFI-1712       | 2374040          | Jul-21 | Reconciliation |
    | AESO-1712       | 2372092          | Jul-21 | Reconciliation |





    # Add actuals to the contract for AEB-19TRN2021, AEB-AS2021, STFI2021 and AEB-CSO2021

    # Change the date
    Given the override date is '04/10/2020'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber  | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202008 | AEB-19TRN2021           | AEBR-1712                 | ?          | 2               | 0            | 2894.14     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202008 | AEB-19TRN2021           | AEBR-1712                 | ?          | 3               | 0            | 5589.94     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202009 | AEB-19TRN2021           | AEBR-1712                 | ?          | 2               | 0            | 2992.29     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202009 | AEB-19TRN2021           | AEBR-1712                 | ?          | 3               | 0            | 9709.77     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202010 | AEB-19TRN2021           | AEBR-1712                 | ?          | 2               | 0            | 1002.51     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202010 | AEB-19TRN2021           | AEBR-1712                 | ?          | 3               | 0            | 2332.55     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202011 | AEB-19TRN2021           | AEBR-1712                 | ?          | 2               | 0            | 586.36      |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202011 | AEB-19TRN2021           | AEBR-1712                 | ?          | 3               | 0            | 1586.86     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202012 | AEB-19TRN2021           | AEBR-1712                 | ?          | 2               | 0            | 1718.33     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202012 | AEB-19TRN2021           | AEBR-1712                 | ?          | 3               | 0            | 1768.81     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202101 | AEB-19TRN2021           | AEBR-1712                 | ?          | 2               | 0            | 2251.44     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202101 | AEB-19TRN2021           | AEBR-1712                 | ?          | 3               | 0            | 1395.06     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202102 | AEB-19TRN2021           | AEBR-1712                 | ?          | 2               | 0            | 1008.38     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202102 | AEB-19TRN2021           | AEBR-1712                 | ?          | 3               | 0            | 1979.63     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202103 | AEB-19TRN2021           | AEBR-1712                 | ?          | 2               | 0            | 1601.04     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202103 | AEB-19TRN2021           | AEBR-1712                 | ?          | 3               | 0            | 1825.11     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202104 | AEB-19TRN2021           | AEBR-1712                 | ?          | 2               | 0            | 606.73      |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202104 | AEB-19TRN2021           | AEBR-1712                 | ?          | 3               | 0            | 1044.07     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202105 | AEB-19TRN2021           | AEBR-1712                 | ?          | 2               | 0            | 854.22      |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202105 | AEB-19TRN2021           | AEBR-1712                 | ?          | 3               | 0            | 551.03      |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202106 | AEB-19TRN2021           | AEBR-1712                 | ?          | 2               | 0            | 797.54      |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202106 | AEB-19TRN2021           | AEBR-1712                 | ?          | 3               | 0            | 1390.90     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202107 | AEB-19TRN2021           | AEBR-1712                 | ?          | 2               | 0            | 1780.95     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202107 | AEB-19TRN2021           | AEBR-1712                 | ?          | 3               | 0            | 794.22      |
    #
    | ILR2021        | R02                  | ORG0017712     | CM             | 202008 | AEB-AS2021              | AEBA-1712                 | ?          | 2               | 0            | 2022.89     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202008 | AEB-AS2021              | AEBA-1712                 | ?          | 3               | 0            | 775.15      |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202009 | AEB-AS2021              | AEBA-1712                 | ?          | 2               | 0            | 1272.35     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202009 | AEB-AS2021              | AEBA-1712                 | ?          | 3               | 0            | 1512.50     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202010 | AEB-AS2021              | AEBA-1712                 | ?          | 2               | 0            | 715.55      |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202010 | AEB-AS2021              | AEBA-1712                 | ?          | 3               | 0            | 579.69      |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202011 | AEB-AS2021              | AEBA-1712                 | ?          | 2               | 0            | 2136.10     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202011 | AEB-AS2021              | AEBA-1712                 | ?          | 3               | 0            | 714.16      |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202012 | AEB-AS2021              | AEBA-1712                 | ?          | 2               | 0            | 2456.88     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202012 | AEB-AS2021              | AEBA-1712                 | ?          | 3               | 0            | 2041.79     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202101 | AEB-AS2021              | AEBA-1712                 | ?          | 2               | 0            | 1316.64     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202101 | AEB-AS2021              | AEBA-1712                 | ?          | 3               | 0            | 1397.07     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202102 | AEB-AS2021              | AEBA-1712                 | ?          | 2               | 0            | 2059.53     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202102 | AEB-AS2021              | AEBA-1712                 | ?          | 3               | 0            | 904.65      |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202103 | AEB-AS2021              | AEBA-1712                 | ?          | 2               | 0            | 1740.57     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202103 | AEB-AS2021              | AEBA-1712                 | ?          | 3               | 0            | 1212.70     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202104 | AEB-AS2021              | AEBA-1712                 | ?          | 2               | 0            | 1975.35     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202104 | AEB-AS2021              | AEBA-1712                 | ?          | 3               | 0            | 1494.02     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202105 | AEB-AS2021              | AEBA-1712                 | ?          | 2               | 0            | 1586.93     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202105 | AEB-AS2021              | AEBA-1712                 | ?          | 3               | 0            | 1555.20     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202106 | AEB-AS2021              | AEBA-1712                 | ?          | 2               | 0            | 1828.15     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202106 | AEB-AS2021              | AEBA-1712                 | ?          | 3               | 0            | 1919.73     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202107 | AEB-AS2021              | AEBA-1712                 | ?          | 2               | 0            | 882.49      |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202107 | AEB-AS2021              | AEBA-1712                 | ?          | 3               | 0            | 2475.46     |
    #
    | ILR2021        | R02                  | ORG0017712     | CM             | 202008 | STFI2021                | STFI-1712                 | ?          | 5               | 0            | 2451.26     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202008 | STFI2021                | STFI-1712                 | ?          | 6               | 0            | 2870.87     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202008 | STFI2021                | STFI-1712                 | ?          | 7               | 0            | 1873.68     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202008 | STFI2021                | STFI-1712                 | ?          | 8               | 0            | 4699.06     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202008 | STFI2021                | STFI-1712                 | ?          | 9               | 0            | 1465.19     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202008 | STFI2021                | STFI-1712                 | ?          | 10              | 0            | 4308.79     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202008 | STFI2021                | STFI-1712                 | ?          | 11              | 0            | 2945.79     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202008 | STFI2021                | STFI-1712                 | ?          | 12              | 0            | 2650.15     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202009 | STFI2021                | STFI-1712                 | ?          | 5               | 0            | 1634.70     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202009 | STFI2021                | STFI-1712                 | ?          | 6               | 0            | 2756.90     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202009 | STFI2021                | STFI-1712                 | ?          | 7               | 0            | 1656.46     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202009 | STFI2021                | STFI-1712                 | ?          | 8               | 0            | 2078.13     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202009 | STFI2021                | STFI-1712                 | ?          | 9               | 0            | 4295.81     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202009 | STFI2021                | STFI-1712                 | ?          | 10              | 0            | 2663.47     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202009 | STFI2021                | STFI-1712                 | ?          | 11              | 0            | 2192.12     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202009 | STFI2021                | STFI-1712                 | ?          | 12              | 0            | 3829.96     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202010 | STFI2021                | STFI-1712                 | ?          | 5               | 0            | 2988.87     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202010 | STFI2021                | STFI-1712                 | ?          | 6               | 0            | 2163.61     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202010 | STFI2021                | STFI-1712                 | ?          | 7               | 0            | 4578.76     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202010 | STFI2021                | STFI-1712                 | ?          | 8               | 0            | 4733.95     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202010 | STFI2021                | STFI-1712                 | ?          | 9               | 0            | 3310.24     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202010 | STFI2021                | STFI-1712                 | ?          | 10              | 0            | 2824.52     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202010 | STFI2021                | STFI-1712                 | ?          | 11              | 0            | 1845.96     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202010 | STFI2021                | STFI-1712                 | ?          | 12              | 0            | 2807.54     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202011 | STFI2021                | STFI-1712                 | ?          | 5               | 0            | 3988.79     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202011 | STFI2021                | STFI-1712                 | ?          | 6               | 0            | 3715.86     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202011 | STFI2021                | STFI-1712                 | ?          | 7               | 0            | 4416.02     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202011 | STFI2021                | STFI-1712                 | ?          | 8               | 0            | 3290.19     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202011 | STFI2021                | STFI-1712                 | ?          | 9               | 0            | 1887.45     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202011 | STFI2021                | STFI-1712                 | ?          | 10              | 0            | 2905.04     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202011 | STFI2021                | STFI-1712                 | ?          | 11              | 0            | 2617.92     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202011 | STFI2021                | STFI-1712                 | ?          | 12              | 0            | 2401.10     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202012 | STFI2021                | STFI-1712                 | ?          | 5               | 0            | 4429.83     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202012 | STFI2021                | STFI-1712                 | ?          | 6               | 0            | 3077.55     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202012 | STFI2021                | STFI-1712                 | ?          | 7               | 0            | 2626.48     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202012 | STFI2021                | STFI-1712                 | ?          | 8               | 0            | 1622.10     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202012 | STFI2021                | STFI-1712                 | ?          | 9               | 0            | 3251.71     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202012 | STFI2021                | STFI-1712                 | ?          | 10              | 0            | 1482.24     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202012 | STFI2021                | STFI-1712                 | ?          | 11              | 0            | 3826.39     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202012 | STFI2021                | STFI-1712                 | ?          | 12              | 0            | 3005.43     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202101 | STFI2021                | STFI-1712                 | ?          | 5               | 0            | 1477.66     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202101 | STFI2021                | STFI-1712                 | ?          | 6               | 0            | 3801.68     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202101 | STFI2021                | STFI-1712                 | ?          | 7               | 0            | 3401.23     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202101 | STFI2021                | STFI-1712                 | ?          | 8               | 0            | 2006.50     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202101 | STFI2021                | STFI-1712                 | ?          | 9               | 0            | 2222.58     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202101 | STFI2021                | STFI-1712                 | ?          | 10              | 0            | 2547.39     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202101 | STFI2021                | STFI-1712                 | ?          | 11              | 0            | 1747.60     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202101 | STFI2021                | STFI-1712                 | ?          | 12              | 0            | 4241.84     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202102 | STFI2021                | STFI-1712                 | ?          | 5               | 0            | 4518.28     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202102 | STFI2021                | STFI-1712                 | ?          | 6               | 0            | 2480.27     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202102 | STFI2021                | STFI-1712                 | ?          | 7               | 0            | 2114.13     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202102 | STFI2021                | STFI-1712                 | ?          | 8               | 0            | 3471.75     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202102 | STFI2021                | STFI-1712                 | ?          | 9               | 0            | 3364.98     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202102 | STFI2021                | STFI-1712                 | ?          | 10              | 0            | 3955.80     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202102 | STFI2021                | STFI-1712                 | ?          | 11              | 0            | 4465.59     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202102 | STFI2021                | STFI-1712                 | ?          | 12              | 0            | 3308.25     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202103 | STFI2021                | STFI-1712                 | ?          | 5               | 0            | 3807.97     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202103 | STFI2021                | STFI-1712                 | ?          | 6               | 0            | 3594.43     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202103 | STFI2021                | STFI-1712                 | ?          | 7               | 0            | 3471.88     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202103 | STFI2021                | STFI-1712                 | ?          | 8               | 0            | 3447.78     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202103 | STFI2021                | STFI-1712                 | ?          | 9               | 0            | 2839.10     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202103 | STFI2021                | STFI-1712                 | ?          | 10              | 0            | 2376.86     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202103 | STFI2021                | STFI-1712                 | ?          | 11              | 0            | 3822.19     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202103 | STFI2021                | STFI-1712                 | ?          | 12              | 0            | 3229.11     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202104 | STFI2021                | STFI-1712                 | ?          | 5               | 0            | 1823.35     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202104 | STFI2021                | STFI-1712                 | ?          | 6               | 0            | 4664.34     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202104 | STFI2021                | STFI-1712                 | ?          | 7               | 0            | 3363.98     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202104 | STFI2021                | STFI-1712                 | ?          | 8               | 0            | 2716.08     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202104 | STFI2021                | STFI-1712                 | ?          | 9               | 0            | 3250.45     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202104 | STFI2021                | STFI-1712                 | ?          | 10              | 0            | 1544.01     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202104 | STFI2021                | STFI-1712                 | ?          | 11              | 0            | 3467.07     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202104 | STFI2021                | STFI-1712                 | ?          | 12              | 0            | 4605.46     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202105 | STFI2021                | STFI-1712                 | ?          | 5               | 0            | 1711.36     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202105 | STFI2021                | STFI-1712                 | ?          | 6               | 0            | 4499.21     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202105 | STFI2021                | STFI-1712                 | ?          | 7               | 0            | 3712.73     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202105 | STFI2021                | STFI-1712                 | ?          | 8               | 0            | 3759.72     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202105 | STFI2021                | STFI-1712                 | ?          | 9               | 0            | 2099.88     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202105 | STFI2021                | STFI-1712                 | ?          | 10              | 0            | 4004.77     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202105 | STFI2021                | STFI-1712                 | ?          | 11              | 0            | 4007.70     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202105 | STFI2021                | STFI-1712                 | ?          | 12              | 0            | 3964.88     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202106 | STFI2021                | STFI-1712                 | ?          | 5               | 0            | 2339.21     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202106 | STFI2021                | STFI-1712                 | ?          | 6               | 0            | 1547.33     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202106 | STFI2021                | STFI-1712                 | ?          | 7               | 0            | 4223.27     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202106 | STFI2021                | STFI-1712                 | ?          | 8               | 0            | 2513.29     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202106 | STFI2021                | STFI-1712                 | ?          | 9               | 0            | 3333.52     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202106 | STFI2021                | STFI-1712                 | ?          | 10              | 0            | 2870.70     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202106 | STFI2021                | STFI-1712                 | ?          | 11              | 0            | 4659.36     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202106 | STFI2021                | STFI-1712                 | ?          | 12              | 0            | 2011.51     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202107 | STFI2021                | STFI-1712                 | ?          | 5               | 0            | 3244.47     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202107 | STFI2021                | STFI-1712                 | ?          | 6               | 0            | 2146.08     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202107 | STFI2021                | STFI-1712                 | ?          | 7               | 0            | 4033.54     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202107 | STFI2021                | STFI-1712                 | ?          | 8               | 0            | 3213.01     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202107 | STFI2021                | STFI-1712                 | ?          | 9               | 0            | 2492.82     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202107 | STFI2021                | STFI-1712                 | ?          | 10              | 0            | 3267.45     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202107 | STFI2021                | STFI-1712                 | ?          | 11              | 0            | 1595.13     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202107 | STFI2021                | STFI-1712                 | ?          | 12              | 0            | 1976.08     |
    #
    | ILR2021        | R02                  | ORG0017712     | CM             | 202008 | AEB-CSO2021             | AESO-712                  | ?          | 3               | 0            | 1388.56     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202008 | AEB-CSO2021             | AESO-712                  | ?          | 4               | 0            | 3893.51     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202009 | AEB-CSO2021             | AESO-712                  | ?          | 3               | 0            | 1156.82     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202009 | AEB-CSO2021             | AESO-712                  | ?          | 4               | 0            | 3844.96     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202010 | AEB-CSO2021             | AESO-712                  | ?          | 3               | 0            | 3908.79     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202010 | AEB-CSO2021             | AESO-712                  | ?          | 4               | 0            | 1645.10     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202011 | AEB-CSO2021             | AESO-712                  | ?          | 3               | 0            | 1715.28     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202011 | AEB-CSO2021             | AESO-712                  | ?          | 4               | 0            | 3479.89     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202012 | AEB-CSO2021             | AESO-712                  | ?          | 3               | 0            | 1823.09     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202012 | AEB-CSO2021             | AESO-712                  | ?          | 4               | 0            | 3194.91     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202101 | AEB-CSO2021             | AESO-712                  | ?          | 3               | 0            | 2937.69     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202101 | AEB-CSO2021             | AESO-712                  | ?          | 4               | 0            | 3947.18     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202102 | AEB-CSO2021             | AESO-712                  | ?          | 3               | 0            | 3767.66     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202102 | AEB-CSO2021             | AESO-712                  | ?          | 4               | 0            | 3071.92     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202103 | AEB-CSO2021             | AESO-712                  | ?          | 3               | 0            | 1924.58     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202103 | AEB-CSO2021             | AESO-712                  | ?          | 4               | 0            | 2882.76     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202104 | AEB-CSO2021             | AESO-712                  | ?          | 3               | 0            | 2022.19     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202104 | AEB-CSO2021             | AESO-712                  | ?          | 4               | 0            | 2874.46     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202105 | AEB-CSO2021             | AESO-712                  | ?          | 3               | 0            | 1568.46     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202105 | AEB-CSO2021             | AESO-712                  | ?          | 4               | 0            | 1546.57     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202106 | AEB-CSO2021             | AESO-712                  | ?          | 3               | 0            | 1994.36     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202106 | AEB-CSO2021             | AESO-712                  | ?          | 4               | 0            | 3817.08     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202107 | AEB-CSO2021             | AESO-712                  | ?          | 3               | 0            | 2913.22     |
    | ILR2021        | R02                  | ORG0017712     | CM             | 202107 | AEB-CSO2021             | AESO-712                  | ?          | 4               | 0            | 3744.48     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service




    # Check CRM subnominals (to slow things down a little)

    # Check the RECONCILIATION subnominal aggregations in CRM
    Then  the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Sep-20    |
    | 10017712 | AEBP-171       | AEAL-1712          | 2372175                  | 0.00      | 
    | 10017712 | AEBP-171       | AEBA-1712          | 2372010                  | 3295.24   | 
    | 10017712 | AEBP-171       | AEBA-1712          | 2372060                  | 2287.65   | 
    | 10017712 | AEBP-171       | AEBR-1712          | 2355800                  | 5886.43   | 
    | 10017712 | AEBP-171       | AEBR-1712          | 2355860                  | 15299.71  | 
    | 10017712 | AEBP-171       | AESO-1712          | 2372092                  | 10283.85  | 
    | 10017712 | AEBP-171       | AETL-1712          | 2355875                  | 0.00      | 
    | 10017712 | AEBP-171       | STFI-1712          | 2374010                  | 9713.73   | 
    | 10017712 | AEBP-171       | STFI-1712          | 2374020                  | 10307.33  | 
    | 10017712 | AEBP-171       | STFI-1712          | 2374030                  | 12733.26  | 
    | 10017712 | AEBP-171       | STFI-1712          | 2374040                  | 11618.02  | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Sep-20    |
    | 10017712 | AEBP-171       | AEBA-1712          | 2372016                  | 0.00      | 
    | 10017712 | AEBP-171       | AEBR-1712          | 2355816                  | -5666.24  | 
    | 10017712 | AEBP-171       | AESO-1712          | 2372092                  | -254.85   | 
    | 10017712 | AEBP-171       | STFI-1712          | 2374010                  | 0.00      | 
    | 10017712 | AEBP-171       | STFI-1712          | 2374020                  | 0.00      | 
    | 10017712 | AEBP-171       | STFI-1712          | 2374030                  | 0.00      | 
    | 10017712 | AEBP-171       | STFI-1712          | 2374040                  | 0.00      | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    |
    | 10017712 | AEBP-171       | AEAL-1712          | 2372165                  | 1682.00   | 1405.00   | 2235.00   | 3446.00   | 797.00    | 2324.00   | 1444.00   | 2117.00   | 100.00    | 3431.00   | 1825.00   | 1958.00   | 
    | 10017712 | AEBP-171       | AETL-1712          | 2355870                  | 2640.00   | 2807.00   | 569.00    | 2600.00   | 2926.00   | 213.00    | 3668.00   | 2442.00   | 3400.00   | 1508.00   | 1518.00   | 3455.00   | 





    # Payment Batch for PoP allocations (AEB-19TRLS2021 and AEB-ASLS2021)

    # Change the date
    Given the override date is '04/09/2020 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete specific rows from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEB-19TRLS2021' AccountingPaymentPeriod '202006' CensusEndDate '04/09/2020' and LinkCodeSuffix 'A'
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEB-ASLS2021' AccountingPaymentPeriod '202006' CensusEndDate '04/09/2020' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | AETL-1712                | 202009 |
    | AEAL-1712                | 202009 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEB-19TRLS2021             | 202009               |                      | A              | NotStarted |
    | AEB-ASLS2021               | 202009               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEB-19TRLS2021             | 202009               | Completed |
    | AEB-ASLS2021               | 202009               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-19TRLS2021' PaymentPeriod '202006' CensusEndDate '04/09/2020' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A712_AEB-19TRLS2021.xml'
    And   the Payment feed xml for FundingStreamPeriod 'AEB-ASLS2021' PaymentPeriod '202006' CensusEndDate '04/09/2020' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A712_AEB-ASLS2021.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-19TRLS2021' PaymentPeriod '202006' CensusEndDate '04/09/2020' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AERL                   | 2020          | 06             | 04          | ?       | AETL-1712     | 2807.00         | PROFILE          | 19-24TrnContractLS                 | 2020-09-18 | 2020-08-01   | 2021-07-31 | ?              | 10017712 | 2355870    |

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-ASLS2021' PaymentPeriod '202006' CensusEndDate '04/09/2020' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AEAL                   | 2020          | 06             | 08          | ?       | AEAL-1712     | 1405.00         | PROFILE          | AEBContractASLS                    | 2020-09-18 | 2020-08-01   | 2021-07-31 | ?              | 10017712 | 2372165    |




    # Payment Batch for PoA allocations (AEB-19TRN2021, AEB-AS2021, STFI2021 and AEB-CSO2021)

    # Change the date
    Given the override date is '08/10/2020 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete specific rows from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEB-19TRN2021' AccountingPaymentPeriod '202006' CensusEndDate '08/10/2020' and LinkCodeSuffix 'A'
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEB-AS2021' AccountingPaymentPeriod '202006' CensusEndDate '08/10/2020' and LinkCodeSuffix 'A'
    And   there is no data in the Payment feed for FundingStreamPeriod 'STFI2021' AccountingPaymentPeriod '202006' CensusEndDate '08/10/2020' and LinkCodeSuffix 'A'
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEB-CSO2021' AccountingPaymentPeriod '202006' CensusEndDate '08/10/2020' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | AEBA-1712                | 202009 |
    | AEBR-1712                | 202009 |
    | STFI-1712                | 202009 |
    | AESO-1712                | 202009 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEB-19TRN2021              | 202009               |                      | A              | NotStarted |
    | AEB-AS2021                 | 202009               |                      | A              | NotStarted |
    | STFI2021                   | 202009               |                      | A              | NotStarted |
    | AEB-CSO2021                | 202009               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEB-19TRN2021              | 202009               | Completed |
    | AEB-AS2021                 | 202009               | Completed |
    | STFI2021                   | 202009               | Completed |
    | AEB-CSO2021                | 202009               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-19TRN2021' PaymentPeriod '202006' CensusEndDate '08/10/2020' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A712_AEB-19TRN2021.xml'
    And   the Payment feed xml for FundingStreamPeriod 'AEB-AS2021' PaymentPeriod '202006' CensusEndDate '08/10/2020' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A712_AEB-AS2021.xml'
    And   the Payment feed xml for FundingStreamPeriod 'STFI2021' PaymentPeriod '202006' CensusEndDate '08/10/2020' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A712_STFI2021.xml'
    And   the Payment feed xml for FundingStreamPeriod 'AEB-CSO2021' PaymentPeriod '202006' CensusEndDate '08/10/2020' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A712_AEB-CSO2021.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-19TRN2021' PaymentPeriod '202006' CensusEndDate '08/10/2020' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AEBR                   | 2020          | 06             | 08          | ?       | AEBR-1712     | 5886.43         | RECONCILIATION   | 19-24 Traineeships                 | 2020-10-20 | 2020-08-01   | 2021-07-31 | ?              | 10017712 | 2355800    |
    | AEBR                   | 2020          | 06             | 08          | ?       | AEBR-1712     | 15299.71        | RECONCILIATION   | 19-24TraineeshpsLngS               | 2020-10-20 | 2020-08-01   | 2021-07-31 | ?              | 10017712 | 2355860    |
    | AEBR                   | 2020          | 06             | 08          | ?       | AEBR-1712     | -5666.24        | CAPPING          | AEB 19-24 Traineeshp               | 2020-10-20 | 2020-08-01   | 2021-07-31 | ?              | 10017712 | 2355816    |

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-AS2021' PaymentPeriod '202006' CensusEndDate '08/10/2020' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AEBA                   | 2020          | 06             | 08          | ?       | AEBA-1712     | 3295.24         | RECONCILIATION   | AEB Other Learning                 | 2020-10-20 | 2020-08-01   | 2021-07-31 | ?              | 10017712 | 2372010    |
    | AEBA                   | 2020          | 06             | 08          | ?       | AEBA-1712     | 2287.65         | RECONCILIATION   | AEB OthLearning LngS               | 2020-10-20 | 2020-08-01   | 2021-07-31 | ?              | 10017712 | 2372060    |

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'STFI2021' PaymentPeriod '202006' CensusEndDate '08/10/2020' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | STFI                   | 2020          | 06             | 08          | ?       | STFI-1712     | 9713.73         | RECONCILIATION   | ShortTermInit1Cntrct               | 2020-10-20 | 2020-08-01   | 2021-07-31 | ?              | 10017712 | 2374010    |
    | STFI                   | 2020          | 06             | 08          | ?       | STFI-1712     | 10307.33        | RECONCILIATION   | ShortTermInit2Cntrct               | 2020-10-20 | 2020-08-01   | 2021-07-31 | ?              | 10017712 | 2374020    |
    | STFI                   | 2020          | 06             | 08          | ?       | STFI-1712     | 12733.26        | RECONCILIATION   | ShortTermInit3Cntrct               | 2020-10-20 | 2020-08-01   | 2021-07-31 | ?              | 10017712 | 2374030    |
    | STFI                   | 2020          | 06             | 08          | ?       | STFI-1712     | 11618.02        | RECONCILIATION   | ShortTermInit4Cntrct               | 2020-10-20 | 2020-08-01   | 2021-07-31 | ?              | 10017712 | 2374040    |

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-CSO2021' PaymentPeriod '202006' CensusEndDate '08/10/2020' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AESO                   | 2020          | 06             | 08          | ?       | AESO-1712     | 10283.85        | RECONCILIATION   | C19SkillsOfferCntrct               | 2020-10-20 | 2020-08-01   | 2021-07-31 | ?              | 10017712 | 2372092    |




    # Run the CDA report for the four 2021 AEBP FSPs
    Given there is no CDA report named 'CDA Latest Version A712.csv'
    And   the following ADF Pipeline run
    And   the following CDA report is run
    | FundingStreamPeriod                                                       | Version         | Suffix |
    | AEB-19TRLS2021,AEB-19TRN2021,AEB-AS2021,AEB-ASLS2021,STFI2021,AEB-CSO2021 | Latest Version  | A712   |

    Then  a report named 'CDA Latest Version A712.csv' is created

    # Check the contents of the CDA report for the September payments
    And   the following rows are present in the report
    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                          | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
    | AEB-19TRLS2021          | 10017712 | 10017712 Co Ltd             |               |                             | AETL-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                |                                                      | Adult Education Budget - 19-24 Traineeships Learner Support          |                                                                 | 9                 | 2020            | 2020/21       |              | 2807         |              | 0             |              | Yes                | 2807.00        |                  | 0.00                  | 0.00           | 2807.00         |             | Yes           |                   |        | 2355870           | 2355875                  |                   | Sep              |
    | AEB-19TRN2021           | 10017712 | 10017712 Co Ltd             |               |                             | AEBR-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                                  | 19-24 Traineeships Total Funding                                | 9                 | 2020            | 2020/21       |              | 0            | 9709.77      | 0             |              | Yes                | 0.00           | 0.00             | 15299.71              | -4091.91       | 11207.80        |             | Yes           |                   |        |                   | 2355860                  | 2355816           | Sep              |
    | AEB-19TRN2021           | 10017712 | 10017712 Co Ltd             |               |                             | AEBR-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                                 | 19-24 Traineeships Total Funding                                | 9                 | 2020            | 2020/21       |              | 0            | 2992.29      | 0             |              | Yes                | 0.00           | 0.00             | 5886.43               | -1574.33       | 4312.10         |             | Yes           |                   |        |                   | 2355800                  | 2355816           | Sep              |
    | AEB-19TRN2021           | 10017712 | 10017712 Co Ltd             |               |                             | AEBR-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                     |                                                                 | 9                 | 2020            | 2020/21       |              | 3504         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
    | AEB-AS2021              | 10017712 | 10017712 Co Ltd             |               |                             | AEBA-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | Adult Skills Learning Support                        | Adult Skills Learning Support                                        | Adult Skills Total Funding                                      | 9                 | 2020            | 2020/21       |              | 0            | 1512.5       | 0             |              | Yes                | 0.00           | 0.00             | 2287.65               | 0.00           | 2287.65         |             | Yes           |                   |        |                   | 2372060                  | 2372016           | Sep              |
    | AEB-AS2021              | 10017712 | 10017712 Co Ltd             |               |                             | AEBA-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | Adult Skills Programme Funding                       | Adult Skills Programme Funding                                       | Adult Skills Total Funding                                      | 9                 | 2020            | 2020/21       |              | 0            | 1272.35      | 0             |              | Yes                | 0.00           | 0.00             | 3295.24               | 0.00           | 3295.24         |             | Yes           |                   |        |                   | 2372010                  | 2372016           | Sep              |
    | AEB-AS2021              | 10017712 | 10017712 Co Ltd             |               |                             | AEBA-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                |                                                      | Adult Skills Total Funding                                           |                                                                 | 9                 | 2020            | 2020/21       |              | 1365         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
    | AEB-ASLS2021            | 10017712 | 10017712 Co Ltd             |               |                             | AEAL-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                |                                                      | Adult Education Budget - Adult Skills Learner Support                |                                                                 | 9                 | 2020            | 2020/21       |              | 1405         |              | 0             |              | Yes                | 1405.00        |                  | 0.00                  | 0.00           | 1405.00         |             | Yes           |                   |        | 2372165           | 2372175                  |                   | Sep              |
    | AEB-CSO2021             | 10017712 | 10017712 Co Ltd             |               |                             | AESO-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | COVID-19 Skills Offer Learning Support               | COVID-19 Skills Offer Learning Support                               | High Value Courses for School and College Leavers Funding       | 9                 | 2020            | 2020/21       |              | 0            | 3844.96      | 0             |              | Yes                | 0.00           | 0.00             | 7738.47               | -191.77        | 7546.70         |             | Yes           |                   |        |                   | 2372092                  | 2372092           | Sep              |
    | AEB-CSO2021             | 10017712 | 10017712 Co Ltd             |               |                             | AESO-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | COVID-19 Skills Offer Programme Funding              | COVID-19 Skills Offer Programme Funding                              | High Value Courses for School and College Leavers Funding       | 9                 | 2020            | 2020/21       |              | 0            | 1156.82      | 0             |              | Yes                | 0.00           | 0.00             | 2545.38               | -63.08         | 2482.30         |             | Yes           |                   |        |                   | 2372092                  | 2372092           | Sep              |
    | AEB-CSO2021             | 10017712 | 10017712 Co Ltd             |               |                             | AESO-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                |                                                      | High Value Courses for School and College Leavers Funding            | High Value Courses for School and College Leavers Funding       | 9                 | 2020            | 2020/21       |              | 918          |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
    | STFI2021                | 10017712 | 10017712 Co Ltd             |               |                             | STFI-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 1                                      |                                                                 | 9                 | 2020            | 2020/21       |              | 302          |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
    | STFI2021                | 10017712 | 10017712 Co Ltd             |               |                             | STFI-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | Short Term Funding Initiative 1 Learning Support     | Short Term Funding Initiative 1 Learning Support                     | Short Term Funding Initiative 1                                 | 9                 | 2020            | 2020/21       |              | 0            | 2756.9       | 0             |              | Yes                | 0.00           | 0.00             | 5627.77               | 0.00           | 5627.77         |             | Yes           |                   |        |                   | 2374010                  | 2374010           | Sep              |
    | STFI2021                | 10017712 | 10017712 Co Ltd             |               |                             | STFI-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | Short Term Funding Initiative 1 Programme Funding    | Short Term Funding Initiative 1 Programme Funding                    | Short Term Funding Initiative 1                                 | 9                 | 2020            | 2020/21       |              | 0            | 1634.7       | 0             |              | Yes                | 0.00           | 0.00             | 4085.96               | 0.00           | 4085.96         |             | Yes           |                   |        |                   | 2374010                  | 2374010           | Sep              |
    | STFI2021                | 10017712 | 10017712 Co Ltd             |               |                             | STFI-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 2                                      |                                                                 | 9                 | 2020            | 2020/21       |              | 455          |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
    | STFI2021                | 10017712 | 10017712 Co Ltd             |               |                             | STFI-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | Short Term Funding Initiative 2 Learning Support     | Short Term Funding Initiative 2 Learning Support                     | Short Term Funding Initiative 2                                 | 9                 | 2020            | 2020/21       |              | 0            | 2078.13      | 0             |              | Yes                | 0.00           | 0.00             | 6777.19               | 0.00           | 6777.19         |             | Yes           |                   |        |                   | 2374020                  | 2374020           | Sep              |
    | STFI2021                | 10017712 | 10017712 Co Ltd             |               |                             | STFI-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | Short Term Funding Initiative 2 Programme Funding    | Short Term Funding Initiative 2 Programme Funding                    | Short Term Funding Initiative 2                                 | 9                 | 2020            | 2020/21       |              | 0            | 1656.46      | 0             |              | Yes                | 0.00           | 0.00             | 3530.14               | 0.00           | 3530.14         |             | Yes           |                   |        |                   | 2374020                  | 2374020           | Sep              |
    | STFI2021                | 10017712 | 10017712 Co Ltd             |               |                             | STFI-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 3                                      |                                                                 | 9                 | 2020            | 2020/21       |              | 3723         |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
    | STFI2021                | 10017712 | 10017712 Co Ltd             |               |                             | STFI-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | Short Term Funding Initiative 3 Learning Support     | Short Term Funding Initiative 3 Learning Support                     | Short Term Funding Initiative 3                                 | 9                 | 2020            | 2020/21       |              | 0            | 2663.47      | 0             |              | Yes                | 0.00           | 0.00             | 6972.26               | 0.00           | 6972.26         |             | Yes           |                   |        |                   | 2374030                  | 2374030           | Sep              |
    | STFI2021                | 10017712 | 10017712 Co Ltd             |               |                             | STFI-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | Short Term Funding Initiative 3 Programme Funding    | Short Term Funding Initiative 3 Programme Funding                    | Short Term Funding Initiative 3                                 | 9                 | 2020            | 2020/21       |              | 0            | 4295.81      | 0             |              | Yes                | 0.00           | 0.00             | 5761.00               | 0.00           | 5761.00         |             | Yes           |                   |        |                   | 2374030                  | 2374030           | Sep              |
    | STFI2021                | 10017712 | 10017712 Co Ltd             |               |                             | STFI-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 4                                      |                                                                 | 9                 | 2020            | 2020/21       |              | 360          |              | 0             |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
    | STFI2021                | 10017712 | 10017712 Co Ltd             |               |                             | STFI-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | Short Term Funding Initiative 4 Learning Support     | Short Term Funding Initiative 4 Learning Support                     | Short Term Funding Initiative 4                                 | 9                 | 2020            | 2020/21       |              | 0            | 3829.96      | 0             |              | Yes                | 0.00           | 0.00             | 6480.11               | 0.00           | 6480.11         |             | Yes           |                   |        |                   | 2374040                  | 2374040           | Sep              |
    | STFI2021                | 10017712 | 10017712 Co Ltd             |               |                             | STFI-1712                | AEBP-1712      | ESFA-712                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                | Short Term Funding Initiative 4 Programme Funding    | Short Term Funding Initiative 4 Programme Funding                    | Short Term Funding Initiative 4                                 | 9                 | 2020            | 2020/21       |              | 0            | 2192.12      | 0             |              | Yes                | 0.00           | 0.00             | 5137.91               | 0.00           | 5137.91         |             | Yes           |                   |        |                   | 2374040                  | 2374040           | Sep              |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
Scenario: A096 Bulk create a new 2021 AEB contract with all 6 allocs. Check docs. (To help with manual checking)
    Given there are no allocations marked as Under Termination for UKPRN '10017096' 
    And   there are no terminated or closed allocations for UKPRN '10017096' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017096' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017096' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017096 Co Ltd' with UKPRN '10017096' and OrgId 'ORG0017096' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017096' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017096 | 117096 | 10017096 Co Ltd | 0              | Active                | Yes           | AA017096      | ?             | 41 Gallish Terrace     | Brookmans Way          | ?                      | ?                      | Hatfield               | Hertfordshire          | AL9 7RT   |
    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017096 |


    

    # Change the date
    Given the override date is '23/08/2020'

    # Bulk file
    And   there are no files prefixed '10017096' in the Sharepoint 'AEB-2021-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 2021 13072020090104 v3_A096' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 2021 13072020090104 v3_A096' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 2021 13072020090104 v3_A096' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 2021 13072020090104 v3_A096' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 2021 13072020090104 v3_A096.xlsx' exists in the Datafiles folder and UKPRN '10017096' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017096' for FundingType 'AEB' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017096' for FundingType 'AEB' and period '2021'

    # Check the contents of the Appendices
    Then  the file named '10017096_[ContractNo]_v1.pdf' in Sharepoint location 'AEB-2021-Input-Appendices' contains the following lines in order
    """
    ESFA AEB - COVID-19 Skills Offer [AllocRef_AESO] £32,719 £22,188 £54,907
    of which High Value Courses for School and College
    £32,719 £22,188 £54,907
    Leavers

    Funding Agreement ESFA-Funded Adult Education Budget - COVID-19 Skills Offer
    Provider: 10017096 Co Ltd UKPRN: 10017096
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_AESO]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - High Value Courses for School and £54,907 £0 £3,329 £7,087 £7,989 £7,394 £1,227 £1,716 £3,977 £7,257 £7,479 £4,972 £2,480
    College Leavers
    Total Funding £54,907 £0 £3,329 £7,087 £7,989 £7,394 £1,227 £1,716 £3,977 £7,257 £7,479 £4,972 £2,480
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
Scenario: A030 Bulk create a 2021 AEBP contract with an AEB-AS2021 alloc. Check SoF doc. Approve. Delete Sector-based params. Issue NFA. Check SoF doc. (To help with manual checking)
    Given there are no allocations marked as Under Termination for UKPRN '10017030' 
    And   there are no terminated or closed allocations for UKPRN '10017030' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017030' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017030' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-030      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-AS2021        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017030'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017030' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017030 Co Ltd' with UKPRN '10017030' and OrgId 'ORG0017030' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017030' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017030 | 117030 | 10017030 Co Ltd | 0              | Active                | Yes           | AA017030      | ?             | 1 Sycamore Road        | ?                      | ?                      | ?                      | Amersham               | Buckinghamshire        | HP6 5ED   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017030 |




    # Upsert the provider config values for Sector-based Work Academies for a specific UKPRN and FSP (DocumentsDomain.ContractReferenceConfig) (30680)
    #   The AEBC-ASCL2021 params should not be picked up as they relate to EDSK 
    Given the following Sector-based Work Academies profile values exist in config
    | UKPRN    | FSPCode       | Aug20-Mar21 | Apr21-Jul21 |
    | 10017030 | AEB-AS2021    | 800.00      | 400.00      |
    | 10017030 | AEBC-ASCL2021 | 999.00      | 999.00      |




    # Change the date
    Given the override date is '22/07/2020'

    # Bulk file
    And   there are no files prefixed '10017030' in the Sharepoint 'AEB-2021-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 2021 28072020221805 v3_A030' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 2021 28072020221805 v3_A030' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 2021 28072020221805 v3_A030' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 2021 28072020221805 v3_A030' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 2021 28072020221805 v3_A030.xlsx' exists in the Datafiles folder and UKPRN '10017030' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017030' for FundingType 'AEB' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017030' for FundingType 'AEB' and period '2021'

    # Check the contents of the Appendices
    Then  the file named '10017030_[ContractNo]_v1.pdf' in Sharepoint location 'AEB-2021-Input-Appendices' contains the following lines in order
   #Then  the file named '10017030_AEBP-030_v1.pdf' in Sharepoint location 'AEB-2021-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017030 Co Ltd UKPRN: 10017030
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    ESFA AEB - Adult Skills [AllocRef_AEBA] £28,291 £13,467 £41,758
    of which Sector-based Work Academies £800 £400 £1,200
    Total: £41,758
    """ 

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017030_[ContractNo]_v1.pdf' in 'AEB-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A030.pdf'




    # Change the date
    Given the override date is '25/07/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017030 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017030 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'AEBP-030'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_AEBA] | 2372010          | Jul-21 | Reconciliation |




    # Execute a NON-FINANCIAL amendment on 2021 AEBP after removing the Sector-based Work Academy parameter vales then check docs

    # Change the date
    Given the override date is '27/07/2020'

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017030'

    # Issue a non-financial VARIATION amendment on v1 to create v2
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '1' of contract 'AEBP-030' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017030 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017030 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017030 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017030' for FundingType 'AEB' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017030' for FundingType 'AEB' and period '2021'

    # Check the contents of the Appendices
    Then  the file named '10017030_[ContractNo]_v2.pdf' in Sharepoint location 'AEB-2021-Input-Appendices' contains the following lines in order
   #Then  the file named '10017030_AEBP-030_v1.pdf' in Sharepoint location 'AEB-2021-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017030 Co Ltd UKPRN: 10017030
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    ESFA AEB - Adult Skills [AllocRef_AEBA] £28,291 £13,467 £41,758
    of which Sector-based Work Academies £0 £0 £0
    Total: £41,758
    """ 


    # Tidy Up
    Given the override date is reset

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017030'
        
@AcceptanceTest @Withdrawn20231002
Scenario: A720 Create a 2021 AEB contract with AEB-19TRN2021 alloc. Consume actuals for R12. Check financials, allowing over-delivery of 30%
    Given there are no allocations marked as Under Termination for UKPRN '10017720' 
    And   there are no terminated or closed allocations for UKPRN '10017720' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017720' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017720' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017720' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBR-720      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBR-720      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-19TRN2021     |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP-720       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017720'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017720' 
    And   there is no caseload advisor for UKPRN '10017720' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017720 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017720' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017720 Co Ltd' with UKPRN '10017720' and OrgId 'ORG0017720' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017720 | 117720 | 10017720 Co Ltd | 0              | Locked Restructure    | Yes           | AA017720      | ?             | 288 Baldwins Lane      | Hall Green             | ?                      | ?                      | Birmingham             | West Midlands          | B28 0XB   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017720 |





    # Change the date
    Given the override date is '01/07/2020'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP-720'
    And   there are no details in ContractManagement.CreatedContract for 'AEBP-720'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017720 | 10017720 Co Ltd      | ESFA-720             | AEBP-720       | 1                     | 01/08/2020        | 31/07/2021      | 19433.00      |                                       | Procured                                   | 2021   | New          | ORG0017720 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017720 | AEBP-720       | AEBR-720      | AEB-19TRN         | AEB-19TRN2021           | AY                      | 01/08/2020          | 31/07/2021        | 19433.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017720 | AEBP-720       | AEBR-720      | 1               | 0                     | 19433.00  | 11869.00  | 7564.00   | 1246.00  | 559.00   | 3603.00  | 890.00   | 1626.00  | 401.00   | 376.00   | 3168.00  | 2195.00  | 431.00   | 2022.00  | 2916.00  | 19-24 Traineeships Total Funding                                | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-720'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-720' and actual ContractNumber 'AEBP-720'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-720' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017720 | AEBP-720           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017720 | ESFA-720           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP-720' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'AEBP-720'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AEBR-720        | 2355800          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10017720 | AEBP-720       | 1               | AEBR-720      | 1               | 0                     | 19433.00     | 0             | 0        | 19-24 Traineeships Total Funding                                | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP-720' agree with the most recent entry for this contract in the ContractManagement feed





    # Add actuals to the contract

    # Change the date
    Given the override date is '04/08/2021'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017720'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jul 2021
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202008 | AEB-19TRN2021           | AEBR-720                 | ?          | 2               | 0            | 1462.80     |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202008 | AEB-19TRN2021           | AEBR-720                 | ?          | 3               | 0            | 1988.08     |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202009 | AEB-19TRN2021           | AEBR-720                 | ?          | 2               | 0            | 1398.04     |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202009 | AEB-19TRN2021           | AEBR-720                 | ?          | 3               | 0            | 1654.56     |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202010 | AEB-19TRN2021           | AEBR-720                 | ?          | 2               | 0            | 1094.55     |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202010 | AEB-19TRN2021           | AEBR-720                 | ?          | 3               | 0            | 439.62      |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202011 | AEB-19TRN2021           | AEBR-720                 | ?          | 2               | 0            | 1928.01     |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202011 | AEB-19TRN2021           | AEBR-720                 | ?          | 3               | 0            | 2435.88     |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202012 | AEB-19TRN2021           | AEBR-720                 | ?          | 2               | 0            | 561.96      |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202012 | AEB-19TRN2021           | AEBR-720                 | ?          | 3               | 0            | 1328.33     |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202101 | AEB-19TRN2021           | AEBR-720                 | ?          | 2               | 0            | 1914.04     |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202101 | AEB-19TRN2021           | AEBR-720                 | ?          | 3               | 0            | 1346.24     |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202102 | AEB-19TRN2021           | AEBR-720                 | ?          | 2               | 0            | 1450.42     |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202102 | AEB-19TRN2021           | AEBR-720                 | ?          | 3               | 0            | 2129.32     |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202103 | AEB-19TRN2021           | AEBR-720                 | ?          | 2               | 0            | 2237.09     |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202103 | AEB-19TRN2021           | AEBR-720                 | ?          | 3               | 0            | 1124.10     |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202104 | AEB-19TRN2021           | AEBR-720                 | ?          | 2               | 0            | 400.85      |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202104 | AEB-19TRN2021           | AEBR-720                 | ?          | 3               | 0            | 450.98      |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202105 | AEB-19TRN2021           | AEBR-720                 | ?          | 2               | 0            | 1278.18     |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202105 | AEB-19TRN2021           | AEBR-720                 | ?          | 3               | 0            | 1507.59     |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202106 | AEB-19TRN2021           | AEBR-720                 | ?          | 2               | 0            | 955.10      |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202106 | AEB-19TRN2021           | AEBR-720                 | ?          | 3               | 0            | 499.08      |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202107 | AEB-19TRN2021           | AEBR-720                 | ?          | 2               | 0            | 726.26      |
    | ILR2021        | R12                  | ORG0017720     | CM             | 202107 | AEB-19TRN2021           | AEBR-720                 | ?          | 3               | 0            | 711.11      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-720       | AEBR-720           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-720       | AEBR-720           | 2               | 15407.30  | 1462.80  | 1398.04  | 1094.55  | 1928.01  | 561.96   | 1914.04  | 1450.42  | 2237.09  | 400.85   | 1278.18  | 955.10   | 726.26   | 
    | AEBP-720       | AEBR-720           | 3               | 15614.89  | 1988.08  | 1654.56  | 439.62   | 2435.88  | 1328.33  | 1346.24  | 2129.32  | 1124.10  | 450.98   | 1507.59  | 499.08   | 711.11   | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-720       | AEBR-720           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-720       | AEBR-720           | 2               | 15407.30  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 15407.30 | 
    | AEBP-720       | AEBR-720           | 3               | 15614.89  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 15614.89 | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-720       | AEBR-720           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-720       | AEBR-720           | 2               | -2860.38  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2860.38 | 
    | AEBP-720       | AEBR-720           | 3               | -2898.91  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2898.91 | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | AEBP-720       | AEBR-720           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-720       | AEBR-720           | 2               | 12546.92  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12546.92 | 
    | AEBP-720       | AEBR-720           | 3               | 12715.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12715.98 | 


    # Explanation ...
    #
    # Profile (19,433.00) x 130% = 25,262.90
    # Actuals (31,022.19) - 25,262.90 = Cap (-5,759.29)
    # D2 cap = -5,759.29 * (15,407.30/31,022.19) = -2,860.38
    # D3 cap = -5,759.29 * (15,614.89/31,022.19) = -2,898.91


    # Tidy Up
    Given the override date is reset
    
      