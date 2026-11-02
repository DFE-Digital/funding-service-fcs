Feature: To Retest the Cost Per Learner bug fix for SkillBootcamps which becomes zero during Amendment


@AcceptanceTest @Complete
Scenario: S002 Bulk load a Skills Bootcamp  (SB2022) contract for 22/23, NFA Amend(Notify), Verify docs and Publish. Withdraw v2 contract, NFA Amend(Vary), verify V3 contract. 
    Given there are no allocations marked as Under Termination for UKPRN '10018002' 
    And   there are no terminated or closed allocations for UKPRN '10018002' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018002' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018002' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018002' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP           |
    | SB2022        |


    # Set the base timestamp for each of the 7 SB document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName          | UploadTimestamp         |
    | FA_SB2022_2022-09-01.docx     | 2022-05-20 10:00:00.000 |
    | SB_W3_S1_2022-08-01.docx		| 2022-05-20 10:00:00.000 |
    | SB_W3_S2_2022-08-01.docx      | 2022-05-20 10:00:00.000 |
    | SB_W3_S3ON_2022-08-01.docx    | 2022-05-20 10:00:00.000 |
    | SB_W3_TAC_2022-08-01.docx     | 2022-05-20 10:00:00.000 |
    | SOF_SB_2022-08-01.docx		| 2022-05-20 10:00:00.000 | 
	| SOF_SB_2022-09-01.docx		| 2022-05-20 10:00:00.000 | 



    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018002'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018002' 
    And   there is no caseload advisor for UKPRN '10018002' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018002 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018002' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018002 Co Ltd' with UKPRN '10018002' and OrgId 'ORG0018002' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018002 | 118002 | 10018002 Co Ltd | 0              | In Administration     | Yes           | AA018002      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018002 |





    # Change the date
    Given the override date is '01/07/2022'

    # Bulk file (UoP = W3L1)
    And   there are no files prefixed '10018002' in the Sharepoint 'SB-2022-Input-Appendices' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S002' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S002' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S002' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SB SB 2022 15072022094413 v3_S002' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SB SB 2022 15072022094413 v3_S002.xlsx' exists in the Datafiles folder and UKPRN '10018002' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018002' for FundingType 'SB' and period '2022'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    Then  the file named '10018002_[ContractNo]_v1.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10018002 Co Ltd UKPRN: 10018002
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 30/09/2023
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £609,730.00
    of which Bay Electech - Electronic Skills Programme 2 [AllocRef_SB]-238 £1,000.00 100 £23,000.00
    of which Trade Skills Development Centre [AllocRef_SB]-239 £2,000.00 23 £46,000.00
	of which Software Development [AllocRef_SB]-189 £3,450.00 60 £184,230.00
	of which Data Analyst [AllocRef_SB]-72 £3,050.00 60 £155,550.00
	of which Digital Marketing [AllocRef_SB]-115 £2,750.00 60 £150,150.00
	of which Plant Operator Skills Bootcamp 2 [AllocRef_SB]-240 £1,200.00 40 £40,800.00
    of which Track Maintenance [AllocRef_SB]-241 £100.00 90 £10,000.00
    Total Funding for this contract: £609,730.00
    Summary of Funding – Page 1

    Agreement Type Contract for Services
    Funding Period 1 August 2022 to 30 September 2023
    Between the Secretary of State for Education
    And 10018002 Co Ltd
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
    10018002 Co Ltd THE SECRETARY OF STATE FOR
    46 The Avenue EDUCATION
    Bournemouth DEPARTMENT FOR EDUCATION
    Dorset 20 GREAT SMITH STREET
    AND
    BH9 2UW LONDON
    SW1P 3BT
    Company No: AA018002
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
    And   Sharepoint file '10018002_[ContractNo]_v1.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S002.pdf'

    
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
    | 10018002 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 30/09/2023      | ?             |
    | 10018002 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 30/09/2023      | ?             |

    

    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-04 09:12:35.000 |


	
    # T&C document changes then Notification amendment issued 

    # Update timestamp on SB TAC document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName          | UploadTimestamp         |
    | SB_W3_TAC_2022-08-01.docx	    | 2022-07-24 22:22:22.000 | 
	
	


    # Change the date to one several days after the date of the revised TAC template
    Given the override date is '28/07/2022'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial notification contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018002 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2022        | 30/09/2023      | Notification  |
    | 10018002 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2022        | 30/09/2023      | ?             |
    | 10018002 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 30/09/2023      | ?             |



    # Retrieve parameters for the Contracting Org
   #And  I retrieve the latest EFA contract details from CRM for provider '10018002' for FundingType 'SB' and period '2022' and Delivery Organisation '10017176'
    And   I retrieve the latest contract details from CRM for provider '10018002' for FundingType 'SB' and period '2022'

    # Check that only the SoF is produced from the following 'set' of six docs for contract v2
    #   Summary of Funding, Main Terms and Conditions (TAC), Schedule 1, Schedule 2, Funding Agreement, Schedule 3on
    And   the file named '10018002_[ContractNo]_v2.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
	Organisation Name: 10018002 Co Ltd UKPRN: 10018002
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 30/09/2023
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £609,730.00
	of which Data Analyst [AllocRef_SB]-72 £3,050.00 60 £155,550.00
	of which Digital Marketing [AllocRef_SB]-115 £2,750.00 60 £150,150.00
	of which Software Development [AllocRef_SB]-189 £3,450.00 60 £184,230.00
    of which Bay Electech - Electronic Skills Programme 2 [AllocRef_SB]-238 £1,000.00 100 £23,000.00
    of which Trade Skills Development Centre [AllocRef_SB]-239 £2,000.00 23 £46,000.00
	of which Plant Operator Skills Bootcamp 2 [AllocRef_SB]-240 £1,200.00 40 £40,800.00
    of which Track Maintenance [AllocRef_SB]-241 £100.00 90 £10,000.00
    Total Funding for this contract: £609,730.00
    Summary of Funding – Page 1
    """


     # There should not be a T&C document
	And   the pdf file does not contain the following text
    """
    Agreement Type Contract for Services
    """
    
    # There should not be a Schedule 1 document
	And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING 
    """

    # There should not be a Schedule 2 document
	And   the pdf file does not contain the following text
    """
    SCHEDULE 2: PAYMENT
    """
    
    # There should not be a Funding Agreement document
	And   the pdf file does not contain the following text
    """
    Funding Agreement
    """

    # There should not be a Schedule 3ON document
	And   the pdf file does not contain the following text
    """
	SCHEDULE 3: CHANGE CONTROL PROCEDURE
    """


    # Save a copy of the output
    Then  Sharepoint file '10018002_[ContractNo]_v2.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S002v2.pdf'




    # Publish then withdraw the contract
    
    # Change the date
    Given the override date is '02/10/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Withdraw v2 of the contract 
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'SB test withdrawal' by 'FCS1 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018002 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2022        | 30/09/2023      | Notification  |
    | 10018002 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 30/09/2023      | ?             |
    | 10018002 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 30/09/2023      | ?             |




    # Execute a NON-FINANCIAL amendment on v2 to create v3

    # Change the date
    Given the override date is '05/10/2022'

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018002'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018002 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2022        | 30/09/2023      | Variation     |
    | 10018002 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2022        | 30/09/2023      | Notification  |
    | 10018002 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2022        | 30/09/2023      | ?             |
    | 10018002 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 30/09/2023      | ?             |


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10018002' for FundingType 'SB' and period '2022' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10018002' for FundingType 'SB' and period '2022'

    # Check the contents of the Appendices 
    #  Note1: If template timestamps don't change then only the SOF is produced 
    #  Note2: If template timestamps change on TAC & S1 then the SOF, TAC and S1 are produced
    Then the file named '10018002_[ContractNo]_v3.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
	Organisation Name: 10018002 Co Ltd UKPRN: 10018002
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 30/09/2023
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £609,730.00
	of which Data Analyst [AllocRef_SB]-72 £3,050.00 60 £155,550.00
	of which Digital Marketing [AllocRef_SB]-115 £2,750.00 60 £150,150.00
	of which Software Development [AllocRef_SB]-189 £3,450.00 60 £184,230.00
    of which Bay Electech - Electronic Skills Programme 2 [AllocRef_SB]-238 £1,000.00 100 £23,000.00
    of which Trade Skills Development Centre [AllocRef_SB]-239 £2,000.00 23 £46,000.00
	of which Plant Operator Skills Bootcamp 2 [AllocRef_SB]-240 £1,200.00 40 £40,800.00
    of which Track Maintenance [AllocRef_SB]-241 £100.00 90 £10,000.00
    Total Funding for this contract: £609,730.00
    Summary of Funding – Page 1

    """

    # Save a copy of the output
    Then  Sharepoint file '10018002_[ContractNo]_v3.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S002v3.pdf'


    # Tidy Up
    And   the override date is reset



@AcceptanceTest @Complete
Scenario: S004 Create and Update draft v1 2223 SB-PAA Contract. Publish and Approve. Bulk amend variation v2 and verify docs (CostPerLearner). 
    Given there are no allocations marked as Under Termination for UKPRN '10018004' 
    And   there are no terminated or closed allocations for UKPRN '10018004' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018004' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018004' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | SB-004  	    |
	| SBA-004       |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | SB-004  	    |
	| SBA-004       |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | SB2022            |
	| SB-PAA2022        |
	

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | SBP-004        | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018004'

#    # Set the 'base' timestamp for all SBP document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
#    And   the following document templates have Upload timestamps as indicated
#    | DocumentTemplateName          | UploadTimestamp         |
#    | FA_SB2022_2022-09-01.docx     | 2022-05-20 10:00:00.000 |
#    | SB_W3_S1_2022-08-01.docx		| 2022-05-20 10:00:00.000 |
#    | SB_W3_S2_2022-08-01.docx      | 2022-05-20 10:00:00.000 |
#    | SB_W3_S3ON_2022-08-01.docx    | 2022-05-20 10:00:00.000 |
#    | SB_W3_TAC_2022-08-01.docx     | 2022-05-20 10:00:00.000 |
#    | SOF_SB_2022-08-01.docx		| 2022-05-20 10:00:00.000 | 
#	| SOF_SB_2022-09-01.docx		| 2022-05-20 10:00:00.000 | 
#    | SB-PAA_W3_S1_2022-08-01.docx	| 2022-05-20 10:00:00.000 |
#    | SB-PAA_W3_S2_2022-08-01.docx  | 2022-05-20 10:00:00.000 |
#


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10018004' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018004 Co Ltd' with UKPRN '10018004' and OrgId 'ORG0018004' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10018004' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018004 | 118004 | 10018004 Co Ltd | 0              | Locked Restructure    | Yes           | AA018004      | ?             | 96 West Yard           | Camden Lock Place      | Chalk Farm Road        | London                 | ?                      | ?                      | NW1 8AF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018004 |




    # Change the date
    Given the override date is '22/07/2022'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10018004 | 10018004 Co Ltd      | ESFA-004             | SBP-004        | 1                     | 01/08/2022        | 31/07/2023      | 19607.00      |                                       | Contract for Services (SB Wave 3) 	     | 2022   | New          | ORG0018004 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018004 | SBP-004	    | SB-004   	    | SB     	        | SB2022        	      | AY                      | 01/08/2022          | 31/07/2023        | 19607.00        | Wave 3 Lot 7 - Green Skills             | W3L7       |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10018004 | SBP-004        | SB-004        | 1               | 0                     | 19607.00  | 10877.00  | 8730.00   | 138.00   | 1126.00  | 1862.00  | 637.00   | 612.00   | 3404.00  | 2431.00  | 667.00   | 2258.00  | 3152.00  | 469.00   | 2851.00  | Advanced Manufacturing - Advanced Engineering and Materials Testing| New       |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | SBP-004       | 1                     | 0                        | 2022-07-22 15:43:08.000 |


    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018004 | SBP-004            | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
    | 10018004 | ESFA-004           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'SBP-004'

    


    # Bulk Update Draft the SB 22/23 contract and check docs

    Given the override date is '15/08/2022'

    # Bulk file 'Revised New' amendment
    And   there are no files prefixed '10018004' in the Sharepoint 'SB-2022-Input-Appendices' folder
    And   there are no files prefixed 'SB SB 2022 28082022094413 v4_S004a' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SB SB 2022 28082022094413 v4_S004a' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SB SB 2022 28082022094413 v4_S004a' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SB SB 2022 28082022094413 v4_S004a' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SB SB 2022 28082022094413 v4_S004a.xlsx' exists in the Datafiles folder and UKPRN '10018004' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018004' for FundingType 'SB' and period '2022'

    # Check the contents of the Appendices (All doc parts should be present)
    Then  the file named '10018004_SBP-004_v1.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
    """ 
    SUMMARY OF FUNDING
    Organisation Name: 10018004 Co Ltd UKPRN: 10018004
    Master Contract Number: ESFA-004 Start Date: 01/08/2022 End Date: 31/07/2023
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £133,643.00
    of which Solar/Renewable Electrician [AllocRef_SBA]-17 £100.00 606 £53,863.00
    of which Analysing Data (leading to Data Technician) [AllocRef_SBA]-18 £150.00 1,326 £42,643.00
    of which Pathway to Apprenticeship [AllocRef_SBA]-19 £200.00 2,046 £37,137.00
    Total Funding for this contract: £133,643.00
    Summary of Funding – Page 1
    Agreement Type Contract for Services
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And 10018004 Co Ltd
    Funding for Skills Bootcamps Wave 3
    Master Contract Number ESFA-004
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    Ceri D’Mello, Deputy Director, Head of Commercial – Skills Category Commercial Directorate,
    Operations Group
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service
    between:
    10018004 Co Ltd THE SECRETARY OF STATE FOR
    96 West Yard EDUCATION
    Camden Lock Place DEPARTMENT FOR EDUCATION
    Chalk Farm Road 20 GREAT SMITH STREET
    AND
    London LONDON
    NW1 8AF SW1P 3BT
    Company No: AA018004
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 2
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | SBP-004        | 1                     | 0                        | 2022-08-15 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018004_SBP-004_v1.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S004_v1.pdf'

    

    # Publish and approve v1

    Given the override date is '17/08/2022'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'SBP-004'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-004' and ContractNumber 'SBP-004' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'SBP-004' has a substatus of 'Approved'
      


      
    # Bulk amend the SB alloc 22/23 contract and check v2 docs

    Given the override date is '05/09/2022'

    # Bulk file 'Revised New' amendment
    And   there are no files prefixed '10018004' in the Sharepoint 'SB-2022-Input-Appendices' folder
    And   there are no files prefixed 'SB SB 2022 05092022094413 v4_S004b' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SB SB 2022 05092022094413 v4_S004b' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SB SB 2022 05092022094413 v4_S004b' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SB SB 2022 05092022094413 v4_S004b' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SB SB 2022 05092022094413 v4_S004b.xlsx' exists in the Datafiles folder and UKPRN '10018004' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018004' for FundingType 'SB' and period '2022'

    # Check the contents of the Appendices (All doc parts should be present)
    Then  the file named '10018004_SBP-004_v2.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
    """ 
    SUMMARY OF FUNDING
    Organisation Name: 10018004 Co Ltd UKPRN: 10018004
    Master Contract Number: ESFA-004 Start Date: 01/08/2022 End Date: 31/07/2023
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £669,646.87
    of which Trade Skills Development Centre [AllocRef_SB]-239 £100.00 911 £327,622.93
    of which Plant Operator Skills Bootcamp 2 [AllocRef_SB]-240 £150.00 911 £327,622.93
    of which Track Maintenance [AllocRef_SB]-241 £150.00 1,000 £14,401.01
    Skills Bootcamps £133,643.00
    of which Solar/Renewable Electrician [AllocRef_SBA]-17 £100.00 606 £53,863.00
    of which Analysing Data (leading to Data Technician) [AllocRef_SBA]-18 £150.00 1,326 £42,643.00
    of which Pathway to Apprenticeship [AllocRef_SBA]-19 £200.00 2,046 £37,137.00
    Total Funding for this contract: £803,289.87
    Summary of Funding – Page 1
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | SBP-004        | 2                     | 0                        | 2022-09-15 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018004_SBP-004_v2.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S004_v2.pdf'

    

