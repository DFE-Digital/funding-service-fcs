Feature: NegativeAndNon-IntegerPlannedValues 19397

@AcceptanceTest @Withdrawn20201209
Scenario: A153 Bulk upload to create a new 17/18 mainstream contract with both negative and non-integer planned values
    Given there is no Contract, Task or Workflow data for UKPRN '10017153'
	And   there is no Organisation data for UKPRN '10017153'
   #And   caseload advisor 'FCS2 Test' is assigned to provider '10017153 Co Ltd' with UKPRN '10017153' and OrgId 'ORG0017153' and has 'FCS1 Test' as a manager
    And   the Allocation Delivery Monitoring Service atom feed is empty

    # Bulk import to create a new contract
    And   there are no files prefixed '10017153_MAIN' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1718 05062017145605 v2_A153' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 05062017145605 v2_A153' in the Sharepoint 'Reports' folder
    And   the override date is '19/07/2017'
    And   spreadsheet 'MAIN AY 1718 05062017145605 v2_A153.xlsx' exists in the Datafiles folder and UKPRN '10017153' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
	And   the Organisation in CRM has a UPIN associated with UKPRN '10017153'

@AcceptanceTest @Withdrawn20201209
Scenario: A154 Inject a new 17/18 mainstream contract with non-integer planned values. Amend to negative values. Check CRM and PaaS.
    Given there is no Contract, Task or Workflow data for UKPRN '10017154'
    And   the Allocation Delivery Monitoring Service atom feed is empty
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEC-154       |
    | AECL-154      |
    | AELS-154      |

    And   caseload advisor 'FCS2 Test' is assigned to provider '10017154 Co Ltd' with UKPRN '10017154' and OrgId 'ORG0017154' and has 'FCS1 Test' as a manager

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017154 | 10017154 Co Ltd      | ESFA-154             | MAIN-154       | 1                     | 01/08/2017        | 31/07/2018      | 75828.68      |                     | Contract for Services | 1718   | New          | ORG0017154 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode    | AllocationDescription | CRMIntent    |
    | 10017154 | MAIN-154       | AEC-154       | AEBC              | AEBC1718                | AY                      | 01/08/2017          | 31/07/2018        | 24956.92        |         |            |                       | New          |
    | 10017154 | MAIN-154       | AECL-154      | AEBTO-CL          | AEBTO-CL1718            | AY                      | 01/08/2017          | 31/07/2018        | 23504.96        |         |            |                       | New          |
    | 10017154 | MAIN-154       | AELS-154      | AEBTO-LS          | AEBTO-LS1718            | AY                      | 01/08/2017          | 31/07/2018        | 27366.80        |         |            |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                       | CRMIntent    |
    | 10017154 | MAIN-154       | AEC-154       | 1               | 0                     | 24956.92  | 2461.01  | 1529.02  | 1588.03  | 3450.10  | 2365.16  | 3730.09  | 2093.05  | 1355.08  | 3481.06  | 1073.07  | 1075.21  | 756.04   | Adult Education Budget Total Funding         | New          |
    | 10017154 | MAIN-154       | AECL-154      | 1               | 0                     | 23504.96  | 1420.11  | 59.05    | 2982.08  | 3372.10  | 1150.04  | 2827.02  | 1649.14  | 3256.00  | 2980.20  | 1779.12  | 358.08   | 1672.02  | Adult Education Budget - Community Learning  | New          |
    | 10017154 | MAIN-154       | AELS-154      | 1               | 0                     | 27366.80  | 1390.04  | 2857.03  | 1283.11  | 3205.09  | 649.26   | 2392.00  | 3828.00  | 1010.10  | 3763.04  | 501.02   | 3938.04  | 2550.07  | Adult Education Budget - Learner Support     | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract 'MAIN-154' is in a state of 'Published to Provider'

    # Inject an SFS approval message
    And   the override date is '12/07/2017'
	And   the PaaS MonthEndIsRunning indicator is set to 'False'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-154' and actual ContractNumber 'MAIN-154'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-154' is in status 'Approved'

    # Check that everything looks ok in PAAS after approval
    And   the PaymentSchedule.DeliverablePayment table contains the following values
    | AllocationNumber | VersionNumber | DeliverableCode | Period   | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | AEC-154          | 1             | 1               | 201708   | 2              | 0             | 2461.01      | 2461.01              | 0.00                | 0.00                   | 0.00                        | 2461.01          | ?            | ?           |
    | AEC-154          | 1             | 2               | 201708   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-154          | 1             | 3               | 201708   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-154          | 1             | 4               | 201708   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-154          | 1             | 5               | 201708   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-154          | 1             | 6               | 201708   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECL-154         | 1             | 1               | 201708   | 2              | 0             | 1420.11      | 1420.11              | 0.00                | 0.00                   | 0.00                        | 1420.11          | ?            | ?           |
    | AELS-154         | 1             | 1               | 201708   | 2              | 0             | 1390.04      | 1390.04              | 0.00                | 0.00                   | 0.00                        | 1390.04          | ?            | ?           |

	# Check the contents of CRM
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef | DeliverableCode | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-154       | AEC-154       | 1               | 2461.01  | 1529.02  | 1588.03  | 3450.10  | 2365.16  | 3730.09  | 2093.05  | 1355.08  | 3481.06  | 1073.07  | 1075.21  | 756.04   | 
    | MAIN-154       | AEC-154       | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AECL-154      | 1               | 1420.11  | 59.05    | 2982.08  | 3372.10  | 1150.04  | 2827.02  | 1649.14  | 3256.00  | 2980.20  | 1779.12  | 358.08   | 1672.02  | 
    | MAIN-154       | AELS-154      | 1               | 1390.04  | 2857.03  | 1283.11  | 3205.09  | 649.26   | 2392.00  | 3828.00  | 1010.10  | 3763.04  | 501.02   | 3938.04  | 2550.07  | 

    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef | DeliverableCode | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-154       | AEC-154       | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AECL-154      | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AELS-154      | 1               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef | DeliverableCode | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-154       | AEC-154       | 1               | 2461.01  | 1529.02  | 1588.03  | 3450.10  | 2365.16  | 3730.09  | 2093.05  | 1355.08  | 3481.06  | 1073.07  | 1075.21  | 756.04   | 
    | MAIN-154       | AEC-154       | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AECL-154      | 1               | 1420.11  | 59.05    | 2982.08  | 3372.10  | 1150.04  | 2827.02  | 1649.14  | 3256.00  | 2980.20  | 1779.12  | 358.08   | 1672.02  | 
    | MAIN-154       | AELS-154      | 1               | 1390.04  | 2857.03  | 1283.11  | 3205.09  | 649.26   | 2392.00  | 3828.00  | 1010.10  | 3763.04  | 501.02   | 3938.04  | 2550.07  | 

	#
	# Part 2: Negatives
	#

    # Bulk file to amend the injected contract
    Given there are no files prefixed '10017154_MAIN-154' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1718 05062017172543 v2_A154' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 05062017172543 v2_A154' in the Sharepoint 'Reports' folder
    And   the override date is '24/08/2017'
    And   spreadsheet 'MAIN AY 1718 05062017172543 v2_A154.xlsx' exists in the Datafiles folder and UKPRN '10017154' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

   #And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish version 2 of the contract
    And   the latest version of contract 'MAIN-154' is in a state of 'Published to Provider'

    # Inject an SFS approval message
	And   the override date is '28/08/2017'
	And   the PaaS MonthEndIsRunning indicator is set to 'False'
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-154' and actual ContractNumber 'MAIN-154'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-154' is in status 'Approved'

    # Check that everything looks ok in PAAS after amendment approval
    And   the PaymentSchedule.DeliverablePayment table contains the following values
    | AllocationNumber | VersionNumber | DeliverableCode | Period   | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | AEC-154          | 2             | 1               | 201709   | 2              | 0             | -3658.38     | -3658.38             | 0.00                | -3024.73               | 0.00                        | -6683.11         | ?            | ?           |
    | AEC-154          | 2             | 2               | 201709   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-154          | 2             | 3               | 201709   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-154          | 2             | 4               | 201709   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-154          | 2             | 5               | 201709   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AEC-154          | 2             | 6               | 201709   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECL-154         | 2             | 1               | 201709   | 2              | 0             | -5336.87     | -5336.87             | 0.00                | -6076.23               | 0.00                        | -11413.10        | ?            | ?           |
    | AELS-154         | 2             | 1               | 201709   | 2              | 0             | -1616.83     | -1616.83             | 0.00                | -9747.01               | 0.00                        | -11363.84        | ?            | ?           |

	# Check the contents of CRM
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef | DeliverableCode | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-154       | AEC-154       | 1               | 2461.01  | -3658.38 | -1850.88 | -4678.87 | 2457.19  | 956.63   | 679.59   | 437.09   | 467.10   | 469.24   | 1822.71  | 2832.89  | 
    | MAIN-154       | AEC-154       | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AECL-154      | 1               | 1420.11  | -5336.87 | 891.70   | 516.00   | 680.21   | 248.14   | 3720.41  | 211.80   | 1690.12  | 825.16   | 363.52   | 1670.02  | 
    | MAIN-154       | AELS-154      | 1               | 1390.04  | -1616.83 | -1055.63 | -3065.82 | -2662.93 | 2979.18  | 2199.75  | 4460.63  | 1987.26  | 2556.20  | 2027.46  | 2219.85  | 

    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef | DeliverableCode | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-154       | AEC-154       | 1               | 0.00     | -3024.73 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AECL-154      | 1               | 0.00     | -6076.23 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AELS-154      | 1               | 0.00     | -9747.01 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef | DeliverableCode | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-154       | AEC-154       | 1               | 2461.01  | -6683.11 | -1850.88 | -4678.87 | 2457.19  | 956.63   | 679.59   | 437.09   | 467.10   | 469.24   | 1822.71  | 2832.89  | 
    | MAIN-154       | AEC-154       | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AEC-154       | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | MAIN-154       | AECL-154      | 1               | 1420.11  | -11413.10| 891.70   | 516.00   | 680.21   | 248.14   | 3720.41  | 211.80   | 1690.12  | 825.16   | 363.52   | 1670.02  | 
    | MAIN-154       | AELS-154      | 1               | 1390.04  | -11363.84| -1055.63 | -3065.82 | -2662.93 | 2979.18  | 2199.75  | 4460.63  | 1987.26  | 2556.20  | 2027.46  | 2219.85  | 

    # Tidy up
    And   the override date is reset
	 