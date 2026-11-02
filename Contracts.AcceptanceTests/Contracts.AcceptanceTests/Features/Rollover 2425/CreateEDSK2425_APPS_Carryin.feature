Feature: CreateEDSK2425_APPS_Carryin 42495

@AcceptanceTest @Complete
@Long2Run @Long2Run123
Scenario: S053 Bulk load a new draft EDSK2425 contract with several FSPs. Publish and approve. Check docs, CRM PaaS and Feed
    Given there are no allocations marked as Under Termination for UKPRN '10018053' 
    And   there are no terminated or closed allocations for UKPRN '10018053' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018053' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018053' 
 
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
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018053' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLBC2425		    |
    | ALLF2425		    |
    | APPS2425		    |

#    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
#    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018053'
#
#    # Set the 'base' timestamp for each of the 22\23 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
#    And   the following document templates have Upload timestamps as indicated 
#    | DocumentTemplateName                              | UploadTimestamp         | 
#    | SOF_EDSK_2022-08-01.docx                          | 2023-04-01 12:00:00.000 | 
#    #  
#    | EDSK2425_TAC_CFS_ITP_2022-08-01.docx              | 2023-04-01 12:00:00.000 | 
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
    Given there is no Organisation data in CRM for UKPRN '10018053' 
    And   there is no caseload advisor for UKPRN '10018053' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018053 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018053' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018053 Co Ltd' with UKPRN '10018053' and OrgId 'ORG0018053' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018053 | 118053 | 10018053 Co Ltd | 0              | In Administration     | Yes           | AA018053      | ?             | 9 Ronaldshaw Park      | Ayr                    | ?                      | ?                      | ?                      | ?                      | KA7 2TJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018053 |





    # Change the date
    Given the override date is '16/07/2024'

    # Bulk file for new [Conditions of Funding (Grant) (College)] contract
    And   there are no files prefixed '10018053' in the Sharepoint 'EDSK-2425-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2425 13062024105948 v1_S053' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2425 13062024105948 v1_S053' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2425 13062024105948 v1_S053' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2425 13062024105948 v1_S053' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2425 13062024105948 v1_S053.xlsx' exists in the Datafiles folder and UKPRN '10018053' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10018053' for FundingType 'EDSK' and period '2425' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10018053' for FundingType 'EDSK' and period '2425'

    # Check the contents of the Appendices
    Then  the file named '10018053_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2425-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2024/25
    Organisation Name: 10018053 Co Ltd UKPRN: 10018053
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 24 - Mar 25 Apr 25 - Jul 25 2024/25 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £25,775 £12,005 £37,780
    Advanced Learner Loans Bursary [AllocRef_ALLC] £40,174 £21,996 £62,170
    Apprenticeships Carry-In [AllocRef_APPS] £22,284 £12,005 £34,289
    Total Funding for this contract: £134,239
    Summary of Funding – Page 1
    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    Funding Period 1 August 2024 to 31 July 2025
    Between the Secretary of State for Education
    And 10018053 Co Ltd
    Advanced Learner Loans
    Funding for
    Apprenticeships Carry-In
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
    EDSK Conditions of Funding (Grant) (Local Authorities)
    Version 2 - July 2024 - Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10018053 Co Ltd THE SECRETARY OF STATE FOR
    9 Ronaldshaw Park EDUCATION
    Ayr DEPARTMENT FOR EDUCATION
    KA7 2TJ 20 GREAT SMITH STREET
    AND
    LONDON
    SW1P 3BT
    Company No: AA018053
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Conditions of Funding (Grant) (Local Authorities)
    Version 2 - July 2024 - Page 60


    SCHEDULE 1: DEFINITIONS
    Schedule 1
    Version 2 - July 2024 - Page 1

    SCHEDULE 2: SPECIFICATION & MONITORING
    ADVANCED LEARNER LOANS SPECIFICATION
    Schedule 2: Advanced Learner Loans 
    Version 2 – July 2024 – Page 1


    SCHEDULE 2: SPECIFICATION & MONITORING
    APPRENTICESHIPS CARRY-IN SPECIFICATION
    Schedule 2: Apprenticeships Carry-In
    Version 1 – July 2024 – Page 1

  

    SCHEDULE 3: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10018053 Co Ltd UKPRN: 10018053
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
    Advanced Learner Loans Facility £37,780 £6,510 £2,041 £5,385 £1,192 £2,094 £1,499 £3,283 £3,771 £6,032 £1,361 £1,584 £3,028
    Total Funding £37,780 £6,510 £2,041 £5,385 £1,192 £2,094 £1,499 £3,283 £3,771 £6,032 £1,361 £1,584 £3,028
    Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Bursary
    Provider: 10018053 Co Ltd UKPRN: 10018053
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
    Contract Ref: [AllocRef_ALLC]
    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
    Advanced Learner Loans Bursary Funding £62,170 £6,951 £5,200 £391 £6,866 £5,454 £7,578 £1,208 £6,526 £6,969 £5,016 £2,925 £7,086
    Total Funding £62,170 £6,951 £5,200 £391 £6,866 £5,454 £7,578 £1,208 £6,526 £6,969 £5,016 £2,925 £7,086
    Advanced Learner Loans – Funding Agreement [AllocRef_ALLC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    APPRENTICESHIPS CARRY-IN
    Funding Agreement – Apprenticeships Carry-In
    Provider: 10018053 Co Ltd UKPRN: 10018053
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2024 End Date: 31/07/2025
    Contract Ref: [AllocRef_APPS]
    Cash (£) Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025 Apr 2025 May 2025 Jun 2025 Jul 2025
    Apprenticeships Carry-In £34,289 £678 £2,041 £5,385 £1,192 £4,435 £1,499 £3,283 £3,771 £6,032 £1,361 £1,584 £3,028
    Total Funding £34,289 £678 £2,041 £5,385 £1,192 £4,435 £1,499 £3,283 £3,771 £6,032 £1,361 £1,584 £3,028
    Apprenticeships Carry-In – Funding Agreement [AllocRef_APPS] – Page 1 Ref (for internal use only):  [ContractNo] v1


    SCHEDULE 4: UK GDPR/DATA PROTECTION
    Schedule 4
    Version 2 – July 2024 – Page 1

    SCHEDULE 5: SECURITY & DEPARTMENT POLICIES
    Schedule 5
    Version 2 – July 2024 – Page 1

    SCHEDULE 6: EXIT ARRANGEMENTS
    Schedule 6
    Version 2 – July 2024 – Page 1

    SCHEDULE 7: SUBCONTRACTING
    Schedule 7
    Version 2 – July 2024 – Page 1
    """
#
#    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
#    #   Note: Documents are created using the system date. The following step 'corrects' this
#    Given the following document creation details exist in the ContractManagement.CreatedContract table
#    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
#    | [ContractNo]   | 1                     | 0                        | 2024-07-16 12:06:22.000 |
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018053_[ContractNo]_v1.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018053_[ContractNo]_v1.pdf'

    
#    # Check the CONTRACT version, status and dates in CRM.
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10018053 | [ContractNo]       | 1                     | 1                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
#    | 10018053 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2024        | 31/07/2025      | ?             |
#
#


#
#
#    # Publish the contract
#
#    # Change the date 
#    Given the override date is '27/07/2023'
#
# #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
#   And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
# #  or
#    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
#    #And   a file with filename '10018025_[ContractNo]_v1.pdf' is created in 'EDSK-2425-Output-Merged Document'
#    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
#    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table
#
#    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10018053 | [ContractNo]       | 1                     | 1                        | Draft            | Published to Provider   | True          | False               | 01/08/2024        | 31/07/2025      | ?             |
#    | 10018053 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |




    # Part 4: Publish and approve 24/25 v1 and check feed

    # Change the date
    Given the override date is '29/07/2024'

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
    | 10018053 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                | True          | True                | 01/08/2024        | 31/07/2025      | ?             |
    | 10018053 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2024        | 31/07/2025      | ?             |



#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
#
#
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '5' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
#    | 10018053 | [ContractNo]   | 1               | [AllocRef_16TR]  | 31              | 0                     | 7545.00      | 0             | 0        | 16-19 Free Meals                               | ?                           |
#    | 10018053 | [ContractNo]   | 1               | [AllocRef_16ED]  | 22              | 0                     | 25383.00     | 0             | 0        | 16-19 High Needs Element 2                     | ?                           |
#    | 10018053 | [ContractNo]   | 1               | [AllocRef_16ED]  | 125             | 0                     | 22750.00     | 0             | 0        | Teacher's Pension Scheme 1619                  | ?                           |
#    | 10018053 | [ContractNo]   | 1               | [AllocRef_16ED]  | 51              | 0                     | 21319.00     | 0             | 0        | Alternative Completions - Sporting Excellence  | ?                           |
#    | 10018053 | [ContractNo]   | 1               | [AllocRef_16ED]  | 143             | 0                     | 8298.00      | 0             | 0        | 16-19 Tuition Fund                             | ?                           |
#

    ## Check the deliverable count in CRM includes all the monitoring deliverables
    #And   there are '120' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

  #  # Check that the CRM subnominals have been created before moving on
   # And   CRM subnominals have been created for the following allocations
   # | AllocationRef    | Subnominal Code  | Period | Payment Type   |
   ##| [AllocRef_ALLF]  | 2372010          | Jul-25 | Reconciliation |
   # | [AllocRef_ALLB]  | 2303800          | Jul-25 | Reconciliation |
   # | [AllocRef_APPS]  | 2240100          | Jul-25 | Reconciliation |
   # | [AllocRef_16TR]  | 2201300          | Jul-25 | Reconciliation |
   # | [AllocRef_16TM]  | 2201350          | Jul-25 | Reconciliation |


    # Part 5: Add Actuals for 24/25 then check CRM

    # Add actuals to the contract for ALLBC2425, ALLF2425, APPS2425

    # Change the date
    Given the override date is '04/10/2024'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018053'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2024
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 656.38      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 614.81      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 614.81      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 2352.37     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 465.26      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 2029.73     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 1578.92     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 2456.58     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 647.63      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 1427.78     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 1516.24     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 903.61      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 1218.05     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 701.10      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 533.70      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 2227.66     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 829.39      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 1417.38     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 1918.11     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 1589.44     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 1711.23     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 1989.29     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 702.52      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | ALLF2425         | [AllocRef_ALLF]          | ?          | 2               | 0            | 750.74      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | ALLF2425         | [AllocRef_ALLF]          | ?          | 6               | 0            | 596.14      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | ALLF2425         | [AllocRef_ALLF]          | ?          | 7               | 0            | 514.81      |
    #
    | APPS           | APPS89               | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 343.56      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 322.38      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 168.11      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 846.86      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 875.31      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 458.34      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 516.63      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 682.09      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 477.18      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 480.01      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 119.73      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 418.47      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 381.10      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 979.14      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1139.69     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 1356.61     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 1322.71     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1236.33     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1272.19     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 1396.93     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 238.20      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 730.41      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 418.21      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 224.05      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1311.28     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 997.86      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 705.86      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 641.13      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 769.94      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 842.12      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1262.28     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 454.26      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1433.43     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 293.02      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 335.48      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 106.84      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1009.04     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 716.13      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 566.30      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 863.95      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 339.06      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1072.13     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 610.19      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 546.70      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 797.59      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 126.17      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 1109.12     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 816.66      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 637.45      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 407.33      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1213.47     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 810.21      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 1487.05     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1317.87     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1053.89     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 922.87      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 1197.25     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 992.68      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 363.19      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 1343.76     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1038.26     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 1308.67     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 248.18      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 939.89      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 646.48      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 644.08      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 8               | 0            | 1111.61     |
    | APPS           | APPS89               | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 9               | 0            | 690.60      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 10              | 0            | 321.43      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 22              | 0            | 987.94      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 23              | 0            | 923.94      |
    | APPS           | APPS89               | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 24              | 0            | 471.91      |
    #
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202408 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202409 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202410 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202411 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202412 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202501 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202502 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202503 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202504 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202505 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202506 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 2               | 0            | 872.56      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 3               | 0            | 1399.35     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 4               | 0            | 845.33      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 5               | 0            | 390.89      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 6               | 0            | 1016.17     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 7               | 0            | 216.91      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 11              | 0            | 1397.45     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 12              | 0            | 1070.04     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 13              | 0            | 722.26      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 14              | 0            | 418.13      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 15              | 0            | 385.36      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 16              | 0            | 1481.64     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 17              | 0            | 711.43      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 18              | 0            | 1328.71     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 19              | 0            | 969.41      |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 20              | 0            | 1332.19     |
    | ILR2425        | R02                  | ORG0018053     | CM             | 202507 | APPS2425                | [AllocRef_APPS]                 | ?          | 21              | 0            | 901.73      |




    Then wait '30' seconds


    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    #    # Check MonitoringDeliverables.HeldReportedActualGroup (Only used for APPS contracts) Is the data showing as unprocessed ?
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS2425' OrgId 'ORG0018053' and Collection 'R02' marked as unprocessed
    And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS2425' OrgId 'ORG0018053' and Collection 'APPS89' marked as unprocessed
#
#    # Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
    When  MonthEnd processing has completed and the processing of held data is triggered
#
    # Check financials

#    # Check the PLANNED VALUES in CRM on the latest approved contract
#    Then  the Planned Values are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
#    | [ContractNo]   | NSF23-0024     | 1               | 89738.00  | 7235.00  | 8287.00  | 3021.00  | 10867.00 | 9072.00  | 4890.00  | 7374.00  | 4146.00  | 3765.00  | 12363.00 | 12533.00 | 6185.00  | 
#    | [ContractNo]   | NSF23-0024     | 2               | 41067.00  | 5587.00  | 5130.00  | 661.00   | 4006.00  | 7763.00  | 714.00   | 120.00   | 1903.00  | 2392.00  | 4653.00  | 7933.00  | 205.00   | 
#    | [ContractNo]   | NSF23-0024     | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | NSF23-0024     | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | NSF23-0024     | 5               | 48671.00  | 1648.00  | 3157.00  | 2360.00  | 6861.00  | 1309.00  | 4176.00  | 7254.00  | 2243.00  | 1373.00  | 7710.00  | 4600.00  | 5980.00  | 
#    | [ContractNo]   | NSF23-0024     | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | NSF23-0024     | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | NSF23-0024     | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | NSF23-0024     | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | NSF23-0024     | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    #
#    | [ContractNo]   | [AllocRef_16TR]    | 1               | 106975.00 | 11441.00 | 6250.00  | 6419.00  | 11750.00 | 7439.00  | 8692.00  | 8660.00  | 10868.00 | 12195.00 | 10326.00 | 7980.00  | 4955.00  | 
#    | [ContractNo]   | [AllocRef_16TR]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TR]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TR]    | 4               | 60557.00  | 6230.00  | 5572.00  | 3820.00  | 6963.00  | 5487.00  | 4075.00  | 6198.00  | 7780.00  | 5147.00  | 5094.00  | 3141.00  | 1050.00  | 
#    | [ContractNo]   | [AllocRef_16TR]    | 5               | 46418.00  | 5211.00  | 678.00   | 2599.00  | 4787.00  | 1952.00  | 4617.00  | 2462.00  | 3088.00  | 7048.00  | 5232.00  | 4839.00  | 3905.00  | 
#    | [ContractNo]   | [AllocRef_16TR]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TR]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TR]    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TR]    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TR]    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#	#
#    | [ContractNo]   | STFI23-0024    | 1               | 48191.00  | 225.00   | 7921.00  | 735.00   | 6393.00  | 5321.00  | 6425.00  | 3113.00  | 5098.00  | 4981.00  | 7444.00  | 55.00    | 480.00   | 
#    | [ContractNo]   | STFI23-0024    | 2               | 57906.00  | 7157.00  | 3028.00  | 5353.00  | 4217.00  | 1786.00  | 6967.00  | 7327.00  | 2518.00  | 6882.00  | 7582.00  | 1754.00  | 3335.00  | 
#    | [ContractNo]   | STFI23-0024    | 3               | 45879.00  | 6542.00  | 650.00   | 6648.00  | 4557.00  | 767.00   | 4185.00  | 3994.00  | 342.00   | 5459.00  | 172.00   | 5968.00  | 6595.00  | 
#    | [ContractNo]   | STFI23-0024    | 4               | 41802.00  | 2603.00  | 6627.00  | 395.00   | 7412.00  | 2264.00  | 1807.00  | 5289.00  | 682.00   | 4439.00  | 3230.00  | 2635.00  | 4419.00  | 
#    | [ContractNo]   | STFI23-0024    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef 	  | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   |
 #   | [ContractNo]   | [AllocRef_ALLBC]   | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ALLBC]   | 2               | 2508.75   | 156.38   | 2352.37  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ALLBC]   | 3               | 580.07    | 114.81   | 465.26   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
 #   | [ContractNo]   | [AllocRef_ALLBC]   | 4               | 629.62    | 114.81   | 514.81   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
	##
   #| [ContractNo]   | [AllocRef_ALLF]    | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
   #| [ContractNo]   | [AllocRef_ALLF]    | 2               | 3008.75   | 656.38   | 2352.37  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
   #| [ContractNo]   | [AllocRef_ALLF]    | 6               | 1080.07   | 614.81   | 465.26   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
   #| [ContractNo]   | [AllocRef_ALLF]    | 7               | 1129.62   | 614.81   | 514.81   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
	#
    | [ContractNo]   | [AllocRef_APPS]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 2               | 1745.12   | 872.56   | 872.56   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 3               | 2798.70   | 1399.35  | 1399.35  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 4               | 1690.66   | 845.33   | 845.33   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 5               | 781.78    | 390.89   | 390.89   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 6               | 2032.34   | 1016.17  | 1016.17  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 7               | 433.82    | 216.91   | 216.91   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 8               | 860.19    | 343.56   | 516.63   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 9               | 1004.47   | 322.38   | 682.09   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 10              | 645.29    | 168.11   | 477.18   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 11              | 2794.90   | 1397.45  | 1397.45  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 12              | 2140.08   | 1070.04  | 1070.04  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 13              | 1444.52   | 722.26   | 722.26   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 14              | 836.26    | 418.13   | 418.13   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 15              | 770.72    | 385.36   | 385.36   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 16              | 2963.28   | 1481.64  | 1481.64  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 17              | 1422.86   | 711.43   | 711.43   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 18              | 2657.42   | 1328.71  | 1328.71  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 19              | 1938.82   | 969.41   | 969.41   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 20              | 2664.38   | 1332.19  | 1332.19  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 21              | 1803.46   | 901.73   | 901.73   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 22              | 1326.87   | 846.86   | 480.01   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 23              | 995.04    | 875.31   | 119.73   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_APPS]    | 24              | 876.81    | 458.34   | 418.47   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 




##    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
##    And   the Reconciliation Data is calculated as follows 
##    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
##    | [ContractNo]   | NSF23-0024     | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | NSF23-0024     | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | NSF23-0024     | 3               | 2755.17   | 0.00     | 2755.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | NSF23-0024     | 4               | 1482.48   | 0.00     | 1482.48  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | NSF23-0024     | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | NSF23-0024     | 6               | 1905.17   | 0.00     | 1905.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | NSF23-0024     | 7               | 2729.42   | 0.00     | 2729.42  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | NSF23-0024     | 8               | 1610.99   | 0.00     | 1610.99  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | NSF23-0024     | 9               | 3909.62   | 0.00     | 3909.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | NSF23-0024     | 10              | 4114.97   | 0.00     | 4114.97  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    #
##    | [ContractNo]   | [AllocRef_16TR]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TR]    | 2               | 3008.75   | 0.00     | 3008.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TR]    | 3               | 980.07    | 0.00     | 980.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TR]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TR]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TR]    | 6               | 2567.98   | 0.00     | 2567.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TR]    | 7               | 2111.17   | 0.00     | 2111.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TR]    | 8               | 1323.40   | 0.00     | 1323.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TR]    | 9               | 3073.78   | 0.00     | 3073.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TR]    | 10              | 2023.94   | 0.00     | 2023.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    #
#    | [ContractNo]   | STFI23-0024    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 5               | 5351.13   | 0.00     | 5351.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 6               | 4974.78   | 0.00     | 4974.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 7               | 6374.14   | 0.00     | 6374.14  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 8               | 4252.65   | 0.00     | 4252.65  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 9               | 5624.78   | 0.00     | 5624.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 10              | 6172.80   | 0.00     | 6172.80  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 11              | 4973.08   | 0.00     | 4973.08  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | STFI23-0024    | 12              | 6826.77   | 0.00     | 6826.77  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
##




    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | 16-18TRN2425              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TR]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 19+ Hardship                            | Adult Skills 19+ Hardship                                       | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 564.11       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100927                   | 2372016           | Aug              |
#    | 16-18TRN2425              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TR]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 19+ Hardship                            | Adult Skills 19+ Hardship                                       | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 2003.87      | 0             |              | Yes                | 0.00           | 0.00             | 2567.98               | 0.00           | 2567.98         |             | No            |                   |        |                   | 100927                   | 2372016           | Sep              |
#    | 16-18TRN2425              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TR]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 20+ Childcare                           | Adult Skills 20+ Childcare                                      | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 1411.24      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100928                   | 2372016           | Aug              |
#    | 16-18TRN2425              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TR]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 20+ Childcare                           | Adult Skills 20+ Childcare                                      | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 699.93       | 0             |              | Yes                | 0.00           | 0.00             | 2111.17               | 0.00           | 2111.17         |             | No            |                   |        |                   | 100928                   | 2372016           | Sep              |
#    | 16-18TRN2425              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TR]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Administration Expenditure              | Adult Skills Administration Expenditure                         | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 1469.21      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100930                   | 2372016           | Aug              |
#    | 16-18TRN2425              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TR]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Administration Expenditure              | Adult Skills Administration Expenditure                         | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 1604.57      | 0             |              | Yes                | 0.00           | 0.00             | 3073.78               | 0.00           | 3073.78         |             | No            |                   |        |                   | 100930                   | 2372016           | Sep              |
#    | 16-18TRN2425              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TR]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills COVID-19 Response (ICT)                 | Adult Skills COVID-19 Response (ICT)                            | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 1163.17      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100931                   | 2372016           | Aug              |
#    | 16-18TRN2425              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TR]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills COVID-19 Response (ICT)                 | Adult Skills COVID-19 Response (ICT)                            | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 860.77       | 0             |              | Yes                | 0.00           | 0.00             | 2023.94               | 0.00           | 2023.94         |             | No            |                   |        |                   | 100931                   | 2372016           | Sep              |
#    | 16-18TRN2425              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TR]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Learning Support                        | Adult Skills Learning Support                                   | Adult Skills                                                    | 8                 | 2022            | 2022/23       |              | 0            | 514.81       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2372060                  | 2372016           | Aug              |
#    | 16-18TRN2425              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TR]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Learning Support                        | Adult Skills Learning Support                                   | Adult Skills                                                    | 9                 | 2022            | 2022/23       |              | 0            | 465.26       | 0             |              | Yes                | 0.00           | 0.00             | 980.07                | 0.00           | 980.07          |             | No            |                   |        |                   | 2372060                  | 2372016           | Sep              |
#    | 16-18TRN2425              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TR]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Programme Funding                       | Adult Skills Programme Funding                                  | Adult Skills                                                    | 8                 | 2022            | 2022/23       |              | 0            | 656.38       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2372010                  | 2372016           | Aug              |
#    | 16-18TRN2425              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TR]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Programme Funding                       | Adult Skills Programme Funding                                  | Adult Skills                                                    | 9                 | 2022            | 2022/23       |              | 0            | 2352.37      | 0             |              | Yes                | 0.00           | 0.00             | 3008.75               | 0.00           | 3008.75         |             | No            |                   |        |                   | 2372010                  | 2372016           | Sep              |
#    | 16-18TRN2425              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TR]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Residential Access Fund                 | Adult Skills Residential Access Fund                            | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 478.56       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100929                   | 2372016           | Aug              |
#    | 16-18TRN2425              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TR]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Residential Access Fund                 | Adult Skills Residential Access Fund                            | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 844.84       | 0             |              | Yes                | 0.00           | 0.00             | 1323.40               | 0.00           | 1323.40         |             | No            |                   |        |                   | 100929                   | 2372016           | Sep              |
#    #
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund 19+ Hardship                    | National Skills Fund 19+ Hardship                               | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 1274.11      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100937                   | 100944            | Aug              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund 19+ Hardship                    | National Skills Fund 19+ Hardship                               | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 631.06       | 0             |              | Yes                | 0.00           | 0.00             | 1905.17               | 0.00           | 1905.17         |             | No            |                   |        |                   | 100937                   | 100944            | Sep              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund 20+ Childcare                   | National Skills Fund 20+ Childcare                              | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 1790.98      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100938                   | 100944            | Aug              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund 20+ Childcare                   | National Skills Fund 20+ Childcare                              | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 938.44       | 0             |              | Yes                | 0.00           | 0.00             | 2729.42               | 0.00           | 2729.42         |             | No            |                   |        |                   | 100938                   | 100944            | Sep              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Administration Expenditure      | National Skills Fund Administration Expenditure                 | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 1977.7       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100940                   | 100944            | Aug              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Administration Expenditure      | National Skills Fund Administration Expenditure                 | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 1931.92      | 0             |              | Yes                | 0.00           | 0.00             | 3909.62               | 0.00           | 3909.62         |             | No            |                   |        |                   | 100940                   | 100944            | Sep              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund COVID-19 Response (ICT)         | National Skills Fund COVID-19 Response (ICT)                    | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 1956.7       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100941                   | 100944            | Aug              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund COVID-19 Response (ICT)         | National Skills Fund COVID-19 Response (ICT)                    | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 2158.27      | 0             |              | Yes                | 0.00           | 0.00             | 4114.97               | 0.00           | 4114.97         |             | No            |                   |        |                   | 100941                   | 100944            | Sep              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Learning Support                | National Skills Fund Learning Support                           | National Skills Fund Total Funding                              | 8                 | 2022            | 2022/23       |              | 0            | 627.27       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100943                   | 100944            | Aug              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Learning Support                | National Skills Fund Learning Support                           | National Skills Fund Total Funding                              | 9                 | 2022            | 2022/23       |              | 0            | 855.21       | 0             |              | Yes                | 0.00           | 0.00             | 1482.48               | 0.00           | 1482.48         |             | No            |                   |        |                   | 100943                   | 100944            | Sep              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Programme Funding               | National Skills Fund Programme Funding                          | National Skills Fund Total Funding                              | 8                 | 2022            | 2022/23       |              | 0            | 1951         | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100942                   | 100944            | Aug              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Programme Funding               | National Skills Fund Programme Funding                          | National Skills Fund Total Funding                              | 9                 | 2022            | 2022/23       |              | 0            | 804.17       | 0             |              | Yes                | 0.00           | 0.00             | 2755.17               | 0.00           | 2755.17         |             | No            |                   |        |                   | 100942                   | 100944            | Sep              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Residential Access Fund         | National Skills Fund Residential Access Fund                    | National Skills Fund Learner Support                            | 8                 | 2022            | 2022/23       |              | 0            | 615.15       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100939                   | 100944            | Aug              |
#    | AEB2023-NSF2324             | 10018024 | 10018024 Co Ltd             |               |                             | NSF23-0024           | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | National Skills Fund Residential Access Fund         | National Skills Fund Residential Access Fund                    | National Skills Fund Learner Support                            | 9                 | 2022            | 2022/23       |              | 0            | 995.84       | 0             |              | Yes                | 0.00           | 0.00             | 1610.99               | 0.00           | 1610.99         |             | No            |                   |        |                   | 100939                   | 100944            | Sep              |
#    #
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 1 Learning Support     | Short Term Funding Initiative 1 Learning Support                | Short Term Funding Initiative 1                                 | 8                 | 2022            | 2022/23       |              | 0            | 1921.44      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374010                  | 2374010           | Aug              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 1 Learning Support     | Short Term Funding Initiative 1 Learning Support                | Short Term Funding Initiative 1                                 | 9                 | 2022            | 2022/23       |              | 0            | 3053.34      | 0             |              | Yes                | 0.00           | 0.00             | 4974.78               | 0.00           | 4974.78         |             | No            |                   |        |                   | 2374010                  | 2374010           | Sep              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 1 Programme Funding    | Short Term Funding Initiative 1 Programme Funding               | Short Term Funding Initiative 1                                 | 8                 | 2022            | 2022/23       |              | 0            | 3062.68      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374010                  | 2374010           | Aug              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 1 Programme Funding    | Short Term Funding Initiative 1 Programme Funding               | Short Term Funding Initiative 1                                 | 9                 | 2022            | 2022/23       |              | 0            | 2288.45      | 0             |              | Yes                | 0.00           | 0.00             | 5351.13               | 0.00           | 5351.13         |             | No            |                   |        |                   | 2374010                  | 2374010           | Sep              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 2 Learning Support     | Short Term Funding Initiative 2 Learning Support                | Short Term Funding Initiative 2                                 | 8                 | 2022            | 2022/23       |              | 0            | 1974.73      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374020                  | 2374020           | Aug              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 2 Learning Support     | Short Term Funding Initiative 2 Learning Support                | Short Term Funding Initiative 2                                 | 9                 | 2022            | 2022/23       |              | 0            | 2277.92      | 0             |              | Yes                | 0.00           | 0.00             | 4252.65               | 0.00           | 4252.65         |             | No            |                   |        |                   | 2374020                  | 2374020           | Sep              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 2 Programme Funding    | Short Term Funding Initiative 2 Programme Funding               | Short Term Funding Initiative 2                                 | 8                 | 2022            | 2022/23       |              | 0            | 3923.76      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374020                  | 2374020           | Aug              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 2 Programme Funding    | Short Term Funding Initiative 2 Programme Funding               | Short Term Funding Initiative 2                                 | 9                 | 2022            | 2022/23       |              | 0            | 2450.38      | 0             |              | Yes                | 0.00           | 0.00             | 6374.14               | 0.00           | 6374.14         |             | No            |                   |        |                   | 2374020                  | 2374020           | Sep              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 3 Learning Support     | Short Term Funding Initiative 3 Learning Support                | Short Term Funding Initiative 3                                 | 8                 | 2022            | 2022/23       |              | 0            | 3299.57      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374030                  | 2374030           | Aug              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 3 Learning Support     | Short Term Funding Initiative 3 Learning Support                | Short Term Funding Initiative 3                                 | 9                 | 2022            | 2022/23       |              | 0            | 2873.23      | 0             |              | Yes                | 0.00           | 0.00             | 6172.80               | 0.00           | 6172.80         |             | No            |                   |        |                   | 2374030                  | 2374030           | Sep              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 3 Programme Funding    | Short Term Funding Initiative 3 Programme Funding               | Short Term Funding Initiative 3                                 | 8                 | 2022            | 2022/23       |              | 0            | 2866.75      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374030                  | 2374030           | Aug              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 3 Programme Funding    | Short Term Funding Initiative 3 Programme Funding               | Short Term Funding Initiative 3                                 | 9                 | 2022            | 2022/23       |              | 0            | 2758.03      | 0             |              | Yes                | 0.00           | 0.00             | 5624.78               | 0.00           | 5624.78         |             | No            |                   |        |                   | 2374030                  | 2374030           | Sep              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 4 Learning Support     | Short Term Funding Initiative 4 Learning Support                | Short Term Funding Initiative 4                                 | 8                 | 2022            | 2022/23       |              | 0            | 4679.3       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374040                  | 2374040           | Aug              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 4 Learning Support     | Short Term Funding Initiative 4 Learning Support                | Short Term Funding Initiative 4                                 | 9                 | 2022            | 2022/23       |              | 0            | 2147.47      | 0             |              | Yes                | 0.00           | 0.00             | 6826.77               | 0.00           | 6826.77         |             | No            |                   |        |                   | 2374040                  | 2374040           | Sep              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 4 Programme Funding    | Short Term Funding Initiative 4 Programme Funding               | Short Term Funding Initiative 4                                 | 8                 | 2022            | 2022/23       |              | 0            | 1543.3       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2374040                  | 2374040           | Aug              |
#    | AEB2023-STFI2324                | 10018024 | 10018024 Co Ltd             |               |                             | STFI23-0024          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Short Term Funding Initiative 4 Programme Funding    | Short Term Funding Initiative 4 Programme Funding               | Short Term Funding Initiative 4                                 | 9                 | 2022            | 2022/23       |              | 0            | 3429.78      | 0             |              | Yes                | 0.00           | 0.00             | 4973.08               | 0.00           | 4973.08         |             | No            |                   |        |                   | 2374040                  | 2374040           | Sep              |
#

#
#    # Part 7a: Payment Batch for 16-18TRN2425
#
#    # Change the date
#    Given the override date is '09/10/2023 22:05'
#
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod '16-18TRN2425' AccountingPaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | [AllocRef_16TR]          | 202309 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | 16-18TRN2425	             | 202309               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | 16-18TRN2425             	 | 202309               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod '16-18TRN2425' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S025_16TR.xml'
#
#    ## Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    #And   the Payment feed xml for FundingStreamPeriod '16-18TRN2425' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' includes the following values
#    #| FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_16TR]  | 3008.75         | RECONCILIATION   | AEB Other Learning                 | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372010    |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_16TR]  | 980.07          | RECONCILIATION   | AEB OthLearning LngS               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372060    |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_16TR]  | 2567.98         | RECONCILIATION   | AdltSkll19+Hardship                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100927     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_16TR]  | 2111.17         | RECONCILIATION   | AdltSkll20+Childcare               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100928     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_16TR]  | 1323.40         | RECONCILIATION   | AdltSkllRsdntlAccess               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100929     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_16TR]  | 3073.78         | RECONCILIATION   | AdltSkllAdminExp                   | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100930     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_16TR]  | 2023.94         | RECONCILIATION   | AdltSkllC19Response                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100931     |
#    ##                                                                                                    £15089.09
#
#

#    
#    # Part 7c: Payment Batch for ALLBC2425
#
#    # Change the date
#    Given the override date is '02/10/2024 22:05'
#
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod 'ALLBC2425' AccountingPaymentPeriod '202407' CensusEndDate '02/10/2024' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | [AllocRef_ALLC]          | 202410 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | ALLBC2425		             | 202410               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | ALLBC2425		         	 | 202410               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'ALLBC2425' PaymentPeriod '202407' CensusEndDate '02/10/2024' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S053_ALLC.xml'
#
#    ## Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    #And   the Payment feed xml for FundingStreamPeriod 'ALLBC2425' PaymentPeriod '202407' CensusEndDate '02/10/2024' and LinkCodeSuffix 'A' includes the following values
#    #| FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ALLB]  | 3008.75         | RECONCILIATION   | AEB Other Learning                 | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372010    |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ALLB]  | 980.07          | RECONCILIATION   | AEB OthLearning LngS               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372060    |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ALLB]  | 2567.98         | RECONCILIATION   | AdltSkll19+Hardship                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100927     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ALLB]  | 2111.17         | RECONCILIATION   | AdltSkll20+Childcare               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100928     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ALLB]  | 1323.40         | RECONCILIATION   | AdltSkllRsdntlAccess               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100929     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ALLB]  | 3073.78         | RECONCILIATION   | AdltSkllAdminExp                   | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100930     |
#    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ALLB]  | 2023.94         | RECONCILIATION   | AdltSkllC19Response                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100931     |
#    ##                                                                                                    £15089.09



    

    # Part 7d: Payment Batch for APPS2425

    # Change the date
    Given the override date is '08/10/2024 22:05'


    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'APPS2425' AccountingPaymentPeriod '202406' CensusEndDate '08/10/2024' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_APPS]          | 202409 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | APPS2425		             | 202409               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | APPS2425		         	 | 202409               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'APPS2425' PaymentPeriod '202406' CensusEndDate '08/10/2024' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S053_APPS.xml'

    ## Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    #And   the Payment feed xml for FundingStreamPeriod 'APPS2425' PaymentPeriod '202306' CensusEndDate '08/10/2023' and LinkCodeSuffix 'A' includes the following values
    #| FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_APPS]  | 3008.75         | RECONCILIATION   | AEB Other Learning                 | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372010    |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_APPS]  | 980.07          | RECONCILIATION   | AEB OthLearning LngS               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372060    |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_APPS]  | 2567.98         | RECONCILIATION   | AdltSkll19+Hardship                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100927     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_APPS]  | 2111.17         | RECONCILIATION   | AdltSkll20+Childcare               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100928     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_APPS]  | 1323.40         | RECONCILIATION   | AdltSkllRsdntlAccess               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100929     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_APPS]  | 3073.78         | RECONCILIATION   | AdltSkllAdminExp                   | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100930     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_APPS]  | 2023.94         | RECONCILIATION   | AdltSkllC19Response                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100931     |
    ##                                                                                                    £15089.09




        # Consolidated payment summary report

   
    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    Given the override date is '10/10/2024'

    Given there are no files prefixed '2024-10 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
   
    When  a Consolidated Payment Summary Report is created in Sharepoint for '10/10/2024'
    # Check the above report manually


        


    
#    
#    # Part 2: Bulk import a 24/25 contract 
#    
#    # Change the date
#    Given the override date is '13/10/2024'
#
#    # Bulk file 
#    And   there are no files prefixed '10018053' in the Sharepoint 'EDSK-2425-Input-Appendices' folder
#    And   there are no files prefixed 'EDSK AY 2425 13102024105948 v2_S053' in the Sharepoint 'Input' folder
#    And   there are no files prefixed 'EDSK AY 2425 13102024105948 v2_S053' in the Sharepoint 'Processing' folder
#    And   there are no files prefixed 'EDSK AY 2425 13102024105948 v2_S053' in the Sharepoint 'Processed' folder
#    And   there are no files prefixed 'EDSK AY 2425 13102024105948 v2_S053' in the Sharepoint 'Reports' folder
#    And   spreadsheet 'EDSK AY 2425 13102024105948 v2_S053.xlsx' exists in the Datafiles folder and UKPRN '10018053' is present in cell 'A2' of the Contract tab
#    #When  the file is copied to the Sharepoint 'Input' folder 
#    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
#    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
#    And   the syntax report includes the phrase 'Success'
#    And   a results report should exist in the Sharepoint Reports folder
#    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
#
#
#
#    
#     # Part 3: Check docs
# 
#     # Change the date
#     Given the override date is '14/10/2024'
#
#    # Retrieve parameters
#   #When  I retrieve the latest EFA contract details from CRM for provider '10018053' for FundingType 'EDSK' and period '2425' and Delivery Organisation '00000000'
#    When  I retrieve the latest contract details from CRM for provider '10018053' for FundingType 'EDSK' and period '2425'
#
#
#
# 
#     # Retrieve parameters
#    #When  I retrieve the latest EFA contract details from CRM for provider '10018052' for FundingType 'ASF2023' and period '2425' and Delivery Organisation '00000000'
#     When  I retrieve the latest contract details from CRM for provider '10018052' for FundingType 'ASF2023' and period '2425'
#
#    # Check the contents of the Appendices
#    Then  the file named '10018024_AEBP23-0024_v2.pdf' in Sharepoint location 'ASF2023-2425-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING
#    Organisation Name: 10018052 Co Ltd UKPRN: 10018052
#    Master Contract Number: ESFA-0052
#    Allocation
#    1 August 2023 to 31 July 2024 Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 Total
#    ESFA AEB - Adult Skills (procured from Aug 2023) ASFA23-0052 £74,278 £35,456 £109,734
#    of which Learner Support £25,394 £21,024 £46,418
#    ESFA AEB - National Skills Fund (procured from Aug 2023) ASFJ23-0052 £54,031 £34,846 £88,877
#    of which Free Courses for Jobs £25,884 £15,183 £41,067
#    of which Learner Support £28,147 £19,663 £47,810
#    ESFA AEB - Short Term Funding Initiatives (procured from
#    ASFS23-0052 £84,398 £42,871 £127,269
#    Aug 2023)
#    of which Short Term Funding Initiative 1 £37,258 £19,663 £56,921
#    of which Short Term Funding Initiative 2 £17,435 £6,457 £23,892
#    of which Short Term Funding Initiative 3 £14,371 £8,135 £22,506
#    of which Short Term Funding Initiative 4 £15,334 £8,616 £23,950
#    Total: £325,880
#    Total Funding for this contract: £325,880
#    Summary of Funding – Page 1
#    Agreement Type Contract for Services
#    st st
#    Funding Period 1 August 2023 to 31 July 2024
#    Between the Secretary of State for Education
#    And  10018052 Co Ltd
#    Funding for ESFA Adult Education Budget (Contract for Services)
#    Master Contract Number ESFA-0052
#    ACCEPTANCE BY THE CONTRACTOR
#    BY ACCEPTING THIS CONTRACT VIA THE MANAGE YOUR EDUCATION & SKILLS
#    FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF THE
#    CONTRACTOR REPRESENTS AND WARRANTS THAT THE CONTRACTOR HAS READ
#    AND UNDERSTOOD THIS CONTRACT, THE CONTRACTOR AGREES TO BE BOUND BY
#    THIS CONTRACT AND THAT HE/SHE IS DULY AUTHORISED TO ACCEPT THIS
#    CONTRACT AND LEGALLY BIND THE CONTRACTOR.
#    SIGNED FOR AND ON BEHALF OF THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    ESFA Adult Education Budget (Contract for Services) Version 1 (July 2023) – Page 1
#    This Contract is made on the date the Contract is digitally signed by the Contractor on
#    the Manage Your Education & Skills Funding Service between:
#    10018052 Co Ltd
#    THE SECRETARY OF STATE FOR
#    345 The Meadway
#    EDUCATION
#    Tilehurst
#    DEPARTMENT FOR EDUCATION
#    Reading
#    20 GREAT SMITH STREET
#    AND
#    Berkshire
#    LONDON
#    RG30 4NU
#    SW1P 3BT
#    Company No: AA018052
#    Hereinafter called  Hereinafter called the
#    “Department”
#    the “Contractor”
#    ESFA Adult Education Budget (Contract for Services) Version 1 (July 2023) – Page 2
#    SCHEDULE 2
#    Funding Agreement – ESFA-Funded Adult Education Budget - Adult Skills (procured from Aug 2023)
#    Provider: 10018052 Co Ltd UKPRN: 10018052
#    Master Contract Number: ESFA-0052 Start Date: 01/08/2024 End Date: 31/07/2025
#    Contract Ref: ASFA23-0052
#    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
#    ESFA AEB - Adult Skills £109,734 £14,200 £6,250 £6,419 £11,750 £7,439 £8,692 £8,660 £10,868 £12,195 £10,326 £7,980 £4,955
#    of which Learner Support £46,418 £5,211 £678 £2,599 £4,787 £1,952 £4,617 £2,462 £3,088 £7,048 £5,232 £4,839 £3,905
#    Total Funding £109,734 £14,200 £6,250 £6,419 £11,750 £7,439 £8,692 £8,660 £10,868 £12,195 £10,326 £7,980 £4,955
#    Schedule 2 – Funding Agreement ASFA23-0052 – Page 1 Ref (for internal use only):  ASFP23-0052 v2
#    SCHEDULE 2
#    Funding Agreement – ESFA-Funded Adult Education Budget - National Skills Fund (procured from Aug 2023)
#    Provider: 10018052 Co Ltd UKPRN: 10018052
#    Master Contract Number: ESFA-0052 Start Date: 01/08/2024 End Date: 31/07/2025
#    Contract Ref: ASFJ23-0052
#    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
#    ESFA AEB - National Skills Fund Free Courses for £88,877 £6,374 £8,287 £3,021 £10,867 £9,072 £4,890 £7,374 £4,146 £3,765 £12,363 £12,533 £6,185
#    Jobs
#    of which Free Courses for Jobs £41,067 £5,587 £5,130 £661 £4,006 £7,763 £714 £120 £1,903 £2,392 £4,653 £7,933 £205
#    of which Learner Support £47,810 £787 £3,157 £2,360 £6,861 £1,309 £4,176 £7,254 £2,243 £1,373 £7,710 £4,600 £5,980
#    Total Funding £88,877 £6,374 £8,287 £3,021 £10,867 £9,072 £4,890 £7,374 £4,146 £3,765 £12,363 £12,533 £6,185
#    Schedule 2 – Funding Agreement ASFJ23-0052 – Page 1 Ref (for internal use only):  ASFP23-0052 v2
#    SCHEDULE 2
#    Funding Agreement – ESFA-Funded Adult Education Budget - Short Term Funding Initiatives (procured from Aug 2023)
#    Provider: 10018052 Co Ltd UKPRN: 10018052
#    Master Contract Number: ESFA-0052 Start Date: 01/08/2024 End Date: 31/07/2025
#    Contract Ref: ASFS23-0052
#    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
#    ESFA AEB - Short Term Funding Initiative 1 £56,921 £9,898 £3,157 £2,360 £6,861 £1,309 £4,176 £7,254 £2,243 £1,373 £7,710 £4,600 £5,980
#    ESFA AEB - Short Term Funding Initiative 2 £23,892 £1,538 £1,706 £3,168 £1,498 £1,824 £2,812 £3,549 £1,340 £2,299 £1,389 £416 £2,353
#    ESFA AEB - Short Term Funding Initiative 3 £22,506 £2,038 £1,950 £250 £2,631 £171 £2,869 £3,160 £1,302 £3,175 £275 £3,541 £1,144
#    ESFA AEB - Short Term Funding Initiative 4 £23,950 £1,503 £3,124 £979 £2,728 £2,165 £1,888 £2,719 £228 £1,281 £2,807 £1,928 £2,600
#    Total Funding £127,269 £14,977 £9,937 £6,757 £13,718 £5,469 £11,745 £16,682 £5,113 £8,128 £12,181 £10,485 £12,077
#    Schedule 2 – Funding Agreement ASFS23-0052 – Page 1 Ref (for internal use only):  ASFP23-0052 v2
#    ESFA Adult Education Budget (Contract for Services) Schedule 3 Version 1 (July 2023) – Page 1
#    ESFA Adult Education Budget (Contract for Services) Schedule 13 Version 1 (July 2023) – Page 2
#    """
#
#    ## Insert/Update details into the ContractManagement.CreatedContract table (J104)
#    ##   Note: Documents are created using the system date. The following step 'corrects' this
#    #Given the following document creation details exist in the ContractManagement.CreatedContract table
#    #| ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
#    #| ASFP23-0052    | 2                     | 0                        | 2024-12-02 12:06:22.000 |
#
#
#    #    # Copy\Save a named Sharepoint file to a named folder\filename
#    And   Sharepoint file '10018053_[ContractNo]_v2.pdf' in 'EDSK-2425-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018053_[ContractNo]_v2.pdf'
#
#
#    
#    # Create and check the contents of the CDA report
#   
#    # Change the date
#    Given the override date is '11/10/2024'
#    
#    # Check the contents of the CDA report
#    And   there is no CDA report named 'CDA Last Approved Version S053.csv'
#
#    And   the following ADF Pipeline run
#
#    #And   the following contracts are in the replicated CRM database
#    #| ContractNumber  | ContractVersionNumber |
#    #| [ContractNo]    | 1                    |
#
#   #When  the following CDA reports are run
#    When  the following CDA report is run
#    | FundingStreamPeriod						    | Version               | Suffix |
#    | APPS2425        				 				| Last Approved         | S053   |
#
#    Then  a report named 'CDA Last Approved Version S053.csv' is created
#
#
#    
#    # Tidy Up
#   Given the override date is reset