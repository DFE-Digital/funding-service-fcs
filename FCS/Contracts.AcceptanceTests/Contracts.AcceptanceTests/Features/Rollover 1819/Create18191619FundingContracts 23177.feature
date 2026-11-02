Feature: Create18191619FundingContracts 23177

@AcceptanceTest @Withdrawn20201209
@Long2Run @Long2Run123
Scenario: A258 Create an 1819 16-19 Funding contract with short 1619LR, NMF and SSF allocations and 2 Delivery Orgs. Bulk update draft. Step through Tasks until Published then approve. Check Tasks, CRM and PaaS
    Given there is no Contract, Task or Workflow data for UKPRN '10017258' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16LR-2581     |
    | NMF-2581      |
    | SSF-2581      |
    | 16LR-2582     |
    | NMF-2582      |
    | SSF-2582      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017258' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017258 Co Ltd' with UKPRN '10017258' and OrgId 'ORG0017258' and has 'FCS1 Test' as a manager 
    And   UPIN '117258' is associated with UKPRN '10017258' in the CRM Organisation table 
 
    And   there is no Organisation data for UKPRN '10023115' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10023115 Co Ltd' with UKPRN '10023115' and OrgId 'ORG0023115' and has 'FCS1 Test' as a manager 
    And   UPIN '123115' is associated with UKPRN '10023115' in the CRM Organisation table 
 
    And   there is no Organisation data for UKPRN '10023592' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10023592 Co Ltd' with UKPRN '10023592' and OrgId 'ORG0023592' and has 'FCS1 Test' as a manager 
    And   UPIN '123592' is associated with UKPRN '10023592' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                    | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017258 | 117258 | 10017258 Co Ltd         | 0              | Active | Yes           | AA017258      | ?             | 34 Newbury Street      | Wantage                | ?                      | ?                      | Oxon                   | Oxfordshire            | OX12 8DD  |
    | 10023115 | 123115 | PBC ASSOCIATES LIMITED  | 0              | Active | Yes           | ?             | 118445        | 18 Clare Street        | London                 | ?                      | ?                      | ?                      | ?                      | EC2A 4LJ  |
    | 10023592 | 123592 | PLATO TRAINING (UK) LTD | 0              | Active | Yes           | AA121272      | ?             | 20 Bothwell Road       | ?                      | ?                      | ?                      | Hamilton               | South Lanarkshire      | ML3 0AY   |

    # Put data in the CRM Organisation table J057
    And   the following Organisations exist in CRM
    | OrgId      | UKPRN    | UPIN   | Name                    | Status | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | ORG0017258 | 10017258 | 117258 | 10017258 Co Ltd         | Active | AA017258      | ?             | 34 Newbury Street      | Wantage                | ?                      | ?                      | Oxon                   | Oxfordshire            | OX12 8DD  |
    | ORG0023115 | 10023115 | 118445 | PBC ASSOCIATES LIMITED  | Active | ?             | 118445        | 18 Clare Street        | London                 | ?                      | ?                      | ?                      | ?                      | EC2A 4LJ  |
    | ORG0023592 | 10023592 | 123592 | PLATO TRAINING (UK) LTD | Active | AA121272      | ?             | 20 Bothwell Road       | ?                      | ?                      | ?                      | Hamilton               | South Lanarkshire      | ML3 0AY   |



    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017258 | 10017258 Co Ltd      | ESFA-258             | 1619F-258      | 1                     | 01/08/2018        | 31/07/2019      | 751101.00     |                                | Contract for Services | 1819   | New          | ORG0017258 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription  | CRMIntent    | DeliveryOrg |
    | 10017258 | 1619F-258      | 16LR-2581     | 1619LR            | 1619LR1819              | AY                      | 01/08/2018          | 31/07/2019        | 139703.00       |                         |            |                        | New          | 10023115    |
    | 10017258 | 1619F-258      | NMF-2581      | NMF               | NMF1819                 | AY                      | 01/08/2018          | 31/07/2019        | 189303.00       |                         |            |                        | New          | 10023115    |
    | 10017258 | 1619F-258      | SSF-2581      | SSF               | SSF1819                 | AY                      | 01/08/2018          | 31/07/2019        | 77227.00        |                         |            |                        | New          | 10023115    |
    #
    | 10017258 | 1619F-258      | 16LR-2582     | 1619LR            | 1619LR1819              | AY                      | 01/08/2018          | 31/07/2019        | 108931.00       |                         |            |                        | New          | 10023592    |
    | 10017258 | 1619F-258      | NMF-2582      | NMF               | NMF1819                 | AY                      | 01/08/2018          | 31/07/2019        | 94303.00        |                         |            |                        | New          | 10023592    |
    | 10017258 | 1619F-258      | SSF-2582      | SSF               | SSF1819                 | AY                      | 01/08/2018          | 31/07/2019        | 141654.00       |                         |            |                        | New          | 10023592    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017258 | 1619F-258      | 16LR-2581     | 21              | 0                     | 20687.00  | 1137.00  | 1240.00  | 1913.00  | 3597.00  | 2244.00  | 638.00   | 1754.00  | 371.00   | 821.00   | 2189.00  | 2767.00  | 2016.00  | 16-19 Formula Protection Funding                                | New          | 10023115    |
    | 10017258 | 1619F-258      | 16LR-2581     | 31              | 0                     | 22591.00  | 194.00   | 486.00   | 2329.00  | 1484.00  | 1301.00  | 866.00   | 2171.00  | 1958.00  | 3579.00  | 1435.00  | 3184.00  | 3604.00  | 16-19 Free Meals                                                | New          | 10023115    |
    | 10017258 | 1619F-258      | 16LR-2581     | 32              | 0                     | 25762.00  | 1395.00  | 2225.00  | 2453.00  | 3505.00  | 1331.00  | 1435.00  | 2107.00  | 2809.00  | 2438.00  | 832.00   | 1949.00  | 3283.00  | 16-19 SPI Element 1                                             | New          | 10023115    |
    | 10017258 | 1619F-258      | 16LR-2581     | 111             | 0                     | 19752.00  | 2409.00  | 77.00    | 3373.00  | 2622.00  | 1174.00  | 1817.00  | 1856.00  | 1737.00  | 2093.00  | 1026.00  | 527.00   | 1041.00  | 14-16 Service Child Premium                                     | New          | 10023115    |
    | 10017258 | 1619F-258      | 16LR-2581     | 112             | 0                     | 23865.00  | 894.00   | 1818.00  | 1763.00  | 2910.00  | 3172.00  | 3369.00  | 2776.00  | 854.00   | 1937.00  | 1408.00  | 276.00   | 2688.00  | 16-19 Capacity and Delivery                                     | New          | 10023115    |
    | 10017258 | 1619F-258      | 16LR-2581     | 113             | 0                     | 27046.00  | 3618.00  | 1380.00  | 3411.00  | 3737.00  | 1024.00  | 1761.00  | 3253.00  | 510.00   | 3302.00  | 2329.00  | 565.00   | 2156.00  | 16-19 Capacity and Delivery Bursary Funds                       | New          | 10023115    |
    #
    | 10017258 | 1619F-258      | NMF-2581      | 51              | 0                     | 30812.00  | 2335.00  | 1900.00  | 3205.00  | 2010.00  | 3630.00  | 2469.00  | 3235.00  | 3655.00  | 3378.00  | 507.00   | 1718.00  | 2770.00  | Alternative Completions - Sporting Excellence                   | New          | 10023115    |
    | 10017258 | 1619F-258      | NMF-2581      | 52              | 0                     | 22939.00  | 1469.00  | 1573.00  | 2245.00  | 229.00   | 3559.00  | 1953.00  | 2087.00  | 703.00   | 1153.00  | 2521.00  | 3099.00  | 2348.00  | Alternative Completions - Sea Fishing                           | New          | 10023115    |
    | 10017258 | 1619F-258      | NMF-2581      | 53              | 0                     | 28826.00  | 2670.00  | 2329.00  | 2368.00  | 2250.00  | 2606.00  | 1538.00  | 2022.00  | 2536.00  | 3713.00  | 1919.00  | 1864.00  | 3011.00  | Alternative Completions - Creative Sector                       | New          | 10023115    |
    | 10017258 | 1619F-258      | NMF-2581      | 100             | 0                     | 19285.00  | 2742.00  | 409.00   | 987.00   | 236.00   | 2489.00  | 2149.00  | 2188.00  | 2070.00  | 2425.00  | 1358.00  | 859.00   | 1373.00  | Strategic College Improvement Fund (SCIF)                       | New          | 10023115    |
    | 10017258 | 1619F-258      | NMF-2581      | 101             | 0                     | 25232.00  | 1687.00  | 3594.00  | 2557.00  | 3703.00  | 264.00   | 462.00   | 3570.00  | 1648.00  | 3713.00  | 2201.00  | 1070.00  | 763.00   | Principals Reference Group                                      | New          | 10023115    |
    | 10017258 | 1619F-258      | NMF-2581      | 102             | 0                     | 26780.00  | 1890.00  | 3353.00  | 2666.00  | 2009.00  | 2997.00  | 3733.00  | 2508.00  | 2483.00  | 1574.00  | 601.00   | 2538.00  | 428.00   | National Leaders of Further Education (NLFE)                    | New          | 10023115    |
    | 10017258 | 1619F-258      | NMF-2581      | 103             | 0                     | 18907.00  | 3178.00  | 495.00   | 2877.00  | 416.00   | 3114.00  | 3406.00  | 1548.00  | 702.00   | 520.00   | 85.00    | 1389.00  | 1177.00  | Forensic Unit                                                   | New          | 10023115    |
    | 10017258 | 1619F-258      | NMF-2581      | 116             | 0                     | 16522.00  | 321.00   | 1878.00  | 3627.00  | 346.00   | 69.00    | 899.00   | 1127.00  | 2179.00  | 3706.00  | 108.00   | 780.00   | 1482.00  | Isles of Scilly                                                 | New          | 10023115    |
    #
    | 10017258 | 1619F-258      | SSF-2581      | 18              | 0                     | 18513.00  | 1303.00  | 423.00   | 1095.00  | 2780.00  | 2409.00  | 804.00   | 937.00   | 3255.00  | 986.00   | 1372.00  | 1950.00  | 1199.00  | Maintained Special SSF Bursary Support                          | New          | 10023115    |
    | 10017258 | 1619F-258      | SSF-2581      | 47              | 0                     | 19186.00  | 223.00   | 865.00   | 905.00   | 786.00   | 1142.00  | 2793.00  | 3277.00  | 90.00    | 2249.00  | 3173.00  | 3119.00  | 564.00   | SSF Free Meals                                                  | New          | 10023115    |
    | 10017258 | 1619F-258      | SSF-2581      | 114             | 0                     | 23430.00  | 1759.00  | 1957.00  | 1364.00  | 3143.00  | 524.00   | 3696.00  | 2565.00  | 1275.00  | 1443.00  | 2906.00  | 1236.00  | 1562.00  | SSF Capacity and Delivery                                       | New          | 10023115    |
    | 10017258 | 1619F-258      | SSF-2581      | 115             | 0                     | 16098.00  | 996.00   | 749.00   | 3225.00  | 482.00   | 2291.00  | 2300.00  | 536.00   | 1144.00  | 2039.00  | 339.00   | 1737.00  | 260.00   | SSF Capacity and Delivery Bursary Funds                         | New          | 10023115    |
    #
    | 10017258 | 1619F-258      | 16LR-2582     | 19              | 0                     | 22796.00  | 1967.00  | 109.00   | 1982.00  | 2782.00  | 2348.00  | 3652.00  | 2457.00  | 376.00   | 2916.00  | 3682.00  | 401.00   | 124.00   | 16-19 Bursary Funds                                             | New          | 10023592    |
    | 10017258 | 1619F-258      | 16LR-2582     | 20              | 0                     | 21661.00  | 2349.00  | 3560.00  | 911.00   | 1455.00  | 1558.00  | 2230.00  | 214.00   | 3545.00  | 1939.00  | 2072.00  | 689.00   | 1139.00  | 16-19 Programme Funding                                         | New          | 10023592    |
    | 10017258 | 1619F-258      | 16LR-2582     | 111             | 0                     | 22934.00  | 1979.00  | 1480.00  | 1994.00  | 452.00   | 2359.00  | 1321.00  | 2468.00  | 2730.00  | 2927.00  | 2334.00  | 412.00   | 2478.00  | 14-16 Service Child Premium                                     | New          | 10023592    |
    | 10017258 | 1619F-258      | 16LR-2582     | 112             | 0                     | 17211.00  | 2822.00  | 1690.00  | 1384.00  | 568.00   | 2031.00  | 1344.00  | 687.00   | 1675.00  | 2411.00  | 1186.00  | 1161.00  | 252.00   | 16-19 Capacity and Delivery                                     | New          | 10023592    |
    | 10017258 | 1619F-258      | 16LR-2582     | 113             | 0                     | 24329.00  | 1135.00  | 3072.00  | 962.00   | 1856.00  | 2874.00  | 1555.00  | 2795.00  | 1792.00  | 2083.00  | 225.00   | 3081.00  | 2899.00  | 16-19 Capacity and Delivery Bursary Funds                       | New          | 10023592    |
    #
    | 10017258 | 1619F-258      | NMF-2582      | 31              | 0                     | 23289.00  | 619.00   | 1923.00  | 1711.00  | 3331.00  | 1187.00  | 2936.00  | 3356.00  | 3079.00  | 208.00   | 436.00   | 1488.00  | 3015.00  | Cadets Vocational Programme                                     | New          | 10023592    |
    | 10017258 | 1619F-258      | NMF-2582      | 32              | 0                     | 28636.00  | 2668.00  | 3340.00  | 341.00   | 3672.00  | 2066.00  | 3182.00  | 816.00   | 2248.00  | 3617.00  | 3212.00  | 2461.00  | 1013.00  | Closing Schools                                                 | New          | 10023592    |
    | 10017258 | 1619F-258      | NMF-2582      | 103             | 0                     | 21707.00  | 2482.00  | 85.00    | 3574.00  | 1494.00  | 332.00   | 1098.00  | 1518.00  | 1241.00  | 2072.00  | 3282.00  | 3352.00  | 1177.00  | Forensic Unit                                                   | New          | 10023592    |
    | 10017258 | 1619F-258      | NMF-2582      | 116             | 0                     | 20671.00  | 3137.00  | 108.00   | 1793.00  | 439.00   | 2534.00  | 3651.00  | 2267.00  | 2717.00  | 385.00   | 963.00   | 212.00   | 2465.00  | Isles of Scilly                                                 | New          | 10023592    |
    #
    | 10017258 | 1619F-258      | SSF-2582      | 2               | 0                     | 22120.00  | 279.00   | 319.00   | 200.00   | 556.00   | 3189.00  | 2690.00  | 3204.00  | 1663.00  | 3570.00  | 2532.00  | 3679.00  | 239.00   | SSF Programme Funding                                           | New          | 10023592    |
    | 10017258 | 1619F-258      | SSF-2582      | 17              | 0                     | 28046.00  | 3373.00  | 3600.00  | 952.00   | 2478.00  | 2582.00  | 3254.00  | 255.00   | 3585.00  | 1980.00  | 3096.00  | 729.00   | 2162.00  | SSF Maintained Special Element 2                                | New          | 10023592    |
    | 10017258 | 1619F-258      | SSF-2582      | 18              | 0                     | 28746.00  | 1686.00  | 1281.00  | 530.00   | 2783.00  | 3425.00  | 3465.00  | 3346.00  | 3702.00  | 2635.00  | 2136.00  | 2649.00  | 1108.00  | Maintained Special SSF Bursary Support                          | New          | 10023592    |
    | 10017258 | 1619F-258      | SSF-2582      | 47              | 0                     | 17356.00  | 187.00   | 132.00   | 1279.00  | 1541.00  | 1738.00  | 1145.00  | 2924.00  | 305.00   | 3478.00  | 2346.00  | 1057.00  | 1224.00  | SSF Free Meals                                                  | New          | 10023592    |
    | 10017258 | 1619F-258      | SSF-2582      | 114             | 0                     | 22769.00  | 3620.00  | 1950.00  | 2276.00  | 3265.00  | 300.00   | 1792.00  | 2751.00  | 1841.00  | 868.00   | 2805.00  | 695.00   | 606.00   | SSF Capacity and Delivery                                       | New          | 10023592    |
    | 10017258 | 1619F-258      | SSF-2582      | 115             | 0                     | 22617.00  | 301.00   | 2683.00  | 222.00   | 2920.00  | 3211.00  | 1354.00  | 3226.00  | 326.00   | 3592.00  | 1195.00  | 983.00   | 2604.00  | SSF Capacity and Delivery Bursary Funds                         | New          | 10023592    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2018'

    # Bulk import to execute an update draft which also adds new deliverables to the contract
    And   there are no files prefixed '10017258_1619F-258' in the Sharepoint '1619FUND-1819-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1819 17012019171819 v3_A258' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1819 17012019171819 v3_A258' in the Sharepoint 'Reports' folder
    And   spreadsheet '1619FUND AY 1819 17012019171819 v3_A258.xlsx' exists in the Datafiles folder and UKPRN '10017258' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

#   # Create a dummy Appendix file containing just the word 'Appendices'
#   Given there are no files prefixed '10017258_1619F-258' in the Sharepoint '1619FUND-1819-Input-Appendices' folder
#   And   a file with filename '10017258_1619F-258_v1.pdf' is created in '1619FUND-1819-Input-Appendices'

    # Create two dummy Terms and Conditions files. Each has just one page containing just the work 'Appendices'
    Given there are no files prefixed '10017258_1619F-258' in the Sharepoint '1619FUND-1819-Input-Terms And Conditions' folder
    And   a file with filename '10017258_1619F-258_11.pdf' is created in '1619FUND-1819-Input-Terms And Conditions'
    And   a file with filename '10017258_1619F-258_61.pdf' is created in '1619FUND-1819-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '1' of contract '1619F-258' for provider '10017258' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '1619F-258' for provider '10017258'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017258 - 10017258 Co Ltd Please review the contract       | 1619F-258      | FCS2 Test                | Contract Advisers Team   | Open            | Not Started      |


    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '1' of contract '1619F-258' for provider '10017258' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '1619F-258' for provider '10017258'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017258 - 10017258 Co Ltd                                  | 1619F-258      | FCS1 Test                | Contract Managers Team   | Open            | Not Started      |


    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When  the following open Task currently linked to version '1' of contract '1619F-258' for provider '10017258' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '1619F-258' for provider '10017258'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017258 - 10017258 Co Ltd                                  | 1619F-258      | Lead Manager Team         | ?                        | Open            | Not Started      |


    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When  the following open Task currently linked to version '1' of contract '1619F-258' for provider '10017258' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |


    # Check that the Tasks on the contract are all marked as completed
    Then  the following Tasks are present against version '1' of contract '1619F-258' for provider '10017258'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017258 - 10017258 Co Ltd                                  | 1619F-258      | Lead Manager Team         | ?                        | Completed       | Completed        |
    | Confirm Internal Approval        | 10017258 - 10017258 Co Ltd                                  | 1619F-258      | FCS1 Test                | Contract Managers Team   | Completed       | Completed        |
    | Review Contract Details          | 10017258 - 10017258 Co Ltd Please review the contract       | 1619F-258      | FCS2 Test                | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017258 - 10017258 Co Ltd Awaiting documentation           | 1619F-258      | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017258 | 1619F-258          | 1                     | 1                        | Draft            | Published to Provider     | True          | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017258 | 1619F-258          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017258 | ESFA-258           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

	# Retrieve parameters
   #Then  I retrieve the latest EFA contract details from CRM for provider '10017258' for FundingType '1619FUND' and period '1819' and Delivery Organisation '00000000'
    Then  I retrieve the latest contract details from CRM for provider '10017258' for FundingType '1619FUND' and period '1819'

    # Check the page numbering in the Payment Schedule
    And   a file for this contract exists in sharepoint location '1619FUND-1819-Input-Appendices'
    And   the pdf file contains the following page lines in order
	"""
	Page 1 of 8 of the Payment Schedules
	Page 2 of 8 of the Payment Schedules
	Page 3 of 8 of the Payment Schedules
	Page 4 of 8 of the Payment Schedules
	Page 5 of 8 of the Payment Schedules
	Page 6 of 8 of the Payment Schedules
	Page 7 of 8 of the Payment Schedules
	Page 8 of 8 of the Payment Schedules
	"""

    # Change the date
    And   the override date is '05/07/2018'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-258' and actual ContractNumber '1619F-258'
#	When  contract approval messages arrive for the following contracts
#    | MasterContractNumber | ContractNumber | Version |
#    | ESFA-258             | 1619F-258      | 1       |

    # Check that the contract is now approved
    Then  the latest version of contract '1619F-258' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017258 | 1619F-258          | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017258 | 1619F-258          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017258 | ESFA-258           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '540' deliverable period rows in CRM linked to the latest version of contract '1619F-258'




    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | 1619F-258      | 16LR-2581       | 18              | 20455.00 | 0.00     | 0.00     | 0.00     | 750.00   | 2500.00  | 1875.00  | 0.00     | 2125.00  | 0.00     | 7500.00  | 2560.00  | 3145.00  | 
    | 1619F-258      | 16LR-2581       | 21              | 6401.00  | -3666.74 | -3592.77 | 0.00     | 4683.18  | 0.00     | 2376.85  | 1391.36  | 0.00     | 1794.25  | 0.00     | 0.00     | 3414.87  | 
    | 1619F-258      | 16LR-2581       | 31              | 20395.00 | -1104.82 | 0.00     | 0.00     | 0.00     | 3995.82  | 0.00     | 0.00     | 4894.67  | 4333.17  | 0.00     | 3890.08  | 4386.08  | 
    | 1619F-258      | 16LR-2581       | 32              | 22897.00 | 0.00     | -4532.39 | 0.00     | 492.51   | 4756.16  | 4829.13  | 4564.76  | 0.00     | 4842.81  | 810.75   | 4776.26  | 2357.01  | 
    | 1619F-258      | 16LR-2581       | 111             | 3642.00  | -4819.85 | -1711.53 | 0.00     | 1847.12  | 0.00     | 0.00     | 4947.55  | 2905.58  | 0.00     | 472.41   | 0.00     | 0.72     | 
    | 1619F-258      | 16LR-2581       | 112             | 7774.00  | -4306.23 | 0.00     | 0.00     | 3454.42  | 0.00     | 0.00     | 631.03   | 4260.21  | 2978.56  | 387.76   | 0.00     | 368.25   | 
    | 1619F-258      | 16LR-2581       | 113             | 8385.00  | -3539.89 | 0.00     | 0.00     | 0.00     | 0.00     | 684.91   | 2832.61  | 915.51   | 1920.09  | 1867.22  | 3295.81  | 408.74   | 
    #
    | 1619F-258      | NMF-2581        | 1               | 3891.00  | -4570.72 | -995.21  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8856.09  | 600.84   | 
    | 1619F-258      | NMF-2581        | 51              | 8919.00  | -3076.27 | 0.00     | 0.00     | 0.00     | 0.00     | 4738.92  | 455.18   | 2855.58  | 3819.97  | 125.27   | 0.00     | 0.35     | 
    | 1619F-258      | NMF-2581        | 52              | 9117.00  | -1709.66 | -1676.88 | 0.00     | 3026.87  | 4368.81  | 548.26   | 0.00     | 0.00     | 2041.38  | 633.91   | 0.00     | 1884.31  | 
    | 1619F-258      | NMF-2581        | 53              | 7128.00  | -88.36   | -4070.76 | 0.00     | 0.00     | 772.42   | 0.00     | 0.00     | 0.00     | 1830.88  | 0.00     | 4348.71  | 4335.11  | 
    | 1619F-258      | NMF-2581        | 100             | 16357.00 | -555.54  | -3556.13 | 0.00     | 4547.53  | 2379.72  | 0.00     | 0.00     | 1374.13  | 3185.49  | 0.00     | 4262.07  | 4719.73  | 
    | 1619F-258      | NMF-2581        | 101             | 15488.00 | -769.04  | 0.00     | 0.00     | 3363.22  | 601.13   | 2326.84  | 0.00     | 0.00     | 4791.79  | 3978.59  | 792.52   | 402.95   | 
    | 1619F-258      | NMF-2581        | 102             | 13950.00 | 0.00     | -4110.96 | 0.00     | 2431.59  | 389.63   | 4401.58  | 2907.46  | 1077.98  | 3013.21  | 0.00     | 3839.08  | 0.43     | 
    | 1619F-258      | NMF-2581        | 103             | 9326.00  | 0.00     | -182.43  | 0.00     | 3066.08  | 0.00     | 1777.02  | 0.00     | 1460.77  | 2802.71  | 296.56   | 0.00     | 105.29   | 
    | 1619F-258      | NMF-2581        | 116             | -2149.00 | -4570.72 | -995.21  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3416.09  | 0.84     | 
    | 1619F-258      | NMF-2581        | 120             | 7292.42  | -150.72  | 2121.21  | 0.00     | 125.00   | 0.00     | 375.00   | 0.00     | 0.00     | 0.00     | 1615.00  | 2806.09  | 400.84   | 
    #
    | 1619F-258      | SSF-2581        | 16              | 16438.00 | -2342.69 | -1611.33 | 0.00     | 2678.25  | 1009.01  | 2477.15  | 0.00     | 0.00     | 6125.41  | 0.00     | 6223.03  | 1879.17  | 
    | 1619F-258      | SSF-2581        | 18              | 12170.00 | -162.83  | -515.84  | 0.00     | 0.00     | 0.00     | 3984.52  | 4017.31  | 1426.51  | 0.00     | 91.01    | 2537.84  | 791.48   | 
    | 1619F-258      | SSF-2581        | 47              | 18753.00 | -2683.55 | 0.00     | 0.00     | 408.24   | 2557.94  | 1955.24  | 2960.82  | 2907.95  | 4335.54  | 1446.61  | 4863.27  | 0.94     | 
    | 1619F-258      | SSF-2581        | 114             | 6830.00  | -3623.18 | -2523.93 | 0.00     | 0.00     | 1373.62  | 0.00     | 2154.06  | 1003.51  | 1585.12  | 3053.91  | 3806.81  | 0.08     | 
    | 1619F-258      | SSF-2581        | 115             | 13475.00 | -2983.69 | -1156.33 | 0.00     | 4936.25  | 441.01   | 4916.15  | 0.00     | 0.00     | 4037.41  | 0.00     | 3000.03  | 284.17   | 
    #
    | 1619F-258      | 16LR-2582       | 8               | 14317.00 | 0.00     | 0.00     | 0.00     | 1982.00  | 295.00   | 378.00   | 0.00     | 2500.00  | 0.00     | 2212.00  | 1750.00  | 5200.00  | 
    | 1619F-258      | 16LR-2582       | 19              | 15593.00 | -39.04   | -52.71   | 0.00     | 2097.13  | 4582.18  | 213.78   | 2996.97  | 0.00     | 0.00     | 1991.38  | 3802.74  | 0.57     | 
    | 1619F-258      | 16LR-2582       | 20              | 2592.00  | -126.68  | -4662.92 | 0.00     | 0.00     | 0.00     | 3980.47  | 0.00     | 2943.11  | 0.00     | 0.00     | 457.05   | 0.97     | 
    | 1619F-258      | 16LR-2582       | 32              | 14475.00 | 0.00     | 0.00     | 0.00     | 3954.62  | 768.55   | 378.33   | 0.00     | 907.07   | 0.00     | 2408.62  | 1680.07  | 4377.74  | 
    | 1619F-258      | 16LR-2582       | 111             | 12617.00 | -813.12  | -2660.58 | 0.00     | 0.00     | 3815.11  | 0.00     | 0.00     | 4800.61  | 1363.82  | 4357.51  | 0.00     | 1753.65  | 
    | 1619F-258      | 16LR-2582       | 112             | 6616.00  | 0.00     | -3601.19 | 0.00     | 272.58   | 0.00     | 81.19    | 451.31   | 358.23   | 4410.38  | 0.00     | 4642.97  | 0.53     | 
    | 1619F-258      | 16LR-2582       | 113             | 10220.00 | 0.00     | 0.00     | 0.00     | 0.00     | 3392.12  | 0.00     | 0.00     | 0.00     | 2758.63  | 0.00     | 2864.38  | 1204.87  | 
    #
    | 1619F-258      | NMF-2582        | 3               | 10461.00 | 0.00     | -3777.95 | 0.00     | 2143.89  | 0.00     | 4545.46  | 2887.23  | 0.00     | 0.00     | 0.00     | 3423.62  | 1238.75  | 
    | 1619F-258      | NMF-2582        | 31              | 4557.00  | -3505.94 | 0.00     | 0.00     | 1709.78  | 0.00     | 0.00     | 1550.16  | 949.45   | 1953.05  | 1900.18  | 0.00     | 0.32     | 
    | 1619F-258      | NMF-2582        | 32              | 14245.00 | 0.00     | -357.41  | 0.00     | 1497.29  | 0.00     | 4016.11  | 367.84   | 0.00     | 1147.28  | 4948.73  | 578.34   | 2046.82  | 
    | 1619F-258      | NMF-2582        | 33              | 11926.00 | 0.00     | -3859.95 | 0.00     | 2852.89  | 0.00     | 3930.46  | 4386.23  | 0.00     | 0.00     | 0.00     | 3031.62  | 1584.75  | 
    | 1619F-258      | NMF-2582        | 103             | 11026.00 | 0.00     | -4078.19 | 0.00     | 4201.76  | 0.00     | 1894.43  | 0.00     | 2126.03  | 0.00     | 3078.74  | 869.73   | 2933.50  | 
    | 1619F-258      | NMF-2582        | 116             | -65.00   | -3639.53 | -2838.43 | 0.00     | 0.00     | 4868.02  | 0.00     | 1544.42  | 0.00     | 0.00     | 0.00     | 0.00     | 0.52     | 
    | 1619F-258      | NMF-2582        | 118             | 22671.35 | 3005.09  | 1250.23  | 0.00     | 985.25   | 3986.55  | 7225.33  | 2083.33  | 0.00     | 4135.56  | 0.00     | 0.00     | 0.01     | 
    | 1619F-258      | NMF-2582        | 119             | 10074.35 | 2645.09  | 1089.23  | 0.00     | 350.25   | 4125.55  | 75.33    | 1723.33  | 0.00     | 65.56    | 0.00     | 0.00     | 0.01     | 
    #
    | 1619F-258      | SSF-2582        | 2               | 793.00   | -4537.76 | -962.25  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2134.64  | 4158.37  | 
    | 1619F-258      | SSF-2582        | 12              | 3674.00  | -1641.25 | 0.00     | 0.00     | 1401.34  | 0.00     | 1804.23  | 0.00     | 0.00     | 2108.79  | 0.00     | 0.00     | 0.89     | 
    | 1619F-258      | SSF-2582        | 13              | 15474.00 | 0.00     | 0.00     | 0.00     | 0.00     | 1606.91  | 4897.73  | 3357.65  | 3939.27  | 0.00     | 0.00     | 905.38   | 767.06   | 
    | 1619F-258      | SSF-2582        | 17              | 2642.00  | -2622.07 | -2462.45 | 0.00     | 0.00     | 0.00     | 0.00     | 4415.13  | 2458.81  | 0.00     | 0.00     | 0.00     | 852.58   | 
    | 1619F-258      | SSF-2582        | 18              | 14981.00 | 0.00     | -1695.12 | 0.00     | 4448.89  | 4818.02  | 3410.53  | 2511.68  | 0.00     | 0.00     | 0.00     | 0.00     | 1487.00  | 
    | 1619F-258      | SSF-2582        | 47              | 1939.00  | -1468.95 | -3016.28 | 0.00     | 3516.28  | 0.00     | 534.27   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2373.68  | 
    | 1619F-258      | SSF-2582        | 114             | 1614.00  | 0.00     | -4083.75 | 0.00     | 0.00     | 0.00     | 2861.69  | 0.00     | 0.00     | 0.00     | 1381.24  | 1454.22  | 0.60     | 
    | 1619F-258      | SSF-2582        | 115             | 3674.00  | -1641.25 | 0.00     | 0.00     | 1401.34  | 0.00     | 1804.23  | 0.00     | 0.00     | 2108.79  | 0.00     | 0.00     | 0.89     | 


    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | 16LR-2581        | 1             | 18              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 21              | 201808 | 2              | 0             | -3666.74     | -3666.74             | 0.00                | 0.00                   | 0.00                        | -3666.74         | ?            | ?           |
    | 16LR-2581        | 1             | 31              | 201808 | 2              | 0             | -1104.82     | -1104.82             | 0.00                | 0.00                   | 0.00                        | -1104.82         | ?            | ?           |
    | 16LR-2581        | 1             | 32              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 111             | 201808 | 2              | 0             | -4819.85     | -4819.85             | 0.00                | 0.00                   | 0.00                        | -4819.85         | ?            | ?           |
    | 16LR-2581        | 1             | 112             | 201808 | 2              | 0             | -4306.23     | -4306.23             | 0.00                | 0.00                   | 0.00                        | -4306.23         | ?            | ?           |
    | 16LR-2581        | 1             | 113             | 201808 | 2              | 0             | -3539.89     | -3539.89             | 0.00                | 0.00                   | 0.00                        | -3539.89         | ?            | ?           |
    #
    | 16LR-2581        | 1             | 18              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 21              | 201809 | 2              | 0             | -3592.77     | -3592.77             | 0.00                | 0.00                   | 0.00                        | -3592.77         | ?            | ?           |
    | 16LR-2581        | 1             | 31              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 32              | 201809 | 2              | 0             | -4532.39     | -4532.39             | 0.00                | 0.00                   | 0.00                        | -4532.39         | ?            | ?           |
    | 16LR-2581        | 1             | 111             | 201809 | 2              | 0             | -1711.53     | -1711.53             | 0.00                | 0.00                   | 0.00                        | -1711.53         | ?            | ?           |
    | 16LR-2581        | 1             | 112             | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 113             | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | 16LR-2581        | 1             | 18              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 21              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 31              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 32              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 111             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 112             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 113             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | 16LR-2581        | 1             | 18              | 201811 | 2              | 0             | 750.00       | 750.00               | 0.00                | 0.00                   | 0.00                        | 750.00           | ?            | ?           |
    | 16LR-2581        | 1             | 21              | 201811 | 2              | 0             | 4683.18      | 4683.18              | 0.00                | 0.00                   | 0.00                        | 4683.18          | ?            | ?           |
    | 16LR-2581        | 1             | 31              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 32              | 201811 | 2              | 0             | 492.51       | 492.51               | 0.00                | 0.00                   | 0.00                        | 492.51           | ?            | ?           |
    | 16LR-2581        | 1             | 111             | 201811 | 2              | 0             | 1847.12      | 1847.12              | 0.00                | 0.00                   | 0.00                        | 1847.12          | ?            | ?           |
    | 16LR-2581        | 1             | 112             | 201811 | 2              | 0             | 3454.42      | 3454.42              | 0.00                | 0.00                   | 0.00                        | 3454.42          | ?            | ?           |
    | 16LR-2581        | 1             | 113             | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | 16LR-2581        | 1             | 18              | 201812 | 2              | 0             | 2500.00      | 2500.00              | 0.00                | 0.00                   | 0.00                        | 2500.00          | ?            | ?           |
    | 16LR-2581        | 1             | 21              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 31              | 201812 | 2              | 0             | 3995.82      | 3995.82              | 0.00                | 0.00                   | 0.00                        | 3995.82          | ?            | ?           |
    | 16LR-2581        | 1             | 32              | 201812 | 2              | 0             | 4756.16      | 4756.16              | 0.00                | 0.00                   | 0.00                        | 4756.16          | ?            | ?           |
    | 16LR-2581        | 1             | 111             | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 112             | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 113             | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | 16LR-2581        | 1             | 18              | 201901 | 2              | 0             | 1875.00      | 1875.00              | 0.00                | 0.00                   | 0.00                        | 1875.00          | ?            | ?           |
    | 16LR-2581        | 1             | 21              | 201901 | 2              | 0             | 2376.85      | 2376.85              | 0.00                | 0.00                   | 0.00                        | 2376.85          | ?            | ?           |
    | 16LR-2581        | 1             | 31              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 32              | 201901 | 2              | 0             | 4829.13      | 4829.13              | 0.00                | 0.00                   | 0.00                        | 4829.13          | ?            | ?           |
    | 16LR-2581        | 1             | 111             | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 112             | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 113             | 201901 | 2              | 0             | 684.91       | 684.91               | 0.00                | 0.00                   | 0.00                        | 684.91           | ?            | ?           |
    #
    | 16LR-2581        | 1             | 18              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 21              | 201902 | 2              | 0             | 1391.36      | 1391.36              | 0.00                | 0.00                   | 0.00                        | 1391.36          | ?            | ?           |
    | 16LR-2581        | 1             | 31              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 32              | 201902 | 2              | 0             | 4564.76      | 4564.76              | 0.00                | 0.00                   | 0.00                        | 4564.76          | ?            | ?           |
    | 16LR-2581        | 1             | 111             | 201902 | 2              | 0             | 4947.55      | 4947.55              | 0.00                | 0.00                   | 0.00                        | 4947.55          | ?            | ?           |
    | 16LR-2581        | 1             | 112             | 201902 | 2              | 0             | 631.03       | 631.03               | 0.00                | 0.00                   | 0.00                        | 631.03           | ?            | ?           |
    | 16LR-2581        | 1             | 113             | 201902 | 2              | 0             | 2832.61      | 2832.61              | 0.00                | 0.00                   | 0.00                        | 2832.61          | ?            | ?           |
    #
    | 16LR-2581        | 1             | 18              | 201903 | 2              | 0             | 2125.00      | 2125.00              | 0.00                | 0.00                   | 0.00                        | 2125.00          | ?            | ?           |
    | 16LR-2581        | 1             | 21              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 31              | 201903 | 2              | 0             | 4894.67      | 4894.67              | 0.00                | 0.00                   | 0.00                        | 4894.67          | ?            | ?           |
    | 16LR-2581        | 1             | 32              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 111             | 201903 | 2              | 0             | 2905.58      | 2905.58              | 0.00                | 0.00                   | 0.00                        | 2905.58          | ?            | ?           |
    | 16LR-2581        | 1             | 112             | 201903 | 2              | 0             | 4260.21      | 4260.21              | 0.00                | 0.00                   | 0.00                        | 4260.21          | ?            | ?           |
    | 16LR-2581        | 1             | 113             | 201903 | 2              | 0             | 915.51       | 915.51               | 0.00                | 0.00                   | 0.00                        | 915.51           | ?            | ?           |
    #
    | 16LR-2581        | 1             | 18              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 21              | 201904 | 2              | 0             | 1794.25      | 1794.25              | 0.00                | 0.00                   | 0.00                        | 1794.25          | ?            | ?           |
    | 16LR-2581        | 1             | 31              | 201904 | 2              | 0             | 4333.17      | 4333.17              | 0.00                | 0.00                   | 0.00                        | 4333.17          | ?            | ?           |
    | 16LR-2581        | 1             | 32              | 201904 | 2              | 0             | 4842.81      | 4842.81              | 0.00                | 0.00                   | 0.00                        | 4842.81          | ?            | ?           |
    | 16LR-2581        | 1             | 111             | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 112             | 201904 | 2              | 0             | 2978.56      | 2978.56              | 0.00                | 0.00                   | 0.00                        | 2978.56          | ?            | ?           |
    | 16LR-2581        | 1             | 113             | 201904 | 2              | 0             | 1920.09      | 1920.09              | 0.00                | 0.00                   | 0.00                        | 1920.09          | ?            | ?           |
    #
    | 16LR-2581        | 1             | 18              | 201905 | 2              | 0             | 7500.00      | 7500.00              | 0.00                | 0.00                   | 0.00                        | 7500.00          | ?            | ?           |
    | 16LR-2581        | 1             | 21              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 31              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 32              | 201905 | 2              | 0             | 810.75       | 810.75               | 0.00                | 0.00                   | 0.00                        | 810.75           | ?            | ?           |
    | 16LR-2581        | 1             | 111             | 201905 | 2              | 0             | 472.41       | 472.41               | 0.00                | 0.00                   | 0.00                        | 472.41           | ?            | ?           |
    | 16LR-2581        | 1             | 112             | 201905 | 2              | 0             | 387.76       | 387.76               | 0.00                | 0.00                   | 0.00                        | 387.76           | ?            | ?           |
    | 16LR-2581        | 1             | 113             | 201905 | 2              | 0             | 1867.22      | 1867.22              | 0.00                | 0.00                   | 0.00                        | 1867.22          | ?            | ?           |
    #
    | 16LR-2581        | 1             | 18              | 201906 | 2              | 0             | 2560.00      | 2560.00              | 0.00                | 0.00                   | 0.00                        | 2560.00          | ?            | ?           |
    | 16LR-2581        | 1             | 21              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 31              | 201906 | 2              | 0             | 3890.08      | 3890.08              | 0.00                | 0.00                   | 0.00                        | 3890.08          | ?            | ?           |
    | 16LR-2581        | 1             | 32              | 201906 | 2              | 0             | 4776.26      | 4776.26              | 0.00                | 0.00                   | 0.00                        | 4776.26          | ?            | ?           |
    | 16LR-2581        | 1             | 111             | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 112             | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2581        | 1             | 113             | 201906 | 2              | 0             | 3295.81      | 3295.81              | 0.00                | 0.00                   | 0.00                        | 3295.81          | ?            | ?           |
    #
    | 16LR-2581        | 1             | 18              | 201907 | 2              | 0             | 3145.00      | 3145.00              | 0.00                | 0.00                   | 0.00                        | 3145.00          | ?            | ?           |
    | 16LR-2581        | 1             | 21              | 201907 | 2              | 0             | 3414.87      | 3414.87              | 0.00                | 0.00                   | 0.00                        | 3414.87          | ?            | ?           |
    | 16LR-2581        | 1             | 31              | 201907 | 2              | 0             | 4386.08      | 4386.08              | 0.00                | 0.00                   | 0.00                        | 4386.08          | ?            | ?           |
    | 16LR-2581        | 1             | 32              | 201907 | 2              | 0             | 2357.01      | 2357.01              | 0.00                | 0.00                   | 0.00                        | 2357.01          | ?            | ?           |
    | 16LR-2581        | 1             | 111             | 201907 | 2              | 0             | 0.72         | 0.72                 | 0.00                | 0.00                   | 0.00                        | 0.72             | ?            | ?           |
    | 16LR-2581        | 1             | 112             | 201907 | 2              | 0             | 368.25       | 368.25               | 0.00                | 0.00                   | 0.00                        | 368.25           | ?            | ?           |
    | 16LR-2581        | 1             | 113             | 201907 | 2              | 0             | 408.74       | 408.74               | 0.00                | 0.00                   | 0.00                        | 408.74           | ?            | ?           |
    #
    | NMF-2581         | 1             | 1               | 201808 | 2              | 0             | -4570.72     | -4570.72             | 0.00                | 0.00                   | 0.00                        | -4570.72         | ?            | ?           |
    | NMF-2581         | 1             | 51              | 201808 | 2              | 0             | -3076.27     | -3076.27             | 0.00                | 0.00                   | 0.00                        | -3076.27         | ?            | ?           |
    | NMF-2581         | 1             | 52              | 201808 | 2              | 0             | -1709.66     | -1709.66             | 0.00                | 0.00                   | 0.00                        | -1709.66         | ?            | ?           |
    | NMF-2581         | 1             | 53              | 201808 | 2              | 0             | -88.36       | -88.36               | 0.00                | 0.00                   | 0.00                        | -88.36           | ?            | ?           |
    | NMF-2581         | 1             | 100             | 201808 | 2              | 0             | -555.54      | -555.54              | 0.00                | 0.00                   | 0.00                        | -555.54          | ?            | ?           |
    | NMF-2581         | 1             | 101             | 201808 | 2              | 0             | -769.04      | -769.04              | 0.00                | 0.00                   | 0.00                        | -769.04          | ?            | ?           |
    | NMF-2581         | 1             | 102             | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 103             | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 116             | 201808 | 2              | 0             | -4570.72     | -4570.72             | 0.00                | 0.00                   | 0.00                        | -4570.72         | ?            | ?           |
    | NMF-2581         | 1             | 120             | 201808 | 2              | 0             | -150.72      | -150.72              | 0.00                | 0.00                   | 0.00                        | -150.72          | ?            | ?           |
    #
    | NMF-2581         | 1             | 1               | 201809 | 2              | 0             | -995.21      | -995.21              | 0.00                | 0.00                   | 0.00                        | -995.21          | ?            | ?           |
    | NMF-2581         | 1             | 51              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 52              | 201809 | 2              | 0             | -1676.88     | -1676.88             | 0.00                | 0.00                   | 0.00                        | -1676.88         | ?            | ?           |
    | NMF-2581         | 1             | 53              | 201809 | 2              | 0             | -4070.76     | -4070.76             | 0.00                | 0.00                   | 0.00                        | -4070.76         | ?            | ?           |
    | NMF-2581         | 1             | 100             | 201809 | 2              | 0             | -3556.13     | -3556.13             | 0.00                | 0.00                   | 0.00                        | -3556.13         | ?            | ?           |
    | NMF-2581         | 1             | 101             | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 102             | 201809 | 2              | 0             | -4110.96     | -4110.96             | 0.00                | 0.00                   | 0.00                        | -4110.96         | ?            | ?           |
    | NMF-2581         | 1             | 103             | 201809 | 2              | 0             | -182.43      | -182.43              | 0.00                | 0.00                   | 0.00                        | -182.43          | ?            | ?           |
    | NMF-2581         | 1             | 116             | 201809 | 2              | 0             | -995.21      | -995.21              | 0.00                | 0.00                   | 0.00                        | -995.21          | ?            | ?           |
    | NMF-2581         | 1             | 120             | 201809 | 2              | 0             | 2121.21      | 2121.21              | 0.00                | 0.00                   | 0.00                        | 2121.21          | ?            | ?           |
    #
    | NMF-2581         | 1             | 1               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 51              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 52              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 53              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 100             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 101             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 102             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 103             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 116             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 120             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NMF-2581         | 1             | 1               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 51              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 52              | 201811 | 2              | 0             | 3026.87      | 3026.87              | 0.00                | 0.00                   | 0.00                        | 3026.87          | ?            | ?           |
    | NMF-2581         | 1             | 53              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 100             | 201811 | 2              | 0             | 4547.53      | 4547.53              | 0.00                | 0.00                   | 0.00                        | 4547.53          | ?            | ?           |
    | NMF-2581         | 1             | 101             | 201811 | 2              | 0             | 3363.22      | 3363.22              | 0.00                | 0.00                   | 0.00                        | 3363.22          | ?            | ?           |
    | NMF-2581         | 1             | 102             | 201811 | 2              | 0             | 2431.59      | 2431.59              | 0.00                | 0.00                   | 0.00                        | 2431.59          | ?            | ?           |
    | NMF-2581         | 1             | 103             | 201811 | 2              | 0             | 3066.08      | 3066.08              | 0.00                | 0.00                   | 0.00                        | 3066.08          | ?            | ?           |
    | NMF-2581         | 1             | 116             | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 120             | 201811 | 2              | 0             | 125.00       | 125.00               | 0.00                | 0.00                   | 0.00                        | 125.00           | ?            | ?           |
    #
    | NMF-2581         | 1             | 1               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 51              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 52              | 201812 | 2              | 0             | 4368.81      | 4368.81              | 0.00                | 0.00                   | 0.00                        | 4368.81          | ?            | ?           |
    | NMF-2581         | 1             | 53              | 201812 | 2              | 0             | 772.42       | 772.42               | 0.00                | 0.00                   | 0.00                        | 772.42           | ?            | ?           |
    | NMF-2581         | 1             | 100             | 201812 | 2              | 0             | 2379.72      | 2379.72              | 0.00                | 0.00                   | 0.00                        | 2379.72          | ?            | ?           |
    | NMF-2581         | 1             | 101             | 201812 | 2              | 0             | 601.13       | 601.13               | 0.00                | 0.00                   | 0.00                        | 601.13           | ?            | ?           |
    | NMF-2581         | 1             | 102             | 201812 | 2              | 0             | 389.63       | 389.63               | 0.00                | 0.00                   | 0.00                        | 389.63           | ?            | ?           |
    | NMF-2581         | 1             | 103             | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 116             | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 120             | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NMF-2581         | 1             | 1               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 51              | 201901 | 2              | 0             | 4738.92      | 4738.92              | 0.00                | 0.00                   | 0.00                        | 4738.92          | ?            | ?           |
    | NMF-2581         | 1             | 52              | 201901 | 2              | 0             | 548.26       | 548.26               | 0.00                | 0.00                   | 0.00                        | 548.26           | ?            | ?           |
    | NMF-2581         | 1             | 53              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 100             | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 101             | 201901 | 2              | 0             | 2326.84      | 2326.84              | 0.00                | 0.00                   | 0.00                        | 2326.84          | ?            | ?           |
    | NMF-2581         | 1             | 102             | 201901 | 2              | 0             | 4401.58      | 4401.58              | 0.00                | 0.00                   | 0.00                        | 4401.58          | ?            | ?           |
    | NMF-2581         | 1             | 103             | 201901 | 2              | 0             | 1777.02      | 1777.02              | 0.00                | 0.00                   | 0.00                        | 1777.02          | ?            | ?           |
    | NMF-2581         | 1             | 116             | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 120             | 201901 | 2              | 0             | 375.00       | 375.00               | 0.00                | 0.00                   | 0.00                        | 375.00           | ?            | ?           |
    #
    | NMF-2581         | 1             | 1               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 51              | 201902 | 2              | 0             | 455.18       | 455.18               | 0.00                | 0.00                   | 0.00                        | 455.18           | ?            | ?           |
    | NMF-2581         | 1             | 52              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 53              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 100             | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 101             | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 102             | 201902 | 2              | 0             | 2907.46      | 2907.46              | 0.00                | 0.00                   | 0.00                        | 2907.46          | ?            | ?           |
    | NMF-2581         | 1             | 103             | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 116             | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 120             | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NMF-2581         | 1             | 1               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 51              | 201903 | 2              | 0             | 2855.58      | 2855.58              | 0.00                | 0.00                   | 0.00                        | 2855.58          | ?            | ?           |
    | NMF-2581         | 1             | 52              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 53              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 100             | 201903 | 2              | 0             | 1374.13      | 1374.13              | 0.00                | 0.00                   | 0.00                        | 1374.13          | ?            | ?           |
    | NMF-2581         | 1             | 101             | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 102             | 201903 | 2              | 0             | 1077.98      | 1077.98              | 0.00                | 0.00                   | 0.00                        | 1077.98          | ?            | ?           |
    | NMF-2581         | 1             | 103             | 201903 | 2              | 0             | 1460.77      | 1460.77              | 0.00                | 0.00                   | 0.00                        | 1460.77          | ?            | ?           |
    | NMF-2581         | 1             | 116             | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 120             | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NMF-2581         | 1             | 1               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 51              | 201904 | 2              | 0             | 3819.97      | 3819.97              | 0.00                | 0.00                   | 0.00                        | 3819.97          | ?            | ?           |
    | NMF-2581         | 1             | 52              | 201904 | 2              | 0             | 2041.38      | 2041.38              | 0.00                | 0.00                   | 0.00                        | 2041.38          | ?            | ?           |
    | NMF-2581         | 1             | 53              | 201904 | 2              | 0             | 1830.88      | 1830.88              | 0.00                | 0.00                   | 0.00                        | 1830.88          | ?            | ?           |
    | NMF-2581         | 1             | 100             | 201904 | 2              | 0             | 3185.49      | 3185.49              | 0.00                | 0.00                   | 0.00                        | 3185.49          | ?            | ?           |
    | NMF-2581         | 1             | 101             | 201904 | 2              | 0             | 4791.79      | 4791.79              | 0.00                | 0.00                   | 0.00                        | 4791.79          | ?            | ?           |
    | NMF-2581         | 1             | 102             | 201904 | 2              | 0             | 3013.21      | 3013.21              | 0.00                | 0.00                   | 0.00                        | 3013.21          | ?            | ?           |
    | NMF-2581         | 1             | 103             | 201904 | 2              | 0             | 2802.71      | 2802.71              | 0.00                | 0.00                   | 0.00                        | 2802.71          | ?            | ?           |
    | NMF-2581         | 1             | 116             | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 120             | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NMF-2581         | 1             | 1               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 51              | 201905 | 2              | 0             | 125.27       | 125.27               | 0.00                | 0.00                   | 0.00                        | 125.27           | ?            | ?           |
    | NMF-2581         | 1             | 52              | 201905 | 2              | 0             | 633.91       | 633.91               | 0.00                | 0.00                   | 0.00                        | 633.91           | ?            | ?           |
    | NMF-2581         | 1             | 53              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 100             | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 101             | 201905 | 2              | 0             | 3978.59      | 3978.59              | 0.00                | 0.00                   | 0.00                        | 3978.59          | ?            | ?           |
    | NMF-2581         | 1             | 102             | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 103             | 201905 | 2              | 0             | 296.56       | 296.56               | 0.00                | 0.00                   | 0.00                        | 296.56           | ?            | ?           |
    | NMF-2581         | 1             | 116             | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 120             | 201905 | 2              | 0             | 1615.00      | 1615.00              | 0.00                | 0.00                   | 0.00                        | 1615.00          | ?            | ?           |
    #
    | NMF-2581         | 1             | 1               | 201906 | 2              | 0             | 8856.09      | 8856.09              | 0.00                | 0.00                   | 0.00                        | 8856.09          | ?            | ?           |
    | NMF-2581         | 1             | 51              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 52              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 53              | 201906 | 2              | 0             | 4348.71      | 4348.71              | 0.00                | 0.00                   | 0.00                        | 4348.71          | ?            | ?           |
    | NMF-2581         | 1             | 100             | 201906 | 2              | 0             | 4262.07      | 4262.07              | 0.00                | 0.00                   | 0.00                        | 4262.07          | ?            | ?           |
    | NMF-2581         | 1             | 101             | 201906 | 2              | 0             | 792.52       | 792.52               | 0.00                | 0.00                   | 0.00                        | 792.52           | ?            | ?           |
    | NMF-2581         | 1             | 102             | 201906 | 2              | 0             | 3839.08      | 3839.08              | 0.00                | 0.00                   | 0.00                        | 3839.08          | ?            | ?           |
    | NMF-2581         | 1             | 103             | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2581         | 1             | 116             | 201906 | 2              | 0             | 3416.09      | 3416.09              | 0.00                | 0.00                   | 0.00                        | 3416.09          | ?            | ?           |
    | NMF-2581         | 1             | 120             | 201906 | 2              | 0             | 2806.09      | 2806.09              | 0.00                | 0.00                   | 0.00                        | 2806.09          | ?            | ?           |
    #
    | NMF-2581         | 1             | 1               | 201907 | 2              | 0             | 600.84       | 600.84               | 0.00                | 0.00                   | 0.00                        | 600.84           | ?            | ?           |
    | NMF-2581         | 1             | 51              | 201907 | 2              | 0             | 0.35         | 0.35                 | 0.00                | 0.00                   | 0.00                        | 0.35             | ?            | ?           |
    | NMF-2581         | 1             | 52              | 201907 | 2              | 0             | 1884.31      | 1884.31              | 0.00                | 0.00                   | 0.00                        | 1884.31          | ?            | ?           |
    | NMF-2581         | 1             | 53              | 201907 | 2              | 0             | 4335.11      | 4335.11              | 0.00                | 0.00                   | 0.00                        | 4335.11          | ?            | ?           |
    | NMF-2581         | 1             | 100             | 201907 | 2              | 0             | 4719.73      | 4719.73              | 0.00                | 0.00                   | 0.00                        | 4719.73          | ?            | ?           |
    | NMF-2581         | 1             | 101             | 201907 | 2              | 0             | 402.95       | 402.95               | 0.00                | 0.00                   | 0.00                        | 402.95           | ?            | ?           |
    | NMF-2581         | 1             | 102             | 201907 | 2              | 0             | 0.43         | 0.43                 | 0.00                | 0.00                   | 0.00                        | 0.43             | ?            | ?           |
    | NMF-2581         | 1             | 103             | 201907 | 2              | 0             | 105.29       | 105.29               | 0.00                | 0.00                   | 0.00                        | 105.29           | ?            | ?           |
    | NMF-2581         | 1             | 116             | 201907 | 2              | 0             | 0.84         | 0.84                 | 0.00                | 0.00                   | 0.00                        | 0.84             | ?            | ?           |
    | NMF-2581         | 1             | 120             | 201907 | 2              | 0             | 400.84       | 400.84               | 0.00                | 0.00                   | 0.00                        | 400.84           | ?            | ?           |
    #
    | SSF-2581         | 1             | 16              | 201808 | 2              | 0             | -2342.69     | -2342.69             | 0.00                | 0.00                   | 0.00                        | -2342.69         | ?            | ?           |
    | SSF-2581         | 1             | 18              | 201808 | 2              | 0             | -162.83      | -162.83              | 0.00                | 0.00                   | 0.00                        | -162.83          | ?            | ?           |
    | SSF-2581         | 1             | 47              | 201808 | 2              | 0             | -2683.55     | -2683.55             | 0.00                | 0.00                   | 0.00                        | -2683.55         | ?            | ?           |
    | SSF-2581         | 1             | 114             | 201808 | 2              | 0             | -3623.18     | -3623.18             | 0.00                | 0.00                   | 0.00                        | -3623.18         | ?            | ?           |
    | SSF-2581         | 1             | 115             | 201808 | 2              | 0             | -2983.69     | -2983.69             | 0.00                | 0.00                   | 0.00                        | -2983.69         | ?            | ?           |
    #
    | SSF-2581         | 1             | 16              | 201809 | 2              | 0             | -1611.33     | -1611.33             | 0.00                | 0.00                   | 0.00                        | -1611.33         | ?            | ?           |
    | SSF-2581         | 1             | 18              | 201809 | 2              | 0             | -515.84      | -515.84              | 0.00                | 0.00                   | 0.00                        | -515.84          | ?            | ?           |
    | SSF-2581         | 1             | 47              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2581         | 1             | 114             | 201809 | 2              | 0             | -2523.93     | -2523.93             | 0.00                | 0.00                   | 0.00                        | -2523.93         | ?            | ?           |
    | SSF-2581         | 1             | 115             | 201809 | 2              | 0             | -1156.33     | -1156.33             | 0.00                | 0.00                   | 0.00                        | -1156.33         | ?            | ?           |
    #
    | SSF-2581         | 1             | 16              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2581         | 1             | 18              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2581         | 1             | 47              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2581         | 1             | 114             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2581         | 1             | 115             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | SSF-2581         | 1             | 16              | 201811 | 2              | 0             | 2678.25      | 2678.25              | 0.00                | 0.00                   | 0.00                        | 2678.25          | ?            | ?           |
    | SSF-2581         | 1             | 18              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2581         | 1             | 47              | 201811 | 2              | 0             | 408.24       | 408.24               | 0.00                | 0.00                   | 0.00                        | 408.24           | ?            | ?           |
    | SSF-2581         | 1             | 114             | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2581         | 1             | 115             | 201811 | 2              | 0             | 4936.25      | 4936.25              | 0.00                | 0.00                   | 0.00                        | 4936.25          | ?            | ?           |
    #
    | SSF-2581         | 1             | 16              | 201812 | 2              | 0             | 1009.01      | 1009.01              | 0.00                | 0.00                   | 0.00                        | 1009.01          | ?            | ?           |
    | SSF-2581         | 1             | 18              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2581         | 1             | 47              | 201812 | 2              | 0             | 2557.94      | 2557.94              | 0.00                | 0.00                   | 0.00                        | 2557.94          | ?            | ?           |
    | SSF-2581         | 1             | 114             | 201812 | 2              | 0             | 1373.62      | 1373.62              | 0.00                | 0.00                   | 0.00                        | 1373.62          | ?            | ?           |
    | SSF-2581         | 1             | 115             | 201812 | 2              | 0             | 441.01       | 441.01               | 0.00                | 0.00                   | 0.00                        | 441.01           | ?            | ?           |
    #
    | SSF-2581         | 1             | 16              | 201901 | 2              | 0             | 2477.15      | 2477.15              | 0.00                | 0.00                   | 0.00                        | 2477.15          | ?            | ?           |
    | SSF-2581         | 1             | 18              | 201901 | 2              | 0             | 3984.52      | 3984.52              | 0.00                | 0.00                   | 0.00                        | 3984.52          | ?            | ?           |
    | SSF-2581         | 1             | 47              | 201901 | 2              | 0             | 1955.24      | 1955.24              | 0.00                | 0.00                   | 0.00                        | 1955.24          | ?            | ?           |
    | SSF-2581         | 1             | 114             | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2581         | 1             | 115             | 201901 | 2              | 0             | 4916.15      | 4916.15              | 0.00                | 0.00                   | 0.00                        | 4916.15          | ?            | ?           |
    #
    | SSF-2581         | 1             | 16              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2581         | 1             | 18              | 201902 | 2              | 0             | 4017.31      | 4017.31              | 0.00                | 0.00                   | 0.00                        | 4017.31          | ?            | ?           |
    | SSF-2581         | 1             | 47              | 201902 | 2              | 0             | 2960.82      | 2960.82              | 0.00                | 0.00                   | 0.00                        | 2960.82          | ?            | ?           |
    | SSF-2581         | 1             | 114             | 201902 | 2              | 0             | 2154.06      | 2154.06              | 0.00                | 0.00                   | 0.00                        | 2154.06          | ?            | ?           |
    | SSF-2581         | 1             | 115             | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | SSF-2581         | 1             | 16              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2581         | 1             | 18              | 201903 | 2              | 0             | 1426.51      | 1426.51              | 0.00                | 0.00                   | 0.00                        | 1426.51          | ?            | ?           |
    | SSF-2581         | 1             | 47              | 201903 | 2              | 0             | 2907.95      | 2907.95              | 0.00                | 0.00                   | 0.00                        | 2907.95          | ?            | ?           |
    | SSF-2581         | 1             | 114             | 201903 | 2              | 0             | 1003.51      | 1003.51              | 0.00                | 0.00                   | 0.00                        | 1003.51          | ?            | ?           |
    | SSF-2581         | 1             | 115             | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | SSF-2581         | 1             | 16              | 201904 | 2              | 0             | 6125.41      | 6125.41              | 0.00                | 0.00                   | 0.00                        | 6125.41          | ?            | ?           |
    | SSF-2581         | 1             | 18              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2581         | 1             | 47              | 201904 | 2              | 0             | 4335.54      | 4335.54              | 0.00                | 0.00                   | 0.00                        | 4335.54          | ?            | ?           |
    | SSF-2581         | 1             | 114             | 201904 | 2              | 0             | 1585.12      | 1585.12              | 0.00                | 0.00                   | 0.00                        | 1585.12          | ?            | ?           |
    | SSF-2581         | 1             | 115             | 201904 | 2              | 0             | 4037.41      | 4037.41              | 0.00                | 0.00                   | 0.00                        | 4037.41          | ?            | ?           |
    #
    | SSF-2581         | 1             | 16              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2581         | 1             | 18              | 201905 | 2              | 0             | 91.01        | 91.01                | 0.00                | 0.00                   | 0.00                        | 91.01            | ?            | ?           |
    | SSF-2581         | 1             | 47              | 201905 | 2              | 0             | 1446.61      | 1446.61              | 0.00                | 0.00                   | 0.00                        | 1446.61          | ?            | ?           |
    | SSF-2581         | 1             | 114             | 201905 | 2              | 0             | 3053.91      | 3053.91              | 0.00                | 0.00                   | 0.00                        | 3053.91          | ?            | ?           |
    | SSF-2581         | 1             | 115             | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | SSF-2581         | 1             | 16              | 201906 | 2              | 0             | 6223.03      | 6223.03              | 0.00                | 0.00                   | 0.00                        | 6223.03          | ?            | ?           |
    | SSF-2581         | 1             | 18              | 201906 | 2              | 0             | 2537.84      | 2537.84              | 0.00                | 0.00                   | 0.00                        | 2537.84          | ?            | ?           |
    | SSF-2581         | 1             | 47              | 201906 | 2              | 0             | 4863.27      | 4863.27              | 0.00                | 0.00                   | 0.00                        | 4863.27          | ?            | ?           |
    | SSF-2581         | 1             | 114             | 201906 | 2              | 0             | 3806.81      | 3806.81              | 0.00                | 0.00                   | 0.00                        | 3806.81          | ?            | ?           |
    | SSF-2581         | 1             | 115             | 201906 | 2              | 0             | 3000.03      | 3000.03              | 0.00                | 0.00                   | 0.00                        | 3000.03          | ?            | ?           |
    #
    | SSF-2581         | 1             | 16              | 201907 | 2              | 0             | 1879.17      | 1879.17              | 0.00                | 0.00                   | 0.00                        | 1879.17          | ?            | ?           |
    | SSF-2581         | 1             | 18              | 201907 | 2              | 0             | 791.48       | 791.48               | 0.00                | 0.00                   | 0.00                        | 791.48           | ?            | ?           |
    | SSF-2581         | 1             | 47              | 201907 | 2              | 0             | 0.94         | 0.94                 | 0.00                | 0.00                   | 0.00                        | 0.94             | ?            | ?           |
    | SSF-2581         | 1             | 114             | 201907 | 2              | 0             | 0.08         | 0.08                 | 0.00                | 0.00                   | 0.00                        | 0.08             | ?            | ?           |
    | SSF-2581         | 1             | 115             | 201907 | 2              | 0             | 284.17       | 284.17               | 0.00                | 0.00                   | 0.00                        | 284.17           | ?            | ?           |
    #
    | 16LR-2582        | 1             | 8               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 19              | 201808 | 2              | 0             | -39.04       | -39.04               | 0.00                | 0.00                   | 0.00                        | -39.04           | ?            | ?           |
    | 16LR-2582        | 1             | 20              | 201808 | 2              | 0             | -126.68      | -126.68              | 0.00                | 0.00                   | 0.00                        | -126.68          | ?            | ?           |
    | 16LR-2582        | 1             | 32              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 111             | 201808 | 2              | 0             | -813.12      | -813.12              | 0.00                | 0.00                   | 0.00                        | -813.12          | ?            | ?           |
    | 16LR-2582        | 1             | 112             | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 113             | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | 16LR-2582        | 1             | 8               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 19              | 201809 | 2              | 0             | -52.71       | -52.71               | 0.00                | 0.00                   | 0.00                        | -52.71           | ?            | ?           |
    | 16LR-2582        | 1             | 20              | 201809 | 2              | 0             | -4662.92     | -4662.92             | 0.00                | 0.00                   | 0.00                        | -4662.92         | ?            | ?           |
    | 16LR-2582        | 1             | 32              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 111             | 201809 | 2              | 0             | -2660.58     | -2660.58             | 0.00                | 0.00                   | 0.00                        | -2660.58         | ?            | ?           |
    | 16LR-2582        | 1             | 112             | 201809 | 2              | 0             | -3601.19     | -3601.19             | 0.00                | 0.00                   | 0.00                        | -3601.19         | ?            | ?           |
    | 16LR-2582        | 1             | 113             | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | 16LR-2582        | 1             | 8               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 19              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 20              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 32              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 111             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 112             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 113             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | 16LR-2582        | 1             | 8               | 201811 | 2              | 0             | 1982.00      | 1982.00              | 0.00                | 0.00                   | 0.00                        | 1982.00          | ?            | ?           |
    | 16LR-2582        | 1             | 19              | 201811 | 2              | 0             | 2097.13      | 2097.13              | 0.00                | 0.00                   | 0.00                        | 2097.13          | ?            | ?           |
    | 16LR-2582        | 1             | 20              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 32              | 201811 | 2              | 0             | 3954.62      | 3954.62              | 0.00                | 0.00                   | 0.00                        | 3954.62          | ?            | ?           |
    | 16LR-2582        | 1             | 111             | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 112             | 201811 | 2              | 0             | 272.58       | 272.58               | 0.00                | 0.00                   | 0.00                        | 272.58           | ?            | ?           |
    | 16LR-2582        | 1             | 113             | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | 16LR-2582        | 1             | 8               | 201812 | 2              | 0             | 295.00       | 295.00               | 0.00                | 0.00                   | 0.00                        | 295.00           | ?            | ?           |
    | 16LR-2582        | 1             | 19              | 201812 | 2              | 0             | 4582.18      | 4582.18              | 0.00                | 0.00                   | 0.00                        | 4582.18          | ?            | ?           |
    | 16LR-2582        | 1             | 20              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 32              | 201812 | 2              | 0             | 768.55       | 768.55               | 0.00                | 0.00                   | 0.00                        | 768.55           | ?            | ?           |
    | 16LR-2582        | 1             | 111             | 201812 | 2              | 0             | 3815.11      | 3815.11              | 0.00                | 0.00                   | 0.00                        | 3815.11          | ?            | ?           |
    | 16LR-2582        | 1             | 112             | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 113             | 201812 | 2              | 0             | 3392.12      | 3392.12              | 0.00                | 0.00                   | 0.00                        | 3392.12          | ?            | ?           |
    #
    | 16LR-2582        | 1             | 8               | 201901 | 2              | 0             | 378.00       | 378.00               | 0.00                | 0.00                   | 0.00                        | 378.00           | ?            | ?           |
    | 16LR-2582        | 1             | 19              | 201901 | 2              | 0             | 213.78       | 213.78               | 0.00                | 0.00                   | 0.00                        | 213.78           | ?            | ?           |
    | 16LR-2582        | 1             | 20              | 201901 | 2              | 0             | 3980.47      | 3980.47              | 0.00                | 0.00                   | 0.00                        | 3980.47          | ?            | ?           |
    | 16LR-2582        | 1             | 32              | 201901 | 2              | 0             | 378.33       | 378.33               | 0.00                | 0.00                   | 0.00                        | 378.33           | ?            | ?           |
    | 16LR-2582        | 1             | 111             | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 112             | 201901 | 2              | 0             | 81.19        | 81.19                | 0.00                | 0.00                   | 0.00                        | 81.19            | ?            | ?           |
    | 16LR-2582        | 1             | 113             | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | 16LR-2582        | 1             | 8               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 19              | 201902 | 2              | 0             | 2996.97      | 2996.97              | 0.00                | 0.00                   | 0.00                        | 2996.97          | ?            | ?           |
    | 16LR-2582        | 1             | 20              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 32              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 111             | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 112             | 201902 | 2              | 0             | 451.31       | 451.31               | 0.00                | 0.00                   | 0.00                        | 451.31           | ?            | ?           |
    | 16LR-2582        | 1             | 113             | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | 16LR-2582        | 1             | 8               | 201903 | 2              | 0             | 2500.00      | 2500.00              | 0.00                | 0.00                   | 0.00                        | 2500.00          | ?            | ?           |
    | 16LR-2582        | 1             | 19              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 20              | 201903 | 2              | 0             | 2943.11      | 2943.11              | 0.00                | 0.00                   | 0.00                        | 2943.11          | ?            | ?           |
    | 16LR-2582        | 1             | 32              | 201903 | 2              | 0             | 907.07       | 907.07               | 0.00                | 0.00                   | 0.00                        | 907.07           | ?            | ?           |
    | 16LR-2582        | 1             | 111             | 201903 | 2              | 0             | 4800.61      | 4800.61              | 0.00                | 0.00                   | 0.00                        | 4800.61          | ?            | ?           |
    | 16LR-2582        | 1             | 112             | 201903 | 2              | 0             | 358.23       | 358.23               | 0.00                | 0.00                   | 0.00                        | 358.23           | ?            | ?           |
    | 16LR-2582        | 1             | 113             | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | 16LR-2582        | 1             | 8               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 19              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 20              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 32              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 111             | 201904 | 2              | 0             | 1363.82      | 1363.82              | 0.00                | 0.00                   | 0.00                        | 1363.82          | ?            | ?           |
    | 16LR-2582        | 1             | 112             | 201904 | 2              | 0             | 4410.38      | 4410.38              | 0.00                | 0.00                   | 0.00                        | 4410.38          | ?            | ?           |
    | 16LR-2582        | 1             | 113             | 201904 | 2              | 0             | 2758.63      | 2758.63              | 0.00                | 0.00                   | 0.00                        | 2758.63          | ?            | ?           |
    #
    | 16LR-2582        | 1             | 8               | 201905 | 2              | 0             | 2212.00      | 2212.00              | 0.00                | 0.00                   | 0.00                        | 2212.00          | ?            | ?           |
    | 16LR-2582        | 1             | 19              | 201905 | 2              | 0             | 1991.38      | 1991.38              | 0.00                | 0.00                   | 0.00                        | 1991.38          | ?            | ?           |
    | 16LR-2582        | 1             | 20              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 32              | 201905 | 2              | 0             | 2408.62      | 2408.62              | 0.00                | 0.00                   | 0.00                        | 2408.62          | ?            | ?           |
    | 16LR-2582        | 1             | 111             | 201905 | 2              | 0             | 4357.51      | 4357.51              | 0.00                | 0.00                   | 0.00                        | 4357.51          | ?            | ?           |
    | 16LR-2582        | 1             | 112             | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 113             | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | 16LR-2582        | 1             | 8               | 201906 | 2              | 0             | 1750.00      | 1750.00              | 0.00                | 0.00                   | 0.00                        | 1750.00          | ?            | ?           |
    | 16LR-2582        | 1             | 19              | 201906 | 2              | 0             | 3802.74      | 3802.74              | 0.00                | 0.00                   | 0.00                        | 3802.74          | ?            | ?           |
    | 16LR-2582        | 1             | 20              | 201906 | 2              | 0             | 457.05       | 457.05               | 0.00                | 0.00                   | 0.00                        | 457.05           | ?            | ?           |
    | 16LR-2582        | 1             | 32              | 201906 | 2              | 0             | 1680.07      | 1680.07              | 0.00                | 0.00                   | 0.00                        | 1680.07          | ?            | ?           |
    | 16LR-2582        | 1             | 111             | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16LR-2582        | 1             | 112             | 201906 | 2              | 0             | 4642.97      | 4642.97              | 0.00                | 0.00                   | 0.00                        | 4642.97          | ?            | ?           |
    | 16LR-2582        | 1             | 113             | 201906 | 2              | 0             | 2864.38      | 2864.38              | 0.00                | 0.00                   | 0.00                        | 2864.38          | ?            | ?           |
    #
    | 16LR-2582        | 1             | 8               | 201907 | 2              | 0             | 5200.00      | 5200.00              | 0.00                | 0.00                   | 0.00                        | 5200.00          | ?            | ?           |
    | 16LR-2582        | 1             | 19              | 201907 | 2              | 0             | 0.57         | 0.57                 | 0.00                | 0.00                   | 0.00                        | 0.57             | ?            | ?           |
    | 16LR-2582        | 1             | 20              | 201907 | 2              | 0             | 0.97         | 0.97                 | 0.00                | 0.00                   | 0.00                        | 0.97             | ?            | ?           |
    | 16LR-2582        | 1             | 32              | 201907 | 2              | 0             | 4377.74      | 4377.74              | 0.00                | 0.00                   | 0.00                        | 4377.74          | ?            | ?           |
    | 16LR-2582        | 1             | 111             | 201907 | 2              | 0             | 1753.65      | 1753.65              | 0.00                | 0.00                   | 0.00                        | 1753.65          | ?            | ?           |
    | 16LR-2582        | 1             | 112             | 201907 | 2              | 0             | 0.53         | 0.53                 | 0.00                | 0.00                   | 0.00                        | 0.53             | ?            | ?           |
    | 16LR-2582        | 1             | 113             | 201907 | 2              | 0             | 1204.87      | 1204.87              | 0.00                | 0.00                   | 0.00                        | 1204.87          | ?            | ?           |
    #
    | NMF-2582         | 1             | 3               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 31              | 201808 | 2              | 0             | -3505.94     | -3505.94             | 0.00                | 0.00                   | 0.00                        | -3505.94         | ?            | ?           |
    | NMF-2582         | 1             | 32              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 33              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 103             | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 116             | 201808 | 2              | 0             | -3639.53     | -3639.53             | 0.00                | 0.00                   | 0.00                        | -3639.53         | ?            | ?           |
    | NMF-2582         | 1             | 118             | 201808 | 2              | 0             | 3005.09      | 3005.09              | 0.00                | 0.00                   | 0.00                        | 3005.09          | ?            | ?           |
    | NMF-2582         | 1             | 119             | 201808 | 2              | 0             | 2645.09      | 2645.09              | 0.00                | 0.00                   | 0.00                        | 2645.09          | ?            | ?           |
    #
    | NMF-2582         | 1             | 3               | 201809 | 2              | 0             | -3777.95     | -3777.95             | 0.00                | 0.00                   | 0.00                        | -3777.95         | ?            | ?           |
    | NMF-2582         | 1             | 31              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 32              | 201809 | 2              | 0             | -357.41      | -357.41              | 0.00                | 0.00                   | 0.00                        | -357.41          | ?            | ?           |
    | NMF-2582         | 1             | 33              | 201809 | 2              | 0             | -3859.95     | -3859.95             | 0.00                | 0.00                   | 0.00                        | -3859.95         | ?            | ?           |
    | NMF-2582         | 1             | 103             | 201809 | 2              | 0             | -4078.19     | -4078.19             | 0.00                | 0.00                   | 0.00                        | -4078.19         | ?            | ?           |
    | NMF-2582         | 1             | 116             | 201809 | 2              | 0             | -2838.43     | -2838.43             | 0.00                | 0.00                   | 0.00                        | -2838.43         | ?            | ?           |
    | NMF-2582         | 1             | 118             | 201809 | 2              | 0             | 1250.23      | 1250.23              | 0.00                | 0.00                   | 0.00                        | 1250.23          | ?            | ?           |
    | NMF-2582         | 1             | 119             | 201809 | 2              | 0             | 1089.23      | 1089.23              | 0.00                | 0.00                   | 0.00                        | 1089.23          | ?            | ?           |
    #
    | NMF-2582         | 1             | 3               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 31              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 32              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 33              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 103             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 116             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 118             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 119             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NMF-2582         | 1             | 3               | 201811 | 2              | 0             | 2143.89      | 2143.89              | 0.00                | 0.00                   | 0.00                        | 2143.89          | ?            | ?           |
    | NMF-2582         | 1             | 31              | 201811 | 2              | 0             | 1709.78      | 1709.78              | 0.00                | 0.00                   | 0.00                        | 1709.78          | ?            | ?           |
    | NMF-2582         | 1             | 32              | 201811 | 2              | 0             | 1497.29      | 1497.29              | 0.00                | 0.00                   | 0.00                        | 1497.29          | ?            | ?           |
    | NMF-2582         | 1             | 33              | 201811 | 2              | 0             | 2852.89      | 2852.89              | 0.00                | 0.00                   | 0.00                        | 2852.89          | ?            | ?           |
    | NMF-2582         | 1             | 103             | 201811 | 2              | 0             | 4201.76      | 4201.76              | 0.00                | 0.00                   | 0.00                        | 4201.76          | ?            | ?           |
    | NMF-2582         | 1             | 116             | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 118             | 201811 | 2              | 0             | 985.25       | 985.25               | 0.00                | 0.00                   | 0.00                        | 985.25           | ?            | ?           |
    | NMF-2582         | 1             | 119             | 201811 | 2              | 0             | 350.25       | 350.25               | 0.00                | 0.00                   | 0.00                        | 350.25           | ?            | ?           |
    #
    | NMF-2582         | 1             | 3               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 31              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 32              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 33              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 103             | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 116             | 201812 | 2              | 0             | 4868.02      | 4868.02              | 0.00                | 0.00                   | 0.00                        | 4868.02          | ?            | ?           |
    | NMF-2582         | 1             | 118             | 201812 | 2              | 0             | 3986.55      | 3986.55              | 0.00                | 0.00                   | 0.00                        | 3986.55          | ?            | ?           |
    | NMF-2582         | 1             | 119             | 201812 | 2              | 0             | 4125.55      | 4125.55              | 0.00                | 0.00                   | 0.00                        | 4125.55          | ?            | ?           |
    #
    | NMF-2582         | 1             | 3               | 201901 | 2              | 0             | 4545.46      | 4545.46              | 0.00                | 0.00                   | 0.00                        | 4545.46          | ?            | ?           |
    | NMF-2582         | 1             | 31              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 32              | 201901 | 2              | 0             | 4016.11      | 4016.11              | 0.00                | 0.00                   | 0.00                        | 4016.11          | ?            | ?           |
    | NMF-2582         | 1             | 33              | 201901 | 2              | 0             | 3930.46      | 3930.46              | 0.00                | 0.00                   | 0.00                        | 3930.46          | ?            | ?           |
    | NMF-2582         | 1             | 103             | 201901 | 2              | 0             | 1894.43      | 1894.43              | 0.00                | 0.00                   | 0.00                        | 1894.43          | ?            | ?           |
    | NMF-2582         | 1             | 116             | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 118             | 201901 | 2              | 0             | 7225.33      | 7225.33              | 0.00                | 0.00                   | 0.00                        | 7225.33          | ?            | ?           |
    | NMF-2582         | 1             | 119             | 201901 | 2              | 0             | 75.33        | 75.33                | 0.00                | 0.00                   | 0.00                        | 75.33            | ?            | ?           |
    #
    | NMF-2582         | 1             | 3               | 201902 | 2              | 0             | 2887.23      | 2887.23              | 0.00                | 0.00                   | 0.00                        | 2887.23          | ?            | ?           |
    | NMF-2582         | 1             | 31              | 201902 | 2              | 0             | 1550.16      | 1550.16              | 0.00                | 0.00                   | 0.00                        | 1550.16          | ?            | ?           |
    | NMF-2582         | 1             | 32              | 201902 | 2              | 0             | 367.84       | 367.84               | 0.00                | 0.00                   | 0.00                        | 367.84           | ?            | ?           |
    | NMF-2582         | 1             | 33              | 201902 | 2              | 0             | 4386.23      | 4386.23              | 0.00                | 0.00                   | 0.00                        | 4386.23          | ?            | ?           |
    | NMF-2582         | 1             | 103             | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 116             | 201902 | 2              | 0             | 1544.42      | 1544.42              | 0.00                | 0.00                   | 0.00                        | 1544.42          | ?            | ?           |
    | NMF-2582         | 1             | 118             | 201902 | 2              | 0             | 2083.33      | 2083.33              | 0.00                | 0.00                   | 0.00                        | 2083.33          | ?            | ?           |
    | NMF-2582         | 1             | 119             | 201902 | 2              | 0             | 1723.33      | 1723.33              | 0.00                | 0.00                   | 0.00                        | 1723.33          | ?            | ?           |
    #
    | NMF-2582         | 1             | 3               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 31              | 201903 | 2              | 0             | 949.45       | 949.45               | 0.00                | 0.00                   | 0.00                        | 949.45           | ?            | ?           |
    | NMF-2582         | 1             | 32              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 33              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 103             | 201903 | 2              | 0             | 2126.03      | 2126.03              | 0.00                | 0.00                   | 0.00                        | 2126.03          | ?            | ?           |
    | NMF-2582         | 1             | 116             | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 118             | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 119             | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NMF-2582         | 1             | 3               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 31              | 201904 | 2              | 0             | 1953.05      | 1953.05              | 0.00                | 0.00                   | 0.00                        | 1953.05          | ?            | ?           |
    | NMF-2582         | 1             | 32              | 201904 | 2              | 0             | 1147.28      | 1147.28              | 0.00                | 0.00                   | 0.00                        | 1147.28          | ?            | ?           |
    | NMF-2582         | 1             | 33              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 103             | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 116             | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 118             | 201904 | 2              | 0             | 4135.56      | 4135.56              | 0.00                | 0.00                   | 0.00                        | 4135.56          | ?            | ?           |
    | NMF-2582         | 1             | 119             | 201904 | 2              | 0             | 65.56        | 65.56                | 0.00                | 0.00                   | 0.00                        | 65.56            | ?            | ?           |
    #
    | NMF-2582         | 1             | 3               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 31              | 201905 | 2              | 0             | 1900.18      | 1900.18              | 0.00                | 0.00                   | 0.00                        | 1900.18          | ?            | ?           |
    | NMF-2582         | 1             | 32              | 201905 | 2              | 0             | 4948.73      | 4948.73              | 0.00                | 0.00                   | 0.00                        | 4948.73          | ?            | ?           |
    | NMF-2582         | 1             | 33              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 103             | 201905 | 2              | 0             | 3078.74      | 3078.74              | 0.00                | 0.00                   | 0.00                        | 3078.74          | ?            | ?           |
    | NMF-2582         | 1             | 116             | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 118             | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 119             | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NMF-2582         | 1             | 3               | 201906 | 2              | 0             | 3423.62      | 3423.62              | 0.00                | 0.00                   | 0.00                        | 3423.62          | ?            | ?           |
    | NMF-2582         | 1             | 31              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 32              | 201906 | 2              | 0             | 578.34       | 578.34               | 0.00                | 0.00                   | 0.00                        | 578.34           | ?            | ?           |
    | NMF-2582         | 1             | 33              | 201906 | 2              | 0             | 3031.62      | 3031.62              | 0.00                | 0.00                   | 0.00                        | 3031.62          | ?            | ?           |
    | NMF-2582         | 1             | 103             | 201906 | 2              | 0             | 869.73       | 869.73               | 0.00                | 0.00                   | 0.00                        | 869.73           | ?            | ?           |
    | NMF-2582         | 1             | 116             | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 118             | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NMF-2582         | 1             | 119             | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NMF-2582         | 1             | 3               | 201907 | 2              | 0             | 1238.75      | 1238.75              | 0.00                | 0.00                   | 0.00                        | 1238.75          | ?            | ?           |
    | NMF-2582         | 1             | 31              | 201907 | 2              | 0             | 0.32         | 0.32                 | 0.00                | 0.00                   | 0.00                        | 0.32             | ?            | ?           |
    | NMF-2582         | 1             | 32              | 201907 | 2              | 0             | 2046.82      | 2046.82              | 0.00                | 0.00                   | 0.00                        | 2046.82          | ?            | ?           |
    | NMF-2582         | 1             | 33              | 201907 | 2              | 0             | 1584.75      | 1584.75              | 0.00                | 0.00                   | 0.00                        | 1584.75          | ?            | ?           |
    | NMF-2582         | 1             | 103             | 201907 | 2              | 0             | 2933.50      | 2933.50              | 0.00                | 0.00                   | 0.00                        | 2933.50          | ?            | ?           |
    | NMF-2582         | 1             | 116             | 201907 | 2              | 0             | 0.52         | 0.52                 | 0.00                | 0.00                   | 0.00                        | 0.52             | ?            | ?           |
    | NMF-2582         | 1             | 118             | 201907 | 2              | 0             | 0.01         | 0.01                 | 0.00                | 0.00                   | 0.00                        | 0.01             | ?            | ?           |
    | NMF-2582         | 1             | 119             | 201907 | 2              | 0             | 0.01         | 0.01                 | 0.00                | 0.00                   | 0.00                        | 0.01             | ?            | ?           |
    #
    | SSF-2582         | 1             | 2               | 201808 | 2              | 0             | -4537.76     | -4537.76             | 0.00                | 0.00                   | 0.00                        | -4537.76         | ?            | ?           |
    | SSF-2582         | 1             | 12              | 201808 | 2              | 0             | -1641.25     | -1641.25             | 0.00                | 0.00                   | 0.00                        | -1641.25         | ?            | ?           |
    | SSF-2582         | 1             | 13              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 17              | 201808 | 2              | 0             | -2622.07     | -2622.07             | 0.00                | 0.00                   | 0.00                        | -2622.07         | ?            | ?           |
    | SSF-2582         | 1             | 18              | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 47              | 201808 | 2              | 0             | -1468.95     | -1468.95             | 0.00                | 0.00                   | 0.00                        | -1468.95         | ?            | ?           |
    | SSF-2582         | 1             | 114             | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 115             | 201808 | 2              | 0             | -1641.25     | -1641.25             | 0.00                | 0.00                   | 0.00                        | -1641.25         | ?            | ?           |
    #
    | SSF-2582         | 1             | 2               | 201809 | 2              | 0             | -962.25      | -962.25              | 0.00                | 0.00                   | 0.00                        | -962.25          | ?            | ?           |
    | SSF-2582         | 1             | 12              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 13              | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 17              | 201809 | 2              | 0             | -2462.45     | -2462.45             | 0.00                | 0.00                   | 0.00                        | -2462.45         | ?            | ?           |
    | SSF-2582         | 1             | 18              | 201809 | 2              | 0             | -1695.12     | -1695.12             | 0.00                | 0.00                   | 0.00                        | -1695.12         | ?            | ?           |
    | SSF-2582         | 1             | 47              | 201809 | 2              | 0             | -3016.28     | -3016.28             | 0.00                | 0.00                   | 0.00                        | -3016.28         | ?            | ?           |
    | SSF-2582         | 1             | 114             | 201809 | 2              | 0             | -4083.75     | -4083.75             | 0.00                | 0.00                   | 0.00                        | -4083.75         | ?            | ?           |
    | SSF-2582         | 1             | 115             | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | SSF-2582         | 1             | 2               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 12              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 13              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 17              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 18              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 47              | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 114             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 115             | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | SSF-2582         | 1             | 2               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 12              | 201811 | 2              | 0             | 1401.34      | 1401.34              | 0.00                | 0.00                   | 0.00                        | 1401.34          | ?            | ?           |
    | SSF-2582         | 1             | 13              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 17              | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 18              | 201811 | 2              | 0             | 4448.89      | 4448.89              | 0.00                | 0.00                   | 0.00                        | 4448.89          | ?            | ?           |
    | SSF-2582         | 1             | 47              | 201811 | 2              | 0             | 3516.28      | 3516.28              | 0.00                | 0.00                   | 0.00                        | 3516.28          | ?            | ?           |
    | SSF-2582         | 1             | 114             | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 115             | 201811 | 2              | 0             | 1401.34      | 1401.34              | 0.00                | 0.00                   | 0.00                        | 1401.34          | ?            | ?           |
    #
    | SSF-2582         | 1             | 2               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 12              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 13              | 201812 | 2              | 0             | 1606.91      | 1606.91              | 0.00                | 0.00                   | 0.00                        | 1606.91          | ?            | ?           |
    | SSF-2582         | 1             | 17              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 18              | 201812 | 2              | 0             | 4818.02      | 4818.02              | 0.00                | 0.00                   | 0.00                        | 4818.02          | ?            | ?           |
    | SSF-2582         | 1             | 47              | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 114             | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 115             | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | SSF-2582         | 1             | 2               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 12              | 201901 | 2              | 0             | 1804.23      | 1804.23              | 0.00                | 0.00                   | 0.00                        | 1804.23          | ?            | ?           |
    | SSF-2582         | 1             | 13              | 201901 | 2              | 0             | 4897.73      | 4897.73              | 0.00                | 0.00                   | 0.00                        | 4897.73          | ?            | ?           |
    | SSF-2582         | 1             | 17              | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 18              | 201901 | 2              | 0             | 3410.53      | 3410.53              | 0.00                | 0.00                   | 0.00                        | 3410.53          | ?            | ?           |
    | SSF-2582         | 1             | 47              | 201901 | 2              | 0             | 534.27       | 534.27               | 0.00                | 0.00                   | 0.00                        | 534.27           | ?            | ?           |
    | SSF-2582         | 1             | 114             | 201901 | 2              | 0             | 2861.69      | 2861.69              | 0.00                | 0.00                   | 0.00                        | 2861.69          | ?            | ?           |
    | SSF-2582         | 1             | 115             | 201901 | 2              | 0             | 1804.23      | 1804.23              | 0.00                | 0.00                   | 0.00                        | 1804.23          | ?            | ?           |
    #
    | SSF-2582         | 1             | 2               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 12              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 13              | 201902 | 2              | 0             | 3357.65      | 3357.65              | 0.00                | 0.00                   | 0.00                        | 3357.65          | ?            | ?           |
    | SSF-2582         | 1             | 17              | 201902 | 2              | 0             | 4415.13      | 4415.13              | 0.00                | 0.00                   | 0.00                        | 4415.13          | ?            | ?           |
    | SSF-2582         | 1             | 18              | 201902 | 2              | 0             | 2511.68      | 2511.68              | 0.00                | 0.00                   | 0.00                        | 2511.68          | ?            | ?           |
    | SSF-2582         | 1             | 47              | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 114             | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 115             | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | SSF-2582         | 1             | 2               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 12              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 13              | 201903 | 2              | 0             | 3939.27      | 3939.27              | 0.00                | 0.00                   | 0.00                        | 3939.27          | ?            | ?           |
    | SSF-2582         | 1             | 17              | 201903 | 2              | 0             | 2458.81      | 2458.81              | 0.00                | 0.00                   | 0.00                        | 2458.81          | ?            | ?           |
    | SSF-2582         | 1             | 18              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 47              | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 114             | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 115             | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | SSF-2582         | 1             | 2               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 12              | 201904 | 2              | 0             | 2108.79      | 2108.79              | 0.00                | 0.00                   | 0.00                        | 2108.79          | ?            | ?           |
    | SSF-2582         | 1             | 13              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 17              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 18              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 47              | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 114             | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 115             | 201904 | 2              | 0             | 2108.79      | 2108.79              | 0.00                | 0.00                   | 0.00                        | 2108.79          | ?            | ?           |
    #
    | SSF-2582         | 1             | 2               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 12              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 13              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 17              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 18              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 47              | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 114             | 201905 | 2              | 0             | 1381.24      | 1381.24              | 0.00                | 0.00                   | 0.00                        | 1381.24          | ?            | ?           |
    | SSF-2582         | 1             | 115             | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | SSF-2582         | 1             | 2               | 201906 | 2              | 0             | 2134.64      | 2134.64              | 0.00                | 0.00                   | 0.00                        | 2134.64          | ?            | ?           |
    | SSF-2582         | 1             | 12              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 13              | 201906 | 2              | 0             | 905.38       | 905.38               | 0.00                | 0.00                   | 0.00                        | 905.38           | ?            | ?           |
    | SSF-2582         | 1             | 17              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 18              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 47              | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | SSF-2582         | 1             | 114             | 201906 | 2              | 0             | 1454.22      | 1454.22              | 0.00                | 0.00                   | 0.00                        | 1454.22          | ?            | ?           |
    | SSF-2582         | 1             | 115             | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | SSF-2582         | 1             | 2               | 201907 | 2              | 0             | 4158.37      | 4158.37              | 0.00                | 0.00                   | 0.00                        | 4158.37          | ?            | ?           |
    | SSF-2582         | 1             | 12              | 201907 | 2              | 0             | 0.89         | 0.89                 | 0.00                | 0.00                   | 0.00                        | 0.89             | ?            | ?           |
    | SSF-2582         | 1             | 13              | 201907 | 2              | 0             | 767.06       | 767.06               | 0.00                | 0.00                   | 0.00                        | 767.06           | ?            | ?           |
    | SSF-2582         | 1             | 17              | 201907 | 2              | 0             | 852.58       | 852.58               | 0.00                | 0.00                   | 0.00                        | 852.58           | ?            | ?           |
    | SSF-2582         | 1             | 18              | 201907 | 2              | 0             | 1487.00      | 1487.00              | 0.00                | 0.00                   | 0.00                        | 1487.00          | ?            | ?           |
    | SSF-2582         | 1             | 47              | 201907 | 2              | 0             | 2373.68      | 2373.68              | 0.00                | 0.00                   | 0.00                        | 2373.68          | ?            | ?           |
    | SSF-2582         | 1             | 114             | 201907 | 2              | 0             | 0.60         | 0.60                 | 0.00                | 0.00                   | 0.00                        | 0.60             | ?            | ?           |
    | SSF-2582         | 1             | 115             | 201907 | 2              | 0             | 0.89         | 0.89                 | 0.00                | 0.00                   | 0.00                        | 0.89             | ?            | ?           |


    # Check the PROFILE subnominal aggregations in PaaS
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202200         | 1619LR1819                 | 201808               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202850         | 1619LR1819                 | 201808               | PROFILE         | CM             | False       | -1104.82        |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203001         | 1619LR1819                 | 201808               | PROFILE         | CM             | False       | -3666.74        |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203006         | 1619LR1819                 | 201808               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203022         | 1619LR1819                 | 201808               | PROFILE         | CM             | False       | -4819.85        |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203023         | 1619LR1819                 | 201808               | PROFILE         | CM             | False       | -4306.23        |
    | 10023115 | ORG0023115 | 16LR-2581         | 2206042         | 1619LR1819                 | 201808               | PROFILE         | CM             | False       | -3539.89        |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202200         | 1619LR1819                 | 201809               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202850         | 1619LR1819                 | 201809               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203001         | 1619LR1819                 | 201809               | PROFILE         | CM             | False       | -3592.77        |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203006         | 1619LR1819                 | 201809               | PROFILE         | CM             | False       | -4532.39        |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203022         | 1619LR1819                 | 201809               | PROFILE         | CM             | False       | -1711.53        |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203023         | 1619LR1819                 | 201809               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2206042         | 1619LR1819                 | 201809               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202200         | 1619LR1819                 | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202850         | 1619LR1819                 | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203001         | 1619LR1819                 | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203006         | 1619LR1819                 | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203022         | 1619LR1819                 | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203023         | 1619LR1819                 | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2206042         | 1619LR1819                 | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202200         | 1619LR1819                 | 201811               | PROFILE         | CM             | False       | 750.00          |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202850         | 1619LR1819                 | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203001         | 1619LR1819                 | 201811               | PROFILE         | CM             | False       | 4683.18         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203006         | 1619LR1819                 | 201811               | PROFILE         | CM             | False       | 492.51          |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203022         | 1619LR1819                 | 201811               | PROFILE         | CM             | False       | 1847.12         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203023         | 1619LR1819                 | 201811               | PROFILE         | CM             | False       | 3454.42         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2206042         | 1619LR1819                 | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202200         | 1619LR1819                 | 201812               | PROFILE         | CM             | False       | 2500.00         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202850         | 1619LR1819                 | 201812               | PROFILE         | CM             | False       | 3995.82         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203001         | 1619LR1819                 | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203006         | 1619LR1819                 | 201812               | PROFILE         | CM             | False       | 4756.16         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203022         | 1619LR1819                 | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203023         | 1619LR1819                 | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2206042         | 1619LR1819                 | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202200         | 1619LR1819                 | 201901               | PROFILE         | CM             | False       | 1875.00         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202850         | 1619LR1819                 | 201901               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203001         | 1619LR1819                 | 201901               | PROFILE         | CM             | False       | 2376.85         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203006         | 1619LR1819                 | 201901               | PROFILE         | CM             | False       | 4829.13         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203022         | 1619LR1819                 | 201901               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203023         | 1619LR1819                 | 201901               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2206042         | 1619LR1819                 | 201901               | PROFILE         | CM             | False       | 684.91          |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202200         | 1619LR1819                 | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202850         | 1619LR1819                 | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203001         | 1619LR1819                 | 201902               | PROFILE         | CM             | False       | 1391.36         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203006         | 1619LR1819                 | 201902               | PROFILE         | CM             | False       | 4564.76         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203022         | 1619LR1819                 | 201902               | PROFILE         | CM             | False       | 4947.55         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203023         | 1619LR1819                 | 201902               | PROFILE         | CM             | False       | 631.03          |
    | 10023115 | ORG0023115 | 16LR-2581         | 2206042         | 1619LR1819                 | 201902               | PROFILE         | CM             | False       | 2832.61         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202200         | 1619LR1819                 | 201903               | PROFILE         | CM             | False       | 2125.00         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202850         | 1619LR1819                 | 201903               | PROFILE         | CM             | False       | 4894.67         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203001         | 1619LR1819                 | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203006         | 1619LR1819                 | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203022         | 1619LR1819                 | 201903               | PROFILE         | CM             | False       | 2905.58         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203023         | 1619LR1819                 | 201903               | PROFILE         | CM             | False       | 4260.21         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2206042         | 1619LR1819                 | 201903               | PROFILE         | CM             | False       | 915.51          |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202200         | 1619LR1819                 | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202850         | 1619LR1819                 | 201904               | PROFILE         | CM             | False       | 4333.17         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203001         | 1619LR1819                 | 201904               | PROFILE         | CM             | False       | 1794.25         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203006         | 1619LR1819                 | 201904               | PROFILE         | CM             | False       | 4842.81         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203022         | 1619LR1819                 | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203023         | 1619LR1819                 | 201904               | PROFILE         | CM             | False       | 2978.56         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2206042         | 1619LR1819                 | 201904               | PROFILE         | CM             | False       | 1920.09         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202200         | 1619LR1819                 | 201905               | PROFILE         | CM             | False       | 7500.00         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202850         | 1619LR1819                 | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203001         | 1619LR1819                 | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203006         | 1619LR1819                 | 201905               | PROFILE         | CM             | False       | 810.75          |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203022         | 1619LR1819                 | 201905               | PROFILE         | CM             | False       | 472.41          |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203023         | 1619LR1819                 | 201905               | PROFILE         | CM             | False       | 387.76          |
    | 10023115 | ORG0023115 | 16LR-2581         | 2206042         | 1619LR1819                 | 201905               | PROFILE         | CM             | False       | 1867.22         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202200         | 1619LR1819                 | 201906               | PROFILE         | CM             | False       | 2560.00         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202850         | 1619LR1819                 | 201906               | PROFILE         | CM             | False       | 3890.08         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203001         | 1619LR1819                 | 201906               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203006         | 1619LR1819                 | 201906               | PROFILE         | CM             | False       | 4776.26         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203022         | 1619LR1819                 | 201906               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203023         | 1619LR1819                 | 201906               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2206042         | 1619LR1819                 | 201906               | PROFILE         | CM             | False       | 3295.81         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202200         | 1619LR1819                 | 201907               | PROFILE         | CM             | False       | 3145.00         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2202850         | 1619LR1819                 | 201907               | PROFILE         | CM             | False       | 4386.08         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203001         | 1619LR1819                 | 201907               | PROFILE         | CM             | False       | 3414.87         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203006         | 1619LR1819                 | 201907               | PROFILE         | CM             | False       | 2357.01         |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203022         | 1619LR1819                 | 201907               | PROFILE         | CM             | False       | 0.72            |
    | 10023115 | ORG0023115 | 16LR-2581         | 2203023         | 1619LR1819                 | 201907               | PROFILE         | CM             | False       | 368.25          |
    | 10023115 | ORG0023115 | 16LR-2581         | 2206042         | 1619LR1819                 | 201907               | PROFILE         | CM             | False       | 408.74          |
    #
    | 10023115 | ORG0023115 | NMF-2581          | 2202032         | NMF1819                    | 201808               | PROFILE         | CM             | False       | -3076.27        |
    | 10023115 | ORG0023115 | NMF-2581          | 2202033         | NMF1819                    | 201808               | PROFILE         | CM             | False       | -1709.66        |
    | 10023115 | ORG0023115 | NMF-2581          | 2202034         | NMF1819                    | 201808               | PROFILE         | CM             | False       | -88.36          |
    | 10023115 | ORG0023115 | NMF-2581          | 2202070         | NMF1819                    | 201808               | PROFILE         | CM             | False       | -4570.72        |
    | 10023115 | ORG0023115 | NMF-2581          | 2203026         | NMF1819                    | 201808               | PROFILE         | CM             | False       | -150.72         |
    | 10023115 | ORG0023115 | NMF-2581          | 2206038         | NMF1819                    | 201808               | PROFILE         | CM             | False       | -4570.72        |
    | 10023115 | ORG0023115 | NMF-2581          | 2208000         | NMF1819                    | 201808               | PROFILE         | CM             | False       | -555.54         |
    | 10023115 | ORG0023115 | NMF-2581          | 2208100         | NMF1819                    | 201808               | PROFILE         | CM             | False       | -769.04         |
    | 10023115 | ORG0023115 | NMF-2581          | 2208200         | NMF1819                    | 201808               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2430670         | NMF1819                    | 201808               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202032         | NMF1819                    | 201809               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202033         | NMF1819                    | 201809               | PROFILE         | CM             | False       | -1676.88        |
    | 10023115 | ORG0023115 | NMF-2581          | 2202034         | NMF1819                    | 201809               | PROFILE         | CM             | False       | -4070.76        |
    | 10023115 | ORG0023115 | NMF-2581          | 2202070         | NMF1819                    | 201809               | PROFILE         | CM             | False       | -995.21         |
    | 10023115 | ORG0023115 | NMF-2581          | 2203026         | NMF1819                    | 201809               | PROFILE         | CM             | False       | 2121.21         |
    | 10023115 | ORG0023115 | NMF-2581          | 2206038         | NMF1819                    | 201809               | PROFILE         | CM             | False       | -995.21         |
    | 10023115 | ORG0023115 | NMF-2581          | 2208000         | NMF1819                    | 201809               | PROFILE         | CM             | False       | -3556.13        |
    | 10023115 | ORG0023115 | NMF-2581          | 2208100         | NMF1819                    | 201809               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2208200         | NMF1819                    | 201809               | PROFILE         | CM             | False       | -4110.96        |
    | 10023115 | ORG0023115 | NMF-2581          | 2430670         | NMF1819                    | 201809               | PROFILE         | CM             | False       | -182.43         |
    | 10023115 | ORG0023115 | NMF-2581          | 2202032         | NMF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202033         | NMF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202034         | NMF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202070         | NMF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2203026         | NMF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2206038         | NMF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2208000         | NMF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2208100         | NMF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2208200         | NMF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2430670         | NMF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202032         | NMF1819                    | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202033         | NMF1819                    | 201811               | PROFILE         | CM             | False       | 3026.87         |
    | 10023115 | ORG0023115 | NMF-2581          | 2202034         | NMF1819                    | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202070         | NMF1819                    | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2203026         | NMF1819                    | 201811               | PROFILE         | CM             | False       | 125.00          |
    | 10023115 | ORG0023115 | NMF-2581          | 2206038         | NMF1819                    | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2208000         | NMF1819                    | 201811               | PROFILE         | CM             | False       | 4547.53         |
    | 10023115 | ORG0023115 | NMF-2581          | 2208100         | NMF1819                    | 201811               | PROFILE         | CM             | False       | 3363.22         |
    | 10023115 | ORG0023115 | NMF-2581          | 2208200         | NMF1819                    | 201811               | PROFILE         | CM             | False       | 2431.59         |
    | 10023115 | ORG0023115 | NMF-2581          | 2430670         | NMF1819                    | 201811               | PROFILE         | CM             | False       | 3066.08         |
    | 10023115 | ORG0023115 | NMF-2581          | 2202032         | NMF1819                    | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202033         | NMF1819                    | 201812               | PROFILE         | CM             | False       | 4368.81         |
    | 10023115 | ORG0023115 | NMF-2581          | 2202034         | NMF1819                    | 201812               | PROFILE         | CM             | False       | 772.42          |
    | 10023115 | ORG0023115 | NMF-2581          | 2202070         | NMF1819                    | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2203026         | NMF1819                    | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2206038         | NMF1819                    | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2208000         | NMF1819                    | 201812               | PROFILE         | CM             | False       | 2379.72         |
    | 10023115 | ORG0023115 | NMF-2581          | 2208100         | NMF1819                    | 201812               | PROFILE         | CM             | False       | 601.13          |
    | 10023115 | ORG0023115 | NMF-2581          | 2208200         | NMF1819                    | 201812               | PROFILE         | CM             | False       | 389.63          |
    | 10023115 | ORG0023115 | NMF-2581          | 2430670         | NMF1819                    | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202032         | NMF1819                    | 201901               | PROFILE         | CM             | False       | 4738.92         |
    | 10023115 | ORG0023115 | NMF-2581          | 2202033         | NMF1819                    | 201901               | PROFILE         | CM             | False       | 548.26          |
    | 10023115 | ORG0023115 | NMF-2581          | 2202034         | NMF1819                    | 201901               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202070         | NMF1819                    | 201901               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2203026         | NMF1819                    | 201901               | PROFILE         | CM             | False       | 375.00          |
    | 10023115 | ORG0023115 | NMF-2581          | 2206038         | NMF1819                    | 201901               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2208000         | NMF1819                    | 201901               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2208100         | NMF1819                    | 201901               | PROFILE         | CM             | False       | 2326.84         |
    | 10023115 | ORG0023115 | NMF-2581          | 2208200         | NMF1819                    | 201901               | PROFILE         | CM             | False       | 4401.58         |
    | 10023115 | ORG0023115 | NMF-2581          | 2430670         | NMF1819                    | 201901               | PROFILE         | CM             | False       | 1777.02         |
    | 10023115 | ORG0023115 | NMF-2581          | 2202032         | NMF1819                    | 201902               | PROFILE         | CM             | False       | 455.18          |
    | 10023115 | ORG0023115 | NMF-2581          | 2202033         | NMF1819                    | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202034         | NMF1819                    | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202070         | NMF1819                    | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2203026         | NMF1819                    | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2206038         | NMF1819                    | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2208000         | NMF1819                    | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2208100         | NMF1819                    | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2208200         | NMF1819                    | 201902               | PROFILE         | CM             | False       | 2907.46         |
    | 10023115 | ORG0023115 | NMF-2581          | 2430670         | NMF1819                    | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202032         | NMF1819                    | 201903               | PROFILE         | CM             | False       | 2855.58         |
    | 10023115 | ORG0023115 | NMF-2581          | 2202033         | NMF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202034         | NMF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202070         | NMF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2203026         | NMF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2206038         | NMF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2208000         | NMF1819                    | 201903               | PROFILE         | CM             | False       | 1374.13         |
    | 10023115 | ORG0023115 | NMF-2581          | 2208100         | NMF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2208200         | NMF1819                    | 201903               | PROFILE         | CM             | False       | 1077.98         |
    | 10023115 | ORG0023115 | NMF-2581          | 2430670         | NMF1819                    | 201903               | PROFILE         | CM             | False       | 1460.77         |
    | 10023115 | ORG0023115 | NMF-2581          | 2202032         | NMF1819                    | 201904               | PROFILE         | CM             | False       | 3819.97         |
    | 10023115 | ORG0023115 | NMF-2581          | 2202033         | NMF1819                    | 201904               | PROFILE         | CM             | False       | 2041.38         |
    | 10023115 | ORG0023115 | NMF-2581          | 2202034         | NMF1819                    | 201904               | PROFILE         | CM             | False       | 1830.88         |
    | 10023115 | ORG0023115 | NMF-2581          | 2202070         | NMF1819                    | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2203026         | NMF1819                    | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2206038         | NMF1819                    | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2208000         | NMF1819                    | 201904               | PROFILE         | CM             | False       | 3185.49         |
    | 10023115 | ORG0023115 | NMF-2581          | 2208100         | NMF1819                    | 201904               | PROFILE         | CM             | False       | 4791.79         |
    | 10023115 | ORG0023115 | NMF-2581          | 2208200         | NMF1819                    | 201904               | PROFILE         | CM             | False       | 3013.21         |
    | 10023115 | ORG0023115 | NMF-2581          | 2430670         | NMF1819                    | 201904               | PROFILE         | CM             | False       | 2802.71         |
    | 10023115 | ORG0023115 | NMF-2581          | 2202032         | NMF1819                    | 201905               | PROFILE         | CM             | False       | 125.27          |
    | 10023115 | ORG0023115 | NMF-2581          | 2202033         | NMF1819                    | 201905               | PROFILE         | CM             | False       | 633.91          |
    | 10023115 | ORG0023115 | NMF-2581          | 2202034         | NMF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202070         | NMF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2203026         | NMF1819                    | 201905               | PROFILE         | CM             | False       | 1615.00         |
    | 10023115 | ORG0023115 | NMF-2581          | 2206038         | NMF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2208000         | NMF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2208100         | NMF1819                    | 201905               | PROFILE         | CM             | False       | 3978.59         |
    | 10023115 | ORG0023115 | NMF-2581          | 2208200         | NMF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2430670         | NMF1819                    | 201905               | PROFILE         | CM             | False       | 296.56          |
    | 10023115 | ORG0023115 | NMF-2581          | 2202032         | NMF1819                    | 201906               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202033         | NMF1819                    | 201906               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202034         | NMF1819                    | 201906               | PROFILE         | CM             | False       | 4348.71         |
    | 10023115 | ORG0023115 | NMF-2581          | 2202070         | NMF1819                    | 201906               | PROFILE         | CM             | False       | 3416.09         |
    | 10023115 | ORG0023115 | NMF-2581          | 2203026         | NMF1819                    | 201906               | PROFILE         | CM             | False       | 2806.09         |
    | 10023115 | ORG0023115 | NMF-2581          | 2206038         | NMF1819                    | 201906               | PROFILE         | CM             | False       | 8856.09         |
    | 10023115 | ORG0023115 | NMF-2581          | 2208000         | NMF1819                    | 201906               | PROFILE         | CM             | False       | 4262.07         |
    | 10023115 | ORG0023115 | NMF-2581          | 2208100         | NMF1819                    | 201906               | PROFILE         | CM             | False       | 792.52          |
    | 10023115 | ORG0023115 | NMF-2581          | 2208200         | NMF1819                    | 201906               | PROFILE         | CM             | False       | 3839.08         |
    | 10023115 | ORG0023115 | NMF-2581          | 2430670         | NMF1819                    | 201906               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202032         | NMF1819                    | 201907               | PROFILE         | CM             | False       | 0.35            |
    | 10023115 | ORG0023115 | NMF-2581          | 2202033         | NMF1819                    | 201907               | PROFILE         | CM             | False       | 1884.31         |
    | 10023115 | ORG0023115 | NMF-2581          | 2202034         | NMF1819                    | 201907               | PROFILE         | CM             | False       | 4335.11         |
    | 10023115 | ORG0023115 | NMF-2581          | 2202070         | NMF1819                    | 201907               | PROFILE         | CM             | False       | 0.84            |
    | 10023115 | ORG0023115 | NMF-2581          | 2203026         | NMF1819                    | 201907               | PROFILE         | CM             | False       | 400.84          |
    | 10023115 | ORG0023115 | NMF-2581          | 2206038         | NMF1819                    | 201907               | PROFILE         | CM             | False       | 600.84          |
    | 10023115 | ORG0023115 | NMF-2581          | 2208000         | NMF1819                    | 201907               | PROFILE         | CM             | False       | 4719.73         |
    | 10023115 | ORG0023115 | NMF-2581          | 2208100         | NMF1819                    | 201907               | PROFILE         | CM             | False       | 402.95          |
    | 10023115 | ORG0023115 | NMF-2581          | 2208200         | NMF1819                    | 201907               | PROFILE         | CM             | False       | 0.43            |
    | 10023115 | ORG0023115 | NMF-2581          | 2430670         | NMF1819                    | 201907               | PROFILE         | CM             | False       | 105.29          |
    #
    | 10023115 | ORG0023115 | SSF-2581          | 2202800         | SSF1819                    | 201808               | PROFILE         | CM             | False       | -2683.55        |
    | 10023115 | ORG0023115 | SSF-2581          | 2206029         | SSF1819                    | 201808               | PROFILE         | CM             | False       | -162.83         |
    | 10023115 | ORG0023115 | SSF-2581          | 2206044         | SSF1819                    | 201808               | PROFILE         | CM             | False       | -2983.69        |
    | 10023115 | ORG0023115 | SSF-2581          | 2218011         | SSF1819                    | 201808               | PROFILE         | CM             | False       | -3623.18        |
    | 10023115 | ORG0023115 | SSF-2581          | 2219140         | SSF1819                    | 201808               | PROFILE         | CM             | False       | -2342.69        |
    | 10023115 | ORG0023115 | SSF-2581          | 2202800         | SSF1819                    | 201809               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | SSF-2581          | 2206029         | SSF1819                    | 201809               | PROFILE         | CM             | False       | -515.84         |
    | 10023115 | ORG0023115 | SSF-2581          | 2206044         | SSF1819                    | 201809               | PROFILE         | CM             | False       | -1156.33        |
    | 10023115 | ORG0023115 | SSF-2581          | 2218011         | SSF1819                    | 201809               | PROFILE         | CM             | False       | -2523.93        |
    | 10023115 | ORG0023115 | SSF-2581          | 2219140         | SSF1819                    | 201809               | PROFILE         | CM             | False       | -1611.33        |
    | 10023115 | ORG0023115 | SSF-2581          | 2202800         | SSF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | SSF-2581          | 2206029         | SSF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | SSF-2581          | 2206044         | SSF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | SSF-2581          | 2218011         | SSF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | SSF-2581          | 2219140         | SSF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | SSF-2581          | 2202800         | SSF1819                    | 201811               | PROFILE         | CM             | False       | 408.24          |
    | 10023115 | ORG0023115 | SSF-2581          | 2206029         | SSF1819                    | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | SSF-2581          | 2206044         | SSF1819                    | 201811               | PROFILE         | CM             | False       | 4936.25         |
    | 10023115 | ORG0023115 | SSF-2581          | 2218011         | SSF1819                    | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | SSF-2581          | 2219140         | SSF1819                    | 201811               | PROFILE         | CM             | False       | 2678.25         |
    | 10023115 | ORG0023115 | SSF-2581          | 2202800         | SSF1819                    | 201812               | PROFILE         | CM             | False       | 2557.94         |
    | 10023115 | ORG0023115 | SSF-2581          | 2206029         | SSF1819                    | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | SSF-2581          | 2206044         | SSF1819                    | 201812               | PROFILE         | CM             | False       | 441.01          |
    | 10023115 | ORG0023115 | SSF-2581          | 2218011         | SSF1819                    | 201812               | PROFILE         | CM             | False       | 1373.62         |
    | 10023115 | ORG0023115 | SSF-2581          | 2219140         | SSF1819                    | 201812               | PROFILE         | CM             | False       | 1009.01         |
    | 10023115 | ORG0023115 | SSF-2581          | 2202800         | SSF1819                    | 201901               | PROFILE         | CM             | False       | 1955.24         |
    | 10023115 | ORG0023115 | SSF-2581          | 2206029         | SSF1819                    | 201901               | PROFILE         | CM             | False       | 3984.52         |
    | 10023115 | ORG0023115 | SSF-2581          | 2206044         | SSF1819                    | 201901               | PROFILE         | CM             | False       | 4916.15         |
    | 10023115 | ORG0023115 | SSF-2581          | 2218011         | SSF1819                    | 201901               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | SSF-2581          | 2219140         | SSF1819                    | 201901               | PROFILE         | CM             | False       | 2477.15         |
    | 10023115 | ORG0023115 | SSF-2581          | 2202800         | SSF1819                    | 201902               | PROFILE         | CM             | False       | 2960.82         |
    | 10023115 | ORG0023115 | SSF-2581          | 2206029         | SSF1819                    | 201902               | PROFILE         | CM             | False       | 4017.31         |
    | 10023115 | ORG0023115 | SSF-2581          | 2206044         | SSF1819                    | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | SSF-2581          | 2218011         | SSF1819                    | 201902               | PROFILE         | CM             | False       | 2154.06         |
    | 10023115 | ORG0023115 | SSF-2581          | 2219140         | SSF1819                    | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | SSF-2581          | 2202800         | SSF1819                    | 201903               | PROFILE         | CM             | False       | 2907.95         |
    | 10023115 | ORG0023115 | SSF-2581          | 2206029         | SSF1819                    | 201903               | PROFILE         | CM             | False       | 1426.51         |
    | 10023115 | ORG0023115 | SSF-2581          | 2206044         | SSF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | SSF-2581          | 2218011         | SSF1819                    | 201903               | PROFILE         | CM             | False       | 1003.51         |
    | 10023115 | ORG0023115 | SSF-2581          | 2219140         | SSF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | SSF-2581          | 2202800         | SSF1819                    | 201904               | PROFILE         | CM             | False       | 4335.54         |
    | 10023115 | ORG0023115 | SSF-2581          | 2206029         | SSF1819                    | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | SSF-2581          | 2206044         | SSF1819                    | 201904               | PROFILE         | CM             | False       | 4037.41         |
    | 10023115 | ORG0023115 | SSF-2581          | 2218011         | SSF1819                    | 201904               | PROFILE         | CM             | False       | 1585.12         |
    | 10023115 | ORG0023115 | SSF-2581          | 2219140         | SSF1819                    | 201904               | PROFILE         | CM             | False       | 6125.41         |
    | 10023115 | ORG0023115 | SSF-2581          | 2202800         | SSF1819                    | 201905               | PROFILE         | CM             | False       | 1446.61         |
    | 10023115 | ORG0023115 | SSF-2581          | 2206029         | SSF1819                    | 201905               | PROFILE         | CM             | False       | 91.01           |
    | 10023115 | ORG0023115 | SSF-2581          | 2206044         | SSF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | SSF-2581          | 2218011         | SSF1819                    | 201905               | PROFILE         | CM             | False       | 3053.91         |
    | 10023115 | ORG0023115 | SSF-2581          | 2219140         | SSF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023115 | ORG0023115 | SSF-2581          | 2202800         | SSF1819                    | 201906               | PROFILE         | CM             | False       | 4863.27         |
    | 10023115 | ORG0023115 | SSF-2581          | 2206029         | SSF1819                    | 201906               | PROFILE         | CM             | False       | 2537.84         |
    | 10023115 | ORG0023115 | SSF-2581          | 2206044         | SSF1819                    | 201906               | PROFILE         | CM             | False       | 3000.03         |
    | 10023115 | ORG0023115 | SSF-2581          | 2218011         | SSF1819                    | 201906               | PROFILE         | CM             | False       | 3806.81         |
    | 10023115 | ORG0023115 | SSF-2581          | 2219140         | SSF1819                    | 201906               | PROFILE         | CM             | False       | 6223.03         |
    | 10023115 | ORG0023115 | SSF-2581          | 2202800         | SSF1819                    | 201907               | PROFILE         | CM             | False       | 0.94            |
    | 10023115 | ORG0023115 | SSF-2581          | 2206029         | SSF1819                    | 201907               | PROFILE         | CM             | False       | 791.48          |
    | 10023115 | ORG0023115 | SSF-2581          | 2206044         | SSF1819                    | 201907               | PROFILE         | CM             | False       | 284.17          |
    | 10023115 | ORG0023115 | SSF-2581          | 2218011         | SSF1819                    | 201907               | PROFILE         | CM             | False       | 0.08            |
    | 10023115 | ORG0023115 | SSF-2581          | 2219140         | SSF1819                    | 201907               | PROFILE         | CM             | False       | 1879.17         |
    #
    | 10023592 | ORG0023592 | 16LR-2582         | 2203000         | 1619LR1819                 | 201808               | PROFILE         | CM             | False       | -126.68         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203003         | 1619LR1819                 | 201808               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203006         | 1619LR1819                 | 201808               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203022         | 1619LR1819                 | 201808               | PROFILE         | CM             | False       | -813.12         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203023         | 1619LR1819                 | 201808               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206036         | 1619LR1819                 | 201808               | PROFILE         | CM             | False       | -39.04          |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206042         | 1619LR1819                 | 201808               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203000         | 1619LR1819                 | 201809               | PROFILE         | CM             | False       | -4662.92        |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203003         | 1619LR1819                 | 201809               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203006         | 1619LR1819                 | 201809               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203022         | 1619LR1819                 | 201809               | PROFILE         | CM             | False       | -2660.58        |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203023         | 1619LR1819                 | 201809               | PROFILE         | CM             | False       | -3601.19        |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206036         | 1619LR1819                 | 201809               | PROFILE         | CM             | False       | -52.71          |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206042         | 1619LR1819                 | 201809               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203000         | 1619LR1819                 | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203003         | 1619LR1819                 | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203006         | 1619LR1819                 | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203022         | 1619LR1819                 | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203023         | 1619LR1819                 | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206036         | 1619LR1819                 | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206042         | 1619LR1819                 | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203000         | 1619LR1819                 | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203003         | 1619LR1819                 | 201811               | PROFILE         | CM             | False       | 1982.00         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203006         | 1619LR1819                 | 201811               | PROFILE         | CM             | False       | 3954.62         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203022         | 1619LR1819                 | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203023         | 1619LR1819                 | 201811               | PROFILE         | CM             | False       | 272.58          |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206036         | 1619LR1819                 | 201811               | PROFILE         | CM             | False       | 2097.13         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206042         | 1619LR1819                 | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203000         | 1619LR1819                 | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203003         | 1619LR1819                 | 201812               | PROFILE         | CM             | False       | 295.00          |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203006         | 1619LR1819                 | 201812               | PROFILE         | CM             | False       | 768.55          |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203022         | 1619LR1819                 | 201812               | PROFILE         | CM             | False       | 3815.11         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203023         | 1619LR1819                 | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206036         | 1619LR1819                 | 201812               | PROFILE         | CM             | False       | 4582.18         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206042         | 1619LR1819                 | 201812               | PROFILE         | CM             | False       | 3392.12         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203000         | 1619LR1819                 | 201901               | PROFILE         | CM             | False       | 3980.47         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203003         | 1619LR1819                 | 201901               | PROFILE         | CM             | False       | 378.00          |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203006         | 1619LR1819                 | 201901               | PROFILE         | CM             | False       | 378.33          |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203022         | 1619LR1819                 | 201901               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203023         | 1619LR1819                 | 201901               | PROFILE         | CM             | False       | 81.19           |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206036         | 1619LR1819                 | 201901               | PROFILE         | CM             | False       | 213.78          |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206042         | 1619LR1819                 | 201901               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203000         | 1619LR1819                 | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203003         | 1619LR1819                 | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203006         | 1619LR1819                 | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203022         | 1619LR1819                 | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203023         | 1619LR1819                 | 201902               | PROFILE         | CM             | False       | 451.31          |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206036         | 1619LR1819                 | 201902               | PROFILE         | CM             | False       | 2996.97         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206042         | 1619LR1819                 | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203000         | 1619LR1819                 | 201903               | PROFILE         | CM             | False       | 2943.11         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203003         | 1619LR1819                 | 201903               | PROFILE         | CM             | False       | 2500.00         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203006         | 1619LR1819                 | 201903               | PROFILE         | CM             | False       | 907.07          |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203022         | 1619LR1819                 | 201903               | PROFILE         | CM             | False       | 4800.61         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203023         | 1619LR1819                 | 201903               | PROFILE         | CM             | False       | 358.23          |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206036         | 1619LR1819                 | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206042         | 1619LR1819                 | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203000         | 1619LR1819                 | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203003         | 1619LR1819                 | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203006         | 1619LR1819                 | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203022         | 1619LR1819                 | 201904               | PROFILE         | CM             | False       | 1363.82         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203023         | 1619LR1819                 | 201904               | PROFILE         | CM             | False       | 4410.38         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206036         | 1619LR1819                 | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206042         | 1619LR1819                 | 201904               | PROFILE         | CM             | False       | 2758.63         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203000         | 1619LR1819                 | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203003         | 1619LR1819                 | 201905               | PROFILE         | CM             | False       | 2212.00         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203006         | 1619LR1819                 | 201905               | PROFILE         | CM             | False       | 2408.62         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203022         | 1619LR1819                 | 201905               | PROFILE         | CM             | False       | 4357.51         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203023         | 1619LR1819                 | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206036         | 1619LR1819                 | 201905               | PROFILE         | CM             | False       | 1991.38         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206042         | 1619LR1819                 | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203000         | 1619LR1819                 | 201906               | PROFILE         | CM             | False       | 457.05          |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203003         | 1619LR1819                 | 201906               | PROFILE         | CM             | False       | 1750.00         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203006         | 1619LR1819                 | 201906               | PROFILE         | CM             | False       | 1680.07         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203022         | 1619LR1819                 | 201906               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203023         | 1619LR1819                 | 201906               | PROFILE         | CM             | False       | 4642.97         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206036         | 1619LR1819                 | 201906               | PROFILE         | CM             | False       | 3802.74         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206042         | 1619LR1819                 | 201906               | PROFILE         | CM             | False       | 2864.38         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203000         | 1619LR1819                 | 201907               | PROFILE         | CM             | False       | 0.97            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203003         | 1619LR1819                 | 201907               | PROFILE         | CM             | False       | 5200.00         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203006         | 1619LR1819                 | 201907               | PROFILE         | CM             | False       | 4377.74         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203022         | 1619LR1819                 | 201907               | PROFILE         | CM             | False       | 1753.65         |
    | 10023592 | ORG0023592 | 16LR-2582         | 2203023         | 1619LR1819                 | 201907               | PROFILE         | CM             | False       | 0.53            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206036         | 1619LR1819                 | 201907               | PROFILE         | CM             | False       | 0.57            |
    | 10023592 | ORG0023592 | 16LR-2582         | 2206042         | 1619LR1819                 | 201907               | PROFILE         | CM             | False       | 1204.87         |
    #
    | 10023592 | ORG0023592 | NMF-2582          | 2202070         | NMF1819                    | 201808               | PROFILE         | CM             | False       | -3639.53        |
    | 10023592 | ORG0023592 | NMF-2582          | 2202993         | NMF1819                    | 201808               | PROFILE         | CM             | False       | -3505.94        |
    | 10023592 | ORG0023592 | NMF-2582          | 2203110         | NMF1819                    | 201808               | PROFILE         | CM             | False       | 2645.09         |
    | 10023592 | ORG0023592 | NMF-2582          | 2206020         | NMF1819                    | 201808               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2218120         | NMF1819                    | 201808               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2322200         | NMF1819                    | 201808               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2430670         | NMF1819                    | 201808               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2601005         | NMF1819                    | 201808               | PROFILE         | CM             | False       | 3005.09         |
    | 10023592 | ORG0023592 | NMF-2582          | 2202070         | NMF1819                    | 201809               | PROFILE         | CM             | False       | -2838.43        |
    | 10023592 | ORG0023592 | NMF-2582          | 2202993         | NMF1819                    | 201809               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2203110         | NMF1819                    | 201809               | PROFILE         | CM             | False       | 1089.23         |
    | 10023592 | ORG0023592 | NMF-2582          | 2206020         | NMF1819                    | 201809               | PROFILE         | CM             | False       | -3859.95        |
    | 10023592 | ORG0023592 | NMF-2582          | 2218120         | NMF1819                    | 201809               | PROFILE         | CM             | False       | -357.41         |
    | 10023592 | ORG0023592 | NMF-2582          | 2322200         | NMF1819                    | 201809               | PROFILE         | CM             | False       | -3777.95        |
    | 10023592 | ORG0023592 | NMF-2582          | 2430670         | NMF1819                    | 201809               | PROFILE         | CM             | False       | -4078.19        |
    | 10023592 | ORG0023592 | NMF-2582          | 2601005         | NMF1819                    | 201809               | PROFILE         | CM             | False       | 1250.23         |
    | 10023592 | ORG0023592 | NMF-2582          | 2202070         | NMF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2202993         | NMF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2203110         | NMF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2206020         | NMF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2218120         | NMF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2322200         | NMF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2430670         | NMF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2601005         | NMF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2202070         | NMF1819                    | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2202993         | NMF1819                    | 201811               | PROFILE         | CM             | False       | 1709.78         |
    | 10023592 | ORG0023592 | NMF-2582          | 2203110         | NMF1819                    | 201811               | PROFILE         | CM             | False       | 350.25          |
    | 10023592 | ORG0023592 | NMF-2582          | 2206020         | NMF1819                    | 201811               | PROFILE         | CM             | False       | 2852.89         |
    | 10023592 | ORG0023592 | NMF-2582          | 2218120         | NMF1819                    | 201811               | PROFILE         | CM             | False       | 1497.29         |
    | 10023592 | ORG0023592 | NMF-2582          | 2322200         | NMF1819                    | 201811               | PROFILE         | CM             | False       | 2143.89         |
    | 10023592 | ORG0023592 | NMF-2582          | 2430670         | NMF1819                    | 201811               | PROFILE         | CM             | False       | 4201.76         |
    | 10023592 | ORG0023592 | NMF-2582          | 2601005         | NMF1819                    | 201811               | PROFILE         | CM             | False       | 985.25          |
    | 10023592 | ORG0023592 | NMF-2582          | 2202070         | NMF1819                    | 201812               | PROFILE         | CM             | False       | 4868.02         |
    | 10023592 | ORG0023592 | NMF-2582          | 2202993         | NMF1819                    | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2203110         | NMF1819                    | 201812               | PROFILE         | CM             | False       | 4125.55         |
    | 10023592 | ORG0023592 | NMF-2582          | 2206020         | NMF1819                    | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2218120         | NMF1819                    | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2322200         | NMF1819                    | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2430670         | NMF1819                    | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2601005         | NMF1819                    | 201812               | PROFILE         | CM             | False       | 3986.55         |
    | 10023592 | ORG0023592 | NMF-2582          | 2202070         | NMF1819                    | 201901               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2202993         | NMF1819                    | 201901               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2203110         | NMF1819                    | 201901               | PROFILE         | CM             | False       | 75.33           |
    | 10023592 | ORG0023592 | NMF-2582          | 2206020         | NMF1819                    | 201901               | PROFILE         | CM             | False       | 3930.46         |
    | 10023592 | ORG0023592 | NMF-2582          | 2218120         | NMF1819                    | 201901               | PROFILE         | CM             | False       | 4016.11         |
    | 10023592 | ORG0023592 | NMF-2582          | 2322200         | NMF1819                    | 201901               | PROFILE         | CM             | False       | 4545.46         |
    | 10023592 | ORG0023592 | NMF-2582          | 2430670         | NMF1819                    | 201901               | PROFILE         | CM             | False       | 1894.43         |
    | 10023592 | ORG0023592 | NMF-2582          | 2601005         | NMF1819                    | 201901               | PROFILE         | CM             | False       | 7225.33         |
    | 10023592 | ORG0023592 | NMF-2582          | 2202070         | NMF1819                    | 201902               | PROFILE         | CM             | False       | 1544.42         |
    | 10023592 | ORG0023592 | NMF-2582          | 2202993         | NMF1819                    | 201902               | PROFILE         | CM             | False       | 1550.16         |
    | 10023592 | ORG0023592 | NMF-2582          | 2203110         | NMF1819                    | 201902               | PROFILE         | CM             | False       | 1723.33         |
    | 10023592 | ORG0023592 | NMF-2582          | 2206020         | NMF1819                    | 201902               | PROFILE         | CM             | False       | 4386.23         |
    | 10023592 | ORG0023592 | NMF-2582          | 2218120         | NMF1819                    | 201902               | PROFILE         | CM             | False       | 367.84          |
    | 10023592 | ORG0023592 | NMF-2582          | 2322200         | NMF1819                    | 201902               | PROFILE         | CM             | False       | 2887.23         |
    | 10023592 | ORG0023592 | NMF-2582          | 2430670         | NMF1819                    | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2601005         | NMF1819                    | 201902               | PROFILE         | CM             | False       | 2083.33         |
    | 10023592 | ORG0023592 | NMF-2582          | 2202070         | NMF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2202993         | NMF1819                    | 201903               | PROFILE         | CM             | False       | 949.45          |
    | 10023592 | ORG0023592 | NMF-2582          | 2203110         | NMF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2206020         | NMF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2218120         | NMF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2322200         | NMF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2430670         | NMF1819                    | 201903               | PROFILE         | CM             | False       | 2126.03         |
    | 10023592 | ORG0023592 | NMF-2582          | 2601005         | NMF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2202070         | NMF1819                    | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2202993         | NMF1819                    | 201904               | PROFILE         | CM             | False       | 1953.05         |
    | 10023592 | ORG0023592 | NMF-2582          | 2203110         | NMF1819                    | 201904               | PROFILE         | CM             | False       | 65.56           |
    | 10023592 | ORG0023592 | NMF-2582          | 2206020         | NMF1819                    | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2218120         | NMF1819                    | 201904               | PROFILE         | CM             | False       | 1147.28         |
    | 10023592 | ORG0023592 | NMF-2582          | 2322200         | NMF1819                    | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2430670         | NMF1819                    | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2601005         | NMF1819                    | 201904               | PROFILE         | CM             | False       | 4135.56         |
    | 10023592 | ORG0023592 | NMF-2582          | 2202070         | NMF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2202993         | NMF1819                    | 201905               | PROFILE         | CM             | False       | 1900.18         |
    | 10023592 | ORG0023592 | NMF-2582          | 2203110         | NMF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2206020         | NMF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2218120         | NMF1819                    | 201905               | PROFILE         | CM             | False       | 4948.73         |
    | 10023592 | ORG0023592 | NMF-2582          | 2322200         | NMF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2430670         | NMF1819                    | 201905               | PROFILE         | CM             | False       | 3078.74         |
    | 10023592 | ORG0023592 | NMF-2582          | 2601005         | NMF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2202070         | NMF1819                    | 201906               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2202993         | NMF1819                    | 201906               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2203110         | NMF1819                    | 201906               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2206020         | NMF1819                    | 201906               | PROFILE         | CM             | False       | 3031.62         |
    | 10023592 | ORG0023592 | NMF-2582          | 2218120         | NMF1819                    | 201906               | PROFILE         | CM             | False       | 578.34          |
    | 10023592 | ORG0023592 | NMF-2582          | 2322200         | NMF1819                    | 201906               | PROFILE         | CM             | False       | 3423.62         |
    | 10023592 | ORG0023592 | NMF-2582          | 2430670         | NMF1819                    | 201906               | PROFILE         | CM             | False       | 869.73          |
    | 10023592 | ORG0023592 | NMF-2582          | 2601005         | NMF1819                    | 201906               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | NMF-2582          | 2202070         | NMF1819                    | 201907               | PROFILE         | CM             | False       | 0.52            |
    | 10023592 | ORG0023592 | NMF-2582          | 2202993         | NMF1819                    | 201907               | PROFILE         | CM             | False       | 0.32            |
    | 10023592 | ORG0023592 | NMF-2582          | 2203110         | NMF1819                    | 201907               | PROFILE         | CM             | False       | 0.01            |
    | 10023592 | ORG0023592 | NMF-2582          | 2206020         | NMF1819                    | 201907               | PROFILE         | CM             | False       | 1584.75         |
    | 10023592 | ORG0023592 | NMF-2582          | 2218120         | NMF1819                    | 201907               | PROFILE         | CM             | False       | 2046.82         |
    | 10023592 | ORG0023592 | NMF-2582          | 2322200         | NMF1819                    | 201907               | PROFILE         | CM             | False       | 1238.75         |
    | 10023592 | ORG0023592 | NMF-2582          | 2430670         | NMF1819                    | 201907               | PROFILE         | CM             | False       | 2933.50         |
    | 10023592 | ORG0023592 | NMF-2582          | 2601005         | NMF1819                    | 201907               | PROFILE         | CM             | False       | 0.01            |
    #
    | 10023592 | ORG0023592 | SSF-2582          | 2202800         | SSF1819                    | 201808               | PROFILE         | CM             | False       | -1468.95        |
    | 10023592 | ORG0023592 | SSF-2582          | 2203007         | SSF1819                    | 201808               | PROFILE         | CM             | False       | -2622.07        |
    | 10023592 | ORG0023592 | SSF-2582          | 2206029         | SSF1819                    | 201808               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206037         | SSF1819                    | 201808               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206044         | SSF1819                    | 201808               | PROFILE         | CM             | False       | -1641.25        |
    | 10023592 | ORG0023592 | SSF-2582          | 2218011         | SSF1819                    | 201808               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2218200         | SSF1819                    | 201808               | PROFILE         | CM             | False       | -1641.25        |
    | 10023592 | ORG0023592 | SSF-2582          | 2219100         | SSF1819                    | 201808               | PROFILE         | CM             | False       | -4537.76        |
    | 10023592 | ORG0023592 | SSF-2582          | 2202800         | SSF1819                    | 201809               | PROFILE         | CM             | False       | -3016.28        |
    | 10023592 | ORG0023592 | SSF-2582          | 2203007         | SSF1819                    | 201809               | PROFILE         | CM             | False       | -2462.45        |
    | 10023592 | ORG0023592 | SSF-2582          | 2206029         | SSF1819                    | 201809               | PROFILE         | CM             | False       | -1695.12        |
    | 10023592 | ORG0023592 | SSF-2582          | 2206037         | SSF1819                    | 201809               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206044         | SSF1819                    | 201809               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2218011         | SSF1819                    | 201809               | PROFILE         | CM             | False       | -4083.75        |
    | 10023592 | ORG0023592 | SSF-2582          | 2218200         | SSF1819                    | 201809               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2219100         | SSF1819                    | 201809               | PROFILE         | CM             | False       | -962.25         |
    | 10023592 | ORG0023592 | SSF-2582          | 2202800         | SSF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2203007         | SSF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206029         | SSF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206037         | SSF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206044         | SSF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2218011         | SSF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2218200         | SSF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2219100         | SSF1819                    | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2202800         | SSF1819                    | 201811               | PROFILE         | CM             | False       | 3516.28         |
    | 10023592 | ORG0023592 | SSF-2582          | 2203007         | SSF1819                    | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206029         | SSF1819                    | 201811               | PROFILE         | CM             | False       | 4448.89         |
    | 10023592 | ORG0023592 | SSF-2582          | 2206037         | SSF1819                    | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206044         | SSF1819                    | 201811               | PROFILE         | CM             | False       | 1401.34         |
    | 10023592 | ORG0023592 | SSF-2582          | 2218011         | SSF1819                    | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2218200         | SSF1819                    | 201811               | PROFILE         | CM             | False       | 1401.34         |
    | 10023592 | ORG0023592 | SSF-2582          | 2219100         | SSF1819                    | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2202800         | SSF1819                    | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2203007         | SSF1819                    | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206029         | SSF1819                    | 201812               | PROFILE         | CM             | False       | 4818.02         |
    | 10023592 | ORG0023592 | SSF-2582          | 2206037         | SSF1819                    | 201812               | PROFILE         | CM             | False       | 1606.91         |
    | 10023592 | ORG0023592 | SSF-2582          | 2206044         | SSF1819                    | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2218011         | SSF1819                    | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2218200         | SSF1819                    | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2219100         | SSF1819                    | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2202800         | SSF1819                    | 201901               | PROFILE         | CM             | False       | 534.27          |
    | 10023592 | ORG0023592 | SSF-2582          | 2203007         | SSF1819                    | 201901               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206029         | SSF1819                    | 201901               | PROFILE         | CM             | False       | 3410.53         |
    | 10023592 | ORG0023592 | SSF-2582          | 2206037         | SSF1819                    | 201901               | PROFILE         | CM             | False       | 4897.73         |
    | 10023592 | ORG0023592 | SSF-2582          | 2206044         | SSF1819                    | 201901               | PROFILE         | CM             | False       | 1804.23         |
    | 10023592 | ORG0023592 | SSF-2582          | 2218011         | SSF1819                    | 201901               | PROFILE         | CM             | False       | 2861.69         |
    | 10023592 | ORG0023592 | SSF-2582          | 2218200         | SSF1819                    | 201901               | PROFILE         | CM             | False       | 1804.23         |
    | 10023592 | ORG0023592 | SSF-2582          | 2219100         | SSF1819                    | 201901               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2202800         | SSF1819                    | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2203007         | SSF1819                    | 201902               | PROFILE         | CM             | False       | 4415.13         |
    | 10023592 | ORG0023592 | SSF-2582          | 2206029         | SSF1819                    | 201902               | PROFILE         | CM             | False       | 2511.68         |
    | 10023592 | ORG0023592 | SSF-2582          | 2206037         | SSF1819                    | 201902               | PROFILE         | CM             | False       | 3357.65         |
    | 10023592 | ORG0023592 | SSF-2582          | 2206044         | SSF1819                    | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2218011         | SSF1819                    | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2218200         | SSF1819                    | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2219100         | SSF1819                    | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2202800         | SSF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2203007         | SSF1819                    | 201903               | PROFILE         | CM             | False       | 2458.81         |
    | 10023592 | ORG0023592 | SSF-2582          | 2206029         | SSF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206037         | SSF1819                    | 201903               | PROFILE         | CM             | False       | 3939.27         |
    | 10023592 | ORG0023592 | SSF-2582          | 2206044         | SSF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2218011         | SSF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2218200         | SSF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2219100         | SSF1819                    | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2202800         | SSF1819                    | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2203007         | SSF1819                    | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206029         | SSF1819                    | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206037         | SSF1819                    | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206044         | SSF1819                    | 201904               | PROFILE         | CM             | False       | 2108.79         |
    | 10023592 | ORG0023592 | SSF-2582          | 2218011         | SSF1819                    | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2218200         | SSF1819                    | 201904               | PROFILE         | CM             | False       | 2108.79         |
    | 10023592 | ORG0023592 | SSF-2582          | 2219100         | SSF1819                    | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2202800         | SSF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2203007         | SSF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206029         | SSF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206037         | SSF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206044         | SSF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2218011         | SSF1819                    | 201905               | PROFILE         | CM             | False       | 1381.24         |
    | 10023592 | ORG0023592 | SSF-2582          | 2218200         | SSF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2219100         | SSF1819                    | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2202800         | SSF1819                    | 201906               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2203007         | SSF1819                    | 201906               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206029         | SSF1819                    | 201906               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2206037         | SSF1819                    | 201906               | PROFILE         | CM             | False       | 905.38          |
    | 10023592 | ORG0023592 | SSF-2582          | 2206044         | SSF1819                    | 201906               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2218011         | SSF1819                    | 201906               | PROFILE         | CM             | False       | 1454.22         |
    | 10023592 | ORG0023592 | SSF-2582          | 2218200         | SSF1819                    | 201906               | PROFILE         | CM             | False       | 0.00            |
    | 10023592 | ORG0023592 | SSF-2582          | 2219100         | SSF1819                    | 201906               | PROFILE         | CM             | False       | 2134.64         |
    | 10023592 | ORG0023592 | SSF-2582          | 2202800         | SSF1819                    | 201907               | PROFILE         | CM             | False       | 2373.68         |
    | 10023592 | ORG0023592 | SSF-2582          | 2203007         | SSF1819                    | 201907               | PROFILE         | CM             | False       | 852.58          |
    | 10023592 | ORG0023592 | SSF-2582          | 2206029         | SSF1819                    | 201907               | PROFILE         | CM             | False       | 1487.00         |
    | 10023592 | ORG0023592 | SSF-2582          | 2206037         | SSF1819                    | 201907               | PROFILE         | CM             | False       | 767.06          |
    | 10023592 | ORG0023592 | SSF-2582          | 2206044         | SSF1819                    | 201907               | PROFILE         | CM             | False       | 0.89            |
    | 10023592 | ORG0023592 | SSF-2582          | 2218011         | SSF1819                    | 201907               | PROFILE         | CM             | False       | 0.60            |
    | 10023592 | ORG0023592 | SSF-2582          | 2218200         | SSF1819                    | 201907               | PROFILE         | CM             | False       | 0.89            |
    | 10023592 | ORG0023592 | SSF-2582          | 2219100         | SSF1819                    | 201907               | PROFILE         | CM             | False       | 4158.37         |
 
    # Tidy up
    And   the override date is reset
   