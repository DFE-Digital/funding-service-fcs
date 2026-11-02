Feature: BulkUploadValidationForUpdateDraftESF 7929AT

@AcceptanceTest @Withdrawn23052024
Scenario: A990 Create an ESF contract with two ESF allocations on one contract. Change deliverable descriptions. Approve. Change deliverable descriptions again
    Given there is no Contract, Task or Workflow data for UKPRN '10017990'
    And   the override date is reset

    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ESF-9901      |
    | ESF-9902      |

    # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017990'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017990 Co Ltd' with UKPRN '10017990' and OrgId 'ORG0017990' and has 'FCS1 Test' as a manager
    And   UPIN '117990' is associated with UKPRN '10017990' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017990 | 117990 | 10017990 Co Ltd | 0              | Active |

    # Create contract
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName          | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 10017990 | 10017990 Co Ltd    | ESFA-990             | ESIF-990       | 1                     |  12/04/2017       |  19/09/2017     | 268739.00     | Contract for Services | 1420   | New       | ORG0017990 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription      | CRMIntent | LEPName                                   | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference       | InvestmentPriority                                    | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType     | LearningRatePremium |
    | 10017990 | ESIF-990       | ESF-9901      | ESF 201420        | ESF                     | 12/04/2017          | 19/09/2017        | 115945.00       |         |         | Funding for the unemployed | New       | York, North Yorkshire and East Riding LEP | E37039  | TSS_20125                    | 00-1         | 20125/23-415-00-1/10017990 | 1.1 Access to employment for jobseekers/ the inactive | 222\SD\7990     | Job seekers fund    | SSR                | Less Developed | 1.12                |
    | 10017990 | ESIF-990       | ESF-9902      | ESF 201420        | ESF                     | 13/04/2017          | 19/09/2017        | 152794.00       |         |         | Funding for the unemployed | New       | London LEP                                | E37023  | TSS_20125                    | 00-1         | 20125/23-415-00-2/10017990 | 1.4 Active Inclusion                                  | 333\SD\7990     | Job seekers fund    | IAG                | Transition     | 1.13                |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | DeliverableName                                           | DeliverableDescription          | CRMIntent |
    | ESIF-990       | ESF-9901      | 10              | 0                     | 1221.00  | 3878.00  | 7435.00  | 28192.00 | 9087.00  | 8567.00  | SD03 Specification Defined Deliverable (with Description) | SD03 Promotional Event          | New       |
    | ESIF-990       | ESF-9901      | 11              | 0                     | 3045.00  | 4267.00  | 6361.00  | 37493.00 | 3984.00  | 2415.00  | SD04 Specification Defined Deliverable (with Description) | SD04 Equality and Individuality | New       |
    | ESIF-990       | ESF-9902      | 10              | 0                     | 3192.00  | 3112.00  | 5295.00  | 46294.00 | 4464.00  | 7534.00  | SD03 Specification Defined Deliverable (with Description) | SD03 Safety and Security        | New       |
    | ESIF-990       | ESF-9902      | 11              | 0                     | 8223.00  | 2667.00  | 5151.00  | 55595.00 | 3666.00  | 7601.00  | SD04 Specification Defined Deliverable (with Description) | SD04 NVQ2 Gaelic                | New       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Bulk file to UPDATE DRAFT the values and the Deliverable Descriptions
    And   spreadsheet 'ESF ESF 1420 13092017135447 v2_A990_1.xlsx' exists in the Datafiles folder and UKPRN '10017990' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    
    # Check contract has been updated correctly
    And   the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | 
    | 10017990 | ESFA-990             | ESIF-990       | 1                     |  12/04/2017       |  19/09/2017     | 131668.00     | Contract for Services | 1420   |
   
    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription             | LEPName                                   | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference       | InvestmentPriority                                    | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType     | LearningRatePremium |
    | 10017990 | ESIF-990       | ESF-9901      | ESF 201420        | ESF                     | 12/04/2017          | 19/09/2017        | 77528.00        |         |         | Skills Support for the Unemployed | York, North Yorkshire and East Riding LEP | E37039  | TSS_20125                    | 00-1         | 20125/23-415-00-1/10017990 | 1.1 Access to employment for jobseekers/ the inactive | 222\SD\7990     | Job Seekers Fund    | SSR                | Less Developed | 1.12                |
    | 10017990 | ESIF-990       | ESF-9902      | ESF 201420        | ESF                     | 13/04/2017          | 19/09/2017        | 54140.00        |         |         | Skills Support for the Unemployed | London LEP                                | E37023  | TSS_20125                    | 00-1         | 20125/23-415-00-2/10017990 | 1.4 Active Inclusion                                  | 333\SD\7991     | Job Seekers Fund    | IAG                | Transition     | 1.13                |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Total    | Apr-17   | May-17  | Jun-17  | Jul-17   | Aug-17   | Sep-17   | DeliverableName                                           | DeliverableDescription      |
    | ESIF-990       | ESF-9901      | 10              | 51612.00 | 12696.00 | 5520.00 | 6486.00 | 14628.00 | 5244.00  | 7038.00  | SD03 Specification Defined Deliverable (with Description) | SD03 Promotional Event      |
    | ESIF-990       | ESF-9901      | 11              | 25916.00 | 8122.00  | 2046.00 | 6634.00 | 2046.00  | 4092.00  | 2976.00  | SD04 Specification Defined Deliverable (with Description) | SD04 Equality and Diversity |
    | ESIF-990       | ESF-9902      | 10              | 49793.00 | 1717.00  | 8080.00 | 101.00  | 12928.00 | 11817.00 | 15150.00 | SD03 Specification Defined Deliverable (with Description) | SD03 Non-promotional Event  |
    | ESIF-990       | ESF-9902      | 11              | 4347.00  | 210.00   | 1050.00 | 637.00  | 819.00   | 833.00   | 798.00   | SD04 Specification Defined Deliverable (with Description) | SD04 NVQ2 Welsh             |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'ESIF-990' is in a state of 'Published to Provider'

    # Inject an SFS contract approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-990' and actual ContractNumber 'ESIF-990'
    Then  the status and sub-status of the latest version of contract 'ESIF-990' are changed to 'Approved'
    And   the latest version of contract 'ESIF-990' is marked as the last approved version

    # Bulk file to AMEND the contract changing the Deliverable Descriptions again
    Given spreadsheet 'ESF ESF 1420 13092017135447 v2_A990_2.xlsx' exists in the Datafiles folder and UKPRN '10017990' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    
    # Check contract has been updated correctly
    And   the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | 
    | 10017990 | ESFA-990             | ESIF-990       | 2                     |  12/04/2017       |  19/09/2017     | 131668.00     | Contract for Services | 1420   |
   
    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription             | LEPName                                   | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference       | InvestmentPriority                                    | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType     | LearningRatePremium |
    | 10017990 | ESIF-990       | ESF-9901      | ESF 201420        | ESF                     | 12/04/2017          | 19/09/2017        | 77528.00        |         |         | Skills Support for the Unemployed | York, North Yorkshire and East Riding LEP | E37039  | TSS_20125                    | 00-1         | 20125/23-415-00-1/10017990 | 1.1 Access to employment for jobseekers/ the inactive | 222\SD\7990     | Job Seekers Fund    | SSR                | Less Developed | 1.12                |
    | 10017990 | ESIF-990       | ESF-9902      | ESF 201420        | ESF                     | 13/04/2017          | 19/09/2017        | 54140.00        |         |         | Skills Support for the Unemployed | London LEP                                | E37023  | TSS_20125                    | 00-1         | 20125/23-415-00-2/10017990 | 1.4 Active Inclusion                                  | 333\SD\7991     | Job Seekers Fund    | IAG                | Transition     | 1.13                |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Total    | Apr-17   | May-17  | Jun-17  | Jul-17   | Aug-17   | Sep-17   | DeliverableName                                           | DeliverableDescription          |
    | ESIF-990       | ESF-9901      | 10              | 51612.00 | 12696.00 | 5520.00 | 6486.00 | 14628.00 | 5244.00  | 7038.00  | SD03 Specification Defined Deliverable (with Description) | SD03 Promotional Event          |
    | ESIF-990       | ESF-9901      | 11              | 25916.00 | 8122.00  | 2046.00 | 6634.00 | 2046.00  | 4092.00  | 2976.00  | SD04 Specification Defined Deliverable (with Description) | SD04 Equality and Individuality |
    | ESIF-990       | ESF-9902      | 10              | 49793.00 | 1717.00  | 8080.00 | 101.00  | 12928.00 | 11817.00 | 15150.00 | SD03 Specification Defined Deliverable (with Description) | SD03 Safety and Security        |
    | ESIF-990       | ESF-9902      | 11              | 4347.00  | 210.00   | 1050.00 | 637.00  | 819.00   | 833.00   | 798.00   | SD04 Specification Defined Deliverable (with Description) | SD04 NVQ2 Gaelic                |

    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20240103
@Long2Run @Long2Run890
Scenario: A893 Create an ESF contract. Bulk UPDATE DRAFT with minimum fields. Check CRM. Approve. Bulk AMEND with minimum fields. Check CRM. Bulk UPDATE DRAFT AMENDMENT with minimum fields. Check CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017893' 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ESF-893       |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017893' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017893 Co Ltd' with UKPRN '10017893' and OrgId 'ORG0017893' and has 'FCS1 Test' as a manager 
    And   UPIN '117893' is associated with UKPRN '10017893' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017893 | 117893 | 10017893 Co Ltd | 0              | Active | Yes           | AA017893      | ?             | 

    # Change the date
    And   the override date is '01/08/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017893 | 10017893 Co Ltd      | ESFA-893             | ESIF-893       | 1                     | 01/08/2017        | 31/07/2018      | 129546.00     | ESF Contract                   | Contract for Services | 1420   | New          | ORG0017893 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                                    | AgreementNumber | ActivityDescription | SpecificationTitle            | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017893 | ESIF-893       | ESF-893       | ESF 201420        | ESF1420                 | ESF                     | 01/08/2017          | 31/07/2018        | 129546.00       |                                         |            | Skills Support for the Unemployed                           | New          | Liverpool City Region LEP                   | E37022       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017893    | 1.1 Access to employment for jobseekers/ the inactive | 555\SD\7893     | Job Seekers Fund    | SSW Retraining for Employment | More Developed | 1.15                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017893 | ESIF-893       | ESF-893       | 1               | 0                     | 78545.00  | 1150.00  | 9660.00  | 7820.00  | 10580.00 | 2185.00  | 9200.00  | 9085.00  | 6555.00  | 3795.00  | 9315.00  | 3335.00  | 5865.00  | ST01 Learner Assessment and Plan                                | New          |             |
    | 10017893 | ESIF-893       | ESF-893       | 2               | 0                     | 18025.00  | 1504.00  | 1890.00  | 2468.00  | 1717.00  | 269.00   | 911.00   | 951.00   | 832.00   | 1188.00  | 2838.00  | 3322.00  | 135.00   | RQ01 Regulated Learning                                         | New          |             |
    | 10017893 | ESIF-893       | ESF-893       | 8               | 0                     | 32976.00  | 4080.00  | 2928.00  | 3264.00  | 1056.00  | 3264.00  | 4224.00  | 3696.00  | 864.00   | 624.00   | 2544.00  | 4368.00  | 2064.00  | SD05 Specification Defined Deliverable (with Description)       | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | 
    | 10017893 | ESIF-893       | ESF-893       | 1               | 115      | 683     | 10       | 84       | 68       | 92       | 19       | 80       | 79       | 57       | 33       | 81       | 29       | 51       |
    | 10017893 | ESIF-893       | ESF-893       | 8               | 48       | 687     | 85       | 61       | 68       | 22       | 68       | 88       | 77       | 18       | 13       | 53       | 91       | 43       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '04/08/2017'

    # Bulk import for an UPDATE DRAFT (_4 = full fat, _5 = skinny, results should be the same)
    And   there are no files prefixed '10017893_ESIF' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 30082018141724 v2_A893' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 30082018141724 v2_A893' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 30082018141724 v2_A893_5.xlsx' exists in the Datafiles folder and UKPRN '10017893' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the contract details in CRM 
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | OrgId      |
    | 10017893 | 10017893 Co Ltd      | ESFA-893             | ESIF-893       | 1                     | 01/08/2017        | 31/07/2018      | 158970.00     | ESF Contract                   | Contract for Services | 1420   | ORG0017893 |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                   | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                                    | AgreementNumber | ActivityDescription | SpecificationTitle            | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017893 | ESIF-893       | ESF-893       | ESF 201420        | ESF1420                 | ESF                     | 01/08/2017          | 31/07/2018        | 158970.00       |                                         |            | Skills Support for the Unemployed       | Liverpool City Region LEP                   | E37022       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017893    | 1.1 Access to employment for jobseekers/ the inactive | 555\SD\7893     | Job Seekers Fund    | SSW Retraining for Employment | More Developed | 1.15                |             |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableName                                             | DeliverableDescription                      | DeliveryOrg  | 
    | 10017893 | ESIF-893       | ESF-893       | 1               | 0                     | 104676.00 | 11468.00 | 8296.00  | 13176.00 | 16836.00 | 10736.00 | 10614.00 | 6100.00  | 1342.00  | 10858.00 | 488.00   | 4880.00  | 9882.00  | ST01 Learner Assessment and Plan                            |                                             |              |
    | 10017893 | ESIF-893       | ESF-893       | 2               | 0                     | 13974.00  | 629.00   | 833.00   | 2108.00  | 1530.00  | 1394.00  | 1105.00  | 2006.00  | 1853.00  | 425.00   | 1496.00  | 153.00   | 442.00   | RQ01 Regulated Learning                                     |                                             |              |
    | 10017893 | ESIF-893       | ESF-893       | 8               | 0                     | 40320.00  | 2736.00  | 4800.00  | 576.00   | 768.00   | 2064.00  | 3456.00  | 2736.00  | 6816.00  | 3696.00  | 6288.00  | 1872.00  | 4512.00  | SD01 Specification Defined Deliverable (with Description)   | SD01 NVQ1 English Language                  |              |

    And   the draft contract deliverable volume details for the latest version of the contract have been updated as follows 
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | 
    | 10017893 | ESIF-893       | ESF-893       | 1               | 122      | 858       | 94       | 68       | 108      | 138      | 88       | 87       | 50       | 11       | 89       | 4        | 40       | 81       | 
    | 10017893 | ESIF-893       | ESF-893       | 8               | 48       | 840       | 57       | 100      | 12       | 16       | 43       | 72       | 57       | 142      | 77       | 131      | 39       | 94       | 


    # Change the date
    Given the override date is '02/08/2017'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'ESIF-893' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '03/08/2017'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-893' and actual ContractNumber 'ESIF-893'

    # Check that the contract is now approved
    Then  the latest version of contract 'ESIF-893' is in status 'Approved'

    # Check the deliverable count in CRM includes all the monitoring deliverables (36 which should be there plus 3 for the extra 'blank' deliverable periods. This is a known bug - but now resolved )
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'ESIF-893'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017893 | ESIF-893           | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017893 | ESIF-893           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017893 | ESFA-893           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |


    # Change the date
    Given the override date is '04/08/2017'

    # Bulk import to AMEND the contract (_1 = full fat, _2 = skinny)
    And   there are no files prefixed '10017893_ESIF' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 29082018131832 v2_A893' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 29082018131832 v2_A893' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 29082018131832 v2_A893_2.xlsx' exists in the Datafiles folder and UKPRN '10017893' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the contract details in CRM 
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | OrgId      |
    | 10017893 | 10017893 Co Ltd      | ESFA-893             | ESIF-893       | 2                     | 01/08/2017        | 31/07/2018      | 196884.00     | ESF Contract                   | Contract for Services | 1420   | ORG0017893 |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                   | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                                    | AgreementNumber | ActivityDescription | SpecificationTitle            | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017893 | ESIF-893       | ESF-893       | ESF 201420        | ESF1420                 | ESF                     | 01/08/2017          | 31/07/2018        | 196884.00       |                                         |            | Skills Support for the Unemployed       | Liverpool City Region LEP                   | E37022       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017893    | 1.1 Access to employment for jobseekers/ the inactive | 555\SD\7893     | Job Seekers Fund    | SSW Retraining for Employment | More Developed | 1.15                |             |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | UKPRN    | ContractNumber | AllocationRef   | DeliverableCode | ParentDeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableName                                             | DeliverableDescription                                      | DeliveryOrg  | 
    | 10017893 | ESIF-893       | ESF-893         | 1               | 0                     | 86526.00 | 7029.00  | 4356.00  | 8316.00  | 11286.00 | 6336.00  | 6237.00  | 2673.00  | 13563.00 | 6534.00  | 12870.00 | 1584.00  | 5742.00  | ST01 Learner Assessment and Plan                            |                                                             |              | 
    | 10017893 | ESIF-893       | ESF-893         | 2               | 0                     | 11679.00 | 238.00   | 442.00   | 1700.00  | 1122.00  | 1003.00  | 697.00   | 1598.00  | 1445.00  | 17.00    | 1088.00  | 2295.00  | 34.00    | RQ01 Regulated Learning                                     |                                                             |              | 
    | 10017893 | ESIF-893       | ESF-893         | 8               | 0                     | 98679.00 | 8214.00  | 3885.00  | 12543.00 | 3108.00  | 2664.00  | 11655.00 | 5772.00  | 11322.00 | 6771.00  | 8103.00  | 16428.00 | 8214.00  | SD01 Specification Defined Deliverable (with Description)   | SD01 NVQ1 English Language                                  |              | 

    And   the draft contract deliverable volume details for the latest version of the contract have been updated as follows 
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | 10017893 | ESIF-893       | ESF-893       | 1               | 99       | 874      | 71       | 44       | 84       | 114      | 64       | 63       | 27       | 137      | 66       | 130      | 16       | 58       | 
    | 10017893 | ESIF-893       | ESF-893       | 8               | 111      | 889      | 74       | 35       | 113      | 28       | 24       | 105      | 52       | 102      | 61       | 73       | 148      | 74       | 


    # Change the date
    Given the override date is '04/08/2017'

    # Bulk import to do an UPDATE DRAFT AMENDMENT (_7 = full fat, _8 = skinny)
    And   there are no files prefixed '10017893_ESIF' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 30082018164624 v2_A893' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 30082018164624 v2_A893' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 30082018164624 v2_A893_8.xlsx' exists in the Datafiles folder and UKPRN '10017893' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the contract details in CRM 
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | OrgId      |
    | 10017893 | 10017893 Co Ltd      | ESFA-893             | ESIF-893       | 2                     | 01/08/2017        | 31/07/2018      | 204559.00     | ESF Contract                   | Contract for Services | 1420   | ORG0017893 |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                   | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                                    | AgreementNumber | ActivityDescription | SpecificationTitle            | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017893 | ESIF-893       | ESF-893       | ESF 201420        | ESF1420                 | ESF                     | 01/08/2017          | 31/07/2018        | 204559.00       |                                         |            | Skills Support for the Unemployed       | Liverpool City Region LEP                   | E37022       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017893    | 1.1 Access to employment for jobseekers/ the inactive | 555\SD\7893     | Job Seekers Fund    | SSW Retraining for Employment | More Developed | 1.15                |             |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | UKPRN    | ContractNumber | AllocationRef  | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableName                                             | DeliverableDescription                                      | DeliveryOrg  | 
    | 10017893 | ESIF-893       | ESF-893        | 1               | 0                     | 133440.00 | 14520.00 | 13920.00 | 15720.00 | 10560.00 | 8040.00  | 10560.00 | 3120.00  | 7560.00  | 7320.00  | 12840.00 | 14160.00 | 15120.00 | ST01 Learner Assessment and Plan                            |                                                             |              |
    | 10017893 | ESIF-893       | ESF-893        | 2               | 0                     | 15946.00  | 1156.00  | 782.00   | 17.00    | 1666.00  | 1785.00  | 238.00   | 1649.00  | 1870.00  | 2550.00  | 510.00   | 1530.00  | 2193.00  | RQ01 Regulated Learning                                     |                                                             |              |
    | 10017893 | ESIF-893       | ESF-893        | 8               | 0                     | 55173.00  | 6943.00  | 2438.00  | 2226.00  | 6519.00  | 3710.00  | 6360.00  | 4187.00  | 4823.00  | 848.00   | 4876.00  | 6572.00  | 5671.00  | SD01 Specification Defined Deliverable (with Description)   | SD01 NVQ1 English Language                                  |              |

    And   the draft contract deliverable volume details for the latest version of the contract have been updated as follows 
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | 
    | 10017893 | ESIF-893       | ESF-893       | 1               | 120      | 1112      | 121      | 116      | 131      | 88       | 67       | 88       | 26       | 63       | 61       | 107      | 118      | 126      |
    | 10017893 | ESIF-893       | ESF-893       | 8               | 53       | 1041      | 131      | 46       | 42       | 123      | 70       | 120      | 79       | 91       | 16       | 92       | 124      | 107      | 

    # Publish the contract
    And   the latest version of contract 'ESIF-893' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-893' and actual ContractNumber 'ESIF-893'

    # Check the deliverable count in CRM includes all the monitoring deliverables (36 which should be there plus 6 for the extra 'blank' deliverable periods. This is a known bug - but now resolved)
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract 'ESIF-893'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017893 | ESIF-893           | 2                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017893 | ESIF-893           | 2                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017893 | ESIF-893           | 1                     | 1                        | Replaced         | Approved                  | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017893 | ESIF-893           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017893 | ESFA-893           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |




    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber    | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | ESF-893             | 1             | 1               | 201708 | 2              | 94            | 11468.00     | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 1               | 201709 | 2              | 68            | 8296.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 1               | 201710 | 2              | 108           | 13176.00     | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 1               | 201711 | 2              | 138           | 16836.00     | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 1               | 201712 | 2              | 88            | 10736.00     | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 1               | 201801 | 2              | 87            | 10614.00     | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 1               | 201802 | 2              | 50            | 6100.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 1               | 201803 | 2              | 11            | 1342.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 1               | 201804 | 2              | 89            | 10858.00     | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 1               | 201805 | 2              | 4             | 488.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 1               | 201806 | 2              | 40            | 4880.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 1               | 201807 | 2              | 81            | 9882.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 2               | 201708 | 2              | 0             | 629.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 2               | 201709 | 2              | 0             | 833.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 2               | 201710 | 2              | 0             | 2108.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 2               | 201711 | 2              | 0             | 1530.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 2               | 201712 | 2              | 0             | 1394.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 2               | 201801 | 2              | 0             | 1105.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 2               | 201802 | 2              | 0             | 2006.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 2               | 201803 | 2              | 0             | 1853.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 2               | 201804 | 2              | 0             | 425.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 2               | 201805 | 2              | 0             | 1496.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 2               | 201806 | 2              | 0             | 153.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 2               | 201807 | 2              | 0             | 442.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 8               | 201708 | 2              | 57            | 2736.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 8               | 201709 | 2              | 100           | 4800.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 8               | 201710 | 2              | 12            | 576.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 8               | 201711 | 2              | 16            | 768.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 8               | 201712 | 2              | 43            | 2064.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 8               | 201801 | 2              | 72            | 3456.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 8               | 201802 | 2              | 57            | 2736.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 8               | 201803 | 2              | 142           | 6816.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 8               | 201804 | 2              | 77            | 3696.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 8               | 201805 | 2              | 131           | 6288.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 8               | 201806 | 2              | 39            | 1872.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 1             | 8               | 201807 | 2              | 94            | 4512.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | ESF-893             | 2             | 1               | 201708 | 2              | 121           | 14520.00     | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 1               | 201709 | 2              | 116           | 13920.00     | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 1               | 201710 | 2              | 131           | 15720.00     | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 1               | 201711 | 2              | 88            | 10560.00     | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 1               | 201712 | 2              | 67            | 8040.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 1               | 201801 | 2              | 88            | 10560.00     | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 1               | 201802 | 2              | 26            | 3120.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 1               | 201803 | 2              | 63            | 7560.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 1               | 201804 | 2              | 61            | 7320.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 1               | 201805 | 2              | 107           | 12840.00     | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 1               | 201806 | 2              | 118           | 14160.00     | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 1               | 201807 | 2              | 126           | 15120.00     | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 2               | 201708 | 2              | 0             | 1156.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 2               | 201709 | 2              | 0             | 782.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 2               | 201710 | 2              | 0             | 17.00        | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 2               | 201711 | 2              | 0             | 1666.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 2               | 201712 | 2              | 0             | 1785.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 2               | 201801 | 2              | 0             | 238.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 2               | 201802 | 2              | 0             | 1649.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 2               | 201803 | 2              | 0             | 1870.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 2               | 201804 | 2              | 0             | 2550.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 2               | 201805 | 2              | 0             | 510.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 2               | 201806 | 2              | 0             | 1530.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 2               | 201807 | 2              | 0             | 2193.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 8               | 201708 | 2              | 131           | 6943.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 8               | 201709 | 2              | 46            | 2438.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 8               | 201710 | 2              | 42            | 2226.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 8               | 201711 | 2              | 123           | 6519.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 8               | 201712 | 2              | 70            | 3710.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 8               | 201801 | 2              | 120           | 6360.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 8               | 201802 | 2              | 79            | 4187.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 8               | 201803 | 2              | 91            | 4823.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 8               | 201804 | 2              | 16            | 848.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 8               | 201805 | 2              | 92            | 4876.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 8               | 201806 | 2              | 124           | 6572.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | ESF-893             | 2             | 8               | 201807 | 2              | 107           | 5671.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |



    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run890
Scenario: A894 Create a procured 1819 AEB contract. Bulk UPDATE DRAFT with minimum fields. Check CRM. Approve. Bulk AMEND with minimum fields. Check CRM. Bulk UPDATE DRAFT AMENDMENT with minimum fields. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017894' 
    And   there are no terminated or closed allocations for UKPRN '10017894' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017894' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEBC-894      |
    | AEBL-894      |
    | AEBT-894      |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017894' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017894 Co Ltd' with UKPRN '10017894' and OrgId 'ORG0017894' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017894' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017894 | 117894 | 10017894 Co Ltd | 0              | Active                | Yes           | AA017894      | ?             | 4 Red Lion Court       | Alexandra Road         | ?                      | ?                      | Hounslow               | Middlesex              | TW3 1JS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017894 |


	
    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017894 | 10017894 Co Ltd      | ESFA-894             | AEBP-894       | 1                     | 01/08/2018        | 31/07/2019      | 60052.00      | Procured AEB Contract          | Contract for Services | 1819   | New          | ORG0017894 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName    | UoPCode    | AllocationDescription  | CRMIntent    | DeliveryOrg |
    | 10017894 | AEBP-894       | AEBC-894      | AEB-CL            | AEB-CL1819              | AY                      | 01/08/2018          | 31/07/2019        | 21710.00        |            |            | CL1                    | New          |             |
    | 10017894 | AEBP-894       | AEBL-894      | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 19035.00        |            |            | LS1                    | New          |             |
    | 10017894 | AEBP-894       | AEBT-894      | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 19307.00        |            |            | TOL1                   | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017894 | AEBP-894       | AEBC-894      | 1               | 0                     | 21710.00  | 3706.00  | 993.00   | 1729.00  | 504.00   | 479.00   | 3271.00  | 2298.00  | 534.00   | 2124.00  | 3019.00  | 336.00   | 2717.00  | Adult Education Budget - Community Learning                     | New          |             |
    | 10017894 | AEBP-894       | AEBL-894      | 1               | 0                     | 19035.00  | 1410.00  | 407.00   | 699.00   | 2542.00  | 1696.00  | 1514.00  | 1079.00  | 2383.00  | 2171.00  | 91.00    | 1647.00  | 3396.00  | Adult Education Budget - Learner Support                        | New          |             |
    | 10017894 | AEBP-894       | AEBT-894      | 1               | 0                     | 19307.00  | 1268.00  | 992.00   | 1822.00  | 2049.00  | 3102.00  | 927.00   | 1031.00  | 1703.00  | 2405.00  | 2034.00  | 429.00   | 1545.00  | Adult Education - Traineeships and Other Learning Total Funding | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017894 | AEBP-894           | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017894 | ESFA-894           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'AEBP-894'

    # Check the contract details in CRM
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | OrgId      |
    | 10017894 | 10017894 Co Ltd      | ESFA-894             | AEBP-894       | 1                     | 01/08/2018        | 31/07/2019      | 60052.00      | Procured AEB Contract          | Contract for Services | 1819   | ORG0017894 |

     And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                          | AgreementNumber | ActivityDescription | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017894 | AEBP-894       | AEBC-894      | AEB-CL            | AEB-CL1819              | AY                      | 01/08/2018          | 31/07/2019        | 21710.00        |                                         |            | CL1                                                         |                                             |              |              |                               |                               |                                             |                 |                     |                       |                |                     |             |
    | 10017894 | AEBP-894       | AEBL-894      | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 19035.00        |                                         |            | LS1                                                         |                                             |              |              |                               |                               |                                             |                 |                     |                       |                |                     |             |
    | 10017894 | AEBP-894       | AEBT-894      | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 19307.00        |                                         |            | TOL1                                                        |                                             |              |              |                               |                               |                                             |                 |                     |                       |                |                     |             |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableName                                                  | DeliverableDescription  | DeliveryOrg |
    | 10017894 | AEBP-894       | AEBC-894      | 1               | 0                     | 21710.00  | 3706.00  | 993.00   | 1729.00  | 504.00   | 479.00   | 3271.00  | 2298.00  | 534.00   | 2124.00  | 3019.00  | 336.00   | 2717.00  | Adult Education Budget - Community Learning                      |                         |             |
    | 10017894 | AEBP-894       | AEBL-894      | 1               | 0                     | 19035.00  | 1410.00  | 407.00   | 699.00   | 2542.00  | 1696.00  | 1514.00  | 1079.00  | 2383.00  | 2171.00  | 91.00    | 1647.00  | 3396.00  | Adult Education Budget - Learner Support                         |                         |             |
    | 10017894 | AEBP-894       | AEBT-894      | 1               | 0                     | 19307.00  | 1268.00  | 992.00   | 1822.00  | 2049.00  | 3102.00  | 927.00   | 1031.00  | 1703.00  | 2405.00  | 2034.00  | 429.00   | 1545.00  | Adult Education - Traineeships and Other Learning Total Funding  |                         |             |


    # Change the date
    Given the override date is '02/07/2018'

    # Bulk import for an UPDATE DRAFT (_1 = full fat, _2 = skinny)
    And   there are no files prefixed '10017894_AEB' in the Sharepoint 'AEB-1819-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1819 30082018092248 v3_A894' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1819 30082018092248 v3_A894' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1819 30082018092248 v3_A894_2.xlsx' exists in the Datafiles folder and UKPRN '10017894' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the contract details in CRM
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | OrgId      |
    | 10017894 | 10017894 Co Ltd      | ESFA-894             | AEBP-894       | 1                     | 01/08/2018        | 31/07/2019      | 82023.00      | Procured AEB Contract          | Contract for Services | 1819   | ORG0017894 |

     And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                          | AgreementNumber | ActivityDescription | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017894 | AEBP-894       | AEBC-894      | AEB-CL            | AEB-CL1819              | AY                      | 01/08/2018          | 31/07/2019        | 23468.00        |                                         |            | CL1                                                         |                                             |              |              |                               |                               |                                             |                 |                     |                       |                |                     |             |
    | 10017894 | AEBP-894       | AEBL-894      | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 28270.00        |                                         |            | LS1                                                         |                                             |              |              |                               |                               |                                             |                 |                     |                       |                |                     |             |
    | 10017894 | AEBP-894       | AEBT-894      | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 30285.00        |                                         |            | TOL1                                                        |                                             |              |              |                               |                               |                                             |                 |                     |                       |                |                     |             |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | UKPRN    | ContractNumber | AllocationRef   | DeliverableCode | ParentDeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableName                                                 | DeliverableDescription                                      | DeliveryOrg | 
    | 10017894 | AEBP-894       | AEBC-894        | 1               | 0                     | 23468.00 | 1455.00  | 1045.00  | 4906.00  | 1911.00  | 992.00   | 113.00   | 1435.00  | 2420.00  | 781.00   | 748.00   | 4482.00  | 3180.00  | Adult Education Budget - Community Learning                     |                                                             |             |
    | 10017894 | AEBP-894       | AEBL-894        | 1               | 0                     | 28270.00 | 1129.00  | 3257.00  | 4454.00  | 865.00   | 4051.00  | 759.00   | 4368.00  | 4758.00  | 2273.00  | 1142.00  | 898.00   | 316.00   | Adult Education Budget - Learner Support                        |                                                             |             | 
    | 10017894 | AEBP-894       | AEBT-894        | 1               | 0                     | 30285.00 | 1557.00  | 1273.00  | 3441.00  | 4209.00  | 1597.00  | 2159.00  | 1789.00  | 2899.00  | 3204.00  | 4612.00  | 1703.00  | 1842.00  | Adult Education - Traineeships and Other Learning Total Funding |                                                             |             |



	# Change the date
    Given the override date is '04/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-894' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '05/07/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-894' and actual ContractNumber 'AEBP-894'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-894' is in status 'Approved'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'AEBP-894'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017894 | AEBP-894           | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017894 | AEBP-894           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017894 | ESFA-894           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |


	# Change the date
    Given the override date is '06/07/2018'

	# Bulk import to AMEND the contract (_3 = full fat, _4 = skinny)
    And   there are no files prefixed '10017894_AEB' in the Sharepoint 'AEB-1819-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1819 30082018113311 v3_A894' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1819 30082018113311 v3_A894' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1819 30082018113311 v3_A894_4.xlsx' exists in the Datafiles folder and UKPRN '10017894' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
	 
    # Check the contract details in CRM
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | OrgId      |
    | 10017894 | 10017894 Co Ltd      | ESFA-894             | AEBP-894       | 2                     | 01/08/2018        | 31/07/2019      | 82812.00      | Procured AEB Contract          | Contract for Services | 1819   | ORG0017894 |

     And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                          | AgreementNumber | ActivityDescription | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017894 | AEBP-894       | AEBC-894      | AEB-CL            | AEB-CL1819              | AY                      | 01/08/2018          | 31/07/2019        | 23318.00        |                                         |            | CL1                                                         |                                             |              |              |                               |                               |                                             |                 |                     |                       |                |                     |             |
    | 10017894 | AEBP-894       | AEBL-894      | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 28364.00        |                                         |            | LS1                                                         |                                             |              |              |                               |                               |                                             |                 |                     |                       |                |                     |             |
    | 10017894 | AEBP-894       | AEBT-894      | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 31130.00        |                                         |            | TOL1                                                        |                                             |              |              |                               |                               |                                             |                 |                     |                       |                |                     |             |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef   | DeliverableCode | ParentDeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableName                                                  | DeliverableDescription                                      | DeliveryOrg | 
    | 10017894 | AEBP-894       | AEBC-894        | 1               | 0                     | 23318.00 | 1327.00  | 986.00   | 4866.00  | 1714.00  | 1150.00  | 255.00   | 1328.00  | 2558.00  | 805.00   | 686.00   | 4399.00  | 3244.00  | Adult Education Budget - Community Learning                      |                                                             |             |
    | 10017894 | AEBP-894       | AEBL-894        | 1               | 0                     | 28364.00 | 1197.00  | 3428.00  | 4353.00  | 809.00   | 4150.00  | 837.00   | 4394.00  | 4825.00  | 2360.00  | 962.00   | 744.00   | 305.00   | Adult Education Budget - Learner Support                         |                                                             |             |
    | 10017894 | AEBP-894       | AEBT-894        | 1               | 0                     | 31130.00 | 1590.00  | 1362.00  | 3479.00  | 4355.00  | 1751.00  | 2131.00  | 1961.00  | 2743.00  | 3329.00  | 4651.00  | 1853.00  | 1925.00  | Adult Education - Traineeships and Other Learning Total Funding  |                                                             |             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'AEBP-894'



	# Change the date
    Given the override date is '08/07/2018'

	# Bulk import to do an UPDATE DRAFT AMENDMENT (_5 = full fat, _6 = skinny)
    And   there are no files prefixed '10017894_AEB' in the Sharepoint 'AEB-1819-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1819 30082018220036 v3_A894' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1819 30082018220036 v3_A894' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1819 30082018220036 v3_A894_6.xlsx' exists in the Datafiles folder and UKPRN '10017894' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
	 
    # Check the contract details in CRM
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | OrgId      |
    | 10017894 | 10017894 Co Ltd      | ESFA-894             | AEBP-894       | 2                     | 01/08/2018        | 31/07/2019      | 84395.00      | Procured AEB Contract          | Contract for Services | 1819   | ORG0017894 |

     And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                          | AgreementNumber | ActivityDescription | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017894 | AEBP-894       | AEBC-894      | AEB-CL            | AEB-CL1819              | AY                      | 01/08/2018          | 31/07/2019        | 23305.00        |                                         |            | CL1                                                         |                                             |              |              |                               |                               |                                             |                 |                     |                       |                |                     |             |
    | 10017894 | AEBP-894       | AEBL-894      | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 29932.00        |                                         |            | LS1                                                         |                                             |              |              |                               |                               |                                             |                 |                     |                       |                |                     |             |
    | 10017894 | AEBP-894       | AEBT-894      | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 31158.00        |                                         |            | TOL1                                                        |                                             |              |              |                               |                               |                                             |                 |                     |                       |                |                     |             |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef   | DeliverableCode | ParentDeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableName                                                  | DeliverableDescription                                      | DeliveryOrg | 
    | 10017894 | AEBP-894       | AEBC-894        | 1               | 0                     | 23305.00 | 1500.00  | 1048.00  | 5009.00  | 1665.00  | 963.00   | 118.00   | 1235.00  | 2468.00  | 847.00   | 635.00   | 4427.00  | 3390.00  | Adult Education Budget - Community Learning                      |                                                             |             |
    | 10017894 | AEBP-894       | AEBL-894        | 1               | 0                     | 29932.00 | 1262.00  | 3446.00  | 4527.00  | 729.00   | 4187.00  | 691.00   | 4574.00  | 4730.00  | 2453.00  | 826.00   | 918.00   | 1589.00  | Adult Education Budget - Learner Support                         |                                                             |             |
    | 10017894 | AEBP-894       | AEBT-894        | 1               | 0                     | 31158.00 | 1676.00  | 1416.00  | 3644.00  | 4370.00  | 1766.00  | 2161.00  | 2156.00  | 2885.00  | 3155.00  | 4488.00  | 1693.00  | 1748.00  | Adult Education - Traineeships and Other Learning Total Funding  |                                                             |             |

    # Publish the contract
    And   the latest version of contract 'AEBP-894' is in a state of 'Published to Provider'

	# Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-894' and actual ContractNumber 'AEBP-894'

	# Check the deliverable count in CRM includes all the monitoring deliverables
    Then  there are '96' deliverable period rows in CRM linked to the latest version of contract 'AEBP-894'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017894 | AEBP-894           | 2                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017894 | AEBP-894           | 2                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017894 | AEBP-894           | 1                     | 1                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017894 | AEBP-894           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017894 | ESFA-894           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | AEBC-894         | 1             | 1               | 201808 | 2              | 0             | 1455.00      | 1455.00              | 0.00                | 0.00                   | 0.00                        | 1455.00          | ?            | ?           |
    | AEBC-894         | 1             | 1               | 201809 | 2              | 0             | 1045.00      | 1045.00              | 0.00                | 0.00                   | 0.00                        | 1045.00          | ?            | ?           |
    | AEBC-894         | 1             | 1               | 201810 | 2              | 0             | 4906.00      | 4906.00              | 0.00                | 0.00                   | 0.00                        | 4906.00          | ?            | ?           |
    | AEBC-894         | 1             | 1               | 201811 | 2              | 0             | 1911.00      | 1911.00              | 0.00                | 0.00                   | 0.00                        | 1911.00          | ?            | ?           |
    | AEBC-894         | 1             | 1               | 201812 | 2              | 0             | 992.00       | 992.00               | 0.00                | 0.00                   | 0.00                        | 992.00           | ?            | ?           |
    | AEBC-894         | 1             | 1               | 201901 | 2              | 0             | 113.00       | 113.00               | 0.00                | 0.00                   | 0.00                        | 113.00           | ?            | ?           |
    | AEBC-894         | 1             | 1               | 201902 | 2              | 0             | 1435.00      | 1435.00              | 0.00                | 0.00                   | 0.00                        | 1435.00          | ?            | ?           |
    | AEBC-894         | 1             | 1               | 201903 | 2              | 0             | 2420.00      | 2420.00              | 0.00                | 0.00                   | 0.00                        | 2420.00          | ?            | ?           |
    | AEBC-894         | 1             | 1               | 201904 | 2              | 0             | 781.00       | 781.00               | 0.00                | 0.00                   | 0.00                        | 781.00           | ?            | ?           |
    | AEBC-894         | 1             | 1               | 201905 | 2              | 0             | 748.00       | 748.00               | 0.00                | 0.00                   | 0.00                        | 748.00           | ?            | ?           |
    | AEBC-894         | 1             | 1               | 201906 | 2              | 0             | 4482.00      | 4482.00              | 0.00                | 0.00                   | 0.00                        | 4482.00          | ?            | ?           |
    | AEBC-894         | 1             | 1               | 201907 | 2              | 0             | 3180.00      | 3180.00              | 0.00                | 0.00                   | 0.00                        | 3180.00          | ?            | ?           |
    #
    | AEBL-894         | 1             | 1               | 201808 | 2              | 0             | 1129.00      | 1129.00              | 0.00                | 0.00                   | 0.00                        | 1129.00          | ?            | ?           |
    | AEBL-894         | 1             | 1               | 201809 | 2              | 0             | 3257.00      | 3257.00              | 0.00                | 0.00                   | 0.00                        | 3257.00          | ?            | ?           |
    | AEBL-894         | 1             | 1               | 201810 | 2              | 0             | 4454.00      | 4454.00              | 0.00                | 0.00                   | 0.00                        | 4454.00          | ?            | ?           |
    | AEBL-894         | 1             | 1               | 201811 | 2              | 0             | 865.00       | 865.00               | 0.00                | 0.00                   | 0.00                        | 865.00           | ?            | ?           |
    | AEBL-894         | 1             | 1               | 201812 | 2              | 0             | 4051.00      | 4051.00              | 0.00                | 0.00                   | 0.00                        | 4051.00          | ?            | ?           |
    | AEBL-894         | 1             | 1               | 201901 | 2              | 0             | 759.00       | 759.00               | 0.00                | 0.00                   | 0.00                        | 759.00           | ?            | ?           |
    | AEBL-894         | 1             | 1               | 201902 | 2              | 0             | 4368.00      | 4368.00              | 0.00                | 0.00                   | 0.00                        | 4368.00          | ?            | ?           |
    | AEBL-894         | 1             | 1               | 201903 | 2              | 0             | 4758.00      | 4758.00              | 0.00                | 0.00                   | 0.00                        | 4758.00          | ?            | ?           |
    | AEBL-894         | 1             | 1               | 201904 | 2              | 0             | 2273.00      | 2273.00              | 0.00                | 0.00                   | 0.00                        | 2273.00          | ?            | ?           |
    | AEBL-894         | 1             | 1               | 201905 | 2              | 0             | 1142.00      | 1142.00              | 0.00                | 0.00                   | 0.00                        | 1142.00          | ?            | ?           |
    | AEBL-894         | 1             | 1               | 201906 | 2              | 0             | 898.00       | 898.00               | 0.00                | 0.00                   | 0.00                        | 898.00           | ?            | ?           |
    | AEBL-894         | 1             | 1               | 201907 | 2              | 0             | 316.00       | 316.00               | 0.00                | 0.00                   | 0.00                        | 316.00           | ?            | ?           |
    #
    | AEBT-894         | 1             | 1               | 201808 | 2              | 0             | 1557.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 1             | 1               | 201809 | 2              | 0             | 1273.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 1             | 1               | 201810 | 2              | 0             | 3441.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 1             | 1               | 201811 | 2              | 0             | 4209.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 1             | 1               | 201812 | 2              | 0             | 1597.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 1             | 1               | 201901 | 2              | 0             | 2159.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 1             | 1               | 201902 | 2              | 0             | 1789.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 1             | 1               | 201903 | 2              | 0             | 2899.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 1             | 1               | 201904 | 2              | 0             | 3204.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 1             | 1               | 201905 | 2              | 0             | 4612.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 1             | 1               | 201906 | 2              | 0             | 1703.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 1             | 1               | 201907 | 2              | 0             | 1842.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | AEBC-894         | 2             | 1               | 201808 | 2              | 0             | 1500.00      | 1500.00              | 0.00                | 0.00                   | 0.00                        | 1500.00          | ?            | ?           |
    | AEBC-894         | 2             | 1               | 201809 | 2              | 0             | 1048.00      | 1048.00              | 0.00                | 0.00                   | 0.00                        | 1048.00          | ?            | ?           |
    | AEBC-894         | 2             | 1               | 201810 | 2              | 0             | 5009.00      | 5009.00              | 0.00                | 0.00                   | 0.00                        | 5009.00          | ?            | ?           |
    | AEBC-894         | 2             | 1               | 201811 | 2              | 0             | 1665.00      | 1665.00              | 0.00                | 0.00                   | 0.00                        | 1665.00          | ?            | ?           |
    | AEBC-894         | 2             | 1               | 201812 | 2              | 0             | 963.00       | 963.00               | 0.00                | 0.00                   | 0.00                        | 963.00           | ?            | ?           |
    | AEBC-894         | 2             | 1               | 201901 | 2              | 0             | 118.00       | 118.00               | 0.00                | 0.00                   | 0.00                        | 118.00           | ?            | ?           |
    | AEBC-894         | 2             | 1               | 201902 | 2              | 0             | 1235.00      | 1235.00              | 0.00                | 0.00                   | 0.00                        | 1235.00          | ?            | ?           |
    | AEBC-894         | 2             | 1               | 201903 | 2              | 0             | 2468.00      | 2468.00              | 0.00                | 0.00                   | 0.00                        | 2468.00          | ?            | ?           |
    | AEBC-894         | 2             | 1               | 201904 | 2              | 0             | 847.00       | 847.00               | 0.00                | 0.00                   | 0.00                        | 847.00           | ?            | ?           |
    | AEBC-894         | 2             | 1               | 201905 | 2              | 0             | 635.00       | 635.00               | 0.00                | 0.00                   | 0.00                        | 635.00           | ?            | ?           |
    | AEBC-894         | 2             | 1               | 201906 | 2              | 0             | 4427.00      | 4427.00              | 0.00                | 0.00                   | 0.00                        | 4427.00          | ?            | ?           |
    | AEBC-894         | 2             | 1               | 201907 | 2              | 0             | 3390.00      | 3390.00              | 0.00                | 0.00                   | 0.00                        | 3390.00          | ?            | ?           |
    #
    | AEBL-894         | 2             | 1               | 201808 | 2              | 0             | 1262.00      | 1262.00              | 0.00                | 0.00                   | 0.00                        | 1262.00          | ?            | ?           |
    | AEBL-894         | 2             | 1               | 201809 | 2              | 0             | 3446.00      | 3446.00              | 0.00                | 0.00                   | 0.00                        | 3446.00          | ?            | ?           |
    | AEBL-894         | 2             | 1               | 201810 | 2              | 0             | 4527.00      | 4527.00              | 0.00                | 0.00                   | 0.00                        | 4527.00          | ?            | ?           |
    | AEBL-894         | 2             | 1               | 201811 | 2              | 0             | 729.00       | 729.00               | 0.00                | 0.00                   | 0.00                        | 729.00           | ?            | ?           |
    | AEBL-894         | 2             | 1               | 201812 | 2              | 0             | 4187.00      | 4187.00              | 0.00                | 0.00                   | 0.00                        | 4187.00          | ?            | ?           |
    | AEBL-894         | 2             | 1               | 201901 | 2              | 0             | 691.00       | 691.00               | 0.00                | 0.00                   | 0.00                        | 691.00           | ?            | ?           |
    | AEBL-894         | 2             | 1               | 201902 | 2              | 0             | 4574.00      | 4574.00              | 0.00                | 0.00                   | 0.00                        | 4574.00          | ?            | ?           |
    | AEBL-894         | 2             | 1               | 201903 | 2              | 0             | 4730.00      | 4730.00              | 0.00                | 0.00                   | 0.00                        | 4730.00          | ?            | ?           |
    | AEBL-894         | 2             | 1               | 201904 | 2              | 0             | 2453.00      | 2453.00              | 0.00                | 0.00                   | 0.00                        | 2453.00          | ?            | ?           |
    | AEBL-894         | 2             | 1               | 201905 | 2              | 0             | 826.00       | 826.00               | 0.00                | 0.00                   | 0.00                        | 826.00           | ?            | ?           |
    | AEBL-894         | 2             | 1               | 201906 | 2              | 0             | 918.00       | 918.00               | 0.00                | 0.00                   | 0.00                        | 918.00           | ?            | ?           |
    | AEBL-894         | 2             | 1               | 201907 | 2              | 0             | 1589.00      | 1589.00              | 0.00                | 0.00                   | 0.00                        | 1589.00          | ?            | ?           |
    #
    | AEBT-894         | 2             | 1               | 201808 | 2              | 0             | 1676.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 2             | 1               | 201809 | 2              | 0             | 1416.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 2             | 1               | 201810 | 2              | 0             | 3644.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 2             | 1               | 201811 | 2              | 0             | 4370.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 2             | 1               | 201812 | 2              | 0             | 1766.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 2             | 1               | 201901 | 2              | 0             | 2161.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 2             | 1               | 201902 | 2              | 0             | 2156.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 2             | 1               | 201903 | 2              | 0             | 2885.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 2             | 1               | 201904 | 2              | 0             | 3155.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 2             | 1               | 201905 | 2              | 0             | 4488.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 2             | 1               | 201906 | 2              | 0             | 1693.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEBT-894         | 2             | 1               | 201907 | 2              | 0             | 1748.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
 
 

	# Tidy up
	And   the override date is reset
	         
@AcceptanceTest @Withdrawn20260521
Scenario: A895 Create an ESF contract for 3 different providers (A, B and C). Approve B and C then amend C in bulk file 1. Update Draft A, Amend B and Update Draft Amend C with minimum fields in bulk file 2. Check CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017895' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017896'
    And   there is no Contract, Task or Workflow data for UKPRN '10017897'

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ESF-895       |
    | ESF-896       |
    | ESF-897       |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017895' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017895 Co Ltd' with UKPRN '10017895' and OrgId 'ORG0017895' and has 'FCS1 Test' as a manager 
    And   UPIN '117895' is associated with UKPRN '10017895' in the CRM Organisation table 

    And   there is no Organisation data for UKPRN '10017896' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017896 Co Ltd' with UKPRN '10017896' and OrgId 'ORG0017896' and has 'FCS1 Test' as a manager 
    And   UPIN '117896' is associated with UKPRN '10017896' in the CRM Organisation table 

    And   there is no Organisation data for UKPRN '10017897' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017897 Co Ltd' with UKPRN '10017897' and OrgId 'ORG0017897' and has 'FCS1 Test' as a manager 
    And   UPIN '117897' is associated with UKPRN '10017897' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017895 | 117895 | 10017895 Co Ltd | 0              | Active | Yes           | AA017895      | ?             | 
    | 10017896 | 117896 | 10017896 Co Ltd | 0              | Active | Yes           | AA017896      | ?             | 
    | 10017897 | 117897 | 10017897 Co Ltd | 0              | Active | Yes           | AA017897      | ?             | 




    # Change the date
    And   the override date is '01/07/2017'

    # Create contract for provider 10017895 'A'
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017895 | 10017895 Co Ltd      | ESFA-895             | ESIF-895       | 1                     | 01/08/2017        | 31/07/2018      | 206565.00     | ESF Contract A                 | Contract for Services | 1420   | New          | ORG0017895 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                             | AgreementNumber | ActivityDescription      | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017895 | ESIF-895       | ESF-895       | ESF 201420        | ESF1420                 | ESF                     | 01/08/2017          | 31/07/2018        | 206565.00       |                                         |            | Skills Support for the Unemployed                           | New          | Cumbria LEP                                 | E37007       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017895    | 1.2 Sustainable integration of young people    | 111\SD\7895     | Supporting new starts    | IAG                   | Transition     | 1.01                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017895 | ESIF-895       | ESF-895       | 8               | 0                     | 69120.00  | 4800.00  | 3960.00  | 6360.00  | 7080.00  | 10200.00 | 3720.00  | 4080.00  | 6000.00  | 8160.00  | 6960.00  | 2280.00  | 5520.00  | SD01 Specification Defined Deliverable (with Description)       | New          |             |
    | 10017895 | ESIF-895       | ESF-895       | 9               | 0                     | 68901.00  | 7021.00  | 11067.00 | 9877.00  | 7735.00  | 3451.00  | 5355.00  | 5474.00  | 5117.00  | 6188.00  | 2975.00  | 1547.00  | 3094.00  | SD02 Specification Defined Deliverable (with Description)       | New          |             |
    | 10017895 | ESIF-895       | ESF-895       | 10              | 0                     | 68544.00  | 2772.00  | 2646.00  | 6174.00  | 6930.00  | 7560.00  | 5796.00  | 11214.00 | 3150.00  | 1512.00  | 9450.00  | 5418.00  | 5922.00  | SD03 Specification Defined Deliverable (with Description)       | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | DeliverableCode | AllocationRef | UnitCost | Total   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | 
    | 10017895 | ESIF-895       | 8               | ESF-895       | 120      | 576     | 40       | 33       | 53       | 59       | 85       | 31       | 34       | 50       | 68       | 58       | 19       | 46       |
    | 10017895 | ESIF-895       | 9               | ESF-895       | 119      | 579     | 59       | 93       | 83       | 65       | 29       | 45       | 46       | 43       | 52       | 25       | 13       | 26       |
    | 10017895 | ESIF-895       | 10              | ESF-895       | 126      | 544     | 22       | 21       | 49       | 55       | 60       | 46       | 89       | 25       | 12       | 75       | 43       | 47       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017895 | ESIF-895           | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017895 | ESFA-895           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |



    # Create contract for provider 10017896 'B'
    Given the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017896 | 10017896 Co Ltd      | ESFA-896             | ESIF-896       | 1                     | 01/08/2017        | 31/07/2018      | 72802.00      | ESF Contract B                 | Contract for Services | 1420   | New          | ORG0017896 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                             | AgreementNumber | ActivityDescription     | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017896 | ESIF-896       | ESF-896       | ESF 201420        | ESF1420                 | ESF                     | 01/08/2017          | 31/07/2018        | 72802.00        |                                         |            | Skills Support for Retraining                               | New          | Greater Birmingham and Solihull LEP         | E37012       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017896    | 1.2 Sustainable integration of young people    | 111\SD\7896     | Funding language skills | IAG                   | More Developed | 1.07                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017896 | ESIF-896       | ESF-896       | 1               | 0                     | 29480.00  | 4224.00  | 484.00   | 1628.00  | 3256.00  | 3388.00  | 4136.00  | 880.00   | 484.00   | 2728.00  | 3960.00  | 1364.00  | 2948.00  | ST01 Learner Assessment and Plan                                | New          |             |
    | 10017896 | ESIF-896       | ESF-896       | 2               | 0                     | 21910.00  | 3022.00  | 2776.00  | 1550.00  | 2508.00  | 616.00   | 626.00   | 2563.00  | 3171.00  | 364.00   | 2365.00  | 63.00    | 2286.00  | RQ01 Regulated Learning                                         | New          |             |
    | 10017896 | ESIF-896       | ESF-896       | 3               | 0                     | 21412.00  | 2380.00  | 3655.00  | 1797.00  | 3670.00  | 769.00   | 334.00   | 1639.00  | 443.00   | 2064.00  | 903.00   | 1669.00  | 2089.00  | NR01 Non Regulated Activity                                     | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | DeliverableCode | AllocationRef | UnitCost | Total   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | 
    | 10017896 | ESIF-896       | 1               | ESF-896       | 44       | 670     | 96       | 11       | 37       | 74       | 77       | 94       | 20       | 11       | 62       | 90       | 31       | 67       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'ESIF-896' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-896' and actual ContractNumber 'ESIF-896'

    # Check that the contract is now approved
    Then  the latest version of contract 'ESIF-896' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017896 | ESIF-896           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017896 | ESFA-896           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |



    # Create contract for provider 10017897 'C'
    Given the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017897 | 10017897 Co Ltd      | ESFA-897             | ESIF-897       | 1                     | 01/08/2017        | 31/07/2018      | 166213.00     | ESF Contract C                 | Contract for Services | 1420   | New          | ORG0017897 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                                    | AgreementNumber | ActivityDescription     | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017897 | ESIF-897       | ESF-897       | ESF 201420        | ESF1420                 | ESF                     | 01/08/2017          | 31/07/2018        | 166213.00       |                                         |            | Skills Support for Refugees                                 | New          | Thames Valley Berkshire LEP                 | E37035       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017897    | 1.1 Access to employment for jobseekers/ the inactive | 111\SD\7897     | Supporting young adults | SSR                   | Less Developed | 1.08                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017897 | ESIF-897       | ESF-897       | 1               | 0                     | 49780.00  | 6764.00  | 5244.00  | 4864.00  | 4104.00  | 6536.00  | 6080.00  | 2204.00  | 5168.00  | 1520.00  | 2280.00  | 1748.00  | 3268.00  | ST01 Learner Assessment and Plan                                | New          |             |
    | 10017897 | ESIF-897       | ESF-897       | 2               | 0                     | 26484.00  | 2454.00  | 1861.00  | 3640.00  | 1021.00  | 492.00   | 3062.00  | 1772.00  | 1940.00  | 3403.00  | 1733.00  | 2059.00  | 3047.00  | RQ01 Regulated Learning                                         | New          |             |
    | 10017897 | ESIF-897       | ESF-897       | 8               | 0                     | 30564.00  | 1026.00  | 1890.00  | 1944.00  | 1782.00  | 2214.00  | 810.00   | 5076.00  | 864.00   | 3726.00  | 4914.00  | 4860.00  | 1458.00  | SD01 Specification Defined Deliverable (with Description)       | New          |             |
    | 10017897 | ESIF-897       | ESF-897       | 12              | 0                     | 59385.00  | 1926.00  | 9309.00  | 1284.00  | 5778.00  | 4815.00  | 10272.00 | 10700.00 | 7062.00  | 1070.00  | 2033.00  | 3531.00  | 1605.00  | SD05 Specification Defined Deliverable (with Description)       | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | DeliverableCode | AllocationRef | UnitCost | Total   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | 
    | 10017897 | ESIF-897       | 1               | ESF-897       | 76       | 655     | 89       | 69       | 64       | 54       | 86       | 80       | 29       | 68       | 20       | 30       | 23       | 43       |
    | 10017897 | ESIF-897       | 8               | ESF-897       | 54       | 566     | 19       | 35       | 36       | 33       | 41       | 15       | 94       | 16       | 69       | 91       | 90       | 27       |
    | 10017897 | ESIF-897       | 12              | ESF-897       | 107      | 555     | 18       | 87       | 12       | 54       | 45       | 96       | 100      | 66       | 10       | 19       | 33       | 15       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'ESIF-897' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-897' and actual ContractNumber 'ESIF-897'

    # Check that the contract is now approved
    Then  the latest version of contract 'ESIF-897' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017897 | ESIF-897           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017897 | ESFA-897           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |


    # Skinny bulk import to AMEND contract for provider 10017897 (C)
    Given there are no files prefixed '10017897_ESIF' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 04092018161727 v2_A895_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 04092018161727 v2_A895_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 04092018161727 v2_A895_1.xlsx' exists in the Datafiles folder and UKPRN '10017897' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Skinny bulk import to UPDATE DRAFT contract for provider A (10017895), AMEND contract for provider B (10017896) and UPDATE DRAFT AMENDMENT for provider C (10017897)
    Given there are no files prefixed '10017897_ESIF' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 04092018161727 v2_A895_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 04092018161727 v2_A895_2' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 04092018161727 v2_A895_2.xlsx' exists in the Datafiles folder and UKPRN '10017895' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
	And   'Success' is displayed in field 'J3' on the 'Contract' tab of the result report
	And   'Success' is displayed in field 'J4' on the 'Contract' tab of the result report

    # Check the deliverable counts in CRM
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'ESIF-895'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'ESIF-896'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'ESIF-897'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017895 | ESIF-895           | 1                     | 1                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017895 | ESIF-895           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017895 | ESFA-895           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
	#
    | 10017896 | ESIF-896           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017896 | ESIF-896           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017896 | ESFA-896           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
	#
    | 10017897 | ESIF-897           | 2                     | 1                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017897 | ESIF-897           | 2                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017897 | ESIF-897           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017897 | ESFA-897           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

	# Check the contract, allocation and deliverable details in CRM for provider A (10017895)
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | OrgId      |
    | 10017895 | 10017895 Co Ltd      | ESFA-895             | ESIF-895       | 1                     | 01/08/2017        | 31/07/2018      | 147465.00     | ESF Contract A                 | Contract for Services | 1420   | ORG0017895 |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription              | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference        | InvestmentPriority                             | AgreementNumber | ActivityDescription   | SpecificationTitle | RegionType  | LearningRatePremium | DeliveryOrg |
    | 10017895 | ESIF-895       | ESF-895       | ESF 201420        | ESF1420                 | ESF                     | 01/08/2017          | 31/07/2018        | 147465.00       |                                         |            | Skills Support for the Unemployed  | Cumbria LEP                                 | E37007       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017895  | 1.2 Sustainable integration of young people    | 111\SD\7895     | Supporting new starts | IAG                | Transition  | 1.01                |             |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | UKPRN    | ContractNumber | AllocationRef   | DeliverableCode | ParentDeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableName                                            | DeliverableDescription                     | DeliveryOrg  | 
    | 10017895 | ESIF-895       | ESF-895         | 8               | 0                     | 42300.00 | 1920.00  | 300.00   | 2700.00  | 4500.00  | 1500.00  | 1440.00  | 8220.00  | 5880.00  | 1620.00  | 5460.00  | 7620.00  | 1140.00  | SD01 Specification Defined Deliverable (with Description)  | SD01 Non accredited learning completion    |              |
    | 10017895 | ESIF-895       | ESF-895         | 9               | 0                     | 12285.00 | 1875.00  | 2055.00  | 915.00   | 405.00   | 300.00   | 30.00    | 825.00   | 690.00   | 1680.00  | 375.00   | 1440.00  | 1695.00  | SD02 Specification Defined Deliverable (with Description)  | SD02 Graduate placement                    |              |
    | 10017895 | ESIF-895       | ESF-895         | 10              | 0                     | 92880.00 | 3780.00  | 4995.00  | 13365.00 | 7290.00  | 10395.00 | 1215.00  | 3780.00  | 10665.00 | 9990.00  | 3780.00  | 11610.00 | 12015.00 | SD03 Specification Defined Deliverable (with Description)  | SD03 Promotional event                     |              |


	# Check the contract, allocation and deliverable details in CRM for provider B (10017896)
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | OrgId      |
    | 10017896 | 10017896 Co Ltd      | ESFA-896             | ESIF-896       | 2                     | 01/08/2017        | 31/07/2018      | 67519.00      | ESF Contract B                 | Contract for Services | 1420   | ORG0017896 |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription              | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference        | InvestmentPriority                             | AgreementNumber | ActivityDescription     | SpecificationTitle | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017896 | ESIF-896       | ESF-896       | ESF 201420        | ESF1420                 | ESF                     | 01/08/2017          | 31/07/2018        | 67519.00        |                                         |            | Skills Support for Retraining      | Greater Birmingham and Solihull LEP         | E37012       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017896  | 1.2 Sustainable integration of young people    | 111\SD\7896     | Funding language skills | IAG                | More Developed | 1.07                |             |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | UKPRN    | ContractNumber | AllocationRef   | DeliverableCode | ParentDeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableName                                             | DeliverableDescription        | DeliveryOrg  | 
    | 10017896 | ESIF-896       | ESF-896         | 1               | 0                     | 41535.00 | 5112.00  | 4757.00  | 923.00   | 3905.00  | 2272.00  | 2769.00  | 4757.00  | 1633.00  | 781.00   | 4118.00  | 5041.00  | 5467.00  | ST01 Learner Assessment and Plan                            |                               |              |
    | 10017896 | ESIF-896       | ESF-896         | 2               | 0                     | 13697.00 | 323.00   | 508.00   | 1734.00  | 833.00   | 952.00   | 1955.00  | 816.00   | 1037.00  | 1717.00  | 1765.00  | 697.00   | 1360.00  | RQ01 Regulated Learning                                     |                               |              |
    | 10017896 | ESIF-896       | ESF-896         | 3               | 0                     | 12287.00 | 1394.00  | 2044.00  | 1743.00  | 1258.00  | 357.00   | 808.00   | 527.00   | 714.00   | 716.00   | 731.00   | 1009.00  | 986.00   | NR01 Non Regulated Activity                                 |                               |              |

	
	# Check the contract, allocation and deliverable details in CRM for provider C (10017897)
    Then  the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | OrgId      |
    | 10017897 | 10017897 Co Ltd      | ESFA-897             | ESIF-897       | 2                     | 01/08/2017        | 31/07/2018      | 131402.00     | ESF Contract C                 | Contract for Services | 1420   | ORG0017897 |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription              | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference        | InvestmentPriority                                     | AgreementNumber | ActivityDescription     | SpecificationTitle | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017897 | ESIF-897       | ESF-897       | ESF 201420        | ESF1420                 | ESF                     | 01/08/2017          | 31/07/2018        | 131402.00       |                                         |            | Skills Support for Refugees        | Thames Valley Berkshire LEP                 | E37035       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017897  | 1.1 Access to employment for jobseekers/ the inactive  | 111\SD\7897     | Supporting young adults | SSR                | Less Developed | 1.08                |             |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows 
    | UKPRN    | ContractNumber | AllocationRef   | DeliverableCode | ParentDeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableName                                             | DeliverableDescription                    | DeliveryOrg  | 
    | 10017897 | ESIF-897       | ESF-897         | 1               | 0                     | 51816.00 | 5304.00  | 3468.00  | 6188.00  | 3604.00  | 4828.00  | 4760.00  | 2244.00  | 5100.00  | 4896.00  | 5508.00  | 1564.00  | 4352.00  | ST01 Learner Assessment and Plan                            |                                           |              |
    | 10017897 | ESIF-897       | ESF-897         | 2               | 0                     | 13056.00 | 340.00   | 544.00   | 1819.00  | 1241.00  | 1105.00  | 816.00   | 1717.00  | 1564.00  | 136.00   | 1207.00  | 2414.00  | 153.00   | RQ01 Regulated Learning                                     |                                           |              |
    | 10017897 | ESIF-897       | ESF-897         | 8               | 0                     | 35844.00 | 2320.00  | 4814.00  | 5104.00  | 3886.00  | 1508.00  | 3190.00  | 2320.00  | 2842.00  | 1160.00  | 4292.00  | 580.00   | 3828.00  | SD01 Specification Defined Deliverable (with Description)   | SD01 Non accredited learning completion   |              |
    | 10017897 | ESIF-897       | ESF-897         | 12              | 0                     | 30686.00 | 2680.00  | 2747.00  | 3618.00  | 4489.00  | 1742.00  | 3685.00  | 2680.00  | 1876.00  | 1340.00  | 4154.00  | 670.00   | 1005.00  | SD05 Specification Defined Deliverable (with Description)   | SD05 Progression through hardship         |              |


	# Tidy up
	And   the override date is reset
		
		  