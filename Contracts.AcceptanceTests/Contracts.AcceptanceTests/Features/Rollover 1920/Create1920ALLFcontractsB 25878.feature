Feature: Create1920ALLFcontractsB 25878

@AcceptanceTest @Withdrawn20220330
Scenario: A879 Bulk load a new 1920 EDSK contract for ALLF. Contract has five delivery Orgs one of which matches the contracting Org. ContractType is Conditions of Funding (Grant)(Employer). Check docs then merge
    Given there are no allocations marked as Under Termination for UKPRN '10017879' 
    And   there are no terminated or closed allocations for UKPRN '10017879' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017879' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-879      |


   # Set organisation and advisors 
	Given there is no Organisation data for UKPRN '10017879' 
	Given there is no Organisation data for UKPRN '10028275'
	Given there is no Organisation data for UKPRN '10025197'
	Given there is no Organisation data for UKPRN '10023229'
	Given there is no Organisation data for UKPRN '10026108'


	And   caseload advisor 'FCS2 Test' is assigned to provider 'Zebedee Ltd' with UKPRN '10017879' and OrgId 'ORG0017879' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                               | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1    | AddressLine2 | AddressLine3 | AddressLine4 | Town | County | Postcode |
    | 10017879 | 117879 | Zebedee Co Ltd                     | 0              | Active | Yes           | AA017879      | 17879         | 60 Union Street | Aberdeen     | ?            | ?            | ?    | ?      | AB10 1BB |
    | 10028275 | 10610  | TRAINING BYTE SIZE LIMITED         | 0              | Active | Yes           | ?             | ?             | ?               | ?            | ?            | ?            | ?    | ?      | ?        |
    | 10025197 | 80300  | UNIVERSITY CENTRE QUAYSIDE LIMITED | 0              | Active | Yes           | ?             | ?             | ?               | ?            | ?            | ?            | ?    | ?      | ?        |
    | 10023229 | 92515  | VENTURE FORWARD LIMITED            | 0              | Active | Yes           | ?             | ?             | ?               | ?            | ?            | ?            | ?    | ?      | ?        |
    | 10026108 | 93932  | VIRTUAL ALLIANCE LIMITED           | 0              | Active | Yes           | ?             | ?             | ?               | ?            | ?            | ?            | ?    | ?      | ?        |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017879 |
	| 10028275 |
	| 10025197 |
	| 10023229 |
	| 10026108 |


    # Change the date
    Given the override date is '06/07/2019'

    # Bulk import to create a new 1920 ALLF Education and Skills with four delivery orgs none of which matches the contracting org
    And   there are no files prefixed '10017879' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed '10017879' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 04032019110954 v3_A879' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 04032019110954 v3_A879' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 04032019110954 v3_A879.xlsx' exists in the Datafiles folder and UKPRN '10017879' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Retrieve parameters 
    And   I retrieve the latest EFA contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017879'
   #And   I retrieve the latest contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920'

    # Assign a Caseload Advisor
    Given caseload advisor 'FCS2 Test' is assigned to UKPRN '10017879'




    # Check that all 6 documents have been produced in the right order by looking for the first line or so in each of:
    #   'Summary of Funding', then 'Main Terms and Conditions' (TAC) then Schedule 1, then Schedule 2, then 'Funding Agreements', then 'Schedule 3'
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
	Organisation Name: Zebedee Co Ltd UKPRN: 10017879

    Agreement Type Conditions of Funding (Grant) (Employers)
	
	SCHEDULE 1: SPECIFICATION & MONITORING

	SCHEDULE 2: PAYMENT
    
	SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
	Provider: Zebedee Co Ltd UKPRN: 10017879
	SCHEDULE 2 – ADVANCED LEARNER LOANS
	Funding Agreement – Advanced Learner Loans Facility
	Provider: TRAINING BYTE SIZE LIMITED UKPRN: 10028275
	SCHEDULE 2 – ADVANCED LEARNER LOANS
	Funding Agreement – Advanced Learner Loans Facility
	Provider: UNIVERSITY CENTRE QUAYSIDE LIMITED UKPRN: 10025197
	SCHEDULE 2 – ADVANCED LEARNER LOANS
	Funding Agreement – Advanced Learner Loans Facility
	Provider: VENTURE FORWARD LIMITED UKPRN: 10023229
	SCHEDULE 2 – ADVANCED LEARNER LOANS
	Funding Agreement – Advanced Learner Loans Facility
	Provider: VIRTUAL ALLIANCE LIMITED UKPRN: 10026108
    
	SCHEDULE 3: NOT USED
    """


    # 1.1. Check the contents of the 'Summary of Funding' doc for the Contracting Org
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: Zebedee Co Ltd UKPRN: 10017879
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    Zebedee Co Ltd [AllocRef_ALLF] £36,733 £14,767 £51,500
    Total Funding for this contract: £255,934
    Summary of Funding – Page 1
    """




    # Retrieve parameters for FIRST Delivery Org 
    And   I retrieve the latest EFA contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10028275'
   #And   I retrieve the latest contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920'

    # 1.2. Check the contents of the 'Summary of Funding' doc for the first Delivery Org
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: Zebedee Co Ltd UKPRN: 10017879
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    TRAINING BYTE SIZE LIMITED [AllocRef_ALLF] £38,026 £23,365 £61,391
    Total Funding for this contract: £255,934
    Summary of Funding – Page 1
    """




    # Retrieve parameters for SECOND Delivery Org 
    And   I retrieve the latest EFA contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10025197'
   #And   I retrieve the latest contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920'

    # 1.3. Check the contents of the 'Summary of Funding' doc for the second Delivery Org
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: Zebedee Co Ltd UKPRN: 10017879
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    UNIVERSITY CENTRE QUAYSIDE LIMITED [AllocRef_ALLF] £33,292 £5,905 £39,197
    Total Funding for this contract: £255,934
    Summary of Funding – Page 1
    """




    # Retrieve parameters for THIRD Delivery Org
	And   I retrieve the latest EFA contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10023229'
   #And   I retrieve the latest contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920'

    # 1.4. Check the contents of the 'Summary of Funding' doc for the third Delivery Org
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: Zebedee Co Ltd UKPRN: 10017879
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    VENTURE FORWARD LIMITED [AllocRef_ALLF] £36,463 £20,471 £56,934
    Total Funding for this contract: £255,934
    Summary of Funding – Page 1
    """




    # Retrieve parameters for FOURTH Delivery Org
	And   I retrieve the latest EFA contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10026108'
   #And   I retrieve the latest contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920'

    # 1.5. Check the contents of the 'Summary of Funding' doc for the fourth Delivery Org
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: Zebedee Co Ltd UKPRN: 10017879
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    VIRTUAL ALLIANCE LIMITED [AllocRef_ALLF] £31,728 £15,184 £46,912
    Total Funding for this contract: £255,934
    Summary of Funding – Page 1
    """	
	


	
	# 2. Check the contents of the 'Main Terms and Conditions' doc
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    Agreement Type Conditions of Funding (Grant) (Employers)
    Funding Period 1 August 2019 to 31 July 2020
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And Zebedee Co Ltd
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
    Zebedee Co Ltd THE SECRETARY OF STATE FOR
    60 Union Street EDUCATION ACTING THROUGH
    Aberdeen THE EDUCATION AND SKILLS
    AB10 1BB FUNDING AGENCY, AN
    EXECUTIVE AGENCY OF THE
    DEPARTMENT OF EDUCATION
    Company No: AA017879 AND CHEYLESMORE HOUSE
    QUINTON ROAD
    COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Employer the Department
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



    # 5.1 Retrieve parameters for the Contracting Org
    And   I retrieve the latest EFA contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017879'
   #And   I retrieve the latest contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920'

    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: Zebedee Co Ltd UKPRN: 10017879
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £51,500 £7,949 £3,819 £6,144 £5,008 £2,578 £7,758 £167 £3,310 £7,673 £422 £2,545 £4,127
    Total Funding £51,500 £7,949 £3,819 £6,144 £5,008 £2,578 £7,758 £167 £3,310 £7,673 £422 £2,545 £4,127
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """



    # 5.2 Retrieve parameters for the FIRST Delivery Org
    And   I retrieve the latest EFA contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10028275'
   #And   I retrieve the latest contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920'

    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: TRAINING BYTE SIZE LIMITED UKPRN: 10028275
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £61,391 £5,847 £7,906 £5,953 £3,861 £72 £3,490 £3,299 £7,598 £4,764 £7,428 £5,273 £5,900
    Total Funding £61,391 £5,847 £7,906 £5,953 £3,861 £72 £3,490 £3,299 £7,598 £4,764 £7,428 £5,273 £5,900
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """




    # 5.3 Retrieve parameters for the SECOND Delivery Org
    And   I retrieve the latest EFA contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10025197'
   #And   I retrieve the latest contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920'

    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: UNIVERSITY CENTRE QUAYSIDE LIMITED UKPRN: 10025197
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £39,197 £398 £4,422 £6,141 £5,207 £59 £7,553 £3,084 £6,428 £2,235 £1,025 £431 £2,214
    Total Funding £39,197 £398 £4,422 £6,141 £5,207 £59 £7,553 £3,084 £6,428 £2,235 £1,025 £431 £2,214
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """


    # 5.4 Retrieve parameters for the THIRD Delivery Org
    And   I retrieve the latest EFA contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10023229'
   #And   I retrieve the latest contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920'

    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: VENTURE FORWARD LIMITED UKPRN: 10023229
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £56,934 £2,833 £5,094 £423 £6,485 £7,928 £3,597 £2,801 £7,302 £7,589 £4,616 £7,694 £572
    Total Funding £56,934 £2,833 £5,094 £423 £6,485 £7,928 £3,597 £2,801 £7,302 £7,589 £4,616 £7,694 £572
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """




    # 5.5 Retrieve parameters for the FOURTH Delivery Org
    And   I retrieve the latest EFA contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10026108'
   #And   I retrieve the latest contract details from CRM for provider '10017879' for FundingType 'EDSK' and period '1920'

    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: VIRTUAL ALLIANCE LIMITED UKPRN: 10026108
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £46,912 £304 £6,641 £3,531 £4,911 £4,995 £4,741 £5,505 £1,100 £2,140 £3,244 £7,883 £1,917
    Total Funding £46,912 £304 £6,641 £3,531 £4,911 £4,995 £4,741 £5,505 £1,100 £2,140 £3,244 £7,883 £1,917
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
    And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017879'
    
    # Create dummy Terms and Conditions files base on Resources/DummyPdf.pdf. Each has one page containing just the work 'Appendices'
    And   there are no files prefixed '10017879' in the Sharepoint 'EDSK-1920-Input-Terms And Conditions' folder
    And   a file with filename '10017879_[ContractNo]_84.pdf' is created in 'EDSK-1920-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017879' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check that the doc merge task has been completed for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017879'
    | Task                             | Description                                         | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Initiate Document Merge          | 10017879 - Zebedee Co Ltd Awaiting documentation    | [ContractNo]   | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the WORKFLOW HISTORY for a merge successful event
    And   the workflow history on contract '[ContractNo]' version '1' includes the following
    | Action                           | CompletedBy     | Comment                        |
    | Document Merge Successful        | CRM Integration | ?                              |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017879 | [ContractNo]       | 1                     | 0                        | Draft            | In Review                 | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017879 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20220614
Scenario: A641 Bulk load to create a new EDSK2223 loans contract using invalid ContractTypes x2. Fail CBR-005

    # Note: This test was valid prior to the deployment of config v64.05. While NMSS and SPI contract types are still invalid 
    #        for loans-only contracts, the system no longer prevents it. Test has been withdrawn

    Given there are no allocations marked as Under Termination for UKPRN '10017641' 
    And   there are no terminated or closed allocations for UKPRN '10017641' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017641' 

    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017641' 


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017641' 
    And   there is no caseload advisor for UKPRN '10017641' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017641 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017641' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017641 Co Ltd' with UKPRN '10017641' and OrgId 'ORG0017641' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017641 | 117641 | 10017641 Co Ltd | 0              | Active                | Yes           | AA017641      | ?             | 41 Send Barns Lane     | Send                   | Woking                 | ?                      | ?                      | Surrey                 | GU23 7BS  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017641 |





    # Change the date
    Given the override date is '22/07/2022'

    # Bulk import to create a new EDSK2223 (Loans) contract with unrecognised ContractType: Conditions of Funding (Grant) (NMSS). Fail CBR-005 
    And   there are no files prefixed '10017641' in the Sharepoint 'EDSK-2223-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2223 30032022171049 v3_A641a' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2223 30032022171049 v3_A641a' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2223 30032022171049 v3_A641a' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2223 30032022171049 v3_A641a' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2223 30032022171049 v3_A641a.xlsx' exists in the Datafiles folder and UKPRN '10017641' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
  # And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # CBR-005
    And   '[Contract] Contract Type is not valid for this Funding Type and Period' is displayed in field 'J2' on the 'Contract' tab of the result report





    # Change the date
    Given the override date is '25/07/2022'

    # Bulk import to create a new EDSK2223 (Loans) contract with unrecognised ContractType: Conditions of Funding (Grant) (SPI). Fail CBR-005 
    And   there are no files prefixed '10017641' in the Sharepoint 'EDSK-2223-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2223 30032022171055 v3_A641b' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2223 30032022171055 v3_A641b' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2223 30032022171055 v3_A641b' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2223 30032022171055 v3_A641b' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2223 30032022171055 v3_A641b.xlsx' exists in the Datafiles folder and UKPRN '10017641' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
  # And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # CBR-005
    And   '[Contract] Contract Type is not valid for this Funding Type and Period' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Tidy up
	And the override date is reset
	  
@AcceptanceTest @Withdrawn20251024
Scenario: A929 Create a new 2223 EDSK contract for ALLF with Contracting Org plus three Delivery Orgs. CofG_College. Update draft then NFA 2x. Update template timestamp. Check docs
    
    # 1. Create 22/23 EDSK loans (ALLF) contract with three Delivery Orgs
    # 2. Bulk update draft to create v1.1 and check docs
    # 3. Publish and approve v1.1
    # 4. NFA variation amendment to create v2.0 then check docs
    # 5. Publish and approve v2.0
    # 6. Change Sch1 template timestamp to a date after NFA variation amendment v2.0
    # 7. NFA variation amendment to create v3.0 then check docs
    
    Given there are no allocations marked as Under Termination for UKPRN '10017929' 
    And   there are no terminated or closed allocations for UKPRN '10017929' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017929' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017929' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017929' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLF-929      |

    # Set the 'base' timestamp for each of the 22\23 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_EDSK_2022-08-01.docx                        | 2022-04-01 12:00:00.000 | 
    # 
    | EDSK2223_TAC_CFS_ITP_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_COLLEGE_2022-08-01.docx       | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_EMPLOYER_2022-08-01.docx      | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_HEI_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_LA_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_TRUST_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    # 
    | EDSK2223_S1_LOANS_CFS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_LOANS_COFG_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    # 
    | EDSK2223_S2_LOANS_CFS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_LOANS_COFG_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    # 
    | FA_EDSK2223_2022-08-01.docx                     | 2022-04-01 12:00:00.000 | 
    # 
    | EDSK2223_S3ON_CFS_ITP_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_COLLEGE_2022-08-01.docx      | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_EMPLOYER_2022-08-01.docx     | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_LA_TRUST_HEI_2022-08-01.docx | 2022-04-01 12:00:00.000 | 



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017929' 
    And   there is no Organisation data for UKPRN '10022880'
    And   there is no Organisation data for UKPRN '10026650'
    And   there is no Organisation data for UKPRN '10029829'

    And   caseload advisor 'FCS2 Test' is assigned to provider 'Vi Coactus Ltd' with UKPRN '10017929' and OrgId 'ORG0017929' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                                   | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1        | AddressLine2 | AddressLine3 | AddressLine4 | Town    | County        | Postcode |
    | 10017929 | 117929 | Vi Coactus Ltd                         | 0              | Active | Yes           | AA017929      | ?             | 9 Kneesworth Street | ?            | ?            | ?            | Royston | Hertfordshire | SG8 5AA  |
    | 10022880 | 74064  | GWE BUSINESS WEST LTD                  | 0              | Active | Yes           | ?             | ?             | ?                   | ?            | ?            | ?            | ?       | ?             | ?        |
    | 10026650 | 77228  | N-GAGED TRAINING & RECRUITMENT LIMITED | 0              | Active | Yes           | ?             | ?             | ?                   | ?            | ?            | ?            | ?       | ?             | ?        |
    | 10029829 | 81045  | WELCOME SKILLS LIMITED                 | 0              | Active | Yes           | ?             | ?             | ?                   | ?            | ?            | ?            | ?       | ?             | ?        |

    # Put the same Provider data in the CRM Organisation table J057
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    | 
    | 10017929 | 
    | 10022880 | 
    | 10026650 | 
    | 10029829 | 
	




    # Part 1: Create 22/23 EDSK loans (ALLF) contract with three Delivery Orgs

    # Change the date
    Given the override date is '01/07/2022'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                            | Period | CRMIntent    | OrgId      |
    | 10017929 | Vi Coactus Ltd       | ESFA-929             | EDSK-929       | 1                     | 01/08/2022        | 31/07/2023      | 98879.00      |                                    | Conditions of Funding (Grant) (College) | 2223   | New          | ORG0017929 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                   | CRMIntent    | DeliveryOrg |
    | 10017929 | EDSK-929       | ALLF-9295     | ALLF              | ALLF2223                | AY                      | 01/08/2022          | 31/07/2023        | 27600.00        |                                         |            |                                         | New          | 10017929    |
    | 10017929 | EDSK-929       | ALLF-9292     | ALLF              | ALLF2223                | AY                      | 01/08/2022          | 31/07/2023        | 18464.00        |                                         |            |                                         | New          | 10022880    |
    | 10017929 | EDSK-929       | ALLF-9293     | ALLF              | ALLF2223                | AY                      | 01/08/2022          | 31/07/2023        | 26130.00        |                                         |            |                                         | New          | 10029829    | 
    | 10017929 | EDSK-929       | ALLF-9294     | ALLF              | ALLF2223                | AY                      | 01/08/2022          | 31/07/2023        | 26685.00        |                                         |            |                                         | New          | 10026650    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableDescription                   | CRMIntent    | DeliveryOrg |
    | 10017929 | EDSK-929       | ALLF-9295     | 5               | 0                     | 27600.00  | 3175.00  | 2517.00  | 3506.00  | 541.00   | 3016.00  | 2992.00  | 2083.00  | 1109.00  | 3046.00  | 936.00   | 1830.00  | 2849.00  | Advanced Learner Loans Facility          | New          | 10017929    |
    | 10017929 | EDSK-929       | ALLF-9292     | 5               | 0                     | 18464.00  | 1986.00  | 2910.00  | 2855.00  | 301.00   | 563.00   | 760.00   | 167.00   | 1946.00  | 3029.00  | 2500.00  | 1368.00  | 79.00    | Advanced Learner Loans Facility          | New          | 10022880    |
    | 10017929 | EDSK-929       | ALLF-9293     | 5               | 0                     | 26130.00  | 3249.00  | 917.00   | 512.00   | 3462.00  | 2014.00  | 2656.00  | 2696.00  | 2577.00  | 2933.00  | 1866.00  | 1367.00  | 1881.00  | Advanced Learner Loans Facility          | New          | 10029829    |
    | 10017929 | EDSK-929       | ALLF-9294     | 5               | 0                     | 26685.00  | 1158.00  | 2398.00  | 1395.00  | 1687.00  | 3530.00  | 1702.00  | 2502.00  | 2067.00  | 3372.00  | 3159.00  | 1079.00  | 2636.00  | Advanced Learner Loans Facility          | New          | 10026650    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'





    # Part 2: Bulk update draft to create v1.1 and check docs
    
    # Change the date
    Given the override date is '18/07/2022'

    # Bulk import to execute an Update Draft for an ALLF alloc
    And   there are no files prefixed '10017929' in the Sharepoint 'EDSK-2223-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2223 31032022113910 v3_A929' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2223 31032022113910 v3_A929' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2223 31032022113910 v3_A929' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2223 31032022113910 v3_A929' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2223 31032022113910 v3_A929.xlsx' exists in the Datafiles folder and UKPRN '10017929' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-929       | 1                     | 1                        | 2022-07-18 09:12:35.000 |


 #  # Assign a Caseload Advisor
 #  Given caseload advisor 'FCS2 Test' is assigned to UKPRN '10017929'


    # Retreive parameters
   #Then  I retrieve the latest contract details from CRM for provider '10017929' for FundingType 'EDSK' and period '2223'
    Then  I retrieve the latest EFA contract details from CRM for provider '10017929' for FundingType 'EDSK' and period '2223' and Delivery Organisation '10017929'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, FA(4xALLF), Sch3ON)
   #And   the file named '10017929_' & '[ContractNo]' & '_v1.pdf' created in Sharepoint location 'EDSK-1920-Input-Appendices' contains the following lines in order
    Then  the file named '10017929_EDSK-929_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: Vi Coactus Ltd UKPRN: 10017929
    Master Contract Number: ESFA-929
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    Advanced Learner Loans Facility
    Vi Coactus Ltd ALLF-9295 £36,485 £13,386 £49,871
    GWE BUSINESS WEST LTD ALLF-9292 £36,485 £13,386 £49,871
    N-GAGED TRAINING & RECRUITMENT LIMITED ALLF-9294 £36,485 £13,386 £49,871
    WELCOME SKILLS LIMITED ALLF-9293 £36,485 £13,386 £49,871
    Total Funding for this contract: £199,484
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And Vi Coactus Ltd
    Funding for Advanced Learner Loans
    Master Agreement Number ESFA-929
    ACCEPTANCE BY THE COLLEGE
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 3 (November 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    Vi Coactus Ltd THE SECRETARY OF STATE FOR
    9 Kneesworth Street EDUCATION
    Royston DEPARTMENT FOR EDUCATION
    Hertfordshire AND 20 GREAT SMITH STREET
    SG8 5AA LONDON
    SW1P 3BT
    Company No: AA017929
    Hereinafter called Hereinafter called
    the College the Department
    EDSK Version 3 (November 2022) Page 2
    EDSK Version 3 (November 2022) Page 74
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (August 2022) – Page 1
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (August 2022) – Page 9
    
    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Facility
    EDSK Schedule 2 – Advanced Learner Loans Version 2 (July 2022) – Page 1
    EDSK Schedule 2 – Advanced Learner Loans Version 2 (July 2022) – Page 2
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: Vi Coactus Ltd UKPRN: 10017929
    Master Contract Number: ESFA-929 Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: ALLF-9295
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Advanced Learner Loans Facility £49,871 £892 £4,374 £7,718 £3,524 £4,426 £3,832 £5,615 £6,104 £414 £3,694 £3,917 £5,361
    Total Funding £49,871 £892 £4,374 £7,718 £3,524 £4,426 £3,832 £5,615 £6,104 £414 £3,694 £3,917 £5,361
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLF-9295 – Page 1 Ref (for internal use only):  EDSK-929 v1

    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: GWE BUSINESS WEST LTD UKPRN: 10022880
    Master Contract Number: ESFA-929 Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: ALLF-9292
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Advanced Learner Loans Facility £49,871 £892 £4,374 £7,718 £3,524 £4,426 £3,832 £5,615 £6,104 £414 £3,694 £3,917 £5,361
    Total Funding £49,871 £892 £4,374 £7,718 £3,524 £4,426 £3,832 £5,615 £6,104 £414 £3,694 £3,917 £5,361
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLF-9292 – Page 1 Ref (for internal use only):  EDSK-929 v1
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: N-GAGED TRAINING & RECRUITMENT LIMITED UKPRN: 10026650
    Master Contract Number: ESFA-929 Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: ALLF-9294
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Advanced Learner Loans Facility £49,871 £892 £4,374 £7,718 £3,524 £4,426 £3,832 £5,615 £6,104 £414 £3,694 £3,917 £5,361
    Total Funding £49,871 £892 £4,374 £7,718 £3,524 £4,426 £3,832 £5,615 £6,104 £414 £3,694 £3,917 £5,361
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLF-9294 – Page 1 Ref (for internal use only):  EDSK-929 v1
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: WELCOME SKILLS LIMITED UKPRN: 10029829
    Master Contract Number: ESFA-929 Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: ALLF-9293
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    Advanced Learner Loans Facility £49,871 £892 £4,374 £7,718 £3,524 £4,426 £3,832 £5,615 £6,104 £414 £3,694 £3,917 £5,361
    Total Funding £49,871 £892 £4,374 £7,718 £3,524 £4,426 £3,832 £5,615 £6,104 £414 £3,694 £3,917 £5,361
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLF-9293 – Page 1 Ref (for internal use only):  EDSK-929 v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 3 (November 2022) – Page 1

    SCHEDULE 9: COLLEGE GOVERNANCE
    4.4 The College must obtain the written consent of the Secretary of State
    before entering into any new arrangements for Borrowing Money and for
    any amendment to such arrangements from 29 November 2022 and
    before entering into any amendment to arrangements for Borrowing
    Money that existed before 29 November 2022. Failure to do so will amount
    to a breach of this Agreement and the provisions of Part 8 (Clauses 34 to
    37) will apply.
    EDSK Schedule 9 Version 3 (November 2022) – Page 2

    SCHEDULE 10: SUB-CONTRACTING
    EDSK Schedule 10 Version 3 (November 2022) – Page 5
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017929_[ContractNo]_v1.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A929v1.pdf'



    # Part 3: Publish and approve v1.1
    
    # Change the date
    Given the override date is '22/07/2022'
    
    # Update the contract to 'Published to Provider'
    And   the latest version of contract 'EDSK-929' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-929' and actual ContractNumber 'EDSK-929'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017929 | EDSK-929           | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017929 | EDSK-929           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017929 | ESFA-929           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |




 
    # Part 4: NFA variation amendment to create v2.0 then check docs

	# Change the date
    Given the override date is '25/07/2022'

	# Issue a non-financial VARIATION amendment on v1 to create v2
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '1' of contract 'EDSK-929' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '1' of contract 'EDSK-929' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017929 | EDSK-929           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017929 | EDSK-929           | 1                     | 1                        | Approved         | Approved                  | False         | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017929 | EDSK-929           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017929 | ESFA-929           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-929       | 2                     | 0                        | 2022-07-25 09:12:35.000 |

    # Retrieve parameters for the Contracting Org
    Then  I retrieve the latest EFA contract details from CRM for provider '10017929' for FundingType 'EDSK' and period '2223' and Delivery Organisation '10017929'
   #Then  I retrieve the latest contract details from CRM for provider '10017929' for FundingType 'EDSK' and period '2223'

    # Check the contents of the Appendices (Just SoF) 
    Then  the file named '10017929_EDSK-929_v2.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: Vi Coactus Ltd UKPRN: 10017929
    Master Contract Number: ESFA-929
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    Advanced Learner Loans Facility
    Vi Coactus Ltd ALLF-9295 £36,485 £13,386 £49,871
    GWE BUSINESS WEST LTD ALLF-9292 £36,485 £13,386 £49,871
    N-GAGED TRAINING & RECRUITMENT LIMITED ALLF-9294 £36,485 £13,386 £49,871
    WELCOME SKILLS LIMITED ALLF-9293 £36,485 £13,386 £49,871
    Total Funding for this contract: £199,484
    Summary of Funding – Page 1
    """

    # There should not be a Main Terms and Conditions document
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    """

    # There should not be a Sch1 document
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """

    # There should not be any Funding Agreement documents
    And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """

    # There should not be a Schedule 3 document
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """





    # Part 5: Publish and approve v2.0
    
	# Change the date
    Given the override date is '26/07/2022'
    
    # Update the contract to 'Published to Provider'
    And   the latest version of contract 'EDSK-929' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-929' and actual ContractNumber 'EDSK-929'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017929 | EDSK-929           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017929 | EDSK-929           | 1                     | 1                        | Replaced         | Approved                  | False         | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017929 | EDSK-929           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017929 | ESFA-929           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |





    # Part 6: Change Sch1 template timestamp to a date after NFA variation amendment v2.0
    
	# Change the date
    Given the override date is '28/07/2022'    
    
    # Set the timestamp for each of the 22\23 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_EDSK_2022-08-01.docx                        | 2022-04-01 12:00:00.000 | 
    # 
    | EDSK2223_TAC_CFS_ITP_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_COLLEGE_2022-08-01.docx       | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_EMPLOYER_2022-08-01.docx      | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_HEI_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_LA_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_TRUST_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    # 
    | EDSK2223_S1_LOANS_CFS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_LOANS_COFG_2022-08-01.docx          | 2022-07-28 17:18:19.000 | 
    # 
    | EDSK2223_S2_LOANS_CFS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_LOANS_COFG_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    # 
    | FA_EDSK2223_2022-08-01.docx                     | 2022-04-01 12:00:00.000 | 
    # 
    | EDSK2223_S3ON_CFS_ITP_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_COLLEGE_2022-08-01.docx      | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_EMPLOYER_2022-08-01.docx     | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_LA_TRUST_HEI_2022-08-01.docx | 2022-04-01 12:00:00.000 |     





    # Part 7: NFA variation amendment to create v3.0 then check docs

	# Change the date
    Given the override date is '30/07/2022'

	# Issue a non-financial VARIATION amendment on v1 to create v2
   #When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'EDSK-929' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'EDSK-929' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017929 | EDSK-929           | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017929 | EDSK-929           | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017929 | EDSK-929           | 1                     | 1                        | Replaced         | Approved                  | False         | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017929 | EDSK-929           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10017929 | ESFA-929           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |



    # Retrieve parameters for the Contracting Org
    Then  I retrieve the latest EFA contract details from CRM for provider '10017929' for FundingType 'EDSK' and period '2223' and Delivery Organisation '10017929'
   #Then  I retrieve the latest contract details from CRM for provider '10017929' for FundingType 'EDSK' and period '2223'

    # Check the contents of the Appendices (SoF plus Sch1 - which has an updated template) 
    Then  the file named '10017929_EDSK-929_v3.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: Vi Coactus Ltd UKPRN: 10017929
    Master Contract Number: ESFA-929
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    Advanced Learner Loans Facility
    Vi Coactus Ltd ALLF-9295 £36,485 £13,386 £49,871
    GWE BUSINESS WEST LTD ALLF-9292 £36,485 £13,386 £49,871
    N-GAGED TRAINING & RECRUITMENT LIMITED ALLF-9294 £36,485 £13,386 £49,871
    WELCOME SKILLS LIMITED ALLF-9293 £36,485 £13,386 £49,871
    Total Funding for this contract: £199,484
    Summary of Funding – Page 1

    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (August 2022) – Page 1
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (August 2022) – Page 9
    """

    # There should not be a Main Terms and Conditions document
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    """

    # There should not be any Funding Agreement documents
    And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """

    # There should not be a Schedule 3 document
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """


    # Tidy up
    Given the override date is reset

    # Re-Set the 'base' timestamp for each of the 22\23 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_EDSK_2022-08-01.docx                        | 2022-04-01 12:00:00.000 | 
    # 
    | EDSK2223_TAC_CFS_ITP_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_COLLEGE_2022-08-01.docx       | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_EMPLOYER_2022-08-01.docx      | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_HEI_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_LA_2022-08-01.docx            | 2022-04-01 12:00:00.000 | 
    | EDSK2223_TAC_COFG_TRUST_2022-08-01.docx         | 2022-04-01 12:00:00.000 | 
    # 
    | EDSK2223_S1_LOANS_CFS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S1_LOANS_COFG_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    # 
    | EDSK2223_S2_LOANS_CFS_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S2_LOANS_COFG_2022-08-01.docx          | 2022-04-01 12:00:00.000 | 
    # 
    | FA_EDSK2223_2022-08-01.docx                     | 2022-04-01 12:00:00.000 | 
    # 
    | EDSK2223_S3ON_CFS_ITP_2022-08-01.docx           | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_COLLEGE_2022-08-01.docx      | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_EMPLOYER_2022-08-01.docx     | 2022-04-01 12:00:00.000 | 
    | EDSK2223_S3ON_COFG_LA_TRUST_HEI_2022-08-01.docx | 2022-04-01 12:00:00.000 | 

