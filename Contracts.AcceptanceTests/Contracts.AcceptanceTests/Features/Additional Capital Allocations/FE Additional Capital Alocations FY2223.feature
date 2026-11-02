Feature: FE Additional Capital Alocations FY2223


@AcceptanceTest @Withdraw25072024
Scenario: S009 Bulk load a FE-ACA 2223 contract to validate new deliverable. Publish and approve. Check docs. Push actuals. Generate payments.
    Given there are no allocations marked as Under Termination for UKPRN '10018009' 
    And   there are no terminated or closed allocations for UKPRN '10018009' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018009' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10018009' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018009' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP           |
    | FE-ACA2223    |



    # Set the base timestamp for each of the  document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName          | UploadTimestamp         |
    | FA_FEACA2223_2022-04-01.docx  | 2022-02-20 10:00:00.000 |



    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018009'


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10018009' 
    And   there is no caseload advisor for UKPRN '10018009' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10018009 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10018009' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018009 Co Ltd' with UKPRN '10018009' and OrgId 'ORG0018009' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018009 | 118009 | 10018009 Co Ltd | 0              | In Administration     | Yes           | AA018009      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018009 |





    # Change the date
    Given the override date is '01/03/2022'

    # Bulk file (UoP = W3L1)
    And   there are no files prefixed '10018009' in the Sharepoint 'FE-ACA-2223-Input-Appendices' folder
    And   there are no files prefixed 'FE-ACA FY 2223 30102022164257 v1_S009' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'FE-ACA FY 2223 30102022164257 v1_S009' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'FE-ACA FY 2223 30102022164257 v1_S009' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'FE-ACA FY 2223 30102022164257 v1_S009' in the Sharepoint 'Reports' folder
    And   spreadsheet 'FE-ACA FY 2223 30102022164257 v1_S009.xlsx' exists in the Datafiles folder and UKPRN '10018009' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018009' for FundingType 'FE-ACA' and period '2223'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    Then  the file named '10018009_[ContractNo]_v1.pdf' in Sharepoint location 'FE-ACA-2223-Input-Appendices' contains the following lines in order
    """
Annex H – Grant payment schedule
Provider: 10018009 Co Ltd UKPRN: 10018009
Master Contract Number: [MasterContractNo] Start Date: 01/04/2022 End Date: 31/03/2023
Contract Ref: [AllocRef_FEAC]
Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
Further Education Additional Capital Allocations £42,534 £3,120 £1,961 £1,389 £1,474 £1,220 £1,984 £1,642 £1,570 £1,174 £9,000 £9,000 £9,000
Total Funding £42,534 £3,120 £1,961 £1,389 £1,474 £1,220 £1,984 £1,642 £1,570 £1,174 £9,000 £9,000 £9,000
Further Education Additional Capital Allocations– [AllocRef_FEAC] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018009_[ContractNo]_v1.pdf' in 'FE-ACA-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S009.pdf'

    
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
    | 10018009 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2022        | 31/03/2023      | ?             |
    | 10018009 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2022        | 31/03/2023      | ?             |



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
    | FA_FEACA2223_2022-04-01.docx  | 2022-07-24 22:22:22.000 | 
	



    # Change the date to one several days after the date of the revised TAC template
    Given the override date is '28/07/2022'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial notification contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018009 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2022        | 31/03/2023      | Notification  |
    | 10018009 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/04/2022        | 31/03/2023      | ?             |
    | 10018009 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2022        | 31/03/2023      | ?             |



    # Retrieve parameters for the Contracting Org
   #And  I retrieve the latest EFA contract details from CRM for provider '10018009' for FundingType 'FE-ACA' and period '2223' and Delivery Organisation '10017176'
    And   I retrieve the latest contract details from CRM for provider '10018009' for FundingType 'FE-ACA' and period '2223'


#/////
#    # Check that only the SoF is produced from the following 'set' of six docs for contract v2
#    #   Summary of Funding, Main Terms and Conditions (TAC), Schedule 1, Schedule 2, Funding Agreement, Schedule 3on
#    And   the file named '10018009_[ContractNo]_v2.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING
#	Organisation Name: 10018009 Co Ltd UKPRN: 10018009
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 30/09/2023
#    Allocation
#    Contract Ref Cost per Learner Number of Total Funding
#    Learners
#    (if fully-funded)
#    Skills Bootcamps £599,730.00
#	of which Data Analyst [AllocRef_SB]-72 £3,050.00 60 £155,550.00
#	of which Digital Marketing [AllocRef_SB]-115 £2,750.00 60 £150,150.00
#	of which Software Development [AllocRef_SB]-189 £3,450.00 60 £184,230.00
#    of which Bay Electech - Electronic Skills Programme 2 [AllocRef_SB]-238 £1,000.00 100 £23,000.00
#    of which Trade Skills Development Centre [AllocRef_SB]-239 £2,000.00 23 £46,000.00
#	of which Plant Operator Skills Bootcamp 2 [AllocRef_SB]-240 £1,200.00 40 £40,800.00
#    Total Funding for this contract: £599,730.00
#    Summary of Funding – Page 1
#
#    """
#
#     # There should not be a T&C document
#	And   the pdf file does not contain the following text
#    """
#    Agreement Type Contract for Services
#    """
#    
#    # There should not be a Schedule 1 document
#	And   the pdf file does not contain the following text
#    """
#    SCHEDULE 1: SPECIFICATION & MONITORING 
#    """
#
#    # There should not be a Schedule 2 document
#	And   the pdf file does not contain the following text
#    """
#    SCHEDULE 2: PAYMENT
#    """
#    
#    # There should not be a Funding Agreement document
#	And   the pdf file does not contain the following text
#    """
#    Funding Agreement
#    """
#
#    # There should not be a Schedule 3ON document
#	And   the pdf file does not contain the following text
#    """
#	SCHEDULE 3: CHANGE CONTROL PROCEDURE
#    """
#////

    # Save a copy of the output
    Then  Sharepoint file '10018009_[ContractNo]_v2.pdf' in 'FE-ACA-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S009_v2.pdf'



    # Publish then withdraw the contract
    
    # Change the date
    Given the override date is '02/10/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Withdraw v2 of the contract 
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'FEACA test withdrawal' by 'FCS1 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018009 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/04/2022        | 31/03/2023      | Notification  |
    | 10018009 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2022        | 31/03/2023      | ?             |
    | 10018009 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2022        | 31/03/2023      | ?             |




    # Execute a NON-FINANCIAL amendment variation on v2 to create v3

    # Change the date
    Given the override date is '05/10/2022'

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018009'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018009 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2022        | 31/03/2023      | Variation     |
    | 10018009 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/04/2022        | 31/03/2023      | Notification  |
    | 10018009 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/04/2022        | 31/03/2023      | ?             |
    | 10018009 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2022        | 31/03/2023      | ?             |


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10018009' for FundingType 'SB' and period '2022' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10018009' for FundingType 'FE-ACA' and period '2223'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    Then  the file named '10018009_[ContractNo]_v3.pdf' in Sharepoint location 'FE-ACA-2223-Input-Appendices' contains the following lines in order
    """
Annex H – Grant payment schedule
Provider: 10018009 Co Ltd UKPRN: 10018009
Master Contract Number: [MasterContractNo] Start Date: 01/04/2022 End Date: 31/03/2023
Contract Ref: [AllocRef_FEAC]
Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
Further Education Additional Capital Allocations £42,534 £3,120 £1,961 £1,389 £1,474 £1,220 £1,984 £1,642 £1,570 £1,174 £9,000 £9,000 £9,000
Total Funding £42,534 £3,120 £1,961 £1,389 £1,474 £1,220 £1,984 £1,642 £1,570 £1,174 £9,000 £9,000 £9,000
Further Education Additional Capital Allocations– [AllocRef_FEAC] – Page 1 Ref (for internal use only):  [ContractNo] v3
    """



    # Save a copy of the output
    Then  Sharepoint file '10018009_[ContractNo]_v3.pdf' in 'FE-ACA-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S009_v3.pdf'


    # Tidy Up
    And   the override date is reset


@AcceptanceTest @Withdrawn20260521
Scenario: S010 Create and Update draft v1 FY2223 FE-ACA Contract. Publish and Approve. Bulk amend variation v2 and verify docs. Run payment batch and generate reports.
    Given there are no allocations marked as Under Termination for UKPRN '10018010' 
    And   there are no terminated or closed allocations for UKPRN '10018010' 
    And   there is no Contract, Task or Workflow data for UKPRN '10018010' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10018010' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | FEAC-8010     |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | FEAC-8010     |


    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | FE-ACA2223        |

	

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | FEACA-8010     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10018010'



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10018010' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018010 Co Ltd' with UKPRN '10018010' and OrgId 'ORG0018010' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10018010' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018010 | 118010 | 10018010 Co Ltd | 0              | In Administration     | Yes           | AA018010      | ?             | 96 West Yard           | Camden Lock Place      | Chalk Farm Road        | London                 | ?                      | ?                      | NW1 8AF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018010 |



    # Change the date
    Given the override date is '22/07/2022'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                              | Period | CRMIntent    | OrgId      |
    | 10018010 | 10018010 Co Ltd      | ESFA-18010           | FEACA-8010     | 1                     | 01/04/2022        | 31/03/2023      | 19607.00     |                                       | Contract for Services				        | 2223   | New          | ORG0018010 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName    | UoPCode  | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10018010 | FEACA-8010	    | FEAC-8010   	| FE-ACA     	    | FE-ACA2223        	  | FY                      | 01/04/2022          | 31/03/2023        | 19607.00        |            |        	|                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Apr-22   | May-22   | Jun-22   | Jul-22   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | DeliverableDescription            | CRMIntent    | DeliveryOrg |
    | 10018010 | FEACA-8010     | FEAC-8010     | 1             | 0                     | 19607.00  | 10877.00  | 8730.00   | 138.00   | 1126.00  | 1862.00  | 637.00   | 612.00   | 3404.00  | 2431.00  | 667.00   | 2258.00  | 3152.00  | 469.00   | 2851.00  | FE Additional Capital Allocations | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | FEACA-8010     | 1                     | 0                        | 2022-07-22 15:43:08.000 |


    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10018010 | FEACA-8010         | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2022        | 31/03/2023      | ?             |
    | 10018010 | ESFA-18010         | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2022        | 31/03/2023      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'FEACA-8010'

 


    # Bulk Update Draft the FE-ACA 22/23 contract and check docs

    Given the override date is '15/08/2022'

    # Bulk file 'Update Draft' amendment
    And   there are no files prefixed '10018010' in the Sharepoint 'FE-ACA-2223-Input-Appendices' folder
    And   there are no files prefixed 'FE-ACA FY 2223 30102022164257 v1_S010a' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'FE-ACA FY 2223 30102022164257 v1_S010a' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'FE-ACA FY 2223 30102022164257 v1_S010a' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'FE-ACA FY 2223 30102022164257 v1_S010a' in the Sharepoint 'Reports' folder
    And   spreadsheet 'FE-ACA FY 2223 30102022164257 v1_S010a.xlsx' exists in the Datafiles folder and UKPRN '10018010' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018010' for FundingType 'FE-ACA' and period '2223'

    # Check the contents of the Appendices (All doc parts should be present)
    Then  the file named '10018010_FEACA-8010_v1.pdf' in Sharepoint location 'FE-ACA-2223-Input-Appendices' contains the following lines in order
    """ 
    Annex H – Grant payment schedule
    Provider: 10018010 Co Ltd UKPRN: 10018010
    Master Contract Number: ESFA-18010 Start Date: 01/04/2022 End Date: 31/03/2023
    Contract Ref: FEAC-8010
    Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    Further Education Additional Capital Allocations £53,863 £4,208 £7,553 £3,359 £4,261 £3,666 £5,450 £5,939 £249 £3,529 £3,751 £5,195 £6,703
    Total Funding £53,863 £4,208 £7,553 £3,359 £4,261 £3,666 £5,450 £5,939 £249 £3,529 £3,751 £5,195 £6,703
    Further Education Additional Capital Allocations– FEAC-8010 – Page 1 Ref (for internal use only):  FEACA-8010 v1
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | FEACA-010      | 1                     | 0                        | 2022-08-15 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018010_FEACA-8010_v1.pdf' in 'FE-ACA-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S010_v1.pdf'

    

    # Publish and approve v1

    Given the override date is '17/08/2022'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'FEACA-8010'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-18010' and ContractNumber 'FEACA-8010' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'FEACA-8010' has a substatus of 'Approved'
      


      
    # Bulk amend the FE-ACA alloc 22/23 contract and check v2 docs

    Given the override date is '05/09/2022'

    # Bulk file 'Revised New' amendment
    And   there are no files prefixed '10018010' in the Sharepoint 'FE-ACA-2223-Input-Appendices' folder
    And   there are no files prefixed 'FE-ACA FY 2223 10112022164257 v1_S010b' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'FE-ACA FY 2223 10112022164257 v1_S010b' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'FE-ACA FY 2223 10112022164257 v1_S010b' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'FE-ACA FY 2223 10112022164257 v1_S010b' in the Sharepoint 'Reports' folder
    And   spreadsheet 'FE-ACA FY 2223 10112022164257 v1_S010b.xlsx' exists in the Datafiles folder and UKPRN '10018010' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10018010' for FundingType 'FE-ACA' and period '2223'

    # Check the contents of the Appendices (All doc parts should be present)
    Then  the file named '10018010_FEACA-8010_v2.pdf' in Sharepoint location 'FE-ACA-2223-Input-Appendices' contains the following lines in order
    """ 
    Annex H – Grant payment schedule
    Provider: 10018010 Co Ltd UKPRN: 10018010
    Master Contract Number: ESFA-18010 Start Date: 01/04/2022 End Date: 31/03/2023
    Contract Ref: FEAC-8010
    Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    Further Education Additional Capital Allocations £327,623 £22,297 £43,515 £33,805 £24,095 £38,480 £49,269 £31,288 £30,928 £17,622 £3,596 £31,647 £1,079
    Total Funding £327,623 £22,297 £43,515 £33,805 £24,095 £38,480 £49,269 £31,288 £30,928 £17,622 £3,596 £31,647 £1,079
    Further Education Additional Capital Allocations– FEAC-8010 – Page 1 Ref (for internal use only):  FEACA-8010 v2
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | FEACA-8010     | 2                     | 0                        | 2022-09-15 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10018010_FEACA-8010_v2.pdf' in 'FE-ACA-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'S010_v2.pdf'

    
#    # CDA
#    
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version S010.csv'
##
##    Then  the contracts are in the replicated CRM database as follows
##    | ContractNumber | ContractVersionNumber |
##    | [ContractNo]   | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version               | Suffix |
#    | FE-ACA2223            | Latest Version        | S010   |
#
#    Then  a report named 'CDA Latest Version S010.csv' is created
#	# Check the above report manually


    # Payment Batch for FE-ACA2223

    # Change the date
    #Given the override date is '10/01/2023 22:05'

    # Month end is not running
    #And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    #And   there is no data in the Payment feed for FundingStreamPeriod 'FE-ACA2223' AccountingPaymentPeriod '202210' CensusEndDate '04/01/2023' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    #And   the following allocation periods are present in the subnominal aggregation PaaS table
    #| ContractAllocationNumber | Period |
    #| [AllocRef_FEAC]          | 202301 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    #And   the following configuration exists in the Payment Timetable
    #| Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    #| FE-ACA2223             | 202301               |                      | A              | NotStarted |

    #When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    #Then  there is an entry in the Payment Timetable
    #| Funding Stream Period Code | Calendar Year/Period | Status    |
    #| FE-ACA2223             | 202301               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    #And   the Payment feed xml for FundingStreamPeriod 'FE-ACA2223' PaymentPeriod '202210' CensusEndDate '04/01/2023' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S010.xml'


#
#
#    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'FE-ACA2223' PaymentPeriod '202210' CensusEndDate '08/09/2022' and LinkCodeSuffix 'A' includes the following values
#    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_FEAC]  | 929.43          | RECONCILIATION   | 19-24Trn19+Hardship                | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 100932     |
#    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_FEAC]  | 947.96          | RECONCILIATION   | 19-24Trn20+Childcare               | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 100933     |
#    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_FEAC]  | 1203.59         | RECONCILIATION   | 19-24TrnRsdntlAccess               | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 100934     |
#    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_FEAC]  | 674.97          | RECONCILIATION   | 19-24TrnAdminExp                   | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 100935     |
#    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_FEAC]  | 530.40          | RECONCILIATION   | 19-24TrnC19Response                | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 100936     |
#    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_FEAC]  | 574.70          | RECONCILIATION   | 19-24 Traineeships                 | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 2355800    |
#    | 19TR                   | 2022          | 05             | 08          | ?       | [AllocRef_FEAC]  | 458.03          | RECONCILIATION   | 19-24TraineeshpsLngS               | 2022-09-20 | 2022-08-01   | 2023-07-31 | ?              | 10017394 | 2355860    |
#



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    #Then  there is an item on the Payment feed for FundingStreamPeriod 'FE-ACA2223' AccountingPaymentPeriod '202210' and CensusEndDate '04/01/2023'

#
#    # Title details
#    And   the Payment feed item TITLE is as follows
#    | Title                                                                                                                                                          |
#    | Payment Requests for Funding Stream Period FE-ACA2223 for Payment Period 202210 have been generated as of Census End Date/Time 2022-09-08T22:00:00Z.       |
#
#
#    # Summary details
#    And   the Payment feed item SUMMARY is as follows
#    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
#    | FE-ACA2223      | 202210        | 2022-09-08T22:00:00Z  | 7                | 5319.08    |
#
#    # PaymentPeriod details
#    And   the Payment feed item PaymentPeriod details are as follows
#    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
#    | ESFA   | 19TR      | 01/08/2022   | 31/07/2023 | 08/09/2022    | 20/09/2022 | 2022          | 05             |
#
#    # PaymentDetails
#    And   the Payment feed item PaymentDetails are as follows
#    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef         | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
#    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_FEAC]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100932     | RECONCILIATION | 19-24Trn19+Hardship           | 929.43          |
#    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_FEAC]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100933     | RECONCILIATION | 19-24Trn20+Childcare          | 947.96          |
#    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_FEAC]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100934     | RECONCILIATION | 19-24TrnRsdntlAccess          | 1203.59         |
#    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_FEAC]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100935     | RECONCILIATION | 19-24TrnAdminExp              | 674.97          |
#    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_FEAC]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100936     | RECONCILIATION | 19-24TrnC19Response           | 530.40          |
#    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_FEAC]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355800    | RECONCILIATION | 19-24 Traineeships            | 574.70          |
#    | ORG0017394  | 10017394       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_FEAC]  | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355860    | RECONCILIATION | 19-24TraineeshpsLngS          | 458.03          |
#
#
#    # Check ADP
#
#    # Check all activity has completed
#    When  there are no messages left in the system
#
#    # Check financials on the ADP feed for Aug-22
#    Then  the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
#    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FEAC]  | 1               | 202301 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FEAC]  | 2               | 202301 | 574.70      | 0.00           | 0.00             | 574.70                | 0.00           | 574.70     |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FEAC]  | 3               | 202301 | 458.03      | 0.00           | 0.00             | 458.03                | 0.00           | 458.03     |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FEAC]  | 4               | 202301 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FEAC]  | 5               | 202301 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FEAC]  | 6               | 202301 | 929.43      | 0.00           | 0.00             | 929.43                | 0.00           | 929.43     |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FEAC]  | 7               | 202301 | 947.96      | 0.00           | 0.00             | 947.96                | 0.00           | 947.96     |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FEAC]  | 8               | 202301 | 1203.59     | 0.00           | 0.00             | 1203.59               | 0.00           | 1203.59    |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FEAC]  | 9               | 202301 | 674.97      | 0.00           | 0.00             | 674.97                | 0.00           | 674.97     |
#    | ContractAllocationActualsReceived | [ContractNo]       | 1             | [AllocRef_FEAC]  | 10              | 202301 | 530.40      | 0.00           | 0.00             | 530.40                | 0.00           | 530.40     |
#
#




    # Part 10: Create Consolidated Payment Summary rpt
   
    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    #Given the override date is '06/01/2023 10:00'

   #Given there are no files prefixed '2023-01 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
   
   #When  a Consolidated Payment Summary Report is created in Sharepoint for '11/01/2023'
    # Check the above report manually


