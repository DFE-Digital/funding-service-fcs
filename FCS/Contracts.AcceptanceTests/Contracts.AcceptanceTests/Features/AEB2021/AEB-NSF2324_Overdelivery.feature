Feature: AEB-NSF2324_Overdelivery

@AcceptanceTest @Withdrawn20260521
Scenario: S039 AEB2021 Capping demo with 50% tolerance for FY 23/24 for alloc AEB-NSF2324
    Given there is no Contract, Task or Workflow data for UKPRN '10018039' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018039' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | NSF-039       |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | NSF-039       |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-NSF2324       |

 #  # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
 #  And   there is no Subnominal data in CRM for the following subnominal codes
 #  | SubnominalCode |
 #  | 100937         |
 #  | 100938         |
 #  | 100939         |
 #  | 100940         |
 #  | 100941         |
 #  | 100942         |
 #  | 100943         |
 #  | 100944         |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP21-039     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018039'

#    # Set the 'base' timestamp for each of the 23/24 AEB document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
#    And   the following document templates have Upload timestamps as indicated 
#    | DocumentTemplateName                            | UploadTimestamp         | 
#    | SOF_AEB2021_2021-08-01.docx                     | 2021-06-20 12:00:00.000 | 
#    | AEB2021_2223_TAC_2022-08-01.docx                | 2022-06-20 12:00:00.000 | 
#    | AEB2021_2223_S1_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
#    | AEB2021_2223_S2_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
#    | FA_AEB2021_2223_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
#    | AEB2021_2223_S3ON_2022-08-01.docx               | 2022-06-20 12:00:00.000 | 
#
#


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018039' 
    And   there is no caseload advisor for UKPRN '10018039' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018039 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018039' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018039 Co Ltd' with UKPRN '10018039' and OrgId 'ORG0018039' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018039 | 118039 | 10018039 Co Ltd | 0              | Active                | Yes           | AA018039      | ?             | 111 Hagley Road        | Edgbaston              | ?                      | ?                      | Birmingham             | West Midlands          | B16 8LB   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018039 |





    # Change the date
    Given the override date is '01/07/2023'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP21-039'
    And   there are no details in ContractManagement.CreatedContract for 'AEBP21-039'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018039 | 10018039 Co Ltd      | ESFA-039             | AEBP21-039     | 1                     | 01/08/2023        | 31/07/2024      | 43199.00      |                                       | Contract for Services                      | 2324   | New          | ORG0018039 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription  | CRMIntent    | DeliveryOrg |
    | 10018039 | AEBP21-039     | NSF-039       | AEB-NSF           | AEB-NSF2324             | AY                      | 01/08/2023          | 31/07/2024        | 43199.00        |                                         |            |                        | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | DeliverableDescription                | CRMIntent    | DeliveryOrg |
    | 10018039 | AEBP21-039     | NSF-039       | 1               | 0                     | 43199.00  | 28440.00  | 14759.00  | 4028.00  | 2022.00  | 6306.00  | 2590.00  | 3618.00  | 535.00   | 3366.00  | 5975.00  | 4567.00  | 407.00   | 5485.00  | 4300.00  | National Skills Fund Total Funding    | New          |             | 
    | 10018039 | AEBP21-039     | NSF-039       | 2               | 1                     | 16804.00  | 10117.00  | 6687.00   | 1027.00  | 340.00   | 3384.00  | 671.00   | 1407.00  | 182.00   | 157.00   | 2949.00  | 1976.00  | 212.00   | 1802.00  | 2697.00  | Level 3 Free Courses for Jobs         | New          |             | 
    | 10018039 | AEBP21-039     | NSF-039       | 5               | 1                     | 26395.00  | 18323.00  | 8072.00   | 3001.00  | 1682.00  | 2922.00  | 1919.00  | 2211.00  | 353.00   | 3209.00  | 3026.00  | 2591.00  | 195.00   | 3683.00  | 1603.00  | National Skills Fund Learner Support  | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP21-039     | 1                     | 0                        | 2023-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP21-039'





    # Publish and approve

    # Change the date
    Given the override date is '03/07/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP21-039'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  contract approval messages arrive for the following contracts
    | MasterContractNumber | ContractNumber | Version |
    | ESFA-039             | AEBP21-039     | 1       |

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP21-039' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018039 | AEBP21-039         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10018039 | ESFA-039           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP21-039' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '120' deliverable period rows in CRM linked to the latest version of contract 'AEBP21-039'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | NSF-039         | 100944           | Jul-23 | Reconciliation |





    # Add actuals to the contract for AEB-NSF2324 for FY1

    # Change the date
    Given the override date is '04/04/2024'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018039'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jul 2024
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202308 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1732.62     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202308 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1753.25     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202308 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1424.28     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202308 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 2184.27     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202308 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 1719.45     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202308 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1165.36     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202308 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1382.58     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202309 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1037.94     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202309 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1035.19     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202309 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1800.35     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202309 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 1193.56     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202309 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 2219.72     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202309 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1658.26     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202309 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1688.53     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202310 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1819.38     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202310 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 2033.75     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202310 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1304.25     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202310 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 2248.75     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202310 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 2106.59     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202310 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1280.95     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202310 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1848.58     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202311 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1670.42     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202311 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1590.11     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202311 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1547.25     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202311 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 2111.61     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202311 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 1608.04     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202311 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1909.58     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202311 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1504.35     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202312 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1356.35     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202312 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1688.23     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202312 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1288.27     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202312 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 1273.02     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202312 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 1398.60     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202312 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1129.25     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202312 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1574.51     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202401 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 2048.90     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202401 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1779.56     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202401 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1573.04     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202401 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 1495.61     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202401 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 1840.75     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202401 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1951.07     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202401 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1229.75     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202402 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1224.20     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202402 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1871.28     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202402 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1623.20     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202402 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 1334.81     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202402 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 1557.18     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202402 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1690.33     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202402 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1774.44     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202403 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1668.38     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202403 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1807.17     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202403 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1650.79     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202403 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 1924.31     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202403 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 1787.45     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202403 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1806.32     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202403 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1896.78     |
    #
    | ILR2324        | R08                  | ORG0018039     | CM             | 202404 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1318.61     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202404 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1620.34     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202404 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1572.78     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202404 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 1564.44     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202404 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 2176.97     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202404 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1773.75     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202404 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1789.61     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202405 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1645.26     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202405 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1803.06     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202405 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1902.28     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202405 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 1996.15     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202405 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 1111.83     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202405 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 2007.26     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202405 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1240.43     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202406 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1441.95     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202406 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1456.12     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202406 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1891.77     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202406 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 1897.21     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202406 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 2153.18     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202406 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1140.28     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202406 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1348.31     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202407 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 2163.09     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202407 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1761.52     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202407 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1809.87     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202407 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 1318.26     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202407 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 1479.57     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202407 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1495.56     |
    | ILR2324        | R08                  | ORG0018039     | CM             | 202407 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1519.71     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



    # Check CRM and PaaS

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-039     | NSF-039            | 1               | 43199.00  | 28440.00 | 14759.00 | 4028.00  | 2022.00  | 6306.00  | 2590.00  | 3618.00  | 535.00   | 3366.00  | 5975.00  | 4567.00  | 407.00   | 5485.00  | 4300.00  | 
    | AEBP21-039     | NSF-039            | 2               | 16804.00  | 10117.00 | 6687.00  | 1027.00  | 340.00   | 3384.00  | 671.00   | 1407.00  | 182.00   | 157.00   | 2949.00  | 1976.00  | 212.00   | 1802.00  | 2697.00  | 
    | AEBP21-039     | NSF-039            | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 5               | 26395.00  | 18323.00 | 8072.00  | 3001.00  | 1682.00  | 2922.00  | 1919.00  | 2211.00  | 353.00   | 3209.00  | 3026.00  | 2591.00  | 195.00   | 3683.00  | 1603.00  | 
    | AEBP21-039     | NSF-039            | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-039     | NSF-039            | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-039     | NSF-039            | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-039     | NSF-039            | 3               | 12558.19  | 1732.62  | 1037.94  | 1819.38  | 1670.42  | 1356.35  | 2048.90  | 1224.20  | 1668.38  | ?        | ?        | ?        | ?        | 
    | AEBP21-039     | NSF-039            | 4               | 13558.54  | 1753.25  | 1035.19  | 2033.75  | 1590.11  | 1688.23  | 1779.56  | 1871.28  | 1807.17  | ?        | ?        | ?        | ?        | 
    | AEBP21-039     | NSF-039            | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-039     | NSF-039            | 6               | 12211.43  | 1424.28  | 1800.35  | 1304.25  | 1547.25  | 1288.27  | 1573.04  | 1623.20  | 1650.79  | ?        | ?        | ?        | ?        | 
    | AEBP21-039     | NSF-039            | 7               | 13765.94  | 2184.27  | 1193.56  | 2248.75  | 2111.61  | 1273.02  | 1495.61  | 1334.81  | 1924.31  | ?        | ?        | ?        | ?        | 
    | AEBP21-039     | NSF-039            | 8               | 14237.78  | 1719.45  | 2219.72  | 2106.59  | 1608.04  | 1398.60  | 1840.75  | 1557.18  | 1787.45  | ?        | ?        | ?        | ?        | 
    | AEBP21-039     | NSF-039            | 9               | 12591.12  | 1165.36  | 1658.26  | 1280.95  | 1909.58  | 1129.25  | 1951.07  | 1690.33  | 1806.32  | ?        | ?        | ?        | ?        | 
    | AEBP21-039     | NSF-039            | 10              | 12899.52  | 1382.58  | 1688.53  | 1848.58  | 1504.35  | 1574.51  | 1229.75  | 1774.44  | 1896.78  | ?        | ?        | ?        | ?        | 
    #                                                       £ 91822.52

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-039     | NSF-039            | 3               | 12558.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12558.19 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 4               | 13558.54  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13558.54 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 6               | 12211.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12211.43 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 7               | 13765.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13765.94 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 8               | 14237.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14237.78 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 9               | 12591.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12591.12 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 10              | 12899.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12899.52 | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                       £ 91822.52                                                                               £ 91822.52                
    
    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-039     | NSF-039            | 3               | -6723.76  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6723.76 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 4               | -7259.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -7259.35 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 6               | -6538.10  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6538.10 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 7               | -7370.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -7370.40 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 8               | -7623.02  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -7623.02 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 9               | -6741.39  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6741.39 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 10              | -6906.51  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6906.51 | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                                                                                                £-49162.50                                         
    
    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-039     | NSF-039            | 3               | 5834.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5834.43  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 4               | 6299.19   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6299.19  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 6               | 5673.33   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5673.33  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 7               | 6395.54   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6395.54  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 8               | 6614.76   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6614.76  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 9               | 5849.73   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5849.73  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 10              | 5993.01   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5993.01  | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                                                                                                £42659.99                





    # Add actuals to the contract for AEB-NSF2324 for FY2 (FY1 unchanged)

    # Change the date
    Given the override date is '04/08/2024'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018039'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jul 2024
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202308 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1732.62     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202308 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1753.25     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202308 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1424.28     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202308 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 2184.27     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202308 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 1719.45     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202308 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1165.36     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202308 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1382.58     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202309 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1037.94     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202309 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1035.19     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202309 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1800.35     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202309 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 1193.56     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202309 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 2219.72     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202309 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1658.26     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202309 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1688.53     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202310 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1819.38     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202310 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 2033.75     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202310 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1304.25     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202310 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 2248.75     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202310 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 2106.59     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202310 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1280.95     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202310 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1848.58     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202311 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1670.42     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202311 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1590.11     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202311 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1547.25     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202311 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 2111.61     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202311 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 1608.04     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202311 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1909.58     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202311 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1504.35     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202312 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1356.35     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202312 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1688.23     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202312 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1288.27     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202312 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 1273.02     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202312 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 1398.60     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202312 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1129.25     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202312 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1574.51     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202401 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 2048.90     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202401 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1779.56     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202401 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1573.04     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202401 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 1495.61     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202401 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 1840.75     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202401 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1951.07     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202401 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1229.75     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202402 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1224.20     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202402 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1871.28     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202402 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1623.20     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202402 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 1334.81     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202402 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 1557.18     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202402 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1690.33     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202402 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1774.44     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202403 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1668.38     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202403 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1807.17     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202403 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1650.79     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202403 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 1924.31     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202403 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 1787.45     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202403 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1806.32     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202403 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1896.78     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202404 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1318.61     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202404 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1620.34     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202404 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1572.78     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202404 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 1564.44     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202404 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 2176.97     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202404 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1773.75     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202404 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1789.61     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202405 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1645.26     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202405 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1803.06     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202405 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1902.28     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202405 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 1996.15     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202405 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 1111.83     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202405 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 2007.26     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202405 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1240.43     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202406 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 1441.95     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202406 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1456.12     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202406 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1891.77     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202406 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 1897.21     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202406 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 2153.18     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202406 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1140.28     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202406 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1348.31     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202407 | AEB-NSF2324             | NSF-039                  | ?          | 3               | 0            | 2163.09     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202407 | AEB-NSF2324             | NSF-039                  | ?          | 4               | 0            | 1761.52     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202407 | AEB-NSF2324             | NSF-039                  | ?          | 6               | 0            | 1809.87     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202407 | AEB-NSF2324             | NSF-039                  | ?          | 7               | 0            | 1318.26     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202407 | AEB-NSF2324             | NSF-039                  | ?          | 8               | 0            | 1479.57     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202407 | AEB-NSF2324             | NSF-039                  | ?          | 9               | 0            | 1495.56     |
    | ILR2324        | R12                  | ORG0018039     | CM             | 202407 | AEB-NSF2324             | NSF-039                  | ?          | 10              | 0            | 1519.71     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



    # Check CRM and PaaS

    # Check the PLANNED VALUES in CRM on the latest approved contract (Unchanged from before)
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-039     | NSF-039            | 1               | 43199.00  | 28440.00 | 14759.00 | 4028.00  | 2022.00  | 6306.00  | 2590.00  | 3618.00  | 535.00   | 3366.00  | 5975.00  | 4567.00  | 407.00   | 5485.00  | 4300.00  | 
    | AEBP21-039     | NSF-039            | 2               | 16804.00  | 10117.00 | 6687.00  | 1027.00  | 340.00   | 3384.00  | 671.00   | 1407.00  | 182.00   | 157.00   | 2949.00  | 1976.00  | 212.00   | 1802.00  | 2697.00  | 
    | AEBP21-039     | NSF-039            | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 5               | 26395.00  | 18323.00 | 8072.00  | 3001.00  | 1682.00  | 2922.00  | 1919.00  | 2211.00  | 353.00   | 3209.00  | 3026.00  | 2591.00  | 195.00   | 3683.00  | 1603.00  | 
    | AEBP21-039     | NSF-039            | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
                        
    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-039     | NSF-039            | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-039     | NSF-039            | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-039     | NSF-039            | 3               | 19127.10  | 1732.62  | 1037.94  | 1819.38  | 1670.42  | 1356.35  | 2048.90  | 1224.20  | 1668.38  | 1318.61  | 1645.26  | 1441.95  | 2163.09  | 
    | AEBP21-039     | NSF-039            | 4               | 20199.58  | 1753.25  | 1035.19  | 2033.75  | 1590.11  | 1688.23  | 1779.56  | 1871.28  | 1807.17  | 1620.34  | 1803.06  | 1456.12  | 1761.52  | 
    | AEBP21-039     | NSF-039            | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-039     | NSF-039            | 6               | 19388.13  | 1424.28  | 1800.35  | 1304.25  | 1547.25  | 1288.27  | 1573.04  | 1623.20  | 1650.79  | 1572.78  | 1902.28  | 1891.77  | 1809.87  | 
    | AEBP21-039     | NSF-039            | 7               | 20542.00  | 2184.27  | 1193.56  | 2248.75  | 2111.61  | 1273.02  | 1495.61  | 1334.81  | 1924.31  | 1564.44  | 1996.15  | 1897.21  | 1318.26  | 
    | AEBP21-039     | NSF-039            | 8               | 21159.33  | 1719.45  | 2219.72  | 2106.59  | 1608.04  | 1398.60  | 1840.75  | 1557.18  | 1787.45  | 2176.97  | 1111.83  | 2153.18  | 1479.57  | 
    | AEBP21-039     | NSF-039            | 9               | 19007.97  | 1165.36  | 1658.26  | 1280.95  | 1909.58  | 1129.25  | 1951.07  | 1690.33  | 1806.32  | 1773.75  | 2007.26  | 1140.28  | 1495.56  | 
    | AEBP21-039     | NSF-039            | 10              | 18797.58  | 1382.58  | 1688.53  | 1848.58  | 1504.35  | 1574.51  | 1229.75  | 1774.44  | 1896.78  | 1789.61  | 1240.43  | 1348.31  | 1519.71  | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-039     | NSF-039            | 3               | 27406.71  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12558.19 | 0.00     | 0.00     | 0.00     | 13292.67 | 
    | AEBP21-039     | NSF-039            | 4               | 29138.72  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13558.54 | 0.00     | 0.00     | 0.00     | 13900.39 | 
    | AEBP21-039     | NSF-039            | 6               | 27439.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12211.43 | 0.00     | 0.00     | 0.00     | 13714.80 | 
    | AEBP21-039     | NSF-039            | 7               | 29617.87  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13765.94 | 0.00     | 0.00     | 0.00     | 14146.46 | 
    | AEBP21-039     | NSF-039            | 8               | 30546.29  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14237.78 | 0.00     | 0.00     | 0.00     | 14544.57 | 
    | AEBP21-039     | NSF-039            | 9               | 27309.29  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12591.12 | 0.00     | 0.00     | 0.00     | 13158.24 | 
    | AEBP21-039     | NSF-039            | 10              | 27302.22  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12899.52 | 0.00     | 0.00     | 0.00     | 12804.57 | 
    #                                                                                                                                                £ 91822.52                                  £ 106937.70

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-039     | NSF-039            | 3               | -10158.44 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6723.76 | 0.00     | 0.00     | 0.00     | -10158.44 | 
    | AEBP21-039     | NSF-039            | 4               | -10731.74 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -7259.35 | 0.00     | 0.00     | 0.00     | -10731.74 | 
    | AEBP21-039     | NSF-039            | 6               | -10290.57 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6538.10 | 0.00     | 0.00     | 0.00     | -10290.57 | 
    | AEBP21-039     | NSF-039            | 7               | -10913.39 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -7370.40 | 0.00     | 0.00     | 0.00     | -10913.39 | 
    | AEBP21-039     | NSF-039            | 8               | -11242.08 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -7623.02 | 0.00     | 0.00     | 0.00     | -11242.08 | 
    | AEBP21-039     | NSF-039            | 9               | -10096.56 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6741.39 | 0.00     | 0.00     | 0.00     | -10096.56 | 
    | AEBP21-039     | NSF-039            | 10              | -9990.42  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -6906.51 | 0.00     | 0.00     | 0.00     | -9990.42  | 
    #                                                                                                                                                £-60538.53                                  £-90702.79

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | AEBP21-039     | NSF-039            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 3               | 7412.81   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5834.43  | 0.00     | 0.00     | 0.00     | 3134.23  | 
    | AEBP21-039     | NSF-039            | 4               | 7788.05   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6299.19  | 0.00     | 0.00     | 0.00     | 3168.65  | 
    | AEBP21-039     | NSF-039            | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-039     | NSF-039            | 6               | 7584.67   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5673.33  | 0.00     | 0.00     | 0.00     | 3424.23  | 
    | AEBP21-039     | NSF-039            | 7               | 7923.14   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6395.54  | 0.00     | 0.00     | 0.00     | 3233.07  | 
    | AEBP21-039     | NSF-039            | 8               | 8153.31   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6614.76  | 0.00     | 0.00     | 0.00     | 3302.49  | 
    | AEBP21-039     | NSF-039            | 9               | 7351.48   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5849.73  | 0.00     | 0.00     | 0.00     | 3061.68  | 
    | AEBP21-039     | NSF-039            | 10              | 7209.03   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5993.01  | 0.00     | 0.00     | 0.00     | 2814.15  | 
    #                                                                                                                                                £31283.99                                   £ 16234.91


    # Tidy Up
    Given the override date is reset


