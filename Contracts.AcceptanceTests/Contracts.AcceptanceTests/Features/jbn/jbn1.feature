Feature: jbn1

@AcceptanceTest @InProgress
Scenario: J001 Approve a contract
    # J001 also works when pointed at MainOAT and DevOAT   
    Given the PaaS MonthEndIsRunning indicator is set to 'False'

    When  contract approval messages arrive for the following contracts
    | MasterContractNumber | ContractNumber | Version |
    | ESFA-23395           | FERCA-1038     | 1       |

@AcceptanceTest @InProgress
Scenario: J002 Approve a contract
    # J002 doesn't work when pointed at OAT
    Given the PaaS MonthEndIsRunning indicator is set to 'False'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-254' and actual ContractNumber 'NLAP-254' 

@AcceptanceTest @InProgress
Scenario: J003 Create a contract from scratch by bulk import
    Given there are no allocations marked as Under Termination for UKPRN '10002843' 
    And   there are no terminated or closed allocations for UKPRN '10002843' 
    And   there is no Contract, Task or Workflow data for UKPRN '10002843' 

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10002843' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10002843 Co Ltd' with UKPRN '10002843' and OrgId 'ORG0002843' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10002843 | 102843 | 10002843 Co Ltd | 0              | Active                | Yes           | AA002843      | ?             | 2 Grenville Buildings  | 12 Cherry Street       | ?                      | ?                      | Birmingham             | West Midlands          | B2 5AR    |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10002843 |

    # Bulk file
    And   there are no files prefixed '10002843' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 12112020085930 v3_10002843' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 12112020085930 v3_10002843' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 12112020085930 v3_10002843' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 12112020085930 v3_10002843' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 12112020085930 v3_10002843.xlsx' exists in the Datafiles folder and UKPRN '10002843' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

@AcceptanceTest @InProgress
Scenario: J004 Publish and approve a contract
    Given caseload advisor 'FCS2 Test' is assigned to provider '10017550 Co Ltd' with UKPRN '10017550' and OrgId 'ORG0017550' and has 'FCS1 Test' as a manager 
    And   the latest version of contract 'MAIN-17418' is in a state of 'Published to Provider'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-131513' and actual ContractNumber 'MAIN-17418'
	Then  the latest version of contract 'MAIN-17418' is in status 'Approved'

@AcceptanceTest @InProgress
Scenario: J005 Inject and approve a four allocation NCS contract
   #Given there is no Contract, Task or Workflow data for contract 'NCS-123' and master contract 'SFA-123'
    Given there is no Contract, Task or Workflow data for UKPRN '10017123'
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | NCSC-123      |
    | NCSE-123      |
    | NCSI-123      |
    | NCSP-123      |

   #And   there is no Organisation data for UKPRN '10017123'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017123 Co Ltd' with UKPRN '10017123' and OrgId 'ORG0017123' and has 'FCS1 Test' as a manager

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017123 | 10017123 Co Ltd      | SFA-123              | NCS-123        | 1                     | 01/04/2017        | 31/03/2018      | 91555.00      | Bernicia                       | Contract for Services | 1718   | New          | ORG0017123 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription   | CRMIntent    |
    | 10017123 | NCS-123        | NCSC-123      | NCS-C             | NCS-C1718               | FY                      | 01/04/2017          | 31/03/2018        | 29482.00        | North East              | 0000000003 | North East              | New          |
    | 10017123 | NCS-123        | NCSE-123      | NCS-IC            | NCS-IC1718              | FY                      | 01/04/2017          | 31/03/2018        | 9849.00         | North East              | 0000000003 | North East              | New          |
    | 10017123 | NCS-123        | NCSI-123      | NCS-I             | NCS-I1718               | FY                      | 01/04/2017          | 31/03/2018        | 12674.00        | North East              | 0000000003 | North East              | New          |
    | 10017123 | NCS-123        | NCSP-123      | NCS-P             | NCS-P1718               | FY                      | 01/04/2017          | 31/03/2018        | 39550.00        | North East              | 0000000003 | North East              | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | DeliverableDescription                                  | CRMIntent    |
    | 10017123 | NCS-123        | NCSC-123      | 1               | 0                     | 29482.00  | 3980.00  | 1996.00  | 1220.00  | 3479.00  | 1662.00  | 1986.00  | 3144.00  | 1033.00  | 4024.00  | 2828.00  | 1838.00  | 2292.00  | Total In The Community Funding                          | New          |
    | 10017123 | NCS-123        | NCSC-123      | 2               | 1                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customer Satisfaction                                   | New          |
    | 10017123 | NCS-123        | NCSC-123      | 3               | 1                     | 27907.00  | 1224.00  | 1294.00  | 1237.00  | 4702.00  | 1176.00  | 4895.00  | 1061.00  | 2351.00  | 1861.00  | 2940.00  | 3628.00  | 1538.00  | Career Management and Jobs and Learning                 | New          |
    | 10017123 | NCS-123        | NCSC-123      | 4               | 3                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Career Management                                       | New          |
    | 10017123 | NCS-123        | NCSC-123      | 5               | 3                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Jobs and Learning                                       | New          |
    | 10017123 | NCS-123        | NCSC-123      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                             | New          |
    | 10017123 | NCS-123        | NCSE-123      | 1               | 0                     | 9849.00   | 0.00     | 0.00     | 0.00     | 1330.00  | 0.00     | 0.00     | 3123.00  | 0.00     | 0.00     | 4181.00  | 0.00     | 1215.00  | Inspiration and Employer Engagement in Custody Activity | New          |
    | 10017123 | NCS-123        | NCSI-123      | 1               | 0                     | 12674.00  | 0.00     | 4318.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4930.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3426.00  | Inspiration Activity                                    | New          |
    | 10017123 | NCS-123        | NCSP-123      | 1               | 0                     | 39550.00  | 3761.00  | 4871.00  | 1954.00  | 1211.00  | 4664.00  | 4385.00  | 1740.00  | 3865.00  | 3667.00  | 3489.00  | 1085.00  | 4858.00  | Total In Custody Funding                                | New          |
    | 10017123 | NCS-123        | NCSP-123      | 2               | 1                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customer Satisfaction                                   | New          |
    | 10017123 | NCS-123        | NCSP-123      | 3               | 1                     | 38254.00  | 4602.00  | 1938.00  | 2971.00  | 4497.00  | 2803.00  | 4980.00  | 1912.00  | 4481.00  | 1423.00  | 2405.00  | 2776.00  | 3466.00  | Career Management and Jobs and Learning                 | New          |
    | 10017123 | NCS-123        | NCSP-123      | 4               | 3                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Career Management                                       | New          |
    | 10017123 | NCS-123        | NCSP-123      | 5               | 3                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Jobs and Learning                                       | New          |
    | 10017123 | NCS-123        | NCSP-123      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                             | New          |
    | 10017123 | NCS-123        | NCSP-123      | 7               | 3                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Career Management 2                                     | New          |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | Total     | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | 10017123 | NCS-123        | NCSC-123      | 6               | 2587      | 308      | 180      | 208      | 333      | 227      | 143      | 112      | 193      | 318      | 90       | 243      | 232      |
    | 10017123 | NCS-123        | NCSP-123      | 6               | 2528      | 93       | 309      | 179      | 121      | 281      | 247      | 330      | 124      | 110      | 204      | 237      | 293      |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract 'NCS-123' is in a state of 'Published to Provider'

    # Check the deliverable count in CRM 
    And   there are '180' deliverable period rows in CRM linked to the latest version of contract 'NCS-123'

    # Inject an SFS approval message
    And   the override date is '05/03/2017'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'SFA-123' and actual ContractNumber 'NCS-123'

    # Check the deliverable count in CRM has not changed 
    Then  there are '180' deliverable period rows in CRM linked to the latest version of contract 'NCS-123'

    # Check that the contract is now approved
    And   the latest version of contract 'NCS-123' is in status 'Approved'
	
@AcceptanceTest @InProgress
Scenario: J006 Create and approve a 4-allocation NCS contract then check deliverables and ADP feed
   #Given there is no Contract, Task or Workflow data for contract 'NCS-999' and master contract 'SFA-999'
    Given there is no Contract, Task or Workflow data for UKPRN '10017999'
	And   the Allocation Delivery Monitoring Service atom feed is empty
	And   there are no entries in the DCFS stub table
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | NCSC-999      |
    | NCSE-999      |
    | NCSI-999      |
    | NCSP-999      |

   #And   there is no Organisation data for UKPRN '10017999'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017999 Co Ltd' with UKPRN '10017999' and OrgId 'ORG0017999' and has 'FCS1 Test' as a manager

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017999 | 10017999 Co Ltd      | SFA-999              | NCS-999        | 1                     | 01/04/2017        | 31/03/2018      | 260552.00     | North Wessex                   | Contract for Services | 1718   | New          | ORG0017999 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription   | CRMIntent    |
    | 10017999 | NCS-999        | NCSC-999      | NCS-C             | NCS-C1718               | FY                      | 01/04/2017          | 31/03/2018        | 123618.00       | Thames Valley           | 0000000008 | Thames Valley           | New          |
    | 10017999 | NCS-999        | NCSE-999      | NCS-IC            | NCS-IC1718              | FY                      | 01/04/2017          | 31/03/2018        | 10621.00        | Thames Valley           | 0000000008 | Thames Valley           | New          |
    | 10017999 | NCS-999        | NCSI-999      | NCS-I             | NCS-I1718               | FY                      | 01/04/2017          | 31/03/2018        | 9456.00         | Thames Valley           | 0000000008 | Thames Valley           | New          |
    | 10017999 | NCS-999        | NCSP-999      | NCS-P             | NCS-P1718               | FY                      | 01/04/2017          | 31/03/2018        | 116857.00       | Thames Valley           | 0000000008 | Thames Valley           | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | DeliverableDescription                                  | CRMIntent    |
    | 10017999 | NCS-999        | NCSC-999      | 1               | 0                     | 123618.00 | 9788.00  | 11938.00 | 5334.00  | 8866.00  | 9356.00  | 11876.00 | 12603.00 | 8819.00  | 11230.00 | 8066.00  | 13595.00 | 12147.00 | Total In The Community Funding                          | New          |
    | 10017999 | NCS-999        | NCSC-999      | 2               | 1                     | 41443.00  | 1366.00  | 3310.00  | 1860.00  | 4824.00  | 4841.00  | 3815.00  | 4565.00  | 1050.00  | 4138.00  | 2991.00  | 4834.00  | 3849.00  | Customer Satisfaction                                   | New          |
    | 10017999 | NCS-999        | NCSC-999      | 3               | 1                     | 82175.00  | 8422.00  | 8628.00  | 3474.00  | 4042.00  | 4515.00  | 8061.00  | 8038.00  | 7769.00  | 7092.00  | 5075.00  | 8761.00  | 8298.00  | Career Management and Jobs and Learning                 | New          |
    | 10017999 | NCS-999        | NCSC-999      | 4               | 3                     | 41367.00  | 4695.00  | 3995.00  | 1794.00  | 1049.00  | 2073.00  | 4381.00  | 4076.00  | 4890.00  | 3501.00  | 2259.00  | 4957.00  | 3697.00  | Career Management                                       | New          |
    | 10017999 | NCS-999        | NCSC-999      | 5               | 3                     | 40808.00  | 3727.00  | 4633.00  | 1680.00  | 2993.00  | 2442.00  | 3680.00  | 3962.00  | 2879.00  | 3591.00  | 2816.00  | 3804.00  | 4601.00  | Jobs and Learning                                       | New          |
    | 10017999 | NCS-999        | NCSC-999      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                             | New          |
    | 10017999 | NCS-999        | NCSE-999      | 1               | 0                     | 10621.00  | 0.00     | 0.00     | 0.00     | 2111.00  | 0.00     | 0.00     | 1472.00  | 0.00     | 0.00     | 2811.00  | 0.00     | 4227.00  | Inspiration and Employer Engagement in Custody Activity | New          |
    | 10017999 | NCS-999        | NCSI-999      | 1               | 0                     | 9456.00   | 0.00     | 1421.00  | 0.00     | 0.00     | 0.00     | 0.00     | 4789.00  | 0.00     | 0.00     | 0.00     | 0.00     | 3246.00  | Inspiration Activity                                    | New          |
    | 10017999 | NCS-999        | NCSP-999      | 1               | 0                     | 116857.00 | 9545.00  | 9696.00  | 11983.00 | 8159.00  | 8766.00  | 12782.00 | 11478.00 | 6414.00  | 10775.00 | 11428.00 | 8526.00  | 7305.00  | Total In Custody Funding                                | New          |
    | 10017999 | NCS-999        | NCSP-999      | 2               | 1                     | 37705.00  | 2910.00  | 4173.00  | 3793.00  | 2464.00  | 2602.00  | 3477.00  | 3740.00  | 2040.00  | 2617.00  | 4202.00  | 4255.00  | 1432.00  | Customer Satisfaction                                   | New          |
    | 10017999 | NCS-999        | NCSP-999      | 3               | 1                     | 79152.00  | 6635.00  | 5523.00  | 8190.00  | 5695.00  | 6164.00  | 9305.00  | 7738.00  | 4374.00  | 8158.00  | 7226.00  | 4271.00  | 5873.00  | Career Management and Jobs and Learning                 | New          |
    | 10017999 | NCS-999        | NCSP-999      | 4               | 3                     | 41432.00  | 4879.00  | 1407.00  | 4671.00  | 4078.00  | 3019.00  | 4459.00  | 4096.00  | 1066.00  | 3264.00  | 3089.00  | 3113.00  | 4291.00  | Career Management                                       | New          |
    | 10017999 | NCS-999        | NCSP-999      | 5               | 3                     | 37720.00  | 1756.00  | 4116.00  | 3519.00  | 1617.00  | 3145.00  | 4846.00  | 3642.00  | 3308.00  | 4894.00  | 4137.00  | 1158.00  | 1582.00  | Jobs and Learning                                       | New          |
    | 10017999 | NCS-999        | NCSP-999      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                             | New          |

	# Add volume details through value-less deliverable 6
    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | Total     | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   |
    | 10017999 | NCS-999        | NCSC-999      | 6               | 2566      | 181      | 172      | 344      | 223      | 300      | 207      | 259      | 204      | 122      | 107      | 289      | 158      |
    | 10017999 | NCS-999        | NCSP-999      | 6               | 2450      | 199      | 129      | 96       | 343      | 336      | 243      | 214      | 86       | 319      | 200      | 140      | 145      |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

	# Publish the contract
    And   the latest version of contract 'NCS-999' is in a state of 'Published to Provider'

	# Check the deliverable count in CRM (NCSC=6x12)+(NCSE=1x12)+(NCSI=1x12)+(NCSP=6x12)
    And   there are '168' deliverable period rows in CRM linked to the latest version of contract 'NCS-999'

    # Inject an SFS approval message
    And   the override date is '05/03/2017'
	When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'SFA-999' and actual ContractNumber 'NCS-999'

	# Check that the contract is approved
    Then  the latest version of contract 'NCS-999' is in status 'Approved'

	# Check the deliverable count in CRM has not changed post-approval
    And   there are '168' deliverable period rows in CRM linked to the latest version of contract 'NCS-999'

    # Check AllocationDelivery.AllocationDeliveryEntry (ADP) feed for approval(0) event
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events 
    | AllocationDeliveryEntryCategory   | ADCode | AllocationNumber | ContractVersionNumber |
    | NewContractAllocationApproved     | 0      | NCSC-999         | 1                     |
    | NewContractAllocationApproved     | 0      | NCSE-999         | 1                     |
    | NewContractAllocationApproved     | 0      | NCSP-999         | 1                     |
    | NewContractAllocationApproved     | 0      | NCSI-999         | 1                     |

	And   the override date is reset

@AcceptanceTest @InProgress
Scenario: J007 Issue request to amend a Levy contract
    When  a request is issued to amend the following approved Levy contract
    | UKPRN    | MasterContractNumber | ContractNumber | Version |
    | 10017545 | ESFA-62899           | APPLEVY-37252  | 1       |

@AcceptanceTest @InProgress
Scenario: J008 Issue a contract withdrawal request for v1 and a reissue request to create v2
    When  a request is issued to withdraw and reissue the following draft Levy contract
    | UKPRN    | MasterContractNumber | ContractNumber | Version |
    | 10017708 | ESFA-62898           | APPLEVY-37251  | 1       |   

@AcceptanceTest @InProgress
Scenario: J009 Assign a caseload advisor to a UKPRN
 #   And   there is no Organisation data for UKPRN '10009095'
    Given caseload advisor 'FCS2 Test' is assigned to provider 'TENDRING DISTRICT COUNCIL' with UKPRN '10009095' and OrgId 'ORG0002197' and has 'FCS1 Test' as a manager
   
@AcceptanceTest @InProgress
Scenario: J010 Check contents of PaymentSchedule.DeliverablePayment
   # Retrieve MasterContract and Contract and Allocation numbers for this contract
    Then  '[AllocRef]' is the ContractAllocationNumber of the latest Levy contract held by UKPRN '10017196'

	And   PAAS table PaymentSchedule.DeliverablePayment contains the following values
    | AllocationNumber | VersionNumber | DeliverableCode | Period   | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualValue |
    | [AllocRef]       | 1             | 1               | 201704   | 2              | 0             | 600.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0.00        |

@AcceptanceTest @InProgress
Scenario: J011 Create a CDA report for a single Funding Stream Period
    Given there is no CDA report named 'CDA Last Approved Version J011.csv'

    When  the following CDA report is run
    | FundingStreamPeriod | Version                | Suffix |
    | 1619ED2021          | Last Approved Version  | J011   |

    Then  a report named 'CDA Last Approved Version J011.csv' is created

@AcceptanceTest @InProgress
Scenario: J012 Create a CDA report for multiple Funding Stream Periods
    Given there is no CDA report named 'CDA Latest Version J012.csv'
    
    When  the following CDA report is run
    | FundingStreamPeriod | Version                | Suffix |
    | ALLBC1819,ALLF1819  | Latest Version         | J012   |

    Then  a report named 'CDA Latest Version J012.csv' is created

@AcceptanceTest @InProgress
Scenario: J013 HeldReportedActuals steps
    # Cleardown
	Given there are no rows on HeldReportedActualGroup for OrgId 'ORG0017123'

	# Data has been parked
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017765' and Collection 'R09' marked as unprocessed

	# Parked data has been processed
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017765' and Collection 'R09' marked as processed

    # Simulate a DC Collection without data 
    Given there is a closed collection with no data for CollectionType 'APPS' and CollectionReturnCode 'APPS22'
	Given there is a closed collection with no data for CollectionType 'ILR1819' and CollectionReturnCode 'R11'

@AcceptanceTest @InProgress
Scenario: J014 Set override date
    Given the override date is '04/09/2019'

@AcceptanceTest @InProgress
Scenario: J017 Not a test. Retrieve parameters from CRM
    # Check the contents of the Appendices
    Then I retrieve the latest contract details from CRM for provider '10017433' for FundingType 'MAIN' and period '1617'
    And   a file for this contract exists in sharepoint location 'MAIN-1617-Input-Appendices'
    #And   the pdf file contains the following simple lines in order
    And   the pdf file contains the following parameterized lines in order
    """
    APPENDIX 1 - SUMMARY OF EDUCATION AND SKILLS FUNDING AGENCY FUNDING 2016/17
    Organisation Name: NACRO
    UKPRN: 10017433
    16-18 Non-Levy Apprenticeships [AllocRef_16NL] £0 £9,683 £9,683
    Adult Non-Levy Apprenticeships [AllocRef_ANL] £0 £7,649 £7,649
	"""

	# Also

    Then  '[MasterContractNo]' is the MasterContractNumber of the latest contract held by UKPRN '10017384'
    And   '[ContractNo]' is the ContractNumber of the latest contract held by UKPRN '10017384'
    And   '[AllocRef]' is the ContractAllocationNumber of the latest contract held by UKPRN '10017384'

    Then  '[MasterContractNo]' is the MasterContractNumber of the latest Levy contract held by UKPRN '10009988'
    And   '[ContractNo]' is the ContractNumber of the latest Levy contract held by UKPRN '10009988'
    And   '[AllocRef]' is the ContractAllocationNumber of the latest Levy contract held by UKPRN '10009988'

@AcceptanceTest @InProgress
Scenario: J018 Not a test. Set Organisation and Advisors
	# Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017395'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017395 Co Ltd' with UKPRN '10017395' and OrgId 'ORG0017395' and has 'FCS1 Test' as a manager
    And   UPIN '117395' is associated with UKPRN '10017395' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017395 | 117395 | 10017395 Co Ltd | 0              | Active |
	 
@AcceptanceTest @InProgress
Scenario: J019 Not a test. Check contents of ADP feed
    # Check the content of the type 2 events on the AllocationDelivery.AllocationDeliveryEntry (ADP) feed 
    Then the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
    | AllocationDeliveryEntryCategory   | ContractNumber | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
    | ContractAllocationActualsReceived | AEBP-294       | 2             | AEBT-294         | 2               | 201711 | 806.60      | 0.00           | 0.00             | 806.60                | 0.00           | 806.60     |
    | ContractAllocationActualsReceived | AEBP-294       | 2             | AEBT-294         | 3               | 201711 | 613.16      | 0.00           | 0.00             | 613.16                | 0.00           | 613.16     |
    | ContractAllocationActualsReceived | AEBP-294       | 2             | AEBT-294         | 4               | 201711 | 938.88      | 0.00           | 0.00             | 938.88                | 0.00           | 938.88     |
    | ContractAllocationActualsReceived | AEBP-294       | 2             | AEBT-294         | 5               | 201711 | 524.80      | 0.00           | 0.00             | 524.80                | 0.00           | 524.80     |
    | ContractAllocationActualsReceived | AEBP-294       | 2             | AEBT-294         | 6               | 201711 | 775.84      | 0.00           | 0.00             | 775.84                | 0.00           | 775.84     |

@AcceptanceTest @InProgress
Scenario: J020 Create a dummy file in a Sharepoint folder then save a copy of it to Datafiles/Downloads
    # Copy Contract.AcceptanceTests\Resources\JerryMouse.pdf into the chosen Sharepoint location
	Given a file called 'TestFile.pdf' is created in Sharepoint folder 'LEVY-1799-Input-Appendices'

    # Copy a named Sharepoint file into Datafiles\Downloads with a different name
    And   Sharepoint file 'TestFile.pdf' in 'LEVY-1799-Input-Appendices' is copied to 'Datafiles/Downloads' as 'JerryMouse.pdf'

@AcceptanceTest @InProgress
Scenario: J021 Put a file in one of the Sharepoint folders
 #   # This file is created out of nothing. It has one page containing just the work 'Appendices'
 #   Given a file with filename '10017123_ESIF-805_v1.pdf' is created in the location 'ESF-1420-Output-Merged Document' 

	Given a file with filename '10017808_NCS-808_v1.pdf' is created in 'NCS-2018-Input-Appendices' 
    And   a file with filename '10017808_NCS-808_11.pdf' is created in 'NCS-2018-Input-Terms And Conditions' 
    And   a file with filename '10017808_NCS-808_61.pdf' is created in 'NCS-2018-Input-Terms And Conditions' 

@AcceptanceTest @InProgress
Scenario: J022 Dummy Addresses with Caseloads
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '90000001' 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Emmerdale County Council' with UKPRN '90000001' and OrgId 'ORG0000001' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '90000001' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                     | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2          | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 90000001 | 000001 | Emmerdale County Council | 0              | Active                | Yes           | AA000001      | ?             | Town Hall              | Trumpton              | ?                      | ?                      | ?                      | ?                      | TR1 1SW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 90000001 |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '90000002' 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Chigley College' with UKPRN '90000002' and OrgId 'ORG0000002' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '90000002' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 90000002 | 000002 | Chigley College | 0              | Active                | Yes           | AA000002      | ?             | College Street         | Chigley                | ?                      | ?                      | ?                      | ?                      | CH92 8AB  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 90000002 |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '90000003' 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Camberwick Green College' with UKPRN '90000003' and OrgId 'ORG0000003' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '90000003' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                     | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 90000003 | 000003 | Camberwick Green College | 0              | Active                | Yes           | AA000003      | ?             | College Road           | Camberwick Green       | ?                      | ?                      | ?                      | ?                      | CM72 6TP  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 90000003 |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '90000004' 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Night Garden Photography Ltd' with UKPRN '90000004' and OrgId 'ORG0000004' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '90000004' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                         | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 90000004 | 000004 | Night Garden Photography Ltd | 0              | Active                | Yes           | AA000004      | ?             | Dark Alley Buildings   | Grey Garden North      | ?                      | ?                      | ?                      | ?                      | DD12 6PY  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 90000004 |


@AcceptanceTest @InProgress
Scenario: J024 Complete a TASK in CRM
    # Complete an existing open Task
    When  the following open Task currently linked to version '1' of contract '1619F-1630' for provider '10022923' is triggered by User 'FCS2 Test'
    | Task                             | Owner            | 
    | Review Contract Details          | FCS2 Test        | 

@AcceptanceTest @InProgress
Scenario: J025 Check the Workflow History for a specific action aka service response
    # This step only looks at the most recent narraive in the contract workflow history 
	Then  the latest workflow history service response on contract 'EMPAGE-228' is 'Document Publish Failed'
   
@AcceptanceTest @InProgress
Scenario: J027 Reset the Paas MonthEndIsRunning indicator  
    Given the PaaS MonthEndIsRunning indicator is set to 'False'

@AcceptanceTest @InProgress
Scenario: J028 Cleardown Notifications
    Given there are no notifications of type 'Amendment Approval'
    And   there are no notifications of type 'Approval Received'
    And   there are no notifications of type 'Caseload re-assigned'
    And   there are no notifications of type 'Contract Amendment Failed'
    And   there are no notifications of type 'Contract Closure Failed'
	And   there are no notifications of type 'Contract Closure Initiation Failed'
	And   there are no notifications of type 'Contract Closure Rejected'
	And   there are no notifications of type 'Contract Deletion Failed'
	And   there are no notifications of type 'Contract Termination Failed'
	And   there are no notifications of type 'Contract Termination Initiation Rejected'
	And   there are no notifications of type 'Contract Withdrawn'
	And   there are no notifications of type 'Document Merge Failed'
	And   there are no notifications of type 'Draft Contract Updated'
	And   there are no notifications of type 'FCR Allocation Update Failed'
	And   there are no notifications of type 'FCR Hold Failed'
	And   there are no notifications of type 'Held FCR Release Failed'
	And   there are no notifications of type 'Manual Approval Failed'
    And   there are no notifications of type 'Non-Financial Contract Amendment Failed'
	And   there are no notifications of type 'Provider Details Updated'
	And   there are no notifications of type 'Publish To Provider Failed'
    And   there are no notifications of type 'Reconciliation Publish To Provider Failed'
    And   there are no notifications of type 'Task Re-assigned'
    And   there are no notifications of type 'Reconciliation Publication Failed'
	
	
    
    #	
   #And   there are no notifications in CRM of type 'Draft Contract Updated' for UKPRN '100170'
   #And   there are no notifications in CRM of type 'Draft Contract Updated' for UKPRN '100171'

@AcceptanceTest @InProgress
Scenario: J029 Copy a file into a Sharepoint folder
    Given there are no files prefixed '10000000_MAIN-0000' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And    a copy of the file '10000000_MAIN-0000_v1.pdf' in 'DataFiles\DummyFiles' exists in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And    a copy of the file '10000000_MAIN-0000_v2.pdf' in 'DataFiles\DummyFiles' exists in the Sharepoint 'MAIN-1718-Input-Appendices' folder

@AcceptanceTest @InProgress
Scenario: J030 Copy a file into a Sharepoint folder
    # Copy 'Resources/DummyPdf.pdf' as '10017322_MAIN-322_61.pdf' to 'EDSK-1920-Input-Terms And Conditions'
    Given a file with filename '10017322_MAIN-322_61.pdf' is created in 'EDSK-1920-Input-Terms And Conditions'

	# Copy 'DummyFile11.pdf' from 'DataFiles/DummyFiles' to 'Input'
    Given file 'DummyFile11.pdf' is copied from 'DataFiles/DummyFiles' to the Sharepoint 'Input' folder

@AcceptanceTest @InProgress
Scenario: J031 Check contract state
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017255 | MAIN-255           | 3                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | Notification  |
    | 10017255 | MAIN-255           | 2                     | 1                        | Replaced         | Approved                  | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017255 | MAIN-255           | 2                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017255 | MAIN-255           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017255 | ESFA-255           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

@AcceptanceTest @InProgress
Scenario: J032 Recreate an Organisation 
    Given there is no Contract, Task or Workflow data for UKPRN '10017369'
    And   there is no Organisation data for UKPRN '10017369'

    # Add data to dbo.Organisations
    And   the following Organisations exist in the FCT Organisation Service 
    | OrgId      | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber |
    | ORG0017369 | 10017369 | 117369 | 10017369 Co Ltd | 0              | Active | Yes           | AA017369      | 17369         |
	# The above populates dbo.Organisations with everything other than the OrgId. This is a system-generated value in the table

	# Dropping a bulk file at this point (to create a new contract) will pick up all the dbo values and create a new row in the CRM Organisation table
	 
    # Set organisation and advisors in CRM
   #And   caseload advisor 'FCS2 Test' is assigned to provider '10017369 Co Ltd' with UKPRN '10017369' and OrgId 'ORG0017369' and has 'FCS1 Test' as a manager 
   #And   UPIN '117367' is associated with UKPRN '10017367' in the CRM Organisation table 

    # Add data to dbo.Organisations
    And   the following Organisations exist in the FCT Organisation Service 
    | OrgId      | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber |
    | ORG1736901 | 11736901 | 736901 | 11736901 Co Ltd | 0              | Active | Yes           | AA736901      | 36901         |
    | ORG1736902 | 11736902 | 736902 | 11736902 Co Ltd | 0              | Active | Yes           | AA736902      | 36902         |
    | ORG1736903 | 11736903 | 736903 | 11736903 Co Ltd | 0              | Active | Yes           | AA736903      | 36903         |
    | ORG1736904 | 11736904 | 736904 | 11736904 Co Ltd | 0              | Active | Yes           | AA736904      | 36904         |
    | ORG1736905 | 11736905 | 736905 | 11736905 Co Ltd | 0              | Active | Yes           | AA736905      | 36905         |	

    ## Check the Organisation details in CRM
    #Then  the CRM Organisation table contains the following values
    #| UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber |
    #| 10017369 | 117369 | 10017369 Co Ltd | Active | AA017369      | 17369         |
    #| 11736901 | 736901 | 11736901 Co Ltd | Active | AA736901      | 36901         |
    #| 11736902 | 736902 | 11736902 Co Ltd | Active | AA736902      | 36902         |
    #| 11736903 | 736903 | 11736903 Co Ltd | Active | AA736903      | 36903         |
    #| 11736904 | 736904 | 11736904 Co Ltd | Active | AA736904      | 36904         |
    #| 11736905 | 736905 | 11736905 Co Ltd | Active | AA736905      | 36905         |	

@AcceptanceTest @InProgress
Scenario: J033 Set up dbo.Organisation data
    # 110 Active Organisations with normal names and addresses
    Given the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                                        | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10029426 | 121585 | ABM TRAINING (UK) LTD                       | 0              | Active | Yes           | ?             | ?             | 18 Miles Road          | Clifton                | Bristol                | ?                      | ?                      | ?                      | BS8 2JW   |
    | 10028009 | 121431 | ABSOLUTE TRAINING SOLUTIONS LTD             | 0              | Active | Yes           | AA121431      | 121431        | 12 Highgate Centre     | Highgate Square        | Birmingham             | ?                      | ?                      | ?                      | B12 0DX   |
    | 10024597 | 126897 | ACADEMY TRAINING GROUP LIMITED              | 0              | Active | Yes           | ?             | ?             | 16 St. Thomas Street   | Bristol                | Avon                   | ?                      | ?                      | ?                      | BS1 6JJ   |
    | 10023357 | 138720 | ACHIEVING EXCELLENCE UK LTD                 | 0              | Active | Yes           | ?             | ?             | 20 Bothwell Road       | ?                      | ?                      | ?                      | Hamilton               | South Lanarkshire      | ML3 0AY   |
    | 10028693 | 118999 | ADVANCE HOUSING AND SUPPORT LIMITED         | 0              | Active | Yes           | ?             | 118999        | 43 Hill Avenue         | ?                      | ?                      | ?                      | Amersham               | Buckinghamshire        | HP6 5BX   |
    | 10029699 | 121748 | AIM SKILLS DEVELOPMENT LIMITED              | 0              | Active | Yes           | AA121748      | 121748        | 1 Ambassador House     | Wolseley Road          | ?                      | ?                      | Harrow                 | Middlesex              | HA3 5RT   |
    | 10020199 | 140188 | ALABARE CHRISTIAN CARE CENTRES              | 0              | Active | Yes           | AA140188      | 140188        | 14 Woolton Lodge       | Woolton Hill           | ?                      | ?                      | Newbury                | Berkshire              | RG20 9SU  |
    | 10022877 | 127577 | ASHORNE HILL MANAGEMENT COLLEGE             | 0              | Active | Yes           | ?             | ?             | 1 William Street       | ?                      | ?                      | ?                      | Windsor                | Berkshire              | SL4 1BB   |
    | 10026573 | 119003 | BACKSTAGE CENTRE LIMITED                    | 0              | Active | Yes           | ?             | 119003        | 14 Daisy Way           | High Lane              | ?                      | ?                      | Stockport              | Cheshire               | SK6 8EF   |
    | 10027317 | 134019 | BE A BETTER YOU TRAINING LIMITED            | 0              | Active | Yes           | ?             | ?             | 6 Widbury Gardens      | ?                      | ?                      | ?                      | ?                      | ?                      | SG12 7AT  |
    | 10021481 | 125481 | BEECHWOOD COMMUNITY TRUST LIMITED           | 0              | Active | Yes           | AA125481      | ?             | 75 Bell Street         | Reigate                | Surrey                 | ?                      | ?                      | ?                      | RH2 7AN   |
    | 10029952 | 121535 | BPP PROFESSIONAL EDUCATION LIMITED          | 0              | Active | Yes           | AA121535      | ?             | 11 Gainsborough Close  | Woodley                | ?                      | ?                      | Reading                | Berkshire              | RG5 4HD   |
    | 10021602 | 118238 | BRITISH TRANSPORT POLICE AUTHORITY          | 0              | Active | Yes           | AA118238      | ?             | 1 Bennell court        | West Street            | Camberton              | Cambridge              | ?                      | ?                      | CB3 7DS   |
    | 10022406 | 125406 | BUSINESS DEVELOPMENT MIDLANDS LTD           | 0              | Active | Yes           | ?             | ?             | 105 Queens Road        | ?                      | ?                      | ?                      | Reading                | Berkshire              | RG1 4DA   |
    | 10029247 | 119014 | C.T.S. TRAINING LIMITED                     | 0              | Active | Yes           | ?             | ?             | 26 Old Hall Street     | Hanley                 | Stoke on Trent         | ?                      | ?                      | ?                      | ST1 3AW   |
    | 10020172 | 122759 | CARE-EX SERVICES LIMITED                    | 0              | Active | Yes           | AA122759      | ?             | 2 Grenville Buildings  | 12 Cherry Street       | ?                      | ?                      | Birmingham             | West Midlands          | B2 5AR    |
    | 10028380 | 125380 | CENTRAL VETERINARY SERVICES LIMITED         | 0              | Active | Yes           | AA125380      | ?             | 17 Wood Street         | ?                      | ?                      | ?                      | Barnet                 | Hertfordshire          | EN5 4AT   |
    | 10020827 | 127427 | CHESTERFIELD BUSINESS COLLEGE LIMITED       | 0              | Active | Yes           | ?             | ?             | 8 Beaumont Gate        | Shenley Hill           | ?                      | ?                      | Radlett                | Hertfordshire          | WD7 7AR   |
    | 10021671 | 126671 | CHIEF ASSESSMENTS LIMITED                   | 0              | Active | Yes           | AA126671      | ?             | 5 Westwood Court       | Brunel Road            | Totton                 | Southampton            | ?                      | ?                      | SO40 3WX  |
    | 10026921 | 131280 | CHRIST THE REDEEMER COLLEGE                 | 0              | Active | Yes           | AA131280      | ?             | 10 St. Mary at Hill    | London                 | ?                      | ?                      | ?                      | ?                      | EC3R 8EE  |
    | 10024320 | 139146 | CHRYSOS H.R. SOLUTIONS LIMITED              | 0              | Active | Yes           | AA139146      | ?             | 37a Star Street        | ?                      | ?                      | ?                      | Ware                   | Hertfordshire          | SG12 7AA  |
    | 10025390 | 130819 | CLARKSON EVANS TRAINING LIMITED             | 0              | Active | Yes           | AA130819      | ?             | 27 Kingfisher Court    | Hambridge Lane         | ?                      | ?                      | Newbury                | Berkshire              | RG14 5SJ  |
    | 10026576 | 119008 | COGENT SKILLS TRAINING LIMITED              | 0              | Active | Yes           | ?             | ?             | 111 Hagley Road        | Edgbaston              | ?                      | ?                      | Birmingham             | West Midlands          | B16 8LB   |
    | 10020068 | 125568 | COMMUNITY TRAINING PORTAL LIMITED           | 0              | Active | Yes           | AA125568      | 125568        | 12 Runnymede Gardens   | Whitton                | ?                      | ?                      | Twickenham             | Middlesex              | TW2 7BS   |
    | 10027433 | 121575 | CONSTRUCTION GATEWAY LIMITED                | 0              | Active | Yes           | ?             | 121575        | 88 Ashburton Road      | ?                      | ?                      | ?                      | Hugglescote            | Coalville              | LE67 2HB  |
    | 10020198 | 119188 | CONSTRUCTION WORKS (HULL) LIMITED           | 0              | Active | Yes           | AA119188      | 119188        | 6 Clyde Street         | Canterbury             | Kent                   | ?                      | ?                      | ?                      | CT1 1NA   |
    | 10025961 | 112126 | CQM TRAINING AND CONSULTANCY LIMITED        | 0              | Active | Yes           | AA112126      | ?             | 139 High Street        | Beckenham              | Kent                   | ?                      | ?                      | ?                      | BR3 1AG   |
    | 10024921 | 128121 | CREATIVE SUPPORT LIMITED                    | 0              | Active | Yes           | AA128121      | ?             | 6 Widbury Gardens      | ?                      | ?                      | ?                      | ?                      | ?                      | SG12 7AT  |
    | 10020303 | 118154 | DEVELOP TRAINING LIMITED                    | 0              | Active | Yes           | ?             | 118154        | 2 Sylvanus             | Wooden Hill            | ?                      | ?                      | Bracknell              | Berkshire              | KG12 8XX  |
    | 10026332 | 130939 | DIGITAL PENINSULA NETWORK LIMITED           | 0              | Active | Yes           | AA130939      | ?             | 1 Ashley Cout          | The High Street        | ?                      | ?                      | West Dryton            | Middlesex              | UB7 7DN   |
    | 10024089 | 138557 | DORAN SCOTT WILLIAMS & CO LTD               | 0              | Active | Yes           | AA138557      | 138557        | 230 Wharfdale Road     | Winnersh Triangle      | ?                      | ?                      | Wokingham              | Berkshire              | RG41 5TP  |
    | 10026277 | 121424 | DYNAMIC COLLEGE LIMITED                     | 0              | Active | Yes           | ?             | ?             | 67 High Street         | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 3AF   |
    | 10028038 | 139101 | EAST ESSEX VOCATIONAL TRAINING LIMITED      | 0              | Active | Yes           | AA139101      | 139101        | 2 Sylvanus             | Wooden Hill            | ?                      | ?                      | Bracknell              | Berkshire              | KG12 8XX  |
    | 10020019 | 121690 | EGLANTINE CATERING LIMITED                  | 0              | Active | Yes           | AA121690      | 121690        | 19 Watling Street      | Canterbury             | Kent                   | ?                      | ?                      | ?                      | CT1 2UA   |
    | 10029332 | 121246 | ELEV8 TRAINING LIMITED                      | 0              | Active | Yes           | AA121246      | ?             | 15 Albert Road         | Middlesbrough          | North Yorkshire        | ?                      | ?                      | ?                      | TS1 1PQ   |
    | 10026843 | 126643 | ELIESHA TRAINING LIMITED                    | 0              | Active | Yes           | ?             | 126643        | 1 Ashley Court         | Cyncoed                | ?                      | ?                      | Cardiff                | ?                      | CF23 6JG  |
    | 10023898 | 121258 | ENABLING DEVELOPMENT OPPORTUNITIES LTD      | 0              | Active | Yes           | AA121258      | 121258        | 58 Uxbridge Road       | Ealing                 | ?                      | ?                      | ?                      | ?                      | W5  2ST   |
    | 10028919 | 121558 | EXCEED TRAINING COMPANY LIMITED             | 0              | Active | Yes           | AA121558      | 121558        | 4 White Oak Square     | London Road            | ?                      | ?                      | Swanley                | Kent                   | BR8 7AG   |
    | 10026317 | 126317 | FLEETMASTER TRAINING LIMITED                | 0              | Active | Yes           | ?             | ?             | 1 Cadogan Square       | ?                      | ?                      | ?                      | Cadogan Street         | Glasgow                | G2 7HF    |
    | 10027599 | 122475 | FLOORTRAIN (GB) LIMITED                     | 0              | Active | Yes           | AA122475      | 122475        | 301 Histon Road        | Cambridge              | ?                      | ?                      | ?                      | ?                      | CB4 3NF   |
    | 10026062 | 121744 | FOCUSING FIRST ON PEOPLE LIMITED            | 0              | Active | Yes           | AA121744      | ?             | 6 Ambassador Place     | Stockport Road         | Altincham              | ?                      | ?                      | Cheshire               | WA15 8DB  |
    | 10029887 | 139926 | GECKO PROGRAMMES LIMITED                    | 0              | Active | Yes           | ?             | ?             | 58 Murray Place        | Stirling               | ?                      | ?                      | ?                      | ?                      | FK8 2BP   |
    | 10027893 | 121552 | GK APPRENTICESHIPS LIMITED                  | 0              | Active | Yes           | ?             | 121552        | 19 Watling Street      | Canterbury             | Kent                   | ?                      | ?                      | ?                      | CT1 2UA   |
    | 10023829 | 118781 | GLOBAL SKILLS TRAINING LTD                  | 0              | Active | Yes           | AA118781      | 118781        | 2 Stratfield Saye      | 20-22 Wellington Road  | ?                      | ?                      | ?                      | ?                      | BH8 8JN   |
    | 10021323 | 119109 | GROUNDWORK NORTH EAST                       | 0              | Active | Yes           | ?             | 119109        | 81a Christchurch Road  | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH1 1ES   |
    | 10022880 | 118474 | GWE BUSINESS WEST LTD                       | 0              | Active | Yes           | AA118474      | ?             | 49 Fife Road           | Kingston               | ?                      | ?                      | ?                      | Surrey                 | KT1 1SF   |
    | 10029337 | 140349 | HARPER CRAVEN ASSOCIATES LIMITED            | 0              | Active | Yes           | ?             | ?             | 71 Patrick Way         | ?                      | ?                      | ?                      | Aylesbury              | Buckinghamshire        | HP21 9XJ  |
    | 10022133 | 125133 | HEALTH AND FITNESS EDUCATION LIMITED        | 0              | Active | Yes           | ?             | 125133        | 43 Townhead Street     | Sheffield              | South Yorkshire        | ?                      | ?                      | ?                      | S1 2EB    |
    | 10021278 | 139924 | HIGHFIELDS COMMUNITY ASSOCIATION            | 0              | Active | Yes           | AA139924      | 139924        | 39a Victoria Road      | Surbiton               | Surrey                 | ?                      | ?                      | ?                      | KT6 4JL   |
    | 10026620 | 125620 | HYBRID TECHNICAL SERVICES LIMITED           | 0              | Active | Yes           | AA125620      | ?             | 11 Kingsmead Square    | Bath                   | Avon                   | ?                      | ?                      | ?                      | BA1 2AB   |
    | 10029736 | 121605 | IGNITE SPORT UK LIMITED                     | 0              | Active | Yes           | ?             | ?             | 16 Emmanuel Court      | Mill Street            | ?                      | ?                      | Sutton Coldfield       | West Midlands          | B72 1TJ   |
    | 10023326 | 125326 | IMPACT TRAINING SOLUTIONS LTD.              | 0              | Active | Yes           | ?             | ?             | 36 Portland Road       | Kilmarnock             | ?                      | ?                      | ?                      | ?                      | KA1 2DL   |
    | 10029419 | 138696 | INTERACTIVE PRO LIMITED                     | 0              | Active | Yes           | AA138696      | 138696        | 7 Lansdowne Place      | 17 Holdenhurst Road    | ?                      | ?                      | Bournemouth            | Dorset                 | BH8 8EW   |
    | 10023908 | 118720 | JEWEL TRAINING & DEVELOPMENT LIMITED        | 0              | Active | Yes           | AA118720      | 118720        | 58 Greystone Road      | Antrim                 | ?                      | ?                      | ?                      | ?                      | BT41 1JZ  |
    | 10021254 | 131092 | JFC TRAINING COLLEGE LTD                    | 0              | Active | Yes           | ?             | 131092        | 33 London Road         | Blackwater             | Camberley              | Surrey                 | ?                      | ?                      | GU17 0AB  |
    | 10028542 | 140687 | JHC SKILLS FOR BUSINESS LIMITED             | 0              | Active | Yes           | AA140687      | ?             | 1 Straw Close          | Caterham               | ?                      | ?                      | ?                      | Surrey                 | CR3 5FZ   |
    | 10024415 | 139048 | KEYSTONE TRAINING LTD                       | 0              | Active | Yes           | ?             | 139048        | 7a Deans Court         | Bicester               | ?                      | ?                      | Oxon                   | Oxfordshire            | OX6 7XZ   |
    | 10025748 | 140369 | KEYTURN TRAINING LIMITED                    | 0              | Active | Yes           | AA140369      | 140369        | 9 Ronaldshaw Park      | Ayr                    | ?                      | ?                      | ?                      | ?                      | KA7 2TJ   |
    | 10025969 | 121750 | KMF PRECISION SHEET METAL LIMITED           | 0              | Active | Yes           | AA121750      | 121750        | 12a Holywell Hill      | ?                      | ?                      | ?                      | St Albans              | Hertfordshire          | AL1 1BZ   |
    | 10026629 | 140373 | LAMMORE CONSULTING LIMITED                  | 0              | Active | Yes           | AA140373      | 140373        | 5 Riversdale Road      | Thames Ditton          | Surrey                 | ?                      | ?                      | ?                      | KT7 0QL   |
    | 10027803 | 121577 | LD TRAINING SERVICES LIMITED                | 0              | Active | Yes           | ?             | 121577        | 22 Church Street       | ?                      | ?                      | ?                      | Ware                   | Hertfordshire          | SG12 9EH  |
    | 10027616 | 121773 | LINDEN MANAGEMENT (UK) LIMITED              | 0              | Active | Yes           | ?             | ?             | 9 Bottisham Close      | Lower Earley           | ?                      | ?                      | Reading                | Berkshire              | RG6 4ED   |
    | 10027453 | 133304 | LONDON PROFESSIONAL COLLEGE LTD             | 0              | Active | Yes           | ?             | 133304        | 37a Star Street        | ?                      | ?                      | ?                      | Ware                   | Hertfordshire          | SG12 7AA  |
    | 10020380 | 138726 | LOVE AND TATE LIMITED                       | 0              | Active | Yes           | AA138726      | ?             | 60 Union Street        | Aberdeen               | ?                      | ?                      | ?                      | ?                      | AB10 1BB  |
    | 10026311 | 118869 | LUL NOMINEE BCV LIMITED                     | 0              | Active | Yes           | AA118869      | ?             | 23 Millpond Court      | Addlestone             | Surrey                 | ?                      | ?                      | ?                      | KT15 2JY  |
    | 10023787 | 121542 | MERCURY TRAINING SERVICES LTD               | 0              | Active | Yes           | ?             | ?             | 71 London Road         | ?                      | ?                      | ?                      | Sevenoaks              | Kent                   | TN13 1AX  |
    | 10021221 | 121667 | MERSEY CARE NHS FOUNDATION TRUST            | 0              | Active | Yes           | AA121667      | ?             | 5 Chiswick High Road   | London                 | ?                      | ?                      | ?                      | ?                      | W4 5RG    |
    | 10027518 | 121526 | MILLENNIUM ACADEMY LTD                      | 0              | Active | Yes           | AA121526      | 121526        | 1 Ashley Court         | Cyncoed                | ?                      | ?                      | Cardiff                | ?                      | CF23 6JG  |
    | 10026268 | 119162 | MINERAL PRODUCTS QUALIFICATIONS COUNCIL     | 0              | Active | Yes           | AA119162      | 119162        | 25 Aycliffe Road       | ?                      | ?                      | ?                      | Borehamwood            | Hertfordshire          | WD6 4JP   |
    | 10027791 | 120863 | MORSON HUMAN RESOURCES LIMITED              | 0              | Active | Yes           | AA120863      | ?             | 1 Gurney Lane          | Cringleford            | ?                      | ?                      | Norwich                | Norfolk                | NR4 7SB   |
    | 10026650 | 121346 | N-GAGED TRAINING & RECRUITMENT LIMITED      | 0              | Active | Yes           | AA121346      | ?             | 23 Millpond Court      | Addlestone             | Surrey                 | ?                      | ?                      | ?                      | KT15 2JY  |
    | 10022596 | 121776 | ONE TO ONE SUPPORT SERVICES LIMITED         | 0              | Active | Yes           | ?             | ?             | 2 Westbourne House     | Wheatlands Estate      | ?                      | ?                      | Heston                 | Middlesex              | TW5 0SA   |
    | 10021243 | 118360 | OXFORD HEALTH NHS FOUNDATION TRUST          | 0              | Active | Yes           | ?             | 118360        | 74 Warwick Road        | Kenilworth             | Warwickshire           | ?                      | ?                      | ?                      | CV8 1HL   |
    | 10029980 | 131306 | PARTNERS IN MANAGEMENT LIMITED              | 0              | Active | Yes           | AA131306      | ?             | 33 Waldorf Heights     | Blackwater             | Camberley              | Surrey                 | ?                      | ?                      | GU17 9JH  |
    | 10023115 | 118445 | PBC ASSOCIATES LIMITED                      | 0              | Active | Yes           | ?             | 118445        | 116 College Road       | Harrow                 | Middlesex              | ?                      | ?                      | ?                      | HA1 1BQ   |
    | 10021539 | 125539 | PET-XI TRAINING LIMITED                     | 0              | Active | Yes           | AA125539      | 125539        | 504 Bunyan Court       | Barbican               | London                 | ?                      | ?                      | ?                      | EC2Y 8DH  |
    | 10023592 | 121272 | PLATO TRAINING (UK) LTD                     | 0              | Active | Yes           | AA121272      | ?             | 5 Westwood Court       | Brunel Road            | Totton                 | Southampton            | ?                      | ?                      | SO40 3WX  |
    | 10024547 | 138255 | PREMIER PEOPLE SOLUTIONS LIMITED            | 0              | Active | Yes           | ?             | ?             | 13 Coombe Road         | New Maldon             | Surrey                 | ?                      | ?                      | ?                      | KT3 4PX   |
    | 10021391 | 118492 | PROFESSIONAL TRAINING SOLUTIONS LIMITED     | 0              | Active | Yes           | AA118492      | ?             | 139 High Street        | Beckenham              | Kent                   | ?                      | ?                      | ?                      | BR3 1AG   |
    | 10027769 | 133767 | PROMISE TRAINING CENTRE LIMITED             | 0              | Active | Yes           | AA133767      | 133767        | 46 Abergarw Road       | Brynmenyn              | Bridgend               | ?                      | ?                      | ?                      | CF32 9LF  |
    | 10028341 | 125341 | QUESTIONS & ANSWERS CIC                     | 0              | Active | Yes           | AA125341      | ?             | 8 Tudor Way            | Petts Wood             | Kent                   | ?                      | ?                      | ?                      | BR1 1DZ   |
    | 10023871 | 122643 | RESULTS CONSORTIUM LIMITED                  | 0              | Active | Yes           | AA122643      | ?             | 4 Red Lion Court       | Alexandra Road         | ?                      | ?                      | Hounslow               | Middlesex              | TW3 1JS   |
    | 10021596 | 126196 | ROYAL HOSPITAL FOR NEURO-DISABILITY         | 0              | Active | Yes           | ?             | ?             | 23 Keytes Lane         | Barford                | ?                      | ?                      | Warwick                | Warwickshire           | CV35 8EP  |
    | 10022729 | 128029 | SELECTION TRAINING LIMITED                  | 0              | Active | Yes           | AA128029      | 128029        | 29 Church Street       | Basingstoke            | ?                      | ?                      | ?                      | ?                      | RG21 7QQ  |
    | 10021585 | 126476 | SHEARS ACADEMY LIMITED                      | 0              | Active | Yes           | ?             | 126476        | 25 High Street         | Cobham                 | Surrey                 | ?                      | ?                      | ?                      | KT11 3DH  |
    | 10023496 | 121425 | SHL TRAINING SOLUTIONS LTD                  | 0              | Active | Yes           | ?             | ?             | 2 Jenner Road          | Guildford              | Surrey                 | ?                      | ?                      | ?                      | GU1 3PL   |
    | 10027642 | 121311 | SIDDHI TRAINING & CONSULTANCY LIMITED       | 0              | Active | Yes           | AA121311      | ?             | 23 Millpond Court      | Addlestone             | Surrey                 | ?                      | ?                      | ?                      | KT15 2JY  |
    | 10022567 | 121340 | SIMIAN RISK MANAGEMENT LIMITED              | 0              | Active | Yes           | ?             | ?             | 71 Patrick Way         | ?                      | ?                      | ?                      | Aylesbury              | Buckinghamshire        | HP21 9XJ  |
    | 10028965 | 121486 | SIMPLY ONE STOP LIMITED                     | 0              | Active | Yes           | ?             | 121486        | 95 Church Way          | Iffley Village         | Oxford                 | ?                      | ?                      | ?                      | OX4 4EG   |
    | 10028441 | 131640 | SPORT SUPPORT SERVICES LIMITED              | 0              | Active | Yes           | AA131640      | ?             | 4 Mount Ephraim Rd     | Tunbridge Wells        | Kent                   | ?                      | ?                      | ?                      | TN1 1EE   |
    | 10023992 | 121274 | SUTTON COLDFIELD TRAINING LIMITED           | 0              | Active | Yes           | AA121274      | ?             | 5 Strand Court         | Bath Road              | ?                      | ?                      | Cheltenham             | Gloucestershire        | GL53 7LW  |
    | 10023492 | 132209 | TEMPLEGATE TRAINING ACADEMY C.I.C.          | 0              | Active | Yes           | AA132209      | ?             | 1 Bell Street          | ?                      | ?                      | ?                      | Maidenhead             | Berkshire              | SL6 1BU   |
    | 10028007 | 121485 | THAT NAIL PLACE LIMITED                     | 0              | Active | Yes           | ?             | ?             | 6 Ambassador Place     | Stockport Road         | Altincham              | ?                      | ?                      | Cheshire               | WA15 8DB  |
    | 10020932 | 138899 | THE COLLEGES' PARTNERSHIP LIMITED           | 0              | Active | Yes           | AA138899      | ?             | 66 St Andrews Road     | Hanley On Thames       | Oxon                   | ?                      | ?                      | ?                      | RG9 1JE   |
    | 10022283 | 131008 | THE EDGE WORKS LIMITED                      | 0              | Active | Yes           | ?             | 131008        | 1 Ashley Cout          | The High Street        | ?                      | ?                      | West Dryton            | Middlesex              | UB7 7DN   |
    | 10026397 | 123033 | THE NVQ TRAINING CENTRE LIMITED             | 0              | Active | Yes           | ?             | ?             | 35 Bridge Street       | ?                      | ?                      | ?                      | Newport                | Gwent                  | NP20 4BH  |
    | 10028238 | 138597 | TOTAL EXCELLENCE CENTRE LIMITED             | 0              | Active | Yes           | AA138597      | 138597        | 43 Hill Avenue         | ?                      | ?                      | ?                      | Amersham               | Buckinghamshire        | HP6 5BX   |
    | 10027651 | 125472 | TOTAL SUPPORT TRAINING LIMITED              | 0              | Active | Yes           | AA125472      | ?             | 884 Plymouth Road      | ?                      | ?                      | ?                      | Slough                 | Berkshire              | SL1 4SH   |
    | 10028120 | 121530 | TOUCHSTONE EDUCATIONAL SOLUTIONS LTD        | 0              | Active | Yes           | AA121530      | ?             | 49 Lyon Meade          | Stanmore               | London                 | ?                      | ?                      | ?                      | HA7 1HZ   |
    | 10029985 | 121462 | TRAINING 4 U SERVICES (UK) LTD              | 0              | Active | Yes           | ?             | 121462        | 4 Red Lion Court       | Alexandra Road         | ?                      | ?                      | Hounslow               | Middlesex              | TW3 1JS   |
    | 10028275 | 140282 | TRAINING BYTE SIZE LIMITED                  | 0              | Active | Yes           | ?             | 140282        | 10 Albyn Place         | Edinburgh              | ?                      | ?                      | ?                      | ?                      | EH2 4NG   |
    | 10025197 | 121814 | UNIVERSITY CENTRE QUAYSIDE LIMITED          | 0              | Active | Yes           | ?             | ?             | 39 Halstead Road       | Earls Colne            | ?                      | ?                      | Colchester             | Essex                  | CO6 2NL   |
    | 10023229 | 138679 | VENTURE FORWARD LIMITED                     | 0              | Active | Yes           | AA138679      | 138679        | 5 Queens Street        | Norwich                | Norfolk                | ?                      | ?                      | ?                      | NR2 4SG   |
    | 10026108 | 124594 | VIRTUAL ALLIANCE LIMITED                    | 0              | Active | Yes           | AA124594      | 124594        | 12-50 Kingsgate Road   | Kingston upon Thames   | Surrey                 | ?                      | ?                      | ?                      | KT2 5AA   |
    | 10025700 | 121812 | VISION TRAINING (NORTH EAST) LIMITED        | 0              | Active | Yes           | AA121812      | ?             | 80 Lapins Lane         | Kingshill              | ?                      | ?                      | West Malling           | Kent                   | ME19 4LE  |
    | 10029843 | 139925 | WALTHAM INTERNATIONAL COLLEGE LIMITED       | 0              | Active | Yes           | ?             | 139925        | 6 Eghams Court         | Boston Drive           | ?                      | ?                      | Bourne End             | Buckinghamshire        | SL8 5YS   |
    | 10029309 | 119033 | WAYS 2 WORK (DONCASTER) LIMITED             | 0              | Active | Yes           | AA119033      | 119033        | 71 London Road         | ?                      | ?                      | ?                      | Sevenoaks              | Kent                   | TN13 1AX  |
    | 10029829 | 121707 | WELCOME SKILLS LIMITED                      | 0              | Active | Yes           | AA121707      | 121707        | 13 Coniston Road       | ?                      | ?                      | ?                      | Chippenham             | Wiltshire              | SN14 0PX  |
    | 10026128 | 139032 | WHITE ROSE TRAINING LIMITED                 | 0              | Active | Yes           | AA139032      | 139032        | 35 The Avenue          | Southampton            | ?                      | ?                      | ?                      | ?                      | SO17 1XN  |
    | 10027269 | 121719 | WORKFORCE TRAINING & DEVELOPMENT LTD        | 0              | Active | Yes           | AA121719      | 121719        | 27 Linford Wood        | Linford Forum          | Rockingham Drive       | Milton Keynes          | ?                      | ?                      | MK14 6LY  |

@AcceptanceTest @InProgress
Scenario: J034 Set up Orgs in PaaS and CRM with the eight recognised status values
    # Add data to dbo.Organisations
	Given the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018991 | 118991 | 10018991 Co Ltd | 0              | Active                | Yes           | AA118991      | 118991        | 111 Hagley Road        | Edgbaston              | ?                      | ?                      | Birmingham             | West Midlands          | B16 8LB   |
    | 10018992 | 118992 | 10018992 Co Ltd | 0              | Deleted               | Yes           | AA118992      | 118992        | 11 Kingsmead Square    | Bath                   | Avon                   | ?                      | ?                      | ?                      | BA1 2AB   |
    | 10018993 | 118993 | 10018993 Co Ltd | 0              | Dissolved             | Yes           | AA118993      | 118993        | 71 Beckenham Lane      | Shortlands             | ?                      | ?                      | Bromley                | Kent                   | BR2 0JB   |
    | 10018994 | 118994 | 10018994 Co Ltd | 0              | Inactive              | Yes           | AA118994      | 118994        | 67 High Street         | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 3AF   |
    | 10018995 | 118995 | 10018995 Co Ltd | 0              | In Liquidation        | Yes           | AA118995      | 118995        | 1 Wellington Square    | Ayr                    | ?                      | ?                      | ?                      | ?                      | KA7 1EN   |
	| 10018996 | 118996 | 10018996 Co Ltd | 0              | Locked Restructure    | Yes           | AA118996      | 118996        | 51 Blackmore           | ?                      | ?                      | ?                      | Letchworth             | Hertfordshire          | SG6 2SZ   |
    | 10018997 | 118997 | 10018997 Co Ltd | 0              | In Administration     | Yes           | AA118997      | 118997        | 12 Aintree Road        | Perivale               | ?                      | ?                      | Greenford              | Middlesex              | UB6 7LA   |
    | 10018998 | 118998 | 10018998 Co Ltd | 0              | Provider Under Change | Yes           | AA118998      | 118998        | 6 Ambassador Place     | Stockport Road         | Altincham              | ?                      | ?                      | Cheshire               | WA15 8DB  |

@AcceptanceTest @InProgress
Scenario: J036 Check Legal Contract Feed
    # Check Atom feed data for an an ItemType zero (Approval) message
    Then  the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version '1' of actual contract number '1619F-398'
    And   the ItemType '0' event for version '1' of actual contract number '1619F-398' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Check the ContractManagement.AtomFeedItem (CM) feed for specific items and values
    And   the Legal Contract Feed includes the following values
    | UKPRN    | ContractNumber | ContractVersion | ItemType | AllocationRef | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    | 10017398 | 1619F-398      | 1               | 0        | 16LR-3981     | 10217123                  | 10217123 Co Ltd              |
    | 10017398 | 1619F-398      | 1               | 0        | NMF-3981      | 10217123                  | 10217123 Co Ltd              |
    | 10017398 | 1619F-398      | 1               | 0        | SSF-3981      | 10217123                  | 10217123 Co Ltd              |
    | 10017398 | 1619F-398      | 1               | 0        | 16LR-3982     | 10417123                  | 10417123 Co Ltd              |
    | 10017398 | 1619F-398      | 1               | 0        | NMF-3982      | 10417123                  | 10417123 Co Ltd              |
    | 10017398 | 1619F-398      | 1               | 0        | SSF-3982      | 10417123                  | 10417123 Co Ltd              |

@AcceptanceTest @InProgress
Scenario: J037 Check ADP Feed
    # Check the AllocationDelivery.AllocationDeliveryEntry (ADP) feed for specific items and values
    Then  the ADP feed includes the following values
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | ContractVersionNumber | SubVersionNumber | AllocationNumber | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    | NewContractAllocationApproved     | 0      | NCS-295        | 2                     | 0                | NCSP-295         | 10117295                  | 10117295 Co Ltd              | 
    | AmendedContractAllocationApproved | 1      | NCS-295        | 2                     | 0                | NCSP-295         | 10117295                  | 10117295 Co Ltd              | 
    | ContractAllocationActualsReceived | 2      | [ContractNo]   | 2                     | 0                | [AllocRef_NCSP]  | 10117295                  | 10117295 Co Ltd              | 
    | ContractAllocationPaymentReceived | 3      | NCS-295        | 2                     | 0                | NCSP-295         | 10117295                  | 10117295 Co Ltd              | 

@AcceptanceTest @InProgress
Scenario: J038 Delete all Subnominal Aggregations data
    Given there is no Subnominal data in CRM or PaaS for the following contract allocations
   #And   there is no Subnominal data for the following contract allocations
   #And   there is no Subnominal or event history data for the following contract allocations
    | AllocationRef |
    | Jan           |
    | Feb           |
    | Mar           |
    | Apr           |
    | May           |
    | Jun           |
	| Jul           |
    | Aug           |
    | Sep           |
	| Oct           |
    | Nov           |
    | Dec           |

@AcceptanceTest @InProgress
Scenario: J042 Delete all evidence of a deliverable
    # Remove a deliverable and its deliverable periods
	Given the following deliverables have been removed from all versions of the contract in CRM and PaaS
    | UKPRN    | ContractNumber | AllocRef   | DeliverableCode |
    | 10018204 | [ContractNo]   | [AllocRef] | 13              |
    | 10018204 | [ContractNo]   | [AllocRef] | 14              |
    | 10047425 | NLAP-155       | YNLP-155   | 5               |
    | 10047425 | NLAP-202       | ANLP-202   | 5               |

@AcceptanceTest @InProgress
Scenario: J043 Count the deliverable periods in PaymentSchedule.DeliverablePayment
    ## Check that the deliverable details have been removed from PaaS
    #Then  there are '0' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'ANLP-123' for DeliverableCode '5'
    #Then  there are '15' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'YNLP-123' for DeliverableCode '5'
    #Then  there are '0' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber '[AllocRef]' for DeliverableCode '13'

	# Check the deliverable count in PaaS for D5
    Then  there are '15' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'ANLP-887' for DeliverableCode '5'
    And   there are '15' deliverable periods on the PaymentSchedule.DeliverablePayment table for version '1' of AllocationNumber 'YNLP-887' for DeliverableCode '5'

@AcceptanceTest @InProgress
Scenario: J044 Terminate a contract using the CRM UI
    # Request termination of the contract via the CRM UI eg ...
    When  CRM user 'CRM Integration' initiates contract termination for Contract 'NLAP-774' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason | TerminationComments |
   #| 05/10/2018               | 06/10/2018              | No                          | Provider Change   | Corporate Merger    |
    | 05/10/2018               | 06/10/2018              | Yes                         | Other             | Suspected Fraud     |

#	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
#   And   the user forwards the termination request for manager approval via SDK
#
#    # Check CONTRACT version, status and dates in CRM
#    Then  the following contract values are present in CRM
#    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10017774 | NLAP-774       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
#    | 10017774 | ESFA-774       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2018        | 31/03/2019      | ?             |
#
#    # Check CONTRACT termination values in CRM
#    And   the following contract termination values are present in CRM
#    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractTerminationDate | TerminationComments  |
#    | NLAP-774       | 1                     | 0                        | 06/10/2018              | Suspected fraud      |
#
#    # Check ALLOCATION termination values in CRM
#    And   the following allocation termination values are present in CRM
#    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | StopNewStartsDate | AllocationTerminationDate |
#    | ANLP-774         | 1                     | 0                        | 05/10/2018        | 06/10/2018                |
#    | YNLP-774         | 1                     | 0                        | 05/10/2018        | 06/10/2018                |
#    
#    # Check the current state of the Tasks for this contract
#    And   the following Tasks are present against version '1' of contract 'NLAP-774' for provider '10017774'
#    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Termination Initiation Approval    | 10017774 - 10017774 Co Ltd     | NLAP-774       | Grace Green               | Contract Managers Team   | Open            | Not Started      |

@AcceptanceTest @InProgress
Scenario: J046 Check that funding claim data is not in PaaS 
    # Check that the claim for 1619LR1718 has not arrived in PaaS
    Then  there is no claim data in the PaaS funding claim tables for any of the following
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | 
    | 10017785 | 1718          | Year End         | 1619LR1718          | 16LR-785      | 

@AcceptanceTest @InProgress
Scenario: J047 Clear down Sharepoint folders 
    And   there are no files prefixed '100' in the Sharepoint 'LOANS-1819-Input-Appendices' folder
	And   there are no files prefixed '100' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
	And   there are no files prefixed '100' in the Sharepoint 'MAIN-1819-Input-Appendices' folder
	And   there are no files prefixed '100' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder
	And   there are no files prefixed '100' in the Sharepoint 'MAIN-1819-Output-Documents for Publication' folder
	And   there are no files prefixed '100' in the Sharepoint 'NCS-1718-Output-Documents for Publication' folder
	And   there are no files prefixed '100' in the Sharepoint '1619FUND-1718-Output-Documents for Publication' folder

@AcceptanceTest @InProgress
Scenario: J048 Delete contracts from CRM for providers 10017000-10017020
    Given there is no Contract, Task or Workflow data for UKPRN '10017000' 
    Given there is no Contract, Task or Workflow data for UKPRN '10017001' 
	Given there is no Contract, Task or Workflow data for UKPRN '10017002'
	Given there is no Contract, Task or Workflow data for UKPRN '10017003' 
	Given there is no Contract, Task or Workflow data for UKPRN '10017004' 
	Given there is no Contract, Task or Workflow data for UKPRN '10017005' 
	Given there is no Contract, Task or Workflow data for UKPRN '10017006' 
	Given there is no Contract, Task or Workflow data for UKPRN '10017007' 
	Given there is no Contract, Task or Workflow data for UKPRN '10017008' 
	Given there is no Contract, Task or Workflow data for UKPRN '10017009' 
	Given there is no Contract, Task or Workflow data for UKPRN '10017010' 
    Given there is no Contract, Task or Workflow data for UKPRN '10017011' 
	Given there is no Contract, Task or Workflow data for UKPRN '10017012' 
	Given there is no Contract, Task or Workflow data for UKPRN '10017013' 
	Given there is no Contract, Task or Workflow data for UKPRN '10017014' 
	Given there is no Contract, Task or Workflow data for UKPRN '10017015' 
	Given there is no Contract, Task or Workflow data for UKPRN '10017016' 
	Given there is no Contract, Task or Workflow data for UKPRN '10017017' 
	Given there is no Contract, Task or Workflow data for UKPRN '10017018' 
	Given there is no Contract, Task or Workflow data for UKPRN '10017019' 
    Given there is no Contract, Task or Workflow data for UKPRN '10017020'
    
#  @AcceptanceTest  <<< This causes the step to fail when pointed at OAT or DOAT
@InProgress
Scenario: J050 Create Consolidated Payment Summary Report in Sharepoint
    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    When a Consolidated Payment Summary Report is created in Sharepoint for '18/09/2022'
    # Check the above report manually

@AcceptanceTest @InProgress
Scenario: PMCK091 Create Deletion Synchronization Failure for a specified contract
    When  Clear down Deletion Synchronization Failure for contract
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017319 | SYNC-FAIL-01   | 1                     | 2                  |
    | 10017319 | SYNC-FAIL-02   | 30                    | 31                 |	

    When  Create Deletion Synchronization Failure for contract (and children)
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017319 | SYNC-FAIL-01   | 1                     | 2                  |
    | 10017319 | SYNC-FAIL-02   | 30                    | 31                 |	

    #When  Clear down Deletion Synchronization Failure for contract
    #| UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    #| 10017319 | SYNC-FAIL-01   | 1                     | 2                  |
    #| 10017319 | SYNC-FAIL-02   | 30                    | 31                 |	

@AcceptanceTest @InProgress
Scenario: PMCK092 Setup rows on ProcessedMessage tables 
	Given Clear down ProcessedMessage table in 'AllocationDelivery' schema
	When Clear down ProcessedMessage table in 'PaymentSchedule' schema
	Then Clear down ProcessedMessage table in 'ContractManagement' schema

	Given Create '150' records on ProcessedMessage table in 'AllocationDelivery' schema that are '50' days old
	When Create '150' records on ProcessedMessage table in 'PaymentSchedule' schema that are '50' days old
	Then Create '150' records on ProcessedMessage table in 'ContractManagement' schema that are '50' days old

	Given Create '150' records on ProcessedMessage table in 'AllocationDelivery' schema that are '120' days old
	When Create '150' records on ProcessedMessage table in 'PaymentSchedule' schema that are '120' days old
	Then Create '150' records on ProcessedMessage table in 'ContractManagement' schema that are '120' days old

	Given Create '150' records on ProcessedMessage table in 'AllocationDelivery' schema that are '121' days old
	When Create '150' records on ProcessedMessage table in 'PaymentSchedule' schema that are '121' days old
	Then Create '150' records on ProcessedMessage table in 'ContractManagement' schema that are '121' days old
	