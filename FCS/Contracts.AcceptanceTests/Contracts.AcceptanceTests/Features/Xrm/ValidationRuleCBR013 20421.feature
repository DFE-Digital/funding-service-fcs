Feature: ValidationRuleCBR013 20421

@AcceptanceTest @Withdrawn20230123
Scenario: A460 Create and approve a 1-allocation 1617 Mainstream contract. Bulk New Amendment of a 1718 Mainstream contract with contract number specified. Fail: CBR013
    Given there is no Contract, Task or Workflow data for UKPRN '10017460' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16AP-460      |
    | 16NL-460      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017460' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017460 Co Ltd' with UKPRN '10017460' and OrgId 'ORG0017460' and has 'FCS1 Test' as a manager 
    And   UPIN '117460' is associated with UKPRN '10017460' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017460 | 117460 | 10017460 Co Ltd | 0              | Active | Yes           | AA017460      | ?             | 

    # Change the date
    And   the override date is '15/07/2016'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017460 | 10017460 Co Ltd      | ESFA-460             | MAIN-460       | 1                     | 01/08/2016        | 31/07/2017      | 22605.00      |                                | Contract for Services | 1617   | New          | ORG0017460 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode    | AllocationDescription | CRMIntent    |
    | 10017460 | MAIN-460       | 16AP-460      | 16-18 APPS        | 16-18APPS1617           | AY                      | 01/08/2016          | 31/07/2017        | 22605.00        |         |            |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-16   | Sep-16   | Oct-16   | Nov-16   | Dec-16   | Jan-17   | Feb-17   | Mar-17   | Apr-17   | May-17   | Jun-17   | Jul-17   | DeliverableDescription                        | CRMIntent    |
    | 10017460 | MAIN-460       | 16AP-460      | 2               | 0                     | 22605.00  | 2202.00  | 1013.00  | 2084.00  | 967.00   | 406.00   | 3258.00  | 2193.00  | 1683.00  | 2897.00  | 3442.00  | 247.00   | 2213.00  | 16-18 Apprenticeships Total Funding           | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    And   the override date is '17/07/2016'

    # Publish the contract
    And   the latest version of contract 'MAIN-460' is in a state of 'Published to Provider'

    # Change the date
    And   the override date is '19/07/2016'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-460' and actual ContractNumber 'MAIN-460'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-460' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017460 | MAIN-460           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2016        | 31/07/2017      | ?             |
    | 10017460 | ESFA-460           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2016        | 31/07/2017      | ?             |

    # Change the date 
    And   the override date is '21/07/2018' 

    # Cleardown prior to bulk import
    Given there are no files prefixed '10017460_MAIN-460' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1718 28032018082514 v2_A460' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1718 28032018082514 v2_A460' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1718 28032018082514 v2_A460' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 28032018082514 v2_A460' in the Sharepoint 'Reports' folder

    # Bulk import to amend the contract
    And   spreadsheet 'MAIN AY 1718 28032018082514 v2_A460.xlsx' exists in the Datafiles folder and UKPRN '10017460' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # CBR013 fail message
    And   '[Contract] A contract number cannot be specified when creating a new contract' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Tidy up
    And   the override date is reset 
    