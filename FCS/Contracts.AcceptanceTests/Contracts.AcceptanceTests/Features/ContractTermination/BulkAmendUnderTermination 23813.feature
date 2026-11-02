Feature: BulkAmendUnderTermination 23813

@AcceptanceTest @Withdrawn20240103 
Scenario: A324 Create and approve an ESF contract. Initiate termination. Approve initiation. Fail to complete termination: termination date in the future. Check Notification and CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017324' 
    And   there are no terminated or closed allocations for UKPRN '10017324' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017324' 
	And   there are no notifications of type 'Contract Termination Failed'
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ESF-324       |

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017324' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017324 Co Ltd' with UKPRN '10017324' and OrgId 'ORG0017324' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017324' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017324 | 117324 | 10017324 Co Ltd | 0              | Active                | Yes           | AA017324      | ?             | 4 Darehill             | Hower Earley           | ?                      | ?                      | Reading                | Buckinghamshire        | R96 4UT   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017324 |




    # Change the date
    Given the override date is '01/12/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017324 | 10017324 Co Ltd      | ESFA-324             | ESIF-324       | 1                     | 01/01/2019        | 31/12/2020      | 69447.00      | ESF Contract                       | Contract for Services                      | 1420   | New          | ORG0017324 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                             | AgreementNumber | ActivityDescription                | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017324 | ESIF-324       | ESF-324       | ESF 201420        | ESF1420                 | ESF                     | 01/01/2019          | 31/12/2020        | 69447.00        |                                         |            | ESF Allocation                                              | New          | Cornwall and the Isles of Scilly LEP        | E37005       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017324    | 1.1 Access to employment for jobseekers/ the inactive | 111\SD\7324     | Numeracy in the workplace          | SSU                   | Transition     | 1.05                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017324 | ESIF-324       | ESF-324       | 13              | 0                     | 37830.00  | 2548.00  | 2080.00  | 2210.00  | 1820.00  | 598.00   | 1924.00  | 936.00   | 858.00   | 2392.00  | 1872.00  | 442.00   | 2366.00  | 1950.00  | 2574.00  | 676.00   | 2262.00  | 2262.00  | 1664.00  | 2376.00  | 1813.00  | 1536.00  | 2366.00  | 3577.00  | 928.00   | SD06 Specification Defined Deliverable (with Description)       | New          |             |
    | 10017324 | ESIF-324       | ESF-324       | 31              | 0                     | 31617.00  | 945.00   | 567.00   | 1755.00  | 2457.00  | 2106.00  | 1350.00  | 513.00   | 621.00   | 1593.00  | 486.00   | 702.00   | 1350.00  | 1188.00  | 378.00   | 999.00   | 2214.00  | 2214.00  | 1053.00  | 1817.00  | 3408.00  | 601.00   | 1620.00  | 300.00   | 1541.00  | SU13 Sustained Education 6 Months                               | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | DeliverableCode | AllocationRef | UnitCost | Total   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | 
    | 10017324 | ESIF-324       | 13              | ESF-324       | 26       | 1455    | 98       | 80       | 85       | 70       | 23       | 74       | 36       | 33       | 92       | 72       | 17       | 91       | 75       | 99       | 26       | 87       | 87       | 64       | 64       | 21       | 36       | 58       | 16       | 51       |
    | 10017324 | ESIF-324       | 31              | ESF-324       | 27       | 1171    | 35       | 21       | 65       | 91       | 78       | 50       | 19       | 23       | 59       | 18       | 26       | 50       | 44       | 14       | 37       | 82       | 82       | 39       | 54       | 76       | 34       | 68       | 32       | 74       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'ESIF-324' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-324' and actual ContractNumber 'ESIF-324'

    # Check that the contract is now approved
    Then  the latest version of contract 'ESIF-324' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017324 | ESIF-324           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2019        | 31/12/2020      | ?             |
    | 10017324 | ESFA-324           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2019        | 31/12/2020      | ?             |

#    # Check the deliverable count in CRM includes all the monitoring deliverables
#   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
#    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'ESIF-324'



 
    # Initiate a TERMINATION

    # Change the date
    Given the override date is '16/03/2019'

    # Request termination of the contract via the CRM UI
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'ESIF-324' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 18/04/2019               | 23/12/2019              | No                          | Notice from Provider    | Director in prison      |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ESF-324          | 28/03/2019                  | 12/04/2019                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'ESIF-324' for UKPRN '10017324'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017324 - 10017324 Co Ltd     | ESIF-324       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017324 | ESIF-324       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/01/2019        | 31/12/2020      | ?             |
    | 10017324 | ESFA-324       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2019        | 31/12/2020      | ?             |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '19/03/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'ESIF-324' for provider '10017324' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017324 | ESIF-324       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/01/2019        | 31/12/2020      | ?             |
    | 10017324 | ESFA-324       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2019        | 31/12/2020      | ?             |





    # Complete the Termination. Check Workflow History and Notification

    # Change the current date to a date prior to the contract termination date (23/12/2019)
	# This currently has no effect on CRM which uses the actual current date - but this may change ...?
    Given the override date is '01/04/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
	
    # Attempt to complete the termination. This should fail
#   When  CRM user 'FCS8 Test' completes the termination request for Contract 'ESIF-324' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' completes the termination request for Contract 'ESIF-324' Version '1' SubVersion '0' via SDK

    # Check that the CONTRACT version, status and dates in CRM have not changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017324 | ESIF-324       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/01/2019        | 31/12/2020      | ?             |
    | 10017324 | ESFA-324       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2019        | 31/12/2020      | ?             |

    # Check the WORKFLOW HISTORY
    And   the workflow history on contract 'ESIF-324' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
    #| Initiate Contract Termination                  | FCS8 Test           | Director in prison               |

    # Check that NOTIFICATION is no longer being generated (25102)
   #And   there is '1' notification of type 'Contract Termination Failed' owned by user 'CRM Integration' which matches the following
    And   there are '0' notifications of type 'Contract Termination Failed' owned by user 'CRM Integration' which match the following
    | Status | NotificationName                        | NotificationText                                                                                                                  |
    | New    | Contract Termination Failed - ESIF-324  | Contract ESIF-324 v1 for provider 10017324 (10017324 Co Ltd) cannot be terminated - Contract Termination Date must be in the past |
	


    # Tidy up
    And   the override date is reset
      
@AcceptanceTest @Withdrawn20231002 
Scenario: A325 Create and approve an 1819 Mainstream contract with 16-18TRN(PoA) and AEBTO-CL(PoP) allocations. Initiate termination. Approve initiation. Bulk amend (Variation). Fail to complete termination of v1: draft v2 exists. Check Notification and CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017325' 
    And   there are no terminated or closed allocations for UKPRN '10017325' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017325' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
	And   there are no notifications of type 'Contract Termination Failed'
	And   there are no notifications of type 'Approval Received'
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16TR-325      |
    | AECL-325      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017325' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017325 Co Ltd' with UKPRN '10017325' and OrgId 'ORG0017325' and has 'FCS1 Test' as a manager 
    And   UPIN '117325' is associated with UKPRN '10017325' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017325 | 117325 | 10017325 Co Ltd | 0              | Active | Yes           | AA017325      | ?             | 

    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017325 | 10017325 Co Ltd      | ESFA-325             | MAIN-325       | 1                     | 01/08/2018        | 31/07/2019      | 80079.00      |                                | Contract for Services | 1819   | New          | ORG0017325 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017325 | MAIN-325       | 16TR-325      | 16-18TRN          | 16-18TRN1819            | AY                      | 01/08/2018          | 31/07/2019        | 54209.00        |                                         |            |                                                             | New          |             |
    | 10017325 | MAIN-325       | AECL-325      | AEBTO-CL          | AEBTO-CL1819            | AY                      | 01/08/2018          | 31/07/2019        | 25870.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017325 | MAIN-325       | 16TR-325      | 1               | 0                     | 54209.00  | 4553.00  | 5136.00  | 1420.00  | 2448.00  | 6767.00  | 5897.00  | 4805.00  | 3396.00  | 6638.00  | 4315.00  | 3130.00  | 5704.00  | 16-18 Traineeships Funding                                      | New          |             |
    | 10017325 | MAIN-325       | 16TR-325      | 2               | 1                     | 27442.00  | 3470.00  | 2813.00  | 100.00   | 836.00   | 3312.00  | 3287.00  | 2378.00  | 1404.00  | 3341.00  | 1231.00  | 2126.00  | 3144.00  | 16-18 Traineeships Programme Funding                            | New          |             |
    | 10017325 | MAIN-325       | 16TR-325      | 3               | 1                     | 26767.00  | 1083.00  | 2323.00  | 1320.00  | 1612.00  | 3455.00  | 2610.00  | 2427.00  | 1992.00  | 3297.00  | 3084.00  | 1004.00  | 2560.00  | 16-18 Traineeships Bursary Funding                              | New          |             |
    | 10017325 | MAIN-325       | AECL-325      | 1               | 0                     | 25870.00  | 1762.00  | 2182.00  | 1905.00  | 2735.00  | 2963.00  | 314.00   | 1841.00  | 1944.00  | 2616.00  | 3318.00  | 2948.00  | 1342.00  | Adult Education Budget - Community Learning                     | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-325' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-325' and actual ContractNumber 'MAIN-325'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-325' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017325 | MAIN-325           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017325 | ESFA-325           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'MAIN-325'



 
    # Initiate a TERMINATION

    # Change the date
    Given the override date is '12/10/2018'

    # Request termination of the contract via the CRM UI
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-325' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 16/10/2018               | 21/10/2018              | No                          | Minimum Standards       | Director in prison      |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | 16TR-325         | 17/10/2018                  | 19/10/2018                |
    | AECL-325         | 18/10/2018                  | 20/10/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'MAIN-325' for UKPRN '10017325'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017325 - 10017325 Co Ltd     | MAIN-325       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017325 | MAIN-325       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017325 | ESFA-325       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '19/10/2018'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'MAIN-325' for provider '10017325' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017325 | MAIN-325       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017325 | ESFA-325       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Amend the contract
    
    # Change the date
    Given the override date is '21/10/2018'

#    # Bulk amend contract (Variation) on v1 to create v2 but don't approve it
#    And   there are no files prefixed '10017325_MAIN-325' in the Sharepoint 'MAIN-1819-Input-Appendices' folder
#    And   there are no files prefixed 'MAIN AY 1819 16102018170000 v3_A325' in the Sharepoint 'Processed' folder
#    And   there are no files prefixed 'MAIN AY 1819 16102018170000 v3_A325' in the Sharepoint 'Reports' folder
#    And   spreadsheet 'MAIN AY 1819 16102018170000 v3_A325.xlsx' exists in the Datafiles folder and UKPRN '10017325' is present in cell 'A2' of the Contract tab
#    When  the file is copied to the Sharepoint 'Input' folder 
#    Then  a syntax report should exist in the Sharepoint Reports folder
#    And   a results report should exist in the Sharepoint Reports folder
#    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Issue a non-financial VARIATION amendment on v1 to create v2 but don't approve it
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'MAIN-325' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'MAIN-325' for a non-financial VARIATION contract amendment
	   	 
    # Contract status is now at 'Awaiting Documentation'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017325 | MAIN-325       | 2                     | 0                        | Draft          | Awaiting Documentation                   | True          | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017325 | MAIN-325       | 1                     | 0                        | Approved       | Under Termination                        | False         | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017325 | ESFA-325       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    
	

	# Complete Termination. Check Workflow History and Notification
	
	# Attempt to complete the termination against v1 of the contract. This should fail
#   When  CRM user 'FCS8 Test' completes the termination request for Contract 'MAIN-325' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' completes the termination request for Contract 'MAIN-325' Version '1' SubVersion '0' via SDK

	# Check that the CONTRACT version, status and dates in CRM have not changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017325 | MAIN-325       | 2                     | 0                        | Draft          | Awaiting Documentation                   | True          | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017325 | MAIN-325       | 1                     | 0                        | Approved       | Under Termination                        | False         | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017325 | ESFA-325       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the WORKFLOW HISTORY for v1
    And   the workflow history on contract 'MAIN-325' version '1' includes the following
    | Action                                         | CompletedBy         | Comment                          |
    | Termination Initiation Successful              | CRM Integration     | ?                                |
    | Approve Termination Initiation                 | FCS5 Test           | ?                                |
#    | Initiate Contract Termination                  | FCS8 Test           | Director in prison               |

    # Check that NOTIFICATION is no longer being generated (25102)
   #And   there is '1' notification of type 'Contract Termination Failed' owned by user 'CRM Integration' which match the following
    And   there are '0' notifications of type 'Contract Termination Failed' owned by user 'CRM Integration' which match the following
    | Status | NotificationName                        | NotificationText                                                                                              |
    | New    | Contract Termination Failed - MAIN-325  | Contract MAIN-325 v1 for provider 10017325 (10017325 Co Ltd) cannot be terminated - a draft amendment exists  |
	


    # Tidy up
	And   the override date is reset
	          
@AcceptanceTest @Complete 
@Long2Run @Long2Run123
Scenario: A326 Create and approve a 2018 NLAP contract. Initiate termination. Approve initiation. Non-financial amendment (Variation). Publish then withdraw. Bulk amend (Notification) Publish and auto-approve. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017326' 
    And   there are no terminated or closed allocations for UKPRN '10017326' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017326' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017326'

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ANLP-326      |
    | YNLP-326      |



    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017326' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017326 Co Ltd' with UKPRN '10017326' and OrgId 'ORG0017326' and has 'FCS1 Test' as a manager 
    And   UPIN '117326' is associated with UKPRN '10017326' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017326 | 117326 | 10017326 Co Ltd | 0              | Active | Yes           | AA017326      | ?             | 




    # Change the date
    Given the override date is '01/12/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017326 | 10017326 Co Ltd      | ESFA-326             | NLAP-326       | 1                     | 01/01/2018        | 31/03/2019      | 55888.00      |                                | Contract for Services | 2018   | New          | ORG0017326 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017326 | NLAP-326       | ANLP-326      | ANLAP             | 16-18NLAP2018           | NONLEVY                 | 01/01/2018          | 31/03/2019        | 26152.00        |                                         |            |                                                             | New          |             |
    | 10017326 | NLAP-326       | YNLP-326      | 16-18NLAP         | 16-18NLAP2018           | NONLEVY                 | 01/01/2018          | 31/03/2019        | 29736.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017326 | NLAP-326       | ANLP-326      | 1               | 0                     | 26152.00  | 1193.00  | 536.00   | 1525.00  | 2261.00  | 1035.00  | 1011.00  | 101.00   | 2829.00  | 1065.00  | 2656.00  | 3550.00  | 867.00   | 3249.00  | 788.00   | 3486.00  | Total Adult Non-Levy Apprenticeships Funding                    | New          |             |
    | 10017326 | NLAP-326       | YNLP-326      | 1               | 0                     | 29736.00  | 2289.00  | 431.00   | 3287.00  | 3104.00  | 2669.00  | 273.00   | 60.00    | 1681.00  | 3238.00  | 1286.00  | 1705.00  | 1429.00  | 2259.00  | 2486.00  | 3539.00  | Total 16-18 Non-Levy Apprenticeships Funding                    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NLAP-326' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-326' and actual ContractNumber 'NLAP-326'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-326' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017326 | NLAP-326           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017326 | ESFA-326           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '150' deliverable period rows in CRM linked to the latest version of contract 'NLAP-326'




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '04/11/2018'

    # Request termination of the contract via the CRM SDK
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'NLAP-326' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 07/12/2018               | 22/12/2018              | No                          | Provider Change         | Suspected fraud         |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ANLP-326         | 01/12/2018                  | 16/12/2018                |
    | YNLP-326         | 16/11/2018                  | 01/12/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'NLAP-326' for UKPRN '10017326'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017326 - 10017326 Co Ltd     | NLAP-326       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017326 | NLAP-326       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017326 | ESFA-326       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '07/11/2018'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'NLAP-326' for provider '10017326' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017326 | NLAP-326       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017326 | ESFA-326       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




	# Change the date
	Given the override date is '12/11/2018'

#    # Bulk amend contract (Variation) to create v2 but don't approve it
#    And   there are no files prefixed '10017326_NLAP-326' in the Sharepoint 'NLA-2018-Input-Appendices' folder
#    And   there are no files prefixed 'NLA NONLEVY 2018 16102018120959 v2_A326_1' in the Sharepoint 'Processed' folder
#    And   there are no files prefixed 'NLA NONLEVY 2018 16102018120959 v2_A326_1' in the Sharepoint 'Reports' folder
#    And   spreadsheet 'NLA NONLEVY 2018 16102018120959 v2_A326_1.xlsx' exists in the Datafiles folder and UKPRN '10017326' is present in cell 'A2' of the Contract tab
#    When  the file is copied to the Sharepoint 'Input' folder 
#    Then  a syntax report should exist in the Sharepoint Reports folder
#    And   a results report should exist in the Sharepoint Reports folder
#    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Issue a non-financial VARIATION amendment on v1 to create v2 but don't approve it
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'NLAP-326' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'NLAP-326' for a non-financial VARIATION contract amendment

    # Contract status is now at 'Awaiting Documentation'

    # Check the CONTRACT version, status and dates in CRM (just a wait really)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017326 | NLAP-326           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/01/2018        | 31/03/2019      | Variation     |
    | 10017326 | NLAP-326           | 1                     | 0                        | Approved         | Under Termination         | False         | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017326 | ESFA-326           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |



    # Change the date
    Given the override date is '13/11/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    When  the latest version of contract 'NLAP-326' is in a state of 'Published to Provider'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017326 | NLAP-326           | 2                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/01/2018        | 31/03/2019      | Variation     |
    | 10017326 | NLAP-326           | 1                     | 0                        | Approved         | Under Termination         | False         | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017326 | ESFA-326           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




	# Withdraw v2
	
	# Change the date
    Given the override date is '14/11/2018'

    # Withdraw the contract
    When  the next action performed on the latest version of contract 'NLAP-326' is 'Withdraw On Behalf Of Provider' with reason 'Test A326' by 'FCS1 Test'

	# Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017326 | NLAP-326           | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/01/2018        | 31/03/2019      | Variation     |
    | 10017326 | NLAP-326           | 1                     | 0                        | Approved         | Under Termination         | True          | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017326 | ESFA-326           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




	# Change the date
	Given the override date is '15/11/2018'

    # Bulk amend contract (Notification) to create v3
    And   there are no files prefixed '10017326_NLAP-326' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 16102018120959 v2_A326_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 16102018120959 v2_A326_2' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 16102018120959 v2_A326_2.xlsx' exists in the Datafiles folder and UKPRN '10017326' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Contract status is now at 'Awaiting Documentation'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017326 | NLAP-326           | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/01/2018        | 31/03/2019      | Notification  |
    | 10017326 | NLAP-326           | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/01/2018        | 31/03/2019      | Variation     |
    | 10017326 | NLAP-326           | 1                     | 0                        | Approved         | Under Termination         | False         | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017326 | ESFA-326           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Put a dummy file into a Sharepoint folder
    Given there are no files prefixed '10017326_NLAP-326' in the Sharepoint 'NLA-2018-Input-Terms And Conditions' folder
    And   a file with filename '10017326_NLAP-326_77.pdf' is created in 'NLA-2018-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When the following open Task currently linked to version '3' of contract 'NLAP-326' for provider '10017326' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '3' of contract 'NLAP-326' for provider '10017326'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017326 - 10017326 Co Ltd Please review the contract       | NLAP-326       | FCS2 Test                | Contract Advisers Team   | Open            | Not Started      |

    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When the following open Task currently linked to version '3' of contract 'NLAP-326' for provider '10017326' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '3' of contract 'NLAP-326' for provider '10017326'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017326 - 10017326 Co Ltd                                  | NLAP-326       | FCS1 Test                | Contract Managers Team   | Open            | Not Started      |
	
    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When the following open Task currently linked to version '3' of contract 'NLAP-326' for provider '10017326' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '3' of contract 'NLAP-326' for provider '10017326'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017326 - 10017326 Co Ltd                                  | NLAP-326       | Lead Manager Team         | ?                        | Open            | Not Started      |

    # Mark Month-End as in progress
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When the following open Task currently linked to version '3' of contract 'NLAP-326' for provider '10017326' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017326 | NLAP-326           | 3                     | 0                        | Approved         | Under Termination         | True          | True                | 01/01/2018        | 31/03/2019      | Notification  |
    | 10017326 | NLAP-326           | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/01/2018        | 31/03/2019      | Variation     |
    | 10017326 | NLAP-326           | 1                     | 0                        | Replaced         | Under Termination         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |
    | 10017326 | ESFA-326           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |


    # Tidy up
    And   the override date is reset 

@AcceptanceTest @Withdrawn20260521 
Scenario: A327 Create and approve an 1819 Mainstream contract with 16-18TRN(PoA) and AEBTO-CL(PoP) allocations. Initiate termination. Approve initiation. Bulk amend (Variation). Delete v2. Complete termination. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017327' 
    And   there are no terminated or closed allocations for UKPRN '10017327' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017327' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16TR-327      |
    | AECL-327      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017327' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017327 Co Ltd' with UKPRN '10017327' and OrgId 'ORG0017327' and has 'FCS1 Test' as a manager 
    And   UPIN '117327' is associated with UKPRN '10017327' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017327 | 117327 | 10017327 Co Ltd | 0              | Active | Yes           | AA017327      | ?             | 

    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017327 | 10017327 Co Ltd      | ESFA-327             | MAIN-327       | 1                     | 01/08/2018        | 31/07/2019      | 80079.00      |                                | Contract for Services | 1819   | New          | ORG0017327 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017327 | MAIN-327       | 16TR-327      | 16-18TRN          | 16-18TRN1819            | AY                      | 01/08/2018          | 31/07/2019        | 54209.00        |                                         |            |                                                             | New          |             |
    | 10017327 | MAIN-327       | AECL-327      | AEBTO-CL          | AEBTO-CL1819            | AY                      | 01/08/2018          | 31/07/2019        | 25870.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017327 | MAIN-327       | 16TR-327      | 1               | 0                     | 54209.00  | 4553.00  | 5136.00  | 1420.00  | 2448.00  | 6767.00  | 5897.00  | 4805.00  | 3396.00  | 6638.00  | 4315.00  | 3130.00  | 5704.00  | 16-18 Traineeships Funding                                      | New          |             |
    | 10017327 | MAIN-327       | 16TR-327      | 2               | 1                     | 27442.00  | 3470.00  | 2813.00  | 100.00   | 836.00   | 3312.00  | 3287.00  | 2378.00  | 1404.00  | 3341.00  | 1231.00  | 2126.00  | 3144.00  | 16-18 Traineeships Programme Funding                            | New          |             |
    | 10017327 | MAIN-327       | 16TR-327      | 3               | 1                     | 26767.00  | 1083.00  | 2323.00  | 1320.00  | 1612.00  | 3455.00  | 2610.00  | 2427.00  | 1992.00  | 3297.00  | 3084.00  | 1004.00  | 2560.00  | 16-18 Traineeships Bursary Funding                              | New          |             |
    | 10017327 | MAIN-327       | AECL-327      | 1               | 0                     | 25870.00  | 1762.00  | 2182.00  | 1905.00  | 2735.00  | 2963.00  | 314.00   | 1841.00  | 1944.00  | 2616.00  | 3318.00  | 2948.00  | 1342.00  | Adult Education Budget - Community Learning                     | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-327' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-327' and actual ContractNumber 'MAIN-327'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-327' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017327 | MAIN-327           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017327 | ESFA-327           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'MAIN-327'



 
    # Initiate a TERMINATION

    # Change the date
    Given the override date is '16/03/2019'

    # Request termination of the contract via the CRM UI
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'MAIN-327' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 18/08/2018               | 23/09/2018              | No                          | Notice from Provider    | Director in prison      |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | 16TR-327         | 28/08/2018                  | 12/09/2018                |
    | AECL-327         | 21/08/2018                  | 05/09/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'MAIN-327' for UKPRN '10017327'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017327 - 10017327 Co Ltd     | MAIN-327       | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017327 | MAIN-327       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017327 | ESFA-327       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '19/03/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'MAIN-327' for provider '10017327' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017327 | MAIN-327       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017327 | ESFA-327       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Amend the contract
	
	# Change the date (to a date after the termination date)
    Given the override date is '16/05/2019'

#    # Bulk amend contract (Variation) to create v2 but don't approve it
#    And   there are no files prefixed '10017327_MAIN-327' in the Sharepoint 'MAIN-1819-Input-Appendices' folder
#    And   there are no files prefixed 'MAIN AY 1819 16102018165859 v3_A327' in the Sharepoint 'Processed' folder
#    And   there are no files prefixed 'MAIN AY 1819 16102018165859 v3_A327' in the Sharepoint 'Reports' folder
#    And   spreadsheet 'MAIN AY 1819 16102018165859 v3_A327.xlsx' exists in the Datafiles folder and UKPRN '10017327' is present in cell 'A2' of the Contract tab
#    When  the file is copied to the Sharepoint 'Input' folder 
#    Then  a syntax report should exist in the Sharepoint Reports folder
#    And   a results report should exist in the Sharepoint Reports folder
#    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Issue a non-financial VARIATION amendment on v1 to create v2 but don't approve it
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'MAIN-327' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'MAIN-327' for a non-financial VARIATION contract amendment

    # Contract status is now at 'Awaiting Documentation'

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017327 | MAIN-327       | 2                     | 0                        | Draft          | Awaiting Documentation                   | True          | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017327 | MAIN-327       | 1                     | 0                        | Approved       | Under Termination                        | False         | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017327 | ESFA-327       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |



	# Delete v2

    # Trigger WF28 in CRM to issue a delete request against v2 of the contract
   #When  a request is initiated in CRM to delete the following contracts
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017327 | MAIN-327       | 2                     | 0                  |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017327 | MAIN-327       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017327 | ESFA-327       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Complete the Termination

    # Change the date (This is ignored by CRM)
    Given the override date is '22/06/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination (23893)
#   When  CRM user 'FCS8 Test' completes the termination request for Contract 'MAIN-327' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' completes the termination request for Contract 'MAIN-327' Version '1' SubVersion '0' via SDK

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017327 | MAIN-327       | 1                     | 0                        | Closed         | Terminated                               | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017327 | ESFA-327       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |


    # Tidy up
	And   the override date is reset
	
@AcceptanceTest @Withdrawn20231002
Scenario: A083 Create and approve a 2021 AEBP contract. Initiate and approve termination. Bulk amend to add an allocation. Approve. NFA amendment. Approve. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017083' 
    And   there are no terminated or closed allocations for UKPRN '10017083' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017083' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017083' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017083' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-083      |
    | AEBR-083      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-083      |
    | AEBR-083      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-19TRN2021     |
    | AEB-AS2021        |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP-083       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017083'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017083' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017083 Co Ltd' with UKPRN '10017083' and OrgId 'ORG0017083' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017083' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017083 | 117083 | 10017083 Co Ltd | 0              | Active                | Yes           | AA017083      | ?             | 41 Send Barns Lane     | Send                   | Woking                 | ?                      | ?                      | Surrey                 | GU23 7BS  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017083 |




    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription  | ContractType   | Period | CRMIntent    | OrgId      |
    | 10017083 | 10017083 Co Ltd      | ESFA-083             | AEBP-083       | 1                     | 01/08/2020        | 31/07/2021      | 39946.00      |                      | Procured       | 2021   | New          | ORG0017083 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName   | UoPCode    | AllocationDescription  | CRMIntent    | DeliveryOrg |
    | 10017083 | AEBP-083       | AEBA-083      | AEB-AS            | AEB-AS2021              | AY                      | 01/08/2020          | 31/07/2021        | 17624.00        |           |            |                        | New          |             |
    | 10017083 | AEBP-083       | AEBR-083      | AEB-19TRN         | AEB-19TRN2021           | AY                      | 01/08/2020          | 31/07/2021        | 22322.00        |           |            |                        | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription             | CRMIntent    | DeliveryOrg |
    | 10017083 | AEBP-083       | AEBA-083      | 1               | 0                     | 17624.00  | 11054.00  | 6570.00   | 801.00   | 144.00   | 1132.00  | 1869.00  | 643.00   | 618.00   | 3410.00  | 2437.00  | 673.00   | 2264.00  | 3158.00  | 475.00   | Adult Skills Total Funding         | New          |             | 
    | 10017083 | AEBP-083       | AEBR-083      | 1               | 0                     | 22322.00  | 13859.00  | 8463.00   | 3488.00  | 1028.00  | 3726.00  | 316.00   | 2159.00  | 1314.00  | 1131.00  | 697.00   | 2001.00  | 1788.00  | 3409.00  | 1265.00  | 19-24 Traineeships Total Funding   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP-083       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-083'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-083' and actual ContractNumber 'AEBP-083'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-083' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017083 | AEBP-083           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017083 | ESFA-083           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'AEBP-083'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AEBA-083        | 2372010          | Jul-21 | Reconciliation |
    | AEBR-083        | 2355860          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                             | DeliverableDescription                                      | 
    | 10017083 | AEBP-083       | 1               | AEBA-083      | 1               | 0                     | 17624.00     | 0             | 0        | Adult Skills Total Funding                                  | ?                                                           |
    | 10017083 | AEBP-083       | 1               | AEBR-083      | 1               | 0                     | 22322.00     | 0             | 0        | 19-24 Traineeships Total Funding                            | ?                                                           |





    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '03/11/2020'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | AEBP-083      | 1               | 0                  | 03/11/2020              | Removed from RoATP          | Company struck off                  |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | AEBA-083           | 09/10/2020                   | 16/10/2020                      |
    | AEBR-083           | 02/10/2020                   | 09/10/2020                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017083 | AEBP-083       | 1                     | 0                        | 03/11/2020                 | Removed from RoATP           | ?                              | 03/11/2020              | Removed from RoATP          | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017083 | AEBP-083      | AEBA-083         | 1                     | 0                        | 09/10/2020                   | 09/10/2020        | 16/10/2020                      | 16/10/2020           |
    | 10017083 | AEBP-083      | AEBR-083         | 1                     | 0                        | 02/10/2020                   | 02/10/2020        | 09/10/2020                      | 09/10/2020           |

    # A Termination Initiation Task should have been created
    And   the following Tasks are present against version '1' of contract 'AEBP-083' for provider '10017083'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017083 - 10017083 Co Ltd     | AEBP-083       | FCS1 TEST               | Contract Managers Team   | Open            | Not Started      |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'AEBP-083' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                             | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus        |
    | 10017083 | ESFA-083           | AEBP-083       | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval | FCS2 TEST             | Document Management Team  | Approved       | Approved                 |
    | 10017083 | ESFA-083           | AEBP-083       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                 | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider    |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-083' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Initiate Contract Termination                  | FCS8 TEST                     | Company struck off               |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017083 | AEBP-083           | 1                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017083 | ESFA-083           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |




    # Approve Termination Initiation (30635)

    # Change the date - CRM ignores this
    Given the override date is '04/11/2020'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task
    When the following open Task currently linked to version '1' of contract 'AEBP-083' for provider '10017083' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Termination Initiation Approval  | FCS1 TEST                 |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017083 | AEBP-083           | 1                     | 0                        | Approved         | Under Termination                        | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017083 | ESFA-083           | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the current state of the TASKS for this contract
    Then  the following Tasks are present against version '1' of contract 'AEBP-083' for provider '10017083'
    | Task                                       | Description                    | Regarding      | Owner                   | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017083 - 10017083 Co Ltd     | AEBP-083       | FCS1 TEST               | Contract Managers Team   | Completed       | Completed        |

    # Check the Termination details on the contract in CRM (These should not have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017083 | AEBP-083       | 1                     | 0                        | 03/11/2020                 | Removed from RoATP           | ?                              | 03/11/2020              | Removed from RoATP          | ?                             |

    # Check the Termination details on the allocations in CRM (These should not have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017083 | AEBP-083      | AEBA-083         | 1                     | 0                        | 09/10/2020                   | 09/10/2020        | 16/10/2020                      | 16/10/2020           |
    | 10017083 | AEBP-083      | AEBR-083         | 1                     | 0                        | 02/10/2020                   | 02/10/2020        | 09/10/2020                      | 09/10/2020           |

    # Check the contents of the Workflow History
    And   the Workflow History for version '1' of contract 'AEBP-083' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy                   | NewContractOwner | NewTaskOwner                | NewStatus         | NewSubStatus                                  | PreviousContractOwner | PreviousTaskOwner         | PreviousStatus | PreviousSubStatus                            |
    | 10017083 | ESFA-083           | AEBP-083       | 1                     | Termination Initiation Successful           | CRM Integration               | FCS2 TEST        | FCS1 TEST                   | Approved          | Under Termination                             | FCS2 TEST             | FCS1 TEST                 | Approved       | Termination Initiation Approval in Progress  |
    | 10017083 | ESFA-083           | AEBP-083       | 1                     | Approve Termination Initiation              | FCS5 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Termination Initiation Approval in Progress   | FCS2 TEST             | FCS1 TEST                 | Approved       | Awaiting Termination Initiation Approval     |
    | 10017083 | ESFA-083           | AEBP-083       | 1                     | Initiate Contract Termination               | FCS8 TEST                     | FCS2 TEST        | FCS1 TEST                   | Approved          | Awaiting Termination Initiation Approval      | FCS2 TEST             | Document Management Team  | Approved       | Approved                                     |
    | 10017083 | ESFA-083           | AEBP-083       | 1                     | Confirm Receipt of Digital Signature        | CRM Integration               | FCS2 TEST        | Document Management Team    | Approved          | Approved                                      | FCS2 TEST             | Document Management Team  | Draft          | Published to Provider                        |

    # Check the Workflow History comments 
    And   the workflow history on contract 'AEBP-083' version '1' includes the following
    | Action                                         | CompletedBy                   | Comment                          |
    | Termination Initiation Successful              | CRM Integration               | ?                                |
    | Approve Termination Initiation                 | FCS5 TEST                     | ?                                |
    | Initiate Contract Termination                  | FCS8 TEST                     | Company struck off               |
    | Confirm Receipt of Digital Signature           | CRM Integration               | ?                                |





    # Bulk amendment, adding an allocation (31891)

    # Change the date
    Given the override date is '06/11/2020'

    # Bulk file
    And   there are no files prefixed '10017083' in the Sharepoint 'AEB-2021-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 2021 18112020104808 v3_A083' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 2021 18112020104808 v3_A083' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 2021 18112020104808 v3_A083' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 2021 18112020104808 v3_A083' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 2021 18112020104808 v3_A083.xlsx' exists in the Datafiles folder and UKPRN '10017083' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017083' for FundingType 'AEB' and period '2021' 

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017083 | AEBP-083           | 2                     | 0                        | Draft            | Awaiting Documentation  | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017083 | AEBP-083           | 1                     | 0                        | Approved         | Under Termination       | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017083 | ESFA-083           | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the Termination details on the contract in CRM 
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason     | TerminationComments    |
    | 10017083 | AEBP-083       | 2                     | 0                        | 03/11/2020                 | Removed from RoATP           | ?                              | 03/11/2020              | Removed from RoATP    | ?                      |

    # Check the Termination details on the allocations in CRM 
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017083 | AEBP-083      | AEBA-083         | 2                     | 0                        | 09/10/2020                   | 09/10/2020        | 16/10/2020                      | 16/10/2020           |
    | 10017083 | AEBP-083      | AEBR-083         | 2                     | 0                        | 02/10/2020                   | 02/10/2020        | 09/10/2020                      | 09/10/2020           |
    | 10017083 | AEBP-083      | [AllocRef_AESO]  | 2                     | 0                        | ?                            | ?                 | ?                               | ?                    |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-083'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-083' and actual ContractNumber 'AEBP-083'

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017083 | AEBP-083           | 2                     | 0                        | Approved         | Under Termination       | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017083 | AEBP-083           | 1                     | 0                        | Replaced         | Under Termination       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017083 | ESFA-083           | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '120' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '120' deliverable period rows in CRM linked to the latest version of contract 'AEBP-083'





    # NFA (31894)
    
    # Change the date
    Given the override date is '08/11/2020'

    # Issue a non-financial VARIATION amendment on v2 to create v3
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'AEBP-083' for a non-financial VARIATION contract amendment
   
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017083 | AEBP-083           | 3                     | 0                        | Draft            | Awaiting Documentation  | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017083 | AEBP-083           | 2                     | 0                        | Approved         | Under Termination       | False         | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017083 | AEBP-083           | 1                     | 0                        | Replaced         | Under Termination       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017083 | ESFA-083           | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017083' for FundingType 'AEB' and period '2021' 
    
    # Check the Termination details on the contract in CRM 
    And   the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason     | TerminationComments    |
    | 10017083 | AEBP-083       | 3                     | 0                        | 03/11/2020                 | Removed from RoATP           | ?                              | 03/11/2020              | Removed from RoATP    | ?                      |

    # Check the Termination details on the allocations in CRM 
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017083 | AEBP-083      | AEBA-083         | 3                     | 0                        | 09/10/2020                   | 09/10/2020        | 16/10/2020                      | 16/10/2020           |
    | 10017083 | AEBP-083      | AEBR-083         | 3                     | 0                        | 02/10/2020                   | 02/10/2020        | 09/10/2020                      | 09/10/2020           |
    | 10017083 | AEBP-083      | [AllocRef_AESO]  | 3                     | 0                        | ?                            | ?                 | ?                               | ?                    |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP-083'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '3'
    When  a contract approval message is received from SFS for version '3' actual MasterContractNumber 'ESFA-083' and actual ContractNumber 'AEBP-083'

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017083 | AEBP-083           | 3                     | 0                        | Approved         | Under Termination       | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017083 | AEBP-083           | 2                     | 0                        | Replaced         | Under Termination       | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017083 | AEBP-083           | 1                     | 0                        | Replaced         | Under Termination       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017083 | ESFA-083           | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '120' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '120' deliverable period rows in CRM linked to the latest version of contract 'AEBP-083'


    # Tidy Up
    And   the override date is reset   
       