Feature: DASLevyCommitmentInitiationA 16104

@AcceptanceTest @Withdrawn20230123
@PublishNewLevyContract
Scenario: A104 Create (and approve several weeks after the contract start date) a Levy contract where caseload does not exist. Consume non-consecutive actuals for NONLEVY alloc. Check Feed, docs, CRM and PaaS
    Given there is no Contract, Task or Workflow data for UKPRN '10017104'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017104'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017104'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017104'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no entries in the DCFS stub table
    And   there are no DAS engagement events stored in FCS
    And   the override date is reset



    # Remove the provider from RoATP (ContractManagement.RoATPProvider)
    And   there is no data on RoATP for the following providers
    | Ukprn    |
    | 10017104 |

    # Add the provider to RoATP (ContractManagement.RoATPProvider)
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017104 | 10017104 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017104' 
   #And   caseload advisor 'FCS2 Test' is assigned to provider '10017104 Co Ltd' with UKPRN '10017104' and OrgId 'ORG0017104' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017104' 
 
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017104 | 117104 | 10017104 Co Ltd | 0              | Provider Under Change | Yes           | AA017104      | ?             | 21 Barley Croft        | Leverstock Green       | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP2 4UU   |
    
    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017104 |




    # Inject data into the stub (16104)
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | ContractType      |
    | 42860 | INITIATED | 2017-02-18T09:31:29.1340 | 10017104   | ProviderAgreement |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017104'




    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017104 | 10017104 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017104 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017104 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017104 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017104 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017104 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017104 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017104 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 

    # Retrieve parameters from CRM  
   #When  I retrieve the latest EFA contract details from CRM for provider '10017104' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017088' 
    And   I retrieve the latest contract details from CRM for provider '10017104' for FundingType 'LEVY' and period '1799' 

    # Check Atom feed data for a type 1 'Published to Provider' event
    And   the ContractManagement.AtomFeedItem table contains one ItemType '1' event for contract number '[ContractNo]'
    And   the ItemType '1' event for contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Check Contract documentation (16390)
    And   a file named '10017104_' & '[ContractNo]' & '_v1.pdf' does not exist in sharepoint location 'LEVY-1799-Input-Appendices'
    And   the file named '10017104_[ContractNo]_v1.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
    """
    Department for Education Apprenticeship Agreement for Training
    Providers
    Terms and Conditions
    THIS AGREEMENT is made on the date the Agreement is digitally signed by the Training
    Provider through the Manage Your Education and Skills Funding Service having
    already been signed by the Department and is between:
    10017104 Co Ltd THE SECRETARY OF STATE FOR
    21 Barley Croft EDUCATION
    Leverstock Green DEPARTMENT FOR
    Hemel Hempstead EDUCATION
    Hertfordshire AND 20 GREAT SMITH STREET
    HP2 4UU LONDON
    SW1P 3BT
    Company No: AA017104
    UKPRN: 10017104
    Referred to in this Agreement as “the Referred to in this Agreement as “the
    Training Provider” Department”
    “Expiry Date” means 31 July 2025 or such later date as is notified in writing by
    Department for Education Apprenticeship Agreement for Training Providers, Winter 2022, Version
    4.1
    Education & Skills Funding Agency
    Education and Skills Funding Agency - GOV.UK (www.gov.uk)
    56
    """

    # The Amendment Letter is not included
    And   the pdf file does not contain the following text
    """
    Agreement number: [MasterContractNo] 
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017104_[ContractNo]_v1.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A104v1.pdf'





    # Change the date
    Given the override date is '22/06/2020'

    # Approve the contract (15397)
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check deliverable period count after approval 
    Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # After approval there should be a Jun-20 deliverable period for each of deliverables 1 through 14 for each allocation 
    Then   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Jun-20   | DeliverableDescription                               | 
    | 10017104 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017104 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017104 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017104 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017104 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017104 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017104 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017104 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017104 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017104 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017104 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017104 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017104 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017104 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017104 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017104 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017104 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017104 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017104 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017104 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017104 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017104 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017104 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017104 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017104 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017104 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017104 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017104 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017104 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 22/06/2020        | ?               | ?             |
    | 10017104 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |




    # Check Workflow History	
    And   the following workflow history entries are present on the latest version of the contract
    | Action                                         | CompletedBy       | Previous Contract Owner | New Contract Owner | 
    | Confirm Receipt of Digital Signature           | CRM Integration   | ?                       | ?                  |
    | Document Published For Digital Sign Off        | CRM Integration   | ?                       | ?                  |
    | Skip Review and Internal Approval              | CRM Integration   | ?                       | ?                  |

    And   the following workflow history entries are not present on the latest version of the contract 
    | Action                                                             |
    | Approve for Issue                                                  |
    | Automatically Approved                                             |

    # Check Atom feed data for a type 0 'Approved' event
    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for contract number '[ContractNo]'
    And   the ItemType '0' event for contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema




    # Change the date
    Given the override date is '07/07/2020'

	# Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

	# Pull DCFS PoI actuals for June 2020 (17384) 
    Then  the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS02               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 2               | 0            | 1460.18     |
    | APPS           | APPS02               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 3               | 0            | 1126.78     |
    | APPS           | APPS02               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 4               | 0            | 0.00        |
    | APPS           | APPS02               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 5               | 0            | 970.76      |
    | APPS           | APPS02               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 6               | 0            | 105.06      |
    | APPS           | APPS02               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 7               | 0            | 1443.38     |
    | APPS           | APPS02               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 9               | 0            | 1304.74     |
    | APPS           | APPS02               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 10              | 0            | 55.74       |
    | APPS           | APPS02               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 11              | 0            | -146.44     |
    | APPS           | APPS02               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 12              | 0            | 1333.13     |
    #
	| APPS           | APPS02               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 2               | 0            | 991.52      |
    | APPS           | APPS02               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 3               | 0            | -52.22      |
    | APPS           | APPS02               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 4               | 0            | 1181.32     |
    | APPS           | APPS02               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 5               | 0            | -23.25      |
    | APPS           | APPS02               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 6               | 0            | -71.24      |
    | APPS           | APPS02               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 7               | 0            | 0.00        |
    | APPS           | APPS02               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 9               | 0            | 128.01      |
    | APPS           | APPS02               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 10              | 0            | 831.52      |
    | APPS           | APPS02               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 11              | 0            | 331.95      |
    | APPS           | APPS02               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 12              | 0            | 0.00        |
    #
	| APPS           | APPS02               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 2               | 0            | 1047.43     |
    | APPS           | APPS02               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 3               | 0            | 581.28      |
    | APPS           | APPS02               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 4               | 0            | 1255.63     |
    | APPS           | APPS02               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 5               | 0            | 1001.61     |
    | APPS           | APPS02               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 6               | 0            | 457.36      |
    | APPS           | APPS02               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 7               | 0            | 186.42      |
    | APPS           | APPS02               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 9               | 0            | 1143.39     |
    | APPS           | APPS02               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 10              | 0            | 365.00      |
    | APPS           | APPS02               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 11              | 0            | 1489.71     |
    | APPS           | APPS02               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 12              | 0            | 633.91      |
    #
	| APPS           | APPS02               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 2               | 0            | 377.90      |
    | APPS           | APPS02               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 3               | 0            | 1339.81     |
    | APPS           | APPS02               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 4               | 0            | 1140.42     |
    | APPS           | APPS02               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 5               | 0            | 0.00        |
    | APPS           | APPS02               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 6               | 0            | 430.90      |
    | APPS           | APPS02               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 7               | 0            | 171.58      |
    | APPS           | APPS02               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 9               | 0            | 1319.50     |
    | APPS           | APPS02               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 10              | 0            | 1336.59     |
    | APPS           | APPS02               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 11              | 0            | 1313.18     |
    | APPS           | APPS02               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 12              | 0            | 357.45      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then  the following data is present in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017104'
    | CollectionReturnPeriod | OrganisationId | FundingStreamPeriodCode | DeliverableCode | Period | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | AllocationStartDate | CollectionReturnCode | CollectionType | PaymentValue | ContractAllocation Number |
    | 202006                 | ORG0017104     | NONLEVY2019             | 2               | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | 991.52       | [AllocRef_NLA]            |
    | 202006                 | ORG0017104     | NONLEVY2019             | 3               | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | -52.22       | [AllocRef_NLA]            |
    | 202006                 | ORG0017104     | NONLEVY2019             | 4               | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | 1181.32      | [AllocRef_NLA]            |
    | 202006                 | ORG0017104     | NONLEVY2019             | 5               | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | -23.25       | [AllocRef_NLA]            |
    | 202006                 | ORG0017104     | NONLEVY2019             | 6               | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | -71.24       | [AllocRef_NLA]            |
    | 202006                 | ORG0017104     | NONLEVY2019             | 7               | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | 0.00         | [AllocRef_NLA]            |
    | 202006                 | ORG0017104     | NONLEVY2019             | 9               | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | 128.01       | [AllocRef_NLA]            |
    | 202006                 | ORG0017104     | NONLEVY2019             | 10              | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | 831.52       | [AllocRef_NLA]            |
    | 202006                 | ORG0017104     | NONLEVY2019             | 11              | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | 331.95       | [AllocRef_NLA]            |
    | 202006                 | ORG0017104     | NONLEVY2019             | 12              | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | 0.00         | [AllocRef_NLA]            |

    And   there are '10' rows in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017104'




	# Change the date
	Given the override date is '07/09/2020'

    # Pull DCFS PoI actuals for August 2020 (17384) 
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS04               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 2               | 0            | 1460.18     |
    | APPS           | APPS04               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 3               | 0            | 1126.78     |
    | APPS           | APPS04               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 4               | 0            | 0.00        |
    | APPS           | APPS04               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 5               | 0            | 970.76      |
    | APPS           | APPS04               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 6               | 0            | 105.06      |
    | APPS           | APPS04               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 7               | 0            | 1443.38     |
    | APPS           | APPS04               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 9               | 0            | 1304.74     |
    | APPS           | APPS04               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 10              | 0            | 55.74       |
    | APPS           | APPS04               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 11              | 0            | -146.44     |
    | APPS           | APPS04               | ORG0017104     | CM             | 202005 | NONLEVY2019             | [AllocRef_NLA]           |         | 12              | 0            | 1333.13     |
    #
	| APPS           | APPS04               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 2               | 0            | 991.52      |
    | APPS           | APPS04               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 3               | 0            | -52.22      |
    | APPS           | APPS04               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 4               | 0            | 1181.32     |
    | APPS           | APPS04               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 5               | 0            | -23.25      |
    | APPS           | APPS04               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 6               | 0            | -71.24      |
    | APPS           | APPS04               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 7               | 0            | 0.00        |
    | APPS           | APPS04               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 9               | 0            | 128.01      |
    | APPS           | APPS04               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 10              | 0            | 831.52      |
    | APPS           | APPS04               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 11              | 0            | 331.95      |
    | APPS           | APPS04               | ORG0017104     | CM             | 202006 | NONLEVY2019             | [AllocRef_NLA]           |         | 12              | 0            | 0.00        |
    #
	| APPS           | APPS04               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 2               | 0            | 1047.43     |
    | APPS           | APPS04               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 3               | 0            | 581.28      |
    | APPS           | APPS04               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 4               | 0            | 1255.63     |
    | APPS           | APPS04               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 5               | 0            | 1001.61     |
    | APPS           | APPS04               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 6               | 0            | 457.36      |
    | APPS           | APPS04               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 7               | 0            | 186.42      |
    | APPS           | APPS04               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 9               | 0            | 1143.39     |
    | APPS           | APPS04               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 10              | 0            | 365.00      |
    | APPS           | APPS04               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 11              | 0            | 1489.71     |
    | APPS           | APPS04               | ORG0017104     | CM             | 202007 | NONLEVY2019             | [AllocRef_NLA]           |         | 12              | 0            | 633.91      |
    #
	| APPS           | APPS04               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 2               | 0            | 377.90      |
    | APPS           | APPS04               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 3               | 0            | 1339.81     |
    | APPS           | APPS04               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 4               | 0            | 1140.42     |
    | APPS           | APPS04               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 5               | 0            | 0.00        |
    | APPS           | APPS04               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 6               | 0            | 430.90      |
    | APPS           | APPS04               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 7               | 0            | 171.58      |
    | APPS           | APPS04               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 9               | 0            | 1319.50     |
    | APPS           | APPS04               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 10              | 0            | 1336.59     |
    | APPS           | APPS04               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 11              | 0            | 1313.18     |
    | APPS           | APPS04               | ORG0017104     | CM             | 202008 | NONLEVY2019             | [AllocRef_NLA]           |         | 12              | 0            | 357.45      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then  the following data is present in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017104'
    | CollectionReturnPeriod | OrganisationId | FundingStreamPeriodCode | DeliverableCode | Period | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | AllocationStartDate | CollectionReturnCode | CollectionType | PaymentValue | ContractAllocation Number |
    | 202006                 | ORG0017104     | NONLEVY2019             | 2               | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | 991.52       | [AllocRef_NLA]            |
    | 202006                 | ORG0017104     | NONLEVY2019             | 3               | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | -52.22       | [AllocRef_NLA]            |
    | 202006                 | ORG0017104     | NONLEVY2019             | 4               | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | 1181.32      | [AllocRef_NLA]            |
    | 202006                 | ORG0017104     | NONLEVY2019             | 5               | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | -23.25       | [AllocRef_NLA]            |
    | 202006                 | ORG0017104     | NONLEVY2019             | 6               | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | -71.24       | [AllocRef_NLA]            |
    | 202006                 | ORG0017104     | NONLEVY2019             | 7               | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | 0.00         | [AllocRef_NLA]            |
    | 202006                 | ORG0017104     | NONLEVY2019             | 9               | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | 128.01       | [AllocRef_NLA]            |
    | 202006                 | ORG0017104     | NONLEVY2019             | 10              | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | 831.52       | [AllocRef_NLA]            |
    | 202006                 | ORG0017104     | NONLEVY2019             | 11              | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | 331.95       | [AllocRef_NLA]            |
    | 202006                 | ORG0017104     | NONLEVY2019             | 12              | 202006 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS02               | APPS           | 0.00         | [AllocRef_NLA]            |
    #
	| 202008                 | ORG0017104     | NONLEVY2019             | 2               | 202008 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS04               | APPS           | 377.90       | [AllocRef_NLA]            |
    | 202008                 | ORG0017104     | NONLEVY2019             | 3               | 202008 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS04               | APPS           | 1339.81      | [AllocRef_NLA]            |
    | 202008                 | ORG0017104     | NONLEVY2019             | 4               | 202008 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS04               | APPS           | 1140.42      | [AllocRef_NLA]            |
    | 202008                 | ORG0017104     | NONLEVY2019             | 5               | 202008 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS04               | APPS           | 0.00         | [AllocRef_NLA]            |
    | 202008                 | ORG0017104     | NONLEVY2019             | 6               | 202008 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS04               | APPS           | 430.90       | [AllocRef_NLA]            |
    | 202008                 | ORG0017104     | NONLEVY2019             | 7               | 202008 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS04               | APPS           | 171.58       | [AllocRef_NLA]            |
    | 202008                 | ORG0017104     | NONLEVY2019             | 9               | 202008 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS04               | APPS           | 1319.50      | [AllocRef_NLA]            |
    | 202008                 | ORG0017104     | NONLEVY2019             | 10              | 202008 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS04               | APPS           | 1336.59      | [AllocRef_NLA]            |
    | 202008                 | ORG0017104     | NONLEVY2019             | 11              | 202008 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS04               | APPS           | 1313.18      | [AllocRef_NLA]            |
    | 202008                 | ORG0017104     | NONLEVY2019             | 12              | 202008 | 10017104 | [ContractNo]   | 1               | 0                  | 22/06/2020          | APPS04               | APPS           | 357.45       | [AllocRef_NLA]            |
	 
    And   there are '20' rows in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017104'

    # Check PAAS after all PoI actuals have been processed (17385)
    And   PAAS table PaymentSchedule.DeliverablePayment contains the following values
    | AllocationNumber | VersionNumber | DeliverableCode | Period   | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | CollectionReturnCode | ActualVolume | ActualValue |
    | [AllocRef_NLA]   | 1             | 2               | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 991.52                      | 991.52           | APPS02               | ?            | 0.00        |
    | [AllocRef_NLA]   | 1             | 3               | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | -52.22                      | -52.22           | APPS02               | ?            | 0.00        |
    | [AllocRef_NLA]   | 1             | 4               | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1181.32                     | 1181.32          | APPS02               | ?            | 0.00        |
    | [AllocRef_NLA]   | 1             | 5               | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | -23.25                      | -23.25           | APPS02               | ?            | 0.00        |
    | [AllocRef_NLA]   | 1             | 6               | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | -71.24                      | -71.24           | APPS02               | ?            | 0.00        |
    | [AllocRef_NLA]   | 1             | 7               | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | APPS02               | ?            | 0.00        |
    | [AllocRef_NLA]   | 1             | 9               | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 128.01                      | 128.01           | APPS02               | ?            | 0.00        |
    | [AllocRef_NLA]   | 1             | 10              | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 831.52                      | 831.52           | APPS02               | ?            | 0.00        |
    | [AllocRef_NLA]   | 1             | 11              | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 331.95                      | 331.95           | APPS02               | ?            | 0.00        |
    | [AllocRef_NLA]   | 1             | 12              | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | APPS02               | ?            | 0.00        |
    #
	| [AllocRef_NLA]   | 1             | 2               | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 377.90                      | 377.90           | APPS04               | ?            | 0.00        |
    | [AllocRef_NLA]   | 1             | 3               | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1339.81                     | 1339.81          | APPS04               | ?            | 0.00        |
    | [AllocRef_NLA]   | 1             | 4               | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1140.42                     | 1140.42          | APPS04               | ?            | 0.00        |
    | [AllocRef_NLA]   | 1             | 5               | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | APPS04               | ?            | 0.00        |
    | [AllocRef_NLA]   | 1             | 6               | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 430.90                      | 430.90           | APPS04               | ?            | 0.00        |
    | [AllocRef_NLA]   | 1             | 7               | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 171.58                      | 171.58           | APPS04               | ?            | 0.00        |
    | [AllocRef_NLA]   | 1             | 9               | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1319.50                     | 1319.50          | APPS04               | ?            | 0.00        |
    | [AllocRef_NLA]   | 1             | 10              | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1336.59                     | 1336.59          | APPS04               | ?            | 0.00        |
    | [AllocRef_NLA]   | 1             | 11              | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1313.18                     | 1313.18          | APPS04               | ?            | 0.00        |
    | [AllocRef_NLA]   | 1             | 12              | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 357.45                      | 357.45           | APPS04               | ?            | 0.00        |

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   |
    | [ContractNo]   | [AllocRef_NLA]     | 1               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 8               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 13              | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 14              | 0.00      | 0.00     | 

    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Aug-20   |
    | [ContractNo]   | [AllocRef_NLA]     | 2               | 1369.42   | 991.52   | 377.90   | 
    | [ContractNo]   | [AllocRef_NLA]     | 3               | 1287.59   | -52.22   | 1339.81  | 
    | [ContractNo]   | [AllocRef_NLA]     | 4               | 2321.74   | 1181.32  | 1140.42  | 
    | [ContractNo]   | [AllocRef_NLA]     | 5               | -23.25    | -23.25   | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 6               | 359.66    | -71.24   | 430.90   | 
    | [ContractNo]   | [AllocRef_NLA]     | 7               | 171.58    | 0.00     | 171.58   | 
    | [ContractNo]   | [AllocRef_NLA]     | 9               | 1447.51   | 128.01   | 1319.50  | 
    | [ContractNo]   | [AllocRef_NLA]     | 10              | 2168.11   | 831.52   | 1336.59  | 
    | [ContractNo]   | [AllocRef_NLA]     | 11              | 1645.13   | 331.95   | 1313.18  | 
    | [ContractNo]   | [AllocRef_NLA]     | 12              | 357.45    | 0.00     | 357.45   | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   |
    | [ContractNo]   | [AllocRef_NLA]     | 1               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]     | 8               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]     | 13              | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]     | 14              | 0.00      | ?        | 

    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Aug-20   |
    | [ContractNo]   | [AllocRef_NLA]     | 2               | 1369.42   | 991.52   | 377.90   | 
    | [ContractNo]   | [AllocRef_NLA]     | 3               | 1287.59   | -52.22   | 1339.81  | 
    | [ContractNo]   | [AllocRef_NLA]     | 4               | 2321.74   | 1181.32  | 1140.42  | 
    | [ContractNo]   | [AllocRef_NLA]     | 5               | -23.25    | -23.25   | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 6               | 359.66    | -71.24   | 430.90   | 
    | [ContractNo]   | [AllocRef_NLA]     | 7               | 171.58    | 0.00     | 171.58   | 
    | [ContractNo]   | [AllocRef_NLA]     | 9               | 1447.51   | 128.01   | 1319.50  | 
    | [ContractNo]   | [AllocRef_NLA]     | 10              | 2168.11   | 831.52   | 1336.59  | 
    | [ContractNo]   | [AllocRef_NLA]     | 11              | 1645.13   | 331.95   | 1313.18  | 
    | [ContractNo]   | [AllocRef_NLA]     | 12              | 357.45    | 0.00     | 357.45   | 

    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Jun-20    | Aug-20    |
    | [ContractNo]   | [AllocRef_NLA]     | 2240200                  | 991.52    | 377.90    | 
    | [ContractNo]   | [AllocRef_NLA]     | 2240210                  | -52.22    | 1339.81   | 
    | [ContractNo]   | [AllocRef_NLA]     | 2240220                  | 1158.07   | 1140.42   | 
    | [ContractNo]   | [AllocRef_NLA]     | 2240230                  | -71.24    | 430.90    | 
    | [ContractNo]   | [AllocRef_NLA]     | 2240240                  | 0.00      | 171.58    | 
    | [ContractNo]   | [AllocRef_NLA]     | 2340200                  | 128.01    | 1319.50   | 
    | [ContractNo]   | [AllocRef_NLA]     | 2340210                  | 831.52    | 1336.59   | 
    | [ContractNo]   | [AllocRef_NLA]     | 2340220                  | 331.95    | 1670.63   | 
	
	
	# Tidy Up
	And   the override date is reset

