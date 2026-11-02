Feature: BulkUploadValidationForCBR-007 12767

@AcceptanceTest @Withdrawn20221103
Scenario: A453 CABR-007 Bulk upload a new 1516 Mainstream contract where an equivalent Contract already exists in CRM for the given UKPRN
    Given there is no Contract, Task or Workflow data for UKPRN '10017453'
    And   there is no Organisation data for UKPRN '10017453'
    And the override date is '01/08/2015'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Genie Us Trainers' with UKPRN '10017453' and OrgId 'ORG0017453' and has 'FCS1 Test' as a manager
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 10017453 | Genie Us Trainers    | SFA-453              | MAIN-453       | 1                     |  01/08/2015       |  31/07/2016     | 46433.00      | Contract for Services | 1516   | New       | ORG0017453 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription  | CRMIntent | LEPCode    | LEPName | TenderSpecificationReference | LotReference | TenderAwardReference        | InvestmentPriority | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType |
    | 10017453 | MAIN-453       | 16AP-453      | 16-18 APPS        | MAIN                    | 01/08/2015          | 31/07/2016        | 46433.00        |         |         | Funding for Unemployed | New       |            |         |                              |              |                             |                    |                 |                     |                    |            |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16   | DeliverableDescription					  | CRMIntent |
    | MAIN-453       | 16AP-453      | 2               | 0                     | 2534.00  | 2534.00  | 1836.00  | 3634.00  | 678.00   | 1984.00  | 1502.00  | 2391.00  | 142.00   | 1387.00  | 2912.00  | 309.00   | 16-18 Apprenticeships Total Funding      | New       |
    | MAIN-453       | 16AP-453      | 4               | 3                     | 952.00   | 268.00   | 3341.00  | 808.00   | 3097.00  | 3908.00  | 3195.00  | 1921.00  | 2727.00  | 1108.00  | 322.00   | 1358.00  | 16-18 Traineeships Programme Funding	  | New       |
	| MAIN-453       | 16AP-453      | 5               | 3                     | 952.00   | 268.00   | 3341.00  | 808.00   | 3097.00  | 3908.00  | 3195.00  | 1921.00  | 2727.00  | 1108.00  | 322.00   | 1358.00  | 16-18 Traineeships Bursary Funding		  | New       |

    And   the contract exists in CRM
	And   an excel spreadsheet exists and has cell 'A2' with a UKPRN '10017453' and a file Name 'MAIN AY 1516 04022016190231 v2_10017453.xlsx'
    When  the file for syntax validation is copied from the source location to the 'Input' 
    Then  I should see a file for syntax validation success report
    And   a results report excel spreadsheet is generated in the storage
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   '[Contract] A Contract already exists for the given UKPRN, Period and dates specified' is displayed in field 'J2' on the 'Contract' tab of the result report

