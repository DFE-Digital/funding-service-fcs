Feature: Create1619EDContracts 26559

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run67
Scenario: A642 Create and approve a 1920 EDSK contract with only a 1619ED allocation. Update draft to add and amend deliverables. Check CRM, docs and financials
    Given there are no allocations marked as Under Termination for UKPRN '10017642' 
    And   there are no terminated or closed allocations for UKPRN '10017642' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017642' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16ED-642      |

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017642' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017642 Co Ltd' with UKPRN '10017642' and OrgId 'ORG0017642' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017642' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017642 | 117642 | 10017642 Co Ltd | 0              | Locked Restructure    | Yes           | AA017642      | ?             | 4 Red Lion Court       | Alexandra Road         | ?                      | ?                      | Hounslow               | Middlesex              | TW3 1JS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017642 |


    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017642 | 10017642 Co Ltd      | ESFA-642             | EDSK-642       | 1                     | 01/08/2019        | 31/07/2020      | 42165.21      |                                    | Conditions of Funding (Grant) (NMSS)       | 1920   | New          | ORG0017642 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017642 | EDSK-642       | 16ED-642      | 1619ED            | 1619ED1920              | AY                      | 01/08/2019          | 31/07/2020        | 42165.21        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017642 | EDSK-642       | 16ED-642      | 2               | 0                     | 4560.90   | 0.00     | 0.00     | 1224.72  | 0.00     | 0.00     | 2628.33  | 0.00     | 0.00     | 707.85   | 0.00     | 0.00     | 0.00     | SSF Programme Funding                                           | New          |             |
    | 10017642 | EDSK-642       | 16ED-642      | 19              | 0                     | 3002.43   | 0.00     | 0.00     | 1032.84  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1969.59  | 16-19 Bursary Funds                                             | New          |             |
    | 10017642 | EDSK-642       | 16ED-642      | 22              | 0                     | 1172.44   | 0.00     | 0.00     | 0.00     | 1172.44  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 High Needs Element 2                                      | New          |             |
    | 10017642 | EDSK-642       | 16ED-642      | 35              | 0                     | 2703.63   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2703.63  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Core Cities Youth Contract                                      | New          |             |
    | 10017642 | EDSK-642       | 16ED-642      | 38              | 0                     | 3106.62   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 395.88   | 0.00     | 0.00     | 2269.38  | 0.00     | 441.36   | 0.00     | LA Other 2                                                      | New          |             |
    | 10017642 | EDSK-642       | 16ED-642      | 45              | 0                     | 2291.87   | -1000.00 | 0.00     | 2278.01  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1013.86  | 0.00     | 0.00     | 0.00     | TechBacc                                                        | New          |             |
    | 10017642 | EDSK-642       | 16ED-642      | 51              | 0                     | 3844.44   | 0.00     | 0.00     | 331.73   | 0.00     | 0.00     | 983.52   | 1826.30  | 0.00     | 0.00     | 93.76    | 0.00     | 609.13   | Alternative Completions - Sporting Excellence                   | New          |             |
    | 10017642 | EDSK-642       | 16ED-642      | 86              | 0                     | 2965.88   | 0.00     | 0.00     | 597.56   | 2098.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 270.15   | 0.00     | 0.00     | 19+ Continuing Learners in SFC (Student Support)                | New          |             |
    | 10017642 | EDSK-642       | 16ED-642      | 115             | 0                     | 4570.13   | 2241.35  | 0.00     | 0.00     | 0.00     | 0.00     | 1868.46  | 0.00     | 0.00     | 0.00     | 460.32   | 0.00     | 0.00     | SSF Capacity and Delivery Bursary Funds                         | New          |             |
    | 10017642 | EDSK-642       | 16ED-642      | 118             | 0                     | 4636.37   | -297.97  | 0.00     | 1606.09  | 0.00     | 0.00     | 249.47   | 0.00     | 0.00     | 0.00     | 2218.46  | 0.00     | 860.32   | Teachers Pay Grant (NMSS)                                       | New          |             |
    | 10017642 | EDSK-642       | 16ED-642      | 119             | 0                     | 4979.06   | 0.00     | 705.53   | 0.00     | 3376.32  | 143.18   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 754.03   | Maths Centre for Excellence 1619                                | New          |             |
    | 10017642 | EDSK-642       | 16ED-642      | 914             | 0                     | 4331.44   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2130.46  | 0.00     | 913.29   | 0.00     | 1287.69  | 16-19 Advanced Maths Premium                                    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'




    # Change the date
    Given the override date is '10/07/2019'

    # Bulk update draft to add deliverables 3, 933, 126-134, 135 and 144. Also update the £ on deliverable 2 
    And   there are no files prefixed '10017642' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 1920 20062019114641 v3_A642' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 20062019114641 v3_A642' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 1920 20062019114641 v3_A642' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 20062019114641 v3_A642_1.xlsx' exists in the Datafiles folder and UKPRN '10017642' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Change the date
    Given the override date is '13/07/2019'
    
    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017642' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017642'
    And   I retrieve the latest contract details from CRM for provider '10017642' for FundingType 'EDSK' and period '1920'  

    # Check that all 6 documents have been produced in the right order by looking for the first line in each of:
    #   'Summary of Funding', then 'Main Terms and Conditions' (TAC) then Schedule 1, then Schedule 2, then 'Funding Agreement', then 'Schedule 3'
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Agreement Type Non-Maintained Special Schools
    SCHEDULE 1: SPECIFICATION & MONITORING
    SCHEDULE 2: PAYMENT
    SCHEDULE 2 – 16 TO 19 EDUCATION
    SCHEDULE 3: NOT USED
    """




    # 1. Check Summary of Funding
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017642 Co Ltd UKPRN: 10017642
    Master Contract Number: ESFA-642
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
	16 to 19 Education 16ED-642 £265,633 £173,835 £439,468
    Total Funding for this contract: £439,468
    Summary of Funding – Page 1
    """




    # 2. Include 'Main Terms & Conditions' doc for contract (ContractType = Conditions of Funding (Grant) (NMSS))
    And   the pdf file contains the following page lines in order
    """
    Agreement Type Non-Maintained Special Schools
    Funding Period 1 August 2019 to 31 July 2020
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017642 Co Ltd
    Funding for 16 to 19 Education
    Master Agreement Number ESFA-642
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    acting through the Education and Skills Funding Agency
    by Eileen Milner, Chief Executive of the Education & Skills Funding Agency
    EDSK Version 2 (September 2019) Page 1
    
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017642 Co Ltd THE SECRETARY OF STATE FOR
    4 Red Lion Court EDUCATION ACTING THROUGH
    Alexandra Road THE EDUCATION AND SKILLS
    Hounslow FUNDING AGENCY, AN
    Middlesex EXECUTIVE AGENCY OF THE
    TW3 1JS DEPARTMENT OF EDUCATION
    AND
    CHEYLESMORE HOUSE
    QUINTON ROAD
    Company No: AA017642 COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 2 (September 2019) Page 2
    """




    # 3. Check the contents of Schedule 1 (S1)
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    16 to 19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 2 NMSS (September 2019) – Page 1
    """




    # 4. Check the contents of Schedule 2 (S2)
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    Schedule 2 – 16 to 19 Education – Page 1
    """




    # 5. Check the contents of the 'Funding Agreement'
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017642 Co Ltd UKPRN: 10017642
    Master Contract Number: ESFA-642 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: 16ED-642
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    16-19 Bursary Funds £3,002 £0.00 £0.00 £1,032.84 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £1,969.59
    16-19 High Needs Element 2 £1,172 £0.00 £0.00 £0.00 £1,172.44 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00
    19+ Continuing Learners Programme Funding £33,942 £0.00 £4,534.63 £0.00 £1,307.85 £4,417.94 £4,672.84 £0.00 £1,647.72 £0.00 £5,214.11 £7,644.46 £4,502.91
    16-19 Advanced Maths Premium £4,331 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,130.46 £0.00 £913.29 £0.00 £1,287.69
    SSF Programme Funding £23,162 -£4,476.61 £0.00 £0.00 £6,939.68 £6,175.96 £0.00 £0.00 £6,875.23 £2,438.64 £5,209.59 £0.00 £0.00
    SSF Capacity and Delivery Bursary Funds £4,570 £2,241.35 £0.00 £0.00 £0.00 £0.00 £1,868.46 £0.00 £0.00 £0.00 £460.32 £0.00 £0.00
    19+ Continuing Learners in SFC (Student Support) £2,966 £0.00 £0.00 £597.56 £2,098.17 £0.00 £0.00 £0.00 £0.00 £0.00 £270.15 £0.00 £0.00
    Alternative Completions - Sporting Excellence £3,844 £0.00 £0.00 £331.73 £0.00 £0.00 £983.52 £1,826.30 £0.00 £0.00 £93.76 £0.00 £609.13
    Maths Centre for Excellence 1619 £4,979 £0.00 £705.53 £0.00 £3,376.32 £143.18 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £754.03
    Teachers Pay Grant (NMSS) £4,636 -£297.97 £0.00 £1,606.09 £0.00 £0.00 £249.47 £0.00 £0.00 £0.00 £2,218.46 £0.00 £860.32
    Young Offenders Institute £37,400 -£1,217.37 £0.00 £0.00 £7,958.29 £400.41 £2,968.97 £7,162.86 £4,753.45 £1,473.69 £5,804.79 £5,518.16 £2,577.01
    Core Cities Youth Contract £2,704 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £2,703.63 £0.00 £0.00 £0.00 £0.00 £0.00
    LA Other 2 £3,107 £0.00 £0.00 £0.00 £0.00 £0.00 £395.88 £0.00 £0.00 £2,269.38 £0.00 £441.36 £0.00
    TechBacc £2,292 -£1,000.00 £0.00 £2,278.01 £0.00 £0.00 £0.00 £0.00 £0.00 £1,013.86 £0.00 £0.00 £0.00
    Teacher's Pension Scheme 1619 £37,266 -£1,217.37 £0.00 £0.00 £7,934.29 £428.41 £2,973.97 £7,100.86 £4,675.45 £1,553.69 £5,706.79 £5,534.16 £2,576.01
    Technical Education - Employer Support Fund £33,351 £0.00 £4,048.45 £0.00 £1,270.85 £4,329.94 £4,634.84 £0.00 £1,701.72 £0.00 £5,135.11 £7,666.46 £4,563.91
    Early Adopter Development Fund - T Level 1619 £19,293 £6,008.32 £0.00 £0.00 £4,884.80 £3,780.22 £0.00 £3,472.07 £1,147.21 £0.00 £0.00 £0.00 £0.00
    Early Adopter Development Fund - Transition £24,582 £929.83 £0.00 £0.00 £6,013.80 £0.00 £1,905.88 £525.87 £7,712.16 £6,608.57 £886.26 £0.00 £0.00
    Programme 1619
    Early Adopter Development Fund - Marketing 1619 £8,940 £53.37 £0.00 £0.00 £0.00 £0.00 £0.00 £2,085.09 £1,119.72 £2,732.11 £2,648.14 £0.00 £302.03
    Early Adopter Development Fund - T Level SSF £20,818 £3,983.50 £261.19 £0.00 £3,350.75 £6,121.71 £0.00 £0.00 £2,129.48 £0.00 £3,658.90 £0.00 £1,312.52
    Early Adopter Development Fund - Transition £12,079 -£4.73 £0.00 £0.00 £200.24 £0.00 £1,729.66 £1,102.16 £1,495.28 £0.00 £0.00 £4,362.67 £3,193.64
    Programme SSF
    Early Adopter Development Fund - Marketing SSF £22,199 £4,675.26 £3,629.41 £0.00 £0.00 £2,897.42 £0.00 £0.00 £0.00 £3,035.64 £0.00 £7,961.51 £0.00
    Early Adopter Development Fund - T Level £29,048 £8,240.30 £6,457.11 £0.00 £6,829.44 £0.00 £0.00 £2,699.00 £0.00 £0.00 £4,822.20 £0.00 £0.00
    Academies
    Schedule 2 – 16 to 19 Education – Funding Agreement 16ED-642 – Page 1 Ref (for internal use only):  EDSK-642 v1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017642 Co Ltd UKPRN: 10017642
    Master Contract Number: ESFA-642 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: 16ED-642
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Early Adopter Development Fund - Transition £17,764 £1,170.36 £3,889.41 £0.00 £0.00 £2,897.42 £0.00 £0.00 £0.00 £3,145.64 £0.00 £6,661.51 £0.00
    Programme Academies
    Early Adopter Development Fund - Marketing £40,664 £7,900.30 £6,457.11 £0.00 £6,829.44 £0.00 £0.00 £2,754.09 £0.00 £0.00 £16,723.08 £0.00 £0.00
    Academies
    Teachers Pension Scheme (NMSS) £30,908 £6,125.80 £6,020.00 £0.00 £5,582.20 £0.00 £0.00 £4,125.00 £0.00 £0.00 £9,055.00 £0.00 £0.00
    COVID-19 Schools Fund Claim £10,445 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £0.00 £5,275.00 £2,125.00 £3,045.00
    Total Funding £439,468 £33,114.34 £36,002.84 £5,846.23 £65,748.56 £31,592.61 £22,383.49 £35,556.93 £35,387.88 £24,271.22 £74,094.95 £47,915.29 £27,553.79
    Schedule 2 – 16 to 19 Education – Funding Agreement 16ED-642 – Page 2 Ref (for internal use only):  EDSK-642 v1
    """




    # 6. Check the contents of Schedules 3-8' (S3ON)
    And   the pdf file contains the following page lines in order
	"""
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (September 2019) – Page 1

    SCHEDULE 4: NOT USED
    EDSK Schedule 4 Version 2 (September 2019) – Page 1

    SCHEDULE 5: NOT USED
    EDSK Schedule 5 Version 2 (September 2019) – Page 1

    SCHEDULE 6: GDPR
    EDSK Schedule 6 Version 2 (September 2019) – Page 1

    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
    EDSK Schedule 7 Version 2 (September 2019) – Page 1

    SCHEDULE 8: EXIT ARRANGEMENTS
    EDSK Schedule 8 Version 2 (September 2019) – Page 1
    """


    # Save a copy of the output
   #Then  Sharepoint file '10017642_[ContractNo]_v1.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A642v1.pdf'
    Then  Sharepoint file '10017642_EDSK-642_v1.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A642v1.pdf'




    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-642' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '17/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-642' and actual ContractNumber 'EDSK-642'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-642' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017642 | EDSK-642           | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017642 | EDSK-642           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017642 | ESFA-642           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM 
   #And   there are '324' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '324' deliverable period rows in CRM linked to the latest version of contract 'EDSK-642'




    # Check the PROFILE PAYMENTS in CRM for all deliverables
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-642       | 16ED-642        | 2               | 23162.49  | -4476.61 | 0.00     | 0.00     | 6939.68  | 6175.96  | 0.00     | 0.00     | 6875.23  | 2438.64  | 5209.59  | 0.00     | 0.00     | 
    | EDSK-642       | 16ED-642        | 3               | 37400.26  | -1217.37 | 0.00     | 0.00     | 7958.29  | 400.41   | 2968.97  | 7162.86  | 4753.45  | 1473.69  | 5804.79  | 5518.16  | 2577.01  | 
    | EDSK-642       | 16ED-642        | 19              | 3002.43   | 0.00     | 0.00     | 1032.84  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1969.59  | 
    | EDSK-642       | 16ED-642        | 22              | 1172.44   | 0.00     | 0.00     | 0.00     | 1172.44  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-642       | 16ED-642        | 35              | 2703.63   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2703.63  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-642       | 16ED-642        | 38              | 3106.62   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 395.88   | 0.00     | 0.00     | 2269.38  | 0.00     | 441.36   | 0.00     | 
    | EDSK-642       | 16ED-642        | 45              | 2291.87   | -1000.00 | 0.00     | 2278.01  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1013.86  | 0.00     | 0.00     | 0.00     | 
    | EDSK-642       | 16ED-642        | 51              | 3844.44   | 0.00     | 0.00     | 331.73   | 0.00     | 0.00     | 983.52   | 1826.30  | 0.00     | 0.00     | 93.76    | 0.00     | 609.13   | 
    | EDSK-642       | 16ED-642        | 86              | 2965.88   | 0.00     | 0.00     | 597.56   | 2098.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 270.15   | 0.00     | 0.00     | 
    | EDSK-642       | 16ED-642        | 115             | 4570.13   | 2241.35  | 0.00     | 0.00     | 0.00     | 0.00     | 1868.46  | 0.00     | 0.00     | 0.00     | 460.32   | 0.00     | 0.00     | 
    | EDSK-642       | 16ED-642        | 118             | 4636.37   | -297.97  | 0.00     | 1606.09  | 0.00     | 0.00     | 249.47   | 0.00     | 0.00     | 0.00     | 2218.46  | 0.00     | 860.32   | 
    | EDSK-642       | 16ED-642        | 119             | 4979.06   | 0.00     | 705.53   | 0.00     | 3376.32  | 143.18   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 754.03   | 
    | EDSK-642       | 16ED-642        | 124             | 33351.28  | 0.00     | 4048.45  | 0.00     | 1270.85  | 4329.94  | 4634.84  | 0.00     | 1701.72  | 0.00     | 5135.11  | 7666.46  | 4563.91  |
    | EDSK-642       | 16ED-642        | 914             | 4331.44   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2130.46  | 0.00     | 913.29   | 0.00     | 1287.69  | 
    | EDSK-642       | 16ED-642        | 933             | 33942.46  | 0.00     | 4534.63  | 0.00     | 1307.85  | 4417.94  | 4672.84  | 0.00     | 1647.72  | 0.00     | 5214.11  | 7644.46  | 4502.91  | 
    | EDSK-642       | 16ED-642        | 125             | 37266.26  | -1217.37 | 0.00     | 0.00     | 7934.29  | 428.41   | 2973.97  | 7100.86  | 4675.45  | 1553.69  | 5706.79  | 5534.16  | 2576.01  | 
    # Nine new Early Adopter deliverables (27555)
    | EDSK-642       | 16ED-642        | 126             | 19292.62  | 6008.32  | 0.00     | 0.00     | 4884.80  | 3780.22  | 0.00     | 3472.07  | 1147.21  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-642       | 16ED-642        | 127             | 24582.37  | 929.83   | 0.00     | 0.00     | 6013.80  | 0.00     | 1905.88  | 525.87   | 7712.16  | 6608.57  | 886.26   | 0.00     | 0.00     | 
    | EDSK-642       | 16ED-642        | 128             | 8940.46   | 53.37    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2085.09  | 1119.72  | 2732.11  | 2648.14  | 0.00     | 302.03   | 
    | EDSK-642       | 16ED-642        | 129             | 20818.05  | 3983.50  | 261.19   | 0.00     | 3350.75  | 6121.71  | 0.00     | 0.00     | 2129.48  | 0.00     | 3658.90  | 0.00     | 1312.52  | 
    | EDSK-642       | 16ED-642        | 130             | 12078.92  | -4.73    | 0.00     | 0.00     | 200.24   | 0.00     | 1729.66  | 1102.16  | 1495.28  | 0.00     | 0.00     | 4362.67  | 3193.64  | 
    | EDSK-642       | 16ED-642        | 131             | 22199.24  | 4675.26  | 3629.41  | 0.00     | 0.00     | 2897.42  | 0.00     | 0.00     | 0.00     | 3035.64  | 0.00     | 7961.51  | 0.00     | 
    | EDSK-642       | 16ED-642        | 132             | 29048.05  | 8240.30  | 6457.11  | 0.00     | 6829.44  | 0.00     | 0.00     | 2699.00  | 0.00     | 0.00     | 4822.20  | 0.00     | 0.00     | 
    | EDSK-642       | 16ED-642        | 133             | 17764.34  | 1170.36  | 3889.41  | 0.00     | 0.00     | 2897.42  | 0.00     | 0.00     | 0.00     | 3145.64  | 0.00     | 6661.51  | 0.00     | 
    | EDSK-642       | 16ED-642        | 134             | 40664.02  | 7900.30  | 6457.11  | 0.00     | 6829.44  | 0.00     | 0.00     | 2754.09  | 0.00     | 0.00     | 16723.08 | 0.00     | 0.00     | 
	# New Teachers Pension NMSS (28284)
	| EDSK-642       | 16ED-642        | 135             | 30908.00  | 6125.80  | 6020.00  | 0.00     | 5582.20  | 0.00     | 0.00     | 4125.00  | 0.00     | 0.00     | 9055.00  | 0.00     | 0.00     | 
    # Covid-19 Schools Fund Claim (30898)
	| EDSK-642       | 16ED-642        | 144             | 10445.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5275.00  | 2125.00  | 3045.00  | 


    # Check the PROFILE subnominal aggregations in PaaS for the nine new Early Adopter deliverables (27555)
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017642 | ORG0017642 | 16ED-642          | 2203060         | 1619ED1920                 | 201908               | PROFILE         | CM             | False       | 6008.32         |
    | 10017642 | ORG0017642 | 16ED-642          | 2203060         | 1619ED1920                 | 201909               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2203060         | 1619ED1920                 | 201910               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2203060         | 1619ED1920                 | 201911               | PROFILE         | CM             | False       | 4884.80         |
    | 10017642 | ORG0017642 | 16ED-642          | 2203060         | 1619ED1920                 | 201912               | PROFILE         | CM             | False       | 3780.22         |
    | 10017642 | ORG0017642 | 16ED-642          | 2203060         | 1619ED1920                 | 202001               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2203060         | 1619ED1920                 | 202002               | PROFILE         | CM             | False       | 3472.07         |
    | 10017642 | ORG0017642 | 16ED-642          | 2203060         | 1619ED1920                 | 202003               | PROFILE         | CM             | False       | 1147.21         |
    | 10017642 | ORG0017642 | 16ED-642          | 2203060         | 1619ED1920                 | 202004               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2203060         | 1619ED1920                 | 202005               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2203060         | 1619ED1920                 | 202006               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2203060         | 1619ED1920                 | 202007               | PROFILE         | CM             | False       | 0.00            |
    #
	| 10017642 | ORG0017642 | 16ED-642          | 2203061         | 1619ED1920                 | 201908               | PROFILE         | CM             | False       | 929.83          |
    | 10017642 | ORG0017642 | 16ED-642          | 2203061         | 1619ED1920                 | 201909               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2203061         | 1619ED1920                 | 201910               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2203061         | 1619ED1920                 | 201911               | PROFILE         | CM             | False       | 6013.80         |
    | 10017642 | ORG0017642 | 16ED-642          | 2203061         | 1619ED1920                 | 201912               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2203061         | 1619ED1920                 | 202001               | PROFILE         | CM             | False       | 1905.88         |
    | 10017642 | ORG0017642 | 16ED-642          | 2203061         | 1619ED1920                 | 202002               | PROFILE         | CM             | False       | 525.87          |
    | 10017642 | ORG0017642 | 16ED-642          | 2203061         | 1619ED1920                 | 202003               | PROFILE         | CM             | False       | 7712.16         |
    | 10017642 | ORG0017642 | 16ED-642          | 2203061         | 1619ED1920                 | 202004               | PROFILE         | CM             | False       | 6608.57         |
    | 10017642 | ORG0017642 | 16ED-642          | 2203061         | 1619ED1920                 | 202005               | PROFILE         | CM             | False       | 886.26          |
    | 10017642 | ORG0017642 | 16ED-642          | 2203061         | 1619ED1920                 | 202006               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2203061         | 1619ED1920                 | 202007               | PROFILE         | CM             | False       | 0.00            |
    #
	| 10017642 | ORG0017642 | 16ED-642          | 2203062         | 1619ED1920                 | 201908               | PROFILE         | CM             | False       | 53.37           |
    | 10017642 | ORG0017642 | 16ED-642          | 2203062         | 1619ED1920                 | 201909               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2203062         | 1619ED1920                 | 201910               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2203062         | 1619ED1920                 | 201911               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2203062         | 1619ED1920                 | 201912               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2203062         | 1619ED1920                 | 202001               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2203062         | 1619ED1920                 | 202002               | PROFILE         | CM             | False       | 2085.09         |
    | 10017642 | ORG0017642 | 16ED-642          | 2203062         | 1619ED1920                 | 202003               | PROFILE         | CM             | False       | 1119.72         |
    | 10017642 | ORG0017642 | 16ED-642          | 2203062         | 1619ED1920                 | 202004               | PROFILE         | CM             | False       | 2732.11         |
    | 10017642 | ORG0017642 | 16ED-642          | 2203062         | 1619ED1920                 | 202005               | PROFILE         | CM             | False       | 2648.14         |
    | 10017642 | ORG0017642 | 16ED-642          | 2203062         | 1619ED1920                 | 202006               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2203062         | 1619ED1920                 | 202007               | PROFILE         | CM             | False       | 302.03          |
    #
	| 10017642 | ORG0017642 | 16ED-642          | 2218060         | 1619ED1920                 | 201908               | PROFILE         | CM             | False       | 3983.50         |
    | 10017642 | ORG0017642 | 16ED-642          | 2218060         | 1619ED1920                 | 201909               | PROFILE         | CM             | False       | 261.19          |
    | 10017642 | ORG0017642 | 16ED-642          | 2218060         | 1619ED1920                 | 201910               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2218060         | 1619ED1920                 | 201911               | PROFILE         | CM             | False       | 3350.75         |
    | 10017642 | ORG0017642 | 16ED-642          | 2218060         | 1619ED1920                 | 201912               | PROFILE         | CM             | False       | 6121.71         |
    | 10017642 | ORG0017642 | 16ED-642          | 2218060         | 1619ED1920                 | 202001               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2218060         | 1619ED1920                 | 202002               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2218060         | 1619ED1920                 | 202003               | PROFILE         | CM             | False       | 2129.48         |
    | 10017642 | ORG0017642 | 16ED-642          | 2218060         | 1619ED1920                 | 202004               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2218060         | 1619ED1920                 | 202005               | PROFILE         | CM             | False       | 3658.90         |
    | 10017642 | ORG0017642 | 16ED-642          | 2218060         | 1619ED1920                 | 202006               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2218060         | 1619ED1920                 | 202007               | PROFILE         | CM             | False       | 1312.52         |
    #
	| 10017642 | ORG0017642 | 16ED-642          | 2218061         | 1619ED1920                 | 201908               | PROFILE         | CM             | False       | -4.73           |
    | 10017642 | ORG0017642 | 16ED-642          | 2218061         | 1619ED1920                 | 201909               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2218061         | 1619ED1920                 | 201910               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2218061         | 1619ED1920                 | 201911               | PROFILE         | CM             | False       | 200.24          |
    | 10017642 | ORG0017642 | 16ED-642          | 2218061         | 1619ED1920                 | 201912               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2218061         | 1619ED1920                 | 202001               | PROFILE         | CM             | False       | 1729.66         |
    | 10017642 | ORG0017642 | 16ED-642          | 2218061         | 1619ED1920                 | 202002               | PROFILE         | CM             | False       | 1102.16         |
    | 10017642 | ORG0017642 | 16ED-642          | 2218061         | 1619ED1920                 | 202003               | PROFILE         | CM             | False       | 1495.28         |
    | 10017642 | ORG0017642 | 16ED-642          | 2218061         | 1619ED1920                 | 202004               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2218061         | 1619ED1920                 | 202005               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2218061         | 1619ED1920                 | 202006               | PROFILE         | CM             | False       | 4362.67         |
    | 10017642 | ORG0017642 | 16ED-642          | 2218061         | 1619ED1920                 | 202007               | PROFILE         | CM             | False       | 3193.64         |
    #
	| 10017642 | ORG0017642 | 16ED-642          | 2218062         | 1619ED1920                 | 201908               | PROFILE         | CM             | False       | 4675.26         |
    | 10017642 | ORG0017642 | 16ED-642          | 2218062         | 1619ED1920                 | 201909               | PROFILE         | CM             | False       | 3629.41         |
    | 10017642 | ORG0017642 | 16ED-642          | 2218062         | 1619ED1920                 | 201910               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2218062         | 1619ED1920                 | 201911               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2218062         | 1619ED1920                 | 201912               | PROFILE         | CM             | False       | 2897.42         |
    | 10017642 | ORG0017642 | 16ED-642          | 2218062         | 1619ED1920                 | 202001               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2218062         | 1619ED1920                 | 202002               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2218062         | 1619ED1920                 | 202003               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2218062         | 1619ED1920                 | 202004               | PROFILE         | CM             | False       | 3035.64         |
    | 10017642 | ORG0017642 | 16ED-642          | 2218062         | 1619ED1920                 | 202005               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2218062         | 1619ED1920                 | 202006               | PROFILE         | CM             | False       | 7961.51         |
    | 10017642 | ORG0017642 | 16ED-642          | 2218062         | 1619ED1920                 | 202007               | PROFILE         | CM             | False       | 0.00            |
    #
	| 10017642 | ORG0017642 | 16ED-642          | 2220060         | 1619ED1920                 | 201908               | PROFILE         | CM             | False       | 8240.30         |
    | 10017642 | ORG0017642 | 16ED-642          | 2220060         | 1619ED1920                 | 201909               | PROFILE         | CM             | False       | 6457.11         |
    | 10017642 | ORG0017642 | 16ED-642          | 2220060         | 1619ED1920                 | 201910               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2220060         | 1619ED1920                 | 201911               | PROFILE         | CM             | False       | 6829.44         |
    | 10017642 | ORG0017642 | 16ED-642          | 2220060         | 1619ED1920                 | 201912               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2220060         | 1619ED1920                 | 202001               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2220060         | 1619ED1920                 | 202002               | PROFILE         | CM             | False       | 2699.00         |
    | 10017642 | ORG0017642 | 16ED-642          | 2220060         | 1619ED1920                 | 202003               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2220060         | 1619ED1920                 | 202004               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2220060         | 1619ED1920                 | 202005               | PROFILE         | CM             | False       | 4822.20         |
    | 10017642 | ORG0017642 | 16ED-642          | 2220060         | 1619ED1920                 | 202006               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2220060         | 1619ED1920                 | 202007               | PROFILE         | CM             | False       | 0.00            |
    #
	| 10017642 | ORG0017642 | 16ED-642          | 2220061         | 1619ED1920                 | 201908               | PROFILE         | CM             | False       | 1170.36         |
    | 10017642 | ORG0017642 | 16ED-642          | 2220061         | 1619ED1920                 | 201909               | PROFILE         | CM             | False       | 3889.41         |
    | 10017642 | ORG0017642 | 16ED-642          | 2220061         | 1619ED1920                 | 201910               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2220061         | 1619ED1920                 | 201911               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2220061         | 1619ED1920                 | 201912               | PROFILE         | CM             | False       | 2897.42         |
    | 10017642 | ORG0017642 | 16ED-642          | 2220061         | 1619ED1920                 | 202001               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2220061         | 1619ED1920                 | 202002               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2220061         | 1619ED1920                 | 202003               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2220061         | 1619ED1920                 | 202004               | PROFILE         | CM             | False       | 3145.64         |
    | 10017642 | ORG0017642 | 16ED-642          | 2220061         | 1619ED1920                 | 202005               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2220061         | 1619ED1920                 | 202006               | PROFILE         | CM             | False       | 6661.51         |
    | 10017642 | ORG0017642 | 16ED-642          | 2220061         | 1619ED1920                 | 202007               | PROFILE         | CM             | False       | 0.00            |
    #
	| 10017642 | ORG0017642 | 16ED-642          | 2220062         | 1619ED1920                 | 201908               | PROFILE         | CM             | False       | 7900.30         |
    | 10017642 | ORG0017642 | 16ED-642          | 2220062         | 1619ED1920                 | 201909               | PROFILE         | CM             | False       | 6457.11         |
    | 10017642 | ORG0017642 | 16ED-642          | 2220062         | 1619ED1920                 | 201910               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2220062         | 1619ED1920                 | 201911               | PROFILE         | CM             | False       | 6829.44         |
    | 10017642 | ORG0017642 | 16ED-642          | 2220062         | 1619ED1920                 | 201912               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2220062         | 1619ED1920                 | 202001               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2220062         | 1619ED1920                 | 202002               | PROFILE         | CM             | False       | 2754.09         |
    | 10017642 | ORG0017642 | 16ED-642          | 2220062         | 1619ED1920                 | 202003               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2220062         | 1619ED1920                 | 202004               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2220062         | 1619ED1920                 | 202005               | PROFILE         | CM             | False       | 16723.08        |
    | 10017642 | ORG0017642 | 16ED-642          | 2220062         | 1619ED1920                 | 202006               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2220062         | 1619ED1920                 | 202007               | PROFILE         | CM             | False       | 0.00            |

    # Check the PROFILE subnominal aggregations in PaaS for the new Teachers Pension NMSS deliverable (28284)
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017642 | ORG0017642 | 16ED-642          | 2601008         | 1619ED1920                 | 201908               | PROFILE         | CM             | False       | 6125.80         |
    | 10017642 | ORG0017642 | 16ED-642          | 2601008         | 1619ED1920                 | 201909               | PROFILE         | CM             | False       | 6020.00         |
    | 10017642 | ORG0017642 | 16ED-642          | 2601008         | 1619ED1920                 | 201910               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2601008         | 1619ED1920                 | 201911               | PROFILE         | CM             | False       | 5582.20         |
    | 10017642 | ORG0017642 | 16ED-642          | 2601008         | 1619ED1920                 | 201912               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2601008         | 1619ED1920                 | 202001               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2601008         | 1619ED1920                 | 202002               | PROFILE         | CM             | False       | 4125.00         |
    | 10017642 | ORG0017642 | 16ED-642          | 2601008         | 1619ED1920                 | 202003               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2601008         | 1619ED1920                 | 202004               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2601008         | 1619ED1920                 | 202005               | PROFILE         | CM             | False       | 9055.00         |
    | 10017642 | ORG0017642 | 16ED-642          | 2601008         | 1619ED1920                 | 202006               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2601008         | 1619ED1920                 | 202007               | PROFILE         | CM             | False       | 0.00            |

    # Check the PROFILE subnominal aggregations in PaaS for the new COVID-19 Schools Fund (30898)
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017642 | ORG0017642 | 16ED-642          | 2221700         | 1619ED1920                 | 201908               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2221700         | 1619ED1920                 | 201909               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2221700         | 1619ED1920                 | 201910               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2221700         | 1619ED1920                 | 201911               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2221700         | 1619ED1920                 | 201912               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2221700         | 1619ED1920                 | 202001               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2221700         | 1619ED1920                 | 202002               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2221700         | 1619ED1920                 | 202003               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2221700         | 1619ED1920                 | 202004               | PROFILE         | CM             | False       | 0.00            |
    | 10017642 | ORG0017642 | 16ED-642          | 2221700         | 1619ED1920                 | 202005               | PROFILE         | CM             | False       | 5275.00         |
    | 10017642 | ORG0017642 | 16ED-642          | 2221700         | 1619ED1920                 | 202006               | PROFILE         | CM             | False       | 2125.00         |
    | 10017642 | ORG0017642 | 16ED-642          | 2221700         | 1619ED1920                 | 202007               | PROFILE         | CM             | False       | 3045.00         |


    # Tidy up
    And the override date is reset 
     
	  