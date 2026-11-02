@#Feature659_Contract_Data_Load__Changes_to_draft_contract
@#Userstory554_Update_Draft_Contracts_in_Bulk__Ready_for_30th_April
@BulkUpload_UpdateDraft_Core
Feature: Update Draft contracts via Bulk Upload process

#High level Scenarios
#	    Contract	Contract Allocation		Deliverables
#SC1	Update		Update					Update
#SC2	Update		Delete	
#SC3	Update		NEW						NEW
#SC4	Update		Update					NEW
#SC5	Update		Update					Delete

@AcceptanceTest @Withdrawn20211216
Scenario: A045 Bulk update a draft 1920 AEB contract. Check CRM. Update draft again to add an allocation. Check CRM 
    Given there are no allocations marked as Under Termination for UKPRN '10017045' 
    And   there are no terminated or closed allocations for UKPRN '10017045' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017045' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017045' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEAL-045      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | AEB-ASLS1920   |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017045' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017045 Co Ltd' with UKPRN '10017045' and OrgId 'ORG0017045' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017045' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017045 | 117045 | 10017045 Co Ltd | 0              | Active                | Yes           | AA017045      | ?             | 74 Warwick Road        | Kenilworth             | Warwickshire           | ?                      | ?                      | ?                      | CV8 1HL   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017045 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017045 | 10017045 Co Ltd      | ESFA-045             | AEBP-045       | 1                     | 01/08/2019        | 31/07/2020      | 25727.00      |                                    | Contract for Services                      | 1920   | New          | ORG0017045 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017045 | AEBP-045       | AEAL-045      | AEB-ASLS          | AEB-ASLS1920            | AY                      | 01/08/2019          | 31/07/2020        | 25727.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017045 | AEBP-045       | AEAL-045      | 1               | 0                     | 25727.00  | 2093.00  | 1436.00  | 2424.00  | 3161.00  | 1935.00  | 1911.00  | 1001.00  | 3729.00  | 1965.00  | 3556.00  | 749.00   | 1767.00  | Adult Education Budget - Adult Skills Learner Support           | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'




    # Change the date
    Given the override date is '23/08/2019'

    # Bulk file to execute an update draft to change financials
    And   there are no files prefixed '10017045' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1920 16102019090734 v3_A045' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1920 16102019090734 v3_A045' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1920 16102019090734 v3_A045' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1920 16102019090734 v3_A045.xlsx' exists in the Datafiles folder and UKPRN '10017045' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Check contract has been updated correctly
    And   the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | 
    | 10017045 | ESFA-045             | AEBP-045       | 1                     | 01/08/2019        | 31/07/2020      | 36853.00      | Contract for Services | 1920   |
   
    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription             | LEPName                                   | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference       | InvestmentPriority                                    | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType     | LearningRatePremium |
    | 10017045 | AEBP-045       | AEAL-045      | AEB-ASLS          | AEB-ASLS1920            | 01/08/2019          | 31/07/2020        | 36853.00        |         |         |                                   |                                           |         |                              |              |                            |                                                       |                 |                     |                    |                |                     |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableName                                       | DeliverableDescription      | 
    | AEBP-045       | AEAL-045      | 1               | 36853.00  | 1605.00  | 946.00   | 7146.00  | 2337.00  | 861.00   | 7400.00  | 1573.00  | 3154.00  | 521.00   | 469.00   | 6466.00  | 4375.00  | Adult Education Budget - Adult Skills Learner Support |                             | 




    # Change the date
    Given the override date is '25/08/2019'
	
	# Bulk file to execute an update draft to add an allocation
    And   there are no files prefixed '10017045' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1920 16102019105952 v3_A045' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1920 16102019105952 v3_A045' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1920 16102019105952 v3_A045' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1920 16102019105952 v3_A045.xlsx' exists in the Datafiles folder and UKPRN '10017045' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017045' for FundingType 'AEB' and period '1920' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017045' for FundingType 'AEB' and period '1920'
	
	# Check contract has been updated correctly
    And   the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | 
    | 10017045 | ESFA-045             | AEBP-045       | 1                     | 01/08/2019        | 31/07/2020      | 92785.00      | Contract for Services | 1920   |
   
    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef   | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | LEPName   | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference  | InvestmentPriority  | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType     | LearningRatePremium |
    | 10017045 | AEBP-045       | AEAL-045        | AEB-ASLS          | AEB-ASLS1920            | 01/08/2019          | 31/07/2020        | 36853.00        |         |         |                       |           |         |                              |              |                       |                     |                 |                     |                    |                |                     |
    | 10017045 | AEBP-045       | [AllocRef_AETL] | AEB-19TRLS        | AEB-19TRLS1920          | 01/08/2019          | 31/07/2020        | 55932.00        |         |         |                       |           |         |                              |              |                       |                     |                 |                     |                    |                |                     |

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableName                                             | DeliverableDescription      | 
    | AEBP-045       | AEAL-045        | 1               | 36853.00  | 1605.00  | 946.00   | 7146.00  | 2337.00  | 861.00   | 7400.00  | 1573.00  | 3154.00  | 521.00   | 469.00   | 6466.00  | 4375.00  | Adult Education Budget - Adult Skills Learner Support       |                             | 
    | AEBP-045       | [AllocRef_AETL] | 1               | 55932.00  | 6667.00  | 2133.00  | 4055.00  | 6242.00  | 3407.00  | 6072.00  | 3917.00  | 4544.00  | 552.00   | 6687.00  | 6295.00  | 5361.00  | Adult Education Budget - 19-24 Traineeships Learner Support |                             | 



   # Tidy up
    And   the override date is reset

#SC4
@AcceptanceTest @Withdrawn20231002
@BulkUpdateDraftContracts 
Scenario: B048 SC4-Ensure Bulk Update draft contract process adds a Deliverable to an existing Allocation when CRM intent in Deliverable Tab is 'NEW' and CRM intent in Contract and Allocation Tab is Update Draft
	Given The file 'MAIN AY 1516 09042015143000 UpdateDraftContractUDC000_4.xlsx' file exists at 'DataFiles' with a UKPRN '10040000'
	And there is no Contract, Task or Workflow data for UKPRN '10040000'
	And the override date is '12/12/2015'
	
	And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      | OrgStatus |
    | 10040000 | NACRO     | ESFA-B048C           | MAIN-B048C     | 1                     | 01/08/2015        | 31/07/2016      | 360		     |                                | Contract for Services | 1617   | New          | ORG0017449 | Active    |

	 And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName   | UoPCode    | AllocationDescription        | CRMIntent    | DeliveryOrg |
    | 10040000 | MAIN-B048C     | ALLC-B048     | OLASS             | 16-OLASS1617            | AY                      | 01/08/2015          | 31/07/2016        | 120.00	        |           |            | HALESOWEN COLLEGE (108457)   | New          | ?			 |

	 And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total   | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16  | Jul-16 | DeliverableDescription | CRMIntent    | DeliveryOrg |
    | 10040000 | MAIN-B048C     | ALLC-B048     | 2               | 0                     | 120.00  | 10.00  | 10.00  | 10.00  | 10.00  | 10.00  | 10.00  | 10.00  | 10.00  | 10.00  | 10.00  | 10.00	| 10.00  | Ashfield               | New          | ?		   |
  	
	And   the contract exists in CRM

	When The file is copied from the source location to the 'Input'
	Then A file 'MAIN AY 1617 09042015143000 UpdateDraftContractUDC000_4.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
	And   a results report should exist in the Sharepoint Reports folder
	And 'Success' is displayed in field 'J2' on the 'Contract' tab of the result report file 
	And 'Success' is displayed in field 'R2' on the 'Contract Allocation' tab of the result report file
	And 'Success' is displayed in field 'N2' on the 'Deliverable' tab of the result report file

	And   the draft contract header details for the latest version of the contract have been updated as follows
    | UKPRN    | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | 
    | 10040000 | ESFA-B048C           | MAIN-B048C     | 1                     |  01/08/2015       |  31/07/2016     | 900           | Contract for Services | 1516 |

    And   the draft contract allocations details for the latest version of the contract have been updated as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription      | LEPName | LEPCode | TenderSpecificationReference | LotReference | TenderAwardReference | InvestmentPriority | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType | LearningRatePremium |
    | 10040000 | MAIN-B048C     | ALLC-B048     | OLASS             | OLASS                   | 01/08/2015          | 31/07/2016        | 900.00          |         |         | HALESOWEN COLLEGE (108457) |         |         |                              |              |                      |                    |                 |                     |                    |            |                     |                

    And   the draft contract deliverables details for the latest version of the contract have been updated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Total  | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 | DeliverableName | DeliverableDescription |
    | MAIN-B048C     | ALLC-B048     | 2               | 120.00 | 10.00  | 10.00  | 10.00  | 10.00  | 10.00  | 10.00  | 10.00  | 10.00  | 10.00  | 10.00  | 10.00  | 10.00  | Ashfield		  |						   |
    | MAIN-B048C     | ALLC-B048     | 17              | 780.00 | 10.00  | 20.00  | 30.00  | 40.00  | 50.00  | 60.00  | 70.00  | 80.00  | 90.00  | 100.00 | 110.00 | 120.00 | Buckley Hall	  | Buckley Hall		   |   
 
	And a pdf has been generated by Doc Gen in Azure in 'MAIN-1516-Input-Appendices'

@AcceptanceTest @Withdrawn20230123
Scenario: A851 Attempt an Update Draft against an 1819 NCS contract that does not have a substatus of 'In Review': Fail UDC-002
    Given there is no Contract, Task or Workflow data for UKPRN '10017851' 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | NCSC-851      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017851' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017851 Co Ltd' with UKPRN '10017851' and OrgId 'ORG0017851' and has 'FCS1 Test' as a manager 
    And   UPIN '117851' is associated with UKPRN '10017851' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017851 | 117851 | 10017851 Co Ltd | 0              | Active | Yes           | AA017851      | ?             | 

    # Change the date
    And   the override date is '01/09/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017851 | 10017851 Co Ltd      | ESFA-851             | NCS-851        | 1                     | 01/10/2018        | 31/03/2019      | 36018.00      |                                | Contract for Services | 1819   | New          | ORG0017851 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017851 | NCS-851        | NCSC-851      | NCS-C             | NCS-C1819               | NCS                     | 01/10/2018          | 31/03/2019        | 36018.00        | East of England and Buckinghamshire     | 0000000101 |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017851 | NCS-851        | NCSC-851      | 1               | 0                     | 36018.00  | 5163.00  | 7401.00  | 5370.00  | 6026.00  | 4055.00  | 8003.00  | Total In The Community Funding                                  | New          |             |
    | 10017851 | NCS-851        | NCSC-851      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             |
    | 10017851 | NCS-851        | NCSC-851      | 2               | 1                     | 10092.00  | 908.00   | 2845.00  | 735.00   | 1629.00  | 2647.00  | 1328.00  | Customer Satisfaction                                           | New          |             |
    | 10017851 | NCS-851        | NCSC-851      | 3               | 1                     | 25926.00  | 4255.00  | 4556.00  | 4635.00  | 4397.00  | 1408.00  | 6675.00  | Career Management and Jobs and Learning                         | New          |             |
    | 10017851 | NCS-851        | NCSC-851      | 4               | 3                     | 13805.00  | 3567.00  | 2564.00  | 2855.00  | 997.00   | 152.00   | 3670.00  | Career Management                                               | New          |             |
    | 10017851 | NCS-851        | NCSC-851      | 5               | 3                     | 12121.00  | 688.00   | 1992.00  | 1780.00  | 3400.00  | 1256.00  | 3005.00  | Jobs and Learning                                               | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | DeliverableCode | AllocationRef | UnitCost | Total   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | 
    | 10017851 | NCS-851        | 6               | NCSC-851      | 101      | 385     | 93       | 77       | 10       | 28       | 89       | 88       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/09/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NCS-851' is in a state of 'Published to Provider'




	# Attempt an 'Update Draft' on a contract that is at 'Published to Provider'. This should fail

    # Change the date
    Given the override date is '11/09/2018'

    And   there are no files prefixed '10017851' in the Sharepoint 'NCS-1819-Input-Appendices' folder
    And   there are no files prefixed 'NCS NCS 1819 03092018121924 v2_A851' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NCS NCS 1819 03092018121924 v2_A851' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NCS NCS 1819 03092018121924 v2_A851.xlsx' exists in the Datafiles folder and UKPRN '10017851' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report
 
    # UDC-002
    And   '[Contract] Contract is not in the correct state in order to be updated' is displayed in field 'J2' on the 'Contract' tab of the result report
   