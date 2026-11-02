Feature: DeleteDraftContract 21080

@AcceptanceTest @Withdrawn20230123
Scenario: A803 Create a draft 1718 Mainstream contract which is Awaiting Documentation. Bulk update draft x2. Delete contract
    Given there is no Contract, Task or Workflow data for UKPRN '10017803' 

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017803' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017803 Co Ltd' with UKPRN '10017803' and OrgId 'ORG0017803' and has 'FCS1 Test' as a manager 
    And   UPIN '117803' is associated with UKPRN '10017803' in the CRM Organisation table 
 
    # Change the date
    And   the override date is '15/07/2017'

    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | 
    | 10017803 | 117803 | 10017803 Co Ltd | 0              | Active | 

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017803 | 10017803 Co Ltd      | ESFA-803             | MAIN-803       | 1                     | 01/08/2017        | 31/07/2018      | 165927.00     |                                | Contract for Services | 1718   | New          | ORG0017803 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode    | AllocationDescription | CRMIntent    |
    | 10017803 | MAIN-803       | 16AP-803      | 16-18 APPS        | 16-18APPS1718           | AY                      | 01/08/2017          | 31/07/2018        | 23086.00        |         |            |                       | New          |
    | 10017803 | MAIN-803       | 16NL-803      | 16-18NLA          | 16-18NLA1718            | AY                      | 01/08/2017          | 31/07/2018        | 23323.00        |         |            |                       | New          |
    | 10017803 | MAIN-803       | AAPP-803      | AAPP              | AAPP1718                | AY                      | 01/08/2017          | 31/07/2018        | 20903.00        |         |            |                       | New          |
    | 10017803 | MAIN-803       | AEC-803       | AEBC              | AEBC1718                | AY                      | 01/08/2017          | 31/07/2018        | 20808.00        |         |            |                       | New          |
    | 10017803 | MAIN-803       | AECL-803      | AEBTO-CL          | AEBTO-CL1718            | AY                      | 01/08/2017          | 31/07/2018        | 18807.00        |         |            |                       | New          |
    | 10017803 | MAIN-803       | AELS-803      | AEBTO-LS          | AEBTO-LS1718            | AY                      | 01/08/2017          | 31/07/2018        | 20185.00        |         |            |                       | New          |
    | 10017803 | MAIN-803       | AEO-803       | AEBTO-TOL         | AEBTO-TOL1718           | AY                      | 01/08/2017          | 31/07/2018        | 22367.00        |         |            |                       | New          |
    | 10017803 | MAIN-803       | ANL-803       | ANLA              | ANLA1718                | AY                      | 01/08/2017          | 31/07/2018        | 16448.00        |         |            |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    |
    | 10017803 | MAIN-803       | 16AP-803      | 2               | 0                     | 23086.00  | 2926.00  | 1658.00  | 2922.00  | 1355.00  | 1750.00  | 2919.00  | 3353.00  | 2090.00  | 1231.00  | 279.00   | 562.00   | 2041.00  | 16-18 Apprenticeships Total Funding                             | New          |
    | 10017803 | MAIN-803       | 16NL-803      | 1               | 0                     | 23323.00  | 3346.00  | 2694.00  | 2412.00  | 1133.00  | 3361.00  | 1286.00  | 1238.00  | 1006.00  | 1748.00  | 2617.00  | 1727.00  | 755.00   | Total 16-18 Non-Levy Apprenticeships Funding                    | New          |
    | 10017803 | MAIN-803       | AAPP-803      | 1               | 0                     | 20903.00  | 793.00   | 52.00    | 3285.00  | 2420.00  | 1588.00  | 348.00   | 2120.00  | 701.00   | 2540.00  | 616.00   | 3158.00  | 3282.00  | Adult Apprenticeships Total Funding                             | New          |
    | 10017803 | MAIN-803       | AEC-803       | 1               | 0                     | 20808.00  | 2738.00  | 1219.00  | 2069.00  | 1793.00  | 1623.00  | 1461.00  | 1162.00  | 2469.00  | 3142.00  | 930.00   | 1886.00  | 316.00   | Adult Education Budget Total Funding                            | New          |
    | 10017803 | MAIN-803       | AECL-803      | 1               | 0                     | 18807.00  | 59.00    | 1713.00  | 1648.00  | 2463.00  | 532.00   | 1114.00  | 1849.00  | 610.00   | 350.00   | 2493.00  | 2978.00  | 2998.00  | Adult Education Budget - Community Learning                     | New          |
    | 10017803 | MAIN-803       | AELS-803      | 1               | 0                     | 20185.00  | 886.00   | 2810.00  | 565.00   | 1681.00  | 308.00   | 1739.00  | 2708.00  | 2779.00  | 2906.00  | 1288.00  | 145.00   | 2370.00  | Adult Education Budget - Learner Support                        | New          |
    | 10017803 | MAIN-803       | AEO-803       | 1               | 0                     | 22367.00  | 1679.00  | 2836.00  | 2760.00  | 1215.00  | 3189.00  | 1578.00  | 1028.00  | 3084.00  | 1520.00  | 2538.00  | 797.00   | 143.00   | Adult Education - Traineeships and Other Learning Total Funding | New          |
    | 10017803 | MAIN-803       | ANL-803       | 1               | 0                     | 16448.00  | 1408.00  | 2941.00  | 259.00   | 616.00   | 824.00   | 3044.00  | 2301.00  | 2097.00  | 2032.00  | 592.00   | 109.00   | 225.00   | Total Adult Non-Levy Apprenticeships Funding                    | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM 
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'MAIN-803'

    # Cleardown prior to first bulk import
    Given there are no files prefixed '10017803_MAIN-803' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
	And   there are no files prefixed '10017803_MAIN-803' in the Sharepoint 'MAIN-1718-Input-Terms And Conditions' folder
	And   there are no files prefixed '10017803_MAIN-803' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder
	And   there are no files prefixed '10017803_MAIN-803' in the Sharepoint 'MAIN-1718-Output-Merged Document' folder

    And   there are no files prefixed 'MAIN AY 1718 08122017090626 v2_A803_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1718 08122017090626 v2_A803_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1718 08122017090626 v2_A803_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 08122017090626 v2_A803_1' in the Sharepoint 'Reports' folder
    
    # Change the date
    And   the override date is '19/07/2017'    

    # Bulk import file 1 to Update Draft
    And   spreadsheet 'MAIN AY 1718 08122017090626 v2_A803_1.xlsx' exists in the Datafiles folder and UKPRN '10017803' is present in cell 'A2' of the Contract tab
	When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Cleardown prior to second bulk import
    Given there are no files prefixed '10017803_MAIN-803' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1718 08122017090633 v2_A803_2' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1718 08122017090633 v2_A803_2' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1718 08122017090633 v2_A803_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 08122017090633 v2_A803_2' in the Sharepoint 'Reports' folder

    # Change the date
    And   the override date is '21/07/2017'

    # Bulk import file 2 to Update Draft again
    And   spreadsheet 'MAIN AY 1718 08122017090633 v2_A803_2.xlsx' exists in the Datafiles folder and UKPRN '10017803' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

	# Put a dummy file into a Sharepoint folder
	Given a file with filename '10017803_MAIN-803_11.pdf' is created in 'MAIN-1718-Input-Terms And Conditions' 
	And   a file with filename '10017803_MAIN-803_61.pdf' is created in 'MAIN-1718-Input-Terms And Conditions' 

    # Trigger WF28 in CRM to issue a delete request against v1 of the contract
    When  a request is initiated in CRM to delete the following contracts
   #When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017803 | MAIN-803       | 1                     | 0                  |

	# Have Tasks been deleted ?
	Then  there are no longer any Task records in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017803 | MAIN-803       | 1                     | 

	# Have Workflow History records been deleted ?
	And   there are no longer any Workflow History records in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017803 | MAIN-803       | 1                     | 

    # Have Allocations, Deliverables and Derliverable Periods been deleted ?
	And   there are no longer any Allocations, Deliverables or Deliverable Periods in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017803 | MAIN-803       | 1                     | 

	# Have Contracts been deleted (inc Master Contract where appropriate) ?
	And   the following contracts are no longer present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017803 | MAIN-803       | 1                     | 
    | 10017803 | ESFA-803       | 1                     | 

	# Have files been removed from Sharepoint
	And   there are no longer any files prefixed '10017803_MAIN-803' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
	And   there are no longer any files prefixed '10017803_MAIN-803' in the Sharepoint 'MAIN-1718-Input-Terms And Conditions' folder
	And   there are no longer any files prefixed '10017803_MAIN-803' in the Sharepoint 'MAIN-1718-Output-Merged Document' folder
    And   there are no longer any files prefixed '10017803_MAIN-803' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder

    # Tidy up
    And   the override date is reset
  
@AcceptanceTest @Withdrawn20230123
Scenario: A804 Create a draft Procured Non-Levy 2018 contract which is Unassigned. Bulk update draft x2. Delete contract
    Given there is no Contract, Task or Workflow data for UKPRN '10017804' 

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017804' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017804 Co Ltd' with UKPRN '10017804' and OrgId 'ORG0017804' and has 'FCS1 Test' as a manager 
    And   UPIN '117804' is associated with UKPRN '10017804' in the CRM Organisation table 
 
    # Change the date
    And   the override date is '16/07/2017'

    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | 
    | 10017804 | 117804 | 10017804 Co Ltd | 0              | Active | 

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017804 | 10017804 Co Ltd      | ESFA-804             | NLAP-804       | 1                     | 01/01/2018        | 31/03/2019      | 32636.00      | Contract for Services | 2018   | New          | ORG0017804 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent    |
    | 10017804 | NLAP-804       | ANLP-804      | ANLAP             | NONLEVY                 | 01/01/2018          | 31/03/2019        | 18946.00        |         |         |                       | New          |
    | 10017804 | NLAP-804       | YNLP-804      | 16-18NLAP         | NONLEVY                 | 01/01/2018          | 31/03/2019        | 13690.00        |         |         |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                        | CRMIntent    |
    | 10017804 | NLAP-804       | ANLP-804      | 1               | 0                     | 18946.00 | 1572.00  | 1355.00  | 390.00   | 2347.00  | 1636.00  | 1265.00  | 976.00   | 268.00   | 1960.00  | 1149.00  | 1884.00  | 1490.00  | 2082.00  | 46.00    | 526.00   | Total 16-18 Non-Levy Apprenticeships Funding  | New          |
    | 10017804 | NLAP-804       | YNLP-804      | 1               | 0                     | 13690.00 | 1284.00  | 1157.00  | 884.00   | 1012.00  | 674.00   | 139.00   | 609.00   | 2448.00  | 152.00   | 976.00   | 912.00   | 1225.00  | 389.00   | 1186.00  | 643.00   | Total Adult Non-Levy Apprenticeships Funding  | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check that the deliverables have all been created in CRM
    Then  there are '15' deliverable periods in CRM linked to the latest version of contract 'NLAP-804' and allocation 'ANLP-804'
    And   there are '15' deliverable periods in CRM linked to the latest version of contract 'NLAP-804' and allocation 'YNLP-804'

    # Cleardown prior to first bulk import
	Given there are no files prefixed '10017804_NLAP-804' in the Sharepoint 'NLA-2018-Input-Appendices' folder
	And   there are no files prefixed '10017804_NLAP-804' in the Sharepoint 'NLA-2018-Input-Terms And Conditions' folder
	And   there are no files prefixed '10017804_NLAP-804' in the Sharepoint 'NLA-2018-Output-Documents for Publication' folder
	And   there are no files prefixed '10017804_NLAP-804' in the Sharepoint 'NLA-2018-Output-Merged Document' folder

    And   there are no files prefixed 'NLA NONLEVY 2018 08122017141348 v2_A804_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 08122017141348 v2_A804_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 08122017141348 v2_A804_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 08122017141348 v2_A804_1' in the Sharepoint 'Reports' folder
    
    # Change the date
    And   the override date is '18/07/2017'    

    # Bulk import file 1 to Update Draft
    And   spreadsheet 'NLA NONLEVY 2018 08122017141348 v2_A804_1.xlsx' exists in the Datafiles folder and UKPRN '10017804' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
	Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Cleardown prior to second bulk import
    Given there are no files prefixed '10017804_NLAP-804' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 08122017141351 v2_A804_2' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 08122017141351 v2_A804_2' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 08122017141351 v2_A804_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 08122017141351 v2_A804_2' in the Sharepoint 'Reports' folder

    # Change the date
    And   the override date is '20/07/2017'

    # Bulk import file 2 to Update Draft again
    And   spreadsheet 'NLA NONLEVY 2018 08122017141351 v2_A804_2.xlsx' exists in the Datafiles folder and UKPRN '10017804' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
	Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Trigger WF28 in CRM to issue a delete request against v1 of the contract
    When  a request is initiated in CRM to delete the following contracts
   #When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017804 | NLAP-804       | 1                     | 0                  |

    # Have Tasks been deleted ?
    Then  there are no longer any Task records in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017804 | NLAP-804       | 1                     | 

    # Have Workflow History records been deleted ?
    And   there are no longer any Workflow History records in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017804 | NLAP-804       | 1                     | 

    # Have Allocations, Deliverables and Derliverable Periods been deleted ?
    And   there are no longer any Allocations, Deliverables or Deliverable Periods in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017804 | NLAP-804       | 1                     | 

    # Have Contracts been deleted (inc Master Contract where appropriate) ?
    And   the following contracts are no longer present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017804 | NLAP-804       | 1                     | 
    | 10017804 | ESFA-804       | 1                     | 

    # Have files been removed from Sharepoint ?
    And   there are no longer any files prefixed '10017804_NLAP-804' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no longer any files prefixed '10017804_NLAP-804' in the Sharepoint 'NLA-2018-Input-Terms And Conditions' folder
    And   there are no longer any files prefixed '10017804_NLAP-804' in the Sharepoint 'NLA-2018-Output-Merged Document' folder
    And   there are no longer any files prefixed '10017804_NLAP-804' in the Sharepoint 'NLA-2018-Output-Documents for Publication' folder

    # Tidy up
    And   the override date is reset
  
@AcceptanceTest @Withdrawn20230123
Scenario: A805 Create a draft ESF 1420 contract which is In Review. Bulk update draft x2. Delete contract
    Given there is no Contract, Task or Workflow data for UKPRN '10017805' 

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017805' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017805 Co Ltd' with UKPRN '10017805' and OrgId 'ORG0017805' and has 'FCS1 Test' as a manager 
    And   UPIN '117805' is associated with UKPRN '10017805' in the CRM Organisation table 
 
    # Change the date
    And   the override date is '01/08/2017'

    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | 
    | 10017805 | 117805 | 10017805 Co Ltd | 0              | Active | 

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017805 | 10017805 Co Ltd      | ESFA-805             | ESIF-805       | 1                     | 01/08/2017        | 31/07/2018      | 178874.00     | Contract for Services | 1420   | New          | ORG0017805 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference | TenderAwardReference          | InvestmentPriority                                                    | AgreementNumber | ActivityDescription | SpecificationTitle                | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017805 | ESIF-805       | ESF-805       | ESF 201420        | ESF                     | 01/08/2017          | 31/07/2018        | 178874.00       |                         |            |                                                             | New          | South East Midlands LEP                     | E37031       | 00-1         | TSS_20125                    | 20125/23-415-00-1/10017805    | 1.2 Sustainable integration of young people                           | 111\SD\7805     | Job Seekers Fund    | IAG                               | Transition     | 1.01                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                    | CRMIntent    | DeliveryOrg |
    | 10017805 | ESIF-805       | ESF-805       | 1               | 0                     |          | 33197.00  | 5190.00  | 3540.00  | 4535.00  | 5569.00  | 1999.00  | 1427.00  | 2893.00  | 1542.00  | 2057.00  | 288.00   | 2905.00  | 1252.00  | ST01 Learner Assessment and Plan                          | New          |             |
    | 10017805 | ESIF-805       | ESF-805       | 2               | 0                     |          | 33029.00  | 3729.00  | 2099.00  | 912.00   | 2890.00  | 1332.00  | 3267.00  | 502.00   | 3814.00  | 2472.00  | 5764.00  | 705.00   | 5543.00  | RQ01 Regulated Learning                                   | New          |             |
    | 10017805 | ESIF-805       | ESF-805       | 3               | 0                     |          | 41990.00  | 2450.00  | 5087.00  | 4961.00  | 4041.00  | 4337.00  | 5963.00  | 800.00   | 192.00   | 2085.00  | 3295.00  | 5540.00  | 3239.00  | NR01 Non Regulated Activity                               | New          |             |
    | 10017805 | ESIF-805       | ESF-805       | 4               | 0                     |          | 38377.00  | 3268.00  | 4892.00  | 3255.00  | 2577.00  | 3064.00  | 5981.00  | 2052.00  | 2981.00  | 2489.00  | 4178.00  | 1091.00  | 2549.00  | FS01 Additional Programme Cost                            | New          |             |
    | 10017805 | ESIF-805       | ESF-805       | 8               | 0                     |          | 32281.00  | 1771.00  | 919.00   | 3188.00  | 1355.00  | 3516.00  | 1382.00  | 3723.00  | 2949.00  | 4091.00  | 5322.00  | 2236.00  | 1829.00  | SD01 Specification Defined Deliverable (with Description) | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check that the deliverables have all been created in CRM
    Then  there are '60' deliverable periods in CRM linked to the latest version of contract 'ESIF-805' and allocation 'ESF-805'
 
    # Cleardown prior to first bulk import
	Given there are no files prefixed '10017805_ESIF-805' in the Sharepoint 'ESF-1420-Input-Appendices' folder
	And   there are no files prefixed '10017805_ESIF-805' in the Sharepoint 'ESF-1420-Input-Terms And Conditions' folder
	And   there are no files prefixed '10017805_ESIF-805' in the Sharepoint 'ESF-1420-Output-Documents for Publication' folder
	And   there are no files prefixed '10017805_ESIF-805' in the Sharepoint 'ESF-1420-Output-Merged Document' folder

    And   there are no files prefixed 'ESF ESF 1420 08122017144353 v2_A805_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'ESF ESF 1420 08122017144353 v2_A805_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'ESF ESF 1420 08122017144353 v2_A805_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 08122017144353 v2_A805_1' in the Sharepoint 'Reports' folder
    
    # Change the date
    And   the override date is '02/08/2017'    

    # Bulk import file 1 to Update Draft
    And   spreadsheet 'ESF ESF 1420 08122017144353 v2_A805_1.xlsx' exists in the Datafiles folder and UKPRN '10017805' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Cleardown prior to second bulk import
    Given there are no files prefixed '10017805_ESIF-805' in the Sharepoint 'ESF-1420-Input-Appendices' folder

    And   there are no files prefixed 'ESF ESF 1420 08122017144511 v2_A805_2' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'ESF ESF 1420 08122017144511 v2_A805_2' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'ESF ESF 1420 08122017144511 v2_A805_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 08122017144511 v2_A805_2' in the Sharepoint 'Reports' folder

    # Change the date
    And   the override date is '03/08/2017'

    # Bulk import file 2 to Update Draft again
    And   spreadsheet 'ESF ESF 1420 08122017144511 v2_A805_2.xlsx' exists in the Datafiles folder and UKPRN '10017805' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Update the status to In review
    Given the latest version of contract 'ESIF-805' is in a state of 'In Review'

	# Put a dummy file into a Sharepoint folder
	And   a file with filename '10017805_ESIF-805_v1.pdf' is created in the location 'ESF-1420-Output-Merged Document' 
	And   a file with filename '10017805_ESIF-805_v1.pdf' is created in the location 'ESF-1420-Output-Merged Document' 

    # Trigger WF28 in CRM to issue a delete request against v1 of the contract
    When  a request is initiated in CRM to delete the following contracts
   #When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017805 | ESIF-805       | 1                     | 0                  |

    # Have Tasks been deleted ?
    Then  there are no longer any Task records in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017805 | ESIF-805       | 1                     | 

    # Have Workflow History records been deleted ?
    And   there are no longer any Workflow History records in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017805 | ESIF-805       | 1                     | 

    # Have Allocations, Deliverables and Derliverable Periods been deleted ?
    And   there are no longer any Allocations, Deliverables or Deliverable Periods in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017805 | ESIF-805       | 1                     | 

    # Have Contracts been deleted (inc Master Contract where appropriate) ?
    And   the following contracts are no longer present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017805 | ESIF-805       | 1                     | 
    | 10017805 | ESFA-805       | 1                     | 

    # Have files been removed from Sharepoint ?
    And   there are no longer any files prefixed '10017805_ESIF-805' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no longer any files prefixed '10017805_ESIF-805' in the Sharepoint 'ESF-1420-Input-Terms And Conditions' folder
    And   there are no longer any files prefixed '10017805_ESIF-805' in the Sharepoint 'ESF-1420-Output-Merged Document' folder
    And   there are no longer any files prefixed '10017805_ESIF-805' in the Sharepoint 'ESF-1420-Output-Documents for Publication' folder

    # Tidy up
    And   the override date is reset
  
