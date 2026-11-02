Feature: Create1920ALLFcontracts 25878

@AcceptanceTest @Withdrawn20230123
Scenario: A322 Bulk load a new 1920 EDSK contract with an ALLF(NoPay) allocation. ContractType is Contract for Services (ITP). No Delivery Org. Check docs then merge
    Given there are no allocations marked as Under Termination for UKPRN '10017322' 
    And   there are no terminated or closed allocations for UKPRN '10017322' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017322' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-322      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017322' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017322 Co Ltd' with UKPRN '10017322' and OrgId 'ORG0017322' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017322 | 117322 | 10017322 Co Ltd | 0              | Locked Restructure    | Yes           | AA017322      | ?             | 16 St. Thomas Street   | Bristol                | ?                      | ?                      | ?                      | Avon                   | BS1 6JJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017322 |



    # Change the date
    Given the override date is '11/07/2019'

    # Bulk import to create a new 1920 ALLF Education and Skills contract
    And   there are no files prefixed '10017322' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
	And   there are no files prefixed '10017322' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 26022019120657 v3_A322' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 26022019120657 v3_A322' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 26022019120657 v3_A322.xlsx' exists in the Datafiles folder and UKPRN '10017322' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters 
   #And   I retrieve the latest EFA contract details from CRM for provider '10017322' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017322'
    And   I retrieve the latest contract details from CRM for provider '10017322' for FundingType 'EDSK' and period '1920'

    # Assign a Caseload Advisor
	Given caseload advisor 'FCS2 Test' is assigned to UKPRN '10017322'



    # Check that all 6 documents have been produced in the right order by looking for the first line in each of:
    #   'Summary of Funding', then 'Main Terms and Conditions' (TAC) then Schedule 1, then Schedule 2, then 'Funding Agreement', then 'Schedule 3'
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Agreement Type Contract for Services
    SCHEDULE 1: SPECIFICATION & MONITORING
    SCHEDULE 2: PAYMENT
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    """


    # 1. Check the contents of the 'Summary of Funding' doc
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017322 Co Ltd UKPRN: 10017322
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £22,371 £10,507 £32,878
    Total Funding for this contract: £32,878
    Summary of Funding – Page 1
	"""


    # 2. Check the contents of the 'Main Terms and Conditions' doc (TAC)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    Agreement Type Contract for Services 
    Funding Period 1 August 2019 to 31 July 2020
    the Secretary of State for Education (acting through the
    Between
    Education and Skills Funding Agency)
    And 10017322 Co Ltd
    Funding for Advanced Learner Loans
    Master Contract Number [MasterContractNo]
    ACCEPTANCE BY CONTRACTOR
    BY ACCEPTING THIS CONTRACT VIA THE MANAGE YOUR EDUCATION &
    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
    THE CONTRACTOR REPRESENTS AND WARRANTS THAT THE CONTRACTOR
    HAS READ AND UNDERSTOOD THIS CONTRACT, THE CONTRACTOR AGREES
    TO BE BOUND BY THIS CONTRACT AND THAT HE/SHE IS DULY AUTHORISED
    TO ACCEPT THIS CONTRACT AND LEGALLY BIND THE CONTRACTOR.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    acting through the Education and Skills Funding Agency
    by Eileen Milner, Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (September 2019) Page 1

    This Contract is made on the date the Agreement is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017322 Co Ltd THE SECRETARY OF STATE FOR
    16 St. Thomas Street EDUCATION ACTING THROUGH
    Bristol THE EDUCATION AND SKILLS
    Avon FUNDING AGENCY, AN
    BS1 6JJ EXECUTIVE AGENCY OF THE
    DEPARTMENT OF EDUCATION
    CHEYLESMORE HOUSE
    Company No: AA017322 QUINTON ROAD
    COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Contractor the Department
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
    “Loans Facility” gives the Contractor the authority to access Loans
	Schedule 1 – Advanced Learner Loans – Page 1

    Company and the Contractor.
    levels 3, 4, 5 and 6 that will be provided by the Contractor.
    the Service is terminated, the Department will remove the Contractor’s
    7. The Contractor shall recruit eligible Learners onto this service from the
	Schedule 1 – Advanced Learner Loans – Page 2

    9. The Contractor shall aim to maximise the use of the Loans Facility and
    10.The Contractor shall not recruit Learners from another contractor that has
    12.The Contractor will deliver the Advanced Learner Loans Provision set out in
    13.The Contractor will maximise the number of Learners that achieve a
    14.The Contractor will maintain evidence of the delivery of the Service as set
    15.The Contractor will support eligible Learners by using the Loans Bursary to
    16.The Contractor will support eligible Learners using Exceptional Learning
    17.In delivering the Advanced Learner Loans Provision, the Contractor will
    Rules the Contractor must not sub-contract Advanced Learner Loans
    19.The Contractor must deliver the Advanced Learner Loans Provision in
    Schedule 1 – Advanced Learner Loans – Page 3
	
	20.The Contractor will deliver the Service in a way that ensures
    Contractor must migrate data for continuing Learners from the 2018 to 2019
    ILR to the 2019 to 2020 ILR.  The Contractor must submit this data in the
    22.The Contractor will submit Learner Data to the Department to comply with
    data submitted to the SLC by the Contractor.  Failure to submit records for
    23.The Contractor shall complete the Learner's qualification on or before the
    planned end date in the data submitted in the ILR.  Where the Contractor
    24.Where required, the Contractor shall submit funding claims in line with
    25.The Contractor will support the five stages of loans administration as set out
    26.The Contractor must repay any funds paid in error by the SLC including
    where the Contractor has not informed the SLC that a Learner has
    withdrawn from or changed their qualification.  The Contractor will repay
    Schedule 1 – Advanced Learner Loans – Page 4
	
	27.The Contractor cannot exceed for any reason the Loans Facility and Loans
    28.The Contractor must inform the Department of any changes to their bank
    details.  The Contractor must not use the new account until the account has
    32.The Department will supply the Contractor’s verified bank details to the SLC
    Schedule 1 – Advanced Learner Loans – Page 5

    SCHEDULE 1B: MONITORING
	https://submitlearnerdatabeta.fasst.org.uk/.  The Contractor must access
    3. If served with notice of a breach, the Contractor must correct data or supply
    5. The Contractor’s submission of data to the SLC will be monitored against
    the service levels set out in the Contractor’s SLC Service Agreement.  The
    Contractor must take any corrective action to correct submissions or service
    Loans Funding Rules, the Department may invite Contractors to submit
    Schedule 1 – Advanced Learner Loans – Page 6
	
	applications and/or to stop making Loans payments to the Contractor,
    and/or reclaim any Loans payments made, where the Contractor exceeds
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
    2. The Contractor’s Loans Facility is set out in the Funding Agreement of this
	3. The Contractor will submit ILR Learner data, Supplementary Data and the
	Contractor’s earnings for the Funding Year to-date by the method set out in
	6. The Department will pay the Contractor on the 14 Working Day of each
	7. The Contractor must submit a planned claim for Exceptional Learning
	set out in the Advanced Learner Loans Funding Rules. The Contractor must
	EDSK Schedule 2 – Advanced Learner Loans Version 2 (September 2019) – Page 1
    """



    # 5. Check the contents of the 'Funding Agreement' doc
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017322 Co Ltd UKPRN: 10017322
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £32,878 £3,261 £2,602 £851 £3,993 £2,518 £1,106 £3,229 £4,811 £2,178 £2,125 £172 £6,032
    Total Funding £32,878 £3,261 £2,602 £851 £3,993 £2,518 £1,106 £3,229 £4,811 £2,178 £2,125 £172 £6,032
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """


    # 6. Check the contents of Schedules 3-8' (S3ON)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 3: CHANGE CONTROL PROCEDURE 
	EDSK Schedule 3 Version 3 (September 2019) – Page 1

	SCHEDULE 4: CONTRACTOR’S RESPONSE/PROPOSALS
    EDSK Schedule 4 Version 3 (September 2019) – Page 1

	SCHEDULE 5: TUPE
	EDSK Schedule 5 Version 3 (September 2019) – Page 1

	SCHEDULE 6: GDPR
	EDSK Schedule 6 Version 3 (September 2019) – Page 1

	SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
	EDSK Schedule 7 Version 3 (September 2019)  – Page 1

	SCHEDULE 8: EXIT ARRANGEMENTS
	EDSK Schedule 8 Version 3 (September 2019)  – Page 1
    """
	
	#And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'



    # Change the date
    Given the override date is '13/07/2019'
	
	# Create dummy Terms and Conditions files base on Resources/DummyPdf.pdf. Each has one page containing just the work 'Appendices'
    And   there are no files prefixed '10017322' in the Sharepoint 'EDSK-1920-Input-Terms And Conditions' folder
    And   a file with filename '10017322_[ContractNo]_11.pdf' is created in 'EDSK-1920-Input-Terms And Conditions'
    And   a file with filename '10017322_[ContractNo]_61.pdf' is created in 'EDSK-1920-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017322' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check that the doc merge task has been completed for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017322'
    | Task                             | Description                                         | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Initiate Document Merge          | 10017322 - 10017322 Co Ltd Awaiting documentation   | [ContractNo]   | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017322 | [ContractNo]       | 1                     | 0                        | Draft            | In Review                 | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017322 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
Scenario: A323 Bulk load a new 1920 EDSK contract with an ALLF(NoPay) allocation. ContractType is Conditions of Funding (Grant) (HEI). No Delivery Org. Check docs inc long name and address
    Given there are no allocations marked as Under Termination for UKPRN '10017323' 
    And   there are no terminated or closed allocations for UKPRN '10017323' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017323' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-323      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017323' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017323 Co Ltd' with UKPRN '10017323' and OrgId 'ORG0017323' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                                                                                   | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017323 | 117323 | THE LEAGUE OF LOCAL AUTHORITY CHIEF EXECUTIVES AND SENIOR MANAGERS (LOLACE LEAGUE) LTD | 0              | Locked Restructure    | Yes           | ?             | 17323         | Griffin House          | Brook Court            | High Street North      | Ledsham                | Ellesmere Port         | Merseyside             | CH66 4TT  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017323 |



    # Change the date
    Given the override date is '11/07/2019'

    # Bulk import to create a new 1920 ALLF Education and Skills contract
    And   there are no files prefixed '10017323' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
	And   there are no files prefixed '10017323' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 28022019092346 v3_A323' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 28022019092346 v3_A323' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 28022019092346 v3_A323.xlsx' exists in the Datafiles folder and UKPRN '10017323' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters 
   #And   I retrieve the latest EFA contract details from CRM for provider '10017323' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017323'
    And   I retrieve the latest contract details from CRM for provider '10017323' for FundingType 'EDSK' and period '1920'


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


    # 1. Check the contents of the 'Summary of Funding' doc
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: THE LEAGUE OF LOCAL AUTHORITY CHIEF EXECUTIVES AND UKPRN: 10017323
    SENIOR MANAGERS (LOLACE LEAGUE) LTD
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £29,081 £13,863 £42,944
    Total Funding for this contract: £42,944
    Summary of Funding – Page 1
    """



    # 2. Check the contents of the 'Main Terms and Conditions' doc (TAC)
    And   a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    Agreement Type Conditions of Funding (Grant) (HEI)
    Funding Period 1 August 2019 to 31 July 2020
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    THE LEAGUE OF LOCAL AUTHORITY CHIEF
    And EXECUTIVES AND SENIOR MANAGERS (LOLACE
    LEAGUE) LTD
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
    THE LEAGUE OF LOCAL AUTHORITY THE SECRETARY OF STATE FOR
    CHIEF EXECUTIVES AND SENIOR EDUCATION ACTING THROUGH
    MANAGERS (LOLACE LEAGUE) LTD THE EDUCATION AND SKILLS
    Griffin House FUNDING AGENCY, AN
    Brook Court EXECUTIVE AGENCY OF THE
    High Street North DEPARTMENT OF EDUCATION
    AND
    Ledsham CHEYLESMORE HOUSE
    Ellesmere Port QUINTON ROAD
    Merseyside COVENTRY
    CH66 4TT CV1 2WT
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (September 2019) Page 1
    """

	# Company number should not be visible
    And   the pdf file does not contain the following text
    """
    Company No:
    """  



    # 5. Check the contents of the 'Funding Agreement' doc 
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: THE LEAGUE OF LOCAL AUTHORITY CHIEF EXECUTIVES AND SENIOR MANAGERS (LOLACE LEAGUE) LTD UKPRN: 10017323
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £42,944 £4,100 £3,441 £1,690 £4,832 £3,356 £1,945 £4,068 £5,649 £3,017 £2,964 £1,011 £6,871
    Total Funding £42,944 £4,100 £3,441 £1,690 £4,832 £3,356 £1,945 £4,068 £5,649 £3,017 £2,964 £1,011 £6,871
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """




    # 6. Check the contents of 'Schedule 3'
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 3: NOT USED
	2.1 The Provider is required to ensure it performs its obligations to assist in
    """
	
	#And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
Scenario: A877 Bulk load a new 1920 EDSK contract for ALLF. Contract has one delivery Org which matches the contracting Org. ContractType is Conditions of Funding (Grant)(HEI). Check docs then merge
    Given there are no allocations marked as Under Termination for UKPRN '10017877' 
    And   there are no terminated or closed allocations for UKPRN '10017877' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017877' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-877      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017877' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017877 Co Ltd' with UKPRN '10017877' and OrgId 'ORG0017877' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017877 | 117877 | 10017877 Co Ltd | 0              | Locked Restructure    | Yes           | AA017877      | ?             | ?                      | ?                      | ?                      | 24 Stoneleigh Park     | Kenilworth             | Warwickshire           | CV8 2LY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017877 |




    # Change the date
    Given the override date is '11/07/2019'

    # Bulk import to create a new 1920 ALLF Education and Skills contract where the contracting org matches the delivery org
    And   there are no files prefixed '10017877' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed '10017877' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 04032019094022 v3_A877' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 04032019094022 v3_A877' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 04032019094022 v3_A877.xlsx' exists in the Datafiles folder and UKPRN '10017877' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters 
    And   I retrieve the latest EFA contract details from CRM for provider '10017877' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017877'
   #And   I retrieve the latest contract details from CRM for provider '10017877' for FundingType 'EDSK' and period '1920'

    # Assign a Caseload Advisor
    Given caseload advisor 'FCS2 Test' is assigned to UKPRN '10017877'



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




    # 1. Check the contents of the 'Summary of Funding' doc
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017877 Co Ltd UKPRN: 10017877
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
    Funding Period 1 August 2019 to 31 July 2020
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017877 Co Ltd
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
    10017877 Co Ltd THE SECRETARY OF STATE FOR
    24 Stoneleigh Park EDUCATION ACTING THROUGH
    Kenilworth THE EDUCATION AND SKILLS
    Warwickshire FUNDING AGENCY, AN
    CV8 2LY EXECUTIVE AGENCY OF THE
    DEPARTMENT OF EDUCATION
    AND
    CHEYLESMORE HOUSE
    Company No: AA017877 QUINTON ROAD
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
    Provider: 10017877 Co Ltd UKPRN: 10017877
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
    And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017877'
    
    # Create dummy Terms and Conditions files base on Resources/DummyPdf.pdf. Each has one page containing just the work 'Appendices'
    And   there are no files prefixed '10017877' in the Sharepoint 'EDSK-1920-Input-Terms And Conditions' folder
    And   a file with filename '10017877_[ContractNo]_55.pdf' is created in 'EDSK-1920-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017877' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check that the doc merge task has been completed for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017877'
    | Task                             | Description                                         | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Initiate Document Merge          | 10017877 - 10017877 Co Ltd Awaiting documentation   | [ContractNo]   | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017877 | [ContractNo]       | 1                     | 0                        | Draft            | In Review                 | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017877 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run890
Scenario: A878 Bulk load a new 1920 EDSK contract for ALLF. Contract has four delivery Orgs none of which match the contracting Org. ContractType is Conditions of Funding (Grant)(LA). Check docs then merge
    Given there are no allocations marked as Under Termination for UKPRN '10017878' 
    And   there are no terminated or closed allocations for UKPRN '10017878' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017878' 
	And   there is no Contract, Task or Workflow data for UKPRN '10027769' 
	And   there is no Contract, Task or Workflow data for UKPRN '10028341' 
	And   there is no Contract, Task or Workflow data for UKPRN '10023871'
	And   there is no Contract, Task or Workflow data for UKPRN '10022729' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-878      |


    # Set organisation and advisors 
	Given there is no Organisation data for UKPRN '10017878' 
	And   there is no Organisation data for UKPRN '10027769'
	And   there is no Organisation data for UKPRN '10028341'
	And   there is no Organisation data for UKPRN '10023871'
	And   there is no Organisation data for UKPRN '10022729'

	And   caseload advisor 'FCS2 Test' is assigned to provider '10017878 Co Ltd' with UKPRN '10017878' and OrgId 'ORG0017878' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1    | AddressLine2  | AddressLine3 | AddressLine4 | Town | County | Postcode |
    | 10017878 | 117878 | 10017878 Co Ltd                 | 0              | Active | Yes           | AA017878      | 17878         | 15 Linden Drive | Bradley Stoke | Bristol      | ?            | ?    | ?      | BS32 8DT |
    | 10027769 | 62541  | PROMISE TRAINING CENTRE LIMITED | 0              | Active | Yes           | ?             | ?             | ?               | ?             | ?            | ?            | ?    | ?      | ?        |
    | 10028341 | 41342  | QUESTIONS & ANSWERS CIC         | 0              | Active | Yes           | ?             | ?             | ?               | ?             | ?            | ?            | ?    | ?      | ?        |
    | 10023871 | 42388  | RESULTS CONSORTIUM LIMITED      | 0              | Active | Yes           | ?             | ?             | ?               | ?             | ?            | ?            | ?    | ?      | ?        |
    | 10022729 | 90787  | SELECTION TRAINING LIMITED      | 0              | Active | Yes           | ?             | ?             | ?               | ?             | ?            | ?            | ?    | ?      | ?        |

    # Put the same Provider data in the CRM Organisation table
	And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
	| UKPRN    |
	| 10017878 |
	| 10027769 |
	| 10028341 |
	| 10023871 |
	| 10022729 |


    # Change the date
    Given the override date is '22/07/2019'

    # Bulk import to create a new 1920 ALLF Education and Skills with four delivery orgs none of which matches the contracting org
    And   there are no files prefixed '10017878' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed '10017878' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 04032019105835 v3_A878' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 04032019105835 v3_A878' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 04032019105835 v3_A878.xlsx' exists in the Datafiles folder and UKPRN '10017878' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters 
    And   I retrieve the latest EFA contract details from CRM for provider '10017878' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10027769'
   #And   I retrieve the latest contract details from CRM for provider '10017878' for FundingType 'EDSK' and period '1920'

    # Assign a Caseload Advisor
    Given caseload advisor 'FCS2 Test' is assigned to UKPRN '10017878'



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
	Provider: PROMISE TRAINING CENTRE LIMITED UKPRN: 10027769
	SCHEDULE 2 – ADVANCED LEARNER LOANS
	Provider: QUESTIONS & ANSWERS CIC UKPRN: 10028341
	SCHEDULE 2 – ADVANCED LEARNER LOANS
	Provider: RESULTS CONSORTIUM LIMITED UKPRN: 10023871
	SCHEDULE 2 – ADVANCED LEARNER LOANS
	Provider: SELECTION TRAINING LIMITED UKPRN: 10022729
	SCHEDULE 3: NOT USED
    """




    # 1.1. Check the contents of the 'Summary of Funding' doc from the perspective of the FIRST delivery org
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017878 Co Ltd UKPRN: 10017878
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    PROMISE TRAINING CENTRE LIMITED [AllocRef_ALLF] £35,602 £20,041 £55,643
    Total Funding for this contract: £191,334
    Summary of Funding – Page 1
    """



    # Retrieve parameters for SECOND Delivery Org 
    And   I retrieve the latest EFA contract details from CRM for provider '10017878' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10028341'
   #And   I retrieve the latest contract details from CRM for provider '10017878' for FundingType 'EDSK' and period '1920'
   
    # 1.2. Check the contents of the 'Summary of Funding' doc from the perspective of the second delivery org
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017878 Co Ltd UKPRN: 10017878
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    QUESTIONS & ANSWERS CIC [AllocRef_ALLF] £38,061 £7,481 £45,542
    Total Funding for this contract: £191,334
    Summary of Funding – Page 1
    """




    # Retrieve parameters for THIRD Delivery Org 
    And   I retrieve the latest EFA contract details from CRM for provider '10017878' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10023871'
   #And   I retrieve the latest contract details from CRM for provider '10017878' for FundingType 'EDSK' and period '1920'
   
    # 1.3. Check the contents of the 'Summary of Funding' doc from the perspective of the second delivery org
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017878 Co Ltd UKPRN: 10017878
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    RESULTS CONSORTIUM LIMITED [AllocRef_ALLF] £34,620 £14,520 £49,140
    Total Funding for this contract: £191,334
    Summary of Funding – Page 1
    """	
	


	
    # Retrieve parameters for FOURTH Delivery Org 
    And   I retrieve the latest EFA contract details from CRM for provider '10017878' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10022729'
   #And   I retrieve the latest contract details from CRM for provider '10017878' for FundingType 'EDSK' and period '1920'
   
    # 1.4. Check the contents of the 'Summary of Funding' doc from the perspective of the second delivery org
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017878 Co Ltd UKPRN: 10017878
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    SELECTION TRAINING LIMITED [AllocRef_ALLF] £27,719 £13,290 £41,009
    Total Funding for this contract: £191,334
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
    And 10017878 Co Ltd
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
    10017878 Co Ltd THE SECRETARY OF STATE FOR
    15 Linden Drive EDUCATION ACTING THROUGH
    Bradley Stoke THE EDUCATION AND SKILLS
    Bristol FUNDING AGENCY, AN
    BS32 8DT EXECUTIVE AGENCY OF THE
    DEPARTMENT OF EDUCATION
    AND CHEYLESMORE HOUSE
    Company No: AA017878 QUINTON ROAD
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




    # Retrieve parameters for FIRST Delivery Org 
    And   I retrieve the latest EFA contract details from CRM for provider '10017878' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10027769'
   #And   I retrieve the latest contract details from CRM for provider '10017878' for FundingType 'EDSK' and period '1920'

    # 5.1. Check the contents of the 'Funding Agreement' from the perspective of the first Delivery Org
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: PROMISE TRAINING CENTRE LIMITED UKPRN: 10027769
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £55,643 £2,826 £2,370 £5,852 £1,245 £5,002 £5,904 £5,310 £7,093 £7,582 £1,892 £5,172 £5,395
    Total Funding £55,643 £2,826 £2,370 £5,852 £1,245 £5,002 £5,904 £5,310 £7,093 £7,582 £1,892 £5,172 £5,395
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """




    # Retrieve parameters for SECOND Delivery Org 
    And   I retrieve the latest EFA contract details from CRM for provider '10017878' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10028341'
   #And   I retrieve the latest contract details from CRM for provider '10017878' for FundingType 'EDSK' and period '1920'

    # 5.2. Check the contents of the 'Funding Agreement' from the perspective of the second Delivery Org
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: QUESTIONS & ANSWERS CIC UKPRN: 10028341
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £45,542 £1,825 £5,243 £7,164 £1,401 £6,517 £1,231 £7,027 £7,653 £3,662 £1,846 £1,454 £519
    Total Funding £45,542 £1,825 £5,243 £7,164 £1,401 £6,517 £1,231 £7,027 £7,653 £3,662 £1,846 £1,454 £519
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """




    # Retrieve parameters for THIRD Delivery Org 
    And   I retrieve the latest EFA contract details from CRM for provider '10017878' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10023871'
   #And   I retrieve the latest contract details from CRM for provider '10017878' for FundingType 'EDSK' and period '1920'

    # 5.3. Check the contents of the 'Funding Agreement' from the perspective of the third Delivery Org
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: RESULTS CONSORTIUM LIMITED UKPRN: 10023871
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £49,140 £4,338 £5,846 £5,049 £1,600 £3,998 £6,865 £1,992 £4,932 £4,063 £2,449 £7,290 £718
    Total Funding £49,140 £4,338 £5,846 £5,049 £1,600 £3,998 £6,865 £1,992 £4,932 £4,063 £2,449 £7,290 £718
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """



    # Retrieve parameters for FOURTH Delivery Org 
    And   I retrieve the latest EFA contract details from CRM for provider '10017878' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10022729'
   #And   I retrieve the latest contract details from CRM for provider '10017878' for FundingType 'EDSK' and period '1920'

    # 5.4. Check the contents of the 'Funding Agreement' from the perspective of the fourth Delivery Org
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: SELECTION TRAINING LIMITED UKPRN: 10022729
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
	Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £41,009 £88 £53 £817 £6,475 £5,403 £6,507 £3,195 £5,181 £5,064 £7,526 £138 £562
    Total Funding £41,009 £88 £53 £817 £6,475 £5,403 £6,507 £3,195 £5,181 £5,064 £7,526 £138 £562
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
    And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017878'
    
    # Create dummy Terms and Conditions files base on Resources/DummyPdf.pdf. Each has one page containing just the work 'Appendices'
    And   there are no files prefixed '10017878' in the Sharepoint 'EDSK-1920-Input-Terms And Conditions' folder
    And   a file with filename '10017878_[ContractNo]_67.pdf' is created in 'EDSK-1920-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017878' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check that the doc merge task has been completed for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017878'
    | Task                             | Description                                         | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Initiate Document Merge          | 10017878 - 10017878 Co Ltd Awaiting documentation   | [ContractNo]   | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the WORKFLOW HISTORY for a merge successful event
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                           | CompletedBy     | Comment                        |
    | Document Merge Successful        | CRM Integration | ?                              |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017878 | [ContractNo]       | 1                     | 0                        | Draft            | In Review                 | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017878 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |


    # Tidy up
    And   the override date is reset

