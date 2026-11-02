Feature: DuplicateContracts 28099

@AcceptanceTest @Withdrawn20201209
@Long2Run @Long2Run123
Scenario: A110 Create three identical 1920 AEBP contracts and two identical 1920 NCS contracts in CRM. Check Dashboard errors
    Given there are no allocations marked as Under Termination for UKPRN '10017110' 
    And   there are no terminated or closed allocations for UKPRN '10017110' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017110' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Remove all data from the Operations.DuplicateContract table (J082)
    And   there is no data in the Operations.DuplicateContract table
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017110' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBR-110      |
    | AETL-110      |
    | NCSC-110      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | AEB-19TRLS1920 |
    | AEB-19TRN1920  |
	| NCS-C1920      |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017110' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017110 Co Ltd' with UKPRN '10017110' and OrgId 'ORG0017110' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017110' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017110 | 117110 | 10017110 Co Ltd | 0              | Active                | Yes           | AA017110      | ?             | 75 Bell Street         | Reigate                | Surrey                 | ?                      | ?                      | ?                      | RH2 7AN   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017110 |




	# Test 1/5

    # Change the date
    Given the override date is '01/07/2019'

    # Create an AEBP contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017110 | 10017110 Co Ltd      | ESFA-110             | AEBP-110       | 1                     | 01/08/2019        | 31/07/2020      | 35551.00      |                                    | Contract for Services                      | 1920   | New          | ORG0017110 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017110 | AEBP-110       | AEBR-110      | AEB-19TRN         | AEB-19TRN1920           | AY                      | 01/08/2019          | 31/07/2020        | 16744.00        |                                         |            |                                                             | New          |             |
    | 10017110 | AEBP-110       | AETL-110      | AEB-19TRLS        | AEB-19TRLS1920          | AY                      | 01/08/2019          | 31/07/2020        | 18807.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017110 | AEBP-110       | AEBR-110      | 1               | 0                     | 16744.00  | 1065.00  | 2463.00  | 986.00   | 2701.00  | 274.00   | 2117.00  | 289.00   | 1089.00  | 654.00   | 1959.00  | 763.00   | 2384.00  | 19-24 Traineeships Total Funding                                | New          |             |
    | 10017110 | AEBP-110       | AETL-110      | 1               | 0                     | 18807.00  | 108.00   | 874.00   | 1294.00  | 1018.00  | 1848.00  | 3058.00  | 410.00   | 954.00   | 1057.00  | 1729.00  | 3414.00  | 3043.00  | Adult Education Budget - 19-24 Traineeships Learner Support     | New          |             |

    And   the contract exists in CRM
    # Contract is now at 'Awaiting Documentation'

	# Give the replicated database time to catch up (Only checking for duplicates for 10017110)
	Then  there are no duplicate contracts in the replicated CRM database

    # Are there duplicate contracts in CRM? (Operations.DuplicateContract) J081
	When  the Duplicate Contract monitoring job is run

	# System should not detect any duplicate contracts (Only checking for duplicates for %-110)
	Then  there are no duplicate contracts in CRM   




    # Test 2/5

	# Remove the contract from the PageObject to allow the contract below to be created
   #Given reset contract to test
    Given the current contract has been removed from memory

	# Create a copy of the above AEBP contract (£1 added to each allocation so reader can distinguish between the contracts in CRM)
    Given the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017110 | 10017110 Co Ltd      | ESFA-110             | AEBP-110       | 1                     | 01/08/2019        | 31/07/2020      | 35553.00      |                                    | Contract for Services                      | 1920   | New          | ORG0017110 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017110 | AEBP-110       | AEBR-110      | AEB-19TRN         | AEB-19TRN1920           | AY                      | 01/08/2019          | 31/07/2020        | 16745.00        |                                         |            |                                                             | New          |             |
    | 10017110 | AEBP-110       | AETL-110      | AEB-19TRLS        | AEB-19TRLS1920          | AY                      | 01/08/2019          | 31/07/2020        | 18808.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017110 | AEBP-110       | AEBR-110      | 1               | 0                     | 16745.00  | 1066.00  | 2463.00  | 986.00   | 2701.00  | 274.00   | 2117.00  | 289.00   | 1089.00  | 654.00   | 1959.00  | 763.00   | 2384.00  | 19-24 Traineeships Total Funding                                | New          |             |
    | 10017110 | AEBP-110       | AETL-110      | 1               | 0                     | 18808.00  | 109.00   | 874.00   | 1294.00  | 1018.00  | 1848.00  | 3058.00  | 410.00   | 954.00   | 1057.00  | 1729.00  | 3414.00  | 3043.00  | Adult Education Budget - 19-24 Traineeships Learner Support     | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

	# Wait for the replicated database to catch up and find the duplicate
	Then  there is '1' duplicate contract in the replicated CRM database as follows
    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | AEBP-110       | 1                     | 0                  |

    # Are there duplicate contracts in CRM? (Operations.DuplicateContract) J081
	When  the Duplicate Contract monitoring job is run 

	# System should be aware of the following duplicate (2x AEBP-110)
	Then  there is '1' duplicate contract in CRM as follows
    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | AEBP-110       | 1                     | 0                  | 




    # Test 3/5
	
	# Remove the contract from the PageObject to allow the contract below to be created
   #Given reset contract to test
    Given the current contract has been removed from memory
	
	# Create a third copy of the above AEBP contract 
    Given the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017110 | 10017110 Co Ltd      | ESFA-110             | AEBP-110       | 1                     | 01/08/2019        | 31/07/2020      | 35551.00      |                                    | Contract for Services                      | 1920   | New          | ORG0017110 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017110 | AEBP-110       | AEBR-110      | AEB-19TRN         | AEB-19TRN1920           | AY                      | 01/08/2019          | 31/07/2020        | 16744.00        |                                         |            |                                                             | New          |             |
    | 10017110 | AEBP-110       | AETL-110      | AEB-19TRLS        | AEB-19TRLS1920          | AY                      | 01/08/2019          | 31/07/2020        | 18807.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017110 | AEBP-110       | AEBR-110      | 1               | 0                     | 16744.00  | 1065.00  | 2463.00  | 986.00   | 2701.00  | 274.00   | 2117.00  | 289.00   | 1089.00  | 654.00   | 1959.00  | 763.00   | 2384.00  | 19-24 Traineeships Total Funding                                | New          |             |
    | 10017110 | AEBP-110       | AETL-110      | 1               | 0                     | 18807.00  | 108.00   | 874.00   | 1294.00  | 1018.00  | 1848.00  | 3058.00  | 410.00   | 954.00   | 1057.00  | 1729.00  | 3414.00  | 3043.00  | Adult Education Budget - 19-24 Traineeships Learner Support     | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

	# Wait for the replicated database to catch up and find the duplicate
	Then  there is '1' duplicate contract in the replicated CRM database as follows
    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | AEBP-110       | 1                     | 0                  |

    # Are there duplicate contracts in CRM? (Operations.DuplicateContract) J081
	When  the Duplicate Contract monitoring job is run 

	# System should be aware of the following duplicate (3x AEBP-110)
	Then  there is '1' duplicate contract in CRM as follows
    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | AEBP-110       | 1                     | 0                  | 




    # Test 4/5
	
	# Change the date
    Given the override date is '01/08/2019'

    # Create an NCS contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017110 | 10017110 Co Ltd      | ESFA-110             | NCS-110        | 1                     | 01/04/2019        | 31/03/2020      | 66775.00      |                                    | Contract for Services                      | 1920   | New          | ORG0017110 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017110 | NCS-110        | NCSC-110      | NCS-C             | NCS-C1920               | FY                      | 01/04/2019          | 31/03/2020        | 66775.00        | North West                              | 0000000105 |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017110 | NCS-110        | NCSC-110      | 1               | 0                     | 66775.00  | 7159.00  | 3611.00  | 6102.00  | 7768.00  | 7224.00  | 3419.00  | 3730.00  | 5747.00  | 6117.00  | 4022.00  | 6605.00  | 5271.00  | Total In The Community Funding                                  | New          |             |
    | 10017110 | NCS-110        | NCSC-110      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             |
    | 10017110 | NCS-110        | NCSC-110      | 2               | 1                     | 28464.00  | 2504.00  | 1501.00  | 1793.00  | 3636.00  | 2791.00  | 2608.00  | 2173.00  | 3478.00  | 3265.00  | 1185.00  | 2741.00  | 789.00   | Customer Satisfaction                                           | New          |             |
    | 10017110 | NCS-110        | NCSC-110      | 3               | 1                     | 38311.00  | 4655.00  | 2110.00  | 4309.00  | 4132.00  | 4433.00  | 811.00   | 1557.00  | 2269.00  | 2852.00  | 2837.00  | 3864.00  | 4482.00  | Career Management and Jobs and Learning                         | New          |             |
    | 10017110 | NCS-110        | NCSC-110      | 4               | 3                     | 16687.00  | 1050.00  | 773.00   | 1603.00  | 1831.00  | 2883.00  | 709.00   | 813.00   | 1485.00  | 2187.00  | 1816.00  | 210.00   | 1327.00  | Career Management                                               | New          |             |
    | 10017110 | NCS-110        | NCSC-110      | 5               | 3                     | 21624.00  | 3605.00  | 1337.00  | 2706.00  | 2301.00  | 1550.00  | 102.00   | 744.00   | 784.00   | 665.00   | 1021.00  | 3654.00  | 3155.00  | Jobs and Learning                                               | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | 
    | 10017110 | NCS-110        | NCSC-110      | 6               | 0        | 845     | 92       | 76       | 100      | 27       | 88       | 87       | 65       | 41       | 89       | 37       | 59       | 84       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

	# Wait for the replicated database to catch up and find the duplicate
	Then  there is '1' duplicate contract in the replicated CRM database as follows
    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | AEBP-110       | 1                     | 0                  |

    # Are there duplicate contracts in CRM? (Operations.DuplicateContract) J081
	When  the Duplicate Contract monitoring job is run 

	# System should be aware of the following duplicate (3x AEBP-110)
	Then  there is '1' duplicate contract in CRM as follows
    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | AEBP-110       | 1                     | 0                  | 




    # Test 5/5
	
	# Remove the contract from the PageObject to allow the contract below to be created
   #Given reset contract to test
    Given the current contract has been removed from memory
	
	# Create an identical copy of the above NCS contract 
    Given the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017110 | 10017110 Co Ltd      | ESFA-110             | NCS-110        | 1                     | 01/04/2019        | 31/03/2020      | 66775.00      |                                    | Contract for Services                      | 1920   | New          | ORG0017110 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017110 | NCS-110        | NCSC-110      | NCS-C             | NCS-C1920               | FY                      | 01/04/2019          | 31/03/2020        | 66775.00        | North West                              | 0000000105 |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017110 | NCS-110        | NCSC-110      | 1               | 0                     | 66775.00  | 7159.00  | 3611.00  | 6102.00  | 7768.00  | 7224.00  | 3419.00  | 3730.00  | 5747.00  | 6117.00  | 4022.00  | 6605.00  | 5271.00  | Total In The Community Funding                                  | New          |             |
    | 10017110 | NCS-110        | NCSC-110      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             |
    | 10017110 | NCS-110        | NCSC-110      | 2               | 1                     | 28464.00  | 2504.00  | 1501.00  | 1793.00  | 3636.00  | 2791.00  | 2608.00  | 2173.00  | 3478.00  | 3265.00  | 1185.00  | 2741.00  | 789.00   | Customer Satisfaction                                           | New          |             |
    | 10017110 | NCS-110        | NCSC-110      | 3               | 1                     | 38311.00  | 4655.00  | 2110.00  | 4309.00  | 4132.00  | 4433.00  | 811.00   | 1557.00  | 2269.00  | 2852.00  | 2837.00  | 3864.00  | 4482.00  | Career Management and Jobs and Learning                         | New          |             |
    | 10017110 | NCS-110        | NCSC-110      | 4               | 3                     | 16687.00  | 1050.00  | 773.00   | 1603.00  | 1831.00  | 2883.00  | 709.00   | 813.00   | 1485.00  | 2187.00  | 1816.00  | 210.00   | 1327.00  | Career Management                                               | New          |             |
    | 10017110 | NCS-110        | NCSC-110      | 5               | 3                     | 21624.00  | 3605.00  | 1337.00  | 2706.00  | 2301.00  | 1550.00  | 102.00   | 744.00   | 784.00   | 665.00   | 1021.00  | 3654.00  | 3155.00  | Jobs and Learning                                               | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | 
    | 10017110 | NCS-110        | NCSC-110      | 6               | 0        | 845     | 92       | 76       | 100      | 27       | 88       | 87       | 65       | 41       | 89       | 37       | 59       | 84       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

	# Wait for the replicated database to catch up and find the duplicates
	Then  there are '2' duplicate contracts in the replicated CRM database as follows
    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | AEBP-110       | 1                     | 0                  |
	| NCS-110        | 1                     | 0                  |

    # Are there duplicate contracts in CRM? (Operations.DuplicateContract) J081
	When  the Duplicate Contract monitoring job is run 

	# System should be aware of the following two duplicates (3x AEBP-110 and 2x NCS-110)
	Then  there are '2' duplicate contracts in CRM as follows
    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | AEBP-110       | 1                     | 0                  |
	| NCS-110        | 1                     | 0                  |


	# Tidy Up
	Then  the override date is reset
	 
