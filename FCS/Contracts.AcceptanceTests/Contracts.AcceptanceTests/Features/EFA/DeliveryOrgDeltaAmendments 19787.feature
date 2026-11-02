Feature: DeliveryOrgDeltaAmendments 19787

@AcceptanceTest @Withdrawn20200717
@Long2Run @Long2Run67
Scenario: A617 First of three tests using delta files to Update Draft a 1718 EFA contract which doesn’t have a Delivery Org
   #Given there is no Contract, Task or Workflow data for contract '1619F-617' and master contract 'ESFA-617'
    Given there is no Contract, Task or Workflow data for UKPRN '10017617'
    And   the Allocation Delivery Monitoring Service atom feed is empty
	And   the override date is '01/07/2017'

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16LR-617      |
    | NMF-617       |
    | SSF-617       |

   # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017617'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017617 Co Ltd' with UKPRN '10017617' and OrgId 'ORG0017617' and has 'FCS1 Test' as a manager
    And   UPIN '117617' is associated with UKPRN '10017617' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017617 | 117617 | 10017617 Co Ltd | 0              | Active |

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017617 | 10017617 Co Ltd      | ESFA-617             | 1619F-617      | 1                     | 01/08/2017        | 31/07/2018      | 143464.00     |                                | Contract for Services | 1718   | New          | ORG0017617 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017617 | 1619F-617      | 16LR-617      | 1619LR            | 1619LR1718              | AY                      | 01/08/2017          | 31/07/2018        | 143464.00       |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                  | CRMIntent    | DeliveryOrg |
    | 10017617 | 1619F-617      | 16LR-617      | 19              | 0                     | 19091.00  | 730.84   | 2329.69  | 983.25   | 1984.74  | 1756.25  | -2473.75 | -874.85  | 3714.25  | 2252.06  | 4335.84  | 2555.32  | 1796.93  | 16-19 Bursary Funds                                     | New          |             |
    | 10017617 | 1619F-617      | 16LR-617      | 20              | 0                     | 15482.00  | 434.42   | 3247.51  | 3994.11  | 4909.26  | 1961.47  | -775.68  | 739.77   | 193.87   | -907.29  | -1574.74 | 2102.92  | 1156.54  | 16-19 Total Programme Funding                           | New          |             |
    | 10017617 | 1619F-617      | 16LR-617      | 21              | 0                     | 27417.00  | -1401.59 | 2477.08  | -209.20  | 3912.97  | 4818.93  | 4696.15  | 2641.73  | -14.30   | 4674.12  | 3860.40  | 3109.47  | -1149.01 | 16-19 Formula Protection Funding                        | New          |             |
    | 10017617 | 1619F-617      | 16LR-617      | 22              | 0                     | 13272.00  | 1422.72  | 4331.16  | 297.56   | -2164.31 | 3571.70  | 2524.99  | 1543.74  | 764.10   | 135.64   | -1264.36 | 2554.29  | -445.14  | 16-19 High Needs Element 2                              | New          |             |
    | 10017617 | 1619F-617      | 16LR-617      | 24              | 0                     | 29931.00  | 246.13   | 3105.89  | 688.43   | 4567.83  | 4511.11  | 4549.38  | 2392.68  | -1099.08 | 1724.27  | 4022.55  | 1385.24  | 3837.06  | 14-16 Programme Funding                                 | New          |             |
    | 10017617 | 1619F-617      | 16LR-617      | 25              | 0                     | 6096.00   | -1275.59 | 2946.47  | -2209.63 | -1959.05 | -2395.16 | 1378.76  | 3622.76  | 2506.07  | -1727.28 | -1864.59 | 3421.88  | 3651.44  | 14-16 Pupil Premium                                     | New          |             |
    | 10017617 | 1619F-617      | 16LR-617      | 31              | 0                     | 6998.00   | 2958.47  | 662.72   | 2636.41  | 3168.53  | -724.91  | -2140.91 | -41.43   | -381.81  | -172.39  | -2753.03 | 608.52   | 3177.47  | 16-19 Free Meals in FE                                  | New          |             |
    | 10017617 | 1619F-617      | 16LR-617      | 32              | 0                     | 15511.00  | -2027.58 | 1694.73  | 368.73   | -2263.55 | 3526.64  | 3688.48  | 2768.32  | -1454.74 | 2427.51  | 4953.98  | -782.52  | 2610.81  | 16-19 High Needs SPI Element 1                          | New          |             |
    | 10017617 | 1619F-617      | 16LR-617      | 33              | 0                     | 9666.00   | 4141.78  | -971.49  | -2108.16 | 3443.72  | -2574.97 | 2582.80  | -33.16   | -44.79   | 1631.13  | 2892.79  | 1202.07  | -496.04  | 19+ Continuing Learners Programme Funding               | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Bulk file(1) to execute an update draft to add an NMF allocation with a Delivery Org specified. Should fail CABR-026
    Given there are no files prefixed '10017617_1619F' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1718 25072017170213 v3_A617_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 25072017170213 v3_A617_1' in the Sharepoint 'Reports' folder
    And   the override date is '11/07/2017'
    And   spreadsheet '1619FUND AY 1718 25072017170213 v3_A617_1.xlsx' exists in the Datafiles folder and UKPRN '10017617' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   '[Contract Allocation] If Delivery Organisations are applicable, they must be specified against all Contract Allocations for the Contract' is displayed in field 'J2' on the 'Contract' tab of the result report

	# Bulk file(2) to execute an update draft to add a second 16LR allocation - without specifying a Delivery Org. Should fail CABR-004
    Given there are no files prefixed '10017617_1619F' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1718 25072017170639 v3_A617_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 25072017170639 v3_A617_2' in the Sharepoint 'Reports' folder
    And   the override date is '12/07/2017'
    And   spreadsheet '1619FUND AY 1718 25072017170639 v3_A617_2.xlsx' exists in the Datafiles folder and UKPRN '10017617' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   '[Contract Allocation] A Contract cannot have more than 1 Contract Allocation for the same Funding Stream Code (and for the same Delivery Organisation if specified)' is displayed in field 'J2' on the 'Contract' tab of the result report

	# Bulk file(3) to execute an update draft to add an SSF allocation - without specifying a Delivery Org. Should be ok
    Given there are no files prefixed '10017617_1619F' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1718 25072017171212 v3_A617_3' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 25072017171212 v3_A617_3' in the Sharepoint 'Reports' folder
    And   the override date is '13/07/2017'
    And   spreadsheet '1619FUND AY 1718 25072017171212 v3_A617_3.xlsx' exists in the Datafiles folder and UKPRN '10017617' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #And   I retrieve the latest contract details from CRM for provider '10017544' for FundingType '1619FUND' and period '1718'
   #And   I retrieve the latest EFA contract details from CRM for provider '10017544' for FundingType '1619FUND' and period '1718' and Delivery Organisation '11754401'

    # Check the contents of the Appendices
    #And   a file for this contract exists in sharepoint location '1619FUND-1718-Input-Appendices'
	And   a file for a contract with Contract Number '1619F-617' version '1' for UKPRN '10017617' exists in sharepoint location '1619FUND-1718-Input-Appendices'
    And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    Provider: 10017617 Co Ltd UPIN: 117617 UKPRN: 10017617
    Master Contract Ref: ESFA-617 Start Date: 01/08/2017 End Date: 31/07/2018
    Page 1 of 1 of the Payment Schedules
    """

    # Tidy up
	And   the override date is reset

@AcceptanceTest @Withdrawn20200717
@Long2Run @Long2Run67
Scenario: A618 Second of three tests using delta files to Update Draft a 1718 EFA contract which doesn’t have a Delivery Org
   #Given there is no Contract, Task or Workflow data for contract '1619F-618' and master contract 'ESFA-618'
    Given there is no Contract, Task or Workflow data for UKPRN '10017618'
    And   the Allocation Delivery Monitoring Service atom feed is empty
    And   the override date is '13/07/2017'

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16LR-618      |
    | NMF-618       |
    | SSF-618       |

   # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017618'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017618 Co Ltd' with UKPRN '10017618' and OrgId 'ORG0017618' and has 'FCS1 Test' as a manager
    And   UPIN '117618' is associated with UKPRN '10017618' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017618 | 117618 | 10017618 Co Ltd | 0              | Active |

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017618 | 10017618 Co Ltd      | ESFA-618             | 1619F-618      | 1                     | 01/08/2017        | 31/07/2018      | 256257.00     |                                | Contract for Services | 1718   | New          | ORG0017618 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017618 | 1619F-618      | 16LR-618      | 1619LR            | 1619LR1718              | AY                      | 01/08/2017          | 31/07/2018        | 143464.00       |                         |            |                                                             | New          |             |
    | 10017618 | 1619F-618      | SSF-618       | SSF               | SSF1718                 | AY                      | 01/08/2017          | 31/07/2018        | 112793.00       |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                  | CRMIntent    | DeliveryOrg |
    | 10017618 | 1619F-618      | 16LR-618      | 19              | 0                     | 19091.00  | 730.84   | 2329.69  | 983.25   | 1984.74  | 1756.25  | -2473.75 | -874.85  | 3714.25  | 2252.06  | 4335.84  | 2555.32  | 1796.93  | 16-19 Bursary Funds                                     | New          |             |
    | 10017618 | 1619F-618      | 16LR-618      | 20              | 0                     | 15482.00  | 434.42   | 3247.51  | 3994.11  | 4909.26  | 1961.47  | -775.68  | 739.77   | 193.87   | -907.29  | -1574.74 | 2102.92  | 1156.54  | 16-19 Total Programme Funding                           | New          |             |
    | 10017618 | 1619F-618      | 16LR-618      | 21              | 0                     | 27417.00  | -1401.59 | 2477.08  | -209.20  | 3912.97  | 4818.93  | 4696.15  | 2641.73  | -14.30   | 4674.12  | 3860.40  | 3109.47  | -1149.01 | 16-19 Formula Protection Funding                        | New          |             |
    | 10017618 | 1619F-618      | 16LR-618      | 22              | 0                     | 13272.00  | 1422.72  | 4331.16  | 297.56   | -2164.31 | 3571.70  | 2524.99  | 1543.74  | 764.10   | 135.64   | -1264.36 | 2554.29  | -445.14  | 16-19 High Needs Element 2                              | New          |             |
    | 10017618 | 1619F-618      | 16LR-618      | 24              | 0                     | 29931.00  | 246.13   | 3105.89  | 688.43   | 4567.83  | 4511.11  | 4549.38  | 2392.68  | -1099.08 | 1724.27  | 4022.55  | 1385.24  | 3837.06  | 14-16 Programme Funding                                 | New          |             |
    | 10017618 | 1619F-618      | 16LR-618      | 25              | 0                     | 6096.00   | -1275.59 | 2946.47  | -2209.63 | -1959.05 | -2395.16 | 1378.76  | 3622.76  | 2506.07  | -1727.28 | -1864.59 | 3421.88  | 3651.44  | 14-16 Pupil Premium                                     | New          |             |
    | 10017618 | 1619F-618      | 16LR-618      | 31              | 0                     | 6998.00   | 2958.47  | 662.72   | 2636.41  | 3168.53  | -724.91  | -2140.91 | -41.43   | -381.81  | -172.39  | -2753.03 | 608.52   | 3177.47  | 16-19 Free Meals in FE                                  | New          |             |
    | 10017618 | 1619F-618      | 16LR-618      | 32              | 0                     | 15511.00  | -2027.58 | 1694.73  | 368.73   | -2263.55 | 3526.64  | 3688.48  | 2768.32  | -1454.74 | 2427.51  | 4953.98  | -782.52  | 2610.81  | 16-19 High Needs SPI Element 1                          | New          |             |
    | 10017618 | 1619F-618      | 16LR-618      | 33              | 0                     | 9666.00   | 4141.78  | -971.49  | -2108.16 | 3443.72  | -2574.97 | 2582.80  | -33.16   | -44.79   | 1631.13  | 2892.79  | 1202.07  | -496.04  | 19+ Continuing Learners Programme Funding               | New          |             |
    #
	| 10017618 | 1619F-618      | SSF-618       | 2               | 0                     | 4759.00   | -2556.32 | -1923.51 | 1486.78  | -1757.69 | 4079.04  | 1671.36  | 149.39   | -737.18  | 4142.46  | 1856.26  | 419.26   | -2070.47 | SSF Total Programme funding                             | New          |             |
    | 10017618 | 1619F-618      | SSF-618       | 13              | 0                     | 25486.00  | 3863.37  | 1880.39  | 4736.27  | 4960.31  | 2775.70  | 1679.49  | 2080.72  | 1251.71  | 4077.24  | -2002.32 | -1192.27 | 1375.89  | SSF Bursary Funds                                       | New          |             |
    | 10017618 | 1619F-618      | SSF-618       | 14              | 0                     | 26801.00  | 3539.01  | 2059.37  | 4631.61  | 2027.47  | 3764.68  | 4591.11  | 4960.18  | 2620.41  | -800.12  | -2606.54 | -2420.77 | 4434.87  | SSF Formula Protection Funding                          | New          |             |
    | 10017618 | 1619F-618      | SSF-618       | 15              | 0                     | 19366.00  | 2091.63  | 4662.91  | 86.86    | 3914.09  | 197.66   | -736.31  | 4677.82  | 3511.29  | 2245.86  | 349.71   | -2722.08 | 1086.51  | SSF High Needs Element 2                                | New          |             |
    | 10017618 | 1619F-618      | SSF-618       | 17              | 0                     | 16798.00  | -456.42  | 1336.37  | 2028.43  | 4653.51  | -262.94  | 1222.51  | 2920.38  | 2276.64  | 120.75   | -1137.81 | -21.00   | 4117.69  | Maintained Special SSF Element 2                        | New          |             |
    | 10017618 | 1619F-618      | SSF-618       | 18              | 0                     | 19583.00  | 1896.76  | 4786.67  | 4998.10  | 632.81   | 2984.15  | 376.20   | 224.38   | 719.36   | 578.38   | 381.94   | 391.86   | 1612.76  | Maintained Special SSF Student Support                  | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Bulk file(4) to execute an update draft which changes the Delivery Org on both allocations from blank to 11761801 (not the Contracting Org). This should be ok
    Given there are no files prefixed '10017618_1619F' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1718 25072017172441 v3_A618_4' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 25072017172441 v3_A618_4' in the Sharepoint 'Reports' folder
    And   the override date is '14/07/2017'
    And   spreadsheet '1619FUND AY 1718 25072017172441 v3_A618_4.xlsx' exists in the Datafiles folder and UKPRN '10017618' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #And   I retrieve the latest contract details from CRM for provider '10017618' for FundingType '1619FUND' and period '1718'
   #And   I retrieve the latest EFA contract details from CRM for provider '10017618' for FundingType '1619FUND' and period '1718' and Delivery Organisation '11761801'

    # Check the contents of the Appendices
   #And   a file for this contract exists in sharepoint location '1619FUND-1718-Input-Appendices'
    And   a file for a contract with Contract Number '1619F-618' version '1' for UKPRN '10017618' exists in sharepoint location '1619FUND-1718-Input-Appendices'
    And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    Provider: 10017618 Co Ltd UPIN: 117618 UKPRN: 10017618
    Master Contract Ref: ESFA-618 Start Date: 01/08/2017 End Date: 31/07/2018
    Page 1 of 3 of the Payment Schedules
    Payment Schedule
    Provider: A1 ASSESSMENT LTD (122442)
    Contract Ref: 16LR-618
    Page 2 of 3 of the Payment Schedules
    Payment Schedule
    Provider: A1 ASSESSMENT LTD (122442)
    Contract Ref: SSF-618
    Page 3 of 3 of the Payment Schedules
    """

    # Bulk file(5) to execute an update draft to add an NMF allocation - without specifying a Delivery Org. Should fail CABR-026
	Given there are no files prefixed '10017618_1619F' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1718 25072017184904 v3_A618_5' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 25072017184904 v3_A618_5' in the Sharepoint 'Reports' folder
    And   the override date is '15/07/2017'
    And   spreadsheet '1619FUND AY 1718 25072017184904 v3_A618_5.xlsx' exists in the Datafiles folder and UKPRN '10017618' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   '[Contract Allocation] If Delivery Organisations are applicable, they must be specified against all Contract Allocations for the Contract' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Bulk file(6) to execute an update draft to add a second 16LR allocation with the same Delivery Org as above (11761801). Should fail CABR-004
	Given there are no files prefixed '10017618_1619F' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1718 25072017190913 v3_A618_6' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 25072017190913 v3_A618_6' in the Sharepoint 'Reports' folder
    And   the override date is '16/07/2017'
    And   spreadsheet '1619FUND AY 1718 25072017190913 v3_A618_6.xlsx' exists in the Datafiles folder and UKPRN '10017618' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   '[Contract Allocation] A Contract cannot have more than 1 Contract Allocation for the same Funding Stream Code (and for the same Delivery Organisation if specified)' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Bulk file(7) to execute an update draft to add a second SSF allocation for a different Delivery Org (11761802) to above (11761801). Should be ok
	Given there are no files prefixed '10017618_1619F' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1718 25072017192610 v3_A618_7' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 25072017192610 v3_A618_7' in the Sharepoint 'Reports' folder
    And   the override date is '17/07/2017'
    And   spreadsheet '1619FUND AY 1718 25072017192610 v3_A618_7.xlsx' exists in the Datafiles folder and UKPRN '10017618' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #And   I retrieve the latest contract details from CRM for provider '10017618' for FundingType '1619FUND' and period '1718'
   #And   I retrieve the latest EFA contract details from CRM for provider '10017618' for FundingType '1619FUND' and period '1718' and Delivery Organisation '11761801'

    # Check the contents of the Appendices
   #And   a file for this contract exists in sharepoint location '1619FUND-1718-Input-Appendices'
    And   a file for a contract with Contract Number '1619F-618' version '1' for UKPRN '10017618' exists in sharepoint location '1619FUND-1718-Input-Appendices'
    And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    Provider: 10017618 Co Ltd UPIN: 117618 UKPRN: 10017618
    Master Contract Ref: ESFA-618 Start Date: 01/08/2017 End Date: 31/07/2018
    Page 1 of 4 of the Payment Schedules
    Payment Schedule
    Provider: A1 ASSESSMENT LTD (122442)
    Contract Ref: 16LR-618
    Page 2 of 4 of the Payment Schedules
    Payment Schedule
    Provider: A1 ASSESSMENT LTD (122442)
    Contract Ref: SSF-618
    Page 3 of 4 of the Payment Schedules
    Provider: MEDI PROSPECTS LTD (129023)
    Page 4 of 4 of the Payment Schedules
    """

	# Tidy up
	And   the override date is reset

@AcceptanceTest @Withdrawn20200717
Scenario: A619 Third of three tests using delta files to Update Draft a 1718 EFA contract which doesn’t have a Delivery Org
   #Given there is no Contract, Task or Workflow data for contract '1619F-619' and master contract 'ESFA-619'
    Given there is no Contract, Task or Workflow data for UKPRN '10017619'
    And   the Allocation Delivery Monitoring Service atom feed is empty
    And   the override date is '17/07/2017'

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16LR-619      |
    | SSF-6191      |
    | SSF-6192      |

   # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017619'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017619 Co Ltd' with UKPRN '10017619' and OrgId 'ORG0017619' and has 'FCS1 Test' as a manager
    And   UPIN '117619' is associated with UKPRN '10017619' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017619 | 117619 | 10017619 Co Ltd | 0              | Active |

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017619 | 10017619 Co Ltd      | ESFA-619             | 1619F-619      | 1                     | 01/08/2017        | 31/07/2018      | 349016.00     |                                | Contract for Services | 1718   | New          | ORG0017619 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription           | CRMIntent    | DeliveryOrg |
    | 10017619 | 1619F-619      | 16LR-619      | 1619LR            | 1619LR1718              | AY                      | 01/08/2017          | 31/07/2018        | 143464.00       |                         |            | A1 ASSESSMENT LTD (122442)      | New          | 11761901    |
    | 10017619 | 1619F-619      | SSF-6191      | SSF               | SSF1718                 | AY                      | 01/08/2017          | 31/07/2018        | 112793.00       |                         |            | A1 ASSESSMENT LTD (122442)      | New          | 11761901    |
    | 10017619 | 1619F-619      | SSF-6192      | SSF               | SSF1718                 | AY                      | 01/08/2017          | 31/07/2018        | 92759.00        |                         |            | MEDI PROSPECTS LTD (129023)     | New          | 11761902    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                  | CRMIntent    | DeliveryOrg |
    | 10017619 | 1619F-619      | 16LR-619      | 19              | 0                     | 19091.00  | 730.84   | 2329.69  | 983.25   | 1984.74  | 1756.25  | -2473.75 | -874.85  | 3714.25  | 2252.06  | 4335.84  | 2555.32  | 1796.93  | 16-19 Bursary Funds                                     | New          | 11761901    |
    | 10017619 | 1619F-619      | 16LR-619      | 20              | 0                     | 15482.00  | 434.42   | 3247.51  | 3994.11  | 4909.26  | 1961.47  | -775.68  | 739.77   | 193.87   | -907.29  | -1574.74 | 2102.92  | 1156.54  | 16-19 Total Programme Funding                           | New          | 11761901    |
    | 10017619 | 1619F-619      | 16LR-619      | 21              | 0                     | 27417.00  | -1401.59 | 2477.08  | -209.20  | 3912.97  | 4818.93  | 4696.15  | 2641.73  | -14.30   | 4674.12  | 3860.40  | 3109.47  | -1149.01 | 16-19 Formula Protection Funding                        | New          | 11761901    |
    | 10017619 | 1619F-619      | 16LR-619      | 22              | 0                     | 13272.00  | 1422.72  | 4331.16  | 297.56   | -2164.31 | 3571.70  | 2524.99  | 1543.74  | 764.10   | 135.64   | -1264.36 | 2554.29  | -445.14  | 16-19 High Needs Element 2                              | New          | 11761901    |
    | 10017619 | 1619F-619      | 16LR-619      | 24              | 0                     | 29931.00  | 246.13   | 3105.89  | 688.43   | 4567.83  | 4511.11  | 4549.38  | 2392.68  | -1099.08 | 1724.27  | 4022.55  | 1385.24  | 3837.06  | 14-16 Programme Funding                                 | New          | 11761901    |
    | 10017619 | 1619F-619      | 16LR-619      | 25              | 0                     | 6096.00   | -1275.59 | 2946.47  | -2209.63 | -1959.05 | -2395.16 | 1378.76  | 3622.76  | 2506.07  | -1727.28 | -1864.59 | 3421.88  | 3651.44  | 14-16 Pupil Premium                                     | New          | 11761901    |
    | 10017619 | 1619F-619      | 16LR-619      | 31              | 0                     | 6998.00   | 2958.47  | 662.72   | 2636.41  | 3168.53  | -724.91  | -2140.91 | -41.43   | -381.81  | -172.39  | -2753.03 | 608.52   | 3177.47  | 16-19 Free Meals in FE                                  | New          | 11761901    |
    | 10017619 | 1619F-619      | 16LR-619      | 32              | 0                     | 15511.00  | -2027.58 | 1694.73  | 368.73   | -2263.55 | 3526.64  | 3688.48  | 2768.32  | -1454.74 | 2427.51  | 4953.98  | -782.52  | 2610.81  | 16-19 High Needs SPI Element 1                          | New          | 11761901    |
    | 10017619 | 1619F-619      | 16LR-619      | 33              | 0                     | 9666.00   | 4141.78  | -971.49  | -2108.16 | 3443.72  | -2574.97 | 2582.80  | -33.16   | -44.79   | 1631.13  | 2892.79  | 1202.07  | -496.04  | 19+ Continuing Learners Programme Funding               | New          | 11761901    |
    #
    | 10017619 | 1619F-619      | SSF-6191      | 2               | 0                     | 4759.00   | -2556.32 | -1923.51 | 1486.78  | -1757.69 | 4079.04  | 1671.36  | 149.39   | -737.18  | 4142.46  | 1856.26  | 419.26   | -2070.47 | SSF Total Programme funding                             | New          | 11761901    |
    | 10017619 | 1619F-619      | SSF-6191      | 13              | 0                     | 25486.00  | 3863.37  | 1880.39  | 4736.27  | 4960.31  | 2775.70  | 1679.49  | 2080.72  | 1251.71  | 4077.24  | -2002.32 | -1192.27 | 1375.89  | SSF Bursary Funds                                       | New          | 11761901    |
    | 10017619 | 1619F-619      | SSF-6191      | 14              | 0                     | 26801.00  | 3539.01  | 2059.37  | 4631.61  | 2027.47  | 3764.68  | 4591.11  | 4960.18  | 2620.41  | -800.12  | -2606.54 | -2420.77 | 4434.87  | SSF Formula Protection Funding                          | New          | 11761901    |
    | 10017619 | 1619F-619      | SSF-6191      | 15              | 0                     | 19366.00  | 2091.63  | 4662.91  | 86.86    | 3914.09  | 197.66   | -736.31  | 4677.82  | 3511.29  | 2245.86  | 349.71   | -2722.08 | 1086.51  | SSF High Needs Element 2                                | New          | 11761901    |
    | 10017619 | 1619F-619      | SSF-6191      | 17              | 0                     | 16798.00  | -456.42  | 1336.37  | 2028.43  | 4653.51  | -262.94  | 1222.51  | 2920.38  | 2276.64  | 120.75   | -1137.81 | -21.00   | 4117.69  | Maintained Special SSF Element 2                        | New          | 11761901    |
    | 10017619 | 1619F-619      | SSF-6191      | 18              | 0                     | 19583.00  | 1896.76  | 4786.67  | 4998.10  | 632.81   | 2984.15  | 376.20   | 224.38   | 719.36   | 578.38   | 381.94   | 391.86   | 1612.76  | Maintained Special SSF Student Support                  | New          | 11761901    |
    #
    | 10017619 | 1619F-619      | SSF-6192      | 2               | 0                     | 20223.00  | 3429.54  | 2847.20  | 3327.38  | 3249.84  | -1094.05 | 3729.62  | 1695.13  | -748.39  | 535.55   | 686.11   | -560.15  | 3124.83  | SSF Total Programme funding                             | New          | 11761902    |
    | 10017619 | 1619F-619      | SSF-6192      | 13              | 0                     | 19264.00  | -456.22  | 4927.77  | 465.82   | -255.87  | 4744.23  | -1698.62 | 3170.11  | -1694.16 | -1214.60 | 2148.91  | 4464.41  | 4662.36  | SSF Bursary Funds                                       | New          | 11761902    |
    | 10017619 | 1619F-619      | SSF-6192      | 14              | 0                     | 19999.00  | -2252.34 | -83.25   | -2053.05 | 3406.47  | 3490.09  | 2115.21  | -2575.63 | 4305.80  | 4747.33  | 4027.82  | -16.43   | 4887.14  | SSF Formula Protection Funding                          | New          | 11761902    |
    | 10017619 | 1619F-619      | SSF-6192      | 15              | 0                     | 10810.00  | 3576.50  | -29.28   | -2186.41 | 1770.84  | 4754.06  | -497.93  | -222.48  | 3955.18  | -677.34  | -1218.64 | 334.32   | 1250.74  | SSF High Needs Element 2                                | New          | 11761902    |
    | 10017619 | 1619F-619      | SSF-6192      | 17              | 0                     | 19717.00  | 4688.07  | 678.85   | -2789.26 | 4864.80  | -2534.03 | -2165.09 | 3223.18  | 4135.66  | 4278.94  | 4469.41  | -2350.47 | 3217.07  | Maintained Special SSF Element 2                        | New          | 11761902    |
    | 10017619 | 1619F-619      | SSF-6192      | 18              | 0                     | 2746.00   | -496.78  | 4341.06  | 4351.15  | -2687.43 | -34.35   | 2056.83  | 244.59   | -2340.08 | -2209.46 | -1668.69 | -2676.39 | 3865.40  | Maintained Special SSF Student Support                  | New          | 11761902    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Bulk file(8) to execute an update draft which removes the Delivery Org from all three allocations. This should fail CABR-004.
    Given there are no files prefixed '10017619_1619F' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1718 25072017193951 v3_A619_8' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 25072017193951 v3_A619_8' in the Sharepoint 'Reports' folder
    And   the override date is '18/07/2017'
    And   spreadsheet '1619FUND AY 1718 25072017193951 v3_A619_8.xlsx' exists in the Datafiles folder and UKPRN '10017619' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   '[Contract Allocation] A Contract cannot have more than 1 Contract Allocation for the same Funding Stream Code (and for the same Delivery Organisation if specified)' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Tidy up
    And   the override date is reset
 
