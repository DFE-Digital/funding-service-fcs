Feature: CustomLetters 35833

@AcceptanceTest @Withdrawn20220120
Scenario: A862 Create and approve a Levy contract. Singleton amendment. Initiate Termination. Singleton amend 3x. Terminate then issue new contract. Check docs. (As A169 but with ShouldMergeAmendmentTemplate=No)

    # 1. Create and approve a Levy contract and check docs
    # 2. Singleton amendment > v2. Letter = LEVY1799_Amendment_No-TD_DUMMY.docx  Agreement\Ts&Cs = null
    # 3. Issue contract termination
    # 4. Singleton amendment > v3. Letter = LEVY1799_Amendment_TD_DUMMY.docx     Agreement\Ts&Cs = T&C_LEVY_Under_Term_DUMMY_2017-05-01.docx 
    # 5. Singleton amendment > v4. Letter = null                                 Agreement\Ts&Cs = null
    # 6. Singleton amendment > v5. Letter = null                                 Agreement\Ts&Cs = T&C_LEVY_Under_Term_DUMMY_2017-05-01.docx
    # 7. Complete termination
    # 8. Create new Levy contract for same provider and check docs

    # Note: Standard Letter = THIS VARIATION is made ...
    #       Custom Letter   = THIS TEST VARIATION is made ...

    Given there are no allocations marked as Under Termination for UKPRN '10017862' 
    And   there are no terminated or closed allocations for UKPRN '10017862' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017862' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017862' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017862' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017862' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017862' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table 
    And   there are no DAS engagement events stored in FCS 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017862' 
 
    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS 
 
    # Clear down all subnominal data from PaaS for an FSP 
    And   there is no Subnominal data in PaaS for the following FSPs 
    | FSP            | 
    | LEVY1799       | 
    | NONLEVY2019    | 
 
 
 
 
    # Remove the provider from RoATP (ContractManagement.RoATPProvider) 
    And   there is no data on RoATP for the following providers 
    | Ukprn    | 
    | 10017862 | 
 
    # Add the provider to RoATP (ContractManagement.RoATPProvider) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017862 | 10017862 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 
 
 
 
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017862' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017862 Co Ltd' with UKPRN '10017862' and OrgId 'ORG0017862' and has 'FCS1 Test' as a manager 
 
    # Put data in the PaaS Organisation table (Organisation.Organisation) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017862 | 117862 | 10017862 Co Ltd | 0              | Active                | Yes           | AA017862      | ?             | 10 Albyn Place         | Edinburgh              | ?                      | ?                      | ?                      | ?                      | EH2 4NG   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017862 |

 
 
 
    # Change the date 
    Given the override date is '16/03/2020' 
 
    # Inject data into the stub to create a contract with two allocations 
   #And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation 
    And   the following Levy event data is available in the DAS agreement stub 
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 62862 | INITIATED | 2019-12-15T18:03:12.2862 | 10017862   | 28862             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017862' 
    Then  there is only one Levy contract in CRM for UKPRN '10017862' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017862' for FundingType 'LEVY' and period '1799' 
 
 
 
 
 
    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017862 | 10017862 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017862 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017862 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017862 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017862 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017862 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017862 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017862 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 
 
    And   there are no open tasks for the contract 
    And   there is no contract owner assigned to the latest version of the contract 
 
    # Check deliverable period count prior to approval 
    And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
 
 
 
    # Check Contract documentation (16390) - Agreement\Ts&Cs only 
    And   the file named '10017862_[ContractNo]_v1.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
    """ 
    ESFA Apprenticeship Agreement for Training Providers
    THIS AGREEMENT is made on the date the Agreement is digitally signed by the Training
    Provider through the Manage Your Education and Skills Funding Service having
    already been signed by the ESFA and is between:
    10017862 Co Ltd THE SECRETARY OF STATE FOR
    10 Albyn Place EDUCATION ACTING THROUGH
    Edinburgh THE EDUCATION AND SKILLS
    EH2 4NG FUNDING AGENCY, AN
    EXECUTIVE AGENCY OF THE
    AND
    DEPARTMENT OF EDUCATION
    Company No: AA017862 CHEYLESMORE HOUSE
    UKPRN: 10017862 QUINTON ROAD
    COVENTRY
    CV1 2WT
    “Expiry Date” means 31 July 2025 or such later date as is notified in writing by
    the ESFA and agreed by the Training Provider in accordance with
    Clause 3 (Commencement and Duration).

    ESFA Apprenticeship Agreement for Training Providers, Winter 2022, Version 4.0
    Education & Skills Funding Agency
    https://www.gov.uk/government/organisations/education-and-skills-funding-agency
    55
    """ 
 
    # The Amendment Letter is not included
    And   the pdf file does not contain the following text
    """
    Agreement number: [MasterContractNo] 
    """
    
    # Save a copy of the output 
    And   Sharepoint file '10017862_[ContractNo]_v1.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A862v1.pdf' 
 
 
 
 
    # Change the date 
    Given the override date is '09/04/2020' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 
 
    # Check deliverable period count after approval 
    Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # After approval there should be a Apr-20 deliverable period for each of deliverables 1 through 14 for each allocation 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Apr-20   | DeliverableDescription                               | 
    | 10017862 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017862 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017862 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017862 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017862 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017862 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017862 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017862 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017862 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017862 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017862 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017862 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017862 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017862 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
    # 
    | 10017862 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017862 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017862 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017862 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017862 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017862 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017862 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017862 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017862 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017862 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017862 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017862 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017862 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017862 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 
 
    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017862 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 09/04/2020        | ?               | ?             | 
    | 10017862 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 
 
    # Check ALLOCATION dates in CRM 
    And   the following allocation values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | 
    | 10017862 | [ContractNo]       | 1                     | [AllocRef_LEVY]     | 09/04/2020          | ?                 | 
    | 10017862 | [ContractNo]       | 1                     | [AllocRef_NLA]      | 09/04/2020          | ?                 | 
 
 
 
 
    # Issue a variation amendment against approved contract v1 to create draft v2 and check docs
     
    # Change the date 
    Given the override date is '01/08/2021' 
 
    # Month end is not running 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
     
    # Issue a contract amendment request 
    When  a request is issued to amend the following Levy contract via Single 
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status    | SubStatus   | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate | AllowUnderTermination | LetterTemplateName                   | AgreementTemplateName   |
    | 10017862 | [MasterContractNo]   | [ContractNo]   | 1       | Approved  | Approved    | Variation     | No                       | No                           | Yes                   | LEVY1799_Amendment_No-TD_DUMMY.docx  | ?                       | 
 
    And   wait '15' seconds 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step  
    Then  the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |  
    | Draft  | Published to Provider  | Yes           | No                  | 2                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017862' for FundingType 'LEVY' and period '1799' 
 
    # Check Contract documentation - Custom letter but no Agreement doc
    And   the file named '10017862_[ContractNo]_v2.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
    """ 
    THIS TEST VARIATION is made on the date the Variation is digitally signed by the
    Training Provider on the Manage your education and skills funding service (“the
    Variation Date”).
    BETWEEN: -
    (1) THE SECRETARY OF STATE FOR EDUCATION acting through the
    Education and Skills Funding Agency an Executive Agency of the Department
    for Education of Cheylesmore House, Quinton Road, Coventry, CV1 2WT (“the
    ESFA"); and
    (2) 10017862 Co Ltd Company No: AA017862 (10017862) whose registered office
    is situated at 10 Albyn Place, Edinburgh, EH2 4NG ("the Training Provider").
    RECITALS: -
    (A) The ESFA and the Training Provider entered into an Apprenticeship Agreement
    for the provision of Apprenticeship Training with the ESFA's reference number
    of [MasterContractNo] ("Original Contract").
    Contract reference: [MasterContractNo]
    """ 
 
    # The Agreement doc is not included
    And   the pdf file does not contain the following text
    """
    THIS AGREEMENT is made on the date the Agreement is digitally signed by the
    """
    
    # Save a copy of the output 
    And   Sharepoint file '10017862_[ContractNo]_v2.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A862v2.pdf' 
 




    # Approve contract v2

    # Change the date 
    Given the override date is '03/08/2021' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2' 
 
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus  | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017862 | [ContractNo]       | 2                     | 0                        | Approved         | Approved           | True          | True                | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved           | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017862 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                  | False         | False               | 01/05/2017        | ?               | ?             |

 
 
 

    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '04/10/2021'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | [ContractNo]  | 2               | 0                  | 01/10/2021              | Other                       | Company struck off                  |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | [AllocRef_LEVY]    | 16/08/2021                   | 23/08/2021                      |
    | [AllocRef_NLA]     | 13/08/2021                   | 20/08/2021                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017862 | [ContractNo]   | 2                     | 0                        | 01/10/2021                 | Other                        | ?                              | 01/10/2021              | Other                       | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017862 | [ContractNo]  | [AllocRef_LEVY]  | 2                     | 0                        | 16/08/2021                   | 16/08/2021        | 23/08/2021                      | 23/08/2021           |
    | 10017862 | [ContractNo]  | [AllocRef_NLA]   | 2                     | 0                        | 13/08/2021                   | 13/08/2021        | 20/08/2021                      | 20/08/2021           |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017862 | [ContractNo]       | 2                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 09/04/2020        | ?               | Variation     |
    | 10017862 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |





    # Approve Termination Initiation (30635)

    # Change the date - CRM ignores this
    Given the override date is '05/10/2021'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task
    When the following open Task currently linked to version '2' of contract '[ContractNo]' for provider '10017862' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Termination Initiation Approval  | Contract Managers Team    |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus  | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017862 | [ContractNo]       | 2                     | 0                        | Approved         | Under Termination  | True          | True                | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved           | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017862 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                  | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the Termination details on the contract in CRM (These should not have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017862 | [ContractNo]   | 2                     | 0                        | 01/10/2021                 | Other                        | ?                              | 01/10/2021              | Other                       | ?                             |

    # Check the Termination details on the allocations in CRM (These should not have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017862 | [ContractNo]  | [AllocRef_LEVY]  | 2                     | 0                        | 16/08/2021                   | 16/08/2021        | 23/08/2021                      | 23/08/2021           |
    | 10017862 | [ContractNo]  | [AllocRef_NLA]   | 2                     | 0                        | 13/08/2021                   | 13/08/2021        | 20/08/2021                      | 20/08/2021           |


    


    # Issue a variation amendment against contract v2 to create draft v3 and check docs
     
    # Change the date 
    Given the override date is '06/10/2021' 
 
    # Month end is not running 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
     
    # Issue a contract amendment request 
    When  a request is issued to amend the following Levy contract via Single 
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status    | SubStatus         | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate | AllowUnderTermination | LetterTemplateName                | AgreementTemplateName                      |
    | 10017862 | [MasterContractNo]   | [ContractNo]   | 2       | Approved  | Under Termination | Variation     | No                       | No                           | Yes                   | LEVY1799_Amendment_TD_DUMMY.docx  | T&C_LEVY_Under_Term_DUMMY_2017-05-01.docx  | 
 
    And   wait '15' seconds 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step  
    Then  the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |  
    | Draft  | Published to Provider  | Yes           | No                  | 3                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017862' for FundingType 'LEVY' and period '1799' 
 
    # Check Contract documentation - Custom letter but no Agreement doc
    And   the file named '10017862_[ContractNo]_v3.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
    """ 
    THIS TEST VARIATION is made on the date the Variation is digitally signed by the
    Training Provider on the Manage your education and skills funding service (“the
    Variation Date”).
    Termination Date: 1 October 2021.
    BETWEEN: -
    (1) THE SECRETARY OF STATE FOR EDUCATION acting through the
    Education and Skills Funding Agency an Executive Agency of the Department
    for Education of Cheylesmore House, Quinton Road, Coventry, CV1 2WT (“the
    ESFA"); and
    (2) 10017862 Co Ltd Company No: AA017862 (10017862) whose registered office
    is situated at 10 Albyn Place, Edinburgh, EH2 4NG ("the Training Provider").
    RECITALS: -
    (A) The ESFA and the Training Provider entered into an Apprenticeship Agreement
    for the provision of Apprenticeship Training with the ESFA's reference number
    of [MasterContractNo] ("Original Contract").
    Contract reference: [MasterContractNo]
    """

    # The Agreement doc is not included 
    And   the pdf file does not contain the following text
    """
    THIS AGREEMENT is made on the date the Agreement is digitally signed by the
    """
 
    # Save a copy of the output 
    And   Sharepoint file '10017862_[ContractNo]_v3.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A862v3.pdf' 
 
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017862 | [ContractNo]       | 3                     | 0                        | Draft            | Published to Provider                     | True          | False               | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 2                     | 0                        | Approved         | Under Termination                         | False         | True                | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017862 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/05/2017        | ?               | ?             |





    # Approve contract v3

    # Change the date 
    Given the override date is '07/10/2021' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '3' 
 
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus  | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017862 | [ContractNo]       | 3                     | 0                        | Approved         | Under Termination  | True          | True                | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved           | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017862 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                  | False         | False               | 01/05/2017        | ?               | ?             |





    # Issue a variation amendment against contract v3 to create draft v4 and check docs
     
    # Change the date 
    Given the override date is '09/10/2021' 
 
    # Month end is not running 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
     
    # Issue a contract amendment request 
    When  a request is issued to amend the following Levy contract via Single 
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status    | SubStatus         | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate | AllowUnderTermination | LetterTemplateName                | AgreementTemplateName                      |
    | 10017862 | [MasterContractNo]   | [ContractNo]   | 3       | Approved  | Under Termination | Variation     | No                       | No                           | Yes                   | ?                                 | ?                                          | 
 
    And   wait '15' seconds 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step  
    Then  the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |  
    | Draft  | Published to Provider  | Yes           | No                  | 4                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017862' for FundingType 'LEVY' and period '1799' 
 
    # Check Contract documentation (16390) - Standard letter but no Agreement doc
    And   the file named '10017862_[ContractNo]_v4.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
    """ 
    THIS VARIATION is made on the date the Variation is digitally signed by the Training
    Provider on the “Manage your education and skills funding service” (“the Variation
    Date”).
    BETWEEN: -
    (1) THE SECRETARY OF STATE FOR EDUCATION acting through the
    Education and Skills Funding Agency an Executive Agency of the Department
    for Education of Cheylesmore House, Quinton Road, Coventry, CV1 2WT (“the
    ESFA”); and
    (2) 10017862 Co Ltd Company No: AA017862 (10017862) whose registered office
    is situated at 10 Albyn Place, Edinburgh, EH2 4NG (“the Training Provider”).
    RECITALS: -
    (A) The ESFA and the Training Provider entered into an Apprenticeship Agreement
    for the provision of Apprenticeship Training with the ESFA’s reference number
    of [MasterContractNo] ("Original Agreement").
    (B) The ESFA and the Training Provider have agreed to vary the terms of the
    Original Agreement as set out in this Variation.
    (C) The ESFA’s reference number for this Variation is Winter 2022, Version 4.0.

    Agreement number: [MasterContractNo]
    """

    # The Agreement doc is not included 
    And   the pdf file does not contain the following text
    """
    THIS AGREEMENT is made on the date the Agreement is digitally signed by the
    """
 
    # Save a copy of the output 
    And   Sharepoint file '10017862_[ContractNo]_v4.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A862v4.pdf' 
 
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017862 | [ContractNo]       | 4                     | 0                        | Draft            | Published to Provider   | True          | False               | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 3                     | 0                        | Approved         | Under Termination       | False         | True                | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination       | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017862 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/05/2017        | ?               | ?             |





    # Approve contract v4

    # Change the date 
    Given the override date is '10/10/2021' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '4' 
 
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus  | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017862 | [ContractNo]       | 4                     | 0                        | Approved         | Under Termination  | True          | True                | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 3                     | 0                        | Replaced         | Under Termination  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved           | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017862 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                  | False         | False               | 01/05/2017        | ?               | ?             |





    # Issue a variation amendment against contract v4 to create draft v5 and check docs
     
    # Change the date 
    Given the override date is '12/10/2021' 
 
    # Month end is not running 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
     
    # Issue a contract amendment request 
    When  a request is issued to amend the following Levy contract via Single 
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status    | SubStatus         | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate | AllowUnderTermination | LetterTemplateName                | AgreementTemplateName                      |
    | 10017862 | [MasterContractNo]   | [ContractNo]   | 4       | Approved  | Under Termination | Variation     | No                       | No                           | Yes                   | ?                                 | T&C_LEVY_Under_Term_DUMMY_2017-05-01.docx  | 
 
    And   wait '15' seconds 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step  
    Then  the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |  
    | Draft  | Published to Provider  | Yes           | No                  | 5                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017862' for FundingType 'LEVY' and period '1799' 
 
    # Check Contract documentation (16390) - Standard letter but no Agreement doc
    And   the file named '10017862_[ContractNo]_v5.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
    """ 
    THIS VARIATION is made on the date the Variation is digitally signed by the Training
    Provider on the “Manage your education and skills funding service” (“the Variation
    Date”).
    BETWEEN: -
    (1) THE SECRETARY OF STATE FOR EDUCATION acting through the
    Education and Skills Funding Agency an Executive Agency of the Department
    for Education of Cheylesmore House, Quinton Road, Coventry, CV1 2WT (“the
    ESFA”); and
    (2) 10017862 Co Ltd Company No: AA017862 (10017862) whose registered office
    is situated at 10 Albyn Place, Edinburgh, EH2 4NG (“the Training Provider”).
    RECITALS: -
    (A) The ESFA and the Training Provider entered into an Apprenticeship Agreement
    for the provision of Apprenticeship Training with the ESFA’s reference number
    of [MasterContractNo] ("Original Agreement").
    (B) The ESFA and the Training Provider have agreed to vary the terms of the
    Original Agreement as set out in this Variation.
    (C) The ESFA’s reference number for this Variation is Winter 2022, Version 4.0.
    “Expiry Date” means 31 July 2025 or such later date as is notified in
    writing by the ESFA and agreed by the Training Provider in
    accordance with Clause 3 (Commencement and Duration).

    Agreement number: [MasterContractNo]
    """

    # The Agreement doc is not included 
    And   the pdf file does not contain the following text
    """
    THIS AGREEMENT is made on the date the Agreement is digitally signed by the
    """

    # Save a copy of the output 
    And   Sharepoint file '10017862_[ContractNo]_v5.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A862v5.pdf' 
 
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017862 | [ContractNo]       | 5                     | 0                        | Draft            | Published to Provider                     | True          | False               | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 4                     | 0                        | Approved         | Under Termination                         | False         | True                | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 3                     | 0                        | Replaced         | Under Termination                         | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination                         | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017862 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/05/2017        | ?               | ?             |





    # Approve contract v5

    # Change the date 
    Given the override date is '14/10/2021' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '5' 
 
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus  | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017862 | [ContractNo]       | 5                     | 0                        | Approved         | Under Termination  | True          | True                | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 4                     | 0                        | Replaced         | Under Termination  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 3                     | 0                        | Replaced         | Under Termination  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved           | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017862 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                  | False         | False               | 01/05/2017        | ?               | ?             |





    # Complete the Termination 

    # Change the date 
    Given the override date is '20/10/2021' 

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination (23893)
#   When  CRM user 'FCS8 Test' completes the termination request for Contract 'ESIF-862' Version '5' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' completes the termination request for Contract '[ContractNo]' Version '5' SubVersion '0' via SDK

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus  | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017862 | [ContractNo]       | 5                     | 0                        | Closed           | Terminated         | True          | True                | 09/04/2020        | 01/10/2021      | Variation     |
    | 10017862 | [ContractNo]       | 4                     | 0                        | Replaced         | Under Termination  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 3                     | 0                        | Replaced         | Under Termination  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017862 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved           | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017862 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                  | False         | False               | 01/05/2017        | ?               | ?             |





    # Change the date 
    Given the override date is '22/10/2021' 
 
    # Inject data into the stub to create a contract with two allocations 
   #And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation 
    And   the following Levy event data is available in the DAS agreement stub 
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 63862 | INITIATED | 2021-10-21T18:03:12.2862 | 10017862   | 29862             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017862' 
    Then  there is only one Levy contract in CRM for UKPRN '10017862' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017862' for FundingType 'LEVY' and period '1799' 
 
 
 
 
 
    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017862 | 10017862 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017862 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017862 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017862 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017862 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017862 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017862 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017862 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 
 
    And   there are no open tasks for the contract 
    And   there is no contract owner assigned to the latest version of the contract 
 
    # Check deliverable period count prior to approval 
    And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
 
 
 
    # Check Contract documentation (16390) - Agreement\Ts&Cs only 
    And   the file named '10017862_[ContractNo]_v1.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
    """ 
    ESFA Apprenticeship Agreement for Training Providers
    THIS AGREEMENT is made on the date the Agreement is digitally signed by the Training
    Provider through the Manage Your Education and Skills Funding Service having
    already been signed by the ESFA and is between:
    10017862 Co Ltd THE SECRETARY OF STATE FOR
    10 Albyn Place EDUCATION ACTING THROUGH
    Edinburgh THE EDUCATION AND SKILLS
    EH2 4NG FUNDING AGENCY, AN
    EXECUTIVE AGENCY OF THE
    AND
    DEPARTMENT OF EDUCATION
    Company No: AA017862 CHEYLESMORE HOUSE
    UKPRN: 10017862 QUINTON ROAD
    COVENTRY
    CV1 2WT
    “Expiry Date” means 31 July 2025 or such later date as is notified in writing by
    the ESFA and agreed by the Training Provider in accordance with
    Clause 3 (Commencement and Duration).

    ESFA Apprenticeship Agreement for Training Providers, Winter 2022, Version 4.0
    Education & Skills Funding Agency
    https://www.gov.uk/government/organisations/education-and-skills-funding-agency
    55
    """ 
 
    # The Amendment Letter is not included
    And   the pdf file does not contain the following text
    """
    Agreement number: [MasterContractNo] 
    """
    
    # Save a copy of the output 
    And   Sharepoint file '10017862_[ContractNo]_v1.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A862av1.pdf' 
 

    # Tidy Up
    Given the override date is reset   

@AcceptanceTest @Withdrawn20220120
Scenario: A863 Create and approve a Levy contract. Bulk amendment. Initiate Termination. Bulk amend 3x. Check docs. (As A565 but with ShouldMergeAmendmentTemplate=No)

    # 1. Create and approve a Levy contract and check docs
    # 2. Bulk amendment > v2. Letter = LEVY1799_Amendment_No-TD_DUMMY.docx  Agreement\Ts&Cs = null
    # 3. Issue contract termination
    # 4. Bulk amendment > v3. Letter = LEVY1799_Amendment_TD_DUMMY.docx     Agreement\Ts&Cs = T&C_LEVY_Under_Term_DUMMY_2017-05-01.docx 
    # 5. Bulk amendment > v4. Letter = null                                 Agreement\Ts&Cs = null
    # 6. Bulk amendment > v5. Letter = null                                 Agreement\Ts&Cs = T&C_LEVY_Under_Term_DUMMY_2017-05-01.docx
    # 7. Complete termination
    # 8. Create new Levy contract for same provider and check docs

    # Note: Standard Letter = THIS VARIATION is made ...
    #       Custom Letter   = THIS TEST VARIATION is made ...

    Given there are no allocations marked as Under Termination for UKPRN '10017863' 
    And   there are no terminated or closed allocations for UKPRN '10017863' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017863' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017863' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017863' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017863' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017863' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table 
    And   there are no DAS engagement events stored in FCS 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017863' 
 
    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS 
 
    # Clear down all subnominal data from PaaS for an FSP 
    And   there is no Subnominal data in PaaS for the following FSPs 
    | FSP            | 
    | LEVY1799       | 
    | NONLEVY2019    | 
 
 
 
 
    # Remove the provider from RoATP (ContractManagement.RoATPProvider) 
    And   there is no data on RoATP for the following providers 
    | Ukprn    | 
    | 10017863 | 
 
    # Add the provider to RoATP (ContractManagement.RoATPProvider) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017863 | 10017863 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 
 
 
 
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017863' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017863 Co Ltd' with UKPRN '10017863' and OrgId 'ORG0017863' and has 'FCS1 Test' as a manager 
 
    # Put data in the PaaS Organisation table (Organisation.Organisation) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017863 | 117863 | 10017863 Co Ltd | 0              | Active                | Yes           | AA017863      | ?             | 10 Albyn Place         | Edinburgh              | ?                      | ?                      | ?                      | ?                      | EH2 4NG   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017863 |

 
 
 
    # Change the date 
    Given the override date is '16/03/2020' 
 
    # Inject data into the stub to create a contract with two allocations 
   #And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation 
    And   the following Levy event data is available in the DAS agreement stub 
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 62863 | INITIATED | 2019-12-15T18:03:12.2863 | 10017863   | 28863             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017863' 
    Then  there is only one Levy contract in CRM for UKPRN '10017863' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017863' for FundingType 'LEVY' and period '1799' 
 
 
 
 
 
    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017863 | 10017863 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017863 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017863 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017863 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017863 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017863 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017863 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017863 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 
 
    And   there are no open tasks for the contract 
    And   there is no contract owner assigned to the latest version of the contract 
 
    # Check deliverable period count prior to approval 
    And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
 
 
 
    # Check Contract documentation (16390) - Agreement\Ts&Cs only 
#    And   the file named '10017863_[ContractNo]_v1.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
#    """ 
#    ESFA Apprenticeship Agreement for Training Providers
#    THIS AGREEMENT is made on the date the Agreement is digitally signed by the Training
#    Provider through the Manage Your Education and Skills Funding Service having
#    already been signed by the ESFA and is between:
#    10017863 Co Ltd THE SECRETARY OF STATE FOR
#    10 Albyn Place EDUCATION ACTING THROUGH
#    Edinburgh THE EDUCATION AND SKILLS
#    EH2 4NG FUNDING AGENCY, AN
#    EXECUTIVE AGENCY OF THE
#    AND
#    DEPARTMENT OF EDUCATION
#    Company No: AA017863 CHEYLESMORE HOUSE
#    UKPRN: 10017863 QUINTON ROAD
#    COVENTRY
#    CV1 2WT
#    “Expiry Date” means 31 July 2025 or such later date as is notified in writing by
#    the ESFA and agreed by the Training Provider in accordance with
#    Clause 3 (Commencement and Duration).
#
#    ESFA Apprenticeship Agreement for Training Providers, Winter 2022, Version 4.0
#    Education & Skills Funding Agency
#    https://www.gov.uk/government/organisations/education-and-skills-funding-agency
#    55
#    """ 
# 
    # The Amendment Letter is not included
    And   the pdf file does not contain the following text
    """
    Agreement number: [MasterContractNo] 
    """
    
    # Save a copy of the output 
    And   Sharepoint file '10017863_[ContractNo]_v1.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A863v1.pdf' 
 
 
 
 
    # Change the date 
    Given the override date is '09/04/2020' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 
 
    # Check deliverable period count after approval 
    Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # After approval there should be a Apr-20 deliverable period for each of deliverables 1 through 14 for each allocation 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Apr-20   | DeliverableDescription                               | 
    | 10017863 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017863 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017863 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017863 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017863 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017863 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017863 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017863 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017863 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017863 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017863 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017863 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017863 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017863 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
    # 
    | 10017863 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017863 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017863 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017863 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017863 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017863 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017863 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017863 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017863 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017863 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017863 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017863 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017863 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017863 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 
 
    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017863 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 09/04/2020        | ?               | ?             | 
    | 10017863 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 
 
    # Check ALLOCATION dates in CRM 
    And   the following allocation values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | 
    | 10017863 | [ContractNo]       | 1                     | [AllocRef_LEVY]     | 09/04/2020          | ?                 | 
    | 10017863 | [ContractNo]       | 1                     | [AllocRef_NLA]      | 09/04/2020          | ?                 | 
 
 
 
 
    # Issue a variation amendment against approved contract v1 to create draft v2 and check docs
     
    # Change the date 
    Given the override date is '01/08/2021' 
 
    # Month end is not running 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
     
    # Issue a contract amendment request 
    When  a request is issued to amend the following Levy contract via Bulk 
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status    | SubStatus   | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate | AllowUnderTermination | LetterTemplateName                   | AgreementTemplateName   |
    | 10017863 | [MasterContractNo]   | [ContractNo]   | 1       | Approved  | Approved    | Variation     | No                       | Yes                   | No                           | Yes                   | LEVY1799_Amendment_No-TD_DUMMY.docx  | ?                       | 
 
    And   wait '15' seconds 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step  
    Then  the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |  
    | Draft  | Published to Provider  | Yes           | No                  | 2                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017863' for FundingType 'LEVY' and period '1799' 
 
    # Check Contract documentation - Custom letter but no Agreement doc
    #And   the file named '10017863_[ContractNo]_v2.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
    #""" 
    #THIS TEST VARIATION is made on the date the Variation is digitally signed by the
    #Training Provider on the Manage your education and skills funding service (“the
    #Variation Date”).
    #BETWEEN: -
    #(1) THE SECRETARY OF STATE FOR EDUCATION acting through the
    #Education and Skills Funding Agency an Executive Agency of the Department
    #for Education of Cheylesmore House, Quinton Road, Coventry, CV1 2WT (“the
    #ESFA"); and
    #(2) 10017863 Co Ltd Company No: AA017863 (10017863) whose registered office
    #is situated at 10 Albyn Place, Edinburgh, EH2 4NG ("the Training Provider").
    #RECITALS: -
    #(A) The ESFA and the Training Provider entered into an Apprenticeship Agreement
    #for the provision of Apprenticeship Training with the ESFA's reference number
    #of [MasterContractNo] ("Original Contract").
    #Contract reference: [MasterContractNo]
    #""" 

    # The Agreement doc is not included
    And   the pdf file does not contain the following text
    """
    THIS AGREEMENT is made on the date the Agreement is digitally signed by the
    """ 

    # Save a copy of the output 
    And   Sharepoint file '10017863_[ContractNo]_v2.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A863v2.pdf' 
 




    # Approve contract v2

    # Change the date 
    Given the override date is '03/08/2021' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2' 
 
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus  | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017863 | [ContractNo]       | 2                     | 0                        | Approved         | Approved           | True          | True                | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved           | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017863 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                  | False         | False               | 01/05/2017        | ?               | ?             |

 
 
 

    # Termination Initiation (30634)

    # Change the date - CRM ignores this
    Given the override date is '04/10/2021'

    # Termination Initiation setup - contract
    When  CRM user 'FCS8 TEST' initiates a contract termination with the following values
    | ContractNo    | ContractVersion | ContractSubVersion | ContractTerminationDate | TerminationReason           | Comments                            |
    | [ContractNo]  | 2               | 0                  | 01/10/2021              | Other                       | Company struck off                  |

    # Termination Initiation setup - allocations
    And   with the following allocation termination options
    | AllocationNumber   | ProvisionalStopNewStartsDate | ProvisionalFundingCessationDate |
    | [AllocRef_LEVY]    | 16/08/2021                   | 23/08/2021                      |
    | [AllocRef_NLA]     | 13/08/2021                   | 20/08/2021                      |

    # Use the SDK to submit a request for manager approval
    And   the user forwards the initiate termination request for manager approval via SDK

    # If all ok then Termination Intiation proceeds and the contract data will have been saved in CRM
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017863 | [ContractNo]   | 2                     | 0                        | 01/10/2021                 | Other                        | ?                              | 01/10/2021              | Other                       | ?                             |

    # ... and the allocation data will have been saved in CRM too
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017863 | [ContractNo]  | [AllocRef_LEVY]  | 2                     | 0                        | 16/08/2021                   | 16/08/2021        | 23/08/2021                      | 23/08/2021           |
    | 10017863 | [ContractNo]  | [AllocRef_NLA]   | 2                     | 0                        | 13/08/2021                   | 13/08/2021        | 20/08/2021                      | 20/08/2021           |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017863 | [ContractNo]       | 2                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 09/04/2020        | ?               | Variation     |
    | 10017863 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |





    # Approve Termination Initiation (30635)

    # Change the date - CRM ignores this
    Given the override date is '05/10/2021'

    # Clear down CM feed
    And   the Contract Management atom feed is empty

    # Complete an existing open Task
    When the following open Task currently linked to version '2' of contract '[ContractNo]' for provider '10017863' is triggered by User 'FCS5 TEST'
    | Task                                     | Owner                     |
    | Confirm Termination Initiation Approval  | Contract Managers Team    |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus  | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017863 | [ContractNo]       | 2                     | 0                        | Approved         | Under Termination  | True          | True                | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved           | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017863 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                  | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the Termination details on the contract in CRM (These should not have changed)
    Then  the following contract termination values are present in CRM
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalTerminationDate | ProvisionalTerminationReason | ProvisionalTerminationComments | ContractTerminationDate | TerminationReason           | TerminationComments           |
    | 10017863 | [ContractNo]   | 2                     | 0                        | 01/10/2021                 | Other                        | ?                              | 01/10/2021              | Other                       | ?                             |

    # Check the Termination details on the allocations in CRM (These should not have changed)
    And   the following allocation termination values are present in CRM
    | UKPRN    | ContractNo    | AllocationNumber | ContractVersionNumber | ContractSubVersionNumber | ProvisionalStopNewStartsDate | StopNewStartsDate | ProvisionalFundingCessationDate | FundingCessationDate |
    | 10017863 | [ContractNo]  | [AllocRef_LEVY]  | 2                     | 0                        | 16/08/2021                   | 16/08/2021        | 23/08/2021                      | 23/08/2021           |
    | 10017863 | [ContractNo]  | [AllocRef_NLA]   | 2                     | 0                        | 13/08/2021                   | 13/08/2021        | 20/08/2021                      | 20/08/2021           |


    


    # Issue a variation amendment against contract v2 to create draft v3 and check docs
     
    # Change the date 
    Given the override date is '06/10/2021' 
 
    # Month end is not running 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
     
    # Issue a contract amendment request 
    When  a request is issued to amend the following Levy contract via Bulk 
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status    | SubStatus         | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate | AllowUnderTermination | LetterTemplateName                | AgreementTemplateName                      |
    | 10017863 | [MasterContractNo]   | [ContractNo]   | 2       | Approved  | Under Termination | Variation     | No                       | Yes                   | No                           | Yes                   | LEVY1799_Amendment_TD_DUMMY.docx  | T&C_LEVY_Under_Term_DUMMY_2017-05-01.docx  | 
 
    And   wait '15' seconds 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step  
    Then  the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |  
    | Draft  | Published to Provider  | Yes           | No                  | 3                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017863' for FundingType 'LEVY' and period '1799' 
 
    # Check Contract documentation - Custom letter but no Agreement doc 
    #And   the file named '10017863_[ContractNo]_v3.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
    #""" 
    #THIS TEST VARIATION is made on the date the Variation is digitally signed by the
    #Training Provider on the Manage your education and skills funding service (“the
    #Variation Date”).
    #Termination Date: 1 October 2021.
    #BETWEEN: -
    #(1) THE SECRETARY OF STATE FOR EDUCATION acting through the
    #Education and Skills Funding Agency an Executive Agency of the Department
    #for Education of Cheylesmore House, Quinton Road, Coventry, CV1 2WT (“the
    #ESFA"); and
    #(2) 10017863 Co Ltd Company No: AA017863 (10017863) whose registered office
    #is situated at 10 Albyn Place, Edinburgh, EH2 4NG ("the Training Provider").
    #RECITALS: -
    #(A) The ESFA and the Training Provider entered into an Apprenticeship Agreement
    #for the provision of Apprenticeship Training with the ESFA's reference number
    #of [MasterContractNo] ("Original Contract").
    #Contract reference: [MasterContractNo]
    #"""

    # The Agreement doc is not included 
    And   the pdf file does not contain the following text
    """
    THIS AGREEMENT is made on the date the Agreement is digitally signed by the
    """
 
    # Save a copy of the output 
    And   Sharepoint file '10017863_[ContractNo]_v3.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A863v3.pdf' 
 
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017863 | [ContractNo]       | 3                     | 0                        | Draft            | Published to Provider                     | True          | False               | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 2                     | 0                        | Approved         | Under Termination                         | False         | True                | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017863 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/05/2017        | ?               | ?             |





    # Approve contract v3

    # Change the date 
    Given the override date is '07/10/2021' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '3' 
 
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus  | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017863 | [ContractNo]       | 3                     | 0                        | Approved         | Under Termination  | True          | True                | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved           | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017863 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                  | False         | False               | 01/05/2017        | ?               | ?             |





    # Issue a variation amendment against contract v3 to create draft v4 and check docs
     
    # Change the date 
    Given the override date is '09/10/2021' 
 
    # Month end is not running 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
     
    # Issue a contract amendment request 
    When  a request is issued to amend the following Levy contract via Bulk 
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status    | SubStatus         | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate | AllowUnderTermination | LetterTemplateName                | AgreementTemplateName                      |
    | 10017863 | [MasterContractNo]   | [ContractNo]   | 3       | Approved  | Under Termination | Variation     | No                       | Yes                   | No                           | Yes                   | ?                                 | ?                                          | 
 
    And   wait '15' seconds 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step  
    Then  the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |  
    | Draft  | Published to Provider  | Yes           | No                  | 4                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017863' for FundingType 'LEVY' and period '1799' 
 
    # Check Contract documentation (16390) - Standard letter but no Agreement doc 
#    And   the file named '10017863_[ContractNo]_v4.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
#    """ 
#    THIS VARIATION is made on the date the Variation is digitally signed by the Training
#    Provider on the “Manage your education and skills funding service” (“the Variation
#    Date”).
#    BETWEEN: -
#    (1) THE SECRETARY OF STATE FOR EDUCATION acting through the
#    Education and Skills Funding Agency an Executive Agency of the Department
#    for Education of Cheylesmore House, Quinton Road, Coventry, CV1 2WT (“the
#    ESFA”); and
#    (2) 10017863 Co Ltd Company No: AA017863 (10017863) whose registered office
#    is situated at 10 Albyn Place, Edinburgh, EH2 4NG (“the Training Provider”).
#    RECITALS: -
#    (A) The ESFA and the Training Provider entered into an Apprenticeship Agreement
#    for the provision of Apprenticeship Training with the ESFA’s reference number
#    of [MasterContractNo] ("Original Agreement").
#    (B) The ESFA and the Training Provider have agreed to vary the terms of the
#    Original Agreement as set out in this Variation.
#    (C) The ESFA’s reference number for this Variation is Winter 2022, Version 4.0.
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    acting through the Education and Skills Funding Agency
#    by John Edwards, Interim Chief Executive of the Education and Skills Funding
#    Agency
#
#    Agreement number: [MasterContractNo]
#    """

    # The Agreement doc is not included 
    And   the pdf file does not contain the following text
    """
    THIS AGREEMENT is made on the date the Agreement is digitally signed by the
    """
 
    # Save a copy of the output 
    And   Sharepoint file '10017863_[ContractNo]_v4.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A863v4.pdf' 
 
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus       | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017863 | [ContractNo]       | 4                     | 0                        | Draft            | Published to Provider   | True          | False               | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 3                     | 0                        | Approved         | Under Termination       | False         | True                | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination       | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017863 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                       | False         | False               | 01/05/2017        | ?               | ?             |





    # Approve contract v4

    # Change the date 
    Given the override date is '10/10/2021' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '4' 
 
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus  | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017863 | [ContractNo]       | 4                     | 0                        | Approved         | Under Termination  | True          | True                | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 3                     | 0                        | Replaced         | Under Termination  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved           | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017863 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                  | False         | False               | 01/05/2017        | ?               | ?             |





    # Issue a variation amendment against contract v4 to create draft v5 and check docs
     
    # Change the date 
    Given the override date is '12/10/2021' 
 
    # Month end is not running 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
     
    # Issue a contract amendment request 
    When  a request is issued to amend the following Levy contract via Bulk 
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status    | SubStatus         | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate | AllowUnderTermination | LetterTemplateName                | AgreementTemplateName                      |
    | 10017863 | [MasterContractNo]   | [ContractNo]   | 4       | Approved  | Under Termination | Variation     | No                       | Yes                   | No                           | Yes                   | ?                                 | T&C_LEVY_Under_Term_DUMMY_2017-05-01.docx  | 
 
    And   wait '15' seconds 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step  
    Then  the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |  
    | Draft  | Published to Provider  | Yes           | No                  | 5                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017863' for FundingType 'LEVY' and period '1799' 
 
    # Check Contract documentation (16390) - Standard letter but no Agreement doc 
    And   the file named '10017863_[ContractNo]_v5.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
    """ 
    THIS VARIATION is made on the date the Variation is digitally signed by the Training
    Provider on the “Manage your education and skills funding service” (“the Variation
    Date”).
    BETWEEN: -
    (1) THE SECRETARY OF STATE FOR EDUCATION acting through the
    Education and Skills Funding Agency an Executive Agency of the Department
    for Education of Cheylesmore House, Quinton Road, Coventry, CV1 2WT (“the
    ESFA”); and
    (2) 10017863 Co Ltd Company No: AA017863 (10017863) whose registered office
    is situated at 10 Albyn Place, Edinburgh, EH2 4NG (“the Training Provider”).
    RECITALS: -
    (A) The ESFA and the Training Provider entered into an Apprenticeship Agreement
    for the provision of Apprenticeship Training with the ESFA’s reference number
    of [MasterContractNo] ("Original Agreement").
    (B) The ESFA and the Training Provider have agreed to vary the terms of the
    Original Agreement as set out in this Variation.
    (C) The ESFA’s reference number for this Variation is Winter 2022, Version 4.0.
    
    Agreement number: [MasterContractNo]
    """ 
 
    # The Agreement doc is not included 
    And   the pdf file does not contain the following text
    """
    THIS AGREEMENT is made on the date the Agreement is digitally signed by the
    """

    # Save a copy of the output 
    And   Sharepoint file '10017863_[ContractNo]_v5.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A863v5.pdf' 
 
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017863 | [ContractNo]       | 5                     | 0                        | Draft            | Published to Provider                     | True          | False               | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 4                     | 0                        | Approved         | Under Termination                         | False         | True                | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 3                     | 0                        | Replaced         | Under Termination                         | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination                         | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017863 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/05/2017        | ?               | ?             |





    # Approve contract v5

    # Change the date 
    Given the override date is '14/10/2021' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '5' 
 
    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus  | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017863 | [ContractNo]       | 5                     | 0                        | Approved         | Under Termination  | True          | True                | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 4                     | 0                        | Replaced         | Under Termination  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 3                     | 0                        | Replaced         | Under Termination  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved           | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017863 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                  | False         | False               | 01/05/2017        | ?               | ?             |





    # Complete the Termination 

    # Change the date 
    Given the override date is '18/10/2021' 

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination (23893)
#   When  CRM user 'FCS8 Test' completes the termination request for Contract 'ESIF-863' Version '5' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' completes the termination request for Contract '[ContractNo]' Version '5' SubVersion '0' via SDK

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus  | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017863 | [ContractNo]       | 5                     | 0                        | Closed           | Terminated         | True          | True                | 09/04/2020        | 01/10/2021      | Variation     |
    | 10017863 | [ContractNo]       | 4                     | 0                        | Replaced         | Under Termination  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 3                     | 0                        | Replaced         | Under Termination  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 2                     | 0                        | Replaced         | Under Termination  | False         | False               | 09/04/2020        | ?               | Variation     |
    | 10017863 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved           | False         | False               | 09/04/2020        | ?               | ?             |
    | 10017863 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                  | False         | False               | 01/05/2017        | ?               | ?             |





    # Change the date 
    Given the override date is '20/10/2021' 
 
    # Inject data into the stub to create a contract with two allocations 
   #And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation 
    And   the following Levy event data is available in the DAS agreement stub 
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 63566 | INITIATED | 2021-10-19T18:03:12.2863 | 10017863   | 29863             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017863' 
    Then  there is only one Levy contract in CRM for UKPRN '10017863' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 
 
    # Retrieve parameters from CRM 
    And   I retrieve the latest contract details from CRM for provider '10017863' for FundingType 'LEVY' and period '1799' 
 
 
 
 
 
    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017863 | 10017863 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017863 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017863 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017863 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017863 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017863 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017863 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017863 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 
 
    And   there are no open tasks for the contract 
    And   there is no contract owner assigned to the latest version of the contract 
 
    # Check deliverable period count prior to approval 
    And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
 
 
 
    # Check Contract documentation (16390) - Agreement\Ts&Cs only 
    And   the file named '10017863_[ContractNo]_v1.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
    """ 
    ESFA Apprenticeship Agreement for Training Providers
    Terms and Conditions
    THIS AGREEMENT is made on the date the Agreement is digitally signed by the Training
    Provider through the Manage Your Education and Skills Funding Service having
    already been signed by the ESFA and is between:
    10017863 Co Ltd THE SECRETARY OF STATE FOR
    10 Albyn Place EDUCATION ACTING THROUGH
    Edinburgh THE EDUCATION AND SKILLS
    EH2 4NG FUNDING AGENCY, AN
    EXECUTIVE AGENCY OF THE
    AND
    DEPARTMENT OF EDUCATION
    Company No: AA017863 CHEYLESMORE HOUSE
    UKPRN: 10017863 QUINTON ROAD
    COVENTRY
    CV1 2WT
    “Expiry Date” means 31 July 2025 or such later date as is notified in writing by
    the ESFA and agreed by the Training Provider in accordance with
    Clause 3 (Commencement and Duration).

    ESFA Apprenticeship Agreement for Training Providers, Winter 2022, Version 4.0
    Education & Skills Funding Agency
    https://www.gov.uk/government/organisations/education-and-skills-funding-agency
    55
    """ 
 
    # The Amendment Letter is not included
    And   the pdf file does not contain the following text
    """
    Agreement number: [MasterContractNo] 
    """
    
    # Save a copy of the output 
    And   Sharepoint file '10017863_[ContractNo]_v1.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A863av1.pdf' 
 

    # Tidy Up
    Given the override date is reset   

