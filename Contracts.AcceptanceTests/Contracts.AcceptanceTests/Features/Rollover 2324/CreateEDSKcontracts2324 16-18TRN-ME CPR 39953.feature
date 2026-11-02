Feature: CreateEDSKcontracts2324 16-18TRN-ME CPR 39953

@AcceptanceTest @Withdrawn20251024
@Long2Run @Long2Run123
Scenario: S036 Bulk load a new draft EDSK2324 contract with several FSPs. Publish and approve. Check docs, CRM PaaS and Feed
    Given there are no allocations marked as Under Termination for UKPRN '10018036' 
    And   there are no terminated or closed allocations for UKPRN '10018036' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018036' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018036' 
 
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
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018036' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN-ME2324   |



#    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
#    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018036'
#
#    # Set the 'base' timestamp for each of the 22\23 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
#    And   the following document templates have Upload timestamps as indicated 
#    | DocumentTemplateName                              | UploadTimestamp         | 
#    | SOF_EDSK_2022-08-01.docx                          | 2023-04-01 12:00:00.000 | 
#    #  
#    | EDSK2223_TAC_CFS_ITP_2022-08-01.docx              | 2023-04-01 12:00:00.000 | 
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
    Given there is no Organisation data in CRM for UKPRN '10018036' 
    And   there is no caseload advisor for UKPRN '10018036' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018036 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018036' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018036 Co Ltd' with UKPRN '10018036' and OrgId 'ORG0018036' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018036 | 118036 | 10018036 Co Ltd | 0              | In Administration     | Yes           | AA018036      | ?             | 9 Ronaldshaw Park      | Ayr                    | ?                      | ?                      | ?                      | ?                      | KA7 2TJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018036 |



    # Change the date
    Given the override date is '16/07/2023'

    # Bulk file for new [Conditions of Funding (Grant) (College)] contract
    And   there are no files prefixed '10018036' in the Sharepoint 'EDSK-2324-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2324 15072023105948 v1_S036' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2324 15072023105948 v1_S036' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2324 15072023105948 v1_S036' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2324 15072023105948 v1_S036' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2324 15072023105948 v1_S036.xlsx' exists in the Datafiles folder and UKPRN '10018036' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    Then wait '20' seconds
#
#    # Retrieve parameters
#When  I retrieve the latest EFA contract details from CRM for provider '10018036' for FundingType 'EDSK' and period '2324' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10018036' for FundingType 'EDSK' and period '2324'
#
    # Check the contents of the Appendices
    Then  the file named '10018036_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2324-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2023/24
    Organisation Name: 10018036 Co Ltd UKPRN: 10018036
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 23 - Mar 24 Apr 24 - Jul 24 2023/24 Total
    16 to 18 Traineeships [AllocRef_16TM] £55,250 £22,694 £77,944
    Total Funding for this contract: £77,944
    Summary of Funding – Page 1
    Agreement Type Contract for Services
    st st
    Funding Period 1 August 2023 to 31 July 2024
    Between the Secretary of State for Education
    And 10018036 Co Ltd
    Funding for 16 to 18 Traineeships
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
    EDSK Version 3 (September 2023) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10018036 Co Ltd THE SECRETARY OF STATE FOR
    9 Ronaldshaw Park EDUCATION
    Ayr DEPARTMENT FOR EDUCATION
    KA7 2TJ AND 20 GREAT SMITH STREET
    LONDON
    SW1P 3BT
    Company No: AA018036
    Hereinafter called Hereinafter called
    the Contractor the Department
    EDSK Version 3 (September 2023) Page 2
    EDSK Version 3 (September 2023) Page 77


    SCHEDULE 1: SPECIFICATION & MONITORING
    16-18-YEAR-OLD TRAINEESHIPS (MARKET ENTRY) SPECIFICATION
    EDSK Schedule 1 – 16 to 18 Traineeships (Market Entry) Version 1 (July 2023) – Page 1
    EDSK Schedule 1 – 16 to 18 Traineeships (Market Entry) Version 1 (July 2023) – Page 6


    SCHEDULE 2: PAYMENT
    16-18-YEAR-OLD TRAINEESHIPS (MARKET ENTRY)
    EDSK Schedule 2 – 16 to 18 Traineeships (Market Entry) Version 1 (July 2023) – Page 1
    16 TO 18 TRAINEESHIPS
    Funding Agreement – 16 to 18 Traineeships
    Provider: 10018036 Co Ltd UKPRN: 10018036
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2023 End Date: 31/07/2024
    Contract Ref: [AllocRef_16TM]
    Cash (£) Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024 Apr 2024 May 2024 Jun 2024 Jul 2024
    16 to 18 Traineeships Programme Funding £32,858 £2,024 £272 £3,414 £1,938 £527 £2,650 £4,231 £1,598 £1,546 £7,543 £5,452 £1,663
    16 to 18 Traineeships Bursary Funding £45,086 £5,080 £7,002 £1,238 £6,354 £1,068 £6,864 £7,491 £3,499 £1,683 £1,291 £357 £3,159
    Total Funding £77,944 £7,104 £7,274 £4,652 £8,292 £1,595 £9,514 £11,722 £5,097 £3,229 £8,834 £5,809 £4,822
    16 to 18 Traineeships – Funding Agreement [AllocRef_16TM] – Page 1 Ref (for internal use only):  [ContractNo] v1

    EDSK Schedule 9 Version 2 (July 2023) – Page 5
    """


    # Copy\Save a named Sharepoint file to a named folder\filename
    Then  Sharepoint file '10018036_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018036_[ContractNo]_v1.pdf'

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-07-16 12:06:22.000 |

##    # Copy\Save a named Sharepoint file to a named folder\filename
#    And   Sharepoint file '10018036_[ContractNo]_v1.pdf' in 'EDSK-2324-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018036_[ContractNo]_v1.pdf'


    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10018036'
    | Task                      | Description                                        | Regarding       | Owner                     | Assigned Team    | State      | Status        |
    | Initiate Document Merge   | 10018036 - 10018036 Co Ltd Awaiting documentation  | [AllocRef_16TM] | Document Management Team  | ?                | Open       | Not Started   |


    # Publish the contract

    # Change the date 
    Given the override date is '20/07/2023'

 #  # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider'
 #  And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
 #  or
    # Update the contract in CRM from 'Awaiting Documentation' to 'Published to Provider' while also generating the event which publishes to the feed
    And   a file with filename '10018036_[ContractNo]_v1.pdf' is created in 'EDSK-2324-Output-Merged Document'
    And   the contract sub-status is updated to 'Document Transfer in Progress' on the latest version of contract '[ContractNo]'
    And   the latest version of contract '[ContractNo]' and master '[MasterContractNo]' is published and on the [ContractManagement].[AtomFeedItem] table

    # Check the CONTRACT version, status and dates in CRM {F6}  This is essentially just a 'wait' before moving on.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018036 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider   | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
    | 10018036 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/08/2023        | 31/07/2024      | ?             |




    # Change the date
    Given the override date is '29/07/2023'

    ## Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    #And the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

#    # Check the CONTRACT version, status and dates in CRM.
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10018036 | [ContractNo]       | 1                     | 1                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2023        | 31/07/2024      | ?             |
#    | 10018036 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2023        | 31/07/2024      | ?             |
#



#
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
#    Then  the Legal Contract CM feed contains the following '5' deliverables
#    | UKPRN    | ContractNumber | ContractVersion | AllocationRef    | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                | DeliverableDescription      |
#    | 10018036 | [ContractNo]   | 1               | [AllocRef_16TM]  | 31              | 0                     | 7545.00      | 0             | 0        | 16-19 Free Meals                               | ?                           |
#    | 10018036 | [ContractNo]   | 1               | [AllocRef_16ED]  | 22              | 0                     | 25383.00     | 0             | 0        | 16-19 High Needs Element 2                     | ?                           |
#    | 10018036 | [ContractNo]   | 1               | [AllocRef_16ED]  | 125             | 0                     | 22750.00     | 0             | 0        | Teacher's Pension Scheme 1619                  | ?                           |
#    | 10018036 | [ContractNo]   | 1               | [AllocRef_16ED]  | 51              | 0                     | 21319.00     | 0             | 0        | Alternative Completions - Sporting Excellence  | ?                           |
#    | 10018036 | [ContractNo]   | 1               | [AllocRef_16ED]  | 143             | 0                     | 8298.00      | 0             | 0        | 16-19 Tuition Fund                             | ?                           |
#

    ## Check the deliverable count in CRM includes all the monitoring deliverables
    #And   there are '120' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

  #  # Check that the CRM subnominals have been created before moving on
   # And   CRM subnominals have been created for the following allocations
   # | AllocationRef    | Subnominal Code  | Period | Payment Type   |
   ##| [AllocRef_ALLF]  | 2372010          | Jul-24 | Reconciliation |
   # | [AllocRef_ALLB]  | 2303800          | Jul-24 | Reconciliation |
   # | [AllocRef_APPS]  | 2240100          | Jul-24 | Reconciliation |
   # | [AllocRef_16TM]  | 2201300          | Jul-24 | Reconciliation |
   # | [AllocRef_16TM]  | 2201350          | Jul-24 | Reconciliation |



    # Part 5: Add Actuals for 23/24 then check CRM

    # Add actuals to the contract for 16-18TRN-ME2324, 16-18TRN-ME2324, ALLB2324, ALLF2324, APPS2324

    # Change the date
    Given the override date is '04/10/2023'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018036'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2023
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202308 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 2               | 0            | 656.38      |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202308 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 3               | 0            | 514.81      |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202309 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 2               | 0            | 2352.37     |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202309 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 3               | 0            | 465.26      |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202310 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 2               | 0            | 2029.73     |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202310 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 3               | 0            | 1578.92     |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202311 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 2               | 0            | 2456.58     |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202311 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 3               | 0            | 647.63      |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202312 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 2               | 0            | 1427.78     |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202312 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 3               | 0            | 1516.24     |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202401 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 2               | 0            | 903.61      |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202401 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 3               | 0            | 1218.05     |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202402 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 2               | 0            | 701.10      |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202402 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 3               | 0            | 533.70      |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202403 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 2               | 0            | 2227.66     |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202403 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 3               | 0            | 829.39      |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202404 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 2               | 0            | 1417.38     |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202404 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 3               | 0            | 1918.11     |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202405 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 2               | 0            | 1589.44     |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202405 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 3               | 0            | 1711.23     |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202406 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 2               | 0            | 1989.29     |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202406 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 3               | 0            | 702.52      |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202407 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 2               | 0            | 750.74      |
    | ILR2324        | R02                  | ORG0018036     | CM             | 202407 | 16-18TRN-ME2324            | [AllocRef_16TM]          | ?          | 3               | 0            | 596.14      |

    Then wait '30' seconds


    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    ##    # Check MonitoringDeliverables.HeldReportedActualGroup (Only used for APPS contracts) Is the data showing as unprocessed ?
    #Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS2324' OrgId 'ORG0018036' and Collection 'R02' marked as unprocessed
    #And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS2324' OrgId 'ORG0018036' and Collection 'APPS77' marked as unprocessed
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
#    | [ContractNo]   | [AllocRef_16TM]    | 1               | 106975.00 | 11441.00 | 6250.00  | 6419.00  | 11750.00 | 7439.00  | 8692.00  | 8660.00  | 10868.00 | 12195.00 | 10326.00 | 7980.00  | 4955.00  | 
#    | [ContractNo]   | [AllocRef_16TM]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TM]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TM]    | 4               | 60557.00  | 6230.00  | 5572.00  | 3820.00  | 6963.00  | 5487.00  | 4075.00  | 6198.00  | 7780.00  | 5147.00  | 5094.00  | 3141.00  | 1050.00  | 
#    | [ContractNo]   | [AllocRef_16TM]    | 5               | 46418.00  | 5211.00  | 678.00   | 2599.00  | 4787.00  | 1952.00  | 4617.00  | 2462.00  | 3088.00  | 7048.00  | 5232.00  | 4839.00  | 3905.00  | 
#    | [ContractNo]   | [AllocRef_16TM]    | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TM]    | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TM]    | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TM]    | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TM]    | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
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
    | ContractNumber | AllocationRef 	  | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   |
    | [ContractNo]   | [AllocRef_16TM]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_16TM]    | 2               | 3008.75   | 656.38   | 2352.37  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_16TM]    | 3               | 980.07    | 514.81   | 465.26   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 



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
##    | [ContractNo]   | [AllocRef_16TM]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TM]    | 2               | 3008.75   | 0.00     | 3008.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TM]    | 3               | 980.07    | 0.00     | 980.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TM]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TM]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TM]    | 6               | 2567.98   | 0.00     | 2567.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TM]    | 7               | 2111.17   | 0.00     | 2111.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TM]    | 8               | 1323.40   | 0.00     | 1323.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TM]    | 9               | 3073.78   | 0.00     | 3073.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
##    | [ContractNo]   | [AllocRef_16TM]    | 10              | 2023.94   | 0.00     | 2023.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
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


#
#    # Part 6: Create and check the contents of the CDA report
#   
#    # Change the date
#    Given the override date is '05/10/2023'
#    
#    # Check the contents of the CDA report
#    And   there is no CDA report named 'CDA Last Approved Version S036.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | [ContractNo]    | 1                     |
#
#   #When  the following CDA reports are run
#    When  the following CDA report is run
#    | FundingStreamPeriod									             | Version               | Suffix |
#    | 16-18TRN-ME2324, , ALLB2324, ALLF2324, APPS2324        | Last Approved         | S036   |
#
#    Then  a report named 'CDA Last Approved Version S036.csv' is created

    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | 16-18TRN-ME2324              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TM]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 19+ Hardship                            | Adult Skills 19+ Hardship                                       | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 564.11       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100927                   | 2372016           | Aug              |
#    | 16-18TRN-ME2324              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TM]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 19+ Hardship                            | Adult Skills 19+ Hardship                                       | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 2003.87      | 0             |              | Yes                | 0.00           | 0.00             | 2567.98               | 0.00           | 2567.98         |             | No            |                   |        |                   | 100927                   | 2372016           | Sep              |
#    | 16-18TRN-ME2324              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TM]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 20+ Childcare                           | Adult Skills 20+ Childcare                                      | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 1411.24      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100928                   | 2372016           | Aug              |
#    | 16-18TRN-ME2324              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TM]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills 20+ Childcare                           | Adult Skills 20+ Childcare                                      | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 699.93       | 0             |              | Yes                | 0.00           | 0.00             | 2111.17               | 0.00           | 2111.17         |             | No            |                   |        |                   | 100928                   | 2372016           | Sep              |
#    | 16-18TRN-ME2324              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TM]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Administration Expenditure              | Adult Skills Administration Expenditure                         | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 1469.21      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100930                   | 2372016           | Aug              |
#    | 16-18TRN-ME2324              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TM]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Administration Expenditure              | Adult Skills Administration Expenditure                         | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 1604.57      | 0             |              | Yes                | 0.00           | 0.00             | 3073.78               | 0.00           | 3073.78         |             | No            |                   |        |                   | 100930                   | 2372016           | Sep              |
#    | 16-18TRN-ME2324              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TM]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills COVID-19 Response (ICT)                 | Adult Skills COVID-19 Response (ICT)                            | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 1163.17      | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100931                   | 2372016           | Aug              |
#    | 16-18TRN-ME2324              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TM]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills COVID-19 Response (ICT)                 | Adult Skills COVID-19 Response (ICT)                            | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 860.77       | 0             |              | Yes                | 0.00           | 0.00             | 2023.94               | 0.00           | 2023.94         |             | No            |                   |        |                   | 100931                   | 2372016           | Sep              |
#    | 16-18TRN-ME2324              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TM]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Learning Support                        | Adult Skills Learning Support                                   | Adult Skills                                                    | 8                 | 2022            | 2022/23       |              | 0            | 514.81       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2372060                  | 2372016           | Aug              |
#    | 16-18TRN-ME2324              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TM]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Learning Support                        | Adult Skills Learning Support                                   | Adult Skills                                                    | 9                 | 2022            | 2022/23       |              | 0            | 465.26       | 0             |              | Yes                | 0.00           | 0.00             | 980.07                | 0.00           | 980.07          |             | No            |                   |        |                   | 2372060                  | 2372016           | Sep              |
#    | 16-18TRN-ME2324              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TM]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Programme Funding                       | Adult Skills Programme Funding                                  | Adult Skills                                                    | 8                 | 2022            | 2022/23       |              | 0            | 656.38       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 2372010                  | 2372016           | Aug              |
#    | 16-18TRN-ME2324              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TM]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Programme Funding                       | Adult Skills Programme Funding                                  | Adult Skills                                                    | 9                 | 2022            | 2022/23       |              | 0            | 2352.37      | 0             |              | Yes                | 0.00           | 0.00             | 3008.75               | 0.00           | 3008.75         |             | No            |                   |        |                   | 2372010                  | 2372016           | Sep              |
#    | 16-18TRN-ME2324              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TM]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Residential Access Fund                 | Adult Skills Residential Access Fund                            | Adult Skills Learner Support                                    | 8                 | 2022            | 2022/23       |              | 0            | 478.56       | 0             |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   | 100929                   | 2372016           | Aug              |
#    | 16-18TRN-ME2324              | 10018024 | 10018024 Co Ltd             |               |                             | [AllocRef_16TM]          | [ContractNo]   | ESFA-0024                | 01/08/2022                  | 31/07/2023                | 1                     | Approved       | Approved                | Adult Skills Residential Access Fund                 | Adult Skills Residential Access Fund                            | Adult Skills Learner Support                                    | 9                 | 2022            | 2022/23       |              | 0            | 844.84       | 0             |              | Yes                | 0.00           | 0.00             | 1323.40               | 0.00           | 1323.40         |             | No            |                   |        |                   | 100929                   | 2372016           | Sep              |
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


    # Part 7a: Payment Batch for 16-18TRN-ME2324

    # Change the date
    Given the override date is '09/10/2023 22:05'


    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '16-18TRN-ME2324' AccountingPaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_16TM]          | 202309 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | 16-18TRN-ME2324	         | 202309               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | 16-18TRN-ME2324            | 202309               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '16-18TRN-ME2324' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S036_16TM.xml'

    ## Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    #And   the Payment feed xml for FundingStreamPeriod '16-18TRN-ME2324' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' includes the following values
    #| FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_16TM]  | 3008.75         | RECONCILIATION   | AEB Other Learning                 | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372010    |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_16TM]  | 980.07          | RECONCILIATION   | AEB OthLearning LngS               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372060    |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_16TM]  | 2567.98         | RECONCILIATION   | AdltSkll19+Hardship                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100927     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_16TM]  | 2111.17         | RECONCILIATION   | AdltSkll20+Childcare               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100928     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_16TM]  | 1323.40         | RECONCILIATION   | AdltSkllRsdntlAccess               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100929     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_16TM]  | 3073.78         | RECONCILIATION   | AdltSkllAdminExp                   | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100930     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_16TM]  | 2023.94         | RECONCILIATION   | AdltSkllC19Response                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100931     |
    ##                                                                                                    £15089.09




    # Consolidated Payment Summary Report
   Given there are no files prefixed '2023-10 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
   
   When  a Consolidated Payment Summary Report is created in Sharepoint for '10/10/2023'
    # Check the above report manually
	
    
    # Tidy Up
   Given the override date is reset
   
   