Feature: MultipleESFinOneBulkFile 20086

@AcceptanceTest @Withdrawn20230123
@HighValue
@Long2Run @Long2Run45
Scenario: A487 Create three single-allocation ESF contracts for one provider under the same master contract. Update Draft. Approve. Amend. Update Draft Amendment. Approve. Check CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017487' 
	And   there are no notifications of type 'Draft Contract Updated'
    And   the Allocation Delivery Monitoring Service atom feed is empty
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there are no entries in the DCFS stub table 
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017487' 
 
    And   there is no data in the PerformanceManagement.ContractAllocation or ContractAllocationDeliverable tables for the following providers 
    | UKPRN    | 
    | 10017487 | 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ESF-4871      |
    | ESF-4872      |
    | ESF-4873      |

    # Change the date 
    And   the override date is '12/08/2017' 

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017487' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017487 Co Ltd' with UKPRN '10017487' and OrgId 'ORG0017487' and has 'FCS1 Test' as a manager 
    And   UPIN '117487' is associated with UKPRN '10017487' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | 
    | 10017487 | 117487 | 10017487 Co Ltd | 0              | Active | 

    # Create first contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017487 | 10017487 Co Ltd      | ESFA-487             | ESIF-4871      | 1                     | 01/08/2017        | 31/07/2017      | 104770.00     | Contract for Services | 1420   | New          | ORG0017487 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName  | UoPCode | AllocationDescription   | CRMIntent    | LEPName                 | LEPCode  | LotReference | TenderSpecificationReference | TenderAwardReference          | InvestmentPriority                                    | AgreementNumber | ActivityDescription | SpecificationTitle  | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017487 | ESIF-4871      | ESF-4871      | ESF 201420        | ESF                     | 01/08/2017          | 31/07/2018        | 104770.00       |          |         |                         | New          | Cumbria LEP             | E37007   | 00-1         | TSS_20125                    | 20125/23-415-00-1/10017487    | 1.1 Access to employment for jobseekers/ the inactive | 111\SD\7487     | Job Seekers Fund    | IAG                 | Transition     | 1.01                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                  | CRMIntent    | DeliveryOrg |
    | 10017487 | ESIF-4871      | ESF-4871      | 2               | 0                     |          | 38388.00  | 5167.00  | 3524.00  | 5591.00  | 3113.00  | 1995.00  | 1323.00  | 2693.00  | 1431.00  | 5273.00  | 3670.00  | 2259.00  | 2349.00  | RQ01 Regulated Learning                                 | New          |             |
    | 10017487 | ESIF-4871      | ESF-4871      | 3               | 0                     |          | 34762.00  | 4797.00  | 927.00   | 3566.00  | 5739.00  | 1474.00  | 4456.00  | 2637.00  | 486.00   | 2475.00  | 2049.00  | 4269.00  | 1887.00  | NR01 Non Regulated Activity                             | New          |             |
    | 10017487 | ESIF-4871      | ESF-4871      | 5               | 0                     |          | 31620.00  | 490.00   | 5375.00  | 686.00   | 3921.00  | 5404.00  | 1489.00  | 2284.00  | 2395.00  | 3169.00  | 1637.00  | 3496.00  | 1274.00  | AC01 Actual Costs                                       | New          |             |

    And   the contract exists in CRM 
    # Contract status is now at 'Awaiting Documentation' 

    # Check the deliverable count in CRM  
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'ESIF-4871' 
 
    # Change the date 
    And   the override date is '14/08/2017' 

    # Create second contract linked to the first master
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName          | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017487 | 10017487 Co Ltd    | ESFA-487             | ESIF-4872      | 1                     | 01/08/2017        | 31/07/2018      | 146334.00     | Contract for Services | 1420   | New          | ORG0017487 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode    | AllocationDescription  | CRMIntent    | LEPName                | LEPCode  | LotReference | TenderSpecificationReference | TenderAwardReference          | InvestmentPriority                          | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017487 | ESIF-4872      | ESF-4872      | ESF 201420        | ESF                     | 01/08/2017          | 31/07/2018        | 146334.00       |         |            |                        | New          | Worcestershire LEP     | E37038   | 00-2         | TSS_20125                    | 20125/23-415-00-2/10017487    | 1.2 Sustainable integration of young people | 222\SD\7487     | Job Seekers Fund    | Community Grants   | More Developed | 1.02                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                  | CRMIntent    | DeliveryOrg |
    | 10017487 | ESIF-4872      | ESF-4872      | 3               | 0                     |          | 37508.00  | 2567.00  | 1746.00  | 4520.00  | 5350.00  | 4935.00  | 1246.00  | 4161.00  | 3037.00  | 1114.00  | 5949.00  | 2839.00  | 44.00    | NR01 Non Regulated Activity                             | New          |             |
    | 10017487 | ESIF-4872      | ESF-4872      | 5               | 0                     |          | 35597.00  | 4824.00  | 3393.00  | 1237.00  | 1261.00  | 2201.00  | 188.00   | 4971.00  | 4705.00  | 4751.00  | 2009.00  | 2717.00  | 3340.00  | AC01 Actual Costs                                       | New          |             |
    | 10017487 | ESIF-4872      | ESF-4872      | 6               | 0                     |          | 29487.00  | 2048.00  | 4162.00  | 680.00   | 676.00   | 1757.00  | 2468.00  | 4836.00  | 5937.00  | 1565.00  | 1063.00  | 4174.00  | 121.00   | CG01 Community Grant Payment                            | New          |             |
    | 10017487 | ESIF-4872      | ESF-4872      | 7               | 0                     |          | 43742.00  | 2750.00  | 5429.00  | 1712.00  | 4012.00  | 5343.00  | 2450.00  | 5703.00  | 3881.00  | 3106.00  | 1355.00  | 3505.00  | 4496.00  | CG02 Community Grant Management Cost                    | New          |             |

    And   the contract exists in CRM 
    # Contract status is now at 'Awaiting Documentation' 

    # Check the deliverable count in CRM  
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'ESIF-4872' 
 
    # Change the date 
    And   the override date is '11/09/2017' 

    # Create third contract linked to the first master
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName          | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 10017487 | 10017487 Co Ltd    | ESFA-487             | ESIF-4873      | 1                     |  09/09/2017       |  22/02/2018     | 57228.00      | Contract for Services | 1420   | New       | ORG0017487 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription   | CRMIntent | LEPName                       | LEPCode      | LotReference | TenderSpecificationReference | TenderAwardReference          | InvestmentPriority         | AgreementNumber | ActivityDescription | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017487 | ESIF-4873      | ESF-4873      | ESF 201420        | ESF                     | 09/09/2017          | 22/02/2018        | 57228.00        |         |         |                         | New       | Coventry and Warwickshire LEP | E37006       | 00-3         | TSS_20125                    | 20125/23-415-00-3/10017487    | 1.4 Active Inclusion       | 333\SD\7487     | Job Seekers Fund    | SSU                   | Less Developed | 1.03                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Total     | Sep-17   | Oct-17   | Nov-17  | Dec-17  | Jan-18   | Feb-18   | DeliverableDescription           | CRMIntent | DeliveryOrg |
    | 10017487 | ESIF-4873      | ESF-4873      | 1               | 0                     | 27       | 6372.00   | 2484.00  | 432.00   | 945.00  | 1026.00 | 513.00   | 972.00   | ST01 Learner Assessment and Plan | New       |             |
    | 10017487 | ESIF-4873      | ESF-4873      | 2               | 0                     |          | 21664.00  | 1633.00  | 3878.00  | 1625.00 | 3791.00 | 3123.00  | 7724.00  | RQ01 Regulated Learning          | New       |             |
    | 10017487 | ESIF-4873      | ESF-4873      | 3               | 0                     |          | 21360.00  | 4241.00  | 1009.00  | 9643.00 | 1956.00 | 3390.00  | 1121.00  | NR01 Non Regulated Activity      | New       |             |
    | 10017487 | ESIF-4873      | ESF-4873      | 4               | 0                     | 33       | 7722.00   | 1782.00  | 594.00   | 528.00  | 1551.00 | 1749.00  | 1518.00  | FS01 Additional Programme Cost   | New       |             |

    And   the draft contract deliverable volume details are as follows 
    | ContractNumber | DeliverableCode | AllocationRef | Sep-17 | Oct-17 | Nov-17 | Dec-17 | Jan-18 | Feb-18 |
    | ESIF-4873      | 1               | ESF-4873      | 92     | 16     | 35     | 38     | 19     | 36     |
    | ESIF-4873      | 4               | ESF-4873      | 54     | 18     | 16     | 47     | 53     | 46     |

    And   the contract exists in CRM 
    # Contract status is now at 'Awaiting Documentation' 

    # Check the deliverable count in CRM  
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'ESIF-4873' 
 
    # Change the date 
    And   the override date is '13/09/2017' 

    # Cleardown prior to first bulk import
    Given there are no files prefixed 'ESF ESF 1420 15112017091014 v2_A487_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'ESF ESF 1420 15112017091014 v2_A487_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'ESF ESF 1420 15112017091014 v2_A487_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 15112017091014 v2_A487_1' in the Sharepoint 'Reports' folder

    # Bulk import to change all three of the contracts by UPDATE DRAFT
    And   spreadsheet 'ESF ESF 1420 15112017091014 v2_A487_1.xlsx' exists in the Datafiles folder and UKPRN '10017487' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
 
    # Change the date 
    And   the override date is '15/09/2017'

    # Publish all three contracts 
    And   the latest version of contract 'ESIF-4871' is in a state of 'Published to Provider' 
    And   the latest version of contract 'ESIF-4872' is in a state of 'Published to Provider' 
	And   the latest version of contract 'ESIF-4873' is in a state of 'Published to Provider' 

    # Change the date 
    And   the override date is '17/09/2017' 
 
    # Inject an SFS approval message for each of the three contracts
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-487' and actual ContractNumber 'ESIF-4871' 
    And   a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-487' and actual ContractNumber 'ESIF-4872' 
	And   a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-487' and actual ContractNumber 'ESIF-4873' 

    # Check that the contracts are now approved 
    Then  the latest version of contract 'ESIF-4871' is in status 'Approved'
    And   the latest version of contract 'ESIF-4872' is in status 'Approved' 
    And   the latest version of contract 'ESIF-4873' is in status 'Approved' 

    # Check the deliverable counts in CRM 
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'ESIF-4871' 
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'ESIF-4872' 
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'ESIF-4873' 

	# Cleardown prior to second bulk import
    Given there are no files prefixed 'ESF ESF 1420 15112017102208 v2_A487-2' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'ESF ESF 1420 15112017102208 v2_A487-2' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'ESF ESF 1420 15112017102208 v2_A487-2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 15112017102208 v2_A487-2' in the Sharepoint 'Reports' folder

    # Bulk import to change two of the three contracts by AMENDMENT 
    And   spreadsheet 'ESF ESF 1420 15112017102208 v2_A487-2.xlsx' exists in the Datafiles folder and UKPRN '10017487' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

	# Cleardown prior to third bulk import
    Given there are no files prefixed 'ESF ESF 1420 15112017102417 v2_A487-3' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'ESF ESF 1420 15112017102417 v2_A487-3' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'ESF ESF 1420 15112017102417 v2_A487-3' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 15112017102417 v2_A487-3' in the Sharepoint 'Reports' folder

    # Bulk import to change two of the three contracts by UPDATE DRAFT AMENDMENT 
    And   spreadsheet 'ESF ESF 1420 15112017102417 v2_A487-3.xlsx' exists in the Datafiles folder and UKPRN '10017487' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Publish the two amended contracts 
    And   the latest version of contract 'ESIF-4872' is in a state of 'Published to Provider' 
	And   the latest version of contract 'ESIF-4873' is in a state of 'Published to Provider' 

    # Change the date 
    And   the override date is '18/09/2017' 
 
    # Inject an SFS approval message for each of the amended contracts
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-487' and actual ContractNumber 'ESIF-4872' 
	And   a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-487' and actual ContractNumber 'ESIF-4873' 

    # Check that the contracts are now approved 
    Then  the latest version of contract 'ESIF-4872' is in status 'Approved' 
    And   the latest version of contract 'ESIF-4873' is in status 'Approved' 

    # Check the deliverable counts in CRM 
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'ESIF-4871' 
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'ESIF-4872' 
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'ESIF-4873' 

	# Check that the planned contract values in CRM agree with the values in the bulk files
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | ESIF-4871      | ESF-4871        | 2               | 13430.00 | 1190.00  | 1292.00  | 323.00   | 1326.00  | 1581.00  | 1989.00  | 1462.00  | 459.00   | 918.00   | 935.00   | 850.00   | 1105.00  | 
    | ESIF-4871      | ESF-4871        | 3               | 15946.00 | 374.00   | 1870.00  | 2499.00  | 2465.00  | 697.00   | 884.00   | 1020.00  | 612.00   | 1836.00  | 34.00    | 2210.00  | 1445.00  | 
    | ESIF-4871      | ESF-4871        | 5               | 16524.00 | 1666.00  | 527.00   | 748.00   | 1428.00  | 1258.00  | 408.00   | 1071.00  | 2312.00  | 2329.00  | 1105.00  | 1530.00  | 2142.00  | 
    #
    | ESIF-4872      | ESF-4872        | 3               | 14790.00 | 2499.00  | 1224.00  | 2516.00  | 935.00   | 799.00   | 510.00   | 1394.00  | 1258.00  | 2380.00  | 510.00   | 748.00   | 17.00    | 
    | ESIF-4872      | ESF-4872        | 5               | 12172.00 | 357.00   | 697.00   | 1513.00  | 272.00   | 238.00   | 85.00    | 1530.00  | 1615.00  | 663.00   | 969.00   | 1921.00  | 2312.00  | 
    | ESIF-4872      | ESF-4872        | 6               | 7072.00  | 561.00   | 595.00   | 510.00   | 748.00   | 17.00    | 357.00   | 697.00   | 1513.00  | 272.00   | 238.00   | 1037.00  | 527.00   | 
    | ESIF-4872      | ESF-4872        | 7               | 12682.00 | 1496.00  | 357.00   | 1870.00  | 1768.00  | 884.00   | 323.00   | 1326.00  | 850.00   | 391.00   | 1088.00  | 1581.00  | 748.00   | 

    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   |
    | ESIF-4873      | ESF-4873        | 1               | 52724.00 | 11662.00 | 490.00   | 8428.00  | 14014.00 | 8134.00  | 9996.00  | 
    | ESIF-4873      | ESF-4873        | 2               | 7055.00  | 1037.00  | 527.00   | 1496.00  | 357.00   | 1870.00  | 1768.00  | 
    | ESIF-4873      | ESF-4873        | 3               | 6851.00  | 884.00   | 323.00   | 1326.00  | 1054.00  | 1105.00  | 2159.00  | 
    | ESIF-4873      | ESF-4873        | 4               | 5784.00  | 912.00   | 264.00   | 1284.00  | 804.00   | 1152.00  | 1368.00  | 

    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   |
    | ESIF-4873      | ESF-4873        | 1               | 538      | 119      | 5        | 86       | 143      | 83       | 102      | 
    | ESIF-4873      | ESF-4873        | 4               | 482      | 76       | 22       | 107      | 67       | 96       | 114      | 

	# Tidy up
    And   the override date is reset
