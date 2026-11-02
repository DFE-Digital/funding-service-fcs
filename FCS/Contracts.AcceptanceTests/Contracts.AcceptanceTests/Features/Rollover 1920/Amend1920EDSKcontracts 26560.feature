Feature: Amend1920EDSKcontracts 26560

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run45
Scenario: A541 Create and approve a 1920 EDSK contract. Execute multiple amendments and updates checking docs along the way
    Given there are no allocations marked as Under Termination for UKPRN '10017541' 
    And   there are no terminated or closed allocations for UKPRN '10017541' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017541' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-541      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017541' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017541 Co Ltd' with UKPRN '10017541' and OrgId 'ORG0017541' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017541' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017541 | 117541 | 10017541 Co Ltd | 0              | Active                | Yes           | AA017541      | ?             | 66 St Andrews Road     | Hanley On Thames       | Oxon                   | ?                      | ?                      | ?                      | RG9 1JE   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017541 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription    | ContractType                         | Period | CRMIntent    | OrgId      |
    | 10017541 | 10017541 Co Ltd      | ESFA-541             | EDSK-541       | 1                     | 01/08/2019        | 31/07/2020      | 21286.00      |                        | Conditions of Funding (Grant) (HEI)  | 1920   | New          | ORG0017541 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017541 | EDSK-541       | ALLF-541      | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 31/07/2020        | 21286.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017541 | EDSK-541       | ALLF-541      | 5               | 0                     | 21286.00  | 1820.00  | 2808.00  | 3544.00  | 2319.00  | 2294.00  | 1385.00  | 412.00   | 2349.00  | 239.00   | 1133.00  | 2151.00  | 832.00   | Advanced Learner Loans Facility                                 | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'




    # Change the date
    Given the override date is '02/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-541' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '03/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-541' and actual ContractNumber 'EDSK-541'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-541' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017541 | EDSK-541           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017541 | ESFA-541           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'EDSK-541'




    # Change the date
    Given the override date is '04/07/2019'

    # Bulk upload a contract amendment to create v2 from v1, adding a Loans Bursary allocation
	#  Only the Loans Bursary allocation is in the bulk file
    And   there are no files prefixed '10017541' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 11062019134015 v3_A541_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 11062019134015 v3_A541_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 11062019134015 v3_A541_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 11062019134015 v3_A541_1.xlsx' exists in the Datafiles folder and UKPRN '10017541' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters for the Contracting Org
   #Given I retrieve the latest EFA contract details from CRM for provider '10017541' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017541'
    Given I retrieve the latest contract details from CRM for provider '10017541' for FundingType 'EDSK' and period '1920'

    # Check that just the expected document parts are present 

	# Includes a Summary of Funding
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017541 Co Ltd UKPRN: 10017541
    Master Contract Number: ESFA-541
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility ALLF-541 £16,931 £4,355 £21,286
    Advanced Learner Loans Bursary [AllocRef_ALLB] £31,570 £13,645 £45,215
    Total Funding for this contract: £66,501
    Summary of Funding – Page 1
    """

    # No 'Terms and Conditions' doc
    And   the pdf file does not contain the following text
    """
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    """

    # No 'Schedule 1' docs
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """

    # No 'Schedule 2: Payment' docs
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2: PAYMENT
    """

	# Includes a Schedule 2 Funding Agreement for Loans Bursary
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017541 Co Ltd UKPRN: 10017541
    Master Contract Number: ESFA-541 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLB]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Bursary Funding £45,215 £3,252 £1,363 £2,807 £6,426 £5,630 £2,180 £2,467 £7,445 £2,572 £3,401 £4,643 £3,029
    Total Funding £45,215 £3,252 £1,363 £2,807 £6,426 £5,630 £2,180 £2,467 £7,445 £2,572 £3,401 £4,643 £3,029
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  EDSK-541 v2
    """

    # No Schedule 2 Funding Agreement for Loans Facility
    And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """
	
    # No 'Schedules 3-9' doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    # Save a copy of the output
   #And   Sharepoint file '10017541_[ContractNo]_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017541_[ContractNo]_v2.pdf'
    And   Sharepoint file '10017541_EDSK-541_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017541_EDSK-541_v2.pdf'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-541' is in a state of 'Published to Provider'

	# Withdraw v2 of the contract 
    When  the next action performed on the latest version of contract 'EDSK-541' is 'Withdraw On Behalf Of Provider' with reason 'The Provider was rude to me' by 'FCS1 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017541 | EDSK-541           | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017541 | EDSK-541           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017541 | ESFA-541           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Change the date
    Given the override date is '05/07/2019'

    # Bulk upload a contract amendment to create v3 from v1, adding a Loans Bursary allocation
	#  Both the Loans Bursary and Loans Facility details are in the bulk file. The latter details are unchanged from v1
    And   there are no files prefixed '10017541' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 11062019134021 v3_A541_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 11062019134021 v3_A541_2' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 11062019134021 v3_A541_2' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 11062019134021 v3_A541_2.xlsx' exists in the Datafiles folder and UKPRN '10017541' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters for the Contracting Org
   #Given I retrieve the latest EFA contract details from CRM for provider '10017541' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017541'
    Given I retrieve the latest contract details from CRM for provider '10017541' for FundingType 'EDSK' and period '1920'

    # Check that just the expected document parts are present 

	# Includes a Summary of Funding
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017541 Co Ltd UKPRN: 10017541
    Master Contract Number: ESFA-541
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility ALLF-541 £16,931 £4,355 £21,286
    Advanced Learner Loans Bursary [AllocRef_ALLB] £31,570 £13,645 £45,215
    Total Funding for this contract: £66,501
    Summary of Funding – Page 1
    """

    # No 'Terms and Conditions' doc
    And   the pdf file does not contain the following text
    """
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    """

    # No 'Schedule 1' docs
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """

    # No 'Schedule 2: Payment' docs
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2: PAYMENT
    """

    # No Schedule 2 Funding Agreement for Loans Facility
    And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """

	# Includes a Schedule 2 Funding Agreement for Loans Bursary
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017541 Co Ltd UKPRN: 10017541
    Master Contract Number: ESFA-541 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLB]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Bursary Funding £45,215 £3,252 £1,363 £2,807 £6,426 £5,630 £2,180 £2,467 £7,445 £2,572 £3,401 £4,643 £3,029
    Total Funding £45,215 £3,252 £1,363 £2,807 £6,426 £5,630 £2,180 £2,467 £7,445 £2,572 £3,401 £4,643 £3,029
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  EDSK-541 v3
    """

    # No Schedules 3-9
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    # Save a copy of the output
   #And   Sharepoint file '10017541_[ContractNo]_v3.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017541_[ContractNo]_v3a.pdf'
    And   Sharepoint file '10017541_EDSK-541_v3.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017541_EDSK-541_v3a.pdf'




    # Change the date
    Given the override date is '06/07/2019'

    # Bulk upload an update draft amendment against v3, adding a 16-18 Traineeships allocation
	#  Only the the 16-18 Traineeships details are in the bulk file
    And   there are no files prefixed '10017541' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 11062019151130 v3_A541_3' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 11062019151130 v3_A541_3' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 11062019151130 v3_A541_3' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 11062019151130 v3_A541_3.xlsx' exists in the Datafiles folder and UKPRN '10017541' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters for the Contracting Org
   #Given I retrieve the latest EFA contract details from CRM for provider '10017541' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017541'
    Given I retrieve the latest contract details from CRM for provider '10017541' for FundingType 'EDSK' and period '1920'

    # Check that just the expected document parts are present 

	# Includes a Summary of Funding
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017541 Co Ltd UKPRN: 10017541
    Master Contract Number: ESFA-541
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility ALLF-541 £16,931 £4,355 £21,286
    Advanced Learner Loans Bursary [AllocRef_ALLB] £31,570 £13,645 £45,215
    16 to 18 Traineeships [AllocRef_16TR] £66,235 £44,088 £110,323
    Total Funding for this contract: £176,824
    Summary of Funding – Page 1
    """

    # No 'Terms and Conditions' doc
    And   the pdf file does not contain the following text
    """
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    """

	# Includes a Schedule 1 for 16-18 Traineeships
    And   the pdf file contains the following page lines in order
    """
	SCHEDULE 1: SPECIFICATION & MONITORING
	16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
	8. The Provider shall recruit eligible Learners onto this service from the
	"""

    # No 'Schedule 1' docs for Loans
    And   the pdf file does not contain the following text
    """
    ADVANCED LEARNER LOANS SPECIFICATION
    """

    # No 'Schedule 2: Payment' doc for Loans
    And   the pdf file does not contain the following text
    """
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    """

    # No Schedule 2 Funding Agreement for Loans Facility
    And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """

	# Includes a 'Schedule 2:Payment' doc for 16-18 Traineeships
    And   the pdf file contains the following page lines in order
    """
	SCHEDULE 2: PAYMENT
	16-18-YEAR-OLD TRAINEESHIPS
	1. The Provider will submit ILR Learner data and the Earning Adjustment
	"""

	# Includes Schedule 2 Funding Agreements for Loans Bursary and 16-18 Traineeships
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017541 Co Ltd UKPRN: 10017541
    Master Contract Number: ESFA-541 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLB]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Bursary Funding £45,215 £3,252 £1,363 £2,807 £6,426 £5,630 £2,180 £2,467 £7,445 £2,572 £3,401 £4,643 £3,029
    Total Funding £45,215 £3,252 £1,363 £2,807 £6,426 £5,630 £2,180 £2,467 £7,445 £2,572 £3,401 £4,643 £3,029
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  EDSK-541 v3

    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017541 Co Ltd UKPRN: 10017541
    Master Contract Number: ESFA-541 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    16 to 18 Traineeships Programme Funding £56,998 £6,685 £4,934 £125 £6,600 £5,189 £7,312 £942 £6,261 £6,208 £4,254 £2,163 £6,325
    16 to 18 Traineeships Bursary Funding £53,325 £1,792 £3,713 £5,900 £3,065 £5,730 £3,575 £4,202 £210 £6,345 £5,953 £5,019 £7,821
    Total Funding £110,323 £8,477 £8,647 £6,025 £9,665 £10,919 £10,887 £5,144 £6,471 £12,553 £10,207 £7,182 £14,146
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  EDSK-541 v3
    """

    # No Schedules 3-9
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    # Save a copy of the output
   #And   Sharepoint file '10017541_[ContractNo]_v3.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017541_[ContractNo]_v3b.pdf'
    And   Sharepoint file '10017541_EDSK-541_v3.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017541_EDSK-541_v3b.pdf'




    # Change the date
    Given the override date is '07/07/2019'

    # Bulk upload an update draft amendment against v3
	#  Change August from £1820 to £2000 on the Loans Facility allocation. Nothing else in the bulk file
    And   there are no files prefixed '10017541' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 11062019152431 v3_A541_4' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 11062019152431 v3_A541_4' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 11062019152431 v3_A541_4' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 11062019152431 v3_A541_4.xlsx' exists in the Datafiles folder and UKPRN '10017541' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters for the Contracting Org
   #Given I retrieve the latest EFA contract details from CRM for provider '10017541' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017541'
    Given I retrieve the latest contract details from CRM for provider '10017541' for FundingType 'EDSK' and period '1920'

    # Check that just the expected document parts are present 
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
	"""
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017541 Co Ltd UKPRN: 10017541
    Master Contract Number: ESFA-541
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility ALLF-541 £17,111 £4,355 £21,466
    Advanced Learner Loans Bursary [AllocRef_ALLB] £31,570 £13,645 £45,215
    16 to 18 Traineeships [AllocRef_16TR] £66,235 £44,088 £110,323
    Total Funding for this contract: £177,004
    Summary of Funding – Page 1
    """

    # No 'Terms and Conditions' doc
    And   the pdf file does not contain the following text
    """
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    """

    # No 'Schedule 1' docs for Loans
    And   the pdf file does not contain the following text
    """
    ADVANCED LEARNER LOANS SPECIFICATION
    """
	
	# Includes a Schedule 1 for 16-18 Traineeships
    And   the pdf file contains the following page lines in order
    """
	SCHEDULE 1: SPECIFICATION & MONITORING
	16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
	"""

    # No 'Schedule 2: Payment' doc for Loans
    And   the pdf file does not contain the following text
    """
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    """

	# Includes Schedule 2 Funding Agreements for Loans Facility and Loans Bursary
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017541 Co Ltd UKPRN: 10017541
    Master Contract Number: ESFA-541 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
	Advanced Learner Loans Facility £21,466 £2,000 £2,808 £3,544 £2,319 £2,294 £1,385 £412 £2,349 £239 £1,133 £2,151 £832
	Total Funding £21,466 £2,000 £2,808 £3,544 £2,319 £2,294 £1,385 £412 £2,349 £239 £1,133 £2,151 £832
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  EDSK-541 v3

    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017541 Co Ltd UKPRN: 10017541
    Master Contract Number: ESFA-541 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLB]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Bursary Funding £45,215 £3,252 £1,363 £2,807 £6,426 £5,630 £2,180 £2,467 £7,445 £2,572 £3,401 £4,643 £3,029
    Total Funding £45,215 £3,252 £1,363 £2,807 £6,426 £5,630 £2,180 £2,467 £7,445 £2,572 £3,401 £4,643 £3,029
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  EDSK-541 v3
    """

	# Includes a 'Schedule 2:Payment' doc for 16-18 Traineeships
    And   the pdf file contains the following page lines in order
    """
	SCHEDULE 2: PAYMENT
	16-18-YEAR-OLD TRAINEESHIPS
	1. The Provider will submit ILR Learner data and the Earning Adjustment
	"""

	# Includes Schedule 2 Funding Agreement for 16-18 Traineeships
    And   the pdf file contains the following page lines in order
    """
	SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017541 Co Ltd UKPRN: 10017541
    Master Contract Number: ESFA-541 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    16 to 18 Traineeships Programme Funding £56,998 £6,685 £4,934 £125 £6,600 £5,189 £7,312 £942 £6,261 £6,208 £4,254 £2,163 £6,325
    16 to 18 Traineeships Bursary Funding £53,325 £1,792 £3,713 £5,900 £3,065 £5,730 £3,575 £4,202 £210 £6,345 £5,953 £5,019 £7,821
    Total Funding £110,323 £8,477 £8,647 £6,025 £9,665 £10,919 £10,887 £5,144 £6,471 £12,553 £10,207 £7,182 £14,146
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  EDSK-541 v3
    """

    # No Schedules 3-9
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    # Save a copy of the output
   #And   Sharepoint file '10017541_[ContractNo]_v3.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017541_[ContractNo]_v3c.pdf'
    And   Sharepoint file '10017541_EDSK-541_v3.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017541_EDSK-541_v3c.pdf'

	


    # Change the date
    Given the override date is '08/07/2019'

    # Bulk upload an update draft amendment against v3
	#  Change August from £2000 back to £1820 on the Loans Facility allocation. Nothing else in the bulk file 
    And   there are no files prefixed '10017541' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 11062019152555 v3_A541_5' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 11062019152555 v3_A541_5' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 11062019152555 v3_A541_5' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 11062019152555 v3_A541_5.xlsx' exists in the Datafiles folder and UKPRN '10017541' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters for the Contracting Org
   #Given I retrieve the latest EFA contract details from CRM for provider '10017541' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017541'
    Given I retrieve the latest contract details from CRM for provider '10017541' for FundingType 'EDSK' and period '1920'

    # Check that just the expected document parts are present
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
	"""
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017541 Co Ltd UKPRN: 10017541
    Master Contract Number: ESFA-541
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility ALLF-541 £16,931 £4,355 £21,286
    Advanced Learner Loans Bursary [AllocRef_ALLB] £31,570 £13,645 £45,215
    16 to 18 Traineeships [AllocRef_16TR] £66,235 £44,088 £110,323
    Total Funding for this contract: £176,824
    Summary of Funding – Page 1
    """

    # No 'Terms and Conditions' doc
    And   the pdf file does not contain the following text
    """
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    """

    # No 'Schedule 1' docs for Loans
    And   the pdf file does not contain the following text
    """
    ADVANCED LEARNER LOANS SPECIFICATION
    """
	
	# Includes a Schedule 1 for 16-18 Traineeships
    And   the pdf file contains the following page lines in order
    """
	SCHEDULE 1: SPECIFICATION & MONITORING
	16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
	8. The Provider shall recruit eligible Learners onto this service from the
	"""

    # No 'Schedule 2: Payment' doc for Loans
    And   the pdf file does not contain the following text
    """
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    """

    # No Schedule 2 Funding Agreement for Loans Facility
    And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """

	# Includes Schedule 2 Funding Agreement for Loans Bursary
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017541 Co Ltd UKPRN: 10017541
    Master Contract Number: ESFA-541 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLB]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Bursary Funding £45,215 £3,252 £1,363 £2,807 £6,426 £5,630 £2,180 £2,467 £7,445 £2,572 £3,401 £4,643 £3,029
    Total Funding £45,215 £3,252 £1,363 £2,807 £6,426 £5,630 £2,180 £2,467 £7,445 £2,572 £3,401 £4,643 £3,029
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  EDSK-541 v3
    """

	# Includes a 'Schedule 2:Payment' doc for 16-18 Traineeships
    And   the pdf file contains the following page lines in order
    """
	SCHEDULE 2: PAYMENT
	16-18-YEAR-OLD TRAINEESHIPS
	1. The Provider will submit ILR Learner data and the Earning Adjustment
	"""

	# Includes Schedule 2 Funding Agreement for 16-18 Traineeships
    And   the pdf file contains the following page lines in order
    """
	SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017541 Co Ltd UKPRN: 10017541
    Master Contract Number: ESFA-541 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    16 to 18 Traineeships Programme Funding £56,998 £6,685 £4,934 £125 £6,600 £5,189 £7,312 £942 £6,261 £6,208 £4,254 £2,163 £6,325
    16 to 18 Traineeships Bursary Funding £53,325 £1,792 £3,713 £5,900 £3,065 £5,730 £3,575 £4,202 £210 £6,345 £5,953 £5,019 £7,821
    Total Funding £110,323 £8,477 £8,647 £6,025 £9,665 £10,919 £10,887 £5,144 £6,471 £12,553 £10,207 £7,182 £14,146
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  EDSK-541 v3
    """

    # No Schedules 3-9
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    # Save a copy of the output
   #And   Sharepoint file '10017541_[ContractNo]_v3.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017541_[ContractNo]_v3d.pdf'
    And   Sharepoint file '10017541_EDSK-541_v3.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017541_EDSK-541_v3d.pdf'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-541' is in a state of 'Published to Provider'

	# Withdraw v3 of the contract 
    When  the next action performed on the latest version of contract 'EDSK-541' is 'Withdraw On Behalf Of Provider' with reason 'My wife told me to do it' by 'FCS1 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017541 | EDSK-541           | 3                     | 3                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017541 | EDSK-541           | 3                     | 2                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017541 | EDSK-541           | 3                     | 1                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017541 | EDSK-541           | 3                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017541 | EDSK-541           | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017541 | EDSK-541           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017541 | ESFA-541           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |




    # Change the date
    Given the override date is '09/07/2019'

    # Bulk upload an update draft amendment against v1 to create v4
    And   there are no files prefixed '10017541' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 11062019175639 v3_A541_6' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 11062019175639 v3_A541_6' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 11062019175639 v3_A541_6' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 11062019175639 v3_A541_6.xlsx' exists in the Datafiles folder and UKPRN '10017541' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters for the Contracting Org
   #Given I retrieve the latest EFA contract details from CRM for provider '10017541' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017541'
    Given I retrieve the latest contract details from CRM for provider '10017541' for FundingType 'EDSK' and period '1920'

    # Check that just the expected document parts are present
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
	"""
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017541 Co Ltd UKPRN: 10017541
    Master Contract Number: ESFA-541
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility ALLF-541 £16,931 £4,355 £21,286
    Advanced Learner Loans Bursary [AllocRef_ALLB] £21,175 £14,490 £35,665
    16 to 18 Traineeships [AllocRef_16TR] £54,965 £33,670 £88,635
    Total Funding for this contract: £145,586
    Summary of Funding – Page 1
    """

    # No 'Terms and Conditions' doc
    And   the pdf file does not contain the following text
    """
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    """

    # No 'Schedule 1' docs for Loans
    And   the pdf file does not contain the following text
    """
    ADVANCED LEARNER LOANS SPECIFICATION
    """
	
	# Includes a Schedule 1 for 16-18 Traineeships
    And   the pdf file contains the following page lines in order
    """
	SCHEDULE 1: SPECIFICATION & MONITORING
	16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
	8. The Provider shall recruit eligible Learners onto this service from the
	"""

    # No 'Schedule 2: Payment' doc for Loans
    And   the pdf file does not contain the following text
    """
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    """

    # No Schedule 2 Funding Agreement for Loans Facility
    And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """

	# Includes Schedule 2 Funding Agreement for Loans Bursary
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017541 Co Ltd UKPRN: 10017541
    Master Contract Number: ESFA-541 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLB]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Bursary Funding £35,665 £1,594 £7,794 £2,985 £1,510 £98 £2,221 £3,803 £1,170 £1,117 £7,115 £5,024 £1,234
    Total Funding £35,665 £1,594 £7,794 £2,985 £1,510 £98 £2,221 £3,803 £1,170 £1,117 £7,115 £5,024 £1,234
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  EDSK-541 v4
    """


	# Includes a 'Schedule 2:Payment' doc for 16-18 Traineeships
    And   the pdf file contains the following page lines in order
    """
	SCHEDULE 2: PAYMENT
	16-18-YEAR-OLD TRAINEESHIPS
	1. The Provider will submit ILR Learner data and the Earning Adjustment
	"""

	# Includes Schedule 2 Funding Agreement for 16-18 Traineeships
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017541 Co Ltd UKPRN: 10017541
    Master Contract Number: ESFA-541 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    16 to 18 Traineeships Programme Funding £35,035 £6,893 £863 £3,051 £216 £2,881 £726 £1,352 £5,312 £3,496 £3,104 £2,169 £4,972
    16 to 18 Traineeships Bursary Funding £53,600 £4,515 £7,997 £3,391 £7,148 £99 £7,456 £1,288 £1,777 £4,038 £7,318 £7,540 £1,033
    Total Funding £88,635 £11,408 £8,860 £6,442 £7,364 £2,980 £8,182 £2,640 £7,089 £7,534 £10,422 £9,709 £6,005
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  EDSK-541 v4
    """

    # No Schedules 3-9
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    # Save a copy of the output
   #And   Sharepoint file '10017541_[ContractNo]_v4.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017541_[ContractNo]_v4.pdf'
    And   Sharepoint file '10017541_EDSK-541_v4.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017541_EDSK-541_v4.pdf'
	



    # Change the date
    Given the override date is '10/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-541' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '4' actual MasterContractNumber 'ESFA-541' and actual ContractNumber 'EDSK-541'


    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-541' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017541 | EDSK-541           | 4                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017541 | EDSK-541           | 3                     | 3                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017541 | EDSK-541           | 3                     | 2                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017541 | EDSK-541           | 3                     | 1                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017541 | EDSK-541           | 3                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017541 | EDSK-541           | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017541 | EDSK-541           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017541 | ESFA-541           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |


	# Tidy up
	And   the override date is reset

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run45
Scenario: A542 Create and approve a 1920 EDSK contract with several allocations. Perform both of the Non-Financial amendments. Check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017542' 
    And   there are no terminated or closed allocations for UKPRN '10017542' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017542' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16TR-542      |
    | AECA-542      |
    | AECT-542      |
    | ALLB-542      |
    | ALLF-542      |
    | APPS-542      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017542' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017542 Co Ltd' with UKPRN '10017542' and OrgId 'ORG0017542' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017542' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017542 | 117542 | 10017542 Co Ltd | 0              | Provider Under Change | Yes           | AA017542      | ?             | 130 St St Alban Road   | ?                      | ?                      | ?                      | Watford                | Hertfordshire          | WD2 4AE   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017542 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName       | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                        | Period | CRMIntent    | OrgId      |
    | 10017542 | 10017542 Co Ltd | ESFA-542             | EDSK-542       | 1                     | 01/08/2019        | 31/07/2020      | 180753.00     |                                    | Conditions of Funding (Grant) (HEI) | 1920   | New          | ORG0017542 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017542 | EDSK-542       | 16TR-542      | 16-18TRN          | 16-18TRN1920            | AY                      | 01/08/2019          | 31/07/2020        | 47285.00        |                                         |            |                                                             | New          |             |
    | 10017542 | EDSK-542       | AECA-542      | AEBC-ASCL         | AEBC-ASCL1920           | AY                      | 01/08/2019          | 31/07/2020        | 41436.00        |                                         |            |                                                             | New          |             |
    | 10017542 | EDSK-542       | AECT-542      | AEBC-19TRN        | AEBC-19TRN1920          | AY                      | 01/08/2019          | 31/07/2020        | 24121.00        |                                         |            |                                                             | New          |             |
    | 10017542 | EDSK-542       | ALLB-542      | ALLB              | ALLB1920                | AY                      | 01/08/2019          | 31/07/2020        | 23322.00        |                                         |            |                                                             | New          |             |
    | 10017542 | EDSK-542       | ALLF-542      | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 31/07/2020        | 22822.00        |                                         |            |                                                             | New          |             |
    | 10017542 | EDSK-542       | APPS-542      | APPS              | APPS1920                | AY                      | 01/08/2019          | 31/07/2020        | 21767.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017542 | EDSK-542       | 16TR-542      | 1               | 0                     | 47285.00  | 5320.00  | 2519.00  | 1555.00  | 1729.00  | 3928.00  | 4733.00  | 5034.00  | 5113.00  | 1175.00  | 5587.00  | 3453.00  | 7139.00  | 16-18 Traineeships Funding                                      | New          |             |
    | 10017542 | EDSK-542       | 16TR-542      | 2               | 1                     | 23333.00  | 2808.00  | 2215.00  | 293.00   | 1376.00  | 847.00   | 3416.00  | 2127.00  | 2294.00  | 56.00    | 2087.00  | 2413.00  | 3401.00  | 16-18 Traineeships Programme Funding                            | New          |             |
    | 10017542 | EDSK-542       | 16TR-542      | 3               | 1                     | 23952.00  | 2512.00  | 304.00   | 1262.00  | 353.00   | 3081.00  | 1317.00  | 2907.00  | 2819.00  | 1119.00  | 3500.00  | 1040.00  | 3738.00  | 16-18 Traineeships Bursary Funding                              | New          |             |
    | 10017542 | EDSK-542       | AECA-542      | 1               | 0                     | 41436.00  | 4272.00  | 3624.00  | 6550.00  | 1474.00  | 3862.00  | 2137.00  | 3609.00  | 4859.00  | 1110.00  | 5422.00  | 4746.00  | 2201.00  | Adult Education Budget Total Funding                            | New          |             |
    | 10017542 | EDSK-542       | AECA-542      | 2               | 1                     | 22618.00  | 3557.00  | 1699.00  | 3572.00  | 671.00   | 237.00   | 1541.00  | 1328.00  | 2949.00  | 805.00   | 2554.00  | 1991.00  | 1714.00  | Adult Skills Total Funding                                      | New          |             |
    | 10017542 | EDSK-542       | AECA-542      | 5               | 1                     | 18818.00  | 715.00   | 1925.00  | 2978.00  | 803.00   | 3625.00  | 596.00   | 2281.00  | 1910.00  | 305.00   | 438.00   | 2755.00  | 487.00   | Community Learning                                              | New          |             |
    | 10017542 | EDSK-542       | AECT-542      | 1               | 0                     | 24121.00  | 2949.00  | 3527.00  | 2776.00  | 1328.00  | 1970.00  | 2009.00  | 1891.00  | 2247.00  | 196.00   | 680.00   | 1194.00  | 3354.00  | 19-24 Traineeships Total Funding                                | New          |             |
    | 10017542 | EDSK-542       | ALLB-542      | 1               | 0                     | 23322.00  | 1609.00  | 1555.00  | 2701.00  | 2963.00  | 3161.00  | 2568.00  | 645.00   | 1728.00  | 1199.00  | 67.00    | 2479.00  | 2647.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             |
    | 10017542 | EDSK-542       | ALLF-542      | 5               | 0                     | 22822.00  | 2945.00  | 1275.00  | 1601.00  | 2589.00  | 2343.00  | 1117.00  | 2076.00  | 183.00   | 193.00   | 2130.00  | 2738.00  | 3632.00  | Advanced Learner Loans Facility                                 | New          |             |
    | 10017542 | EDSK-542       | APPS-542      | 1               | 0                     | 21767.00  | 3025.00  | 723.00   | 2946.00  | 960.00   | 2235.00  | 377.00   | 2250.00  | 3050.00  | 2615.00  | 218.00   | 2724.00  | 644.00   | Apprenticeships Carry-In Total Funding                          | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '04/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-542' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '05/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-542' and actual ContractNumber 'EDSK-542'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-542' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017542 | EDSK-542           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017542 | ESFA-542           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '516' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '516' deliverable period rows in CRM linked to the latest version of contract 'EDSK-542'



    # Execute a non-financial VARIATION amendment

    # Change the date
    Given the override date is '22/07/2019'

    # Issue a non-financial VARIATION amendment on v1 to create v2
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-542' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-542' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017542 | EDSK-542           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017542 | EDSK-542           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017542 | ESFA-542           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |


    # The pdf produced should have a 'Summary of Funding' only 

    # Retrieve parameters 
   #And   I retrieve the latest EFA contract details from CRM for provider '10017542' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017542'
    And   I retrieve the latest contract details from CRM for provider '10017542' for FundingType 'EDSK' and period '1920'

    # Output should contain just a 'Summary of Funding' doc
    And   a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017542 Co Ltd UKPRN: 10017542
    Master Contract Number: ESFA-542
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility ALLF-542 £14,129 £8,693 £22,822
    Advanced Learner Loans Bursary ALLB-542 £16,930 £6,392 £23,322
    ESFA AEB - 19 to 24 Traineeships AECT-542 £18,697 £5,424 £24,121
    ESFA AEB - Adult Skills and Community Learning AECA-542 £30,387 £11,049 £41,436
	of which Community Learning £14,833 £3,985 £18,818
    Apprenticeships Carry-In APPS-542 £15,566 £6,201 £21,767
    16 to 18 Traineeships 16TR-542 £29,931 £17,354 £47,285
	Total Funding for this contract: £180,753
	Summary of Funding – Page 1
	"""

    # No 'Terms and Conditions' doc
    And   the pdf file does not contain the following text
    """
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    """

    # No 'Schedule 1' docs
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """

    # No 'Schedule 2: Payment' docs
    And   the pdf file does not contain the following text
    """
    Schedule 2: Payment
    """

    # No Schedule 2 Funding Agreements
    And   the pdf file does not contain the following text
    """
    Provider: 10017542 Co Ltd UKPRN: 10017542
    """
	
	# No 'Schedules 3-9' doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    # Save a copy of the output
   #Then  Sharepoint file '10017542_[ContractNo]_v3.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017542_[ContractNo]_v2.pdf'
    Then  Sharepoint file '10017542_EDSK-542_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017542_EDSK-542_v2.pdf'


    # Change the date
    Given the override date is '23/07/2019'
	
	# Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-542' is in a state of 'Published to Provider'

	# Inject an SFS approval message
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-542' and actual ContractNumber 'EDSK-542'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-542' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017542 | EDSK-542           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017542 | EDSK-542           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017542 | ESFA-542           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
	



    # Execute a non-financial NOTIFICATION amendment

    # Change the date
    Given the override date is '26/07/2019'

    # Issue a non-financial VARIATION amendment on v2 to create v3
	#When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'EDSK-542' for a non-financial VARIATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'EDSK-542' for a non-financial NOTIFICATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017542 | EDSK-542           | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | Notification  |
    | 10017542 | EDSK-542           | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017542 | EDSK-542           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017542 | ESFA-542           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |


    # The pdf produced should have a 'Summary of Funding' only 

    # Retrieve parameters 
   #And   I retrieve the latest EFA contract details from CRM for provider '10017542' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017542'
    And   I retrieve the latest contract details from CRM for provider '10017542' for FundingType 'EDSK' and period '1920'

    # Output should contain just a 'Summary of Funding' doc
    And   a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017542 Co Ltd UKPRN: 10017542
    Master Contract Number: ESFA-542
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility ALLF-542 £14,129 £8,693 £22,822
    Advanced Learner Loans Bursary ALLB-542 £16,930 £6,392 £23,322
    ESFA AEB - 19 to 24 Traineeships AECT-542 £18,697 £5,424 £24,121
    ESFA AEB - Adult Skills and Community Learning AECA-542 £30,387 £11,049 £41,436
	of which Community Learning £14,833 £3,985 £18,818
    Apprenticeships Carry-In APPS-542 £15,566 £6,201 £21,767
    16 to 18 Traineeships 16TR-542 £29,931 £17,354 £47,285
	Total Funding for this contract: £180,753
	Summary of Funding – Page 1
	"""

    # No 'Terms and Conditions' doc
    And   the pdf file does not contain the following text
    """
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    """

    # No 'Schedule 1' docs
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """

    # No 'Schedule 2: Payment' docs
    And   the pdf file does not contain the following text
    """
    Schedule 2: Payment
    """

    # No Schedule 2 Funding Agreements
    And   the pdf file does not contain the following text
    """
    Provider: 10017542 Co Ltd UKPRN: 10017542
    """
	
	# No 'Schedules 3-9' doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    # Save a copy of the output
   #Then  Sharepoint file '10017542_[ContractNo]_v3.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017542_[ContractNo]_v3.pdf'
    Then  Sharepoint file '10017542_EDSK-542_v3.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017542_EDSK-542_v3.pdf'


    # Tidy Up
    Then   the override date is reset
	
@AcceptanceTest @Withdrawn20230123
Scenario: A550 Create and approve a 3-allocation 1920 EDSK contract. Amend to add three more. Check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017550' 
    And   there are no terminated or closed allocations for UKPRN '10017550' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017550' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16TR-550      |
    | ALLB-550      |
    | ALLF-550      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017550' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017550 Co Ltd' with UKPRN '10017550' and OrgId 'ORG0017550' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017550' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status  | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017550 | 117550 | 10017550 Co Ltd | 0              | Active  | Yes           | AA017550      | ?             | 5 Westwood Court       | Brunel Road            | Totton                 | Southampton            | ?                      | ?                      | SO40 3WX  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017550 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                         | Period | CRMIntent    | OrgId      |
    | 10017550 | 10017550 Co Ltd      | ESFA-550             | EDSK-550       | 1                     | 01/08/2019        | 31/07/2020      | 94054.00      |                                    | Conditions of Funding (Grant) (HEI)  | 1920   | New          | ORG0017550 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017550 | EDSK-550       | 16TR-550      | 16-18TRN          | 16-18TRN1920            | AY                      | 01/08/2019          | 31/07/2020        | 37710.00        |                                         |            |                                                             | New          |             |
    | 10017550 | EDSK-550       | ALLB-550      | ALLB              | ALLB1920                | AY                      | 01/08/2019          | 31/07/2020        | 28685.00        |                                         |            |                                                             | New          |             |
    | 10017550 | EDSK-550       | ALLF-550      | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 31/07/2020        | 27659.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017550 | EDSK-550       | 16TR-550      | 1               | 0                     | 37710.00  | 3684.00  | 2591.00  | 4884.00  | 4425.00  | 5803.00  | 916.00   | 3491.00  | 3921.00  | 1880.00  | 600.00   | 1722.00  | 3793.00  | 16-18 Traineeships Funding                                      | New          |             |
    | 10017550 | EDSK-550       | 16TR-550      | 2               | 1                     | 19933.00  | 1489.00  | 579.00   | 3307.00  | 1543.00  | 3134.00  | 327.00   | 1345.00  | 3727.00  | 1266.00  | 263.00   | 555.00   | 2398.00  | 16-18 Traineeships Programme Funding                            | New          |             |
    | 10017550 | EDSK-550       | 16TR-550      | 3               | 1                     | 17777.00  | 2195.00  | 2012.00  | 1577.00  | 2882.00  | 2669.00  | 589.00   | 2146.00  | 194.00   | 614.00   | 337.00   | 1167.00  | 1395.00  | 16-18 Traineeships Bursary Funding                              | New          |             |
    | 10017550 | EDSK-550       | ALLB-550      | 1               | 0                     | 28685.00  | 723.00   | 2250.00  | 2353.00  | 3025.00  | 3727.00  | 3356.00  | 1751.00  | 2867.00  | 501.00   | 1933.00  | 3302.00  | 2897.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             |
    | 10017550 | EDSK-550       | ALLF-550      | 5               | 0                     | 27659.00  | 3745.00  | 2297.00  | 2939.00  | 2979.00  | 2860.00  | 3216.00  | 2149.00  | 1650.00  | 2164.00  | 622.00   | 1546.00  | 1492.00  | Advanced Learner Loans Facility                                 | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-550' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-550' and actual ContractNumber 'EDSK-550'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-550' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017550 | EDSK-550           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017550 | ESFA-550           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '132 deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '132' deliverable period rows in CRM linked to the latest version of contract 'EDSK-550'




    # Change the date
    Given the override date is '06/07/2019'

    # Bulk upload to amend v1 and create a draft v2. 
	# Add AECT, AECA and APPS. All six allocs are in the bulk file but ALLF, ALLB and 16TR are unchanged from original values
    And   there are no files prefixed '10017550' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 12062019085527 v3_A550_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 12062019085527 v3_A550_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 12062019085527 v3_A550_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 12062019085527 v3_A550_1.xlsx' exists in the Datafiles folder and UKPRN '10017550' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters for the Contracting Org
   #Given I retrieve the latest EFA contract details from CRM for provider '10017550' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017550'
    Given I retrieve the latest contract details from CRM for provider '10017550' for FundingType 'EDSK' and period '1920'

    # Check that just the expected document parts are present
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017550 Co Ltd UKPRN: 10017550
    Master Contract Number: ESFA-550
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility ALLF-550 £21,835 £5,824 £27,659
    Advanced Learner Loans Bursary ALLB-550 £20,052 £8,633 £28,685
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AECT] £20,464 £10,967 £31,431
    ESFA AEB - Adult Skills and Community Learning [AllocRef_AECA] £72,252 £30,636 £102,888
    of which Community Learning £44,426 £6,734 £51,160
    Apprenticeships Carry-In [AllocRef_APPS] £35,236 £17,792 £53,028
    16 to 18 Traineeships 16TR-550 £29,715 £7,995 £37,710
    Total Funding for this contract: £281,401
    Summary of Funding – Page 1
    """

    # No 'Terms and Conditions' doc
    And   the pdf file does not contain the following text
    """
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    """

    # No 'Schedule 1' doc for Loans
    And   the pdf file does not contain the following text
    """
	ADVANCED LEARNER LOANS SPECIFICATION
	"""

	# Includes 'Schedule 1' docs for AEB and APPS
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
	ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
	8. The Provider shall recruit eligible Learners onto this service from the
	Schedule 1 – ESFA-Funded Adult Education Budget – Page 3

	SCHEDULE 1: SPECIFICATION & MONITORING
    APPRENTICESHIPS CARRY-IN SPECIFICATION
	12.The Provider will not recruit new Learners to this Service.
    Schedule 1 – Apprenticeships Carry-In – Page 3
    """

    # No 'Schedule 1' doc for 18-18 Traineeships
    And   the pdf file does not contain the following text
    """
	16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
	"""
	
	# No 'Schedule 2: Payment' doc for Loans
	And   the pdf file does not contain the following text
	"""
	ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
	"""

	# No Schedule 2 Funding Agreements for Loans
	And   the pdf file does not contain the following text
	"""
	SCHEDULE 2 – ADVANCED LEARNER LOANS
	"""
	
	# Includes a 'Schedule 2: Payment' doc for AEB
	And   the pdf file contains the following page lines in order
	"""
	SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
	1. The Department will pay the Provider the Funding set out in the Funding
    Schedule 2 – ESFA-Funded Adult Education Budget – Page 1
	"""

	# Includes a Schedule 2 Funding Agreement for 19-24 Traineeships and Adult Skills & Community Learning
	And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: 10017550 Co Ltd UKPRN: 10017550
    Master Contract Number: ESFA-550 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AECT]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - 19 to 24 Traineeships £31,431 £4,634 £165 £5,125 £932 £1,834 £1,239 £3,023 £3,512 £5,773 £1,102 £1,324 £2,768
    Total Funding £31,431 £4,634 £165 £5,125 £932 £1,834 £1,239 £3,023 £3,512 £5,773 £1,102 £1,324 £2,768
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECT] – Page 1 Ref (for internal use only):  EDSK-550 v2

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning
    Provider: 10017550 Co Ltd UKPRN: 10017550
    Master Contract Number: ESFA-550 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AECA]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills and Community Learning £102,888 £12,715 £4,733 £6,941 £8,267 £12,238 £6,164 £11,090 £10,104 £3,002 £8,405 £10,209 £9,020
    of which Community Learning £51,160 £7,684 £498 £6,156 £5,084 £6,188 £4,987 £6,973 £6,856 £1,368 £1,930 £2,355 £1,081
    Total Funding £102,888 £12,715 £4,733 £6,941 £8,267 £12,238 £6,164 £11,090 £10,104 £3,002 £8,405 £10,209 £9,020
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECA] – Page 1 Ref (for internal use only):  EDSK-550 v2
    """

    # Includes a 'Schedule 2: Payment' doc for APPS Carry-In
	And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2: PAYMENT
    APPRENTICESHIPS CARRY-IN
	1. The Provider will submit ILR Learner data monthly, and, where appropriate,
    Schedule 2 – Apprenticeships Carry-In – Page 1
    """

	# Includes a Schedule 2 Funding Agreement for APPS Carry-In
	And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – APPRENTICESHIPS CARRY-IN
    Funding Agreement – Apprenticeships Carry-In
    Provider: 10017550 Co Ltd UKPRN: 10017550
    Master Contract Number: ESFA-550 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Apprenticeships Carry-In £53,028 £6,648 £1,022 £7,837 £5,407 £2,636 £2,996 £6,139 £2,551 £3,251 £5,374 £6,956 £2,211
    Total Funding £53,028 £6,648 £1,022 £7,837 £5,407 £2,636 £2,996 £6,139 £2,551 £3,251 £5,374 £6,956 £2,211
    Schedule 2 – Apprenticeships Carry-In – Funding Agreement [AllocRef_APPS] – Page 1 Ref (for internal use only):  EDSK-550 v2
    """

	# No 'Schedule 2: Payment' doc for 16-18 Traineeships
	And   the pdf file does not contain the following text
	"""
	16-18-YEAR-OLD TRAINEESHIPS
	"""

	# No Schedule 2 Funding Agreements for 16-18 Traineeships
	And   the pdf file does not contain the following text
	"""
	Funding Agreement – 16 to 18 Traineeships
	"""
	
	# No 'Schedules 3-9' doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    # Save a copy of the output
   #And   Sharepoint file '10017550_[ContractNo]_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017550_[ContractNo]_v2.pdf'
    And   Sharepoint file '10017550_EDSK-550_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017550_EDSK-550_v2.pdf'


	# Tidy up
	And   the override date is reset

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run45
Scenario: A560 Create and approve a 6-allocation 1920 EDSK contract. Amend allocation dates. Check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017560' 
    And   there are no terminated or closed allocations for UKPRN '10017560' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017560' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16TR-560      |
    | AECA-560      |
    | AECT-560      |
    | ALLC-560      |
    | ALLF-560      |
    | APPS-560      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017560' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017560 Co Ltd' with UKPRN '10017560' and OrgId 'ORG0017560' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017560' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017560 | 117560 | 10017560 Co Ltd | 0              | Locked Restructure    | Yes           | AA017560      | ?             | 39a Victoria Road      | Surbiton               | Surrey                 | ?                      | ?                      | ?                      | KT6 4JL   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017560 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                             | Period | CRMIntent    | OrgId      |
    | 10017560 | 10017560 Co Ltd      | ESFA-560             | EDSK-560       | 1                     | 01/08/2019        | 31/07/2020      | 177832.00     |                                    | Conditions of Funding (Grant) (Employer) | 1920   | New          | ORG0017560 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017560 | EDSK-560       | 16TR-560      | 16-18TRN          | 16-18TRN1920            | AY                      | 01/08/2019          | 31/07/2020        | 46974.00        |                                         |            |                                                             | New          |             |
    | 10017560 | EDSK-560       | AECA-560      | AEBC-ASCL         | AEBC-ASCL1920           | AY                      | 01/08/2019          | 31/07/2020        | 43678.00        |                                         |            |                                                             | New          |             |
    | 10017560 | EDSK-560       | AECT-560      | AEBC-19TRN        | AEBC-19TRN1920          | AY                      | 01/08/2019          | 31/07/2020        | 25413.00        |                                         |            |                                                             | New          |             |
    | 10017560 | EDSK-560       | ALLC-560      | ALLBC             | ALLBC1920               | AY                      | 01/08/2019          | 31/07/2020        | 26118.00        |                                         |            |                                                             | New          |             |
    | 10017560 | EDSK-560       | ALLF-560      | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 31/07/2020        | 15968.00        |                                         |            |                                                             | New          |             |
    | 10017560 | EDSK-560       | APPS-560      | APPS              | APPS1920                | AY                      | 01/08/2019          | 31/07/2020        | 19681.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017560 | EDSK-560       | 16TR-560      | 1               | 0                     | 46974.00  | 1245.00  | 1546.00  | 5327.00  | 6073.00  | 6784.00  | 3667.00  | 3651.00  | 4679.00  | 5297.00  | 3444.00  | 3335.00  | 1926.00  | 16-18 Traineeships Funding                                      | New          |             |
    | 10017560 | EDSK-560       | 16TR-560      | 2               | 1                     | 20326.00  | 168.00   | 1220.00  | 2747.00  | 2851.00  | 3523.00  | 524.00   | 153.00   | 2248.00  | 3365.00  | 998.00   | 2431.00  | 98.00    | 16-18 Traineeships Programme Funding                            | New          |             |
    | 10017560 | EDSK-560       | 16TR-560      | 3               | 1                     | 26648.00  | 1077.00  | 326.00   | 2580.00  | 3222.00  | 3261.00  | 3143.00  | 3498.00  | 2431.00  | 1932.00  | 2446.00  | 904.00   | 1828.00  | 16-18 Traineeships Bursary Funding                              | New          |             |
    | 10017560 | EDSK-560       | AECA-560      | 1               | 0                     | 43678.00  | 3488.00  | 1260.00  | 2510.00  | 3443.00  | 4343.00  | 3379.00  | 7254.00  | 5752.00  | 2856.00  | 3158.00  | 3236.00  | 2999.00  | Adult Education Budget Total Funding                            | New          |             |
    | 10017560 | EDSK-560       | AECA-560      | 2               | 1                     | 21919.00  | 3388.00  | 834.00   | 1096.00  | 1293.00  | 700.00   | 2479.00  | 3562.00  | 3033.00  | 1901.00  | 612.00   | 779.00   | 2242.00  | Adult Skills Total Funding                                      | New          |             |
    | 10017560 | EDSK-560       | AECA-560      | 5               | 1                     | 21759.00  | 100.00   | 426.00   | 1414.00  | 2150.00  | 3643.00  | 900.00   | 3692.00  | 2719.00  | 955.00   | 2546.00  | 2457.00  | 757.00   | Community Learning                                              | New          |             |
    | 10017560 | EDSK-560       | AECT-560      | 1               | 0                     | 25413.00  | 1052.00  | 2292.00  | 1289.00  | 1581.00  | 3424.00  | 1596.00  | 2396.00  | 1961.00  | 3266.00  | 3053.00  | 973.00   | 2530.00  | 19-24 Traineeships Total Funding                                | New          |             |
    | 10017560 | EDSK-560       | ALLC-560      | 1               | 0                     | 26118.00  | 2192.00  | 1629.00  | 1352.00  | 2182.00  | 3393.00  | 744.00   | 2271.00  | 1392.00  | 2064.00  | 3749.00  | 3378.00  | 1772.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             |
    | 10017560 | EDSK-560       | ALLF-560      | 5               | 0                     | 15968.00  | 1444.00  | 61.00    | 1494.00  | 1879.00  | 2457.00  | 1706.00  | 259.00   | 901.00   | 940.00   | 822.00   | 1177.00  | 2828.00  | Advanced Learner Loans Facility                                 | New          |             |
    | 10017560 | EDSK-560       | APPS-560      | 1               | 0                     | 19681.00  | 840.00   | 1354.00  | 3513.00  | 736.00   | 682.00   | 1828.00  | 2090.00  | 2288.00  | 1695.00  | 3474.00  | 855.00   | 326.00   | Apprenticeships Carry-In Total Funding                          | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-560' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-560' and actual ContractNumber 'EDSK-560'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-560' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017560 | EDSK-560           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017560 | ESFA-560           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '516' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '516' deliverable period rows in CRM linked to the latest version of contract 'EDSK-560'




    # Change the date
    Given the override date is '17/07/2019'

    # Bulk upload to amend v1 and create v2. 
	# All six allocations have their allocation dates amended in the bulk file. Nothing else changes
    And   there are no files prefixed '10017560' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 12062019105507 v3_A560_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 12062019105507 v3_A560_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 12062019105507 v3_A560_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 12062019105507 v3_A560_1.xlsx' exists in the Datafiles folder and UKPRN '10017560' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters for the Contracting Org
   #Given I retrieve the latest EFA contract details from CRM for provider '10017560' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017560'
    Given I retrieve the latest contract details from CRM for provider '10017560' for FundingType 'EDSK' and period '1920'

    # Check that just the expected document parts are present
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017560 Co Ltd UKPRN: 10017560
    Master Contract Number: ESFA-560
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility ALLF-560 £10,201 £5,767 £15,968
    Advanced Learner Loans Bursary ALLC-560 £15,155 £10,963 £26,118
    ESFA AEB - 19 to 24 Traineeships AECT-560 £15,591 £9,822 £25,413
    ESFA AEB - Adult Skills and Community Learning AECA-560 £31,429 £12,249 £43,678
    of which Community Learning £15,044 £6,715 £21,759
    Apprenticeships Carry-In APPS-560 £13,331 £6,350 £19,681
    16 to 18 Traineeships 16TR-560 £32,972 £14,002 £46,974
    Total Funding for this contract: £177,832
    Summary of Funding – Page 1
    """

    # No 'Terms and Conditions' doc
    And   the pdf file does not contain the following text
    """
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    """

    # No 'Schedule 1' docs
    And   the pdf file does not contain the following text
    """
	SCHEDULE 1: SPECIFICATION & MONITORING
	"""
	
	# No 'Schedule 2: Payment' docs
	And   the pdf file does not contain the following text
	"""
	SCHEDULE 2: PAYMENT
	"""

	# Includes Schedule 2 Funding Agreements for Loans(2), AEB(2), APPS and 16-18 Traineeships
	And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017560 Co Ltd UKPRN: 10017560
    Master Contract Number: ESFA-560 Start Date: 23/08/2019 End Date: 22/07/2020
    Contract Ref: ALLF-560
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £15,968 £1,444 £61 £1,494 £1,879 £2,457 £1,706 £259 £901 £940 £822 £1,177 £2,828
    Total Funding £15,968 £1,444 £61 £1,494 £1,879 £2,457 £1,706 £259 £901 £940 £822 £1,177 £2,828
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLF-560 – Page 1 Ref (for internal use only):  EDSK-560 v2

    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017560 Co Ltd UKPRN: 10017560
    Master Contract Number: ESFA-560 Start Date: 01/08/2019 End Date: 11/07/2020
    Contract Ref: ALLC-560
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Bursary Funding £26,118 £2,192 £1,629 £1,352 £2,182 £3,393 £744 £2,271 £1,392 £2,064 £3,749 £3,378 £1,772
    Total Funding £26,118 £2,192 £1,629 £1,352 £2,182 £3,393 £744 £2,271 £1,392 £2,064 £3,749 £3,378 £1,772
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLC-560 – Page 1 Ref (for internal use only):  EDSK-560 v2

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: 10017560 Co Ltd UKPRN: 10017560
    Master Contract Number: ESFA-560 Start Date: 01/08/2019 End Date: 28/07/2020
    Contract Ref: AECT-560
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - 19 to 24 Traineeships £25,413 £1,052 £2,292 £1,289 £1,581 £3,424 £1,596 £2,396 £1,961 £3,266 £3,053 £973 £2,530
    Total Funding £25,413 £1,052 £2,292 £1,289 £1,581 £3,424 £1,596 £2,396 £1,961 £3,266 £3,053 £973 £2,530
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement AECT-560 – Page 1 Ref (for internal use only):  EDSK-560 v2

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning
    Provider: 10017560 Co Ltd UKPRN: 10017560
    Master Contract Number: ESFA-560 Start Date: 14/08/2019 End Date: 31/07/2020
    Contract Ref: AECA-560
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills and Community Learning £43,678 £3,488 £1,260 £2,510 £3,443 £4,343 £3,379 £7,254 £5,752 £2,856 £3,158 £3,236 £2,999
    of which Community Learning £21,759 £100 £426 £1,414 £2,150 £3,643 £900 £3,692 £2,719 £955 £2,546 £2,457 £757
    Total Funding £43,678 £3,488 £1,260 £2,510 £3,443 £4,343 £3,379 £7,254 £5,752 £2,856 £3,158 £3,236 £2,999
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement AECA-560 – Page 1 Ref (for internal use only):  EDSK-560 v2

    SCHEDULE 2 – APPRENTICESHIPS CARRY-IN
    Funding Agreement – Apprenticeships Carry-In
    Provider: 10017560 Co Ltd UKPRN: 10017560
    Master Contract Number: ESFA-560 Start Date: 17/08/2019 End Date: 26/07/2020
    Contract Ref: APPS-560
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Apprenticeships Carry-In £19,681 £840 £1,354 £3,513 £736 £682 £1,828 £2,090 £2,288 £1,695 £3,474 £855 £326
    Total Funding £19,681 £840 £1,354 £3,513 £736 £682 £1,828 £2,090 £2,288 £1,695 £3,474 £855 £326
    Schedule 2 – Apprenticeships Carry-In – Funding Agreement APPS-560 – Page 1 Ref (for internal use only):  EDSK-560 v2

    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017560 Co Ltd UKPRN: 10017560
    Master Contract Number: ESFA-560 Start Date: 07/08/2019 End Date: 31/07/2020
    Contract Ref: 16TR-560
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    16 to 18 Traineeships Programme Funding £20,326 £168 £1,220 £2,747 £2,851 £3,523 £524 £153 £2,248 £3,365 £998 £2,431 £98
    16 to 18 Traineeships Bursary Funding £26,648 £1,077 £326 £2,580 £3,222 £3,261 £3,143 £3,498 £2,431 £1,932 £2,446 £904 £1,828
    Total Funding £46,974 £1,245 £1,546 £5,327 £6,073 £6,784 £3,667 £3,651 £4,679 £5,297 £3,444 £3,335 £1,926
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement 16TR-560 – Page 1 Ref (for internal use only):  EDSK-560 v2
    """
	
	# No 'Schedules 3-9' doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    # Save a copy of the output
   #And   Sharepoint file '10017560_[ContractNo]_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017560_[ContractNo]_v2.pdf'
    And   Sharepoint file '10017560_EDSK-560_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017560_EDSK-560_v2.pdf'

	# Tidy up
	And   the override date is reset

	 