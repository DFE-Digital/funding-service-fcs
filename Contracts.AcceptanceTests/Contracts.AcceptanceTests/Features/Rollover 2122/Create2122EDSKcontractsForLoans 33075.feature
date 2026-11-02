Feature: Create2122EDSKcontractsForLoans 33075

@AcceptanceTest @Withdrawn20230123
Scenario: A182 Bulk create a new 2122 EDSK contract with ALLF, ALLB and ALLBC allocations. Publish and approve. NFA. Check CRM, PaaS and docs
    Given there are no allocations marked as Under Termination for UKPRN '10017182' 
    And   there are no terminated or closed allocations for UKPRN '10017182' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017182' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017182' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017182' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLB2122          |
    | ALLBC2122         |
    | ALLF2122          |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017182'

    # Set the 'base' timestamp for each of the 21\22 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_EDSK_2021-08-01.docx                        | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_TAC_CFS_ITP_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_COLLEGE_2021-08-01.docx       | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_EMPLOYER_2021-08-01.docx      | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_HEI_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_LA_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_TRUST_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S1_LOANS_CFS_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_LOANS_COFG_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S2_LOANS_CFS_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_LOANS_COFG_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    # 
    | FA_EDSK2122_2021-08-01.docx                     | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S3ON_CFS_ITP_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_COLLEGE_2021-08-01.docx      | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_EMPLOYER_2021-08-01.docx     | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_LA_TRUST_HEI_2021-08-01.docx | 2021-06-07 12:00:00.000 | 




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017182' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017182 Co Ltd' with UKPRN '10017182' and OrgId 'ORG0017182' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017182' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017182 | 117182 | 10017182 Co Ltd | 0              | Provider Under Change | Yes           | AA017182      | ?             | 45 Hagley Road         | ?                      | ?                      | ?                      | Stourbridge            | West Midlands          | DY8 1QR   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017182 |




    # Change the date
    Given the override date is '01/07/2021'

    # Bulk NEW file - Conditions of Funding (Grant)(LA)
    And   there are no files prefixed '10017182' in the Sharepoint 'EDSK-2122-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2122 18032021123142 v3_A182' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2122 18032021123142 v3_A182' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2122 18032021123142 v3_A182' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2122 18032021123142 v3_A182' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2122 18032021123142 v3_A182.xlsx' exists in the Datafiles folder and UKPRN '10017182' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017182' for FundingType 'EDSK' and period '2122' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017182' for FundingType 'EDSK' and period '2122'

    # Check the contents of the Appendices
    Then  the file named '10017182_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    Organisation Name: 10017182 Co Ltd UKPRN: 10017182
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 2021/22 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £39,336 £13,664 £53,000
    Advanced Learner Loans Bursary [AllocRef_ALLB] £39,627 £10,373 £50,000
    Advanced Learner Loans Bursary [AllocRef_ALLC] £26,522 £20,478 £47,000
    Total Funding for this contract: £150,000
    Summary of Funding – Page 1

    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017182 Co Ltd
    Funding for Advanced Learner Loans
    Master Agreement Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    EDSK Version 3 (April 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017182 Co Ltd THE SECRETARY OF STATE FOR
    45 Hagley Road
    EDUCATION
    Stourbridge
    DEPARTMENT FOR EDUCATION
    West Midlands
    20 GREAT SMITH STREET
    AND
    DY8 1QR
    LONDON
    SW1P 3BT
    Company No: AA017182
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (April 2022) Page 2
    EDSK Version 3 (April 2022) Page 75
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2021) – Page 1
    EDSK Schedule 1 – Advanced Learner Loans Version 1 (April 2021) – Page 9
    
    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Facility
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2021) – Page 1
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (April 2021) – Page 2

    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017182 Co Ltd UKPRN: 10017182
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Advanced Learner Loans Facility £53,000 £3,569 £4,124 £7,788 £3,595 £4,497 £3,902 £5,686 £6,175 £481 £3,765 £3,987 £5,431
    Total Funding £53,000 £3,569 £4,124 £7,788 £3,595 £4,497 £3,902 £5,686 £6,175 £481 £3,765 £3,987 £5,431
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017182 Co Ltd UKPRN: 10017182
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_ALLB]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Advanced Learner Loans Bursary Funding £50,000 £4,895 £3,144 £6,286 £4,810 £3,398 £5,521 £7,103 £4,470 £3,001 £2,464 £373 £4,535
    Total Funding £50,000 £4,895 £3,144 £6,286 £4,810 £3,398 £5,521 £7,103 £4,470 £3,001 £2,464 £373 £4,535
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLB] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10017182 Co Ltd UKPRN: 10017182
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_ALLC]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    Advanced Learner Loans Bursary Funding £47,000 £626 £2,548 £4,735 £1,900 £4,300 £2,410 £3,037 £6,966 £5,180 £4,788 £3,854 £6,656
    Total Funding £47,000 £626 £2,548 £4,735 £1,900 £4,300 £2,410 £3,037 £6,966 £5,180 £4,788 £3,854 £6,656
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 Version 2 (July 2021) – Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017182_[ContractNo]_v1.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A182v1.pdf'

    # Contract status is now at 'Awaiting Documentation'



    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this 
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-01 09:11:46.000 |
 

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017182 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017182 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '144' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_ALLB] | 2303800          | Jul-22 | Reconciliation |
    | [AllocRef_ALLC] | 2303975          | Jul-22 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription   | 
    | 10017182 | [ContractNo]   | 1               | [AllocRef_ALLB] | 1               | 0                     | 50000.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding   | ?                        |
    | 10017182 | [ContractNo]   | 1               | [AllocRef_ALLC] | 1               | 0                     | 47000.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding   | ?                        |
    | 10017182 | [ContractNo]   | 1               | [AllocRef_ALLF] | 5               | 0                     | 53000.00     | 0             | 0        | Advanced Learner Loans Facility                | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed





    # NFA amendment then check doc parts (No doc templates have changed since v1 was generated)

    Given the override date is '04/07/2021'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017182 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017182 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017182 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the contents of the Appendices
    Then  the file named '10017182_[ContractNo]_v2.pdf' in Sharepoint location 'EDSK-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2021/22
    """
    
    # There shouldn't be a T&C doc
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    """

    # There shouldn't be a Sch1 doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """

    # There shouldn't be a Sch2 doc
    And   the pdf file does not contain the following text
    """  
    SCHEDULE 2: PAYMENT
    """
    
    # There shouldn't be a Sch3ON doc
    And   the pdf file does not contain the following text
    """  
    SCHEDULE 3: NOT USED
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017182_[ContractNo]_v2.pdf' in 'EDSK-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A182v2.pdf'

    # Contract status is now at 'Awaiting Documentation'


    # Tidy Up
    And   the override date is reset
    
@AcceptanceTest @Withdrawn20230123
Scenario: A181 Create and approve a new 2122 EDSK contract with ALLF, ALLB and ALLBC allocations. Bulk amend and approve. Consume actuals. Check CRM, financials, PaaS, CDA and Feed
    Given there are no allocations marked as Under Termination for UKPRN '10017181' 
    And   there are no terminated or closed allocations for UKPRN '10017181' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017181' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017181' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017181' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLB-181      |
    | ALLC-181      |
    | ALLF-181      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ALLB-181      |
    | ALLC-181      |
    | ALLF-181      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLB2122          |
    | ALLBC2122         |
    | ALLF2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-181       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017181'

    # Set the 'base' timestamp for each of the 21\22 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_EDSK_2021-08-01.docx                        | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_TAC_CFS_ITP_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_COLLEGE_2021-08-01.docx       | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_EMPLOYER_2021-08-01.docx      | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_HEI_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_LA_2021-08-01.docx            | 2021-06-07 12:00:00.000 | 
    | EDSK2122_TAC_COFG_TRUST_2021-08-01.docx         | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S1_LOANS_CFS_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S1_LOANS_COFG_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S2_LOANS_CFS_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S2_LOANS_COFG_2021-08-01.docx          | 2021-06-07 12:00:00.000 | 
    # 
    | FA_EDSK2122_2021-08-01.docx                     | 2021-06-07 12:00:00.000 | 
    # 
    | EDSK2122_S3ON_CFS_ITP_2021-08-01.docx           | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_COLLEGE_2021-08-01.docx      | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_EMPLOYER_2021-08-01.docx     | 2021-06-07 12:00:00.000 | 
    | EDSK2122_S3ON_COFG_LA_TRUST_HEI_2021-08-01.docx | 2021-06-07 12:00:00.000 | 




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017181' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017181 Co Ltd' with UKPRN '10017181' and OrgId 'ORG0017181' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017181' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017181 | 117181 | 10017181 Co Ltd | 0              | In Administration     | Yes           | AA017181      | ?             | 9 Colme Street         | Edinburgh              | ?                      | ?                      | ?                      | ?                      | EH3 6AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017181 |




    # Change the date
    Given the override date is '01/07/2021'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017181 | 10017181 Co Ltd      | ESFA-181             | EDSK-181       | 1                     | 01/08/2021        | 31/07/2022      | 78340.00      |                                       | Conditions of Funding (Grant) (Employer)   | 2122   | New          | ORG0017181 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017181 | EDSK-181       | ALLB-181      | ALLB              | ALLB2122                | AY                      | 01/08/2021          | 31/07/2022        | 26009.00        |                                         |            |                                                             | New          |             |
    | 10017181 | EDSK-181       | ALLC-181      | ALLBC             | ALLBC2122               | AY                      | 01/08/2021          | 31/07/2022        | 32937.00        |                                         |            |                                                             | New          |             |
    | 10017181 | EDSK-181       | ALLF-181      | ALLF              | ALLF2122                | AY                      | 01/08/2021          | 31/07/2022        | 19394.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017181 | EDSK-181       | ALLB-181      | 1               | 0                     | 26009.00  | 14629.00  | 11380.00  | 2033.00  | 2137.00  | 2809.00  | 793.00   | 422.00   | 2517.00  | 2651.00  | 1267.00  | 1717.00  | 3086.00  | 3664.00  | 2913.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             | 
    | 10017181 | EDSK-181       | ALLC-181      | 1               | 0                     | 32937.00  | 23527.00  | 9410.00   | 3321.00  | 2980.00  | 3019.00  | 2901.00  | 3257.00  | 2189.00  | 2673.00  | 3187.00  | 663.00   | 2570.00  | 2515.00  | 3662.00  | Total Advanced Learner Loans Bursary Funding                    | New          |             | 
    | 10017181 | EDSK-181       | ALLF-181      | 5               | 0                     | 19394.00  | 13920.00  | 5474.00   | 1095.00  | 1293.00  | 700.00   | 2479.00  | 843.00   | 3032.00  | 2884.00  | 1594.00  | 779.00   | 2242.00  | 1555.00  | 898.00   | Advanced Learner Loans Facility                                 | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-181       | 1                     | 0                        | 2021-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-181'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-181' and actual ContractNumber 'EDSK-181'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-181' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017181 | EDSK-181           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017181 | ESFA-181           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-181' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '144' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '144' deliverable period rows in CRM linked to the latest version of contract 'EDSK-181'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | ALLB-181        | 2303800          | Jul-22 | Reconciliation |
    | ALLC-181        | 2303975          | Jul-22 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10017181 | EDSK-181       | 1               | ALLB-181      | 1               | 0                     | 26009.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding                    | ?                                                           |
    | 10017181 | EDSK-181       | 1               | ALLC-181      | 1               | 0                     | 32937.00     | 0             | 0        | Total Advanced Learner Loans Bursary Funding                    | ?                                                           |
    | 10017181 | EDSK-181       | 1               | ALLF-181      | 5               | 0                     | 19394.00     | 0             | 0        | Advanced Learner Loans Facility                                 | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'EDSK-181' agree with the most recent entry for this contract in the ContractManagement feed





    # Change the date
    Given the override date is '23/08/2021'

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-181       | 1                     | 0                        | 

#    # Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version A181.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | EDSK-181       | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod         | Version               | Suffix |
#    | ALLB2122,ALLBC2122,ALLF2122 | Latest Version        | A181   |
#
#    Then  a report named 'CDA Latest Version A181.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | ALLB2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLB-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 8                 | 2021            | 2021/22       |              | 2033         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | ALLB2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLB-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 9                 | 2021            | 2021/22       |              | 2137         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | ALLB2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLB-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 10                | 2021            | 2021/22       |              | 2809         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | ALLB2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLB-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 11                | 2021            | 2021/22       |              | 793          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | ALLB2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLB-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 12                | 2021            | 2021/22       |              | 422          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | ALLB2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLB-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 1                 | 2022            | 2021/22       |              | 2517         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | ALLB2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLB-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 2                 | 2022            | 2021/22       |              | 2651         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | ALLB2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLB-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 3                 | 2022            | 2021/22       |              | 1267         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | ALLB2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLB-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 4                 | 2022            | 2022/23       |              | 1717         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | ALLB2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLB-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 5                 | 2022            | 2022/23       |              | 3086         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | ALLB2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLB-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 6                 | 2022            | 2022/23       |              | 3664         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | ALLB2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLB-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 7                 | 2022            | 2022/23       |              | 2913         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    #
#    | ALLBC2122               | 10017181 | 10017181 Co Ltd             |               |                             | ALLC-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 8                 | 2021            | 2021/22       |              | 3321         |              |               |              | Yes                | 3321.00        | 0.00             | 0.00                  | 0.00           | 3321.00         |             | No            |                   |        | 2303900           | 2303975                  |                   | Aug              |
#    | ALLBC2122               | 10017181 | 10017181 Co Ltd             |               |                             | ALLC-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 9                 | 2021            | 2021/22       |              | 2980         |              |               |              | Yes                | 2980.00        |                  | 0.00                  | 0.00           | 2980.00         |             | No            |                   |        | 2303900           | 2303975                  |                   | Sep              |
#    | ALLBC2122               | 10017181 | 10017181 Co Ltd             |               |                             | ALLC-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 10                | 2021            | 2021/22       |              | 3019         |              |               |              | Yes                | 3019.00        |                  | 0.00                  | 0.00           | 3019.00         |             | No            |                   |        | 2303900           | 2303975                  |                   | Oct              |
#    | ALLBC2122               | 10017181 | 10017181 Co Ltd             |               |                             | ALLC-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 11                | 2021            | 2021/22       |              | 2901         |              |               |              | Yes                | 2901.00        |                  | 0.00                  | 0.00           | 2901.00         |             | No            |                   |        | 2303900           | 2303975                  |                   | Nov              |
#    | ALLBC2122               | 10017181 | 10017181 Co Ltd             |               |                             | ALLC-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 12                | 2021            | 2021/22       |              | 3257         |              |               |              | Yes                | 3257.00        |                  | 0.00                  | 0.00           | 3257.00         |             | No            |                   |        | 2303900           | 2303975                  |                   | Dec              |
#    | ALLBC2122               | 10017181 | 10017181 Co Ltd             |               |                             | ALLC-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 1                 | 2022            | 2021/22       |              | 2189         |              |               |              | Yes                | 2189.00        |                  | 0.00                  | 0.00           | 2189.00         |             | No            |                   |        | 2303900           | 2303975                  |                   | Jan              |
#    | ALLBC2122               | 10017181 | 10017181 Co Ltd             |               |                             | ALLC-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 2                 | 2022            | 2021/22       |              | 2673         |              |               |              | Yes                | 2673.00        |                  | 0.00                  | 0.00           | 2673.00         |             | No            |                   |        | 2303900           | 2303975                  |                   | Feb              |
#    | ALLBC2122               | 10017181 | 10017181 Co Ltd             |               |                             | ALLC-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 3                 | 2022            | 2021/22       |              | 3187         |              |               |              | Yes                | 3187.00        |                  | 0.00                  | 0.00           | 3187.00         |             | No            |                   |        | 2303900           | 2303975                  |                   | Mar              |
#    | ALLBC2122               | 10017181 | 10017181 Co Ltd             |               |                             | ALLC-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 4                 | 2022            | 2022/23       |              | 663          |              |               |              | Yes                | 663.00         |                  | 0.00                  | 0.00           | 663.00          |             | No            |                   |        | 2303900           | 2303975                  |                   | Apr              |
#    | ALLBC2122               | 10017181 | 10017181 Co Ltd             |               |                             | ALLC-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 5                 | 2022            | 2022/23       |              | 2570         |              |               |              | Yes                | 2570.00        |                  | 0.00                  | 0.00           | 2570.00         |             | No            |                   |        | 2303900           | 2303975                  |                   | May              |
#    | ALLBC2122               | 10017181 | 10017181 Co Ltd             |               |                             | ALLC-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 6                 | 2022            | 2022/23       |              | 2515         |              |               |              | Yes                | 2515.00        |                  | 0.00                  | 0.00           | 2515.00         |             | No            |                   |        | 2303900           | 2303975                  |                   | Jun              |
#    | ALLBC2122               | 10017181 | 10017181 Co Ltd             |               |                             | ALLC-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Total Advanced Learner Loans Bursary Funding                    |                                                                 | 7                 | 2022            | 2022/23       |              | 3662         |              |               |              | Yes                | 3662.00        |                  | 0.00                  | 0.00           | 3662.00         |             | No            |                   |        | 2303900           | 2303975                  |                   | Jul              |
#    #
#    | ALLF2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLF-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 8                 | 2021            | 2021/22       |              | 1095         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | ALLF2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLF-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 9                 | 2021            | 2021/22       |              | 1293         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | ALLF2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLF-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 10                | 2021            | 2021/22       |              | 700          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | ALLF2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLF-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 11                | 2021            | 2021/22       |              | 2479         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | ALLF2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLF-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 12                | 2021            | 2021/22       |              | 843          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | ALLF2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLF-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 1                 | 2022            | 2021/22       |              | 3032         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | ALLF2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLF-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 2                 | 2022            | 2021/22       |              | 2884         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | ALLF2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLF-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 3                 | 2022            | 2021/22       |              | 1594         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | ALLF2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLF-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 4                 | 2022            | 2022/23       |              | 779          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | ALLF2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLF-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 5                 | 2022            | 2022/23       |              | 2242         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | ALLF2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLF-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 6                 | 2022            | 2022/23       |              | 1555         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | ALLF2122                | 10017181 | 10017181 Co Ltd             |               |                             | ALLF-181                 | EDSK-181       | ESFA-181                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 7                 | 2022            | 2022/23       |              | 898          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |





    # Add actuals to the contract

    # Change the date
    Given the override date is '04/10/2021'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017181'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2021
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202108 | ALLB2122                | ALLB-181                 | ?          | 2               | 0            | 1365.67     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202108 | ALLB2122                | ALLB-181                 | ?          | 3               | 0            | 2472.15     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202108 | ALLB2122                | ALLB-181                 | ?          | 4               | 0            | 2388.13     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202109 | ALLB2122                | ALLB-181                 | ?          | 2               | 0            | 1183.98     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202109 | ALLB2122                | ALLB-181                 | ?          | 3               | 0            | 1215.02     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202109 | ALLB2122                | ALLB-181                 | ?          | 4               | 0            | 2116.09     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202110 | ALLB2122                | ALLB-181                 | ?          | 2               | 0            | 1680.30     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202110 | ALLB2122                | ALLB-181                 | ?          | 3               | 0            | 2035.37     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202110 | ALLB2122                | ALLB-181                 | ?          | 4               | 0            | 677.07      |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202111 | ALLB2122                | ALLB-181                 | ?          | 2               | 0            | 681.29      |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202111 | ALLB2122                | ALLB-181                 | ?          | 3               | 0            | 1330.57     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202111 | ALLB2122                | ALLB-181                 | ?          | 4               | 0            | 846.85      |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202112 | ALLB2122                | ALLB-181                 | ?          | 2               | 0            | 1955.69     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202112 | ALLB2122                | ALLB-181                 | ?          | 3               | 0            | 1906.20     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202112 | ALLB2122                | ALLB-181                 | ?          | 4               | 0            | 2273.66     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202201 | ALLB2122                | ALLB-181                 | ?          | 2               | 0            | 1564.30     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202201 | ALLB2122                | ALLB-181                 | ?          | 3               | 0            | 1763.31     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202201 | ALLB2122                | ALLB-181                 | ?          | 4               | 0            | 2003.43     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202202 | ALLB2122                | ALLB-181                 | ?          | 2               | 0            | 1621.60     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202202 | ALLB2122                | ALLB-181                 | ?          | 3               | 0            | 401.51      |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202202 | ALLB2122                | ALLB-181                 | ?          | 4               | 0            | 808.49      |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202203 | ALLB2122                | ALLB-181                 | ?          | 2               | 0            | 1997.37     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202203 | ALLB2122                | ALLB-181                 | ?          | 3               | 0            | 1251.32     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202203 | ALLB2122                | ALLB-181                 | ?          | 4               | 0            | 877.79      |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202204 | ALLB2122                | ALLB-181                 | ?          | 2               | 0            | 1883.38     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202204 | ALLB2122                | ALLB-181                 | ?          | 3               | 0            | 1461.59     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202204 | ALLB2122                | ALLB-181                 | ?          | 4               | 0            | 192.05      |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202205 | ALLB2122                | ALLB-181                 | ?          | 2               | 0            | 655.38      |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202205 | ALLB2122                | ALLB-181                 | ?          | 3               | 0            | 1351.19     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202205 | ALLB2122                | ALLB-181                 | ?          | 4               | 0            | 2456.40     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202206 | ALLB2122                | ALLB-181                 | ?          | 2               | 0            | 2012.91     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202206 | ALLB2122                | ALLB-181                 | ?          | 3               | 0            | 577.01      |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202206 | ALLB2122                | ALLB-181                 | ?          | 4               | 0            | 433.75      |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202207 | ALLB2122                | ALLB-181                 | ?          | 2               | 0            | 2066.31     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202207 | ALLB2122                | ALLB-181                 | ?          | 3               | 0            | 1210.30     |
    | ILR2122        | R02                  | ORG0017181     | CM             | 202207 | ALLB2122                | ALLB-181                 | ?          | 4               | 0            | 2303.38     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



    # Check CRM and PaaS

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-181       | ALLB-181           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-181       | ALLB-181           | 2               | 2549.65   | 1365.67  | 1183.98  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-181       | ALLB-181           | 3               | 3687.17   | 2472.15  | 1215.02  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | EDSK-181       | ALLB-181           | 4               | 4504.22   | 2388.13  | 2116.09  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-181       | ALLC-181           | 1               | 32937.00  | 3321.00  | 2980.00  | 3019.00  | 2901.00  | 3257.00  | 2189.00  | 2673.00  | 3187.00  | 663.00   | 2570.00  | 2515.00  | 3662.00  | 
    | EDSK-181       | ALLC-181           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-181       | ALLC-181           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-181       | ALLC-181           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-181       | ALLB-181           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-181       | ALLB-181           | 2               | 2549.65   | 0.00     | 2549.65  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-181       | ALLB-181           | 3               | 3687.17   | 0.00     | 3687.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-181       | ALLB-181           | 4               | 4504.22   | 0.00     | 4504.22  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-181       | ALLB-181           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-181       | ALLB-181           | 2               | 2549.65   | 0.00     | 2549.65  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-181       | ALLB-181           | 3               | 3687.17   | 0.00     | 3687.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-181       | ALLB-181           | 4               | 4504.22   | 0.00     | 4504.22  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-181       | ALLC-181           | 1               | 32937.00  | 3321.00  | 2980.00  | 3019.00  | 2901.00  | 3257.00  | 2189.00  | 2673.00  | 3187.00  | 663.00   | 2570.00  | 2515.00  | 3662.00  | 
    | EDSK-181       | ALLC-181           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-181       | ALLC-181           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-181       | ALLC-181           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | EDSK-181       | ALLB-181           | 1               | 26009.00  | 2033.00  | 2137.00  | 2809.00  | 793.00   | 422.00   | 2517.00  | 2651.00  | 1267.00  | 1717.00  | 3086.00  | 3664.00  | 2913.00  | 
    | EDSK-181       | ALLB-181           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-181       | ALLB-181           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-181       | ALLB-181           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-181       | ALLC-181           | 1               | 32937.00  | 3321.00  | 2980.00  | 3019.00  | 2901.00  | 3257.00  | 2189.00  | 2673.00  | 3187.00  | 663.00   | 2570.00  | 2515.00  | 3662.00  | 
    | EDSK-181       | ALLC-181           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-181       | ALLC-181           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-181       | ALLC-181           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | EDSK-181       | ALLF-181           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-181       | ALLF-181           | 5               | 19394.00  | 1095.00  | 1293.00  | 700.00   | 2479.00  | 843.00   | 3032.00  | 2884.00  | 1594.00  | 779.00   | 2242.00  | 1555.00  | 898.00   | 
    | EDSK-181       | ALLF-181           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-181       | ALLF-181           | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 



    # Payment Batch for ALLB2122

    # Change the date
    Given the override date is '08/10/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'ALLB2122' AccountingPaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | ALLB-181                 | 202109 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ALLB2122                   | 202109               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ALLB2122                   | 202109               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLB2122' PaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A181.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'ALLB2122' PaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | LBT                    | 2021          | 06             | 08          | ?       | ALLB-181      | 10741.04        | RECONCILIATION   | Adv LL Bursary                     | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017181 | 2303800    |


    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'ALLB2122' AccountingPaymentPeriod '202106' and CensusEndDate '08/10/2021'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                          |
    | Payment Requests for Funding Stream Period ALLB2122 for Payment Period 202106 have been generated as of Census End Date/Time 2021-10-08T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | ALLB2122            | 202106        | 2021-10-08T22:00:00Z  | 1                | 10741.04   |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | LBT       | 01/08/2021   | 31/07/2022 | 08/10/2021    | 20/10/2021 | 2021          | 06             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017181  | 10017181       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | ALLB-181   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2303800    | RECONCILIATION | Adv LL Bursary                | 10741.04        |


    # Tidy Up
    And   the override date is reset

