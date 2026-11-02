Feature: DeleteDraftContractExistingMaster 21114

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run890
Scenario: A924 Create and approve a 1718 Mainstream contract. Bulk amend to create a draft v2 at Awaiting Documentation. Update Draft Amendment. Delete v2. Bulk amend to create a second v2. Approve.
    Given there is no Contract, Task or Workflow data for UKPRN '10017924' 
	And   there are no notifications of type 'Draft Contract Updated'

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017924' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017924 Co Ltd' with UKPRN '10017924' and OrgId 'ORG0017924' and has 'FCS1 Test' as a manager 
    And   UPIN '117924' is associated with UKPRN '10017924' in the CRM Organisation table 
 
    # Change the date
    And   the override date is '14/07/2017'

    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | 
    | 10017924 | 117924 | 10017924 Co Ltd | 0              | Active | 

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017924 | 10017924 Co Ltd      | ESFA-924             | MAIN-924       | 1                     | 01/08/2017        | 31/07/2018      | 46409.00      |                                | Contract for Services | 1718   | New          | ORG0017924 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode    | AllocationDescription | CRMIntent    |
    | 10017924 | MAIN-924       | 16AP-924      | 16-18 APPS        | 16-18APPS1718           | AY                      | 01/08/2017          | 31/07/2018        | 23086.00        |         |            |                       | New          |
    | 10017924 | MAIN-924       | 16NL-924      | 16-18NLA          | 16-18NLA1718            | AY                      | 01/08/2017          | 31/07/2018        | 23323.00        |         |            |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    |
    | 10017924 | MAIN-924       | 16AP-924      | 2               | 0                     | 23086.00  | 2926.00  | 1658.00  | 2922.00  | 1355.00  | 1750.00  | 2919.00  | 3353.00  | 2090.00  | 1231.00  | 279.00   | 562.00   | 2041.00  | 16-18 Apprenticeships Total Funding                             | New          |
    | 10017924 | MAIN-924       | 16NL-924      | 1               | 0                     | 23323.00  | 3346.00  | 2694.00  | 2412.00  | 1133.00  | 3361.00  | 1286.00  | 1238.00  | 1006.00  | 1748.00  | 2617.00  | 1727.00  | 755.00   | Total 16-18 Non-Levy Apprenticeships Funding                    | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    And   the override date is '15/07/2017'  

    # Cleardown prior to first bulk import
    Given there are no files prefixed '10017924_MAIN-924' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are no files prefixed '10017924_MAIN-924' in the Sharepoint 'MAIN-1718-Input-Terms And Conditions' folder
    And   there are no files prefixed '10017924_MAIN-924' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder
    And   there are no files prefixed '10017924_MAIN-924' in the Sharepoint 'MAIN-1718-Output-Merged Document' folder

    And   there are no files prefixed 'MAIN AY 1718 12122017102326 v2_A924_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1718 12122017102326 v2_A924_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1718 12122017102326 v2_A924_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 12122017102326 v2_A924_1' in the Sharepoint 'Reports' folder  

    # Bulk import file 1 to Update Draft and create files in Sharepoint
    And   spreadsheet 'MAIN AY 1718 12122017102326 v2_A924_1.xlsx' exists in the Datafiles folder and UKPRN '10017924' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
	Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Publish the contract
    And   the latest version of contract 'MAIN-924' is in a state of 'Published to Provider'

	# Have v1 files been left in Sharepoint
    And   there are files prefixed '10017924_MAIN-924_v1' in the Sharepoint 'MAIN-1718-Input-Appendices' folder

    # Change the date
    And   the override date is '16/07/2017'

	# Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-924' and actual ContractNumber 'MAIN-924'

    # Check the deliverable count in CRM
    Then  there are '24' deliverable period rows in CRM linked to the latest version of contract 'MAIN-924'

    # Check version and status values in CRM
	And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017924 | MAIN-924       | 1                     | 1                        | Approved       | Approved          | True          | True                | 01/08/2017        | 31/07/2018      | ?             | 
    | 10017924 | ESFA-924       | 1                     | 0                        | Draft          | ?                 | False         | False               | 01/08/2017        | 31/07/2018      | ?             | 

	# Change the date
    And   the override date is '17/07/2017' 

    # Cleardown prior to second bulk import
    Given there are no files prefixed 'MAIN AY 1718 12122017102348 v2_A924_2' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1718 12122017102348 v2_A924_2' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1718 12122017102348 v2_A924_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 12122017102348 v2_A924_2' in the Sharepoint 'Reports' folder  

    # Bulk import file 2 to amend contract 
    And   spreadsheet 'MAIN AY 1718 12122017102348 v2_A924_2.xlsx' exists in the Datafiles folder and UKPRN '10017924' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Cleardown prior to third bulk import
    Given there are no files prefixed 'MAIN AY 1718 12122017102351 v2_A924_3' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1718 12122017102351 v2_A924_3' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1718 12122017102351 v2_A924_3' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 12122017102351 v2_A924_3' in the Sharepoint 'Reports' folder

    # Change the date
    And   the override date is '18/07/2017'

    # Bulk import file 3 to Update Draft Amendment
    And   spreadsheet 'MAIN AY 1718 12122017102351 v2_A924_3.xlsx' exists in the Datafiles folder and UKPRN '10017924' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check version and status values in CRM
	Then   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017924 | MAIN-924       | 2                     | 1                        | Draft          | Awaiting Documentation | True          | False               | 01/08/2017        | 31/07/2018      | Variation     | 
    | 10017924 | MAIN-924       | 1                     | 1                        | Approved       | Approved               | False         | True                | 01/08/2017        | 31/07/2018      | ?             | 
    | 10017924 | ESFA-924       | 1                     | 0                        | Draft          | ?                      | False         | False               | 01/08/2017        | 31/07/2018      | ?             | 

	# Put dummy files into a Sharepoint folder
	Given a file with filename '10017924_MAIN-924_11.pdf' is created in 'MAIN-1718-Input-Terms And Conditions' 
	And   a file with filename '10017924_MAIN-924_61.pdf' is created in 'MAIN-1718-Input-Terms And Conditions' 

    # Trigger WF28 in CRM to issue a delete request against v2 of the contract
    When  a request is initiated in CRM to delete the following contracts
   #When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017924 | MAIN-924       | 2                     | 0                  |

    # Have Tasks been deleted ?
    Then  there are no longer any Task records in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017924 | MAIN-924       | 2                     | 

    # Have Workflow History records been deleted ?
    And   there are no longer any Workflow History records in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017924 | MAIN-924       | 2                     | 

    # Have Allocations, Deliverables and Derliverable Periods been deleted ?
    And   there are no longer any Allocations, Deliverables or Deliverable Periods in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017924 | MAIN-924       | 2                     | 

    # Have Contracts been deleted (inc Master Contract where appropriate) ?
    And   the following contracts are no longer present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017924 | MAIN-924       | 2                     | 
   #| 10017924 | ESFA-924       | 2                     | 

    # Check version and status values in CRM
	And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017924 | MAIN-924       | 1                     | 1                        | Approved       | Approved          | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017924 | ESFA-924       | 1                     | 0                        | Draft          | ?                 | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Have v2 files been removed from Sharepoint
    And   there are no longer any files prefixed '10017924_MAIN-924_v2' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are no longer any files prefixed '10017924_MAIN-924_v2' in the Sharepoint 'MAIN-1718-Input-Terms And Conditions' folder
    And   there are no longer any files prefixed '10017924_MAIN-924_v2' in the Sharepoint 'MAIN-1718-Output-Merged Document' folder
   #And   there are no longer any files prefixed '10017924_MAIN-924_v2' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder

    # Change the date
    And   the override date is '19/07/2017' 

    # Cleardown prior to fourth bulk import
    Given there are no files prefixed 'MAIN AY 1718 12122017102357 v2_A924_4' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1718 12122017102357 v2_A924_4' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1718 12122017102357 v2_A924_4' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 12122017102357 v2_A924_4' in the Sharepoint 'Reports' folder  

    # Bulk import file 4 to amend contract a second time and create another v2
    And   spreadsheet 'MAIN AY 1718 12122017102357 v2_A924_4.xlsx' exists in the Datafiles folder and UKPRN '10017924' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check version and status values in CRM
	And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017924 | MAIN-924       | 2                     | 0                        | Draft          | Awaiting Documentation | True          | False               | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017924 | MAIN-924       | 1                     | 1                        | Approved       | Approved               | False         | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017924 | ESFA-924       | 1                     | 0                        | Draft          | ?                      | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Publish the contract
    And   the latest version of contract 'MAIN-924' is in a state of 'Published to Provider'

    # Change the date
    And   the override date is '20/07/2017'

	# Inject an SFS approval message
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-924' and actual ContractNumber 'MAIN-924'

    # Check version and status values in CRM
	Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017924 | MAIN-924       | 2                     | 0                        | Approved       | Approved          | True          | True                | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017924 | MAIN-924       | 1                     | 1                        | Replaced       | Approved          | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017924 | ESFA-924       | 1                     | 0                        | Draft          | ?                 | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM
    And   there are '120' deliverable period rows in CRM linked to the latest version of contract 'MAIN-924'

    # Tidy up
    And   the override date is reset
  
@AcceptanceTest @Withdrawn20230123
Scenario: A925 Create two draft ESF 1420 contracts at Awaiting Documentation. Bulk update each. Delete one contract and check CRM.
    Given there is no Contract, Task or Workflow data for UKPRN '10017925' 

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017925' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017925 Co Ltd' with UKPRN '10017925' and OrgId 'ORG0017925' and has 'FCS1 Test' as a manager 
    And   UPIN '117925' is associated with UKPRN '10017925' in the CRM Organisation table 
 
    # Change the date
    And   the override date is '01/08/2017'

    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | 
    | 10017925 | 117925 | 10017925 Co Ltd | 0              | Active | 


    # Create first 1718 ESF contract 
    Given the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017925 | 10017925 Co Ltd      | ESFA-925             | ESIF-9251      | 1                     | 01/08/2017        | 31/07/2018      | 66226.00      | Contract for Services | 1420   | New          | ORG0017925 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference | TenderAwardReference          | InvestmentPriority                                    | AgreementNumber | ActivityDescription | SpecificationTitle                | RegionType      | LearningRatePremium | DeliveryOrg |
    | 10017925 | ESIF-9251      | ESF-9251      | ESF 201420        | ESF                     | 01/08/2017          | 31/07/2018        | 33029.00        |                         |            |                                                             | New          | South East Midlands LEP                     | E37031       | 00-1         | TSS_20125                    | 20125/23-415-00-1/10017925    | 1.2 Sustainable integration of young people           | 666\SD\7925     | Job Seekers Fund    | SSW Apprenticeship Services       | Less Developed  | 1.01                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                    | CRMIntent    | DeliveryOrg |
    | 10017925 | ESIF-9251      | ESF-9251      | 2               | 0                     |          | 33029.00  | 3729.00  | 2099.00  | 912.00   | 2890.00  | 1332.00  | 3267.00  | 502.00   | 3814.00  | 2472.00  | 5764.00  | 705.00   | 5543.00  | RQ01 Regulated Learning                                   | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check that the deliverables have all been created in CRM
    Then  there are '12' deliverable periods in CRM linked to the latest version of contract 'ESIF-9251' and allocation 'ESF-9251'


    # Create second 1718 ESF contract 
    Given the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017925 | 10017925 Co Ltd      | ESFA-925             | ESIF-9252      | 1                     | 01/08/2017        | 31/07/2018      | 59911.00      | Contract for Services | 1420   | New          | ORG0017925 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference | TenderAwardReference          | InvestmentPriority                                    | AgreementNumber | ActivityDescription | SpecificationTitle                | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017925 | ESIF-9252      | ESF-9252      | ESF 201420        | ESF                     | 01/08/2017          | 31/07/2018        | 121727.00       |                         |            |                                                             | New          | Leicester and Leicestershire LEP            | E37021       | 00-2         | TSS_20125                    | 20125/23-415-00-2/10017925    | 1.1 Access to employment for jobseekers/ the inactive | 555\SD\7925     | Job Seekers Fund    | SSW Retraining for Employment     | More Developed | 1.07                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                     | CRMIntent    | DeliveryOrg |
    | 10017925 | ESIF-9252      | ESF-9252      | 3               | 0                     |          | 28878.00  | 509.00   | 1167.00  | 4080.00  | 2736.00  | 2155.00  | 2003.00  | 787.00   | 21.00    | 3230.00  | 3949.00  | 3273.00  | 4968.00  | NR01 Non Regulated Activity                                | New          |             |
    | 10017925 | ESIF-9252      | ESF-9252      | 5               | 0                     |          | 31033.00  | 2782.00  | 2963.00  | 1261.00  | 1992.00  | 590.00   | 917.00   | 4232.00  | 5575.00  | 3191.00  | 556.00   | 4551.00  | 2423.00  | AC01 Actuals Costs                                         | New          |             |

    And   the contract exists in CRM 
    # Contract status is now at 'Awaiting Documentation' 

    # Check that the deliverables have all been created in CRM
    Then  there are '24' deliverable periods in CRM linked to the latest version of contract 'ESIF-9252' and allocation 'ESF-9252'


    # Cleardown prior to first bulk import
    Given there are no files prefixed '10017925_ESIF-925' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed '10017925_ESIF-925' in the Sharepoint 'ESF-1420-Input-Terms And Conditions' folder
    And   there are no files prefixed '10017925_ESIF-925' in the Sharepoint 'ESF-1420-Output-Documents for Publication' folder
    And   there are no files prefixed '10017925_ESIF-925' in the Sharepoint 'ESF-1420-Output-Merged Document' folder

    And   there are no files prefixed 'ESF ESF 1420 13122017091511 v2_A925_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'ESF ESF 1420 13122017091511 v2_A925_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'ESF ESF 1420 13122017091511 v2_A925_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 13122017091511 v2_A925_1' in the Sharepoint 'Reports' folder
    
    # Change the date
    And   the override date is '02/08/2017'    

    # Bulk import file 1 to Update Draft first contract
    And   spreadsheet 'ESF ESF 1420 13122017091511 v2_A925_1.xlsx' exists in the Datafiles folder and UKPRN '10017925' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Cleardown prior to second bulk import
    Given there are no files prefixed 'ESF ESF 1420 13122017094023 v2_A925_2' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'ESF ESF 1420 13122017094023 v2_A925_2' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'ESF ESF 1420 13122017094023 v2_A925_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 13122017094023 v2_A925_2' in the Sharepoint 'Reports' folder

    # Change the date
    And   the override date is '03/08/2017'

    # Bulk import file 2 to Update Draft second contract
    And   spreadsheet 'ESF ESF 1420 13122017094023 v2_A925_2.xlsx' exists in the Datafiles folder and UKPRN '10017925' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017925 | ESIF-9252          | 1                     | 1                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017925 | ESIF-9252          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017925 | ESIF-9251          | 1                     | 1                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017925 | ESIF-9251          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017925 | ESFA-925           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |



    # Put a dummy file into a Sharepoint folder for each contract
    And   a file with filename '10017925_ESIF-9251_11.pdf' is created in the location 'ESF-1420-Input-Terms And Conditions' 
    And   a file with filename '10017925_ESIF-9252_11.pdf' is created in the location 'ESF-1420-Input-Terms And Conditions' 

    # Trigger WF28 in CRM to issue a delete request against v1 of the contract
    When  a request is initiated in CRM to delete the following contracts
   #When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017925 | ESIF-9251      | 1                     | 0                  |

    # Have Tasks been deleted ?
    Then  there are no longer any Task records in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017925 | ESIF-9251      | 1                     | 

    # Have Workflow History records been deleted ?
    And   there are no longer any Workflow History records in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017925 | ESIF-9251      | 1                     | 

    # Have Allocations, Deliverables and Derliverable Periods been deleted ?
    And   there are no longer any Allocations, Deliverables or Deliverable Periods in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017925 | ESIF-9251      | 1                     | 

    # Have Contracts been deleted (inc Master Contract where appropriate) ?
    And   the following contracts are no longer present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017925 | ESIF-9251      | 1                     | 
   #| 10017925 | ESFA-925       | 1                     | 

    # Have files been removed from Sharepoint ?
    And   there are no longer any files prefixed '10017925_ESIF-9251' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no longer any files prefixed '10017925_ESIF-9251' in the Sharepoint 'ESF-1420-Input-Terms And Conditions' folder
    And   there are no longer any files prefixed '10017925_ESIF-9251' in the Sharepoint 'ESF-1420-Output-Merged Document' folder
    And   there are no longer any files prefixed '10017925_ESIF-9251' in the Sharepoint 'ESF-1420-Output-Documents for Publication' folder

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017925 | ESIF-9252          | 1                     | 1                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017925 | ESIF-9252          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017925 | ESFA-925           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Tidy up
    And   the override date is reset
  
@AcceptanceTest @Complete
@Long2Run @Long2Run890
Scenario: A926 Create and approve a 2018 NLAP contract. Bulk amend to create v2, publish it then withdraw it. Bulk amend again to create v3. Mark as In Review. Delete and check CRM.
    Given there is no Contract, Task or Workflow data for UKPRN '10017926' 

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017926' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017926 Co Ltd' with UKPRN '10017926' and OrgId 'ORG0017926' and has 'FCS1 Test' as a manager 
    And   UPIN '117926' is associated with UKPRN '10017926' in the CRM Organisation table 
 
    # Change the date
    And   the override date is '12/12/2017'

    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | 
    | 10017926 | 117926 | 10017926 Co Ltd | 0              | Active | 

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017926 | 10017926 Co Ltd      | ESFA-926             | NLAP-926       | 1                     | 01/01/2018        | 31/03/2019      | 29753.00      | Contract for Services | 2018   | New          | ORG0017926 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent    |
    | 10017926 | NLAP-926       | ANLP-926      | ANLAP             | NONLEVY                 | 01/01/2018          | 31/03/2019        | 16961.00        |         |         |                       | New          |
    | 10017926 | NLAP-926       | YNLP-926      | 16-18NLAP         | NONLEVY                 | 01/01/2018          | 31/03/2019        | 12792.00        |         |         |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                        | CRMIntent    |
    | 10017926 | NLAP-926       | ANLP-926      | 1               | 0                     | 16961.00 | 1761.00  | 2322.00  | 1326.00  | 224.00   | 1895.00  | 1005.00  | 1155.00  | 1230.00  | 519.00   | 824.00   | 238.00   | 1475.00  | 424.00   | 2319.00  | 244.00   | Total 16-18 Non-Levy Apprenticeships Funding  | New          |
    | 10017926 | NLAP-926       | YNLP-926      | 1               | 0                     | 12792.00 | 184.00   | 263.00   | 829.00   | 320.00   | 0.00     | 1342.00  | 1643.00  | 1360.00  | 2069.00  | 204.00   | 479.00   | 1697.00  | 1135.00  | 892.00   | 375.00   | Total Adult Non-Levy Apprenticeships Funding  | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check that the deliverables have all been created in CRM
    Then  there are '15' deliverable periods in CRM linked to the latest version of contract 'NLAP-926' and allocation 'ANLP-926'
    And   there are '15' deliverable periods in CRM linked to the latest version of contract 'NLAP-926' and allocation 'YNLP-926'

    # Publish the contract
    And   the latest version of contract 'NLAP-926' is in a state of 'Published to Provider'


    # Change the date
    And   the override date is '13/12/2017'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-926' and actual ContractNumber 'NLAP-926'

    # Check version and status values in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017926 | NLAP-926       | 1                     | 0                        | Approved       | Approved          | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017926 | ESFA-926       | 1                     | 0                        | Draft          | ?                 | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM has increased to reflect the addition of monitoring deliverables 
    And   there are '75' deliverable periods in CRM linked to the latest version of contract 'NLAP-926' and allocation 'ANLP-926'
    And   there are '75' deliverable periods in CRM linked to the latest version of contract 'NLAP-926' and allocation 'YNLP-926'


    # Change the date
    And   the override date is '15/12/2017' 

    # Cleardown prior to first bulk import
    Given there are no files prefixed '10017926_NLAP-926' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed '10017926_NLAP-926' in the Sharepoint 'NLA-2018-Input-Terms And Conditions' folder
    And   there are no files prefixed '10017926_NLAP-926' in the Sharepoint 'NLA-2018-Output-Documents for Publication' folder
    And   there are no files prefixed '10017926_NLAP-926' in the Sharepoint 'NLA-2018-Output-Merged Document' folder

    And   there are no files prefixed 'NLA NONLEVY 2018 13122017115357 v2_A926_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 13122017115357 v2_A926_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 13122017115357 v2_A926_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 13122017115357 v2_A926_1' in the Sharepoint 'Reports' folder   

    # Bulk import file 1 to AMEND v1 and create a draft v2
    And   spreadsheet 'NLA NONLEVY 2018 13122017115357 v2_A926_1.xlsx' exists in the Datafiles folder and UKPRN '10017926' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report





    # Change the date
    And   the override date is '17/12/2017' 

    # Publish the contract
    And   the latest version of contract 'NLAP-926' is in a state of 'Published to Provider'

    # Check version and status values in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus     | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017926 | NLAP-926       | 2                     | 0                        | Draft          | Published to Provider | True          | False               | 01/01/2018        | 31/03/2019      | Variation     |
    | 10017926 | NLAP-926       | 1                     | 0                        | Approved       | Approved              | False         | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017926 | ESFA-926       | 1                     | 0                        | Draft          | ?                     | False         | False               | 01/01/2018        | 31/03/2019      | ?             |





    # Change the date
    And   the override date is '19/12/2017' 

    # Withdraw the contract
    When  the next action performed by manager 'FCS1 Test' on the latest version of contract 'NLAP-926' is to 'Withdraw On Behalf Of Provider' specifying the reason as 'Test for story 21114'

    # Check version and status values in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017926 | NLAP-926       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider  | False         | False               | 01/01/2018        | 31/03/2019      | Variation     |
    | 10017926 | NLAP-926       | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017926 | ESFA-926       | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/01/2018        | 31/03/2019      | ?             |





    # Change the date
    And   the override date is '20/12/2017'

    # Cleardown prior to second bulk import
    Given there are no files prefixed 'NLA NONLEVY 2018 13122017115402 v2_A926_2' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 13122017115402 v2_A926_2' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 13122017115402 v2_A926_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 13122017115402 v2_A926_2' in the Sharepoint 'Reports' folder

    # Bulk import file 2 to AMEND v1 and create a draft v3
    And   spreadsheet 'NLA NONLEVY 2018 13122017115402 v2_A926_2.xlsx' exists in the Datafiles folder and UKPRN '10017926' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Contract status is now at 'Awaiting Documentation'


    # Change the date
    And   the override date is '21/12/2017'

    # Update the status to In Review
    Given the latest version of contract 'NLAP-926' is in a state of 'In Review'

    # Check version and status values in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017926 | NLAP-926       | 3                     | 0                        | Draft            | In Review              | True          | False               | 01/01/2018        | 31/03/2019      | Variation     |
    | 10017926 | NLAP-926       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider  | False         | False               | 01/01/2018        | 31/03/2019      | Variation     |
    | 10017926 | NLAP-926       | 1                     | 0                        | Approved         | Approved               | False         | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017926 | ESFA-926       | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Put a dummy file into a Sharepoint folder
    And   a file with filename '10017926_NLAP-926_v2.pdf' is created in the location 'NLA-2018-Output-Merged Document' 
    And   a file with filename '10017926_NLAP-926_v2.pdf' is created in the location 'NLA-2018-Output-Merged Document' 


    # Change the date
    And   the override date is '23/12/2017'

    # Trigger WF28 in CRM to issue a delete request against v3 of the contract
    When  a request is initiated in CRM to delete the following contracts
   #When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017926 | NLAP-926       | 3                     | 0                  |

    # Have Tasks been deleted ?
    Then  there are no longer any Task records in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017926 | NLAP-926       | 3                     | 

    # Have Workflow History records been deleted ?
    And   there are no longer any Workflow History records in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017926 | NLAP-926       | 3                     | 

    # Have Allocations, Deliverables and Derliverable Periods been deleted ?
    And   there are no longer any Allocations, Deliverables or Deliverable Periods in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017926 | NLAP-926       | 3                     | 

    # Have Contracts been deleted (inc Master Contract where appropriate) ?
    And   the following contracts are no longer present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017926 | NLAP-926       | 3                     | 
   #| 10017926 | ESFA-926       | 1                     |  

    # Have v3 files been removed from Sharepoint ?
    And   there are no longer any files prefixed '10017926_NLAP-926_v3' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no longer any files prefixed '10017926_NLAP-926_v3' in the Sharepoint 'NLA-2018-Input-Terms And Conditions' folder
    And   there are no longer any files prefixed '10017926_NLAP-926_v3' in the Sharepoint 'NLA-2018-Output-Merged Document' folder
    And   there are no longer any files prefixed '10017926_NLAP-926_v3' in the Sharepoint 'NLA-2018-Output-Documents for Publication' folder

    # Check version and status values in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017926 | NLAP-926       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider   | False         | False               | 01/01/2018        | 31/03/2019      | Variation     |
    | 10017926 | NLAP-926       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017926 | ESFA-926       | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

   # Change the date
    And   the override date is '25/12/2017'

    # Cleardown prior to third bulk import
    Given there are no files prefixed 'NLA NONLEVY 2018 13122017115534 v2_A926_3' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 13122017115534 v2_A926_3' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 13122017115534 v2_A926_3' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 13122017115534 v2_A926_3' in the Sharepoint 'Reports' folder

    # Bulk import file 3 to AMEND v1 and create a second draft v3
    And   spreadsheet 'NLA NONLEVY 2018 13122017115534 v2_A926_3.xlsx' exists in the Datafiles folder and UKPRN '10017926' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Contract status is now at 'Awaiting Documentation'


    # Change the date
    And   the override date is '27/12/2017'

    # Publish the contract
    And   the latest version of contract 'NLAP-926' is in a state of 'Published to Provider'


    # Change the date
    And   the override date is '29/12/2017'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '3' actual MasterContractNumber 'ESFA-926' and actual ContractNumber 'NLAP-926'

    # Check version and status values in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017926 | NLAP-926       | 3                     | 0                        | Approved         | Approved                | True          | True                | 01/01/2018        | 31/03/2019      | Variation     |
    | 10017926 | NLAP-926       | 1                     | 0                        | Replaced         | Approved                | False         | False               | 01/01/2018        | 31/03/2019      | ?             |
    | 10017926 | ESFA-926       | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM has increased to reflect the addition of monitoring deliverables 
    And   there are '75' deliverable periods in CRM linked to the latest version of contract 'NLAP-926' and allocation 'ANLP-926'
    And   there are '75' deliverable periods in CRM linked to the latest version of contract 'NLAP-926' and allocation 'YNLP-926'

    # Tidy up
    And   the override date is reset
  
@AcceptanceTest @Withdrawn20230123
Scenario: A927 Create a new 1718 EFA (1619F) contract. Update draft then withdraw v1. Bulk upload a new contract as v2 then delete. Check CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017927' 

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017927' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017927 Co Ltd' with UKPRN '10017927' and OrgId 'ORG0017927' and has 'FCS1 Test' as a manager 
    And   UPIN '117927' is associated with UKPRN '10017927' in the CRM Organisation table 
 
    # Change the date
    And   the override date is '02/07/2017'

    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | 
    | 10017927 | 117927 | 10017927 Co Ltd | 0              | Active | 

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017927 | 10017927 Co Ltd      | ESFA-927             | 1619F-927      | 1                     | 01/08/2017        | 31/07/2018      | 52511.00      |                                | 16-19 Funding         | 1718   | New          | ORG0017927 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017927 | 1619F-927      | 16LR-9271     | 1619LR            | 1619LR1718              | AY                      | 01/08/2017          | 31/07/2018        | 4950.00         |                         |            | LESLIE FRANCES (HAIR FASHIONS) LIMITED (107027)             | New          | 11792701    |
    | 10017927 | 1619F-927      | NMF-9272      | NMF               | NMF1718                 | AY                      | 01/08/2017          | 31/07/2018        | 15594.00        |                         |            | SKILLS TO GROUP LIMITED (106516)                            | New          | 11792702    |
    | 10017927 | 1619F-927      | SSF-9272      | SSF               | SSF1718                 | AY                      | 01/08/2017          | 31/07/2018        | 31967.00        |                         |            | SKILLS TO GROUP LIMITED (106516)                            | New          | 11792702    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                  | CRMIntent    | DeliveryOrg |
    | 10017927 | 1619F-927      | 16LR-9271     | 32              | 0                     | 4950.00   | 3953.49  | -779.84  | -1563.36 | -1549.87 | -916.69  | -1424.66 | 1287.04  | 4701.04  | 274.31   | -478.75  | 2442.65  | -995.71  | 16-19 High Needs SPI Element 1                          | New          | 11792701    |
    | 10017927 | 1619F-927      | NMF-9272      | 31              | 0                     | 15594.00  | 1507.94  | -2595.26 | 4039.05  | 674.48   | 1615.66  | -1537.81 | -1325.16 | 1892.62  | -2265.38 | 4935.14  | 4516.51  | 4136.14  | Cadets Vocational Programme                             | New          | 11792702    |
    | 10017927 | 1619F-927      | SSF-9272      | 13              | 0                     | 31967.00  | 1823.33  | 4193.81  | 3366.08  | 2110.66  | 2955.27  | 4798.94  | -702.07  | -376.55  | 1841.83  | 4614.40  | 4576.11  | 2765.26  | SSF Bursary Funds                                       | New          | 11792702    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check that the deliverables have all been created in CRM
    Then  there are '36' deliverable period rows in CRM linked to the latest version of contract '1619F-927'

    # Change the date
    And   the override date is '03/07/2017'

    # Cleardown prior to first bulk import
    Given there are no files prefixed '10017927_1619F-927' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   there are no files prefixed '10017927_1619F-927' in the Sharepoint '1619FUND-1718-Input-Terms And Conditions' folder
    And   there are no files prefixed '10017927_1619F-927' in the Sharepoint '1619FUND-1718-Output-Documents for Publication' folder
    And   there are no files prefixed '10017927_1619F-927' in the Sharepoint '1619FUND-1718-Output-Merged Document' folder

    And   there are no files prefixed '1619FUND AY 1718 14122017090234 v3_A927_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed '1619FUND AY 1718 14122017090234 v3_A927_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '1619FUND AY 1718 14122017090234 v3_A927_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 14122017090234 v3_A927_1' in the Sharepoint 'Reports' folder   

    # Bulk import file 1 to update the draft contract and create docs in Sharepoint
    And   spreadsheet '1619FUND AY 1718 14122017090234 v3_A927_1.xlsx' exists in the Datafiles folder and UKPRN '10017927' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Change the date
    And   the override date is '05/07/2017'

    # Publish the contract
    And   the latest version of contract '1619F-927' is in a state of 'Published to Provider'

    # Change the date
    And   the override date is '06/07/2017'

    # Withdraw the contract
    When  the next action performed by manager 'FCS1 Test' on the latest version of contract '1619F-927' is to 'Withdraw On Behalf Of Provider' specifying the reason as 'Test for story 21114'

    # Change the date
    And   the override date is '08/07/2017' 

    # Cleardown prior to second bulk import
    Given there are no files prefixed '1619FUND AY 1718 14122017090241 v3_A927_2' in the Sharepoint 'Input' folder
    And   there are no files prefixed '1619FUND AY 1718 14122017090241 v3_A927_2' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '1619FUND AY 1718 14122017090241 v3_A927_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 14122017090241 v3_A927_2' in the Sharepoint 'Reports' folder   

    # Bulk import file 2 to create a new draft contract as v2 (Revised New)
    And   spreadsheet '1619FUND AY 1718 14122017090241 v3_A927_2.xlsx' exists in the Datafiles folder and UKPRN '10017927' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check version and status values in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017927 | 1619F-927          | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017927 | 1619F-927          | 1                     | 1                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017927 | 1619F-927          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017927 | ESFA-927           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Change the date
    And   the override date is '09/07/2017' 

    # Trigger WF28 in CRM to issue a delete request against v2 of the contract
    When  a request is initiated in CRM to delete the following contracts
   #When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017927 | 1619F-927      | 2                     | 0                  |

    # Have Tasks been deleted ?
    Then  there are no longer any Task records in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017927 | 1619F-927      | 2                     | 

    # Have Workflow History records been deleted ?
    And   there are no longer any Workflow History records in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017927 | 1619F-927      | 2                     | 

    # Have Allocations, Deliverables and Derliverable Periods been deleted ?
    And   there are no longer any Allocations, Deliverables or Deliverable Periods in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017927 | 1619F-927      | 2                     | 

    # Have Contracts been deleted (inc Master Contract where appropriate) ?
    And   the following contracts are no longer present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017927 | 1619F-927      | 2                     | 
   #| 10017927 | ESFA-927       | 1                     |  

    # Have files been removed from Sharepoint ?
    And   there are no longer any files prefixed '10017927_1619F-927_v2' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   there are no longer any files prefixed '10017927_1619F-927_v2' in the Sharepoint '1619FUND-1718-Input-Terms And Conditions' folder
    And   there are no longer any files prefixed '10017927_1619F-927_v2' in the Sharepoint '1619FUND-1718-Output-Merged Document' folder
    And   there are no longer any files prefixed '10017927_1619F-927_v2' in the Sharepoint '1619FUND-1718-Output-Documents for Publication' folder



	# Prior to 26173 the following values were being generated
	
#   # Check version and status values in CRM
#   And   the following contract values are present in CRM
#   | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#   | 10017927 | 1619F-927          | 1                     | 1                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
#   | 10017927 | 1619F-927          | 1                     | 0                        | Superseded Draft | ?                         | True          | False               | 01/08/2017        | 31/07/2018      | ?             |
#   | 10017927 | ESFA-927           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

	# After 26173 the LatestVersion flag changed as shown below ...

    # Check version and status values in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017927 | 1619F-927          | 1                     | 1                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017927 | 1619F-927          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017927 | ESFA-927           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Tidy up
    And   the override date is reset
	 
@AcceptanceTest @Withdrawn20230123
Scenario: A928 Create and approve a 1617 Mainstream contract. Bulk upload a draft 1718 Mainstream contract under the same Master. Delete 1718 contract and check CRM.
    Given there is no Contract, Task or Workflow data for UKPRN '10017928' 

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017928' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017928 Co Ltd' with UKPRN '10017928' and OrgId 'ORG0017928' and has 'FCS1 Test' as a manager 
    And   UPIN '117928' is associated with UKPRN '10017928' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | 
    | 10017928 | 117928 | 10017928 Co Ltd | 0              | Active | 

    # Change the date
    And   the override date is '14/07/2016'

    # Create 1617 Mainstream contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017928 | 10017928 Co Ltd      | ESFA-928             | MAIN-9281      | 1                     | 01/08/2016        | 31/07/2017      | 18230.00      |                                | Contract for Services | 1617   | New          | ORG0017928 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode    | AllocationDescription | CRMIntent    |
    | 10017928 | MAIN-9281      | AAC-9281      | AAC               | AAC1617                 | AY                      | 01/08/2016          | 31/07/2017        | 18230.00        |         |            |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | Apr-17   | May-17   | Jun-17   | Jul-17   | DeliverableDescription                 | CRMIntent    |
    | 10017928 | MAIN-9281      | AAC-9281      | 1               | 0                     | 18230.00  | 2566.00  | 1045.00  | 343.00   | 2503.00  | 1686.00  | 732.00   | 657.00   | 849.00   | 2741.00  | 3254.00  | 1052.00  | 802.00   | Adult Apprenticeships Total Funding    | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract 'MAIN-9281' is in a state of 'Published to Provider'

    # Check the deliverable count in CRM 
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'MAIN-9281'

    # Change the date
    And   the override date is '15/07/2016'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-928' and actual ContractNumber 'MAIN-9281'

    # Check version and status values in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017928 | MAIN-9281          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2016        | 31/07/2017      | ?             |
    | 10017928 | ESFA-928           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2016        | 31/07/2017      | ?             |

    # Change the date
    And   the override date is '14/07/2017'

    # Create 1718 Mainstream contract
    Given the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017928 | 10017928 Co Ltd      | ESFA-928             | MAIN-9282      | 1                     | 01/08/2017        | 31/07/2018      | 23139.00      |                                | Contract for Services | 1718   | New          | ORG0017928 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode    | AllocationDescription | CRMIntent    |
    | 10017928 | MAIN-9282      | AEC-9282      | AEBC              | AEBC1718                | AY                      | 01/08/2017          | 31/07/2018        | 23139.00        |         |            |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    |
    | 10017928 | MAIN-9282      | AEC-9282      | 1               | 0                     | 23139.00  | 1509.00  | 1924.00  | 2861.00  | 1916.00  | 1525.00  | 1806.00  | 836.00   | 2186.00  | 1740.00  | 2399.00  | 3109.00  | 1328.00  | Adult Education Budget Total Funding                            | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM 
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'MAIN-9282'

    # Change the date
    And   the override date is '15/07/2017'

    # Cleardown prior to bulk import
    Given there are no files prefixed 'MAIN AY 1718 14122017175813 v2_A928' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1718 14122017175813 v2_A928' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1718 14122017175813 v2_A928' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 14122017175813 v2_A928' in the Sharepoint 'Reports' folder   

    # Bulk import file to Update Draft
    And   spreadsheet 'MAIN AY 1718 14122017175813 v2_A928.xlsx' exists in the Datafiles folder and UKPRN '10017928' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check version and status values in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017928 | MAIN-9282          | 1                     | 1                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017928 | MAIN-9282          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017928 | ESFA-928           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2016        | 31/07/2017      | ?             |

    # Change the date
    And   the override date is '19/07/2017'

    # Trigger WF28 in CRM to issue a delete request against v1.1 of the contract
    When  a request is initiated in CRM to delete the following contracts
   #When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017928 | MAIN-9282      | 1                     | 1                  |

    # Have Tasks been deleted ?
    Then  there are no longer any Task records in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017928 | MAIN-9282      | 1                     | 

    # Have Workflow History records been deleted ?
    And   there are no longer any Workflow History records in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017928 | MAIN-9282      | 1                     | 

    # Have Allocations, Deliverables and Derliverable Periods been deleted ?
    And   there are no longer any Allocations, Deliverables or Deliverable Periods in CRM for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017928 | MAIN-9282      | 1                     | 

    # Have Contracts been deleted (inc Master Contract where appropriate) ?
    And   the following contracts are no longer present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017928 | MAIN-9282      | 1                     | 
   #| 10017928 | ESFA-928       | 1                     |  

    # Have files been removed from Sharepoint ?
    And   there are no longer any files prefixed '10017928_MAIN-9282' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are no longer any files prefixed '10017928_MAIN-9282' in the Sharepoint 'MAIN-1718-Input-Terms And Conditions' folder
    And   there are no longer any files prefixed '10017928_MAIN-9282' in the Sharepoint 'MAIN-1718-Output-Merged Document' folder
    And   there are no longer any files prefixed '10017928_MAIN-9282' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder

    # Check version and status values in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017928 | MAIN-9281      | 1                     | 0                        | Approved         | Approved               | True          | True                | 01/08/2016        | 31/07/2017      | ?             |
    | 10017928 | ESFA-928       | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/08/2016        | 31/07/2017      | ?             |

    # Tidy up
    And   the override date is reset
	 
	  
	   