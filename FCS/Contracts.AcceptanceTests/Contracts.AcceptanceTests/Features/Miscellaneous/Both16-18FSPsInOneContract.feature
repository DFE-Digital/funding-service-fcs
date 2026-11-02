Feature: Both16-18FSPsInOneContract

@AcceptanceTest @Manual
Scenario: A808 Bulk ceate a new EDSK2122 contract (CofG) with both 16-18 Traineeships and 16-18 Traineeships(ME). Check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017808' 
    And   there are no terminated or closed allocations for UKPRN '10017808' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017808' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017808' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017808' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN-ME2122   |
    | 16-18TRN2122      |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017808'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017808' 
    And   there is no caseload advisor for UKPRN '10017808' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017808 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017808' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017808 Co Ltd' with UKPRN '10017808' and OrgId 'ORG0017808' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017808 | 117808 | 10017808 Co Ltd | 0              | Active                | Yes           | AA017808      | ?             | 37a Star Street        | ?                      | ?                      | ?                      | Ware                   | Hertfordshire          | SG12 7AA  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017808 |





    # Change the date
    Given the override date is '01/11/2021'

    # Bulk file
    And   there are no files prefixed '10017808' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2122 18112021105208 v3_A808' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2122 18112021105208 v3_A808' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2122 18112021105208 v3_A808' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2122 18112021105208 v3_A808' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2122 18112021105208 v3_A808.xlsx' exists in the Datafiles folder and UKPRN '10017808' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017808' for FundingType 'EDSK' and period '2122' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017808' for FundingType 'EDSK' and period '2122'

    # Check the contents of the Appendices
    Then  the file named '10017808_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017808 Co Ltd UKPRN: 10017808
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    16 to 18 Traineeships [AllocRef_16TR] £30,032 £25,554 £55,586
    16 to 18 Traineeships [AllocRef_16TM] £41,529 £35,175 £76,704
    Total Funding for this contract: £132,290
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Colleges)
    Funding Period 1 August 2021 to 31 July 2022
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017808 Co Ltd
    Funding for 16 to 18 Traineeships
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE COLLEGE
    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
    THE COLLEGE REPRESENTS AND WARRANTS THAT THE COLLEGE HAS READ
    AND UNDERSTOOD THIS AGREEMENT, THE COLLEGE AGREES TO BE BOUND
    BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO ACCEPT
    THIS AGREEMENT AND LEGALLY BIND THE COLLEGE.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    acting through the Education and Skills Funding Agency
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 2 (July 2021) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017808 Co Ltd THE SECRETARY OF STATE FOR
    37a Star Street EDUCATION ACTING THROUGH
    Ware THE EDUCATION AND SKILLS
    Hertfordshire FUNDING AGENCY, AN
    SG12 7AA EXECUTIVE AGENCY OF THE
    AND
    DEPARTMENT OF EDUCATION
    CHEYLESMORE HOUSE
    Company No: AA017808 QUINTON ROAD
    COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the College the Department
    EDSK Version 2 (July 2021) Page 2
    EDSK Version 2 (July 2021) Page 78
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
    EDSK Schedule 1 – 16 to 18 Traineeships Version 2 (December 2021) – Page 1
    EDSK Schedule 1 – 16 to 18 Traineeships Version 2 (December 2021) – Page 6
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS (MARKET ENTRY) SPECIFICATION
    EDSK Schedule 1 – 16 to 18 Traineeships (Market Entry) Version 1 (October 2021) – Page 1
    EDSK Schedule 1 – 16 to 18 Traineeships (Market Entry) Version 1 (October 2021) – Page 6
    
    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS
    EDSK Schedule 2 – 16 to 18 Traineeships Version 1 (July 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017808 Co Ltd UKPRN: 10017808
    Master Contract Number: [MasterContractNo] Start Date: 01/12/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16TR]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16 to 18 Traineeships Programme Funding £28,673 £3,464 £1,308 £1,935 £5,894 £4,079 £3,686 £2,752 £5,555
    16 to 18 Traineeships Bursary Funding £26,913 £5,098 £629 £3,973 £7,731 £682 £87 £4,112 £4,601
    Total Funding £55,586 £8,562 £1,937 £5,908 £13,625 £4,761 £3,773 £6,864 £10,156
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TR] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS (MARKET ENTRY)
    EDSK Schedule 2 – 16 to 18 Traineeships Version 1 (Market Entry) (October 2021) – Page 1
    
    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10017808 Co Ltd UKPRN: 10017808
    Master Contract Number: [MasterContractNo] Start Date: 01/12/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_16TM]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    16 to 18 Traineeships Programme Funding £45,514 £6,035 £4,283 £7,426 £5,950 £4,538 £6,661 £6,627 £3,994
    16 to 18 Traineeships Bursary Funding £31,190 £3,941 £1,988 £7,848 £4,058 £7,476 £1,446 £3,634 £799
    Total Funding £76,704 £9,976 £6,271 £15,274 £10,008 £12,014 £8,107 £10,261 £4,793
    Schedule 2 – 16 to 18 Traineeships – Funding Agreement [AllocRef_16TM] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017808_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A808.pdf'

    # Display Sharepoint filename
    And   message '10017808_[ContractNo]_v1.pdf' is written to the Output window


    # Tidy Up
    Given the override date is reset

