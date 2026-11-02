Feature: CommasAndCRLFinCDA 27057

@AcceptanceTest @Withdrawn20240103
@Long2Run @Long2Run67
Scenario: A657 Create a draft ESF contract. Update draft to add a comma and a newline character to a deliverable description. Create CDA. Live bug
    Given there are no allocations marked as Under Termination for UKPRN '10017657' 
    And   there are no terminated or closed allocations for UKPRN '10017657' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017657' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ESF-657       |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017657' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017657 Co Ltd' with UKPRN '10017657' and OrgId 'ORG0017657' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017657' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017657 | 117657 | 10017657 Co Ltd | 0              | Active                | Yes           | AA017657      | ?             | 15 Albert Road         | Middlesbrough          | North Yorkshire        | ?                      | ?                      | ?                      | TS1 1PQ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017657 |




    # Change the date
    Given the override date is '01/06/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017657 | 10017657 Co Ltd      | ESFA-657             | ESIF-657       | 1                     | 01/07/2019        | 31/12/2019      | 92665.00      | ESF Contract                       | Contract for Services                      | 1420   | New          | ORG0017657 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName      | UoPCode    | AllocationDescription      | CRMIntent    | LEPName                   | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                                    | AgreementNumber | ActivityDescription                | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017657 | ESIF-657       | ESF-657       | ESF 201420        | ESF1420                 | ESF                     | 01/07/2019          | 31/12/2019        | 92665.00        |              |            | ESF Allocation             | New          | Northamptonshire LEP      | E37026       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017657    | 1.1 Access to employment for jobseekers/ the inactive | 111\SD\7657     | Foreign language training          | SSW Skills            | Transition     | 1.07                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017657 | ESIF-657       | ESF-657       | 10              | 0                     | 10033.00  | 3255.00  | 1017.00  | 330.00   | 3373.00  | 661.00   | 1397.00  | SD03 Specification Defined Deliverable (with Description)       | New          |             |
    | 10017657 | ESIF-657       | ESF-657       | 17              | 0                     | 39688.00  | 4477.00  | 8349.00  | 7744.00  | 1573.00  | 6171.00  | 11374.00 | SD10 Specification Defined Deliverable (with Description)       | New          |             |
    | 10017657 | ESIF-657       | ESF-657       | 21              | 0                     | 27482.00  | 8099.00  | 1911.00  | 6006.00  | 6006.00  | 2093.00  | 3367.00  | PG04 Progression Apprenticeship (EDU)                           | New          |             |
    | 10017657 | ESIF-657       | ESF-657       | 31              | 0                     | 5642.00   | 312.00   | 572.00   | 390.00   | 936.00   | 1690.00  | 1742.00  | SU13 Sustained Education 6 Months                               | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | DeliverableCode | AllocationRef | UnitCost | Total   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | 
    | 10017657 | ESIF-657       | 10              | ESF-657       | 26       | 217     | 12       | 22       | 15       | 36       | 65       | 67       |
    | 10017657 | ESIF-657       | 17              | ESF-657       | 121      | 328     | 37       | 69       | 64       | 13       | 51       | 94       |
    | 10017657 | ESIF-657       | 21              | ESF-657       | 91       | 302     | 89       | 21       | 66       | 66       | 23       | 37       |
    | 10017657 | ESIF-657       | 31              | ESF-657       | 26       | 217     | 12       | 22       | 15       | 36       | 65       | 67       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'
	   

    # Change the date
    Given the override date is '12/06/2019'

    # Bulk file to run an Update Draft to change two of the deliverable names
    And   there are no files prefixed '10017657' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 15072019115913 v3_A657' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 15072019115913 v3_A657' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'ESF ESF 1420 15072019115913 v3_A657' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 15072019115913 v3_A657.xlsx' exists in the Datafiles folder and UKPRN '10017657' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    
    # CDA
    
    # Run the CDA report
    Given there is no CDA report named 'CDA Latest Version A657.csv'

    Then  the contracts are in the replicated CRM database as follows
    | ContractNumber | ContractVersionNumber |
    | ESIF-657       | 1                     |

    When  the following CDA report is run
    | FundingStreamPeriod   | Version               | Suffix |
    | ESF1420               | Latest Version        | A657   |

    Then  a report named 'CDA Latest Version A657.csv' is created

    # Check the contents of the CDA report
    And   the following rows are present in the report
    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
    | ESF1420                 | 10017657 | 10017657 Co Ltd             |               |                             | ESF-657                  | ESIF-657       | ESFA-657                | 01/07/2019                  | 31/12/2019                | 1                     | Draft          | Awaiting Documentation  | SD03, With comma                                     | SD03 Specification Defined Deliverable (with Description)       |                                                                 | 7                 | 2019            | 2019/20       |              | 11660        |              | 110           |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Jul              |
    | ESF1420                 | 10017657 | 10017657 Co Ltd             |               |                             | ESF-657                  | ESIF-657       | ESFA-657                | 01/07/2019                  | 31/12/2019                | 1                     | Draft          | Awaiting Documentation  | SD03, With comma                                     | SD03 Specification Defined Deliverable (with Description)       |                                                                 | 8                 | 2019            | 2019/20       |              | 2014         |              | 19            |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Aug              |
    | ESF1420                 | 10017657 | 10017657 Co Ltd             |               |                             | ESF-657                  | ESIF-657       | ESFA-657                | 01/07/2019                  | 31/12/2019                | 1                     | Draft          | Awaiting Documentation  | SD03, With comma                                     | SD03 Specification Defined Deliverable (with Description)       |                                                                 | 9                 | 2019            | 2019/20       |              | 10706        |              | 101           |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Sep              |
    | ESF1420                 | 10017657 | 10017657 Co Ltd             |               |                             | ESF-657                  | ESIF-657       | ESFA-657                | 01/07/2019                  | 31/12/2019                | 1                     | Draft          | Awaiting Documentation  | SD03, With comma                                     | SD03 Specification Defined Deliverable (with Description)       |                                                                 | 10                | 2019            | 2019/20       |              | 12084        |              | 114           |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Oct              |
    | ESF1420                 | 10017657 | 10017657 Co Ltd             |               |                             | ESF-657                  | ESIF-657       | ESFA-657                | 01/07/2019                  | 31/12/2019                | 1                     | Draft          | Awaiting Documentation  | SD03, With comma                                     | SD03 Specification Defined Deliverable (with Description)       |                                                                 | 11                | 2019            | 2019/20       |              | 424          |              | 4             |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Nov              |
    | ESF1420                 | 10017657 | 10017657 Co Ltd             |               |                             | ESF-657                  | ESIF-657       | ESFA-657                | 01/07/2019                  | 31/12/2019                | 1                     | Draft          | Awaiting Documentation  | SD03, With comma                                     | SD03 Specification Defined Deliverable (with Description)       |                                                                 | 12                | 2019            | 2019/20       |              | 3604         |              | 34            |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Dec              |
    #
    | ESF1420                 | 10017657 | 10017657 Co Ltd             |               |                             | ESF-657                  | ESIF-657       | ESFA-657                | 01/07/2019                  | 31/12/2019                | 1                     | Draft          | Awaiting Documentation  | SD10\nWith CRLF                                      | SD10 Specification Defined Deliverable (with Description)       |                                                                 | 7                 | 2019            | 2019/20       |              | 11660        |              | 110           |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Jul              |
    | ESF1420                 | 10017657 | 10017657 Co Ltd             |               |                             | ESF-657                  | ESIF-657       | ESFA-657                | 01/07/2019                  | 31/12/2019                | 1                     | Draft          | Awaiting Documentation  | SD10\nWith CRLF                                      | SD10 Specification Defined Deliverable (with Description)       |                                                                 | 8                 | 2019            | 2019/20       |              | 2014         |              | 19            |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Aug              |
    | ESF1420                 | 10017657 | 10017657 Co Ltd             |               |                             | ESF-657                  | ESIF-657       | ESFA-657                | 01/07/2019                  | 31/12/2019                | 1                     | Draft          | Awaiting Documentation  | SD10\nWith CRLF                                      | SD10 Specification Defined Deliverable (with Description)       |                                                                 | 9                 | 2019            | 2019/20       |              | 10706        |              | 101           |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Sep              |
    | ESF1420                 | 10017657 | 10017657 Co Ltd             |               |                             | ESF-657                  | ESIF-657       | ESFA-657                | 01/07/2019                  | 31/12/2019                | 1                     | Draft          | Awaiting Documentation  | SD10\nWith CRLF                                      | SD10 Specification Defined Deliverable (with Description)       |                                                                 | 10                | 2019            | 2019/20       |              | 12084        |              | 114           |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Oct              |
    | ESF1420                 | 10017657 | 10017657 Co Ltd             |               |                             | ESF-657                  | ESIF-657       | ESFA-657                | 01/07/2019                  | 31/12/2019                | 1                     | Draft          | Awaiting Documentation  | SD10\nWith CRLF                                      | SD10 Specification Defined Deliverable (with Description)       |                                                                 | 11                | 2019            | 2019/20       |              | 424          |              | 4             |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Nov              |
    | ESF1420                 | 10017657 | 10017657 Co Ltd             |               |                             | ESF-657                  | ESIF-657       | ESFA-657                | 01/07/2019                  | 31/12/2019                | 1                     | Draft          | Awaiting Documentation  | SD10\nWith CRLF                                      | SD10 Specification Defined Deliverable (with Description)       |                                                                 | 12                | 2019            | 2019/20       |              | 3604         |              | 34            |              |                    |                |                  |                       |                |                 |             |               |                   |        |                   |                          |                   | Dec              |


    # Tidy up
	And   the override date is reset
	