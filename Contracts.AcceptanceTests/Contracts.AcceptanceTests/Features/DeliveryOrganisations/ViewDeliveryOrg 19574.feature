Feature: ViewDeliveryOrg 19574

@AcceptanceTest @Withdrawn20191220
Scenario: A398 Create a new 1718 1619F (EFA) contract with two Allocs and Delivery Orgs. Update Draft changing one Delivery Org and adding a new Alloc and Delivery Org. Approve. Check CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017398' 
	And   there are no notifications of type 'Caseload re-assigned'
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Clear down data from the CRM Organisation table
    And   there is no Organisation data for UKPRN '10017398'
    And   there is no Organisation data for UKPRN '10217398'
    And   there is no Organisation data for UKPRN '10317398'
    And   there is no Organisation data for UKPRN '10417398'
    And   there is no Organisation data for UKPRN '10517398'

    # Add data to dbo.Organisations inc Dissolved
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status         | UKRLPCalledOk | CompanyNumber | CharityNumber |
    | 10017398 | 117398 | 10017398 Co Ltd | 0              | Active         | Yes           | AA017398      | ?             |
    | 10217398 | 217398 | 10217398 Co Ltd | 0              | Deleted        | Yes           | ?             | 27398         |
    | 10317398 | 317398 | 10317398 Co Ltd | 0              | Dissolved      | Yes           | AA317398      | 37398         |
    | 10417398 | 417398 | 10417398 Co Ltd | 0              | Inactive       | Yes           | ?             | ?             |
    | 10517398 | 517398 | 10517398 Co Ltd | 0              | In Liquidation | Yes           | AA517398      | 57398         |

	# Add data to CRM Organisations table
    And   the following Organisations exist in the CRM Organisations table
    | UKPRN    | UPIN   | Name             | CompanyNumber | CharityNumber |
    | 10017398 | 117398 | 10017398 Co Ltd  | AA017398      | ?             |

	# Associate an Advisor with the main provider
	And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017398'

    # Change the date
    And   the override date is '01/07/2017'

    # Associate an Advisor with the main provider without creating an Org
    #Given caseload advisor 'FCS2 Test' is assigned to provider '10017398 Co Ltd' with UKPRN '10017398' and OrgId 'ORG0000000' already created and has 'FCS1 Test' as a manager

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017398 | 10017398 Co Ltd      | ESFA-398             | 1619F-398      | 1                     | 01/08/2017        | 31/07/2018      | 284007.00     |                                | Contract for Services | 1718   | New          | ORG0017398 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017398 | 1619F-398      | 16LR-3981     | 1619LR            | 1619LR1718              | AY                      | 01/08/2017          | 31/07/2018        | 51196.00        |                         |            | THE LATYMER SCHOOL (113025)                                 | New          | 10217398    |
    | 10017398 | 1619F-398      | NMF-3981      | NMF               | NMF1718                 | AY                      | 01/08/2017          | 31/07/2018        | 39555.00        |                         |            | THE LATYMER SCHOOL (113025)                                 | New          | 10217398    |
    | 10017398 | 1619F-398      | SSF-3981      | SSF               | SSF1718                 | AY                      | 01/08/2017          | 31/07/2018        | 54472.00        |                         |            | THE LATYMER SCHOOL (113025)                                 | New          | 10217398    |
    #
    | 10017398 | 1619F-398      | 16LR-3982     | 1619LR            | 1619LR1718              | AY                      | 01/08/2017          | 31/07/2018        | 43890.00        |                         |            | BIRTENSHAW (122211)                                         | New          | 10317398    |
    | 10017398 | 1619F-398      | NMF-3982      | NMF               | NMF1718                 | AY                      | 01/08/2017          | 31/07/2018        | 26561.00        |                         |            | BIRTENSHAW (122211)                                         | New          | 10317398    |
    | 10017398 | 1619F-398      | SSF-3982      | SSF               | SSF1718                 | AY                      | 01/08/2017          | 31/07/2018        | 68333.00        |                         |            | BIRTENSHAW (122211)                                         | New          | 10317398    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017398 | 1619F-398      | 16LR-3981     | 19              | 0                     | 25985.00  | 2836.00  | 2560.00  | 3416.00  | 531.00   | 3428.00  | 2521.00  | 2940.00  | 957.00   | 2376.00  | 2228.00  | 293.00   | 1899.00  | 16-19 Bursary Funds                                             | New          | 10217398    |
    | 10017398 | 1619F-398      | 16LR-3981     | 20              | 0                     | 25211.00  | 2970.00  | 2214.00  | 3358.00  | 3068.00  | 2608.00  | 2192.00  | 273.00   | 493.00   | 2333.00  | 2037.00  | 897.00   | 2768.00  | 16-19 Total Programme Funding                                   | New          | 10217398    |
    | 10017398 | 1619F-398      | NMF-3981      | 31              | 0                     | 17836.00  | 364.00   | 2681.00  | 1805.00  | 781.00   | 701.00   | 907.00   | 2936.00  | 3486.00  | 1125.00  | 856.00   | 357.00   | 1837.00  | Cadets Vocational Programme                                     | New          | 10217398    |
    | 10017398 | 1619F-398      | NMF-3981      | 32              | 0                     | 21719.00  | 1843.00  | 1208.00  | 112.00   | 1065.00  | 2200.00  | 3233.00  | 471.00   | 115.00   | 1894.00  | 3449.00  | 2860.00  | 3269.00  | Closing Schools                                                 | New          | 10217398    |
    | 10017398 | 1619F-398      | SSF-3981      | 14              | 0                     | 28130.00  | 3439.00  | 3181.00  | 735.00   | 2700.00  | 2517.00  | 2352.00  | 129.00   | 3619.00  | 3382.00  | 918.00   | 1873.00  | 3285.00  | SSF Formula Protection Funding                                  | New          | 10217398    |
    | 10017398 | 1619F-398      | SSF-3981      | 15              | 0                     | 26342.00  | 1718.00  | 3731.00  | 894.00   | 3270.00  | 441.00   | 1350.00  | 1693.00  | 2331.00  | 3512.00  | 3404.00  | 3367.00  | 631.00   | SSF High Needs Element 2                                        | New          | 10217398    |
    #
    | 10017398 | 1619F-398      | 16LR-3982     | 19              | 0                     | 23168.00  | 2024.00  | 2194.00  | 1121.00  | 1167.00  | 2917.00  | 101.00   | 2865.00  | 3064.00  | 2674.00  | 217.00   | 1582.00  | 3242.00  | 16-19 Bursary Funds                                             | New          | 10317398    |
    | 10017398 | 1619F-398      | 16LR-3982     | 33              | 0                     | 20722.00  | 3673.00  | 275.00   | 1494.00  | 1400.00  | 1863.00  | 626.00   | 1805.00  | 1002.00  | 2377.00  | 2056.00  | 628.00   | 3523.00  | 19+ Continuing Learners Programme Funding                       | New          | 10317398    |
    | 10017398 | 1619F-398      | NMF-3982      | 51              | 0                     | 26561.00  | 1554.00  | 3185.00  | 3107.00  | 2538.00  | 2721.00  | 3739.00  | 1307.00  | 1882.00  | 1578.00  | 2623.00  | 712.00   | 1615.00  | Alternative Completions - AASE Sporting Excellence              | New          | 10317398    |
    | 10017398 | 1619F-398      | SSF-3982      | 2               | 0                     | 23866.00  | 3192.00  | 1892.00  | 744.00   | 3368.00  | 1429.00  | 1247.00  | 2902.00  | 856.00   | 1704.00  | 923.00   | 3300.00  | 2309.00  | SSF Total Programme Funding                                     | New          | 10317398    |
    | 10017398 | 1619F-398      | SSF-3982      | 13              | 0                     | 22439.00  | 1435.00  | 1491.00  | 3235.00  | 2218.00  | 3497.00  | 1964.00  | 1272.00  | 3264.00  | 1008.00  | 1010.00  | 711.00   | 1334.00  | SSF Bursary Funds                                               | New          | 10317398    |
    | 10017398 | 1619F-398      | SSF-3982      | 14              | 0                     | 22028.00  | 59.00    | 2797.00  | 3162.00  | 1081.00  | 2651.00  | 1548.00  | 3053.00  | 2795.00  | 1669.00  | 338.00   | 1569.00  | 1306.00  | SSF Formula Protection Funding                                  | New          | 10317398    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    And   the override date is '05/07/2017'

    # Cleardown Sharepoint
    And   there are no files prefixed '10017398_1619F-398' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1718 19042018132726 v3_A398_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed '1619FUND AY 1718 19042018132726 v3_A398_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '1619FUND AY 1718 19042018132726 v3_A398_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 19042018132726 v3_A398_1' in the Sharepoint 'Reports' folder

    # Bulk import to execute an 'Update Draft' on allocs 1 and 2, and adding a 'new' alloc 3 
    # DeliveryOrganisationUKPRN stays the same on alloc 1 but changes on alloc 2
    # Allocation Description changes on allocs 1 and 2
    And   spreadsheet '1619FUND AY 1718 19042018132726 v3_A398_1.xlsx' exists in the Datafiles folder and UKPRN '10017398' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Change the date
    Given the override date is '09/07/2017'

    # Publish the contract
    And   the latest version of contract '1619F-398' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-398' and actual ContractNumber '1619F-398'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017398 | 1619F-398          | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017398 | 1619F-398          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017398 | ESFA-398           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM has not changed post-approval
    And   there are '168' deliverable period rows in CRM linked to the latest version of contract '1619F-398'

    # Retrieve the master contract, contract and allocation numbers from CRM for the first (valid) delivery org
   #And   I retrieve the latest contract details from CRM for provider '10017390' for FundingType '1619FUND' and period '1718'
    And   I retrieve the latest EFA contract details from CRM for provider '10017398' for FundingType '1619FUND' and period '1718' and Delivery Organisation '10517398'

    # Check the DeliveryOrg data on the allocations 
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | DeliveryOrganisationUKPRN | AllocationRef    | AllocationStartDate | AllocationEndDate | DeliveryOrganisationProvider |
    | 10017398 | 1619F-398          | 1                     | 10217398                  | 16LR-3981        | 01/08/2017          | 31/07/2018        | 10217398 Co Ltd              |
    | 10017398 | 1619F-398          | 1                     | 10217398                  | NMF-3981         | 01/08/2017          | 31/07/2018        | 10217398 Co Ltd              |
    | 10017398 | 1619F-398          | 1                     | 10217398                  | SSF-3981         | 01/08/2017          | 31/07/2018        | 10217398 Co Ltd              |
    | 10017398 | 1619F-398          | 1                     | 10417398                  | 16LR-3982        | 01/08/2017          | 31/07/2018        | 10417398 Co Ltd              |
    | 10017398 | 1619F-398          | 1                     | 10417398                  | NMF-3982         | 01/08/2017          | 31/07/2018        | 10417398 Co Ltd              |
    | 10017398 | 1619F-398          | 1                     | 10417398                  | SSF-3982         | 01/08/2017          | 31/07/2018        | 10417398 Co Ltd              |
    | 10017398 | 1619F-398          | 1                     | 10517398                  | [AllocRef_16LR]  | 01/08/2017          | 31/07/2018        | 10517398 Co Ltd              |
    | 10017398 | 1619F-398          | 1                     | 10517398                  | [AllocRef_NMF]   | 01/08/2017          | 31/07/2018        | 10517398 Co Ltd              |

    # Check the Organisation details in CRM
    And   the CRM Organisation table contains the following values
    | UKPRN    | UPIN     | Name            | Status          | CompanyNumber | CharityNumber |
  # | 10017398 | 117398   | 10017398 Co Ltd | Active          | AA017398      | ?             |
    | 10217398 | 217398   | 10217398 Co Ltd | Deleted         | ?             | 27398         |
    | 10417398 | 417398   | 10417398 Co Ltd | Inactive        | ?             | ?             |
    | 10517398 | 517398   | 10517398 Co Ltd | In Liquidation  | AA517398      | 57398         |
	
	# Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20191220
Scenario: A399 Create a new 1718 1619F (EFA) contract with two Allocs and Delivery Orgs. Approve. Amend to add another allocation. Approve. Check CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017399' 
	And   there are no notifications of type 'Caseload re-assigned'
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Clear down data from the CRM Organisation table
    And   there is no Organisation data for UKPRN '10017399'
    And   there is no Organisation data for UKPRN '10217399'
    And   there is no Organisation data for UKPRN '10317399'
    And   there is no Organisation data for UKPRN '10417399'
    And   there is no Organisation data for UKPRN '10517399'

    # Add data to dbo.Organisations inc Dissolved 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status         | UKRLPCalledOk | CompanyNumber | CharityNumber |
    | 10017399 | 117399 | 10017399 Co Ltd | 0              | Active         | Yes           | AA017399      | ?             |
    | 10217399 | 217399 | 10217399 Co Ltd | 0              | Deleted        | Yes           | ?             | 27399         |
    | 10317399 | 317399 | 10317399 Co Ltd | 0              | Dissolved      | Yes           | AA317399      | 37399         |
    | 10517399 | 517399 | 10517399 Co Ltd | 0              | In Liquidation | Yes           | AA517399      | ?             |

    # Add data to CRM Organisations table
    And   the following Organisations exist in the CRM Organisations table
    | UKPRN    | UPIN   | Name             | CompanyNumber | CharityNumber |
    | 10017399 | 117399 | 10017399 Co Ltd  | AA017399      | ?             |

    # Associate an Advisor with the main provider
    And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017399'

    # Change the date
    And   the override date is '01/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017399 | 10017399 Co Ltd      | ESFA-399             | 1619F-399      | 1                     | 01/08/2017        | 31/07/2018      | 284007.00     |                                | Contract for Services | 1718   | New          | ORG0017399 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription          | CRMIntent    | DeliveryOrg |
    | 10017399 | 1619F-399      | 16LR-3991     | 1619LR            | 1619LR1718              | AY                      | 01/08/2017          | 31/07/2018        | 51196.00        |                         |            | THE LATYMER SCHOOL (113025)    | New          | 10217399    |
    | 10017399 | 1619F-399      | NMF-3991      | NMF               | NMF1718                 | AY                      | 01/08/2017          | 31/07/2018        | 39555.00        |                         |            | THE LATYMER SCHOOL (113025)    | New          | 10217399    |
    | 10017399 | 1619F-399      | SSF-3991      | SSF               | SSF1718                 | AY                      | 01/08/2017          | 31/07/2018        | 54472.00        |                         |            | THE LATYMER SCHOOL (113025)    | New          | 10217399    |
    #
    | 10017399 | 1619F-399      | 16LR-3992     | 1619LR            | 1619LR1718              | AY                      | 01/08/2017          | 31/07/2018        | 43890.00        |                         |            | BIRTENSHAW FE COLLEGE (122211) | New          | 10317399    |
    | 10017399 | 1619F-399      | NMF-3992      | NMF               | NMF1718                 | AY                      | 01/08/2017          | 31/07/2018        | 26561.00        |                         |            | BIRTENSHAW FE COLLEGE (122211) | New          | 10317399    |
    | 10017399 | 1619F-399      | SSF-3992      | SSF               | SSF1718                 | AY                      | 01/08/2017          | 31/07/2018        | 68333.00        |                         |            | BIRTENSHAW FE COLLEGE (122211) | New          | 10317399    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017399 | 1619F-399      | 16LR-3991     | 19              | 0                     | 25985.00  | 2836.00  | 2560.00  | 3416.00  | 531.00   | 3428.00  | 2521.00  | 2940.00  | 957.00   | 2376.00  | 2228.00  | 293.00   | 1899.00  | 16-19 Bursary Funds                                             | New          | 10217399    |
    | 10017399 | 1619F-399      | 16LR-3991     | 20              | 0                     | 25211.00  | 2970.00  | 2214.00  | 3358.00  | 3068.00  | 2608.00  | 2192.00  | 273.00   | 493.00   | 2333.00  | 2037.00  | 897.00   | 2768.00  | 16-19 Total Programme Funding                                   | New          | 10217399    |
    | 10017399 | 1619F-399      | NMF-3991      | 31              | 0                     | 17836.00  | 364.00   | 2681.00  | 1805.00  | 781.00   | 701.00   | 907.00   | 2936.00  | 3486.00  | 1125.00  | 856.00   | 357.00   | 1837.00  | Cadets Vocational Programme                                     | New          | 10217399    |
    | 10017399 | 1619F-399      | NMF-3991      | 32              | 0                     | 21719.00  | 1843.00  | 1208.00  | 112.00   | 1065.00  | 2200.00  | 3233.00  | 471.00   | 115.00   | 1894.00  | 3449.00  | 2860.00  | 3269.00  | Closing Schools                                                 | New          | 10217399    |
    | 10017399 | 1619F-399      | SSF-3991      | 14              | 0                     | 28130.00  | 3439.00  | 3181.00  | 735.00   | 2700.00  | 2517.00  | 2352.00  | 129.00   | 3619.00  | 3382.00  | 918.00   | 1873.00  | 3285.00  | SSF Formula Protection Funding                                  | New          | 10217399    |
    | 10017399 | 1619F-399      | SSF-3991      | 15              | 0                     | 26342.00  | 1718.00  | 3731.00  | 894.00   | 3270.00  | 441.00   | 1350.00  | 1693.00  | 2331.00  | 3512.00  | 3404.00  | 3367.00  | 631.00   | SSF High Needs Element 2                                        | New          | 10217399    |
    #
    | 10017399 | 1619F-399      | 16LR-3992     | 19              | 0                     | 23168.00  | 2024.00  | 2194.00  | 1121.00  | 1167.00  | 2917.00  | 101.00   | 2865.00  | 3064.00  | 2674.00  | 217.00   | 1582.00  | 3242.00  | 16-19 Bursary Funds                                             | New          | 10317399    |
    | 10017399 | 1619F-399      | 16LR-3992     | 33              | 0                     | 20722.00  | 3673.00  | 275.00   | 1494.00  | 1400.00  | 1863.00  | 626.00   | 1805.00  | 1002.00  | 2377.00  | 2056.00  | 628.00   | 3523.00  | 19+ Continuing Learners Programme Funding                       | New          | 10317399    |
    | 10017399 | 1619F-399      | NMF-3992      | 51              | 0                     | 26561.00  | 1554.00  | 3185.00  | 3107.00  | 2538.00  | 2721.00  | 3739.00  | 1307.00  | 1882.00  | 1578.00  | 2623.00  | 712.00   | 1615.00  | Alternative Completions - AASE Sporting Excellence              | New          | 10317399    |
    | 10017399 | 1619F-399      | SSF-3992      | 2               | 0                     | 23866.00  | 3192.00  | 1892.00  | 744.00   | 3368.00  | 1429.00  | 1247.00  | 2902.00  | 856.00   | 1704.00  | 923.00   | 3300.00  | 2309.00  | SSF Total Programme Funding                                     | New          | 10317399    |
    | 10017399 | 1619F-399      | SSF-3992      | 13              | 0                     | 22439.00  | 1435.00  | 1491.00  | 3235.00  | 2218.00  | 3497.00  | 1964.00  | 1272.00  | 3264.00  | 1008.00  | 1010.00  | 711.00   | 1334.00  | SSF Bursary Funds                                               | New          | 10317399    |
    | 10017399 | 1619F-399      | SSF-3992      | 14              | 0                     | 22028.00  | 59.00    | 2797.00  | 3162.00  | 1081.00  | 2651.00  | 1548.00  | 3053.00  | 2795.00  | 1669.00  | 338.00   | 1569.00  | 1306.00  | SSF Formula Protection Funding                                  | New          | 10317399    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Cleardown Sharepoint
    And   there are no files prefixed '10017399_1619F-399' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1718 25042018135026 v3_A399_0' in the Sharepoint 'Input' folder
    And   there are no files prefixed '1619FUND AY 1718 25042018135026 v3_A399_0' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '1619FUND AY 1718 25042018135026 v3_A399_0' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 25042018135026 v3_A399_0' in the Sharepoint 'Reports' folder

    # Bulk import to Update Draft, adding delivery Orgs to the contract
	And   spreadsheet '1619FUND AY 1718 25042018135026 v3_A399_0.xlsx' exists in the Datafiles folder and UKPRN '10017399' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Publish the contract
    And   the latest version of contract '1619F-399' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-399' and actual ContractNumber '1619F-399'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017399 | 1619F-399          | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017399 | 1619F-399          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017399 | ESFA-399           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM has not changed post-approval
    And   there are '144' deliverable period rows in CRM linked to the latest version of contract '1619F-399'

    # Change the date
    Given the override date is '05/07/2017'

    # Cleardown Sharepoint
    And   there are no files prefixed '10017399_1619F-399' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1718 19042018132801 v3_A399_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed '1619FUND AY 1718 19042018132801 v3_A399_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '1619FUND AY 1718 19042018132801 v3_A399_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 19042018132801 v3_A399_1' in the Sharepoint 'Reports' folder

    # Bulk import to Amend contract by adding a 'new' alloc 3 for delivery Org 10517399
    And   spreadsheet '1619FUND AY 1718 19042018132801 v3_A399_1.xlsx' exists in the Datafiles folder and UKPRN '10017399' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Change the date
    Given the override date is '09/07/2017'

    # Publish the contract
    And   the latest version of contract '1619F-399' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-399' and actual ContractNumber '1619F-399'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017399 | 1619F-399          | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017399 | 1619F-399          | 1                     | 1                        | Replaced         | Approved                  | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017399 | 1619F-399          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017399 | ESFA-399           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM has not changed post-approval
    And   there are '156' deliverable period rows in CRM linked to the latest version of contract '1619F-399'

    # Retrieve the master contract, contract and allocation numbers from CRM for the new allocation and delivery org
   #And   I retrieve the latest contract details from CRM for provider '10017390' for FundingType '1619FUND' and period '1718'
    And   I retrieve the latest EFA contract details from CRM for provider '10017399' for FundingType '1619FUND' and period '1718' and Delivery Organisation '10517399'

    # Check the DeliveryOrg data on the allocations 
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | DeliveryOrganisationUKPRN | AllocationRef    | AllocationStartDate | AllocationEndDate | DeliveryOrganisationProvider |
    | 10017399 | 1619F-399          | 2                     | 10217399                  | 16LR-3991        | 01/08/2017          | 31/07/2018        | 10217399 Co Ltd              |
    | 10017399 | 1619F-399          | 2                     | 10217399                  | NMF-3991         | 01/08/2017          | 31/07/2018        | 10217399 Co Ltd              |
    | 10017399 | 1619F-399          | 2                     | 10217399                  | SSF-3991         | 01/08/2017          | 31/07/2018        | 10217399 Co Ltd              |
    | 10017399 | 1619F-399          | 2                     | 10317399                  | 16LR-3992        | 01/08/2017          | 31/07/2018        | 10317399 Co Ltd              |
    | 10017399 | 1619F-399          | 2                     | 10317399                  | NMF-3992         | 01/08/2017          | 31/07/2018        | 10317399 Co Ltd              |
    | 10017399 | 1619F-399          | 2                     | 10317399                  | SSF-3992         | 01/08/2017          | 31/07/2018        | 10317399 Co Ltd              |
    | 10017399 | 1619F-399          | 2                     | 10517399                  | [AllocRef_16LR]  | 01/08/2017          | 31/07/2018        | 10517399 Co Ltd              |
   
    # Check the Organisation details in CRM
    And   the CRM Organisation table contains the following values
    | UKPRN    | UPIN   | Name            | Status         | CompanyNumber | CharityNumber |
  # | 10017399 | 117399 | 10017399 Co Ltd | Active         | AA017399      | ?             |
    | 10217399 | 217399 | 10217399 Co Ltd | Deleted        | ?             | 27399         |
    | 10317399 | 317399 | 10317399 Co Ltd | Dissolved      | AA317399      | 37399         |
    | 10517399 | 517399 | 10517399 Co Ltd | In Liquidation | AA517399      | ?             |

	# Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
Scenario: A448 Bulk load a new 1718 1619F (EFA) contract with two valid active delivery Orgs and one not known to PIMS. Fail: CABR027
    Given there is no Contract, Task or Workflow data for UKPRN '10017448'
    And   there is no Organisation data for UKPRN '10017448'

    # Add data to dbo.Organisations (One contracting Org and two delivery Orgs)
    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber |
    | 10017448 | 117448 | 10017448 Co Ltd | 0              | Active | Yes           | AA117448      | 117448        |
    | 10217448 | 217448 | 10217448 Co Ltd | 0              | Active | Yes           | AA217448      | ?             |
    | 10417448 | 417448 | 10417448 Co Ltd | 0              | Active | Yes           | ?             | 417448        |

    # Associate an Advisor with the main provider
   #And   caseload advisor 'FCS2 Test' is assigned to provider '10017448 Co Ltd' with UKPRN '10017448' and OrgId 'ORG0000000' and has 'FCS1 Test' as a manager

    # Cleardown prior to bulk import
    Given there are no files prefixed '10017448_1619F' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1718 24042018151809 v3_A448' in the Sharepoint 'Input' folder
    And   there are no files prefixed '1619FUND AY 1718 24042018151809 v3_A448' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '1619FUND AY 1718 24042018151809 v3_A448' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 24042018151809 v3_A448' in the Sharepoint 'Reports' folder

    # Change the date
    And   the override date is '15/07/2017'

    # Bulk import to create a new contract. Two pukka delivery Orgs and one (78900203) not known to PIMS
    And   spreadsheet '1619FUND AY 1718 24042018151809 v3_A448.xlsx' exists in the Datafiles folder and UKPRN '10017448' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # CABR027
    And   '[Contract Allocation] An invalid UKPRN has been specified for the Delivery Organisation' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   '[Contract Allocation] An invalid UKPRN has been specified for the Delivery Organisation' is displayed in field 'X5' on the 'Contract Allocation' tab of the result report
    And   '[Contract Allocation] An invalid UKPRN has been specified for the Delivery Organisation' is displayed in field 'O244' on the 'Deliverable' tab of the result report

	# Check we have not created a contract in CRM for the contracting Org
	And   no contracts exist in CRM for UKPRN '10017448'

    # Tidy up
    And   the override date is reset 

@AcceptanceTest @Withdrawn20230123
Scenario: A449 Create a new 1718 1619F (EFA) contract with a valid active delivery Org. Update draft to change the delivery Org to one not known to PIMS. Fail: CABR027
    Given there is no Contract, Task or Workflow data for UKPRN '10017449'
    And   there is no Organisation data for UKPRN '10017449'

    # Add data to dbo.Organisations
    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber |
    | 10017449 | 117449 | 10017449 Co Ltd | 0              | Active | Yes           | AA117449      | 117449        |
    | 10217449 | 217449 | 10217449 Co Ltd | 0              | Active | Yes           | ?             | 217449        |
    | 10317449 | 317449 | 10317449 Co Ltd | 0              | Active | Yes           | AA317449      | ?             |

    # Associate an Advisor with the main provider
   #And   caseload advisor 'FCS2 Test' is assigned to provider '10017449 Co Ltd' with UKPRN '10017449' and OrgId 'ORG0000000' and has 'FCS1 Test' as a manager

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      | OrgStatus |
    | 10017449 | 10017449 Co Ltd      | ESFA-449             | 1619F-449      | 1                     | 01/08/2017        | 31/07/2018      | 24308.00      |                                | Contract for Services | 1718   | New          | ORG0017449 | Active    |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName   | UoPCode    | AllocationDescription        | CRMIntent    | DeliveryOrg |
    | 10017449 | 1619F-449      | 16LR-449      | 1619LR            | 1619LR1718              | AY                      | 01/08/2017          | 31/07/2018        | 24308.00        |           |            | HALESOWEN COLLEGE (108457)   | New          | 10217449    |
 
    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription   | CRMIntent    | DeliveryOrg |
    | 10017449 | 1619F-449      | 16LR-449      | 20              | 0                     | 24308.00  | 1044.96  | 3816.74  | 4346.38  | 1085.00  | 3698.99  | -670.00  | 1530.57  | -2089.49 | 3238.21  | 1415.02  | 2917.45  | 3974.05  | 16-19 Bursary Funds      | New          | 10217449    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Cleardown prior to bulk import
    Given there are no files prefixed '10017449_1619F' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1718 24042018151823 v3_A449' in the Sharepoint 'Input' folder
    And   there are no files prefixed '1619FUND AY 1718 24042018151823 v3_A449' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '1619FUND AY 1718 24042018151823 v3_A449' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 24042018151823 v3_A449' in the Sharepoint 'Reports' folder

    # Change the date
    And   the override date is '15/07/2017'

    # Bulk import (update draft) to give contract a pukka delivery Org
    And   spreadsheet '1619FUND AY 1718 24042018151823 v3_A449_1.xlsx' exists in the Datafiles folder and UKPRN '10017449' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

	# Change the date
    Given the override date is '18/07/2017'

    # Bulk import (update draft) to give contract a delivery Org not known to PIMS
    And   spreadsheet '1619FUND AY 1718 24042018152106 v3_A449_2.xlsx' exists in the Datafiles folder and UKPRN '10017449' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # CABR027
    And   '[Contract Allocation] An invalid UKPRN has been specified for the Delivery Organisation' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   '[Contract Allocation] An invalid UKPRN has been specified for the Delivery Organisation' is displayed in field 'X2' on the 'Contract Allocation' tab of the result report
    And   '[Contract Allocation] An invalid UKPRN has been specified for the Delivery Organisation' is displayed in field 'O2' on the 'Deliverable' tab of the result report

    # Tidy up
    And   the override date is reset 
	  
