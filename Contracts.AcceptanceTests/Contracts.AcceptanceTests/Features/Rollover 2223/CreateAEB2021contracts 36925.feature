Feature: CreateAEB2021contracts 36925

@AcceptanceTest @InProgress
Scenario: A107 Bug 37482. Create and approve a 21/22 AEB2021 contract (AEB-AS only). Add 22/23 contract (AEB-AS only) with shared Master. Check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017107' 
    And   there are no terminated or closed allocations for UKPRN '10017107' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017107' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017107' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017107' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-AS2122        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017107'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017107' 
    And   there is no caseload advisor for UKPRN '10017107' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017107 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017107' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017107 Co Ltd' with UKPRN '10017107' and OrgId 'ORG0017107' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017107 | 117107 | 10017107 Co Ltd | 0              | Active                | Yes           | AA017107      | ?             | 1 Church Mews          | ?                      | ?                      | ?                      | Clophill               | Bedfordshire           | MK45 4BQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017107 |





    # Change the date
    Given the override date is '01/07/2021'

    # Bulk file (New Amendment, AEB-AS alloc only)
    And   there are no files prefixed '10017107' in the Sharepoint 'AEB2021-2122-Input-Appendices' folder
    And   there are no files prefixed 'AEB2021 AY 2122 15072022122750 v3_A107' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB2021 AY 2122 15072022122750 v3_A107' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB2021 AY 2122 15072022122750 v3_A107' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB2021 AY 2122 15072022122750 v3_A107' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB2021 AY 2122 15072022122750 v3_A107.xlsx' exists in the Datafiles folder and UKPRN '10017107' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017107' for FundingType 'AEB2021' and period '2122'

    # Check the contents of the SoF
    Then  the file named '10017107_[ContractNo]_v1.pdf' in Sharepoint location 'AEB2021-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017107 Co Ltd UKPRN: 10017107
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) [AllocRef_AEBA] £57,220 £39,987 £97,207
    of which Learner Support £26,195 £18,258 £44,453
    Total: £97,207
    Total Funding for this contract: £97,207
    Summary of Funding – Page 1
    """





    # Publish and approve

    # Change the date
    Given the override date is '02/07/2021'

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
    | 10017107 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017107 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Change the date
    Given the override date is '23/07/2022'

    # Bulk file (New Amendment, AEB-AS alloc only)
    And   there are no files prefixed '10017107' in the Sharepoint 'AEB2021-2223-Input-Appendices' folder
    And   there are no files prefixed 'AEB2021 AY 2223 15072022120908 v3_A107' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB2021 AY 2223 15072022120908 v3_A107' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB2021 AY 2223 15072022120908 v3_A107' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB2021 AY 2223 15072022120908 v3_A107' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB2021 AY 2223 15072022120908 v3_A107.xlsx' exists in the Datafiles folder and UKPRN '10017107' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017107' for FundingType 'AEB2021' and period '2223'

    # Check the contents of the SoF
    Then  the file named '10017107_[ContractNo]_v1.pdf' in Sharepoint location 'AEB2021-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017107 Co Ltd UKPRN: 10017107
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
   
    of which Learner Support £26,195 £18,258 £44,453
    Total: £97,207
    Allocation
    1 August 2022 to 31 July 2023 Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) [AllocRef_AEBA] £54,302 £33,349 £87,651
    of which Learner Support £26,237 £11,995 £38,232
    Total: £87,651
    Total Funding for this contract: £184,858
    Summary of Funding – Page 1
    """

 #  Blank line above is ...
 #
 #  ESFA AEB - Adult Skills (procured from Aug 2021) [AllocRef_AEBA] £57,220 £39,987 £97,207

    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Withdrawn25072024
@Long2Run @Long2Run123
Scenario: A108 Create and approve a 21/22 AEB2021 contract. Add 22/23 contract with shared Master. Publish and approve. Add actuals for 22/23. Payment Batch. Check docs, CRM and feed

    # 1. Create and approve a 21/22 contract
    # 2. Bulk import a 22/23 contract (New Amendment)
    # 3. Check docs
    # 4. Publish and approve 22/23 v1 and check feed
    # 5. Add Actuals for 22/23 then check CRM
    # 6. Create and check the contents of the CDA report
    # 7. Payment Batch for AEB-AS2223, AEB-NSF2223 and STFI2223 and check feed
    # 8. Run Consolidated Payment Summary Report

    Given there are no allocations marked as Under Termination for UKPRN '10017108' 
    And   there are no terminated or closed allocations for UKPRN '10017108' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017108' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017108' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017108' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-108      |
    | NSF-108       |
    | STFI-108      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-108      |
    | NSF-108       |
    | STFI-108      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-AS2122        |
    | AEB-NSF2122       |
    | STFI2122          |
    #
    | AEB-AS2223        |
    | AEB-NSF2223       |
    | STFI2223          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP21-108     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017108'

    # Set the 'base' timestamp for each of the 21/22 and 22/23 AEB document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_AEB2021_2021-08-01.docx                     | 2021-06-20 12:00:00.000 | 
    #
    | AEB2021_2122_TAC_2021-08-01.docx                | 2021-06-20 12:00:00.000 | 
    | AEB2021_2122_S1_2021-08-01.docx                 | 2021-06-20 12:00:00.000 | 
    | AEB2021_2122_S2_2021-08-01.docx                 | 2021-06-20 12:00:00.000 | 
    | FA_AEB2021_2122_2021-08-01.docx                 | 2021-06-20 12:00:00.000 | 
    | AEB2021_2122_S3ON_2021-08-01.docx               | 2021-06-20 12:00:00.000 | 
    #
    | AEB2021_2223_TAC_2022-08-01.docx                | 2022-06-20 12:00:00.000 | 
    | AEB2021_2223_S1_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
    | AEB2021_2223_S2_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
    | FA_AEB2021_2223_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
    | AEB2021_2223_S3ON_2022-08-01.docx               | 2022-06-20 12:00:00.000 | 



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017108' 
    And   there is no caseload advisor for UKPRN '10017108' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017108 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017108' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017108 Co Ltd' with UKPRN '10017108' and OrgId 'ORG0017108' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017108 | 117108 | 10017108 Co Ltd | 0              | Active                | Yes           | AA017108      | ?             | 345 The Meadway        | Tilehurst              | ?                      | ?                      | Reading                | Berkshire              | RG30 4NU  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017108 |





    # Part 1: Create and approve a 21/22 contract
  
    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP21-108'
    And   there are no details in ContractManagement.CreatedContract for 'AEBP21-108'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017108 | 10017108 Co Ltd      | ESFA-108             | AEBP21-108     | 1                     | 01/08/2021        | 31/07/2022      | 179004.00     |                                       | Contract for Services                      | 2122   | New          | ORG0017108 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017108 | AEBP21-108     | AEBA-108      | AEB-AS            | AEB-AS2122              | AY                      | 01/08/2021          | 31/07/2022        | 43859.00        |                                         |            |                                                             | New          |             |
    | 10017108 | AEBP21-108     | NSF-108       | AEB-NSF           | AEB-NSF2122             | AY                      | 01/08/2021          | 31/07/2022        | 41465.00        |                                         |            |                                                             | New          |             |
    | 10017108 | AEBP21-108     | STFI-108      | STFI              | STFI2122                | AY                      | 01/08/2021          | 31/07/2022        | 93680.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017108 | AEBP21-108     | AEBA-108      | 1               | 0                     | 43859.00  | 28552.00  | 15307.00  | 3217.00  | 3201.00  | 4229.00  | 1146.00  | 3977.00  | 6586.00  | 5178.00  | 1018.00  | 2396.00  | 4911.00  | 3785.00  | 4215.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017108 | AEBP21-108     | AEBA-108      | 4               | 1                     | 19067.00  | 10517.00  | 8550.00   | 93.00    | 1081.00  | 1817.00  | 592.00   | 567.00   | 3359.00  | 2386.00  | 622.00   | 2213.00  | 3107.00  | 424.00   | 2806.00  | Adult Skills                                                    | New          |             | 
    | 10017108 | AEBP21-108     | AEBA-108      | 5               | 1                     | 24792.00  | 18035.00  | 6757.00   | 3124.00  | 2120.00  | 2412.00  | 554.00   | 3410.00  | 3227.00  | 2792.00  | 396.00   | 183.00   | 1804.00  | 3361.00  | 1409.00  | Adult Skills Learner Support                                    | New          |             | 
    #
    | 10017108 | AEBP21-108     | NSF-108       | 1               | 0                     | 41465.00  | 27612.00  | 13853.00  | 6461.00  | 3915.00  | 2413.00  | 2236.00  | 2537.00  | 6317.00  | 3361.00  | 372.00   | 955.00   | 941.00   | 5670.00  | 6287.00  | National Skills Fund Total Funding                              | New          |             | 
    | 10017108 | AEBP21-108     | NSF-108       | 2               | 1                     | 22473.00  | 15005.00  | 7468.00   | 3383.00  | 3106.00  | 235.00   | 463.00   | 1515.00  | 3042.00  | 3145.00  | 116.00   | 818.00   | 448.00   | 2543.00  | 3659.00  | Level 3 Offer for 24 year olds and over                         | New          |             | 
    | 10017108 | AEBP21-108     | NSF-108       | 5               | 1                     | 18992.00  | 12607.00  | 6385.00   | 3078.00  | 809.00   | 2178.00  | 1773.00  | 1022.00  | 3275.00  | 216.00   | 256.00   | 137.00   | 493.00   | 3127.00  | 2628.00  | National Skills Fund Learner Support                            | New          |             | 
    #
    | 10017108 | AEBP21-108     | STFI-108      | 1               | 0                     | 23332.00  | 12783.00  | 10549.00  | 253.00   | 2413.00  | 3337.00  | 3282.00  | 728.00   | 989.00   | 1187.00  | 594.00   | 2373.00  | 3455.00  | 2926.00  | 1795.00  | Short Term Funding Initiative 1                                 | New          |             | 
    | 10017108 | AEBP21-108     | STFI-108      | 2               | 0                     | 23892.00  | 17435.00  | 6457.00   | 1538.00  | 1706.00  | 3168.00  | 1498.00  | 1824.00  | 2812.00  | 3549.00  | 1340.00  | 2299.00  | 1389.00  | 416.00   | 2353.00  | Short Term Funding Initiative 2                                 | New          |             | 
    | 10017108 | AEBP21-108     | STFI-108      | 3               | 0                     | 22506.00  | 14371.00  | 8135.00   | 2038.00  | 1950.00  | 250.00   | 2631.00  | 171.00   | 2869.00  | 3160.00  | 1302.00  | 3175.00  | 275.00   | 3541.00  | 1144.00  | Short Term Funding Initiative 3                                 | New          |             | 
    | 10017108 | AEBP21-108     | STFI-108      | 4               | 0                     | 23950.00  | 15334.00  | 8616.00   | 1503.00  | 3124.00  | 979.00   | 2728.00  | 2165.00  | 1888.00  | 2719.00  | 228.00   | 1281.00  | 2807.00  | 1928.00  | 2600.00  | Short Term Funding Initiative 4                                 | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP21-108     | 1                     | 0                        | 2021-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP21-108'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-108' and ContractNumber 'AEBP21-108' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP21-108' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017108 | AEBP21-108         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017108 | ESFA-108           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP21-108' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '120' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '120' deliverable period rows in CRM linked to the latest version of contract 'AEBP21-108'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AEBA-108        | 2372010          | Jul-22 | Reconciliation |
    | NSF-108         | 100942           | Jul-22 | Reconciliation |
    | STFI-108        | 2374010          | Jul-22 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)  
    Then  the Legal Contract CM feed contains the following '10' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10017108 | AEBP21-108     | 1               | AEBA-108      | 1               | 0                     | 43859.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
    | 10017108 | AEBP21-108     | 1               | AEBA-108      | 4               | 1                     | 19067.00     | 0             | 0        | Adult Skills                                                    | ?                                                           |
    | 10017108 | AEBP21-108     | 1               | AEBA-108      | 5               | 1                     | 24792.00     | 0             | 0        | Adult Skills Learner Support                                    | ?                                                           |
    #
    | 10017108 | AEBP21-108     | 1               | NSF-108       | 1               | 0                     | 41465.00     | 0             | 0        | National Skills Fund Total Funding                              | ?                                                           |
    | 10017108 | AEBP21-108     | 1               | NSF-108       | 2               | 1                     | 22473.00     | 0             | 0        | Level 3 Offer for 24 year olds and over                         | ?                                                           |
    | 10017108 | AEBP21-108     | 1               | NSF-108       | 5               | 1                     | 18992.00     | 0             | 0        | National Skills Fund Learner Support                            | ?                                                           |
    #
    | 10017108 | AEBP21-108     | 1               | STFI-108      | 1               | 0                     | 23332.00     | 0             | 0        | Short Term Funding Initiative 1                                 | ?                                                           |
    | 10017108 | AEBP21-108     | 1               | STFI-108      | 2               | 0                     | 23892.00     | 0             | 0        | Short Term Funding Initiative 2                                 | ?                                                           |
    | 10017108 | AEBP21-108     | 1               | STFI-108      | 3               | 0                     | 22506.00     | 0             | 0        | Short Term Funding Initiative 3                                 | ?                                                           |
    | 10017108 | AEBP21-108     | 1               | STFI-108      | 4               | 0                     | 23950.00     | 0             | 0        | Short Term Funding Initiative 4                                 | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP21-108' agree with the most recent entry for this contract in the ContractManagement feed





    # Part 2: Bulk import a 22/23 contract (New Amendment)
    
    # Change the date
    Given the override date is '01/07/2022'

    # Bulk file (New Amendment)
    And   there are no files prefixed '10017108' in the Sharepoint 'AEB2021-2223-Input-Appendices' folder
    And   there are no files prefixed 'AEB2021 AY 2223 27052022112659 v3_A108' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB2021 AY 2223 27052022112659 v3_A108' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB2021 AY 2223 27052022112659 v3_A108' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB2021 AY 2223 27052022112659 v3_A108' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB2021 AY 2223 27052022112659 v3_A108.xlsx' exists in the Datafiles folder and UKPRN '10017108' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report





     # Part 3: Check docs
 
     # Change the date
     Given the override date is '02/07/2022'
 
     # Retrieve parameters
    #When  I retrieve the latest EFA contract details from CRM for provider '10017108' for FundingType 'AEB2021' and period '2223' and Delivery Organisation '00000000'
     When  I retrieve the latest contract details from CRM for provider '10017108' for FundingType 'AEB2021' and period '2223'

    # Check the contents of the Appendices
    Then  the file named '10017108_[ContractNo]_v1.pdf' in Sharepoint location 'AEB2021-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017108 Co Ltd UKPRN: 10017108
    Master Contract Number: ESFA-108
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) AEBA-108 £28,552 £15,307 £43,859
    of which Learner Support £18,035 £6,757 £24,792
    ESFA AEB - National Skills Fund (procured from Aug 2021) NSF-108 £27,612 £13,853 £41,465
    of which Level 3 Offer for 24 year olds and over £15,005 £7,468 £22,473
    of which Learner Support £12,607 £6,385 £18,992
    ESFA AEB - Short Term Funding Initiatives (procured from
    STFI-108 £59,923 £33,757 £93,680
    Aug 2021)
    of which Short Term Funding Initiative 1 £12,783 £10,549 £23,332
    of which Short Term Funding Initiative 2 £17,435 £6,457 £23,892
    of which Short Term Funding Initiative 3 £14,371 £8,135 £22,506
    of which Short Term Funding Initiative 4 £15,334 £8,616 £23,950
    Total: £179,004
    Allocation
    1 August 2022 to 31 July 2023 Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) [AllocRef_AEBA] £71,519 £35,456 £106,975
    of which Learner Support £25,394 £21,024 £46,418
    ESFA AEB - National Skills Fund (procured from Aug 2021) [AllocRef_NSF] £54,892 £34,846 £89,738
    of which Level 3 Free Courses for Jobs £25,884 £15,183 £41,067
    of which Learner Support £29,008 £19,663 £48,671
    ESFA AEB - Short Term Funding Initiatives (procured from
    [AllocRef_STFI] £128,348 £65,430 £193,778
    Aug 2021)
    of which Short Term Funding Initiative 1 £35,231 £12,960 £48,191
    of which Short Term Funding Initiative 2 £38,353 £19,553 £57,906
    of which Short Term Funding Initiative 3 £27,685 £18,194 £45,879
    of which Short Term Funding Initiative 4 £27,079 £14,723 £41,802
    Total: £390,491
    Total Funding for this contract: £569,495
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2021 to 31 July 2023
    Between the Secretary of State for Education
    And 10017108 Co Ltd
    Funding for ESFA Adult Education Budget (Contract for Services)
    Master Contract Number ESFA-108
    ACCEPTANCE BY THE CONTRACTOR
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017108 Co Ltd THE SECRETARY OF STATE FOR
    345 The Meadway EDUCATION
    Tilehurst DEPARTMENT FOR EDUCATION
    Reading 20 GREAT SMITH STREET
    AND
    Berkshire LONDON
    RG30 4NU SW1P 3BT
    Company No: AA017108
    Hereinafter called Hereinafter called
    the Contractor the Department
    ESFA Adult Education Budget (Procured) Version 4 (July 2022) - Page 2

    Inadequate overall
    13.5 Where the Department is made aware that Ofsted has provisionally
    assessed the Services to be inadequate overall, the Department may, in
    its absolute discretion commence discussions with the Contractor and
    other relevant co-funding regulatory bodies where appropriate as part of
    considering what actions as specified in Clauses 13.6(a) to 13.6(e)
    inclusive may be taken.
    ESFA Adult Education Budget (Procured) Version 4 (July 2022) - Page 30

    23.1.7 The Contractor must update the course information with details
    of all of the Services funded by the Department to the course
    directory (Publish to the course directory
    (nationalcareers.service.gov.uk)). The Contractor must regularly
    review this information and keep it updated.
    ESFA Adult Education Budget (Procured) Version 4 (July 2022) - Page 45

    40.4.3 The Contractor fails to comply with requirements imposed under
    Clauses 11.10(a) and/or 11.10(b) (Quality Assurance and
    Raising Standards); and/or
    ESFA Adult Education Budget (Procured) Version 4 (July 2022) - Page 70
    ESFA Adult Education Budget (Procured) Version 4 (July 2022) - Page 78
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET CONTRACT FOR SERVICES
    ESFA Adult Education Budget (Procured) Schedule 1 Version 3 (July 2022) – Page 1
    ESFA Adult Education Budget (Procured) Schedule 1 Version 3 (July 2022) – Page 12
    
    SCHEDULE 2: PAYMENT 
    ESFA ADULT EDUCATION BUDGET (CONTRACT FOR SERVICES)
    5. The Department will pay the Contractor on the 16 Working Day of each
    month.
    ESFA Adult Education Budget (Procured) Schedule 2 Version 3 (February 2023) – Page 1
    ESFA Adult Education Budget (Procured) Schedule 2 Version 3 (February 2023) – Page 2

    SCHEDULE 2
    Funding Agreement – ESFA-Funded Adult Education Budget - Adult Skills (procured from Aug 2021)
    Provider: 10017108 Co Ltd UKPRN: 10017108
    Master Contract Number: ESFA-108 Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_AEBA]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    ESFA AEB - Adult Skills £106,975 £11,441 £6,250 £6,419 £11,750 £7,439 £8,692 £8,660 £10,868 £12,195 £10,326 £7,980 £4,955
    of which Learner Support £46,418 £5,211 £678 £2,599 £4,787 £1,952 £4,617 £2,462 £3,088 £7,048 £5,232 £4,839 £3,905
    Total Funding £106,975 £11,441 £6,250 £6,419 £11,750 £7,439 £8,692 £8,660 £10,868 £12,195 £10,326 £7,980 £4,955
    Schedule 2 – Funding Agreement [AllocRef_AEBA] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2
    Funding Agreement – ESFA-Funded Adult Education Budget - National Skills Fund (procured from Aug 2021)
    Provider: 10017108 Co Ltd UKPRN: 10017108
    Master Contract Number: ESFA-108 Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_NSF]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    ESFA AEB - National Skills Fund £89,738 £7,235 £8,287 £3,021 £10,867 £9,072 £4,890 £7,374 £4,146 £3,765 £12,363 £12,533 £6,185
    of which Level 3 Free Courses for Jobs £41,067 £5,587 £5,130 £661 £4,006 £7,763 £714 £120 £1,903 £2,392 £4,653 £7,933 £205
    of which Learner Support £48,671 £1,648 £3,157 £2,360 £6,861 £1,309 £4,176 £7,254 £2,243 £1,373 £7,710 £4,600 £5,980
    Total Funding £89,738 £7,235 £8,287 £3,021 £10,867 £9,072 £4,890 £7,374 £4,146 £3,765 £12,363 £12,533 £6,185
    Schedule 2 – Funding Agreement [AllocRef_NSF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2
    Funding Agreement – ESFA-Funded Adult Education Budget - Short Term Funding Initiatives (procured from Aug 2021)
    Provider: 10017108 Co Ltd UKPRN: 10017108
    Master Contract Number: ESFA-108 Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_STFI]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    ESFA AEB - Short Term Funding Initiative 1 £48,191 £225 £7,921 £735 £6,393 £5,321 £6,425 £3,113 £5,098 £4,981 £7,444 £55 £480
    ESFA AEB - Short Term Funding Initiative 2 £57,906 £7,157 £3,028 £5,353 £4,217 £1,786 £6,967 £7,327 £2,518 £6,882 £7,582 £1,754 £3,335
    ESFA AEB - Short Term Funding Initiative 3 £45,879 £6,542 £650 £6,648 £4,557 £767 £4,185 £3,994 £342 £5,459 £172 £5,968 £6,595
    ESFA AEB - Short Term Funding Initiative 4 £41,802 £2,603 £6,627 £395 £7,412 £2,264 £1,807 £5,289 £682 £4,439 £3,230 £2,635 £4,419
    Total Funding £193,778 £16,527 £18,226 £13,131 £22,579 £10,138 £19,384 £19,723 £8,640 £21,761 £18,428 £10,412 £14,829
    Schedule 2 – Funding Agreement [AllocRef_STFI] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    ESFA Adult Education Budget (Procured) Schedule 3 Version 2 (July 2022) – Page 1

    Nature and The Contractor will be required to submit the data to the
    purposes of the Department for the purposes as set out in Clause 23
    Processing (Submission of Learner Data) of this Contract.
    The processing of data in the Contract refers to the
    submission of ILR data to the Department only. The
    processing does not include the processing of Personal
    Data collected from the Learners by the Contractor for
    the purposes of enrolling Learners onto programmes or
    delivering education or training.
    ESFA Adult Education Budget (Procured) Schedule 5 Version 2 (July 2022) – Page 1
    
    ESFA Adult Education Budget (Procured) Schedule 9 Version 2 (July 2022) – Page 1
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-01 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017108_[ContractNo]_v1.pdf' in 'AEB2021-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A108.pdf'





    # Part 4: Publish and approve 22/23 v1 and check feed

    # Change the date
    Given the override date is '05/07/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-108' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017108 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    #
    | 10017108 | AEBP21-108         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017108 | ESFA-108           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '120' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_AEBA] | 2372010          | Jul-23 | Reconciliation |
    | [AllocRef_NSF]  | 100942           | Jul-23 | Reconciliation |
    | [AllocRef_STFI] | 2374010          | Jul-23 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '10' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                      | DeliverableDescription   | 
    | 10017108 | [ContractNo]   | 1               | [AllocRef_AEBA] | 1               | 0                     | 106975.00    | 0             | 0        | Adult Skills Total Funding           | ?                        |
    | 10017108 | [ContractNo]   | 1               | [AllocRef_AEBA] | 4               | 1                     | 60557.00     | 0             | 0        | Adult Skills                         | ?                        |
    | 10017108 | [ContractNo]   | 1               | [AllocRef_AEBA] | 5               | 1                     | 46418.00     | 0             | 0        | Adult Skills Learner Support         | ?                        |
    | 10017108 | [ContractNo]   | 1               | [AllocRef_NSF]  | 1               | 0                     | 89738.00     | 0             | 0        | National Skills Fund Total Funding   | ?                        |
    | 10017108 | [ContractNo]   | 1               | [AllocRef_NSF]  | 2               | 1                     | 41067.00     | 0             | 0        | Level 3 Free Courses for Jobs        | ?                        |
    | 10017108 | [ContractNo]   | 1               | [AllocRef_NSF]  | 5               | 1                     | 48671.00     | 0             | 0        | National Skills Fund Learner Support | ?                        |
    | 10017108 | [ContractNo]   | 1               | [AllocRef_STFI] | 1               | 0                     | 48191.00     | 0             | 0        | Short Term Funding Initiative 1      | ?                        |
    | 10017108 | [ContractNo]   | 1               | [AllocRef_STFI] | 2               | 0                     | 57906.00     | 0             | 0        | Short Term Funding Initiative 2      | ?                        |
    | 10017108 | [ContractNo]   | 1               | [AllocRef_STFI] | 3               | 0                     | 45879.00     | 0             | 0        | Short Term Funding Initiative 3      | ?                        |
    | 10017108 | [ContractNo]   | 1               | [AllocRef_STFI] | 4               | 0                     | 41802.00     | 0             | 0        | Short Term Funding Initiative 4      | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed





    # Part 5: Add Actuals for 22/23 then check CRM

    # Add actuals to the contract for AEB-AS2223, AEB-NSF2223 and STFI2223

    # Change the date
    Given the override date is '04/10/2022'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017108'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2022
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 2               | 0            | 656.38      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 3               | 0            | 514.81      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 6               | 0            | 564.11      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 7               | 0            | 1411.24     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 8               | 0            | 478.56      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 9               | 0            | 1469.21     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 10              | 0            | 1163.17     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 2               | 0            | 2352.37     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 3               | 0            | 465.26      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 6               | 0            | 2003.87     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 7               | 0            | 699.93      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 8               | 0            | 844.84      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 9               | 0            | 1604.57     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 10              | 0            | 860.77      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 2               | 0            | 2029.73     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 3               | 0            | 1578.92     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 6               | 0            | 456.94      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 7               | 0            | 1664.81     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 8               | 0            | 1759.15     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 9               | 0            | 691.06      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 10              | 0            | 2444.27     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 2               | 0            | 2456.58     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 3               | 0            | 647.63      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 6               | 0            | 759.23      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 7               | 0            | 2063.91     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 8               | 0            | 450.22      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 9               | 0            | 1934.00     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 10              | 0            | 1123.20     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 2               | 0            | 1427.78     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 3               | 0            | 1516.24     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 6               | 0            | 1788.03     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 7               | 0            | 1329.88     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 8               | 0            | 2026.43     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 9               | 0            | 789.27      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 10              | 0            | 1287.03     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 2               | 0            | 903.61      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 3               | 0            | 1218.05     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 6               | 0            | 1600.94     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 7               | 0            | 2117.38     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 8               | 0            | 1741.50     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 9               | 0            | 1842.61     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 10              | 0            | 1337.66     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 2               | 0            | 701.10      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 3               | 0            | 533.70      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 6               | 0            | 1360.83     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 7               | 0            | 923.42      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 8               | 0            | 1747.44     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 9               | 0            | 608.77      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 10              | 0            | 418.35      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 2               | 0            | 2227.66     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 3               | 0            | 829.39      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 6               | 0            | 1203.95     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 7               | 0            | 1434.69     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 8               | 0            | 1798.00     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 9               | 0            | 1085.30     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 10              | 0            | 1960.48     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 2               | 0            | 1417.38     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 3               | 0            | 1918.11     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 6               | 0            | 1045.39     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 7               | 0            | 1643.91     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 8               | 0            | 2101.00     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 9               | 0            | 1190.52     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 10              | 0            | 1883.35     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 2               | 0            | 1589.44     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 3               | 0            | 1711.23     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 6               | 0            | 2444.42     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 7               | 0            | 492.88      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 8               | 0            | 1272.18     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 9               | 0            | 1953.95     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 10              | 0            | 2268.45     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 2               | 0            | 1989.29     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 3               | 0            | 702.52      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 6               | 0            | 829.25      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 7               | 0            | 2068.54     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 8               | 0            | 1235.99     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 9               | 0            | 1246.41     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 10              | 0            | 670.54      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 2               | 0            | 750.74      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 3               | 0            | 596.14      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 6               | 0            | 670.68      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 7               | 0            | 2008.59     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 8               | 0            | 529.00      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 9               | 0            | 909.14      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | AEB-AS2223              | [AllocRef_AEBA]          | ?          | 10              | 0            | 1313.35     |
    #
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 3               | 0            | 1951.00     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 4               | 0            | 627.27      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 6               | 0            | 1274.11     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 7               | 0            | 1790.98     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 8               | 0            | 615.15      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 9               | 0            | 1977.70     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 10              | 0            | 1956.70     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 3               | 0            | 804.17      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 4               | 0            | 855.21      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 6               | 0            | 631.06      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 7               | 0            | 938.44      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 8               | 0            | 995.84      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 9               | 0            | 1931.92     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 10              | 0            | 2158.27     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 3               | 0            | 1047.32     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 4               | 0            | 1860.24     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 6               | 0            | 1778.15     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 7               | 0            | 1313.84     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 8               | 0            | 560.35      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 9               | 0            | 1744.40     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 10              | 0            | 1768.41     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 3               | 0            | 1027.36     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 4               | 0            | 979.42      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 6               | 0            | 420.79      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 7               | 0            | 850.88      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 8               | 0            | 407.36      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 9               | 0            | 469.54      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 10              | 0            | 2122.51     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 3               | 0            | 1242.00     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 4               | 0            | 1707.76     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 6               | 0            | 709.66      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 7               | 0            | 540.85      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 8               | 0            | 1633.41     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 9               | 0            | 1106.69     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 10              | 0            | 1255.89     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 3               | 0            | 1285.57     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 4               | 0            | 1961.54     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 6               | 0            | 2148.01     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 7               | 0            | 1767.36     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 8               | 0            | 407.44      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 9               | 0            | 1239.62     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 10              | 0            | 1895.13     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 3               | 0            | 994.41      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 4               | 0            | 2233.51     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 6               | 0            | 1402.23     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 7               | 0            | 1597.45     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 8               | 0            | 1779.48     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 9               | 0            | 664.64      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 10              | 0            | 512.30      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 3               | 0            | 1169.29     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 4               | 0            | 1720.29     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 6               | 0            | 1635.78     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 7               | 0            | 1230.69     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 8               | 0            | 1531.22     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 9               | 0            | 945.68      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 10              | 0            | 1638.53     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 3               | 0            | 1248.17     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 4               | 0            | 1864.06     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 6               | 0            | 1103.86     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 7               | 0            | 1856.37     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 8               | 0            | 829.96      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 9               | 0            | 1025.21     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 10              | 0            | 1113.23     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 3               | 0            | 562.25      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 4               | 0            | 1572.82     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 6               | 0            | 1277.62     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 7               | 0            | 775.62      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 8               | 0            | 778.81      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 9               | 0            | 1924.50     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 10              | 0            | 1381.12     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 3               | 0            | 1152.10     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 4               | 0            | 1750.97     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 6               | 0            | 565.78      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 7               | 0            | 1246.40     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 8               | 0            | 1701.23     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 9               | 0            | 1981.15     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 10              | 0            | 2105.12     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 3               | 0            | 1501.39     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 4               | 0            | 1579.87     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 6               | 0            | 876.86      |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 7               | 0            | 1035.48     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 8               | 0            | 1670.15     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 9               | 0            | 1406.46     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | AEB-NSF2223             | [AllocRef_NSF]           | ?          | 10              | 0            | 860.95      |
    #
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | STFI2223                | [AllocRef_STFI]          | ?          | 5               | 0            | 3062.68     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | STFI2223                | [AllocRef_STFI]          | ?          | 6               | 0            | 1921.44     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | STFI2223                | [AllocRef_STFI]          | ?          | 7               | 0            | 3923.76     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | STFI2223                | [AllocRef_STFI]          | ?          | 8               | 0            | 1974.73     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | STFI2223                | [AllocRef_STFI]          | ?          | 9               | 0            | 2866.75     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | STFI2223                | [AllocRef_STFI]          | ?          | 10              | 0            | 3299.57     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | STFI2223                | [AllocRef_STFI]          | ?          | 11              | 0            | 1543.30     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202208 | STFI2223                | [AllocRef_STFI]          | ?          | 12              | 0            | 4679.30     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | STFI2223                | [AllocRef_STFI]          | ?          | 5               | 0            | 2288.45     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | STFI2223                | [AllocRef_STFI]          | ?          | 6               | 0            | 3053.34     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | STFI2223                | [AllocRef_STFI]          | ?          | 7               | 0            | 2450.38     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | STFI2223                | [AllocRef_STFI]          | ?          | 8               | 0            | 2277.92     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | STFI2223                | [AllocRef_STFI]          | ?          | 9               | 0            | 2758.03     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | STFI2223                | [AllocRef_STFI]          | ?          | 10              | 0            | 2873.23     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | STFI2223                | [AllocRef_STFI]          | ?          | 11              | 0            | 3429.78     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202209 | STFI2223                | [AllocRef_STFI]          | ?          | 12              | 0            | 2147.47     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | STFI2223                | [AllocRef_STFI]          | ?          | 5               | 0            | 2151.15     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | STFI2223                | [AllocRef_STFI]          | ?          | 6               | 0            | 1913.51     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | STFI2223                | [AllocRef_STFI]          | ?          | 7               | 0            | 2274.98     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | STFI2223                | [AllocRef_STFI]          | ?          | 8               | 0            | 2038.74     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | STFI2223                | [AllocRef_STFI]          | ?          | 9               | 0            | 4121.72     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | STFI2223                | [AllocRef_STFI]          | ?          | 10              | 0            | 1793.75     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | STFI2223                | [AllocRef_STFI]          | ?          | 11              | 0            | 2583.48     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202210 | STFI2223                | [AllocRef_STFI]          | ?          | 12              | 0            | 2090.50     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | STFI2223                | [AllocRef_STFI]          | ?          | 5               | 0            | 1859.62     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | STFI2223                | [AllocRef_STFI]          | ?          | 6               | 0            | 2525.45     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | STFI2223                | [AllocRef_STFI]          | ?          | 7               | 0            | 2877.09     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | STFI2223                | [AllocRef_STFI]          | ?          | 8               | 0            | 4468.58     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | STFI2223                | [AllocRef_STFI]          | ?          | 9               | 0            | 2273.67     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | STFI2223                | [AllocRef_STFI]          | ?          | 10              | 0            | 2563.53     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | STFI2223                | [AllocRef_STFI]          | ?          | 11              | 0            | 3047.25     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202211 | STFI2223                | [AllocRef_STFI]          | ?          | 12              | 0            | 3929.91     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | STFI2223                | [AllocRef_STFI]          | ?          | 5               | 0            | 1499.26     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | STFI2223                | [AllocRef_STFI]          | ?          | 6               | 0            | 2982.96     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | STFI2223                | [AllocRef_STFI]          | ?          | 7               | 0            | 1725.33     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | STFI2223                | [AllocRef_STFI]          | ?          | 8               | 0            | 2311.61     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | STFI2223                | [AllocRef_STFI]          | ?          | 9               | 0            | 4131.33     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | STFI2223                | [AllocRef_STFI]          | ?          | 10              | 0            | 2580.26     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | STFI2223                | [AllocRef_STFI]          | ?          | 11              | 0            | 4377.97     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202212 | STFI2223                | [AllocRef_STFI]          | ?          | 12              | 0            | 4045.05     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | STFI2223                | [AllocRef_STFI]          | ?          | 5               | 0            | 3682.03     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | STFI2223                | [AllocRef_STFI]          | ?          | 6               | 0            | 3700.14     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | STFI2223                | [AllocRef_STFI]          | ?          | 7               | 0            | 2527.35     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | STFI2223                | [AllocRef_STFI]          | ?          | 8               | 0            | 2594.85     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | STFI2223                | [AllocRef_STFI]          | ?          | 9               | 0            | 3463.68     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | STFI2223                | [AllocRef_STFI]          | ?          | 10              | 0            | 2386.97     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | STFI2223                | [AllocRef_STFI]          | ?          | 11              | 0            | 3296.57     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202301 | STFI2223                | [AllocRef_STFI]          | ?          | 12              | 0            | 4023.07     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | STFI2223                | [AllocRef_STFI]          | ?          | 5               | 0            | 1996.45     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | STFI2223                | [AllocRef_STFI]          | ?          | 6               | 0            | 2461.42     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | STFI2223                | [AllocRef_STFI]          | ?          | 7               | 0            | 3679.89     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | STFI2223                | [AllocRef_STFI]          | ?          | 8               | 0            | 1878.11     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | STFI2223                | [AllocRef_STFI]          | ?          | 9               | 0            | 2341.28     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | STFI2223                | [AllocRef_STFI]          | ?          | 10              | 0            | 4021.98     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | STFI2223                | [AllocRef_STFI]          | ?          | 11              | 0            | 1938.07     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202302 | STFI2223                | [AllocRef_STFI]          | ?          | 12              | 0            | 2408.94     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | STFI2223                | [AllocRef_STFI]          | ?          | 5               | 0            | 2457.61     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | STFI2223                | [AllocRef_STFI]          | ?          | 6               | 0            | 2671.53     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | STFI2223                | [AllocRef_STFI]          | ?          | 7               | 0            | 3218.73     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | STFI2223                | [AllocRef_STFI]          | ?          | 8               | 0            | 4404.03     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | STFI2223                | [AllocRef_STFI]          | ?          | 9               | 0            | 2886.26     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | STFI2223                | [AllocRef_STFI]          | ?          | 10              | 0            | 2768.93     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | STFI2223                | [AllocRef_STFI]          | ?          | 11              | 0            | 2901.56     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202303 | STFI2223                | [AllocRef_STFI]          | ?          | 12              | 0            | 2955.46     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | STFI2223                | [AllocRef_STFI]          | ?          | 5               | 0            | 2057.17     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | STFI2223                | [AllocRef_STFI]          | ?          | 6               | 0            | 1805.53     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | STFI2223                | [AllocRef_STFI]          | ?          | 7               | 0            | 3768.73     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | STFI2223                | [AllocRef_STFI]          | ?          | 8               | 0            | 3948.03     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | STFI2223                | [AllocRef_STFI]          | ?          | 9               | 0            | 2322.28     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | STFI2223                | [AllocRef_STFI]          | ?          | 10              | 0            | 2006.79     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | STFI2223                | [AllocRef_STFI]          | ?          | 11              | 0            | 4300.15     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202304 | STFI2223                | [AllocRef_STFI]          | ?          | 12              | 0            | 3073.22     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | STFI2223                | [AllocRef_STFI]          | ?          | 5               | 0            | 3613.33     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | STFI2223                | [AllocRef_STFI]          | ?          | 6               | 0            | 2958.78     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | STFI2223                | [AllocRef_STFI]          | ?          | 7               | 0            | 4293.80     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | STFI2223                | [AllocRef_STFI]          | ?          | 8               | 0            | 1968.35     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | STFI2223                | [AllocRef_STFI]          | ?          | 9               | 0            | 4524.62     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | STFI2223                | [AllocRef_STFI]          | ?          | 10              | 0            | 1659.81     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | STFI2223                | [AllocRef_STFI]          | ?          | 11              | 0            | 4711.05     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202305 | STFI2223                | [AllocRef_STFI]          | ?          | 12              | 0            | 2080.61     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | STFI2223                | [AllocRef_STFI]          | ?          | 5               | 0            | 4220.87     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | STFI2223                | [AllocRef_STFI]          | ?          | 6               | 0            | 3296.95     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | STFI2223                | [AllocRef_STFI]          | ?          | 7               | 0            | 1746.92     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | STFI2223                | [AllocRef_STFI]          | ?          | 8               | 0            | 2656.09     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | STFI2223                | [AllocRef_STFI]          | ?          | 9               | 0            | 1870.04     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | STFI2223                | [AllocRef_STFI]          | ?          | 10              | 0            | 3147.59     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | STFI2223                | [AllocRef_STFI]          | ?          | 11              | 0            | 1525.50     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202306 | STFI2223                | [AllocRef_STFI]          | ?          | 12              | 0            | 2853.88     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | STFI2223                | [AllocRef_STFI]          | ?          | 5               | 0            | 3501.13     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | STFI2223                | [AllocRef_STFI]          | ?          | 6               | 0            | 2306.02     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | STFI2223                | [AllocRef_STFI]          | ?          | 7               | 0            | 2620.15     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | STFI2223                | [AllocRef_STFI]          | ?          | 8               | 0            | 4685.11     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | STFI2223                | [AllocRef_STFI]          | ?          | 9               | 0            | 3286.95     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | STFI2223                | [AllocRef_STFI]          | ?          | 10              | 0            | 4435.01     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | STFI2223                | [AllocRef_STFI]          | ?          | 11              | 0            | 2498.86     |
    | ILR2223        | R02                  | ORG0017108     | CM             | 202307 | STFI2223                | [AllocRef_STFI]          | ?          | 12              | 0            | 3577.04     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | [ContractNo]   | [AllocRef_NSF]     | 1               | 89738.00  | 7235.00  | 8287.00  | 3021.00  | 10867.00 | 9072.00  | 4890.00  | 7374.00  | 4146.00  | 3765.00  | 12363.00 | 12533.00 | 6185.00  | 
    | [ContractNo]   | [AllocRef_NSF]     | 2               | 41067.00  | 5587.00  | 5130.00  | 661.00   | 4006.00  | 7763.00  | 714.00   | 120.00   | 1903.00  | 2392.00  | 4653.00  | 7933.00  | 205.00   | 
    | [ContractNo]   | [AllocRef_NSF]     | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 5               | 48671.00  | 1648.00  | 3157.00  | 2360.00  | 6861.00  | 1309.00  | 4176.00  | 7254.00  | 2243.00  | 1373.00  | 7710.00  | 4600.00  | 5980.00  | 
    | [ContractNo]   | [AllocRef_NSF]     | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_STFI]    | 1               | 48191.00  | 225.00   | 7921.00  | 735.00   | 6393.00  | 5321.00  | 6425.00  | 3113.00  | 5098.00  | 4981.00  | 7444.00  | 55.00    | 480.00   | 
    | [ContractNo]   | [AllocRef_STFI]    | 2               | 57906.00  | 7157.00  | 3028.00  | 5353.00  | 4217.00  | 1786.00  | 6967.00  | 7327.00  | 2518.00  | 6882.00  | 7582.00  | 1754.00  | 3335.00  | 
    | [ContractNo]   | [AllocRef_STFI]    | 3               | 45879.00  | 6542.00  | 650.00   | 6648.00  | 4557.00  | 767.00   | 4185.00  | 3994.00  | 342.00   | 5459.00  | 172.00   | 5968.00  | 6595.00  | 
    | [ContractNo]   | [AllocRef_STFI]    | 4               | 41802.00  | 2603.00  | 6627.00  | 395.00   | 7412.00  | 2264.00  | 1807.00  | 5289.00  | 682.00   | 4439.00  | 3230.00  | 2635.00  | 4419.00  | 
    | [ContractNo]   | [AllocRef_STFI]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_STFI]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_STFI]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_STFI]    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_STFI]    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_STFI]    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_STFI]    | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_STFI]    | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_AEBA]    | 1               | 106975.00 | 11441.00 | 6250.00  | 6419.00  | 11750.00 | 7439.00  | 8692.00  | 8660.00  | 10868.00 | 12195.00 | 10326.00 | 7980.00  | 4955.00  | 
    | [ContractNo]   | [AllocRef_AEBA]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 4               | 60557.00  | 6230.00  | 5572.00  | 3820.00  | 6963.00  | 5487.00  | 4075.00  | 6198.00  | 7780.00  | 5147.00  | 5094.00  | 3141.00  | 1050.00  | 
    | [ContractNo]   | [AllocRef_AEBA]    | 5               | 46418.00  | 5211.00  | 678.00   | 2599.00  | 4787.00  | 1952.00  | 4617.00  | 2462.00  | 3088.00  | 7048.00  | 5232.00  | 4839.00  | 3905.00  | 
    | [ContractNo]   | [AllocRef_AEBA]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | [ContractNo]   | [AllocRef_NSF]     | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NSF]     | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NSF]     | 3               | 2755.17   | 1951.00  | 804.17   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NSF]     | 4               | 1482.48   | 627.27   | 855.21   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NSF]     | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NSF]     | 6               | 1905.17   | 1274.11  | 631.06   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NSF]     | 7               | 2729.42   | 1790.98  | 938.44   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NSF]     | 8               | 1610.99   | 615.15   | 995.84   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NSF]     | 9               | 3909.62   | 1977.70  | 1931.92  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_NSF]     | 10              | 4114.97   | 1956.70  | 2158.27  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | [ContractNo]   | [AllocRef_STFI]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_STFI]    | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_STFI]    | 3               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_STFI]    | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_STFI]    | 5               | 5351.13   | 3062.68  | 2288.45  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_STFI]    | 6               | 4974.78   | 1921.44  | 3053.34  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_STFI]    | 7               | 6374.14   | 3923.76  | 2450.38  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_STFI]    | 8               | 4252.65   | 1974.73  | 2277.92  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_STFI]    | 9               | 5624.78   | 2866.75  | 2758.03  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_STFI]    | 10              | 6172.80   | 3299.57  | 2873.23  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_STFI]    | 11              | 4973.08   | 1543.30  | 3429.78  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_STFI]    | 12              | 6826.77   | 4679.30  | 2147.47  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | [ContractNo]   | [AllocRef_AEBA]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AEBA]    | 2               | 3008.75   | 656.38   | 2352.37  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AEBA]    | 3               | 980.07    | 514.81   | 465.26   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AEBA]    | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AEBA]    | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AEBA]    | 6               | 2567.98   | 564.11   | 2003.87  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AEBA]    | 7               | 2111.17   | 1411.24  | 699.93   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AEBA]    | 8               | 1323.40   | 478.56   | 844.84   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AEBA]    | 9               | 3073.78   | 1469.21  | 1604.57  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_AEBA]    | 10              | 2023.94   | 1163.17  | 860.77   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | [ContractNo]   | [AllocRef_NSF]     | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 3               | 2755.17   | 0.00     | 2755.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 4               | 1482.48   | 0.00     | 1482.48  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 6               | 1905.17   | 0.00     | 1905.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 7               | 2729.42   | 0.00     | 2729.42  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 8               | 1610.99   | 0.00     | 1610.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 9               | 3909.62   | 0.00     | 3909.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NSF]     | 10              | 4114.97   | 0.00     | 4114.97  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_STFI]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_STFI]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_STFI]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_STFI]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_STFI]    | 5               | 5351.13   | 0.00     | 5351.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_STFI]    | 6               | 4974.78   | 0.00     | 4974.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_STFI]    | 7               | 6374.14   | 0.00     | 6374.14  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_STFI]    | 8               | 4252.65   | 0.00     | 4252.65  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_STFI]    | 9               | 5624.78   | 0.00     | 5624.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_STFI]    | 10              | 6172.80   | 0.00     | 6172.80  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_STFI]    | 11              | 4973.08   | 0.00     | 4973.08  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_STFI]    | 12              | 6826.77   | 0.00     | 6826.77  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_AEBA]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 2               | 3008.75   | 0.00     | 3008.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 3               | 980.07    | 0.00     | 980.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 6               | 2567.98   | 0.00     | 2567.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 7               | 2111.17   | 0.00     | 2111.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 8               | 1323.40   | 0.00     | 1323.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 9               | 3073.78   | 0.00     | 3073.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_AEBA]    | 10              | 2023.94   | 0.00     | 2023.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 





    # Part 6: Create and check the contents of the CDA report
   
    # Change the date
#    Given the override date is '05/10/2022'
    
    # Check the contents of the CDA report
#    And   there is no CDA report named 'CDA Last Approved Version A108.csv'

#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | [ContractNo]   | 1                     |

   #When  the following CDA reports are run
#    When  the following CDA report is run
#    | FundingStreamPeriod             | Version               | Suffix |
#    | AEB-AS2223,AEB-NSF2223,STFI2223 | Last Approved         | A108   |

#    Then  a report named 'CDA Last Approved Version A108.csv' is created

    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | AEB-AS2223              | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 19+ Hardship                            | Adult Skills 19+ Hardship                                       | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 564.11       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100927                   | 2372016           | Aug              |
#    | AEB-AS2223              | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 19+ Hardship                            | Adult Skills 19+ Hardship                                       | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 2003.87      | 0             |              | Yes                | 0.00           | 0.00             | 2567.98               | 0.00           | 2567.98         |             | No            |                   |        |                   | 100927                   | 2372016           | Sep              |
#    | AEB-AS2223              | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 20+ Childcare                           | Adult Skills 20+ Childcare                                      | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 1411.24      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100928                   | 2372016           | Aug              |
#    | AEB-AS2223              | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 20+ Childcare                           | Adult Skills 20+ Childcare                                      | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 699.93       | 0             |              | Yes                | 0.00           | 0.00             | 2111.17               | 0.00           | 2111.17         |             | No            |                   |        |                   | 100928                   | 2372016           | Sep              |
#    | AEB-AS2223              | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Administration Expenditure              | Adult Skills Administration Expenditure                         | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 1469.21      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100930                   | 2372016           | Aug              |
#    | AEB-AS2223              | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Administration Expenditure              | Adult Skills Administration Expenditure                         | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 1604.57      | 0             |              | Yes                | 0.00           | 0.00             | 3073.78               | 0.00           | 3073.78         |             | No            |                   |        |                   | 100930                   | 2372016           | Sep              |
#    | AEB-AS2223              | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills COVID-19 Response (ICT)                 | Adult Skills COVID-19 Response (ICT)                            | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 1163.17      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100931                   | 2372016           | Aug              |
#    | AEB-AS2223              | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills COVID-19 Response (ICT)                 | Adult Skills COVID-19 Response (ICT)                            | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 860.77       | 0             |              | Yes                | 0.00           | 0.00             | 2023.94               | 0.00           | 2023.94         |             | No            |                   |        |                   | 100931                   | 2372016           | Sep              |
#    | AEB-AS2223              | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Learning Support                        | Adult Skills Learning Support                                   | Adult Skills                                                    | 8                 | 2022            | 2022/23       |              | 0            | 514.81       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2372060                  | 2372016           | Aug              |
#    | AEB-AS2223              | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Learning Support                        | Adult Skills Learning Support                                   | Adult Skills                                                    | 9                 | 2022            | 2022/23       |              | 0            | 465.26       | 0             |              | Yes                | 0.00           | 0.00             | 980.07                | 0.00           | 980.07          |             | No            |                   |        |                   | 2372060                  | 2372016           | Sep              |
#    | AEB-AS2223              | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Programme Funding                       | Adult Skills Programme Funding                                  | Adult Skills                                                    | 8                 | 2022            | 2022/23       |              | 0            | 656.38       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2372010                  | 2372016           | Aug              |
#    | AEB-AS2223              | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Programme Funding                       | Adult Skills Programme Funding                                  | Adult Skills                                                    | 9                 | 2022            | 2022/23       |              | 0            | 2352.37      | 0             |              | Yes                | 0.00           | 0.00             | 3008.75               | 0.00           | 3008.75         |             | No            |                   |        |                   | 2372010                  | 2372016           | Sep              |
#    | AEB-AS2223              | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Residential Access Fund                 | Adult Skills Residential Access Fund                            | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 478.56       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100929                   | 2372016           | Aug              |
#    | AEB-AS2223              | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_AEBA]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Residential Access Fund                 | Adult Skills Residential Access Fund                            | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 844.84       | 0             |              | Yes                | 0.00           | 0.00             | 1323.40               | 0.00           | 1323.40         |             | No            |                   |        |                   | 100929                   | 2372016           | Sep              |
#    #
#    | AEB-NSF2223             | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund 19+ Hardship                    | National Skills Fund 19+ Hardship                               | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 1274.11      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100937                   | 100944            | Aug              |
#    | AEB-NSF2223             | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund 19+ Hardship                    | National Skills Fund 19+ Hardship                               | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 631.06       | 0             |              | Yes                | 0.00           | 0.00             | 1905.17               | 0.00           | 1905.17         |             | No            |                   |        |                   | 100937                   | 100944            | Sep              |
#    | AEB-NSF2223             | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund 20+ Childcare                   | National Skills Fund 20+ Childcare                              | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 1790.98      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100938                   | 100944            | Aug              |
#    | AEB-NSF2223             | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund 20+ Childcare                   | National Skills Fund 20+ Childcare                              | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 938.44       | 0             |              | Yes                | 0.00           | 0.00             | 2729.42               | 0.00           | 2729.42         |             | No            |                   |        |                   | 100938                   | 100944            | Sep              |
#    | AEB-NSF2223             | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Administration Expenditure      | National Skills Fund Administration Expenditure                 | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 1977.7       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100940                   | 100944            | Aug              |
#    | AEB-NSF2223             | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Administration Expenditure      | National Skills Fund Administration Expenditure                 | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 1931.92      | 0             |              | Yes                | 0.00           | 0.00             | 3909.62               | 0.00           | 3909.62         |             | No            |                   |        |                   | 100940                   | 100944            | Sep              |
#    | AEB-NSF2223             | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund COVID-19 Response (ICT)         | National Skills Fund COVID-19 Response (ICT)                    | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 1956.7       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100941                   | 100944            | Aug              |
#    | AEB-NSF2223             | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund COVID-19 Response (ICT)         | National Skills Fund COVID-19 Response (ICT)                    | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 2158.27      | 0             |              | Yes                | 0.00           | 0.00             | 4114.97               | 0.00           | 4114.97         |             | No            |                   |        |                   | 100941                   | 100944            | Sep              |
#    | AEB-NSF2223             | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Learning Support                | National Skills Fund Learning Support                           | National Skills Fund Total Funding                              | 8                 | 2022            | 2022/23       |              | 0            | 627.27       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100943                   | 100944            | Aug              |
#    | AEB-NSF2223             | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Learning Support                | National Skills Fund Learning Support                           | National Skills Fund Total Funding                              | 9                 | 2022            | 2022/23       |              | 0            | 855.21       | 0             |              | Yes                | 0.00           | 0.00             | 1482.48               | 0.00           | 1482.48         |             | No            |                   |        |                   | 100943                   | 100944            | Sep              |
#    | AEB-NSF2223             | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Programme Funding               | National Skills Fund Programme Funding                          | National Skills Fund Total Funding                              | 8                 | 2022            | 2022/23       |              | 0            | 1951         | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100942                   | 100944            | Aug              |
#    | AEB-NSF2223             | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Programme Funding               | National Skills Fund Programme Funding                          | National Skills Fund Total Funding                              | 9                 | 2022            | 2022/23       |              | 0            | 804.17       | 0             |              | Yes                | 0.00           | 0.00             | 2755.17               | 0.00           | 2755.17         |             | No            |                   |        |                   | 100942                   | 100944            | Sep              |
#    | AEB-NSF2223             | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Residential Access Fund         | National Skills Fund Residential Access Fund                    | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 615.15       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100939                   | 100944            | Aug              |
#    | AEB-NSF2223             | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_NSF]           | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Residential Access Fund         | National Skills Fund Residential Access Fund                    | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 995.84       | 0             |              | Yes                | 0.00           | 0.00             | 1610.99               | 0.00           | 1610.99         |             | No            |                   |        |                   | 100939                   | 100944            | Sep              |
#    #
#    | STFI2223                | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 1 Learning Support     | Short Term Funding Initiative 1 Learning Support                | Short Term Funding Initiative 1                                 | 8                 | 2022            | 2022/23       |              | 0            | 1921.44      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374010                  | 2374010           | Aug              |
#    | STFI2223                | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 1 Learning Support     | Short Term Funding Initiative 1 Learning Support                | Short Term Funding Initiative 1                                 | 9                 | 2022            | 2022/23       |              | 0            | 3053.34      | 0             |              | Yes                | 0.00           | 0.00             | 4974.78               | 0.00           | 4974.78         |             | No            |                   |        |                   | 2374010                  | 2374010           | Sep              |
#    | STFI2223                | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 1 Programme Funding    | Short Term Funding Initiative 1 Programme Funding               | Short Term Funding Initiative 1                                 | 8                 | 2022            | 2022/23       |              | 0            | 3062.68      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374010                  | 2374010           | Aug              |
#    | STFI2223                | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 1 Programme Funding    | Short Term Funding Initiative 1 Programme Funding               | Short Term Funding Initiative 1                                 | 9                 | 2022            | 2022/23       |              | 0            | 2288.45      | 0             |              | Yes                | 0.00           | 0.00             | 5351.13               | 0.00           | 5351.13         |             | No            |                   |        |                   | 2374010                  | 2374010           | Sep              |
#    | STFI2223                | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 2 Learning Support     | Short Term Funding Initiative 2 Learning Support                | Short Term Funding Initiative 2                                 | 8                 | 2022            | 2022/23       |              | 0            | 1974.73      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374020                  | 2374020           | Aug              |
#    | STFI2223                | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 2 Learning Support     | Short Term Funding Initiative 2 Learning Support                | Short Term Funding Initiative 2                                 | 9                 | 2022            | 2022/23       |              | 0            | 2277.92      | 0             |              | Yes                | 0.00           | 0.00             | 4252.65               | 0.00           | 4252.65         |             | No            |                   |        |                   | 2374020                  | 2374020           | Sep              |
#    | STFI2223                | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 2 Programme Funding    | Short Term Funding Initiative 2 Programme Funding               | Short Term Funding Initiative 2                                 | 8                 | 2022            | 2022/23       |              | 0            | 3923.76      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374020                  | 2374020           | Aug              |
#    | STFI2223                | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 2 Programme Funding    | Short Term Funding Initiative 2 Programme Funding               | Short Term Funding Initiative 2                                 | 9                 | 2022            | 2022/23       |              | 0            | 2450.38      | 0             |              | Yes                | 0.00           | 0.00             | 6374.14               | 0.00           | 6374.14         |             | No            |                   |        |                   | 2374020                  | 2374020           | Sep              |
#    | STFI2223                | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 3 Learning Support     | Short Term Funding Initiative 3 Learning Support                | Short Term Funding Initiative 3                                 | 8                 | 2022            | 2022/23       |              | 0            | 3299.57      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374030                  | 2374030           | Aug              |
#    | STFI2223                | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 3 Learning Support     | Short Term Funding Initiative 3 Learning Support                | Short Term Funding Initiative 3                                 | 9                 | 2022            | 2022/23       |              | 0            | 2873.23      | 0             |              | Yes                | 0.00           | 0.00             | 6172.80               | 0.00           | 6172.80         |             | No            |                   |        |                   | 2374030                  | 2374030           | Sep              |
#    | STFI2223                | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 3 Programme Funding    | Short Term Funding Initiative 3 Programme Funding               | Short Term Funding Initiative 3                                 | 8                 | 2022            | 2022/23       |              | 0            | 2866.75      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374030                  | 2374030           | Aug              |
#    | STFI2223                | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 3 Programme Funding    | Short Term Funding Initiative 3 Programme Funding               | Short Term Funding Initiative 3                                 | 9                 | 2022            | 2022/23       |              | 0            | 2758.03      | 0             |              | Yes                | 0.00           | 0.00             | 5624.78               | 0.00           | 5624.78         |             | No            |                   |        |                   | 2374030                  | 2374030           | Sep              |
#    | STFI2223                | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 4 Learning Support     | Short Term Funding Initiative 4 Learning Support                | Short Term Funding Initiative 4                                 | 8                 | 2022            | 2022/23       |              | 0            | 4679.3       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374040                  | 2374040           | Aug              |
#    | STFI2223                | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 4 Learning Support     | Short Term Funding Initiative 4 Learning Support                | Short Term Funding Initiative 4                                 | 9                 | 2022            | 2022/23       |              | 0            | 2147.47      | 0             |              | Yes                | 0.00           | 0.00             | 6826.77               | 0.00           | 6826.77         |             | No            |                   |        |                   | 2374040                  | 2374040           | Sep              |
#    | STFI2223                | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 4 Programme Funding    | Short Term Funding Initiative 4 Programme Funding               | Short Term Funding Initiative 4                                 | 8                 | 2022            | 2022/23       |              | 0            | 1543.3       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374040                  | 2374040           | Aug              |
#    | STFI2223                | 10017108 | 10017108 Co Ltd             |               |                             | [AllocRef_STFI]          | [ContractNo]   | ESFA-108                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 4 Programme Funding    | Short Term Funding Initiative 4 Programme Funding               | Short Term Funding Initiative 4                                 | 9                 | 2022            | 2022/23       |              | 0            | 3429.78      | 0             |              | Yes                | 0.00           | 0.00             | 4973.08               | 0.00           | 4973.08         |             | No            |                   |        |                   | 2374040                  | 2374040           | Sep              |
#




    # Part 7a: Payment Batch for AEB-AS2223

    # Change the date
    Given the override date is '10/10/2022 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEB-AS2223' AccountingPaymentPeriod '202206' CensusEndDate '10/10/2022' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_AEBA]          | 202209 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEB-AS2223                 | 202209               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEB-AS2223                 | 202209               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-AS2223' PaymentPeriod '202206' CensusEndDate '10/10/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A108_AS.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-AS2223' PaymentPeriod '202206' CensusEndDate '10/10/2022' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AEBA                   | 2022          | 06             | 10          | ?       | [AllocRef_AEBA]  | 3008.75         | RECONCILIATION   | AEB Other Learning                 | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017108 | 2372010    |
    | AEBA                   | 2022          | 06             | 10          | ?       | [AllocRef_AEBA]  | 980.07          | RECONCILIATION   | AEB OthLearning LngS               | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017108 | 2372060    |
    | AEBA                   | 2022          | 06             | 10          | ?       | [AllocRef_AEBA]  | 2567.98         | RECONCILIATION   | AdltSkll19+Hardship                | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017108 | 100927     |
    | AEBA                   | 2022          | 06             | 10          | ?       | [AllocRef_AEBA]  | 2111.17         | RECONCILIATION   | AdltSkll20+Childcare               | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017108 | 100928     |
    | AEBA                   | 2022          | 06             | 10          | ?       | [AllocRef_AEBA]  | 1323.40         | RECONCILIATION   | AdltSkllRsdntlAccess               | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017108 | 100929     |
    | AEBA                   | 2022          | 06             | 10          | ?       | [AllocRef_AEBA]  | 3073.78         | RECONCILIATION   | AdltSkllAdminExp                   | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017108 | 100930     |
    | AEBA                   | 2022          | 06             | 10          | ?       | [AllocRef_AEBA]  | 2023.94         | RECONCILIATION   | AdltSkllC19Response                | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017108 | 100931     |
    #                                                                                                    £15089.09




    # Part 7b: Payment Batch for AEB-NSF2223

    # Change the date
    Given the override date is '10/10/2022 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEB-NSF2223' AccountingPaymentPeriod '202206' CensusEndDate '10/10/2022' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_NSF]           | 202209 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEB-NSF2223                | 202209               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEB-NSF2223                | 202209               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-NSF2223' PaymentPeriod '202206' CensusEndDate '10/10/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A108_NSF.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-NSF2223' PaymentPeriod '202206' CensusEndDate '10/10/2022' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | NSF                    | 2022          | 06             | 10          | ?       | [AllocRef_NSF]   | 2755.17         | RECONCILIATION   | NSF Programme                      | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017108 | 100942     |
    | NSF                    | 2022          | 06             | 10          | ?       | [AllocRef_NSF]   | 1482.48         | RECONCILIATION   | NSF Learning Support               | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017108 | 100943     |
    | NSF                    | 2022          | 06             | 10          | ?       | [AllocRef_NSF]   | 1905.17         | RECONCILIATION   | NSF 19+ Hardship                   | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017108 | 100937     |
    | NSF                    | 2022          | 06             | 10          | ?       | [AllocRef_NSF]   | 2729.42         | RECONCILIATION   | NSF 20+ Childcare                  | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017108 | 100938     |
    | NSF                    | 2022          | 06             | 10          | ?       | [AllocRef_NSF]   | 1610.99         | RECONCILIATION   | NSF RsdntlAccessFund               | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017108 | 100939     |
    | NSF                    | 2022          | 06             | 10          | ?       | [AllocRef_NSF]   | 3909.62         | RECONCILIATION   | NSF Admin Exp                      | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017108 | 100940     |
    | NSF                    | 2022          | 06             | 10          | ?       | [AllocRef_NSF]   | 4114.97         | RECONCILIATION   | NSF COVID19 Response               | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017108 | 100941     |
    #                                                                                                    £18507.82




    # Part 7c: Payment Batch for STFI2223

    # Change the date
    Given the override date is '10/10/2022 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'STFI2223' AccountingPaymentPeriod '202206' CensusEndDate '10/10/2022' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_STFI]          | 202209 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | STFI2223                   | 202209               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | STFI2223                   | 202209               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'STFI2223' PaymentPeriod '202206' CensusEndDate '10/10/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A108_STFI.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'STFI2223' PaymentPeriod '202206' CensusEndDate '10/10/2022' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | STFI                   | 2022          | 06             | 10          | ?       | [AllocRef_STFI]  | 10325.91        | RECONCILIATION   | ShortTermInit1Cntrct               | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017108 | 2374010    |
    | STFI                   | 2022          | 06             | 10          | ?       | [AllocRef_STFI]  | 10626.79        | RECONCILIATION   | ShortTermInit2Cntrct               | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017108 | 2374020    |
    | STFI                   | 2022          | 06             | 10          | ?       | [AllocRef_STFI]  | 11797.58        | RECONCILIATION   | ShortTermInit3Cntrct               | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017108 | 2374030    |
    | STFI                   | 2022          | 06             | 10          | ?       | [AllocRef_STFI]  | 11799.85        | RECONCILIATION   | ShortTermInit4Cntrct               | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017108 | 2374040    |
    #                                                                                                    £ 44550.13





    # Consolidated Payment Summary Report

    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    When a Consolidated Payment Summary Report is created in Sharepoint for '12/10/2022'
    # Check the above report manually

    
    # Tidy Up
 #  Given the override date is reset
    
@AcceptanceTest @Complete
Scenario: A109 Create a 21/22 AEB2021 contract. Update draft contract. Check docs and that doc parts are for 21/22

    # 1. Create a draft AEB2021 contract for 20/21
    # 2. Update draft 21/22 contract without changing the financials and check docs and doc parts

    Given there are no allocations marked as Under Termination for UKPRN '10017109' 
    And   there are no terminated or closed allocations for UKPRN '10017109' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017109' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017109' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017109' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-109      |
    | NSF-109       |
    | STFI-109      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-109      |
    | NSF-109       |
    | STFI-109      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-AS2122        |
    | AEB-NSF2122       |
    | STFI2122          |

#    # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
#    And   there is no Subnominal data in CRM for the following subnominal codes
#    | SubnominalCode |
#    | 100927         |
#    | 100928         |
#    | 100929         |
#    | 100930         |
#    | 100931         |
#    | 2372010        |
#    | 2372016        |
#    | 2372060        |
#
#    | 100937         |
#    | 100938         |
#    | 100939         |
#    | 100940         |
#    | 100941         |
#    | 100942         |
#    | 100943         |
#    | 100944         |
#
#    | 2374010        |
#    | 2374020        |
#    | 2374030        |
#    | 2374040        |


    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP21-109     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017109'

    # Set the 'base' timestamp for each of the 21/22 and 22/23 AEB document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_AEB2021_2021-08-01.docx                     | 2021-06-20 12:00:00.000 | 
    #
    | AEB2021_2122_TAC_2021-08-01.docx                | 2021-06-20 12:00:00.000 | 
    | AEB2021_2122_S1_2021-08-01.docx                 | 2021-06-20 12:00:00.000 | 
    | AEB2021_2122_S2_2021-08-01.docx                 | 2021-06-20 12:00:00.000 | 
    | FA_AEB2021_2122_2021-08-01.docx                 | 2021-06-20 12:00:00.000 | 
    | AEB2021_2122_S3ON_2021-08-01.docx               | 2021-06-20 12:00:00.000 | 
    #
    | AEB2021_2223_TAC_2022-08-01.docx                | 2022-06-20 12:00:00.000 | 
    | AEB2021_2223_S1_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
    | AEB2021_2223_S2_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
    | FA_AEB2021_2223_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
    | AEB2021_2223_S3ON_2022-08-01.docx               | 2022-06-20 12:00:00.000 | 



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017109' 
    And   there is no caseload advisor for UKPRN '10017109' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017109 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017109' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017109 Co Ltd' with UKPRN '10017109' and OrgId 'ORG0017109' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017109 | 117109 | 10017109 Co Ltd | 0              | Active                | Yes           | AA017109      | ?             | 91 Hullbridge Road     | South Woodham Ferrers  | ?                      | ?                      | Chelmsford             | Essex                  | CM3 5LJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017109 |





    # Part 1: Create a draft AEB2021 contract for 20/21

    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP21-109'
    And   there are no details in ContractManagement.CreatedContract for 'AEBP21-109'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017109 | 10017109 Co Ltd      | ESFA-109             | AEBP21-109     | 1                     | 01/08/2021        | 31/07/2022      | 182779.00     |                                       | Contract for Services                      | 2122   | New          | ORG0017109 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017109 | AEBP21-109     | AEBA-109      | AEB-AS            | AEB-AS2122              | AY                      | 01/08/2021          | 31/07/2022        | 51421.00        |                                         |            |                                                             | New          |             |
    | 10017109 | AEBP21-109     | NSF-109       | AEB-NSF           | AEB-NSF2122             | AY                      | 01/08/2021          | 31/07/2022        | 45927.00        |                                         |            |                                                             | New          |             |
    | 10017109 | AEBP21-109     | STFI-109      | STFI              | STFI2122                | AY                      | 01/08/2021          | 31/07/2022        | 85431.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017109 | AEBP21-109     | AEBA-109      | 1               | 0                     | 51421.00  | 37295.00  | 14126.00  | 5697.00  | 5683.00  | 3009.00  | 3626.00  | 6458.00  | 5366.00  | 3958.00  | 3498.00  | 1176.00  | 3690.00  | 6266.00  | 2994.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017109 | AEBP21-109     | AEBA-109      | 4               | 1                     | 27394.00  | 19770.00  | 7624.00   | 2637.00  | 3626.00  | 661.00   | 3136.00  | 3112.00  | 2203.00  | 1229.00  | 3166.00  | 1056.00  | 1950.00  | 2969.00  | 1649.00  | Adult Skills                                                    | New          |             | 
    | 10017109 | AEBP21-109     | AEBA-109      | 5               | 1                     | 24027.00  | 17525.00  | 6502.00   | 3060.00  | 2057.00  | 2348.00  | 490.00   | 3346.00  | 3163.00  | 2729.00  | 332.00   | 120.00   | 1740.00  | 3297.00  | 1345.00  | Adult Skills Learner Support                                    | New          |             | 
    #
    | 10017109 | AEBP21-109     | NSF-109       | 1               | 0                     | 45927.00  | 30587.00  | 15340.00  | 4982.00  | 6138.00  | 934.00   | 757.00   | 4759.00  | 4839.00  | 5584.00  | 2594.00  | 3178.00  | 3163.00  | 4191.00  | 4808.00  | National Skills Fund Total Funding                              | New          |             | 
    | 10017109 | AEBP21-109     | NSF-109       | 2               | 1                     | 23289.00  | 15549.00  | 7740.00   | 3451.00  | 3174.00  | 303.00   | 531.00   | 1583.00  | 3110.00  | 3213.00  | 184.00   | 886.00   | 516.00   | 2611.00  | 3727.00  | Level 3 Offer for 24 year olds and over                         | New          |             | 
    | 10017109 | AEBP21-109     | NSF-109       | 5               | 1                     | 22638.00  | 15038.00  | 7600.00   | 1531.00  | 2964.00  | 631.00   | 226.00   | 3176.00  | 1729.00  | 2371.00  | 2410.00  | 2292.00  | 2647.00  | 1580.00  | 1081.00  | National Skills Fund Learner Support                            | New          |             | 
    #
    | 10017109 | AEBP21-109     | STFI-109      | 1               | 0                     | 23777.00  | 15546.00  | 8231.00   | 1524.00  | 3683.00  | 906.00   | 852.00   | 1998.00  | 2260.00  | 2458.00  | 1865.00  | 3644.00  | 1025.00  | 496.00   | 3066.00  | Short Term Funding Initiative 1                                 | New          |             | 
    | 10017109 | AEBP21-109     | STFI-109      | 2               | 0                     | 17930.00  | 10993.00  | 6937.00   | 733.00   | 900.00   | 2363.00  | 693.00   | 1019.00  | 2007.00  | 2743.00  | 535.00   | 1493.00  | 584.00   | 3312.00  | 1548.00  | Short Term Funding Initiative 2                                 | New          |             | 
    | 10017109 | AEBP21-109     | STFI-109      | 3               | 0                     | 22387.00  | 16759.00  | 5628.00   | 2337.00  | 2248.00  | 548.00   | 2930.00  | 469.00   | 3167.00  | 3459.00  | 1601.00  | 3474.00  | 573.00   | 138.00   | 1443.00  | Short Term Funding Initiative 3                                 | New          |             | 
    | 10017109 | AEBP21-109     | STFI-109      | 4               | 0                     | 21337.00  | 13592.00  | 7745.00   | 3136.00  | 1055.00  | 2612.00  | 660.00   | 97.00    | 3521.00  | 650.00   | 1861.00  | 2913.00  | 739.00   | 3561.00  | 532.00   | Short Term Funding Initiative 4                                 | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP21-109     | 1                     | 0                        | 2021-07-01 09:12:35.000 |

#    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP21-109'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Inject an SFS approval message 
# #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
#    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-109' and ContractNumber 'AEBP21-109' and Version '1'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract 'AEBP21-109' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017109 | AEBP21-109         | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017109 | ESFA-109           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |










    # Part 2: Update draft 21/22 contract without changing the financials and check docs and doc parts
    
    # Change the date
    Given the override date is '23/08/2021'

    # Bulk file
    And   there are no files prefixed '10017109' in the Sharepoint 'AEB2021-2122-Input-Appendices' folder
    And   there are no files prefixed 'AEB2021 AY 2122 01062022115942 v3_A109' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB2021 AY 2122 01062022115942 v3_A109' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB2021 AY 2122 01062022115942 v3_A109' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB2021 AY 2122 01062022115942 v3_A109' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB2021 AY 2122 01062022115942 v3_A109.xlsx' exists in the Datafiles folder and UKPRN '10017109' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017109' for FundingType 'AEB2021' and period '2122' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017109' for FundingType 'AEB2021' and period '2122'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, FA x3, Sch3ON)  (These should be 21/22 versions)
    Then  the file named '10017109_AEBP21-109_v1.pdf' in Sharepoint location 'AEB2021-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017109 Co Ltd UKPRN: 10017109
    Master Contract Number: ESFA-109
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) AEBA-109 £37,295 £14,126 £51,421
    of which Learner Support £17,525 £6,502 £24,027
    ESFA AEB - National Skills Fund (procured from Aug 2021) NSF-109 £30,587 £15,340 £45,927
    of which Level 3 Offer for 24 year olds and over £15,549 £7,740 £23,289
    of which Learner Support £15,038 £7,600 £22,638
    ESFA AEB - Short Term Funding Initiatives (procured from
    STFI-109 £56,890 £28,541 £85,431
    Aug 2021)
    of which Short Term Funding Initiative 1 £15,546 £8,231 £23,777
    of which Short Term Funding Initiative 2 £10,993 £6,937 £17,930
    of which Short Term Funding Initiative 3 £16,759 £5,628 £22,387
    of which Short Term Funding Initiative 4 £13,592 £7,745 £21,337
    Total: £182,779
    Total Funding for this contract: £182,779
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017109 Co Ltd
    Funding for ESFA Adult Education Budget (Contract for Services)
    Master Contract Number ESFA-109
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017109 Co Ltd THE SECRETARY OF STATE FOR
    91 Hullbridge Road EDUCATION
    South Woodham Ferrers DEPARTMENT FOR EDUCATION
    Chelmsford 20 GREAT SMITH STREET
    AND
    Essex LONDON
    CM3 5LJ SW1P 3BT
    Company No: AA017109
    Hereinafter called Hereinafter called
    the Contractor the Department
    ESFA Adult Education Budget (Procured) Version 3 (April 2022) - Page 2
    ESFA Adult Education Budget (Procured) Version 3 (April 2022) - Page 78
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET CONTRACT FOR SERVICES 2021/22
    ESFA Adult Education Budget (Procured) Schedule 1 Version 2 (March 2022) – Page 1
    ESFA Adult Education Budget (Procured) Schedule 1 Version 2 (March 2022) – Page 12
    
    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (CONTRACT FOR SERVICES)
    ESFA Adult Education Budget (Procured) Schedule 2 Version 1 (July 2021) – Page 1
    ESFA Adult Education Budget (Procured) Schedule 2 Version 1 (July 2021) – Page 2
    
    SCHEDULE 2
    Funding Agreement – ESFA-Funded Adult Education Budget - Adult Skills (procured from Aug 2021)
    Provider: 10017109 Co Ltd UKPRN: 10017109
    Master Contract Number: ESFA-109 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: AEBA-109
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    ESFA AEB - Adult Skills £51,421 £5,697 £5,683 £3,009 £3,626 £6,458 £5,366 £3,958 £3,498 £1,176 £3,690 £6,266 £2,994
    of which Learner Support £24,027 £3,060 £2,057 £2,348 £490 £3,346 £3,163 £2,729 £332 £120 £1,740 £3,297 £1,345
    Total Funding £51,421 £5,697 £5,683 £3,009 £3,626 £6,458 £5,366 £3,958 £3,498 £1,176 £3,690 £6,266 £2,994
    Schedule 2 – Funding Agreement AEBA-109 – Page 1 Ref (for internal use only):  AEBP21-109 v1
    
    SCHEDULE 2
    Funding Agreement – ESFA-Funded Adult Education Budget - National Skills Fund (procured from Aug 2021)
    Provider: 10017109 Co Ltd UKPRN: 10017109
    Master Contract Number: ESFA-109 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: NSF-109
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    ESFA AEB - National Skills Fund £45,927 £4,982 £6,138 £934 £757 £4,759 £4,839 £5,584 £2,594 £3,178 £3,163 £4,191 £4,808
    of which Level 3 Offer for 24 year olds and over £23,289 £3,451 £3,174 £303 £531 £1,583 £3,110 £3,213 £184 £886 £516 £2,611 £3,727
    of which Learner Support £22,638 £1,531 £2,964 £631 £226 £3,176 £1,729 £2,371 £2,410 £2,292 £2,647 £1,580 £1,081
    Total Funding £45,927 £4,982 £6,138 £934 £757 £4,759 £4,839 £5,584 £2,594 £3,178 £3,163 £4,191 £4,808
    Schedule 2 – Funding Agreement NSF-109 – Page 1 Ref (for internal use only):  AEBP21-109 v1
    
    SCHEDULE 2
    Funding Agreement – ESFA-Funded Adult Education Budget - Short Term Funding Initiatives (procured from Aug 2021)
    Provider: 10017109 Co Ltd UKPRN: 10017109
    Master Contract Number: ESFA-109 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: STFI-109
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    ESFA AEB - Short Term Funding Initiative 1 £23,777 £1,524 £3,683 £906 £852 £1,998 £2,260 £2,458 £1,865 £3,644 £1,025 £496 £3,066
    ESFA AEB - Short Term Funding Initiative 2 £17,930 £733 £900 £2,363 £693 £1,019 £2,007 £2,743 £535 £1,493 £584 £3,312 £1,548
    ESFA AEB - Short Term Funding Initiative 3 £22,387 £2,337 £2,248 £548 £2,930 £469 £3,167 £3,459 £1,601 £3,474 £573 £138 £1,443
    ESFA AEB - Short Term Funding Initiative 4 £21,337 £3,136 £1,055 £2,612 £660 £97 £3,521 £650 £1,861 £2,913 £739 £3,561 £532
    Total Funding £85,431 £7,730 £7,886 £6,429 £5,135 £3,583 £10,955 £9,310 £5,862 £11,524 £2,921 £7,507 £6,589
    Schedule 2 – Funding Agreement STFI-109 – Page 1 Ref (for internal use only):  AEBP21-109 v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    ESFA Adult Education Budget (Procured) Schedule 3 Version 1 (July 2021) – Page 1
    ESFA Adult Education Budget (Procured) Schedule 9 Version 1 (July 2021) – Page 1
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP21-109     | 1                     | 1                        | 2021-08-23 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017109_AEBP21-109_v1.pdf' in 'AEB2021-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A109.pdf'


    # Tidy Up
    Given the override date is reset


