Feature: NonFinancialDocumentProcessing 22618

@AcceptanceTest @Withdrawn20230123
Scenario: A253 Create and approve an ESF1420 contract. Bulk amend with minimum-plus details. Approve. Initiate a non-financial variation amendment on v2 to create v3. Check doc, doc merge, CRM and workflow history
    Given there is no Contract, Task or Workflow data for UKPRN '10017253'
	And   there are no master contracts in CRM for master contract number 'ESFA-5253'
    And   the Allocation Delivery Monitoring Service atom feed is empty 
	And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017253'
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ESF-5253      |

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017253' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017253 Co Ltd' with UKPRN '10017253' and OrgId 'ORG0017253' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017253' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017253 | 117253 | 10017253 Co Ltd | 0              | In Administration     | Yes           | AA017253      | ?             | 6 Leck House           | Lake Street            | ?                      | ?                      | Leighton Buzzard       | Bedfordshire           | LU7 8TQ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017253 |



    # Change the date 
    And   the override date is '11/08/2017'     

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017253 | 10017253 Co Ltd      | ESFA-5253            | ESIF-5253      | 1                     | 01/08/2017        | 31/07/2018      | 150326.00     | Contract for Services | 1420   | New          | ORG0017253 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference | TenderAwardReference          | InvestmentPriority         | AgreementNumber | ActivityDescription | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017253 | ESIF-5253      | ESF-5253      | ESF 201420        | ESF                     | 01/08/2017          | 31/07/2018        | 150326.00       |                         |            | Skills Support for the Unemployed                           | New          | Leicester and Leicestershire LEP            | E37021       | 00-1         | TSS_20125                    | 20125/23-415-00-1/10017253    | 1.4 Active Inclusion       | 777\SD\7253     | Job Seekers Fund    | SSR                   | Transition     | 1.07                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                     | CRMIntent    | DeliveryOrg |
    | 10017253 | ESIF-5253      | ESF-5253      | 2               | 0                     |          | 38251.00  | 4260.00  | 291.00   | 2496.00  | 5179.00  | 4747.00  | 3486.00  | 1751.00  | 1825.00  | 4653.00  | 103.00   | 4569.00  | 4891.00  | RQ01 Regulated Learning                                    | New          |             |
    | 10017253 | ESIF-5253      | ESF-5253      | 3               | 0                     |          | 37807.00  | 4608.00  | 340.00   | 3563.00  | 2823.00  | 1803.00  | 2254.00  | 5773.00  | 5232.00  | 356.00   | 5699.00  | 2197.00  | 3159.00  | NR01 Non Regulated Activity                                | New          |             |
    | 10017253 | ESIF-5253      | ESF-5253      | 8               | 0                     |          | 47221.00  | 5917.00  | 5468.00  | 1376.00  | 4177.00  | 5881.00  | 3744.00  | 3894.00  | 1597.00  | 1690.00  | 4983.00  | 4951.00  | 3543.00  | SD01 Specification Defined Deliverable (with Description)  | New          |             |
    | 10017253 | ESIF-5253      | ESF-5253      | 9               | 0                     |          | 27047.00  | 618.00   | 636.00   | 4798.00  | 1721.00  | 293.00   | 1478.00  | 3213.00  | 656.00   | 5997.00  | 4064.00  | 113.00   | 3460.00  | SD02 Specification Defined Deliverable (with Description)  | New          |             |

    And   the contract exists in CRM 
    # Contract status is now at 'Awaiting Documentation' 

	# Check the deliverable count in CRM (essentially just a wait)
    Then  there are '48' deliverable period rows in CRM linked to the latest version of contract 'ESIF-5253'
    And   there are '48' deliverable periods in CRM linked to the latest version of contract 'ESIF-5253' and allocation 'ESF-5253'
 
    # Publish the contract 
    Given the latest version of contract 'ESIF-5253' is in a state of 'Published to Provider' 
 
    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-5253' and actual ContractNumber 'ESIF-5253' 
 
    # Check that the contract is now approved 
    Then  the latest version of contract 'ESIF-5253' is in status 'Approved' 
 
    # Check the deliverable count in CRM has not changed post-approval
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'ESIF-5253'
    And   there are '48' deliverable periods in CRM linked to the latest version of contract 'ESIF-5253' and allocation 'ESF-5253'




    # Change the date
    And   the override date is '22/03/2018'

    # Amend the contract (Use minimum fields - 23595 - but change start date)
    Given there are no files prefixed '10017253_ESIF-5253' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 14032018190711 v2_A253' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 14032018190711 v2_A253' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 14032018190711 v2_A253.xlsx' exists in the Datafiles folder and UKPRN '10017253' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the contents of the Appendices
    And   I retrieve the latest contract details from CRM for provider '10017253' for FundingType 'ESF' and period '1420'
    And   a file for this contract exists in sharepoint location 'ESF-1420-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    APPENDIX 1 - SUMMARY OF FUNDING
    Organisation Name: 10017253 Co Ltd
    UKPRN: 10017253
    Maximum
    Contract Ref Start Date End Date
    Contract Values
    Skills Support for the Unemployed ESF-5253 02/08/2017 31/07/2018 £114,349
    Total Funding for this contract £114,349
    Education and Skills Funding Agency Appendix 1 Master Contract ref: ESFA-5253

    Funding Agreement Skills Support for the Unemployed
    (Appendix 2)
    Leicester and Leicestershire LEP
    Provider: 10017253 Co Ltd UKPRN: 10017253
    Master Contract Ref: ESFA-5253 Start Date: 02/08/2017 End Date: 31/07/2018
    Contract Ref: ESF-5253 Tender Specification Ref: TSS_20125 Lot Ref: 00-1
    Specification Title: SSR Agreement: 777\SD\7253
    LEP: Leicester and Leicestershire LEP
    Unit Cost Total Jan 2017 Feb 2017 Mar 2017 Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017
    RQ01 Regulated Learning N/A £12,971 £833 £374 £1,054 £1,564 £731
    NR01 Non Regulated Activity N/A £14,841 £2,414 £68 £1,326 £748 £629
    SD01 Non accredited learning £3 £2,649 £36 £162 £348 £363 £444
    completion
    883 12 54 116 121 148
    SD02 Graduate placement £112 £83,888 £5,936 £8,848 £9,072 £8,512 £10,192
    749 53 79 81 76 91
    Total Funding £114,349 £9,219 £9,452 £11,800 £11,187 £11,996
    Ref (for internal use only):  ESIF-5253 v2
    Page 1 of 2 of this Funding Agreement

    Funding Agreement Skills Support for the Unemployed
    (Appendix 2)
    Leicester and Leicestershire LEP
    Provider: 10017253 Co Ltd UKPRN: 10017253
    Master Contract Ref: ESFA-5253 Start Date: 02/08/2017 End Date: 31/07/2018
    Contract Ref: ESF-5253 Tender Specification Ref: TSS_20125 Lot Ref: 00-1
    Specification Title: SSR Agreement: 777\SD\7253
    LEP: Leicester and Leicestershire LEP
    Unit Cost Jan 2018 Feb 2018 Mar 2018 Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018
    RQ01 Regulated Learning N/A £714 £85 £1,955 £748 £1,836 £2,465 £612
    NR01 Non Regulated Activity N/A £323 £1,224 £1,071 £2,193 £714 £1,921 £2,210
    SD01 Non accredited learning £3 £78 £33 £288 £423 £135 £312 £27
    completion
    26 11 96 141 45 104 9
    SD02 Graduate placement £112 £5,264 £3,024 £5,376 £15,232 £2,576 £2,352 £7,504
    47 27 48 136 23 21 67
    Total Funding £6,379 £4,366 £8,690 £18,596 £5,261 £7,050 £10,353
    Ref (for internal use only):  ESIF-5253 v2
    Page 2 of 2 of this Funding Agreement
    """


    # Check CONTRACT version, status and dates in CRM
    Then the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017253 | ESIF-5253          | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 02/08/2017        | 31/07/2018      | Variation     |
    | 10017253 | ESIF-5253          | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017253 | ESFA-5253          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Change the date 
    And   the override date is '24/03/2018' 
 
    # Publish the contract 
    And  the latest version of contract 'ESIF-5253' is in a state of 'Published to Provider' 

 
    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-5253' and actual ContractNumber 'ESIF-5253' 
 
    # Check that v2 of the contract is now approved 
    Then  the latest version of contract 'ESIF-5253' is in status 'Approved' 

    # Check CONTRACT version, status and dates in CRM
    Then the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017253 | ESIF-5253          | 2                     | 0                        | Approved         | Approved                  | True          | True                | 02/08/2017        | 31/07/2018      | Variation     |
    | 10017253 | ESIF-5253          | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017253 | ESFA-5253          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |




	# Change the date 
    Given the override date is '06/05/2018' 

    # Initiate non-financial amendment request on v2 to create v3
   #When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'ESIF-5253' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'ESIF-5253' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017253 | ESIF-5253          | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 02/08/2017        | 31/07/2018      | Variation     |
    | 10017253 | ESIF-5253          | 2                     | 0                        | Approved         | Approved                  | False         | True                | 02/08/2017        | 31/07/2018      | Variation     |
    | 10017253 | ESIF-5253          | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017253 | ESFA-5253          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
   
    # Check the WORKFLOW HISTORY for v2
    And   the workflow history on contract 'ESIF-5253' version '2' includes the following
    | Action                                  | CompletedBy     | Comment                        |
    | Initiate Non-Financial Amendment (Vary) | FCS2 Test      | ?                              |

    # Check the WORKFLOW HISTORY for v3
    And   the workflow history on contract 'ESIF-5253' version '3' includes the following
    | Action                                  | CompletedBy     | Comment                        |
    | Non-Financial Amendment Created         | CRM Integration | ?                              |

    # Check the current state of the TASKS for this contract
    And   the following Tasks are present against version '2' of contract 'ESIF-5253' for provider '10017253'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Initiate Document Merge          | 10017253 - 10017253 Co Ltd Awaiting documentation           | ESIF-5253      | Document Management Team  | ?                        | Open            | Not Started      |

    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017253' for FundingType 'ESF' and period '1420' and Delivery Organisation '11725301'
    And   I retrieve the latest contract details from CRM for provider '10017253' for FundingType 'ESF' and period '1420'

    # Check the contents of the Appendices. The details should be identical to v2, but the version number should now be v3
    And   a file for this contract exists in sharepoint location 'ESF-1420-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    APPENDIX 1 - SUMMARY OF FUNDING
    Organisation Name: 10017253 Co Ltd
    UKPRN: 10017253
    Maximum
    Contract Ref Start Date End Date
    Contract Values
    Skills Support for the Unemployed ESF-5253 02/08/2017 31/07/2018 £114,349
    Total Funding for this contract £114,349
    Education and Skills Funding Agency Appendix 1 Master Contract ref: ESFA-5253

    Funding Agreement Skills Support for the Unemployed
    (Appendix 2)
    Leicester and Leicestershire LEP
    Provider: 10017253 Co Ltd UKPRN: 10017253
    Master Contract Ref: ESFA-5253 Start Date: 02/08/2017 End Date: 31/07/2018
    Contract Ref: ESF-5253 Tender Specification Ref: TSS_20125 Lot Ref: 00-1
    Specification Title: SSR Agreement: 777\SD\7253
    LEP: Leicester and Leicestershire LEP
    Unit Cost Total Jan 2017 Feb 2017 Mar 2017 Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017
    RQ01 Regulated Learning N/A £12,971 £833 £374 £1,054 £1,564 £731
    NR01 Non Regulated Activity N/A £14,841 £2,414 £68 £1,326 £748 £629
    SD01 Non accredited learning £3 £2,649 £36 £162 £348 £363 £444
    completion
    883 12 54 116 121 148
    SD02 Graduate placement £112 £83,888 £5,936 £8,848 £9,072 £8,512 £10,192
    749 53 79 81 76 91
    Total Funding £114,349 £9,219 £9,452 £11,800 £11,187 £11,996
    Ref (for internal use only):  ESIF-5253 v3
	Page 1 of 2 of this Funding Agreement

    Funding Agreement Skills Support for the Unemployed
    (Appendix 2)
    Leicester and Leicestershire LEP
    Provider: 10017253 Co Ltd UKPRN: 10017253
    Master Contract Ref: ESFA-5253 Start Date: 02/08/2017 End Date: 31/07/2018
    Contract Ref: ESF-5253 Tender Specification Ref: TSS_20125 Lot Ref: 00-1
    Specification Title: SSR Agreement: 777\SD\7253
    LEP: Leicester and Leicestershire LEP
    Unit Cost Jan 2018 Feb 2018 Mar 2018 Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018
    RQ01 Regulated Learning N/A £714 £85 £1,955 £748 £1,836 £2,465 £612
    NR01 Non Regulated Activity N/A £323 £1,224 £1,071 £2,193 £714 £1,921 £2,210
    SD01 Non accredited learning £3 £78 £33 £288 £423 £135 £312 £27
    completion
    26 11 96 141 45 104 9
    SD02 Graduate placement £112 £5,264 £3,024 £5,376 £15,232 £2,576 £2,352 £7,504
    47 27 48 136 23 21 67
    Total Funding £6,379 £4,366 £8,690 £18,596 £5,261 £7,050 £10,353
    Ref (for internal use only):  ESIF-5253 v3
    Page 2 of 2 of this Funding Agreement
    """

	# Remove any Terms and Conditions files then add dummy files to Sharepoint
    Given there are no files prefixed '10017253_ESIF-5253' in the Sharepoint 'ESF-1420-Input-Terms And Conditions' folder
#   And   a copy of the file '10017253_ESIF-5253_11.pdf' in 'DataFiles\DummyFiles' exists in the Sharepoint 'ESF-1420-Input-Terms And Conditions' folder

   # Create a dummy Appendix file containing just the word 'Appendices'
   And   a file with filename '10017253_ESIF-5253_11.pdf' is created in 'ESF-1420-Input-Terms And Conditions'



    # Remove any Merged documents before running the Document Merge task
    And   there are no files prefixed '10017253_ESIF-5253' in the Sharepoint 'ESF-1420-Output-Merged Document' folder

    # Complete an existing open Task
    When the following open Task currently linked to version '3' of contract 'ESIF-5253' for provider '10017253' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    | 
    | Initiate Document Merge          | Document Management Team | 

    # Check that the merge Task has completed and a review Task has been created
    Then  the following Tasks are present against version '3' of contract 'ESIF-5253' for provider '10017253'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017253 - 10017253 Co Ltd Please review the contract       | ESIF-5253      | FCS2 Test                | Contract Advisers Team   | Open            | Not Started      |
    | Initiate Document Merge          | 10017253 - 10017253 Co Ltd Awaiting documentation           | ESIF-5253      | Document Management Team  | ?                        | Completed       | Completed        |

    And   there is '1' file prefixed '10017253_ESIF-5253' in the Sharepoint 'ESF-1420-Output-Merged Document' folder

    # Check the WORKFLOW HISTORY for v3
    And   the workflow history on contract 'ESIF-5253' version '3' includes the following
    | Action                                  | CompletedBy     | Comment                        |
    | Document Merge Successful               | CRM Integration | ?                              |
    | Initiate Document Merge                 | FCS2 Test       | ?                              |




    # Change the date 
    And   the override date is '12/05/2018' 
 
    # Publish the contract 
    And  the latest version of contract 'ESIF-5253' is in a state of 'Published to Provider' 

 
    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '3' actual MasterContractNumber 'ESFA-5253' and actual ContractNumber 'ESIF-5253' 
 
    # Check that v2 of the contract is now approved 
    Then  the latest version of contract 'ESIF-5253' is in status 'Approved' 

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017253 | ESIF-5253          | 3                     | 0                        | Approved         | Approved                  | True          | True                | 02/08/2017        | 31/07/2018      | Variation     |
    | 10017253 | ESIF-5253          | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 02/08/2017        | 31/07/2018      | Variation     |
    | 10017253 | ESIF-5253          | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2017        | 31/07/2018      | ?             |


    # Tidy up
    And   the override date is reset
   
@AcceptanceTest @Complete
@Long2Run @Long2Run123
Scenario: A254 Create and approve a 15mth NLAP2018 contract. Bulk amend v1 to create v2 adding 12mths to contract. Approve v2. Initiate a non-financial notification amendment on v2 to create v3. Check docs, CRM, workflow history and CDA
    Given there is no Contract, Task or Workflow data for UKPRN '10017254' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
	And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017254'
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

	# Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017254'



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017254' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017254 Co Ltd' with UKPRN '10017254' and OrgId 'ORG0017254' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017254' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017254 | 117254 | 10017254 Co Ltd | 0              | Active                | Yes           | AA017254      | ?             | 8 Beaumont Gate        | Shenley Hill           | ?                      | ?                      | Radlett                | Hertfordshire          | WD7 7AR   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017254 |



    # Change the date 
    Given the override date is '16/12/2017'     

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017254 | 10017254 Co Ltd      | ESFA-254             | NLAP-254       | 1                     | 01/01/2018        | 31/03/2019      | 35262.00      | Contract for Services | 2018   | New          | ORG0017254 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent    |
    | 10017254 | NLAP-254       | ANLP-254      | ANLAP             | NONLEVY                 | 01/01/2018          | 31/03/2019        | 17574.00        |         |         |                       | New          |
    | 10017254 | NLAP-254       | YNLP-254      | 16-18NLAP         | NONLEVY                 | 01/01/2018          | 31/03/2019        | 17688.00        |         |         |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                        | CRMIntent    |
    | 10017254 | NLAP-254       | ANLP-254      | 1               | 0                     | 17574.00 | 476.00   | 1710.00  | 1869.00  | 1535.00  | 1956.00  | 404.00   | 2020.00  | 506.00   | 2392.00  | 164.00   | 153.00   | 1983.00  | 949.00   | 1159.00  | 298.00   | Total 16-18 Non-Levy Apprenticeships Funding  | New          |
    | 10017254 | NLAP-254       | YNLP-254      | 1               | 0                     | 17688.00 | 569.00   | 1548.00  | 1225.00  | 1702.00  | 2217.00  | 926.00   | 756.00   | 732.00   | 375.00   | 1325.00  | 558.00   | 1461.00  | 909.00   | 2190.00  | 1195.00  | Total Adult Non-Levy Apprenticeships Funding  | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check that the deliverables have all been created in CRM
	Then  there are '30' deliverable period rows in CRM linked to the latest version of contract 'NLAP-254'
    And   there are '15' deliverable periods in CRM linked to the latest version of contract 'NLAP-254' and allocation 'ANLP-254'
    And   there are '15' deliverable periods in CRM linked to the latest version of contract 'NLAP-254' and allocation 'YNLP-254'
 
 

    # Change the date  
    Given the override date is '20/12/2017' 

    # Publish the contract
    And   the latest version of contract 'NLAP-254' is in a state of 'Published to Provider'
  
    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-254' and actual ContractNumber 'NLAP-254' 
 
    # Check that the contract is now approved 
    Then  the latest version of contract 'NLAP-254' is in status 'Approved' 
 
    # Check the deliverable count in CRM now includes the monitoring deliverables
    And   there are '150' deliverable period rows in CRM linked to the latest version of contract 'NLAP-254'
    And   there are '75' deliverable periods in CRM linked to the latest version of contract 'NLAP-254' and allocation 'ANLP-254'
    And   there are '75' deliverable periods in CRM linked to the latest version of contract 'NLAP-254' and allocation 'YNLP-254'

 #  # Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
 #  Given the following NLAP NewStarts profile values exist in config
 #  | UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
 #  | 10017254 | 0.00               | 0.00               | 0.00                                 | 0.00                                 |





    # Change the date
    Given the override date is '05/09/2018'

    # Bulk import to amend v1 and create v2. As there is no data in DocumentsDomain.NLAPFundingConfig for this provider, it should use the 'old' template
    And   there are no files prefixed '10017254_NLAP-254' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 15032018164718 v2_A254' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 15032018164718 v2_A254' in the Sharepoint 'Reports' folder
#   When  a copy of 'NLA NONLEVY 2018 15032018164718 v2_A254.xlsx' from 'DataFiles' is put in the Sharepoint 'Input' folder
    And   spreadsheet 'NLA NONLEVY 2018 15032018164718 v2_A254.xlsx' exists in the Datafiles folder and UKPRN '10017254' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017254' for FundingType 'NLA' and period '2018' and Delivery Organisation '10017254'
    And   I retrieve the latest contract details from CRM for provider '10017254' for FundingType 'NLA' and period '2018'

    # Check the contents of the Appendices for v2
    #And   the file named '10017254_NLAP-254_v2.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    #"""
    #APPENDIX 1 – SUMMARY OF FUNDING
    #Organisation Name: 10017254 Co Ltd UKPRN: 10017254
    #Master Contract Number: ESFA-254
    #Allocation
    #Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Apr 22 to Mar 23 Apr 23 to Mar 24 Apr 24 to Mar 25 Apr 25 to Mar 26 Total
    #16-18 Non-Levy Apprenticeships YNLP-254 £16,671 £49,667 £56,865 £0 £123,203
    #of which New Starts £0 £0
    #Adult Non-Levy Apprenticeships ANLP-254 £5,451 £38,906 £53,650 £0 £98,007
    #of which New Starts £0 £0
    #Total: £221,210
    #
    #Funding Agreement 16-18 Non-Levy Apprenticeships
    #Provider: 10017254 Co Ltd UKPRN: 10017254
    #Master Contract Ref: ESFA-254 Start Date: 01/01/2018 End Date: 31/03/2020
    #Contract Ref: YNLP-254
    #Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    #16-18 Non-Levy Apprenticeships £123,203 £6,580 £5,921 £4,170
    #Total Funding £123,203 £6,580 £5,921 £4,170
    #Ref (for internal use only):  NLAP-254 v2
    #Page 1 of 3 of this Funding Agreement
    #
    #Funding Agreement 16-18 Non-Levy Apprenticeships
    #Provider: 10017254 Co Ltd UKPRN: 10017254
    #Master Contract Ref: ESFA-254 Start Date: 01/01/2018 End Date: 31/03/2020
    #Contract Ref: YNLP-254
    #Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    #16-18 Non-Levy Apprenticeships £7,312 £5,836 £4,425 £6,548 £178 £5,497 £5,444 £3,490 £1,399 £5,561 £1,028 £2,949
    #Total Funding £7,312 £5,836 £4,425 £6,548 £178 £5,497 £5,444 £3,490 £1,399 £5,561 £1,028 £2,949
    #Ref (for internal use only):  NLAP-254 v2
    #Page 2 of 3 of this Funding Agreement
    #
    #Funding Agreement 16-18 Non-Levy Apprenticeships
    #Provider: 10017254 Co Ltd UKPRN: 10017254
    #Master Contract Ref: ESFA-254 Start Date: 01/01/2018 End Date: 31/03/2020
    #Contract Ref: YNLP-254
    #Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    #16-18 Non-Levy Apprenticeships £5,136 £2,301 £4,966 £2,811 £3,438 £7,397 £5,582 £5,189 £4,255 £7,057 £6,601 £2,132
    #Total Funding £5,136 £2,301 £4,966 £2,811 £3,438 £7,397 £5,582 £5,189 £4,255 £7,057 £6,601 £2,132
    #Ref (for internal use only):  NLAP-254 v2
    #Page 3 of 3 of this Funding Agreement
    #
    #Funding Agreement Adult Non-Levy Apprenticeships
    #Provider: 10017254 Co Ltd UKPRN: 10017254
    #Master Contract Ref: ESFA-254 Start Date: 01/01/2018 End Date: 31/03/2020
    #Contract Ref: ANLP-254
    #Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    #Adult Non-Levy Apprenticeships £98,007 £3,235 £657 £1,559
    #Total Funding £98,007 £3,235 £657 £1,559
    #Ref (for internal use only):  NLAP-254 v2
    #Page 1 of 3 of this Funding Agreement
    #
    #Funding Agreement Adult Non-Levy Apprenticeships
    #Provider: 10017254 Co Ltd UKPRN: 10017254
    #Master Contract Ref: ESFA-254 Start Date: 01/01/2018 End Date: 31/03/2020
    #Contract Ref: ANLP-254
    #Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    #Adult Non-Levy Apprenticeships £965 £2,748 £3,237 £5,498 £827 £1,050 £2,493 £4,002 £3,205 £7,706 £2,154 £5,021
    #Total Funding £965 £2,748 £3,237 £5,498 £827 £1,050 £2,493 £4,002 £3,205 £7,706 £2,154 £5,021
    #Ref (for internal use only):  NLAP-254 v2
    #Page 2 of 3 of this Funding Agreement
    #
    #Funding Agreement Adult Non-Levy Apprenticeships
    #Provider: 10017254 Co Ltd UKPRN: 10017254
    #Master Contract Ref: ESFA-254 Start Date: 01/01/2018 End Date: 31/03/2020
    #Contract Ref: ANLP-254
    #Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    #Adult Non-Levy Apprenticeships £148 £3,088 £2,218 £604 £5,445 £6,825 £6,910 £6,655 £7,419 £5,126 £4,054 £5,158
    #Total Funding £148 £3,088 £2,218 £604 £5,445 £6,825 £6,910 £6,655 £7,419 £5,126 £4,054 £5,158
    #Ref (for internal use only):  NLAP-254 v2
    #Page 3 of 3 of this Funding Agreement
    #"""

    # Check CONTRACT version, status and dates in CRM
    And  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017254 | NLAP-254           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/01/2018        | 31/03/2020      | Variation     |
    | 10017254 | NLAP-254           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/01/2018        | 31/03/2019      | ?             |
    | 10017254 | ESFA-254           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




    # Change the date 
    Given the override date is '07/09/2018' 
 
    # Publish the contract 
    And  the latest version of contract 'NLAP-254' is in a state of 'Published to Provider' 
 
    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-254' and actual ContractNumber 'NLAP-254' 
 
    # Check that v2 of the contract is now approved 
    Then  the latest version of contract 'NLAP-254' is in status 'Approved' 

    # Check CONTRACT version, status and dates in CRM
    And  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017254 | NLAP-254           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2020      | Variation     |
    | 10017254 | NLAP-254           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/01/2018        | 31/03/2019      | ?             |
    | 10017254 | ESFA-254           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




    # Change the date 
    Given the override date is '22/11/2019' 

	# Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   the following NLAP NewStarts profile values exist in config
	| UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
    | 10017254 | 0.00               | 0.00               | 0.00                                 | 0.00                                 |

    # Initiate non-financial amendment request on v2 to create v3. As there is data in DocumentsDomain.NLAPFundingConfig for this provider, it should use the 'new' template
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'NLAP-254' for a non-financial NOTIFICATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'NLAP-254' for a non-financial VARIATION contract amendment


    # Check the deliverable count in CRM
    Then  there are '54' deliverable period rows in CRM linked to the latest version of contract 'NLAP-254'
    And   there are '27' deliverable periods in CRM linked to the latest version of contract 'NLAP-254' and allocation 'ANLP-254'
    And   there are '27' deliverable periods in CRM linked to the latest version of contract 'NLAP-254' and allocation 'YNLP-254'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017254 | NLAP-254           | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/01/2018        | 31/03/2020      | Notification  |
    | 10017254 | NLAP-254           | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/01/2018        | 31/03/2020      | Variation     |
    | 10017254 | NLAP-254           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/01/2018        | 31/03/2019      | ?             |
    | 10017254 | ESFA-254           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |



    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017254' for FundingType 'NLA' and period '2018' and Delivery Organisation '10017254'
    And   I retrieve the latest contract details from CRM for provider '10017254' for FundingType 'NLA' and period '2018'
	
    # Check the contents of the Appendices. The financials should be unchanged from v2, but the version number should v3 and the 'new' template used.
   # And   the file named '10017254_' & 'NLAP-254' & '_v3.pdf' created in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
   # """
   # APPENDIX 1 – SUMMARY OF FUNDING
   # Organisation Name: 10017254 Co Ltd UKPRN: 10017254
   # Master Contract Number: ESFA-254
   # Allocation
   # Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Apr 22 to Mar 23 Apr 23 to Mar 24 Apr 24 to Mar 25 Apr 25 to Mar 26 Total
   # 16-18 Non-Levy Apprenticeships YNLP-254 £16,671 £49,667 £56,865 £0 £123,203
   # of which New Starts £0 £0
   # Adult Non-Levy Apprenticeships ANLP-254 £5,451 £38,906 £53,650 £0 £98,007
   # of which New Starts £0 £0
   # Total: £221,210
   #
   # Funding Agreement 16-18 Non-Levy Apprenticeships
   # Provider: 10017254 Co Ltd UKPRN: 10017254
   # Master Contract Ref: ESFA-254 Start Date: 01/01/2018 End Date: 31/03/2020
   # Contract Ref: YNLP-254
   # Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
   # 16-18 Non-Levy Apprenticeships £123,203 £6,580 £5,921 £4,170
   # Total Funding £123,203 £6,580 £5,921 £4,170
   # Ref (for internal use only):  NLAP-254 v3
   # Page 1 of 3 of this Funding Agreement
   #
   # Funding Agreement 16-18 Non-Levy Apprenticeships
   # Provider: 10017254 Co Ltd UKPRN: 10017254
   # Master Contract Ref: ESFA-254 Start Date: 01/01/2018 End Date: 31/03/2020
   # Contract Ref: YNLP-254
   # Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
   # 16-18 Non-Levy Apprenticeships £7,312 £5,836 £4,425 £6,548 £178 £5,497 £5,444 £3,490 £1,399 £5,561 £1,028 £2,949
   # Total Funding £7,312 £5,836 £4,425 £6,548 £178 £5,497 £5,444 £3,490 £1,399 £5,561 £1,028 £2,949
   # Ref (for internal use only):  NLAP-254 v3
   # Page 2 of 3 of this Funding Agreement
   #
   # Funding Agreement 16-18 Non-Levy Apprenticeships
   # Provider: 10017254 Co Ltd UKPRN: 10017254
   # Master Contract Ref: ESFA-254 Start Date: 01/01/2018 End Date: 31/03/2020
   # Contract Ref: YNLP-254
   # Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
   # 16-18 Non-Levy Apprenticeships £5,136 £2,301 £4,966 £2,811 £3,438 £7,397 £5,582 £5,189 £4,255 £7,057 £6,601 £2,132
   # Total Funding £5,136 £2,301 £4,966 £2,811 £3,438 £7,397 £5,582 £5,189 £4,255 £7,057 £6,601 £2,132
   # Ref (for internal use only):  NLAP-254 v3
   # Page 3 of 3 of this Funding Agreement
   #
   # Funding Agreement Adult Non-Levy Apprenticeships
   # Provider: 10017254 Co Ltd UKPRN: 10017254
   # Master Contract Ref: ESFA-254 Start Date: 01/01/2018 End Date: 31/03/2020
   # Contract Ref: ANLP-254
   # Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
   # Adult Non-Levy Apprenticeships £98,007 £3,235 £657 £1,559
   # Total Funding £98,007 £3,235 £657 £1,559
   # Ref (for internal use only):  NLAP-254 v3
   # Page 1 of 3 of this Funding Agreement
   #
   # Funding Agreement Adult Non-Levy Apprenticeships
   # Provider: 10017254 Co Ltd UKPRN: 10017254
   # Master Contract Ref: ESFA-254 Start Date: 01/01/2018 End Date: 31/03/2020
   # Contract Ref: ANLP-254
   # Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
   # Adult Non-Levy Apprenticeships £965 £2,748 £3,237 £5,498 £827 £1,050 £2,493 £4,002 £3,205 £7,706 £2,154 £5,021
   # Total Funding £965 £2,748 £3,237 £5,498 £827 £1,050 £2,493 £4,002 £3,205 £7,706 £2,154 £5,021
   # Ref (for internal use only):  NLAP-254 v3
   #
   # Funding Agreement Adult Non-Levy Apprenticeships
   # Provider: 10017254 Co Ltd UKPRN: 10017254
   # Master Contract Ref: ESFA-254 Start Date: 01/01/2018 End Date: 31/03/2020
   # Contract Ref: ANLP-254
   # Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
   # Adult Non-Levy Apprenticeships £148 £3,088 £2,218 £604 £5,445 £6,825 £6,910 £6,655 £7,419 £5,126 £4,054 £5,158
   # Total Funding £148 £3,088 £2,218 £604 £5,445 £6,825 £6,910 £6,655 £7,419 £5,126 £4,054 £5,158
   # Ref (for internal use only):  NLAP-254 v3
   # Page 3 of 3 of this Funding Agreement
   # """


    # Check the WORKFLOW HISTORY for v2
    And   the workflow history on contract 'NLAP-254' version '2' includes the following
    | Action                                    | CompletedBy      | Comment                     |
    | Initiate Non-Financial Amendment (Notify) | FCS2 Test        | ?                           |

    # Check the WORKFLOW HISTORY for v3
    And   the workflow history on contract 'NLAP-254' version '3' includes the following
    | Action                                    | CompletedBy      | Comment                     |
    | Non-Financial Amendment Created           | CRM Integration  | ?                           |




    
#     Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version A254.csv'
#
#    Then  the contracts are in the replicated CRM database as follows
#    | ContractNumber | ContractVersionNumber |
#    | NLAP-254       | 2                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod      | Version               | Suffix |
#    | 16-18NLAP2018,ANLAP2018  | Latest Version        | A254   |
#
#    Then  a report named 'CDA Latest Version A254.csv' is created
#
#     Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 1                 | 2018            | 2017/18       |              | 6580         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 2                 | 2018            | 2017/18       |              | 5921         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 3                 | 2018            | 2017/18       |              | 4170         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 4                 | 2018            | 2018/19       |              | 7312         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 5                 | 2018            | 2018/19       |              | 5836         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 6                 | 2018            | 2018/19       |              | 4425         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 7                 | 2018            | 2018/19       |              | 6548         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 8                 | 2018            | 2018/19       |              | 178          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 9                 | 2018            | 2018/19       |              | 5497         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 10                | 2018            | 2018/19       |              | 5444         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 11                | 2018            | 2018/19       |              | 3490         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 12                | 2018            | 2018/19       |              | 1399         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 1                 | 2019            | 2018/19       |              | 5561         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 2                 | 2019            | 2018/19       |              | 1028         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 3                 | 2019            | 2018/19       |              | 2949         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 4                 | 2019            | 2019/20       |              | 5136         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 5                 | 2019            | 2019/20       |              | 2301         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 6                 | 2019            | 2019/20       |              | 4966         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 7                 | 2019            | 2019/20       |              | 2811         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 8                 | 2019            | 2019/20       |              | 3438         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 9                 | 2019            | 2019/20       |              | 7397         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 10                | 2019            | 2019/20       |              | 5582         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 11                | 2019            | 2019/20       |              | 5189         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 12                | 2019            | 2019/20       |              | 4255         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 1                 | 2020            | 2019/20       |              | 7057         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 2                 | 2020            | 2019/20       |              | 6601         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | 16-18NLAP2018           | 10017254 | 10017254 Co Ltd             |               |                             | YNLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total 16-18 Non-Levy Apprenticeships Funding                    |                                                                 | 3                 | 2020            | 2019/20       |              | 2132         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 4                 | 2018            | 2018/19       |              | 965          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 5                 | 2018            | 2018/19       |              | 2748         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 6                 | 2018            | 2018/19       |              | 3237         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 7                 | 2018            | 2018/19       |              | 5498         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 8                 | 2018            | 2018/19       |              | 827          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 9                 | 2018            | 2018/19       |              | 1050         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 10                | 2018            | 2018/19       |              | 2493         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 11                | 2018            | 2018/19       |              | 4002         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 12                | 2018            | 2018/19       |              | 3205         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 1                 | 2019            | 2018/19       |              | 7706         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 2                 | 2019            | 2018/19       |              | 2154         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 3                 | 2019            | 2018/19       |              | 5021         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 4                 | 2019            | 2019/20       |              | 148          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 5                 | 2019            | 2019/20       |              | 3088         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 6                 | 2019            | 2019/20       |              | 2218         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 7                 | 2019            | 2019/20       |              | 604          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 8                 | 2019            | 2019/20       |              | 5445         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 9                 | 2019            | 2019/20       |              | 6825         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 10                | 2019            | 2019/20       |              | 6910         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 11                | 2019            | 2019/20       |              | 6655         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 12                | 2019            | 2019/20       |              | 7419         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 1                 | 2020            | 2019/20       |              | 5126         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 2                 | 2020            | 2019/20       |              | 4054         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | ANLAP2018               | 10017254 | 10017254 Co Ltd             |               |                             | ANLP-254                 | NLAP-254       | ESFA-254                | 01/01/2018                  | 31/03/2020                | 3                     | Draft          | Awaiting Documentation  |                                                      | Total Adult Non-Levy Apprenticeships Funding                    |                                                                 | 3                 | 2020            | 2019/20       |              | 5158         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |


    # Tidy up
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017254'
    And   the override date is reset

