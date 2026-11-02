Feature: Create1920ALLFcontractsA 25878

@AcceptanceTest @Withdrawn20230123
Scenario: A742 Bulk load a new 1920 EDSK contract with an ALLF(NoPay) allocation. No Delivery Orgs. ContractType is Conditions of Funding (Grant)(College). Check docs then merge
    Given there are no allocations marked as Under Termination for UKPRN '10017742' 
    And   there are no terminated or closed allocations for UKPRN '10017742' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017742' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-742      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017742' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017742 Co Ltd' with UKPRN '10017742' and OrgId 'ORG0017742' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status    | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017742 | 117742 | 10017742 Co Ltd | 0              | Active    | Yes           | AA017742      | ?             | 16 St. Thomas Street   | Bristol                | ?                      | ?                      | ?                      | Avon                   | BS1 6JJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017742 |




    # Change the date
    Given the override date is '01/07/2019'

    # Bulk import to create a new 1920 ALLF Education and Skills contract for ContractType 'Conditions of Funding (Grant) (College)'
    And   there are no files prefixed '10017742' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed '10017742' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 31052019102834 v3_A742' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 31052019102834 v3_A742' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 31052019102834 v3_A742.xlsx' exists in the Datafiles folder and UKPRN '10017742' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters 
   #And   I retrieve the latest EFA contract details from CRM for provider '10017742' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017742'
    And   I retrieve the latest contract details from CRM for provider '10017742' for FundingType 'EDSK' and period '1920'

    # Assign a Caseload Advisor
    Given caseload advisor 'FCS2 Test' is assigned to UKPRN '10017742'



    # Check that all 6 documents have been produced in the right order by looking for the first line in each of:
    #   'Summary of Funding', then 'Main Terms and Conditions' (TAC) then Schedule 1, then Schedule 2, then 'Funding Agreement', then 'Schedule 3'
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Agreement Type Conditions of Funding (Grant) (Colleges)
	SCHEDULE 1: SPECIFICATION & MONITORING
    SCHEDULE 2: PAYMENT
	SCHEDULE 2 – ADVANCED LEARNER LOANS
    SCHEDULE 3: NOT USED
    """



    # 1. Check the contents of the 'Summary of Funding' doc
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017742 Co Ltd UKPRN: 10017742
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £14,978 £15,366 £30,344
    Total Funding for this contract: £30,344
    Summary of Funding – Page 1
    """




    # 2. Check the contents of the 'Main Terms and Conditions' doc (TAC)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    st st
    Funding Period 1 August 2019 to 31 July 2020
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017742 Co Ltd
    Funding for Advanced Learner Loans
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY COLLEGE
    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
    THE COLLEGE REPRESENTS AND WARRANTS THAT THE COLLEGE HAS READ
    AND UNDERSTOOD THIS AGREEMENT, THE COLLEGE AGREES TO BE BOUND
    BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO ACCEPT
    THIS AGREEMENT AND LEGALLY BIND THE COLLEGE.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    acting through the Education and Skills Funding Agency
    by Eileen Milner, Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (September 2019) Page 1

    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017742 Co Ltd THE SECRETARY OF STATE FOR
    16 St. Thomas Street EDUCATION ACTING THROUGH
    Bristol THE EDUCATION AND SKILLS
    Avon FUNDING AGENCY, AN
    BS1 6JJ EXECUTIVE AGENCY OF THE
    AND
    DEPARTMENT OF EDUCATION
    CHEYLESMORE HOUSE
    Company No: AA017742 QUINTON ROAD
    COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the College the Department
    EDSK Version 3 (September 2019) Page 2
	"""




    # 3. Check the contents of Schedule 1 (S1)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    “Loans Facility” gives the College the authority to access Loans
	Schedule 1 – Advanced Learner Loans – Page 1

    Company and the College.
    levels 3, 4, 5 and 6 that will be provided by the College.
    If the Service is terminated, the Department will remove the College’s
    7. The College shall recruit eligible Learners onto this service from the Service
	Schedule 1 – Advanced Learner Loans – Page 2

    9. The College shall aim to maximise the use of the Loans Facility and Bursary
    10.The College shall not recruit Learners from another contractor that has
    12.The College will deliver the Advanced Learner Loans Provision set out in
    13.The College will maximise the number of Learners that achieve a
    14.The College will maintain evidence of the delivery of the Service as set out
    15.The College will support eligible Learners by using the Loans Bursary to
    16.The College will support eligible Learners using Exceptional Learning
    17.In delivering the Advanced Learner Loans Provision, the College will comply
    Rules the College must not sub-contract Advanced Learner Loans Provision
    19.The College must deliver the Advanced Learner Loans Provision in England
	Schedule 1 – Advanced Learner Loans – Page 3

    20.The College will deliver the Service in a way that ensures
    College must migrate data for continuing Learners from the 2018 to 2019
    ILR to the 2019 to 2020 ILR.  The College must submit this data in the first
    22.The College will submit Learner Data to the Department to comply with
    data submitted to the SLC by the College.  Failure to submit records for less
    23.The College shall complete the Learner's qualification on or before the
    planned end date in the data submitted in the ILR.  Where the College
    24.Where required, the College shall submit funding claims in line with
    25.The College will support the five stages of loans administration as set out in
    26.The College must repay any funds paid in error by the SLC including where
    the College has not informed the SLC that a Learner has withdrawn from or
    changed their qualification.  The College will repay within 30 days of being
	Schedule 1 – Advanced Learner Loans – Page 4

    27.The College cannot exceed for any reason the Loans Facility and Loans
    28.The College must inform the Department of any changes to their bank
    details.  The College must not use the new account until the account has
    32.The Department will supply the College’s verified bank details to the SLC to
	Schedule 1 – Advanced Learner Loans – Page 5
    
    SCHEDULE 1B: MONITORING
	https://submitlearnerdatabeta.fasst.org.uk/. The College must access the
    3. If served with notice of a breach, the College must correct data or supply
    5. The College’s submission of data to the SLC will be monitored against the
    service levels set out in the College’s SLC Service Agreement.  The College 
    Loans Funding Rules, the Department may invite Colleges to submit
	Schedule 1 – Advanced Learner Loans – Page 6

    applications and/or to stop making Loans payments to the College, and/or
    reclaim any Loans payments made, where the College exceeds its Loans
    11.The Department will reconcile the College’s earnings against the payments
    13.Where the College’s actual delivery in the final claim, as against the contract
    Department to the College, the Department will deduct the amount owed
    College.  Where the overpayment cannot be recovered from future
    payments within the Financial Year, the Department will invoice the College
    14.Where the College’s actual delivery in the final claim, has exceeded the
    contract Allocation, the College does so at their own risk.  The Department
    15.Should there be an under or over payment to the College, the Department
	Schedule 1 – Advanced Learner Loans – Page 7
    """
	



    # 4. Check the contents of Schedule 2 (S2)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 2: PAYMENT
    2. The College’s Loans Facility is set out in the Funding Agreement of this
    3. The Department will pay the College the Funding set out in the Funding
    5. The College must submit a planned claim for Exceptional Learning Support
    in the Advanced Learner Loans Funding Rules. The College must not incur
	EDSK Schedule 2 – Advanced Learner Loans Version 2 (September 2019) – Page 1
    """




    # 5. Check the contents of the 'Funding Agreement'
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017742 Co Ltd UKPRN: 10017742
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £30,344 £1,814 £62 £3,205 £1,729 £317 £2,440 £4,022 £1,389 £1,336 £7,334 £5,243 £1,453
    Total Funding £30,344 £1,814 £62 £3,205 £1,729 £317 £2,440 £4,022 £1,389 £1,336 £7,334 £5,243 £1,453
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """



    # 6. Check the contents of Schedules 3-9' (S3ON)
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
    
    #And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'



    # Change the date
    Given the override date is '03/07/2019'
    
    # Create a dummy Terms and Conditions file based on Resources/DummyPdf.pdf. (One page containing just the work 'Appendices')
    And   there are no files prefixed '10017742' in the Sharepoint 'EDSK-1920-Input-Terms And Conditions' folder
    And   a file with filename '10017742_[ContractNo]_44.pdf' is created in 'EDSK-1920-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017742' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check that the doc merge task has been completed for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017742'
    | Task                             | Description                                         | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Initiate Document Merge          | 10017742 - 10017742 Co Ltd Awaiting documentation   | [ContractNo]   | Document Management Team  | ?                        | Completed       | Completed        |


    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017742 | [ContractNo]       | 1                     | 0                        | Draft            | In Review                 | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017742 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |



    # Tidy up
    And   the override date is reset
  
@AcceptanceTest @Withdrawn20230123
Scenario: A743 Bulk load a new 1920 EDSK contract with an ALLF(NoPay) allocation. No Delivery Orgs. ContractType is Conditions of Funding (Grant)(Employer). Check docs then merge
    Given there are no allocations marked as Under Termination for UKPRN '10017743' 
    And   there are no terminated or closed allocations for UKPRN '10017743' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017743' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-743      |


   # Set organisation and advisors 
   Given there is no Organisation data for UKPRN '10017743' 
   And   caseload advisor 'FCS2 Test' is assigned to provider '10017743 Co Ltd' with UKPRN '10017743' and OrgId 'ORG0017743' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name             | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1    | AddressLine2 | AddressLine3 | AddressLine4 | Town | County | Postcode |
    | 10017743 | 117743 | 10017743 Co Ltd  | 0              | Active | Yes           | AA017743      | 17743         | 60 Union Street | Aberdeen     | ?            | ?            | ?    | ?      | AB10 1BB |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017743 |


    # Change the date
    Given the override date is '06/07/2019'

    # Bulk import to create a new 1920 ALLF Education and Skills with four delivery orgs none of which matches the contracting org
    And   there are no files prefixed '10017743' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed '10017743' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 31052019110954 v3_A743' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 31052019110954 v3_A743' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 31052019110954 v3_A743.xlsx' exists in the Datafiles folder and UKPRN '10017743' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters 
   #And   I retrieve the latest EFA contract details from CRM for provider '10017743' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017743'
    And   I retrieve the latest contract details from CRM for provider '10017743' for FundingType 'EDSK' and period '1920'

    # Assign a Caseload Advisor
    Given caseload advisor 'FCS2 Test' is assigned to UKPRN '10017743'




    # Check that all 6 documents have been produced in the right order by looking for the first line in each of:
    #   'Summary of Funding', then 'Main Terms and Conditions' (TAC) then Schedule 1, then Schedule 2, then 'Funding Agreement', then 'Schedule 3'
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Agreement Type Conditions of Funding (Grant) (Employers)
    SCHEDULE 1: SPECIFICATION & MONITORING
    SCHEDULE 2: PAYMENT
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    SCHEDULE 3: NOT USED
    """


    # 1. Check the contents of the 'Summary of Funding' doc for Contracting Org
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017743 Co Ltd UKPRN: 10017743
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £36,733 £14,767 £51,500
    Total Funding for this contract: £51,500
    Summary of Funding – Page 1
    """




    # 2. Check the contents of the 'Main Terms and Conditions' doc (TAC)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    Agreement Type Conditions of Funding (Grant) (Employers)
    st st
    Funding Period 1 August 2019 to 31 July 2020
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017743 Co Ltd
    Funding for Advanced Learner Loans
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY EMPLOYER
    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
    THE EMPLOYER REPRESENTS AND WARRANTS THAT THE EMPLOYER HAS
    READ AND UNDERSTOOD THIS AGREEMENT, THE EMPLOYER AGREES TO BE
    BOUND BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO
    ACCEPT THIS AGREEMENT AND LEGALLY BIND THE EMPLOYER.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    acting through the Education and Skills Funding Agency
    by Eileen Milner, Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (September 2019) Page 1

    This Agreement is made on the date the Agreement is digitally signed by the
    Employer on the Manage Your Education & Skills Funding Service between:
    10017743 Co Ltd THE SECRETARY OF STATE FOR
    60 Union Street EDUCATION ACTING THROUGH
    Aberdeen THE EDUCATION AND SKILLS
    AB10 1BB FUNDING AGENCY, AN
    EXECUTIVE AGENCY OF THE
    DEPARTMENT OF EDUCATION
    Company No: AA017743 AND CHEYLESMORE HOUSE
    QUINTON ROAD
    COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Employer the Department
    EDSK Version 3 (September 2019) Page 1
	"""




    # 3. Check the contents of Schedule 1 (S1)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
	SCHEDULE 1: SPECIFICATION & MONITORING
    “Loans Facility” gives the Employer the authority to access Loans
	Schedule 1 – Advanced Learner Loans – Page 1

    Company and the Employer.
    levels 3, 4, 5 and 6 that will be provided by the Employer.
    If the Service is terminated, the Department will remove the Employer’s
    7. The Employer shall recruit eligible Learners onto this service from the
	Schedule 1 – Advanced Learner Loans – Page 2

    9. The Employer shall aim to maximise the use of the Loans Facility and
    10.The Employer shall not recruit Learners from another contractor that has
    12.The Employer will deliver the Advanced Learner Loans Provision set out in
    13.The Employer will maximise the number of Learners that achieve a
    14.The Employer will maintain evidence of the delivery of the Service as set
    15.The Employer will support eligible Learners by using the Loans Bursary to
    16.The Employer will support eligible Learners using Exceptional Learning
    17.In delivering the Advanced Learner Loans Provision, the Employer will
    Rules the Employer must not sub-contract Advanced Learner Loans
    19.The Employer must deliver the Advanced Learner Loans Provision in
	Schedule 1 – Advanced Learner Loans – Page 3

    20.The Employer will deliver the Service in a way that ensures
    Employer must migrate data for continuing Learners from the 2018 to 2019
    ILR to the 2019 to 2020 ILR.  The Employer must submit this data in the first
    22.The Employer will submit Learner Data to the Department to comply with
    data submitted to the SLC by the Employer.  Failure to submit records for
    23.The Employer shall complete the Learner's qualification on or before the
    planned end date in the data submitted in the ILR.  Where the Employer
    24.Where required, the Employer shall submit funding claims in line with
    25.The Employer will support the five stages of loans administration as set out
    26.The Employer must repay any funds paid in error by the SLC including
    where the Employer has not informed the SLC that a Learner has withdrawn
    from or changed their qualification.  The Employer will repay within 30 days
    Schedule 1 – Advanced Learner Loans – Page 4

	27.The Employer cannot exceed for any reason the Loans Facility and Loans
    28.The Employer must inform the Department of any changes to their bank
    details.  The Employer must not use the new account until the account has
    32.The Department will supply the Employer’s verified bank details to the SLC
    Schedule 1 – Advanced Learner Loans – Page 5

    SCHEDULE 1B: MONITORING
	https://submitlearnerdatabeta.fasst.org.uk/. The Employer must access the
    3. If served with notice of a breach, the Employer must correct data or supply
    5. The Employer’s submission of data to the SLC will be monitored against the
    service levels set out in the Employer’s SLC Service Agreement.  The
    Employer must take any corrective action to correct submissions or service
    Loans Funding Rules, the Department may invite Employers to submit
	Schedule 1 – Advanced Learner Loans – Page 6

    applications and/or to stop making Loans payments to the Employer, and/or
    reclaim any Loans payments made, where the Employer exceeds its Loans
    11.The Department will reconcile the Employer’s earnings against the
    13.Where the Employer’s actual delivery in the final claim, as against the
    the Department to the Employer, the Department will deduct the amount
    Employer.  Where the overpayment cannot be recovered from future
    Employer for the remaining debt and the Employer will pay the invoice within
    14.Where the Employer’s actual delivery in the final claim, has exceeded the
    contract Allocation, the Employer does so at their own risk.  The Department
    15.Should there be an under or over payment to the Employer, the Department
    Schedule 1 – Advanced Learner Loans – Page 7
	"""




    # 4. Check the contents of Schedule 2 (S2)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
	SCHEDULE 2: PAYMENT
    2. The Employer’s Loans Facility is set out in the Funding Agreement of this
    3. The Department will pay the Employer the Funding set out in the Funding
    5. The Employer must submit a planned claim for Exceptional Learning
    set out in the Advanced Learner Loans Funding Rules. The Employer must
	EDSK Schedule 2 – Advanced Learner Loans Version 2 (September 2019) – Page 1
    """



    # 5. Check the contents of the 'Funding Agreement'
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017743 Co Ltd UKPRN: 10017743
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £51,500 £7,949 £3,819 £6,144 £5,008 £2,578 £7,758 £167 £3,310 £7,673 £422 £2,545 £4,127
    Total Funding £51,500 £7,949 £3,819 £6,144 £5,008 £2,578 £7,758 £167 £3,310 £7,673 £422 £2,545 £4,127
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
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
    

    # Contract status is now at 'Awaiting Documentation'



    # Change the date
    Given the override date is '08/07/2019'

    # Assign a caseload Advisor
    And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017743'
    
    # Create dummy Terms and Conditions files base on Resources/DummyPdf.pdf. Each has one page containing just the work 'Appendices'
    And   there are no files prefixed '10017743' in the Sharepoint 'EDSK-1920-Input-Terms And Conditions' folder
    And   a file with filename '10017743_[ContractNo]_23.pdf' is created in 'EDSK-1920-Input-Terms And Conditions'
    And   a file with filename '10017743_[ContractNo]_87.pdf' is created in 'EDSK-1920-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017743' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check that the doc merge task has been completed for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017743'
    | Task                             | Description                                         | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Initiate Document Merge          | 10017743 - 10017743 Co Ltd Awaiting documentation   | [ContractNo]   | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the WORKFLOW HISTORY for a merge successful event
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                           | CompletedBy     | Comment                        |
    | Document Merge Successful        | CRM Integration | ?                              |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017743 | [ContractNo]       | 1                     | 0                        | Draft            | In Review                 | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017743 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
Scenario: A744 Bulk load a new 1920 EDSK contract with an ALLF(NoPay) allocation. No Delivery Orgs. ContractType is Conditions of Funding (Grant)(HEI). Check docs then merge
    Given there are no allocations marked as Under Termination for UKPRN '10017744' 
    And   there are no terminated or closed allocations for UKPRN '10017744' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017744' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-744      |


   # Set organisation and advisors 
   Given there is no Organisation data for UKPRN '10017744' 
   And   caseload advisor 'FCS2 Test' is assigned to provider '10017744 Co Ltd' with UKPRN '10017744' and OrgId 'ORG0017744' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017744 | 117744 | 10017744 Co Ltd | 0              | Locked Restructure    | Yes           | AA017744      | ?             | ?                      | ?                      | ?                      | 24 Stoneleigh Park     | Kenilworth             | Warwickshire           | CV8 2LY   |


    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017744 |




    # Change the date
    Given the override date is '11/07/2019'

    # Bulk import to create a new 1920 ALLF Education and Skills contract where the contracting org matches the delivery org
    And   there are no files prefixed '10017744' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed '10017744' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 31052019124022 v3_A744' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 31052019124022 v3_A744' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 31052019124022 v3_A744.xlsx' exists in the Datafiles folder and UKPRN '10017744' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters 
   #And   I retrieve the latest EFA contract details from CRM for provider '10017744' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017744'
    And   I retrieve the latest contract details from CRM for provider '10017744' for FundingType 'EDSK' and period '1920'

    # Assign a Caseload Advisor
    Given caseload advisor 'FCS2 Test' is assigned to UKPRN '10017744'



    # Check that all 6 documents have been produced in the right order by looking for the first line in each of:
    #   'Summary of Funding', then 'Main Terms and Conditions' (TAC) then Schedule 1, then Schedule 2, then 'Funding Agreement', then 'Schedule 3'
	Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Agreement Type Conditions of Funding (Grant) (HEI)
    SCHEDULE 1: SPECIFICATION & MONITORING
    SCHEDULE 2: PAYMENT
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    SCHEDULE 3: NOT USED
    """




    # 1. Check the contents of the 'Summary of Funding'
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017744 Co Ltd UKPRN: 10017744
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £46,101 £14,420 £60,521
    Total Funding for this contract: £60,521
    Summary of Funding – Page 1
    """




    # 2. Check the contents of the 'Main Terms and Conditions' doc (TAC)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    Agreement Type Conditions of Funding (Grant) (HEI)
    st st
    Funding Period 1 August 2019 to 31 July 2020
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017744 Co Ltd
    Funding for Advanced Learner Loans
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY PROVIDER
    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
    THE PROVIDER REPRESENTS AND WARRANTS THAT THE PROVIDER HAS
    READ AND UNDERSTOOD THIS AGREEMENT, THE PROVIDER AGREES TO BE
    BOUND BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO
    ACCEPT THIS AGREEMENT AND LEGALLY BIND THE PROVIDER.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    acting through the Education and Skills Funding Agency
    by Eileen Milner, Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (September 2019) Page 1

    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017744 Co Ltd THE SECRETARY OF STATE FOR
    24 Stoneleigh Park EDUCATION ACTING THROUGH
    Kenilworth THE EDUCATION AND SKILLS
    Warwickshire FUNDING AGENCY, AN
    CV8 2LY EXECUTIVE AGENCY OF THE
    DEPARTMENT OF EDUCATION
    AND
    CHEYLESMORE HOUSE
    Company No: AA017744 QUINTON ROAD
    COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (September 2019) Page 2
	"""




    # 3. Check the contents of Schedule 1 (S1)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
	SCHEDULE 1: SPECIFICATION & MONITORING 
	“Loans Facility” gives the Provider the authority to access Loans
	Schedule 1 – Advanced Learner Loans – Page 1

	Company and the Provider.
	levels 3, 4, 5 and 6 that will be provided by the Provider.
	If the Service is terminated, the Department will remove the Provider’s
	7. The Provider shall recruit eligible Learners onto this service from the Service
	Schedule 1 – Advanced Learner Loans – Page 2

	9. The Provider shall aim to maximise the use of the Loans Facility and Bursary
	10.The Provider shall not recruit Learners from another contractor that has
	12.The Provider will deliver the Advanced Learner Loans Provision set out in
	13.The Provider will maximise the number of Learners that achieve a
	14.The Provider will maintain evidence of the delivery of the Service as set out
	15.The Provider will support eligible Learners by using the Loans Bursary to
	16.The Provider will support eligible Learners using Exceptional Learning
	17.In delivering the Advanced Learner Loans Provision, the Provider will
	Rules the Provider must not sub-contract Advanced Learner Loans
	19.The Provider must deliver the Advanced Learner Loans Provision in
	Schedule 1 – Advanced Learner Loans – Page 3

	20.The Provider will deliver the Service in a way that ensures
	Provider must migrate data for continuing Learners from the 2018 to 2019
	ILR to the 2019 to 2020 ILR.  The Provider must submit this data in the first
	22.The Provider will submit Learner Data to the Department to comply with
	data submitted to the SLC by the Provider.  Failure to submit records for
	23.The Provider shall complete the Learner's qualification on or before the
	planned end date in the data submitted in the ILR.  Where the Provider
	24.Where required, the Provider shall submit funding claims in line with
	25.The Provider will support the five stages of loans administration as set out
	26.The Provider must repay any funds paid in error by the SLC including where
    the Provider has not informed the SLC that a Learner has withdrawn from
    or changed their qualification.  The Provider will repay within 30 days of
	Schedule 1 – Advanced Learner Loans – Page 4

	27.The Provider cannot exceed for any reason the Loans Facility and Loans
	28.The Provider must inform the Department of any changes to their bank
    details.  The Provider must not use the new account until the account has
	32.The Department will supply the Provider’s verified bank details to the SLC
	Schedule 1 – Advanced Learner Loans – Page 5

	SCHEDULE 1B: MONITORING
    https://submitlearnerdatabeta.fasst.org.uk/. The Provider must access the
	3. If served with notice of a breach, the Provider must correct data or supply
	5. The Provider’s submission of data to the SLC will be monitored against the
    service levels set out in the Provider’s SLC Service Agreement.  The
    Provider must take any corrective action to correct submissions or service
	Loans Funding Rules, the Department may invite Providers to submit
	Schedule 1 – Advanced Learner Loans – Page 6

	applications and/or to stop making Loans payments to the Provider, and/or
	reclaim any Loans payments made, where the Provider exceeds its Loans
	11.The Department will reconcile the Provider’s earnings against the payments
	13.Where the Provider’s actual delivery in the final claim, as against the
    the Department to the Provider, the Department will deduct the amount
    Provider.  Where the overpayment cannot be recovered from future
    payments within the Financial Year, the Department will invoice the Provider
    for the remaining debt and the Provider will pay the invoice within 30 days.
	14.Where the Provider’s actual delivery in the final claim, has exceeded the
	contract Allocation, the Provider does so at their own risk.  The Department
	15.Should there be an under or over payment to the Provider, the Department
	Schedule 1 – Advanced Learner Loans – Page 7
	"""




    # 4. Check the contents of Schedule 2 (S2)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
	SCHEDULE 2: PAYMENT
	2. The Provider’s Loans Facility is set out in the Funding Agreement of this
	3. The Department will pay the Provider the Funding set out in the Funding
	5. The Provider must submit a planned claim for Exceptional Learning Support
    in the Advanced Learner Loans Funding Rules. The Provider must not incur
	EDSK Schedule 2 – Advanced Learner Loans Version 2 (September 2019) – Page 1
    """


    # 5. Check the contents of the 'Funding Agreement' 
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
	SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017744 Co Ltd UKPRN: 10017744
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £60,521 £6,227 £5,569 £3,817 £6,960 £5,484 £4,072 £6,195 £7,777 £5,144 £5,091 £3,138 £1,047
    Total Funding £60,521 £6,227 £5,569 £3,817 £6,960 £5,484 £4,072 £6,195 £7,777 £5,144 £5,091 £3,138 £1,047
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
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
    EDSK Schedule 5 Version 3 (September 2019) – Page 1

    SCHEDULE 6: GDPR
    EDSK Schedule 6 Version 3 (September 2019) – Page 1

    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
    EDSK Schedule 7 Version 3 (September 2019) – Page 1

    SCHEDULE 8: EXIT ARRANGEMENTS
    EDSK Schedule 8 Version 3 (September 2019) – Page 1
    """
    
    #And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'



    # Change the date
    Given the override date is '13/07/2019'

    # Assign a caseload Advisor
    And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017744'
    
    # Create dummy Terms and Conditions files base on Resources/DummyPdf.pdf. Each has one page containing just the work 'Appendices'
    And   there are no files prefixed '10017744' in the Sharepoint 'EDSK-1920-Input-Terms And Conditions' folder
    And   a file with filename '10017744_[ContractNo]_55.pdf' is created in 'EDSK-1920-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017744' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check that the doc merge task has been completed for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017744'
    | Task                             | Description                                         | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Initiate Document Merge          | 10017744 - 10017744 Co Ltd Awaiting documentation   | [ContractNo]   | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017744 | [ContractNo]       | 1                     | 0                        | Draft            | In Review                 | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017744 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
Scenario: A745 Bulk load a new 1920 EDSK contract with an ALLF(NoPay) allocation. No Delivery Orgs. ContractType is Conditions of Funding (Grant)(Trust). Check docs then merge
    Given there are no allocations marked as Under Termination for UKPRN '10017745' 
    And   there are no terminated or closed allocations for UKPRN '10017745' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017745' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-745      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017745' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017745 Co Ltd' with UKPRN '10017745' and OrgId 'ORG0017745' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1    | AddressLine2  | AddressLine3 | AddressLine4 | Town | County | Postcode |
    | 10017745 | 117745 | 10017745 Co Ltd                 | 0              | Active | Yes           | AA017745      | 17745         | 15 Linden Drive | Bradley Stoke | Bristol      | ?            | ?    | ?      | BS32 8DT |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017742 |




    # Change the date
    Given the override date is '22/07/2019'

    # Bulk import to create a new 1920 ALLF Education and Skills contract
    And   there are no files prefixed '10017745' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed '10017745' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 31052019155835 v3_A745' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 31052019155835 v3_A745' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 31052019155835 v3_A745.xlsx' exists in the Datafiles folder and UKPRN '10017745' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters 
   #And   I retrieve the latest EFA contract details from CRM for provider '10017745' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10027769'
    And   I retrieve the latest contract details from CRM for provider '10017745' for FundingType 'EDSK' and period '1920'

    # Assign a Caseload Advisor
    Given caseload advisor 'FCS2 Test' is assigned to UKPRN '10017745'




    # Check that all 6 documents have been produced in the right order by looking for the first line in each of:
    #   'Summary of Funding', then 'Main Terms and Conditions' (TAC) then Schedule 1, then Schedule 2, then 'Funding Agreement', then 'Schedule 3'
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Agreement Type Conditions of Funding (Grant)
    SCHEDULE 1: SPECIFICATION & MONITORING
    SCHEDULE 2: PAYMENT
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    SCHEDULE 3: NOT USED
    """




    # 1. Check the contents of the 'Summary of Funding' doc 
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017745 Co Ltd UKPRN: 10017745
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £38,061 £7,481 £45,542
    Total Funding for this contract: £45,542
    Summary of Funding – Page 1
    """

	


    # 2. Check the contents of the 'Main Terms and Conditions' doc (TAC)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    Agreement Type Conditions of Funding (Grant)
    Funding Period 1 August 2019 to 31 July 2020
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017745 Co Ltd
    Funding for Advanced Learner Loans
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY PROVIDER
    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
    THE PROVIDER REPRESENTS AND WARRANTS THAT THE PROVIDER HAS
    READ AND UNDERSTOOD THIS AGREEMENT, THE PROVIDER AGREES TO BE
    BOUND BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO
    ACCEPT THIS AGREEMENT AND LEGALLY BIND THE PROVIDER.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    acting through the Education and Skills Funding Agency
    by Eileen Milner, Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (September 2019) Page 1

    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017745 Co Ltd THE SECRETARY OF STATE FOR
    15 Linden Drive EDUCATION ACTING THROUGH
    Bradley Stoke THE EDUCATION AND SKILLS
    Bristol FUNDING AGENCY, AN
    BS32 8DT EXECUTIVE AGENCY OF THE
    DEPARTMENT OF EDUCATION
    AND CHEYLESMORE HOUSE
    Company No: AA017745 QUINTON ROAD
    COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (September 2019) Page 2
	"""




    # 3. Check the contents of Schedule 1 (S1)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
	SCHEDULE 1: SPECIFICATION & MONITORING 
	“Loans Facility” gives the Provider the authority to access Loans
	Schedule 1 – Advanced Learner Loans – Page 1

	Company and the Provider.
	levels 3, 4, 5 and 6 that will be provided by the Provider.
	If the Service is terminated, the Department will remove the Provider’s
	7. The Provider shall recruit eligible Learners onto this service from the Service
	Schedule 1 – Advanced Learner Loans – Page 2

	9. The Provider shall aim to maximise the use of the Loans Facility and Bursary
	10.The Provider shall not recruit Learners from another contractor that has
	12.The Provider will deliver the Advanced Learner Loans Provision set out in
	13.The Provider will maximise the number of Learners that achieve a
	14.The Provider will maintain evidence of the delivery of the Service as set out
	15.The Provider will support eligible Learners by using the Loans Bursary to
	16.The Provider will support eligible Learners using Exceptional Learning
	17.In delivering the Advanced Learner Loans Provision, the Provider will
	Rules the Provider must not sub-contract Advanced Learner Loans
	19.The Provider must deliver the Advanced Learner Loans Provision in
	Schedule 1 – Advanced Learner Loans – Page 3

	20.The Provider will deliver the Service in a way that ensures
	Provider must migrate data for continuing Learners from the 2018 to 2019
	ILR to the 2019 to 2020 ILR.  The Provider must submit this data in the first
	22.The Provider will submit Learner Data to the Department to comply with
	data submitted to the SLC by the Provider.  Failure to submit records for
	23.The Provider shall complete the Learner's qualification on or before the
	planned end date in the data submitted in the ILR.  Where the Provider
	24.Where required, the Provider shall submit funding claims in line with
	25.The Provider will support the five stages of loans administration as set out
	26.The Provider must repay any funds paid in error by the SLC including where
    the Provider has not informed the SLC that a Learner has withdrawn from
    or changed their qualification.  The Provider will repay within 30 days of
	Schedule 1 – Advanced Learner Loans – Page 4
	
	27.The Provider cannot exceed for any reason the Loans Facility and Loans
	28.The Provider must inform the Department of any changes to their bank
    details.  The Provider must not use the new account until the account has
	32.The Department will supply the Provider’s verified bank details to the SLC
	Schedule 1 – Advanced Learner Loans – Page 5

	SCHEDULE 1B: MONITORING
	https://submitlearnerdatabeta.fasst.org.uk/. The Provider must access the
	3. If served with notice of a breach, the Provider must correct data or supply
	5. The Provider’s submission of data to the SLC will be monitored against the
    service levels set out in the Provider’s SLC Service Agreement.  The
    Provider must take any corrective action to correct submissions or service
	Loans Funding Rules, the Department may invite Providers to submit
	Schedule 1 – Advanced Learner Loans – Page 6
	
	applications and/or to stop making Loans payments to the Provider, and/or
	reclaim any Loans payments made, where the Provider exceeds its Loans
	11.The Department will reconcile the Provider’s earnings against the payments
	13.Where the Provider’s actual delivery in the final claim, as against the
    the Department to the Provider, the Department will deduct the amount
    Provider.  Where the overpayment cannot be recovered from future
    payments within the Financial Year, the Department will invoice the Provider
    for the remaining debt and the Provider will pay the invoice within 30 days.
	14.Where the Provider’s actual delivery in the final claim, has exceeded the
	contract Allocation, the Provider does so at their own risk.  The Department
	15.Should there be an under or over payment to the Provider, the Department
	Schedule 1 – Advanced Learner Loans – Page 7
	"""




    # 4. Check the contents of Schedule 2 (S2)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
	SCHEDULE 2: PAYMENT
	2. The Provider’s Loans Facility is set out in the Funding Agreement of this
	3. The Department will pay the Provider the Funding set out in the Funding
	5. The Provider must submit a planned claim for Exceptional Learning Support
    in the Advanced Learner Loans Funding Rules. The Provider must not incur
	EDSK Schedule 2 – Advanced Learner Loans Version 2 (September 2019) – Page 1
    """




    # 5. Check the contents of the 'Funding Agreement' 
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017745 Co Ltd UKPRN: 10017745
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £45,542 £1,825 £5,243 £7,164 £1,401 £6,517 £1,231 £7,027 £7,653 £3,662 £1,846 £1,454 £519
    Total Funding £45,542 £1,825 £5,243 £7,164 £1,401 £6,517 £1,231 £7,027 £7,653 £3,662 £1,846 £1,454 £519
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
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
    EDSK Schedule 5 Version 3 (September 2019) – Page 1

    SCHEDULE 6: GDPR
    EDSK Schedule 6 Version 3 (September 2019) – Page 1

    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
    EDSK Schedule 7 Version 3 (September 2019) – Page 1

    SCHEDULE 8: EXIT ARRANGEMENTS
    EDSK Schedule 8 Version 3 (September 2019) – Page 1
    """  
	

    #And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'



    # Change the date
    Given the override date is '23/07/2019'

    # Assign a caseload Advisor
    And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017745'
    
    # Create dummy Terms and Conditions files base on Resources/DummyPdf.pdf. Each has one page containing just the work 'Appendices'
    And   there are no files prefixed '10017745' in the Sharepoint 'EDSK-1920-Input-Terms And Conditions' folder
    And   a file with filename '10017745_[ContractNo]_54.pdf' is created in 'EDSK-1920-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017745' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check that the doc merge task has been completed for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017745'
    | Task                             | Description                                         | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Initiate Document Merge          | 10017745 - 10017745 Co Ltd Awaiting documentation   | [ContractNo]   | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the WORKFLOW HISTORY for a merge successful event
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                           | CompletedBy     | Comment                        |
    | Document Merge Successful        | CRM Integration | ?                              |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017745 | [ContractNo]       | 1                     | 0                        | Draft            | In Review                 | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017745 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |


    # Tidy up
    And   the override date is reset

