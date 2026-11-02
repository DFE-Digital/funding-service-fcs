Feature: SB2023 new FSP 38400 41372

@AcceptanceTest @Complete
Scenario: S035 Create Skill Bootcamps to validate new contract 23/24 for SB as part of story 38400. Publish and approve. Check docs. Push actuals. Generate payments.

    Given there are no allocations marked as Under Termination for UKPRN '10018035' 
    And   there are no terminated or closed allocations for UKPRN '10018035' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018035' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018035' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018035' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP           |
    | SB2023        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018035'

    # Set the 'base' timestamp for each of the Bootcamps document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    Given the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_SB_2023-08-01.docx                          | 2023-07-21 12:00:00.000 | 
 
    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018035' 
    And   there is no caseload advisor for UKPRN '10018035' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018035 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018035' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018035 Co Ltd' with UKPRN '10018035' and OrgId 'ORG0018035' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018035 | 118035 | 10018035 Co Ltd | 0              | In Administration     | Yes           | AA018035      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018035 |





    # Change the date
    Given the override date is '01/08/2023'

    # Bulk file (UoP = R1C1)
    And   there are no files prefixed '10018035' in the Sharepoint 'SBD-2023-Input-Appendices' folder
    And   there are no files prefixed 'SBD SB 2023 24072023094413 v1_S035' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SBD SB 2023 24072023094413 v1_S035' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SBD SB 2023 24072023094413 v1_S035' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SBD SB 2023 24072023094413 v1_S035' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SBD SB 2023 24072023094413 v1_S035.xlsx' exists in the Datafiles folder and UKPRN '10018035' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018035' for FundingType 'SBD' and period '2023'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    Then  the file named '10018035_[ContractNo]_v1.pdf' in Sharepoint location 'SBD-2023-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10018035 Co Ltd UKPRN: 10018035
    Master Contract Number: [MasterContractNo] Start Date: 01/09/2023 End Date: 31/07/2026
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £2,800,000.00
    of which Web Essentials [AllocRef_SBD]-337 £1,000.00 350 £350,000.00
    of which Level 3 Diploma in Electrical Installations [AllocRef_SBD]-697 £1,000.00 350 £350,000.00
    of which Enhanced Dozer [AllocRef_SBD]-698 £1,000.00 350 £350,000.00
    of which New Entrant - Career in Plant [AllocRef_SBD]-699 £1,000.00 350 £350,000.00
    of which Enhanced 360 Excavator [AllocRef_SBD]-700 £1,000.00 350 £350,000.00
    of which Access into Higher Nuclear Skills [AllocRef_SBD]-701 £1,000.00 350 £350,000.00
    of which Skills Bootcamp for Creative Freelancers [AllocRef_SBD]-702 £1,000.00 350 £350,000.00
    of which Construction Operations in Groundworks [AllocRef_SBD]-703 £1,000.00 350 £350,000.00
    Total Funding for this contract: £2,800,000.00
   """  




    # There should not be a Funding Agreement
    And   the pdf file does not contain the following text
    """
    Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018035_[ContractNo]_v1.pdf' in 'SBD-2023-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018035_[ContractNo]_v1.pdf'

    
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
    | 10018035 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/09/2023        | 31/07/2026      | ?             |
    | 10018035 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/09/2023        | 31/07/2026      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-08-01 09:12:35.000 |
	


	
#    # Check ADP
#
#    # Check all activity has completed
#    When  there are no messages left in the system
#
#    # Check Planned data on the ADP feed for Aug-22
#    Then  the Allocation Delivery Monitoring Service atom feed contains the following Planned data
#    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume | 
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 72              | 202309 | 155550.00	  | 60            |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 115             | 202309 | 150150.00	  | 60            |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 189             | 202309 | 184230.00	  | 60            |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 238             | 202309 | 23000.00	  | 100           |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 239             | 202309 | 46000.00	  | 23            |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 240             | 202309 | 40800.00	  | 40            |
#


    # Add actuals to the contract for SB2023

    # Change the date
    Given the override date is '04/05/2025'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018035'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    Then wait '10' seconds
    
    # Pull actuals from DC for Aug 2023 (Four deliverables)
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode  | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode      | DeliverableCode | ActualVolume | ActualValue |
    | SB             | SB02                  | ORG0018035     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 337             | 0            | 1900.00     |
    | SB             | SB02                  | ORG0018035     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 697             | 0            | 1900.00     |
    | SB             | SB02                  | ORG0018035     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 698             | 0            | 1900.00     |
    | SB             | SB02                  | ORG0018035     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 699             | 0            | 1900.00     |
    | SB             | SB02                  | ORG0018035     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 700             | 0            | 1900.00     |
    | SB             | SB02                  | ORG0018035     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 701             | 0            | 1900.00     |
    | SB             | SB02                  | ORG0018035     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 702             | 0            | 1900.00     |
    | SB             | SB02                  | ORG0018035     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 703             | 0            | 1900.00     |



    Then wait '10' seconds

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   |
    | [ContractNo]   | [AllocRef_SBD]     | 337             | 1900.00   |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBD]     | 697             | 1900.00   |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBD]     | 698             | 1900.00   |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBD]     | 699             | 1900.00   |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBD]     | 700             | 1900.00   |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBD]     | 701             | 1900.00   |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBD]     | 702             | 1900.00   |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBD]     | 703             | 1900.00   |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

   
#
#
#    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
#    And   the Reconciliation Data is calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   |
#    | [ContractNo]   | [AllocRef_SB]      | 72              | 8229.83   | 8229.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 115             | 547.07    | 547.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 189             | 552.44    | 552.44   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 238             | 1002.62   | 1002.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 239             | 648.52    | 648.52   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 240             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 242             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 243             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 244             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 245             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 246             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 247             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 248             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 249             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 250             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
#   #                                                       £ 27465.68
#
#    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
#    And   the Capping Amounts are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   |
#    | [ContractNo]   | [AllocRef_SB]      | 72              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 115             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 189             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 238             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 239             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 240             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 242             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 243             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 244             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 245             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 246             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 247             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 248             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 249             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 250             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
#
#    # Check the NET AMOUNTS in CRM on the latest approved contract
#    And   the Net Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-23   |
#    | [ContractNo]   | [AllocRef_SB]      | 72              | 8229.83   | 8229.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 115             | 547.07    | 547.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 189             | 552.44    | 552.44   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 238             | 1002.62   | 1002.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 239             | 648.52    | 648.52   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 240             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 242             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 243             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 244             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 245             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 246             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 247             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 248             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 249             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 250             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
#  #                                                         £ 27465.68
#


    # Payment Batch for SB2023(PoA)

      Given the override date is '09/05/2025 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'SB2023' AccountingPaymentPeriod '202501' CensusEndDate '09/05/2025' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_SBD]           | 202504 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | SB2023               		 | 202504               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | SB2023                 	 | 202504               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SB2023' PaymentPeriod '202501' CensusEndDate '09/05/2025' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S035.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
  

    # Check the RECONCILIATION subnominal aggregations in CRM
    #And   the Reconciliation Subnominal Amounts are calculated as follows
    #| UKPRN    | ContractNumber | AllocationRef     | ReconciliationSubnominal | Sep-23    | Oct-23    | Nov-23    | Dec-23    | Jan-24    | Feb-24    | Mar-24    | Apr-24    | May-24    | Jun-24    | Jul-24    | Aug-24    | 
    #| 10018049 | [ContractNo]   | [AllocRef_SB]     | 101139                   | 22520.12  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 



    # Consolidated payment summary report

   
    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    Given the override date is '10/05/2025 10:00'

    Given there are no files prefixed '2025-04 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
   
    When  a Consolidated Payment Summary Report is created in Sharepoint for '10/05/2025'
    # Check the above report manually


    
        # Run the CDA report for the four 2021 AEBP FSPs
    Given the override date is '11/05/2024'
    Given there is no CDA report named 'CDA Latest Version S035.csv'
    And   the following ADF Pipeline run
    And   the following CDA report is run
    | FundingStreamPeriod   | Version         | Suffix |
    | SB2023                | Latest Version  | S035   |
 
    Then  a report named 'CDA Latest Version S035.csv' is created
    
#
#
#    # Update the timestamp on the TaC template to a date after contract v2 was created on 22/03/2023 (DocumentsDomain.UploadedDocumentTemplate) (J107) 
#    Given the following document templates have Upload timestamps as indicated 
#    | DocumentTemplateName                            | UploadTimestamp         | 
#    | SB_W3_TAC_2022-08-01.docx                       | 2023-03-14 12:00:00.000 | 
# #  | SB_W3_S1_2022-08-01.docx                        | 2022-06-21 12:00:00.000 | 
# #  | SB-PAA_W3_S1_2022-08-01.docx                    | 2022-06-21 12:00:00.000 | 
# #  | SB_W3_S2_2022-08-01.docx                        | 2022-06-21 12:00:00.000 | 
# #  | SB-PAA_W3_S2_2022-08-01.docx                    | 2022-06-21 12:00:00.000 | 
# #  | SB_W3_S3ON_2022-08-01.docx                      | 2022-06-21 12:00:00.000 | 
#
#
#    # Extension of SB contract to Sep 2024
#
#    # Change the date
#    Given the override date is '15/03/2023'
#
#    # Bulk file (UoP = R1C1)
#    And   there are no files prefixed '10018035' in the Sharepoint 'SBD-2023-Input-Appendices' folder
#    And   there are no files prefixed 'SB SB 2022 01032023094413 v3_S001b' in the Sharepoint 'Input' folder
#    And   there are no files prefixed 'SB SB 2022 01032023094413 v3_S001b' in the Sharepoint 'Processing' folder
#    And   there are no files prefixed 'SB SB 2022 01032023094413 v3_S001b' in the Sharepoint 'Processed' folder
#    And   there are no files prefixed 'SB SB 2022 01032023094413 v3_S001b' in the Sharepoint 'Reports' folder
#    And   spreadsheet 'SB SB 2022 01032023094413 v3_S001b.xlsx' exists in the Datafiles folder and UKPRN '10018035' is present in cell 'A2' of the Contract tab
#   #When  the file is copied to the Sharepoint 'Input' folder 
#    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
#    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
#    And   the syntax report includes the phrase 'Success'
#    And   a results report should exist in the Sharepoint Reports folder
#    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
#
#
#    # Retrieve parameters
#    When  I retrieve the latest contract details from CRM for provider '10018035' for FundingType 'SB' and period '2022'
#
#    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
#    Then  the file named '10018001_[ContractNo]_v2.pdf' in Sharepoint location 'SBD-2023-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING
#    Organisation Name: 10018035 Co Ltd UKPRN: 10018035
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 30/09/2024
#    Allocation
#    Contract Ref Cost per Learner Number of Total Funding
#    Learners
#    (if fully-funded)
#    Skills Bootcamps £4,203,360.00
#    of which Data Analyst [AllocRef_SB]-72 £120.00 208 £24,960.00
#    of which Digital Marketing [AllocRef_SB]-115 £140.00 1,560 £218,400.00
#    of which Software Development [AllocRef_SB]-189 £3,450.00 260 £897,000.00
#    of which Bay Electech - Electronic Skills Programme 2 [AllocRef_SB]-238 £1,000.00 2,600 £307,000.00
#    of which Trade Skills Development Centre [AllocRef_SB]-239 £2,000.00 598 £1,196,000.00
#    of which Plant Operator Skills Bootcamp 2 [AllocRef_SB]-240 £150.00 1,040 £156,000.00
#    of which OTP Operative [AllocRef_SB]-242 £150.00 1,040 £156,000.00
#    of which New Entrant - Possession Management [AllocRef_SB]-243 £150.00 1,040 £156,000.00
#    of which Project Controls [AllocRef_SB]-244 £150.00 1,040 £156,000.00
#    of which Cloud with Cyber [AllocRef_SB]-245 £150.00 1,040 £156,000.00
#    of which Renewable Energy Electrical Installer [AllocRef_SB]-246 £150.00 1,040 £156,000.00
#    of which Creative Computing [AllocRef_SB]-247 £150.00 1,040 £156,000.00
#    of which Leadership & Management [AllocRef_SB]-248 £150.00 1,040 £156,000.00
#    of which Plastering inc Internal Thermal Insulation [AllocRef_SB]-249 £150.00 1,040 £156,000.00
#    of which Brick inc External Thermal Insulation [AllocRef_SB]-250 £150.00 1,040 £156,000.00
#    Total Funding for this contract: £4,203,360.00
#    Summary of Funding – Page 1
#
#    Agreement Type Contract for Services
#    Funding Period 1 August 2022 to 30 September 2024
#    """
#
#    # There should not be a Funding Agreement
#    And   the pdf file does not contain the following text
#    """
#    Funding Agreement
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#    And   Sharepoint file '10018001_[ContractNo]_v2.pdf' in 'SBD-2023-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S001b.pdf'
#
#
#    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#    
#
    
    # Amend Vary

      # Change the date
   Given the override date is '01/11/2023'

   # Bulk file (UoP = R1C1)
   And   there are no files prefixed '10018035' in the Sharepoint 'SBD-2023-Input-Appendices' folder
   And   there are no files prefixed 'SBD SB 2023 01112023094413 v2_S035' in the Sharepoint 'Input' folder
   And   there are no files prefixed 'SBD SB 2023 01112023094413 v2_S035' in the Sharepoint 'Processing' folder
   And   there are no files prefixed 'SBD SB 2023 01112023094413 v2_S035' in the Sharepoint 'Processed' folder
   And   there are no files prefixed 'SBD SB 2023 01112023094413 v2_S035' in the Sharepoint 'Reports' folder
   And   spreadsheet 'SBD SB 2023 01112023094413 v2_S035.xlsx' exists in the Datafiles folder and UKPRN '10018035' is present in cell 'A2' of the Contract tab
  #When  the file is copied to the Sharepoint 'Input' folder 
   When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
   Then  a syntax report showing file success should exist in the Sharepoint Reports folder
   And   the syntax report includes the phrase 'Success'
   And   a results report should exist in the Sharepoint Reports folder
   And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


   # Retrieve parameters
   When  I retrieve the latest contract details from CRM for provider '10018035' for FundingType 'SBD' and period '2023'

   # Check the contents of the Appendices 
   Then  the file named '10018035_[ContractNo]_v2.pdf' in Sharepoint location 'SBD-2023-Input-Appendices' contains the following lines in order
   """
    SUMMARY OF FUNDING
    Organisation Name: 10018035 Co Ltd UKPRN: 10018035
    Master Contract Number: [MasterContractNo] Start Date: 01/09/2023 End Date: 31/07/2026
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £4,550,000.00
    of which Web Essentials [AllocRef_SBD]-337 £2,000.00 350 £700,000.00
    of which Level 3 Diploma in Electrical Installations [AllocRef_SBD]-697 £2,000.00 350 £700,000.00
    of which Enhanced Dozer [AllocRef_SBD]-698 £2,000.00 350 £700,000.00
    of which New Entrant - Career in Plant [AllocRef_SBD]-699 £2,000.00 350 £700,000.00
    of which Enhanced 360 Excavator [AllocRef_SBD]-700 £2,000.00 350 £700,000.00
    of which Access into Higher Nuclear Skills [AllocRef_SBD]-701 £1,000.00 350 £350,000.00
    of which Skills Bootcamp for Creative Freelancers [AllocRef_SBD]-702 £1,000.00 350 £350,000.00
    of which Construction Operations in Groundworks [AllocRef_SBD]-703 £1,000.00 350 £350,000.00
    Total Funding for this contract: £4,550,000.00
    """


   # There should not be a Funding Agreement
   And   the pdf file does not contain the following text
   """
   Funding Agreement
   """

   # Copy\Save a named Sharepoint file to a named folder\filename
   And   Sharepoint file '10018035_[ContractNo]_v2.pdf' in 'SBD-2023-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018035_[ContractNo]_v2.pdf'

# Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

   # Month end is not running
   And   the PaaS MonthEndIsRunning indicator is set to 'False'

   # Inject an SFS approval message 
   When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

   # Check that the contract is now approved
   Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
   Then wait '10' seconds


   # Test CRM details against same in ContractManagement feed (30447)
   Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

   # Insert/Update details into the ContractManagement.CreatedContract table (J104)
   #   Note: Documents are created using the system date. The following step 'corrects' this
   Given the following document creation details exist in the ContractManagement.CreatedContract table
   | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
   | [ContractNo]   | 2                     | 0                        | 2023-08-01 09:12:35.000 |


# Add actuals to the contract for SB2023

   # Change the date
   Given the override date is '04/05/2025' 

   # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
   And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018035'

   # Clear down the stub
   And   there are no entries in the DCFS stub table

   # Month end is not running
   And   the PaaS MonthEndIsRunning indicator is set to 'False'

   # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
   And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

   Then wait '10' seconds
   
   # Pull actuals from DC for Aug 2023 (Four deliverables)
   And   the following closed collections are available in DCFS 
   | CollectionType | CollectionReturnCode  | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode      | DeliverableCode | ActualVolume | ActualValue |
   | SB             | SB02                  | ORG0018035     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 698             | 0            | 1900.00     |
   | SB             | SB02                  | ORG0018035     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 699             | 0            | 1900.00     |
   | SB             | SB02                  | ORG0018035     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 700             | 0            | 1900.00     |
   | SB             | SB02                  | ORG0018035     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 701             | 0            | 1900.00     |
   | SB             | SB02                  | ORG0018035     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 702             | 0            | 1900.00     |
   | SB             | SB02                  | ORG0018035     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 703             | 0            | 1900.00     |



   Then wait '10' seconds

   # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
  #When  the FCT system polls the DCFS DEDS service
   When  the FCT system polls the SLD service

   # Check the ACTUAL VALUES in CRM on the latest approved contract
   Then  the Actuals Value Data is as follows
  | ContractNumber | AllocationRef        | DeliverableCode | Total     | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   |
    | [ContractNo]   | [AllocRef_SBD]     | 698             | 1900.00   |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBD]     | 699             | 1900.00   |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBD]     | 700             | 1900.00   |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBD]     | 701             | 1900.00   |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBD]     | 702             | 1900.00   |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBD]     | 703             | 1900.00   |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        |?         | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

  # Payment Batch for SB2023(PoA)

   # Change the date
   Given the override date is '09/05/2025 22:05'

   # Month end is not running
   And   the PaaS MonthEndIsRunning indicator is set to 'False'

   # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
   And   there is no data in the Payment feed for FundingStreamPeriod 'SB2023' AccountingPaymentPeriod '202501' CensusEndDate '09/05/2025' and LinkCodeSuffix 'A'

   # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
   And   the following allocation periods are present in the subnominal aggregation PaaS table
   | ContractAllocationNumber | Period |
   | [AllocRef_SBD]            | 202504 |

   # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
   And   the following configuration exists in the Payment Timetable
   | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
   | SB2023               		 | 202504               |                      | A              | NotStarted |

   When  the Payment Generation Batch run is started

   # PaymentGeneration.PaymentTimetable
   Then  there is an entry in the Payment Timetable
   | Funding Stream Period Code | Calendar Year/Period | Status    |
   | SB2023                 	 | 202504               | Completed |

   # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
   And   the Payment feed xml for FundingStreamPeriod 'SB2023' PaymentPeriod '202501' CensusEndDate '09/05/2025' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S035.xml'


   Given there are no files prefixed '2024-05 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
  When  a Consolidated Payment Summary Report is created in Sharepoint for '10/05/2025'
   # Check the above report manually





@AcceptanceTest @Complete
Scenario: S049 Create Skill Bootcamps to validate new contract 23/24 for SB as part of story 42843. Publish and approve. Check docs. Push actuals. Generate payments.

    Given there are no allocations marked as Under Termination for UKPRN '10018049' 
    And   there are no terminated or closed allocations for UKPRN '10018049' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018049' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018049' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018049' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP           |
    | SB2023        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018049'

    # Set the 'base' timestamp for each of the Bootcamps document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    Given the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_SB_2023-08-01.docx                          | 2023-07-21 12:00:00.000 | 
 
    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018049' 
    And   there is no caseload advisor for UKPRN '10018049' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018049 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018049' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018049 Co Ltd' with UKPRN '10018049' and OrgId 'ORG0018049' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018049 | 118049 | 10018049 Co Ltd | 0              | In Administration     | Yes           | AA018049      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018049 |





    # Change the date
    Given the override date is '01/08/2023'

    # Bulk file (UoP = R1C1)
    And   there are no files prefixed '10018049' in the Sharepoint 'SBD-2023-Input-Appendices' folder
    And   there are no files prefixed 'SBD SB 2023 04042023094413 v1_S049' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SBD SB 2023 04042023094413 v1_S049' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SBD SB 2023 04042023094413 v1_S049' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SBD SB 2023 04042023094413 v1_S049' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SBD SB 2023 04042023094413 v1_S049.xlsx' exists in the Datafiles folder and UKPRN '10018049' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018049' for FundingType 'SBD' and period '2023'

#    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
#    Then  the file named '10018049_[ContractNo]_v1.pdf' in Sharepoint location 'SBD-2023-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING
#    Organisation Name: 10018049 Co Ltd UKPRN: 10018049
#    Master Contract Number: [MasterContractNo] Start Date: 01/02/2024 End Date: 31/01/2026
#    Allocation
#    Contract Ref Cost per Learner Number of Total Funding
#    Learners
#    (if fully-funded)
#    Skills Bootcamps £788,516.00
#    of which Early Years Educator [AllocRef_SBD]-508 £1,886.00 230 £390,508.00
#    of which SBC003 Electrical Skills Essentials - Solar PV [AllocRef_SBD]-686 £1,600.00 400 £190,508.00
#    of which Upskilling training and assessing leads (w/o plant) [AllocRef_SBD]-726 £1,000.00 3,600 £17,400.00
#    of which Machinery Surveyor [AllocRef_SBD]-727 £1,100.00 1,200 £10,200.00
#    of which New Air source heat pump [AllocRef_SBD]-728 £1,100.00 1,200 £119,900.00
#    of which Inspection & Testing Plus EV Package [AllocRef_SBD]-396 £500.00 120 £60,000.00
#    Total Funding for this contract: £788,516.00
#    Summary of Funding – Page 1
#    """
#
#
#    # There should not be a Funding Agreement
#    And   the pdf file does not contain the following text
#    """
#    Funding Agreement
#    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018049_[ContractNo]_v1.pdf' in 'SBD-2023-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018049_[ContractNo]_v1.pdf'

    
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
    | 10018049 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/02/2024        | 31/01/2026      | ?             |
    | 10018049 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2024        | 31/01/2026      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-08-01 09:12:35.000 |
	


	
#    # Check ADP
#
#    # Check all activity has completed
#    When  there are no messages left in the system
#
#    # Check Planned data on the ADP feed for Aug-22
#    Then  the Allocation Delivery Monitoring Service atom feed contains the following Planned data
#    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume | 
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 72              | 202309 | 155550.00	  | 60            |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 115             | 202309 | 150150.00	  | 60            |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 189             | 202309 | 184230.00	  | 60            |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 238             | 202309 | 23000.00	  | 100           |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 239             | 202309 | 46000.00	  | 23            |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 240             | 202309 | 40800.00	  | 40            |
#


    # Add actuals to the contract for SB2023

    # Change the date
    Given the override date is '04/05/2025'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018049'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    Then wait '10' seconds
    
    # Pull actuals from DC for Aug 2023 (Four deliverables)
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode  | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode      | DeliverableCode | ActualVolume | ActualValue |
    | SB             | SB19                  | ORG0018049     | CM             | 202501 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 508             | 0            | 1900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202501 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 686             | 0            | 2900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202501 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 726             | 0            | 3900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202501 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 727             | 0            | 1100.00     |
	#
    | SB             | SB19                  | ORG0018049     | CM             | 202502 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 508             | 0            | 1000.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202502 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 686             | 0            | 2000.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202502 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 726             | 0            | 3000.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202502 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 727             | 0            | 1300.00     |
	#
    | SB             | SB19                  | ORG0018049     | CM             | 202503 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 508             | 0            | 900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202503 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 686             | 0            | 900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202503 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 726             | 0            | 900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202503 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 727             | 0            | 1200.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202503 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 728             | 0            | 700.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202503 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 396             | 0            | 1100.00     |
	#
    | SB             | SB19                  | ORG0018049     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 508             | 0            | 900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 686             | 0            | 900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 726             | 0            | 900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 727             | 0            | 1200.00    |
    | SB             | SB19                  | ORG0018049     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 728             | 0            | 900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 396             | 0            | 1200.00    |
    #
    | SB             | SB19                  | ORG0018049     | CM             | 202601 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 508             | 0            | 1900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202601 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 686             | 0            | 2900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202601 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 726             | 0            | 3900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202601 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 727             | 0            | 1100.00     |
	#
    | SB             | SB19                  | ORG0018049     | CM             | 202602 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 508             | 0            | 1000.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202602 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 686             | 0            | 2000.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202602 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 726             | 0            | 3000.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202602 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 727             | 0            | 1300.00     |
	#
    | SB             | SB19                  | ORG0018049     | CM             | 202603 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 508             | 0            | 900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202603 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 686             | 0            | 900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202603 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 726             | 0            | 900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202603 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 727             | 0            | 1200.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202603 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 728             | 0            | 700.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202603 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 396             | 0            | 1100.00     |
	#
    | SB             | SB19                  | ORG0018049     | CM             | 202604 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 508             | 0            | 900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202604 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 686             | 0            | 900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202604 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 726             | 0            | 900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202604 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 727             | 0            | 1200.00    |
    | SB             | SB19                  | ORG0018049     | CM             | 202604 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 728             | 0            | 900.00     |
    | SB             | SB19                  | ORG0018049     | CM             | 202604 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 396             | 0            | 1200.00    |
    #

    Then wait '10' seconds

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   |
    | [ContractNo]   | [AllocRef_SBD]     | 508             | 2800.00   |1900.00   | 1000.00  | 900.00   | 900.00   | ?        | ?        | ?        |
    | [ContractNo]   | [AllocRef_SBD]     | 686             | 5800.00   |2900.00   | 2000.00  | 900.00   | 900.00   | ?        | ?        | ?        |
    | [ContractNo]   | [AllocRef_SBD]     | 726             | 7800.00   |3900.00   | 3000.00  | 900.00   | 900.00   | ?        | ?        | ?        |
    | [ContractNo]   | [AllocRef_SBD]     | 727             | 7800.00   |1100.00   | 1300.00  | 1200.00  | 1200.00  | ?        | ?        | ?        |
    | [ContractNo]   | [AllocRef_SBD]     | 728             | 7800.00   | 0.00     | 0.00     | 700.00   | 900.00   | ?        | ?        | ?        |
    | [ContractNo]   | [AllocRef_SBD]     | 396             | 7800.00   | 0.00     | 0.00     | 1100.00  | 1200.00  | ?        | ?        | ?        |

                                                            # 17400.00
   
#
#
#    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
#    And   the Reconciliation Data is calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   |
#    | [ContractNo]   | [AllocRef_SB]      | 72              | 8229.83   | 8229.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 115             | 547.07    | 547.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 189             | 552.44    | 552.44   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 238             | 1002.62   | 1002.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 239             | 648.52    | 648.52   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 240             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 242             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 243             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 244             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 245             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 246             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 247             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 248             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 249             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 250             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
#   #                                                       £ 27465.68
#
#    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
#    And   the Capping Amounts are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   |
#    | [ContractNo]   | [AllocRef_SB]      | 72              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 115             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 189             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 238             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 239             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 240             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 242             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 243             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 244             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 245             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 246             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 247             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 248             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 249             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 250             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
#
#    # Check the NET AMOUNTS in CRM on the latest approved contract
#    And   the Net Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-23   |
#    | [ContractNo]   | [AllocRef_SB]      | 72              | 8229.83   | 8229.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 115             | 547.07    | 547.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 189             | 552.44    | 552.44   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 238             | 1002.62   | 1002.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 239             | 648.52    | 648.52   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 240             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 242             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 243             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 244             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 245             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 246             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 247             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 248             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 249             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 250             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
#  #                                                         £ 27465.68
#


    # Payment Batch for SB2023(PoA)

    # Change the date
    Given the override date is '09/05/2025 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'SB2023' AccountingPaymentPeriod '202501' CensusEndDate '09/05/2025' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_SBD]           | 202504 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | SB2023               		 | 202504               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | SB2023                 	 | 202504               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SB2023' PaymentPeriod '202501' CensusEndDate '09/05/2025' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S049.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
  

    # Check the RECONCILIATION subnominal aggregations in CRM
    #And   the Reconciliation Subnominal Amounts are calculated as follows
    #| UKPRN    | ContractNumber | AllocationRef     | ReconciliationSubnominal | Sep-23    | Oct-23    | Nov-23    | Dec-23    | Jan-24    | Feb-24    | Mar-24    | Apr-24    | May-24    | Jun-24    | Jul-24    | Aug-24    | 
    #| 10018049 | [ContractNo]   | [AllocRef_SB]     | 101139                   | 22520.12  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 



    # Consolidated payment summary report

   
    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    Given the override date is '10/05/2025 10:00'

    Given there are no files prefixed '2025-04 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
   
    When  a Consolidated Payment Summary Report is created in Sharepoint for '10/05/2025'
    # Check the above report manually


    
    # Run the CDA report for the four 2021 AEBP FSPs
    Given the override date is '11/05/2025'
    Given there is no CDA report named 'CDA Latest Version S049.csv'
    And   the following ADF Pipeline run
    And   the following CDA report is run
    | FundingStreamPeriod   | Version         | Suffix |
    | SB2023                | Latest Version  | S049   |
 
    Then  a report named 'CDA Latest Version S049.csv' is created



#
#
#    # Update the timestamp on the TaC template to a date after contract v2 was created on 22/03/2023 (DocumentsDomain.UploadedDocumentTemplate) (J107) 
#    Given the following document templates have Upload timestamps as indicated 
#    | DocumentTemplateName                            | UploadTimestamp         | 
#    | SB_W3_TAC_2022-08-01.docx                       | 2023-03-14 12:00:00.000 | 
# #  | SB_W3_S1_2022-08-01.docx                        | 2022-06-21 12:00:00.000 | 
# #  | SB-PAA_W3_S1_2022-08-01.docx                    | 2022-06-21 12:00:00.000 | 
# #  | SB_W3_S2_2022-08-01.docx                        | 2022-06-21 12:00:00.000 | 
# #  | SB-PAA_W3_S2_2022-08-01.docx                    | 2022-06-21 12:00:00.000 | 
# #  | SB_W3_S3ON_2022-08-01.docx                      | 2022-06-21 12:00:00.000 | 
#
#
#    # Extension of SB contract to Sep 2024
#
#    # Change the date
#    Given the override date is '15/03/2023'
#
#    # Bulk file (UoP = R1C1)
#    And   there are no files prefixed '10018049' in the Sharepoint 'SBD-2023-Input-Appendices' folder
#    And   there are no files prefixed 'SB SB 2022 01032023094413 v3_S001b' in the Sharepoint 'Input' folder
#    And   there are no files prefixed 'SB SB 2022 01032023094413 v3_S001b' in the Sharepoint 'Processing' folder
#    And   there are no files prefixed 'SB SB 2022 01032023094413 v3_S001b' in the Sharepoint 'Processed' folder
#    And   there are no files prefixed 'SB SB 2022 01032023094413 v3_S001b' in the Sharepoint 'Reports' folder
#    And   spreadsheet 'SB SB 2022 01032023094413 v3_S001b.xlsx' exists in the Datafiles folder and UKPRN '10018049' is present in cell 'A2' of the Contract tab
#   #When  the file is copied to the Sharepoint 'Input' folder 
#    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
#    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
#    And   the syntax report includes the phrase 'Success'
#    And   a results report should exist in the Sharepoint Reports folder
#    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
#
#
#    # Retrieve parameters
#    When  I retrieve the latest contract details from CRM for provider '10018049' for FundingType 'SB' and period '2022'
#
#    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
#    Then  the file named '10018001_[ContractNo]_v2.pdf' in Sharepoint location 'SBD-2023-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING
#    Organisation Name: 10018049 Co Ltd UKPRN: 10018049
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 30/09/2024
#    Allocation
#    Contract Ref Cost per Learner Number of Total Funding
#    Learners
#    (if fully-funded)
#    Skills Bootcamps £4,203,360.00
#    of which Data Analyst [AllocRef_SB]-72 £120.00 208 £24,960.00
#    of which Digital Marketing [AllocRef_SB]-115 £140.00 1,560 £218,400.00
#    of which Software Development [AllocRef_SB]-189 £3,450.00 260 £897,000.00
#    of which Bay Electech - Electronic Skills Programme 2 [AllocRef_SB]-238 £1,000.00 2,600 £307,000.00
#    of which Trade Skills Development Centre [AllocRef_SB]-239 £2,000.00 598 £1,196,000.00
#    of which Plant Operator Skills Bootcamp 2 [AllocRef_SB]-240 £150.00 1,040 £156,000.00
#    of which OTP Operative [AllocRef_SB]-242 £150.00 1,040 £156,000.00
#    of which New Entrant - Possession Management [AllocRef_SB]-243 £150.00 1,040 £156,000.00
#    of which Project Controls [AllocRef_SB]-244 £150.00 1,040 £156,000.00
#    of which Cloud with Cyber [AllocRef_SB]-245 £150.00 1,040 £156,000.00
#    of which Renewable Energy Electrical Installer [AllocRef_SB]-246 £150.00 1,040 £156,000.00
#    of which Creative Computing [AllocRef_SB]-247 £150.00 1,040 £156,000.00
#    of which Leadership & Management [AllocRef_SB]-248 £150.00 1,040 £156,000.00
#    of which Plastering inc Internal Thermal Insulation [AllocRef_SB]-249 £150.00 1,040 £156,000.00
#    of which Brick inc External Thermal Insulation [AllocRef_SB]-250 £150.00 1,040 £156,000.00
#    Total Funding for this contract: £4,203,360.00
#    Summary of Funding – Page 1
#
#    Agreement Type Contract for Services
#    Funding Period 1 August 2022 to 30 September 2024
#    """
#
#    # There should not be a Funding Agreement
#    And   the pdf file does not contain the following text
#    """
#    Funding Agreement
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#    And   Sharepoint file '10018001_[ContractNo]_v2.pdf' in 'SBD-2023-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S001b.pdf'
#
#
#    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#    
#
    
    # Amend Vary

    # Change the date
    Given the override date is '01/07/2025'

    # Bulk file (UoP = R1C1)
    And   there are no files prefixed '10018049' in the Sharepoint 'SBD-2023-Input-Appendices' folder
    And   there are no files prefixed 'SBD SB 2023 01112023094413 v2_S049' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SBD SB 2023 01112023094413 v2_S049' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SBD SB 2023 01112023094413 v2_S049' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SBD SB 2023 01112023094413 v2_S049' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SBD SB 2023 01112023094413 v2_S049.xlsx' exists in the Datafiles folder and UKPRN '10018049' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018049' for FundingType 'SBD' and period '2023'

    # Check the contents of the Appendices 
    Then  the file named '10018049_[ContractNo]_v2.pdf' in Sharepoint location 'SBD-2023-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10018049 Co Ltd UKPRN: 10018049
    Master Contract Number: [MasterContractNo] Start Date: 01/02/2024 End Date: 31/01/2026
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £1,605,216.00
    of which Inspection & Testing Plus EV Package [AllocRef_SBD]-396 £500.00 120 £60,000.00
    of which Early Years Educator [AllocRef_SBD]-508 £1,886.00 230 £390,508.00
    of which SBC003 Electrical Skills Essentials - Solar PV [AllocRef_SBD]-686 £1,600.00 400 £190,508.00
    of which Upskilling training and assessing leads (w/o plant) [AllocRef_SBD]-726 £1,000.00 720 £304,200.00
    of which Machinery Surveyor [AllocRef_SBD]-727 £1,100.00 960 £300,000.00
    of which New Air source heat pump [AllocRef_SBD]-728 £100.00 240 £60,000.00
    of which Cyber - Security, Intrusion Analysis, Technology [AllocRef_SBD]-522 £1,500.00 240 £300,000.00
    Readiness, Engineering
    Total Funding for this contract: £1,605,216.00
    Summary of Funding – Page 1
    """

    # There should not be a Funding Agreement
    And   the pdf file does not contain the following text
    """
    Funding Agreement
    """
 

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018049_[ContractNo]_v2.pdf' in 'SBD-2023-Input-Appendices' is copied to 'Datafiles/Downloads' as '10018049_[ContractNo]_v2.pdf'
#
# # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#    Then wait '10' seconds
#
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
#    #   Note: Documents are created using the system date. The following step 'corrects' this
#    Given the following document creation details exist in the ContractManagement.CreatedContract table
#    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
#    | [ContractNo]   | 2                     | 0                        | 2024-08-01 09:12:35.000 |
#
##
# # Add actuals to the contract for SB2023
#
#    # Change the date
#    Given the override date is '04/07/2024' 
#
#    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
#    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018049'
#
#    # Clear down the stub
#    And   there are no entries in the DCFS stub table
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
#    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS
#
#    Then wait '10' seconds
#    
#    # Pull actuals from DC for Aug 2023 (Four deliverables)
#    And   the following closed collections are available in DCFS 
#    | CollectionType | CollectionReturnCode  | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode      | DeliverableCode | ActualVolume | ActualValue |
#    | SB             | SB02                  | ORG0018049     | CM             | 202404 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 691             | 0            | 1900.00     |
#    | SB             | SB02                  | ORG0018049     | CM             | 202404 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 692             | 0            | 1900.00     |
#    | SB             | SB02                  | ORG0018049     | CM             | 202404 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 693             | 0            | 1900.00     |
#
#
#
#    Then wait '10' seconds
#
#    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
#   #When  the FCT system polls the DCFS DEDS service
#    When  the FCT system polls the SLD service
#
#    # Check the ACTUAL VALUES in CRM on the latest approved contract
#    Then  the Actuals Value Data is as follows
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   |
#    | [ContractNo]   | [AllocRef_SBD]     | 691             | 1900.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_SBD]     | 692             | 1900.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_SBD]     | 693             | 1900.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        | 
#
#	  # Payment Batch for SB2023(PoA)
#
#    # Change the date
#    Given the override date is '09/05/2024 22:05'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod 'SB2023' AccountingPaymentPeriod '202401' CensusEndDate '09/05/2024' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | [AllocRef_SBD]            | 202404 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | SB2023               		 | 202404               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | SB2023                 	 | 202404               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'SB2023' PaymentPeriod '202401' CensusEndDate '09/05/2024' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S049.xml'
#


        
    # Tidy Up
   Given the override date is reset



   @AcceptanceTest @Complete
Scenario: AK043 Create Skill Bootcamps to validate new contract 23/24 for SB as part of story 42843. Publish and approve. Check docs. Push actuals. Generate payments.

    Given there are no allocations marked as Under Termination for UKPRN '10000043' 
    And   there are no terminated or closed allocations for UKPRN '10000043' 
    And   there is no Contract, Task or Workflow data for UKPRN '10000043' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10000043' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10000043' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP           |
    | SB2023        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10000043'

    # Set the 'base' timestamp for each of the Bootcamps document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
     Given the following document templates have Upload timestamps as indicated 
  | DocumentTemplateName                            | UploadTimestamp         | 
  | SOF_SB_2023-08-01.docx                          | 2023-07-21 12:00:00.000 | 
 
 
    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10000043' 
    And   there is no caseload advisor for UKPRN '10000043' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10000043 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10000043' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10000043 Co Ltd' with UKPRN '10000043' and OrgId 'ORG0010043' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10000043 | 110043 | 10000043 Co Ltd | 0              | In Administration     | Yes           | AA010043      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10000043 |





    # Change the date
    Given the override date is '01/08/2023'

    # Bulk file (UoP = W3L1)
    And   there are no files prefixed '10000043' in the Sharepoint 'SBD-2023-Input-Appendices' folder
    And   there are no files prefixed 'SBD SB 2023 05042023094413 v1_AK043' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SBD SB 2023 05042023094413 v1_AK043' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SBD SB 2023 05042023094413 v1_AK043' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SBD SB 2023 05042023094413 v1_AK043' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SBD SB 2023 05042023094413 v1_AK043.xlsx' exists in the Datafiles folder and UKPRN '10000043' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10000043' for FundingType 'SBD' and period '2023'


    #    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
#    Then  the file named '10000043_[ContractNo]_v1.pdf' in Sharepoint location 'SBD-2023-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING
#    Organisation Name: 10000043 Co Ltd UKPRN: 10000043
#    Master Contract Number: [MasterContractNo] Start Date: 01/02/2024 End Date: 31/07/2027
#    Allocation
#    Contract Ref Cost per Learner Number of Total Funding
#    Learners
#    (if fully-funded)
#    Skills Bootcamps  £1,723,040.00
#    of which Early Years Educator [AllocRef_SBD]-508 £1,886.00 460  £781,016.00
#    of which SBC003 Electrical Skills Essentials - Solar PV [AllocRef_SBD]-686 £1,600.00 1,200  £571,524.00
#    of which Upskilling training and assessing leads (w/o plant) [AllocRef_SBD]-726 £1,000.00 5,400 £26,300.00
#    of which Machinery Surveyor [AllocRef_SBD]-727 £1,100.00 1,800 £14,900.00
#    of which New Air source heat pump [AllocRef_SBD]-728 £1,100.00 1,800 £234,300.00
#    of which Inspection & Testing Plus EV Package [AllocRef_SBD]-396 £500.00 190 £95,000.00
#    Total Funding for this contract: £1,723,040.00
#    Summary of Funding – Page 1
#    """
#
#
#    # There should not be a Funding Agreement
#    And   the pdf file does not contain the following text
#    """
#    Funding Agreement
#    """









    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10000043_[ContractNo]_v1.pdf' in 'SBD-2023-Input-Appendices' is copied to 'Datafiles/Downloads' as 'Ak043.pdf'

    
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
    | 10000043 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/02/2024         | 31/07/2027      | ?             |
    | 10000043 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/02/2024         | 31/07/2027      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2023-08-01 09:12:35.000 |
	

    # Add actuals to the contract for SB2023

    # Change the date
    Given the override date is '04/05/2027'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0010043'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS
    Then wait '10' seconds
    
    # Pull actuals from DC for Aug 2023 (Four deliverables)
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode  | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode      | DeliverableCode | ActualVolume | ActualValue |
    | SB             | SB43                  | ORG0010043     | CM             | 202501 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 508             | 0            | 1900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202501 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 686             | 0            | 2900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202501 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 726             | 0            | 3900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202501 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 727             | 0            | 1100.00     |
	#
    | SB             | SB43                  | ORG0010043     | CM             | 202502 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 508             | 0            | 1000.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202502 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 686             | 0            | 2000.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202502 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 726             | 0            | 3000.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202502 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 727             | 0            | 1300.00     |
	#
    | SB             | SB43                  | ORG0010043     | CM             | 202503 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 508             | 0            | 900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202503 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 686             | 0            | 900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202503 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 726             | 0            | 900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202503 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 727             | 0            | 1200.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202503 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 728             | 0            | 700.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202503 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 396             | 0            | 1100.00     |
	#
    | SB             | SB43                  | ORG0010043     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 508             | 0            | 900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 686             | 0            | 900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 726             | 0            | 900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 727             | 0            | 1200.00    |
    | SB             | SB43                  | ORG0010043     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 728             | 0            | 900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202504 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 396             | 0            | 1200.00    |
   #
    | SB             | SB43                  | ORG0010043     | CM             | 202701 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 508             | 0            | 1900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202701 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 686             | 0            | 2900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202701 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 726             | 0            | 3900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202701 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 727             | 0            | 1100.00     |
	#
    | SB             | SB43                  | ORG0010043     | CM             | 202702 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 508             | 0            | 1000.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202702 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 686             | 0            | 2000.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202702 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 726             | 0            | 3000.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202702 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 727             | 0            | 1300.00     |
	#
    | SB             | SB43                  | ORG0010043     | CM             | 202703 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 508             | 0            | 900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202703 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 686             | 0            | 900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202703 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 726             | 0            | 900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202703 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 727             | 0            | 1200.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202703 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 728             | 0            | 700.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202703 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 396             | 0            | 1100.00     |
	#
    | SB             | SB43                  | ORG0010043     | CM             | 202704 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 508             | 0            | 900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202704 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 686             | 0            | 900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202704 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 726             | 0            | 900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202704 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 727             | 0            | 1200.00    |
    | SB             | SB43                  | ORG0010043     | CM             | 202704 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 728             | 0            | 900.00     |
    | SB             | SB43                  | ORG0010043     | CM             | 202704 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 396             | 0            | 1200.00    |
    #

    

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service
    Then wait '10' seconds

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-27   | Feb-27   | Mar-27   | Apr-27   | May-27   | Jun-27   | Jul-27   |
   | [ContractNo]   | [AllocRef_SBD]     | 508             | 2800.00   |1900.00   | 1000.00  | 900.00   | 900.00   | ?        | ?        | ?        |
    | [ContractNo]   | [AllocRef_SBD]     | 686             | 5800.00   |2900.00   | 2000.00  | 900.00   | 900.00   | ?        | ?        | ?        |
    | [ContractNo]   | [AllocRef_SBD]     | 726             | 7800.00   |3900.00   | 3000.00  | 900.00   | 900.00   | ?        | ?        | ?        |
    | [ContractNo]   | [AllocRef_SBD]     | 727             | 7800.00   |1100.00   | 1300.00  | 1200.00  | 1200.00  | ?        | ?        | ?        |
    | [ContractNo]   | [AllocRef_SBD]     | 728             | 7800.00   | 0.00     | 0.00     | 700.00   | 900.00   | ?        | ?        | ?        |
    | [ContractNo]   | [AllocRef_SBD]     | 396             | 7800.00   | 0.00     | 0.00     | 1100.00  | 1200.00  | ?        | ?        | ?        |

#
#
#    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
#    And   the Reconciliation Data is calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   | 
#    | [ContractNo]   | [AllocRef_SB]      | 508             | 8229.83   | 8229.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 686             | 547.07    | 547.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 726             | 552.44    | 552.44   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 727             | 1002.62   | 1002.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 728             | 648.52    | 648.52   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 396             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

#
#    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
#    And   the Capping Amounts are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   | 
#    | [ContractNo]   | [AllocRef_SB]      | 508             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 686             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 726             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 727             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 728             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 396             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

#
#    # Check the NET AMOUNTS in CRM on the latest approved contract
#    And   the Net Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-25   | Sep-25   | Oct-25   | Nov-25   | Dec-25   | Jan-26   | Feb-26   | Mar-26   | Apr-26   | May-26   | Jun-26   | Jul-26   | 
#    | [ContractNo]   | [AllocRef_SB]      | 508             | 8229.83   | 8229.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 686             | 547.07    | 547.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 726             | 552.44    | 552.44   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 727             | 1002.62   | 1002.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 728             | 648.52    | 648.52   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_SB]      | 396             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

#
#    # Payment Batch for SB2023(PoA)
#
#    # Change the date
    Given the override date is '11/05/2027 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'SB2023' AccountingPaymentPeriod '202701' CensusEndDate '11/05/2027' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_SBD]           | 202704 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | SB2023               		 | 202704               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | SB2023                 	 | 202704               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SB2023' PaymentPeriod '202701' CensusEndDate '11/05/2027' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'Ak043.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
  

    # Check the RECONCILIATION subnominal aggregations in CRM
    #And   the Reconciliation Subnominal Amounts are calculated as follows
    #| UKPRN    | ContractNumber | AllocationRef     | ReconciliationSubnominal | Sep-23    | Oct-23    | Nov-23    | Dec-23    | Jan-24    | Feb-24    | Mar-24    | Apr-24    | May-24    | Jun-24    | Jul-24    | Aug-24    | 
    #| 10000043 | [ContractNo]   | [AllocRef_SB]     | 101139                   | 22520.12  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 



    # Consolidated payment summary report

   
    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    Given the override date is '12/05/2027 10:00'

    Given there are no files prefixed '2027-04 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
   
    When  a Consolidated Payment Summary Report is created in Sharepoint for '12/05/2027'
    # Check the above report manually


    
    # Run the CDA report for the four 2021 AEBP FSPs
    Given the override date is '11/05/2025'
    Given there is no CDA report named 'CDA Latest Version Ak043.csv'
    And   the following ADF Pipeline run
    And   the following CDA report is run
    | FundingStreamPeriod   | Version         | Suffix |
    | SB2023                | Latest Version  | AK043   |
 
    Then  a report named 'CDA Latest Version AK043.csv' is created




    
    # Amend Vary

    # Change the date
    Given the override date is '01/07/2025'

    # Bulk file (UoP = R1C1)
    And   there are no files prefixed '10000043' in the Sharepoint 'SBD-2023-Input-Appendices' folder
    And   there are no files prefixed 'SBD SB 2023 06112023094413 v2_AK043' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SBD SB 2023 06112023094413 v2_AK043' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SBD SB 2023 06112023094413 v2_AK043' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SBD SB 2023 06112023094413 v2_AK043' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SBD SB 2023 06112023094413 v2_AK043.xlsx' exists in the Datafiles folder and UKPRN '10000043' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10000043' for FundingType 'SBD' and period '2023'



    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10000043_[ContractNo]_v2.pdf' in 'SBD-2023-Input-Appendices' is copied to 'Datafiles/Downloads' as '10000043_[ContractNo]_v2.pdf'
#
# # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#    Then wait '10' seconds
#
#
#    # Test CRM details against same in ContractManagement feed (30447)
#    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed
#
#    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
#    #   Note: Documents are created using the system date. The following step 'corrects' this
#    Given the following document creation details exist in the ContractManagement.CreatedContract table
#    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
#    | [ContractNo]   | 2                     | 0                        | 2024-08-01 09:12:35.000 |
#
##
# # Add actuals to the contract for SB2023
#
#    # Change the date
#    Given the override date is '04/07/2024' 
#
#    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
#    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018049'
#
#    # Clear down the stub
#    And   there are no entries in the DCFS stub table
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
#    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS
#
#    Then wait '10' seconds
#    
#    # Pull actuals from DC for Aug 2023 (Four deliverables)
#    And   the following closed collections are available in DCFS 
#    | CollectionType | CollectionReturnCode  | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode      | DeliverableCode | ActualVolume | ActualValue |
#    | SB             | SB02                  | ORG0018049     | CM             | 202404 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 691             | 0            | 1900.00     |
#    | SB             | SB02                  | ORG0018049     | CM             | 202404 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 692             | 0            | 1900.00     |
#    | SB             | SB02                  | ORG0018049     | CM             | 202404 | SB2023   	             | [AllocRef_SBD]            | R02C07       | 693             | 0            | 1900.00     |
#
#
#
#    Then wait '10' seconds
#
#    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
#   #When  the FCT system polls the DCFS DEDS service
#    When  the FCT system polls the SLD service
#
#    # Check the ACTUAL VALUES in CRM on the latest approved contract
#    Then  the Actuals Value Data is as follows
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   |
#    | [ContractNo]   | [AllocRef_SBD]     | 691             | 1900.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_SBD]     | 692             | 1900.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_SBD]     | 693             | 1900.00   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1900.00  | ?        | ?        | ?        | ?        | 
#
#	  # Payment Batch for SB2023(PoA)
#
#    # Change the date
#    Given the override date is '09/05/2024 22:05'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod 'SB2023' AccountingPaymentPeriod '202401' CensusEndDate '09/05/2024' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | [AllocRef_SBD]            | 202404 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | SB2023               		 | 202404               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | SB2023                 	 | 202404               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'SB2023' PaymentPeriod '202401' CensusEndDate '09/05/2024' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S049.xml'
#


        
    # Tidy Up
   Given the override date is reset

