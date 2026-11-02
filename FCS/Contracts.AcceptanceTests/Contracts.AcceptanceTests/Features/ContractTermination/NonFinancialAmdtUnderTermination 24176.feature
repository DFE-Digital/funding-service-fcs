Feature: NonFinancialAmdtUnderTermination 24176

@AcceptanceTest @Withdrawn20231002 
@Long2Run @Long2Run123
Scenario: A318 Create and approve an 1819 AEB contract. Initiate termination and approve initiation. Execute non-financial variation amendment. Publish then withdraw. Execute non-financial notification amendment. Publish and auto-approve. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017318' 
    And   there are no terminated or closed allocations for UKPRN '10017318' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017318' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEBC-318      |
    | AEBL-318      |
    | AEBT-318      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017318' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017318 Co Ltd' with UKPRN '10017318' and OrgId 'ORG0017318' and has 'FCS1 Test' as a manager 
    And   UPIN '117318' is associated with UKPRN '10017318' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017318 | 117318 | 10017318 Co Ltd | 0              | Active | Yes           | AA017318      | ?             | 




    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017318 | 10017318 Co Ltd      | ESFA-318             | AEBP-318       | 1                     | 01/08/2018        | 31/07/2019      | 63779.00      |                                | Contract for Services | 1819   | New          | ORG0017318 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017318 | AEBP-318       | AEBC-318      | AEB-CL            | AEB-CL1819              | AY                      | 01/08/2018          | 31/07/2019        | 27221.00        |                                         |            |                                                             | New          |             |
    | 10017318 | AEBP-318       | AEBL-318      | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 20536.00        |                                         |            |                                                             | New          |             |
    | 10017318 | AEBP-318       | AEBT-318      | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 16022.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017318 | AEBP-318       | AEBC-318      | 1               | 0                     | 27221.00  | 3240.00  | 527.00   | 1263.00  | 3739.00  | 3714.00  | 2805.00  | 1832.00  | 68.00    | 1658.00  | 2553.00  | 3571.00  | 2251.00  | Adult Education Budget - Community Learning                     | New          |             |
    | 10017318 | AEBP-318       | AEBL-318      | 1               | 0                     | 20536.00  | 302.00   | 2999.00  | 3291.00  | 1433.00  | 588.00   | 405.00   | 3671.00  | 1275.00  | 1062.00  | 2683.00  | 539.00   | 2288.00  | Adult Education Budget - Learner Support                        | New          |             |
    | 10017318 | AEBP-318       | AEBT-318      | 1               | 0                     | 16022.00  | 686.00   | 409.00   | 1240.00  | 1467.00  | 2520.00  | 345.00   | 449.00   | 1121.00  | 1823.00  | 1452.00  | 3547.00  | 963.00   | Adult Education - Traineeships and Other Learning Total Funding | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-318' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-318' and actual ContractNumber 'AEBP-318'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-318' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017318 | AEBP-318           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017318 | ESFA-318           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'AEBP-318'




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '09/03/2019'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason        | Comments           |
    | AEBP-318      | 1               | 0                  | 26/04/2019              | Provider Change          | ?                  |

    And   with the following allocation termination options
    | AllocationNumber | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | AEBC-318         | 31/03/2019                   | 15/04/2019                      |
    | AEBL-318         | 30/03/2019                   | 14/04/2019                      |
    | AEBT-318         | 29/03/2019                   | 13/04/2019                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017318 | AEBP-318       | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017318 | ESFA-318       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |



    
    # Authorise the Termination Initiation

    # Change the date
    Given the override date is '12/03/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'AEBP-318' for provider '10017318' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS1 TEST     |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017318 | AEBP-318       | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017318 | ESFA-318       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check CONTRACT termination values in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017318 | AEBP-318       | 1                     | 0                        | 26/04/2019                 | Provider Change              | ?                              | 26/04/2019              | Provider Change             | ?                             |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017318 | AEBP-318      | AEBC-318         | 1                     | 0                        | 31/03/2019                   | 31/03/2019        | 15/04/2019                      | 15/04/2019           |
    | 10017318 | AEBP-318      | AEBL-318         | 1                     | 0                        | 30/03/2019                   | 30/03/2019        | 14/04/2019                      | 14/04/2019           |
    | 10017318 | AEBP-318      | AEBT-318         | 1                     | 0                        | 29/03/2019                   | 29/03/2019        | 13/04/2019                      | 13/04/2019           |




    # Non-financial VARIATION amendment 

    # Change the date
    Given the override date is '14/03/2019'

    # Initiate non-financial variation amendment request on v1 to create v2
   #When  a request is raised by advisor 'FCS2 TEST' against version '1' subversion '0' of contract 'AEBP-318' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 TEST' against version '1' subversion '0' of contract 'AEBP-318' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017318 | AEBP-318           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017318 | AEBP-318           | 1                     | 0                        | Approved         | Under Termination         | False         | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017318 | ESFA-318           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

	# Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    When  the latest version of contract 'AEBP-318' is in a state of 'Published to Provider'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017318 | AEBP-318           | 2                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017318 | AEBP-318           | 1                     | 0                        | Approved         | Under Termination         | False         | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017318 | ESFA-318           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check CONTRACT termination values in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017318 | AEBP-318       | 2                     | 0                        | 26/04/2019                 | Provider Change              | ?                              | 26/04/2019              | Provider Change             | ?                             |

    # Check ALLOCATION termination values in CRM
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017318 | AEBP-318      | AEBC-318         | 2                     | 0                        | 31/03/2019                   | 31/03/2019        | 15/04/2019                      | 15/04/2019           |
    | 10017318 | AEBP-318      | AEBL-318         | 2                     | 0                        | 30/03/2019                   | 30/03/2019        | 14/04/2019                      | 14/04/2019           |
    | 10017318 | AEBP-318      | AEBT-318         | 2                     | 0                        | 29/03/2019                   | 29/03/2019        | 13/04/2019                      | 13/04/2019           |





    # Withdraw v2
    
    # Change the date
    Given the override date is '21/03/2019'

    # Withdraw the contract
    When  the next action performed on the latest version of contract 'AEBP-318' is 'Withdraw On Behalf Of Provider' with reason 'Test A318' by 'FCS1 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017318 | AEBP-318           | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017318 | AEBP-318           | 1                     | 0                        | Approved         | Under Termination         | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017318 | ESFA-318           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Non-financial NOTIFICATION amendment 

    # Change the date
    Given the override date is '24/03/2019'

    # Initiate non-financial notification amendment request on v1 to create v3
    When  a request is raised by advisor 'FCS2 TEST' against version '1' subversion '0' of contract 'AEBP-318' for a non-financial NOTIFICATION contract amendment
   #When  a request is raised by advisor 'FCS2 TEST' against version '1' subversion '0' of contract 'AEBP-318' for a non-financial VARIATION contract amendment

    # Contract status is now at 'Awaiting Documentation'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017318 | AEBP-318           | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2018        | 31/07/2019      | Notification  |
    | 10017318 | AEBP-318           | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017318 | AEBP-318           | 1                     | 0                        | Approved         | Under Termination         | False         | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017318 | ESFA-318           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Put a dummy file into a Sharepoint folder
    Given there are no files prefixed '10017318_AEBP-318' in the Sharepoint 'AEB-1819-Input-Terms And Conditions' folder
    And   a file with filename '10017318_AEBP-318.pdf' is created in 'AEB-1819-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When the following open Task currently linked to version '3' of contract 'AEBP-318' for provider '10017318' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '3' of contract 'AEBP-318' for provider '10017318'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017318 - 10017318 Co Ltd Please review the contract       | AEBP-318       | FCS2 Test                 | Contract Advisers Team   | Open            | Not Started      |

    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When the following open Task currently linked to version '3' of contract 'AEBP-318' for provider '10017318' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 TEST                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '3' of contract 'AEBP-318' for provider '10017318'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017318 - 10017318 Co Ltd                                  | AEBP-318       | FCS1 Test                 | Contract Managers Team   | Open            | Not Started      |
    
    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When the following open Task currently linked to version '3' of contract 'AEBP-318' for provider '10017318' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 TEST                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '3' of contract 'AEBP-318' for provider '10017318'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017318 - 10017318 Co Ltd                                  | AEBP-318       | Lead Manager Team         | ?                        | Open            | Not Started      |

    # Mark Month-End as in progress
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When the following open Task currently linked to version '3' of contract 'AEBP-318' for provider '10017318' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017318 | AEBP-318           | 3                     | 0                        | Approved         | Under Termination         | True          | True                | 01/08/2018        | 31/07/2019      | Notification  |
    | 10017318 | AEBP-318           | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017318 | AEBP-318           | 1                     | 0                        | Replaced         | Under Termination         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017318 | ESFA-318           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |


    # Tidy up
    And   the override date is reset 
   
@AcceptanceTest @Withdrawn20231002 
Scenario: A319 Create and approve an 1819 Loans contract. Initiate termination and approve initiation. Execute non-financial variation amendment. Delete v2. Complete termination. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017319' 
    And   there are no terminated or closed allocations for UKPRN '10017319' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017319' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLC-319      |
    | ALLF-319      |
    | CLP-319       |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017319' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017319 Co Ltd' with UKPRN '10017319' and OrgId 'ORG0017319' and has 'FCS1 Test' as a manager 
    And   UPIN '117319' is associated with UKPRN '10017319' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017319 | 117319 | 10017319 Co Ltd | 0              | Active | Yes           | AA017319      | ?             | 




    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017319 | 10017319 Co Ltd      | ESFA-319             | LOANS-319      | 1                     | 01/08/2018        | 31/07/2019      | 61509.00      |                                | Contract for Services | 1819   | New          | ORG0017319 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017319 | LOANS-319      | ALLC-319      | ALLBC             | ALLBC1819               | AY                      | 01/08/2018          | 31/07/2019        | 23740.00        |                                         |            |                                                             | New          |             |
    | 10017319 | LOANS-319      | ALLF-319      | ALLF              | ALLF1819                | AY                      | 01/08/2018          | 31/07/2019        | 21065.00        |                                         |            |                                                             | New          |             |
    | 10017319 | LOANS-319      | CLP-319       | CLP               | CLP1819                 | AY                      | 01/08/2018          | 31/07/2019        | 16704.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017319 | LOANS-319      | ALLC-319      | 1               | 0                     | 23740.00  | 3258.00  | 545.00   | 1282.00  | 56.00    | 3733.00  | 2823.00  | 1850.00  | 86.00    | 1677.00  | 2571.00  | 3589.00  | 2270.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             |
    | 10017319 | LOANS-319      | ALLF-319      | 5               | 0                     | 21065.00  | 962.00   | 3660.00  | 251.00   | 2094.00  | 1249.00  | 1066.00  | 631.00   | 1936.00  | 1723.00  | 3344.00  | 1200.00  | 2949.00  | Advanced Learner Loans Facility                                 | New          |             |
    | 10017319 | LOANS-319      | CLP-319       | 1               | 0                     | 16704.00  | 1051.00  | 775.00   | 1605.00  | 1832.00  | 2885.00  | 711.00   | 814.00   | 1486.00  | 2188.00  | 1817.00  | 212.00   | 1328.00  | Career Learning Pilots                                          | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'LOANS-319' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-319' and actual ContractNumber 'LOANS-319'

    # Check that the contract is now approved
    Then  the latest version of contract 'LOANS-319' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017319 | LOANS-319          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017319 | ESFA-319           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '108' deliverable period rows in CRM linked to the latest version of contract 'LOANS-319'




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '11/03/2019'

    # Request termination of the contract 
    When  CRM user 'FCS8 Test' initiates contract termination for Contract 'LOANS-319' Version '1' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | InitiateAmendmentOnApproval | TerminationReason       | TerminationComments     |
    | 13/10/2018               | 28/10/2018              | No                          | Other                   | Police involvement      |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ALLC-319         | 02/10/2018                  | 17/10/2018                |
    | ALLF-319         | 27/09/2018                  | 11/10/2018                |
    | CLP-319          | 28/09/2018                  | 12/10/2018                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '1' of contract 'LOANS-319' for UKPRN '10017319'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017319 - 10017319 Co Ltd     | LOANS-319      | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017319 | LOANS-319      | 1                     | 0                        | Approved       | Awaiting Termination Initiation Approval | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017319 | ESFA-319       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Approve the Termination Initiation

    # Change the date
    Given the override date is '14/03/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '1' of contract 'LOANS-319' for provider '10017319' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017319 | LOANS-319      | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017319 | ESFA-319       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Non-financial VARIATION amendment 

    # Change the date
    Given the override date is '17/03/2019'

    # Initiate non-financial variation amendment request on v1 to create v2
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'LOANS-319' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'LOANS-319' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017319 | LOANS-319          | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017319 | LOANS-319          | 1                     | 0                        | Approved         | Under Termination         | False         | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017319 | ESFA-319           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Delete v2

    # Change the date
    Given the override date is '18/03/2019'

    # Trigger WF28 in CRM to issue a delete request against v2 of the contract
   #When  a request is initiated in CRM to delete the following contracts
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017319 | LOANS-319      | 2                     | 0                  |


    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017319 | LOANS-319      | 1                     | 0                        | Approved       | Under Termination                        | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017319 | ESFA-319       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Complete the Termination

    # Change the date (CRM ignores this date)
    Given the override date is '11/05/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination (23893)
#   When  CRM user 'FCS8 Test' completes the termination request for Contract 'LOANS-319' Version '1' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' completes the termination request for Contract 'LOANS-319' Version '1' SubVersion '0' via SDK

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ContractStatus | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017319 | LOANS-319      | 1                     | 0                        | Closed         | Terminated                               | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017319 | ESFA-319       | 1                     | 0                        | Draft          | ?                                        | False         | False               | 01/08/2018        | 31/07/2019      | ?             |


    # Tidy up
    And   the override date is reset 

    