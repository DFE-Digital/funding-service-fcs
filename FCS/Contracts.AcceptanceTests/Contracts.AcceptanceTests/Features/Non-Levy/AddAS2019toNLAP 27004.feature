Feature: AddAS2019toNLAP 27004

@AcceptanceTest @Complete
Scenario: A731 Create and approve a 2018 NLAP contract without a related Levy contract. Bulk amend to add both AS2019 allocations. Bulk amend again to add 2021 periods. Check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017731' 
    And   there are no terminated or closed allocations for UKPRN '10017731' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017731' 
    And   there are no notifications of type 'Document Merge Failed' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017731'



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017731' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017731 Co Ltd' with UKPRN '10017731' and OrgId 'ORG0017731' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017731' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017731 | 117731 | 10017731 Co Ltd | 0              | Active                | Yes           | AA017731      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017731 |




    # Change the date
    Given the override date is '01/12/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017731 | 10017731 Co Ltd      | ESFA-731             | NLAP-731       | 1                     | 01/01/2018        | 31/03/2020      | 98509.00      |                                    | Contract for Services                      | 2018   | New          | ORG0017731 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017731 | NLAP-731       | ANLP-731      | ANLAP             | ANLAP2018               | NONLEVY                 | 01/01/2018          | 31/03/2020        | 43019.00        |                                         |            |                                                             | New          |             |
    | 10017731 | NLAP-731       | YNLP-731      | 16-18NLAP         | 16-18NLAP2018           | NONLEVY                 | 01/01/2018          | 31/03/2020        | 55490.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017731 | NLAP-731       | ANLP-731      | 1               | 0                     | 43019.00  | 1010.00  | 1049.00  | 930.00   | 1286.00  | 2937.00  | 3421.00  | 234.00   | 2393.00  | 3317.00  | 3263.00  | 708.00   | 970.00   | 1168.00  | 575.00   | 2354.00  | 3436.00  | 2907.00  | 1776.00  | 486.00   | 654.00   | 2116.00  | 447.00   | 772.00   | 1761.00  | 1514.00  | 288.00   | 1247.00  | Total Adult Non-Levy Apprenticeships Funding                    | New          |             |
    | 10017731 | NLAP-731       | YNLP-731      | 1               | 0                     | 55490.00  | 398.00   | 407.00   | 2345.00  | 2952.00  | 146.00   | 2147.00  | 3545.00  | 2068.00  | 82.00    | 1356.00  | 3199.00  | 1371.00  | 2171.00  | 1737.00  | 3041.00  | 1846.00  | 3466.00  | 2305.00  | 3071.00  | 3491.00  | 3214.00  | 343.00   | 1554.00  | 2606.00  | 3150.00  | 3254.00  | 225.00   | Total 16-18 Non-Levy Apprenticeships Funding                    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NLAP-731' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-731' and actual ContractNumber 'NLAP-731'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-731' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017731 | NLAP-731           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2020      | ?             |
    | 10017731 | ESFA-731           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '270' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '270' deliverable period rows in CRM linked to the latest version of contract 'NLAP-731'

 #  # Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
 #  Given the following NLAP NewStarts profile values exist in config
 #  | UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
 #  | 10017731 | 0.00               | 0.00               | 0.00                                 | 0.00                                 |





    # Change the date
    Given the override date is '28/07/2019'

    # Bulk file to add 16-18NLAP-AS2019 and ANLAP-AS2019 allocations to the approved contract. (Notification amendment)
    And   there are no files prefixed '10017731' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 26072019091617 v3_A731' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 26072019091617 v3_A731' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 26072019091617 v3_A731' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 26072019091617 v3_A731.xlsx' exists in the Datafiles folder and UKPRN '10017731' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017731' for FundingType 'NLA' and period '2018' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017731' for FundingType 'NLA' and period '2018'

    # Check the contents of the Appendices. The YNAS and ANAS allocation refs on the Summary of Funding should be blank
   #And   a file for this contract exists in sharepoint location 'NLA-2018-Input-Appendices'
   #And   the pdf file contains the following page lines in order
	#Then  the file named '10017731_NLAP-731_v2.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    #"""
    #APPENDIX 1 – SUMMARY OF FUNDING
    #Organisation Name: 10017731 Co Ltd UKPRN: 10017731
    #Master Contract Number: ESFA-731
    #Allocation
    #Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Apr 22 to Mar 23 Apr 23 to Mar 24 Apr 24 to Mar 25 Apr 25 to Mar 26 Apr 26 to Mar 27 Total
    #16-18 Non-Levy Apprenticeships YNLP-731 £3,150 £23,815 £28,525 £0 £55,490
    #of which New Starts £0 £0
    #16-18 Non-Levy Apprenticeships £40,530 £0 £40,530
    #(Employer on Apprenticeship 
    #Service)
    #Adult Non-Levy Apprenticeships ANLP-731 £2,989 £22,626 £17,404 £0 £43,019
    #of which New Starts £0 £0
    #Adult Non-Levy Apprenticeships £28,035 £0 £28,035
    #(Employer on Apprenticeship 
    #Service)
    #Total: £167,074
    #
    #Funding Agreement 16-18 Non-Levy Apprenticeships
    #Provider: 10017731 Co Ltd UKPRN: 10017731
    #Master Contract Ref: ESFA-731 Start Date: 01/01/2018 End Date: 31/03/2020
    #Contract Ref: YNLP-731
    #Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    #16-18 Non-Levy Apprenticeships £55,490 £398 £407 £2,345
    #Total Funding £55,490 £398 £407 £2,345
    #Ref (for internal use only):  NLAP-731 v2
    #Page 1 of 3 of this Funding Agreement
    #
    #Funding Agreement 16-18 Non-Levy Apprenticeships
    #Provider: 10017731 Co Ltd UKPRN: 10017731
    #Master Contract Ref: ESFA-731 Start Date: 01/01/2018 End Date: 31/03/2020
    #Contract Ref: YNLP-731
    #Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    #16-18 Non-Levy Apprenticeships £2,952 £146 £2,147 £3,545 £2,068 £82 £1,356 £3,199 £1,371 £2,171 £1,737 £3,041
    #Total Funding £2,952 £146 £2,147 £3,545 £2,068 £82 £1,356 £3,199 £1,371 £2,171 £1,737 £3,041
    #Ref (for internal use only):  NLAP-731 v2
    #Page 2 of 3 of this Funding Agreement
    #
    #Funding Agreement 16-18 Non-Levy Apprenticeships
    #Provider: 10017731 Co Ltd UKPRN: 10017731
    #Master Contract Ref: ESFA-731 Start Date: 01/01/2018 End Date: 31/03/2020
    #Contract Ref: YNLP-731
    #Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    #16-18 Non-Levy Apprenticeships £1,846 £3,466 £2,305 £3,071 £3,491 £3,214 £343 £1,554 £2,606 £3,150 £3,254 £225
    #Total Funding £1,846 £3,466 £2,305 £3,071 £3,491 £3,214 £343 £1,554 £2,606 £3,150 £3,254 £225
    #Ref (for internal use only):  NLAP-731 v2
    #Page 3 of 3 of this Funding Agreement
    #
    #Funding Agreement Adult Non-Levy Apprenticeships
    #Provider: 10017731 Co Ltd UKPRN: 10017731
    #Master Contract Ref: ESFA-731 Start Date: 01/01/2018 End Date: 31/03/2020
    #Contract Ref: ANLP-731
    #Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    #Adult Non-Levy Apprenticeships £43,019 £1,010 £1,049 £930
    #Total Funding £43,019 £1,010 £1,049 £930
    #Ref (for internal use only):  NLAP-731 v2
    #Page 1 of 3 of this Funding Agreement
    #
    #Funding Agreement Adult Non-Levy Apprenticeships
    #Provider: 10017731 Co Ltd UKPRN: 10017731
    #Master Contract Ref: ESFA-731 Start Date: 01/01/2018 End Date: 31/03/2020
    #Contract Ref: ANLP-731
    #Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    #Adult Non-Levy Apprenticeships £1,286 £2,937 £3,421 £234 £2,393 £3,317 £3,263 £708 £970 £1,168 £575 £2,354
    #Total Funding £1,286 £2,937 £3,421 £234 £2,393 £3,317 £3,263 £708 £970 £1,168 £575 £2,354
    #Ref (for internal use only):  NLAP-731 v2
    #Page 2 of 3 of this Funding Agreement
    #
    #Funding Agreement Adult Non-Levy Apprenticeships
    #Provider: 10017731 Co Ltd UKPRN: 10017731
    #Master Contract Ref: ESFA-731 Start Date: 01/01/2018 End Date: 31/03/2020
    #Contract Ref: ANLP-731
    #Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    #Adult Non-Levy Apprenticeships £3,436 £2,907 £1,776 £486 £654 £2,116 £447 £772 £1,761 £1,514 £288 £1,247
    #Total Funding £3,436 £2,907 £1,776 £486 £654 £2,116 £447 £772 £1,761 £1,514 £288 £1,247
    #Ref (for internal use only):  NLAP-731 v2
    #Page 3 of 3 of this Funding Agreement
    #"""

    # Copy\Save a named Sharepoint file to a named folder\filename
   #And   Sharepoint file '10017731_[ContractNo]_v1.pdf' in 'NLA-2018-Input-Appendices' is copied to 'Datafiles/Downloads' as '<filename2>.pdf'
    And   Sharepoint file '10017731_NLAP-731_v2.pdf' in 'NLA-2018-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A731v2.pdf'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017731 | NLAP-731           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/01/2018        | 31/03/2020      | Notification  |
    | 10017731 | NLAP-731           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/01/2018        | 31/03/2020      | ?             |
    | 10017731 | ESFA-731           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2020      | ?             |




    # Attempt to execute a doc merge without a T&C document. (Replacement for B030)
    #  This should fail, reset the contract and issue a notification (Replacement for clunky test B030)

    Given there are no files prefixed '10017731_NLAP-731' in the Sharepoint 'NLA-2018-Input-Terms And Conditions' folder

    # Attempt to complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '2' of contract 'NLAP-731' for provider '10017731' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Task completion fails. Check that a notification has been created
    Then  there is '1' notification of type 'Document Merge Failed' owned by team 'Document Management Team' which matches the following 
    | Status | NotificationName                | NotificationText                                                                                                                                                  |
    | New    | Document Merge Failed-NLAP-731  | Automatic merge cannot occur where documentation has not been uploaded for contract UKPRN: 10017731 & Contract: NLAP-731. Please upload documentation and re-try  |




    # Create a dummy Terms and Conditions file with just one page containing just the work 'Appendices'
    Given there are no files prefixed '10017731_NLAP-731' in the Sharepoint 'NLA-2018-Input-Terms And Conditions' folder
    And   a file with filename '10017731_NLAP-731_11.pdf' is created in 'NLA-2018-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '2' of contract 'NLAP-731' for provider '10017731' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract 'NLAP-731' for provider '10017731'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017731 - 10017731 Co Ltd Please review the contract       | NLAP-731       | FCS2 Test                | Contract Advisers Team   | Open            | Not Started      |


    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '2' of contract 'NLAP-731' for provider '10017731' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract 'NLAP-731' for provider '10017731'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017731 - 10017731 Co Ltd                                  | NLAP-731       | FCS1 Test                | Contract Managers Team   | Open            | Not Started      |


    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When  the following open Task currently linked to version '2' of contract 'NLAP-731' for provider '10017731' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract 'NLAP-731' for provider '10017731'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017731 - 10017731 Co Ltd                                  | NLAP-731       | Lead Manager Team         | ?                        | Open            | Not Started      |


    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When  the following open Task currently linked to version '2' of contract 'NLAP-731' for provider '10017731' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |


	# Contract should auto-approve once published

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017731 | NLAP-731           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2020      | Notification  |
    | 10017731 | NLAP-731           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/01/2018        | 31/03/2020      | ?             |
    | 10017731 | ESFA-731           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2020      | ?             |




    # Amend the contract to add a further 12 months and use 2021 template (28766)
    
	# Change the date
	Given the override date is '20/02/2020'
	
	# Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   the following NLAP NewStarts profile values exist in config
	| UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
    | 10017731 | 6408.00            | 8712.00            | 1255.00                              | 2067.00                              |

    # Bulk file
    And   there are no files prefixed '10017731' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 26072019091622 v3_A731_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 26072019091622 v3_A731_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 26072019091622 v3_A731_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 26072019091622 v3_A731_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 26072019091622 v3_A731_1.xlsx' exists in the Datafiles folder and UKPRN '10017731' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the contents of the Appendices. The YNAS and ANAS allocation refs on the Summary of Funding should be blank
	#Then  the file named '10017731_NLAP-731_v3.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    #"""
    #APPENDIX 1 – SUMMARY OF FUNDING
    #Organisation Name: 10017731 Co Ltd UKPRN: 10017731
    #Master Contract Number: ESFA-731
    #Allocation
    #Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Apr 22 to Mar 23 Apr 23 to Mar 24 Apr 24 to Mar 25 Apr 25 to Mar 26 Total
    #16-18 Non-Levy Apprenticeships YNLP-731 £3,150 £23,815 £28,525 £40,703 £96,193
    #of which New Starts £6,408 £6,408
    #16-18 Non-Levy Apprenticeships £40,530 £0 £40,530
    #(Employer on Apprenticeship 
    #Service)
    #Adult Non-Levy Apprenticeships ANLP-731 £2,989 £22,626 £17,404 £47,019 £90,038
    #of which New Starts £8,712 £8,712
    #Adult Non-Levy Apprenticeships £28,035 £0 £28,035
    #(Employer on Apprenticeship 
    #Service)
    #Total: £254,796
    #
    #Funding Agreement 16-18 Non-Levy Apprenticeships
    #Provider: 10017731 Co Ltd UKPRN: 10017731
    #Master Contract Ref: ESFA-731 Start Date: 01/01/2018 End Date: 31/03/2021
    #Contract Ref: YNLP-731
    #Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    #16-18 Non-Levy Apprenticeships £96,193 £398 £407 £2,345
    #Total Funding £96,193 £398 £407 £2,345
    #Ref (for internal use only):  NLAP-731 v3
    #Page 1 of 4 of this Funding Agreement
    #
    #Funding Agreement 16-18 Non-Levy Apprenticeships
    #Provider: 10017731 Co Ltd UKPRN: 10017731
    #Master Contract Ref: ESFA-731 Start Date: 01/01/2018 End Date: 31/03/2021
    #Contract Ref: YNLP-731
    #Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    #16-18 Non-Levy Apprenticeships £2,952 £146 £2,147 £3,545 £2,068 £82 £1,356 £3,199 £1,371 £2,171 £1,737 £3,041
    #Total Funding £2,952 £146 £2,147 £3,545 £2,068 £82 £1,356 £3,199 £1,371 £2,171 £1,737 £3,041
    #Ref (for internal use only):  NLAP-731 v3
    #Page 2 of 4 of this Funding Agreement
    #
    #Funding Agreement 16-18 Non-Levy Apprenticeships
    #Provider: 10017731 Co Ltd UKPRN: 10017731
    #Master Contract Ref: ESFA-731 Start Date: 01/01/2018 End Date: 31/03/2021
    #Contract Ref: YNLP-731
    #Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    #16-18 Non-Levy Apprenticeships £1,846 £3,466 £2,305 £3,071 £3,491 £3,214 £343 £1,554 £2,606 £3,150 £3,254 £225
    #Total Funding £1,846 £3,466 £2,305 £3,071 £3,491 £3,214 £343 £1,554 £2,606 £3,150 £3,254 £225
    #Ref (for internal use only):  NLAP-731 v3
    #Page 3 of 4 of this Funding Agreement
    #
    #Funding Agreement 16-18 Non-Levy Apprenticeships
    #Provider: 10017731 Co Ltd UKPRN: 10017731
    #Master Contract Ref: ESFA-731 Start Date: 01/01/2018 End Date: 31/03/2021
    #Contract Ref: YNLP-731
    #Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    #16-18 Non-Levy Apprenticeships £3,725 £3,066 £1,315 £4,457 £2,981 £1,569 £94 £1,676 £6,994 £6,941 £4,988 £2,897
    #Total Funding £3,725 £3,066 £1,315 £4,457 £2,981 £1,569 £94 £1,676 £6,994 £6,941 £4,988 £2,897
    #Ref (for internal use only):  NLAP-731 v3
    #Page 4 of 4 of this Funding Agreement
    #
    #Funding Agreement Adult Non-Levy Apprenticeships
    #Provider: 10017731 Co Ltd UKPRN: 10017731
    #Master Contract Ref: ESFA-731 Start Date: 01/01/2018 End Date: 31/03/2021
    #Contract Ref: ANLP-731
    #Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    #Adult Non-Levy Apprenticeships £90,038 £1,010 £1,049 £930
    #Total Funding £90,038 £1,010 £1,049 £930
    #Ref (for internal use only):  NLAP-731 v3
    #Page 1 of 4 of this Funding Agreement
    #
    #Funding Agreement Adult Non-Levy Apprenticeships
    #Provider: 10017731 Co Ltd UKPRN: 10017731
    #Master Contract Ref: ESFA-731 Start Date: 01/01/2018 End Date: 31/03/2021
    #Contract Ref: ANLP-731
    #Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    #Adult Non-Levy Apprenticeships £1,286 £2,937 £3,421 £234 £2,393 £3,317 £3,263 £708 £970 £1,168 £575 £2,354
    #Total Funding £1,286 £2,937 £3,421 £234 £2,393 £3,317 £3,263 £708 £970 £1,168 £575 £2,354
    #Ref (for internal use only):  NLAP-731 v3
    #Page 2 of 4 of this Funding Agreement
    #
    #Funding Agreement Adult Non-Levy Apprenticeships
    #Provider: 10017731 Co Ltd UKPRN: 10017731
    #Master Contract Ref: ESFA-731 Start Date: 01/01/2018 End Date: 31/03/2021
    #Contract Ref: ANLP-731
    #Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    #Adult Non-Levy Apprenticeships £3,436 £2,907 £1,776 £486 £654 £2,116 £447 £772 £1,761 £1,514 £288 £1,247
    #Total Funding £3,436 £2,907 £1,776 £486 £654 £2,116 £447 £772 £1,761 £1,514 £288 £1,247
    #Ref (for internal use only):  NLAP-731 v3
    #Page 3 of 4 of this Funding Agreement
    #
    #Funding Agreement Adult Non-Levy Apprenticeships
    #Provider: 10017731 Co Ltd UKPRN: 10017731
    #Master Contract Ref: ESFA-731 Start Date: 01/01/2018 End Date: 31/03/2021
    #Contract Ref: ANLP-731
    #Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    #Adult Non-Levy Apprenticeships £7,424 £2,891 £6,192 £429 £5,545 £259 £6,055 £6,681 £2,690 £874 £481 £7,498
    #Total Funding £7,424 £2,891 £6,192 £429 £5,545 £259 £6,055 £6,681 £2,690 £874 £481 £7,498
    #Ref (for internal use only):  NLAP-731 v3
    #Page 4 of 4 of this Funding Agreement
    #"""


	# Tidy Up
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017731'
	And   the override date is reset

@AcceptanceTest @Withdrawn20200420
Scenario: A732 Create and approve a Levy contract. Create and approve a 2018 NLAP contract. Notification amendment on Levy contract to add NONLEVY2019 allocation. Bulk amendment on NLAP contract to add both AS2019 allocations. Bulk update draft to add 2021 periods. Check NLAP docs
    Given there are no allocations marked as Under Termination for UKPRN '10017732' 
    And   there are no terminated or closed allocations for UKPRN '10017732' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017732' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017732' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017732' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017732' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017732' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table 
    And   there are no DAS engagement events stored in FCS 

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017732'
 


    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017732' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017732 Co Ltd' with UKPRN '10017732' and OrgId 'ORG0017732' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017732' 
 
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017732 | 117732 | 10017732 Co Ltd | 0              | Active                | Yes           | AA017732      | ?             | 34 Comet Road          | ?                      | ?                      | ?                      | Hatfield               | Hertfordshire          | AL10 0SX  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017732 |

 
    # Set RoATP data (needed for amendment checks) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017732 | 10017732 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 
 
 
 
    # Change the date 
    Given the override date is '16/09/2017' 

    # Create dummy docs in Sharepoint
    And   a file with filename '10017732_APPLEVY-732_v1.pdf' is created in 'LEVY-1799-Input-Appendices'
    And   a file with filename '10017732_APPLEVY-732_v1.pdf' is created in 'LEVY-1799-Output-Documents for Publication'
 
    # Inject data into the stub 
   #And   the following Levy event data is available in the DAS agreement stub 
	And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 42732 | INITIATED | 2017-09-15T18:03:12.2732 | 10017732   | 28732             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017732' 
    Then  there is only one Levy contract in CRM for UKPRN '10017732' with a status of 'Draft' 

#    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
#    And   the latest version of the contract has the following settings 
#    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
#    | Draft  | Internally Approved    | Yes           | No                  | 1                     | 

    # Retrieve parameters from CRM 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017732' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017732' 
#    When  I retrieve the latest contract details from CRM for provider '10017732' for FundingType 'LEVY' and period '1799' 

    # Publish the contract (This is needed because the injection step above leaves the contract in the wrong state)
    Given the latest version of contract 'APPLEVY-732' is in a state of 'Published to Provider'


 

    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017732 | 10017732 Co Ltd      | LEVY        | ESFA-732             | APPLEVY-732    | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017732 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017732 | LEVY              | LEVY1799                | APPLEVY-732    | LEVY-732            | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017732 | LEVY              | LEVY-732            | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017732 | LEVY              | LEVY-732            | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 

    # Check deliverable period count 
    And   there are '2' deliverable period rows in CRM linked to the latest version of contract number 'APPLEVY-732' 

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017732 | APPLEVY-732        | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/05/2017        | ?               | ?             |
    | 10017732 | ESFA-732           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |




	# Change the date 
    Given the override date is '12/12/2017' 

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
 
    # Approve the contract 
	When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-732' and actual ContractNumber 'APPLEVY-732' 
 
     # Check that the contract is now approved
    Then  the latest version of contract 'APPLEVY-732' is in status 'Approved'

    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017732 | APPLEVY-732        | 1                     | 0                        | Approved         | Approved               | True          | True                | 12/12/2017        | ?               | ?             | 
    | 10017732 | ESFA-732           | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 
 
    # Check ALLOCATION dates in CRM 
    And   the following allocation values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate | 
    | 10017732 | APPLEVY-732        | 1                     | LEVY-732        | 12/12/2017          | ?                 | 

    # Check deliverable period count after approval 
    And   there are '14' deliverable period rows in CRM linked to the latest version of contract number 'APPLEVY-732' 
 
    # After approval there should be a Dec-17 deliverable period for each of deliverables 1 through 14 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef   | DeliverableCode | ParentDeliverableCode | Total    | Dec-17   | DeliverableDescription                           | 
    | 10017732 | LEVY              | LEVY_732        | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                 | 
    | 10017732 | LEVY              | LEVY_732        | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                         | 
    | 10017732 | LEVY              | LEVY_732        | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                         | 
    | 10017732 | LEVY              | LEVY_732        | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support    | 
    | 10017732 | LEVY              | LEVY_732        | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other               | 
    | 10017732 | LEVY              | LEVY_732        | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers   | 
    | 10017732 | LEVY              | LEVY_732        | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals | 
    | 10017732 | LEVY              | LEVY_732        | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                 | 
    | 10017732 | LEVY              | LEVY_732        | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                         | 
    | 10017732 | LEVY              | LEVY_732        | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                         | 
    | 10017732 | LEVY              | LEVY_732        | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support    | 
    | 10017732 | LEVY              | LEVY_732        | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other               | 
    | 10017732 | LEVY              | LEVY_732        | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers   | 
    | 10017732 | LEVY              | LEVY_732        | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals | 
 



    # Create a 2018 NLAP contract
	
	# Change the date
    Given the override date is '23/12/2017'

    # Create contract (Note: MasterContractNo ESFA-732 has been used by the preceding Levy contract so ESFA-1732 is used below)
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017732 | 10017732 Co Ltd      | ESFA-1732            | NLAP-732       | 1                     | 01/01/2018        | 31/03/2020      | 100299.00     |                                    | Contract for Services                      | 2018   | New          | ORG0017732 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017732 | NLAP-732       | ANLP-732      | ANLAP             | ANLAP2018               | NONLEVY                 | 01/01/2018          | 31/03/2020        | 50940.00        |                                         |            |                                                             | New          |             |
    | 10017732 | NLAP-732       | YNLP-732      | 16-18NLAP         | 16-18NLAP2018           | NONLEVY                 | 01/01/2018          | 31/03/2020        | 49359.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017732 | NLAP-732       | ANLP-732      | 1               | 0                     | 50940.00  | 3730.00  | 731.00   | 360.00   | 2455.00  | 3571.00  | 1205.00  | 2638.00  | 305.00   | 3601.00  | 2850.00  | 1403.00  | 2045.00  | 2084.00  | 1966.00  | 2321.00  | 1254.00  | 755.00   | 1269.00  | 3428.00  | 652.00   | 597.00   | 1743.00  | 2005.00  | 2203.00  | 1610.00  | 3389.00  | 770.00   | Total Adult Non-Levy Apprenticeships Funding                    | New          |             |
    | 10017732 | NLAP-732       | YNLP-732      | 1               | 0                     | 49359.00  | 2317.00  | 1186.00  | 3597.00  | 64.00    | 1526.00  | 3557.00  | 182.00   | 1171.00  | 1907.00  | 3399.00  | 657.00   | 3448.00  | 2475.00  | 711.00   | 2302.00  | 2213.00  | 513.00   | 2895.00  | 434.00   | 3132.00  | 3424.00  | 1566.00  | 3439.00  | 538.00   | 103.00   | 1408.00  | 1195.00  | Total 16-18 Non-Levy Apprenticeships Funding                    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NLAP-732' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-1732' and actual ContractNumber 'NLAP-732'

    # Check that the contract is now approved
    Then  the latest version of contract 'NLAP-732' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017732 | NLAP-732           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2020      | ?             |
    | 10017732 | ESFA-1732          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '270' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '270' deliverable period rows in CRM linked to the latest version of contract 'NLAP-732'




    # Amend the Levy contract to add a NONLEVY2019 allocation
    
    # Change the date
    Given the override date is '28/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    
    # Issue a contract amendment request on v1 to create v2, adding a NONLEVY2019 allocation. Singleton mechanism
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017732 | ESFA-732             | APPLEVY-732    | 1       | Approved | Approved  | Notification  | Yes                      | Yes                          | 

    # Check the CONTRACT version, status and dates in CRM.  Contract should have auto-approved
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017732 | APPLEVY-732        | 2                     | 0                        | Approved         | Approved                  | True          | True                | 12/12/2017        | ?               | Notification  |
    | 10017732 | APPLEVY-732        | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 12/12/2017        | ?               | ?             |
    | 10017732 | ESFA-732           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Retrieve parameters from CRM 
    #When  I retrieve the latest EFA contract details from CRM for provider '10017732' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017732' 
     When  I retrieve the latest contract details from CRM for provider '10017732' for FundingType 'LEVY' and period '1799' 

    # Check that the Contract Allocation has been created correctly in CRM
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType       |
    | 10017732 | APPLEVY-732        | [AllocRef_NLA]        | ?                             | 0.00            | ?             | ?                | 01/08/2019 | ?          | NONLEVY       | NONLEVY2019         | Contract Allocation |




    # Execute a Notification amendment on the NLAP contract to add a 16-18NLAP-AS2019 and an ANLAP-AS2019 allocation

    # Change the date
    Given the override date is '29/07/2019'

    # Bulk file to add 16-18NLAP-AS2019 and ANLAP-AS2019 allocations to the approved contract. (Notification amendment)
    And   there are no files prefixed '10017732' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 26072019091834 v3_A732' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 26072019091834 v3_A732' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 26072019091834 v3_A732' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 26072019091834 v3_A732.xlsx' exists in the Datafiles folder and UKPRN '10017732' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017732' for FundingType 'NLA' and period '2018' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017732' for FundingType 'NLA' and period '2018'

    # Check the contents of the Appendices
   #And   a file for this contract exists in sharepoint location 'NLA-2018-Input-Appendices'
   #And   the pdf file contains the following page lines in order
	And   the file named '10017732_' & 'NLAP-732' & '_v2.pdf' created in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017732 Co Ltd UKPRN: 10017732
    Master Contract Number: ESFA-1732
    Allocation
    Contract Ref Jan 18 – Mar 18 Apr 18 – Mar 19 Apr 19 – Mar 20 Total
    16-18 Non-Levy Apprenticeships YNLP-732 £7,100 £21,399 £20,860 £49,359
    16-18 Non-Levy Apprenticeships [AllocRef_NLA] £0 £0 £16,648 £16,648
    (Employer on Apprenticeship Service)
    Adult Non-Levy Apprenticeships ANLP-732 £4,821 £26,444 £19,675 £50,940
    Adult Non-Levy Apprenticeships [AllocRef_NLA] £0 £0 £18,432 £18,432
    (Employer on Apprenticeship Service)
    Total Funding for this contract: £135,379

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017732 Co Ltd UKPRN: 10017732
    Master Contract Ref: ESFA-1732 Start Date: 01/01/2018 End Date: 31/03/2020
    Contract Ref: YNLP-732
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    16-18 Non-Levy Apprenticeships £49,359 £2,317 £1,186 £3,597
    Total Funding £49,359 £2,317 £1,186 £3,597
    Ref (for internal use only):  NLAP-732 v2
    Page 1 of 3 of this Funding Agreement

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017732 Co Ltd UKPRN: 10017732
    Master Contract Ref: ESFA-1732 Start Date: 01/01/2018 End Date: 31/03/2020
    Contract Ref: YNLP-732
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    16-18 Non-Levy Apprenticeships £64 £1,526 £3,557 £182 £1,171 £1,907 £3,399 £657 £3,448 £2,475 £711 £2,302
    Total Funding £64 £1,526 £3,557 £182 £1,171 £1,907 £3,399 £657 £3,448 £2,475 £711 £2,302
    Ref (for internal use only):  NLAP-732 v2
    Page 2 of 3 of this Funding Agreement

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017732 Co Ltd UKPRN: 10017732
    Master Contract Ref: ESFA-1732 Start Date: 01/01/2018 End Date: 31/03/2020
    Contract Ref: YNLP-732
    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    16-18 Non-Levy Apprenticeships £2,213 £513 £2,895 £434 £3,132 £3,424 £1,566 £3,439 £538 £103 £1,408 £1,195
    Total Funding £2,213 £513 £2,895 £434 £3,132 £3,424 £1,566 £3,439 £538 £103 £1,408 £1,195
    Ref (for internal use only):  NLAP-732 v2
    Page 3 of 3 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017732 Co Ltd UKPRN: 10017732
    Master Contract Ref: ESFA-1732 Start Date: 01/01/2018 End Date: 31/03/2020
    Contract Ref: ANLP-732
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    Adult Non-Levy Apprenticeships £50,940 £3,730 £731 £360
    Total Funding £50,940 £3,730 £731 £360
    Ref (for internal use only):  NLAP-732 v2
    Page 1 of 3 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017732 Co Ltd UKPRN: 10017732
    Master Contract Ref: ESFA-1732 Start Date: 01/01/2018 End Date: 31/03/2020
    Contract Ref: ANLP-732
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    Adult Non-Levy Apprenticeships £2,455 £3,571 £1,205 £2,638 £305 £3,601 £2,850 £1,403 £2,045 £2,084 £1,966 £2,321
    Total Funding £2,455 £3,571 £1,205 £2,638 £305 £3,601 £2,850 £1,403 £2,045 £2,084 £1,966 £2,321
    Ref (for internal use only):  NLAP-732 v2
    Page 2 of 3 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017732 Co Ltd UKPRN: 10017732
    Master Contract Ref: ESFA-1732 Start Date: 01/01/2018 End Date: 31/03/2020
    Contract Ref: ANLP-732
    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    Adult Non-Levy Apprenticeships £1,254 £755 £1,269 £3,428 £652 £597 £1,743 £2,005 £2,203 £1,610 £3,389 £770
    Total Funding £1,254 £755 £1,269 £3,428 £652 £597 £1,743 £2,005 £2,203 £1,610 £3,389 £770
    Ref (for internal use only):  NLAP-732 v2
    Page 3 of 3 of this Funding Agreement
    """   

    # Copy\Save a named Sharepoint file to a named folder\filename
   #And   Sharepoint file '10017732_[ContractNo]_v1.pdf' in 'NLA-2018-Input-Appendices' is copied to 'Datafiles/Downloads' as '<filename2>.pdf'
    And   Sharepoint file '10017732_NLAP-732_v2.pdf' in 'NLA-2018-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A732v2.pdf'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017732 | NLAP-732           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/01/2018        | 31/03/2020      | Notification  |
    | 10017732 | NLAP-732           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/01/2018        | 31/03/2020      | ?             |
    | 10017732 | ESFA-1732          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2020      | ?             |




    # Bulk 'Update Draft Amendment' on v2.0 to create v2.1, extending the draft YNLP contract by 12 months and picking up the 2021 template (28766)
    
	# Change the date
	Given the override date is '20/02/2020'
	
	# Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   the following NLAP NewStarts profile values exist in config
	| UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
    | 10017732 | 5286.00            | 9154.00            | 1324.00                              | 2296.00                              |

    # Bulk file
    And   there are no files prefixed '10017732' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 26072019091851 v3_A732_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 26072019091851 v3_A732_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 26072019091851 v3_A732_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 26072019091851 v3_A732_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 26072019091851 v3_A732_1.xlsx' exists in the Datafiles folder and UKPRN '10017732' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the contents of the Appendices. The YNAS and ANAS allocation refs on the Summary of Funding should be populated
	Then  the file named '10017732_' & 'NLAP-732' & '_v2.pdf' created in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017732 Co Ltd UKPRN: 10017732
    Master Contract Number: ESFA-1732
    Allocation
    Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Total
    16-18 Non-Levy Apprenticeships YNLP-732 £7,100 £21,399 £20,860 £41,119 £90,478
    of which New Starts £5,286 £5,286
    16-18 Non-Levy Apprenticeships [AllocRef_NLA] £0 £0 £16,648 £0 £16,648
    (Employer on Apprenticeship Service)
    Adult Non-Levy Apprenticeships ANLP-732 £4,821 £26,444 £19,675 £47,304 £98,244
    of which New Starts £9,154 £9,154
    Adult Non-Levy Apprenticeships [AllocRef_NLA] £0 £0 £18,432 £0 £18,432
    (Employer on Apprenticeship Service)
    Total: £223,802
    The estimated maximum future funding (from April 2021 to completion) for new starts between April 2020 and March 2021 is as follows:
    16-18 Non-Levy Apprenticeships £1,324
    Adult Non-Levy Apprenticeships £2,296

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017732 Co Ltd UKPRN: 10017732
    Master Contract Ref: ESFA-1732 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: YNLP-732
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    16-18 Non-Levy Apprenticeships £90,478 £2,317 £1,186 £3,597
    Total Funding £90,478 £2,317 £1,186 £3,597
    Ref (for internal use only):  NLAP-732 v2
    Page 1 of 4 of this Funding Agreement

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017732 Co Ltd UKPRN: 10017732
    Master Contract Ref: ESFA-1732 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: YNLP-732
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    16-18 Non-Levy Apprenticeships £64 £1,526 £3,557 £182 £1,171 £1,907 £3,399 £657 £3,448 £2,475 £711 £2,302
    Total Funding £64 £1,526 £3,557 £182 £1,171 £1,907 £3,399 £657 £3,448 £2,475 £711 £2,302
    Ref (for internal use only):  NLAP-732 v2
    Page 2 of 4 of this Funding Agreement

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017732 Co Ltd UKPRN: 10017732
    Master Contract Ref: ESFA-1732 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: YNLP-732
    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    16-18 Non-Levy Apprenticeships £2,213 £513 £2,895 £434 £3,132 £3,424 £1,566 £3,439 £538 £103 £1,408 £1,195
    Total Funding £2,213 £513 £2,895 £434 £3,132 £3,424 £1,566 £3,439 £538 £103 £1,408 £1,195
    Ref (for internal use only):  NLAP-732 v2
    Page 3 of 4 of this Funding Agreement

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017732 Co Ltd UKPRN: 10017732
    Master Contract Ref: ESFA-1732 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: YNLP-732
    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    16-18 Non-Levy Apprenticeships £3,718 £3,139 £1,374 £4,454 £3,031 £1,579 £169 £1,722 £7,051 £6,960 £5,029 £2,893
    Total Funding £3,718 £3,139 £1,374 £4,454 £3,031 £1,579 £169 £1,722 £7,051 £6,960 £5,029 £2,893
    Ref (for internal use only):  NLAP-732 v2
    Page 4 of 4 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017732 Co Ltd UKPRN: 10017732
    Master Contract Ref: ESFA-1732 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: ANLP-732
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    Adult Non-Levy Apprenticeships £98,244 £3,730 £731 £360
    Total Funding £98,244 £3,730 £731 £360
    Ref (for internal use only):  NLAP-732 v2
    Page 1 of 4 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017732 Co Ltd UKPRN: 10017732
    Master Contract Ref: ESFA-1732 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: ANLP-732
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    Adult Non-Levy Apprenticeships £2,455 £3,571 £1,205 £2,638 £305 £3,601 £2,850 £1,403 £2,045 £2,084 £1,966 £2,321
    Total Funding £2,455 £3,571 £1,205 £2,638 £305 £3,601 £2,850 £1,403 £2,045 £2,084 £1,966 £2,321
    Ref (for internal use only):  NLAP-732 v2
    Page 2 of 4 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017732 Co Ltd UKPRN: 10017732
    Master Contract Ref: ESFA-1732 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: ANLP-732
    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    Adult Non-Levy Apprenticeships £1,254 £755 £1,269 £3,428 £652 £597 £1,743 £2,005 £2,203 £1,610 £3,389 £770
    Total Funding £1,254 £755 £1,269 £3,428 £652 £597 £1,743 £2,005 £2,203 £1,610 £3,389 £770
    Ref (for internal use only):  NLAP-732 v2
    Page 3 of 4 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017732 Co Ltd UKPRN: 10017732
    Master Contract Ref: ESFA-1732 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: ANLP-732
    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    Adult Non-Levy Apprenticeships £7,487 £2,901 £6,226 £427 £5,565 £290 £6,042 £6,697 £2,749 £893 £540 £7,487
    Total Funding £7,487 £2,901 £6,226 £427 £5,565 £290 £6,042 £6,697 £2,749 £893 £540 £7,487
    Ref (for internal use only):  NLAP-732 v2
    Page 4 of 4 of this Funding Agreement
    """


    # Tidy Up
    And   the override date is reset

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017732'

