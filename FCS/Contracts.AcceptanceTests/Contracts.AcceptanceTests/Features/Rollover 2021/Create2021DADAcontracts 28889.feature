Feature: Create2021DADAcontracts 28889

@AcceptanceTest @Withdrawn20231002
Scenario: A178 Bulk load a new DADA2021 contract. Publish and approve. Non-financial amendment. Delete v2. Adjust template timestamp. Non-financial amendment. Check docs along the way. Check CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017178' 
    And   there are no terminated or closed allocations for UKPRN '10017178' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017178' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017178' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | DADA2021       |

    # Set the base timestamp for each of the 6 DADA document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName          | UploadTimestamp         |
    | SOF_DADA_2020-08-01.docx      | 2020-05-20 10:00:00.000 |
    | DADA2020_TAC_2020-08-01.docx  | 2020-05-20 10:00:00.000 |
    | DADA2021_S1_2020-08-01.docx   | 2020-05-20 10:00:00.000 |
    | DADA2020_S2_2020-08-01.docx   | 2020-05-20 10:00:00.000 |
    | FA_DADA2021_2020-08-01.docx   | 2020-05-20 10:00:00.000 |
    | DADA2020_S3ON_2020-08-01.docx | 2020-05-20 10:00:00.000 | 
 



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017178' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017178 Co Ltd' with UKPRN '10017178' and OrgId 'ORG0017178' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017178' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017178 | 117178 | 10017178 Co Ltd | 0              | Active                | Yes           | AA017178      | ?             | 404 Winter Gardens     | ?                      | ?                      | ?                      | ?                      | ?                      | MK9 2EA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017178 |




    # Change the date
    Given the override date is '23/07/2020'

    # Bulk file
    And   there are no files prefixed '10017178' in the Sharepoint 'DADA-2021-Input-Appendices' folder
    And   there are no files prefixed 'DADA AY 2021 24022020180142 v3_A178' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'DADA AY 2021 24022020180142 v3_A178' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'DADA AY 2021 24022020180142 v3_A178' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'DADA AY 2021 24022020180142 v3_A178' in the Sharepoint 'Reports' folder
    And   spreadsheet 'DADA AY 2021 24022020180142 v3_A178.xlsx' exists in the Datafiles folder and UKPRN '10017178' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Scenario B012 checked that CRM Org data was not duplicated after a bulk import. Now checked here instead
    And   UKPRN '10017178' has not been duplicated in CRM

    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017178' for FundingType 'DADA' and period '2021' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017178' for FundingType 'DADA' and period '2021'

    # Check that all 6 documents have been produced in the right order, viz
    #   'Summary of Funding', then 'Main Terms and Conditions' (TAC) then Schedule 1, then Schedule 2, then 'Funding Agreement', then 'Schedule 3on'
    And   the file named '10017178_[ContractNo]_v1.pdf' in Sharepoint location 'DADA-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017178 Co Ltd UKPRN: 10017178
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    Dance and Drama Awards (DaDA) [AllocRef_DADA] £1,251 £1,947 £3,198
    Total: £3,198
    Total Funding for this contract: £3,198
    Summary of Funding – Page 1

    Agreement Type Contract for Services
    Funding Period 1 August 2020 to 31 July 2023
    the Secretary of State for Education (acting through the
    Between
    Education and Skills Funding Agency)
    And 10017178 Co Ltd
    Funding for Dance and Drama Awards (DaDA)
    Master Contract Number [MasterContractNo]
    DaDA Version 1 (July 2020) Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017178 Co Ltd THE SECRETARY OF STATE FOR
    404 Winter Gardens EDUCATION ACTING THROUGH
    MK9 2EA THE EDUCATION AND SKILLS
    FUNDING AGENCY, AN
    EXECUTIVE AGENCY OF THE
    Company No: AA017178 DEPARTMENT OF EDUCATION
    AND
    CHEYLESMORE HOUSE
    QUINTON ROAD
    COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Contractor the Department
    DaDA Version 1 (July 2020) Page 2
    DaDA Version 1 (July 2020) Page 75

    SCHEDULE 1: SPECIFICATION & MONITORING 
    DANCE AND DRAMA AWARDS (DaDA) SPECIFICATION
    DaDA Schedule 1 Version 1 (July 2020) – Page 1
    DaDA Schedule 1 Version 1 (July 2020) – Page 4
    SCHEDULE 1: ANNEX 1
    DaDA Schedule 1 – Annex 1 Version 1 (July 2020) – Page 1
    DaDA Schedule 1 – Annex 1 Version 1 (July 2020) – Page 45

    SCHEDULE 2: PAYMENT
    DANCE AND DRAMA AWARDS (DaDA) PAYMENT
    DaDA Schedule 2 Version 1 (July 2020) – Page 1

    SCHEDULE 2
    Funding Agreement
    Provider: 10017178 Co Ltd UKPRN: 10017178
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_DADA]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    Dance and Drama Awards (DaDA) £3,198 £0 £1,251 £0 £0 £0 £0 £0 £0 £1,947 £0 £0 £0
    Total Funding £3,198 £0 £1,251 £0 £0 £0 £0 £0 £0 £1,947 £0 £0 £0
    Schedule 2 – Funding Agreement [AllocRef_DADA] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    DaDA Schedule 3 Version 1 (July 2020) – Page 1
    SCHEDULE 4: NOT USED
    DaDA Schedule 4 Version 1 (July 2020) – Page 1
    SCHEDULE 5: TUPE
    DaDA Schedule 5 Version 1 (July 2020) – Page 1
    DaDA Schedule 5 Version 1 (July 2020) – Page 27
    SCHEDULE 6: GDPR
    DaDA Schedule 6 Version 1 (July 2020) – Page 1
    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
    DaDA Schedule 7 Version 1 (July 2020) – Page 1
    DaDA Schedule 7 Version 1 (July 2020) – Page 7
    SCHEDULE 8: EXIT ARRANGEMENTS
    DaDA Schedule 8 Version 1 (July 2020) – Page 1
    DaDA Schedule 8 Version 1 (July 2020) – Page 5
    SCHEDULE 9 CONTRACTOR’S RESPONSE/PROPOSALS
    DaDA Schedule 9 Version 1 (July 2020) – Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017178_[ContractNo]_v1.pdf' in 'DADA-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A178_1.pdf'

    # Display Sharepoint filename
    And   message '10017178_[ContractNo]_v1.pdf' is written to the Output window




    # Publish and approve
	
    # Change the date
    Given the override date is '27/07/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017178 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017178 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'DADAS-178'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_DADA] | 2207010          | Jul-21 | Profile        |




    # Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | [ContractNo]   | [AllocRef_DADA]    | 1               | 3198.00   | 0.00     | 1251.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1947.00  | 0.00     | 0.00     | 0.00     | 




    # Create non-financial Variation amendment and check docs

    # Change the date
    Given the override date is '02/09/2020'

    # Attempt a non-financial VARIATION amendment request on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017178 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017178 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017178 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the contents of the Appendices (Only a SoF should be present)
    And   the file named '10017178_[ContractNo]_v2.pdf' in Sharepoint location 'DADA-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017178 Co Ltd UKPRN: 10017178
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    Dance and Drama Awards (DaDA) [AllocRef_DADA] £1,251 £1,947 £3,198
    Total: £3,198
    Total Funding for this contract: £3,198
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

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017178_[ContractNo]_v2.pdf' in 'DADA-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A178_2.pdf'

    # Display Sharepoint filename
    And   message '10017178_[ContractNo]_v2.pdf' is written to the Output window




    # Delete draft v2

    Given there are no files prefixed '10017178' in the Sharepoint 'DADA-2021-Input-Appendices' folder

    # Trigger WF28 in CRM to issue a delete request against v2 of the contract (J090)
    When  a request is initiated in CRM to delete the following contracts
   #When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017178 | [ContractNo]   | 2                     | 0                  |

    # Check the CONTRACT version, status and dates in CRM - Wait for the deletion to be effective
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017178 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017178 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2020-09-02 09:12:35.000 |

    # Associate a timestamp with a document template (J107)
    #   DocumentsDomain.UploadedDocumentTemplate
    Given the following document templates have Upload timestamps as indicated
    | DocumentTemplateName               | UploadTimestamp         |
    | DADA2020_S3ON_2020-08-01.docx      | 2021-06-01 09:00:00.000 |




    # Create non-financial Variation amendment a second time and check docs

    # Change the date
    Given the override date is '04/06/2021 15:30'

    # Attempt a non-financial VARIATION amendment request on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017178 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017178 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017178 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the contents of the Appendices (Only SoF and S3ON should be present; the latter because the timestamp changed)
    And   the file named '10017178_[ContractNo]_v2.pdf' in Sharepoint location 'DADA-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017178 Co Ltd UKPRN: 10017178
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    Dance and Drama Awards (DaDA) [AllocRef_DADA] £1,251 £1,947 £3,198
    Total: £3,198
    Total Funding for this contract: £3,198
    Summary of Funding – Page 1

    SCHEDULE 3: CHANGE CONTROL PROCEDURE
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

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017178_[ContractNo]_v2.pdf' in 'DADA-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A178_2.pdf'


    # Tidy up
    Given the override date is reset
  
@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run123
Scenario: A179 Create and approve a new DADA2021 contract. Bulk amend and approve. Create PoP payment. Check CRM, CDA, Financials and feeds
    Given there are no allocations marked as Under Termination for UKPRN '10017179' 
    And   there are no terminated or closed allocations for UKPRN '10017179' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017179' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017179' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | DADA-179      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | DADA-179      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP           |
    | DADA2021      |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017179' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017179 Co Ltd' with UKPRN '10017179' and OrgId 'ORG0017179' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017179' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017179 | 117179 | 10017179 Co Ltd | 0              | Provider Under Change | Yes           | AA017179      | ?             | 28 Prince Street       | Aberdeen               | ?                      | ?                      | ?                      | ?                      | AB11 6BQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017179 |




    # Change the date
    Given the override date is '01/09/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription  | ContractType             | Period | CRMIntent    | OrgId      |
    | 10017179 | 10017179 Co Ltd      | ESFA-179             | DADAS-179      | 1                     | 01/08/2020        | 31/07/2021      | 6562.00       |                      | Contract for Services    | 2021   | New          | ORG0017179 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName    | UoPCode    | AllocationDescription   | CRMIntent    | DeliveryOrg |
    | 10017179 | DADAS-179      | DADA-179      | DADA              | DADA2021                | AY                      | 01/08/2020          | 31/07/2021        | 6562.00         |            |            |                         | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription           | CRMIntent    | DeliveryOrg |
    | 10017179 | DADAS-179      | DADA-179      | 1               | 0                     | 4344.00   | 3086.00   | 1258.00   | 0.00     | 3086.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1258.00  | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme    | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'DADAS-179'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-179' and actual ContractNumber 'DADAS-179'

    # Check that the contract is now approved
    Then  the latest version of contract 'DADAS-179' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017179 | DADAS-179          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017179 | ESFA-179           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'DADAS-179'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | DADA-179      | 2207010          | Jul-21 | Profile        |




    # Amend the contract

    # Change the date
    Given the override date is '28/09/2020'

    # Bulk file
    And   there are no files prefixed '10017179' in the Sharepoint 'DADA-2021-Input-Appendices' folder
    And   there are no files prefixed 'DADA AY 2021 24022020180151 v3_A179' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'DADA AY 2021 24022020180151 v3_A179' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'DADA AY 2021 24022020180151 v3_A179' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'DADA AY 2021 24022020180151 v3_A179' in the Sharepoint 'Reports' folder
    And   spreadsheet 'DADA AY 2021 24022020180151 v3_A179.xlsx' exists in the Datafiles folder and UKPRN '10017179' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

   #And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'




    # Change the date
    Given the override date is '29/09/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'DADAS-179'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-179' and actual ContractNumber 'DADAS-179'

    # Check that the contract is now approved
    Then  the latest version of contract 'DADAS-179' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017179 | DADAS-179          | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017179 | DADAS-179          | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017179 | ESFA-179           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'DADAS-179'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | DADA-179      | 2207010          | Mar-21 | Profile        |




    # Check CRM financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | 
    | DADAS-179      | DADA-179           | 1               | 7160.00   | 0.00     | 2035.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5125.00  | 0.00     | 0.00     | 0.00     | 




    # Payment Batch for Sep-20 for DADA2021

    # Change the date
    Given the override date is '04/09/2020 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'DADA2021' AccountingPaymentPeriod '202006' CensusEndDate '04/09/2020' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | DADA-179                 | 202009 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | DADA2021                   | 202009               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | DADA2021                   | 202009               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'DADA2021' PaymentPeriod '202006' CensusEndDate '04/09/2020' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A179.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'DADA2021' PaymentPeriod '202006' CensusEndDate '04/09/2020' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | DADA                   | 2020          | 06             | 04          | ?       | DADA-179      | 3086.00         | PROFILE          | Dance & Drama Awards   | 2020-09-24 | 2020-08-01   | 2021-07-31 | ?              | 10017179 | 2207010    |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    And   there is an item on the Payment feed for FundingStreamPeriod 'DADA2021' AccountingPaymentPeriod '202006' and CensusEndDate '04/09/2020'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                              |
    | Payment Requests for Funding Stream Period DADA2021 for Payment Period 202006 have been generated as of Census End Date/Time 2020-09-04T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | DADA2021            | 202006        | 2020-09-04T22:00:00Z  | 1                | 3086.00    |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | DADA      | 01/08/2020   | 31/07/2021 | 04/09/2020    | 24/09/2020 | 2020          | 06             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription  | AggregatedValue |
    | ORG0017179  | 10017179       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | DADA-179   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2207010    | PROFILE        | Dance & Drama Awards   | 3086.00         |




    # Check Financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | DADAS-179      | DADA-179           | 1               | 7160.00   | 0.00     | 2035.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5125.00  | 0.00     | 0.00     | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | DADAS-179      | DADA-179           | 1               | -1051.00  | ?        | 0.00     | -1051.00 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | DADAS-179      | DADA-179           | 1               | 8211.00   | ?        | 3086.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5125.00  | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | DADAS-179      | DADA-179           | 1               | 7160.00   | 0.00     | 3086.00  | -1051.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 5125.00  | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    |
    | 10017179 | DADAS-179      | DADA-179           | 2207010                  | 0.00      | 3086.00   | -1051.00  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 5125.00   | 0.00      | 0.00      | 0.00      | 


    # Check the PROFILE subnominal aggregations in PaaS
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017179 | ORG0017179 | DADA-179          | 2207010         | DADA2021                   | 202008               | PROFILE         | CM             | False       | 0.00            |
    | 10017179 | ORG0017179 | DADA-179          | 2207010         | DADA2021                   | 202009               | PROFILE         | CM             | True        | 3086.00         |
    | 10017179 | ORG0017179 | DADA-179          | 2207010         | DADA2021                   | 202010               | PROFILE         | CM             | False       | -1051.00        |
    | 10017179 | ORG0017179 | DADA-179          | 2207010         | DADA2021                   | 202011               | PROFILE         | CM             | False       | 0.00            |
    | 10017179 | ORG0017179 | DADA-179          | 2207010         | DADA2021                   | 202012               | PROFILE         | CM             | False       | 0.00            |
    | 10017179 | ORG0017179 | DADA-179          | 2207010         | DADA2021                   | 202101               | PROFILE         | CM             | False       | 0.00            |
    | 10017179 | ORG0017179 | DADA-179          | 2207010         | DADA2021                   | 202102               | PROFILE         | CM             | False       | 0.00            |
    | 10017179 | ORG0017179 | DADA-179          | 2207010         | DADA2021                   | 202103               | PROFILE         | CM             | False       | 0.00            |
    | 10017179 | ORG0017179 | DADA-179          | 2207010         | DADA2021                   | 202104               | PROFILE         | CM             | False       | 5125.00         |
    | 10017179 | ORG0017179 | DADA-179          | 2207010         | DADA2021                   | 202105               | PROFILE         | CM             | False       | 0.00            |
    | 10017179 | ORG0017179 | DADA-179          | 2207010         | DADA2021                   | 202106               | PROFILE         | CM             | False       | 0.00            |
    | 10017179 | ORG0017179 | DADA-179          | 2207010         | DADA2021                   | 202107               | PROFILE         | CM             | False       | 0.00            |




#    # Check the contents of the CDA report
#    Given there is no CDA report named 'CDA Last Approved Version A179.csv'
#
#    Then  the contracts are in the replicated CRM database as follows
#    | ContractNumber | ContractVersionNumber |
#    | DADAS-179      | 2                     |
#
#   #When  the following CDA reports are run
#    When  the following CDA report is run
#    | FundingStreamPeriod  | Version               | Suffix |
#    | DADA2021             | Last Approved Version | A179   |
#
#    Then  a report named 'CDA Last Approved Version A179.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | DADA2021                | 10017179 | 10017179 Co Ltd             |               |                             | DADA-179                 | DADAS-179      | ESFA-179                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 8                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Aug              |
#    | DADA2021                | 10017179 | 10017179 Co Ltd             |               |                             | DADA-179                 | DADAS-179      | ESFA-179                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 9                 | 2020            | 2020/21       |              | 2035         |              |               |              | Yes                | 3086.00        | 0.00             | 0.00                  | 0.00           | 3086.00         |             | Yes           |                   |        | 2207010           |                          |                   | Sep              |
#    | DADA2021                | 10017179 | 10017179 Co Ltd             |               |                             | DADA-179                 | DADAS-179      | ESFA-179                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 10                | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | -1051.00         | 0.00                  | 0.00           | -1051.00        |             | No            |                   |        | 2207010           |                          |                   | Oct              |
#    | DADA2021                | 10017179 | 10017179 Co Ltd             |               |                             | DADA-179                 | DADAS-179      | ESFA-179                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 11                | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Nov              |
#    | DADA2021                | 10017179 | 10017179 Co Ltd             |               |                             | DADA-179                 | DADAS-179      | ESFA-179                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 12                | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Dec              |
#    | DADA2021                | 10017179 | 10017179 Co Ltd             |               |                             | DADA-179                 | DADAS-179      | ESFA-179                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 1                 | 2021            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Jan              |
#    | DADA2021                | 10017179 | 10017179 Co Ltd             |               |                             | DADA-179                 | DADAS-179      | ESFA-179                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 2                 | 2021            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Feb              |
#    | DADA2021                | 10017179 | 10017179 Co Ltd             |               |                             | DADA-179                 | DADAS-179      | ESFA-179                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 3                 | 2021            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Mar              |
#    | DADA2021                | 10017179 | 10017179 Co Ltd             |               |                             | DADA-179                 | DADAS-179      | ESFA-179                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 4                 | 2021            | 2021/22       |              | 5125         |              |               |              | Yes                | 5125.00        |                  | 0.00                  | 0.00           | 5125.00         |             | No            |                   |        | 2207010           |                          |                   | Apr              |
#    | DADA2021                | 10017179 | 10017179 Co Ltd             |               |                             | DADA-179                 | DADAS-179      | ESFA-179                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 5                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | May              |
#    | DADA2021                | 10017179 | 10017179 Co Ltd             |               |                             | DADA-179                 | DADAS-179      | ESFA-179                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 6                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Jun              |
#    | DADA2021                | 10017179 | 10017179 Co Ltd             |               |                             | DADA-179                 | DADAS-179      | ESFA-179                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Dance and Drama Awards Scheme                                   |                                                                 | 7                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2207010           |                          |                   | Jul              |


    # Tidy Up
    And   the override date is reset

     