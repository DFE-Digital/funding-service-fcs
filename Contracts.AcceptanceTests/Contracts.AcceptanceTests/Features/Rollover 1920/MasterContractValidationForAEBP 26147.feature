Feature: MasterContractValidationForAEBP 26147

@AcceptanceTest @Withdrawn20230118
Scenario: A312 Various Master Contract tests on multi-year AEBP contracts to validate MBR-006
    Given there are no allocations marked as Under Termination for UKPRN '10017312' 
	And   there are no allocations marked as Under Termination for UKPRN '10017313' 
    And   there are no terminated or closed allocations for UKPRN '10017312' 
	And   there are no terminated or closed allocations for UKPRN '10017313'
    And   there is no Contract, Task or Workflow data for UKPRN '10017312' 
	And   there is no Contract, Task or Workflow data for UKPRN '10017313' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017312' 
	And   there is no Organisation data for UKPRN '10017313' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017312 Co Ltd' with UKPRN '10017312' and OrgId 'ORG0017312' and has 'FCS1 Test' as a manager 
	And   caseload advisor 'FCS2 Test' is assigned to provider '10017313 Co Ltd' with UKPRN '10017313' and OrgId 'ORG0017313' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017nnn' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017312 | 117312 | 10017312 Co Ltd | 0              | Active                | Yes           | AA017312      | ?             | 9 Kneesworth Street    | ?                      | ?                      | ?                      | Royston                | Hertfordshire          | SG8 5AA   |
    | 10017313 | 117313 | 10017313 Co Ltd | 0              | Active                | Yes           | AA017313      | ?             | 91 Hullbridge Road     | South Woodham Ferrers  | ?                      | ?                      | Chelmsford             | Essex                  | CM3 5LJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017312 |
    | 10017313 |




    # Change the date
    Given the override date is '01/10/2017'

    # Create predecessor AEBP contract but don't approve it
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017312 | 10017312 Co Ltd      | ESFA-312             | AEBP-312       | 1                     | 01/11/2017        | 31/07/2018      | 57532.00      |                                    | Contract for Services                      | 1718   | New          | ORG0017312 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017312 | AEBP-312       | AEBC-312      | AEB-CL            | AEB-CL1718              | AY                      | 01/11/2017          | 31/07/2018        | 18030.00        |                                         |            |                                                             | New          |             |
    | 10017312 | AEBP-312       | AEBL-312      | AEB-LS            | AEB-LS1718              | AY                      | 01/11/2017          | 31/07/2018        | 21492.00        |                                         |            |                                                             | New          |             |
    | 10017312 | AEBP-312       | AEBT-312      | AEB-TOL           | AEB-TOL1718             | AY                      | 01/11/2017          | 31/07/2018        | 18010.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017312 | AEBP-312       | AEBC-312      | 1               | 0                     | 18030.00  | 2355.00  | 2647.00  | 789.00   | 2662.00  | 3462.00  | 3027.00  | 631.00   | 418.00   | 2039.00  | Adult Education Budget - Community Learning                     | New          |             |
    | 10017312 | AEBP-312       | AEBL-312      | 1               | 0                     | 21492.00  | 1509.00  | 3258.00  | 2695.00  | 2418.00  | 3249.00  | 758.00   | 1810.00  | 3337.00  | 2458.00  | Adult Education Budget - Learner Support                        | New          |             |
    | 10017312 | AEBP-312       | AEBT-312      | 1               | 0                     | 18010.00  | 3009.00  | 993.00   | 622.00   | 2718.00  | 2851.00  | 1468.00  | 2900.00  | 3286.00  | 163.00   | Adult Education - Traineeships and Other Learning Total Funding | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '23/10/2018'




    # Bulk file to attempt a New Amendment for an 1819 AEBP where the predecessor 1718 AEBP contract is Draft
    Given there are no files prefixed '10017312' in the Sharepoint 'AEB-1718-Input-Appendices' folder
    And   there are no files prefixed '10017312' in the Sharepoint 'AEB-1819-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1819 01072019132911 v3_A312_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1819 01072019132911 v3_A312_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1819 01072019132911 v3_A312_1.xlsx' exists in the Datafiles folder and UKPRN '10017312' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder

    # Fail MBR-006
    And   'Failed' is displayed in field 'O2' on the 'Deliverable' tab of the result report
    And   '[Contract] This provider does not have an approved contract under this Master Contract Reference Number in the preceding Funding Period for this Funding Type' is displayed in field 'O2' on the 'Contract' tab of the result report file




    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-312' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '25/10/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-312' and actual ContractNumber 'AEBP-312'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-312' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017312 | AEBP-312           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/11/2017        | 31/07/2018      | ?             |
    | 10017312 | ESFA-312           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/11/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '108' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '108' deliverable period rows in CRM linked to the latest version of contract 'AEBP-312'




    # Change the date
    Given the override date is '26/10/2018'

    # Create and approve an ESF contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017312 | 10017312 Co Ltd      | ESFA-3121            | ESIF-312       | 1                     | 01/01/2019        | 31/12/2019      | 222075.00     | ESF Contract                       | Contract for Services                      | 1420   | New          | ORG0017312 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                             | AgreementNumber | ActivityDescription                | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017312 | ESIF-312       | ESF-312       | ESF 201420        | ESF1420                 | ESF                     | 01/01/2019          | 31/12/2019        | 222075.00       |                                         |            | ESF Allocation                                              | New          | Dorset LEP                                  | E37009       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017312    | 1.4 Active Inclusion                           | 111\SD\7312     | Numeracy in the workplace          | NEET                  | More Developed | 1.09                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017312 | ESIF-312       | ESF-312       | 5               | 0                     | 21670.00  | 1664.00  | 2306.00  | 2346.00  | 2227.00  | 2583.00  | 532.00   | 1016.00  | 1530.00  | 3690.00  | 913.00   | 858.00   | 2005.00  | AC01 Actual Costs                                               | New          |             |
    | 10017312 | ESIF-312       | ESF-312       | 15              | 0                     | 65688.00  | 4620.00  | 8400.00  | 6636.00  | 6300.00  | 5376.00  | 8064.00  | 7644.00  | 3360.00  | 6552.00  | 2520.00  | 3360.00  | 2856.00  | SD08 Specification Defined Deliverable (with Description)       | New          |             |
    | 10017312 | ESIF-312       | ESF-312       | 29              | 0                     | 38612.00  | 1421.00  | 4753.00  | 4802.00  | 2646.00  | 3381.00  | 4459.00  | 2401.00  | 4116.00  | 2303.00  | 4361.00  | 1470.00  | 2499.00  | SU11 Sustained Employment 6 Months                              | New          |             |
    | 10017312 | ESIF-312       | ESF-312       | 36              | 0                     | 96105.00  | 7301.00  | 9834.00  | 8493.00  | 2682.00  | 6705.00  | 11622.00 | 3278.00  | 8344.00  | 6854.00  | 4023.00  | 12367.00 | 14602.00 | SU23 Sustained Education 12 Months                              | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | DeliverableCode | AllocationRef | UnitCost | Total   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | 
    | 10017312 | ESIF-312       | 15              | ESF-312       | 84       | 782     | 55       | 100      | 79       | 75       | 64       | 96       | 91       | 40       | 78       | 30       | 40       | 34       |
    | 10017312 | ESIF-312       | 29              | ESF-312       | 49       | 788     | 29       | 97       | 98       | 54       | 69       | 91       | 49       | 84       | 47       | 89       | 30       | 51       |
    | 10017312 | ESIF-312       | 36              | ESF-312       | 149      | 645     | 49       | 66       | 57       | 18       | 45       | 78       | 22       | 56       | 46       | 27       | 83       | 98       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '27/10/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'ESIF-312' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-3121' and actual ContractNumber 'ESIF-312'

    # Check that the contract is now approved
    Then  the latest version of contract 'ESIF-312' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017312 | ESIF-312           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2019        | 31/12/2019      | ?             |
    | 10017312 | ESFA-3121          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2019        | 31/12/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'ESIF-312'




    # Bulk file to attempt a New Amendment for an 1819 AEBP where the Master Contract number in the bulk file (ESFA-3121) belongs to an approved ESF contract
    Given there are no files prefixed '10017312' in the Sharepoint 'AEB-1718-Input-Appendices' folder
    And   there are no files prefixed '10017312' in the Sharepoint 'AEB-1819-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1819 01072019132922 v3_A312_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1819 01072019132922 v3_A312_2' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1819 01072019132922 v3_A312_2.xlsx' exists in the Datafiles folder and UKPRN '10017312' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder

    # Fail MBR-006
    And   'Failed' is displayed in field 'O2' on the 'Deliverable' tab of the result report
    And   '[Contract] This provider does not have an approved contract under this Master Contract Reference Number in the preceding Funding Period for this Funding Type' is displayed in field 'O2' on the 'Contract' tab of the result report file




    # Bulk file to attempt a New Amendment for an 1819 AEBP where the Master Contract number in the bulk file (SFA-312) does not exist
    Given there are no files prefixed '10017312' in the Sharepoint 'AEB-1718-Input-Appendices' folder
    And   there are no files prefixed '10017312' in the Sharepoint 'AEB-1819-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1819 01072019132935 v3_A312_3' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1819 01072019132935 v3_A312_3' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1819 01072019132935 v3_A312_3.xlsx' exists in the Datafiles folder and UKPRN '10017312' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder

    # Fail MBR-006
    And   'Failed' is displayed in field 'O2' on the 'Deliverable' tab of the result report
    And   '[Contract] This provider does not have an approved contract under this Master Contract Reference Number in the preceding Funding Period for this Funding Type' is displayed in field 'O2' on the 'Contract' tab of the result report file




    # Change the date
    Given the override date is '01/12/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017313 | 10017313 Co Ltd      | ESFA-313             | ESIF-313       | 1                     | 01/01/2019        | 31/12/2019      | 84142.00      | ESF Contract                       | Contract for Services                      | 1420   | New          | ORG0017313 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                             | AgreementNumber | ActivityDescription                | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017313 | ESIF-313       | ESF-313       | ESF 201420        | ESF1420                 | ESF                     | 01/01/2019          | 31/12/2019        | 84142.00        |                                         |            | ESF Allocation                                              | New          | Liverpool City Region LEP                   | E37022       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017313    | 1.1 Access to employment for jobseekers/ the inactive | 111\SD\7313     | Numeracy in the workplace          | SSU                   | Transition     | 1.05                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017313 | ESIF-313       | ESF-313       | 3               | 0                     | 22990.00  | 2644.00  | 406.00   | 3420.00  | 2763.00  | 50.00    | 786.00   | 3262.00  | 3237.00  | 2328.00  | 2338.00  | 574.00   | 1182.00  | NR01 Non Regulated Activity                                     | New          |             |
    | 10017313 | ESIF-313       | ESF-313       | 10              | 0                     | 61152.00  | 3276.00  | 2184.00  | 7476.00  | 4872.00  | 5208.00  | 8232.00  | 4788.00  | 5460.00  | 7476.00  | 1344.00  | 4452.00  | 6384.00  | SD03 Specification Defined Deliverable (with Description)       | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | DeliverableCode | AllocationRef | UnitCost | Total   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | 
    | 10017313 | ESIF-313       | 10              | ESF-313       | 84       | 728     | 39       | 26       | 89       | 58       | 62       | 98       | 57       | 65       | 89       | 16       | 53       | 76       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'




    # Bulk file to attempt a New Amendment for an ESF contract where the Master Contract number in the bulk file (ESFA-3121) is for a different EFS provider\contract
    Given there are no files prefixed '10017312' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 03072019121050 v3_A312_4' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 03072019121050 v3_A312_4' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 03072019121050 v3_A312_4.xlsx' exists in the Datafiles folder and UKPRN '10017312' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder

    # Fail MBR-007
    And   'Failed' is displayed in field 'O2' on the 'Deliverable' tab of the result report
    And   '[Contract] This Master Contract Number is already in use by a different Master Contract.' is displayed in field 'O2' on the 'Contract' tab of the result report file



    # Tidy up
    And   the override date is reset

	   