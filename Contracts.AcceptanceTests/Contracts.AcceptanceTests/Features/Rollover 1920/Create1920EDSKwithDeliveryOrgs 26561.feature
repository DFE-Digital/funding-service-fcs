Feature: Create1920EDSKwithDeliveryOrgs 26561

@AcceptanceTest @Complete
@HighValue
@Long2Run @Long2Run123
Scenario: A304 Bulk load a new 1920 EDSK contract with six FSPs and several Delivery Orgs. Check docs. Publish and approve
    Given there are no allocations marked as Under Termination for UKPRN '10017304' 
    And   there are no terminated or closed allocations for UKPRN '10017304' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017304' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017304' 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Trumpton County Council' with UKPRN '10017304' and OrgId 'ORG0017304' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017304' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                                                                                          | SequenceNumber | Status  | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017304 | 117304 | Trumpton County Council                                                                       | 0              | Active  | Yes           | AA017304      | ?             | 9 Westwood Green       | Brunel Road            | Totton                 | Southampton            | ?                      | ?                      | SO40 3WX  |
    | 10005863 | 115863 | KING EDWARD VI CHURCH OF ENGLAND VOLUNTARY CONTROLLED UPPER SCHOOL and Sixth Form College     | 0              | Active  | Yes           | AA005863      | ?             | 60 Wolf Lane           | ?                      | ?                      | ?                      | Windsor                | Berkshire              | SL4 4YZ   |
    | 10001895 | 111895 | SIR JOHN CASS FOUNDATION AND REDCOATCHURCH OF ENGLAND SECONDARY SCHOOL and Sixth Form College | 0              | Active  | Yes           | AA001895      | ?             | 96 West Yard           | Camden Lock Place      | Chalk Farm Road        | London                 | ?                      | ?                      | NW1 8AF   |
    | 10003634 | 113634 | THE DEANERY CHURCH OF ENGLAND HIGH SCHOOL AND SIXTH FORM COLLEGE                              | 0              | Active  | Yes           | AA003634      | ?             | 15 Princeton Mews      | 167-169 London Road    | Kingston upon Thames   | ?                      | ?                      | Surrey                 | KT2 6PT   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017304 |
	| 10005863 |
	| 10001895 |
	| 10003634 |



    # Change the date
    Given the override date is '16/07/2019'

    # Bulk upload a new six-allocation EDSK contract with several Delivery Orgs. Contract Type = 'Conditions of Funding (Grant) (LA)'
    And   there are no files prefixed '10017304' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 14062019110258 v3_A304' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 14062019110258 v3_A304' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 14062019110258 v3_A304' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 14062019110258 v3_A304.xlsx' exists in the Datafiles folder and UKPRN '10017304' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

   
    # Retrieve parameters for the Contracting Org
   #Given I retrieve the latest contract details from CRM for provider '10017304' for FundingType 'EDSK' and period '1920'  
    Given I retrieve the latest EFA contract details from CRM for provider '10017304' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017304'
   
    # Check Summary of Funding
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: Trumpton County Council UKPRN: 10017304
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    Trumpton County Council [AllocRef_ALLF] £18,134 £16,946 £35,080
    Advanced Learner Loans Bursary
    Trumpton County Council [AllocRef_ALLC] £30,974 £18,581 £49,555
    ESFA AEB - 19 to 24 Traineeships
    Trumpton County Council [AllocRef_AECT] £36,413 £13,350 £49,763
    Apprenticeships Carry-In
    Trumpton County Council [AllocRef_APPS] £29,976 £19,137 £49,113
    16 to 18 Traineeships
    Trumpton County Council [AllocRef_16TR] £81,348 £35,820 £117,168
    Summary of Funding – Page 1
    Total Funding for this contract: £1,048,541
    Summary of Funding – Page 2
    """

    # Retrieve parameters for 10005863 (KING EDWARD VI ...)
   #Given I retrieve the latest contract details from CRM for provider '10017304' for FundingType 'EDSK' and period '1920'  
    Given I retrieve the latest EFA contract details from CRM for provider '10017304' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10005863'
   
    # Check Summary of Funding
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: Trumpton County Council UKPRN: 10017304
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    KING EDWARD VI CHURCH OF ENGLAND [AllocRef_ALLF] £28,127 £7,949 £36,076
    VOLUNTARY CONTROLLED UPPER SCHOOL and
    Sixth Form College
    Advanced Learner Loans Bursary
    KING EDWARD VI CHURCH OF ENGLAND [AllocRef_ALLC] £45,557 £15,608 £61,165
    VOLUNTARY CONTROLLED UPPER SCHOOL and
    Sixth Form College
    ESFA AEB - 19 to 24 Traineeships
    KING EDWARD VI CHURCH OF ENGLAND [AllocRef_AECT] £34,912 £15,317 £50,229
    VOLUNTARY CONTROLLED UPPER SCHOOL and
    Sixth Form College
    ESFA AEB - Adult Skills and Community Learning
    KING EDWARD VI CHURCH OF ENGLAND [AllocRef_AECA] £25,823 £9,718 £35,541
    VOLUNTARY CONTROLLED UPPER SCHOOL and
    Sixth Form College
    of which Community Learning £0 £0 £0
    Apprenticeships Carry-In
    KING EDWARD VI CHURCH OF ENGLAND [AllocRef_APPS] £28,365 £13,099 £41,464
    VOLUNTARY CONTROLLED UPPER SCHOOL and
    Sixth Form College
    16 to 18 Traineeships
    KING EDWARD VI CHURCH OF ENGLAND [AllocRef_16TR] £56,339 £28,922 £85,261
    VOLUNTARY CONTROLLED UPPER SCHOOL and
    Sixth Form College
    Summary of Funding – Page 1
    Total Funding for this contract: £1,048,541
    Summary of Funding – Page 2
    """

    # Retrieve parameters for 10001895 (SIR JOHN CASS ...)
   #Given I retrieve the latest contract details from CRM for provider '10017304' for FundingType 'EDSK' and period '1920'  
    Given I retrieve the latest EFA contract details from CRM for provider '10017304' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10001895'
   
    # Check Summary of Funding
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: Trumpton County Council UKPRN: 10017304
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    ESFA AEB - 19 to 24 Traineeships
    SIR JOHN CASS FOUNDATION AND [AllocRef_AECT] £31,437 £16,296 £47,733
    REDCOATCHURCH OF ENGLAND SECONDARY
    SCHOOL and Sixth Form College
    ESFA AEB - Adult Skills and Community Learning
    SIR JOHN CASS FOUNDATION AND [AllocRef_AECA] £24,797 £18,008 £42,805
    REDCOATCHURCH OF ENGLAND SECONDARY
    SCHOOL and Sixth Form College
    of which Community Learning £24,797 £18,008 £42,805
    16 to 18 Traineeships
    Summary of Funding – Page 1
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    SIR JOHN CASS FOUNDATION AND [AllocRef_16TR] £77,678 £19,062 £96,740
    REDCOATCHURCH OF ENGLAND SECONDARY
    SCHOOL and Sixth Form College
    Total Funding for this contract: £1,048,541
    Summary of Funding – Page 2
    """
	   	 
    # Retrieve parameters for 10003634 (THE DEANERY ...)
   #Given I retrieve the latest contract details from CRM for provider '10017304' for FundingType 'EDSK' and period '1920'  
    Given I retrieve the latest EFA contract details from CRM for provider '10017304' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10003634'
   
    # Check Summary of Funding
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: Trumpton County Council UKPRN: 10017304
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    THE DEANERY CHURCH OF ENGLAND HIGH SCHOOL [AllocRef_ALLF] £30,336 £20,329 £50,665
    AND SIXTH FORM COLLEGE
    Advanced Learner Loans Bursary
    THE DEANERY CHURCH OF ENGLAND HIGH SCHOOL [AllocRef_ALLC] £25,589 £12,117 £37,706
    AND SIXTH FORM COLLEGE
    ESFA AEB - 19 to 24 Traineeships
    THE DEANERY CHURCH OF ENGLAND HIGH SCHOOL [AllocRef_AECA] £63,227 £37,151 £100,378
    AND SIXTH FORM COLLEGE
    of which Community Learning £31,310 £12,865 £44,175
    Apprenticeships Carry-In
    THE DEANERY CHURCH OF ENGLAND HIGH SCHOOL [AllocRef_APPS] £43,633 £18,466 £62,099
    AND SIXTH FORM COLLEGE
    Summary of Funding – Page 1
    Total Funding for this contract: £1,048,541
    Summary of Funding – Page 2
    """

    # Save a copy of the output
   #Then  Sharepoint file '10017304_EDSK-304_v1.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017304_EDSK-304_v1.pdf'
    Then  Sharepoint file '10017304_[ContractNo]_v1.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017304_EDSK-304_v1.pdf'



    # Change the date
    Given the override date is '22/07/2019'

    # Check the deliverable count in CRM prior to approval
    Then  there are '360' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
	Given the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-304' and actual ContractNumber 'EDSK-304'
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
   #Then  the latest version of contract 'EDSK-304' is in status 'Approved'
	Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017304 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017304 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '1548' deliverable period rows in CRM linked to the latest version of contract 'EDSK-304'
    And   there are '1548' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'


	# Tidy up
	And the override date is reset 
	
@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run123
Scenario: A305 Create and approve a 1920 EDSK contract with two ALLF1920 allocations each with a delivery org not equal to the contracting org. Amend to add allocations (inc 16ED) then update draft amendment. Check docs and CRM 
    Given there are no allocations marked as Under Termination for UKPRN '10017305' 
    And   there are no terminated or closed allocations for UKPRN '10017305' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017305' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-3051     |
	| ALLF-3052     |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017305' 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'ACME ACADEMY TRUST' with UKPRN '10017305' and OrgId 'ORG0017305' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017305' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                        | SequenceNumber | Status   | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017305 | 117305 | ACME ACADEMY TRUST          | 0              | Active   | Yes           | AA017305      | ?             | 29 Waterside           | 44 - 48 Wharf Road     | Islington              | London                 | ?                      | ?                      | N1 7SH    |
    | 10031404 | 131404 | GREENDALE COMMUNITY ACADEMY | 0              | Active   | Yes           | AA031404      | 31404         | 9 Challoner Court      | Merchants Landing      | ?                      | ?                      | Bristol                | Avon                   | BS1 4RG   |
    | 10031026 | 131026 | TESTING ACADEMY             | 0              | Active   | Yes           | AA031026      | ?             | 4 High Street          | Delph                  | ?                      | ?                      | Saddleworth            | Greater Manchester     | OL4 7DJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017305 |
    | 10031404 |
    | 10031026 |



    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName               | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017305 | ACME ACADEMY TRUST      | ESFA-305             | EDSK-305       | 1                     | 01/08/2019        | 31/07/2020      | 65040.00      |                       | Conditions of Funding (Grant) (HEI)        | 1920   | New          | ORG0017305 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName      | UoPCode    | AllocationDescription       | CRMIntent    | DeliveryOrg |
    | 10017305 | EDSK-305       | ALLF-3051     | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 31/07/2020        | 30716.00        |              |            |                             | New          | 10031404    |
    | 10017305 | EDSK-305       | ALLF-3052     | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 31/07/2020        | 34324.00        |              |            |                             | New          | 10031026    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription            | CRMIntent    | DeliveryOrg |
    | 10017305 | EDSK-305       | ALLF-3051     | 5               | 0                     | 30716.00  | 1845.00  | 93.00    | 3236.00  | 1760.00  | 348.00   | 2471.00  | 4053.00  | 1420.00  | 1367.00  | 7365.00  | 5274.00  | 1484.00  | Advanced Learner Loans Facility   | New          | 10031404    |
    | 10017305 | EDSK-305       | ALLF-3052     | 5               | 0                     | 34324.00  | 2127.00  | 357.00   | 3480.00  | 2322.00  | 623.00   | 2811.00  | 4277.00  | 1787.00  | 1668.00  | 7631.00  | 5569.00  | 1672.00  | Advanced Learner Loans Facility   | New          | 10031026    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-305' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '05/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-305' and actual ContractNumber 'EDSK-305'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-305' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017305 | EDSK-305           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017305 | ESFA-305           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'EDSK-305'




    # Change the date
    Given the override date is '07/07/2019'

    # Bulk amend the contract adding 1xAEBC-19TRN1920, 2xAEBC-ASCL1920, 2xALLBC1920 and 2x16ED - all with delivery orgs
    And   there are no files prefixed '10017305' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 17062019140653 v3_A305_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 17062019140653 v3_A305_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 17062019140653 v3_A305_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 17062019140653 v3_A305_1.xlsx' exists in the Datafiles folder and UKPRN '10017305' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

   
    # Retrieve parameters for Greendale Community Academy (10031404)
   #Given I retrieve the latest contract details from CRM for provider '10017305' for FundingType 'EDSK' and period '1920'  
    Given I retrieve the latest EFA contract details from CRM for provider '10017305' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10031404'

    # Check the document parts
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: ACME ACADEMY TRUST UKPRN: 10017305
    Master Contract Number: ESFA-305
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    GREENDALE COMMUNITY ACADEMY ALLF-3051 £15,226 £15,490 £30,716
    Advanced Learner Loans Bursary
    GREENDALE COMMUNITY ACADEMY [AllocRef_ALLC] £37,145 £9,740 £46,885
    ESFA AEB - 19 to 24 Traineeships
    GREENDALE COMMUNITY ACADEMY [AllocRef_AECT] £31,613 £18,901 £50,514
    ESFA AEB - Adult Skills and Community Learning
    GREENDALE COMMUNITY ACADEMY [AllocRef_AECA] £67,278 £37,469 £104,747
    of which Community Learning £29,646 £28,541 £58,187
	16 to 19 Education
	GREENDALE COMMUNITY ACADEMY [AllocRef_16ED] £24,721 £20,313 £45,034
    Total Funding for this contract: £507,265
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

    # Includes a Schedule 1 for AEB
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
	ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
	Schedule 1 – ESFA-Funded Adult Education Budget – Page 1
	8. The Contractor shall recruit eligible Learners onto this service from the
	"""

    # No 'Schedule 1' docs for APPS
    And   the pdf file does not contain the following text
    """
    APPRENTICESHIPS CARRY-IN SPECIFICATION
    """

    # No 'Schedule 1' docs for 16-18 Traineeships
    And   the pdf file does not contain the following text
    """
    16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
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
    Provider: GREENDALE COMMUNITY ACADEMY UKPRN: 10031404
    Master Contract Number: ESFA-305 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLC]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Bursary Funding £46,885 £5,893 £7,814 £2,051 £7,167 £1,881 £7,676 £352 £4,311 £2,496 £2,103 £1,169 £3,972
    Total Funding £46,885 £5,893 £7,814 £2,051 £7,167 £1,881 £7,676 £352 £4,311 £2,496 £2,103 £1,169 £3,972
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLC] – Page 1 Ref (for internal use only):  EDSK-305 v2
    """

    # Includes a 'Schedule 2:Payment' doc for AEB
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
	1. The Department will pay the Contractor the Funding set out in the Funding
	Schedule 2 – ESFA-Funded Adult Education Budget – Page 1
    """

	# Includes a Schedule 2 Funding Agreement for AEB and Adult Skills
	And   the pdf file contains the following page lines in order
	"""
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: GREENDALE COMMUNITY ACADEMY UKPRN: 10031404
    Master Contract Number: ESFA-305 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AECT]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - 19 to 24 Traineeships £50,514 £283 £3,765 £7,109 £2,915 £3,817 £3,223 £5,006 £5,495 £7,756 £3,085 £3,308 £4,752
    Total Funding £50,514 £283 £3,765 £7,109 £2,915 £3,817 £3,223 £5,006 £5,495 £7,756 £3,085 £3,308 £4,752
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECT] – Page 1 Ref (for internal use only):  EDSK-305 v2

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning
    Provider: GREENDALE COMMUNITY ACADEMY UKPRN: 10031404
    Master Contract Number: ESFA-305 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AECA]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills and Community Learning £104,747 £9,204 £6,564 £8,772 £10,099 £6,119 £5,885 £10,811 £9,824 £10,674 £8,125 £9,929 £8,741
    of which Community Learning £58,187 £1,953 £110 £5,768 £4,696 £5,800 £2,488 £4,474 £4,357 £6,820 £7,382 £7,806 £6,533
    Total Funding £104,747 £9,204 £6,564 £8,772 £10,099 £6,119 £5,885 £10,811 £9,824 £10,674 £8,125 £9,929 £8,741
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECA] – Page 1 Ref (for internal use only):  EDSK-305 v2
	"""

	# Includes a 'Schedule 2: Payment' doc for 16ED
	And   the pdf file contains the following page lines in order
	"""
	SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
	Schedule 2 – 16 to 19 Education – Page 1
	"""

	# Includes a Schedule 2 Funding Agreement for 16ED
	And   the pdf file contains the following page lines in order
	"""
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: GREENDALE COMMUNITY ACADEMY UKPRN: 10031404
    Master Contract Number: ESFA-305 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    16-19 Programme Funding £12,713 -£4,935.71 £0.00 £0.00 £5,020.67 £0.00 £911.75 £7,482.74 £0.00 £1,002.87 £3,230.56 £0.00 £0.00
    16-19 Free Meals £916 -£7,181.48 £0.00 £0.00 £0.00 £1,883.01 £0.00 £0.00 £0.00 £0.00 £6,214.11 £0.00 £0.00
	16-19 Growth £12,875 £524.52 £843.87 £0.00 £0.00 £3,582.36 £0.00 £0.00 £5,227.81 £1,204.26 £0.00 £0.00 £1,491.89
    Area Review Transition Grant £11,131 £83.12 £0.00 £0.00 £370.75 £6,060.33 £4,616.88 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Alternative Completions - Creative Sector £7,401 £230.46 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £909.20 £6,260.91 £0.00 £0.00
    Total Funding £45,034 -£11,279.09 £843.87 £0.00 £5,391.42 £11,525.70 £5,528.63 £7,482.74 £5,227.81 £3,116.33 £15,705.58 £0.00 £1,491.89
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-305 v2
    """


    # No Schedules 3-9
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """




    # Retrieve parameters for Testing Academy (10031026)
   #Given I retrieve the latest contract details from CRM for provider '10017305' for FundingType 'EDSK' and period '1920'  
    Given I retrieve the latest EFA contract details from CRM for provider '10017305' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10031026'

    # Includes a Summary of Funding
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: ACME ACADEMY TRUST UKPRN: 10017305
    Master Contract Number: ESFA-305
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    TESTING ACADEMY ALLF-3052 £17,784 £16,540 £34,324
    Advanced Learner Loans Bursary
    TESTING ACADEMY [AllocRef_ALLC] £39,813 £11,922 £51,735
    ESFA AEB - Adult Skills and Community Learning
    TESTING ACADEMY [AllocRef_AECA] £67,278 £37,469 £104,747
    of which Community Learning £29,646 £28,541 £58,187
	16 to 19 Education
	TESTING ACADEMY [AllocRef_16ED] £8,862 £29,700 £38,562
    Total Funding for this contract: £507,265
    Summary of Funding – Page 1
    """

    # Includes Schedule 2 Funding Agreement for Loans Bursary, AEB and 16ED
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: TESTING ACADEMY UKPRN: 10031026
    Master Contract Number: ESFA-305 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLC]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Bursary Funding £51,735 £5,978 £8,441 £2,384 £7,763 £2,336 £7,841 £435 £4,635 £3,269 £2,577 £2,011 £4,065
    Total Funding £51,735 £5,978 £8,441 £2,384 £7,763 £2,336 £7,841 £435 £4,635 £3,269 £2,577 £2,011 £4,065
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLC] – Page 1 Ref (for internal use only):  EDSK-305 v2

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning
    Provider: TESTING ACADEMY UKPRN: 10031026
    Master Contract Number: ESFA-305 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AECA]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills and Community Learning £104,747 £9,204 £6,564 £8,772 £10,099 £6,119 £5,885 £10,811 £9,824 £10,674 £8,125 £9,929 £8,741
    of which Community Learning £58,187 £1,953 £110 £5,768 £4,696 £5,800 £2,488 £4,474 £4,357 £6,820 £7,382 £7,806 £6,533
    Total Funding £104,747 £9,204 £6,564 £8,772 £10,099 £6,119 £5,885 £10,811 £9,824 £10,674 £8,125 £9,929 £8,741
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECA] – Page 1 Ref (for internal use only):  EDSK-305 v2

    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: TESTING ACADEMY UKPRN: 10031026
    Master Contract Number: ESFA-305 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    16-19 Programme Funding £5,509 -£7,194.09 £0.00 £0.00 £5,782.36 £0.00 £4,116.72 £0.00 £0.00 £124.23 £0.00 £1,653.65 £1,026.15
    SSF Free Meals £7,370 -£6,486.86 £0.00 £0.00 £998.66 £234.22 £0.00 £0.00 £6,773.48 £0.00 £5,107.85 £743.02 £0.00
    Residential Support Scheme £11,153 -£5,320.91 £0.00 £0.00 £0.00 £0.00 £1,838.49 £0.00 £6,764.36 £6,202.31 £0.00 £0.00 £1,668.55
    19+ Continuing Learners in SFC (Student Support) £9,235 -£7,496.35 £5,437.60 £0.00 £315.21 £0.00 £0.00 £3,595.24 £0.00 £846.54 £6,536.39 £0.00 £0.00
    Isles of Scilly £4,219 -£5,730.10 £0.00 £0.00 £0.00 £4,509.10 £687.54 £1,006.89 £0.00 £0.00 £3,745.38 £0.00 £0.00
    Teachers Pay Grant (NMSS) £1,077 -£5,390.23 £1,367.28 £0.00 £0.00 £1,654.91 £0.00 £0.00 £1,399.00 £0.00 £2,046.03 £0.00 £0.00
    Total Funding £38,562 -£37,618.54 £6,804.88 £0.00 £7,096.23 £6,398.23 £6,642.75 £4,602.13 £14,936.84 £7,173.08 £17,435.65 £2,396.67 £2,694.70
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-305 v2
    """

    # Save a copy of the output
   #Then  Sharepoint file '10017305_[ContractNo]_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017305_EDSK-305_v2.pdf'
    Then  Sharepoint file '10017305_EDSK-305_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017305_EDSK-305_v2a.pdf'




    # Change the date
    Given the override date is '07/07/2019'

    # Bulk amend the contract adding 1xAEBC-19TRN1920, 2xAEBC-ASCL1920 and 2xALLBC1920 - all with delivery orgs
    And   there are no files prefixed '10017305' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 17062019140714 v3_A305_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 17062019140714 v3_A305_2' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 17062019140714 v3_A305_2' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 17062019140714 v3_A305_2.xlsx' exists in the Datafiles folder and UKPRN '10017305' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

   
    # Retrieve parameters for Greendale Community Academy (10031404)
   #Given I retrieve the latest contract details from CRM for provider '10017305' for FundingType 'EDSK' and period '1920'  
    Given I retrieve the latest EFA contract details from CRM for provider '10017305' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10031404'

    # Check that just the expected document parts are present
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: ACME ACADEMY TRUST UKPRN: 10017305
    Master Contract Number: ESFA-305
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    GREENDALE COMMUNITY ACADEMY ALLF-3051 £15,226 £15,490 £30,716
    Advanced Learner Loans Bursary
    GREENDALE COMMUNITY ACADEMY [AllocRef_ALLC] £37,145 £9,740 £46,885
    ESFA AEB - 19 to 24 Traineeships
    GREENDALE COMMUNITY ACADEMY [AllocRef_AECT] £31,613 £18,901 £50,514
    ESFA AEB - Adult Skills and Community Learning
    GREENDALE COMMUNITY ACADEMY [AllocRef_AECA] £67,278 £37,469 £104,747
    of which Community Learning £29,646 £28,541 £58,187
	16 to 19 Education
	GREENDALE COMMUNITY ACADEMY [AllocRef_16ED] £24,721 £20,313 £45,034
    Total Funding for this contract: £507,515
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

    # Includes a Schedule 1 for AEB
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
	8. The Contractor shall recruit eligible Learners onto this service from the
    Schedule 1 – ESFA-Funded Adult Education Budget – Page 3
    """

    # No 'Schedule 1' docs for Apps Carry-In
    And   the pdf file does not contain the following text
    """
    APPRENTICESHIPS CARRY-IN SPECIFICATION
    """

    # No 'Schedule 1' docs for 16-18 Traineeships
    And   the pdf file does not contain the following text
    """
    16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
    """

    # No 'Schedule 2: Payment' doc for Loans
    And   the pdf file does not contain the following text
    """
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    """

    # Include Schedule 2 Funding Agreement for Loans Bursary
	And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: GREENDALE COMMUNITY ACADEMY UKPRN: 10031404
    Master Contract Number: ESFA-305 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLC]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Bursary Funding £46,885 £5,893 £7,814 £2,051 £7,167 £1,881 £7,676 £352 £4,311 £2,496 £2,103 £1,169 £3,972
    Total Funding £46,885 £5,893 £7,814 £2,051 £7,167 £1,881 £7,676 £352 £4,311 £2,496 £2,103 £1,169 £3,972
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLC] – Page 1 Ref (for internal use only):  EDSK-305 v2
    """

	# Include Schedule 2: Payment doc for AEB
	And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
	1. The Department will pay the Contractor the Funding set out in the Funding
    Schedule 2 – ESFA-Funded Adult Education Budget – Page 1
    """

	# Include Schedule 2 Funding Agreement for 19-24 Traineeships, Adult Skills and 16ED
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: GREENDALE COMMUNITY ACADEMY UKPRN: 10031404
    Master Contract Number: ESFA-305 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AECT]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - 19 to 24 Traineeships £50,514 £283 £3,765 £7,109 £2,915 £3,817 £3,223 £5,006 £5,495 £7,756 £3,085 £3,308 £4,752
    Total Funding £50,514 £283 £3,765 £7,109 £2,915 £3,817 £3,223 £5,006 £5,495 £7,756 £3,085 £3,308 £4,752
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECT] – Page 1 Ref (for internal use only):  EDSK-305 v2

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning
    Provider: GREENDALE COMMUNITY ACADEMY UKPRN: 10031404
    Master Contract Number: ESFA-305 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AECA]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills and Community Learning £104,747 £9,204 £6,564 £8,772 £10,099 £6,119 £5,885 £10,811 £9,824 £10,674 £8,125 £9,929 £8,741
    of which Community Learning £58,187 £1,953 £110 £5,768 £4,696 £5,800 £2,488 £4,474 £4,357 £6,820 £7,382 £7,806 £6,533
    Total Funding £104,747 £9,204 £6,564 £8,772 £10,099 £6,119 £5,885 £10,811 £9,824 £10,674 £8,125 £9,929 £8,741
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECA] – Page 1 Ref (for internal use only):  EDSK-305 v2

    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: GREENDALE COMMUNITY ACADEMY UKPRN: 10031404
    Master Contract Number: ESFA-305 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    16-19 Programme Funding £12,713 -£4,935.71 £0.00 £0.00 £5,020.67 £0.00 £911.75 £7,482.74 £0.00 £1,002.87 £3,230.56 £0.00 £0.00
    16-19 Free Meals £916 -£7,181.48 £0.00 £0.00 £0.00 £1,883.01 £0.00 £0.00 £0.00 £0.00 £6,214.11 £0.00 £0.00
	16-19 Growth £12,875 £524.52 £843.87 £0.00 £0.00 £3,582.36 £0.00 £0.00 £5,227.81 £1,204.26 £0.00 £0.00 £1,491.89
    Area Review Transition Grant £11,131 £83.12 £0.00 £0.00 £370.75 £6,060.33 £4,616.88 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    Alternative Completions - Creative Sector £7,401 £230.46 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £909.20 £6,260.91 £0.00 £0.00
	Total Funding £45,034 -£11,279.09 £843.87 £0.00 £5,391.42 £11,525.70 £5,528.63 £7,482.74 £5,227.81 £3,116.33 £15,705.58 £0.00 £1,491.89
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-305 v2
    """
	   	 
    # Retrieve parameters for Testing Academy (10031026)
   #Given I retrieve the latest contract details from CRM for provider '10017305' for FundingType 'EDSK' and period '1920'  
    Given I retrieve the latest EFA contract details from CRM for provider '10017305' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10031026'

    # Check that just the expected document parts are present
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: ACME ACADEMY TRUST UKPRN: 10017305
    Master Contract Number: ESFA-305
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    TESTING ACADEMY ALLF-3052 £18,505 £16,069 £34,574
    Advanced Learner Loans Bursary
    TESTING ACADEMY [AllocRef_ALLC] £39,813 £11,922 £51,735
    ESFA AEB - Adult Skills and Community Learning
    TESTING ACADEMY [AllocRef_AECA] £67,278 £37,469 £104,747
    of which Community Learning £29,646 £28,541 £58,187
	16 to 19 Education
	TESTING ACADEMY [AllocRef_16ED] £8,862 £29,700 £38,562
    Total Funding for this contract: £507,515
    Summary of Funding – Page 1
    """

    # Include Schedule 2 Funding Agreements for Loans Facility, Loans Bursary and 16ED
	And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: TESTING ACADEMY UKPRN: 10031026
    Master Contract Number: ESFA-305 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: ALLF-3052
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £34,574 £4,056 £1,022 £3,121 £2,006 £576 £1,823 £3,767 £2,134 £2,287 £5,769 £6,002 £2,011
    Total Funding £34,574 £4,056 £1,022 £3,121 £2,006 £576 £1,823 £3,767 £2,134 £2,287 £5,769 £6,002 £2,011
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLF-3052 – Page 1 Ref (for internal use only):  EDSK-305 v2

    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: TESTING ACADEMY UKPRN: 10031026
    Master Contract Number: ESFA-305 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLC]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Bursary Funding £51,735 £5,978 £8,441 £2,384 £7,763 £2,336 £7,841 £435 £4,635 £3,269 £2,577 £2,011 £4,065
    Total Funding £51,735 £5,978 £8,441 £2,384 £7,763 £2,336 £7,841 £435 £4,635 £3,269 £2,577 £2,011 £4,065
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLC] – Page 1 Ref (for internal use only):  EDSK-305 v2

    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: TESTING ACADEMY UKPRN: 10031026
    Master Contract Number: ESFA-305 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    16-19 Programme Funding £5,509 -£7,194.09 £0.00 £0.00 £5,782.36 £0.00 £4,116.72 £0.00 £0.00 £124.23 £0.00 £1,653.65 £1,026.15
    SSF Free Meals £7,370 -£6,486.86 £0.00 £0.00 £998.66 £234.22 £0.00 £0.00 £6,773.48 £0.00 £5,107.85 £743.02 £0.00
    Residential Support Scheme £11,153 -£5,320.91 £0.00 £0.00 £0.00 £0.00 £1,838.49 £0.00 £6,764.36 £6,202.31 £0.00 £0.00 £1,668.55
    19+ Continuing Learners in SFC (Student Support) £9,235 -£7,496.35 £5,437.60 £0.00 £315.21 £0.00 £0.00 £3,595.24 £0.00 £846.54 £6,536.39 £0.00 £0.00
    Isles of Scilly £4,219 -£5,730.10 £0.00 £0.00 £0.00 £4,509.10 £687.54 £1,006.89 £0.00 £0.00 £3,745.38 £0.00 £0.00
    Teachers Pay Grant (NMSS) £1,077 -£5,390.23 £1,367.28 £0.00 £0.00 £1,654.91 £0.00 £0.00 £1,399.00 £0.00 £2,046.03 £0.00 £0.00
    Total Funding £38,562 -£37,618.54 £6,804.88 £0.00 £7,096.23 £6,398.23 £6,642.75 £4,602.13 £14,936.84 £7,173.08 £17,435.65 £2,396.67 £2,694.70
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-305 v2
    """

    # Save a copy of the output
   #Then  Sharepoint file '10017305_[ContractNo]_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017305_EDSK-305_v2.pdf'
    Then  Sharepoint file '10017305_EDSK-305_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017305_EDSK-305_v2b.pdf'

	# Tidy up
	And the override date is reset 

@AcceptanceTest @Withdrawn20231002
Scenario: A306 Create and approve a 1920 EDSK contract with an ASCL allocation and a delivery org. Amend contract to add a second ASCL for a different delivery org. Check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017306' 
    And   there are no terminated or closed allocations for UKPRN '10017306' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017306' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017306' 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Wintergardens plc' with UKPRN '10017306' and OrgId 'ORG0017306' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017306' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name               | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017306 | 117306 | Wintergardens plc  | 0              | Active                | Yes           | AA017306      | ?             | 72 Brackenwoods        | Necton                 | ?                      | ?                      | Swaffham               | Norfolk                | PE37 8EX  |
    | 10022066 | 122066 | Samuels & Partners | 0              | Locked Restructure    | Yes           | AA022066      | ?             | 4 Barnhaven Close      | Wyke Road              | ?                      | ?                      | Weymouth               | Dorset                 | DT4 9QJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017306 |
    | 10022066 |



    # Change the date
    Given the override date is '01/12/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017306 | Wintergardens plc    | ESFA-306             | EDSK-306       | 1                     | 01/01/2020        | 31/07/2020      | 28215.00      |                                    | Contract for Services (ITP)                | 1920   | New          | ORG0017306 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017306 | EDSK-306       | AECA-306      | AEBC-ASCL         | AEBC-ASCL1920           | AY                      | 01/01/2020          | 31/07/2020        | 28215.00        |                                         |            |                                                             | New          | 10017306    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                    | CRMIntent    | DeliveryOrg |
    | 10017306 | EDSK-306       | AECA-306      | 1               | 0                     | 28215.00  | 2066.00  | 4646.00  | 6276.00  | 2367.00  | 4725.00  | 1355.00  | 6780.00  | Adult Education Budget Total Funding      | New          | 10017306    |
    | 10017306 | EDSK-306       | AECA-306      | 2               | 1                     | 15557.00  | 1430.00  | 2419.00  | 3155.00  | 1929.00  | 1905.00  | 996.00   | 3723.00  | Adult Skills Total Funding                | New          | 10017306    |
    | 10017306 | EDSK-306       | AECA-306      | 5               | 1                     | 12658.00  | 636.00   | 2227.00  | 3121.00  | 438.00   | 2820.00  | 359.00   | 3057.00  | Community Learning                        | New          | 10017306    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/12/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-306' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/12/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-306' and actual ContractNumber 'EDSK-306'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-306' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017306 | EDSK-306           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2020        | 31/07/2020      | ?             |
    | 10017306 | ESFA-306           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2020        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '35' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '35' deliverable period rows in CRM linked to the latest version of contract 'EDSK-306'




    # Change the date
    Given the override date is '16/02/2020'

    # Bulk upload a contract amendment to add a second delivery org for a short period ASCL allocation
	#  Original allocation also in bulk file but is unchanged from above
    And   there are no files prefixed '10017306' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 18062019131215 v3_A306' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 18062019131215 v3_A306' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 18062019131215 v3_A306' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 18062019131215 v3_A306.xlsx' exists in the Datafiles folder and UKPRN '10017306' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report



    # Retrieve parameters for Delivery Org 10022066
   #Given I retrieve the latest contract details from CRM for provider '10017306' for FundingType 'EDSK' and period '1920'  
    Given I retrieve the latest EFA contract details from CRM for provider '10017306' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10022066'

    # Check that just the expected document parts are present
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: Wintergardens plc UKPRN: 10017306
    Master Contract Number: ESFA-306
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    ESFA AEB - Adult Skills and Community Learning
    Wintergardens plc AECA-306 £12,988 £15,227 £28,215
    of which Community Learning £5,984 £6,674 £12,658
    Samuels & Partners [AllocRef_AECA] £6,126 £20,926 £27,052
    of which Community Learning £3,002 £10,423 £13,425
    Total Funding for this contract: £55,267
    Summary of Funding – Page 1
    """

    # No 'Terms and Conditions' doc
    And   the pdf file does not contain the following text
    """
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    """

    # No 'Schedule 1' docs for AEB
    And   the pdf file does not contain the following text
    """
	ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
	"""

	# No 'Schedule 2: Payment' doc for AEB
	And   the pdf file does not contain the following text
	"""
	ESFA ADULT EDUCATION BUDGET (GRANT)
	"""

	# No Schedule 2 Funding Agreement for 10017306 (Wintergardens plc)
	And   the pdf file does not contain the following text
	"""
	Provider: Wintergardens plc UKPRN: 10017306
	"""

	# Includes a Schedule 2 Funding Agreement for 10022066 (Samuels and Partners)
	And   the pdf file contains the following page lines in order
	"""
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning
    Provider: Samuels & Partners UKPRN: 10022066
    Master Contract Number: ESFA-306 Start Date: 01/03/2020 End Date: 31/07/2020
    Contract Ref: [AllocRef_AECA]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills and Community Learning £27,052 £6,126 £6,753 £6,182 £4,736 £3,255
    of which Community Learning £13,425 £3,002 £4,675 £2,005 £2,858 £885
    Total Funding £27,052 £6,126 £6,753 £6,182 £4,736 £3,255
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECA] – Page 1 Ref (for internal use only):  EDSK-306 v2
    """

    # No Schedules 3-9
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
Scenario: A307 Create and approve an EDSK contract for ALLF1920 without Delivery org. Amend to add 5 allocations and delivery orgs. Check docs and CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017307' 
    And   there are no terminated or closed allocations for UKPRN '10017307' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017307' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-307      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017307' 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'NORTH WALMINGTON-ON-SEA BOROUGH COUNCIL' with UKPRN '10017307' and OrgId 'ORG0017307' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017307' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                                                      | SequenceNumber | Status   | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017307 | 117307 | NORTH WALMINGTON-ON-SEA BOROUGH COUNCIL                   | 0              | Active   | Yes           | AA017307      | ?             | 45 Hagley Road         | ?                      | ?                      | ?                      | Stourbridge            | West Midlands          | DY8 1QR   |
    | 10038108 | 138108 | GRANGE HILL SIXTH FORM                                    | 0              | Active   | Yes           | ?             | 38108         | 58 Murray Place        | Stirling               | ?                      | ?                      | ?                      | ?                      | FK8 2BP   |
    | 10038567 | 138567 | RYDELL HIGH SCHOOL SPECIALIST MATHS AND COMPUTING COLLEGE | 0              | Active   | Yes           | AA038567      | ?             | 1 Christies Warehouse  | Wherry Quay            | ?                      | ?                      | Ipswich                | Suffolk                | IP4 1AS   |
    | 10039002 | 139002 | TESTING SIXTH FORM                                        | 0              | Active   | Yes           | AA039002      | 39002         | 10 Witcham Close       | Lower Early            | ?                      | ?                      | Reading                | Berkshire              | RG6 4H6   |


    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017307 |
	| 10038108 |
	| 10038567 |
	| 10039002 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName                               | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017307 | NORTH WALMINGTON-ON-SEA BOROUGH COUNCIL | ESFA-307             | EDSK-307       | 1                     | 01/08/2019        | 31/07/2020      | 41710.00      |                                    | Conditions of Funding (Grant) (College)    | 1920   | New          | ORG0017307 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName       | UoPCode    | AllocationDescription     | CRMIntent    | DeliveryOrg |
    | 10017307 | EDSK-307       | ALLF-307      | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 31/07/2020        | 41710.00        |               |            |                           | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription              | CRMIntent    | DeliveryOrg |
    | 10017307 | EDSK-307       | ALLF-307      | 5               | 0                     | 41710.00  | 7464.00  | 5712.00  | 4006.00  | 2530.00  | 1119.00  | 3242.00  | 4823.00  | 2191.00  | 2138.00  | 185.00   | 6045.00  | 2255.00  | Advanced Learner Loans Facility     | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-307' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '04/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-307' and actual ContractNumber 'EDSK-307'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-307' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017307 | EDSK-307           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017307 | ESFA-307           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'EDSK-307'




    # Change the date
    Given the override date is '06/07/2019'

    # Bulk amend the contract adding 5 allocations with delivery orgs on everything
    And   there are no files prefixed '10017307' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 17062019092414 v3_A307_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 17062019092414 v3_A307_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 17062019092414 v3_A307_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 17062019092414 v3_A307_1.xlsx' exists in the Datafiles folder and UKPRN '10017307' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

   
    # Retrieve parameters for Contracting\Delivery Org 10017307
   #Given I retrieve the latest contract details from CRM for provider '10017307' for FundingType 'EDSK' and period '1920'  
    Given I retrieve the latest EFA contract details from CRM for provider '10017307' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017307'

    # Check that just the expected document parts are present
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: NORTH WALMINGTON-ON-SEA BOROUGH COUNCIL UKPRN: 10017307
    Master Contract Number: ESFA-307
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £31,087 £10,623 £41,710
    Advanced Learner Loans Bursary [AllocRef_ALLB] £28,399 £21,269 £49,668
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AECT] £28,839 £13,537 £42,376
    ESFA AEB - Adult Skills and Community Learning [AllocRef_AECA] £71,955 £23,591 £95,546
    of which Community Learning £33,159 £14,082 £47,241
    Apprenticeships Carry-In [AllocRef_APPS] £33,102 £13,806 £46,908
    16 to 18 Traineeships
    NORTH WALMINGTON-ON-SEA BOROUGH COUNCIL [AllocRef_16TR] £70,783 £39,082 £109,865
    Total Funding for this contract: £715,053
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

    # Includes Schedule 1s for AEB, APPS Carry-In and 16-18 Traineeships
	And   the pdf file contains the following page lines in order
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
	8. The College shall recruit eligible Learners onto this service from the
	Schedule 1 – ESFA-Funded Adult Education Budget – Page 3

    SCHEDULE 1: SPECIFICATION & MONITORING
    APPRENTICESHIPS CARRY-IN SPECIFICATION
	12.The College will not recruit new Learners to this Service.
	Schedule 1 – Apprenticeships Carry-In – Page 3

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
	8. The College shall recruit eligible Learners onto this service from the
	Schedule 1 – 16 to 18 Traineeships – Page 2
    """

    # No 'Schedule 2: Payment' doc for Loans
    And   the pdf file does not contain the following text
    """
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    """

    # No Schedule 2 Funding Agreement for Loans Facility - because the numbers haven't changed
    And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """
	
	# Includes Schedule 2 Funding Agreement for Loans Bursary
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: NORTH WALMINGTON-ON-SEA BOROUGH COUNCIL UKPRN: 10017307
    Master Contract Number: ESFA-307 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLB]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Bursary Funding £49,668 £824 £2,745 £4,933 £2,098 £4,763 £2,608 £3,234 £7,194 £5,378 £4,986 £4,051 £6,854
    Total Funding £49,668 £824 £2,745 £4,933 £2,098 £4,763 £2,608 £3,234 £7,194 £5,378 £4,986 £4,051 £6,854
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  EDSK-307 v2
    """


    # Includes 'Schedule2: Payment' doc for AEB 
    And   the pdf file contains the following page lines in order
    """
	SCHEDULE 2: PAYMENT
	ESFA ADULT EDUCATION BUDGET (GRANT)
	1. The Department will pay the College the Funding set out in the Funding
	Schedule 2 – ESFA-Funded Adult Education Budget – Page 1
	"""

	# Includes Funding Agreements for both AEB allocs
	And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: NORTH WALMINGTON-ON-SEA BOROUGH COUNCIL UKPRN: 10017307
    Master Contract Number: ESFA-307 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AECT]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - 19 to 24 Traineeships £42,376 £6,893 £2,424 £5,768 £1,575 £2,477 £1,882 £3,666 £4,154 £6,415 £1,744 £1,967 £3,411
    Total Funding £42,376 £6,893 £2,424 £5,768 £1,575 £2,477 £1,882 £3,666 £4,154 £6,415 £1,744 £1,967 £3,411
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECT] – Page 1 Ref (for internal use only):  EDSK-307 v2

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning
    Provider: NORTH WALMINGTON-ON-SEA BOROUGH COUNCIL UKPRN: 10017307
    Master Contract Number: ESFA-307 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AECA]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills and Community Learning £95,546 £9,495 £9,463 £3,720 £12,997 £1,066 £8,783 £13,709 £12,722 £5,620 £5,184 £6,988 £5,799
    of which Community Learning £47,241 £2,099 £2,863 £570 £7,449 £602 £5,241 £7,226 £7,109 £1,621 £4,295 £4,720 £3,446
    Total Funding £95,546 £9,495 £9,463 £3,720 £12,997 £1,066 £8,783 £13,709 £12,722 £5,620 £5,184 £6,988 £5,799
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECA] – Page 1 Ref (for internal use only):  EDSK-307 v2
    """

    # Includes 'Schedule 2: Payment' doc and Schedule 2 Funding Agreement for APPS Carry-In 
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2: PAYMENT
    APPRENTICESHIPS CARRY-IN
	1. The College will submit ILR Learner data monthly, and, where appropriate,
    Schedule 2 – Apprenticeships Carry-In – Page 1

    SCHEDULE 2 – APPRENTICESHIPS CARRY-IN
    Funding Agreement – Apprenticeships Carry-In
    Provider: NORTH WALMINGTON-ON-SEA BOROUGH COUNCIL UKPRN: 10017307
    Master Contract Number: ESFA-307 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Apprenticeships Carry-In £46,908 £3,540 £7,977 £6,840 £4,410 £1,639 £2,000 £5,142 £1,554 £2,254 £4,378 £5,959 £1,215
    Total Funding £46,908 £3,540 £7,977 £6,840 £4,410 £1,639 £2,000 £5,142 £1,554 £2,254 £4,378 £5,959 £1,215
    Schedule 2 – Apprenticeships Carry-In – Funding Agreement [AllocRef_APPS] – Page 1 Ref (for internal use only):  EDSK-307 v2
    """

	# Includes 'Schedule 2: Payment' doc and Schedule 2 Funding Agreement for 16-18 Traineeships for NORTH WALMINGTON-ON-SEA BOROUGH COUNCIL
	And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS
	1. The College will submit ILR Learner data and the Earning Adjustment
    Schedule 2 – 16 to 18 Traineeships – Page 1

    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: NORTH WALMINGTON-ON-SEA BOROUGH COUNCIL UKPRN: 10017307
    Master Contract Number: ESFA-307 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    16 to 18 Traineeships Programme Funding £52,057 £4,105 £2,043 £8,246 £4,499 £7,486 £7,492 £3,729 £945 £3,661 £1,579 £2,012 £6,260
    16 to 18 Traineeships Bursary Funding £57,808 £2,019 £4,146 £2,711 £5,458 £5,330 £647 £3,940 £7,987 £6,520 £6,323 £8,160 £4,567
    Total Funding £109,865 £6,124 £6,189 £10,957 £9,957 £12,816 £8,139 £7,669 £8,932 £10,181 £7,902 £10,172 £10,827
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  EDSK-307 v2
    """

    # No Schedules 3-9
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """




    # Retrieve parameters for Delivery Org 10038108 (GRANGE HILL SIXTH FORM)
   #Given I retrieve the latest contract details from CRM for provider '10017307' for FundingType 'EDSK' and period '1920'  
    Given I retrieve the latest EFA contract details from CRM for provider '10017307' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10038108'

    # Check that just the expected document parts are present
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    GRANGE HILL SIXTH FORM [AllocRef_16TR] £70,490 £39,100 £109,590
    """

    # Includes a Schedule 2 Funding Agreement for 16-18 Traineeships for GRANGE HILL SIXTH FORM
	And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: GRANGE HILL SIXTH FORM UKPRN: 10038108
    Master Contract Number: ESFA-307 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    16 to 18 Traineeships Programme Funding £51,719 £4,044 £2,216 £7,901 £3,978 £7,833 £7,295 £4,070 £1,051 £3,755 £1,338 £1,972 £6,266
    16 to 18 Traineeships Bursary Funding £57,871 £1,960 £3,684 £3,147 £5,494 £5,199 £818 £4,087 £7,713 £6,444 £6,413 £7,996 £4,916
    Total Funding £109,590 £6,004 £5,900 £11,048 £9,472 £13,032 £8,113 £8,157 £8,764 £10,199 £7,751 £9,968 £11,182
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  EDSK-307 v2
    """




    # Retrieve parameters for Delivery Org 10038567 (RYDELL HIGH SCHOOL ...)
   #Given I retrieve the latest contract details from CRM for provider '10017307' for FundingType 'EDSK' and period '1920'  
    Given I retrieve the latest EFA contract details from CRM for provider '10017307' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10038567'

    # Check that just the expected document parts are present
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    RYDELL HIGH SCHOOL SPECIALIST MATHS AND [AllocRef_16TR] £71,032 £38,974 £110,006
    COMPUTING COLLEGE
    """

    # Includes a Schedule 2 Funding Agreement for 16-18 Traineeships for RYDELL HIGH SCHOOL ...
	And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: RYDELL HIGH SCHOOL SPECIALIST MATHS AND COMPUTING COLLEGE UKPRN: 10038567
    Master Contract Number: ESFA-307 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_16TR]
	Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    16 to 18 Traineeships Programme Funding £52,168 £4,187 £2,137 £8,086 £4,529 £7,608 £7,228 £3,568 £1,256 £3,763 £1,715 £2,096 £5,995
    16 to 18 Traineeships Bursary Funding £57,838 £2,268 £3,669 £2,963 £5,570 £5,213 £903 £3,920 £7,927 £6,828 £5,971 £8,067 £4,539
    Total Funding £110,006 £6,455 £5,806 £11,049 £10,099 £12,821 £8,131 £7,488 £9,183 £10,591 £7,686 £10,163 £10,534
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  EDSK-307 v2
    """



    # Retrieve parameters for Delivery Org 10039002 (TESTING SIXTH FORM)
   #Given I retrieve the latest contract details from CRM for provider '10017307' for FundingType 'EDSK' and period '1920'  
    Given I retrieve the latest EFA contract details from CRM for provider '10017307' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10039002'

    # Check that just the expected document parts are present
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    TESTING SIXTH FORM [AllocRef_16TR] £70,181 £39,203 £109,384
    """

    # Includes a Schedule 2 Funding Agreement for 16-18 Traineeships for TESTING SIXTH FORM
	And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: TESTING SIXTH FORM UKPRN: 10039002
    Master Contract Number: ESFA-307 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    16 to 18 Traineeships Programme Funding £51,846 £4,094 £1,956 £7,943 £4,288 £7,486 £7,438 £3,701 £1,284 £3,888 £1,604 £1,854 £6,310
    16 to 18 Traineeships Bursary Funding £57,538 £1,965 £3,604 £3,183 £5,525 £5,058 £595 £4,025 £8,036 £6,941 £5,938 £7,806 £4,862
    Total Funding £109,384 £6,059 £5,560 £11,126 £9,813 £12,544 £8,033 £7,726 £9,320 £10,829 £7,542 £9,660 £11,172
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  EDSK-307 v2
    """


    # Save a copy of the output
   #Then  Sharepoint file '10017307_[ContractNo]_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017307_EDSK-307_v2.pdf'
    Then  Sharepoint file '10017307_EDSK-307_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017307_EDSK-307_v2.pdf'


	# Tidy up
	And the override date is reset 
	 