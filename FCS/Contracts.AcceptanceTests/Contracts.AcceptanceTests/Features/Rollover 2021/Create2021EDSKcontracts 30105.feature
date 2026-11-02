Feature: Create2021EDSKcontracts 30105

@AcceptanceTest @Complete
Scenario: A510 Create a 2021 EDSK contract with just an STFIC alloc. Update draft to add 3 delivery orgs. Approve. Check SoF and FA docs and CRM financials
    Given there are no allocations marked as Under Termination for UKPRN '10017510' 
    And   there are no terminated or closed allocations for UKPRN '10017510' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017510' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017510' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | STFC-510      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | STFC-510      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | STFIC2021         |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-510       | 1                     | 0                        |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017510' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017510 Co Ltd' with UKPRN '10017510' and OrgId 'ORG0017510' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017510' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status   | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017510 | 117510 | 10017510 Co Ltd | 0              | Active   | Yes           | AA017510      | ?             | 1 Wherry Dock          | ?                      | ?                      | ?                      | Ipswich                | Suffolk                | IP4 1AS   |
    | 10027510 | 127510 | 10027510 Co Ltd | 0              | Active   | Yes           | AA027510      | ?             | 25 Lamberth Wharf      | Wherry Quay            | ?                      | ?                      | Ipswich                | Suffolk                | IP4 1AS   |
    | 10037510 | 137510 | 10037510 Co Ltd | 0              | Active   | Yes           | AA037510      | ?             | 9 Chester Wharf        | Wherry Quay            | ?                      | ?                      | Ipswich                | Suffolk                | IP4 1AS   |
    | 10047510 | 147510 | 10047510 Co Ltd | 0              | Active   | Yes           | AA047510      | ?             | 108 Key Wharf          | Wherry Quay            | ?                      | ?                      | Ipswich                | Suffolk                | IP4 1AS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017510 |
    | 10027510 |
    | 10037510 |
    | 10047510 |




    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017510 | 10017510 Co Ltd      | ESFA-510             | EDSK-510       | 1                     | 01/08/2020        | 31/07/2021      | 68308.00      |                                       | Conditions of Funding (Grant) (HEI)        | 2021   | New          | ORG0017510 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017510 | EDSK-510       | STFC-510      | STFIC             | STFIC2021               | AY                      | 01/08/2020          | 31/07/2021        | 68308.00        |                                         |            |                                                             | New          | 10017510    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription               | CRMIntent    | DeliveryOrg |
    | 10017510 | EDSK-510       | STFC-510      | 1               | 0                     | 27388.00  | 18532.00  | 8856.00   | 2945.00  | 233.00   | 969.00   | 3444.00  | 3420.00  | 2510.00  | 1537.00  | 3474.00  | 1364.00  | 2258.00  | 3277.00  | 1957.00  | Short Term Funding Initiative 1      | New          | 10017510    | 
    | 10017510 | EDSK-510       | STFC-510      | 2               | 0                     | 21153.00  | 15609.00  | 5544.00   | 3746.00  | 2742.00  | 3034.00  | 1176.00  | 331.00   | 148.00   | 3414.00  | 1018.00  | 805.00   | 2426.00  | 282.00   | 2031.00  | Short Term Funding Initiative 2      | New          | 10017510    | 
    | 10017510 | EDSK-510       | STFC-510      | 3               | 0                     | 19767.00  | 14434.00  | 5333.00   | 73.00    | 3497.00  | 626.00   | 854.00   | 1906.00  | 3433.00  | 3537.00  | 508.00   | 1210.00  | 839.00   | 2934.00  | 350.00   | Short Term Funding Initiative 3      | New          | 10017510    | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-510       | 1                     | 0                        | 2020-07-01 09:12:35.000 |




    # Change the date
    Given the override date is '11/07/2020'

    # Bulk Update Draft file to add 3 delivery orgs and further deliverables
    And   there are no files prefixed '10017510' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 17072020103044 v3_A510' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 17072020103044 v3_A510' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 17072020103044 v3_A510' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 17072020103044 v3_A510' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 17072020103044 v3_A510.xlsx' exists in the Datafiles folder and UKPRN '10017510' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters for Contracting Org 10017510
    When  I retrieve the latest EFA contract details from CRM for provider '10017510' for FundingType 'EDSK' and period '2021' and Delivery Organisation '10017510'

    # Check the contents of the Summary of Funding and the Funding Agreement for STFIC and AEBC-CSO
    Then  the file named '10017510_EDSK-510_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017510 Co Ltd UKPRN: 10017510
    Master Contract Number: ESFA-510
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    10017510 Co Ltd STFC-510 £48,575 £19,733 £68,308
    of which Short Term Funding Initiative 1 £18,532 £8,856 £27,388
    of which Short Term Funding Initiative 2 £15,609 £5,544 £21,153
    of which Short Term Funding Initiative 3 £14,434 £5,333 £19,767
    Total Funding for this contract: £408,197
    Summary of Funding – Page 1

    Agreement Type Conditions of Funding (Grant) (HEI)
    Funding Period 1 August 2020 to 31 July 2021
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017510 Co Ltd
    Funding for ESFA-Funded Adult Education Budget
    Master Agreement Number ESFA-510
    EDSK Version 3 (September 2020) Page 1
    
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017510 Co Ltd THE SECRETARY OF STATE FOR
    1 Wherry Dock EDUCATION ACTING THROUGH
    Ipswich THE EDUCATION AND SKILLS
    Suffolk FUNDING AGENCY, AN
    IP4 1AS EXECUTIVE AGENCY OF THE
    DEPARTMENT OF EDUCATION
    AND
    CHEYLESMORE HOUSE
    Company No: AA017510 QUINTON ROAD
    COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (September 2020) Page 2

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Short Term Funding Initiatives
    Provider: 10017510 Co Ltd UKPRN: 10017510
    Master Contract Number: ESFA-510 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: STFC-510
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    Short Term Funding Initiative 1 £27,388 £2,945 £233 £969 £3,444 £3,420 £2,510 £1,537 £3,474 £1,364 £2,258 £3,277 £1,957
    Short Term Funding Initiative 2 £21,153 £3,746 £2,742 £3,034 £1,176 £331 £148 £3,414 £1,018 £805 £2,426 £282 £2,031
    Short Term Funding Initiative 3 £19,767 £73 £3,497 £626 £854 £1,906 £3,433 £3,537 £508 £1,210 £839 £2,934 £350
    Total Funding £68,308 £6,764 £6,472 £4,629 £5,474 £5,657 £6,091 £8,488 £5,000 £3,379 £5,523 £6,493 £4,338
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement STFC-510 – Page 1 Ref (for internal use only):  EDSK-510 v1
    """




    # Retrieve parameters for Delivery Org 10027510
    When  I retrieve the latest EFA contract details from CRM for provider '10017510' for FundingType 'EDSK' and period '2021' and Delivery Organisation '10027510'

    # Check the contents of the Summary of Funding and the Funding Agreement for STFIC and AEBC-CSO
    Then  the file named '10017510_EDSK-510_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017510 Co Ltd UKPRN: 10017510
    Master Contract Number: ESFA-510
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    ESFA AEB - COVID-19 Skills Offer
    10027510 Co Ltd [AllocRef_AECS] £35,961 £17,210 £53,171
    of which National Skills Fund Level 3 Offer for 24 year £0 £10,000 £10,000
    old and over
    of which High Value Courses for School and College £35,961 £7,210 £43,171
    Leavers
    10027510 Co Ltd [AllocRef_STFC] £21,827 £13,355 £35,182
    of which Short Term Funding Initiative 1 £21,827 £13,355 £35,182

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - COVID-19 Skills Offer
    Provider: 10027510 Co Ltd UKPRN: 10027510
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_AECS]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - High Value Courses for School and £43,171 £4,669 £5,049 £2,172 £2,899 £5,966 £7,267 £5,463 £2,476 £1,720 £1,720 £1,429 £2,341
    College Leavers
    ESFA AEB - National Skills Fund Level 3 Offer for 24 £10,000 £0 £0 £0 £0 £0 £0 £0 £0 £675 £2,322 £3,114 £3,889
    year old and over
    Total Funding £53,171 £4,669 £5,049 £2,172 £2,899 £5,966 £7,267 £5,463 £2,476 £2,395 £4,042 £4,543 £6,230
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECS] – Page 1 Ref (for internal use only):  EDSK-510 v1

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Short Term Funding Initiatives
    Provider: 10027510 Co Ltd UKPRN: 10027510
    Master Contract Number: ESFA-510 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_STFC]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    Short Term Funding Initiative 1 £35,182 £1,550 £2,993 £4,501 £3,705 £255 £2,654 £5,521 £648 £3,588 £2,718 £1,104 £5,945
    Total Funding £35,182 £1,550 £2,993 £4,501 £3,705 £255 £2,654 £5,521 £648 £3,588 £2,718 £1,104 £5,945
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_STFC] – Page 1 Ref (for internal use only):  EDSK-510 v1
    """




    # Retrieve parameters for Delivery Org 10037510
    When  I retrieve the latest EFA contract details from CRM for provider '10017510' for FundingType 'EDSK' and period '2021' and Delivery Organisation '10037510'

    # Check the contents of the Summary of Funding and the Funding Agreement
    Then  the file named '10017510_EDSK-510_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017510 Co Ltd UKPRN: 10017510
    Master Contract Number: ESFA-510
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    ESFA AEB - COVID-19 Skills Offer
    10037510 Co Ltd [AllocRef_AECS] £29,624 £27,087 £56,711
    of which National Skills Fund Level 3 Offer for 24 year £0 £13,000 £13,000
    old and over
    of which High Value Courses for School and College £29,624 £14,087 £43,711
    Leavers
    10037510 Co Ltd [AllocRef_STFC] £61,471 £28,724 £90,195
    of which Short Term Funding Initiative 2 £26,907 £14,031 £40,938
    of which Short Term Funding Initiative 3 £34,564 £14,693 £49,257

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - COVID-19 Skills Offer
    Provider: 10037510 Co Ltd UKPRN: 10037510
    Master Contract Number: ESFA-510 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_AECS]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - High Value Courses for School and £43,711 £7,168 £661 £4,280 £3,484 £7,985 £321 £5,299 £426 £1,255 £2,497 £6,723 £3,612
    College Leavers
    ESFA AEB - National Skills Fund Level 3 Offer for 24 £13,000 £0 £0 £0 £0 £0 £0 £0 £0 £1,869 £2,486 £3,978 £4,667
    year old and over
    Total Funding £56,711 £7,168 £661 £4,280 £3,484 £7,985 £321 £5,299 £426 £3,124 £4,983 £10,701 £8,279
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECS] – Page 1 Ref (for internal use only):  EDSK-510 v1

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Short Term Funding Initiatives
    Provider: 10037510 Co Ltd UKPRN: 10037510
    Master Contract Number: ESFA-510 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_STFC]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    Short Term Funding Initiative 2 £40,938 £915 £3,516 £5,777 £1,106 £7,168 £661 £4,280 £3,484 £7,985 £321 £5,299 £426
    Short Term Funding Initiative 3 £49,257 £1,255 £2,497 £6,723 £3,612 £4,992 £5,077 £4,822 £5,586 £1,182 £2,221 £3,326 £7,964
    Total Funding £90,195 £2,170 £6,013 £12,500 £4,718 £12,160 £5,738 £9,102 £9,070 £9,167 £2,542 £8,625 £8,390
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_STFC] – Page 1 Ref (for internal use only):  EDSK-510 v1
    """




    # Retrieve parameters for Delivery Org 10047510
    When  I retrieve the latest EFA contract details from CRM for provider '10017510' for FundingType 'EDSK' and period '2021' and Delivery Organisation '10047510'

    # Check the contents of the Summary of Funding and the Funding Agreement
    Then  the file named '10017510_EDSK-510_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017510 Co Ltd UKPRN: 10017510
    Master Contract Number: ESFA-510
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    ESFA AEB - COVID-19 Skills Offer
    10047510 Co Ltd [AllocRef_AECS] £28,558 £33,446 £62,004
    of which National Skills Fund Level 3 Offer for 24 year £0 £23,000 £23,000
    old and over
    of which High Value Courses for School and College £28,558 £10,446 £39,004
    Leavers
    10047510 Co Ltd [AllocRef_STFC] £35,444 £7,182 £42,626
    of which Short Term Funding Initiative 4 £35,444 £7,182 £42,626

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - COVID-19 Skills Offer
    Provider: 10047510 Co Ltd UKPRN: 10047510
    Master Contract Number: ESFA-510 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_AECS]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - High Value Courses for School and £39,004 £6,465 £2,435 £2,172 £8,152 £1,554 £2,314 £3,343 £2,123 £4,434 £2,577 £1,322 £2,113
    College Leavers
    ESFA AEB - National Skills Fund Level 3 Offer for 24 £23,000 £0 £0 £0 £0 £0 £0 £0 £0 £689 £7,192 £7,005 £8,114
    year old and over
    Total Funding £62,004 £6,465 £2,435 £2,172 £8,152 £1,554 £2,314 £3,343 £2,123 £5,123 £9,769 £8,327 £10,227
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECS] – Page 1 Ref (for internal use only):  EDSK-510 v1

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Short Term Funding Initiatives
    Provider: 10047510 Co Ltd UKPRN: 10047510
    Master Contract Number: ESFA-510 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_STFC]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    Short Term Funding Initiative 4 £42,626 £4,661 £4,948 £1,976 £2,942 £5,882 £7,124 £5,511 £2,400 £1,668 £1,753 £1,498 £2,263
    Total Funding £42,626 £4,661 £4,948 £1,976 £2,942 £5,882 £7,124 £5,511 £2,400 £1,668 £1,753 £1,498 £2,263
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_STFC] – Page 1 Ref (for internal use only):  EDSK-510 v1
    """




    # Check that a zero STFI Deliverable ONE is not shown anywhere
    And   the pdf file does not contain the following text
    """
    of which Short Term Funding Initiative 1 £0 £0 £0
    """

    # Check that a zero STFI Deliverable TWO is not shown anywhere
    And   the pdf file does not contain the following text
    """
    of which Short Term Funding Initiative 2 £0 £0 £0
    """

    # Check that a zero STFI Deliverable THREE is not shown anywhere
    And   the pdf file does not contain the following text
    """
    of which Short Term Funding Initiative 3 £0 £0 £0
    """

    # Check that a zero STFI Deliverable FOUR is not shown anywhere
    And   the pdf file does not contain the following text
    """
    of which Short Term Funding Initiative 4 £0 £0 £0
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017510_EDSK-510_v1.pdf' in 'EDSK-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A510.pdf'




    # Change the date
    Given the override date is '15/07/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-510' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-510'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-510' and actual ContractNumber 'EDSK-510'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-510' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017510 | EDSK-510           | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017510 | EDSK-510           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017510 | ESFA-510           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '432' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '432' deliverable period rows in CRM linked to the latest version of contract 'EDSK-510'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | STFC-510        | 2373010          | Jul-21 | Profile        |
    | [AllocRef_AECS] | 2372091          | Jul-21 | Profile        |





    # Check CRM financials

    # Retrieve parameters for Delivery Org 10027510
    When  I retrieve the latest EFA contract details from CRM for provider '10017510' for FundingType 'EDSK' and period '2021' and Delivery Organisation '10027510'

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-510       | [AllocRef_STFC]    | 1               | 35182.00  | 1550.00  | 2993.00  | 4501.00  | 3705.00  | 255.00   | 2654.00  | 5521.00  | 648.00   | 3588.00  | 2718.00  | 1104.00  | 5945.00  | 
    #
    | EDSK-510       | [AllocRef_AECS]    | 1               | 53171.00  | 4669.00  | 5049.00  | 2172.00  | 2899.00  | 5966.00  | 7267.00  | 5463.00  | 2476.00  | 2395.00  | 4042.00  | 4543.00  | 6230.00  | 
    | EDSK-510       | [AllocRef_AECS]    | 2               | 43171.00  | 4669.00  | 5049.00  | 2172.00  | 2899.00  | 5966.00  | 7267.00  | 5463.00  | 2476.00  | 1720.00  | 1720.00  | 1429.00  | 2341.00  | 
    | EDSK-510       | [AllocRef_AECS]    | 6               | 10000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 675.00   | 2322.00  | 3114.00  | 3889.00  | 


    # Retrieve parameters for Delivery Org 10037510
    When  I retrieve the latest EFA contract details from CRM for provider '10017510' for FundingType 'EDSK' and period '2021' and Delivery Organisation '10037510'

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-510       | [AllocRef_STFC]    | 2               | 40938.00  | 915.00   | 3516.00  | 5777.00  | 1106.00  | 7168.00  | 661.00   | 4280.00  | 3484.00  | 7985.00  | 321.00   | 5299.00  | 426.00   | 
    | EDSK-510       | [AllocRef_STFC]    | 3               | 49257.00  | 1255.00  | 2497.00  | 6723.00  | 3612.00  | 4992.00  | 5077.00  | 4822.00  | 5586.00  | 1182.00  | 2221.00  | 3326.00  | 7964.00  | 
    #
    | EDSK-510       | [AllocRef_AECS]    | 1               | 56711.00  | 7168.00  | 661.00   | 4280.00  | 3484.00  | 7985.00  | 321.00   | 5299.00  | 426.00   | 3124.00  | 4983.00  | 10701.00 | 8279.00  | 
    | EDSK-510       | [AllocRef_AECS]    | 2               | 43711.00  | 7168.00  | 661.00   | 4280.00  | 3484.00  | 7985.00  | 321.00   | 5299.00  | 426.00   | 1255.00  | 2497.00  | 6723.00  | 3612.00  | 
    | EDSK-510       | [AllocRef_AECS]    | 6               | 13000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1869.00  | 2486.00  | 3978.00  | 4667.00  | 
  

    # Retrieve parameters for Delivery Org 10047510
    When  I retrieve the latest EFA contract details from CRM for provider '10017510' for FundingType 'EDSK' and period '2021' and Delivery Organisation '10047510'

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-510       | [AllocRef_STFC]    | 4               | 42626.00  | 4661.00  | 4948.00  | 1976.00  | 2942.00  | 5882.00  | 7124.00  | 5511.00  | 2400.00  | 1668.00  | 1753.00  | 1498.00  | 2263.00  | 
    #
    | EDSK-510       | [AllocRef_AECS]    | 1               | 62004.00  | 6465.00  | 2435.00  | 2172.00  | 8152.00  | 1554.00  | 2314.00  | 3343.00  | 2123.00  | 5123.00  | 9769.00  | 8327.00  | 10227.00 | 
    | EDSK-510       | [AllocRef_AECS]    | 2               | 39004.00  | 6465.00  | 2435.00  | 2172.00  | 8152.00  | 1554.00  | 2314.00  | 3343.00  | 2123.00  | 4434.00  | 2577.00  | 1322.00  | 2113.00  | 
    | EDSK-510       | [AllocRef_AECS]    | 6               | 23000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 689.00   | 7192.00  | 7005.00  | 8114.00  | 


    # Tidy Up
    And   the override date is reset
     
@AcceptanceTest @Withdrawn20231002
Scenario: A511 Create and approve a 2021EDSK contract with an ALLF alloc. Bulk variation amendment to add 16-18TRN alloc. No template timestamp changes. Check document parts
    Given there are no allocations marked as Under Termination for UKPRN '10017511' 
    And   there are no terminated or closed allocations for UKPRN '10017511' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017511' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017511' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLF-511      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ALLF-511      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP          |
    | ALLF2021     |
    | 16-18TRN2021 |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-511       | 1                     | 0                        |
    | EDSK-511       | 2                     | 0                        |
    | EDSK-511       | 3                     | 0                        |
    | EDSK-511       | 4                     | 0                        |

    # Set the 'base' timestamp for all EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And   the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_CFS_ITP_2020-08-01.docx            | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_COLLEGE_2020-08-01.docx       | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_HEI_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_LA_2020-08-01.docx            | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_NMSS_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_SPI_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_TRUST_2020-08-01.docx         | 2020-06-18 12:00:00.000 |
    #
    | EDSK2021_S1_1618TRN_CFS.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1618TRN_COFG.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_COLLEGE.docx                 | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_HEI.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_ITP.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_LA.docx                      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_NMSS.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_SPI.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_AEB_CFS.docx                        | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_AEB_COFG.docx                       | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_APPS_COLLEGE.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_APPS_OTHER.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_LOANS_CFS.docx                      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-06-18 12:00:00.000 |
    #
    | EDSK2021_S2_1618TRN_CFS.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_1618TRN_COFG.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_1619ED_CFS.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_1619ED_COFG.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_AEB_CFS.docx                        | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_AEB_COFG.docx                       | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_APPS_COLLEGE.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_APPS_OTHER.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_LOANS_CFS_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    #
    | EDSK2021_S3ON_CFS_ITP_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_COLLEGE_2020-08-01.docx      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_LA_TRUST_HEI_2020-08-01.docx | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_NMSS_2020-08-01.docx         | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_SPI_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    #
    | FA_EDSK2021_2020-08-01.docx                     | 2020-06-18 12:00:00.000 |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017511' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017511 Co Ltd' with UKPRN '10017511' and OrgId 'ORG0017511' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017511' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017511 | 117511 | 10017511 Co Ltd | 0              | Active                | Yes           | AA017511      | ?             | 9 Quarter Gate         | South Woodham Ferrers  | ?                      | ?                      | Chelmsford             | Essex                  | CM3 5GT   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017511 |




    # Change the date (This is after all the template timestamps)
    Given the override date is '20/06/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription    | ContractType                        | Period | CRMIntent    | OrgId      |
    | 10017511 | 10017511 Co Ltd      | ESFA-511             | EDSK-511       | 1                     | 01/08/2020        | 31/07/2021      | 21065.00      |                        | Conditions of Funding (Grant) (HEI) | 2021   | New          | ORG0017511 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName    | UoPCode    | AllocationDescription   | CRMIntent    | DeliveryOrg |
    | 10017511 | EDSK-511       | ALLF-511      | ALLF              | ALLF2021                | AY                      | 01/08/2020          | 31/07/2021        | 21065.00        |            |            |                         | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription            | CRMIntent    | DeliveryOrg |
    | 10017511 | EDSK-511       | ALLF-511      | 5               | 0                     | 21065.00  | 15550.00  | 5515.00   | 2110.00  | 3098.00  | 133.00   | 2609.00  | 2584.00  | 1675.00  | 702.00   | 2639.00  | 529.00   | 1423.00  | 2441.00  | 1122.00  | Advanced Learner Loans Facility   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

     # Insert/Update details into the ContractManagement.CreatedContract table
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-511       | 1                     | 0                        | 2020-06-20 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-511' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-511'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-511' and actual ContractNumber 'EDSK-511'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-511' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017511 | EDSK-511           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017511 | ESFA-511           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'EDSK-511'




    # Amend contract adding an allocation for 16-18 Traineeships and STFIC
    
    # Change the date (This is ignored when creating ContractManagement.CreatedContract details for v2)
    Given the override date is '01/07/2020'

    # Bulk file - variation amendment
    And   there are no files prefixed '10017511' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 22062020140541 v3_A511' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 22062020140541 v3_A511' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 22062020140541 v3_A511' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 22062020140541 v3_A511' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 22062020140541 v3_A511.xlsx' exists in the Datafiles folder and UKPRN '10017511' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017511' for FundingType 'EDSK' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017511' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices. 
    #   Should include Summary of Funding plus the Schedule 1, Schedule 2 and Funding Agreement for 16-18 Traineeships 
    Then  the file named '10017511_EDSK-511_v2.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017511 Co Ltd UKPRN: 10017511
    Master Contract Number: ESFA-511
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    Advanced Learner Loans Facility ALLF-511 £15,550 £5,515 £21,065
    ESFA AEB - Short Term Funding Initiatives [AllocRef_STFC] £125,139 £43,950 £169,089
    of which Short Term Funding Initiative 1 £43,311 £8,646 £51,957
    of which Short Term Funding Initiative 2 £22,581 £10,207 £32,788
    of which Short Term Funding Initiative 3 £29,927 £11,767 £41,694
    of which Short Term Funding Initiative 4 £29,320 £13,330 £42,650
    16 to 18 Traineeships [AllocRef_16TR] £56,461 £19,324 £75,785
    Total Funding for this contract: £265,939
    Summary of Funding – Page 1

    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 1
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 7

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2020) – Page 1
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2020) – Page 6

    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
    EDSK Schedule 2 – ESFA-Funded Adult Education Budget Version 1 (July 2020) – Page 1

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Short Term Funding Initiatives
    Provider: 10017511 Co Ltd UKPRN: 10017511
    Master Contract Number: ESFA-511 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_STFC]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    Short Term Funding Initiative 1 £51,957 £2,204 £7,862 £6,790 £7,894 £4,582 £6,567 £6,450 £962 £1,525 £1,949 £675 £4,497
    Short Term Funding Initiative 2 £32,788 £6,822 £5,686 £3,255 £485 £845 £3,988 £400 £1,100 £3,223 £4,805 £60 £2,119
    Short Term Funding Initiative 3 £41,694 £166 £6,026 £2,236 £5,654 £5,463 £1,812 £6,928 £1,642 £7,437 £113 £4,072 £145
    Short Term Funding Initiative 4 £42,650 £1,864 £930 £3,733 £3,276 £6,758 £2,151 £5,909 £4,699 £4,105 £5,888 £538 £2,799
    Total Funding £169,089 £11,056 £20,504 £16,014 £17,309 £17,648 £14,518 £19,687 £8,403 £16,290 £12,755 £5,345 £9,560
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_STFC] – Page 1 Ref (for internal use only):  EDSK-511 v2
    
    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS
    EDSK Schedule 2 – 16 to 18 Traineeships Version 1 (July 2020) – Page 1

    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017511 Co Ltd UKPRN: 10017511
    Master Contract Number: ESFA-511 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    16 to 18 Traineeships Programme Funding £31,777 £2,596 £844 £3,987 £2,511 £1,099 £3,222 £4,804 £2,171 £2,118 £165 £6,025 £2,235
    16 to 18 Traineeships Bursary Funding £44,008 £5,653 £7,574 £1,811 £6,927 £1,641 £7,437 £112 £4,072 £2,256 £1,864 £929 £3,732
    Total Funding £75,785 £8,249 £8,418 £5,798 £9,438 £2,740 £10,659 £4,916 £6,243 £4,374 £2,029 £6,954 £5,967
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  EDSK-511 v2
    """

    # There should not be a TAC doc for CoFG(HEI)
    And   the pdf file does not contain the following text
    """
    EDSK Version 3 (September 2020) Page 1
    """

    # There should not be a Loans Sch 1 doc for CoFG
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (July 2020) – Page 1
    """

    # There should not be a Loans Sch 2 doc for CoFG
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (May 2020) – Page 1
    """

    # There should not be a Sch 3ON doc for CoFG(HEI)
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 3 Version 2 (July 2020) – Page 1
    """

 
    # Tidy Up
    And the override date is reset
                  
@AcceptanceTest @Withdrawn20231002
Scenario: A512 Create and approve a 2021EDSK contract with ALLF and 16-18TRN allocs. Roll forward template timestamps for Sch1 and Sch2 of 16-18TRN. Bulk amend ALLF financials. Check which document parts are created
    Given there are no allocations marked as Under Termination for UKPRN '10017512' 
    And   there are no terminated or closed allocations for UKPRN '10017512' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017512' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017512' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-512      |
    | ALLF-512      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-512      |
    | ALLF-512      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLF2021          |
    | 16-18TRN2021      |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-512       | 1                     | 0                        |
    | EDSK-512       | 2                     | 0                        |

    # Set the 'base' timestamp for all EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And   the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_CFS_ITP_2020-08-01.docx            | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_COLLEGE_2020-08-01.docx       | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_HEI_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_LA_2020-08-01.docx            | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_NMSS_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_SPI_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_TRUST_2020-08-01.docx         | 2020-06-18 12:00:00.000 |
    #
    | EDSK2021_S1_1618TRN_CFS.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1618TRN_COFG.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_COLLEGE.docx                 | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_HEI.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_ITP.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_LA.docx                      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_NMSS.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_SPI.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_AEB_CFS.docx                        | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_AEB_COFG.docx                       | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_APPS_COLLEGE.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_APPS_OTHER.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_LOANS_CFS.docx                      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-06-18 12:00:00.000 |
    #
    | EDSK2021_S2_1618TRN_CFS.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_1618TRN_COFG.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_1619ED_CFS.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_1619ED_COFG.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_AEB_CFS.docx                        | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_AEB_COFG.docx                       | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_APPS_COLLEGE.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_APPS_OTHER.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_LOANS_CFS_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    #
    | EDSK2021_S3ON_CFS_ITP_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_COLLEGE_2020-08-01.docx      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_LA_TRUST_HEI_2020-08-01.docx | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_NMSS_2020-08-01.docx         | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_SPI_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    #
    | FA_EDSK2021_2020-08-01.docx                     | 2020-06-18 12:00:00.000 |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017512' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017512 Co Ltd' with UKPRN '10017512' and OrgId 'ORG0017512' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017512' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017512 | 117512 | 10017512 Co Ltd | 0              | Active                | Yes           | AA017512      | ?             | 55 Fountain Place      | Loanhead               | Midlothian             | ?                      | ?                      | ?                      | EH20 9DT  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017512 |




    # Change the date
    Given the override date is '20/06/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription   | ContractType                        | Period | CRMIntent    | OrgId      |
    | 10017512 | 10017512 Co Ltd      | ESFA-512             | EDSK-512       | 1                     | 01/08/2020        | 31/07/2021      | 66227.00      |                       | Conditions of Funding (Grant) (LA)  | 2021   | New          | ORG0017512 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName    | UoPCode    | AllocationDescription  | CRMIntent    | DeliveryOrg |
    | 10017512 | EDSK-512       | 16TR-512      | 16-18TRN          | 16-18TRN2021            | AY                      | 01/08/2020          | 31/07/2021        | 48523.00        |            |            |                        | New          |             |
    | 10017512 | EDSK-512       | ALLF-512      | ALLF              | ALLF2021                | AY                      | 01/08/2020          | 31/07/2021        | 17704.00        |            |            |                        | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                  | CRMIntent    | DeliveryOrg |
    | 10017512 | EDSK-512       | 16TR-512      | 1               | 0                     | 48523.00  | 29850.00  | 18673.00  | 4280.00  | 4898.00  | 4028.00  | 2936.00  | 1529.00  | 4770.00  | 2447.00  | 4962.00  | 3836.00  | 4265.00  | 5926.00  | 4646.00  | Total 16-18 Traineeships Funding        | New          |             | 
    | 10017512 | EDSK-512       | 16TR-512      | 2               | 1                     | 28001.00  | 17910.00  | 10091.00  | 835.00   | 3311.00  | 3286.00  | 2377.00  | 1404.00  | 3341.00  | 1231.00  | 2125.00  | 3143.00  | 1823.00  | 3064.00  | 2061.00  | 16-18 Traineeships Programme Funding    | New          |             | 
    | 10017512 | EDSK-512       | 16TR-512      | 3               | 1                     | 20522.00  | 11940.00  | 8582.00   | 3445.00  | 1587.00  | 742.00   | 559.00   | 125.00   | 1429.00  | 1216.00  | 2837.00  | 693.00   | 2442.00  | 2862.00  | 2585.00  | 16-18 Traineeships Bursary Funding      | New          |             | 
    | 10017512 | EDSK-512       | ALLF-512      | 5               | 0                     | 17704.00  | 13185.00  | 4519.00   | 1586.00  | 1813.00  | 2866.00  | 691.00   | 795.00   | 1467.00  | 2169.00  | 1798.00  | 192.00   | 1309.00  | 2643.00  | 375.00   | Advanced Learner Loans Facility         | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-512       | 1                     | 0                        | 2020-06-20 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-512' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-512'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-512' and actual ContractNumber 'EDSK-512'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-512' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017512 | EDSK-512           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017512 | ESFA-512           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '84' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '84' deliverable period rows in CRM linked to the latest version of contract 'EDSK-512'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
   #| ALLF-512        | 0000000          | Jul-21 |                |
    | 16TR-512        | 2201300          | Jul-21 | Reconciliation |



    
    # Update timestamps on S1 and S2 1618TRN templates
    
    # Change the date
    Given the override date is '21/06/2020'
    
    # Set the 16-18TRN Sch1 and Sch2 template timestamps to a point after contract v1 was created
    #   (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And   the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_S1_1618TRN_CFS.docx                    | 2020-06-21 12:33:17.000 |
    | EDSK2021_S1_1618TRN_COFG.docx                   | 2020-06-21 12:33:17.000 |
    | EDSK2021_S2_1618TRN_CFS.docx                    | 2020-06-21 12:33:17.000 |
    | EDSK2021_S2_1618TRN_COFG.docx                   | 2020-06-21 12:33:17.000 |




    # Amend financials on ALLF allocation
    
    # Change the date (This is ignored when creating ContractManagement.CreatedContract details for v2)
    Given the override date is '23/06/2020'

    # Bulk variation amendment 
    And   there are no files prefixed '10017512' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 23062020094150 v3_A512' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 23062020094150 v3_A512' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 23062020094150 v3_A512' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 23062020094150 v3_A512' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 23062020094150 v3_A512.xlsx' exists in the Datafiles folder and UKPRN '10017512' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017512' for FundingType 'EDSK' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017512' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices
    #   Should include Summary of Funding, 16-18 Traineeships Schedule 1, Loans Facility Funding Agreement and 16-18 Traineeships Schedule 2
   #Then  the file named '10017512_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    Then  the file named '10017512_EDSK-512_v2.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017512 Co Ltd UKPRN: 10017512
    Master Contract Number: ESFA-512
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    Advanced Learner Loans Facility ALLF-512 £16,934 £6,636 £23,570
    16 to 18 Traineeships 16TR-512 £29,850 £18,673 £48,523
    Total Funding for this contract: £72,093
    Summary of Funding – Page 1
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2020) – Page 1
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017512 Co Ltd UKPRN: 10017512
    Master Contract Number: ESFA-512 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: ALLF-512
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    Advanced Learner Loans Facility £23,570 £2,937 £1,186 £1,218 £2,852 £1,441 £3,564 £1,223 £2,513 £2,460 £507 £1,092 £2,577
    Total Funding £23,570 £2,937 £1,186 £1,218 £2,852 £1,441 £3,564 £1,223 £2,513 £2,460 £507 £1,092 £2,577
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLF-512 – Page 1 Ref (for internal use only):  EDSK-512 v2
    
    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS
    EDSK Schedule 2 – 16 to 18 Traineeships Version 1 (July 2020) – Page 1
    """

    # There should not be a TAC doc for CoFG(LA)
    And   the pdf file does not contain the following text
    """
    EDSK Version 3 (September 2020) Page 1
    """

    # There should not be a Loans Sch 1 doc for CoFG
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (July 2020) – Page 1
    """

    # There should not be a Loans Sch 2 doc for CoFG
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (May 2020) – Page 1
    """

    # There should not be a Sch 3ON doc
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 3 Version 2 (July 2020) – Page 1
    """


    # Tidy Up
    And the override date is reset
   
@AcceptanceTest @Withdrawn20231002
Scenario: A513 Create and approve a 2021EDSK contract with an ALLF alloc. Roll forward template timestamps for all bar Loans Sch2 templates. Bulk amend to add allocs for 1619ED, APPS, 16-18TRN, AEBC-19TRN and AEBC-ASCL. Check which document parts are created
    Given there are no allocations marked as Under Termination for UKPRN '10017513' 
    And   there are no terminated or closed allocations for UKPRN '10017513' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017513' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017513' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLF-513      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ALLF-513      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP          |
    | ALLF2021     |
    | 16-18TRN2021 |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-513       | 1                     | 0                        |
    | EDSK-513       | 2                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017513'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017513' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017513 Co Ltd' with UKPRN '10017513' and OrgId 'ORG0017513' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017513' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017513 | 117513 | 10017513 Co Ltd | 0              | Active                | Yes           | AA017513      | ?             | 9 Quarter Gate         | South Woodham Ferrers  | ?                      | ?                      | Chelmsford             | Essex                  | CM3 5GT   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017513 |




    # Change the date 
    Given the override date is '20/06/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription    | ContractType                        | Period | CRMIntent    | OrgId      |
    | 10017513 | 10017513 Co Ltd      | ESFA-513             | EDSK-513       | 1                     | 01/08/2020        | 31/07/2021      | 21065.00      |                        | Conditions of Funding (Grant) (LA)  | 2021   | New          | ORG0017513 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName    | UoPCode    | AllocationDescription   | CRMIntent    | DeliveryOrg |
    | 10017513 | EDSK-513       | ALLF-513      | ALLF              | ALLF2021                | AY                      | 01/08/2020          | 31/07/2021        | 21065.00        |            |            |                         | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription            | CRMIntent    | DeliveryOrg |
    | 10017513 | EDSK-513       | ALLF-513      | 5               | 0                     | 21065.00  | 15550.00  | 5515.00   | 2110.00  | 3098.00  | 133.00   | 2609.00  | 2584.00  | 1675.00  | 702.00   | 2639.00  | 529.00   | 1423.00  | 2441.00  | 1122.00  | Advanced Learner Loans Facility   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

     # Upsert details in the ContractManagement.CreatedContract table
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-513       | 1                     | 0                        | 2020-06-20 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-513' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-513'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-513' and actual ContractNumber 'EDSK-513'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-513' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017513 | EDSK-513           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017513 | ESFA-513           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'EDSK-513'




    # Update template timestamps
    
    # Change the date
    Given the override date is '22/06/2020'
    
    # Update the timestamp timestamps for all EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    #   ALLF template timestamps to be set to a date\time before the creation of v1
    And   the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_CFS_ITP_2020-08-01.docx            | 2020-06-22 09:15:30.000 |
    | EDSK2021_TAC_COFG_COLLEGE_2020-08-01.docx       | 2020-06-22 09:15:30.000 |
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-06-22 09:15:30.000 |
    | EDSK2021_TAC_COFG_HEI_2020-08-01.docx           | 2020-06-22 09:15:30.000 |
    | EDSK2021_TAC_COFG_LA_2020-08-01.docx            | 2020-06-22 09:15:30.000 |
    | EDSK2021_TAC_COFG_NMSS_2020-08-01.docx          | 2020-06-22 09:15:30.000 |
    | EDSK2021_TAC_COFG_SPI_2020-08-01.docx           | 2020-06-22 09:15:30.000 |
    | EDSK2021_TAC_COFG_TRUST_2020-08-01.docx         | 2020-06-22 09:15:30.000 |
    #
    | EDSK2021_S1_1618TRN_CFS.docx                    | 2020-06-22 09:15:30.000 |
    | EDSK2021_S1_1618TRN_COFG.docx                   | 2020-06-22 09:15:30.000 |
    | EDSK2021_S1_1619ED_COLLEGE.docx                 | 2020-06-22 09:15:30.000 |
    | EDSK2021_S1_1619ED_HEI.docx                     | 2020-06-22 09:15:30.000 |
    | EDSK2021_S1_1619ED_ITP.docx                     | 2020-06-22 09:15:30.000 |
    | EDSK2021_S1_1619ED_LA.docx                      | 2020-06-22 09:15:30.000 |
    | EDSK2021_S1_1619ED_NMSS.docx                    | 2020-06-22 09:15:30.000 |
    | EDSK2021_S1_1619ED_SPI.docx                     | 2020-06-22 09:15:30.000 |
    | EDSK2021_S1_AEB_CFS.docx                        | 2020-06-22 09:15:30.000 |
    | EDSK2021_S1_AEB_COFG.docx                       | 2020-06-22 09:15:30.000 |
    | EDSK2021_S1_APPS_COLLEGE.docx                   | 2020-06-22 09:15:30.000 |
    | EDSK2021_S1_APPS_OTHER.docx                     | 2020-06-22 09:15:30.000 |
    | EDSK2021_S1_LOANS_CFS.docx                      | 2020-06-22 09:15:30.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-06-22 09:15:30.000 |
    #
    | EDSK2021_S2_1618TRN_CFS.docx                    | 2020-06-22 09:15:30.000 |
    | EDSK2021_S2_1618TRN_COFG.docx                   | 2020-06-22 09:15:30.000 |
    | EDSK2021_S2_1619ED_CFS.docx                     | 2020-06-22 09:15:30.000 |
    | EDSK2021_S2_1619ED_COFG.docx                    | 2020-06-22 09:15:30.000 |
    | EDSK2021_S2_AEB_CFS.docx                        | 2020-06-22 09:15:30.000 |
    | EDSK2021_S2_AEB_COFG.docx                       | 2020-06-22 09:15:30.000 |
    | EDSK2021_S2_APPS_COLLEGE.docx                   | 2020-06-22 09:15:30.000 |
    | EDSK2021_S2_APPS_OTHER.docx                     | 2020-06-22 09:15:30.000 |
    | EDSK2021_S2_LOANS_CFS_2020-08-01.docx           | 2020-05-11 22:33:44.000 |
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-05-11 22:33:44.000 |
    #
    | EDSK2021_S3ON_CFS_ITP_2020-08-01.docx           | 2020-06-22 09:15:30.000 |
    | EDSK2021_S3ON_COFG_COLLEGE_2020-08-01.docx      | 2020-06-22 09:15:30.000 |
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-06-22 09:15:30.000 |
    | EDSK2021_S3ON_COFG_LA_TRUST_HEI_2020-08-01.docx | 2020-06-22 09:15:30.000 |
    | EDSK2021_S3ON_COFG_NMSS_2020-08-01.docx         | 2020-06-22 09:15:30.000 |
    | EDSK2021_S3ON_COFG_SPI_2020-08-01.docx          | 2020-06-22 09:15:30.000 |
    #
    | FA_EDSK2021_2020-08-01.docx                     | 2020-06-22 09:15:30.000 |




    # Amend contract adding allocs for 1619ED, APPS, 16-18TRN, AEBC-19TRN and AEBC-ASCL

    # Upsert the provider config values for Sector-based Work Academies for a specific UKPRN and FSP (DocumentsDomain.ContractReferenceConfig) (30680)
    Given the following Sector-based Work Academies profile values exist in config
    | UKPRN    | FSPCode       | Aug20-Mar21 | Apr21-Jul21 |
    | 10017513 | AEBC-ASCL2021 | 5000.00     | 1000.00     |

    
    # Change the date (This is ignored when creating ContractManagement.CreatedContract details for v2)
    Given the override date is '01/07/2020'

    # Bulk file - variation amendment
    And   there are no files prefixed '10017513' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 23062020121637 v3_A513' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 23062020121637 v3_A513' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 23062020121637 v3_A513' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 23062020121637 v3_A513' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 23062020121637 v3_A513.xlsx' exists in the Datafiles folder and UKPRN '10017513' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017513' for FundingType 'EDSK' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017513' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices. 
    # Should include a Summary of Funding, a TAC then
    #         Schedule 1 SPECIFICATION & MONITORING for Loans, AEB, APPS, 16-18TR and 16-19ED then
    #         Schedule 2 PAYMENT for AEB plus FA for 16-19TRN and ASCL then
    #         Schedule 2 PAYMENT for APPS plus FA then
    #         Schedule 2 PAYMENT for 16-18 Traineeships plus FA then
    #         Schedule 2 PAYMENT for 16-19 Education plus FA then
    #         Schedule 3 onwards   
    Then  the file named '10017513_EDSK-513_v2.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017513 Co Ltd UKPRN: 10017513
    Master Contract Number: ESFA-513
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    Advanced Learner Loans Facility ALLF-513 £15,550 £5,515 £21,065
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AECT] £37,829 £19,493 £57,322
    ESFA AEB - Adult Skills and Community Learning [AllocRef_AECA] £62,606 £23,450 £86,056
    of which Community Learning £31,404 £13,359 £44,763
    of which Sector-based Work Academies £5,000 £1,000 £6,000
    Apprenticeships Carry-In [AllocRef_APPS] £30,180 £11,692 £41,872
    16 to 18 Traineeships [AllocRef_16TR] £60,957 £33,745 £94,702
    16 to 19 Education [AllocRef_16ED] £23,376 £17,098 £40,474
    Total Funding for this contract: £341,490
    Summary of Funding – Page 1

    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    EDSK Version 3 (September 2020) Page 1
    EDSK Version 3 (September 2020) Page 73

    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (July 2020) – Page 1
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (July 2020) – Page 8

    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 1
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 7

    SCHEDULE 1: SPECIFICATION & MONITORING
    APPRENTICESHIPS CARRY-IN SPECIFICATION
    EDSK Schedule 1 – Apprenticeships Carry-In Version 1 (July 2020) – Page 1
    EDSK Schedule 1 – Apprenticeships Carry-In Version 1 (July 2020) – Page 7

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2020) – Page 1
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2020) – Page 6

    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 3 LA (June 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 3 LA (June 2021) – Page 12

    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
    EDSK Schedule 2 – ESFA-Funded Adult Education Budget Version 1 (July 2020) – Page 1

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: 10017513 Co Ltd UKPRN: 10017513
    Master Contract Number: ESFA-513 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_AECT]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - 19 to 24 Traineeships £57,322 £6,105 £4,831 £701 £5,138 £1,890 £7,411 £6,752 £5,001 £192 £6,667 £5,255 £7,379
    Total Funding £57,322 £6,105 £4,831 £701 £5,138 £1,890 £7,411 £6,752 £5,001 £192 £6,667 £5,255 £7,379
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECT] – Page 1 Ref (for internal use only):  EDSK-513 v2
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning
    Provider: 10017513 Co Ltd UKPRN: 10017513
    Master Contract Number: ESFA-513 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_AECA]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - Adult Skills and Community Learning £86,056 £9,005 £10,332 £8,464 £6,118 £3,093 £10,057 £13,018 £2,519 £8,050 £8,973 £4,588 £1,839
    of which Community Learning £44,763 £2,157 £6,116 £4,301 £3,908 £2,974 £5,777 £5,320 £851 £4,195 £7,952 £903 £309
    Total Funding £86,056 £9,005 £10,332 £8,464 £6,118 £3,093 £10,057 £13,018 £2,519 £8,050 £8,973 £4,588 £1,839
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECA] – Page 1 Ref (for internal use only):  EDSK-513 v2

    SCHEDULE 2: PAYMENT
    APPRENTICESHIPS CARRY-IN
    EDSK Schedule 2 – Apprenticeships Carry-In Version 1 (July 2020) – Page 1

    SCHEDULE 2 – APPRENTICESHIPS CARRY-IN
    Funding Agreement – Apprenticeships Carry-In
    Provider: 10017513 Co Ltd UKPRN: 10017513
    Master Contract Number: ESFA-513 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    Apprenticeships Carry-In £41,872 £6,923 £1,774 £1,318 £4,800 £2,305 £3,950 £4,852 £4,258 £6,041 £691 £840 £4,120
    Total Funding £41,872 £6,923 £1,774 £1,318 £4,800 £2,305 £3,950 £4,852 £4,258 £6,041 £691 £840 £4,120
    Schedule 2 – Apprenticeships Carry-In – Funding Agreement [AllocRef_APPS] – Page 1 Ref (for internal use only):  EDSK-513 v2

    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS
    EDSK Schedule 2 – 16 to 18 Traineeships Version 1 (July 2020) – Page 1

    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017513 Co Ltd UKPRN: 10017513
    Master Contract Number: ESFA-513 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    16 to 18 Traineeships Programme Funding £57,789 £5,204 £6,648 £2,317 £7,359 £3,910 £6,308 £3,336 £4,302 £7,242 £533 £6,870 £3,760
    16 to 18 Traineeships Bursary Funding £36,913 £3,028 £3,113 £2,858 £3,623 £1,330 £258 £1,362 £6,001 £2,147 £7,869 £2,381 £2,943
    Total Funding £94,702 £8,232 £9,761 £5,175 £10,982 £5,240 £6,566 £4,698 £10,303 £9,389 £8,402 £9,251 £6,703
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  EDSK-513 v2

    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2020) – Page 1

    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: 10017513 Co Ltd UKPRN: 10017513
    Master Contract Number: ESFA-513 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    16-19 Resource Management (16-19) £15,100 £125.88 £0.00 £0.00 £1,912.82 £504.67 £0.00 £1,753.18 £4,788.81 £842.20 £1,735.42 £3,163.29 £274.04
    16-19 Advanced Maths Premium £10,593 -£178.83 £980.38 £0.00 £366.49 £101.65 £0.00 £4,015.01 £1,297.19 £0.00 £1,529.52 £0.00 £2,481.94
    16-19 High Value Courses Premium £14,780 -£13.55 £3,575.59 £0.00 £0.00 £2,445.81 £1,249.27 £0.00 £451.70 £0.00 £3,816.66 £3,254.74 £0.00
    Total Funding £40,474 -£66.50 £4,555.97 £0.00 £2,279.31 £3,052.13 £1,249.27 £5,768.19 £6,537.70 £842.20 £7,081.60 £6,418.03 £2,755.98
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  EDSK-513 v2

    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2020) – Page 1
    """



    # Should not include a Schedule 2 or FA for Loans (because their templates didn't change)
    
    # There should not be a Sch2 for ALLF for CoFG(LA)
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (May 2020) – Page 1
    """

    # There should not be a Funding Agreement for Loans
    And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """


    # Tidy Up
    Given the override date is reset

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017513'

@AcceptanceTest @Withdrawn20231002
Scenario: A514 Create and approve a 2021EDSK contract with 16-18TRN (PoA), AEBC-19TRN (PoP) and AEBC-CSO2021 (PoP) allocs. Consume actuals. Generate PoP and PoA payments. Check CRM, financials, feed and CDA
    Given there are no allocations marked as Under Termination for UKPRN '10017514' 
    And   there are no terminated or closed allocations for UKPRN '10017514' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017514' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017514' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-514      |
    | AECT-514      |
    | AECS-514      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-514      |
    | AECT-514      |
    | AECS-514      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | 16-18TRN2021   |
    | AEBC-19TRN2021 |
    | AEBC-CSO2021   |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-514       | 1                     | 0                        |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017514' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017514 Co Ltd' with UKPRN '10017514' and OrgId 'ORG0017514' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017514' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017514 | 117514 | 10017514 Co Ltd | 0              | Locked Restructure    | Yes           | AA017514      | ?             | 15 Princeton Mews      | 167-169 London Road    | Kingston upon Thames   | ?                      | ?                      | Surrey                 | KT2 6PT   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017514 |




    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017514 | 10017514 Co Ltd      | ESFA-514             | EDSK-514       | 1                     | 01/08/2020        | 31/07/2021      | 73672.00      |                                       | Conditions of Funding (Grant) (SPI)        | 2021   | New          | ORG0017514 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017514 | EDSK-514       | 16TR-514      | 16-18TRN          | 16-18TRN2021            | AY                      | 01/08/2020          | 31/07/2021        | 46787.00        |                                         |            |                                                             | New          |             |
    | 10017514 | EDSK-514       | AECT-514      | AEBC-19TRN        | AEBC-19TRN2021          | AY                      | 01/08/2020          | 31/07/2021        | 26885.00        |                                         |            |                                                             | New          |             |
    | 10017514 | EDSK-514       | AECS-514      | AEBC-CSO          | AEBC-CSO2021            | AY                      | 01/08/2020          | 31/07/2021        | 20440.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017514 | EDSK-514       | 16TR-514      | 1               | 0                     | 46787.00  | 34861.00  | 11926.00  | 5369.00  | 2286.00  | 5117.00  | 4025.00  | 2618.00  | 5859.00  | 7237.00  | 2350.00  | 4925.00  | 1653.00  | 3314.00  | 2034.00  | Total 16-18 Traineeships Funding                                | New          |             | 
    | 10017514 | EDSK-514       | 16TR-514      | 2               | 1                     | 21050.00  | 15743.00  | 5307.00   | 3340.00  | 2115.00  | 2090.00  | 1181.00  | 208.00   | 2145.00  | 3735.00  | 929.00   | 1947.00  | 627.00   | 1868.00  | 865.00   | 16-18 Traineeships Programme Funding                            | New          |             | 
    | 10017514 | EDSK-514       | 16TR-514      | 3               | 1                     | 25737.00  | 19118.00  | 6619.00   | 2029.00  | 171.00   | 3027.00  | 2844.00  | 2410.00  | 3714.00  | 3502.00  | 1421.00  | 2978.00  | 1026.00  | 1446.00  | 1169.00  | 16-18 Traineeships Bursary Funding                              | New          |             | 
    | 10017514 | EDSK-514       | AECT-514      | 1               | 0                     | 26885.00  | 19305.00  | 7580.00   | 2351.00  | 2578.00  | 3631.00  | 1456.00  | 1560.00  | 2232.00  | 2934.00  | 2563.00  | 958.00   | 2074.00  | 3408.00  | 1140.00  | 19-24 Traineeships Total Funding                                | New          |             | 
    | 10017514 | EDSK-514       | AECS-514      | 1               | 0                     | 20440.00  | 12666.00  | 7774.00   | 3600.00  | 887.00   | 1623.00  | 398.00   | 373.00   | 3165.00  | 2192.00  | 428.00   | 2019.00  | 2913.00  | 230.00   | 2612.00  | COVID-19 Skills Offer Total Funding                             | New          |             | 
    | 10017514 | EDSK-514       | AECS-514      | 2               | 1                     | 20440.00  | 12666.00  | 7774.00   | 3600.00  | 887.00   | 1623.00  | 398.00   | 373.00   | 3165.00  | 2192.00  | 428.00   | 2019.00  | 2913.00  | 230.00   | 2612.00  | High Value Courses for School and College Leavers Funding       | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-514' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-514'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-514' and actual ContractNumber 'EDSK-514'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-514' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017514 | EDSK-514           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017514 | ESFA-514           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '120' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '120' deliverable period rows in CRM linked to the latest version of contract 'EDSK-514'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 16TR-514        | 2201300          | Jul-21 | Reconciliation |
    | AECT-514        | 2355700          | Jul-21 | Profile        |
    | AECS-514        | 2372091          | Jul-21 | Profile        |




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/10/2020'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017514'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202008 | 16-18TRN2021            | 16TR-514                 | ?          | 2               | 0            | 1708.28     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202008 | 16-18TRN2021            | 16TR-514                 | ?          | 3               | 0            | 1981.52     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202009 | 16-18TRN2021            | 16TR-514                 | ?          | 2               | 0            | 1200.67     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202009 | 16-18TRN2021            | 16TR-514                 | ?          | 3               | 0            | 2723.52     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202010 | 16-18TRN2021            | 16TR-514                 | ?          | 2               | 0            | 2723.51     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202010 | 16-18TRN2021            | 16TR-514                 | ?          | 3               | 0            | 2939.81     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202011 | 16-18TRN2021            | 16TR-514                 | ?          | 2               | 0            | 2626.42     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202011 | 16-18TRN2021            | 16TR-514                 | ?          | 3               | 0            | 1856.99     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202012 | 16-18TRN2021            | 16TR-514                 | ?          | 2               | 0            | 2403.46     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202012 | 16-18TRN2021            | 16TR-514                 | ?          | 3               | 0            | 1971.31     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202101 | 16-18TRN2021            | 16TR-514                 | ?          | 2               | 0            | 2880.37     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202101 | 16-18TRN2021            | 16TR-514                 | ?          | 3               | 0            | 2862.28     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202102 | 16-18TRN2021            | 16TR-514                 | ?          | 2               | 0            | 1398.66     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202102 | 16-18TRN2021            | 16TR-514                 | ?          | 3               | 0            | 1765.06     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202103 | 16-18TRN2021            | 16TR-514                 | ?          | 2               | 0            | 2473.54     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202103 | 16-18TRN2021            | 16TR-514                 | ?          | 3               | 0            | 971.97      |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202104 | 16-18TRN2021            | 16TR-514                 | ?          | 2               | 0            | 1214.38     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202104 | 16-18TRN2021            | 16TR-514                 | ?          | 3               | 0            | 2445.90     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202105 | 16-18TRN2021            | 16TR-514                 | ?          | 2               | 0            | 2859.56     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202105 | 16-18TRN2021            | 16TR-514                 | ?          | 3               | 0            | 2090.85     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202106 | 16-18TRN2021            | 16TR-514                 | ?          | 2               | 0            | 2839.53     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202106 | 16-18TRN2021            | 16TR-514                 | ?          | 3               | 0            | 1187.72     |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202107 | 16-18TRN2021            | 16TR-514                 | ?          | 2               | 0            | 844.82      |
    | ILR2021        | R02                  | ORG0017514     | CM             | 202107 | 16-18TRN2021            | 16TR-514                 | ?          | 3               | 0            | 1315.27     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


    # Check CRM and PaaS

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-514       | 16TR-514           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-514       | 16TR-514           | 2               | 2908.95   | 1708.28  | 1200.67  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-514       | 16TR-514           | 3               | 4705.04   | 1981.52  | 2723.52  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-514       | 16TR-514           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-514       | 16TR-514           | 2               | 2908.95   | 0.00     | 2908.95  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-514       | 16TR-514           | 3               | 4705.04   | 0.00     | 4705.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-514       | 16TR-514           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-514       | 16TR-514           | 2               | 2908.95   | 0.00     | 2908.95  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-514       | 16TR-514           | 3               | 4705.04   | 0.00     | 4705.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-514       | AECS-514           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-514       | AECS-514           | 2               | 20440.00  | 3600.00  | 887.00   | 1623.00  | 398.00   | 373.00   | 3165.00  | 2192.00  | 428.00   | 2019.00  | 2913.00  | 230.00   | 2612.00  | 
    | EDSK-514       | AECS-514           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-514       | AECS-514           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-514       | AECT-514           | 1               | 26885.00  | 2351.00  | 2578.00  | 3631.00  | 1456.00  | 1560.00  | 2232.00  | 2934.00  | 2563.00  | 958.00   | 2074.00  | 3408.00  | 1140.00  | 
    | EDSK-514       | AECT-514           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-514       | AECT-514           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-514       | AECT-514           | 1               | 26885.00  | 2351.00  | 2578.00  | 3631.00  | 1456.00  | 1560.00  | 2232.00  | 2934.00  | 2563.00  | 958.00   | 2074.00  | 3408.00  | 1140.00  | 
    | EDSK-514       | AECT-514           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-514       | AECT-514           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-514       | AECS-514           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-514       | AECS-514           | 2               | 20440.00  | 3600.00  | 887.00   | 1623.00  | 398.00   | 373.00   | 3165.00  | 2192.00  | 428.00   | 2019.00  | 2913.00  | 230.00   | 2612.00  | 
    | EDSK-514       | AECS-514           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-514       | AECS-514           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the RECONCILIATION subnominal aggregations in PaaS for Sep-20
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017514 | ORG0017514 | 16TR-514          | 2201300         | 16-18TRN2021               | 202009               | RECONCILIATION  | CM             | False       | 2908.95         |
    | 10017514 | ORG0017514 | 16TR-514          | 2201350         | 16-18TRN2021               | 202009               | RECONCILIATION  | CM             | False       | 4705.04         |
   
    # Check the PROFILE subnominal aggregations in PaaS
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017514 | ORG0017514 | AECT-514          | 2355700         | AEBC-19TRN2021             | 202008               | PROFILE         | CM             | False       | 2351.00         |
    | 10017514 | ORG0017514 | AECT-514          | 2355700         | AEBC-19TRN2021             | 202009               | PROFILE         | CM             | False       | 2578.00         |
    | 10017514 | ORG0017514 | AECT-514          | 2355700         | AEBC-19TRN2021             | 202010               | PROFILE         | CM             | False       | 3631.00         |
    | 10017514 | ORG0017514 | AECT-514          | 2355700         | AEBC-19TRN2021             | 202011               | PROFILE         | CM             | False       | 1456.00         |
    | 10017514 | ORG0017514 | AECT-514          | 2355700         | AEBC-19TRN2021             | 202012               | PROFILE         | CM             | False       | 1560.00         |
    | 10017514 | ORG0017514 | AECT-514          | 2355700         | AEBC-19TRN2021             | 202101               | PROFILE         | CM             | False       | 2232.00         |
    | 10017514 | ORG0017514 | AECT-514          | 2355700         | AEBC-19TRN2021             | 202102               | PROFILE         | CM             | False       | 2934.00         |
    | 10017514 | ORG0017514 | AECT-514          | 2355700         | AEBC-19TRN2021             | 202103               | PROFILE         | CM             | False       | 2563.00         |
    | 10017514 | ORG0017514 | AECT-514          | 2355700         | AEBC-19TRN2021             | 202104               | PROFILE         | CM             | False       | 958.00          |
    | 10017514 | ORG0017514 | AECT-514          | 2355700         | AEBC-19TRN2021             | 202105               | PROFILE         | CM             | False       | 2074.00         |
    | 10017514 | ORG0017514 | AECT-514          | 2355700         | AEBC-19TRN2021             | 202106               | PROFILE         | CM             | False       | 3408.00         |
    | 10017514 | ORG0017514 | AECT-514          | 2355700         | AEBC-19TRN2021             | 202107               | PROFILE         | CM             | False       | 1140.00         |
    #
    | 10017514 | ORG0017514 | AECS-514          | 2372091         | AEBC-CSO2021               | 202008               | PROFILE         | CM             | False       | 3600.00         |
    | 10017514 | ORG0017514 | AECS-514          | 2372091         | AEBC-CSO2021               | 202009               | PROFILE         | CM             | False       | 887.00          |
    | 10017514 | ORG0017514 | AECS-514          | 2372091         | AEBC-CSO2021               | 202010               | PROFILE         | CM             | False       | 1623.00         |
    | 10017514 | ORG0017514 | AECS-514          | 2372091         | AEBC-CSO2021               | 202011               | PROFILE         | CM             | False       | 398.00          |
    | 10017514 | ORG0017514 | AECS-514          | 2372091         | AEBC-CSO2021               | 202012               | PROFILE         | CM             | False       | 373.00          |
    | 10017514 | ORG0017514 | AECS-514          | 2372091         | AEBC-CSO2021               | 202101               | PROFILE         | CM             | False       | 3165.00         |
    | 10017514 | ORG0017514 | AECS-514          | 2372091         | AEBC-CSO2021               | 202102               | PROFILE         | CM             | False       | 2192.00         |
    | 10017514 | ORG0017514 | AECS-514          | 2372091         | AEBC-CSO2021               | 202103               | PROFILE         | CM             | False       | 428.00          |
    | 10017514 | ORG0017514 | AECS-514          | 2372091         | AEBC-CSO2021               | 202104               | PROFILE         | CM             | False       | 2019.00         |
    | 10017514 | ORG0017514 | AECS-514          | 2372091         | AEBC-CSO2021               | 202105               | PROFILE         | CM             | False       | 2913.00         |
    | 10017514 | ORG0017514 | AECS-514          | 2372091         | AEBC-CSO2021               | 202106               | PROFILE         | CM             | False       | 230.00          |
    | 10017514 | ORG0017514 | AECS-514          | 2372091         | AEBC-CSO2021               | 202107               | PROFILE         | CM             | False       | 2612.00         |




#    # CDA 
#
#    # Run the CDA report for 16-18TRN2021, AEBC-19TRN2021 and AEBC-CSO2021
#    Given there is no CDA report named 'CDA Latest Version A514.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | EDSK-514       | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod                      | Version               | Suffix |
#    | 16-18TRN2021,AEBC-19TRN2021,AEBC-CSO2021 | Latest Version        | A514   |
#
#    Then  a report named 'CDA Latest Version A514.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | 16-18TRN2021            | 10017514 | 10017514 Co Ltd             |               |                             | 16TR-514                 | EDSK-514       | ESFA-514                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | Total 16-18 Traineeships Funding                                | 8                 | 2020            | 2020/21       |              | 3340         | 1708.28      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201300                  | 2201300           | Aug              |
#    | 16-18TRN2021            | 10017514 | 10017514 Co Ltd             |               |                             | 16TR-514                 | EDSK-514       | ESFA-514                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | Total 16-18 Traineeships Funding                                | 8                 | 2020            | 2020/21       |              | 2029         | 1981.52      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2201350                  | 2201350           | Aug              |
#    | 16-18TRN2021            | 10017514 | 10017514 Co Ltd             |               |                             | 16TR-514                 | EDSK-514       | ESFA-514                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Bursary Funding                              | Total 16-18 Traineeships Funding                                | 9                 | 2020            | 2020/21       |              | 171          | 2723.52      |               |              | Yes                | 0.00           | 0.00             | 4705.04               | 0.00           | 4705.04         |             | No            |                   |        |                   | 2201350                  | 2201350           | Sep              |
#    | 16-18TRN2021            | 10017514 | 10017514 Co Ltd             |               |                             | 16TR-514                 | EDSK-514       | ESFA-514                | 01/08/2020                  | 31/07/2021                | 1                     | Approved       | Approved                |                                                      | 16-18 Traineeships Programme Funding                            | Total 16-18 Traineeships Funding                                | 9                 | 2020            | 2020/21       |              | 2115         | 1200.67      |               |              | Yes                | 0.00           | 0.00             | 2908.95               | 0.00           | 2908.95         |             | No            |                   |        |                   | 2201300                  | 2201300           | Sep              |




    # Payment Batch for 16-18TRN2021 (PoA)

    # Change the date
    Given the override date is '08/10/2020 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '16-18TRN2021' AccountingPaymentPeriod '202006' CensusEndDate '08/10/2020' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | 16TR-514                 | 202009 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 16-18TRN2021               | 202009               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 16-18TRN2021               | 202009               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18TRN2021' PaymentPeriod '202006' CensusEndDate '08/10/2020' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A514_PoA.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18TRN2021' PaymentPeriod '202006' CensusEndDate '08/10/2020' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | 16TR                   | 2020          | 06             | 08          | ?       | 16TR-514      | 2908.95         | RECONCILIATION   | 16-18Traineeships      | 2020-10-20 | 2020-08-01   | 2021-07-31 | ?              | 10017514 | 2201300    |
    | 16TR                   | 2020          | 06             | 08          | ?       | 16TR-514      | 4705.04         | RECONCILIATION   | 16-18TraineeshipBurs   | 2020-10-20 | 2020-08-01   | 2021-07-31 | ?              | 10017514 | 2201350    |


    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod '16-18TRN2021' AccountingPaymentPeriod '202006' and CensusEndDate '08/10/2020'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                  |
    | Payment Requests for Funding Stream Period 16-18TRN2021 for Payment Period 202006 have been generated as of Census End Date/Time 2020-10-08T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate        | PaymentLineCount | TotalValue | 
    | 16-18TRN2021        | 202006        | 2020-10-08T22:00:00Z | 2                | 7613.99    |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | 16TR      | 01/08/2020   | 31/07/2021 | 08/10/2020    | 20/10/2020 | 2020          | 06             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription   | AggregatedValue |
    | ORG0017514  | 10017514       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | 16TR-514   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2201300    | RECONCILIATION | 16-18Traineeships       | 2908.95         |
    | ORG0017514  | 10017514       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | 16TR-514   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2201350    | RECONCILIATION | 16-18TraineeshipBurs    | 4705.04         |




    # Payment Batch for AEBC-19TRN2021 (PoP) and AEBC-CSO2021 (PoP)

    # Change the date
    Given the override date is '04/12/2020 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEBC-19TRN2021' AccountingPaymentPeriod '202009' CensusEndDate '04/12/2020' and LinkCodeSuffix 'A'
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEBC-CSO2021' AccountingPaymentPeriod '202009' CensusEndDate '04/12/2020' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | AECT-514                 | 202012 |
    | AECS-514                 | 202012 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEBC-19TRN2021             | 202012               |                      | A              | NotStarted |
    | AEBC-CSO2021               | 202012               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEBC-19TRN2021             | 202012               | Completed |
    | AEBC-CSO2021               | 202012               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEBC-19TRN2021' PaymentPeriod '202009' CensusEndDate '04/12/2020' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A514_PoP_19TRN.xml'
    And   the Payment feed xml for FundingStreamPeriod 'AEBC-CSO2021' PaymentPeriod '202009' CensusEndDate '04/12/2020' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A514_PoP_CSO.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEBC-19TRN2021' PaymentPeriod '202009' CensusEndDate '04/12/2020' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AECT                   | 2020          | 09             | 04          | ?       | AECT-514      | 1560.00         | PROFILE          | 19-24TrnGrant                      | 2020-12-18 | 2020-08-01   | 2021-07-31 | ?              | 10017514 | 2355700    |

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEBC-CSO2021' PaymentPeriod '202009' CensusEndDate '04/12/2020' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AECS                   | 2020          | 09             | 04          | ?       | AECS-514      | 373.00          | PROFILE          | C19SkillsOfferGrant                | 2020-12-18 | 2020-08-01   | 2021-07-31 | ?              | 10017514 | 2372091    |



    # Retrieve data from the Payment Feed and check for specific items and values for AEBC-19TRN2021 (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'AEBC-19TRN2021' AccountingPaymentPeriod '202009' and CensusEndDate '04/12/2020'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                    |
    | Payment Requests for Funding Stream Period AEBC-19TRN2021 for Payment Period 202009 have been generated as of Census End Date/Time 2020-12-04T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | AEBC-19TRN2021      | 202009        | 2020-12-04T22:00:00Z  | 1                | 1560.00    |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | AECT      | 01/08/2020   | 31/07/2021 | 04/12/2020    | 18/12/2020 | 2020          | 09             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017514  | 10017514       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AECT-514   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355700    | PROFILE        | 19-24TrnGrant                 | 1560.00         |




    # Retrieve data from the Payment Feed and check for specific items and values for AEBC-CSO2021 (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'AEBC-CSO2021' AccountingPaymentPeriod '202009' and CensusEndDate '04/12/2020'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                  |
    | Payment Requests for Funding Stream Period AEBC-CSO2021 for Payment Period 202009 have been generated as of Census End Date/Time 2020-12-04T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | AEBC-CSO2021        | 202009        | 2020-12-04T22:00:00Z  | 1                | 373.00     |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | AECS      | 01/08/2020   | 31/07/2021 | 04/12/2020    | 18/12/2020 | 2020          | 09             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017514  | 10017514       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AECS-514   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2372091    | PROFILE        | C19SkillsOfferGrant           | 373.00         |


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
Scenario: A515 Create and approve a 2021EDSK contract with an ALLF alloc. Bulk notification amendment to add AEBC-ASCL alloc. Approve. NFA variation amendment. Withdraw. NFA notification amendment. No template timestamp changes. Check doc parts along the way
    Given there are no allocations marked as Under Termination for UKPRN '10017515' 
    And   there are no terminated or closed allocations for UKPRN '10017515' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017515' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017515' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLF-515      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ALLF-515      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP           |
    | ALLF2021      |
    | AEBC-ASCL2021 |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017515'

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-515       | 1                     | 0                        |
    | EDSK-515       | 2                     | 0                        |
    | EDSK-515       | 3                     | 0                        |

    # Set the 'base' timestamp for all EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And   the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_CFS_ITP_2020-08-01.docx            | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_COLLEGE_2020-08-01.docx       | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_HEI_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_LA_2020-08-01.docx            | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_NMSS_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_SPI_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_TRUST_2020-08-01.docx         | 2020-06-18 12:00:00.000 |
    #
    | EDSK2021_S1_1618TRN_CFS.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1618TRN_COFG.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_COLLEGE.docx                 | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_HEI.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_ITP.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_LA.docx                      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_NMSS.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_SPI.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_AEB_CFS.docx                        | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_AEB_COFG.docx                       | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_APPS_COLLEGE.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_APPS_OTHER.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_LOANS_CFS.docx                      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-06-18 12:00:00.000 |
    #
    | EDSK2021_S2_1618TRN_CFS.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_1618TRN_COFG.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_1619ED_CFS.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_1619ED_COFG.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_AEB_CFS.docx                        | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_AEB_COFG.docx                       | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_APPS_COLLEGE.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_APPS_OTHER.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_LOANS_CFS_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    #
    | EDSK2021_S3ON_CFS_ITP_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_COLLEGE_2020-08-01.docx      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_LA_TRUST_HEI_2020-08-01.docx | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_NMSS_2020-08-01.docx         | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_SPI_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    #
    | FA_EDSK2021_2020-08-01.docx                     | 2020-06-18 12:00:00.000 |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017515' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017515 Co Ltd' with UKPRN '10017515' and OrgId 'ORG0017515' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017515' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1          | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017515 | 117515 | 10017515 Co Ltd | 0              | Active                | Yes           | AA017515      | ?             | 161 William Gorth St  | South Woodham Ferrers  | ?                      | ?                      | Chelmsford             | Essex                  | CM3 5GT   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017515 |




    # Change the date (This is after all the template timestamps)
    Given the override date is '20/06/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription    | ContractType                        | Period | CRMIntent    | OrgId      |
    | 10017515 | 10017515 Co Ltd      | ESFA-515             | EDSK-515       | 1                     | 01/08/2020        | 31/07/2021      | 21065.00      |                        | Conditions of Funding (Grant) (HEI) | 2021   | New          | ORG0017515 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName    | UoPCode    | AllocationDescription   | CRMIntent    | DeliveryOrg |
    | 10017515 | EDSK-515       | ALLF-515      | ALLF              | ALLF2021                | AY                      | 01/08/2020          | 31/07/2021        | 21065.00        |            |            |                         | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription            | CRMIntent    | DeliveryOrg |
    | 10017515 | EDSK-515       | ALLF-515      | 5               | 0                     | 21065.00  | 15550.00  | 5515.00   | 2110.00  | 3098.00  | 133.00   | 2609.00  | 2584.00  | 1675.00  | 702.00   | 2639.00  | 529.00   | 1423.00  | 2441.00  | 1122.00  | Advanced Learner Loans Facility   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

     # Insert/Update details into the ContractManagement.CreatedContract table
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-515       | 1                     | 0                        | 2020-06-20 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-515' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-515'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-515' and actual ContractNumber 'EDSK-515'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-515' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017515 | EDSK-515           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017515 | ESFA-515           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'EDSK-515'




    # Amend contract adding an allocation for AEBC-ASCL
    
    # Change the date (This is ignored when creating ContractManagement.CreatedContract details for v2)
    Given the override date is '01/07/2020'

    # Upsert the provider config values for Sector-based Work Academies for a specific UKPRN and FSP (DocumentsDomain.ContractReferenceConfig) (30680)
    And   the following Sector-based Work Academies profile values exist in config
    | UKPRN    | FSPCode       | Aug20-Mar21 | Apr21-Jul21 |
    | 10017515 | AEBC-ASCL2021 | 5000.00     | 1000.00     |


    # Bulk file - Notification amendment
    And   there are no files prefixed '10017511' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 25062020092627 v3_A515' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 25062020092627 v3_A515' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 25062020092627 v3_A515' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 25062020092627 v3_A515' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 25062020092627 v3_A515.xlsx' exists in the Datafiles folder and UKPRN '10017515' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017515' for FundingType 'EDSK' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017515' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices. 
    #   Should include Summary of Funding plus the Schedule 1, Schedule 2 and Funding Agreement for AEBC-ASCL2021 
    Then  the file named '10017515_EDSK-515_v2.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017515 Co Ltd UKPRN: 10017515
    Master Contract Number: ESFA-515
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    Advanced Learner Loans Facility ALLF-515 £15,550 £5,515 £21,065
    ESFA AEB - Adult Skills and Community Learning [AllocRef_AECA] £75,770 £36,932 £112,702
    of which Community Learning £28,980 £21,560 £50,540
    of which Sector-based Work Academies £5,000 £1,000 £6,000
    Total Funding for this contract: £133,767
    Summary of Funding – Page 1

    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 1

    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
    EDSK Schedule 2 – ESFA-Funded Adult Education Budget Version 1 (July 2020) – Page 1

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECA] – Page 1 Ref (for internal use only):  EDSK-515 v2
    """

    # There should not be a TAC doc for CoFG(HEI)
    And   the pdf file does not contain the following text
    """
    EDSK Version 3 (September 2020) Page 1
    """

    # There should not be a Loans Sch 1 doc for CoFG
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (July 2020) – Page 1
    """

    # There should not be a Loans Sch 2 doc for CoFG
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (May 2020) – Page 1
    """

    # There should not be a Sch 3ON doc for CoFG(HEI)
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 3 Version 2 (July 2020) – Page 1
    """


    # Approve the contract (Note: Notification amendments only auto-approve if progressed to Published by a Task) 

    # Change the date
    Given the override date is '02/07/2020'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-515' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-515'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-515' and actual ContractNumber 'EDSK-515'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-515' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017515 | EDSK-515           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Notification  |
    | 10017515 | EDSK-515           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017515 | ESFA-515           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '108' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '108' deliverable period rows in CRM linked to the latest version of contract 'EDSK-515'




    # Execute a non-financial VARIATION amendment after first removing the Sector-based Work Academies config values

    # Change the date
    Given the override date is '03/07/2020'

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017515'

    # Issue a non-financial VARIATION amendment on v2 to create v3
   #When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'EDSK-515' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'EDSK-515' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017515 | EDSK-515           | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017515 | EDSK-515           | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | Notification  |
    | 10017515 | EDSK-515           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017515 | ESFA-515           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017515' for FundingType 'EDSK' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017515' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices. 
    #   Should include just a Summary of Funding
    Then  the file named '10017515_EDSK-515_v3.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017515 Co Ltd UKPRN: 10017515
    Master Contract Number: ESFA-515
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    Advanced Learner Loans Facility ALLF-515 £15,550 £5,515 £21,065
    ESFA AEB - Adult Skills and Community Learning [AllocRef_AECA] £75,770 £36,932 £112,702
    of which Community Learning £28,980 £21,560 £50,540
    of which Sector-based Work Academies £0 £0 £0
    Total Funding for this contract: £133,767
    Summary of Funding – Page 1
    """

    # There should not be a TAC doc for CoFG(HEI)
    And   the pdf file does not contain the following text
    """
    EDSK Version 3 (September 2020) Page 1
    """

    # There should not be a Loans Sch 1 doc for CoFG
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (July 2020) – Page 1
    """

    # There should not be an AEB Sch 1 doc for CoFG
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 1
    """
    
    # There should not be a Loans Sch 2 doc for CoFG
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (May 2020) – Page 1
    """

    # There should not be an AEB Sch 2 doc for CoFG
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – ESFA-Funded Adult Education Budget Version 1 (July 2020) – Page 1
    """

    # There should not be a Loans Sch 2 Funding Agreement
    And   the pdf file does not contain the following text
    """
    Schedule 2 – ESFA-Funded Advanced Learner Loans – Funding Agreement ALLF-515 – Page 1 Ref (for internal use only):  EDSK-515 v2
    """

    # There should not be an AEBC-ASCL Sch 2 Funding Agreement
    And   the pdf file does not contain the following text
    """
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECA] – Page 1 Ref (for internal use only):  EDSK-515 v2
    """

    # There should not be a Sch 3ON doc for CoFG(HEI)
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 3 Version 2 (July 2020) – Page 1
    """




    # Withdraw v3 then issue another v3 using non-financial NOTIFICATION amendment

    # Change the date
    Given the override date is '04/07/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-515'

    # Withdraw v3 of the contract 
    When  the next action performed on the latest version of contract 'EDSK-515' is 'Withdraw On Behalf Of Provider' with reason 'The Provider requested withdrawal' by 'FCS1 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017515 | EDSK-515           | 3                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017515 | EDSK-515           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Notification  |
    | 10017515 | EDSK-515           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017515 | ESFA-515           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |




    # Execute a non-financial NOTIFICATION amendment after changing the sector-based work parameters again

    # Change the date
    Given the override date is '05/07/2020'

    # Upsert the provider config values for Sector-based Work Academies for a specific UKPRN and FSP (DocumentsDomain.ContractReferenceConfig) (30680)
    Given the following Sector-based Work Academies profile values exist in config
    | UKPRN    | FSPCode       | Aug20-Mar21 | Apr21-Jul21 |
    | 10017515 | AEBC-ASCL2021 | 2500.00     | 0.00        |

    # Issue a non-financial NOTIFICATION amendment on v2 to create v4
   #When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'EDSK-515' for a non-financial VARIATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'EDSK-515' for a non-financial NOTIFICATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017515 | EDSK-515           | 4                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Notification  |
    | 10017515 | EDSK-515           | 3                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017515 | EDSK-515           | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | Notification  |
    | 10017515 | EDSK-515           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017515 | ESFA-515           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017515' for FundingType 'EDSK' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017515' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices. 
    #   Should include just a Summary of Funding
    Then  the file named '10017515_EDSK-515_v4.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017515 Co Ltd UKPRN: 10017515
    Master Contract Number: ESFA-515
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    Advanced Learner Loans Facility ALLF-515 £15,550 £5,515 £21,065
    ESFA AEB - Adult Skills and Community Learning [AllocRef_AECA] £75,770 £36,932 £112,702
    of which Community Learning £28,980 £21,560 £50,540
    of which Sector-based Work Academies £2,500 £0 £2,500
    Total Funding for this contract: £133,767
    Summary of Funding – Page 1
    """

    # There should not be a TAC doc for CoFG(HEI)
    And   the pdf file does not contain the following text
    """
    EDSK Version 3 (September 2020) Page 1
    """

    # There should not be a Loans Sch 1 doc for CoFG
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (July 2020) – Page 1
    """

    # There should not be an AEB Sch 1 doc for CoFG
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 1
    """
    
    # There should not be a Loans Sch 2 doc for CoFG
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (May 2020) – Page 1
    """

    # There should not be an AEB Sch 2 doc for CoFG
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – ESFA-Funded Adult Education Budget Version 1 (July 2020) – Page 1
    """

    # There should not be a Loans Sch 2 Funding Agreement
    And   the pdf file does not contain the following text
    """
    Schedule 2 – ESFA-Funded Advanced Learner Loans – Funding Agreement ALLF-515 – Page 1 Ref (for internal use only):  EDSK-515 v2
    """

    # There should not be an AEBC-ASCL Sch 2 Funding Agreement
    And   the pdf file does not contain the following text
    """
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECA] – Page 1 Ref (for internal use only):  EDSK-515 v2
    """

    # There should not be a Sch 3ON doc for CoFG(HEI)
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 3 Version 2 (July 2020) – Page 1
    """


    # Tidy Up
    Given the override date is reset

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    Given there are no Sector-based Work Academies profile values in config for UKPRN '10017515'
      
@AcceptanceTest @Withdrawn20231002
Scenario: A516 Bulk create a new 2021EDSK contract with all allocs. Identify document parts for CofG(College)
    Given there are no allocations marked as Under Termination for UKPRN '10017516' 
    And   there are no terminated or closed allocations for UKPRN '10017516' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017516' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017516' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLF-516      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ALLF-516      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP           |
    | ALLF2021      |
    | AEBC-ASCL2021 |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-516       | 1                     | 0                        |

    # Set the 'base' timestamp for all 39 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And   the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_CFS_ITP_2020-08-01.docx            | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_COLLEGE_2020-08-01.docx       | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_HEI_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_LA_2020-08-01.docx            | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_NMSS_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_SPI_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_TRUST_2020-08-01.docx         | 2020-06-18 12:00:00.000 |
    #
    | EDSK2021_S1_1618TRN_CFS.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1618TRN_COFG.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_COLLEGE.docx                 | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_HEI.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_ITP.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_LA.docx                      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_NMSS.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_SPI.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_AEB_CFS.docx                        | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_AEB_COFG.docx                       | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_APPS_COLLEGE.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_APPS_OTHER.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_LOANS_CFS.docx                      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-06-18 12:00:00.000 |
    #
    | EDSK2021_S2_1618TRN_CFS.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_1618TRN_COFG.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_1619ED_CFS.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_1619ED_COFG.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_AEB_CFS.docx                        | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_AEB_COFG.docx                       | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_APPS_COLLEGE.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_APPS_OTHER.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_LOANS_CFS_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    #
    | EDSK2021_S3ON_CFS_ITP_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_COLLEGE_2020-08-01.docx      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_LA_TRUST_HEI_2020-08-01.docx | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_NMSS_2020-08-01.docx         | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_SPI_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    #
    | FA_EDSK2021_2020-08-01.docx                     | 2020-06-18 12:00:00.000 |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017516' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017516 Co Ltd' with UKPRN '10017516' and OrgId 'ORG0017516' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017516' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1          | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017516 | 117516 | 10017516 Co Ltd | 0              | Active                | Yes           | AA017516      | ?             | 161 William Gorth St  | South Woodham Ferrers  | ?                      | ?                      | Chelmsford             | Essex                  | CM3 5GT   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017516 |




    # Bulk file to create an EDSK 2021 contract with all ten allocs
    
    # Change the date
    Given the override date is '01/07/2020'

    # Bulk file - New intent
    And   there are no files prefixed '10017516' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 26062020152444 v3_A516' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 26062020152444 v3_A516' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 26062020152444 v3_A516' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 26062020152444 v3_A516' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 26062020152444 v3_A516.xlsx' exists in the Datafiles folder and UKPRN '10017516' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017516' for FundingType 'EDSK' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017516' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices. 
    Then  the file named '10017516_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017516 Co Ltd UKPRN: 10017516
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    EDSK Version 3 (September 2020) Page 1
    EDSK Version 3 (September 2020) Page 78
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (July 2020) – Page 1
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (July 2020) – Page 8
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 1
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 7
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    APPRENTICESHIPS CARRY-IN SPECIFICATION
    EDSK Schedule 1 – Apprenticeships Carry-In Version 1 (July 2020) – Page 1
    EDSK Schedule 1 – Apprenticeships Carry-In Version 1 (July 2020) – Page 8
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2020) – Page 1
    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2020) – Page 6
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-19 EDUCATION SPECIFICATION
    EDSK Schedule 1 – 16 to 19 Education Version 3 College (June 2021) – Page 1
    EDSK Schedule 1 – 16 to 19 Education Version 3 College (June 2021) – Page 11
    
    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Facility
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (May 2020) – Page 1
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (May 2020) – Page 2
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
    Adult Education Budget
    EDSK Schedule 2 – ESFA-Funded Adult Education Budget Version 1 (July 2020) – Page 1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECT] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Adult Skills and Community Learning
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECA] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - COVID-19 Skills Offer
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECS] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - Short Term Funding Initiatives
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_STFC] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 2: PAYMENT
    APPRENTICESHIPS CARRY-IN
    EDSK Schedule 2 – Apprenticeships Carry-In Version 1 (July 2020) – Page 1
    
    SCHEDULE 2 – APPRENTICESHIPS CARRY-IN
    Funding Agreement – Apprenticeships Carry-In
    Schedule 2 – Apprenticeships Carry-In – Funding Agreement [AllocRef_APPS] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS
    EDSK Schedule 2 – 16 to 18 Traineeships Version 1 (July 2020) – Page 1
    
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    16-19 EDUCATION PAYMENT
    EDSK Schedule 2 – 16 to 19 Education Version 1 (July 2020) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2020) – Page 1
    SCHEDULE 4: NOT USED
    EDSK Schedule 4 Version 2 (July 2020) – Page 1
    SCHEDULE 5: NOT USED
    EDSK Schedule 5 Version 2 (July 2020) – Page 1
    SCHEDULE 6: GDPR
    PROCESSING, PERSONAL DATA AND DATA SUBJECTS
    EDSK Schedule 6 Version 2 (July 2020) – Page 1
    EDSK Schedule 6 Version 2 (July 2020) – Page 2
    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
    EDSK Schedule 7 Version 2 (July 2020) – Page 1
    EDSK Schedule 7 Version 2 (July 2020) – Page 7
    SCHEDULE 8: EXIT ARRANGEMENTS
    EDSK Schedule 8 Version 2 (July 2020) – Page 1
    EDSK Schedule 8 Version 2 (July 2020) – Page 5
    SCHEDULE 9: COLLEGE GOVERNANCE
    EDSK Schedule 9 Version 2 (July 2020) – Page 1
    EDSK Schedule 9 Version 2 (July 2020) – Page 5
    """

    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
Scenario: A031 Bulk create a 2021 EDSK contract with an AEBC-ASCL2021 alloc and two Delivery Orgs. Check SoF doc. (To help with manual checking)
    Given there are no allocations marked as Under Termination for UKPRN '10017031' 
    And   there are no terminated or closed allocations for UKPRN '10017031' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017031' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017031' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-031      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-ASCL2021     |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017031'
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10032931'
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10034058'


    # Set organisation and advisors for Contracting Org (10017031)
    Given there is no Organisation data for UKPRN '10017031' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017031 Co Ltd' with UKPRN '10017031' and OrgId 'ORG0017031' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017031' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                    | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017031 | 117031 | Trumpton County Council | 0              | Active                | Yes           | AA017031      | ?             | 49 Lyon Meade          | Stanmore               | London                 | ?                      | ?                      | ?                      | HA7 1HZ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017031 |


    # Set organisation and advisors for Delivery Org 1 (10032931)
    Given there is no Organisation data for UKPRN '10032931' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017031 Co Ltd' with UKPRN '10032931' and OrgId 'ORG0032931' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10032931' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                     | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10032931 | 132931 | Camberwick Green College | 0              | Active                | Yes           | AA032931      | ?             | 10 Graham Drive        | Sandwich               | Chigley                | ?                      | ?                      | ?                      | HA4 3AS   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10032931 |


    # Set organisation and advisors for Delivery Org 2 (10034058)
    Given there is no Organisation data for UKPRN '10034058' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10034058 Co Ltd' with UKPRN '10034058' and OrgId 'ORG0034058' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10034058' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10034058 | 134058 | Chigley College | 0              | Active                | Yes           | AA034058      | ?             | 8 School Lane          | Aigburth               | Liverpool              | ?                      | ?                      | ?                      | L18 6TY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10034058 |




    # Upsert the provider config values for Sector-based Work Academies for a specific UKPRN and FSP (DocumentsDomain.ContractReferenceConfig) (30680)
    #   The AEB-AS2021 params should not be picked up as they relate to AEBP 
    Given the following Sector-based Work Academies profile values exist in config
    | UKPRN    | FSPCode       | Aug20-Mar21 | Apr21-Jul21 |
    | 10017031 | AEBC-ASCL2021 | 6025.00     | 400.00      |
    | 10032931 | AEB-AS2021    | 999.00      | 999.00      |
    | 10034058 | AEBC-ASCL2021 | 3546.00     | 750.00      |
    | 10034058 | AEB-AS2021    | 999.00      | 999.00      |



    # Change the date
    Given the override date is '24/07/2020'

    # Bulk file
    And   there are no files prefixed '10017031' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 29072020073901 v3_A031' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 29072020073901 v3_A031' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 29072020073901 v3_A031' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 29072020073901 v3_A031' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 29072020073901 v3_A031.xlsx' exists in the Datafiles folder and UKPRN '10017031' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Retrieve parameters for Contracting Org (10017031)
    When  I retrieve the latest EFA contract details from CRM for provider '10017031' for FundingType 'EDSK' and period '2021' and Delivery Organisation '10017031'
   #When  I retrieve the latest contract details from CRM for provider '10017031' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices
    Then  the file named '10017031_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
   #Then  the file named '10017031_EDSK-031_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: Trumpton County Council UKPRN: 10017031
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    ESFA AEB - Adult Skills and Community Learning
    
    Trumpton County Council [AllocRef_AECA] £67,635 £29,540 £97,175
    of which Community Learning £35,379 £7,599 £42,978
    of which Sector-based Work Academies £6,025 £400 £6,425

    Total Funding for this contract: £200,071
    """


    # Retrieve parameters for Delivery Org 1 (10032931)
    When  I retrieve the latest EFA contract details from CRM for provider '10017031' for FundingType 'EDSK' and period '2021' and Delivery Organisation '10032931'
   #When  I retrieve the latest contract details from CRM for provider '10017031' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices
    Then  the file named '10017031_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
   #Then  the file named '10017031_EDSK-031_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: Trumpton County Council UKPRN: 10017031
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    ESFA AEB - Adult Skills and Community Learning
    
    Camberwick Green College [AllocRef_AECA] £27,459 £22,461 £49,920
    of which Community Learning £0 £0 £0
    of which Sector-based Work Academies £0 £0 £0

    Total Funding for this contract: £200,071
    """


    # Retrieve parameters for Delivery Org 2 (10034058)
    When  I retrieve the latest EFA contract details from CRM for provider '10017031' for FundingType 'EDSK' and period '2021' and Delivery Organisation '10034058'
   #When  I retrieve the latest contract details from CRM for provider '10017031' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices
    Then  the file named '10017031_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
   #Then  the file named '10017031_EDSK-031_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: Trumpton County Council UKPRN: 10017031
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    ESFA AEB - Adult Skills and Community Learning
    
    Chigley College [AllocRef_AECA] £36,040 £16,936 £52,976
    of which Community Learning £36,040 £16,936 £52,976
    of which Sector-based Work Academies £3,546 £750 £4,296

    Total Funding for this contract: £200,071
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017031_[ContractNo]_v1.pdf' in 'EDSK-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A031.pdf'


    # Tidy Up
    Given the override date is reset

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017031'
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10032931'
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10034058'

@AcceptanceTest @Withdrawn20231002
Scenario: A036 Bulk create a 2021 EDSK contract with an AEBC-ASCL2021 alloc and no Delivery Orgs. Check SoF doc. Approve. Delete Sector-based params. Issue NFA. Check SoF doc. (To help with manual checking)
    And   there are no terminated or closed allocations for UKPRN '10017036' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017036' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017036' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECA-036      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-ASCL2021     |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017036'




    # Set organisation and advisors
    Given there is no Organisation data for UKPRN '10017036' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017036 Co Ltd' with UKPRN '10017036' and OrgId 'ORG0017036' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017036' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017036 | 117036 | 10017036 Co Ltd | 0              | Active                | Yes           | AA017036      | ?             | 49 Lyon Meade          | Stanmore               | London                 | ?                      | ?                      | ?                      | HA7 1HZ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017036 |




    # Upsert the provider config values for Sector-based Work Academies for a specific UKPRN and FSP (DocumentsDomain.ContractReferenceConfig) (30680)
    Given the following Sector-based Work Academies profile values exist in config
    | UKPRN    | FSPCode       | Aug20-Mar21 | Apr21-Jul21 |
    | 10017036 | AEBC-ASCL2021 | 1250.00     | 0.00        |





    # Change the date
    Given the override date is '24/07/2020'

    # Bulk file
    And   there are no files prefixed '10017036' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 29072020074555 v3_A036' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 29072020074555 v3_A036' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 29072020074555 v3_A036' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 29072020074555 v3_A036' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 29072020074555 v3_A036.xlsx' exists in the Datafiles folder and UKPRN '10017036' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Retrieve parameters 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017036' for FundingType 'EDSK' and period '2021' and Delivery Organisation '10017036'
    When  I retrieve the latest contract details from CRM for provider '10017036' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices
    Then  the file named '10017036_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
   #Then  the file named '10017036_EDSK-036_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017036 Co Ltd UKPRN: 10017036
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    ESFA AEB - Adult Skills and Community Learning [AllocRef_AECA] £67,635 £29,540 £97,175
    of which Community Learning £35,379 £7,599 £42,978
    of which Sector-based Work Academies £1,250 £0 £1,250
    Total Funding for this contract: £97,175
    """




    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017036_[ContractNo]_v1.pdf' in 'EDSK-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A036.pdf'




    # Change the date
    Given the override date is '25/07/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017036 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017036 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'EDSK-036'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_AECA] | 2371175          | Jul-21 | Reconciliation |




    # Execute a NON-FINANCIAL amendment on 2021 EDSK after removing the Sector-based Work Academy parameter vales then check docs

    # Change the date
    Given the override date is '27/07/2020'

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017036'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '1' of contract 'AEBP-036' for a non-financial VARIATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017036 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Notification  |
    | 10017036 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017036 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017036' for FundingType 'EDSK' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017036' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices
    Then  the file named '10017036_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
   #Then  the file named '10017036_EDSK-036_v2.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017036 Co Ltd UKPRN: 10017036
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    ESFA AEB - Adult Skills and Community Learning [AllocRef_AECA] £67,635 £29,540 £97,175
    of which Community Learning £35,379 £7,599 £42,978
    of which Sector-based Work Academies £0 £0 £0
    Total Funding for this contract: £97,175
    """

    # Tidy Up
    Given the override date is reset

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017036'

@AcceptanceTest @Withdrawn20231002
Scenario: A038 Create and approve a 2021 EDSK CofG(LA) contract with ALLB and AEBC-19TRN allocs. Update template timestamps then issue a non-financial amendment. Publish. Withdraw. Reissue NFA. Check docs. (To help with manual testing)
    Given there are no allocations marked as Under Termination for UKPRN '10017038' 
    And   there are no terminated or closed allocations for UKPRN '10017038' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017038' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017038' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AECT-038      |
    | ALLB-038      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AECT-038      |
    | ALLB-038      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEBC-19TRN2021    |
    | ALLB2021          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-038       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017038'

    # Set the 'base' timestamp for all EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And   the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_CFS_ITP_2020-08-01.docx            | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_COLLEGE_2020-08-01.docx       | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_HEI_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_LA_2020-08-01.docx            | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_NMSS_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_SPI_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_TRUST_2020-08-01.docx         | 2020-06-18 12:00:00.000 |
    #
    | EDSK2021_S1_1618TRN_CFS.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1618TRN_COFG.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_COLLEGE.docx                 | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_HEI.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_ITP.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_LA.docx                      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_NMSS.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_SPI.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_AEB_CFS.docx                        | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_AEB_COFG.docx                       | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_APPS_COLLEGE.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_APPS_OTHER.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_LOANS_CFS.docx                      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-06-18 12:00:00.000 |
    #
    | EDSK2021_S2_1618TRN_CFS.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_1618TRN_COFG.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_1619ED_CFS.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_1619ED_COFG.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_AEB_CFS.docx                        | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_AEB_COFG.docx                       | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_APPS_COLLEGE.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_APPS_OTHER.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_LOANS_CFS_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    #
    | EDSK2021_S3ON_CFS_ITP_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_COLLEGE_2020-08-01.docx      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_LA_TRUST_HEI_2020-08-01.docx | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_NMSS_2020-08-01.docx         | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_SPI_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    #
    | FA_EDSK2021_2020-08-01.docx                     | 2020-06-18 12:00:00.000 |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017038' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017038 Co Ltd' with UKPRN '10017038' and OrgId 'ORG0017038' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017038' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017038 | 117038 | 10017038 Co Ltd | 0              | In Administration     | Yes           | AA017038      | ?             | 1 Cadogan Square       | ?                      | ?                      | ?                      | Cadogan Street         | Glasgow                | G2 7HF    |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017038 |




    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017038 | 10017038 Co Ltd      | ESFA-038             | EDSK-038       | 1                     | 01/08/2020        | 31/07/2021      | 43231.00      |                                       | Conditions of Funding (Grant) (LA)         | 2021   | New          | ORG0017038 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017038 | EDSK-038       | AECT-038      | AEBC-19TRN        | AEBC-19TRN2021          | AY                      | 01/08/2020          | 31/07/2021        | 20665.00        |                                         |            |                                                             | New          |             |
    | 10017038 | EDSK-038       | ALLB-038      | ALLB              | ALLB2021                | AY                      | 01/08/2020          | 31/07/2021        | 22566.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017038 | EDSK-038       | AECT-038      | 1               | 0                     | 20665.00  | 14253.00  | 6412.00   | 3617.00  | 2391.00  | 2367.00  | 1457.00  | 484.00   | 2421.00  | 311.00   | 1205.00  | 2223.00  | 904.00   | 2144.00  | 1141.00  | 19-24 Traineeships Total Funding                                | New          |             | 
    | 10017038 | EDSK-038       | ALLB-038      | 1               | 0                     | 22566.00  | 14538.00  | 8028.00   | 2382.00  | 524.00   | 3380.00  | 3197.00  | 2762.00  | 366.00   | 153.00   | 1774.00  | 3330.00  | 1378.00  | 1798.00  | 1522.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-038       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-038' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-038'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-038' and actual ContractNumber 'EDSK-038'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-038' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017038 | EDSK-038           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017038 | ESFA-038           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '84' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '84' deliverable period rows in CRM linked to the latest version of contract 'EDSK-038'

#    # Check that the CRM subnominals have been created before moving on
#    And   CRM subnominals have been created for the following allocations
#    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
#    | AECT-038        | 2355775          | Jul-21 | Reconciliation |
#    | ALLB-038        | 2303800          | Jul-21 | Reconciliation |






    # Execute a NON-FINANCIAL amendment on v1 to create v2

    # Change the date
    Given the override date is '28/09/2020'

    # Update two template timestamps (DocumentsDomain.UploadedDocumentTemplate) (J107)
    #   Timestamps are after v1 was created
    And   the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_COFG_LA_2020-08-01.docx            | 2020-09-01 08:22:16.000 |
    | EDSK2021_S1_AEB_COFG.docx                       | 2020-09-02 11:15:34.000 |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017038'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-038' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017038 | EDSK-038           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017038 | EDSK-038           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017038 | ESFA-038           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017038' for FundingType 'EDSK' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017038' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices 
    #  Note1: If template timestamps don't change then only the SOF is produced 
    #  Note2: If template timestamps change on TAC & S1 then the SOF, TAC and S1 are produced
    Then  the file named '10017038_EDSK-038_v2.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017038 Co Ltd UKPRN: 10017038
    Master Contract Number: ESFA-038
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    Advanced Learner Loans Bursary ALLB-038 £14,538 £8,028 £22,566
    ESFA AEB - 19 to 24 Traineeships AECT-038 £14,253 £6,412 £20,665
    Total Funding for this contract: £43,231
    Summary of Funding – Page 1

    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    Funding Period 1 August 2020 to 31 July 2021
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017038 Co Ltd
    Advanced Learner Loans
    Funding for
    ESFA-Funded Adult Education Budget
    Master Agreement Number ESFA-038
    EDSK Version 3 (September 2020) Page 1
    EDSK Version 3 (September 2020) Page 73

    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 1
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 7
    """

    # Save a copy of the output
    Then  Sharepoint file '10017038_EDSK-038_v2.pdf' in 'EDSK-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A038v2.pdf'




    # Publish then withdraw the contract
    
    # Change the date
    Given the override date is '02/10/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-642' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-038'

    # Withdraw v2 of the contract 
    When  the next action performed on the latest version of contract 'EDSK-038' is 'Withdraw On Behalf Of Provider' with reason 'EDSK test withdrawal' by 'FCS1 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017038 | EDSK-038           | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017038 | EDSK-038           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017038 | ESFA-038           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |




    # Execute a NON-FINANCIAL amendment on v1 to create v2

    # Change the date
    Given the override date is '05/10/2020'

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017038'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-038' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017038 | EDSK-038           | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017038 | EDSK-038           | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017038 | EDSK-038           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017038 | ESFA-038           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017038' for FundingType 'EDSK' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017038' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices 
    #  Note1: If template timestamps don't change then only the SOF is produced 
    #  Note2: If template timestamps change on TAC & S1 then the SOF, TAC and S1 are produced
    Then  the file named '10017038_EDSK-038_v3.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017038 Co Ltd UKPRN: 10017038
    Master Contract Number: ESFA-038
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    Advanced Learner Loans Bursary ALLB-038 £14,538 £8,028 £22,566
    ESFA AEB - 19 to 24 Traineeships AECT-038 £14,253 £6,412 £20,665
    Total Funding for this contract: £43,231
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    Funding Period 1 August 2020 to 31 July 2021
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017038 Co Ltd
    Advanced Learner Loans
    Funding for
    ESFA-Funded Adult Education Budget
    Master Agreement Number ESFA-038
    EDSK Version 3 (September 2020) Page 1
    EDSK Version 3 (September 2020) Page 73
  
    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 1
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 7
    """

    # Save a copy of the output
    Then  Sharepoint file '10017038_EDSK-038_v3.pdf' in 'EDSK-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A038v3.pdf'


    # Tidy Up
    And   the override date is reset
      
@AcceptanceTest @Withdrawn20231002
Scenario: A039 Create and approve a 2021 EDSK CofG(College) contract with APPS alloc. Update template timestamp for AEBC-19TRN then bulk amend to add AEBC-19TRN. Check docs. (To help with manual testing)
    Given there are no allocations marked as Under Termination for UKPRN '10017039' 
    And   there are no terminated or closed allocations for UKPRN '10017039' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017039' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017039' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | APPS-039      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | APPS-039      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | APPS2021          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-039       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017039'

    # Set the 'base' timestamp for all EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And   the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_CFS_ITP_2020-08-01.docx            | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_COLLEGE_2020-08-01.docx       | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_HEI_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_LA_2020-08-01.docx            | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_NMSS_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_SPI_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_TRUST_2020-08-01.docx         | 2020-06-18 12:00:00.000 |
    #
    | EDSK2021_S1_1618TRN_CFS.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1618TRN_COFG.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_COLLEGE.docx                 | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_HEI.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_ITP.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_LA.docx                      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_NMSS.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_1619ED_SPI.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_AEB_CFS.docx                        | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_AEB_COFG.docx                       | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_APPS_COLLEGE.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_APPS_OTHER.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_LOANS_CFS.docx                      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-06-18 12:00:00.000 |
    #
    | EDSK2021_S2_1618TRN_CFS.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_1618TRN_COFG.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_1619ED_CFS.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_1619ED_COFG.docx                    | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_AEB_CFS.docx                        | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_AEB_COFG.docx                       | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_APPS_COLLEGE.docx                   | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_APPS_OTHER.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_LOANS_CFS_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    #
    | EDSK2021_S3ON_CFS_ITP_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_COLLEGE_2020-08-01.docx      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_LA_TRUST_HEI_2020-08-01.docx | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_NMSS_2020-08-01.docx         | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_SPI_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    #
    | FA_EDSK2021_2020-08-01.docx                     | 2020-06-18 12:00:00.000 |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017039' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017039 Co Ltd' with UKPRN '10017039' and OrgId 'ORG0017039' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017039' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017039 | 117039 | 10017039 Co Ltd | 0              | Locked Restructure    | Yes           | AA017039      | ?             | 96 West Yard           | Camden Lock Place      | Chalk Farm Road        | London                 | ?                      | ?                      | NW1 8AF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017039 |




    # Change the date
    Given the override date is '22/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017039 | 10017039 Co Ltd      | ESFA-039             | EDSK-039       | 1                     | 01/08/2020        | 31/07/2021      | 19607.00      |                                       | Conditions of Funding (Grant) (College)    | 2021   | New          | ORG0017039 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017039 | EDSK-039       | APPS-039      | APPS              | APPS2021                | AY                      | 01/08/2020          | 31/07/2021        | 19607.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017039 | EDSK-039       | APPS-039      | 1               | 0                     | 19607.00  | 10877.00  | 8730.00   | 138.00   | 1126.00  | 1862.00  | 637.00   | 612.00   | 3404.00  | 2431.00  | 667.00   | 2258.00  | 3152.00  | 469.00   | 2851.00  | Apprenticeships Carry-In Total Funding                          | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-039       | 1                     | 0                        | 2020-07-22 15:43:08.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'EDSK-039' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-039'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-039' and actual ContractNumber 'EDSK-039'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-039' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017039 | EDSK-039           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017039 | ESFA-039           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '288' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '288' deliverable period rows in CRM linked to the latest version of contract 'EDSK-039'




    # Bulk amend to add AEBC-19TRN2021 to contract after first changing the template data

    # Change the date
    Given the override date is '17/09/2020'

    # Update two template timestamps (DocumentsDomain.UploadedDocumentTemplate) (J107)
    #   Timestamps are after v1 was created
    And   the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_COFG_COLLEGE_2020-08-01.docx       | 2020-09-15 08:53:47.000 |
    | EDSK2021_S1_AEB_COFG.docx                       | 2020-09-16 17:22:14.000 |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017038'


    # Bulk file
    And   there are no files prefixed '10017039' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 10092020170128 v3_A039' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 10092020170128 v3_A039' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 10092020170128 v3_A039' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 10092020170128 v3_A039' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 10092020170128 v3_A039.xlsx' exists in the Datafiles folder and UKPRN '10017039' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017039' for FundingType 'EDSK' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017039' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices
    Then  the file named '10017039_EDSK-039_v2.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017039 Co Ltd UKPRN: 10017039
    Master Contract Number: ESFA-039
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AECT] £40,257 £16,640 £56,897
    Apprenticeships Carry-In APPS-039 £10,877 £8,730 £19,607
    Total Funding for this contract: £76,504
    Summary of Funding – Page 1

    Agreement Type Conditions of Funding (Grant) (Colleges)
    EDSK Version 3 (September 2020) Page 1
    EDSK Version 3 (September 2020) Page 78
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET (GRANTS) SPECIFICATION
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 1
    EDSK Schedule 1 – ESFA-Funded Adult Education Budget Version 3 (February 2021) – Page 7
    
    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (GRANT)
    EDSK Schedule 2 – ESFA-Funded Adult Education Budget Version 1 (July 2020) – Page 1
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - 19 to 24 Traineeships
    Provider: 10017039 Co Ltd UKPRN: 10017039
    Master Contract Number: ESFA-039 Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_AECT]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - 19 to 24 Traineeships £56,897 £6,231 £4,480 £7,622 £6,147 £4,735 £6,858 £489 £3,695 £3,642 £1,689 £7,549 £3,760
    Total Funding £56,897 £6,231 £4,480 £7,622 £6,147 £4,735 £6,858 £489 £3,695 £3,642 £1,689 £7,549 £3,760
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECT] – Page 1 Ref (for internal use only):  EDSK-039 v2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017039_EDSK-039_v2.pdf' in 'EDSK-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A039.pdf'


    # Tidy Up
    And   the override date is reset

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017038'
       