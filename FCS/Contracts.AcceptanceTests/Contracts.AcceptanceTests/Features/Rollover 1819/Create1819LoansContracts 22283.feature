Feature: Create1819LoansContracts 22283

@AcceptanceTest @Withdrawn20201209
Scenario: A436 Bulk load a new 1819 LOANS contract with ALLB(PoA), ALLF(NoPay) and CLP(PoA) allocations. Check docs. Publish and approve
    Given there is no Contract, Task or Workflow data for UKPRN '10017436' 

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017436' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017436 Co Ltd' with UKPRN '10017436' and OrgId 'ORG0017436' and has 'FCS1 Test' as a manager 
    And   UPIN '117436' is associated with UKPRN '10017436' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017436 | 117436 | 10017436 Co Ltd | 0              | Active | Yes           | AA017436      | ?             | 

    # Change the date
    And   the override date is '02/04/2018'

    # Bulk import to create a new LOANS contract
    And   there are no files prefixed '10017436_LOANS' in the Sharepoint 'LOANS-1819-Input-Appendices' folder
    And   there are no files prefixed 'LOANS AY 1819 22032018120727 v2_A436' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'LOANS AY 1819 22032018120727 v2_A436' in the Sharepoint 'Reports' folder
    And   spreadsheet 'LOANS AY 1819 22032018120727 v2_A436.xlsx' exists in the Datafiles folder and UKPRN '10017436' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017436' for FundingType 'LOANS' and period '1819' and Delivery Organisation '10174361'
    And   I retrieve the latest contract details from CRM for provider '10017436' for FundingType 'LOANS' and period '1819'

    # Check the contents of the Appendices
    And   a file for this contract exists in sharepoint location 'LOANS-1819-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    APPENDIX 1 - SUMMARY OF FUNDING 2018/19
    Organisation Name: 10017436 Co Ltd
    UKPRN: 10017436
    Maximum Values
    Ref Aug 18 - Mar 19 Apr 19 - Jul 19 2018/19 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £15,343 £6,590 £21,933
    Career Learning Pilots [AllocRef_CLP] £17,286 £9,380 £26,666
	Advanced Learner Loans Bursary [AllocRef_ALLB] £27,302 £10,751 £38,053
    Total Funding for this agreement £86,652
    Appendix 1 2018/19 Master ref: [MasterContractNo]
    Funding Agreement Career Learning Pilots
    Provider: 10017436 Co Ltd UKPRN: 10017436
    Master Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Agreement Ref: [AllocRef_CLP]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Career Learning Pilots £26,666 £1,548 £2,487 £1,991 £4,794 £1,337 £3,122 £88 £1,919 £1,377 £372 £3,386 £4,245
    Total Funding £26,666 £1,548 £2,487 £1,991 £4,794 £1,337 £3,122 £88 £1,919 £1,377 £372 £3,386 £4,245
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    Funding Agreement Advanced Learner Loans Bursary
    Provider: 10017436 Co Ltd UKPRN: 10017436
    Master Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Agreement Ref: [AllocRef_ALLB]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Advanced Learner Loans Bursary Funding £38,053 £4,321 £3,911 £2,820 £4,777 £3,858 £2,979 £4,301 £335 £3,646 £3,613 £2,397 £1,095
    Total Funding £38,053 £4,321 £3,911 £2,820 £4,777 £3,858 £2,979 £4,301 £335 £3,646 £3,613 £2,397 £1,095
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
	"""

    # Appendix 2 (Funding Agreement) should never be produced for ALLF
    And   the pdf file does not contain the following line
    """
    Funding Agreement Advanced Learner Loans Facility
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
   #And   there are 'nnn' deliverable periods in CRM linked to the latest version of contract 'xxxx-436' and allocation 'xxxx-436' 
   #And   there are 'nnn' deliverable period rows in CRM linked to the latest version of contract 'xxxx-436' 
    And   there are '108' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 

	# Tidy up
    And   the override date is reset
	
@AcceptanceTest @Withdrawn20201209
Scenario: A437 Bulk load a new 1819 LOANS contract with ALLBC(PoP) and ALLF(NoPay) allocations. Check docs. Publish and approve
    Given there is no Contract, Task or Workflow data for UKPRN '10017437' 

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017437' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017437 Co Ltd' with UKPRN '10017437' and OrgId 'ORG0017437' and has 'FCS1 Test' as a manager 
    And   UPIN '117437' is associated with UKPRN '10017437' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017437 | 117437 | 10017437 Co Ltd | 0              | Active | Yes           | AA017437      | ?             | 

    # Change the date
    And   the override date is '02/04/2018'

    # Bulk import to create a new LOANS contract
    And   there are no files prefixed '10017437_LOANS' in the Sharepoint 'LOANS-1819-Input-Appendices' folder
    And   there are no files prefixed 'LOANS AY 1819 22032018120821 v2_A437' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'LOANS AY 1819 22032018120821 v2_A437' in the Sharepoint 'Reports' folder
    And   spreadsheet 'LOANS AY 1819 22032018120821 v2_A437.xlsx' exists in the Datafiles folder and UKPRN '10017437' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017437' for FundingType 'LOANS' and period '1819' and Delivery Organisation '10174371'
    And   I retrieve the latest contract details from CRM for provider '10017437' for FundingType 'LOANS' and period '1819'

    # Check the contents of the Appendices
    And   a file for this contract exists in sharepoint location 'LOANS-1819-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    APPENDIX 1 - SUMMARY OF FUNDING 2018/19
    Organisation Name: 10017437 Co Ltd
    UKPRN: 10017437
    Maximum Values
    Ref Aug 18 - Mar 19 Apr 19 - Jul 19 2018/19 Total
	Advanced Learner Loans Facility [AllocRef_ALLF] £21,619 £13,519 £35,138
    Advanced Learner Loans Bursary [AllocRef_ALLC] £25,793 £13,131 £38,924
    Total Funding for this agreement £74,062
    Appendix 1 2018/19 Master ref: [MasterContractNo]
    Funding Agreement Advanced Learner Loans Bursary
    Provider: 10017437 Co Ltd UKPRN: 10017437
    Master Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Agreement Ref: [AllocRef_ALLC]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Advanced Learner Loans Bursary Funding £38,924 £4,696 £2,124 £3,572 £2,865 £1,351 £4,577 £4,801 £1,807 £4,524 £4,960 £1,331 £2,316
    Total Funding £38,924 £4,696 £2,124 £3,572 £2,865 £1,351 £4,577 £4,801 £1,807 £4,524 £4,960 £1,331 £2,316
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
	"""

	# Appendix 2 (Funding Agreement) should never be produced for ALLF
    And   the pdf file does not contain the following line
    """
    Funding Agreement Advanced Learner Loans Facility
    """

	# Appendix 2 (Funding Agreement) should not have been produced for CLP (It is not included in the bulk file for this contract)
	And   the pdf file does not contain the following line
    """
    Funding Agreement Career Learning Pilots
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
   #And   there are 'nn' deliverable periods in CRM linked to the latest version of contract 'xxxx-437' and allocation 'xxxx-437' 
   #And   there are 'nn' deliverable period rows in CRM linked to the latest version of contract 'xxxx-437' 
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 

	# Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20200604
@HighValue
@Long2Run @Long2Run45
Scenario: A438 Create an 1819 LOANS contract with ALLB (PoA), ALLF (NoPay) and CLP (PoA) allocations. Bulk update draft. Step through Tasks until Published then approve. Consume actuals and create payment files. Check CRM, Tasks, Financials, ADP feed and Payment Feed
    Given there are no allocations marked as Under Termination for UKPRN '10017438' 
    And   there are no terminated or closed allocations for UKPRN '10017438' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017438' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017438' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLB-438      |
    | ALLF-438      |
    | CLP-438       |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | ALLB1819       |
    | ALLF1819       |
    | CLP1819        |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017438' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017438 Co Ltd' with UKPRN '10017438' and OrgId 'ORG0017438' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017438' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017438 | 117438 | 10017438 Co Ltd | 0              | Provider Under Change | Yes           | AA017438      | ?             | 6 Clyde Street         | Canterbury             | Kent                   | ?                      | ?                      | ?                      | CT1 1NA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017438 |




    # Change the date
    Given the override date is '02/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017438 | 10017438 Co Ltd      | ESFA-438             | LOANS-438      | 1                     | 01/08/2018        | 31/07/2019      | 66857.00      |                                | Contract for Services | 1819   | New          | ORG0017438 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode    | AllocationDescription | CRMIntent    |
    | 10017438 | LOANS-438      | ALLB-438      | ALLB              | ALLB1819                | AY                      | 01/08/2018          | 31/07/2019        | 23168.00        |         |            |                       | New          | 
    | 10017438 | LOANS-438      | ALLF-438      | ALLF              | ALLF1819                | AY                      | 01/08/2018          | 31/07/2019        | 25313.00        |         |            |                       | New          |
    | 10017438 | LOANS-438      | CLP-438       | CLP               | CLP1819                 | AY                      | 01/08/2018          | 31/07/2019        | 18376.00        |         |            |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    |
    | 10017438 | LOANS-438      | ALLB-438      | 1               | 0                     | 23168.00  | 2024.00  | 2194.00  | 1121.00  | 1167.00  | 2917.00  | 101.00   | 2865.00  | 3064.00  | 2674.00  | 217.00   | 1582.00  | 3242.00  | Total Advanced Learner Loans Bursary Funding                    | New          |
    | 10017438 | LOANS-438      | ALLF-438      | 5               | 0                     | 25313.00  | 2759.00  | 1357.00  | 1049.00  | 3222.00  | 2230.00  | 2215.00  | 1528.00  | 388.00   | 1986.00  | 2446.00  | 3203.00  | 2930.00  | Advanced Learner Loans Facility                                 | New          |
    | 10017438 | LOANS-438      | CLP-438       | 1               | 0                     | 18376.00  | 128.00   | 1925.00  | 3211.00  | 1534.00  | 2389.00  | 1783.00  | 1822.00  | 1647.00  | 1269.00  | 1447.00  | 980.00   | 241.00   | Career Learning Pilots                                          | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'




    # Change the date
    Given the override date is '04/07/2018'

    # Bulk import to do an update draft on the LOANS contract
    And   there are no files prefixed '10017438_LOANS' in the Sharepoint 'LOANS-1819-Input-Appendices' folder
    And   there are no files prefixed 'LOANS AY 1819 22032018150353 v2_A438' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'LOANS AY 1819 22032018150353 v2_A438' in the Sharepoint 'Reports' folder
    And   spreadsheet 'LOANS AY 1819 22032018150353 v2_A438.xlsx' exists in the Datafiles folder and UKPRN '10017438' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

#    # Create a dummy Appendix file containing just the work 'Appendices'
#    Given there are no files prefixed '10017438_LOANS-438' in the Sharepoint 'LOANS-1819-Input-Appendices' folder
#    And   a file with filename '10017438_LOANS-438_v1.pdf' is created in 'LOANS-1819-Input-Appendices'

    # Create two dummy Terms and Conditions files. Each has just one page containing just the work 'Appendices'
    Given there are no files prefixed '10017438_LOANS-438' in the Sharepoint 'LOANS-1819-Input-Terms And Conditions' folder
    And   a file with filename '10017438_LOANS-438_11.pdf' is created in 'LOANS-1819-Input-Terms And Conditions'
    And   a file with filename '10017438_LOANS-438_61.pdf' is created in 'LOANS-1819-Input-Terms And Conditions'




    # Change the date
    Given the override date is '06/07/2018'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When the following open Task currently linked to version '1' of contract 'LOANS-438' for provider '10017438' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'LOANS-438' for provider '10017438'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017438 - 10017438 Co Ltd Please review the contract       | LOANS-438      | FCS2 Test                 | Contract Advisers Team   | Open            | Not Started      |


    # Change the date
    Given the override date is '08/07/2018'

    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When the following open Task currently linked to version '1' of contract 'LOANS-438' for provider '10017438' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'LOANS-438' for provider '10017438'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017438 - 10017438 Co Ltd                                  | LOANS-438      | FCS1 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Change the date
    Given the override date is '10/07/2018'

    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When the following open Task currently linked to version '1' of contract 'LOANS-438' for provider '10017438' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'LOANS-438' for provider '10017438'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017438 - 10017438 Co Ltd                                  | LOANS-438      | Lead Manager Team         | ?                        | Open            | Not Started      |


    # Change the date
    Given the override date is '12/07/2018'

    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When the following open Task currently linked to version '1' of contract 'LOANS-438' for provider '10017438' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |


    # Check that the Tasks on the contract are all marked as completed
    Then  the following Tasks are present against version '1' of contract 'LOANS-438' for provider '10017438'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017438 - 10017438 Co Ltd                                  | LOANS-438      | Lead Manager Team         | ?                        | Completed       | Completed        |
    | Confirm Internal Approval        | 10017438 - 10017438 Co Ltd                                  | LOANS-438      | FCS1 Test                 | Contract Managers Team   | Completed       | Completed        |
    | Review Contract Details          | 10017438 - 10017438 Co Ltd Please review the contract       | LOANS-438      | FCS2 Test                 | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017438 - 10017438 Co Ltd Awaiting documentation           | LOANS-438      | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM, post-approval
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017438 | LOANS-438          | 1                     | 1                        | Draft            | Published to Provider     | True          | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017438 | LOANS-438          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017438 | ESFA-438           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Change the date
    Given the override date is '14/07/2018'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-438' and actual ContractNumber 'LOANS-438'

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017438 | LOANS-438          | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017438 | LOANS-438          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017438 | ESFA-438           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM 
    And   there are '108' deliverable period rows in CRM linked to the latest version of contract 'LOANS-438'

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-438      | ALLB-438        | 1               | 22193.00 | 2174.00  | 1764.00  | 673.00   | 2630.00  | 1711.00  | 832.00   | 2154.00  | 3139.00  | 1500.00  | 1467.00  | 250.00   | 3899.00  | 
    | LOANS-438      | ALLB-438        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-438      | ALLB-438        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-438      | ALLB-438        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-438      | ALLF-438        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-438      | ALLF-438        | 5               | 36169.00 | 4164.00  | 3754.00  | 2663.00  | 4620.00  | 3701.00  | 2822.00  | 4144.00  | 178.00   | 3489.00  | 3456.00  | 2240.00  | 938.00   | 
    | LOANS-438      | ALLF-438        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-438      | ALLF-438        | 7               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-438      | CLP-438         | 1               | 36018.00 | 3838.00  | 1015.00  | 2211.00  | 3573.00  | 1808.00  | 3468.00  | 2126.00  | 2516.00  | 4981.00  | 3851.00  | 3606.00  | 3025.00  | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualValue |
    | ALLB-438         | 1             | 1               | 201808 | 2              | 0             | 2174.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLB-438         | 1             | 1               | 201809 | 2              | 0             | 1764.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLB-438         | 1             | 1               | 201810 | 2              | 0             | 673.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLB-438         | 1             | 1               | 201811 | 2              | 0             | 2630.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLB-438         | 1             | 1               | 201812 | 2              | 0             | 1711.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLB-438         | 1             | 1               | 201901 | 2              | 0             | 832.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLB-438         | 1             | 1               | 201902 | 2              | 0             | 2154.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLB-438         | 1             | 1               | 201903 | 2              | 0             | 3139.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLB-438         | 1             | 1               | 201904 | 2              | 0             | 1500.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLB-438         | 1             | 1               | 201905 | 2              | 0             | 1467.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLB-438         | 1             | 1               | 201906 | 2              | 0             | 250.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLB-438         | 1             | 1               | 201907 | 2              | 0             | 3899.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | ALLF-438         | 1             | 5               | 201808 | 2              | 0             | 4164.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-438         | 1             | 5               | 201809 | 2              | 0             | 3754.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-438         | 1             | 5               | 201810 | 2              | 0             | 2663.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-438         | 1             | 5               | 201811 | 2              | 0             | 4620.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-438         | 1             | 5               | 201812 | 2              | 0             | 3701.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-438         | 1             | 5               | 201901 | 2              | 0             | 2822.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-438         | 1             | 5               | 201902 | 2              | 0             | 4144.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-438         | 1             | 5               | 201903 | 2              | 0             | 178.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-438         | 1             | 5               | 201904 | 2              | 0             | 3489.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-438         | 1             | 5               | 201905 | 2              | 0             | 3456.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-438         | 1             | 5               | 201906 | 2              | 0             | 2240.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-438         | 1             | 5               | 201907 | 2              | 0             | 938.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | CLP-438          | 1             | 1               | 201808 | 2              | 0             | 3838.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | CLP-438          | 1             | 1               | 201809 | 2              | 0             | 1015.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | CLP-438          | 1             | 1               | 201810 | 2              | 0             | 2211.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | CLP-438          | 1             | 1               | 201811 | 2              | 0             | 3573.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | CLP-438          | 1             | 1               | 201812 | 2              | 0             | 1808.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | CLP-438          | 1             | 1               | 201901 | 2              | 0             | 3468.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | CLP-438          | 1             | 1               | 201902 | 2              | 0             | 2126.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | CLP-438          | 1             | 1               | 201903 | 2              | 0             | 2516.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | CLP-438          | 1             | 1               | 201904 | 2              | 0             | 4981.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | CLP-438          | 1             | 1               | 201905 | 2              | 0             | 3851.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | CLP-438          | 1             | 1               | 201906 | 2              | 0             | 3606.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | CLP-438          | 1             | 1               | 201907 | 2              | 0             | 3025.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
	
    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
	| AllocationRef | Subnominal Code | Period | Payment Type   |
	| ALLB-438      | 2303800         | Jul-19 | Reconciliation |
	| CLP-438       | 2206500         | Jul-19 | Reconciliation |
   



   # Change the date
    Given the override date is '07/09/2018'

    # Clear down the summarised actuals
    And   there are no entries in the DCFS stub table

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject and consume DCFS-format summarised actuals for ALLF for August 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201808 | ALLF1819                | ALLF-438                 |         | 2               | 0            | 808.09      | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201809 | ALLF1819                | ALLF-438                 |         | 2               | 0            | 1222.00     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201810 | ALLF1819                | ALLF-438                 |         | 2               | 0            | 1105.00     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201811 | ALLF1819                | ALLF-438                 |         | 2               | 0            | 169.00      | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201812 | ALLF1819                | ALLF-438                 |         | 2               | 0            | 377.00      | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201901 | ALLF1819                | ALLF-438                 |         | 2               | 0            | 845.00      | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201902 | ALLF1819                | ALLF-438                 |         | 2               | 0            | 64.90       | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201903 | ALLF1819                | ALLF-438                 |         | 2               | 0            | 559.00      | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201904 | ALLF1819                | ALLF-438                 |         | 2               | 0            | 1612.00     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201905 | ALLF1819                | ALLF-438                 |         | 2               | 0            | 1017.00     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201906 | ALLF1819                | ALLF-438                 |         | 2               | 0            | 1118.00     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201907 | ALLF1819                | ALLF-438                 |         | 2               | 0            | 143.00      | 
    #
    | ALLF           | A01                  | ORG0017438     | CM             | 201808 | ALLF1819                | ALLF-438                 |         | 6               | 0            | 55.65       | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201809 | ALLF1819                | ALLF-438                 |         | 6               | 0            | 1300.00     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201810 | ALLF1819                | ALLF-438                 |         | 6               | 0            | 1079.00     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201811 | ALLF1819                | ALLF-438                 |         | 6               | 0            | 1438.00     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201812 | ALLF1819                | ALLF-438                 |         | 6               | 0            | 1014.00     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201901 | ALLF1819                | ALLF-438                 |         | 6               | 0            | 1742.00     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201902 | ALLF1819                | ALLF-438                 |         | 6               | 0            | 31.19       | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201903 | ALLF1819                | ALLF-438                 |         | 6               | 0            | 1534.00     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201904 | ALLF1819                | ALLF-438                 |         | 6               | 0            | 1755.00     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201905 | ALLF1819                | ALLF-438                 |         | 6               | 0            | 1495.00     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201906 | ALLF1819                | ALLF-438                 |         | 6               | 0            | 1924.00     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201907 | ALLF1819                | ALLF-438                 |         | 6               | 0            | 624.00      | 
    #
    | ALLF           | A01                  | ORG0017438     | CM             | 201808 | ALLF1819                | ALLF-438                 |         | 7               | 0            | 567.89      | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201809 | ALLF1819                | ALLF-438                 |         | 7               | 0            | 1339.00     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201810 | ALLF1819                | ALLF-438                 |         | 7               | 0            | 1391.00     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201811 | ALLF1819                | ALLF-438                 |         | 7               | 0            | 1625.00     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201812 | ALLF1819                | ALLF-438                 |         | 7               | 0            | 559.00      | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201901 | ALLF1819                | ALLF-438                 |         | 7               | 0            | 364.00      | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201902 | ALLF1819                | ALLF-438                 |         | 7               | 0            | 3255.65     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201903 | ALLF1819                | ALLF-438                 |         | 7               | 0            | 1547.00     | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201904 | ALLF1819                | ALLF-438                 |         | 7               | 0            | 689.00      | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201905 | ALLF1819                | ALLF-438                 |         | 7               | 0            | 923.00      | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201906 | ALLF1819                | ALLF-438                 |         | 7               | 0            | 934.20      | 
    | ALLF           | A01                  | ORG0017438     | CM             | 201907 | ALLF1819                | ALLF-438                 |         | 7               | 0            | 1950.00     | 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUALS in CRM
    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-438      | ALLF-438        | 2               | 9039.99  | 808.09   | 1222.00  | 1105.00  | 169.00   | 377.00   | 845.00   | 64.90    | 559.00   | 1612.00  | 1017.00  | 1118.00  | 143.00   | 
    | LOANS-438      | ALLF-438        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-438      | ALLF-438        | 6               | 13991.84 | 55.65    | 1300.00  | 1079.00  | 1438.00  | 1014.00  | 1742.00  | 31.19    | 1534.00  | 1755.00  | 1495.00  | 1924.00  | 624.00   | 
    | LOANS-438      | ALLF-438        | 7               | 15144.74 | 567.89   | 1339.00  | 1391.00  | 1625.00  | 559.00   | 364.00   | 3255.65  | 1547.00  | 689.00   | 923.00   | 934.20   | 1950.00  | 

    # Actuals are not paid by the SFA but Reconciliation fields will have non-zero values for deliverable 7 to reflect what has been paid by the Student Loans Company 
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-438      | ALLF-438        | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-438      | ALLF-438        | 5               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-438      | ALLF-438        | 6               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-438      | ALLF-438        | 7               | 567.89   | 567.89   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Actuals are not paid by the SFA but Net fields will have non-zero values for deliverable 7 to reflect what has been paid by the Student Loans Company 
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-438      | ALLF-438        | 2               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-438      | ALLF-438        | 5               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-438      | ALLF-438        | 6               | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-438      | ALLF-438        | 7               | 567.89   | 567.89   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the ACTUAL totals in CRM at deliverable level rather than deliverable period level (24295)
    And   the Actuals Data is stored in CRM at deliverable level against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | ActualValue | ActualVolume |
    | LOANS-438      | ALLF-438        | 2               | 9039.99     | 0            |
	| LOANS-438      | ALLF-438        | 5               | 38176.57    | ?            |
	| LOANS-438      | ALLF-438        | 6               | 13991.84    | 0            |
	| LOANS-438      | ALLF-438        | 7               | 15144.74    | 0            |




    # Change the date
    Given the override date is '06/01/2019'

    # Clear down the summarised actuals
    And   there are no entries in the DCFS stub table

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Consume DCFS summarised actuals for ALLB and CLP for December 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201808 | ALLB1819                | ALLB-438                 |         | 2               | 0            | 2134.28     | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201809 | ALLB1819                | ALLB-438                 |         | 2               | 0            | 2021.16     | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201810 | ALLB1819                | ALLB-438                 |         | 2               | 0            | 1825.55     | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201811 | ALLB1819                | ALLB-438                 |         | 2               | 0            | 1616.50     | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201812 | ALLB1819                | ALLB-438                 |         | 2               | 0            | 1431.00     | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201901 | ALLB1819                | ALLB-438                 |         | 2               | 0            | 1312.70     | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201902 | ALLB1819                | ALLB-438                 |         | 2               | 0            | 1100.98     | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201903 | ALLB1819                | ALLB-438                 |         | 2               | 0            | 1008.44     | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201904 | ALLB1819                | ALLB-438                 |         | 2               | 0            | 816.32      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201905 | ALLB1819                | ALLB-438                 |         | 2               | 0            | 618.03      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201906 | ALLB1819                | ALLB-438                 |         | 2               | 0            | 442.65      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201907 | ALLB1819                | ALLB-438                 |         | 2               | 0            | 202.03      | 
    #
    | ILR1819        | R01                  | ORG0017438     | CM             | 201808 | ALLB1819                | ALLB-438                 |         | 3               | 0            | 1028.54     | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201809 | ALLB1819                | ALLB-438                 |         | 3               | 0            | 856.99      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201810 | ALLB1819                | ALLB-438                 |         | 3               | 0            | 811.23      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201811 | ALLB1819                | ALLB-438                 |         | 3               | 0            | 743.50      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201812 | ALLB1819                | ALLB-438                 |         | 3               | 0            | 712.00      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201901 | ALLB1819                | ALLB-438                 |         | 3               | 0            | 608.67      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201902 | ALLB1819                | ALLB-438                 |         | 3               | 0            | 588.41      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201903 | ALLB1819                | ALLB-438                 |         | 3               | 0            | 492.36      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201904 | ALLB1819                | ALLB-438                 |         | 3               | 0            | 418.09      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201905 | ALLB1819                | ALLB-438                 |         | 3               | 0            | 367.81      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201906 | ALLB1819                | ALLB-438                 |         | 3               | 0            | 201.45      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201907 | ALLB1819                | ALLB-438                 |         | 3               | 0            | 100.05      | 
    #
    | ILR1819        | R01                  | ORG0017438     | CM             | 201808 | ALLB1819                | ALLB-438                 |         | 4               | 0            | 124.87      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201809 | ALLB1819                | ALLB-438                 |         | 4               | 0            | 43.07       | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201810 | ALLB1819                | ALLB-438                 |         | 4               | 0            | 58.09       | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201811 | ALLB1819                | ALLB-438                 |         | 4               | 0            | 16.21       | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201812 | ALLB1819                | ALLB-438                 |         | 4               | 0            | 88.08       | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201901 | ALLB1819                | ALLB-438                 |         | 4               | 0            | 70.75       | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201902 | ALLB1819                | ALLB-438                 |         | 4               | 0            | 339.12      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201903 | ALLB1819                | ALLB-438                 |         | 4               | 0            | 82.67       | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201904 | ALLB1819                | ALLB-438                 |         | 4               | 0            | 67.10       | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201905 | ALLB1819                | ALLB-438                 |         | 4               | 0            | 51.44       | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201906 | ALLB1819                | ALLB-438                 |         | 4               | 0            | 43.17       | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201907 | ALLB1819                | ALLB-438                 |         | 4               | 0            | 12.85       | 
    #
    | ILR1819        | R01                  | ORG0017438     | CM             | 201808 | CLP1819                 | CLP-438                  |         | 1               | 0            | 31729.70    | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201809 | CLP1819                 | CLP-438                  |         | 1               | 0            | 1534.28     | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201810 | CLP1819                 | CLP-438                  |         | 1               | 0            | 1346.87     | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201811 | CLP1819                 | CLP-438                  |         | 1               | 0            | 1205.70     | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201812 | CLP1819                 | CLP-438                  |         | 1               | 0            | 1187.57     | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201901 | CLP1819                 | CLP-438                  |         | 1               | 0            | 1002.50     | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201902 | CLP1819                 | CLP-438                  |         | 1               | 0            | 985.00      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201903 | CLP1819                 | CLP-438                  |         | 1               | 0            | 901.05      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201904 | CLP1819                 | CLP-438                  |         | 1               | 0            | 865.90      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201905 | CLP1819                 | CLP-438                  |         | 1               | 0            | 784.56      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201906 | CLP1819                 | CLP-438                  |         | 1               | 0            | 606.40      | 
    | ILR1819        | R01                  | ORG0017438     | CM             | 201907 | CLP1819                 | CLP-438                  |         | 1               | 0            | 585.75      | 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUALS in CRM
    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-438      | ALLB-438        | 2               | 9028.49  | 2134.28  | 2021.16  | 1825.55  | 1616.50  | 1431.00  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-438      | ALLB-438        | 3               | 4152.26  | 1028.54  | 856.99   | 811.23   | 743.50   | 712.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-438      | ALLB-438        | 4               | 330.32   | 124.87   | 43.07    | 58.09    | 16.21    | 88.08    | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-438      | CLP-438         | 1               | 37004.12 | 31729.70 | 1534.28  | 1346.87  | 1205.70  | 1187.57  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-438      | ALLB-438        | 2               | 9028.49  | 0.00     | 0.00     | 0.00     | 0.00     | 9028.49  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-438      | ALLB-438        | 3               | 4152.26  | 0.00     | 0.00     | 0.00     | 0.00     | 4152.26  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-438      | ALLB-438        | 4               | 330.32   | 0.00     | 0.00     | 0.00     | 0.00     | 330.32   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-438      | CLP-438         | 1               | 37004.12 | 0.00     | 0.00     | 0.00     | 0.00     | 37004.12 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-438      | ALLB-438        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-438      | ALLB-438        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-438      | ALLB-438        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-438      | CLP-438         | 1               | -16449.12| 0.00     | 0.00     | 0.00     | 0.00     | -16449.12| ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-438      | ALLB-438        | 2               | 9028.49  | 0.00     | 0.00     | 0.00     | 0.00     | 9028.49  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-438      | ALLB-438        | 3               | 4152.26  | 0.00     | 0.00     | 0.00     | 0.00     | 4152.26  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-438      | ALLB-438        | 4               | 330.32   | 0.00     | 0.00     | 0.00     | 0.00     | 330.32   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | LOANS-438      | CLP-438         | 1               | 20555.00 | 0.00     | 0.00     | 0.00     | 0.00     | 20555.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualValue |
    | CLP-438          | 1             | 1               | 201808 | 2              | 0             | 3838.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 31729.70    |
    | CLP-438          | 1             | 1               | 201809 | 2              | 0             | 1015.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 1534.28     |
    | CLP-438          | 1             | 1               | 201810 | 2              | 0             | 2211.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 1346.87     |
    | CLP-438          | 1             | 1               | 201811 | 2              | 0             | 3573.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 1205.70     |
    | CLP-438          | 1             | 1               | 201812 | 2              | 0             | 1808.00      | 0.00                 | -16449.12           | 0.00                   | 37004.12                    | 20555.00         | 1187.57     |
    | CLP-438          | 1             | 1               | 201901 | 2              | 0             | 3468.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | CLP-438          | 1             | 1               | 201902 | 2              | 0             | 2126.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | CLP-438          | 1             | 1               | 201903 | 2              | 0             | 2516.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | CLP-438          | 1             | 1               | 201904 | 2              | 0             | 4981.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | CLP-438          | 1             | 1               | 201905 | 2              | 0             | 3851.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | CLP-438          | 1             | 1               | 201906 | 2              | 0             | 3606.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | CLP-438          | 1             | 1               | 201907 | 2              | 0             | 3025.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts in CRM are as follows
    | ContractNumber | AllocationRef   | ReconciliationSubnominal | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18    |
    | LOANS-438      | ALLB-438        | 2303800                  | 0.00     | 0.00     | 0.00     | 0.00     | 13511.07  | 
    | LOANS-438      | CLP-438         | 2206500                  | 0.00     | 0.00     | 0.00     | 0.00     | 37004.12  | 

    # Check the CAPPING subnominal aggregations in CRM
    And   the Capping Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef   | CappingSubnominal        | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18    |
    | LOANS-438      | ALLB-438        | 2303800                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00      | 
    | LOANS-438      | CLP-438         | 2206500                  | 0.00     | 0.00     | 0.00     | 0.00     | -16449.12 | 

    # Set dates for payment run for ALLB and CLP
    Given the override date is '08/01/2019 22:05'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
	# Note: PaymentPeriod is the accounting year and month, eg for April 2018 the value would be 201801 not 201804
    Given there is no data in the Payment feed for FundingStreamPeriod 'ALLB1819' AccountingPaymentPeriod '201809' CensusEndDate '08/01/2019' and LinkCodeSuffix 'A'
    And   there is no data in the Payment feed for FundingStreamPeriod 'CLP1819' AccountingPaymentPeriod '201809' CensusEndDate '08/01/2019' and LinkCodeSuffix 'A'
    
#   # Delete all NAT, PAY and ERR files from the Maytech FTP server
#   And   there are no files on the Maytech FTP server
     
    # PaymentGeneration.PaymentTimetable
    And   the below configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ALLB1819                   | 201812               |                      | A              | NotStarted |
    | CLP1819                    | 201812               |                      | A              | NotStarted |

#    # Coda.AccountCode
#    And   the below configuration exists in the Account Codes table
#    | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#    | 10017438 | ALLB1819                   | CODA438   | 8113000      | 01/04/1990           | 31/03/2020         |
#    | 10017438 | CLP1819                    | CODC438   | 8113000      | 01/04/1990           | 31/03/2020         |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ALLB1819                   | 201812               | Completed |
    | CLP1819                    | 201812               | Completed |

#    # File created in Maytech FTP folder for 'Advanced Learner Loans Bursary'
#    And   Payment file 'LBT20180908A.pay' is created in the FTP Folder
#
#    # Decrypt the payment file to the Output window and save a decrypted version to Datafiles/Downloads
#    Given there is an encrypted file called 'LBT20180908A.pay' in the Maytech FTP folder decrypt it then save it to 'DataFiles/Downloads'
#
#    Then  the following details are present in payment file 'LBT20180908A.pay'
#    | LinkCode    | CompanyCode | Element1 | Element2 | Element3 | Element4 | Element5 | Element6 | Element7 | Element8 | Year | Period | Date       | Amount   | Dc   | LineType | Doc     | Desc                            | DueDate    | Tax | Extref1                       | Extref2     | Extref3 | Extref4 | Extref5  | Extref6 | Num   | DocLineNo |
#    | LBT180908A  | SFA         | AAA40    | +        | 8113000  | CODA438  | 02       | ALLB-438 | ?        | ?        | 2018 | 09     | 08/01/2019 | 13511.07 | 160  | 157      | LBTR    | Adv LL Bursary Rec Jan19        | 16/01/2019 | ?   | ALLB RECONCILIATION 2018/19   | LBT180908A  | ?       | ?       | 10017438 | 2303800 | 1     | 1         |
#    | LBT180908A  | SFA         | AAA40    | +        | 2303800  | 5000     | 02       | ALLB-438 | ?        | ?        | 2018 | 09     | 08/01/2019 | 13511.07 | 161  | 158      | LBTR    | Adv LL Bursary Rec Jan19        | 16/01/2019 | VIO | ALLB RECONCILIATION 2018/19   | LBT180908A  | ?       | ?       | 10017438 | CODA438 | 1     | 2         |

    # Check the Payment feed for ALLB

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLB1819' PaymentPeriod '201809' CensusEndDate '08/01/2019' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A438_ALLB.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLB1819' PaymentPeriod '201809' CensusEndDate '08/01/2019' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | LBT                    | 2018          | 09             | 08          | ?       | ALLB-438      | 13511.07        | RECONCILIATION   | Adv LL Bursary                     | 2019-01-16 | 2018-08-01   | 2019-07-31 | ?              | 10017438 | 2303800    |

#    # File created in Maytech FTP folder for 'Career Learning Pilots'
#    And   Payment file 'CLP20180908A.pay' is created in the FTP Folder
#
#    # Save a copy of the output to the datafiles/Downloads folder
#    Given there is an encrypted file called 'CLP20180908A.pay' in the Maytech FTP folder decrypt it then save it to 'DataFiles/Downloads'
#
#    Then  the following details are present in payment file 'CLP20180908A.pay'
#    | LinkCode    | CompanyCode | Element1 | Element2 | Element3 | Element4 | Element5 | Element6   | Element7 | Element8 | Year | Period | Date       | Amount   | Dc   | LineType | Doc     | Desc                            | DueDate    | Tax | Extref1                       | Extref2     | Extref3      | Extref4 | Extref5  | Extref6 | Num   | DocLineNo |
#    | CLP180908A  | SFA         | AAA40    | +        | 8113000  | CODC438  | 02       | CLP-438    | ?        | ?        | 2018 | 09     | 08/01/2019 | 16449.12 | 161  | 157      | CLPC    | CareerLearningPilots Cap Jan19  | 16/01/2019 | ?   | CLP PAYMENT CAP 2018/19       | CLP180908A  | ?            | ?       | 10017438 | 2206500 | 1     | 1         |
#    | CLP180908A  | SFA         | AAA40    | +        | 2206500  | 5000     | 02       | CLP-438    | ?        | ?        | 2018 | 09     | 08/01/2019 | 16449.12 | 160  | 158      | CLPC    | CareerLearningPilots Cap Jan19  | 16/01/2019 | VIO | CLP PAYMENT CAP 2018/19       | CLP180908A  | ?            | ?       | 10017438 | CODC438 | 1     | 2         |
#    | CLP180908A  | SFA         | AAA40    | +        | 8113000  | CODC438  | 02       | CLP-438    | ?        | ?        | 2018 | 09     | 08/01/2019 | 37004.12 | 160  | 157      | CLPR    | CareerLearningPilots Rec Jan19  | 16/01/2019 | ?   | CLP RECONCILIATION 2018/19    | CLP180908A  | ?            | ?       | 10017438 | 2206500 | 2     | 1         |
#    | CLP180908A  | SFA         | AAA40    | +        | 2206500  | 5000     | 02       | CLP-438    | ?        | ?        | 2018 | 09     | 08/01/2019 | 37004.12 | 161  | 158      | CLPR    | CareerLearningPilots Rec Jan19  | 16/01/2019 | VIO | CLP RECONCILIATION 2018/19    | CLP180908A  | ?            | ?       | 10017438 | CODC438 | 2     | 2         |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'CLP1819' PaymentPeriod '201809' CensusEndDate '08/01/2019' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A438_CLP.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'CLP1819' PaymentPeriod '201809' CensusEndDate '08/01/2019' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | CLP                    | 2018          | 09             | 08          | ?       | CLP-438       | -16449.12       | CAPPING          | CareerLearningPilots               | 2019-01-16 | 2018-08-01   | 2019-07-31 | ?              | 10017438 | 2206500    |
    | CLP                    | 2018          | 09             | 08          | ?       | CLP-438       | 37004.12        | RECONCILIATION   | CareerLearningPilots               | 2019-01-16 | 2018-08-01   | 2019-07-31 | ?              | 10017438 | 2206500    |

    # Check the AllocationDelivery.AllocationDeliveryEntry (ADP) feed for specific items and values (23186)
    And   the ADP feed includes the following values
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | ContractVersionNumber | SubVersionNumber | AllocationNumber | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    # ADCode 0 = New Approval
    | NewContractAllocationApproved     | 0      | LOANS-438      | 1                     | 0                | ALLB-438         | ?                         | ?                            | 
    | NewContractAllocationApproved     | 0      | LOANS-438      | 1                     | 0                | CLP-438          | ?                         | ?                            | 

#   # Check that payment files have not been created in the Maytech FTP folder (22121)
#   And   Payment file 'LBT20180908A.nat' is not present on the Maytech FTP server
#   And   Payment file 'LBT20180908A.pay' is not present on the Maytech FTP server
#   And   Payment file 'LBT20180908A.err' is not present on the Maytech FTP server
#   # It is possible that the payment files could be created AFTER this check is done. Check manually


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20200604
@Long2Run @Long2Run45
Scenario: A440 Create an 1819 LOANS contract with ALLBC (PoP) and ALLF (NoPay) allocations. Bulk update draft. Step through Tasks until Published then approve. Create PoP payment files. Check CRM, Tasks, Financials, PaaS, ADP feed and Payment feed
    Given there is no Contract, Task or Workflow data for UKPRN '10017440' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLC-440      |
    | ALLF-440      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017440' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017440 Co Ltd' with UKPRN '10017440' and OrgId 'ORG0017440' and has 'FCS1 Test' as a manager 
    And   UPIN '117440' is associated with UKPRN '10017440' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017440 | 117440 | 10017440 Co Ltd | 0              | Active | Yes           | AA017440      | ?             | 




    # Change the date
    Given the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017440 | 10017440 Co Ltd      | ESFA-440             | LOANS-440      | 1                     | 01/08/2018        | 31/07/2019      | 48834.00      |                                | Contract for Services | 1819   | New          | ORG0017440 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017440 | LOANS-440      | ALLC-440      | ALLBC             | ALLBC1819               | AY                      | 01/08/2018          | 31/07/2019        | 23168.00        |                         |            |                                                             | New          |             |
    | 10017440 | LOANS-440      | ALLF-440      | ALLF              | ALLF1819                | AY                      | 01/08/2018          | 31/07/2019        | 25666.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017440 | LOANS-440      | ALLC-440      | 1               | 0                     | 23168.00  | 2024.00  | 2194.00  | 1121.00  | 1167.00  | 2917.00  | 101.00   | 2865.00  | 3064.00  | 2674.00  | 217.00   | 1582.00  | 3242.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             |
    | 10017440 | LOANS-440      | ALLF-440      | 5               | 0                     | 25666.00  | 2975.00  | 1432.00  | 3610.00  | 3275.00  | 258.00   | 3564.00  | 1397.00  | 1992.00  | 2889.00  | 248.00   | 2242.00  | 1784.00  | Advanced Learner Loans Facility                                 | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Bulk import to do an update draft on the LOANS contract
    And   there are no files prefixed '10017440_LOANS' in the Sharepoint 'LOANS-1819-Input-Appendices' folder
    And   there are no files prefixed 'LOANS AY 1819 03052018142426 v2_A440' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'LOANS AY 1819 03052018142426 v2_A440' in the Sharepoint 'Reports' folder
    And   spreadsheet 'LOANS AY 1819 03052018142426 v2_A440.xlsx' exists in the Datafiles folder and UKPRN '10017440' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Create two dummy Terms and Conditions files. Each has just one page containing just the work 'Appendices'
    Given there are no files prefixed '10017440_LOANS-440' in the Sharepoint 'LOANS-1819-Input-Terms And Conditions' folder
    And   a file with filename '10017440_LOANS-440_11.pdf' is created in 'LOANS-1819-Input-Terms And Conditions'
    And   a file with filename '10017440_LOANS-440_61.pdf' is created in 'LOANS-1819-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '1' of contract 'LOANS-440' for provider '10017440' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'LOANS-440' for provider '10017440'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017440 - 10017440 Co Ltd Please review the contract       | LOANS-440      | FCS2 Test                | Contract Advisers Team   | Open            | Not Started      |


    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '1' of contract 'LOANS-440' for provider '10017440' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'LOANS-440' for provider '10017440'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017440 - 10017440 Co Ltd                                  | LOANS-440      | FCS1 Test                | Contract Managers Team   | Open            | Not Started      |


    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When  the following open Task currently linked to version '1' of contract 'LOANS-440' for provider '10017440' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'LOANS-440' for provider '10017440'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017440 - 10017440 Co Ltd                                  | LOANS-440      | Lead Manager Team         | ?                        | Open            | Not Started      |


    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When  the following open Task currently linked to version '1' of contract 'LOANS-440' for provider '10017440' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |


    # Check that the Tasks on the contract are all marked as completed
    Then  the following Tasks are present against version '1' of contract 'LOANS-440' for provider '10017440'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017440 - 10017440 Co Ltd                                  | LOANS-440      | Lead Manager Team         | ?                        | Completed       | Completed        |
    | Confirm Internal Approval        | 10017440 - 10017440 Co Ltd                                  | LOANS-440      | FCS1 Test                | Contract Managers Team   | Completed       | Completed        |
    | Review Contract Details          | 10017440 - 10017440 Co Ltd Please review the contract       | LOANS-440      | FCS2 Test                | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017440 - 10017440 Co Ltd Awaiting documentation           | LOANS-440      | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017440 | LOANS-440          | 1                     | 1                        | Draft            | Published to Provider     | True          | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017440 | LOANS-440          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017440 | ESFA-440           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Change the date
    Given the override date is '09/07/2018'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-440' and actual ContractNumber 'LOANS-440'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017440 | LOANS-440          | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017440 | LOANS-440          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017440 | ESFA-440           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'LOANS-440'

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-440      | ALLC-440        | 1               | 25580.00 | 2556.00  | 4684.00  | 929.00   | 2291.00  | 526.00   | 2185.00  | 843.00   | 1233.00  | 3699.00  | 2568.00  | 2324.00  | 1742.00  | 
    | LOANS-440      | ALLC-440        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-440      | ALLC-440        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-440      | ALLC-440        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-440      | ALLF-440        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-440      | ALLF-440        | 5               | 34369.00 | 2562.00  | 2277.00  | 4446.00  | 1577.00  | 3917.00  | 4478.00  | 4108.00  | 268.00   | 572.00   | 1980.00  | 4023.00  | 4161.00  | 
    | LOANS-440      | ALLF-440        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | LOANS-440      | ALLF-440        | 7               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualValue |
    | ALLC-440         | 1             | 1               | 201808 | 2              | 0             | 2556.00      | 2556.00              | 0.00                | 0.00                   | 0.00                        | 2556.00          | ?           |
    | ALLC-440         | 1             | 1               | 201809 | 2              | 0             | 4684.00      | 4684.00              | 0.00                | 0.00                   | 0.00                        | 4684.00          | ?           |
    | ALLC-440         | 1             | 1               | 201810 | 2              | 0             | 929.00       | 929.00               | 0.00                | 0.00                   | 0.00                        | 929.00           | ?           |
    | ALLC-440         | 1             | 1               | 201811 | 2              | 0             | 2291.00      | 2291.00              | 0.00                | 0.00                   | 0.00                        | 2291.00          | ?           |
    | ALLC-440         | 1             | 1               | 201812 | 2              | 0             | 526.00       | 526.00               | 0.00                | 0.00                   | 0.00                        | 526.00           | ?           |
    | ALLC-440         | 1             | 1               | 201901 | 2              | 0             | 2185.00      | 2185.00              | 0.00                | 0.00                   | 0.00                        | 2185.00          | ?           |
    | ALLC-440         | 1             | 1               | 201902 | 2              | 0             | 843.00       | 843.00               | 0.00                | 0.00                   | 0.00                        | 843.00           | ?           |
    | ALLC-440         | 1             | 1               | 201903 | 2              | 0             | 1233.00      | 1233.00              | 0.00                | 0.00                   | 0.00                        | 1233.00          | ?           |
    | ALLC-440         | 1             | 1               | 201904 | 2              | 0             | 3699.00      | 3699.00              | 0.00                | 0.00                   | 0.00                        | 3699.00          | ?           |
    | ALLC-440         | 1             | 1               | 201905 | 2              | 0             | 2568.00      | 2568.00              | 0.00                | 0.00                   | 0.00                        | 2568.00          | ?           |
    | ALLC-440         | 1             | 1               | 201906 | 2              | 0             | 2324.00      | 2324.00              | 0.00                | 0.00                   | 0.00                        | 2324.00          | ?           |
    | ALLC-440         | 1             | 1               | 201907 | 2              | 0             | 1742.00      | 1742.00              | 0.00                | 0.00                   | 0.00                        | 1742.00          | ?           |
    #																																																									      
    | ALLF-440         | 1             | 5               | 201808 | 2              | 0             | 2562.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-440         | 1             | 5               | 201809 | 2              | 0             | 2277.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-440         | 1             | 5               | 201810 | 2              | 0             | 4446.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-440         | 1             | 5               | 201811 | 2              | 0             | 1577.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-440         | 1             | 5               | 201812 | 2              | 0             | 3917.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-440         | 1             | 5               | 201901 | 2              | 0             | 4478.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-440         | 1             | 5               | 201902 | 2              | 0             | 4108.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-440         | 1             | 5               | 201903 | 2              | 0             | 268.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-440         | 1             | 5               | 201904 | 2              | 0             | 572.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-440         | 1             | 5               | 201905 | 2              | 0             | 1980.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-440         | 1             | 5               | 201906 | 2              | 0             | 4023.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | ALLF-440         | 1             | 5               | 201907 | 2              | 0             | 4161.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |

    # Check the PROFILE subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017440 | ORG0017440 | ALLC-440          | 2303900         | ALLBC1819                  | 201808               | PROFILE         | CM             | False       | 2556.00         |
    | 10017440 | ORG0017440 | ALLC-440          | 2303900         | ALLBC1819                  | 201809               | PROFILE         | CM             | False       | 4684.00         |
    | 10017440 | ORG0017440 | ALLC-440          | 2303900         | ALLBC1819                  | 201810               | PROFILE         | CM             | False       | 929.00          |
    | 10017440 | ORG0017440 | ALLC-440          | 2303900         | ALLBC1819                  | 201811               | PROFILE         | CM             | False       | 2291.00         |
    | 10017440 | ORG0017440 | ALLC-440          | 2303900         | ALLBC1819                  | 201812               | PROFILE         | CM             | False       | 526.00          |
    | 10017440 | ORG0017440 | ALLC-440          | 2303900         | ALLBC1819                  | 201901               | PROFILE         | CM             | False       | 2185.00         |
    | 10017440 | ORG0017440 | ALLC-440          | 2303900         | ALLBC1819                  | 201902               | PROFILE         | CM             | False       | 843.00          |
    | 10017440 | ORG0017440 | ALLC-440          | 2303900         | ALLBC1819                  | 201903               | PROFILE         | CM             | False       | 1233.00         |
    | 10017440 | ORG0017440 | ALLC-440          | 2303900         | ALLBC1819                  | 201904               | PROFILE         | CM             | False       | 3699.00         |
    | 10017440 | ORG0017440 | ALLC-440          | 2303900         | ALLBC1819                  | 201905               | PROFILE         | CM             | False       | 2568.00         |
    | 10017440 | ORG0017440 | ALLC-440          | 2303900         | ALLBC1819                  | 201906               | PROFILE         | CM             | False       | 2324.00         |
    | 10017440 | ORG0017440 | ALLC-440          | 2303900         | ALLBC1819                  | 201907               | PROFILE         | CM             | False       | 1742.00         |





	# Change the date
    Given the override date is '03/08/2018 22:05'
	
	# Month end is not running
	And   the PaaS MonthEndIsRunning indicator is set to 'False'

	# Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ALLBC1819' AccountingPaymentPeriod '201805' CensusEndDate '03/08/2018' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaaS. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | ALLC-440                 | 201808 |

    # PaymentGeneration.PaymentTimetable
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ALLBC1819                  | 201808               |                      | A              | NotStarted |

#    # Coda.AccountCode
#    And   the following configuration exists in the Account Codes table
#    | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#    | 10017440 | ALLBC1819                  | CODA440   | 8115000      | 01/08/1990           | 31/08/2020         |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ALLBC1819                  | 201808               | Completed |

#    # File created in Maytech FTP folder for 'Advanced Learner Loans Bursary (College)'
#    And   Payment file 'LBCO20180503A.pay' is created in the FTP Folder
#
#    # Decrypt the payment file to the Output window and save a decrypted version to Datafiles/Downloads
#    Given there is an encrypted file called 'LBCO20180503A.pay' in the Maytech FTP folder decrypt it then save it to 'DataFiles/Downloads'
#
#    Then  the following details are present in payment file 'LBCO20180503A.pay'
#    | LinkCode    | CompanyCode | Element1 | Element2 | Element3 | Element4 | Element5 | Element6 | Element7 | Element8 | Year | Period | Date       | Amount   | Dc   | LineType | Doc     | Desc                            | DueDate    | Tax | Extref1                       | Extref2     | Extref3 | Extref4 | Extref5  | Extref6 | Num   | DocLineNo |
#    | LBCO180503A | SFA         | AAA40    | +        | 8115000  | CODA440  | 02       | ALLC-440 | ?        | ?        | 2018 | 05     | 03/08/2018 | 2556.00  | 160  | 157      | LBCOP   | Adv LL Bursary Prf Aug18        | 15/08/2018 | ?   | ALLC PROFILE 2018/19          | LBCO180503A | ?       | ?       | 10017440 | 2303900 | 1     | 1         |
#    | LBCO180503A | SFA         | AAA40    | +        | 2303900  | 5000     | 02       | ALLC-440 | ?        | ?        | 2018 | 05     | 03/08/2018 | 2556.00  | 161  | 158      | LBCOP   | Adv LL Bursary Prf Aug18        | 15/08/2018 | VIO | ALLC PROFILE 2018/19          | LBCO180503A | ?       | ?       | 10017440 | CODA440 | 1     | 2         |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLBC1819' PaymentPeriod '201805' CensusEndDate '03/08/2018' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A440.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLBC1819' PaymentPeriod '201805' CensusEndDate '03/08/2018' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | LBCO                   | 2018          | 05             | 03          | ?       | ALLC-440      | 2556.00         | PROFILE          | Adv LL Bursary                     | 2018-08-15 | 2018-08-01   | 2019-07-31 | ?              | 10017440 | 2303900    |

    # Check the AllocationDelivery.AllocationDeliveryEntry (ADP) feed for specific items and values (23186)
    And   the ADP feed includes the following values
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | ContractVersionNumber | SubVersionNumber | AllocationNumber | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    # ADCode 0 = New Approval
    | NewContractAllocationApproved     | 0      | LOANS-440      | 1                     | 0                | ALLC-440         | ?                         | ?                            | 
    | NewContractAllocationApproved     | 0      | LOANS-440      | 1                     | 0                | ALLF-440         | ?                         | ?                            | 


    # Tidy up
    And   the override date is reset

	 