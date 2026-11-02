Feature: DaDA_NotificationAmendments 30031

@AcceptanceTest @Withdrawn20230123
Scenario: A526 Ceate and approve a DADA2021 contract. Change Ts&Cs. Notification amendment and approval. Variation amendment. Check docs along the way
    Given there are no allocations marked as Under Termination for UKPRN '10017526' 
    And   there are no terminated or closed allocations for UKPRN '10017526' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017526' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017526' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | DADA-526      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | DADA-526      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | DADA2021          |

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
    Given there is no Organisation data for UKPRN '10017526' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017526 Co Ltd' with UKPRN '10017526' and OrgId 'ORG0017526' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017526' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017526 | 117526 | 10017526 Co Ltd | 0              | Locked Restructure    | Yes           | AA017526      | ?             | 25 Aycliffe Road       | ?                      | ?                      | ?                      | Borehamwood            | Hertfordshire          | WD6 4JP   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017526 |




    # Change the date
    Given the override date is '23/05/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017526 | 10017526 Co Ltd      | ESFA-526             | DADAS-526      | 1                     | 01/08/2020        | 31/07/2021      | 4175.00       |                                       | Contract for Services                      | 2021   | New          | ORG0017526 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017526 | DADAS-526      | DADA-526      | DADA              | DADA2021                | AY                      | 01/08/2020          | 31/07/2021        | 4175.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017526 | DADAS-526      | DADA-526      | 1               | 0                     | 4175.00   | 1040.00   | 3135.00   | 0.00     | 1040.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3135.00  | 0.00     | 0.00     | 0.00     | Dance and Drama Awards Scheme                                   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'DADAS-526' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'DADAS-526'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-526' and actual ContractNumber 'DADAS-526'

    # Check that the contract is now approved
    Then  the latest version of contract 'DADAS-526' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017526 | DADAS-526          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017526 | ESFA-526           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'DADAS-526'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | DADA-526        | 2207010          | Jul-21 | Profile        |

    # Update details in the ContractManagement.CreatedContract table for v1
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | DADAS-526      | 1                     | 0                        | 2020-05-23 09:00:00.000 |




    # T&C document changes then Notification amendment issued 

    # Update timestamp on DADA TAC document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName          | UploadTimestamp         |
    | DADA2020_TAC_2020-08-01.docx  | 2020-05-24 22:22:22.000 | 




    # Change the date to one several days after the date of the revised TAC template
    Given the override date is '28/05/2020'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'DADAS-526' for a non-financial VARIATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'DADAS-526' for a non-financial NOTIFICATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017526 | DADAS-526          | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Notification  |
    | 10017526 | DADAS-526          | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017526 | ESFA-526           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Retrieve parameters for the Contracting Org
   #And  I retrieve the latest EFA contract details from CRM for provider '10017526' for FundingType 'DADA' and period '2021' and Delivery Organisation '10017176'
    And   I retrieve the latest contract details from CRM for provider '10017526' for FundingType 'DADA' and period '2021'

    # Check that only the SoF is produced from the following 'set' of six docs for contract v2
    #   Summary of Funding, Main Terms and Conditions (TAC), Schedule 1, Schedule 2, Funding Agreement, Schedule 3on
    And   the file named '10017526_DADAS-526_v2.pdf' in Sharepoint location 'DADA-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
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

    # Update the contract sub-status to 'Published to Provider'
    And   the latest version of contract 'DADAS-526' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-526' and actual ContractNumber 'DADAS-526'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017526 | DADAS-526          | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Notification  |
    | 10017526 | DADAS-526          | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017526 | ESFA-526           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Update details in the ContractManagement.CreatedContract table for v2
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | DADAS-526      | 2                     | 0                        | 2020-05-28 09:00:00.000 |




    # Variation Amendment

    # Change the date to one several days after the date of the revised TAC template
    Given the override date is '01/06/2020'

    # Issue a non-financial VARIATION amendment on v2 to create v3. The Summary of Funding AND revised TAC document should be produced
   #When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'DADAS-526' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'DADAS-526' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017526 | DADAS-526          | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017526 | DADAS-526          | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | Notification  |
    | 10017526 | DADAS-526          | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017526 | ESFA-526           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Retrieve parameters for the Contracting Org
   #And  I retrieve the latest EFA contract details from CRM for provider '10017526' for FundingType 'DADA' and period '2021' and Delivery Organisation '10017176'
    And   I retrieve the latest contract details from CRM for provider '10017526' for FundingType 'DADA' and period '2021'

    # Check that the SoF and TAC are produced from the following 'set' of six docs for contract v3
    #   Summary of Funding, Main Terms and Conditions (TAC), Schedule 1, Schedule 2, Funding Agreement, Schedule 3on
    And   the file named '10017526_DADAS-526_v3.pdf' in Sharepoint location 'DADA-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING

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
    DaDA Schedule 2 Version 1 (July 2020) – Page 1
    """
    
    # There should not be a Funding Agreement document
	And   the pdf file does not contain the following text
    """
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    """

    # There should not be a Schedule 3ON document
	And   the pdf file does not contain the following text
    """
	DaDA Schedule 3 Version 1 (July 2020) – Page 1
    """

    # Tidy up
    And   the override date is reset 
       
          