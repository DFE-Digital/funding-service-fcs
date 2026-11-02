Feature: APPS2526final


@AcceptanceTest @Complete
@Long2Run @Long2Run123
Scenario: S900 Bulk load a new draft EDSK2526 contract with several FSPs. Publish and approve. Check docs, CRM PaaS and Feed
    Given there are no allocations marked as Under Termination for UKPRN '10010037' 
    And   there are no terminated or closed allocations for UKPRN '10010037' 
    And   there is no Contract, Task or Workflow data for UKPRN '10010037' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10010037' 
 
#    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
#    Given there is no data in the ContractRequest.FundingAllocationRelease table 
#
#    # Clear down the CFS stub, PaaS Funding Allocation tables and FeedRead
#    And   there is no data in the CFS stub
#    And   there is no data in the Funding Allocation PaaS tables
 
    
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    ## Clear down ContractRequest.FundingAllocationRelease table (J146) 
    #And   there is no data in the ContractRequest.FundingAllocationRelease table 

    
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10010037' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLBC2526		    |
    | ALLF2526		    |
    | APPS2526		    |

#    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
#    And   there are no Sector-based Work Academies profile values in config for UKPRN '10010037'
#
#    # Set the 'base' timestamp for each of the 22\23 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
#    And   the following document templates have Upload timestamps as indicated 
#    | DocumentTemplateName                              | UploadTimestamp         | 
#    | SOF_EDSK_2022-08-01.docx                          | 2023-04-01 12:00:00.000 | 
#    #  
#    | EDSK2526_TAC_CFS_ITP_2022-08-01.docx              | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_TAC_COFG_COLLEGE_2022-08-01.docx         | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_TAC_COFG_EMPLOYER_2022-08-01.docx        | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_TAC_COFG_HEI_2022-08-01.docx             | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_TAC_COFG_LA_2022-08-01.docx              | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_TAC_COFG_NMSS_2022-08-01.docx            | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_TAC_COFG_SPI_2022-08-01.docx             | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_TAC_COFG_TRUST_2022-08-01.docx           | 2023-04-01 12:00:00.000 | 
#    #  
#    | EDSK2223_S1_1618TRN_CFS_2022-08-01.docx           | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_1618TRN_COFG_2022-08-01.docx          | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_1619ED_COLLEGE_2022-08-01.docx        | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_1619ED_HEI_2022-08-01.docx            | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_1619ED_ITP_2022-08-01.docx            | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_1619ED_LA_2022-08-01.docx             | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_1619ED_NMSS_2022-08-01.docx           | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_1619ED_SPI_2022-08-01.docx            | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_AEB_COFG_2022-08-01.docx              | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_LOANS_CFS_2022-08-01.docx             | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S1_LOANS_COFG_2022-08-01.docx            | 2023-04-01 12:00:00.000 | 
#    #  
#    | EDSK2223_S2_1618TRN_CFS_2022-08-01.docx           | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S2_1618TRN_COFG_2022-08-01.docx          | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S2_1618TRNME_CFS_2022-08-01.docx         | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S2_1618TRNME_COFG_2022-08-01.docx        | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S2_1619ED_CFS_2022-08-01.docx            | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S2_1619ED_COFG_2022-08-01.docx           | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S2_1619ED_NMSS_2022-08-01.docx           | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S2_AEB_COFG_2022-08-01.docx              | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S2_LOANS_CFS_2022-08-01.docx             | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S2_LOANS_COFG_2022-08-01.docx            | 2023-04-01 12:00:00.000 | 
#    #  
#    | FA_EDSK2223_2022-08-01.docx                       | 2023-04-01 12:00:00.000 | 
#    #  
#    | EDSK2223_S3ON_CFS_ITP_2022-08-01.docx             | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S3ON_COFG_COLLEGE_2022-08-01.docx        | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S3ON_COFG_EMPLOYER_2022-08-01.docx       | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S3ON_COFG_LA_TRUST_HEI_2022-08-01.docx   | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S3ON_COFG_NMSS_2022-08-01.docx           | 2023-04-01 12:00:00.000 | 
#    | EDSK2223_S3ON_COFG_SPI_2022-08-01.docx            | 2023-04-01 12:00:00.000 | 
#


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10010037' 
    And   there is no caseload advisor for UKPRN '10010037' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10010037 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10010037' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10010037 Co Ltd' with UKPRN '10010037' and OrgId 'ORG0010037' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10010037 | 110037 | 10010037 Co Ltd | 0              | In Administration     | Yes           | AA010037      | ?             | 9 Ronaldshaw Park      | Ayr                    | ?                      | ?                      | ?                      | ?                      | KA7 2TJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10010037 |





    # Change the date
    Given the override date is '16/07/2025'

    # Bulk file for new [Conditions of Funding (Grant) (College)] contract
    And   there are no files prefixed '10010037' in the Sharepoint 'EDSK-2526-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2526 12062024105948 v1_AK037' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2526 12062024105948 v1_AK037' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2526 12062024105948 v1_AK037' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2526 12062024105948 v1_AK037' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2526 12062024105948 v1_AK037.xlsx' exists in the Datafiles folder and UKPRN '10010037' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10010037' for FundingType 'EDSK' and period '2526' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10010037' for FundingType 'EDSK' and period '2526'

    # Check the contents of the Appendices
#    Then  the file named '10010037_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2526-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING 2025/25
#    Organisation Name: 10010037 Co Ltd UKPRN: 10010037
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    Contract Ref Aug 25 - Mar 26 Apr 26 - Jul 26 2025/26 Total
#    Advanced Learner Loans Facility [AllocRef_ALLF] £25,775 £12,005 £37,780
#    Advanced Learner Loans Bursary [AllocRef_ALLC] £40,174 £21,996 £62,170
#    Apprenticeships Carry-In [AllocRef_APPS] £22,284 £12,005 £34,289
#    Total Funding for this contract: £134,239
#    Summary of Funding – Page 1
#    Agreement Type Conditions of Funding (Grant) (Local Authorities)
#    Funding Period 1 August 2025 to 31 July 2026
#    Between the Secretary of State for Education
#    And 10010037 Co Ltd
#    Advanced Learner Loans
#    Funding for
#    Apprenticeships Carry-In
#    ACCEPTANCE BY THE PROVIDER
#    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
#    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
#    THE PROVIDER REPRESENTS AND WARRANTS THAT THE PROVIDER HAS
#    READ AND UNDERSTOOD THIS AGREEMENT, THE PROVIDER AGREES TO BE
#    BOUND BY THIS AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO
#    ACCEPT THIS AGREEMENT AND LEGALLY BIND THE PROVIDER.
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    EDSK Conditions of Funding (Grant) (Local Authorities)
#    Version 2 - July 2025 - Page 1
#    This Agreement is made on the date the Agreement is digitally signed by the
#    Provider on the Manage Your Education & Skills Funding Service between:
#    10010037 Co Ltd THE SECRETARY OF STATE FOR
#    9 Ronaldshaw Park EDUCATION
#    Ayr DEPARTMENT FOR EDUCATION
#    KA7 2TJ 20 GREAT SMITH STREET
#    AND
#    LONDON
#    SW1P 3BT
#    Company No: AA018053
#    Hereinafter called Hereinafter called
#    the Provider the Department
#    EDSK Conditions of Funding (Grant) (Local Authorities)
#    Version 2 - July 2025 - Page 60
#
#
#    SCHEDULE 1: DEFINITIONS
#    Schedule 1
#    Version 2 - July 2025 - Page 1
#
#    SCHEDULE 2: SPECIFICATION & MONITORING
#    ADVANCED LEARNER LOANS SPECIFICATION
#    Schedule 2: Advanced Learner Loans 
#    Version 2 – July 2025 – Page 1
#
#
#    SCHEDULE 2: SPECIFICATION & MONITORING
#    APPRENTICESHIPS CARRY-IN SPECIFICATION
#    Schedule 2: Apprenticeships Carry-In
#    Version 1 – July 2025 – Page 1
#
#  
#
#    SCHEDULE 3: PAYMENT
#    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
#    Funding Agreement – Advanced Learner Loans Facility
#    Provider: 10010037 Co Ltd UKPRN: 10010037
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2025 End Date: 31/07/2026
#    Contract Ref: [AllocRef_ALLF]
#    Cash (£) Aug 2025 Sep 2025 Oct 2025 Nov 2025 Dec 2025 Jan 2026 Feb 2026 Mar 2026 Apr 2026 May 2026 Jun 2026 Jul 2026
#    Advanced Learner Loans Facility £37,780 £6,510 £2,041 £5,385 £1,192 £2,094 £1,499 £3,283 £3,771 £6,032 £1,361 £1,584 £3,028
#    Total Funding £37,780 £6,510 £2,041 £5,385 £1,192 £2,094 £1,499 £3,283 £3,771 £6,032 £1,361 £1,584 £3,028
#    Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
#    
#    ADVANCED LEARNER LOANS
#    Funding Agreement – Advanced Learner Loans Bursary
#    Provider: 10010037 Co Ltd UKPRN: 10010037
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2025 End Date: 31/07/2026
#    Contract Ref: [AllocRef_ALLC]
#    Cash (£) Aug 2025 Sep 2025 Oct 2025 Nov 2025 Dec 2025 Jan 2026 Feb 2026 Mar 2026 Apr 2026 May 2026 Jun 2026 Jul 2026
#    Advanced Learner Loans Bursary Funding £62,170 £6,951 £5,200 £391 £6,866 £5,454 £7,578 £1,208 £6,526 £6,969 £5,016 £2,925 £7,086
#    Total Funding £62,170 £6,951 £5,200 £391 £6,866 £5,454 £7,578 £1,208 £6,526 £6,969 £5,016 £2,925 £7,086
#    Advanced Learner Loans – Funding Agreement [AllocRef_ALLC] – Page 1 Ref (for internal use only):  [ContractNo] v1
#    
#    APPRENTICESHIPS CARRY-IN
#    Funding Agreement – Apprenticeships Carry-In
#    Provider: 10010037 Co Ltd UKPRN: 10010037
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2025 End Date: 31/07/2026
#    Contract Ref: [AllocRef_APPS]
#    Cash (£) Aug 2025 Sep 2025 Oct 2025 Nov 2025 Dec 2025 Jan 2026 Feb 2026 Mar 2026 Apr 2026 May 2026 Jun 2026 Jul 2026
#    Apprenticeships Carry-In £34,289 £678 £2,041 £5,385 £1,192 £4,435 £1,499 £3,283 £3,771 £6,032 £1,361 £1,584 £3,028
#    Total Funding £34,289 £678 £2,041 £5,385 £1,192 £4,435 £1,499 £3,283 £3,771 £6,032 £1,361 £1,584 £3,028
#    Apprenticeships Carry-In – Funding Agreement [AllocRef_APPS] – Page 1 Ref (for internal use only):  [ContractNo] v1
#
#
#    SCHEDULE 4: UK GDPR/DATA PROTECTION
#    Schedule 4
#    Version 2 – July 2025 – Page 1
#
#    SCHEDULE 5: SECURITY & DEPARTMENT POLICIES
#    Schedule 5
#    Version 2 – July 2025 – Page 1
#
#    SCHEDULE 6: EXIT ARRANGEMENTS
#    Schedule 6
#    Version 2 – July 2025 – Page 1
#
#    SCHEDULE 7: SUBCONTRACTING
#    Schedule 7
#    Version 2 – July 2025 – Page 1
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
    
    And   Sharepoint file '10010037_[ContractNo]_v1.pdf' in 'EDSK-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as '10010037_[ContractNo]_v1.pdf'


    # Part 4: Publish and approve 25/26 v1 and check feed

    # Change the date
    Given the override date is '29/07/2025'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010037 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2025        | 31/07/2026      | ?             |
    | 10010037 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2025        | 31/07/2026      | ?             |


    # Part 5: Add Actuals for 25/26 then check CRM

    # Add actuals to the contract for ALLBC2526, ALLF2526, APPS2526

  # Add actuals to the contract for APPS2526

  # Change the date
  Given the override date is '04/09/2025'

  # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
  And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0010037'

  # Clear down the stub
  And   there are no entries in the DCFS stub table

  # Month end is not running
  And   the PaaS MonthEndIsRunning indicator is set to 'False'

  # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
  And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

  # Pull actuals from DC for Aug 2022
 And   the following closed collections are available in DCFS 
 | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber        | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
 | APPS           | APPS100               | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 343.56      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 322.38      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 168.11      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 846.86      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 875.31      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 458.34      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 516.63      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 682.09      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 477.18      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 480.01      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 119.73      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 418.47      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 381.10      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 979.14      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1139.69     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 1356.61     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 1322.71     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1236.33     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1272.19     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 1396.93     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 238.20      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 730.41      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 418.21      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 224.05      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1311.28     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 997.86      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 705.86      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 641.13      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 769.94      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 842.12      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1262.28     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 454.26      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1433.43     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 293.02      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 335.48      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 106.84      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1009.04     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 716.13      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 566.30      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 863.95      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 339.06      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1072.13     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 610.19      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 546.70      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 797.59      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 126.17      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 1109.12     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 816.66      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 637.45      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 407.33      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1213.47     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 810.21      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 1487.05     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1317.87     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1053.89     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 922.87      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1197.25     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 992.68      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 363.19      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1343.76     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1038.26     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 1308.67     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 248.18      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 939.89      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 646.48      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 644.08      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1111.61     |
 | APPS           | APPS100               | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 9               | 0            | 690.60      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 10              | 0            | 321.43      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 22              | 0            | 987.94      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 23              | 0            | 923.94      |
 | APPS           | APPS100               | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 24              | 0            | 471.91      |
 #
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202508 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202509 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202510 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202511 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202512 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202601 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202602 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202603 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202604 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202605 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202606 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
 | ILR2526        | R01                  | ORG0010037     | CM             | 202607 | APPS2526                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |


   


    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service
     Then wait '30' seconds

    #    # Check MonitoringDeliverables.HeldReportedActualGroup (Only used ILR2526 APPS contracts) Is the data showing as unprocessed ?
   # Then  there is '1' row on table HeldReportedActualGroup for FSP 'ILR2526' OrgId 'ORG0010037' and Collection 'R02' marked as unprocessed
   #And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS' OrgId 'ORG0010037' and Collection 'APPS100' marked as unprocessed
#
#    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    When  MonthEnd processing has completed and the processing of held data is triggered
#
    # Check financials

# # Check the ACTUAL VALUES in CRM on the latest approved contract
 Then  the Actuals Value Data is as follows
 | ContractNumber | AllocationRef 	  | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   |
 | [ContractNo]   | [AllocRef_APPS]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 2               | 872.56    | 872.56   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 3               | 1399.35   | 1399.35  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 4               | 845.33    | 845.33   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 5               | 390.89    | 390.89   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 6               | 1016.17   | 1016.17  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 7               | 216.91    | 216.91   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 8               | 343.56    | 343.56   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 9               | 322.38    | 322.38   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 10              | 168.11    | 168.11   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 11              | 1397.45   | 1397.45  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 12              | 1070.04   | 1070.04  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 13              | 722.26    | 722.26   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 14              | 418.13    | 418.13   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 15              | 385.36    | 385.36   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 16              | 1481.64   | 1481.64  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 17              | 711.43    | 711.43   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 18              | 1328.71   | 1328.71  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 19              | 969.41    | 969.41   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 20              | 1332.19   | 1332.19  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 21              | 901.73    | 901.73   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 22              | 846.86    | 846.86   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 23              | 875.31    | 875.31   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 | [ContractNo]   | [AllocRef_APPS]    | 24              | 458.34    | 458.34   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

 And   the Reconciliation Data is calculated as follows 
 | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   |
 | [ContractNo]   | [AllocRef_APPS]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 2               | 872.56    | 872.56   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 3               | 1399.35   | 1399.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 4               | 845.33    | 845.33   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 5               | 390.89    | 390.89   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 6               | 1016.17   | 1016.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 7               | 216.91    | 216.91   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 8               | 343.56    | 343.56   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 9               | 322.38    | 322.38   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 10              | 168.11    | 168.11   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 11              | 1397.45   | 1397.45  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 12              | 1070.04   | 1070.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 13              | 722.26    | 722.26   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 14              | 418.13    | 418.13   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 15              | 385.36    | 385.36   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 16              | 1481.64   | 1481.64  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 17              | 711.43    | 711.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 18              | 1328.71   | 1328.71  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 19              | 969.41    | 969.41   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 20              | 1332.19   | 1332.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 21              | 901.73    | 901.73   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 22              | 846.86    | 846.86   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 23              | 875.31    | 875.31   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 24              | 458.34    | 458.34   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

 # Check the CAPPING AMOUNTS in CRM on the latest approved contract
 And   the Capping Amounts are calculated as follows 
 | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   |
 | [ContractNo]   | [AllocRef_APPS]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 14              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 15              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 16              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 19              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 20              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 21              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 22              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 23              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 24              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

 # Check the NET AMOUNTS in CRM on the latest approved contract
 And   the Net Payments are calculated as follows 
 | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   |
 | [ContractNo]   | [AllocRef_APPS]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 2               | 872.56    | 872.56   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 3               | 1399.35   | 1399.35  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 4               | 845.33    | 845.33   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 5               | 390.89    | 390.89   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 6               | 1016.17   | 1016.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 7               | 216.91    | 216.91   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 8               | 343.56    | 343.56   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 9               | 322.38    | 322.38   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 10              | 168.11    | 168.11   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 11              | 1397.45   | 1397.45  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 12              | 1070.04   | 1070.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 13              | 722.26    | 722.26   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 14              | 418.13    | 418.13   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 15              | 385.36    | 385.36   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 16              | 1481.64   | 1481.64  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 17              | 711.43    | 711.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 18              | 1328.71   | 1328.71  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 19              | 969.41    | 969.41   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 20              | 1332.19   | 1332.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 21              | 901.73    | 901.73   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 22              | 846.86    | 846.86   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 23              | 875.31    | 875.31   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
 | [ContractNo]   | [AllocRef_APPS]    | 24              | 458.34    | 458.34   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


 ## Check the RECONCILIATION subnominal aggregations in CRM
 #And   the Reconciliation Subnominal Amounts are calculated as follows
 #| ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   |
 #| 10010037 | [ContractNo]   | [AllocRef_APPS]    | 2240100                  | 4524.30   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
 #| 10010037 | [ContractNo]   | [AllocRef_APPS]    | 2240150                  | 665.94    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
 #| 10010037 | [ContractNo]   | [AllocRef_APPS]    | 2240160                  | 168.11    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
 #| 10010037 | [ContractNo]   | [AllocRef_APPS]    | 2240170                  | 216.91    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
 #| 10010037 | [ContractNo]   | [AllocRef_APPS]    | 2340100                  | 8487.91   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
 #| 10010037 | [ContractNo]   | [AllocRef_APPS]    | 2340150                  | 1722.17   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
 #| 10010037 | [ContractNo]   | [AllocRef_APPS]    | 2340160                  | 458.34    | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
 #| 10010037 | [ContractNo]   | [AllocRef_APPS]    | 2340170                  | 2230.44   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
 
 
 
 


    # Change the date
    Given the override date is '16/09/2025'

    # Bulk file for new [Conditions of Funding (Grant) (College)] contract
    And   there are no files prefixed '10010037' in the Sharepoint 'EDSK-2526-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2526 12062025105948 v2_AK037' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2526 12062025105948 v2_AK037' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2526 12062025105948 v2_AK037' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2526 12062025105948 v2_AK037' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2526 12062025105948 v2_AK037.xlsx' exists in the Datafiles folder and UKPRN '10010037' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10010037' for FundingType 'EDSK' and period '2526' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10010037' for FundingType 'EDSK' and period '2526'


#    # Copy\Save a named Sharepoint file to a named folder\filename
    
    And   Sharepoint file '10010037_[ContractNo]_v2.pdf' in 'EDSK-2526-Input-Appendices' is copied to 'Datafiles/Downloads' as '10010037_[ContractNo]_v2.pdf'

 
 