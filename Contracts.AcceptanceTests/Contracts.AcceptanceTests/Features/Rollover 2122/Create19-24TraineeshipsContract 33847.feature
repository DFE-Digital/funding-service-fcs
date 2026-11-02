Feature: Create19-24TraineeshipsContract 33847

@AcceptanceTest @Withdrawn20231002
Scenario: A280 Create and approve a 20/21 19-24 Traineeships contract. Bulk add a 21/22 19-24 Traineeships contract with linked Master. NFA. Actuals. Check docs, CRM and Feed
    
    #  1. Create a draft 20/21 19-24 Traineeships contract
    #  2. Attempt to add a 21/22 contract by bulk upload (New Amendment) but fail (MBR-005)
    #  3. Publish and approve 20/21 contract
    #  4. Bulk file (again) to add 21/22 contract linked to 20/21 by Master
    #  5. Check docs and doc parts
    #  6. Attempt NFA against approved 20/21 contract but fail because 21/22 is in draft 
    #  7. Publish and approve 21/22 contract 
    #  8. Check financials
    #  9. CDA
    # 10. Add 21/22 actuals and check financials in CRM and PaaS
    # 11. Payment Batch
    # 12. Check feed
        
    Given there are no allocations marked as Under Termination for UKPRN '10017280' 
    And   there are no terminated or closed allocations for UKPRN '10017280' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017280' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017280' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017280' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 19TL-280      |
    | 19TR-280      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 19TL-280      |
    | 19TR-280      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 19TRN2020-2021    |
    | 19TRN2020-LS2021  |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | 19TR20-280     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017280'

    # Set the base timestamp for each of the 19-24 Traineeships document templates (DocumentsDomain.UploadedDocumentTemplate) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_19TRN2020_2020-08-01.docx                   | 2020-12-02 10:00:00.000 | 
    | 19TRN2020_TAC_2020-08-01.docx                   | 2020-12-02 10:00:00.000 | 
    | 19TRN2020_2021_S1_2020-08-01.docx               | 2020-12-02 10:00:00.000 | 
    | 19TRN2020_S2_2020-08-01.docx                    | 2020-12-02 10:00:00.000 | 
    | FA_19TRN2020_2021_2020-08-01.docx               | 2020-12-02 10:00:00.000 | 
    | 19TRN2020_S3ON_2020-08-01.docx                  | 2020-12-02 10:00:00.000 | 
    # 
    | 19TRN2020_2122_TAC_2021-08-01.docx              | 2021-06-02 10:00:00.000 | 
    | 19TRN2020_2122_S1_2021-08-01.docx               | 2021-06-02 10:00:00.000 | 
    | 19TRN2020_2122_S2_2021-08-01.docx               | 2021-06-02 10:00:00.000 | 
    | 19TRN2020_2122_S3ON_2021-08-01.docx             | 2021-06-02 10:00:00.000 | 



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017280' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017280 Co Ltd' with UKPRN '10017280' and OrgId 'ORG0017280' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017280' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017280 | 117280 | 10017280 Co Ltd | 0              | In Administration     | Yes           | AA017280      | ?             | 9 Ronaldshaw Park      | Ayr                    | ?                      | ?                      | ?                      | ?                      | KA7 2TJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017280 |





    # Change the date
    Given the override date is '01/01/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number '19TR20-280'
    And   there are no details in ContractManagement.CreatedContract for '19TR20-280'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017280 | 10017280 Co Ltd      | ESFA-280             | 19TR20-280     | 1                     | 01/02/2021        | 31/07/2021      | 28017.00      |                                       | Contract for Services                      | 2021   | New          | ORG0017280 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017280 | 19TR20-280     | 19TL-280      | 19TRN2020-LS      | 19TRN2020-LS2021        | AY                      | 01/02/2021          | 31/07/2021        | 13847.00        |                                         |            |                                                             | New          |             |
    | 10017280 | 19TR20-280     | 19TR-280      | 19TRN2020         | 19TRN2020-2021          | AY                      | 01/02/2021          | 31/07/2021        | 14170.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017280 | 19TR20-280     | 19TL-280      | 1               | 0                     | 13847.00  | 2858.00  | 2201.00  | 3189.00  | 224.00   | 2700.00  | 2675.00  | 19-24 Traineeships Learner Support Total Funding                | New          |             | 
    | 10017280 | 19TR20-280     | 19TR-280      | 1               | 0                     | 14170.00  | 2469.00  | 1495.00  | 3432.00  | 1322.00  | 2217.00  | 3235.00  | 19-24 Traineeships Total Funding                                | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | 19TR20-280     | 1                     | 0                        | 2021-01-01 09:12:35.000 |





    # Bulk File to create a 19-24 Traineeships contract for 21/22 linked by Master to the 20/21 contract. 
    #  This should fail because the 20/21 contract is in Draft

    Given the override date is '01/07/2021'

    # Bulk file (Intent = New Amendment) 
    And   there are no files prefixed '10017280' in the Sharepoint '19TRN2020-2122-Input-Appendices' folder
    And   there are no files prefixed '19TRN2020 AY 2122 21062021165958 v3_A280' in the Sharepoint 'Input' folder
    And   there are no files prefixed '19TRN2020 AY 2122 21062021165958 v3_A280' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '19TRN2020 AY 2122 21062021165958 v3_A280' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '19TRN2020 AY 2122 21062021165958 v3_A280' in the Sharepoint 'Reports' folder
    And   spreadsheet '19TRN2020 AY 2122 21062021165958 v3_A280.xlsx' exists in the Datafiles folder and UKPRN '10017280' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # MBR-005
    And   '[Contract] This Master Contract cannot have more than one associated Contract in a draft status at the same time' is displayed in field 'J2' on the 'Contract' tab of the result report





    # Publish and approve the 20/21 contract

    # Change the date
    Given the override date is '04/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '19TR20-280'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-280' and actual ContractNumber '19TR20-280'

    # Check that the contract is now approved
    Then  the latest version of contract '19TR20-280' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017280 | 19TR20-280         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/02/2021        | 31/07/2021      | ?             |
    | 10017280 | ESFA-280           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-280' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract '19TR20-280'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 19TR-280        | 2355800          | Jul-21 | Reconciliation |
    | 19TL-280        | 2355875          | Jul-21 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                 | DeliverableDescription                                      | 
    | 10017280 | 19TR20-280     | 1               | 19TL-280      | 1               | 0                     | 13847.00     | 0             | 0        | 19-24 Traineeships Learner Support Total Funding                | ?                                                           |
    | 10017280 | 19TR20-280     | 1               | 19TR-280      | 1               | 0                     | 14170.00     | 0             | 0        | 19-24 Traineeships Total Funding                                | ?                                                           |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '19TR20-280' agree with the most recent entry for this contract in the ContractManagement feed


   


    # Second attempt ...
    # Bulk File to create a 19-24 Traineeships contract for 21/22 linked by Master to the 20/21 contract

    Given the override date is '06/07/2021'

    # Bulk file (Intent = New Amendment)
    And   there are no files prefixed '10017280' in the Sharepoint '19TRN2020-2122-Input-Appendices' folder
    And   there are no files prefixed '19TRN2020 AY 2122 21062021165958 v3_A280' in the Sharepoint 'Input' folder
    And   there are no files prefixed '19TRN2020 AY 2122 21062021165958 v3_A280' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '19TRN2020 AY 2122 21062021165958 v3_A280' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '19TRN2020 AY 2122 21062021165958 v3_A280' in the Sharepoint 'Reports' folder
    And   spreadsheet '19TRN2020 AY 2122 21062021165958 v3_A280.xlsx' exists in the Datafiles folder and UKPRN '10017280' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report



    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017280' for FundingType '19TRN2020' and period '2122' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017280' for FundingType '19TRN2020' and period '2122'

    # Check the contents of the Appendices (SoF, T&C, Sch1, Sch2, FA, Sch3ON)
    Then  the file named '10017280_[ContractNo]_v1.pdf' in Sharepoint location '19TRN2020-2122-Input-Appendices' contains the following lines in order
    """    
    SUMMARY OF FUNDING
    Organisation Name: 10017280 Co Ltd UKPRN: 10017280
    Master Contract Number: ESFA-280
    Allocation
    1 February 2021 to 31 July 2021 Contract Ref Feb 21 - Mar 21 Apr 21 - Jul 21 Total
    19 to 24 Traineeships - 2020 Procurement 19TR-280 £3,964 £10,206 £14,170
    19 to 24 Traineeships - 2020 Procurement - Learner Support 19TL-280 £5,059 £8,788 £13,847
    Total: £28,017
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    19 to 24 Traineeships - 2020 Procurement [AllocRef_19TR] £74,178 £25,822 £100,000
    of which Learner Support £37,101 £12,014 £49,115
    Total: £100,000
    Total Funding for this contract: £128,017
    Summary of Funding – Page 1

    Agreement Type Contract for Services
    Funding Period 1 February 2021 to 31 July 2023
    Between the Secretary of State for Education
    And 10017280 Co Ltd
    Funding for 19 to 24 Traineeships
    Master Contract Number ESFA-280
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    Version 3 (April 2022) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017280 Co Ltd THE SECRETARY OF STATE FOR
    9 Ronaldshaw Park EDUCATION
    Ayr DEPARTMENT FOR EDUCATION
    KA7 2TJ 20 GREAT SMITH STREET
    AND
    LONDON
    SW1P 3BT
    Company No: AA017280
    Hereinafter called Hereinafter called
    the Contractor the Department
    Version 3 (April 2022) Page 2
    Version 3 (April 2022) Page 78

    SCHEDULE 1: SPECIFICATION & MONITORING
    19 TO 24-YEAR-OLD PROCURED ADULT EDUCATION BUDGET
    TRAINEESHIPS SPECIFICATION
    Schedule 1 Version 2 (July 2021) – Page 1
    
    SCHEDULE 2: PAYMENT
    19-24-YEAR-OLD PROCURED ADULT EDUCATION BUDGET
    TRAINEESHIPS
    Schedule 2 Version 2 (July 2021)  – Page 1

    SCHEDULE 2
    Funding Agreement – 19 to 24 Traineeships - 2020 Procurement
    Provider: 10017280 Co Ltd UKPRN: 10017280
    Master Contract Number: ESFA-280 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_19TR]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    19 to 24 Traineeships - 2020 Procurement £100,000 £1,345 £12,055 £12,225 £2,855 £13,244 £11,218 £12,514 £8,722 £4,148 £1,846 £7,451 £12,377
    of which Learner Support £49,115 £971 £4,389 £6,310 £1,749 £5,663 £5,048 £6,172 £6,799 £2,807 £992 £599 £7,616
    Total Funding £100,000 £1,345 £12,055 £12,225 £2,855 £13,244 £11,218 £12,514 £8,722 £4,148 £1,846 £7,451 £12,377
    Schedule 2 – Funding Agreement [AllocRef_19TR] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    Schedule 3 Version 2 (July 2021) – Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017280_[ContractNo]_v1.pdf' in '19TRN2020-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A280.pdf'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-01-07 09:12:35.000 |





    # While 20/21 is Approved\Approved and 21/22 is Draft\Awaiting Documentation, try a non-financial amendment on 20/21. 
    #  This should fail because the 21/22 contract is in Draft

    # Change the date
    Given the override date is '07/07/2021'

    # Issue a non-financial VARIATION amendment 
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '19TR20-280' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM. These should not have changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017280 | 19TR20-280         | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/02/2021        | 31/07/2021      | ?             |
    | 10017280 | ESFA-280           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |





    # Publish and approve the 21/22 contract

    Given the override date is '10/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-280' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # ... and the 20/21 contract is also still approved
    And   the latest version of contract '19TR20-280' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017280 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017280 | ESFA-280           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2021        | 31/07/2021      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables (10 deliverables x 12 months)
    And   there are '120' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | [ContractNo]   | [AllocRef_19TR]    | 1               | 100000.00 | 1345.00  | 12055.00 | 12225.00 | 2855.00  | 13244.00 | 11218.00 | 12514.00 | 8722.00  | 4148.00  | 1846.00  | 7451.00  | 12377.00 | 
    | [ContractNo]   | [AllocRef_19TR]    | 4               | 50885.00  | 374.00   | 7666.00  | 5915.00  | 1106.00  | 7581.00  | 6170.00  | 6342.00  | 1923.00  | 1341.00  | 854.00   | 6852.00  | 4761.00  | 
    | [ContractNo]   | [AllocRef_19TR]    | 5               | 49115.00  | 971.00   | 4389.00  | 6310.00  | 1749.00  | 5663.00  | 5048.00  | 6172.00  | 6799.00  | 2807.00  | 992.00   | 599.00   | 7616.00  | 

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_19TR] | 2355800          | Jul-22 | Reconciliation |
    | [AllocRef_19TR] | 100936           | Jul-22 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    And   the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                     | DeliverableDescription     | 
    | 10017280 | [ContractNo]   | 1               | [AllocRef_19TR]  | 1               | 0                     | 100000.00    | 0             | 0        | 19-24 Traineeships Total Funding    | ?                          |
    | 10017280 | [ContractNo]   | 1               | [AllocRef_19TR]  | 4               | 0                     | 50885.00     | 0             | 0        | 19-24 Traineeships                  | ?                          |
    | 10017280 | [ContractNo]   | 1               | [AllocRef_19TR]  | 5               | 0                     | 49115.00     | 0             | 0        | 19-24 Traineeships Learner Support  | ?                          |

    # Test CRM details against same in ContractManagement feed (30447)
    And   the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed





#    # CDA
#    
#    # Change the date
#    Given the override date is '12/07/2021'
#
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version A280.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | 19TR20-280     | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version               | Suffix |
#    | 19TRN2020-2122        | Latest Version        | A280   |
#
#    Then  a report named 'CDA Latest Version A280.csv' is created
#
#    # Check the planned values in the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 8                 | 2021            | 2021/22       |              | 374          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 9                 | 2021            | 2021/22       |              | 7666         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 10                | 2021            | 2021/22       |              | 5915         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 11                | 2021            | 2021/22       |              | 1106         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 12                | 2021            | 2021/22       |              | 7581         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 1                 | 2022            | 2021/22       |              | 6170         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 2                 | 2022            | 2021/22       |              | 6342         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 3                 | 2022            | 2021/22       |              | 1923         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 4                 | 2022            | 2022/23       |              | 1341         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 5                 | 2022            | 2022/23       |              | 854          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 6                 | 2022            | 2022/23       |              | 6852         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships                                              | 19-24 Traineeships Total Funding                                | 7                 | 2022            | 2022/23       |              | 4761         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    #
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 8                 | 2021            | 2021/22       |              | 971          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 9                 | 2021            | 2021/22       |              | 4389         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 10                | 2021            | 2021/22       |              | 6310         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 11                | 2021            | 2021/22       |              | 1749         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 12                | 2021            | 2021/22       |              | 5663         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 1                 | 2022            | 2021/22       |              | 5048         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 2                 | 2022            | 2021/22       |              | 6172         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 3                 | 2022            | 2021/22       |              | 6799         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 4                 | 2022            | 2022/23       |              | 2807         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 5                 | 2022            | 2022/23       |              | 992          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 6                 | 2022            | 2022/23       |              | 599          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | 19TRN2020-2122          | 10017280 | 10017280 Co Ltd             |               |                             | [AllocRef_19TR]          | [ContractNo]   | ESFA-280                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Learner Support                              | 19-24 Traineeships Total Funding                                | 7                 | 2022            | 2022/23       |              | 7616         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |





    # Add actuals to the contract

    # Change the date
    Given the override date is '04/09/2021'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017280'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2021
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202108 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 2               | 0            | 1449.74     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202108 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 3               | 0            | 1325.15     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202108 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 6               | 0            | 1367.11     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202108 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 7               | 0            | 1221.02     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202108 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 8               | 0            | 1016.82     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202108 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 9               | 0            | 666.20      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202108 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 10              | 0            | 779.54      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202109 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 2               | 0            | 989.39      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202109 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 3               | 0            | 507.16      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202109 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 6               | 0            | 1121.24     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202109 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 7               | 0            | 448.69      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202109 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 8               | 0            | 441.72      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202109 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 9               | 0            | 833.34      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202109 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 10              | 0            | 655.71      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202110 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 2               | 0            | 618.77      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202110 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 3               | 0            | 1423.48     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202110 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 6               | 0            | 1224.55     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202110 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 7               | 0            | 1035.14     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202110 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 8               | 0            | 1383.86     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202110 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 9               | 0            | 1230.59     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202110 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 10              | 0            | 808.66      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202111 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 2               | 0            | 579.01      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202111 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 3               | 0            | 676.14      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202111 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 6               | 0            | 1144.55     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202111 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 7               | 0            | 506.77      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202111 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 8               | 0            | 977.14      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202111 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 9               | 0            | 1316.77     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202111 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 10              | 0            | 280.12      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202112 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 2               | 0            | 1490.25     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202112 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 3               | 0            | 668.65      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202112 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 6               | 0            | 879.03      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202112 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 7               | 0            | 995.49      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202112 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 8               | 0            | 1450.18     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202112 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 9               | 0            | 1033.30     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202112 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 10              | 0            | 614.24      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202201 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 2               | 0            | 864.87      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202201 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 3               | 0            | 1179.50     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202201 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 6               | 0            | 395.45      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202201 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 7               | 0            | 939.95      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202201 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 8               | 0            | 1213.73     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202201 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 9               | 0            | 1467.47     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202201 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 10              | 0            | 840.45      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202202 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 2               | 0            | 990.76      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202202 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 3               | 0            | 966.39      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202202 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 6               | 0            | 306.70      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202202 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 7               | 0            | 343.52      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202202 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 8               | 0            | 981.59      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202202 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 9               | 0            | 806.22      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202202 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 10              | 0            | 412.76      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202203 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 2               | 0            | 1461.22     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202203 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 3               | 0            | 1133.46     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202203 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 6               | 0            | 1398.28     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202203 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 7               | 0            | 806.08      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202203 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 8               | 0            | 335.26      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202203 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 9               | 0            | 911.78      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202203 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 10              | 0            | 674.45      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202204 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 2               | 0            | 1206.61     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202204 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 3               | 0            | 1009.01     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202204 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 6               | 0            | 1077.13     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202204 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 7               | 0            | 1431.17     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202204 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 8               | 0            | 490.74      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202204 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 9               | 0            | 1306.33     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202204 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 10              | 0            | 1048.52     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202205 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 2               | 0            | 489.46      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202205 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 3               | 0            | 460.93      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202205 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 6               | 0            | 273.00      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202205 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 7               | 0            | 329.20      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202205 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 8               | 0            | 667.72      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202205 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 9               | 0            | 1177.69     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202205 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 10              | 0            | 930.67      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202206 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 2               | 0            | 1494.96     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202206 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 3               | 0            | 566.78      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202206 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 6               | 0            | 354.08      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202206 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 7               | 0            | 843.17      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202206 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 8               | 0            | 994.81      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202206 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 9               | 0            | 917.63      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202206 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 10              | 0            | 562.84      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202207 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 2               | 0            | 495.51      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202207 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 3               | 0            | 264.39      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202207 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 6               | 0            | 1241.51     |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202207 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 7               | 0            | 505.82      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202207 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 8               | 0            | 735.25      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202207 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 9               | 0            | 901.68      |
    | ILR2122        | R01                  | ORG0017280     | CM             | 202207 | 19TRN2020-2122          | [AllocRef_19TR]          | ?          | 10              | 0            | 572.61      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | [ContractNo]   | [AllocRef_19TR]    | 2               | 1449.74   | 1449.74  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 3               | 1325.15   | 1325.15  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 6               | 1367.11   | 1367.11  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 7               | 1221.02   | 1221.02  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 8               | 1016.82   | 1016.82  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 9               | 666.20    | 666.20   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_19TR]    | 10              | 779.54    | 779.54   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | [ContractNo]   | [AllocRef_19TR]    | 2               | 1449.74   | 1449.74  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 3               | 1325.15   | 1325.15  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 6               | 1367.11   | 1367.11  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 7               | 1221.02   | 1221.02  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 8               | 1016.82   | 1016.82  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 9               | 666.20    | 666.20   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 10              | 779.54    | 779.54   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | [ContractNo]   | [AllocRef_19TR]    | 2               | 1449.74   | 1449.74  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 3               | 1325.15   | 1325.15  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 6               | 1367.11   | 1367.11  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 7               | 1221.02   | 1221.02  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 8               | 1016.82   | 1016.82  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 9               | 666.20    | 666.20   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 10              | 779.54    | 779.54   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017280 | ORG0017280 | [AllocRef_19TR]   | 100932          | 19TRN2020-2122             | 202108               | RECONCILIATION  | CM             | False       | 1367.11         |
    | 10017280 | ORG0017280 | [AllocRef_19TR]   | 100933          | 19TRN2020-2122             | 202108               | RECONCILIATION  | CM             | False       | 1221.02         |
    | 10017280 | ORG0017280 | [AllocRef_19TR]   | 100934          | 19TRN2020-2122             | 202108               | RECONCILIATION  | CM             | False       | 1016.82         |
    | 10017280 | ORG0017280 | [AllocRef_19TR]   | 100935          | 19TRN2020-2122             | 202108               | RECONCILIATION  | CM             | False       | 666.20          |
    | 10017280 | ORG0017280 | [AllocRef_19TR]   | 100936          | 19TRN2020-2122             | 202108               | RECONCILIATION  | CM             | False       | 779.54          |
    | 10017280 | ORG0017280 | [AllocRef_19TR]   | 2355800         | 19TRN2020-2122             | 202108               | RECONCILIATION  | CM             | False       | 1449.74         |
    | 10017280 | ORG0017280 | [AllocRef_19TR]   | 2355860         | 19TRN2020-2122             | 202108               | RECONCILIATION  | CM             | False       | 1325.15         |





    # Payment Batch  for 19TRN2020-2122

    # Change the date
    Given the override date is '08/09/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '19TRN2020-2122' AccountingPaymentPeriod '202105' CensusEndDate '08/09/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_19TR]          | 202108 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 19TRN2020-2122             | 202108               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 19TRN2020-2122             | 202108               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '19TRN2020-2122' PaymentPeriod '202105' CensusEndDate '08/09/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A280.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod '19TRN2020-2122' PaymentPeriod '202105' CensusEndDate '08/09/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef   | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | 19TR                   | 2021          | 05             | 08          | ?       | [AllocRef_19TR] | 1367.11         | RECONCILIATION   | 19-24Trn19+Hardship                | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017280 | 100932     |
    | 19TR                   | 2021          | 05             | 08          | ?       | [AllocRef_19TR] | 1221.02         | RECONCILIATION   | 19-24Trn20+Childcare               | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017280 | 100933     |
    | 19TR                   | 2021          | 05             | 08          | ?       | [AllocRef_19TR] | 1016.82         | RECONCILIATION   | 19-24TrnRsdntlAccess               | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017280 | 100934     |
    | 19TR                   | 2021          | 05             | 08          | ?       | [AllocRef_19TR] | 666.20          | RECONCILIATION   | 19-24TrnAdminExp                   | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017280 | 100935     |
    | 19TR                   | 2021          | 05             | 08          | ?       | [AllocRef_19TR] | 779.54          | RECONCILIATION   | 19-24TrnC19Response                | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017280 | 100936     |
    | 19TR                   | 2021          | 05             | 08          | ?       | [AllocRef_19TR] | 1449.74         | RECONCILIATION   | 19-24 Traineeships                 | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017280 | 2355800    |
    | 19TR                   | 2021          | 05             | 08          | ?       | [AllocRef_19TR] | 1325.15         | RECONCILIATION   | 19-24TraineeshpsLngS               | 2021-09-20 | 2021-08-01   | 2022-07-31 | ?              | 10017280 | 2355860    |

    
    # Tidy Up
    Given the override date is reset
    
@AcceptanceTest @Withdrawn20230123
Scenario: A281 Bulk create a new 21/22 19-24 Traineeships contract. Publish and approve. Check docs, financials, CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017281' 
    And   there are no terminated or closed allocations for UKPRN '10017281' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017281' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017281' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017281' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 19TRN2020-2122    |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017281'

    # Set the base timestamp for each of the 19-24 Traineeships document templates (DocumentsDomain.UploadedDocumentTemplate) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_19TRN2020_2020-08-01.docx                   | 2020-12-02 10:00:00.000 | 
    | 19TRN2020_TAC_2020-08-01.docx                   | 2020-12-02 10:00:00.000 | 
    | 19TRN2020_2021_S1_2020-08-01.docx               | 2020-12-02 10:00:00.000 | 
    | 19TRN2020_S2_2020-08-01.docx                    | 2020-12-02 10:00:00.000 | 
    | FA_19TRN2020_2021_2020-08-01.docx               | 2020-12-02 10:00:00.000 | 
    | 19TRN2020_S3ON_2020-08-01.docx                  | 2020-12-02 10:00:00.000 | 
    # 
    | 19TRN2020_2122_TAC_2021-08-01.docx              | 2021-06-02 10:00:00.000 | 
    | 19TRN2020_2122_S1_2021-08-01.docx               | 2021-06-02 10:00:00.000 | 
    | 19TRN2020_2122_S2_2021-08-01.docx               | 2021-06-02 10:00:00.000 | 
    | 19TRN2020_2122_S3ON_2021-08-01.docx             | 2021-06-02 10:00:00.000 | 




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017281' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017281 Co Ltd' with UKPRN '10017281' and OrgId 'ORG0017281' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017281' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017281 | 117281 | 10017281 Co Ltd | 0              | Active                | Yes           | AA017281      | ?             | 22 Church Street       | ?                      | ?                      | ?                      | Ware                   | Hertfordshire          | SG12 9EH  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017281 |





    # Change the date
    Given the override date is '01/07/2021'

    # Bulk file (Intent = New) 
    And   there are no files prefixed '10017281' in the Sharepoint '19TRN2020-2122-Input-Appendices' folder
    And   there are no files prefixed '19TRN2020 AY 2122 24062021141525 v3_A281' in the Sharepoint 'Input' folder
    And   there are no files prefixed '19TRN2020 AY 2122 24062021141525 v3_A281' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '19TRN2020 AY 2122 24062021141525 v3_A281' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '19TRN2020 AY 2122 24062021141525 v3_A281' in the Sharepoint 'Reports' folder
    And   spreadsheet '19TRN2020 AY 2122 24062021141525 v3_A281.xlsx' exists in the Datafiles folder and UKPRN '10017281' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017281' for FundingType '19TRN2020' and period '2122'

    # Check the contents of the Appendices
    Then  the file named '10017281_[ContractNo]_v1.pdf' in Sharepoint location '19TRN2020-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017281 Co Ltd UKPRN: 10017281
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    19 to 24 Traineeships - 2020 Procurement [AllocRef_19TR] £91,135 £43,865 £135,000
    of which Learner Support £38,440 £25,244 £63,684
    Total: £135,000
    Total Funding for this contract: £135,000
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 February 2021 to 31 July 2023
    Between the Secretary of State for Education
    And 10017281 Co Ltd
    Funding for 19 to 24 Traineeships
    Master Contract Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    Version 3 (April 2022) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017281 Co Ltd THE SECRETARY OF STATE FOR
    22 Church Street EDUCATION
    Ware DEPARTMENT FOR EDUCATION
    Hertfordshire 20 GREAT SMITH STREET
    AND
    SG12 9EH LONDON
    SW1P 3BT
    Company No: AA017281
    Hereinafter called Hereinafter called
    the Contractor the Department
    Version 3 (April 2022) Page 2
    Version 3 (April 2022) Page 78

    SCHEDULE 1: SPECIFICATION & MONITORING
    19 TO 24-YEAR-OLD PROCURED ADULT EDUCATION BUDGET
    TRAINEESHIPS SPECIFICATION
    Schedule 1 Version 2 (July 2021) – Page 1
    
    SCHEDULE 2: PAYMENT
    19-24-YEAR-OLD PROCURED ADULT EDUCATION BUDGET
    TRAINEESHIPS
    Schedule 2 Version 2 (July 2021)  – Page 1
    
    SCHEDULE 2
    Funding Agreement – 19 to 24 Traineeships - 2020 Procurement
    Provider: 10017281 Co Ltd UKPRN: 10017281
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_19TR]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    19 to 24 Traineeships - 2020 Procurement £135,000 £8,190 £13,120 £9,209 £10,462 £10,431 £13,687 £13,940 £12,096 £9,751 £6,725 £13,690 £13,699
    of which Learner Support £63,684 £3,484 £5,272 £2,837 £5,502 £3,347 £3,973 £7,908 £6,117 £5,725 £4,790 £7,593 £7,136
    Total Funding £135,000 £8,190 £13,120 £9,209 £10,462 £10,431 £13,687 £13,940 £12,096 £9,751 £6,725 £13,690 £13,699
    Schedule 2 – Funding Agreement [AllocRef_19TR] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    Schedule 3 Version 2 (July 2021) – Page 1 
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017281_[ContractNo]_v1.pdf' in '19TRN2020-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A281.pdf'

    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-01 09:12:35.000 |

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
    | 10017281 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017281 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '120' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_19TR] | 2355800          | Jul-22 | Reconciliation |
    | [AllocRef_19TR] | 100932           | Jul-22 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '3' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                      | DeliverableDescription     | 
    | 10017281 | [ContractNo]   | 1               | [AllocRef_19TR] | 1               | 1                     | 135000.00    | 0             | 0        | 19-24 Traineeships Total Funding     | ?                          |
    | 10017281 | [ContractNo]   | 1               | [AllocRef_19TR] | 4               | 1                     | 71316.00     | 0             | 0        | 19-24 Traineeships                   | ?                          |
    | 10017281 | [ContractNo]   | 1               | [AllocRef_19TR] | 5               | 1                     | 63684.00     | 0             | 0        | 19-24 Traineeships Learner Support   | ?                          |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | [ContractNo]   | [AllocRef_19TR]    | 1               | 135000.00 | 8190.00  | 13120.00 | 9209.00  | 10462.00 | 10431.00 | 13687.00 | 13940.00 | 12096.00 | 9751.00  | 6725.00  | 13690.00 | 13699.00 | 
    | [ContractNo]   | [AllocRef_19TR]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 4               | 71316.00  | 4706.00  | 7848.00  | 6372.00  | 4960.00  | 7084.00  | 9714.00  | 6032.00  | 5979.00  | 4026.00  | 1935.00  | 6097.00  | 6563.00  | 
    | [ContractNo]   | [AllocRef_19TR]    | 5               | 63684.00  | 3484.00  | 5272.00  | 2837.00  | 5502.00  | 3347.00  | 3973.00  | 7908.00  | 6117.00  | 5725.00  | 4790.00  | 7593.00  | 7136.00  | 
    | [ContractNo]   | [AllocRef_19TR]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_19TR]    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Tidy Up
    And   the override date is reset    

