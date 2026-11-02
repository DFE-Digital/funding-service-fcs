Feature: Create1819MainstreamContracts 22862

@AcceptanceTest @Withdrawn20201209
Scenario: A613 Bulk load a new 1819 Mainstream contract with just an AEBTO-CL (PoP) allocation. Check docs. Publish and approve
    Given there is no Contract, Task or Workflow data for UKPRN '10017613' 

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017613' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017613 Co Ltd' with UKPRN '10017613' and OrgId 'ORG0017613' and has 'FCS1 Test' as a manager 
    And   UPIN '117613' is associated with UKPRN '10017613' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017613 | 117613 | 10017613 Co Ltd | 0              | Active | Yes           | AA017613      | ?             | 

    # Change the date
    And   the override date is '02/04/2018'

    # Bulk import to create a new LOANS contract
    And   there are no files prefixed '10017613_MAIN' in the Sharepoint 'MAIN-1819-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1819 14052018130627 v3_A613' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1819 14052018130627 v3_A613' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 1819 14052018130627 v3_A613.xlsx' exists in the Datafiles folder and UKPRN '10017613' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017613' for FundingType 'MAIN' and period '1819' and Delivery Organisation '10176131'
    And   I retrieve the latest contract details from CRM for provider '10017613' for FundingType 'MAIN' and period '1819'

    # Check the contents of the Appendices
    And   a file for this contract exists in sharepoint location 'MAIN-1819-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """    
    APPENDIX 1 - SUMMARY OF EDUCATION AND SKILLS FUNDING AGENCY FUNDING 2018/19
    Organisation Name: 10017613 Co Ltd
    UKPRN: 10017613
    Allocation
    Contract Ref Aug 18 - Mar 19 Apr 19 - Jul 19 2018/19 Total
    Adult Education Budget - Community Learning [AllocRef_AECL] £14,487 £0 £14,487
    Total Funding for this contract £14,487
    Education and Skills Funding Agency Appendix 1 2018/19 Master Contract ref: [MasterContractNo]
    Funding Agreement Adult Education Budget - Community Learning
    Provider: 10017613 Co Ltd UKPRN: 10017613
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: [AllocRef_AECL]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Adult Education Budget - Community Learning £14,487 £14,487 £0 £0 £0 £0 £0 £0 £0 £0 £0 £0 £0
    Total Funding £14,487 £14,487 £0 £0 £0 £0 £0 £0 £0 £0 £0 £0 £0
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """

   #And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'
   
    # Inject an SFS contract approval message.
   #When  an AEB contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved in CRM
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the deliverable counts in CRM 
   #And   there are 'nnn' deliverable periods in CRM linked to the latest version of contract 'xxxx-613' and allocation 'xxxx-613' 
   #And   there are 'nnn' deliverable period rows in CRM linked to the latest version of contract 'xxxx-613' 
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 

    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run67
Scenario: A616 Create a new 1819 Mainstream contract with just an AEBTO-CL (PoP) allocation. Bulk update draft with minimum-plus fields. Step through Tasks until Published then approve. Create PoP payment files. Check CRM, Tasks, Financials and PaaS
    Given there is no Contract, Task or Workflow data for UKPRN '10017616' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AECL-616      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017616' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017616 Co Ltd' with UKPRN '10017616' and OrgId 'ORG0017616' and has 'FCS1 Test' as a manager 
    And   UPIN '117616' is associated with UKPRN '10017616' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017616 | 117616 | 10017616 Co Ltd | 0              | Active | Yes           | AA017616      | ?             | 

    # Change the date
    And   the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017616 | 10017616 Co Ltd      | ESFA-616             | MAIN-616       | 1                     | 01/08/2018        | 31/07/2019      | 4275.00       |                                | Contract for Services | 1819   | New          | ORG0017616 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription      | CRMIntent    | DeliveryOrg |
    | 10017616 | MAIN-616       | AECL-616      | AEBTO-CL          | AEBTO-CL1819            | AY                      | 01/08/2018          | 31/07/2019        | 4275.00         |                         |            |                            | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                 | CRMIntent    | DeliveryOrg |
    | 10017616 | MAIN-616       | AECL-616      | 1               | 0                     | 4275.00   | 4275.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Adult Education Budget Total Funding   | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017616 | MAIN-616           | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017616 | ESFA-616           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Change the date
    Given the override date is '04/07/2018'

    # Bulk import to update draft and create v1.1
    And   there are no files prefixed '10017616_MAIN' in the Sharepoint 'MAIN-1819-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1819 14052018130651 v3_A616' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1819 14052018130651 v3_A616' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 1819 14052018130651 v3_A616.xlsx' exists in the Datafiles folder and UKPRN '10017616' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

#   # Create a dummy Appendix file containing just the word 'Appendices'
#   Given there are no files prefixed '10017616_MAIN-616' in the Sharepoint 'MAIN-1819-Input-Appendices' folder
#   And   a file with filename '10017616_MAIN-616_v1.pdf' is created in 'MAIN-1819-Input-Appendices'

    # Create two dummy Terms and Conditions files. Each has just one page containing just the work 'Appendices'
    Given there are no files prefixed '10017616_MAIN-616' in the Sharepoint 'MAIN-1819-Input-Terms And Conditions' folder
    And   a file with filename '10017616_MAIN-616_11.pdf' is created in 'MAIN-1819-Input-Terms And Conditions'
    And   a file with filename '10017616_MAIN-616_61.pdf' is created in 'MAIN-1819-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '1' of contract 'MAIN-616' for provider '10017616' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'MAIN-616' for provider '10017616'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017616 - 10017616 Co Ltd Please review the contract       | MAIN-616       | FCS2 Test                | Contract Advisers Team   | Open            | Not Started      |


    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '1' of contract 'MAIN-616' for provider '10017616' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'MAIN-616' for provider '10017616'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017616 - 10017616 Co Ltd                                  | MAIN-616       | FCS1 Test                | Contract Managers Team   | Open            | Not Started      |


    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When  the following open Task currently linked to version '1' of contract 'MAIN-616' for provider '10017616' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'MAIN-616' for provider '10017616'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017616 - 10017616 Co Ltd                                  | MAIN-616       | Lead Manager Team         | ?                        | Open            | Not Started      |


    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When  the following open Task currently linked to version '1' of contract 'MAIN-616' for provider '10017616' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |


    # Check that the Tasks on the contract are all marked as completed
    Then  the following Tasks are present against version '1' of contract 'MAIN-616' for provider '10017616'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017616 - 10017616 Co Ltd                                  | MAIN-616       | Lead Manager Team         | ?                        | Completed       | Completed        |
    | Confirm Internal Approval        | 10017616 - 10017616 Co Ltd                                  | MAIN-616       | FCS1 Test                | Contract Managers Team   | Completed       | Completed        |
    | Review Contract Details          | 10017616 - 10017616 Co Ltd Please review the contract       | MAIN-616       | FCS2 Test                | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017616 - 10017616 Co Ltd Awaiting documentation           | MAIN-616       | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017616 | MAIN-616           | 1                     | 1                        | Draft            | Published to Provider     | True          | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017616 | MAIN-616           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017616 | ESFA-616           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Change the date
    Given the override date is '06/07/2018'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-616' and actual ContractNumber 'MAIN-616'

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017616 | MAIN-616           | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017616 | MAIN-616           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017616 | ESFA-616           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'MAIN-616'

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-616       | AECL-616        | 1               | 4750.00  | 4750.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualValue |
    | AECL-616         | 1             | 1               | 201808 | 2              | 0             | 4750.00      | 4750.00              | 0.00                | 0.00                   | 0.00                        | 4750.00          | ?           |
    | AECL-616         | 1             | 1               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AECL-616         | 1             | 1               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AECL-616         | 1             | 1               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AECL-616         | 1             | 1               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AECL-616         | 1             | 1               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AECL-616         | 1             | 1               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AECL-616         | 1             | 1               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AECL-616         | 1             | 1               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AECL-616         | 1             | 1               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AECL-616         | 1             | 1               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AECL-616         | 1             | 1               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |

    # Check the PROFILE subnominal aggregations in PaaS
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017616 | ORG0017616 | AECL-616          | 2372030         | AEBTO-CL1819               | 201808               | PROFILE         | CM             | False       | 4750.00         |
    | 10017616 | ORG0017616 | AECL-616          | 2372030         | AEBTO-CL1819               | 201809               | PROFILE         | CM             | False       | 0.00            |
    | 10017616 | ORG0017616 | AECL-616          | 2372030         | AEBTO-CL1819               | 201810               | PROFILE         | CM             | False       | 0.00            |
    | 10017616 | ORG0017616 | AECL-616          | 2372030         | AEBTO-CL1819               | 201811               | PROFILE         | CM             | False       | 0.00            |
    | 10017616 | ORG0017616 | AECL-616          | 2372030         | AEBTO-CL1819               | 201812               | PROFILE         | CM             | False       | 0.00            |
    | 10017616 | ORG0017616 | AECL-616          | 2372030         | AEBTO-CL1819               | 201901               | PROFILE         | CM             | False       | 0.00            |
    | 10017616 | ORG0017616 | AECL-616          | 2372030         | AEBTO-CL1819               | 201902               | PROFILE         | CM             | False       | 0.00            |
    | 10017616 | ORG0017616 | AECL-616          | 2372030         | AEBTO-CL1819               | 201903               | PROFILE         | CM             | False       | 0.00            |
    | 10017616 | ORG0017616 | AECL-616          | 2372030         | AEBTO-CL1819               | 201904               | PROFILE         | CM             | False       | 0.00            |
    | 10017616 | ORG0017616 | AECL-616          | 2372030         | AEBTO-CL1819               | 201905               | PROFILE         | CM             | False       | 0.00            |
    | 10017616 | ORG0017616 | AECL-616          | 2372030         | AEBTO-CL1819               | 201906               | PROFILE         | CM             | False       | 0.00            |
    | 10017616 | ORG0017616 | AECL-616          | 2372030         | AEBTO-CL1819               | 201907               | PROFILE         | CM             | False       | 0.00            |

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Run the payment batch to create AEBC (PoP) payment files in Maytech's FTP site
    Given the override date is '03/08/2018 22:05'
    
    # This bit checks that there is something in PaaS. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | AECL-616                 | 201808 |

	# PaymentGeneration.PaymentBatchFeedItem
	And   there is no data in the Payment feed for FundingStreamPeriod 'AEBTO-CL1819' PaymentPeriod '201805' CensusEndDate '03/08/2018' and LinkCodeSuffix 'A'

    # PaymentGeneration.PaymentTimetable
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEBTO-CL1819               | 201808               |                      | A              | NotStarted |

#    # Coda.AccountCode
#    And   the following configuration exists in the Account Codes table
#    | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#    | 10017616 | AEBTO-CL1819               | CODA616   | 8115000      | 01/08/1990           | 31/08/2020         |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEBTO-CL1819               | 201808               | Completed |

#    # File created in Maytech FTP folder for 'Adult Education Budget - Community Learning (TO)'
#    Then  Payment file 'AETC20180503A.pay' is created in the FTP Folder
#
#    And   the following details are present in payment file 'AETC20180503A.pay'
#    | LinkCode    | CompanyCode | Element1 | Element2 | Element3 | Element4 | Element5 | Element6 | Element7 | Element8 | Year | Period | Date       | Amount   | Dc   | LineType | Doc     | Desc                            | DueDate    | Tax | Extref1                       | Extref2     | Extref3 | Extref4 | Extref5  | Extref6 | Num   | DocLineNo |
#    | AETC180503A | SFA         | AAA40    | +        | 8115000  | CODA616  | 02       | AECL-616 | ?        | ?        | 2018 | 05     | 03/08/2018 | 4750.00  | 160  | 157      | AETCP   | AEB Community Learng Prf Aug18  | 15/08/2018 | ?   | AECL PROFILE 2018/19          | AETC180503A | ?       | ?       | 10017616 | 2372030 | 1     | 1         |
#    | AETC180503A | SFA         | AAA40    | +        | 2372030  | 5000     | 02       | AECL-616 | ?        | ?        | 2018 | 05     | 03/08/2018 | 4750.00  | 161  | 158      | AETCP   | AEB Community Learng Prf Aug18  | 15/08/2018 | VIO | AECL PROFILE 2018/19          | AETC180503A | ?       | ?       | 10017616 | CODA616 | 1     | 2         |
#
#    # Save a copy of the output to the datafiles/Downloads folder
#    Given there is an encrypted file called 'AETC20180503A.pay' in the Maytech FTP folder decrypt it then save it to 'DataFiles/Downloads'





#    # CDA
#
#	# Run CDA report
#	Given there is no CDA report named 'CDA Last Approved Version A616.csv'
#
#    Then  the contracts are in the replicated CRM database as follows
#    | ContractNumber | ContractVersionNumber |
#    | MAIN-616       | 1                     |
#
#	When  the following CDA report is run
#    | FundingStreamPeriod  | Version               | Suffix |
#    | AEBTO-CL1819         | Last Approved Version | A616   |
#
#    Then  a report named 'CDA Last Approved Version A616.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName    | DeliveryUKPRN | DeliveryProviderName | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus | DeliverableDescription | Deliverable                                 | DeliverableParent | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | AEBTO-CL1819            | 10017616 | 10017616 Co Ltd |               |                      | AECL-616                 | MAIN-616       | ESFA-616                | 01/08/2018                  | 31/07/2019                | 1                     | Approved       | Approved          |                        | Adult Education Budget - Community Learning |                   | 8                 | 2018            | 2018/19       |              | 4750         |              |               |              | Yes                | 4750.00        | 0.00             | 0.00                  | 0.00           | 4750.00         |             | Yes           |                   |     | 2372030           |                          |                   | Aug              |
#    | AEBTO-CL1819            | 10017616 | 10017616 Co Ltd |               |                      | AECL-616                 | MAIN-616       | ESFA-616                | 01/08/2018                  | 31/07/2019                | 1                     | Approved       | Approved          |                        | Adult Education Budget - Community Learning |                   | 9                 | 2018            | 2018/19       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |     | 2372030           |                          |                   | Sep              |
#    | AEBTO-CL1819            | 10017616 | 10017616 Co Ltd |               |                      | AECL-616                 | MAIN-616       | ESFA-616                | 01/08/2018                  | 31/07/2019                | 1                     | Approved       | Approved          |                        | Adult Education Budget - Community Learning |                   | 10                | 2018            | 2018/19       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |     | 2372030           |                          |                   | Oct              |
#    | AEBTO-CL1819            | 10017616 | 10017616 Co Ltd |               |                      | AECL-616                 | MAIN-616       | ESFA-616                | 01/08/2018                  | 31/07/2019                | 1                     | Approved       | Approved          |                        | Adult Education Budget - Community Learning |                   | 11                | 2018            | 2018/19       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |     | 2372030           |                          |                   | Nov              |
#    | AEBTO-CL1819            | 10017616 | 10017616 Co Ltd |               |                      | AECL-616                 | MAIN-616       | ESFA-616                | 01/08/2018                  | 31/07/2019                | 1                     | Approved       | Approved          |                        | Adult Education Budget - Community Learning |                   | 12                | 2018            | 2018/19       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |     | 2372030           |                          |                   | Dec              |
#    | AEBTO-CL1819            | 10017616 | 10017616 Co Ltd |               |                      | AECL-616                 | MAIN-616       | ESFA-616                | 01/08/2018                  | 31/07/2019                | 1                     | Approved       | Approved          |                        | Adult Education Budget - Community Learning |                   | 1                 | 2019            | 2018/19       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |     | 2372030           |                          |                   | Jan              |
#    | AEBTO-CL1819            | 10017616 | 10017616 Co Ltd |               |                      | AECL-616                 | MAIN-616       | ESFA-616                | 01/08/2018                  | 31/07/2019                | 1                     | Approved       | Approved          |                        | Adult Education Budget - Community Learning |                   | 2                 | 2019            | 2018/19       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |     | 2372030           |                          |                   | Feb              |
#    | AEBTO-CL1819            | 10017616 | 10017616 Co Ltd |               |                      | AECL-616                 | MAIN-616       | ESFA-616                | 01/08/2018                  | 31/07/2019                | 1                     | Approved       | Approved          |                        | Adult Education Budget - Community Learning |                   | 3                 | 2019            | 2018/19       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |     | 2372030           |                          |                   | Mar              |
#    | AEBTO-CL1819            | 10017616 | 10017616 Co Ltd |               |                      | AECL-616                 | MAIN-616       | ESFA-616                | 01/08/2018                  | 31/07/2019                | 1                     | Approved       | Approved          |                        | Adult Education Budget - Community Learning |                   | 4                 | 2019            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |     | 2372030           |                          |                   | Apr              |
#    | AEBTO-CL1819            | 10017616 | 10017616 Co Ltd |               |                      | AECL-616                 | MAIN-616       | ESFA-616                | 01/08/2018                  | 31/07/2019                | 1                     | Approved       | Approved          |                        | Adult Education Budget - Community Learning |                   | 5                 | 2019            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |     | 2372030           |                          |                   | May              |
#    | AEBTO-CL1819            | 10017616 | 10017616 Co Ltd |               |                      | AECL-616                 | MAIN-616       | ESFA-616                | 01/08/2018                  | 31/07/2019                | 1                     | Approved       | Approved          |                        | Adult Education Budget - Community Learning |                   | 6                 | 2019            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |     | 2372030           |                          |                   | Jun              |
#    | AEBTO-CL1819            | 10017616 | 10017616 Co Ltd |               |                      | AECL-616                 | MAIN-616       | ESFA-616                | 01/08/2018                  | 31/07/2019                | 1                     | Approved       | Approved          |                        | Adult Education Budget - Community Learning |                   | 7                 | 2019            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |     | 2372030           |                          |                   | Jul              |

    # Tidy up
    And   the override date is reset
  
