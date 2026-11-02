Feature: FundingDocsWithDeliveryOrgs 23208

@AcceptanceTest @Withdrawn20210702
Scenario: A715 Bulk load a new mixed-allocation 1819 LOANS contract with two Delivery Orgs one of which matches the Contracting Org. Check docs and CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017715'
    And   there is no Organisation data for UKPRN '10017715'

    # Add data to dbo.Organisations
    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber |
    | 10017715 | 017715 | 10017715 Co Ltd | 0              | Active | Yes           | AA017715      | 017715        |
    | 10117715 | 117715 | 10117715 Co Ltd | 0              | Active | Yes           | AA117715      | ?             |

    # Associate an Advisor with the main provider
   #And   caseload advisor 'FCS2 Test' is assigned to provider '10017715 Co Ltd' with UKPRN '10017715' and OrgId 'ORG0000000' and has 'FCS1 Test' as a manager

    # Cleardown prior to bulk import
    Given there are no files prefixed '10017715_LOANS' in the Sharepoint 'LOANS-1819-Input-Appendices' folder
    And   there are no files prefixed 'LOANS AY 1819 10052018053203 v3_A715' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'LOANS AY 1819 10052018053203 v3_A715' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'LOANS AY 1819 10052018053203 v3_A715' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'LOANS AY 1819 10052018053203 v3_A715' in the Sharepoint 'Reports' folder

    # Change the date
    And   the override date is '09/07/2018'

    # Bulk import a new contract with one Delivery Org which matches the Contracting Org
    And   spreadsheet 'LOANS AY 1819 10052018053203 v3_A715.xlsx' exists in the Datafiles folder and UKPRN '10017715' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve the master contract, contract and allocation numbers from CRM for the first Delivery Org (which = Contracting Org)
   #And   I retrieve the latest contract details from CRM for provider '10017715' for FundingType 'LOANS' and period '1819'
    And   I retrieve the latest EFA contract details from CRM for provider '10017715' for FundingType 'LOANS' and period '1819' and Delivery Organisation '10017715'

    # Check the contents of Appendix 1 (Summary of Funding) plus the Summary of Funding and the Appendix 2 (Funding Agreement) for the first Delivery Org 
    And   a file for this contract exists in sharepoint location 'LOANS-1819-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """    
    APPENDIX 1 - SUMMARY OF FUNDING 2018/19
    Organisation Name: 10017715 Co Ltd
    UKPRN: 10017715
    Maximum Values
    Ref Aug 18 - Mar 19 Apr 19 - Jul 19 2018/19 Total
    Advanced Learner Loans Facility ALLF £24,243 £13,516 £37,759
    Career Learning Pilots CLP £36,275 £22,089 £58,364
	Advanced Learner Loans Bursary ALLC £43,450 £19,062 £62,512
    Total Funding for this agreement £158,635
    Appendix 1 2018/19 Master ref: [MasterContractNo]

    SUMMARY OF FUNDING 2018/19
    Organisation Name: 10017715 Co Ltd
	UKPRN: 10017715
    Career Learning Pilots [AllocRef_CLP] £17,523 £9,499 £27,022
	Advanced Learner Loans Bursary [AllocRef_ALLC] £23,941 £9,730 £33,671
    Total Funding for this agreement £60,693
	Appendix 1 2018/19 Master ref: [MasterContractNo]

	Funding Agreement Career Learning Pilots
    Provider: 10017715 Co Ltd UKPRN: 10017715
    Master Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Agreement Ref: [AllocRef_CLP]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Career Learning Pilots £27,022 £1,704 £4,209 £329 £4,698 £1,492 £1,208 £3,376 £507 £2,847 £2,094 £1,724 £2,834
    Total Funding £27,022 £1,704 £4,209 £329 £4,698 £1,492 £1,208 £3,376 £507 £2,847 £2,094 £1,724 £2,834
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

	Funding Agreement Advanced Learner Loans Bursary
    Provider: 10017715 Co Ltd UKPRN: 10017715
    Master Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Agreement Ref: [AllocRef_ALLC]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Advanced Learner Loans Bursary Funding £33,671 £2,607 £4,987 £1,484 £777 £4,214 £2,489 £2,713 £4,670 £2,436 £2,872 £4,194 £228
    Total Funding £33,671 £2,607 £4,987 £1,484 £777 £4,214 £2,489 £2,713 £4,670 £2,436 £2,872 £4,194 £228
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
	"""

	# Retrieve the master contract, contract and allocation numbers from CRM for the second Delivery Org
   #And   I retrieve the latest contract details from CRM for provider '10017715' for FundingType 'LOANS' and period '1819'
    And  I retrieve the latest EFA contract details from CRM for provider '10017715' for FundingType 'LOANS' and period '1819' and Delivery Organisation '10117715'

    # Check the contents of the Summary of Funding and the Appendix 2 (Funding Agreement) for the second Delivery Org 
    And   a file for this contract exists in sharepoint location 'LOANS-1819-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """    
    SUMMARY OF FUNDING 2018/19
    Organisation Name: 10117715 Co Ltd 
	UKPRN: 10117715
    Advanced Learner Loans Facility [AllocRef_ALLF] £24,243 £13,516 £37,759
	Career Learning Pilots [AllocRef_CLP] £18,752 £12,590 £31,342
	Advanced Learner Loans Bursary [AllocRef_ALLC] £19,509 £9,332 £28,841
    Total Funding for this agreement £97,942
	Appendix 1 2018/19 Master ref: [MasterContractNo]

	Funding Agreement Career Learning Pilots
    Provider: 10117715 Co Ltd UKPRN: 10117715
    Master Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Agreement Ref: [AllocRef_CLP]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Career Learning Pilots £31,342 £4,826 £814 £318 £3,121 £4,614 £1,449 £3,365 £245 £4,655 £3,650 £1,713 £2,572
    Total Funding £31,342 £4,826 £814 £318 £3,121 £4,614 £1,449 £3,365 £245 £4,655 £3,650 £1,713 £2,572
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

	Funding Agreement Advanced Learner Loans Bursary
    Provider: 10117715 Co Ltd UKPRN: 10117715
    Master Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Agreement Ref: [AllocRef_ALLC]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Advanced Learner Loans Bursary Funding £28,841 £2,728 £2,318 £1,227 £3,184 £2,265 £1,386 £2,708 £3,693 £2,054 £2,021 £804 £4,453
    Total Funding £28,841 £2,728 £2,318 £1,227 £3,184 £2,265 £1,386 £2,708 £3,693 £2,054 £2,021 £804 £4,453
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus  | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017715 | [ContractNo]       | 1                     | 0                        | Draft            | Unassigned         | True          | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017715 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the Organisation details in CRM (Note: UPIN is numeric so leading zero is lost)
     And   the CRM Organisation table contains the following values
    | UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber |
    | 10017715 | 17715  | 10017715 Co Ltd | Active | AA017715      | 017715        |
    | 10117715 | 117715 | 10117715 Co Ltd | Active | AA117715      | ?             |
    
    # Tidy up
    And   the override date is reset
  
@AcceptanceTest @Withdrawn20210702
Scenario: A718 Bulk load a new multi-allocation 1819 Mainstream contract with four Delivery Orgs one of which is the Contracting Org. Check docs and CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017718'
    And   there is no Organisation data for UKPRN '10017718'

    # Add data to dbo.Organisations
    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber |
    | 10017718 | 017718 | 10017718 Co Ltd | 0              | Active | Yes           | AA017718      | 017718        |
    | 10117718 | 117718 | 10117718 Co Ltd | 0              | Active | Yes           | ?             | 117718        |
    | 10217718 | 217718 | 10217718 Co Ltd | 0              | Active | Yes           | AA217718      | ?             |
    | 10317718 | 317718 | 10317718 Co Ltd | 0              | Active | Yes           | AA317718      | 317718        |

    # Associate an Advisor with the main provider
   #And   caseload advisor 'FCS2 Test' is assigned to provider '10017718 Co Ltd' with UKPRN '10017718' and OrgId 'ORG0000000' and has 'FCS1 Test' as a manager

    # Cleardown prior to bulk import
    Given there are no files prefixed '10017718_MAIN' in the Sharepoint 'MAIN-1819-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1819 10052018112442 v3_A718' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1819 10052018112442 v3_A718' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1819 10052018112442 v3_A718' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1819 10052018112442 v3_A718' in the Sharepoint 'Reports' folder

    # Change the date
    And   the override date is '18/07/2018'

    # Bulk import a new contract with four Delivery Orgs one of which is the Contracting Org
    And   spreadsheet 'MAIN AY 1819 10052018112442 v3_A718.xlsx' exists in the Datafiles folder and UKPRN '10017718' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve the master contract, contract and allocation numbers from CRM for the first Delivery Org (which = Contracting Org)
   #And   I retrieve the latest contract details from CRM for provider '10017718' for FundingType 'MAIN' and period '1819'
    Then  I retrieve the latest EFA contract details from CRM for provider '10017718' for FundingType 'MAIN' and period '1819' and Delivery Organisation '10017718'

    # Check the contents of Appendix 1 (Summary of Funding) and the Appendix 2 (Funding Agreement) for the first Delivery Org (which = Contracting Org)
    And   a file for this contract exists in sharepoint location 'MAIN-1819-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """    
    APPENDIX 1 - SUMMARY OF EDUCATION AND SKILLS FUNDING AGENCY FUNDING 2018/19
    Organisation Name: 10017718 Co Ltd
    UKPRN: 10017718
    Allocation
    Contract Ref Aug 18 - Mar 19 Apr 19 - Jul 19 2018/19 Total
    Apprenticeships Carry-In APPS £34,079 £19,327 £53,406
    16-18 Traineeships 16TR £121,933 £54,291 £176,224
    Adult Education Budget AEC £67,771 £32,193 £99,964
    of which Community Learning £31,942 £14,467 £46,409
    Total Funding for this contract £329,594
    Education and Skills Funding Agency Appendix 1 2018/19 Master Contract ref: [MasterContractNo]
    Funding Agreement 16-18 Traineeships
    Provider: 10017718 Co Ltd UKPRN: 10017718
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    16-18 Traineeships Programme Funding £26,845 £196 £1,604 £3,646 £3,785 £4,684 £672 £176 £2,978 £4,472 £1,306 £3,223 £103
    16-18 Traineeships Bursary Funding £27,943 £4,512 £3,507 £1,571 £2,430 £2,483 £2,324 £2,800 £1,372 £705 £1,392 £4,281 £566
    Total Funding £54,788 £4,708 £5,111 £5,217 £6,215 £7,167 £2,996 £2,976 £4,350 £5,177 £2,698 £7,504 £669
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """

    # Retrieve the master contract, contract and allocation numbers from CRM for the second Delivery Org
   #And   I retrieve the latest contract details from CRM for provider '10017718' for FundingType 'MAIN' and period '1819'
    And   I retrieve the latest EFA contract details from CRM for provider '10017718' for FundingType 'MAIN' and period '1819' and Delivery Organisation '10117718'

    # Check the contents of Appendix 2 (Funding Agreement) for the second Delivery Org 
    And   a file for this contract exists in sharepoint location 'MAIN-1819-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """    
    Funding Agreement Apprenticeships Carry-In
    Provider: 10117718 Co Ltd UKPRN: 10117718
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Apprenticeships Carry-In £25,486 £1,576 £4,081 £201 £4,570 £1,364 £1,080 £3,248 £379 £2,719 £1,966 £1,596 £2,706
    Total Funding £25,486 £1,576 £4,081 £201 £4,570 £1,364 £1,080 £3,248 £379 £2,719 £1,966 £1,596 £2,706
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    Funding Agreement 16-18 Traineeships
    Provider: 10117718 Co Ltd UKPRN: 10117718
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    16-18 Traineeships Programme Funding £25,897 £2,909 £2,499 £402 £2,358 £1,439 £560 £1,882 £2,867 £1,228 £1,195 £4,930 £3,628
    16-18 Traineeships Bursary Funding £29,933 £1,268 £3,396 £4,592 £1,003 £4,189 £898 £4,507 £4,897 £2,411 £1,281 £1,036 £455
    Total Funding £55,830 £4,177 £5,895 £4,994 £3,361 £5,628 £1,458 £6,389 £7,764 £3,639 £2,476 £5,966 £4,083
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """

    # Retrieve the master contract, contract and allocation numbers from CRM for the third Delivery Org
   #And   I retrieve the latest contract details from CRM for provider '10017718' for FundingType 'MAIN' and period '1819'
    And   I retrieve the latest EFA contract details from CRM for provider '10017718' for FundingType 'MAIN' and period '1819' and Delivery Organisation '10217718'

    # Check the contents of Appendix 2 (Funding Agreement) for the third Delivery Org 
    And   a file for this contract exists in sharepoint location 'MAIN-1819-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    Funding Agreement Adult Education Budget
    Provider: 10217718 Co Ltd UKPRN: 10217718
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: [AllocRef_AEC]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Adult Education Budget £47,479 £4,083 £1,101 £2,774 £2,707 £5,226 £3,937 £7,805 £7,110 £3,237 £2,324 £3,746 £3,429
    of which Community Learning £22,030 £3,925 £508 £858 £1,122 £329 £2,709 £4,157 £3,449 £1,936 £210 £435 £2,392
    Total Funding £47,479 £4,083 £1,101 £2,774 £2,707 £5,226 £3,937 £7,805 £7,110 £3,237 £2,324 £3,746 £3,429
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """

    # Retrieve the master contract, contract and allocation numbers from CRM for the fourth Delivery Org
   #And   I retrieve the latest contract details from CRM for provider '10017718' for FundingType 'MAIN' and period '1819'
    And   I retrieve the latest EFA contract details from CRM for provider '10017718' for FundingType 'MAIN' and period '1819' and Delivery Organisation '10317718'

    # Check the contents of Appendix 2 (Funding Agreement) for the third Delivery Org 
    And   a file for this contract exists in sharepoint location 'MAIN-1819-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    Funding Agreement Apprenticeships Carry-In
    Provider: 10317718 Co Ltd UKPRN: 10317718
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Apprenticeships Carry-In £27,920 £3,403 £2,273 £2,028 £1,446 £3,192 £2,907 £124 £2,207 £4,547 £157 £4,738 £898
    Total Funding £27,920 £3,403 £2,273 £2,028 £1,446 £3,192 £2,907 £124 £2,207 £4,547 £157 £4,738 £898
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    Funding Agreement 16-18 Traineeships
    Provider: 10317718 Co Ltd UKPRN: 10317718
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    16-18 Traineeships Programme Funding £33,415 £79 £3,305 £2,215 £4,171 £3,252 £2,373 £3,695 £4,680 £3,041 £3,008 £1,792 £1,804
    16-18 Traineeships Bursary Funding £32,191 £4,396 £258 £1,454 £4,131 £1,051 £4,025 £1,368 £3,074 £4,224 £3,094 £2,849 £2,267
    Total Funding £65,606 £4,475 £3,563 £3,669 £8,302 £4,303 £6,398 £5,063 £7,754 £7,265 £6,102 £4,641 £4,071
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    Funding Agreement Adult Education Budget
    Provider: 10317718 Co Ltd UKPRN: 10317718
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: [AllocRef_AEC]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Adult Education Budget £52,485 £3,868 £887 £6,195 £2,493 £5,012 £3,723 £3,954 £6,896 £9,288 £3,425 £3,531 £3,213
    of which Community Learning £24,379 £685 £401 £2,569 £1,015 £2,040 £2,602 £2,231 £3,342 £4,961 £103 £2,146 £2,284
    Total Funding £52,485 £3,868 £887 £6,195 £2,493 £5,012 £3,723 £3,954 £6,896 £9,288 £3,425 £3,531 £3,213
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus  | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017718 | [ContractNo]       | 1                     | 0                        | Draft            | Unassigned         | True          | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017718 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the Organisation details in CRM (Note: UPIN is numeric so leading zero is lost)
     And   the CRM Organisation table contains the following values
    | UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber |
    | 10017718 | 17718  | 10017718 Co Ltd | Active | AA017718      | 017718        |
    | 10117718 | 117718 | 10117718 Co Ltd | Active | ?             | 117718        |
    | 10217718 | 217718 | 10217718 Co Ltd | Active | AA217718      | ?             |
    | 10317718 | 317718 | 10317718 Co Ltd | Active | AA317718      | 317718        |

    # Tidy up
    And   the override date is reset 
	  
