Feature: CreateEDSKContracts 39333

@AcceptanceTest @Withdrawn20251024
@FundingClaims
Scenario: S027 Create and approve an EDSK2324 contract with AEBC-19TRN2324, AEBC-ASCL2324, AEBC-NSF2324,  ALLBC2324 and STFIC2324 allocs. Approve. Notification amendment v2. Payment generation.
    
    # 1. Create and approve an EDSK2324 contract with all four FCR allocs. Check CRM and feed
    # 2. Populate the stub with Claim data
    # 3. Consume stub data and check CRM
    # 4. Update FCR and check CRM
    # 5. Publish FCR. Check CRM and feed
    # 6. Validate new field addition EarningsBoostValue
    
    Given there are no allocations marked as Under Termination for UKPRN '10018027' 
    And   there are no terminated or closed allocations for UKPRN '10018027' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018027' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018027' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018027' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-027      |
    | AECT-027      |
    | ALLC-027      |
    | NSFC-027      |
    | STFC-027      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-027      |
    | AECT-027      |
    | ALLC-027      |
    | NSFC-027      |
    | STFC-027      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-19TRN2324    |
    | AEBC-ASCL2324     |
    | AEBC-NSF2324      |
    | ALLBC2324         |
    | STFIC2324         |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-1027      | 1                     | 0                        |

    

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018027'



    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10018027 |

    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    Given there is no data in the Reconciliation Profiling table for UKPRN '10018027' and FundingPeriod 'AY2223'

 #  # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
 #  And   the Reconciliation Profiling table includes a row for UKPRN '10018027' and FundingPeriod 'AY2223'

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AECT-027      |
    | AECA-027      |
    | NSFC-027      |
    | ALLC-027      |
    | STFC-027      |

    
    # Set the base timestamp for each of the  document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                         | UploadTimestamp         |
    | FA_EDSK2324_2023-08-01.docx                  | 2023-02-20 10:00:00.000 |
    | EDSK2324_S3_AEB_AA_LA_2023-08-01.docx        | 2023-02-20 10:00:00.000 |
    | EDSK2324_S3_AEB_AA_COLLEGE_2023-08-01.docx   | 2023-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_AA_LA_2023-08-01.docx        | 2023-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_AA_COLLEGE_2023-08-01.docx   | 2023-02-20 10:00:00.000 |
    | EDSK2324_S2_AEB_COFG_2023-08-01.docx         | 2023-02-20 10:00:00.000 |
    | EDSK2324_S1_AEB_COFG_2023-08-01.docx         | 2023-02-20 10:00:00.000 |


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018027' 
    And   there is no caseload advisor for UKPRN '10018027' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018027 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018027' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018027 Co Ltd' with UKPRN '10018027' and OrgId 'ORG0018027' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018027 | 118027 | 10018027 Co Ltd | 0              | In Administration     | Yes           | AA118027      | ?             | 7 Coventry Hill        | ?                      | ?                      | ?                      | High Wycombe           | Coventry			     | HP13 6NS  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018027 |





    # Part 1: Create and approve an EDSK2324 contract with all four FCR allocs. Check CRM and feed
    
    # Change the date
    Given the override date is '01/07/2023'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'EDSK-1027'
    And   there are no details in ContractManagement.CreatedContract for 'EDSK-1027'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription   | ContractType                           | Period | CRMIntent    | OrgId      |
    | 10018027 | 10018027 Co Ltd      | ESFA-1027            | EDSK-1027      | 1                     | 01/08/2023        | 31/07/2024      | 112978.00      |                       | Conditions of Funding (Grant) (HEI)    | 2324   | New          | ORG0018027 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName    | UoPCode    | AllocationDescription        | CRMIntent    | DeliveryOrg |
    | 10018027 | EDSK-1027       | AECA-027      | AEBC-ASCL         | AEBC-ASCL2324           | AY                      | 01/08/2023          | 31/07/2024        | 40751.00        |            |            |                              | New          |             |
    | 10018027 | EDSK-1027       | AECT-027      | AEBC-19TRN        | AEBC-19TRN2324          | AY                      | 01/08/2023          | 31/07/2024        | 21854.00        |            |            |                              | New          |             |
    | 10018027 | EDSK-1027       | ALLC-027      | ALLBC             | ALLBC2324               | AY                      | 01/08/2023          | 31/07/2024        | 20478.00        |            |            |                              | New          |             |
    | 10018027 | EDSK-1027       | NSFC-027      | AEBC-NSF          | AEBC-NSF2324            | AY                      | 01/08/2023          | 31/07/2024        | 17995.00        |            |            |                              | New          |             |
    | 10018027 | EDSK-1027       | STFC-027      | STFIC             | STFIC2324               | AY                      | 01/08/2023          | 31/07/2024        | 17000.00        |            |            |                              | New          |             |


    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber  | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableDescription                              | CRMIntent    | DeliveryOrg |
    | 10018027 | EDSK-1027       | AECA-027      | 1               | 0                     | 35651.00  | 22628.00  | 13023.00  | 3026.00  | 2883.00  | 2330.00  | 3989.00  | 2710.00  | 3832.00  | 466.00   | 3392.00  | 3753.00  | 3421.00  | 2680.00  | 3169.00  | Adult Skills and Community Learning Total Funding   | New          |             | 
    | 10018027 | EDSK-1027       | AECA-027      | 2               | 1                     | 11604.00  | 8072.00   | 3532.00   | 926.00   | 585.00   | 625.00   | 506.00   | 862.00   | 3496.00  | 279.00   | 793.00   | 1969.00  | 175.00   | 121.00   | 1267.00  | Adult Skills Total Funding                          | New          |             | 
    | 10018027 | EDSK-1027       | AECA-027      | 5               | 1                     | 24047.00  | 14556.00  | 9491.00   | 2100.00  | 2298.00  | 1705.00  | 3483.00  | 1848.00  | 336.00   | 187.00   | 2599.00  | 1784.00  | 3246.00  | 2559.00  | 1902.00  | Community Learning                                  | New          |             | 
    | 10018027 | EDSK-1027       | AECA-027      | 12              | 1                     | 5100.00   | 4100.00   | 1000.00   | 2100.00  | 2000.00  | 0.00     | 3483.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1000.00  | Community Learning                                  | New          |             | 
    | 10018027 | EDSK-1027       | AECT-027      | 1               | 0                     | 21854.00  | 16140.00  | 5714.00   | 2199.00  | 2935.00  | 1709.00  | 1685.00  | 775.00   | 785.00   | 2722.00  | 3330.00  | 523.00   | 2524.00  | 222.00   | 2445.00  | 19-24 Traineeships Total Funding                    | New          |             | 
    | 10018027 | EDSK-1027       | ALLC-027      | 1               | 0                     | 20478.00  | 15221.00  | 5257.00   | 2013.00  | 3288.00  | 447.00   | 3303.00  | 3120.00  | 2685.00  | 289.00   | 76.00    | 1697.00  | 536.00   | 1302.00  | 1722.00  | Total Advanced Learner Loans Bursary Funding        | New          |             | 
    | 10018027 | EDSK-1027       | NSFC-027      | 1               | 0                     | 17995.00  | 10848.00  | 7147.00   | 1736.00  | 2566.00  | 76.00    | 145.00   | 1672.00  | 1775.00  | 2447.00  | 431.00   | 2779.00  | 1173.00  | 2289.00  | 906.00   | Total 16-18 Traineeships Funding                    | New          |             | 
    | 10018027 | EDSK-1027       | NSFC-027      | 2               | 1                     | 17995.00  | 10848.00  | 7147.00   | 1736.00  | 2566.00  | 76.00    | 145.00   | 1672.00  | 1775.00  | 2447.00  | 431.00   | 2779.00  | 1173.00  | 2289.00  | 906.00   | Level 3 Offer for 24 year olds and over             | New          |             | 
    | 10018027 | EDSK-1027       | STFC-027      | 1               | 0                     | 17000.00  | 9853.00   | 7147.00   | 741.00   | 2566.00  | 76.00    | 145.00   | 1672.00  | 1775.00  | 2447.00  | 431.00   | 2779.00  | 1173.00  | 2289.00  | 906.00   | Short Term Funding Initiative 1                     | New          |             | 


    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'
    
    # Check the deliverables have all been created in CRM. Essentially a 'wait'
   #And   there are '84' deliverable period rows in CRM linked to the latest version of contract number 'EDSK-1027'
    And   there are '108' deliverable period rows in CRM linked to the latest version of contract 'EDSK-1027'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-1027'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-1027' and ContractNumber 'EDSK-1027' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-1027' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018027 | EDSK-1027          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018027 | ESFA-1027          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract 'EDSK-1027' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Check the deliverable count in CRM includes all the monitoring deliverables
#   #And   there are '192' deliverable period rows in CRM linked to the latest version of contract number 'EDSK-1027'
#    And   there are '192' deliverable period rows in CRM linked to the latest version of contract 'EDSK-1027'
#
#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | AECT-027        | 2355775          | Jul-24 | Reconciliation |
#    | AECA-027        | 2371175          | Jul-24 | Reconciliation |
#    | NSFC-027        | 100946           | Jul-24 | Reconciliation |
#    | ALLC-027        | 2303975          | Jul-24 | Reconciliation |
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '7' deliverables
#    | UKPRN    | ContractNumber  | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
#    | 10018027 | EDSK-1027       | 1               | AECA-027      | 1               | 0                     | 35651.00     | 0             | 0        | Adult Skills and Community Learning Total Funding               | ?                                                           |
#    | 10018027 | EDSK-1027       | 1               | AECA-027      | 2               | 1                     | 11604.00     | 0             | 0        | Adult Skills Total Funding                                      | ?                                                           |
#    | 10018027 | EDSK-1027       | 1               | AECA-027      | 5               | 1                     | 24047.00     | 0             | 0        | Community Learning                                              | ?                                                           |
#    | 10018027 | EDSK-1027       | 1               | AECT-027      | 1               | 0                     | 21854.00     | 0             | 0        | 19-24 Traineeships Total Funding                                | ?                                                           |
#    | 10018027 | EDSK-1027       | 1               | ALLC-027      | 1               | 0                     | 20478.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding                    | ?                                                           |
#    | 10018027 | EDSK-1027       | 1               | NSFC-027      | 1               | 0                     | 17995.00     | 0             | 0        | Total 16-18 Traineeships Funding                                | ?                                                           |
#    | 10018027 | EDSK-1027       | 1               | NSFC-027      | 2               | 1                     | 17995.00     | 0             | 0        | Level 3 Offer for 24 year olds and over                         | ?                                                           |
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract 'EDSK-1027' agree with the most recent entry for this contract in the ContractManagement feed
#



    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for 'EDSK-1027'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-1027      | 1                     | 0                        | 2023-07-01 09:12:35.000 |

    And 'Fail'

    # T&C document changes then Notification amendment issued 

    # Update timestamp on template (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                         | UploadTimestamp         |
    | FA_EDSK2324_2023-08-01.docx                  | 2023-07-01 10:00:00.000 |
    | EDSK2324_S3_AEB_AA_LA_2023-08-01.docx        | 2023-07-01 10:00:00.000 |
    | EDSK2324_S3_AEB_AA_COLLEGE_2023-08-01.docx   | 2023-07-01 10:00:00.000 |
    | EDSK2324_S2_AEB_AA_LA_2023-08-01.docx        | 2023-07-01 10:00:00.000 |
    | EDSK2324_S2_AEB_AA_COLLEGE_2023-08-01.docx   | 2023-07-01 10:00:00.000 |
    | EDSK2324_S2_AEB_COFG_2023-08-01.docx         | 2023-07-01 10:00:00.000 |
    | EDSK2324_S1_AEB_COFG_2023-08-01.docx         | 2023-07-01 10:00:00.000 |	



    # Change the date to one several days after the date of the revised TAC template
    Given the override date is '28/07/2023'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial notification contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-1027' for a non-financial NOTIFICATION contract amendment


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018027 | EDSK-1027          | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2023        | 31/07/2024      | Notification  |
    | 10018027 | EDSK-1027          | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018027 | ESFA-1027          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |



    # Retrieve parameters for the Contracting Org
   #And  I retrieve the latest EFA contract details from CRM for provider '10018009' for FundingType 'FE-ACA' and period '2223' and Delivery Organisation '10017176'
    And   I retrieve the latest contract details from CRM for provider '10018027' for FundingType 'EDSK' and period '2324'


#/////
#    # Check that only the SoF is produced from the following 'set' of six docs for contract v2
#    #   Summary of Funding, Main Terms and Conditions (TAC), Schedule 1, Schedule 2, Funding Agreement, Schedule 3on
#    And   the file named '10018009_[ContractNo]_v2.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING
#	Organisation Name: 10018009 Co Ltd UKPRN: 10018009
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 30/09/2023
#    Allocation
#    Contract Ref Cost per Learner Number of Total Funding
#    Learners
#    (if fully-funded)
#    Skills Bootcamps £599,730.00
#	of which Data Analyst [AllocRef_SB]-72 £3,050.00 60 £155,550.00
#	of which Digital Marketing [AllocRef_SB]-115 £2,750.00 60 £150,150.00
#	of which Software Development [AllocRef_SB]-189 £3,450.00 60 £184,230.00
#    of which Bay Electech - Electronic Skills Programme 2 [AllocRef_SB]-238 £1,000.00 100 £23,000.00
#    of which Trade Skills Development Centre [AllocRef_SB]-239 £2,000.00 23 £46,000.00
#	of which Plant Operator Skills Bootcamp 2 [AllocRef_SB]-240 £1,200.00 40 £40,800.00
#    Total Funding for this contract: £599,730.00
#    Summary of Funding – Page 1
#
#    """
#
#     # There should not be a T&C document
#	And   the pdf file does not contain the following text
#    """
#    Agreement Type Contract for Services
#    """
#    
#    # There should not be a Schedule 1 document
#	And   the pdf file does not contain the following text
#    """
#    SCHEDULE 1: SPECIFICATION & MONITORING 
#    """
#
#    # There should not be a Schedule 2 document
#	And   the pdf file does not contain the following text
#    """
#    SCHEDULE 2: PAYMENT
#    """
#    
#    # There should not be a Funding Agreement document
#	And   the pdf file does not contain the following text
#    """
#    Funding Agreement
#    """
#
#    # There should not be a Schedule 3ON document
#	And   the pdf file does not contain the following text
#    """
#	SCHEDULE 3: CHANGE CONTROL PROCEDURE
#    """
#////

    # Save a copy of the output
    Then  Sharepoint file '10018027_[ContractNo]_v2.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S027_v2.pdf'
