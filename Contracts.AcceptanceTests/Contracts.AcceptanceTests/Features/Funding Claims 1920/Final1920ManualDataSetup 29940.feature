Feature: Final1920ManualDataSetup 29940

@AcceptanceTest @Withdrawn20230123
Scenario: A517 Create and approve a 1920 EDSK contract with AEBC-19TRN, AEBC-ASCL and ALLBC allocs. Process 1920 Final Funding Claim data for all three allocs. (Claim higher than profile) Bulk amend then publish FCR. Check CRM, feed and financials
    Given there are no allocations marked as Under Termination for UKPRN '10017517' 
    And   there are no terminated or closed allocations for UKPRN '10017517' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017517' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017517' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-517      |
    | AECT-517      |
    | ALLC-517      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-517      |
    | AECT-517      |
    | ALLC-517      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-19TRN1920    |
    | AEBC-ASCL1920     |
    | ALLBC1920         |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-517       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017517'

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017517 |

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Year End      | 1920   |
    | Final         | 1718   |
    | Final         | 1819   |
    | Final         | 1920   |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AECA-517      |
    | AECT-517      |
    | ALLC-517      |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017517' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017517 Co Ltd' with UKPRN '10017517' and OrgId 'ORG0017517' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017517' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017517 | 117517 | 10017517 Co Ltd | 0              | Active                | Yes           | AA017517      | ?             | 4 St John's Court      | Moulsham Street        | ?                      | ?                      | Chelmsford             | Essex                  | CM2 0JD   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017517 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017517 | 10017517 Co Ltd      | ESFA-517             | EDSK-517       | 1                     | 01/08/2019        | 31/07/2020      | 82082.00      |                                       | Conditions of Funding (Grant) (NMSS)       | 1920   | New          | ORG0017517 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017517 | EDSK-517       | AECA-517      | AEBC-ASCL         | AEBC-ASCL1920           | AY                      | 01/08/2019          | 31/07/2020        | 42350.00        |                                         |            |                                                             | New          |             |
    | 10017517 | EDSK-517       | AECT-517      | AEBC-19TRN        | AEBC-19TRN1920          | AY                      | 01/08/2019          | 31/07/2020        | 23005.00        |                                         |            |                                                             | New          |             |
    | 10017517 | EDSK-517       | ALLC-517      | ALLBC             | ALLBC1920               | AY                      | 01/08/2019          | 31/07/2020        | 16727.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017517 | EDSK-517       | AECA-517      | 1               | 0                     | 42350.00  | 28782.00  | 13568.00  | 6635.00  | 1748.00  | 4323.00  | 4753.00  | 2712.00  | 1432.00  | 2554.00  | 4625.00  | 4831.00  | 2475.00  | 2143.00  | 4119.00  | Adult Education Budget Total Funding                            | New          |             | 
    | 10017517 | EDSK-517       | AECA-517      | 2               | 1                     | 18271.00  | 12455.00  | 5816.00   | 3064.00  | 257.00   | 1275.00  | 3657.00  | 1196.00  | 193.00   | 485.00   | 2328.00  | 1482.00  | 1300.00  | 865.00   | 2169.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017517 | EDSK-517       | AECA-517      | 5               | 1                     | 24079.00  | 16327.00  | 7752.00   | 3571.00  | 1491.00  | 3048.00  | 1096.00  | 1516.00  | 1239.00  | 2069.00  | 2297.00  | 3349.00  | 1175.00  | 1278.00  | 1950.00  | Community Learning                                              | New          |             | 
    | 10017517 | EDSK-517       | AECT-517      | 1               | 0                     | 23005.00  | 14704.00  | 8301.00   | 1636.00  | 1265.00  | 3360.00  | 775.00   | 2110.00  | 3543.00  | 1210.00  | 805.00   | 54.00    | 2308.00  | 2950.00  | 2989.00  | 19-24 Traineeships Total Funding                                | New          |             | 
    | 10017517 | EDSK-517       | ALLC-517      | 1               | 0                     | 16727.00  | 13892.00  | 2835.00   | 784.00   | 1140.00  | 72.00    | 3275.00  | 87.00    | 2247.00  | 3171.00  | 3116.00  | 562.00   | 824.00   | 1021.00  | 428.00   | Total Advanced Learner Loans Bursary Funding                    | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-517       | 1                     | 0                        | 2019-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-517' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-517'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-517' and actual ContractNumber 'EDSK-517'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-517' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017517 | EDSK-517           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017517 | ESFA-517           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '144' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '144' deliverable period rows in CRM linked to the latest version of contract 'EDSK-517'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECT-517        | 2355775          | Jul-20 | Reconciliation |
    | AECA-517        | 2371175          | Jul-20 | Reconciliation |
    | ALLC-517        | 2303975          | Jul-20 | Reconciliation |




    # Populate stub with Claim data

    # Change the date
    Given the override date is '19/09/2020'

    #Set up claim data from DC for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | AECA-517      | AEBC-ASCL1920           |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | AECT-517      | AEBC-19TRN1920          |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | ALLC-517      | ALLBC1920               |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | AECA-517      | 3               | 6755.21     | 0.00          | 0.00            | 6755.21    |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | AECA-517      | 4               | 6504.13     | 0.00          | 0.00            | 6504.13    |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | AECA-517      | 5               | 6208.75     | 0.00          | 0.00            | 6208.75    |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | AECA-517      | 6               | 7102.44     | 0.00          | 0.00            | 7102.44    |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | AECA-517      | 7               | 7018.37     | 0.00          | 0.00            | 7018.37    |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | AECA-517      | 8               | 6884.83     | 0.00          | 0.00            | 6884.83    |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | AECA-517      | 9               | 7275.44     | 0.00          | 0.00            | 7275.44    |
    #                                                                                                                                                                           £ 47749.17  
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | AECT-517      | 2               | 6213.89     | 0.00          | 0.00            | 6213.89    |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | AECT-517      | 3               | 5884.32     | 0.00          | 0.00            | 5884.32    |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | AECT-517      | 4               | 6133.62     | 0.00          | 0.00            | 6133.62    |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | AECT-517      | 5               | 6101.18     | 0.00          | 0.00            | 6101.18    |
    #                                                                                                                                                                           £ 24333.01  
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | ALLC-517      | 2               | 2862.66     | 0.00          | 0.00            | 2862.66    |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | ALLC-517      | 3               | 2733.79     | 0.00          | 0.00            | 2733.79    |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | ALLC-517      | 4               | 2459.51     | 0.00          | 0.00            | 2459.51    |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | ALLC-517      | 5               | 2854.14     | 0.00          | 0.00            | 2854.14    |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | ALLC-517      | 6               | 2498.63     | 0.00          | 0.00            | 2498.63    |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | ALLC-517      | 7               | 2676.49     | 0.00          | 0.00            | 2676.49    |
    | ORG0017517     | 10017517 | 3                  | Final         | AY             | 1920   | ALLC-517      | 8               | 2790.86     | 0.00          | 0.00            | 2790.86    |
    #                                                                                                                                                                           £ 18876.08  

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017517 | 1920          | Final            | ALLBC1920           | 3                  | 16727.00     | 18876.08     | 0.00                        | 0.00                | 18876.08         | 0.00            | 18876.08                 | Draft      |
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | 3                  | 23005.00     | 24333.01     | 1328.01                     | 1328.01             | 24333.01         | 0.00            | 24333.01                 | Draft      |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | 3                  | 42350.00     | 47749.17     | 1270.50                     | 1270.50             | 47749.17         | 0.00            | 47749.17                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017517 | 1920          | Final            | ALLBC1920           | ALLC-517      | 16727.00     | 18876.08     | 0.00                        | 0.00                | 18876.08         | 0.00            | ?                     | 18876.08                 | 501.81           |
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | AECT-517      | 23005.00     | 24333.01     | 1328.01                     | 1328.01             | 24333.01         | 0.00            | ?                     | 24333.01                 | 690.15           |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | AECA-517      | 42350.00     | 47749.17     | 1270.50                     | 1270.50             | 47749.17         | 0.00            | ?                     | 47749.17                 | 1270.50          |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | AECT-517      | AEBC-19TRN1920       | 2               | 19-24 Traineeships Programme Funding                   | 0.00         | 6213.89      |
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | AECT-517      | AEBC-19TRN1920       | 3               | 19-24 Traineeships Learning Support                    | 0.00         | 5884.32      |
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | AECT-517      | AEBC-19TRN1920       | 4               | 19-24 Traineeships Learner Support                     | 0.00         | 6133.62      |
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | AECT-517      | AEBC-19TRN1920       | 5               | 19-24 Traineeships Admin Expenditure                   | 0.00         | 6101.18      |
    #
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | AECA-517      | AEBC-ASCL1920        | 3               | Adult Skills Programme Funding                         | 0.00         | 6755.21      |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | AECA-517      | AEBC-ASCL1920        | 4               | Adult Skills Learning Support                          | 0.00         | 6504.13      |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | AECA-517      | AEBC-ASCL1920        | 5               | Community Learning                                     | 24079.00     | 6208.75      |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | AECA-517      | AEBC-ASCL1920        | 6               | Adult Skills 19+ Hardship                              | 0.00         | 7102.44      |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | AECA-517      | AEBC-ASCL1920        | 7               | Adult Skills 20+ Childcare                             | 0.00         | 7018.37      |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | AECA-517      | AEBC-ASCL1920        | 8               | Adult Skills Residential Access Fund                   | 0.00         | 6884.83      |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | AECA-517      | AEBC-ASCL1920        | 9               | Adult Skills Administration Expenditure                | 0.00         | 7275.44      |
    #
    | 10017517 | 1920          | Final            | ALLBC1920           | ALLC-517      | ALLBC1920            | 2               | Loans - Bursary Funding                                | 0.00         | 2862.66      |
    | 10017517 | 1920          | Final            | ALLBC1920           | ALLC-517      | ALLBC1920            | 3               | Loans - Area Costs                                     | 0.00         | 2733.79      |
    | 10017517 | 1920          | Final            | ALLBC1920           | ALLC-517      | ALLBC1920            | 4               | Loans - Excess Claims                                  | 0.00         | 2459.51      |
    | 10017517 | 1920          | Final            | ALLBC1920           | ALLC-517      | ALLBC1920            | 5               | Loans - Hardship                                       | 0.00         | 2854.14      |
    | 10017517 | 1920          | Final            | ALLBC1920           | ALLC-517      | ALLBC1920            | 6               | Loans - Childcare                                      | 0.00         | 2498.63      |
    | 10017517 | 1920          | Final            | ALLBC1920           | ALLC-517      | ALLBC1920            | 7               | Loans - Residential Access Fund                        | 0.00         | 2676.49      |
    | 10017517 | 1920          | Final            | ALLBC1920           | ALLC-517      | ALLBC1920            | 8               | Loans - Administration Expenditure                     | 0.00         | 2790.86      |




    # Bulk amend the contracts financials

    # Change the date
    Given the override date is '20/09/2020'

    # Bulk file
    And   there are no files prefixed '10017517' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 23092020073459 v3_A517' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 1920 23092020073459 v3_A517' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 23092020073459 v3_A517' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 23092020073459 v3_A517' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 23092020073459 v3_A517.xlsx' exists in the Datafiles folder and UKPRN '10017517' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Change the date
    Given the override date is '21/09/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-517'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-517' and actual ContractNumber 'EDSK-517'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-517' is showing as 'Approved'

   # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '156' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '156' deliverable period rows in CRM linked to the latest version of contract 'EDSK-517'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECT-517        | 2355775          | Oct-20 | Reconciliation |
    | AECA-517        | 2371175          | Oct-20 | Reconciliation |
    | ALLC-517        | 2303975          | Oct-20 | Reconciliation |




    # Check the details in CRM after the contract has been amended
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017517 | 1920          | Final            | ALLBC1920           | 3                  | 16563.00     | 18876.08     | 0.00                        | 0.00                | 18876.08         | 0.00            | 18876.08                 | Draft      |
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | 3                  | 23428.00     | 24333.01     | 905.01                      | 1328.01             | 24333.01         | 0.00            | 24333.01                 | Draft      |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | 3                  | 42430.00     | 47749.17     | 1272.90                     | 1270.50             | 47749.17         | 0.00            | 47749.17                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017517 | 1920          | Final            | ALLBC1920           | ALLC-517      | 16563.00     | 18876.08     | 0.00                        | 0.00                | 18876.08         | ?               | ?                     | 18876.08                 |
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | AECT-517      | 23428.00     | 24333.01     | 905.01                      | 1328.01             | 24333.01         | ?               | ?                     | 24333.01                 |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | AECA-517      | 42430.00     | 47749.17     | 1272.90                     | 1270.50             | 47749.17         | ?               | ?                     | 47749.17                 |
 
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | AECT-517      | AEBC-19TRN1920       | 2               | 19-24 Traineeships Programme Funding                   | 0.00         | 6213.89      |
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | AECT-517      | AEBC-19TRN1920       | 3               | 19-24 Traineeships Learning Support                    | 0.00         | 5884.32      |
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | AECT-517      | AEBC-19TRN1920       | 4               | 19-24 Traineeships Learner Support                     | 0.00         | 6133.62      |
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | AECT-517      | AEBC-19TRN1920       | 5               | 19-24 Traineeships Admin Expenditure                   | 0.00         | 6101.18      |
    #
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | AECA-517      | AEBC-ASCL1920        | 3               | Adult Skills Programme Funding                         | 0.00         | 6755.21      |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | AECA-517      | AEBC-ASCL1920        | 4               | Adult Skills Learning Support                          | 0.00         | 6504.13      |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | AECA-517      | AEBC-ASCL1920        | 5               | Community Learning                                     | 24079.00     | 6208.75      |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | AECA-517      | AEBC-ASCL1920        | 6               | Adult Skills 19+ Hardship                              | 0.00         | 7102.44      |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | AECA-517      | AEBC-ASCL1920        | 7               | Adult Skills 20+ Childcare                             | 0.00         | 7018.37      |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | AECA-517      | AEBC-ASCL1920        | 8               | Adult Skills Residential Access Fund                   | 0.00         | 6884.83      |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | AECA-517      | AEBC-ASCL1920        | 9               | Adult Skills Administration Expenditure                | 0.00         | 7275.44      |
    #
    | 10017517 | 1920          | Final            | ALLBC1920           | ALLC-517      | ALLBC1920            | 2               | Loans - Bursary Funding                                | 0.00         | 2862.66      |
    | 10017517 | 1920          | Final            | ALLBC1920           | ALLC-517      | ALLBC1920            | 3               | Loans - Area Costs                                     | 0.00         | 2733.79      |
    | 10017517 | 1920          | Final            | ALLBC1920           | ALLC-517      | ALLBC1920            | 4               | Loans - Excess Claims                                  | 0.00         | 2459.51      |
    | 10017517 | 1920          | Final            | ALLBC1920           | ALLC-517      | ALLBC1920            | 5               | Loans - Hardship                                       | 0.00         | 2854.14      |
    | 10017517 | 1920          | Final            | ALLBC1920           | ALLC-517      | ALLBC1920            | 6               | Loans - Childcare                                      | 0.00         | 2498.63      |
    | 10017517 | 1920          | Final            | ALLBC1920           | ALLC-517      | ALLBC1920            | 7               | Loans - Residential Access Fund                        | 0.00         | 2676.49      |
    | 10017517 | 1920          | Final            | ALLBC1920           | ALLC-517      | ALLBC1920            | 8               | Loans - Administration Expenditure                     | 0.00         | 2790.86      |




    # Change the date 
    Given the override date is '26/09/2020'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither ... 
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017517 | 1920          | Final            | ALLBC1920           | 3                  | ALLC-517      | 16563.00     | 18876.08     | 0.00                        | 100.00              | 18876.08         | 0.00            | ?                     |
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | 3                  | AECT-517      | 23428.00     | 24333.01     | 905.01                      | 1300.00             | 24333.01         | 0.00            | ?                     |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | 3                  | AECA-517      | 42430.00     | 47749.17     | 1272.90                     | 1200.00             | 47749.17         | 0.00            | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017517 | 1920          | Final            | ALLBC1920           | 3                  | 16563.00     | 18876.08     | 0.00                        | 100.00              | 18876.08         | 0.00            | 18876.08                 | Draft      |
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | 3                  | 23428.00     | 24333.01     | 905.01                      | 1300.00             | 24333.01         | 0.00            | 24333.01                 | Draft      |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | 3                  | 42430.00     | 47749.17     | 1272.90                     | 1200.00             | 47749.17         | 0.00            | 47749.17                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017517 | 1920          | Final            | ALLBC1920           | ALLC-517      | 16563.00     | 18876.08     | 0.00                        | 100.00              | 18876.08         | 0.00            | ?                     | 18876.08                 | 501.81           |
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | AECT-517      | 23428.00     | 24333.01     | 905.01                      | 1300.00             | 24333.01         | 0.00            | ?                     | 24333.01                 | 690.15           |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | AECA-517      | 42430.00     | 47749.17     | 1272.90                     | 1200.00             | 47749.17         | 0.00            | ?                     | 47749.17                 | 1270.50          |




    # Change the date
    Given the override date is '27/09/2020'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '1920-Final' and Allocation Group Code 'AEBC-ASCL1920'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '1920-Final' and Allocation Group Code 'AEBC-ASCL1920'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | 3                  |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | 3                  |
    | 10017517 | 1920          | Final            | ALLBC1920           | 3                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | 3                  |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | 3                  |
    | 10017517 | 1920          | Final            | ALLBC1920           | 3                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | 3                  |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | 3                  |
    | 10017517 | 1920          | Final            | ALLBC1920           | 3                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                         | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017517 | ALLC-517         | 1920   | Final         | Advanced Learner Loans Bursary (College) 19/20              | 16563.00     | 18876.08     | 0.00                        | 100.00                   | 18876.08           | ?               | ?                     | 18876.08                 |
    | 10017517 | AECT-517         | 1920   | Final         | AEB (College) - 19 to 24 Traineeships 19/20                 | 23428.00     | 24333.01     | 905.01                      | 1300.00                  | 24333.01           | ?               | ?                     | 24333.01                 |
    | 10017517 | AECA-517         | 1920   | Final         | AEB (College) - Adult Skills and Community Learning 19/20   | 42430.00     | 47749.17     | 1272.90                     | 1200.00                  | 47749.17           | ?               | ?                     | 47749.17                 |


    # Check that the FCR Allocation values in CRM mirror those in the AtomFeedItem table
    And   allocation data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017517 | 1920          | Final            | ALLBC1920           | ALLC-517      | 16563.00     | 18876.08     | 0.00                        | 100.00              | 18876.08         | 0.00            | ?                     | 18876.08                 |
    | 10017517 | 1920          | Final            | AEBC-19TRN1920      | AECT-517      | 23428.00     | 24333.01     | 905.01                      | 1300.00             | 24333.01         | 0.00            | ?                     | 24333.01                 |
    | 10017517 | 1920          | Final            | AEBC-ASCL1920       | AECA-517      | 42430.00     | 47749.17     | 1272.90                     | 1200.00             | 47749.17         | 0.00            | ?                     | 47749.17                 |



    # Check Financials

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    Then  the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Oct-20   |
    | EDSK-517       | AECA-517           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECA-517           | 2               | 18271.00  | 3064.00  | 257.00   | 1275.00  | 3657.00  | 1196.00  | 193.00   | 485.00   | 2328.00  | 1482.00  | 1300.00  | 865.00   | 2169.00  | 0.00     | 
    | EDSK-517       | AECA-517           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECA-517           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECA-517           | 5               | 24079.00  | 3571.00  | 1491.00  | 3048.00  | 1096.00  | 1516.00  | 1239.00  | 2069.00  | 2297.00  | 3349.00  | 1175.00  | 1278.00  | 1950.00  | 0.00     | 
    #
    | EDSK-517       | AECT-517           | 1               | 23005.00  | 1636.00  | 1265.00  | 3360.00  | 775.00   | 2110.00  | 3543.00  | 1210.00  | 805.00   | 54.00    | 2308.00  | 2950.00  | 2989.00  | 0.00     | 
    | EDSK-517       | AECT-517           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECT-517           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-517       | ALLC-517           | 1               | 16727.00  | 784.00   | 1140.00  | 72.00    | 3275.00  | 87.00    | 2247.00  | 3171.00  | 3116.00  | 562.00   | 824.00   | 1021.00  | 428.00   | 0.00     | 
    | EDSK-517       | ALLC-517           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | ALLC-517           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | ALLC-517           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Oct-20   |
    | EDSK-517       | AECA-517           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECA-517           | 2               | 4741.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4741.00  | 
    | EDSK-517       | AECA-517           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECA-517           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECA-517           | 5               | -4661.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4661.00 | 
    #
    | EDSK-517       | AECT-517           | 1               | 423.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 423.00   | 
    | EDSK-517       | AECT-517           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECT-517           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-517       | ALLC-517           | 1               | -164.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -164.00  | 
    | EDSK-517       | ALLC-517           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | ALLC-517           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | ALLC-517           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Oct-20   |
    | EDSK-517       | AECA-517           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECA-517           | 2               | 650.82    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 650.82   | 
    | EDSK-517       | AECA-517           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECA-517           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECA-517           | 5               | 549.18    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 549.18   | 
    #
    | EDSK-517       | AECT-517           | 1               | 1300.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1300.00  | 
    | EDSK-517       | AECT-517           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECT-517           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-517       | ALLC-517           | 1               | 100.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 100.00   | 
    | EDSK-517       | ALLC-517           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | ALLC-517           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | ALLC-517           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Oct-20   |
    | EDSK-517       | AECA-517           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECA-517           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECA-517           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECA-517           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECA-517           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-517       | AECT-517           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECT-517           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECT-517           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-517       | ALLC-517           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | ALLC-517           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | ALLC-517           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | ALLC-517           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Oct-20   |
    | EDSK-517       | AECA-517           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECA-517           | 2               | 23662.82  | 3064.00  | 257.00   | 1275.00  | 3657.00  | 1196.00  | 193.00   | 485.00   | 2328.00  | 1482.00  | 1300.00  | 865.00   | 2169.00  | 5391.82  | 
    | EDSK-517       | AECA-517           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECA-517           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECA-517           | 5               | 19967.18  | 3571.00  | 1491.00  | 3048.00  | 1096.00  | 1516.00  | 1239.00  | 2069.00  | 2297.00  | 3349.00  | 1175.00  | 1278.00  | 1950.00  | -4111.82 | 
    #
    | EDSK-517       | AECT-517           | 1               | 24728.00  | 1636.00  | 1265.00  | 3360.00  | 775.00   | 2110.00  | 3543.00  | 1210.00  | 805.00   | 54.00    | 2308.00  | 2950.00  | 2989.00  | 1723.00  | 
    | EDSK-517       | AECT-517           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECT-517           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-517       | ALLC-517           | 1               | 16663.00  | 784.00   | 1140.00  | 72.00    | 3275.00  | 87.00    | 2247.00  | 3171.00  | 3116.00  | 562.00   | 824.00   | 1021.00  | 428.00   | -64.00   | 
    | EDSK-517       | ALLC-517           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | ALLC-517           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | ALLC-517           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Oct-20   |
    | EDSK-517       | AECA-517           | 1               | 42430.00  | 5438.00  | 4429.00  | 2645.00  | 3772.00  | 2826.00  | 3750.00  | 5159.00  | 3599.00  | 2956.00  | 2844.00  | 1357.00  | 3655.00  | 0.00     | 
    | EDSK-517       | AECA-517           | 2               | 23012.00  | 2762.00  | 2683.00  | 1214.00  | 2105.00  | 1028.00  | 2546.00  | 3172.00  | 1123.00  | 1511.00  | 1878.00  | 1068.00  | 1922.00  | 0.00     | 
    | EDSK-517       | AECA-517           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECA-517           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECA-517           | 5               | 19418.00  | 2676.00  | 1746.00  | 1431.00  | 1667.00  | 1798.00  | 1204.00  | 1987.00  | 2476.00  | 1445.00  | 966.00   | 289.00   | 1733.00  | 0.00     | 
    #
    | EDSK-517       | AECT-517           | 1               | 23428.00  | 1423.00  | 2654.00  | 1426.00  | 1767.00  | 2909.00  | 2002.00  | 1317.00  | 1108.00  | 1287.00  | 1975.00  | 3454.00  | 2106.00  | 0.00     | 
    | EDSK-517       | AECT-517           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | AECT-517           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-517       | ALLC-517           | 1               | 16563.00  | 1024.00  | 1606.00  | 1101.00  | 555.00   | 3422.00  | 1213.00  | 1489.00  | 1626.00  | 1005.00  | 1218.00  | 1211.00  | 1093.00  | 0.00     | 
    | EDSK-517       | ALLC-517           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | ALLC-517           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-517       | ALLC-517           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Oct-20    |
    | 10017517 | EDSK-517       | AECA-517           | 2371175                  | 1200.00   | 
    | 10017517 | EDSK-517       | AECT-517           | 2355775                  | 1300.00   | 
    | 10017517 | EDSK-517       | ALLC-517           | 2303975                  | 100.00    | 


    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber    | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | AECA-517            | 2             | 1               | 202010 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECA-517            | 2             | 2               | 202010 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 4741.00                | 650.82                      | 5391.82          | ?            | ?           |
    | AECA-517            | 2             | 3               | 202010 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECA-517            | 2             | 4               | 202010 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECA-517            | 2             | 5               | 202010 | 2              | 0             | 0.00         | 0.00                 | 0.00                | -4661.00               | 549.18                      | -4111.82         | ?            | ?           |
    #
    | AECT-517            | 2             | 1               | 202010 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 423.00                 | 1300.00                     | 1723.00          | ?            | ?           |
    | AECT-517            | 2             | 2               | 202010 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-517            | 2             | 3               | 202010 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | ALLC-517            | 2             | 1               | 202010 | 2              | 0             | 0.00         | 0.00                 | 0.00                | -164.00                | 100.00                      | -64.00           | ?            | ?           |
    | ALLC-517            | 2             | 2               | 202010 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-517            | 2             | 3               | 202010 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ALLC-517            | 2             | 4               | 202010 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |


    #ADP Feed

    # Check the ADP feed contains events for Oct-20
    Then  the Allocation Delivery Performance atom feed contains the following FCR Published events
    | ContractNumber | VersionNumber | AllocationNumber | DeliverableCode | Period | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment | AggregatedPaymentType | SubnominalCode | AggregatedValue |
    | EDSK-517       | 2             | AECA-517         | 2               | 202010 | 0.00           | 4741.00          | 650.82                | 0.00           | 5391.82    | PROFILE               | 2371110        | 4741.00         |
    | EDSK-517       | 2             | AECA-517         | 5               | 202010 | 0.00           | -4661.00         | 549.18                | 0.00           | -4111.82   | PROFILE               | 2371130        | -4661.00        |
    | EDSK-517       | 2             | AECA-517         | 2               | 202010 | 0.00           | 4741.00          | 650.82                | 0.00           | 5391.82    | RECONCILIATION        | 2371175        | 1200.00         |
    | EDSK-517       | 2             | AECA-517         | 5               | 202010 | 0.00           | -4661.00         | 549.18                | 0.00           | -4111.82   | RECONCILIATION        | 2371175        | 1200.00         |
    #
    | EDSK-517       | 2             | AECT-517         | 1               | 202010 | 0.00           | 423.00           | 1300.00               | 0.00           | 1723.00    | PROFILE               | 2355700        | 423.00          |
    | EDSK-517       | 2             | AECT-517         | 1               | 202010 | 0.00           | 423.00           | 1300.00               | 0.00           | 1723.00    | RECONCILIATION        | 2355775        | 1300.00         |
    #
    | EDSK-517       | 2             | ALLC-517         | 1               | 202010 | 0.00           | -164.00          | 100.00                | 0.00           | -64.00     | PROFILE               | 2303900        | -164.00         |
    | EDSK-517       | 2             | ALLC-517         | 1               | 202010 | 0.00           | -164.00          | 100.00                | 0.00           | -64.00     | RECONCILIATION        | 2303975        | 100.00          |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
Scenario: A518 Create and approve a 1920 AEBP contract with AEB-19TRLS and AEB-ASLS allocs. Process 1920 Final Funding Claim data for both allocs. (Claim less than profile) Bulk amend then publish FCR. Check CRM, feed and financials
    Given there are no allocations marked as Under Termination for UKPRN '10017518' 
    And   there are no terminated or closed allocations for UKPRN '10017518' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017518' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017518' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEAL-518      |
    | AETL-518      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEAL-518      |
    | AETL-518      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-19TRLS1920    |
    | AEB-ASLS1920      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP-518       | 1                     | 0                        |

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Year End      | 1920   |
    | Final         | 1718   |
    | Final         | 1819   |
    | Final         | 1920   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017518 |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEAL-518      |
    | AETL-518      |





    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017518' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017518 Co Ltd' with UKPRN '10017518' and OrgId 'ORG0017518' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017518' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017518 | 117518 | 10017518 Co Ltd | 0              | Active                | Yes           | AA017518      | ?             | 15 Linden Drive        | Bradley Stoke          | Bristol                | ?                      | ?                      | ?                      | BS32 8DT  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017518 |




    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017518 | 10017518 Co Ltd      | ESFA-518             | AEBP-518       | 1                     | 01/08/2019        | 31/07/2020      | 38499.00      |                                       | Procured                                   | 1920   | New          | ORG0017518 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017518 | AEBP-518       | AEAL-518      | AEB-ASLS          | AEB-ASLS1920            | AY                      | 01/08/2019          | 31/07/2020        | 21335.00        |                                         |            |                                                             | New          |             |
    | 10017518 | AEBP-518       | AETL-518      | AEB-19TRLS        | AEB-19TRLS1920          | AY                      | 01/08/2019          | 31/07/2020        | 17164.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017518 | AEBP-518       | AEAL-518      | 1               | 0                     | 21335.00  | 15214.00  | 6121.00   | 823.00   | 2380.00  | 428.00   | 3566.00  | 3289.00  | 418.00   | 1629.00  | 2681.00  | 507.00   | 3329.00  | 300.00   | 1985.00  | Adult Education Budget - Adult Skills Learner Support           | New          |             | 
    | 10017518 | AEBP-518       | AETL-518      | 1               | 0                     | 17164.00  | 13918.00  | 3246.00   | 2998.00  | 1392.00  | 1526.00  | 142.00   | 1575.00  | 1960.00  | 2538.00  | 1787.00  | 340.00   | 982.00   | 1021.00  | 903.00   | Adult Education Budget - 19-24 Traineeships Learner Support     | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP-518       | 1                     | 0                        | 2019-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'AEBP-518' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-518'

    # Change the date
    Given the override date is '11/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-518' and actual ContractNumber 'AEBP-518'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-518' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017518 | AEBP-518           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017518 | ESFA-518           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'AEBP-518'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AETL-518        | 2355875          | Jul-20 | Reconciliation |
    | AEAL-518        | 2372175          | Jul-20 | Reconciliation |




    # Populate stub with Claim data

    # Change the date
    Given the override date is '19/09/2020'

    #Set up claim data from DC for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017518     | 10017518 | 3                  | Final         | AY             | 1920   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017518     | 10017518 | 3                  | Final         | AY             | 1920   | AEAL-518      | AEB-ASLS1920            |
    | ORG0017518     | 10017518 | 3                  | Final         | AY             | 1920   | AETL-518      | AEB-19TRLS1920          |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017518     | 10017518 | 3                  | Final         | AY             | 1920   | AEAL-518      | 2               | 4724.97     | 0.00          | 0.00            | 4724.97    |
    | ORG0017518     | 10017518 | 3                  | Final         | AY             | 1920   | AEAL-518      | 3               | 5288.05     | 0.00          | 0.00            | 5288.05    |
    | ORG0017518     | 10017518 | 3                  | Final         | AY             | 1920   | AEAL-518      | 4               | 5030.76     | 0.00          | 0.00            | 5030.76    |
    | ORG0017518     | 10017518 | 3                  | Final         | AY             | 1920   | AEAL-518      | 5               | 5283.02     | 0.00          | 0.00            | 5283.02    |
    #                                                                                                                                                                           £ 20326.80  
    | ORG0017518     | 10017518 | 3                  | Final         | AY             | 1920   | AETL-518      | 2               | 8326.70     | 0.00          | 0.00            | 8326.70    |
    | ORG0017518     | 10017518 | 3                  | Final         | AY             | 1920   | AETL-518      | 3               | 7299.86     | 0.00          | 0.00            | 7299.86    |
    #                                                                                                                                                                           £ 15626.56  

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed




    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017518 | 1920          | Final            | AEB-19TRLS1920      | 3                  | 17164.00     | 15626.56     | -1537.44                    | -1537.44            | 15626.56         | 0.00            | 15626.56                 | Draft      |
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | 3                  | 21335.00     | 20326.80     | -1008.20                    | -1008.20            | 20326.80         | 0.00            | 20326.80                 | Draft      |

    # FCR Allocation
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017518 | 1920          | Final            | AEB-19TRLS1920      | AETL-518      | 17164.00     | 15626.56     | -1537.44                    | -1537.44            | 15626.56         | 0.00            | ?                     | 15626.56                 | 514.92           |
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | AEAL-518      | 21335.00     | 20326.80     | -1008.20                    | -1008.20            | 20326.80         | 0.00            | ?                     | 20326.80                 | 640.05           |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017518 | 1920          | Final            | AEB-19TRLS1920      | AETL-518      | AEB-19TRLS1920       | 2               | 19-24 Traineeships Learner Support                     | 0.00         | 8326.70      |
    | 10017518 | 1920          | Final            | AEB-19TRLS1920      | AETL-518      | AEB-19TRLS1920       | 3               | 19-24 Traineeships Administration Expenditure          | 0.00         | 7299.86      |
    #
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | AEAL-518      | AEB-ASLS1920         | 2               | Adult Skills 19+ Hardship                              | 0.00         | 4724.97      |
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | AEAL-518      | AEB-ASLS1920         | 3               | Adult Skills 20+ Childcare                             | 0.00         | 5288.05      |
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | AEAL-518      | AEB-ASLS1920         | 4               | Adult Skills Residential Access Fund                   | 0.00         | 5030.76      |
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | AEAL-518      | AEB-ASLS1920         | 5               | Adult Skills Administration Expenditure                | 0.00         | 5283.02      |




    # Bulk amend the contracts financials
    
    # Change the date 
    Given the override date is '22/09/2020'  
    
    # Bulk file
    And   there are no files prefixed '10017518' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1920 23092020113023 v3_A518' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 1920 23092020113023 v3_A518' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1920 23092020113023 v3_A518' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1920 23092020113023 v3_A518' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1920 23092020113023 v3_A518.xlsx' exists in the Datafiles folder and UKPRN '10017518' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    
    
    
    
    # Change the date
    Given the override date is '23/09/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-518'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-518' and actual ContractNumber 'AEBP-518'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-518' is showing as 'Approved'

   # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '26' deliverable period rows in CRM linked to the latest version of contract 'AEBP-518'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AETL-518        | 2355875          | Oct-20 | Reconciliation |
    | AEAL-518        | 2372175          | Oct-20 | Reconciliation |
    



     # Check the details in CRM after the contract has been amended
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017518 | 1920          | Final            | AEB-19TRLS1920      | 3                  | 17223.00     | 15626.56     | -1596.44                    | -1537.44            | 15626.56         | 0.00            | 15626.56                 | Draft      |
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | 3                  | 21226.00     | 20326.80     | -899.20                     | -1008.20            | 20326.80         | 0.00            | 20326.80                 | Draft      |

    # FCR Allocation
    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017518 | 1920          | Final            | AEB-19TRLS1920      | AETL-518      | 17223.00     | 15626.56     | -1596.44                    | -1537.44            | 15626.56         | 0.00            | ?                     | 15626.56                 | 514.92           |
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | AEAL-518      | 21226.00     | 20326.80     | -899.20                     | -1008.20            | 20326.80         | 0.00            | ?                     | 20326.80                 | 640.05           |

    # FCR Allocation Deliverable
    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017518 | 1920          | Final            | AEB-19TRLS1920      | AETL-518      | AEB-19TRLS1920       | 2               | 19-24 Traineeships Learner Support                     | 0.00         | 8326.70      |
    | 10017518 | 1920          | Final            | AEB-19TRLS1920      | AETL-518      | AEB-19TRLS1920       | 3               | 19-24 Traineeships Administration Expenditure          | 0.00         | 7299.86      |
    #
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | AEAL-518      | AEB-ASLS1920         | 2               | Adult Skills 19+ Hardship                              | 0.00         | 4724.97      |
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | AEAL-518      | AEB-ASLS1920         | 3               | Adult Skills 20+ Childcare                             | 0.00         | 5288.05      |
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | AEAL-518      | AEB-ASLS1920         | 4               | Adult Skills Residential Access Fund                   | 0.00         | 5030.76      |
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | AEAL-518      | AEB-ASLS1920         | 5               | Adult Skills Administration Expenditure                | 0.00         | 5283.02      |






   
    
    # Change the date 
    Given the override date is '26/09/2020'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither ... 
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017518 | 1920          | Final            | AEB-19TRLS1920      | 3                  | AETL-518      | 17223.00     | 15626.56     | -1596.44                    | -1500.00            | 15626.56         | 0.00            | ?                     |
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | 3                  | AEAL-518      | 21226.00     | 20326.80     | -899.20                     | -1000.00            | 20326.80         | 0.00            | ?                     |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017518 | 1920          | Final            | AEB-19TRLS1920      | 3                  | 17223.00     | 15626.56     | -1596.44                    | -1500.00            | 15626.56         | 0.00            | 15626.56                 | Draft      |
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | 3                  | 21226.00     | 20326.80     | -899.20                     | -1000.00            | 20326.80         | 0.00            | 20326.80                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017518 | 1920          | Final            | AEB-19TRLS1920      | AETL-518      | 17223.00     | 15626.56     | -1596.44                    | -1500.00            | 15626.56         | 0.00            | ?                     | 15626.56                 | 514.92           |
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | AEAL-518      | 21226.00     | 20326.80     | -899.20                     | -1000.00            | 20326.80         | 0.00            | ?                     | 20326.80                 | 640.05           |




    # Change the date
    Given the override date is '27/09/2020'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '1920-Final' and Allocation Group Code 'AEB-ASLS1920'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '1920-Final' and Allocation Group Code 'AEB-ASLS1920'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017518 | 1920          | Final            | AEB-19TRLS1920      | 3                  |
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | 3                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017518 | 1920          | Final            | AEB-19TRLS1920      | 3                  |
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | 3                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017518 | 1920          | Final            | AEB-19TRLS1920      | 3                  |
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | 3                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                           | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017518 | AETL-518         | 1920   | Final         | AEB (Procured) - 19 to 24 Traineeships Learner Support 19/20  | 17223.00     | 15626.56     | -1596.44                    | -1500.00                 | 15626.56           | ?               | ?                     | 15626.56                 |
    | 10017518 | AEAL-518         | 1920   | Final         | AEB (Procured) - Adult Skills Learner Support 19/20           | 21226.00     | 20326.80     | -899.20                     | -1000.00                 | 20326.80           | ?               | ?                     | 20326.80                 |

    # Check that the FCR Allocation values in CRM mirror those in the AtomFeedItem table
    And   allocation data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10017518 | 1920          | Final            | AEB-19TRLS1920      | AETL-518      | 17223.00     | 15626.56     | -1596.44                    | -1500.00            | 15626.56         | 0.00            | ?                     | 15626.56                 |
    | 10017518 | 1920          | Final            | AEB-ASLS1920        | AEAL-518      | 21226.00     | 20326.80     | -899.20                     | -1000.00            | 20326.80         | 0.00            | ?                     | 20326.80                 |
 
  


    # Check financials

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    Then  the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Oct-20   |
    | AEBP-518       | AEAL-518           | 1               | 21335.00  | 823.00   | 2380.00  | 428.00   | 3566.00  | 3289.00  | 418.00   | 1629.00  | 2681.00  | 507.00   | 3329.00  | 300.00   | 1985.00  | 0.00     | 
    | AEBP-518       | AETL-518           | 1               | 17164.00  | 2998.00  | 1392.00  | 1526.00  | 142.00   | 1575.00  | 1960.00  | 2538.00  | 1787.00  | 340.00   | 982.00   | 1021.00  | 903.00   | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Oct-20   |
    | AEBP-518       | AEAL-518           | 1               | -109.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -109.00  | 
    | AEBP-518       | AETL-518           | 1               | 59.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 59.00    | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Oct-20   |
    | AEBP-518       | AEAL-518           | 1               | -1000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1000.00 | 
    | AEBP-518       | AETL-518           | 1               | -1500.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1500.00 | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Oct-20   |
    | AEBP-518       | AEAL-518           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-518       | AETL-518           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Oct-20   |
    | AEBP-518       | AEAL-518           | 1               | 20226.00  | 823.00   | 2380.00  | 428.00   | 3566.00  | 3289.00  | 418.00   | 1629.00  | 2681.00  | 507.00   | 3329.00  | 300.00   | 1985.00  | -1109.00 | 
    | AEBP-518       | AETL-518           | 1               | 15723.00  | 2998.00  | 1392.00  | 1526.00  | 142.00   | 1575.00  | 1960.00  | 2538.00  | 1787.00  | 340.00   | 982.00   | 1021.00  | 903.00   | -1441.00 | 

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Oct-20   |
    | AEBP-518       | AEAL-518           | 1               | 21226.00  | 2095.00  | 1568.00  | 1483.00  | 1670.00  | 1835.00  | 1500.00  | 2345.00  | 1972.00  | 1131.00  | 2115.00  | 1723.00  | 1789.00  | 0.00     | 
    | AEBP-518       | AETL-518           | 1               | 17223.00  | 1123.00  | 1464.00  | 1713.00  | 1855.00  | 986.00   | 1575.00  | 747.00   | 1328.00  | 1647.00  | 1594.00  | 1641.00  | 1550.00  | 0.00     | 


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-19    | Sep-19    | Oct-19    | Nov-19    | Dec-19    | Jan-20    | Feb-20    | Mar-20    | Apr-20    | May-20    | Jun-20    | Jul-20    | Oct-20    |
    | 10017518 | AEBP-518       | AEAL-518           | 2372175                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | -1000.00  | 
    | 10017518 | AEBP-518       | AETL-518           | 2355875                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | -1500.00  | 


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20260521
Scenario: A523 Create and approve a 1920 AEBP contract with AEB-19TRLS and AEB-ASLS. Ditto a 1920 EDSK contract with AEBC-19TRN, AEBC-ASCL and ALLBC allocs. Pull in Final Funding Claims for both contracts (To help with manual checking)
    Given there are no allocations marked as Under Termination for UKPRN '10017523' 
    And   there are no terminated or closed allocations for UKPRN '10017523' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017523' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017523' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECA-523      |
    | AECT-523      |
    | ALLC-523      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-523      |
    | AECT-523      |
    | ALLC-523      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-19TRN1920    |
    | AEBC-ASCL1920     |
    | ALLBC1920         |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-523       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017523'

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017523 |

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Year End      | 1920   |
    | Final         | 1718   |
    | Final         | 1819   |
    | Final         | 1920   |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AECA-523      |
    | AECT-523      |
    | ALLC-523      |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017523' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017523 Co Ltd' with UKPRN '10017523' and OrgId 'ORG0017523' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017523' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017523 | 117523 | 10017523 Co Ltd | 0              | Active                | Yes           | AA017523      | ?             | 4 St John's Court      | Moulsham Street        | ?                      | ?                      | Chelmsford             | Essex                  | CM2 0JD   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017523 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create EDSK contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017523 | 10017523 Co Ltd      | ESFA-523             | EDSK-523       | 1                     | 01/08/2019        | 31/07/2020      | 82082.00      |                                       | Conditions of Funding (Grant) (NMSS)       | 1920   | New          | ORG0017523 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017523 | EDSK-523       | AECA-523      | AEBC-ASCL         | AEBC-ASCL1920           | AY                      | 01/08/2019          | 31/07/2020        | 42350.00        |                                         |            |                                                             | New          |             |
    | 10017523 | EDSK-523       | AECT-523      | AEBC-19TRN        | AEBC-19TRN1920          | AY                      | 01/08/2019          | 31/07/2020        | 23005.00        |                                         |            |                                                             | New          |             |
    | 10017523 | EDSK-523       | ALLC-523      | ALLBC             | ALLBC1920               | AY                      | 01/08/2019          | 31/07/2020        | 16727.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017523 | EDSK-523       | AECA-523      | 1               | 0                     | 42350.00  | 28782.00  | 13568.00  | 6635.00  | 1748.00  | 4323.00  | 4753.00  | 2712.00  | 1432.00  | 2554.00  | 4625.00  | 4831.00  | 2475.00  | 2143.00  | 4119.00  | Adult Education Budget Total Funding                            | New          |             | 
    | 10017523 | EDSK-523       | AECA-523      | 2               | 1                     | 18271.00  | 12455.00  | 5816.00   | 3064.00  | 257.00   | 1275.00  | 3657.00  | 1196.00  | 193.00   | 485.00   | 2328.00  | 1482.00  | 1300.00  | 865.00   | 2169.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017523 | EDSK-523       | AECA-523      | 5               | 1                     | 24079.00  | 16327.00  | 7752.00   | 3571.00  | 1491.00  | 3048.00  | 1096.00  | 1516.00  | 1239.00  | 2069.00  | 2297.00  | 3349.00  | 1175.00  | 1278.00  | 1950.00  | Community Learning                                              | New          |             | 
    | 10017523 | EDSK-523       | AECT-523      | 1               | 0                     | 23005.00  | 14704.00  | 8301.00   | 1636.00  | 1265.00  | 3360.00  | 775.00   | 2110.00  | 3543.00  | 1210.00  | 805.00   | 54.00    | 2308.00  | 2950.00  | 2989.00  | 19-24 Traineeships Total Funding                                | New          |             | 
    | 10017523 | EDSK-523       | ALLC-523      | 1               | 0                     | 16727.00  | 13892.00  | 2835.00   | 784.00   | 1140.00  | 72.00    | 3275.00  | 87.00    | 2247.00  | 3171.00  | 3116.00  | 562.00   | 824.00   | 1021.00  | 428.00   | Total Advanced Learner Loans Bursary Funding                    | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-523       | 1                     | 0                        | 2019-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-523' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-523'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-523' and actual ContractNumber 'EDSK-523'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-523' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017523 | EDSK-523           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017523 | ESFA-523           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '144' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '144' deliverable period rows in CRM linked to the latest version of contract 'EDSK-523'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AECT-523        | 2355775          | Jul-20 | Reconciliation |
    | AECA-523        | 2371175          | Jul-20 | Reconciliation |
    | ALLC-523        | 2303975          | Jul-20 | Reconciliation |



    # A524

    Given there are no allocations marked as Under Termination for UKPRN '10017524' 
    And   there are no terminated or closed allocations for UKPRN '10017524' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017524' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017524' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEAL-524      |
    | AETL-524      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEAL-524      |
    | AETL-524      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-19TRLS1920    |
    | AEB-ASLS1920      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP-524       | 1                     | 0                        |

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Year End      | 1920   |
    | Final         | 1718   |
    | Final         | 1819   |
    | Final         | 1920   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017524 |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEAL-524      |
    | AETL-524      |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017524' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017524 Co Ltd' with UKPRN '10017524' and OrgId 'ORG0017524' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017524' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017524 | 117524 | 10017524 Co Ltd | 0              | Active                | Yes           | AA017524      | ?             | 15 Linden Drive        | Bradley Stoke          | Bristol                | ?                      | ?                      | ?                      | BS32 8DT  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017524 |




    # Create Procured AEB contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017524 | 10017524 Co Ltd      | ESFA-524             | AEBP-524       | 1                     | 01/08/2019        | 31/07/2020      | 38499.00      |                                       | Procured                                   | 1920   | New          | ORG0017524 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017524 | AEBP-524       | AEAL-524      | AEB-ASLS          | AEB-ASLS1920            | AY                      | 01/08/2019          | 31/07/2020        | 21335.00        |                                         |            |                                                             | New          |             |
    | 10017524 | AEBP-524       | AETL-524      | AEB-19TRLS        | AEB-19TRLS1920          | AY                      | 01/08/2019          | 31/07/2020        | 17164.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017524 | AEBP-524       | AEAL-524      | 1               | 0                     | 21335.00  | 15214.00  | 6121.00   | 823.00   | 2380.00  | 428.00   | 3566.00  | 3289.00  | 418.00   | 1629.00  | 2681.00  | 507.00   | 3329.00  | 300.00   | 1985.00  | Adult Education Budget - Adult Skills Learner Support           | New          |             | 
    | 10017524 | AEBP-524       | AETL-524      | 1               | 0                     | 17164.00  | 13918.00  | 3246.00   | 2998.00  | 1392.00  | 1526.00  | 142.00   | 1575.00  | 1960.00  | 2538.00  | 1787.00  | 340.00   | 982.00   | 1021.00  | 903.00   | Adult Education Budget - 19-24 Traineeships Learner Support     | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP-524       | 1                     | 0                        | 2019-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'AEBP-524' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-524'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-524' and actual ContractNumber 'AEBP-524'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-524' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017524 | AEBP-524           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017524 | ESFA-524           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'AEBP-524'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AETL-524        | 2355875          | Jul-20 | Reconciliation |
    | AEAL-524        | 2372175          | Jul-20 | Reconciliation |




    # Load Funding Claims for both contracts

    # Change the date
    Given the override date is '27/09/2020'

    #Set up claim data from DC for a 'Final'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | False         |
    | ORG0017524     | 10017524 | 3                  | Final         | AY             | 1920   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | AECA-523      | AEBC-ASCL1920           |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | AECT-523      | AEBC-19TRN1920          |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | ALLC-523      | ALLBC1920               |
    | ORG0017524     | 10017524 | 3                  | Final         | AY             | 1920   | AEAL-524      | AEB-ASLS1920            |
    | ORG0017524     | 10017524 | 3                  | Final         | AY             | 1920   | AETL-524      | AEB-19TRLS1920          |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | AECA-523      | 3               | 6755.21     | 0.00          | 0.00            | 6755.21    |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | AECA-523      | 4               | 6504.13     | 0.00          | 0.00            | 6504.13    |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | AECA-523      | 5               | 6208.75     | 0.00          | 0.00            | 6208.75    |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | AECA-523      | 6               | 7102.44     | 0.00          | 0.00            | 7102.44    |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | AECA-523      | 7               | 7018.37     | 0.00          | 0.00            | 7018.37    |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | AECA-523      | 8               | 6884.83     | 0.00          | 0.00            | 6884.83    |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | AECA-523      | 9               | 7275.44     | 0.00          | 0.00            | 7275.44    |
    #                                                                                                                                                                           £ 47749.17  
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | AECT-523      | 2               | 6213.89     | 0.00          | 0.00            | 6213.89    |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | AECT-523      | 3               | 5884.32     | 0.00          | 0.00            | 5884.32    |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | AECT-523      | 4               | 6133.62     | 0.00          | 0.00            | 6133.62    |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | AECT-523      | 5               | 6101.18     | 0.00          | 0.00            | 6101.18    |
    #                                                                                                                                                                           £ 24333.01  
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | ALLC-523      | 2               | 2862.66     | 0.00          | 0.00            | 2862.66    |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | ALLC-523      | 3               | 2733.79     | 0.00          | 0.00            | 2733.79    |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | ALLC-523      | 4               | 2459.51     | 0.00          | 0.00            | 2459.51    |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | ALLC-523      | 5               | 2854.14     | 0.00          | 0.00            | 2854.14    |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | ALLC-523      | 6               | 2498.63     | 0.00          | 0.00            | 2498.63    |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | ALLC-523      | 7               | 2676.49     | 0.00          | 0.00            | 2676.49    |
    | ORG0017523     | 10017523 | 3                  | Final         | AY             | 1920   | ALLC-523      | 8               | 2790.86     | 0.00          | 0.00            | 2790.86    |
    #                                                                                                                                                                           £ 18876.08  
    | ORG0017524     | 10017524 | 3                  | Final         | AY             | 1920   | AEAL-524      | 2               | 4724.97     | 0.00          | 0.00            | 4724.97    |
    | ORG0017524     | 10017524 | 3                  | Final         | AY             | 1920   | AEAL-524      | 3               | 5288.05     | 0.00          | 0.00            | 5288.05    |
    | ORG0017524     | 10017524 | 3                  | Final         | AY             | 1920   | AEAL-524      | 4               | 5030.76     | 0.00          | 0.00            | 5030.76    |
    | ORG0017524     | 10017524 | 3                  | Final         | AY             | 1920   | AEAL-524      | 5               | 5283.02     | 0.00          | 0.00            | 5283.02    |
    #                                                                                                                                                                           £ 20326.80  
    | ORG0017524     | 10017524 | 3                  | Final         | AY             | 1920   | AETL-524      | 2               | 8326.70     | 0.00          | 0.00            | 8326.70    |
    | ORG0017524     | 10017524 | 3                  | Final         | AY             | 1920   | AETL-524      | 3               | 7299.86     | 0.00          | 0.00            | 7299.86    |
    #                                                                                                                                                                           £ 15626.56  

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Tidy up
 #  And   the override date is reset

