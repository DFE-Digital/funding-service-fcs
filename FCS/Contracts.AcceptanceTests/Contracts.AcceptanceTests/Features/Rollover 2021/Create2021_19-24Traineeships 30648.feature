Feature: Create2021_19-24Traineeships 30648

@AcceptanceTest @Withdrawn20220309
 Scenario: A084 Bulk load a new 19TRN2020 contract. Check CRM and docs. Approve then NFA Check CRM and docs
    Given there are no allocations marked as Under Termination for UKPRN '10017084' 
    And   there are no terminated or closed allocations for UKPRN '10017084' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017084' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017084' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017084' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 19TL-084      |
    | 19TR-084      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 19TL-084      |
    | 19TR-084      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 19TRN2020-2021    |
    | 19TRN2020-LS2021  |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | 19TR20-084     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017084'

    # Set the base timestamp for each of the 6 19TRN2020 document templates (DocumentsDomain.UploadedDocumentTemplate) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_19TRN2020_2020-08-01.docx                   | 2020-12-02 10:00:00.000 | 
    | 19TRN2020_TAC_2020-08-01.docx                   | 2020-12-02 10:00:00.000 | 
    | 19TRN2020_2021_S1_2020-08-01.docx               | 2020-12-02 10:00:00.000 | 
    | 19TRN2020_S2_2020-08-01.docx                    | 2020-12-02 10:00:00.000 | 
    | FA_19TRN2020_2021_2020-08-01.docx               | 2020-12-02 10:00:00.000 | 
    | 19TRN2020_S3ON_2020-08-01.docx                  | 2020-12-02 10:00:00.000 | 




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017084' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017084 Co Ltd' with UKPRN '10017084' and OrgId 'ORG0017084' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017084' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017084 | 117084 | 10017084 Co Ltd | 0              | Active                | Yes           | AA017084      | ?             | 91 Hullbridge Road     | South Woodham Ferrers  | ?                      | ?                      | Chelmsford             | Essex                  | CM3 5LJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017084 |




    # Change the date
    Given the override date is '03/12/2020'

    # Bulk file
    And   there are no files prefixed '10017084' in the Sharepoint '19TRN2020-2021-Input-Appendices' folder
    And   there are no files prefixed '19TRN2020 AY 2021 01122020154703 v3_A084' in the Sharepoint 'Input' folder
    And   there are no files prefixed '19TRN2020 AY 2021 01122020154703 v3_A084' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '19TRN2020 AY 2021 01122020154703 v3_A084' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '19TRN2020 AY 2021 01122020154703 v3_A084' in the Sharepoint 'Reports' folder
    And   spreadsheet '19TRN2020 AY 2021 01122020154703 v3_A084.xlsx' exists in the Datafiles folder and UKPRN '10017084' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017084' for FundingType '19TRN2020' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017084' for FundingType '19TRN2020' and period '2021'

    # Check that all documents have been produced and are in the right order
    #   SoF then TaC then S1 then S2 then two Funding Agreements then S3ON
    Then  the file named '10017084_[ContractNo]_v1.pdf' in Sharepoint location '19TRN2020-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017084 Co Ltd UKPRN: 10017084
    Master Contract Number: [MasterContractNo]
    Allocation
    1 February 2021 to 31 July 2021 Contract Ref Feb 21 - Mar 21 Apr 21 - Jul 21 Total
    19 to 24 Traineeships - 2020 Procurement [AllocRef_19TR] £975 £15,025 £16,000
    19 to 24 Traineeships - 2020 Procurement - Learner Support [AllocRef_19TL] £12,847 £12,153 £25,000
    Total: £41,000
    Total Funding for this contract: £41,000
    Summary of Funding – Page 1

    Agreement Type Contract for Services
    Funding Period 1 February 2021 to 31 July 2023
    the Secretary of State for Education (acting through the
    Between
    Education and Skills Funding Agency)
    And 10017084 Co Ltd
    Funding for 19 to 24 Traineeships
    Master Contract Number [MasterContractNo]
    Version 1 (October 2020) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017084 Co Ltd THE SECRETARY OF STATE FOR
    91 Hullbridge Road EDUCATION ACTING THROUGH
    South Woodham Ferrers THE EDUCATION AND SKILLS
    Chelmsford FUNDING AGENCY, AN
    Essex EXECUTIVE AGENCY OF THE
    CM3 5LJ DEPARTMENT OF EDUCATION
    AND
    CHEYLESMORE HOUSE
    QUINTON ROAD
    Company No: AA017084 COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Contractor the Department
    Version 1 (October 2020) Page 2
    Version 1 (October 2020) Page 76

    SCHEDULE 1: SPECIFICATION & MONITORING
    Schedule 1 Version 1 (October 2020) – Page 1
    Schedule 1 Version 1 (October 2020) – Page 15

    SCHEDULE 2: PAYMENT
    19-24-YEAR-OLD PROCURED ADULT EDUCATION BUDGET
    TRAINEESHIPS    
    Schedule 2 Version 1 (October 2020)  – Page 1

    SCHEDULE 2
    Funding Agreement – 19 to 24 Traineeships - 2020 Procurement
    Provider: 10017084 Co Ltd UKPRN: 10017084
    Master Contract Number: [MasterContractNo] Start Date: 01/02/2021 End Date: 31/07/2021
    Contract Ref: [AllocRef_19TR]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    19 to 24 Traineeships - 2020 Procurement £16,000 £817 £158 £6,357 £1,549 £507 £6,612
    Total Funding £16,000 £817 £158 £6,357 £1,549 £507 £6,612
    Schedule 2 – Funding Agreement [AllocRef_19TR] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 2
    Funding Agreement – 19 to 24 Traineeships - 2020 Procurement - Learner Support
    Provider: 10017084 Co Ltd UKPRN: 10017084
    Master Contract Number: [MasterContractNo] Start Date: 01/02/2021 End Date: 31/07/2021
    Contract Ref: [AllocRef_19TL]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    19 to 24 Traineeships - 2020 Procurement - Learner £25,000 £5,633 £7,214 £4,581 £4,529 £2,559 £484
    Support
    Total Funding £25,000 £5,633 £7,214 £4,581 £4,529 £2,559 £484
    Schedule 2 – Funding Agreement [AllocRef_19TL] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    Schedule 3 Version 1 (October 2020) – Page 1
    """

    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this 
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2020-12-03 09:12:35.000 |
    
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017084_[ContractNo]_v1.pdf' in '19TRN2020-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A084.pdf'

    # Display Sharepoint filename
    And   message '10017084_[ContractNo]_v1.pdf' is written to the Output window
    
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
    | 10017084 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/02/2021        | 31/07/2021      | ?             |
    | 10017084 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_19TL] | 2355870          | Jul-21 | Profile        |
    | [AllocRef_19TR] | 2355800          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    And   the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                   | DeliverableDescription    | 
    | 10017084 | [ContractNo]   | 1               | [AllocRef_19TL] | 1               | 0                     | 25000.00     | 0             | 0        | 19-24 Traineeships Learner Support Total Funding  | ?                         |
    | 10017084 | [ContractNo]   | 1               | [AllocRef_19TR] | 1               | 0                     | 16000.00     | 0             | 0        | 19-24 Traineeships Total Funding                  | ?                         |





    # Update S2 timestamp then execute a non-financial amendment

    # Change the date
    Given the override date is '04/03/2021'

    # Update the S2 template timestamp to a date\time after contract v1 was created (DocumentsDomain.UploadedDocumentTemplate) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
   #| SOF_19TRN2020_2020-08-01.docx                   | 2020-12-02 10:00:00.000 | 
   #| 19TRN2020_TAC_2020-08-01.docx                   | 2020-12-02 10:00:00.000 | 
   #| 19TRN2020_2021_S1_2020-08-01.docx               | 2020-12-02 10:00:00.000 | 
    | 19TRN2020_S2_2020-08-01.docx                    | 2021-12-04 22:23:24.000 | 
   #| FA_19TRN2020_2021_2020-08-01.docx               | 2020-12-02 10:00:00.000 | 
   #| 19TRN2020_S3ON_2020-08-01.docx                  | 2020-12-02 10:00:00.000 | 
   
    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017084 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/02/2021        | 31/07/2021      | Variation     |
    | 10017084 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/02/2021        | 31/07/2021      | ?             |
    | 10017084 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Check the contents of the Appendices (SoF and S2 only. No FA because a NFA doesn't change the financials)
    Then  the file named '10017084_[ContractNo]_v2.pdf' in Sharepoint location '19TRN2020-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017084 Co Ltd UKPRN: 10017084
    Master Contract Number: [MasterContractNo]
    Allocation
    1 February 2021 to 31 July 2021 Contract Ref Feb 21 - Mar 21 Apr 21 - Jul 21 Total
    19 to 24 Traineeships - 2020 Procurement [AllocRef_19TR] £975 £15,025 £16,000
    19 to 24 Traineeships - 2020 Procurement - Learner Support [AllocRef_19TL] £12,847 £12,153 £25,000
    Total: £41,000
    Total Funding for this contract: £41,000
    Summary of Funding – Page 1

    SCHEDULE 2: PAYMENT
    19-24-YEAR-OLD PROCURED ADULT EDUCATION BUDGET
    TRAINEESHIPS    
    Schedule 2 Version 1 (October 2020)  – Page 1
    """

    # The appendix shouldn't include a TaC doc
    And   the pdf file does not contain the following text
    """
    Agreement Type Contract for Services
    """

    # The appendix shouldn't include an S1 doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """

    # The appendix shouldn't include an FA doc
    And   the pdf file does not contain the following text
    """
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    """

    # The appendix shouldn't include an S3ON doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    """


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20220309
Scenario: A085 Create and approve a 19TRN2020 contract. Bulk amend. Check CRM and docs. Consume actuals. Run payment batch. Check CDA, CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017085' 
    And   there are no terminated or closed allocations for UKPRN '10017085' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017085' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017085' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017085' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 19TL-085      |
    | 19TR-085      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 19TL-085      |
    | 19TR-085      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 19TRN2020-2021    |
    | 19TRN2020-LS2021  |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | 19TR20-085     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017085'

    # Set the base timestamp for each of the 6 19TRN2020 document templates (DocumentsDomain.UploadedDocumentTemplate) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_19TRN2020_2020-08-01.docx                   | 2020-12-02 10:00:00.000 | 
    | 19TRN2020_TAC_2020-08-01.docx                   | 2020-12-02 10:00:00.000 | 
    | 19TRN2020_2021_S1_2020-08-01.docx               | 2020-12-02 10:00:00.000 | 
    | 19TRN2020_S2_2020-08-01.docx                    | 2020-12-02 10:00:00.000 | 
    | FA_19TRN2020_2021_2020-08-01.docx               | 2020-12-02 10:00:00.000 | 
    | 19TRN2020_S3ON_2020-08-01.docx                  | 2020-12-02 10:00:00.000 | 




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017085' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017085 Co Ltd' with UKPRN '10017085' and OrgId 'ORG0017085' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017085' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017085 | 117085 | 10017085 Co Ltd | 0              | Provider Under Change | Yes           | AA017085      | ?             | 4 St John's Court      | Moulsham Street        | ?                      | ?                      | Chelmsford             | Essex                  | CM2 0JD   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017085 |




    # Change the date
    Given the override date is '11/12/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017085 | 10017085 Co Ltd      | ESFA-085             | 19TR20-085     | 1                     | 01/02/2021        | 31/07/2021      | 21064.00      |                                       | Contract for Services                      | 2021   | New          | ORG0017085 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017085 | 19TR20-085     | 19TL-085      | 19TRN2020-LS      | 19TRN2020-LS2021        | AY                      | 01/02/2021          | 31/07/2021        | 12435.00        |                                         |            |                                                             | New          |             |
    | 10017085 | 19TR20-085     | 19TR-085      | 19TRN2020         | 19TRN2020-2021          | AY                      | 01/02/2021          | 31/07/2021        | 8629.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017085 | 19TR20-085     | 19TL-085      | 1               | 0                     | 12435.00  | 2006.00  | 1349.00  | 2337.00  | 3073.00  | 1847.00  | 1823.00  | 19-24 Traineeships Learner Support Total Funding                | New          |             | 
    | 10017085 | 19TR20-085     | 19TR-085      | 1               | 0                     | 8629.00   | 1545.00  | 572.00   | 2509.00  | 399.00   | 1293.00  | 2311.00  | 19-24 Traineeships Total Funding                                | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this 
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 19TR20-085     | 1                     | 0                        | 2020-12-11 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-085'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-085' and actual ContractNumber '19TR20-085'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-085' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017085 | 19TR20-085         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/02/2021        | 31/07/2021      | ?             |
    | 10017085 | ESFA-085           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract '19TR20-085'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 19TR-085        | 2355800          | Jul-21 | Reconciliation |
    | 19TL-085        | 2355875          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                             | DeliverableDescription                                      | 
    | 10017085 | 19TR20-085     | 1               | 19TL-085      | 1               | 0                     | 12435.00     | 0             | 0        | 19-24 Traineeships Learner Support Total Funding            | ?                                                           |
    | 10017085 | 19TR20-085     | 1               | 19TR-085      | 1               | 0                     | 8629.00      | 0             | 0        | 19-24 Traineeships Total Funding                            | ?                                                           |




    # Bulk amend and check doc parts (No template changes)

    # Change the date
    Given the override date is '15/12/2020'

    # Bulk amendment to change financials
    And   there are no files prefixed '10017085' in the Sharepoint '19TRN2020-2021-Input-Appendices' folder
    And   there are no files prefixed '19TRN2020 AY 2021 01122020154722 v3_A085' in the Sharepoint 'Input' folder
    And   there are no files prefixed '19TRN2020 AY 2021 01122020154722 v3_A085' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '19TRN2020 AY 2021 01122020154722 v3_A085' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '19TRN2020 AY 2021 01122020154722 v3_A085' in the Sharepoint 'Reports' folder
    And   spreadsheet '19TRN2020 AY 2021 01122020154722 v3_A085.xlsx' exists in the Datafiles folder and UKPRN '10017085' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check that all document parts have been produced and are in the right order by looking for the first line in each of:
    #   SoF then two Funding Agreements
    Then  the file named '10017085_19TR20-085_v2.pdf' in Sharepoint location '19TRN2020-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Funding Agreement – 19 to 24 Traineeships - 2020 Procurement
    Funding Agreement – 19 to 24 Traineeships - 2020 Procurement - Learner Support
    """

    # 1. Check Summary of Funding (SoF)
    Then  the file named '10017085_19TR20-085_v2.pdf' in Sharepoint location '19TRN2020-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017085 Co Ltd UKPRN: 10017085
    Master Contract Number: ESFA-085
    Allocation
    1 February 2021 to 31 July 2021 Contract Ref Feb 21 - Mar 21 Apr 21 - Jul 21 Total
    19 to 24 Traineeships - 2020 Procurement 19TR-085 £2,117 £7,512 £9,629
    19 to 24 Traineeships - 2020 Procurement - Learner Support 19TL-085 £3,355 £10,080 £13,435
    Total: £23,064
    Total Funding for this contract: £23,064
    Summary of Funding – Page 1
    """

    # 2. Check Funding Agreements (2x FA)
    And   the file named '10017085_19TR20-085_v2.pdf' in Sharepoint location '19TRN2020-2021-Input-Appendices' contains the following lines in order
    """
    SCHEDULE 2
    Funding Agreement – 19 to 24 Traineeships - 2020 Procurement
    Provider: 10017085 Co Ltd UKPRN: 10017085
    Master Contract Number: ESFA-085 Start Date: 01/02/2021 End Date: 31/07/2021
    Contract Ref: 19TR-085
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    19 to 24 Traineeships - 2020 Procurement £9,629 £1,545 £572 £2,509 £1,399 £1,293 £2,311
    Total Funding £9,629 £1,545 £572 £2,509 £1,399 £1,293 £2,311
    Schedule 2 – Funding Agreement 19TR-085 – Page 1 Ref (for internal use only):  19TR20-085 v2
    
    SCHEDULE 2
    Funding Agreement – 19 to 24 Traineeships - 2020 Procurement - Learner Support
    Provider: 10017085 Co Ltd UKPRN: 10017085
    Master Contract Number: ESFA-085 Start Date: 01/02/2021 End Date: 31/07/2021
    Contract Ref: 19TL-085
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    19 to 24 Traineeships - 2020 Procurement - Learner £13,435 £2,006 £1,349 £2,337 £3,073 £2,847 £1,823
    Support
    Total Funding £13,435 £2,006 £1,349 £2,337 £3,073 £2,847 £1,823
    Schedule 2 – Funding Agreement 19TL-085 – Page 1 Ref (for internal use only):  19TR20-085 v2
    """

    # The appendix shouldn't include a TaC doc
    And   the pdf file does not contain the following text
    """
    Agreement Type Contract for Services
    """

    # The appendix shouldn't include an S1 doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """

    # The appendix shouldn't include an S2 doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2: PAYMENT
    """
    
    # The appendix shouldn't include an S3ON doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    """


    # Change the date
    Given the override date is '17/12/2020'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-085'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-085' and actual ContractNumber '19TR20-085'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-085' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017085 | 19TR20-085         | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/02/2021        | 31/07/2021      | Variation     |
    | 10017085 | 19TR20-085         | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/02/2021        | 31/07/2021      | ?             |
    | 10017085 | ESFA-085           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract '19TR20-085'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 19TR-085        | 2355800          | Jul-21 | Reconciliation |
    | 19TL-085        | 2355875          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                             | DeliverableDescription                                      | 
    | 10017085 | 19TR20-085     | 2               | 19TL-085      | 1               | 0                     | 13435.00     | 0             | 0        | 19-24 Traineeships Learner Support Total Funding            | ?                                                           |
    | 10017085 | 19TR20-085     | 2               | 19TR-085      | 1               | 0                     | 9629.00      | 0             | 0        | 19-24 Traineeships Total Funding                            | ?                                                           |





#    # CDA Reports
#
#    # Run the CDA report for 16-18TRN1920 
#    Given there is no CDA report named 'CDA Last Approved Version A085.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | 19TR20-085     | 2                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod | Version               | Suffix    |
#    | 19TRN2020-2021      | Last Approved Version | A085      |
#
#    Then  a report named 'CDA Last Approved Version A085.csv' is created

    ## Check the contents of the CDA report
    #And   the following rows are present in the report
    #| FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
    #| 19TRN2020-2021          | 10017085 | 10017085 Co Ltd             |               |                             | 19TR-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                |                                                                 | 2                 | 2021            | 2020/21       |              | 1545         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
    #| 19TRN2020-2021          | 10017085 | 10017085 Co Ltd             |               |                             | 19TR-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                |                                                                 | 3                 | 2021            | 2020/21       |              | 572          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
    #| 19TRN2020-2021          | 10017085 | 10017085 Co Ltd             |               |                             | 19TR-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                |                                                                 | 4                 | 2021            | 2021/22       |              | 2509         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
    #| 19TRN2020-2021          | 10017085 | 10017085 Co Ltd             |               |                             | 19TR-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                |                                                                 | 5                 | 2021            | 2021/22       |              | 1399         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
    #| 19TRN2020-2021          | 10017085 | 10017085 Co Ltd             |               |                             | 19TR-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                |                                                                 | 6                 | 2021            | 2021/22       |              | 1293         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
    #| 19TRN2020-2021          | 10017085 | 10017085 Co Ltd             |               |                             | 19TR-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                |                                                                 | 7                 | 2021            | 2021/22       |              | 2311         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
    #| 19TRN2020-2021          | 10017085 | 10017085 Co Ltd             |               |                             | 19TR-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships Total Funding                                | 2                 | 2021            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355860                  | 2355816           | Feb              |
    #| 19TRN2020-2021          | 10017085 | 10017085 Co Ltd             |               |                             | 19TR-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships Total Funding                                | 3                 | 2021            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355860                  | 2355816           | Mar              |
    #| 19TRN2020-2021          | 10017085 | 10017085 Co Ltd             |               |                             | 19TR-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships Total Funding                                | 4                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355860                  | 2355816           | Apr              |
    #| 19TRN2020-2021          | 10017085 | 10017085 Co Ltd             |               |                             | 19TR-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships Total Funding                                | 5                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355860                  | 2355816           | May              |
    #| 19TRN2020-2021          | 10017085 | 10017085 Co Ltd             |               |                             | 19TR-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships Total Funding                                | 6                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355860                  | 2355816           | Jun              |
    #| 19TRN2020-2021          | 10017085 | 10017085 Co Ltd             |               |                             | 19TR-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships Total Funding                                | 7                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355860                  | 2355816           | Jul              |
    #| 19TRN2020-2021          | 10017085 | 10017085 Co Ltd             |               |                             | 19TR-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships Total Funding                                | 2                 | 2021            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355800                  | 2355816           | Feb              |
    #| 19TRN2020-2021          | 10017085 | 10017085 Co Ltd             |               |                             | 19TR-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships Total Funding                                | 3                 | 2021            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355800                  | 2355816           | Mar              |
    #| 19TRN2020-2021          | 10017085 | 10017085 Co Ltd             |               |                             | 19TR-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships Total Funding                                | 4                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355800                  | 2355816           | Apr              |
    #| 19TRN2020-2021          | 10017085 | 10017085 Co Ltd             |               |                             | 19TR-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships Total Funding                                | 5                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355800                  | 2355816           | May              |
    #| 19TRN2020-2021          | 10017085 | 10017085 Co Ltd             |               |                             | 19TR-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships Total Funding                                | 6                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355800                  | 2355816           | Jun              |
    #| 19TRN2020-2021          | 10017085 | 10017085 Co Ltd             |               |                             | 19TR-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships Total Funding                                | 7                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2355800                  | 2355816           | Jul              |
    ##
    #| 19TRN2020-LS2021        | 10017085 | 10017085 Co Ltd             |               |                             | 19TL-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support Total Funding                |                                                                 | 2                 | 2021            | 2020/21       |              | 2006         |              |               |              | Yes                | 2006.00        | 0.00             | 0.00                  | 0.00           | 2006.00         |             | No            |                   |        | 2355870           | 2355875                  |                   | Feb              |
    #| 19TRN2020-LS2021        | 10017085 | 10017085 Co Ltd             |               |                             | 19TL-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support Total Funding                |                                                                 | 3                 | 2021            | 2020/21       |              | 1349         |              |               |              | Yes                | 1349.00        |                  | 0.00                  | 0.00           | 1349.00         |             | No            |                   |        | 2355870           | 2355875                  |                   | Mar              |
    #| 19TRN2020-LS2021        | 10017085 | 10017085 Co Ltd             |               |                             | 19TL-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support Total Funding                |                                                                 | 4                 | 2021            | 2021/22       |              | 2337         |              |               |              | Yes                | 2337.00        |                  | 0.00                  | 0.00           | 2337.00         |             | No            |                   |        | 2355870           | 2355875                  |                   | Apr              |
    #| 19TRN2020-LS2021        | 10017085 | 10017085 Co Ltd             |               |                             | 19TL-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support Total Funding                |                                                                 | 5                 | 2021            | 2021/22       |              | 3073         |              |               |              | Yes                | 3073.00        |                  | 0.00                  | 0.00           | 3073.00         |             | No            |                   |        | 2355870           | 2355875                  |                   | May              |
    #| 19TRN2020-LS2021        | 10017085 | 10017085 Co Ltd             |               |                             | 19TL-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support Total Funding                |                                                                 | 6                 | 2021            | 2021/22       |              | 2847         |              |               |              | Yes                | 2847.00        |                  | 0.00                  | 0.00           | 2847.00         |             | No            |                   |        | 2355870           | 2355875                  |                   | Jun              |
    #| 19TRN2020-LS2021        | 10017085 | 10017085 Co Ltd             |               |                             | 19TL-085                 | 19TR20-085     | ESFA-085                | 01/02/2021                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support Total Funding                |                                                                 | 7                 | 2021            | 2021/22       |              | 1823         |              |               |              | Yes                | 1823.00        |                  | 0.00                  | 0.00           | 1823.00         |             | No            |                   |        | 2355870           | 2355875                  |                   | Jul              |





    # Add actuals to the contract

    # Change the date
    Given the override date is '04/04/2021'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017085'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Mar 2021
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2021        | R08                  | ORG0017085     | CM             | 202102 | 19TRN2020-2021          | 19TR-085                 | ?          | 2               | 0            | 877.46      |
    | ILR2021        | R08                  | ORG0017085     | CM             | 202102 | 19TRN2020-2021          | 19TR-085                 | ?          | 3               | 0            | 410.81      |
    | ILR2021        | R08                  | ORG0017085     | CM             | 202103 | 19TRN2020-2021          | 19TR-085                 | ?          | 2               | 0            | 1456.68     |
    | ILR2021        | R08                  | ORG0017085     | CM             | 202103 | 19TRN2020-2021          | 19TR-085                 | ?          | 3               | 0            | 553.20      |
    | ILR2021        | R08                  | ORG0017085     | CM             | 202104 | 19TRN2020-2021          | 19TR-085                 | ?          | 2               | 0            | 545.66      |
    | ILR2021        | R08                  | ORG0017085     | CM             | 202104 | 19TRN2020-2021          | 19TR-085                 | ?          | 3               | 0            | 519.05      |
    | ILR2021        | R08                  | ORG0017085     | CM             | 202105 | 19TRN2020-2021          | 19TR-085                 | ?          | 2               | 0            | 355.89      |
    | ILR2021        | R08                  | ORG0017085     | CM             | 202105 | 19TRN2020-2021          | 19TR-085                 | ?          | 3               | 0            | 1496.26     |
    | ILR2021        | R08                  | ORG0017085     | CM             | 202106 | 19TRN2020-2021          | 19TR-085                 | ?          | 2               | 0            | 1356.95     |
    | ILR2021        | R08                  | ORG0017085     | CM             | 202106 | 19TRN2020-2021          | 19TR-085                 | ?          | 3               | 0            | 1226.39     |
    | ILR2021        | R08                  | ORG0017085     | CM             | 202107 | 19TRN2020-2021          | 19TR-085                 | ?          | 2               | 0            | 372.89      |
    | ILR2021        | R08                  | ORG0017085     | CM             | 202107 | 19TRN2020-2021          | 19TR-085                 | ?          | 3               | 0            | 340.82      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


    # Check Financials

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | 19TR20-085     | 19TR-085           | 2               | 2334.14   | 877.46   | 1456.68  | ?        | ?        | ?        | ?        | 
    | 19TR20-085     | 19TR-085           | 3               | 964.01    | 410.81   | 553.20   | ?        | ?        | ?        | ?        | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | 19TR20-085     | 19TL-085           | 1               | 13435.00  | 2006.00  | 1349.00  | 2337.00  | 3073.00  | 2847.00  | 1823.00  | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | 19TR20-085     | 19TR-085           | 2               | 2334.14   | 0.00     | 2334.14  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 19TR20-085     | 19TR-085           | 3               | 964.01    | 0.00     | 964.01   | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract (Cap at FY with 10% over-delivery allowed)
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | 19TR20-085     | 19TR-085           | 2               | -386.45   | 0.00     | -386.45  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 19TR20-085     | 19TR-085           | 3               | -159.60   | 0.00     | -159.60  | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | 19TR20-085     | 19TL-085           | 1               | 13435.00  | 2006.00  | 1349.00  | 2337.00  | 3073.00  | 2847.00  | 1823.00  | 
    #
    | 19TR20-085     | 19TR-085           | 2               | 1947.69   | 0.00     | 1947.69  | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 19TR20-085     | 19TR-085           | 3               | 804.41    | 0.00     | 804.41   | 0.00     | 0.00     | 0.00     | 0.00     | 
        
    # Check the ACTUAL totals in CRM at deliverable level rather than deliverable period level (24295)
    And   the Actuals Data is stored in CRM at deliverable level against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | ActualValue | ActualVolume |
    | 19TR20-085     | 19TR-085        | 2               | 2334.14     | 0            |
    | 19TR20-085     | 19TR-085        | 3               | 964.01      | 0            |





    # Payment Batch for 19TRN2020-2021

    # Change the date
    Given the override date is '12/04/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '19TRN2020-2021' AccountingPaymentPeriod '202012' CensusEndDate '12/04/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | 19TR-085                 | 202103 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 19TRN2020-2021             | 202103               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 19TRN2020-2021             | 202103               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '19TRN2020-2021' PaymentPeriod '202012' CensusEndDate '12/04/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A085.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod '19TRN2020-2021' PaymentPeriod '202012' CensusEndDate '12/04/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription   | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | 19TR                   | 2020          | 12             | 12          | ?       | 19TR-085      | 2334.14         | RECONCILIATION   | 19-24 Traineeships      | 2021-04-22 | 2021-02-01   | 2021-07-31 | ?              | 10017085 | 2355800    |
    | 19TR                   | 2020          | 12             | 12          | ?       | 19TR-085      | -546.05         | CAPPING          | AEB 19-24 Traineeshp    | 2021-04-22 | 2021-02-01   | 2021-07-31 | ?              | 10017085 | 2355816    |
    | 19TR                   | 2020          | 12             | 12          | ?       | 19TR-085      | 964.01          | RECONCILIATION   | 19-24TraineeshpsLngS    | 2021-04-22 | 2021-02-01   | 2021-07-31 | ?              | 10017085 | 2355860    |

    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod '19TRN2020-2021' AccountingPaymentPeriod '202012' and CensusEndDate '12/04/2021'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                    |
    | Payment Requests for Funding Stream Period 19TRN2020-2021 for Payment Period 202012 have been generated as of Census End Date/Time 2021-04-12T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | 19TRN2020-2021      | 202012        | 2021-04-12T22:00:00Z  | 3                | 2752.10    |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | 19TR      | 01/02/2021   | 31/07/2021 | 12/04/2021    | 22/04/2021 | 2020          | 12             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017085  | 10017085       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | 19TR-085   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355800    | RECONCILIATION | 19-24 Traineeships            | 2334.14         |
    | ORG0017085  | 10017085       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | 19TR-085   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355816    | CAPPING        | AEB 19-24 Traineeshp          | -546.05         |
    | ORG0017085  | 10017085       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | 19TR-085   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355860    | RECONCILIATION | 19-24TraineeshpsLngS          | 964.01          |




    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check that the relevant events are on the ADP feed
    Then  the ADP feed includes the following values
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber     | ContractVersionNumber | SubVersionNumber | AllocationNumber | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    | ContractAllocationActualsReceived | 2      | 19TR20-085         | 2                     | 0                | 19TR-085         | ?                         | ?                            |
    | ContractAllocationPaymentReceived | 3      | 19TR20-085         | 2                     | 0                | 19TR-085         | ?                         | ?                            |

    # Check the ADP feed event header information
    And   the Allocation Delivery feed includes the following event information
    | UKPRN    | ContractNumber     | ContractVersion | ContractSubVersion | CategoryTerm                        | CategoryLabel                        | Title                                                                               |
    | 10017085 | 19TR20-085         | 2               | 0                  | ContractAllocationActualsReceived   | Contract Allocation Actuals Received | Actuals for Allocation 19TR-085 of Contract 19TR20-085: 2.0 have been received      |
    | 10017085 | 19TR20-085         | 2               | 0                  | ContractAllocationPaymentReceived   | Contract Allocation Payment Posted   | Payment for Allocation 19TR-085 of Contract 19TR20-085: 2.0 have been posted        |

    # Check financials on the ADP feed
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
    | ContractAllocationActualsReceived | 19TR20-085         | 2             | 19TR-085         | 1               | 202102 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | 19TR20-085         | 2             | 19TR-085         | 1               | 202103 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | 19TR20-085         | 2             | 19TR-085         | 1               | 202104 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | 19TR20-085         | 2             | 19TR-085         | 1               | 202105 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | 19TR20-085         | 2             | 19TR-085         | 1               | 202106 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | 19TR20-085         | 2             | 19TR-085         | 1               | 202107 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsReceived | 19TR20-085         | 2             | 19TR-085         | 2               | 202102 | 877.46      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | 19TR20-085         | 2             | 19TR-085         | 2               | 202103 | 1456.68     | 0.00           | 0.00             | 2334.14               | -386.45        | 1947.69    |
    | ContractAllocationActualsReceived | 19TR20-085         | 2             | 19TR-085         | 2               | 202104 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | 19TR20-085         | 2             | 19TR-085         | 2               | 202105 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | 19TR20-085         | 2             | 19TR-085         | 2               | 202106 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | 19TR20-085         | 2             | 19TR-085         | 2               | 202107 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsReceived | 19TR20-085         | 2             | 19TR-085         | 3               | 202102 | 410.81      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | 19TR20-085         | 2             | 19TR-085         | 3               | 202103 | 553.20      | 0.00           | 0.00             | 964.01                | -159.60        | 804.41     |
    | ContractAllocationActualsReceived | 19TR20-085         | 2             | 19TR-085         | 3               | 202104 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | 19TR20-085         | 2             | 19TR-085         | 3               | 202105 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | 19TR20-085         | 2             | 19TR-085         | 3               | 202106 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | 19TR20-085         | 2             | 19TR-085         | 3               | 202107 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |


    # Tidy Up
    And   the override date is reset
       
         