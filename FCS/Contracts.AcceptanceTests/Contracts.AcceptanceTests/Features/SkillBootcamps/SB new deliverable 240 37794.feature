Feature: Create Skill Bootcamps to validate a new deliverable 240 for SB as part of story 37794. Publish and approve. Check docs. Push actuals. Generate payments.

 
@AcceptanceTest @Inprogress
Scenario: S001 Bulk load a Skills Bootcamp  (SB2022) contract for 22/23 to validate 2 new deliverables. Publish and approve. Check docs. Push actuals for new collection. Generate payments.
          #Extend the contract to Sep 2024. Publish and approve. 
          #Add a new deliverable. Check docs. 

    Given there are no allocations marked as Under Termination for UKPRN '10018001' 
    And   there are no terminated or closed allocations for UKPRN '10018001' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018001' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018001' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018001' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP           |
    | SB2022        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018001'

    # Set the 'base' timestamp for each of the Bootcamps document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    Given the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_SB_2022-08-01.docx                          | 2022-06-21 12:00:00.000 | 
    | SB_W3_TAC_2022-08-01.docx                       | 2022-06-21 12:00:00.000 | 
 
    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018001' 
    And   there is no caseload advisor for UKPRN '10018001' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018001 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018001' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018001 Co Ltd' with UKPRN '10018001' and OrgId 'ORG0018001' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018001 | 118001 | 10018001 Co Ltd | 0              | In Administration     | Yes           | AA018001      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018001 |





    # Change the date
    Given the override date is '01/07/2022'

    # Bulk file (UoP = W3L1)
    And   there are no files prefixed '10018001' in the Sharepoint 'SB-2022-Input-Appendices' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S001' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S001' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S001' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S001' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SB SB 2022 15072022094413 v3_S001.xlsx' exists in the Datafiles folder and UKPRN '10018001' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018001' for FundingType 'SB' and period '2022'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    Then  the file named '10018001_[ContractNo]_v1.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10018001 Co Ltd UKPRN: 10018001
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 30/09/2023
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £1,951,080.00
    of which Bay Electech - Electronic Skills Programme 2 [AllocRef_SB]-238 £1,000.00 100 £23,000.00
    of which Trade Skills Development Centre [AllocRef_SB]-239 £2,000.00 23 £46,000.00
	of which Software Development [AllocRef_SB]-189 £3,450.00 60 £184,230.00
	of which Data Analyst [AllocRef_SB]-72 £3,050.00 60 £155,550.00
	of which Digital Marketing [AllocRef_SB]-115 £2,750.00 60 £150,150.00
	of which Plant Operator Skills Bootcamp 2 [AllocRef_SB]-240 £1,200.00 40 £40,800.00
    of which OTP Operative [AllocRef_SB]-242 £2,750.00 60 £150,150.00
    of which New Entrant - Possession Management [AllocRef_SB]-243 £2,750.00 60 £150,150.00
    of which Project Controls [AllocRef_SB]-244 £2,750.00 60 £150,150.00
    of which Cloud with Cyber [AllocRef_SB]-245 £2,750.00 60 £150,150.00
    of which Renewable Energy Electrical Installer [AllocRef_SB]-246 £2,750.00 60 £150,150.00
    of which Creative Computing [AllocRef_SB]-247 £2,750.00 60 £150,150.00
    of which Leadership & Management [AllocRef_SB]-248 £2,750.00 60 £150,150.00
    of which Plastering inc Internal Thermal Insulation [AllocRef_SB]-249 £2,750.00 60 £150,150.00
    of which Brick inc External Thermal Insulation [AllocRef_SB]-250 £2,750.00 60 £150,150.00
    Total Funding for this contract: £1,951,080.00
    Summary of Funding – Page 1

    Agreement Type Contract for Services
    Funding Period 1 August 2022 to 30 September 2023
    Between the Secretary of State for Education
    And 10018001 Co Ltd
    Funding for Skills Bootcamps Wave 3
    Master Contract Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    Ceri D’Mello, Deputy Director, Head of Commercial – Skills Category Commercial Directorate,
    Operations Group
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service
    between:
    10018001 Co Ltd THE SECRETARY OF STATE FOR
    46 The Avenue EDUCATION
    Bournemouth DEPARTMENT FOR EDUCATION
    Dorset 20 GREAT SMITH STREET
    AND
    BH9 2UW LONDON
    SW1P 3BT
    Company No: AA018001
    Hereinafter called Hereinafter called
    the “Contractor” the “DFE”
    each a “Party” and together the “Parties”.
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 2
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 40
    
    Schedule 1
    The Specification
    Skills Bootcamps Wave 3 Schedule 1 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 1 Version 1 (August 2022) - Page 12
    
    Schedule 2
    Financials
    Payment triggers
    Learners not currently in Completion of 5 Successful completion Recording of a successful
    Skills Bootcamps Wave 3 Schedule 2 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 2 Version 1 (August 2022) - Page 4
    
    Schedule 3
    Skills Bootcamps Wave 3 Schedule 3 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 7 Version 1 (August 2022) - Page 1
    """

    # There should not be a Funding Agreement
    And   the pdf file does not contain the following text
    """
    Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018001_[ContractNo]_v1.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S001.pdf'

    
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
    | 10018001 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 30/09/2023      | ?             |
    | 10018001 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 30/09/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-01 09:12:35.000 |
	


	
#    # Check ADP
#
#    # Check all activity has completed
#    When  there are no messages left in the system
#
#    # Check Planned data on the ADP feed for Aug-22
#    Then  the Allocation Delivery Monitoring Service atom feed contains the following Planned data
#    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume | 
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 72              | 202208 | 155550.00	  | 60            |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 115             | 202208 | 150150.00	  | 60            |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 189             | 202208 | 184230.00	  | 60            |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 238             | 202208 | 23000.00	  | 100           |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 239             | 202208 | 46000.00	  | 23            |
#    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SB]    | 240             | 202208 | 40800.00	  | 40            |
#


    # Add actuals to the contract for SB2022

    # Change the date
    Given the override date is '04/09/2022'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018001'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2022 (Four deliverables)
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode  | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | SB             | SB01                  | ORG0018001     | CM             | 202208 | SB2022   	             | [AllocRef_SB]            | W3L1       | 72              | 0            | 8229.83     |
    | SB             | SB01                  | ORG0018001     | CM             | 202208 | SB2022           	     | [AllocRef_SB]            | W3L1       | 115             | 0            | 547.07      |
    | SB             | SB01                  | ORG0018001     | CM             | 202208 | SB2022             	 | [AllocRef_SB]            | W3L1       | 189             | 0            | 552.44      |
    | SB             | SB01                  | ORG0018001     | CM             | 202208 | SB2022              	 | [AllocRef_SB]            | W3L1       | 238             | 0            | 1002.62     |
    | SB             | SB01                  | ORG0018001     | CM             | 202208 | SB2022              	 | [AllocRef_SB]            | W3L1       | 239             | 0            | 648.52      |
    | SB             | SB01                  | ORG0018001     | CM             | 202208 | SB2022              	 | [AllocRef_SB]            | W3L1       | 240             | 0            | 1648.52      |
	| SB             | SB01                  | ORG0018001     | CM             | 202208 | SB2022              	 | [AllocRef_SB]            | W3L1       | 242             | 0            | 1648.52      |
    | SB             | SB01                  | ORG0018001     | CM             | 202208 | SB2022              	 | [AllocRef_SB]            | W3L1       | 243             | 0            | 1648.52      |
    | SB             | SB01                  | ORG0018001     | CM             | 202208 | SB2022              	 | [AllocRef_SB]            | W3L1       | 244             | 0            | 1648.52      |
    | SB             | SB01                  | ORG0018001     | CM             | 202208 | SB2022              	 | [AllocRef_SB]            | W3L1       | 245             | 0            | 1648.52      |
    | SB             | SB01                  | ORG0018001     | CM             | 202208 | SB2022              	 | [AllocRef_SB]            | W3L1       | 246             | 0            | 1648.52      |
    | SB             | SB01                  | ORG0018001     | CM             | 202208 | SB2022              	 | [AllocRef_SB]            | W3L1       | 247             | 0            | 1648.52      |
    | SB             | SB01                  | ORG0018001     | CM             | 202208 | SB2022              	 | [AllocRef_SB]            | W3L1       | 248             | 0            | 1648.52      |
    | SB             | SB01                  | ORG0018001     | CM             | 202208 | SB2022              	 | [AllocRef_SB]            | W3L1       | 249             | 0            | 1648.52      |
    | SB             | SB01                  | ORG0018001     | CM             | 202208 | SB2022              	 | [AllocRef_SB]            | W3L1       | 250             | 0            | 1648.52      |

    
    Then wait '10' seconds

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SB]      | 72              | 8229.83   | 8229.83  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 115             | 547.07    | 547.07   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 189             | 552.44    | 552.44   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 238             | 1002.62   | 1002.62  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 239             | 648.52    | 648.52   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 240             | 1648.52   | 1648.52  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 242             | 1648.52   | 1648.52  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 243             | 1648.52   | 1648.52  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 244             | 1648.52   | 1648.52  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 245             | 1648.52   | 1648.52  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 246             | 1648.52   | 1648.52  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 247             | 1648.52   | 1648.52  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 248             | 1648.52   | 1648.52  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 249             | 1648.52   | 1648.52  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 250             | 1648.52   | 1648.52  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 



    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SB]      | 72              | 8229.83   | 8229.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 115             | 547.07    | 547.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 189             | 552.44    | 552.44   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 238             | 1002.62   | 1002.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 239             | 648.52    | 648.52   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 240             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 242             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 243             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 244             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 245             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 246             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 247             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 248             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 249             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 250             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

   #                                                       £ 27465.68

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SB]      | 72              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 115             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 189             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 238             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 239             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 240             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 242             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 243             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 244             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 245             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 246             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 247             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 248             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 249             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 250             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SB]      | 72              | 8229.83   | 8229.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 115             | 547.07    | 547.07   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 189             | 552.44    | 552.44   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 238             | 1002.62   | 1002.62  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 239             | 648.52    | 648.52   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 240             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 242             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 243             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 244             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 245             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 246             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 247             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 248             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 249             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 250             | 1648.52   | 1648.52  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

  #                                                         £ 27465.68



    # Payment Batch for SB2022(PoA)

    # Change the date
    Given the override date is '08/09/2022 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'SB2022' AccountingPaymentPeriod '202205' CensusEndDate '08/09/2022' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_SB]            | 202208 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | SB2022               		 | 202208               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | SB2022                 	 | 202208               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SB2022' PaymentPeriod '202205' CensusEndDate '08/09/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A636.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'SB2022' PaymentPeriod '202205' CensusEndDate '08/09/2022' and LinkCodeSuffix 'A' includes the following values
#    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue   | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    | SB                     | 2022          | 05             | 08          | ?       | [AllocRef_SB]     | 27465.68          | RECONCILIATION   | Skills Bootcamps       | 2022-09-20 | 2022-08-01   | 2027-07-31 | ?              | 10018001 | 101139     |
#

    # Check the RECONCILIATION subnominal aggregations in CRM
    #And   the Reconciliation Subnominal Amounts are calculated as follows
    #| UKPRN    | ContractNumber | AllocationRef     | ReconciliationSubnominal | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    | Apr-23    | May-23    | Jun-23    | Jul-23    | Aug-23    | Sep-23    |
    #| 10018001 | [ContractNo]   | [AllocRef_SB]     | 101139                   | 22520.12  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 



    


    # Update the timestamp on the TaC template to a date after contract v2 was created on 22/03/2023 (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    Given the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SB_W3_TAC_2022-08-01.docx                       | 2023-03-14 12:00:00.000 | 
 #  | SB_W3_S1_2022-08-01.docx                        | 2022-06-21 12:00:00.000 | 
 #  | SB-PAA_W3_S1_2022-08-01.docx                    | 2022-06-21 12:00:00.000 | 
 #  | SB_W3_S2_2022-08-01.docx                        | 2022-06-21 12:00:00.000 | 
 #  | SB-PAA_W3_S2_2022-08-01.docx                    | 2022-06-21 12:00:00.000 | 
 #  | SB_W3_S3ON_2022-08-01.docx                      | 2022-06-21 12:00:00.000 | 




    # Extension of SB contract to Sep 2024

    # Change the date
    Given the override date is '15/03/2023'

    # Bulk file (UoP = W3L1)
    And   there are no files prefixed '10018001' in the Sharepoint 'SB-2022-Input-Appendices' folder
    And   there are no files prefixed 'SB SB 2022 01032023094413 v3_S001b' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SB SB 2022 01032023094413 v3_S001b' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SB SB 2022 01032023094413 v3_S001b' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SB SB 2022 01032023094413 v3_S001b' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SB SB 2022 01032023094413 v3_S001b.xlsx' exists in the Datafiles folder and UKPRN '10018001' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018001' for FundingType 'SB' and period '2022'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    Then  the file named '10018001_[ContractNo]_v2.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10018001 Co Ltd UKPRN: 10018001
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 30/09/2024
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £4,203,360.00
    of which Data Analyst [AllocRef_SB]-72 £120.00 208 £24,960.00
    of which Digital Marketing [AllocRef_SB]-115 £140.00 1,560 £218,400.00
    of which Software Development [AllocRef_SB]-189 £3,450.00 260 £897,000.00
    of which Bay Electech - Electronic Skills Programme 2 [AllocRef_SB]-238 £1,000.00 2,600 £307,000.00
    of which Trade Skills Development Centre [AllocRef_SB]-239 £2,000.00 598 £1,196,000.00
    of which Plant Operator Skills Bootcamp 2 [AllocRef_SB]-240 £150.00 1,040 £156,000.00
    of which OTP Operative [AllocRef_SB]-242 £150.00 1,040 £156,000.00
    of which New Entrant - Possession Management [AllocRef_SB]-243 £150.00 1,040 £156,000.00
    of which Project Controls [AllocRef_SB]-244 £150.00 1,040 £156,000.00
    of which Cloud with Cyber [AllocRef_SB]-245 £150.00 1,040 £156,000.00
    of which Renewable Energy Electrical Installer [AllocRef_SB]-246 £150.00 1,040 £156,000.00
    of which Creative Computing [AllocRef_SB]-247 £150.00 1,040 £156,000.00
    of which Leadership & Management [AllocRef_SB]-248 £150.00 1,040 £156,000.00
    of which Plastering inc Internal Thermal Insulation [AllocRef_SB]-249 £150.00 1,040 £156,000.00
    of which Brick inc External Thermal Insulation [AllocRef_SB]-250 £150.00 1,040 £156,000.00
    Total Funding for this contract: £4,203,360.00
    Summary of Funding – Page 1

    Agreement Type Contract for Services
    Funding Period 1 August 2022 to 30 September 2024
    """

    # There should not be a Funding Agreement
    And   the pdf file does not contain the following text
    """
    Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018001_[ContractNo]_v2.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S001b.pdf'


    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    

    
    # Add a new deliverable

    # Change the date
    Given the override date is '10/04/2023'

    # Bulk file (UoP = W3L1)
    And   there are no files prefixed '10018001' in the Sharepoint 'SB-2022-Input-Appendices' folder
    And   there are no files prefixed 'SB SB 2022 10042023094413 v3_S001c' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SB SB 2022 10042023094413 v3_S001c' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SB SB 2022 10042023094413 v3_S001c' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SB SB 2022 10042023094413 v3_S001c' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SB SB 2022 10042023094413 v3_S001c.xlsx' exists in the Datafiles folder and UKPRN '10018001' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018001' for FundingType 'SB' and period '2022'

    # Check the contents of the Appendices 
    Then  the file named '10018001_[ContractNo]_v3.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10018001 Co Ltd UKPRN: 10018001
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 30/09/2024
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £4,710,360.00
    of which Data Analyst [AllocRef_SB]-72 £120.00 208 £24,960.00
    of which Digital Marketing [AllocRef_SB]-115 £140.00 1,560 £218,400.00
    of which Software Development [AllocRef_SB]-189 £3,450.00 260 £897,000.00
    of which Bay Electech - Electronic Skills Programme 2 [AllocRef_SB]-238 £1,000.00 2,600 £307,000.00
    of which Trade Skills Development Centre [AllocRef_SB]-239 £2,000.00 598 £1,196,000.00
    of which Plant Operator Skills Bootcamp 2 [AllocRef_SB]-240 £150.00 1,040 £156,000.00
    of which Cloud Computing - Architecting in the Cloud [AllocRef_SB]-5 £1,000.00 507 £507,000.00
    Total Funding for this contract: £4,710,360.00
    Summary of Funding – Page 1
    """

    # There should not be a SoF
    And   the pdf file does not contain the following text
    """
    Agreement Type Contract for Services
    """

 
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018001_[ContractNo]_v3.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S001c.pdf'

    
    

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '3'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'



    # Add actuals to the contract for SB2022

    # Change the date
    Given the override date is '04/10/2023'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018035'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS



    # Pull actuals from DC for Sep 2023 (Four deliverables)
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode  | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode   | DeliverableCode | ActualVolume | ActualValue |
    | SB             | SB14                  | ORG0018001     | CM             | 202309 | SB2022              	 | [AllocRef_SB]            | W3L1       | 72              | 0            | 1002.62     |
    | SB             | SB14                  | ORG0018001     | CM             | 202309 | SB2022              	 | [AllocRef_SB]            | W3L1       | 115             | 0            | 648.52      |
    | SB             | SB14                  | ORG0018001     | CM             | 202309 | SB2022              	 | [AllocRef_SB]            | W3L1       | 189             | 0            | 1648.52     |
	| SB             | SB14                  | ORG0018001     | CM             | 202309 | SB2022              	 | [AllocRef_SB]            | W3L1       | 238             | 0            | 1648.52     |
    | SB             | SB14                  | ORG0018001     | CM             | 202309 | SB2022           	     | [AllocRef_SB]            | W3L1       | 239             | 0            | 547.07      |
    | SB             | SB14                  | ORG0018001     | CM             | 202309 | SB2022             	 | [AllocRef_SB]            | W3L1       | 240             | 0            | 552.44      |
    | SB             | SB14                  | ORG0018001     | CM             | 202309 | SB2022   	             | [AllocRef_SB]            | W3L1       | 242             | 0            | 8229.83     |

    Then wait '10' seconds

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef     | DeliverableCode | Total     | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   |
    | [ContractNo]   | [AllocRef_SB]     | 72              | 1002.62   | 1002.62  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]     | 115             | 648.52    | 648.52   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | [ContractNo]   | [AllocRef_SB]     | 189             | 1648.52   | 1648.52  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]     | 238             | 1648.52   | 1648.52  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        |
    | [ContractNo]   | [AllocRef_SB]     | 239             | 547.07    | 547.07   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]     | 240             | 552.44    | 552.44   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]     | 242             | 8229.83   | 8229.83  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

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


    # Payment Batch for SB2022(PoA)

    # Change the date
    Given the override date is '09/10/2023 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'SB2022' AccountingPaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_SB]            | 202309 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | SB2022               		 | 202309               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | SB2022                 	 | 202309               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SB2022' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S001.xml'

#    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'SB2023' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' includes the following values
#    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue   | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    | SB                     | 2023          | 06             | 09          | ?       | [AllocRef_SB]     | 14277.52          | RECONCILIATION   | Skills Bootcamps       | 2023-10-19 | 2022-08-01   | 2024-09-30 | ?              | 10018035 | 101139     |
#


    # Check the RECONCILIATION subnominal aggregations in CRM
    #And   the Reconciliation Subnominal Amounts are calculated as follows
    #| UKPRN    | ContractNumber | AllocationRef     | ReconciliationSubnominal | Sep-23    | Oct-23    | Nov-23    | Dec-23    | Jan-24    | Feb-24    | Mar-24    | Apr-24    | May-24    | Jun-24    | Jul-24    | Aug-24    | 
    #| 10018035 | [ContractNo]   | [AllocRef_SB]     | 101139                   | 22520.12  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 



    # Create Consolidated Payment Summary rpt
   
    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    #Given the override date is '06/01/2023 10:00'

#   Given there are no files prefixed '2023-10 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
#   
#   When  a Consolidated Payment Summary Report is created in Sharepoint for '11/10/2023'
#    # Check the above report manually
#


  
    # Extension of SB contract to Jul 2025

    # Change the date
    Given the override date is '15/03/2025'

    # Bulk file (UoP = W3L1)
    And   there are no files prefixed '10018001' in the Sharepoint 'SB-2022-Input-Appendices' folder
    And   there are no files prefixed 'SB SB 2022 21052025094413 v3_S001d' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SB SB 2022 21052025094413 v3_S001d' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SB SB 2022 21052025094413 v3_S001d' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SB SB 2022 21052025094413 v3_S001d' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SB SB 2022 21052025094413 v3_S001d.xlsx' exists in the Datafiles folder and UKPRN '10018001' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018001' for FundingType 'SB' and period '2022'

#    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
#    Then  the file named '10018001_[ContractNo]_v4.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING
#    Organisation Name: 10018001 Co Ltd UKPRN: 10018001
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

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018001_[ContractNo]_v4.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S001d.pdf'


    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    

	