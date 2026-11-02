Feature: CreateLoansContracts 38416

@AcceptanceTest @InProgress
Scenario: A219 Bulk load a new EDSK2324 Loans contract with ALLBC and ALLF allocs (CfS ITP). NFA. Check document parts and financials
    Given there is no Contract, Task or Workflow data for UKPRN '10017219' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017219' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Set the 'base' timestamp for each of the 23\24 EDSK Loans document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    Given the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | SOF_EDSK_2023-08-01.docx                        | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_TAC_AA_COLLEGE_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_AA_LA_2023-08-01.docx              | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_CFS_ITP_2023-08-01.docx            | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_EMPLOYER_2023-08-01.docx      | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_HEI_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_LA_2023-08-01.docx            | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_TRUST_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S1_LOANS_CFS_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_S1_LOANS_COFG_2023-08-01.docx          | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S2_LOANS_AA_COLLEGE_2023-08-01.docx    | 2023-03-01 12:00:00.000 |
    | EDSK2324_S2_LOANS_AA_LA_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    | EDSK2324_S2_LOANS_CFS_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_S2_LOANS_COFG_2023-08-01.docx          | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S3_LOANS_AA_COLLEGE_2023-08-01.docx    | 2023-03-01 12:00:00.000 |
    | EDSK2324_S3_LOANS_AA_LA_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    #
    | FA_EDSK2324_2023-08-01.docx                     | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S3ON_CFS_ITP_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_S3ON_COFG_EMPLOYER_2023-08-01.docx     | 2023-03-01 12:00:00.000 |
    | EDSK2324_S3ON_COFG_LA_TRUST_HEI_2023-08-01.docx | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S4ON_AA_COLLEGE_2023-08-01.docx        | 2023-03-01 12:00:00.000 |
    | EDSK2324_S4ON_AA_LA_2023-08-01.docx             | 2023-03-01 12:00:00.000 |




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017219' 
    And   there is no caseload advisor for UKPRN '10017219' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017219 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017219' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017219 Co Ltd' with UKPRN '10017219' and OrgId 'ORG0017219' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017219 | 117219 | 10017219 Co Ltd | 0              | Active                | Yes           | AA017219      | ?             | 301 Histon Road        | Cambridge              | ?                      | ?                      | ?                      | ?                      | CB4 3NF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017219 |





    # Bulk load a contract with New intent (ALLBC and ALLF, CfS ITP)

    # Change the date
    Given the override date is '22/03/2023'

    # Bulk file
    And   there are no files prefixed '10017219' in the Sharepoint 'EDSK-2324-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2324 22032023111711 v3_A219' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2324 22032023111711 v3_A219' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2324 22032023111711 v3_A219' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2324 22032023111711 v3_A219' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2324 22032023111711 v3_A219.xlsx' exists in the Datafiles folder and UKPRN '10017219' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017219' for FundingType 'EDSK' and period '2324'

    # Check the contents of the Appendices (Sch1 is missing)
    Then  the file named '10017219_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10017219 Co Ltd UKPRN: 10017219
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £36,785 £16,051 £52,836
    Advanced Learner Loans Bursary [AllocRef_ALLC] £24,773 £15,885 £40,658
    Total Funding for this contract: £93,494
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2023 to 31 July 2024
    Between the Secretary of State for Education
    And 10017219 Co Ltd
    Funding for Advanced Learner Loans
    Master Contract Number [MasterContractNo]
    ACCEPTANCE BY THE CONTRACTOR
    BY ACCEPTING THIS CONTRACT VIA THE MANAGE YOUR EDUCATION &
    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
    THE CONTRACTOR REPRESENTS AND WARRANTS THAT THE CONTRACTOR
    HAS READ AND UNDERSTOOD THIS CONTRACT, THE CONTRACTOR AGREES
    TO BE BOUND BY THIS CONTRACT AND THAT HE/SHE IS DULY AUTHORISED
    TO ACCEPT THIS CONTRACT AND LEGALLY BIND THE CONTRACTOR.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 1 (April 2023) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017219 Co Ltd THE SECRETARY OF STATE FOR
    301 Histon Road EDUCATION
    Cambridge DEPARTMENT FOR EDUCATION
    CB4 3NF AND 20 GREAT SMITH STREET
    LONDON
    SW1P 3BT
    Company No: AA017219
    Hereinafter called Hereinafter called
    the Contractor the Department
    EDSK Version 1 (April 2023) Page 2
    EDSK Version 1 (April 2023) Page 76
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2023) – Page 1
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2023) – Page 8
    
    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON ACTUALS)
    Advanced Learner Loans Facility
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2023) – Page 1
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2023) – Page 2
    
    ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017219 Co Ltd UKPRN: 10017219
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Advanced Learner Loans Facility £52,836 £6,126 £3,291 £5,956 £3,800 £4,427 £436 £6,571 £6,178 £5,244 £96 £7,590 £3,121
    Total Funding £52,836 £6,126 £3,291 £5,956 £3,800 £4,427 £436 £6,571 £6,178 £5,244 £96 £7,590 £3,121
    Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017219 Co Ltd UKPRN: 10017219
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_ALLC]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Advanced Learner Loans Bursary Funding £40,658 £4,574 £3,098 £1,686 £3,809 £5,391 £2,758 £2,705 £752 £6,612 £2,823 £6,240 £210
    Total Funding £40,658 £4,574 £3,098 £1,686 £3,809 £5,391 £2,758 £2,705 £752 £6,612 £2,823 £6,240 £210
    Advanced Learner Loans – Funding Agreement [AllocRef_ALLC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    EDSK Schedule 3 Version 1 (April 2023) – Page 1
    EDSK Schedule 9 Version 1 (April 2023) – Page 5
    """

 #  # There should not be a ...
 #  And   the pdf file does not contain the following text
 #  """
 #  Blah
 #  """

   #And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-03-22 09:12:35.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017219_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A219.pdf'





    # Publish and approve

    # Change the date
    Given the override date is '24/03/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017219 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10017219 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_ALLC] | 2303975          | Jul-24 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                               | DeliverableDescription    | 
    | 10017219 | [ContractNo]   | 1               | [AllocRef_ALLC] | 1               | 0                     | 40658.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding  | ?                         |
    | 10017219 | [ContractNo]   | 1               | [AllocRef_ALLF] | 5               | 0                     | 52836.00     | 0             | 0        | Advanced Learner Loans Facility               | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed



    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_ALLC]    | 1               | 40658.00  | 4574.00  | 3098.00  | 1686.00  | 3809.00  | 5391.00  | 2758.00  | 2705.00  | 752.00   | 6612.00  | 2823.00  | 6240.00  | 210.00   | 
    | [ContractNo]   | [AllocRef_ALLC]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLC]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLC]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_ALLF]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 52836.00  | 6126.00  | 3291.00  | 5956.00  | 3800.00  | 4427.00  | 436.00   | 6571.00  | 6178.00  | 5244.00  | 96.00    | 7590.00  | 3121.00  | 
    | [ContractNo]   | [AllocRef_ALLF]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_ALLC]    | 1               | 40658.00  | 4574.00  | 3098.00  | 1686.00  | 3809.00  | 5391.00  | 2758.00  | 2705.00  | 752.00   | 6612.00  | 2823.00  | 6240.00  | 210.00   | 
    | [ContractNo]   | [AllocRef_ALLC]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLC]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLC]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_ALLF]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 




    # Adjust template timestamps. Raise NFA. Check doc parts

       # To Do




    # Execute a NON-FINANCIAL amendment and check docs

    # Change the date
    Given the override date is '26/03/2023'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017219 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2023        | 31/07/2024      | Variation     |
    | 10017219 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10017219 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |


    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017219' for FundingType 'EDSK' and period '2324'

    # Check the contents of the Appendices 
    Then  the file named '10017219_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10017219 Co Ltd UKPRN: 10017219
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £36,785 £16,051 £52,836
    Advanced Learner Loans Bursary [AllocRef_ALLC] £24,773 £15,885 £40,658
    Total Funding for this contract: £93,494
    Summary of Funding – Page 1
    """

    # There should not be a TAC
    And   the pdf file does not contain the following text
    """
    Agreement Type Contract for Services
    """

 #  # There should not be a ... 
 #  And   the pdf file does not contain the following text
 #  """
 #  Blah
 #  """
 
    # Tidy Up
    Given the override date is reset

@AcceptanceTest @InProgress
Scenario: A220 Bulk load a new EDSK2324 Loans contract with ALLB and ALLF allocs (CofG Employer). NFA. Check document parts. Actuals. PoA batch. Check financials
    Given there is no Contract, Task or Workflow data for UKPRN '10017220' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017220' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Set the 'base' timestamp for each of the 23\24 EDSK Loans document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    Given the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | SOF_EDSK_2023-08-01.docx                        | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_TAC_AA_COLLEGE_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_AA_LA_2023-08-01.docx              | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_CFS_ITP_2023-08-01.docx            | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_EMPLOYER_2023-08-01.docx      | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_HEI_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_LA_2023-08-01.docx            | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_TRUST_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S1_LOANS_CFS_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_S1_LOANS_COFG_2023-08-01.docx          | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S2_LOANS_AA_COLLEGE_2023-08-01.docx    | 2023-03-01 12:00:00.000 |
    | EDSK2324_S2_LOANS_AA_LA_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    | EDSK2324_S2_LOANS_CFS_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_S2_LOANS_COFG_2023-08-01.docx          | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S3_LOANS_AA_COLLEGE_2023-08-01.docx    | 2023-03-01 12:00:00.000 |
    | EDSK2324_S3_LOANS_AA_LA_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    #
    | FA_EDSK2324_2023-08-01.docx                     | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S3ON_CFS_ITP_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_S3ON_COFG_EMPLOYER_2023-08-01.docx     | 2023-03-01 12:00:00.000 |
    | EDSK2324_S3ON_COFG_LA_TRUST_HEI_2023-08-01.docx | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S4ON_AA_COLLEGE_2023-08-01.docx        | 2023-03-01 12:00:00.000 |
    | EDSK2324_S4ON_AA_LA_2023-08-01.docx             | 2023-03-01 12:00:00.000 |




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017220' 
    And   there is no caseload advisor for UKPRN '10017220' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017220 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017220' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017220 Co Ltd' with UKPRN '10017220' and OrgId 'ORG0017220' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017220 | 117220 | 10017220 Co Ltd | 0              | Active                | Yes           | AA017220      | ?             | 301 Histon Road        | Cambridge              | ?                      | ?                      | ?                      | ?                      | CB4 3NF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017220 |





    # Bulk load a contract with New intent (ALLB and ALLF, CofG Employer)

    # Change the date
    Given the override date is '22/03/2023'

    # Bulk file
    And   there are no files prefixed '10017220' in the Sharepoint 'EDSK-2324-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2324 15032023142203 v3_A220' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2324 15032023142203 v3_A220' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2324 15032023142203 v3_A220' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2324 15032023142203 v3_A220' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2324 15032023142203 v3_A220.xlsx' exists in the Datafiles folder and UKPRN '10017220' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017220' for FundingType 'EDSK' and period '2324'

    # Check the contents of the Appendices (Sch1 is missing)
    Then  the file named '10017220_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10017220 Co Ltd UKPRN: 10017220
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £23,201 £6,799 £30,000
    Advanced Learner Loans Bursary [AllocRef_ALLB] £21,898 £18,102 £40,000
    Total Funding for this contract: £70,000
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Employers)
    Funding Period 1 August 2023 to 31 July 2024
    Between the Secretary of State for Education
    And 10017220 Co Ltd
    Funding for Advanced Learner Loans
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE EMPLOYER
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 1 (April 2023) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Employer on the Manage Your Education & Skills Funding Service between:
    10017220 Co Ltd THE SECRETARY OF STATE FOR
    301 Histon Road EDUCATION
    Cambridge DEPARTMENT FOR EDUCATION
    CB4 3NF 20 GREAT SMITH STREET
    AND
    LONDON
    SW1P 3BT
    Company No: AA017220
    Hereinafter called Hereinafter called
    the Employer the Department
    EDSK Version 1 (April 2023) Page 2
    EDSK Version 1 (April 2023) Page 74
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2023) – Page 1
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2023) – Page 9
    
    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Facility
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2023) – Page 1
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2023) – Page 2
    
    ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017220 Co Ltd UKPRN: 10017220
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Advanced Learner Loans Facility £30,000 £3,920 £1,841 £3,077 £1,133 £1,859 £5,703 £3,330 £2,338 £1,523 £1,130 £2,147 £1,999
    Total Funding £30,000 £3,920 £1,841 £3,077 £1,133 £1,859 £5,703 £3,330 £2,338 £1,523 £1,130 £2,147 £1,999
    Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017220 Co Ltd UKPRN: 10017220
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_ALLB]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Advanced Learner Loans Bursary Funding £40,000 £2,479 £2,327 £3,870 £2,394 £982 £3,105 £4,687 £2,054 £2,077 £7,999 £5,908 £2,118
    Total Funding £40,000 £2,479 £2,327 £3,870 £2,394 £982 £3,105 £4,687 £2,054 £2,077 £7,999 £5,908 £2,118
    Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 1 (April 2023) – Page 1
    EDSK Schedule 9 Version 1 (April 2023) – Page 5
    """

 #  # There should not be a ...
 #  And   the pdf file does not contain the following text
 #  """
 #  Blah
 #  """

   #And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-03-22 09:12:35.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017220_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A220.pdf'





    # Publish and approve

    # Change the date
    Given the override date is '24/03/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017220 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10017220 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_ALLB] | 2303800          | Jul-24 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                               | DeliverableDescription    | 
    | 10017220 | [ContractNo]   | 1               | [AllocRef_ALLB] | 1               | 0                     | 40000.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding  | ?                         |
    | 10017220 | [ContractNo]   | 1               | [AllocRef_ALLF] | 5               | 0                     | 30000.00     | 0             | 0        | Advanced Learner Loans Facility               | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed



    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_ALLB]    | 1               | 40000.00  | 2479.00  | 2327.00  | 3870.00  | 2394.00  | 982.00   | 3105.00  | 4687.00  | 2054.00  | 2077.00  | 7999.00  | 5908.00  | 2118.00  | 
    | [ContractNo]   | [AllocRef_ALLB]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLB]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLB]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_ALLF]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 30000.00  | 3920.00  | 1841.00  | 3077.00  | 1133.00  | 1859.00  | 5703.00  | 3330.00  | 2338.00  | 1523.00  | 1130.00  | 2147.00  | 1999.00  | 
    | [ContractNo]   | [AllocRef_ALLF]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_ALLB]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLB]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLB]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLB]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    # 
    | [ContractNo]   | [AllocRef_ALLF]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 



    # Adjust template timestamps. Raise NFA. Check doc parts

       # To Do



    # Execute a NON-FINANCIAL amendment and check docs

    # Change the date
    Given the override date is '26/03/2023'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017220 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2023        | 31/07/2024      | Variation     |
    | 10017220 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10017220 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |


    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017220' for FundingType 'EDSK' and period '2324'

    # Check the contents of the Appendices 
    Then  the file named '10017220_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10017220 Co Ltd UKPRN: 10017220
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £23,201 £6,799 £30,000
    Advanced Learner Loans Bursary [AllocRef_ALLB] £21,898 £18,102 £40,000
    Total Funding for this contract: £70,000
    Summary of Funding – Page 1
    """

    # There should not be a TAC
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Employers)
    """

 #  # There should not be a ... 
 #  And   the pdf file does not contain the following text
 #  """
 #  Blah
 #  """
 


    # Publish and approve

    # Change the date
    Given the override date is '28/03/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017220 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | Variation     |
    | 10017220 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10017220 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_ALLB] | 2303800          | Jul-24 | Reconciliation |





    # Add actuals to the contract for ALLB2324

    # Change the date
    Given the override date is '04/09/2023'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017220'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202308 | ALLB2324                | [AllocRef_ALLB]          | ?          | 2               | 0            | 2498.70     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202308 | ALLB2324                | [AllocRef_ALLB]          | ?          | 3               | 0            | 1347.24     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202308 | ALLB2324                | [AllocRef_ALLB]          | ?          | 4               | 0            | 2090.31     |
    #
    | ILR2324        | R01                  | ORG0017220     | CM             | 202309 | ALLB2324                | [AllocRef_ALLB]          | ?          | 2               | 0            | 679.53      |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202309 | ALLB2324                | [AllocRef_ALLB]          | ?          | 3               | 0            | 1330.31     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202309 | ALLB2324                | [AllocRef_ALLB]          | ?          | 4               | 0            | 2364.35     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202310 | ALLB2324                | [AllocRef_ALLB]          | ?          | 2               | 0            | 1764.18     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202310 | ALLB2324                | [AllocRef_ALLB]          | ?          | 3               | 0            | 1048.84     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202310 | ALLB2324                | [AllocRef_ALLB]          | ?          | 4               | 0            | 2091.38     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202311 | ALLB2324                | [AllocRef_ALLB]          | ?          | 2               | 0            | 194.56      |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202311 | ALLB2324                | [AllocRef_ALLB]          | ?          | 3               | 0            | 1727.00     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202311 | ALLB2324                | [AllocRef_ALLB]          | ?          | 4               | 0            | 748.89      |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202312 | ALLB2324                | [AllocRef_ALLB]          | ?          | 2               | 0            | 2368.13     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202312 | ALLB2324                | [AllocRef_ALLB]          | ?          | 3               | 0            | 2322.55     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202312 | ALLB2324                | [AllocRef_ALLB]          | ?          | 4               | 0            | 2213.62     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202401 | ALLB2324                | [AllocRef_ALLB]          | ?          | 2               | 0            | 1475.22     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202401 | ALLB2324                | [AllocRef_ALLB]          | ?          | 3               | 0            | 614.34      |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202401 | ALLB2324                | [AllocRef_ALLB]          | ?          | 4               | 0            | 1898.97     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202402 | ALLB2324                | [AllocRef_ALLB]          | ?          | 2               | 0            | 936.70      |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202402 | ALLB2324                | [AllocRef_ALLB]          | ?          | 3               | 0            | 2089.85     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202402 | ALLB2324                | [AllocRef_ALLB]          | ?          | 4               | 0            | 892.58      |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202403 | ALLB2324                | [AllocRef_ALLB]          | ?          | 2               | 0            | 2441.41     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202403 | ALLB2324                | [AllocRef_ALLB]          | ?          | 3               | 0            | 632.58      |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202403 | ALLB2324                | [AllocRef_ALLB]          | ?          | 4               | 0            | 1493.84     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202404 | ALLB2324                | [AllocRef_ALLB]          | ?          | 2               | 0            | 1783.60     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202404 | ALLB2324                | [AllocRef_ALLB]          | ?          | 3               | 0            | 609.71      |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202404 | ALLB2324                | [AllocRef_ALLB]          | ?          | 4               | 0            | 951.32      |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202405 | ALLB2324                | [AllocRef_ALLB]          | ?          | 2               | 0            | 2100.55     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202405 | ALLB2324                | [AllocRef_ALLB]          | ?          | 3               | 0            | 1159.46     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202405 | ALLB2324                | [AllocRef_ALLB]          | ?          | 4               | 0            | 200.33      |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202406 | ALLB2324                | [AllocRef_ALLB]          | ?          | 2               | 0            | 1309.97     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202406 | ALLB2324                | [AllocRef_ALLB]          | ?          | 3               | 0            | 278.64      |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202406 | ALLB2324                | [AllocRef_ALLB]          | ?          | 4               | 0            | 1200.39     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202407 | ALLB2324                | [AllocRef_ALLB]          | ?          | 2               | 0            | 1747.56     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202407 | ALLB2324                | [AllocRef_ALLB]          | ?          | 3               | 0            | 1910.20     |
    | ILR2324        | R01                  | ORG0017220     | CM             | 202407 | ALLB2324                | [AllocRef_ALLB]          | ?          | 4               | 0            | 2472.73     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


    # Check actuals in CRM

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_ALLB]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLB]    | 2               | 2498.70   | 2498.70  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLB]    | 3               | 1347.24   | 1347.24  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLB]    | 4               | 2090.31   | 2090.31  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | [ContractNo]   | [AllocRef_ALLF]    | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLF]    | 6               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLF]    | 7               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_ALLB]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLB]    | 2               | 2498.70   | 2498.70  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLB]    | 3               | 1347.24   | 1347.24  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLB]    | 4               | 2090.31   | 2090.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_ALLF]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_ALLB]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLB]    | 2               | 2498.70   | 2498.70  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLB]    | 3               | 1347.24   | 1347.24  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLB]    | 4               | 2090.31   | 2090.31  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_ALLF]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 





    # Payment Batch starts here for ALLB2324 (PoA)


    # Change the date
    Given the override date is '08/09/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ALLB2324' AccountingPaymentPeriod '202305' CensusEndDate '08/09/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_ALLB]          | 202308 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ALLB2324                   | 202308               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ALLB2324                   | 202308               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLB2324' PaymentPeriod '202305' CensusEndDate '08/09/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A220.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLB2324' PaymentPeriod '202305' CensusEndDate '08/09/2023' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription    | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | LBT                    | 2023          | 05             | 08          | ?       | [AllocRef_ALLB]   | 5936.25         | RECONCILIATION   | Adv LL Bursary           | 2023-09-22 | 2023-08-01   | 2024-07-31 | ?              | 10017220 | 2303800    |

    # Tidy Up
  # Given the override date is reset

@AcceptanceTest @InProgress
Scenario: A221 Bulk load a new EDSK2324 Loans contract with ALLBC and ALLF allocs (CofG LA). NFA. Check document parts and financials
    Given there is no Contract, Task or Workflow data for UKPRN '10017221' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017221' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Set the 'base' timestamp for each of the 23\24 EDSK Loans document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    Given the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | SOF_EDSK_2023-08-01.docx                        | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_TAC_AA_COLLEGE_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_AA_LA_2023-08-01.docx              | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_CFS_ITP_2023-08-01.docx            | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_EMPLOYER_2023-08-01.docx      | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_HEI_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_LA_2023-08-01.docx            | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_TRUST_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S1_LOANS_CFS_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_S1_LOANS_COFG_2023-08-01.docx          | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S2_LOANS_AA_COLLEGE_2023-08-01.docx    | 2023-03-01 12:00:00.000 |
    | EDSK2324_S2_LOANS_AA_LA_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    | EDSK2324_S2_LOANS_CFS_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_S2_LOANS_COFG_2023-08-01.docx          | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S3_LOANS_AA_COLLEGE_2023-08-01.docx    | 2023-03-01 12:00:00.000 |
    | EDSK2324_S3_LOANS_AA_LA_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    #
    | FA_EDSK2324_2023-08-01.docx                     | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S3ON_CFS_ITP_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_S3ON_COFG_EMPLOYER_2023-08-01.docx     | 2023-03-01 12:00:00.000 |
    | EDSK2324_S3ON_COFG_LA_TRUST_HEI_2023-08-01.docx | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S4ON_AA_COLLEGE_2023-08-01.docx        | 2023-03-01 12:00:00.000 |
    | EDSK2324_S4ON_AA_LA_2023-08-01.docx             | 2023-03-01 12:00:00.000 |




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017221' 
    And   there is no caseload advisor for UKPRN '10017221' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017221 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017221' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017221 Co Ltd' with UKPRN '10017221' and OrgId 'ORG0017221' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017221 | 117221 | 10017221 Co Ltd | 0              | Active                | Yes           | AA017221      | ?             | 301 Histon Road        | Cambridge              | ?                      | ?                      | ?                      | ?                      | CB4 3NF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017221 |





    # Bulk load a contract with New intent (ALLBC and ALLF, CofG LA)

    # Change the date
    Given the override date is '22/03/2023'

    # Bulk file
    And   there are no files prefixed '10017221' in the Sharepoint 'EDSK-2324-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2324 22032023111734 v3_A221' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2324 22032023111734 v3_A221' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2324 22032023111734 v3_A221' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2324 22032023111734 v3_A221' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2324 22032023111734 v3_A221.xlsx' exists in the Datafiles folder and UKPRN '10017221' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017221' for FundingType 'EDSK' and period '2324'

    # Check the contents of the Appendices 
    Then  the file named '10017221_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10017221 Co Ltd UKPRN: 10017221
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £36,785 £16,051 £52,836
    Advanced Learner Loans Bursary [AllocRef_ALLC] £24,773 £15,885 £40,658
    Total Funding for this contract: £93,494
    Summary of Funding – Page 1
    
    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    Funding Period 1 August 2023 to 31 July 2024
    Between the Secretary of State for Education
    And 10017221 Co Ltd
    Funding for Advanced Learner Loans
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE PROVIDER
    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
    THE PROVIDER REPRESENTS AND WARRANTS THAT THE PROVIDER HAS
    READ AND UNDERSTOOD THIS AGREEMENT, THE PROVIDER AGREES TO BE
    BOUND BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO
    ACCEPT THIS AGREEMENT AND LEGALLY BIND THE PROVIDER.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK Version 1 (April 2023) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017221 Co Ltd THE SECRETARY OF STATE FOR
    301 Histon Road EDUCATION
    Cambridge DEPARTMENT FOR EDUCATION
    CB4 3NF 20 GREAT SMITH STREET
    AND
    LONDON
    SW1P 3BT
    Company No: AA017221
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 1 (April 2023) Page 2
    EDSK Version 1 (April 2023) Page 74
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2023) – Page 1
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2023) – Page 9
    
    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Facility
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2023) – Page 1
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2023) – Page 2
    
    ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017221 Co Ltd UKPRN: 10017221
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Advanced Learner Loans Facility £52,836 £6,126 £3,291 £5,956 £3,800 £4,427 £436 £6,571 £6,178 £5,244 £96 £7,590 £3,121
    Total Funding £52,836 £6,126 £3,291 £5,956 £3,800 £4,427 £436 £6,571 £6,178 £5,244 £96 £7,590 £3,121
    Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017221 Co Ltd UKPRN: 10017221
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_ALLC]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Advanced Learner Loans Bursary Funding £40,658 £4,574 £3,098 £1,686 £3,809 £5,391 £2,758 £2,705 £752 £6,612 £2,823 £6,240 £210
    Total Funding £40,658 £4,574 £3,098 £1,686 £3,809 £5,391 £2,758 £2,705 £752 £6,612 £2,823 £6,240 £210
    Advanced Learner Loans – Funding Agreement [AllocRef_ALLC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 1 (April 2023) – Page 1
    EDSK Schedule 9 Version 1 (April 2023) – Page 5
    """

 #  # There should not be a ...
 #  And   the pdf file does not contain the following text
 #  """
 #  Blah
 #  """

   #And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-03-22 09:12:35.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017221_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A221.pdf'





    # Publish and approve

    # Change the date
    Given the override date is '24/03/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017221 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10017221 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_ALLC] | 2303975          | Jul-24 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                               | DeliverableDescription    | 
    | 10017221 | [ContractNo]   | 1               | [AllocRef_ALLC] | 1               | 0                     | 40658.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding  | ?                         |
    | 10017221 | [ContractNo]   | 1               | [AllocRef_ALLF] | 5               | 0                     | 52836.00     | 0             | 0        | Advanced Learner Loans Facility               | ?                         |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed




    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_ALLC]    | 1               | 40658.00  | 4574.00  | 3098.00  | 1686.00  | 3809.00  | 5391.00  | 2758.00  | 2705.00  | 752.00   | 6612.00  | 2823.00  | 6240.00  | 210.00   | 
    | [ContractNo]   | [AllocRef_ALLC]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLC]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLC]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_ALLF]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 52836.00  | 6126.00  | 3291.00  | 5956.00  | 3800.00  | 4427.00  | 436.00   | 6571.00  | 6178.00  | 5244.00  | 96.00    | 7590.00  | 3121.00  | 
    | [ContractNo]   | [AllocRef_ALLF]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_ALLC]    | 1               | 40658.00  | 4574.00  | 3098.00  | 1686.00  | 3809.00  | 5391.00  | 2758.00  | 2705.00  | 752.00   | 6612.00  | 2823.00  | 6240.00  | 210.00   | 
    | [ContractNo]   | [AllocRef_ALLC]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLC]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLC]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_ALLF]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    
    # Adjust template timestamps. Raise NFA. Check doc parts

       # To Do



    # Execute a NON-FINANCIAL amendment and check docs

    # Change the date
    Given the override date is '26/03/2023'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017221 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2023        | 31/07/2024      | Variation     |
    | 10017221 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10017221 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |


    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017221' for FundingType 'EDSK' and period '2324'

    # Check the contents of the Appendices 
    Then  the file named '10017221_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10017221 Co Ltd UKPRN: 10017221
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £36,785 £16,051 £52,836
    Advanced Learner Loans Bursary [AllocRef_ALLC] £24,773 £15,885 £40,658
    Total Funding for this contract: £93,494
    Summary of Funding – Page 1
    """

    # There should not be a TAC
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    """

 #  # There should not be a ... 
 #  And   the pdf file does not contain the following text
 #  """
 #  Blah
 #  """
 
    # Tidy Up
    Given the override date is reset

@AcceptanceTest @InProgress
Scenario: A222 Bulk load a new EDSK2324 Loans contract with ALLB and ALLF allocs (AA LA). NFA. Check document parts and financials
    Given there is no Contract, Task or Workflow data for UKPRN '10017222' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017222' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Associate a timestamp with a document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
    Given the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | SOF_EDSK_2023-08-01.docx                        | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_TAC_AA_COLLEGE_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_AA_LA_2023-08-01.docx              | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_CFS_ITP_2023-08-01.docx            | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_EMPLOYER_2023-08-01.docx      | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_HEI_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_LA_2023-08-01.docx            | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_TRUST_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S1_LOANS_CFS_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_S1_LOANS_COFG_2023-08-01.docx          | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S2_LOANS_AA_COLLEGE_2023-08-01.docx    | 2023-03-01 12:00:00.000 |
    | EDSK2324_S2_LOANS_AA_LA_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    | EDSK2324_S2_LOANS_CFS_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_S2_LOANS_COFG_2023-08-01.docx          | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S3_LOANS_AA_COLLEGE_2023-08-01.docx    | 2023-03-01 12:00:00.000 |
    | EDSK2324_S3_LOANS_AA_LA_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    #
    | FA_EDSK2324_2023-08-01.docx                     | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S3ON_CFS_ITP_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_S3ON_COFG_EMPLOYER_2023-08-01.docx     | 2023-03-01 12:00:00.000 |
    | EDSK2324_S3ON_COFG_LA_TRUST_HEI_2023-08-01.docx | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S4ON_AA_COLLEGE_2023-08-01.docx        | 2023-03-01 12:00:00.000 |
    | EDSK2324_S4ON_AA_LA_2023-08-01.docx             | 2023-03-01 12:00:00.000 |




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017222' 
    And   there is no caseload advisor for UKPRN '10017222' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017222 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017222' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017222 Co Ltd' with UKPRN '10017222' and OrgId 'ORG0017222' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017222 | 117222 | 10017222 Co Ltd | 0              | Active                | Yes           | AA017222      | ?             | 15 Blackdown Gardens   | Clatterbridge          | ?                      | ?                      | ?                      | ?                      | CB4 8BF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017222 |





    # Bulk load a contract with New intent (ALLB and ALLF, AA LA)

    # Change the date
    Given the override date is '22/03/2023'

    # Bulk file
    And   there are no files prefixed '10017222' in the Sharepoint 'EDSK-2324-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2324 23032023124211 v3_A222' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2324 23032023124211 v3_A222' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2324 23032023124211 v3_A222' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2324 23032023124211 v3_A222' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2324 23032023124211 v3_A222.xlsx' exists in the Datafiles folder and UKPRN '10017222' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017222' for FundingType 'EDSK' and period '2324'

    # Check the contents of the Appendices 
    Then  the file named '10017222_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10017222 Co Ltd UKPRN: 10017222
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £35,922 £23,081 £59,003
    Advanced Learner Loans Bursary [AllocRef_ALLB] £24,246 £16,751 £40,997
    Total Funding for this contract: £100,000
    Summary of Funding – Page 1
    
    Agreement Type Accountability Agreement (Local Authorities)
    Funding Period 1 August 2023 to 31 July 2024
    Between the Secretary of State for Education
    And 10017222 Co Ltd
    Funding for Advanced Learner Loans
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE PROVIDER
    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
    THE PROVIDER REPRESENTS AND WARRANTS THAT THE PROVIDER HAS
    READ AND UNDERSTOOD THIS AGREEMENT, THE PROVIDER AGREES TO BE
    BOUND BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO
    ACCEPT THIS AGREEMENT AND LEGALLY BIND THE PROVIDER.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    Accountability Agreement (LA) Version 1 (April 2023) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017222 Co Ltd THE SECRETARY OF STATE FOR
    15 Blackdown Gardens EDUCATION
    Clatterbridge DEPARTMENT FOR EDUCATION
    CB4 8BF 20 GREAT SMITH STREET
    AND
    LONDON
    SW1P 3BT
    Company No: AA017222
    Hereinafter called Hereinafter called
    the Provider the Department
    Accountability Agreement (LA) Version 1 (April 2023) Page 2
    Accountability Agreement (LA) Version 1 (April 2023) Page 73
    
    SCHEDULE 2: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    Schedule 2 – Advanced Learner Loans Version 1 (April 2023) – Page 1
    Schedule 2 – Advanced Learner Loans Version 1 (April 2023) – Page 9

    SCHEDULE 3: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Facility
    Schedule 3 – Advanced Learner Loans Version 1 (April 2023) – Page 1
    Schedule 3 – Advanced Learner Loans Version 1 (April 2023) – Page 2
    
    ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017222 Co Ltd UKPRN: 10017222
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Advanced Learner Loans Facility £59,003 £3,265 £5,135 £7,373 £4,539 £5,204 £5,048 £3,675 £1,683 £7,819 £7,426 £6,492 £1,344
    Total Funding £59,003 £3,265 £5,135 £7,373 £4,539 £5,204 £5,048 £3,675 £1,683 £7,819 £7,426 £6,492 £1,344
    Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017222 Co Ltd UKPRN: 10017222
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_ALLB]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Advanced Learner Loans Bursary Funding £40,997 £3,722 £1,971 £2,113 £3,637 £2,226 £4,349 £2,930 £3,298 £3,245 £2,992 £7,152 £3,362
    Total Funding £40,997 £3,722 £1,971 £2,113 £3,637 £2,226 £4,349 £2,930 £3,298 £3,245 £2,992 £7,152 £3,362
    Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 4: UK GDPR/DATA PROTECTION
    Schedule 4 Version 1 (April 2023) – Page 1
    Schedule 9 Version 1 (April 2023) – Page 1
    """

 #  # There should not be a ...
 #  And   the pdf file does not contain the following text
 #  """
 #  Blah
 #  """

   #And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-03-22 09:12:35.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017222_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A222.pdf'





    # Publish and approve

    # Change the date
    Given the override date is '24/03/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017222 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10017222 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_ALLB] | 2303800          | Jul-24 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                               | DeliverableDescription    | 
    | 10017222 | [ContractNo]   | 1               | [AllocRef_ALLB] | 1               | 0                     | 40997.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding  | ?                         |
    | 10017222 | [ContractNo]   | 1               | [AllocRef_ALLF] | 5               | 0                     | 59003.00     | 0             | 0        | Advanced Learner Loans Facility               | ?                         |


    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed




    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_ALLB]    | 1               | 40997.00  | 3722.00  | 1971.00  | 2113.00  | 3637.00  | 2226.00  | 4349.00  | 2930.00  | 3298.00  | 3245.00  | 2992.00  | 7152.00  | 3362.00  | 
    | [ContractNo]   | [AllocRef_ALLB]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLB]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLB]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_ALLF]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 59003.00  | 3265.00  | 5135.00  | 7373.00  | 4539.00  | 5204.00  | 5048.00  | 3675.00  | 1683.00  | 7819.00  | 7426.00  | 6492.00  | 1344.00  | 
    | [ContractNo]   | [AllocRef_ALLF]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 



    
    # Adjust template timestamps. Raise NFA. Check doc parts

       # To Do



    # Execute a NON-FINANCIAL amendment and check docs

    # Change the date
    Given the override date is '26/03/2023'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017222 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2023        | 31/07/2024      | Variation     |
    | 10017222 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10017222 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |


    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017222' for FundingType 'EDSK' and period '2324'

    # Check the contents of the Appendices 
    Then  the file named '10017222_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10017222 Co Ltd UKPRN: 10017222
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £35,922 £23,081 £59,003
    Advanced Learner Loans Bursary [AllocRef_ALLB] £24,246 £16,751 £40,997
    Total Funding for this contract: £100,000
    Summary of Funding – Page 1
    """

    # There should not be a TAC
    And   the pdf file does not contain the following text
    """
    Agreement Type Accountability Agreement (Local Authorities)
    """

 #  # There should not be a ... 
 #  And   the pdf file does not contain the following text
 #  """
 #  Blah
 #  """
 
    # Tidy Up
    Given the override date is reset

@AcceptanceTest @InProgress
Scenario: A223 Bulk load a new EDSK2324 Loans contract with ALLBC and ALLF allocs (AA College). NFA. Check document parts. PoP batch. Check financials
    Given there is no Contract, Task or Workflow data for UKPRN '10017223' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017223' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Set the 'base' timestamp for each of the 23\24 EDSK Loans document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    Given the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | SOF_EDSK_2023-08-01.docx                        | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_TAC_AA_COLLEGE_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_AA_LA_2023-08-01.docx              | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_CFS_ITP_2023-08-01.docx            | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_EMPLOYER_2023-08-01.docx      | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_HEI_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_LA_2023-08-01.docx            | 2023-03-01 12:00:00.000 |
    | EDSK2324_TAC_COFG_TRUST_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S1_LOANS_CFS_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_S1_LOANS_COFG_2023-08-01.docx          | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S2_LOANS_AA_COLLEGE_2023-08-01.docx    | 2023-03-01 12:00:00.000 |
    | EDSK2324_S2_LOANS_AA_LA_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    | EDSK2324_S2_LOANS_CFS_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_S2_LOANS_COFG_2023-08-01.docx          | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S3_LOANS_AA_COLLEGE_2023-08-01.docx    | 2023-03-01 12:00:00.000 |
    | EDSK2324_S3_LOANS_AA_LA_2023-08-01.docx         | 2023-03-01 12:00:00.000 |
    #
    | FA_EDSK2324_2023-08-01.docx                     | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S3ON_CFS_ITP_2023-08-01.docx           | 2023-03-01 12:00:00.000 |
    | EDSK2324_S3ON_COFG_EMPLOYER_2023-08-01.docx     | 2023-03-01 12:00:00.000 |
    | EDSK2324_S3ON_COFG_LA_TRUST_HEI_2023-08-01.docx | 2023-03-01 12:00:00.000 |
    #
    | EDSK2324_S4ON_AA_COLLEGE_2023-08-01.docx        | 2023-03-01 12:00:00.000 |
    | EDSK2324_S4ON_AA_LA_2023-08-01.docx             | 2023-03-01 12:00:00.000 |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017223' 
    And   there is no caseload advisor for UKPRN '10017223' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017223 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017223' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017223 Co Ltd' with UKPRN '10017223' and OrgId 'ORG0017223' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017223 | 117223 | 10017223 Co Ltd | 0              | Active                | Yes           | AA017223      | ?             | 8 Grassmere Road       | Battle                 | Shrewsbury             | ?                      | ?                      | ?                      | SY4 1DF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017223 |





    # Bulk load a contract with New intent (ALLBC and ALLF, AA College)

    # Change the date
    Given the override date is '22/03/2023'

    # Bulk file
    And   there are no files prefixed '10017223' in the Sharepoint 'EDSK-2324-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2324 24032023082204 v3_A223' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2324 24032023082204 v3_A223' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2324 24032023082204 v3_A223' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2324 24032023082204 v3_A223' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2324 24032023082204 v3_A223.xlsx' exists in the Datafiles folder and UKPRN '10017223' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017223' for FundingType 'EDSK' and period '2324'

    # Check the contents of the Appendices 
    Then  the file named '10017223_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10017223 Co Ltd UKPRN: 10017223
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £38,292 £11,186 £49,478
    Advanced Learner Loans Bursary [AllocRef_ALLC] £33,730 £16,791 £50,521
    Total Funding for this contract: £99,999
    Summary of Funding – Page 1
    
    Agreement Type Accountability Agreement (Colleges)
    Funding Period 1 August 2023 to 31 July 2024
    Between the Secretary of State for Education
    And 10017223 Co Ltd
    Funding for Advanced Learner Loans
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
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    Accountability Agreement (College) Version 1 (April 2023) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    College on the Manage Your Education & Skills Funding Service between:
    10017223 Co Ltd THE SECRETARY OF STATE FOR
    8 Grassmere Road EDUCATION
    Battle DEPARTMENT FOR EDUCATION
    Shrewsbury AND 20 GREAT SMITH STREET
    SY4 1DF LONDON
    SW1P 3BT
    Company No: AA017223
    Hereinafter called Hereinafter called
    the College the Department
    Accountability Agreement (College) Version 1 (April 2023) Page 2
    Accountability Agreement (College) Version 1 (April 2023) Page 71
    
    SCHEDULE 2: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    Schedule 2 – Advanced Learner Loans Version 1 (April 2023) – Page 1
    Schedule 2 – Advanced Learner Loans Version 1 (April 2023) – Page 9
    
    SCHEDULE 3: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Facility
    Schedule 3 – Advanced Learner Loans Version 1 (April 2023) – Page 1
    Schedule 3 – Advanced Learner Loans Version 1 (April 2023) – Page 2

    ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017223 Co Ltd UKPRN: 10017223
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Advanced Learner Loans Facility £49,478 £6,224 £6,194 £2,382 £7,498 £2,212 £4,456 £4,683 £4,643 £2,827 £2,434 £1,622 £4,303
    Total Funding £49,478 £6,224 £6,194 £2,382 £7,498 £2,212 £4,456 £4,683 £4,643 £2,827 £2,434 £1,622 £4,303
    Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017223 Co Ltd UKPRN: 10017223
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_ALLC]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    Advanced Learner Loans Bursary Funding £50,521 £4,158 £2,406 £5,549 £4,073 £2,661 £4,784 £6,366 £3,733 £3,680 £1,727 £7,587 £3,797
    Total Funding £50,521 £4,158 £2,406 £5,549 £4,073 £2,661 £4,784 £6,366 £3,733 £3,680 £1,727 £7,587 £3,797
    Advanced Learner Loans – Funding Agreement [AllocRef_ALLC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 4: UK GDPR/DATA PROTECTION
    Schedule 4 Version 1 (April 2023) – Page 1
    Schedule 9 Version 1 (April 2023) – Page 1
    """

 #  # There should not be a ...
 #  And   the pdf file does not contain the following text
 #  """
 #  Blah
 #  """

   #And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-03-22 09:12:35.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017223_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A223.pdf'





    # Publish and approve

    # Change the date
    Given the override date is '24/03/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017223 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10017223 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_ALLC] | 2303975          | Jul-24 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                               | DeliverableDescription    | 
    | 10017223 | [ContractNo]   | 1               | [AllocRef_ALLC] | 1               | 0                     | 50521.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding  | ?                         |
    | 10017223 | [ContractNo]   | 1               | [AllocRef_ALLF] | 5               | 0                     | 49478.00     | 0             | 0        | Advanced Learner Loans Facility               | ?                         |


    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed




    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_ALLC]    | 1               | 50521.00  | 4158.00  | 2406.00  | 5549.00  | 4073.00  | 2661.00  | 4784.00  | 6366.00  | 3733.00  | 3680.00  | 1727.00  | 7587.00  | 3797.00  | 
    | [ContractNo]   | [AllocRef_ALLC]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLC]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLC]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_ALLF]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 49478.00  | 6224.00  | 6194.00  | 2382.00  | 7498.00  | 2212.00  | 4456.00  | 4683.00  | 4643.00  | 2827.00  | 2434.00  | 1622.00  | 4303.00  | 
    | [ContractNo]   | [AllocRef_ALLF]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_ALLC]    | 1               | 50521.00  | 4158.00  | 2406.00  | 5549.00  | 4073.00  | 2661.00  | 4784.00  | 6366.00  | 3733.00  | 3680.00  | 1727.00  | 7587.00  | 3797.00  | 
    | [ContractNo]   | [AllocRef_ALLC]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLC]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLC]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    # 
    | [ContractNo]   | [AllocRef_ALLF]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    
    # Adjust template timestamps. Raise NFA. Check doc parts

       # To Do



    # Execute a NON-FINANCIAL amendment and check docs

    # Change the date
    Given the override date is '26/03/2023'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017223 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2023        | 31/07/2024      | Variation     |
    | 10017223 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2023        | 31/07/2024      | ?             |
    | 10017223 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |


    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017223' for FundingType 'EDSK' and period '2324'

    # Check the contents of the Appendices 
    Then  the file named '10017223_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10017223 Co Ltd UKPRN: 10017223
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £38,292 £11,186 £49,478
    Advanced Learner Loans Bursary [AllocRef_ALLC] £33,730 £16,791 £50,521
    Total Funding for this contract: £99,999
    Summary of Funding – Page 1
    """

    # There should not be a TAC
    And   the pdf file does not contain the following text
    """
    Agreement Type TAC for AA College
    """

 #  # There should not be a ... 
 #  And   the pdf file does not contain the following text
 #  """
 #  Blah
 #  """





    # Publish and approve

    # Change the date
    Given the override date is '28/03/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017223 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2023        | 31/07/2024      | Variation     |
    | 10017223 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10017223 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_ALLC] | 2303900          | Jul-24 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                               | DeliverableDescription    | 
    | 10017223 | [ContractNo]   | 2               | [AllocRef_ALLC] | 1               | 0                     | 50521.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding  | ?                         |
    | 10017223 | [ContractNo]   | 2               | [AllocRef_ALLF] | 5               | 0                     | 49478.00     | 0             | 0        | Advanced Learner Loans Facility               | ?                         |





    # Payment Batch starts here for ALLBC2324 (PoP)


    # Change the date
    Given the override date is '02/08/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ALLBC2324' AccountingPaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_ALLC]          | 202308 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ALLBC2324                  | 202308               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ALLBC2324                  | 202308               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLBC2324' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A223.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLBC2324' PaymentPeriod '202305' CensusEndDate '02/08/2023' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription    | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | LBCO                   | 2023          | 05             | 02          | ?       | [AllocRef_ALLC]   | 4158.00         | PROFILE          | Adv LL Bursary           | 2023-08-18 | 2023-08-01   | 2024-07-31 | ?              | 10017223 | 2303900    |

    # Tidy Up
 #  Given the override date is reset

