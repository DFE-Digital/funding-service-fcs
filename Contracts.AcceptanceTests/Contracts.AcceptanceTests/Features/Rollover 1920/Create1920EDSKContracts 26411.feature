Feature: Create1920EDSKContracts 26411

@AcceptanceTest @Withdrawn20210702
Scenario: A295 Bulk load a 6-allocation 1920 EDSK contract without Delivery Orgs. Check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017295' 
    And   there are no terminated or closed allocations for UKPRN '10017295' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017295' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017295' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017295 Co Ltd' with UKPRN '10017295' and OrgId 'ORG0017295' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017295' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017295 | 117295 | 10017295 Co Ltd | 0              | Provider Under Change | Yes           | AA017295      | ?             | 17 Wood Street         | ?                      | ?                      | ?                      | Barnet                 | Hertfordshire          | EN5 4AT   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017295 |




    # Change the date
    Given the override date is '02/07/2019'

    # Bulk load a new EDSK contract with all 6 EDSK allocations [Contract Type = Conditions of Funding (Grant) (Trust)]
    And   there are no files prefixed '10017295' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 05062019172844 v3_A295' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 05062019172844 v3_A295' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 05062019172844 v3_A295' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 05062019172844 v3_A295.xlsx' exists in the Datafiles folder and UKPRN '10017295' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report



    # Retrieve parameters for the Contracting Org
   #Given I retrieve the latest EFA contract details from CRM for provider '10017295' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017295'
    Given I retrieve the latest contract details from CRM for provider '10017295' for FundingType 'EDSK' and period '1920'


    # Check that all the document parts are present AND in the correct order.
    # ie Summary of Funding, Terms and Conditions, 5x(Schedule 1), 5x(Schedule 2 Payment then Schedule 2 Funding Agreement), Schedules 3-9
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """    
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017295 Co Ltd UKPRN: 10017295

    Agreement Type Conditions of Funding (Grant)
    Funding Period 1 August 2019 to 31 July 2020

    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION

    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION

    SCHEDULE 1: SPECIFICATION & MONITORING
    APPRENTICESHIPS CARRY-IN SPECIFICATION

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION

    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)

    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Funding Agreement – Advanced Learner Loans Bursary

    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
	1. The Department will pay the Provider the Funding set out in the Funding

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning

    SCHEDULE 2: PAYMENT
    APPRENTICESHIPS CARRY-IN
	1. The Provider will submit ILR Learner data monthly, and, where appropriate,

    SCHEDULE 2 – APPRENTICESHIPS CARRY-IN
    Funding Agreement – Apprenticeships Carry-In

    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS
	1. The Provider will submit ILR Learner data and the Earning Adjustment

    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships

    SCHEDULE 3: NOT USED
    """        



    # Check the individual document parts

    
    # Check the Summary of Funding doc. There should be six allocations
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017295 Co Ltd UKPRN: 10017295
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £47,768 £19,498 £67,266
    Advanced Learner Loans Bursary [AllocRef_ALLB] £28,524 £19,949 £48,473
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AECT] £45,594 £24,019 £69,613
    ESFA AEB - Adult Skills and Community Learning [AllocRef_AECA] £78,098 £42,497 £120,595
	of which Community Learning £36,870 £28,173 £65,043
    Apprenticeships Carry-In [AllocRef_APPS] £40,734 £22,206 £62,940
    16 to 18 Traineeships [AllocRef_16TR] £89,384 £40,520 £129,904
    Total Funding for this contract: £498,791
    Summary of Funding – Page 1
    """

    # Check the contents of the Main Terms and Conditions docs
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    Agreement Type Conditions of Funding (Grant)
    st st
    Funding Period 1 August 2019 to 31 July 2020
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017295 Co Ltd
    Advanced Learner Loans
    ESFA-Funded Adult Education Budget
    Apprenticeships Carry-In
    16 to 18 Traineeships
    Master Agreement Number [MasterContractNo]
    EDSK Version 3 (September 2019) Page 1

    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017295 Co Ltd THE SECRETARY OF STATE FOR
    17 Wood Street EDUCATION ACTING THROUGH
    Barnet THE EDUCATION AND SKILLS
    Hertfordshire FUNDING AGENCY, AN
    EN5 4AT EXECUTIVE AGENCY OF THE
    DEPARTMENT OF EDUCATION
    AND CHEYLESMORE HOUSE
    Company No: AA017295 QUINTON ROAD
    COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (September 2019) Page 2
    """

    # Check the contents of four sets of 'Schedule 1' docs
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    Schedule 1 – Advanced Learner Loans – Page 1
	7. The Provider shall recruit eligible Learners onto this service from the Service

    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
    Schedule 1 – ESFA-Funded Adult Education Budget – Page 1
	8. The Provider shall recruit eligible Learners onto this service from the

    SCHEDULE 1: SPECIFICATION & MONITORING
    APPRENTICESHIPS CARRY-IN SPECIFICATION
    Schedule 1 – Apprenticeships Carry-In – Page 1

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
    Schedule 1 – 16 to 18 Traineeships – Page 1
	8. The Provider shall recruit eligible Learners onto this service from the
    """

    # Check the contents of the four sets of 'Schedule 2' docs
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """    
    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Facility
    EDSK Schedule 2 – Advanced Learner Loans Version 2 (September 2019) – Page 1

    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017295 Co Ltd UKPRN: 10017295
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £67,266 £7,249 £5,744 £8,068 £6,046 £5,113 £7,675 £1,900 £5,973 £6,150 £4,380 £2,471 £6,497
    Total Funding £67,266 £7,249 £5,744 £8,068 £6,046 £5,113 £7,675 £1,900 £5,973 £6,150 £4,380 £2,471 £6,497
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017295 Co Ltd UKPRN: 10017295
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLB]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Bursary Funding £48,473 £3,855 £1,851 £5,048 £1,209 £4,434 £2,284 £2,555 £7,288 £5,282 £4,776 £3,923 £5,968
    Total Funding £48,473 £3,855 £1,851 £5,048 £1,209 £4,434 £2,284 £2,555 £7,288 £5,282 £4,776 £3,923 £5,968
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
    Schedule 2 – ESFA-Funded Adult Education Budget – Page 1

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: 10017295 Co Ltd UKPRN: 10017295
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AECT]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - 19 to 24 Traineeships £69,613 £5,348 £8,851 £4,235 £7,764 £8,279 £7,939 £1,215 £1,963 £4,714 £8,663 £8,322 £2,320
    Total Funding £69,613 £5,348 £8,851 £4,235 £7,764 £8,279 £7,939 £1,215 £1,963 £4,714 £8,663 £8,322 £2,320
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECT] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning
    Provider: 10017295 Co Ltd UKPRN: 10017295
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AECA]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills and Community Learning £120,595 £7,735 £7,372 £9,908 £10,763 £16,108 £6,272 £10,471 £9,469 £9,428 £16,403 £8,420 £8,246
    of which Community Learning £65,043 £742 £1,645 £7,130 £6,323 £7,799 £3,587 £5,481 £4,163 £7,135 £7,523 £7,421 £6,094
    Total Funding £120,595 £7,735 £7,372 £9,908 £10,763 £16,108 £6,272 £10,471 £9,469 £9,428 £16,403 £8,420 £8,246
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECA] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 2: PAYMENT
    APPRENTICESHIPS CARRY-IN
	1. The Provider will submit ILR Learner data monthly, and, where appropriate,
    Schedule 2 – Apprenticeships Carry-In – Page 1

    SCHEDULE 2 – APPRENTICESHIPS CARRY-IN
    Funding Agreement – Apprenticeships Carry-In
    Provider: 10017295 Co Ltd UKPRN: 10017295
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Apprenticeships Carry-In £62,940 £3,478 £5,936 £4,488 £2,131 £6,576 £7,395 £3,135 £7,595 £7,833 £2,534 £4,282 £7,557
    Total Funding £62,940 £3,478 £5,936 £4,488 £2,131 £6,576 £7,395 £3,135 £7,595 £7,833 £2,534 £4,282 £7,557
    Schedule 2 – Apprenticeships Carry-In – Funding Agreement [AllocRef_APPS] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS
	1. The Provider will submit ILR Learner data and the Earning Adjustment
    Schedule 2 – 16 to 18 Traineeships – Page 1

    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017295 Co Ltd UKPRN: 10017295
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    16 to 18 Traineeships Programme Funding £65,042 £4,429 £3,791 £8,772 £5,549 £9,243 £9,097 £4,293 £2,564 £4,120 £2,522 £3,006 £7,656
    16 to 18 Traineeships Bursary Funding £64,862 £3,524 £4,261 £3,821 £6,281 £7,148 £2,050 £5,704 £8,857 £7,367 £7,080 £7,183 £1,586
    Total Funding £129,904 £7,953 £8,052 £12,593 £11,830 £16,391 £11,147 £9,997 £11,421 £11,487 £9,602 £10,189 £9,242
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Check the contents of Schedules 3-8 (S3ON)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 3 (September 2019) – Page 1

    SCHEDULE 4: NOT USED
    EDSK Schedule 4 Version 3 (September 2019) – Page 1

    SCHEDULE 5: NOT USED
    EDSK Schedule 5 Version 3 (September 2019) – Page 1

    SCHEDULE 6: GDPR
    EDSK Schedule 6 Version 3 (September 2019) – Page 1

    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
    EDSK Schedule 7 Version 3 (September 2019) – Page 1

    SCHEDULE 8: EXIT ARRANGEMENTS
    EDSK Schedule 8 Version 3 (September 2019) – Page 1
    """


    # Save a copy of the output
   #And   Sharepoint file '10017295_EDSK-295_v1.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017295_EDSK-295_v1.pdf'
    And   Sharepoint file '10017295_[ContractNo]_v1.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017295_EDSK-295_v1.pdf'


    # Tidy Up
    And the override date is reset
     
@AcceptanceTest @Withdrawn20210702
Scenario: A296 Bulk load a 1920 EDSK contract with just an AEBC-ASCL1920 allocation and no Delivery Orgs. Check and save docs then publish and approve
    Given there are no allocations marked as Under Termination for UKPRN '10017296' 
    And   there are no terminated or closed allocations for UKPRN '10017296' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017296' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017296' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017296 Co Ltd' with UKPRN '10017296' and OrgId 'ORG0017296' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017296' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017296 | 117296 | 10017296 Co Ltd | 0              | In Administration     | Yes           | AA017296      | ?             | 105 Queens Road        | ?                      | ?                      | ?                      | Reading                | Berkshire              | RG1 4DA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017296 |




    # Change the date
    Given the override date is '01/07/2019'

    # Bulk load a new EDSK contract with just an AEBC-ASCL1920 allocation [Contract Type = Conditions of Funding (Grant) (College)]
    And   there are no files prefixed '10017296' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 07062019072602 v3_A296' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 07062019072602 v3_A296' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 07062019072602 v3_A296' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 07062019072602 v3_A296.xlsx' exists in the Datafiles folder and UKPRN '10017296' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report



    # Retrieve parameters for the Contracting Org
   #Given I retrieve the latest EFA contract details from CRM for provider '10017296' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017296'
    Given I retrieve the latest contract details from CRM for provider '10017296' for FundingType 'EDSK' and period '1920'


    # Check that all 6 documents have been produced in the right order by looking for the first line in each of:
    #   'Summary of Funding', then 'Main Terms and Conditions' (TAC) then Schedule 1, then Schedule 2, then 'Funding Agreement', then 'Schedule 3'
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """    
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017296 Co Ltd UKPRN: 10017296

    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2019 to 31 July 2020

    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
	8. The College shall recruit eligible Learners onto this service from the

    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
	1. The Department will pay the College the Funding set out in the Funding

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning

    SCHEDULE 3: NOT USED
    """        

    

    # Check the individual document parts

    
    # 1. Check the contents of the 'Summary of Funding' doc
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017296 Co Ltd UKPRN: 10017296
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    ESFA AEB - Adult Skills and Community Learning [AllocRef_AECA] £65,696 £43,820 £109,516
	of which Community Learning £27,918 £25,004 £52,922
    Total Funding for this contract: £109,516
    Summary of Funding – Page 1
    """



    # 2. Check the contents of the 'Main Terms and Conditions' doc (TAC)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    st st
    Funding Period 1 August 2019 to 31 July 2020
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017296 Co Ltd
    Funding for ESFA-Funded Adult Education Budget
    Master Agreement Number [MasterContractNo]
    EDSK Version 3 (September 2019) Page 1

    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017296 Co Ltd THE SECRETARY OF STATE FOR
    105 Queens Road EDUCATION ACTING THROUGH
    Reading THE EDUCATION AND SKILLS
    Berkshire FUNDING AGENCY, AN
    RG1 4DA EXECUTIVE AGENCY OF THE
    AND
    DEPARTMENT OF EDUCATION
    CHEYLESMORE HOUSE
    Company No: AA017296 QUINTON ROAD
    COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the College the Department
    EDSK Version 3 (September 2019) Page 2
    """


    # 3. Check the contents of Schedule 1 (S1)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
    Schedule 1 – ESFA-Funded Adult Education Budget – Page 1
	8. The College shall recruit eligible Learners onto this service from the
    """


    # 4. Check the contents of Schedule 2 (S2)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """    
    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
	Schedule 2 – ESFA-Funded Adult Education Budget – Page 1
	"""


	# 5. Check the contents of the 'Funding Agreement'
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning
    Provider: 10017296 Co Ltd UKPRN: 10017296
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AECA]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills and Community Learning £109,516 £8,409 £8,579 £5,958 £9,599 £10,852 £10,819 £5,077 £6,403 £12,486 £10,140 £7,115 £14,079
    of which Community Learning £52,922 £1,758 £3,679 £5,867 £3,032 £5,697 £3,541 £4,168 £176 £6,312 £5,919 £4,985 £7,788
    Total Funding £109,516 £8,409 £8,579 £5,958 £9,599 £10,852 £10,819 £5,077 £6,403 £12,486 £10,140 £7,115 £14,079
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECA] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # 6. Check the contents of Schedules 3-9' (S3ON)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 3 (September 2019) – Page 1

    SCHEDULE 4: NOT USED
    EDSK Schedule 4 Version 3 (September 2019) – Page 1

    SCHEDULE 5: NOT USED
    EDSK Schedule 5 Version 3 (September 2019) – Page 1

    SCHEDULE 6: GDPR
    EDSK Schedule 6 Version 3 (September 2019) – Page 1

    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
    EDSK Schedule 7 Version 3 (September 2019) – Page 1

    SCHEDULE 8: EXIT ARRANGEMENTS
    EDSK Schedule 8 Version 3 (September 2019) – Page 1

    SCHEDULE 9: COLLEGE GOVERNANCE
    EDSK Schedule 9 Version 3 (September 2019) – Page 1
    """


    # Save a copy of the output
   #And   Sharepoint file '10017296_EDSK-295_v1.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017296_EDSK-296_v1.pdf'
    And   Sharepoint file '10017296_[ContractNo]_v1.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017296_EDSK-296_v1.pdf'



    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '05/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-296' and actual ContractNumber 'EDSK-296'
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017296 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017296 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '60' deliverable period rows in CRM linked to the latest version of contract 'EDSK-296'
    And   there are '60' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20210702
Scenario: A297 Bulk load a 1920 EDSK contract with ALLF, ALLBC and APPS allocations but no Delivery Orgs. Check and save docs then publish and approve
    Given there are no allocations marked as Under Termination for UKPRN '10017297' 
    And   there are no terminated or closed allocations for UKPRN '10017297' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017297' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017297' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017297 Co Ltd' with UKPRN '10017297' and OrgId 'ORG0017297' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017297' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017297 | 117297 | 10017297 Co Ltd | 0              | Provider Under Change | Yes           | AA017297      | ?             | 68 Barton Street       | North Greys            | ?                      | ?                      | Whigton                | Berks                  | CH66 4YE  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017297 |




    # Change the date
    Given the override date is '12/07/2019'

    # Bulk load a new EDSK contract with 3 EDSK allocations  [Contract Type = Conditions of Funding (Grant) (Employer)]
    And   there are no files prefixed '10017297' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 07062019081435 v3_A297' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 07062019081435 v3_A297' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 07062019081435 v3_A297' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 07062019081435 v3_A297.xlsx' exists in the Datafiles folder and UKPRN '10017297' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report



    # Retrieve parameters for the Contracting Org
   #Given I retrieve the latest EFA contract details from CRM for provider '10017297' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017297'
    Given I retrieve the latest contract details from CRM for provider '10017297' for FundingType 'EDSK' and period '1920'


    # Check that all 6 documents have been produced in the right order by looking for the first line in each of:
    #   'Summary of Funding', then 'Main Terms and Conditions' (TAC) then Schedule 1, then Schedule 2, then 'Funding Agreement', then 'Schedule 3'
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """    
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017297 Co Ltd UKPRN: 10017297

    Agreement Type Conditions of Funding (Grant) (Employers)
    Funding Period 1 August 2019 to 31 July 2020

    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION

    SCHEDULE 1: SPECIFICATION & MONITORING
    APPRENTICESHIPS CARRY-IN SPECIFICATION
	12.The Employer will not recruit new Learners to this Service.

    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)

    SCHEDULE 2 – ADVANCED LEARNER LOANS     
	Funding Agreement – Advanced Learner Loans Facility
    Funding Agreement – Advanced Learner Loans Bursary

    SCHEDULE 2: PAYMENT
    APPRENTICESHIPS CARRY-IN
	1. The Employer will submit ILR Learner data monthly, and, where appropriate,

    SCHEDULE 2 – APPRENTICESHIPS CARRY-IN
    Funding Agreement – Apprenticeships Carry-In

    SCHEDULE 3: NOT USED
    """        



    # Check the individual document parts

    
    # 1. Check the Summary of Funding doc. There should be three allocations
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017297 Co Ltd UKPRN: 10017297
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £21,000 £10,426 £31,426
    Advanced Learner Loans Bursary [AllocRef_ALLC] £35,131 £8,733 £43,864
    Apprenticeships Carry-In [AllocRef_APPS] £35,416 £20,867 £56,283
    Total Funding for this contract: £131,573
    Summary of Funding – Page 1
    """




    # 2. Check the contents of the Main Terms and Conditions docs
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    Agreement Type Conditions of Funding (Grant) (Employers)
    st st
    Funding Period 1 August 2019 to 31 July 2020
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017297 Co Ltd
    Advanced Learner Loans
    Apprenticeships Carry-In
    Master Agreement Number [MasterContractNo]
    EDSK Version 3 (September 2019) Page 1

    This Agreement is made on the date the Agreement is digitally signed by the
    Employer on the Manage Your Education & Skills Funding Service between:
    10017297 Co Ltd THE SECRETARY OF STATE FOR
    68 Barton Street EDUCATION ACTING THROUGH
    North Greys THE EDUCATION AND SKILLS
    Whigton FUNDING AGENCY, AN
    Berks EXECUTIVE AGENCY OF THE
    CH66 4YE DEPARTMENT OF EDUCATION
    AND CHEYLESMORE HOUSE
    QUINTON ROAD
    Company No: AA017297 COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Employer the Department
    EDSK Version 3 (September 2019) Page 2
    """




    # 3. Check the contents of Schedule 1 (S1)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    Schedule 1 – Advanced Learner Loans – Page 1
    SCHEDULE 1B: MONITORING 
    ADVANCED LEARNER LOANS MONITORING (PAY ON PROFILE)
    Schedule 1 – Advanced Learner Loans – Page 8

    SCHEDULE 1: SPECIFICATION & MONITORING
    APPRENTICESHIPS CARRY-IN SPECIFICATION
    Schedule 1 – Apprenticeships Carry-In – Page 1
    """




    # 4. Check the contents of the two sets of 'Schedule 2' docs (S2)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """    
    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Facility
    EDSK Schedule 2 – Advanced Learner Loans Version 2 (September 2019) – Page 1

    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017297 Co Ltd UKPRN: 10017297
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £31,426 £579 £6,778 £1,970 £494 £7,033 £1,205 £2,787 £154 £101 £6,099 £4,008 £218
    Total Funding £31,426 £579 £6,778 £1,970 £494 £7,033 £1,205 £2,787 £154 £101 £6,099 £4,008 £218
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017297 Co Ltd UKPRN: 10017297
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLC]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Bursary Funding £43,864 £5,641 £7,562 £1,799 £6,915 £1,629 £7,425 £100 £4,060 £2,244 £1,852 £917 £3,720
    Total Funding £43,864 £5,641 £7,562 £1,799 £6,915 £1,629 £7,425 £100 £4,060 £2,244 £1,852 £917 £3,720
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLC] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 2: PAYMENT
    APPRENTICESHIPS CARRY-IN 
    Schedule 2 – Apprenticeships Carry-In – Page 1

    SCHEDULE 2 – APPRENTICESHIPS CARRY-IN
    Funding Agreement – Apprenticeships Carry-In
	Provider: 10017297 Co Ltd UKPRN: 10017297
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Apprenticeships Carry-In £56,283 £7,357 £2,888 £6,232 £7,382 £334 £7,690 £1,522 £2,011 £4,272 £7,552 £7,775 £1,268
    Total Funding £56,283 £7,357 £2,888 £6,232 £7,382 £334 £7,690 £1,522 £2,011 £4,272 £7,552 £7,775 £1,268
    Schedule 2 – Apprenticeships Carry-In – Funding Agreement [AllocRef_APPS] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """




    # 6. Check the contents of Schedules 3-8' (S3ON)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 3 (September 2019) – Page 1

    SCHEDULE 4: NOT USED
    EDSK Schedule 4 Version 3 (September 2019) – Page 1

    SCHEDULE 5: NOT USED
    EDSK Schedule 5 Version 3 (September 2019)  – Page 1

    SCHEDULE 6: GDPR
    EDSK Schedule 6 Version 3 (September 2019) – Page 1

    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
    EDSK Schedule 7 Version 3 (September 2019) – Page 1

    SCHEDULE 8: EXIT ARRANGEMENTS
    EDSK Schedule 8 Version 3 (September 2019) – Page 1
    """



    # Save a copy of the output
   #And   Sharepoint file '10017297_EDSK-297_v1.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017297_EDSK-297_v1.pdf'
    And   Sharepoint file '10017297_[ContractNo]_v1.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017297_EDSK-297_v1.pdf'
    



    # Change the date
    Given the override date is '15/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '16/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-297' and actual ContractNumber 'EDSK-297'
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017297 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017297 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '384' deliverable period rows in CRM linked to the latest version of contract 'EDSK-297'
    And   there are '384' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'


    # Tidy up
    Then   the override date is reset

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run123
Scenario: A299 Create a 3-allocation 1920 EDSK contract with 2 FSPGroups but no Delivery Orgs. Bulk update draft to add an APPS alloc\FSPGroup and an AEB alloc\FSPGroup. Check and save docs then publish and approve
    Given there are no allocations marked as Under Termination for UKPRN '10017299' 
    And   there are no terminated or closed allocations for UKPRN '10017299' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017299' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16TR-299      |
    | AECA-299      |
    | AECT-299      |
    | ALLB-299      |
    | ALLF-299      |
    | APPS-299      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017299' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017299, Sons and Daughters Co Ltd' with UKPRN '10017299' and OrgId 'ORG0017299' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017299' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                                | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017299 | 117299 | 10017299, Sons and Daughters Co Ltd | 0              | Provider Under Change | Yes           | AA017299      | ?             | 17 Wood Street         | ?                      | ?                      | ?                      | Barnet                 | Hertfordshire          | EN5 4AT   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017299 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName                           | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017299 | 10017299, Sons and Daughters Co Ltd | ESFA-299             | EDSK-299       | 1                     | 01/08/2019        | 31/07/2020      | 93429.00      |                                    | Conditions of Funding (Grant) (HEI)        | 1920   | New          | ORG0017299 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017299 | EDSK-299       | 16TR-299      | 16-18TRN          | 16-18TRN1920            | AY                      | 01/08/2019          | 31/07/2020        | 47285.00        |                                         |            |                                                             | New          |             |
  # | 10017299 | EDSK-299       | AECA-299      | AEBC-ASCL         | AEBC-ASCL1920           | AY                      | 01/08/2019          | 31/07/2020        | 41436.00        |                                         |            |                                                             | New          |             |
  # | 10017299 | EDSK-299       | AECT-299      | AEBC-19TRN        | AEBC-19TRN1920          | AY                      | 01/08/2019          | 31/07/2020        | 24121.00        |                                         |            |                                                             | New          |             |
    | 10017299 | EDSK-299       | ALLB-299      | ALLB              | ALLB1920                | AY                      | 01/08/2019          | 31/07/2020        | 23322.00        |                                         |            |                                                             | New          |             |
    | 10017299 | EDSK-299       | ALLF-299      | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 31/07/2020        | 22822.00        |                                         |            |                                                             | New          |             |
  # | 10017299 | EDSK-299       | APPS-299      | APPS              | APPS1920                | AY                      | 01/08/2019          | 31/07/2020        | 21767.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017299 | EDSK-299       | 16TR-299      | 1               | 0                     | 47285.00  | 5320.00  | 2519.00  | 1555.00  | 1729.00  | 3928.00  | 4733.00  | 5034.00  | 5113.00  | 1175.00  | 5587.00  | 3453.00  | 7139.00  | 16-18 Traineeships Funding                                      | New          |             |
    | 10017299 | EDSK-299       | 16TR-299      | 2               | 1                     | 23333.00  | 2808.00  | 2215.00  | 293.00   | 1376.00  | 847.00   | 3416.00  | 2127.00  | 2294.00  | 56.00    | 2087.00  | 2413.00  | 3401.00  | 16-18 Traineeships Programme Funding                            | New          |             |
    | 10017299 | EDSK-299       | 16TR-299      | 3               | 1                     | 23952.00  | 2512.00  | 304.00   | 1262.00  | 353.00   | 3081.00  | 1317.00  | 2907.00  | 2819.00  | 1119.00  | 3500.00  | 1040.00  | 3738.00  | 16-18 Traineeships Bursary Funding                              | New          |             |
  # | 10017299 | EDSK-299       | AECA-299      | 1               | 0                     | 41436.00  | 4272.00  | 3624.00  | 6550.00  | 1474.00  | 3862.00  | 2137.00  | 3609.00  | 4859.00  | 1110.00  | 2992.00  | 4746.00  | 2201.00  | Adult Education Budget Total Funding                            | New          |             |
  # | 10017299 | EDSK-299       | AECA-299      | 2               | 1                     | 22618.00  | 3557.00  | 1699.00  | 3572.00  | 671.00   | 237.00   | 1541.00  | 1328.00  | 2949.00  | 805.00   | 2554.00  | 1991.00  | 1714.00  | Adult Skills Total Funding                                      | New          |             |
  # | 10017299 | EDSK-299       | AECA-299      | 5               | 1                     | 18818.00  | 715.00   | 1925.00  | 2978.00  | 803.00   | 3625.00  | 596.00   | 2281.00  | 1910.00  | 305.00   | 438.00   | 2755.00  | 487.00   | Community Learning                                              | New          |             |
  # | 10017299 | EDSK-299       | AECT-299      | 1               | 0                     | 24121.00  | 2949.00  | 3527.00  | 2776.00  | 1328.00  | 1970.00  | 2009.00  | 1891.00  | 2247.00  | 196.00   | 680.00   | 1194.00  | 3354.00  | 19-24 Traineeships Total Funding                                | New          |             |
    | 10017299 | EDSK-299       | ALLB-299      | 1               | 0                     | 23322.00  | 1609.00  | 1555.00  | 2701.00  | 2963.00  | 3161.00  | 2568.00  | 645.00   | 1728.00  | 1199.00  | 67.00    | 2479.00  | 2647.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             |
    | 10017299 | EDSK-299       | ALLF-299      | 5               | 0                     | 22822.00  | 2945.00  | 1275.00  | 1601.00  | 2589.00  | 2343.00  | 1117.00  | 2076.00  | 183.00   | 193.00   | 2130.00  | 2738.00  | 3632.00  | Advanced Learner Loans Facility                                 | New          |             |
  # | 10017299 | EDSK-299       | APPS-299      | 1               | 0                     | 21767.00  | 3025.00  | 723.00   | 2946.00  | 960.00   | 2235.00  | 377.00   | 2250.00  | 3050.00  | 2615.00  | 218.00   | 2724.00  | 644.00   | Apprenticeships Carry-In Total Funding                          | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'




    # Change the date
    Given the override date is '03/07/2019'

    # Bulk upload an Update Draft to change financials and add an APPS and an AEBC-ASCL allocation
    And   there are no files prefixed '10017299' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 03062019095857 v3_A299' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 03062019095857 v3_A299' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 03062019095857 v3_A299' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 03062019095857 v3_A299.xlsx' exists in the Datafiles folder and UKPRN '10017299' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report



    # Retrieve parameters for the Contracting Org
   #Given I retrieve the latest EFA contract details from CRM for provider '10017299' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017299'
    Given I retrieve the latest contract details from CRM for provider '10017299' for FundingType 'EDSK' and period '1920'

    # Check that all the document parts are present AND in the correct order.
    # ie Summary of Funding, Terms and Conditions, 4x(Schedule 1), 4x(Schedule 2 Payment then Schedule 2 Funding Agreement), Schedules 3-9
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """    
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017299, Sons and Daughters Co Ltd UKPRN: 10017299
    Agreement Type Conditions of Funding (Grant) (HEI)
    Advanced Learner Loans
    ESFA-Funded Adult Education Budget
    Apprenticeships Carry-In
    16 to 18 Traineeships

    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION

    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
	8. The Provider shall recruit eligible Learners onto this service from the

    SCHEDULE 1: SPECIFICATION & MONITORING
    APPRENTICESHIPS CARRY-IN SPECIFICATION
	12.The Provider will not recruit new Learners to this Service.

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
	8. The Provider shall recruit eligible Learners onto this service from the

    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)

    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Funding Agreement – Advanced Learner Loans Bursary
    
    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
	1. The Department will pay the Provider the Funding set out in the Funding

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning

    SCHEDULE 2: PAYMENT
    APPRENTICESHIPS CARRY-IN
	1. The Provider will submit ILR Learner data monthly, and, where appropriate,

    SCHEDULE 2 – APPRENTICESHIPS CARRY-IN
    Funding Agreement – Apprenticeships Carry-In

    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS
	1. The Provider will submit ILR Learner data and the Earning Adjustment

    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships

    SCHEDULE 3: NOT USED
    """    




    # Save a copy of the output
   #And   Sharepoint file '10017299_[ContractNo]_v1.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017299_[ContractNo]_v1.pdf'
    And   Sharepoint file '10017299_EDSK-299_v1.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017299_EDSK-299_v1.pdf'




    # Change the date
    Given the override date is '04/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-299' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '05/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-299' and actual ContractNumber 'EDSK-299'
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-299' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017299 | EDSK-299           | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017299 | EDSK-299           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017299 | ESFA-299           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '480' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '480' deliverable period rows in CRM linked to the latest version of contract 'EDSK-299'



    # Tidy Up
    And the override date is reset
	  
