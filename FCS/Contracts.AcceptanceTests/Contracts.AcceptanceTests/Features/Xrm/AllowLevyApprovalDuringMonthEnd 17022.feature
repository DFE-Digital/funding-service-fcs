Feature: AllowLevyApprovalDuringMonthEnd 17022

@AcceptanceTest @Withdrawn20231002 
@PublishNewLevyContract
Scenario: A117 Manage a digital approval for Levy during month-end
    Given there is no Contract, Task or Workflow data for UKPRN '10017117'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Levy 117 Co Ltd' with UKPRN '10017117' and OrgId 'ORG0017117' and has 'FCS1 Test' as a manager
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there are no DAS engagement events stored in FCS
    And   the override date is reset

    When  a valid DAS request is received to create a Levy contract based on the following 
    | UKPRN    | FundingType | ContractStartDate | ContractEndDate |
    | 10017117 | LEVY        | 01/05/2017        | ?               |

    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017117 | Levy 117 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017117 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017117 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
    | 10017117 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017117 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017117 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017117 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017117 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Retrieve MasterContract and Contract numbers for this contract
    And   '[MasterContractNo]' is the MasterContractNumber of the latest Levy contract held by UKPRN '10017117'
    And   '[ContractNo]' is the ContractNumber of the latest Levy contract held by UKPRN '10017117'

    # Check Atom feed data
    And   the ContractManagement.AtomFeedItem table contains one ItemType '1' event for version '1' of contract number '[ContractNo]'
    And   the ItemType '1' event for version '1' of contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema
    And   the ContractManagement.AtomFeedItem table does not contain an ItemType '0' event for version '1' of contract number '[ContractNo]'

    # Mark Month-End as in progress
    Given the override date is '10/05/2017'
    And   the PaaS MonthEndIsRunning indicator is set to 'True'

    # Inject approval message
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

   # Check that contract has been approved
    Then  the latest version of the contract has the following settings 
    | Status   | SubStatus | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Approved | Approved  | Yes           | Yes                 | 1                     |

    # Check Atom feed after approval for an ItemType zero
    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version '1' of contract number '[ContractNo]'
    And   the ItemType '0' event for version '1' of contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Tidy up
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002 
Scenario: A118 Create and successfully approve a 1718 16-18Apps contract during month-end. Non-financial VARIATION amendment to create v2. Fail to approve during month-end but approve ok after month-end
    Given there is no Contract, Task or Workflow data for UKPRN '10017118'
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16AP-118      |
 #  And   there are no created contracts for this number 'MAIN-118'
 #  And   there are no approved contracts for this number 'MAIN-118'
    And   the override date is reset
    And   the PaaS MonthEndIsRunning indicator is set to 'False'



    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017118' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017118 Co Ltd' with UKPRN '10017118' and OrgId 'ORG0017118' and has 'FCS1 Test' as a manager 
    And   UPIN '117118' is associated with UKPRN '10017118' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017118 | 117118 | 10017118 Co Ltd | 0              | Active | Yes           | AA017118      | ?             | 




    # Change the date
    Given the override date is '01/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017118 | 10017118 Co Ltd      | ESFA-118             | MAIN-118       | 1                     | 01/08/2017        | 31/07/2018      | 22587.00      |                                | Contract for Services | 1718   | New          | ORG0017118 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    |
    | 10017118 | MAIN-118       | 16AP-118      | 16-18 APPS        | 16-18APPS1718           | AY                      | 01/08/2017          | 31/07/2018        | 22587.00        |                         |            |                                                             | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    |
    | 10017118 | MAIN-118       | 16AP-118      | 2               | 0                     | 22587.00  | 2661.00  | 2024.00  | 2194.00  | 1121.00  | 1167.00  | 2917.00  | 101.00   | 2865.00  | 3064.00  | 2674.00  | 217.00   | 1582.00  | Total 16-18 Funding                                             | New          |

    And   the contract exists in CRM
	# Contract status is now at 'Awaiting Documentation'

	# Publish the contract
    And   the latest version of contract 'MAIN-118' is in a state of 'Published to Provider'

	# Change the date
	Given the override date is '26/07/2017'
   
    # Mark Month-End as in progress
    And   the PaaS MonthEndIsRunning indicator is set to 'True'

    # Inject an SFS contract approval message. This should succeed. Version 1 can be approved during month-end 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-118' and actual ContractNumber 'MAIN-118'

    # Check that contract has been approved   
	Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017118 | MAIN-118           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017118 | ESFA-118           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check Atom feed data for an ItemType zero (Approval) event
    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version '1' of actual contract number 'MAIN-118'
    And   the ItemType '0' event for version '1' of actual contract number 'MAIN-118' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Mark Month-End as complete
    When  the PaaS MonthEndIsRunning indicator is set to 'False'

    # The following bulk file has been replaced by a non-financial variation amendment

#    # Cleardown prior to bulk import
#    Given there are no files prefixed '10017118_MAIN-118' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
#    And   there are no files prefixed 'MAIN AY 1718 16042018095011 v2_A118' in the Sharepoint 'Input' folder
#    And   there are no files prefixed 'MAIN AY 1718 16042018095011 v2_A118' in the Sharepoint 'Processing' folder
#    And   there are no files prefixed 'MAIN AY 1718 16042018095011 v2_A118' in the Sharepoint 'Processed' folder
#    And   there are no files prefixed 'MAIN AY 1718 16042018095011 v2_A118' in the Sharepoint 'Reports' folder
#
#    # Bulk import to amend the contract
#    And   spreadsheet 'MAIN AY 1718 16042018095011 v2_A118.xlsx' exists in the Datafiles folder and UKPRN '10017118' is present in cell 'A2' of the Contract tab
#    When  the file is copied to the Sharepoint 'Input' folder
#    Then  a syntax report should exist in the Sharepoint Reports folder
#    And   a results report should exist in the Sharepoint Reports folder
#    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Execute a non-financial VARIATION amendment

    # Change the date
    Given the override date is '22/08/2017'

    # Issue a non-financial VARIATION amendment on v1 to create v2
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'MAIN-118' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'MAIN-118' for a non-financial VARIATION contract amendment
   
    # Check that contract has been approved   
	Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017118 | MAIN-118           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017118 | MAIN-118           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017118 | ESFA-118           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |


	# Publish the contract
    And   the latest version of contract 'MAIN-118' is in a state of 'Published to Provider'

    # Mark Month-End as in progress
    And   the PaaS MonthEndIsRunning indicator is set to 'True'

    # Inject an SFS contract approval message. This should be 'parked'. Version >1 cannot be approved during month-end 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-118' and actual ContractNumber 'MAIN-118'

    # Check that contract status has not changed, ie the contract approval message has not been processed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017118 | MAIN-118           | 2                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017118 | MAIN-118           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017118 | ESFA-118           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check Atom feed does not contain an ItemType zero (Approval) event
    And    the ContractManagement.AtomFeedItem table does not contain an ItemType '0' event for version '2' of actual contract number 'MAIN-118'

    # Mark Month-End as complete
    When  the PaaS MonthEndIsRunning indicator is set to 'False'

    # Check that contract approval message has finally been processed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017118 | MAIN-118           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017118 | MAIN-118           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017118 | ESFA-118           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check Atom feed after approval for an ItemType zero (Approval) event
    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version '2' of actual contract number 'MAIN-118'
    And   the ItemType '0' event for version '2' of actual contract number 'MAIN-118' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Tidy up
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   the override date is reset

@AcceptanceTest @Complete
@Long2Run @Long2Run123
Scenario: A159 Create and successfully approve a 1718 16-18Apps contract during month-end. Bulk NOTIFICATION amendment to create v2. Step through to published and fail to auto-approve during month-end but auto-approve ok after month-end
    Given there is no Contract, Task or Workflow data for UKPRN '10017159'
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16AP-159      |

    And   the override date is reset
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there are no created contracts for this number 'MAIN-159'

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017159' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017159 Co Ltd' with UKPRN '10017159' and OrgId 'ORG0017159' and has 'FCS1 Test' as a manager 
    And   UPIN '117159' is associated with UKPRN '10017159' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017159 | 117159 | 10017159 Co Ltd | 0              | Active | Yes           | AA017159      | ?             | 

    # Change the date
    And   the override date is '01/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017159 | 10017159 Co Ltd      | ESFA-159             | MAIN-159       | 1                     | 01/08/2017        | 31/07/2018      | 22587.00      |                                | Contract for Services | 1718   | New          | ORG0017159 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    |
    | 10017159 | MAIN-159       | 16AP-159      | 16-18 APPS        | 16-18APPS1718           | AY                      | 01/08/2017          | 31/07/2018        | 22587.00        |                         |            |                                                             | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    |
    | 10017159 | MAIN-159       | 16AP-159      | 2               | 0                     | 22587.00  | 2661.00  | 2024.00  | 2194.00  | 1121.00  | 1167.00  | 2917.00  | 101.00   | 2865.00  | 3064.00  | 2674.00  | 217.00   | 1582.00  | 16-18 Apprenticeships Total Funding                             | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract 'MAIN-159' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '26/07/2017'
   
    # Mark Month-End as in progress
    And   the PaaS MonthEndIsRunning indicator is set to 'True'

    # Inject an SFS contract approval message. This should succeed. Version 1 can be approved during month-end 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-159' and actual ContractNumber 'MAIN-159'

    # Check that contract has been approved
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017159 | MAIN-159           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017159 | ESFA-159           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check Atom feed data for an ItemType zero (Approval) event
    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version '1' of actual contract number 'MAIN-159'
    And   the ItemType '0' event for version '1' of actual contract number 'MAIN-159' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Mark Month-End as complete
    When  the PaaS MonthEndIsRunning indicator is set to 'False'

    # Cleardown prior to bulk import
    Given there are no files prefixed '10017159_MAIN-159' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1718 16042018095222 v2_A159' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1718 16042018095222 v2_A159' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1718 16042018095222 v2_A159' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 16042018095222 v2_A159' in the Sharepoint 'Reports' folder

    # Bulk import to amend the contract
    And   spreadsheet 'MAIN AY 1718 16042018095222 v2_A159.xlsx' exists in the Datafiles folder and UKPRN '10017159' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
   
   # Create two dummy Terms and Conditions files. Each has just one page containing just the work 'Appendices'
    Given there are no files prefixed '10017159_MAIN-159' in the Sharepoint 'MAIN-1718-Input-Terms And Conditions' folder
    And   a file with filename '10017159_MAIN-159_11.pdf' is created in 'MAIN-1718-Input-Terms And Conditions'
    And   a file with filename '10017159_MAIN-159_61.pdf' is created in 'MAIN-1718-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When the following open Task currently linked to version '2' of contract 'MAIN-159' for provider '10017159' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract 'MAIN-159' for provider '10017159'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017159 - 10017159 Co Ltd Please review the contract       | MAIN-159       | FCS2 Test                | Contract Advisers Team   | Open            | Not Started      |


    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When the following open Task currently linked to version '2' of contract 'MAIN-159' for provider '10017159' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract 'MAIN-159' for provider '10017159'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017159 - 10017159 Co Ltd                                  | MAIN-159       | FCS1 Test                | Contract Managers Team   | Open            | Not Started      |



    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When the following open Task currently linked to version '2' of contract 'MAIN-159' for provider '10017159' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract 'MAIN-159' for provider '10017159'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017159 - 10017159 Co Ltd                                  | MAIN-159       | Lead Manager Team         | ?                        | Open            | Not Started      |

    # Mark Month-End as in progress
    And   the PaaS MonthEndIsRunning indicator is set to 'True'

    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When the following open Task currently linked to version '2' of contract 'MAIN-159' for provider '10017159' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |


    # Check that contract status has not changed, ie the contract approval message has not been processed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017159 | MAIN-159           | 2                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/08/2017        | 31/07/2018      | Notification  |
    | 10017159 | MAIN-159           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017159 | ESFA-159           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check Atom feed does not contain an ItemType zero (Approval) event
    And    the ContractManagement.AtomFeedItem table does not contain an ItemType '0' event for version '2' of actual contract number 'MAIN-159'

    # Mark Month-End as complete
    When  the PaaS MonthEndIsRunning indicator is set to 'False'

    # Check that contract approval message has finally been processed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017159 | MAIN-159           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | Notification  |
    | 10017159 | MAIN-159           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017159 | ESFA-159           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check Atom feed after approval for an ItemType zero (Approval) event
    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for version '2' of actual contract number 'MAIN-159'
    And   the ItemType '0' event for version '2' of actual contract number 'MAIN-159' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Tidy up
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
   # And   the override date is reset

