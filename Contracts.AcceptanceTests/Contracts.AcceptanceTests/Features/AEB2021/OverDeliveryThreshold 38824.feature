Feature: OverDeliveryThreshold 38824

@AcceptanceTest @Withdrawn25072024
Scenario: A023 AEB2021 Capping demo with 10% tolerance for AY 22/23 for alloc AEB-AS2223 
    Given there is no Contract, Task or Workflow data for UKPRN '10017023' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017023' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-023      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-023      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-AS2223        |

 #  # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
 #  And   there is no Subnominal data in CRM for the following subnominal codes
 #  | SubnominalCode |
 #  | 100927         |
 #  | 100928         |
 #  | 100929         |
 #  | 100930         |
 #  | 100931         |
 #  | 2372010        |
 #  | 2372016        |
 #  | 2372060        |


    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP21-023     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017023'

    # Set the 'base' timestamp for each of the 22/23 AEB document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_AEB2021_2021-08-01.docx                     | 2021-06-20 12:00:00.000 | 
    | AEB2021_2223_TAC_2022-08-01.docx                | 2022-06-20 12:00:00.000 | 
    | AEB2021_2223_S1_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
    | AEB2021_2223_S2_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
    | FA_AEB2021_2223_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
    | AEB2021_2223_S3ON_2022-08-01.docx               | 2022-06-20 12:00:00.000 | 




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017023' 
    And   there is no caseload advisor for UKPRN '10017023' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017023 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017023' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017023 Co Ltd' with UKPRN '10017023' and OrgId 'ORG0017023' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017023 | 117023 | 10017023 Co Ltd | 0              | In Administration     | Yes           | AA017023      | ?             | 9 Colme Street         | Edinburgh              | ?                      | ?                      | ?                      | ?                      | EH3 6AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017023 |





    # Change the date
    Given the override date is '01/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP21-023'
    And   there are no details in ContractManagement.CreatedContract for 'AEBP21-023'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017023 | 10017023 Co Ltd      | ESFA-023             | AEBP21-023     | 1                     | 01/08/2022        | 31/07/2023      | 18403.00      |                                       | Contract for Services                      | 2223   | New          | ORG0017023 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017023 | AEBP21-023     | AEBA-023      | AEB-AS            | AEB-AS2223              | AY                      | 01/08/2022          | 31/07/2023        | 18403.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableDescription                                                          | CRMIntent    | DeliveryOrg |
    | 10017023 | AEBP21-023     | AEBA-023      | 1               | 0                     | 18403.00  | 5000.00   | 13403.00  | 914.00   | 810.00   | 591.00   | 577.00   | 606.00   | 390.00   | 552.00   | 560.00   | 1452.00  | 4694.00  | 2371.00  | 4886.00  | Adult Skills Total Funding                                                      | New          |             | 
    | 10017023 | AEBP21-023     | AEBA-023      | 4               | 1                     | 8859.00   | 2778.00   | 6081.00   | 651.00   | 465.00   | 307.00   | 295.00   | 333.00   | 174.00   | 281.00   | 272.00   | 899.00   | 2836.00  | 726.00   | 1620.00  | Adult Skills                                                                    | New          |             | 
    | 10017023 | AEBP21-023     | AEBA-023      | 5               | 1                     | 9544.00   | 2222.00   | 7322.00   | 263.00   | 345.00   | 284.00   | 282.00   | 273.00   | 216.00   | 271.00   | 288.00   | 553.00   | 1858.00  | 1645.00  | 3266.00  | Adult Skills Learner Support                                                    | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP21-023     | 1                     | 0                        | 2022-07-01 09:12:35.000 |

    


    # Publish and approve

    # Change the date
    Given the override date is '03/07/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP21-023'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  contract approval messages arrive for the following contracts
    | MasterContractNumber | ContractNumber | Version |
    | ESFA-023             | AEBP21-023     | 1       |

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP21-023' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017023 | AEBP21-023         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017023 | ESFA-023           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP21-023' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '120' deliverable period rows in CRM linked to the latest version of contract 'AEBP21-023'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AEBA-023        | 2372010          | Jul-23 | Reconciliation |





    # Add actuals to the contract for AEB-AS2223

    # Change the date
    Given the override date is '04/08/2023'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017023'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jul 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202208 | AEB-AS2223              | AEBA-023                 | ?          | 2               | 0            | 1008.09     |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202208 | AEB-AS2223              | AEBA-023                 | ?          | 3               | 0            | 2012.55     |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202208 | AEB-AS2223              | AEBA-023                 | ?          | 6               | 0            | 618.63      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202208 | AEB-AS2223              | AEBA-023                 | ?          | 7               | 0            | 385.70      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202208 | AEB-AS2223              | AEBA-023                 | ?          | 8               | 0            | 797.29      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202208 | AEB-AS2223              | AEBA-023                 | ?          | 9               | 0            | 2017.91     |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202208 | AEB-AS2223              | AEBA-023                 | ?          | 10              | 0            | 908.65      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202209 | AEB-AS2223              | AEBA-023                 | ?          | 2               | 0            | 222.41      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202209 | AEB-AS2223              | AEBA-023                 | ?          | 3               | 0            | 2091.88     |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202209 | AEB-AS2223              | AEBA-023                 | ?          | 6               | 0            | 945.02      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202209 | AEB-AS2223              | AEBA-023                 | ?          | 7               | 0            | 719.72      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202209 | AEB-AS2223              | AEBA-023                 | ?          | 8               | 0            | 436.98      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202209 | AEB-AS2223              | AEBA-023                 | ?          | 9               | 0            | 929.86      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202209 | AEB-AS2223              | AEBA-023                 | ?          | 10              | 0            | 1211.08     |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202210 | AEB-AS2223              | AEBA-023                 | ?          | 2               | 0            | 1406.52     |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202210 | AEB-AS2223              | AEBA-023                 | ?          | 3               | 0            | 1246.63     |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202210 | AEB-AS2223              | AEBA-023                 | ?          | 6               | 0            | 415.76      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202210 | AEB-AS2223              | AEBA-023                 | ?          | 7               | 0            | 1433.78     |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202210 | AEB-AS2223              | AEBA-023                 | ?          | 8               | 0            | 1022.25     |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202210 | AEB-AS2223              | AEBA-023                 | ?          | 9               | 0            | 873.01      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202210 | AEB-AS2223              | AEBA-023                 | ?          | 10              | 0            | 540.91      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202211 | AEB-AS2223              | AEBA-023                 | ?          | 2               | 0            | 870.34      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202211 | AEB-AS2223              | AEBA-023                 | ?          | 3               | 0            | 2001.45     |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202211 | AEB-AS2223              | AEBA-023                 | ?          | 6               | 0            | 193.73      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202211 | AEB-AS2223              | AEBA-023                 | ?          | 7               | 0            | 528.80      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202211 | AEB-AS2223              | AEBA-023                 | ?          | 8               | 0            | 681.61      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202211 | AEB-AS2223              | AEBA-023                 | ?          | 9               | 0            | 667.85      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202211 | AEB-AS2223              | AEBA-023                 | ?          | 10              | 0            | 218.88      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202212 | AEB-AS2223              | AEBA-023                 | ?          | 2               | 0            | 805.32      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202212 | AEB-AS2223              | AEBA-023                 | ?          | 3               | 0            | 621.12      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202212 | AEB-AS2223              | AEBA-023                 | ?          | 6               | 0            | 267.12      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202212 | AEB-AS2223              | AEBA-023                 | ?          | 7               | 0            | 1092.67     |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202212 | AEB-AS2223              | AEBA-023                 | ?          | 8               | 0            | 494.14      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202212 | AEB-AS2223              | AEBA-023                 | ?          | 9               | 0            | 349.13      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202212 | AEB-AS2223              | AEBA-023                 | ?          | 10              | 0            | 2024.74     |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202301 | AEB-AS2223              | AEBA-023                 | ?          | 2               | 0            | 419.93      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202301 | AEB-AS2223              | AEBA-023                 | ?          | 3               | 0            | 336.99      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202301 | AEB-AS2223              | AEBA-023                 | ?          | 6               | 0            | 1471.68     |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202301 | AEB-AS2223              | AEBA-023                 | ?          | 7               | 0            | 828.77      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202301 | AEB-AS2223              | AEBA-023                 | ?          | 8               | 0            | 317.71      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202301 | AEB-AS2223              | AEBA-023                 | ?          | 9               | 0            | 938.97      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202301 | AEB-AS2223              | AEBA-023                 | ?          | 10              | 0            | 504.71      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202302 | AEB-AS2223              | AEBA-023                 | ?          | 2               | 0            | 337.71      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202302 | AEB-AS2223              | AEBA-023                 | ?          | 3               | 0            | 1491.84     |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202302 | AEB-AS2223              | AEBA-023                 | ?          | 6               | 0            | 438.89      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202302 | AEB-AS2223              | AEBA-023                 | ?          | 7               | 0            | 163.08      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202302 | AEB-AS2223              | AEBA-023                 | ?          | 8               | 0            | 213.22      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202302 | AEB-AS2223              | AEBA-023                 | ?          | 9               | 0            | 438.44      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202302 | AEB-AS2223              | AEBA-023                 | ?          | 10              | 0            | 104.56      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202303 | AEB-AS2223              | AEBA-023                 | ?          | 2               | 0            | 174.61      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202303 | AEB-AS2223              | AEBA-023                 | ?          | 3               | 0            | 378.07      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202303 | AEB-AS2223              | AEBA-023                 | ?          | 6               | 0            | 1970.59     |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202303 | AEB-AS2223              | AEBA-023                 | ?          | 7               | 0            | 453.09      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202303 | AEB-AS2223              | AEBA-023                 | ?          | 8               | 0            | 519.19      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202303 | AEB-AS2223              | AEBA-023                 | ?          | 9               | 0            | 598.83      |
 #  | ILR2223        | R12                  | ORG0017023     | CM             | 202303 | AEB-AS2223              | AEBA-023                 | ?          | 10              | 0            | 469.75      |
    #
    | ILR2223        | R12                  | ORG0017023     | CM             | 202304 | AEB-AS2223              | AEBA-023                 | ?          | 2               | 0            | 196.22      |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202304 | AEB-AS2223              | AEBA-023                 | ?          | 3               | 0            | 392.84      |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202304 | AEB-AS2223              | AEBA-023                 | ?          | 6               | 0            | 293.74      |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202304 | AEB-AS2223              | AEBA-023                 | ?          | 7               | 0            | 262.48      |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202304 | AEB-AS2223              | AEBA-023                 | ?          | 8               | 0            | 710.65      |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202304 | AEB-AS2223              | AEBA-023                 | ?          | 9               | 0            | 496.71      |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202304 | AEB-AS2223              | AEBA-023                 | ?          | 10              | 0            | 365.53      |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202305 | AEB-AS2223              | AEBA-023                 | ?          | 2               | 0            | 621.86      |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202305 | AEB-AS2223              | AEBA-023                 | ?          | 3               | 0            | 533.34      |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202305 | AEB-AS2223              | AEBA-023                 | ?          | 6               | 0            | 951.25      |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202305 | AEB-AS2223              | AEBA-023                 | ?          | 7               | 0            | 759.18      |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202305 | AEB-AS2223              | AEBA-023                 | ?          | 8               | 0            | 694.13      |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202305 | AEB-AS2223              | AEBA-023                 | ?          | 9               | 0            | 881.78      |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202305 | AEB-AS2223              | AEBA-023                 | ?          | 10              | 0            | 135.15      |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202306 | AEB-AS2223              | AEBA-023                 | ?          | 2               | 0            | 644.81      |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202306 | AEB-AS2223              | AEBA-023                 | ?          | 3               | 0            | 1250.25     |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202306 | AEB-AS2223              | AEBA-023                 | ?          | 6               | 0            | 1199.37     |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202306 | AEB-AS2223              | AEBA-023                 | ?          | 7               | 0            | 1349.50     |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202306 | AEB-AS2223              | AEBA-023                 | ?          | 8               | 0            | 1125.43     |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202306 | AEB-AS2223              | AEBA-023                 | ?          | 9               | 0            | 1162.45     |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202306 | AEB-AS2223              | AEBA-023                 | ?          | 10              | 0            | 225.68      |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202307 | AEB-AS2223              | AEBA-023                 | ?          | 2               | 0            | 1306.80     |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202307 | AEB-AS2223              | AEBA-023                 | ?          | 3               | 0            | 569.74      |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202307 | AEB-AS2223              | AEBA-023                 | ?          | 6               | 0            | 1205.78     |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202307 | AEB-AS2223              | AEBA-023                 | ?          | 7               | 0            | 1191.82     |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202307 | AEB-AS2223              | AEBA-023                 | ?          | 8               | 0            | 1345.06     |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202307 | AEB-AS2223              | AEBA-023                 | ?          | 9               | 0            | 1770.05     |
    | ILR2223        | R12                  | ORG0017023     | CM             | 202307 | AEB-AS2223              | AEBA-023                 | ?          | 10              | 0            | 484.68      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



    # Check Financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-023     | AEBA-023           | 1               | 18403.00  | 5000.00  | 13403.00 | 914.00   | 810.00   | 591.00   | 577.00   | 606.00   | 390.00   | 552.00   | 560.00   | 1452.00  | 4694.00  | 2371.00  | 4886.00  | 
    | AEBP21-023     | AEBA-023           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-023     | AEBA-023           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-023     | AEBA-023           | 4               | 8859.00   | 2778.00  | 6081.00  | 651.00   | 465.00   | 307.00   | 295.00   | 333.00   | 174.00   | 281.00   | 272.00   | 899.00   | 2836.00  | 726.00   | 1620.00  | 
    | AEBP21-023     | AEBA-023           | 5               | 9544.00   | 2222.00  | 7322.00  | 263.00   | 345.00   | 284.00   | 282.00   | 273.00   | 216.00   | 271.00   | 288.00   | 553.00   | 1858.00  | 1645.00  | 3266.00  | 
    | AEBP21-023     | AEBA-023           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-023     | AEBA-023           | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-023     | AEBA-023           | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-023     | AEBA-023           | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-023     | AEBA-023           | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-023     | AEBA-023           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-023     | AEBA-023           | 2               | 2769.69   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 196.22   | 621.86   | 644.81   | 1306.80  | 
    | AEBP21-023     | AEBA-023           | 3               | 2746.17   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 392.84   | 533.34   | 1250.25  | 569.74   | 
    | AEBP21-023     | AEBA-023           | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-023     | AEBA-023           | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-023     | AEBA-023           | 6               | 3650.14   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 293.74   | 951.25   | 1199.37  | 1205.78  | 
    | AEBP21-023     | AEBA-023           | 7               | 3562.98   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 262.48   | 759.18   | 1349.50  | 1191.82  | 
    | AEBP21-023     | AEBA-023           | 8               | 3875.27   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 710.65   | 694.13   | 1125.43  | 1345.06  | 
    | AEBP21-023     | AEBA-023           | 9               | 4310.99   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 496.71   | 881.78   | 1162.45  | 1770.05  | 
    | AEBP21-023     | AEBA-023           | 10              | 1211.04   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 365.53   | 135.15   | 225.68   | 484.68   | 
    #                                                       £ 22126.28

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-023     | AEBA-023           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-023     | AEBA-023           | 2               | 2769.69   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2769.69  | 
    | AEBP21-023     | AEBA-023           | 3               | 2746.17   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2746.17  | 
    | AEBP21-023     | AEBA-023           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-023     | AEBA-023           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-023     | AEBA-023           | 6               | 3650.14   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3650.14  | 
    | AEBP21-023     | AEBA-023           | 7               | 3562.98   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3562.98  | 
    | AEBP21-023     | AEBA-023           | 8               | 3875.27   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3875.27  | 
    | AEBP21-023     | AEBA-023           | 9               | 4310.99   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4310.99  | 
    | AEBP21-023     | AEBA-023           | 10              | 1211.04   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1211.04  | 
    #                                                       £ 22126.28

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-023     | AEBA-023           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-023     | AEBA-023           | 2               | -235.70   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -235.70  | 
    | AEBP21-023     | AEBA-023           | 3               | -233.70   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -233.70  | 
    | AEBP21-023     | AEBA-023           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-023     | AEBA-023           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-023     | AEBA-023           | 6               | -310.63   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -310.63  | 
    | AEBP21-023     | AEBA-023           | 7               | -303.22   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -303.22  | 
    | AEBP21-023     | AEBA-023           | 8               | -329.79   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -329.79  | 
    | AEBP21-023     | AEBA-023           | 9               | -366.87   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -366.87  | 
    | AEBP21-023     | AEBA-023           | 10              | -103.06   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -103.06  | 
    #                                                       £ -1882.97

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-023     | AEBA-023           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-023     | AEBA-023           | 2               | 2533.99   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2533.99  | 
    | AEBP21-023     | AEBA-023           | 3               | 2512.47   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2512.47  | 
    | AEBP21-023     | AEBA-023           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-023     | AEBA-023           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-023     | AEBA-023           | 6               | 3339.51   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3339.51  | 
    | AEBP21-023     | AEBA-023           | 7               | 3259.76   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3259.76  | 
    | AEBP21-023     | AEBA-023           | 8               | 3545.48   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3545.48  | 
    | AEBP21-023     | AEBA-023           | 9               | 3944.12   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3944.12  | 
    | AEBP21-023     | AEBA-023           | 10              | 1107.98   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1107.98  | 
    #                                                       £ 20243.31

    # Explanation ...
    #
    # Profile for AY 22/23 (18,403.00) x 110% = 20,243.30 (ProfileX)
    # Cap = ProfileX (20,243.30) - Actuals (22,126.28) = Cap (-1,882.98)
    # Apportion Cap between Deliverables as follows:
    #       Cap * Actuals for Deliverable/Total actuals
    # D2 cap = -1,882.98 * (2,769.69/22,126.28) = -235.70   
    # D3 cap = -1,882.98 * (2,746.17/22,126.28) = -233.70  
    # D6 cap = -1,882.98 * (3,650.14/22,126.28) = -310.63
    # D7 cap = -1,882.98 * (3,562.98/22,126.28) = -303.22
    # D8 cap = -1,882.98 * (3,875.27/22,126.28) = -329.79
    # D9 cap = -1,882.98 * (4,310.99/22,126.28) = -366.87
    # D10 cap = -1,882.98 * (1,211.04/22,126.28) = -103.06


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Withdrawn25072024
Scenario: A024 AEB2021 Capping demo with 10% tolerance for FY 22/23 for alloc AEB-NSF2223
    Given there is no Contract, Task or Workflow data for UKPRN '10017024' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017024' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | NSF-024       |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | NSF-024       |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-NSF2223       |

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
    | AEBP21-024     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017024'

    # Set the 'base' timestamp for each of the 22/23 AEB document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_AEB2021_2021-08-01.docx                     | 2021-06-20 12:00:00.000 | 
    | AEB2021_2223_TAC_2022-08-01.docx                | 2022-06-20 12:00:00.000 | 
    | AEB2021_2223_S1_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
    | AEB2021_2223_S2_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
    | FA_AEB2021_2223_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
    | AEB2021_2223_S3ON_2022-08-01.docx               | 2022-06-20 12:00:00.000 | 




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017024' 
    And   there is no caseload advisor for UKPRN '10017024' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017024 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017024' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017024 Co Ltd' with UKPRN '10017024' and OrgId 'ORG0017024' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017024 | 117024 | 10017024 Co Ltd | 0              | Active                | Yes           | AA017024      | ?             | 111 Hagley Road        | Edgbaston              | ?                      | ?                      | Birmingham             | West Midlands          | B16 8LB   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017024 |





    # Change the date
    Given the override date is '01/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP21-024'
    And   there are no details in ContractManagement.CreatedContract for 'AEBP21-024'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017024 | 10017024 Co Ltd      | ESFA-024             | AEBP21-024     | 1                     | 01/08/2022        | 31/07/2023      | 43199.00      |                                       | Contract for Services                      | 2223   | New          | ORG0017024 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription  | CRMIntent    | DeliveryOrg |
    | 10017024 | AEBP21-024     | NSF-024       | AEB-NSF           | AEB-NSF2223             | AY                      | 01/08/2022          | 31/07/2023        | 43199.00        |                                         |            |                        | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableDescription                | CRMIntent    | DeliveryOrg |
    | 10017024 | AEBP21-024     | NSF-024       | 1               | 0                     | 43199.00  | 28440.00  | 14759.00  | 4028.00  | 2022.00  | 6306.00  | 2590.00  | 3618.00  | 535.00   | 3366.00  | 5975.00  | 4567.00  | 407.00   | 5485.00  | 4300.00  | National Skills Fund Total Funding    | New          |             | 
    | 10017024 | AEBP21-024     | NSF-024       | 2               | 1                     | 16804.00  | 10117.00  | 6687.00   | 1027.00  | 340.00   | 3384.00  | 671.00   | 1407.00  | 182.00   | 157.00   | 2949.00  | 1976.00  | 212.00   | 1802.00  | 2697.00  | Level 3 Free Courses for Jobs         | New          |             | 
    | 10017024 | AEBP21-024     | NSF-024       | 5               | 1                     | 26395.00  | 18323.00  | 8072.00   | 3001.00  | 1682.00  | 2922.00  | 1919.00  | 2211.00  | 353.00   | 3209.00  | 3026.00  | 2591.00  | 195.00   | 3683.00  | 1603.00  | National Skills Fund Learner Support  | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP21-024     | 1                     | 0                        | 2022-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP21-024'





    # Publish and approve

    # Change the date
    Given the override date is '03/07/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP21-024'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  contract approval messages arrive for the following contracts
    | MasterContractNumber | ContractNumber | Version |
    | ESFA-024             | AEBP21-024     | 1       |

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP21-024' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017024 | AEBP21-024         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017024 | ESFA-024           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP21-024' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '120' deliverable period rows in CRM linked to the latest version of contract 'AEBP21-024'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | NSF-024         | 100944           | Jul-23 | Reconciliation |





    # Add actuals to the contract for AEB-NSF2223 for FY1

    # Change the date
    Given the override date is '04/04/2023'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017024'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jul 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202208 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1732.62     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202208 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1753.25     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202208 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1424.28     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202208 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 2184.27     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202208 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 1719.45     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202208 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1165.36     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202208 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1382.58     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202209 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1037.94     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202209 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1035.19     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202209 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1800.35     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202209 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 1193.56     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202209 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 2219.72     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202209 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1658.26     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202209 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1688.53     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202210 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1819.38     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202210 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 2033.75     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202210 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1304.25     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202210 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 2248.75     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202210 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 2106.59     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202210 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1280.95     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202210 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1848.58     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202211 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1670.42     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202211 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1590.11     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202211 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1547.25     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202211 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 2111.61     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202211 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 1608.04     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202211 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1909.58     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202211 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1504.35     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202212 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1356.35     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202212 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1688.23     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202212 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1288.27     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202212 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 1273.02     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202212 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 1398.60     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202212 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1129.25     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202212 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1574.51     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202301 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 2048.90     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202301 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1779.56     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202301 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1573.04     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202301 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 1495.61     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202301 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 1840.75     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202301 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1951.07     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202301 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1229.75     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202302 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1224.20     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202302 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1871.28     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202302 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1623.20     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202302 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 1334.81     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202302 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 1557.18     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202302 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1690.33     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202302 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1774.44     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202303 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1668.38     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202303 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1807.17     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202303 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1650.79     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202303 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 1924.31     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202303 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 1787.45     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202303 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1806.32     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202303 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1896.78     |
    #
    | ILR2223        | R08                  | ORG0017024     | CM             | 202304 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1318.61     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202304 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1620.34     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202304 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1572.78     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202304 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 1564.44     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202304 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 2176.97     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202304 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1773.75     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202304 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1789.61     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202305 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1645.26     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202305 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1803.06     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202305 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1902.28     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202305 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 1996.15     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202305 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 1111.83     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202305 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 2007.26     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202305 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1240.43     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202306 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1441.95     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202306 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1456.12     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202306 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1891.77     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202306 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 1897.21     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202306 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 2153.18     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202306 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1140.28     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202306 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1348.31     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202307 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 2163.09     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202307 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1761.52     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202307 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1809.87     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202307 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 1318.26     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202307 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 1479.57     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202307 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1495.56     |
    | ILR2223        | R08                  | ORG0017024     | CM             | 202307 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1519.71     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



    # Check CRM and PaaS

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-024     | NSF-024            | 1               | 43199.00  | 28440.00 | 14759.00 | 4028.00  | 2022.00  | 6306.00  | 2590.00  | 3618.00  | 535.00   | 3366.00  | 5975.00  | 4567.00  | 407.00   | 5485.00  | 4300.00  | 
    | AEBP21-024     | NSF-024            | 2               | 16804.00  | 10117.00 | 6687.00  | 1027.00  | 340.00   | 3384.00  | 671.00   | 1407.00  | 182.00   | 157.00   | 2949.00  | 1976.00  | 212.00   | 1802.00  | 2697.00  | 
    | AEBP21-024     | NSF-024            | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 5               | 26395.00  | 18323.00 | 8072.00  | 3001.00  | 1682.00  | 2922.00  | 1919.00  | 2211.00  | 353.00   | 3209.00  | 3026.00  | 2591.00  | 195.00   | 3683.00  | 1603.00  | 
    | AEBP21-024     | NSF-024            | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-024     | NSF-024            | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-024     | NSF-024            | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-024     | NSF-024            | 3               | 12558.19  | 1732.62  | 1037.94  | 1819.38  | 1670.42  | 1356.35  | 2048.90  | 1224.20  | 1668.38  | ?        | ?        | ?        | ?        | 
    | AEBP21-024     | NSF-024            | 4               | 13558.54  | 1753.25  | 1035.19  | 2033.75  | 1590.11  | 1688.23  | 1779.56  | 1871.28  | 1807.17  | ?        | ?        | ?        | ?        | 
    | AEBP21-024     | NSF-024            | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-024     | NSF-024            | 6               | 12211.43  | 1424.28  | 1800.35  | 1304.25  | 1547.25  | 1288.27  | 1573.04  | 1623.20  | 1650.79  | ?        | ?        | ?        | ?        | 
    | AEBP21-024     | NSF-024            | 7               | 13765.94  | 2184.27  | 1193.56  | 2248.75  | 2111.61  | 1273.02  | 1495.61  | 1334.81  | 1924.31  | ?        | ?        | ?        | ?        | 
    | AEBP21-024     | NSF-024            | 8               | 14237.78  | 1719.45  | 2219.72  | 2106.59  | 1608.04  | 1398.60  | 1840.75  | 1557.18  | 1787.45  | ?        | ?        | ?        | ?        | 
    | AEBP21-024     | NSF-024            | 9               | 12591.12  | 1165.36  | 1658.26  | 1280.95  | 1909.58  | 1129.25  | 1951.07  | 1690.33  | 1806.32  | ?        | ?        | ?        | ?        | 
    | AEBP21-024     | NSF-024            | 10              | 12899.52  | 1382.58  | 1688.53  | 1848.58  | 1504.35  | 1574.51  | 1229.75  | 1774.44  | 1896.78  | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-024     | NSF-024            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 3               | 12558.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12558.19 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 4               | 13558.54  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13558.54 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 6               | 12211.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12211.43 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 7               | 13765.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13765.94 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 8               | 14237.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14237.78 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 9               | 12591.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12591.12 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 10              | 12899.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12899.52 | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                                                                                                £ 91822.52                
    
    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-024     | NSF-024            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 3               | -8279.61  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -8279.61 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 4               | -8939.14  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -8939.14 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 6               | -8050.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -8050.99 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 7               | -9075.87  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -9075.87 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 8               | -9386.96  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -9386.96 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 9               | -8301.32  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -8301.32 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 10              | -8504.64  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -8504.64 | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                                                                                                £-60538.53                                         
    
    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-024     | NSF-024            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 3               | 4278.58   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4278.58  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 4               | 4619.40   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4619.40  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 6               | 4160.44   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4160.44  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 7               | 4690.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4690.07  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 8               | 4850.82   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4850.82  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 9               | 4289.80   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4289.80  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 10              | 4394.88   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4394.88  | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                                                                                                £31283.99                





    # Add actuals to the contract for AEB-NSF2223 for FY2 (FY1 unchanged)

    # Change the date
    Given the override date is '04/08/2023'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017024'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jul 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202208 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1732.62     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202208 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1753.25     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202208 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1424.28     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202208 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 2184.27     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202208 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 1719.45     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202208 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1165.36     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202208 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1382.58     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202209 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1037.94     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202209 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1035.19     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202209 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1800.35     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202209 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 1193.56     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202209 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 2219.72     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202209 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1658.26     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202209 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1688.53     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202210 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1819.38     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202210 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 2033.75     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202210 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1304.25     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202210 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 2248.75     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202210 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 2106.59     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202210 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1280.95     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202210 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1848.58     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202211 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1670.42     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202211 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1590.11     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202211 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1547.25     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202211 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 2111.61     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202211 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 1608.04     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202211 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1909.58     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202211 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1504.35     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202212 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1356.35     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202212 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1688.23     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202212 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1288.27     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202212 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 1273.02     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202212 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 1398.60     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202212 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1129.25     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202212 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1574.51     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202301 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 2048.90     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202301 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1779.56     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202301 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1573.04     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202301 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 1495.61     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202301 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 1840.75     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202301 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1951.07     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202301 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1229.75     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202302 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1224.20     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202302 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1871.28     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202302 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1623.20     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202302 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 1334.81     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202302 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 1557.18     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202302 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1690.33     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202302 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1774.44     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202303 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1668.38     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202303 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1807.17     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202303 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1650.79     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202303 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 1924.31     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202303 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 1787.45     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202303 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1806.32     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202303 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1896.78     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202304 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1318.61     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202304 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1620.34     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202304 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1572.78     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202304 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 1564.44     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202304 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 2176.97     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202304 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1773.75     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202304 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1789.61     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202305 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1645.26     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202305 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1803.06     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202305 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1902.28     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202305 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 1996.15     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202305 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 1111.83     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202305 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 2007.26     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202305 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1240.43     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202306 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 1441.95     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202306 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1456.12     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202306 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1891.77     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202306 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 1897.21     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202306 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 2153.18     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202306 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1140.28     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202306 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1348.31     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202307 | AEB-NSF2223             | NSF-024                  | ?          | 3               | 0            | 2163.09     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202307 | AEB-NSF2223             | NSF-024                  | ?          | 4               | 0            | 1761.52     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202307 | AEB-NSF2223             | NSF-024                  | ?          | 6               | 0            | 1809.87     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202307 | AEB-NSF2223             | NSF-024                  | ?          | 7               | 0            | 1318.26     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202307 | AEB-NSF2223             | NSF-024                  | ?          | 8               | 0            | 1479.57     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202307 | AEB-NSF2223             | NSF-024                  | ?          | 9               | 0            | 1495.56     |
    | ILR2223        | R12                  | ORG0017024     | CM             | 202307 | AEB-NSF2223             | NSF-024                  | ?          | 10              | 0            | 1519.71     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



    # Check CRM and PaaS

    # Check the PLANNED VALUES in CRM on the latest approved contract (Unchanged from before)
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-024     | NSF-024            | 1               | 43199.00  | 28440.00 | 14759.00 | 4028.00  | 2022.00  | 6306.00  | 2590.00  | 3618.00  | 535.00   | 3366.00  | 5975.00  | 4567.00  | 407.00   | 5485.00  | 4300.00  | 
    | AEBP21-024     | NSF-024            | 2               | 16804.00  | 10117.00 | 6687.00  | 1027.00  | 340.00   | 3384.00  | 671.00   | 1407.00  | 182.00   | 157.00   | 2949.00  | 1976.00  | 212.00   | 1802.00  | 2697.00  | 
    | AEBP21-024     | NSF-024            | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 5               | 26395.00  | 18323.00 | 8072.00  | 3001.00  | 1682.00  | 2922.00  | 1919.00  | 2211.00  | 353.00   | 3209.00  | 3026.00  | 2591.00  | 195.00   | 3683.00  | 1603.00  | 
    | AEBP21-024     | NSF-024            | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
                        
    # Check the ACTUAL VALUES in CRM on the latest approved contract
    And   the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-024     | NSF-024            | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-024     | NSF-024            | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-024     | NSF-024            | 3               | 19127.10  | 1732.62  | 1037.94  | 1819.38  | 1670.42  | 1356.35  | 2048.90  | 1224.20  | 1668.38  | 1318.61  | 1645.26  | 1441.95  | 2163.09  | 
    | AEBP21-024     | NSF-024            | 4               | 20199.58  | 1753.25  | 1035.19  | 2033.75  | 1590.11  | 1688.23  | 1779.56  | 1871.28  | 1807.17  | 1620.34  | 1803.06  | 1456.12  | 1761.52  | 
    | AEBP21-024     | NSF-024            | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-024     | NSF-024            | 6               | 19388.13  | 1424.28  | 1800.35  | 1304.25  | 1547.25  | 1288.27  | 1573.04  | 1623.20  | 1650.79  | 1572.78  | 1902.28  | 1891.77  | 1809.87  | 
    | AEBP21-024     | NSF-024            | 7               | 20542.00  | 2184.27  | 1193.56  | 2248.75  | 2111.61  | 1273.02  | 1495.61  | 1334.81  | 1924.31  | 1564.44  | 1996.15  | 1897.21  | 1318.26  | 
    | AEBP21-024     | NSF-024            | 8               | 21159.33  | 1719.45  | 2219.72  | 2106.59  | 1608.04  | 1398.60  | 1840.75  | 1557.18  | 1787.45  | 2176.97  | 1111.83  | 2153.18  | 1479.57  | 
    | AEBP21-024     | NSF-024            | 9               | 19007.97  | 1165.36  | 1658.26  | 1280.95  | 1909.58  | 1129.25  | 1951.07  | 1690.33  | 1806.32  | 1773.75  | 2007.26  | 1140.28  | 1495.56  | 
    | AEBP21-024     | NSF-024            | 10              | 18797.58  | 1382.58  | 1688.53  | 1848.58  | 1504.35  | 1574.51  | 1229.75  | 1774.44  | 1896.78  | 1789.61  | 1240.43  | 1348.31  | 1519.71  | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-024     | NSF-024            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 3               | 27406.71  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12558.19 | 0.00     | 0.00     | 0.00     | 14848.52 | 
    | AEBP21-024     | NSF-024            | 4               | 29138.72  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13558.54 | 0.00     | 0.00     | 0.00     | 15580.18 | 
    | AEBP21-024     | NSF-024            | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 6               | 27439.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12211.43 | 0.00     | 0.00     | 0.00     | 15227.69 | 
    | AEBP21-024     | NSF-024            | 7               | 29617.87  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13765.94 | 0.00     | 0.00     | 0.00     | 15851.93 | 
    | AEBP21-024     | NSF-024            | 8               | 30546.29  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14237.78 | 0.00     | 0.00     | 0.00     | 16308.51 | 
    | AEBP21-024     | NSF-024            | 9               | 27309.29  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12591.12 | 0.00     | 0.00     | 0.00     | 14718.17 | 
    | AEBP21-024     | NSF-024            | 10              | 27302.22  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12899.52 | 0.00     | 0.00     | 0.00     | 14402.70 | 
    #                                                                                                                                                £ 91822.52                                  £ 106937.70

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23    |
    | AEBP21-024     | NSF-024            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | AEBP21-024     | NSF-024            | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | AEBP21-024     | NSF-024            | 3               | -20829.69 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -8279.61 | 0.00     | 0.00     | 0.00     | -12550.08 | 
    | AEBP21-024     | NSF-024            | 4               | -22195.64 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -8939.14 | 0.00     | 0.00     | 0.00     | -13256.50 | 
    | AEBP21-024     | NSF-024            | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | AEBP21-024     | NSF-024            | 6               | -20767.58 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -8050.99 | 0.00     | 0.00     | 0.00     | -12716.59 | 
    | AEBP21-024     | NSF-024            | 7               | -22556.88 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -9075.87 | 0.00     | 0.00     | 0.00     | -13481.01 | 
    | AEBP21-024     | NSF-024            | 8               | -23273.64 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -9386.96 | 0.00     | 0.00     | 0.00     | -13886.68 | 
    | AEBP21-024     | NSF-024            | 9               | -20774.26 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -8301.32 | 0.00     | 0.00     | 0.00     | -12472.94 | 
    | AEBP21-024     | NSF-024            | 10              | -20843.63 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -8504.64 | 0.00     | 0.00     | 0.00     | -12338.99 | 
    #                                                                                                                                                £-60538.53                                  £-90702.79

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-024     | NSF-024            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 3               | 6577.02   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4278.58  | 0.00     | 0.00     | 0.00     | 2298.44  | 
    | AEBP21-024     | NSF-024            | 4               | 6943.08   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4619.40  | 0.00     | 0.00     | 0.00     | 2323.68  | 
    | AEBP21-024     | NSF-024            | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-024     | NSF-024            | 6               | 6671.54   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4160.44  | 0.00     | 0.00     | 0.00     | 2511.10  | 
    | AEBP21-024     | NSF-024            | 7               | 7060.99   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4690.07  | 0.00     | 0.00     | 0.00     | 2370.92  | 
    | AEBP21-024     | NSF-024            | 8               | 7272.65   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4850.82  | 0.00     | 0.00     | 0.00     | 2421.83  | 
    | AEBP21-024     | NSF-024            | 9               | 6535.03   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4289.80  | 0.00     | 0.00     | 0.00     | 2245.23  | 
    | AEBP21-024     | NSF-024            | 10              | 6458.59   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 4394.88  | 0.00     | 0.00     | 0.00     | 2063.71  | 
    #                                                                                                                                                £31283.99                                   £ 16234.91


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Withdrawn20260521
Scenario: A025 AEB2021 Capping with 10% tolerance for AY 22/23 for alloc AEB-AS2223
    Given there is no Contract, Task or Workflow data for UKPRN '10017025' 

    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017025' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-025      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-025      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-AS2223        |

 #  # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
 #  And   there is no Subnominal data in CRM for the following subnominal codes
 #  | SubnominalCode |
 #  | 100927         |
 #  | 100928         |
 #  | 100929         |
 #  | 100930         |
 #  | 100931         |
 #  | 2372010        |
 #  | 2372016        |
 #  | 2372060        |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP21-025     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017025'

    # Set the 'base' timestamp for each of the 22/23 AEB document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_AEB2021_2021-08-01.docx                     | 2021-06-20 12:00:00.000 | 
    | AEB2021_2223_TAC_2022-08-01.docx                | 2022-06-20 12:00:00.000 | 
    | AEB2021_2223_S1_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
    | AEB2021_2223_S2_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
    | FA_AEB2021_2223_2022-08-01.docx                 | 2022-06-20 12:00:00.000 | 
    | AEB2021_2223_S3ON_2022-08-01.docx               | 2022-06-20 12:00:00.000 | 




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017025' 
    And   there is no caseload advisor for UKPRN '10017025' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017025 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017025' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017025 Co Ltd' with UKPRN '10017025' and OrgId 'ORG0017025' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017025 | 117025 | 10017025 Co Ltd | 0              | Provider Under Change | Yes           | AA017025      | ?             | 108 Welsh Row          | ?                      | ?                      | ?                      | Nantwich               | Cheshire               | CW5 5EY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017025 |





    # Change the date
    Given the override date is '01/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP21-025'
    And   there are no details in ContractManagement.CreatedContract for 'AEBP21-025'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017025 | 10017025 Co Ltd      | ESFA-025             | AEBP21-025     | 1                     | 01/08/2022        | 31/07/2023      | 49972.00      |                                       | Contract for Services                      | 2223   | New          | ORG0017025 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017025 | AEBP21-025     | AEBA-025      | AEB-AS            | AEB-AS2223              | AY                      | 01/08/2022          | 31/07/2023        | 49972.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableDescription                                                          | CRMIntent    | DeliveryOrg |
    | 10017025 | AEBP21-025     | AEBA-025      | 1               | 0                     | 49972.00  | 35422.00  | 14550.00  | 5826.00  | 3820.00  | 4403.00  | 4388.00  | 5416.00  | 2333.00  | 5164.00  | 4072.00  | 2664.00  | 2205.00  | 7284.00  | 2397.00  | Adult Skills Total Funding                                                      | New          |             | 
    | 10017025 | AEBP21-025     | AEBA-025      | 4               | 1                     | 24453.00  | 17683.00  | 6770.00   | 2898.00  | 2211.00  | 1554.00  | 2542.00  | 3278.00  | 2053.00  | 2028.00  | 1119.00  | 146.00   | 2083.00  | 3674.00  | 867.00   | Adult Skills                                                                    | New          |             | 
    | 10017025 | AEBP21-025     | AEBA-025      | 5               | 1                     | 25519.00  | 17739.00  | 7780.00   | 2928.00  | 1609.00  | 2849.00  | 1846.00  | 2138.00  | 280.00   | 3136.00  | 2953.00  | 2518.00  | 122.00   | 3610.00  | 1530.00  | Adult Skills Learner Support                                                    | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP21-025'





    # Publish and approve

    # Change the date
    Given the override date is '09/07/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP21-025'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-025' and ContractNumber 'AEBP21-025' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP21-025' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017025 | AEBP21-025         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017025 | ESFA-025           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '120' deliverable period rows in CRM linked to the latest version of contract 'AEBP21-025'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AEBA-025        | 2372010          | Jul-23 | Reconciliation |





    # Add actuals to the contract for AEB-AS2223 for Mar 23

    # Change the date
    Given the override date is '04/04/2023'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017025'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Mar 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202208 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 2237.60     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202208 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 489.65      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202208 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 790.45      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202208 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 1460.88     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202208 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 899.89      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202208 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 725.72      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202208 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 1438.33     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202209 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 2274.00     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202209 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 1215.23     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202209 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 440.57      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202209 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 836.17      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202209 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 578.25      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202209 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 534.12      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202209 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 1413.91     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202210 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 1651.14     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202210 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 2153.40     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202210 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 1073.58     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202210 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 1325.92     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202210 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 2048.95     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202210 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 1083.54     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202210 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 2337.47     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202211 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 1796.32     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202211 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 976.63      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202211 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 1708.80     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202211 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 2461.73     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202211 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 2248.47     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202211 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 1870.43     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202211 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 1201.77     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202212 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 2184.78     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202212 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 598.37      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202212 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 2188.50     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202212 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 2069.16     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202212 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 942.78      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202212 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 768.80      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202212 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 2368.83     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202301 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 2078.31     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202301 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 1889.98     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202301 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 1828.33     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202301 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 611.96      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202301 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 1508.76     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202301 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 643.96      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202301 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 2355.36     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202302 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 788.91      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202302 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 428.82      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202302 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 1856.05     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202302 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 1127.24     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202302 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 1973.86     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202302 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 697.16      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202302 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 606.52      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202303 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 434.32      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202303 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 1102.03     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202303 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 2189.32     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202303 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 2125.02     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202303 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 1519.00     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202303 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 2452.53     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202303 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 1649.28     |
    #
    | ILR2223        | R08                  | ORG0017025     | CM             | 202304 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 2135.79     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202304 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 539.76      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202304 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 2456.09     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202304 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 466.07      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202304 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 1328.00     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202304 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 1860.30     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202304 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 2327.93     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202305 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 2475.31     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202305 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 1451.13     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202305 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 2463.51     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202305 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 2325.54     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202305 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 1785.71     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202305 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 1935.17     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202305 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 2090.62     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202306 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 731.52      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202306 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 530.74      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202306 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 1236.00     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202306 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 1305.21     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202306 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 1761.40     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202306 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 1945.15     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202306 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 805.73      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202307 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 2182.30     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202307 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 896.40      |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202307 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 1866.45     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202307 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 1187.92     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202307 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 1122.35     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202307 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 2241.28     |
    | ILR2223        | R08                  | ORG0017025     | CM             | 202307 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 1761.62     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    

    # Check CRM and PaaS

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-025     | AEBA-025           | 1               | 49972.00  | 35422.00 | 14550.00 | 5826.00  | 3820.00  | 4403.00  | 4388.00  | 5416.00  | 2333.00  | 5164.00  | 4072.00  | 2664.00  | 2205.00  | 7284.00  | 2397.00  | 
    | AEBP21-025     | AEBA-025           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 4               | 24453.00  | 17683.00 | 6770.00  | 2898.00  | 2211.00  | 1554.00  | 2542.00  | 3278.00  | 2053.00  | 2028.00  | 1119.00  | 146.00   | 2083.00  | 3674.00  | 867.00   | 
    | AEBP21-025     | AEBA-025           | 5               | 25519.00  | 17739.00 | 7780.00  | 2928.00  | 1609.00  | 2849.00  | 1846.00  | 2138.00  | 280.00   | 3136.00  | 2953.00  | 2518.00  | 122.00   | 3610.00  | 1530.00  | 
    | AEBP21-025     | AEBA-025           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
  
    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-025     | AEBA-025           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-025     | AEBA-025           | 2               | 13445.38  | 2237.60  | 2274.00  | 1651.14  | 1796.32  | 2184.78  | 2078.31  | 788.91   | 434.32   | ?        | ?        | ?        | ?        | 
    | AEBP21-025     | AEBA-025           | 3               | 8854.11   | 489.65   | 1215.23  | 2153.40  | 976.63   | 598.37   | 1889.98  | 428.82   | 1102.03  | ?        | ?        | ?        | ?        | 
    | AEBP21-025     | AEBA-025           | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-025     | AEBA-025           | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-025     | AEBA-025           | 6               | 12075.60  | 790.45   | 440.57   | 1073.58  | 1708.80  | 2188.50  | 1828.33  | 1856.05  | 2189.32  | ?        | ?        | ?        | ?        | 
    | AEBP21-025     | AEBA-025           | 7               | 12018.08  | 1460.88  | 836.17   | 1325.92  | 2461.73  | 2069.16  | 611.96   | 1127.24  | 2125.02  | ?        | ?        | ?        | ?        | 
    | AEBP21-025     | AEBA-025           | 8               | 11719.96  | 899.89   | 578.25   | 2048.95  | 2248.47  | 942.78   | 1508.76  | 1973.86  | 1519.00  | ?        | ?        | ?        | ?        | 
    | AEBP21-025     | AEBA-025           | 9               | 8776.26   | 725.72   | 534.12   | 1083.54  | 1870.43  | 768.80   | 643.96   | 697.16   | 2452.53  | ?        | ?        | ?        | ?        | 
    | AEBP21-025     | AEBA-025           | 10              | 13371.47  | 1438.33  | 1413.91  | 2337.47  | 1201.77  | 2368.83  | 2355.36  | 606.52   | 1649.28  | ?        | ?        | ?        | ?        | 
  
    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-025     | AEBA-025           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 2               | 13445.38  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13445.38 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 3               | 8854.11   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8854.11  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 6               | 12075.60  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12075.60 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 7               | 12018.08  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12018.08 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 8               | 11719.96  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 11719.96 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 9               | 8776.26   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8776.26  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 10              | 13371.47  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13371.47 | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-025     | AEBA-025           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 2               | -4236.88  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4236.88 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 3               | -2790.09   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00    | -2790.09 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 6               | -3805.24  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -3805.24 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 7               | -3787.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -3787.12 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 8               | -3693.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -3693.17 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 9               | -2765.56  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2765.56 | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 10              | -4213.59  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4213.59 | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-025     | AEBA-025           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 2               | 9208.50   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 9208.50  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 3               | 6064.02   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6064.02  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 6               | 8270.36   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8270.36  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 7               | 8230.96   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8230.96  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 8               | 8026.79   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8026.79  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 9               | 6010.70   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6010.70  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 10              | 9157.88   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 9157.88  | 0.00     | 0.00     | 0.00     | 0.00     | 





    # Add actuals to the contract for AEB-AS2223 for Jul 23

    # Change the date
    Given the override date is '04/08/2023'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017025'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Jul 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202208 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 2237.60     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202208 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 489.65      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202208 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 790.45      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202208 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 1460.88     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202208 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 899.89      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202208 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 725.72      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202208 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 1438.33     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202209 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 2274.00     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202209 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 1215.23     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202209 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 440.57      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202209 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 836.17      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202209 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 578.25      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202209 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 534.12      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202209 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 1413.91     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202210 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 1651.14     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202210 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 2153.40     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202210 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 1073.58     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202210 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 1325.92     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202210 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 2048.95     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202210 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 1083.54     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202210 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 2337.47     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202211 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 1796.32     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202211 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 976.63      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202211 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 1708.80     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202211 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 2461.73     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202211 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 2248.47     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202211 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 1870.43     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202211 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 1201.77     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202212 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 2184.78     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202212 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 598.37      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202212 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 2188.50     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202212 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 2069.16     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202212 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 942.78      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202212 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 768.80      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202212 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 2368.83     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202301 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 2078.31     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202301 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 1889.98     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202301 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 1828.33     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202301 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 611.96      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202301 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 1508.76     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202301 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 643.96      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202301 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 2355.36     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202302 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 788.91      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202302 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 428.82      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202302 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 1856.05     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202302 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 1127.24     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202302 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 1973.86     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202302 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 697.16      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202302 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 606.52      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202303 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 434.32      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202303 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 1102.03     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202303 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 2189.32     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202303 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 2125.02     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202303 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 1519.00     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202303 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 2452.53     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202303 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 1649.28     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202304 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 2135.79     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202304 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 539.76      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202304 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 2456.09     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202304 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 466.07      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202304 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 1328.00     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202304 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 1860.30     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202304 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 2327.93     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202305 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 2475.31     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202305 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 1451.13     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202305 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 2463.51     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202305 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 2325.54     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202305 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 1785.71     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202305 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 1935.17     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202305 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 2090.62     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202306 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 731.52      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202306 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 530.74      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202306 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 1236.00     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202306 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 1305.21     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202306 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 1761.40     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202306 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 1945.15     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202306 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 805.73      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202307 | AEB-AS2223              | AEBA-025                 | ?          | 2               | 0            | 2182.30     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202307 | AEB-AS2223              | AEBA-025                 | ?          | 3               | 0            | 896.40      |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202307 | AEB-AS2223              | AEBA-025                 | ?          | 6               | 0            | 1866.45     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202307 | AEB-AS2223              | AEBA-025                 | ?          | 7               | 0            | 1187.92     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202307 | AEB-AS2223              | AEBA-025                 | ?          | 8               | 0            | 1122.35     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202307 | AEB-AS2223              | AEBA-025                 | ?          | 9               | 0            | 2241.28     |
    | ILR2223        | R12                  | ORG0017025     | CM             | 202307 | AEB-AS2223              | AEBA-025                 | ?          | 10              | 0            | 1761.62     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

  
    # Check CRM and PaaS

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-025     | AEBA-025           | 1               | 49972.00  | 35422.00 | 14550.00 | 5826.00  | 3820.00  | 4403.00  | 4388.00  | 5416.00  | 2333.00  | 5164.00  | 4072.00  | 2664.00  | 2205.00  | 7284.00  | 2397.00  | 
    | AEBP21-025     | AEBA-025           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 4               | 24453.00  | 17683.00 | 6770.00  | 2898.00  | 2211.00  | 1554.00  | 2542.00  | 3278.00  | 2053.00  | 2028.00  | 1119.00  | 146.00   | 2083.00  | 3674.00  | 867.00   | 
    | AEBP21-025     | AEBA-025           | 5               | 25519.00  | 17739.00 | 7780.00  | 2928.00  | 1609.00  | 2849.00  | 1846.00  | 2138.00  | 280.00   | 3136.00  | 2953.00  | 2518.00  | 122.00   | 3610.00  | 1530.00  | 
    | AEBP21-025     | AEBA-025           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
    | AEBP21-025     | AEBA-025           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 2               | 25207.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13445.38 | 0.00     | 0.00     | 0.00     | 11761.80 | 
    | AEBP21-025     | AEBA-025           | 3               | 15062.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8854.11  | 0.00     | 0.00     | 0.00     | 6208.12  | 
    | AEBP21-025     | AEBA-025           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-025     | AEBA-025           | 6               | 23902.89  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12075.60 | 0.00     | 0.00     | 0.00     | 11827.29 | 
    | AEBP21-025     | AEBA-025           | 7               | 21089.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12018.08 | 0.00     | 0.00     | 0.00     | 9071.86  | 
    | AEBP21-025     | AEBA-025           | 8               | 21410.59  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 11719.96 | 0.00     | 0.00     | 0.00     | 9690.63  | 
    | AEBP21-025     | AEBA-025           | 9               | 19523.72  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8776.26  | 0.00     | 0.00     | 0.00     | 10747.46 | 
    | AEBP21-025     | AEBA-025           | 10              | 24570.96  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13371.47 | 0.00     | 0.00     | 0.00     | 11199.49 | 
    
    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23    | Apr-23   | May-23   | Jun-23   | Jul-23     |
    | AEBP21-025     | AEBA-025           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00       | 
    | AEBP21-025     | AEBA-025           | 2               | -16020.39 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4,236.88 | 0.00     | 0.00     | 0.00     | -11,783.51 | 
    | AEBP21-025     | AEBA-025           | 3               | -9685.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2,790.09 | 0.00     | 0.00     | 0.00     | -6895.89   | 
    | AEBP21-025     | AEBA-025           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00       | 
    | AEBP21-025     | AEBA-025           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00       | 
    | AEBP21-025     | AEBA-025           | 6               | -15098.39 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -3,805.24 | 0.00     | 0.00     | 0.00     | -11,293.15 | 
    | AEBP21-025     | AEBA-025           | 7               | -13509.82 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -3,787.12 | 0.00     | 0.00     | 0.00     | -9,722.70  | 
    | AEBP21-025     | AEBA-025           | 8               | -13648.84 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -3,693.17 | 0.00     | 0.00     | 0.00     | -9,955.67  | 
    | AEBP21-025     | AEBA-025           | 9               | -12182.21 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2,765.56 | 0.00     | 0.00     | 0.00     | -9,416.65  | 
    | AEBP21-025     | AEBA-025           | 10              | -15652.68 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -4,213.59 | 0.00     | 0.00     | 0.00     | -11,439.09 | 
    
    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23    | Jul-23   |
    | AEBP21-025     | AEBA-025           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 
    | AEBP21-025     | AEBA-025           | 2               | 9186.79   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 9,208.50 | 0.00     | 0.00     | 0.00      | -21.71   | 
    | AEBP21-025     | AEBA-025           | 3               | 5376.25   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6,064.02 | 0.00     | 0.00     | 0.00      | -687.77  | 
    | AEBP21-025     | AEBA-025           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 
    | AEBP21-025     | AEBA-025           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 0.00     | 
    | AEBP21-025     | AEBA-025           | 6               | 8804.5    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8,270.36 | 0.00     | 0.00     | 0.00      | 534.14   | 
    | AEBP21-025     | AEBA-025           | 7               | 7580.12   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8,230.96 | 0.00     | 0.00     | 0.00      | -650.84  | 
    | AEBP21-025     | AEBA-025           | 8               | 7761.75   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8,026.79 | 0.00     | 0.00     | 0.00      | -265.04  | 
    | AEBP21-025     | AEBA-025           | 9               | 7341.51   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6,010.70 | 0.00     | 0.00     | 0.00      | 1,330.81 | 
    | AEBP21-025     | AEBA-025           | 10              | 8918.28   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 9,157.88 | 0.00     | 0.00     | 0.00      | -239.60  | 


    # Tidy Up
    Given the override date is reset

       