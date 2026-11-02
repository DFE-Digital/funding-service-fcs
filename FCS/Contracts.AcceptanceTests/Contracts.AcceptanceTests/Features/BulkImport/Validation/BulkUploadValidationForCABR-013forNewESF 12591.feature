Feature: BulkUploadValidationForCABR-013forNewESF 12591

@AcceptanceTest @Withdrawn20200505
Scenario: A945 CABR-013 Bulk upload a new ESF contract with Tender Award Ref duplicated in bulk file
    Given an excel spreadsheet exists and has cell 'A2' with a UKPRN '10017945' and a file Name 'ESF ESF 1420 01012016000000 Error_CABR-013_10017945.xlsx'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  I should see a file for syntax validation report
	And   syntax validation report contains '2 Contract Allocations cannot have the same Tender Award Reference within the Bulk Import file or the CRM system.'

@AcceptanceTest @Withdrawn20230123
Scenario: A946 CABR-013 Bulk upload a new ESF contract with same Tender Award Ref in bulk file and CRM
    # Inject a contract for 10017949 with a tender award reference of 29801/23-003-00-01/10017946
	# Bulk create a new contract for 10017946 with the same tender award reference as above. Fail: CABR-013
    Given there is no Contract, Task or Workflow data for UKPRN '10017949'
    And   there is no Organisation data for UKPRN '10017949'
    And   the override date is '01/04/2015'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017949 Co Ltd' with UKPRN '10017949' and OrgId 'ORG0017949' and has 'FCS1 Test' as a manager
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 10017949 | 10017949 Co Ltd      | SFA-949              | ESIF-949       | 1                     |  01/04/2015       |  31/03/2016     | 46433.00      | Contract for Services | 1420   | New       | ORG0017949 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription  | CRMIntent | LEPCode    | LEPName | TenderSpecificationReference | LotReference | TenderAwardReference        | InvestmentPriority | AgreementNumber | ActivityDescription | SpecificationTitle | RegionType |
    | 10017949 | ESIF-949       | ESF-949       | ESF 201420        | AY                      | 01/04/2015          | 31/03/2016        | 46433.00        |         |         | Funding for Unemployed | New       | Dorset LEP | E37009  | ITT-29801                    | 00-01        | 29801/23-003-00-01/10017946 | 1.5 CLLD           | 08SESF01        | Job Seekers Fund    | ESFSp01            | Transition |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | DeliverableDescription       | CRMIntent |
    | ESIF-949       | ESF-949       | 2               | 0                     | 2919.00  | 3734.00  | 1836.00  | 3634.00  | 678.00   | 1984.00  | 1502.00  | 2391.00  | 142.00   | 1387.00  | 2912.00  | 309.00   | RQ01 Regulated Learning      | New       |
    | ESIF-949       | ESF-949       | 3               | 0                     | 952.00   | 268.00   | 3341.00  | 808.00   | 3097.00  | 3908.00  | 3195.00  | 1921.00  | 2727.00  | 1108.00  | 322.00   | 1358.00  | NR01 Non Regulated Activity  | New       |

    And   the contract exists in CRM

	# Bulk import to create a new ESF contract with the same tender award reference as the injected contract. Fail: CABR-013
	And   an excel spreadsheet exists and has cell 'A2' with a UKPRN '10017946' and a file Name 'ESF ESF 1420 01012016000000 Error_CABR-013_10017946.xlsx'
    When  the file for syntax validation is copied from the source location to the 'Input'
    Then  I should see a file for syntax validation success report
    And   a results report excel spreadsheet is generated in the storage

	# Fail CABR-013
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   '[Contract Allocation] 2 Contract Allocations cannot have the same Tender Award Reference within the Bulk Import file or the CRM system' is displayed in field 'J2' on the 'Contract' tab of the result report

