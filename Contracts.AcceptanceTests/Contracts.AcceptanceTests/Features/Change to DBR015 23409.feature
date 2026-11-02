Feature: Change to DBR015 23409

@AcceptanceTest @Withdrawn20231002
Scenario: A635 Create a new 2018 NCS contract with just an NCS-C2018 allocation. Bulk update draft and check that DBR-015 is not triggered
    Given there is no Contract, Task or Workflow data for UKPRN '10017635' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | NCSC-635      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017635' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017635 Co Ltd' with UKPRN '10017635' and OrgId 'ORG0017635' and has 'FCS1 Test' as a manager 
    And   UPIN '117635' is associated with UKPRN '10017635' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017635 | 117635 | 10017635 Co Ltd | 0              | Active | Yes           | AA017635      | ?             | 

    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017635 | 10017635 Co Ltd      | ESFA-635             | NCS-635        | 1                     | 01/04/2018        | 30/09/2018      | 46251.00      |                                | Contract for Services | 2018   | New          | ORG0017635 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017635 | NCS-635        | NCSC-635      | NCS-C             | NCS-C2018               | NCS                     | 01/04/2018          | 30/09/2018        | 31443.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017635 | NCS-635        | NCSC-635      | 1               | 0                     | 31443.00  | 3933.00  | 4082.00  | 9072.00  | 5204.00  | 3741.00  | 5411.00  | Total In The Community Funding                                  | New          |             |
    | 10017635 | NCS-635        | NCSC-635      | 2               | 1                     | 9583.00   | 566.00   | 541.00   | 3333.00  | 2360.00  | 596.00   | 2187.00  | Customer Satisfaction                                           | New          |             |
    | 10017635 | NCS-635        | NCSC-635      | 3               | 1                     | 21860.00  | 3367.00  | 3541.00  | 5739.00  | 2844.00  | 3145.00  | 3224.00  | Career Management and Jobs and Learning                         | New          |             |
    | 10017635 | NCS-635        | NCSC-635      | 4               | 3                     | 7335.00   | 302.00   | 1321.00  | 3702.00  | 1242.00  | 238.00   | 530.00   | Career Management                                               | New          |             |
    | 10017635 | NCS-635        | NCSC-635      | 5               | 3                     | 14525.00  | 3065.00  | 2220.00  | 2037.00  | 1602.00  | 2907.00  | 2694.00  | Jobs and Learning                                               | New          |             |
    | 10017635 | NCS-635        | NCSC-635      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | DeliverableCode | AllocationRef | UnitCost | Total   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | 
    | 10017635 | NCS-635        | 6               | NCSC-635      | 32       | 489     | 84       | 64       | 100      | 83       | 67       | 91       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Cleardown prior to bulk amendment
    Given there are no files prefixed '10017635_NCS' in the Sharepoint 'NCS-2018-Input-Appendices' folder
    And   there are no files prefixed 'NCS NCS 2018 11062018095811 v2_A635' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NCS NCS 2018 11062018095811 v2_A635' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NCS NCS 2018 11062018095811 v2_A635' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NCS NCS 2018 11062018095811 v2_A635' in the Sharepoint 'Reports' folder

    # Change the date
    And   the override date is '18/07/2018'

    # Bulk update draft 
    And   spreadsheet 'NCS NCS 2018 11062018095811 v2_A635.xlsx' exists in the Datafiles folder and UKPRN '10017635' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder

#   # Before code fix in 23409
#   And   'Fail' is displayed in field 'J2' on the 'Contract' tab of the result report
#   And   '[Deliverable] Deliverable is not a profile Deliverable' is displayed in field 'J2' on the 'Contract' tab of the result report

	# After code fix in 23409
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

	# Tidy up
	And   the override date is reset
    