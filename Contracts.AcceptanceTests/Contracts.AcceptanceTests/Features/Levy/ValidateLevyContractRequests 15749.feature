Feature: ValidateLevyContractRequests 15749

@AcceptanceTest @Complete 
@PublishNewLevyContract
 Scenario: A681 Multi-action Levy scenario including creation, withdrawal, recreation and approval (inc DAS-CBR-001) with doc checks
    Given there is no Contract, Task or Workflow data for UKPRN '10017681'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017681'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017681'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS
    And   the override date is reset



    # Remove the provider from RoATP (ContractManagement.RoATPProvider)
    And   there is no data on RoATP for the following providers
    | Ukprn    |
    | 10017681 |

    # Add the provider to RoATP (ContractManagement.RoATPProvider)
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name                              | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017681 | Top Cat and Badger Industries Ltd | Main provider | False                  | False                                      | 15/03/2017 | 



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017681' 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Top Cat and Badger Industries Ltd' with UKPRN '10017681' and OrgId 'ORG0017681' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017681' 
 
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name                              | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017681 | 117681 | Top Cat and Badger Industries Ltd | 0              | Provider Under Change | Yes           | AA017681      | ?             | 7 Amersham Hill        | ?                      | ?                      | ?                      | High Wycombe           | Buckinghamshire        | HP13 6NS  |
    
    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017681 |




    # Inject data into the stub (16104)
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42564 | INITIATED | 2016-12-07T18:03:12.2539 | 10017681   | 28945             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017681'
    And   there is only one Levy contract in CRM for UKPRN '10017681' with a status of 'Draft'

    # Check contract creation
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName                         | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017681 | Top Cat and Badger Industries Ltd | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017681 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017681 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
    | 10017681 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                  | 
    | 10017681 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships        | 
    | 10017681 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships        | 
    | 10017681 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017681 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Retrieve parameters from CRM 
   #And   I retrieve the latest EFA contract details from CRM for provider '10017681' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017681' 
    And   I retrieve the latest contract details from CRM for provider '10017681' for FundingType 'LEVY' and period '1799' 

    # Check Atom feed data for a type 1 'Published to Provider' event
    And   the ContractManagement.AtomFeedItem table contains one ItemType '1' event for contract number '[ContractNo]'
    And   the ItemType '1' event for contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017681_[ContractNo]_v1.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as '10017681_[ContractNo]_v1.pdf'

    ## Check Contract documentation (16390)
    #And   a file named '10017681_' & '[ContractNo]' & '_v1.pdf' does not exist in sharepoint location 'LEVY-1799-Input-Appendices'
    #And   a file named '10017681_' & '[ContractNo]' & '_v1.pdf' exists in sharepoint location 'LEVY-1799-Output-Documents for Publication'
  # And   the generated ts&cs document in sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
#    And   the file named '10017681_[ContractNo]_v1.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
#    """
#    (C) The Department’s reference for this Variation is January 2026, Version 4.5.
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by Andrew Thomas, Director of Funding and Financial Oversight
#    Agreement number: [MasterContractNo]
#    Department for Education Apprenticeships-Provider Agreement, January 2026, Version 4.5
#    Department for Education
#    Department for Education - GOV.UK
#    69
#    """
#
#    # The Amendment Letter is not included
#    And   the pdf file does not contain the following text
#    """
#    Agreement number: [MasterContractNo] 
#    """



    # Withdraw contract
    When  the next action performed by manager 'FCS1 Test' on the latest version of contract '[ContractNo]' is to 'Withdraw On Behalf Of Provider' specifying the reason as 'Testing'
    
    Then  the latest version of the contract has the following settings
    | Status    | SubStatus             | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Withdrawn | Withdrawn By Provider | No            | No                  | 1                     |

    And   the following workflow history entries are present on the latest version of the contract
    | Action                                         | CompletedBy       | Previous Contract Owner | New Contract Owner | 
    | Withdraw On Behalf Of Provider                 | CRM Integration   | ?                       | ?                  |
    | Document Published For Digital Sign Off        | CRM Integration   | ?                       | ?                  |
    | Skip Review and Internal Approval              | CRM Integration   | ?                       | ?                  |

    # Check Atom feed data for a type 2 'Withdrawal' event
    And   the ContractManagement.AtomFeedItem table contains one ItemType '2' event for contract number '[ContractNo]'
    And   the ItemType '2' event for contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema




    # Clear down the stub then inject and pull data for the second time
    Given there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS

    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42571 | INITIATED | 2016-12-07T18:03:24.2173 | 10017681   | 28983             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017681'
    And   there is only one Levy contract in CRM for UKPRN '10017681' with a status of 'Draft'

    # Check the second CRM contract is in the correct state
    Then  the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Retrieve parameters from CRM 
   #And   I retrieve the latest EFA contract details from CRM for provider '10017681' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017681' 
    And   I retrieve the latest contract details from CRM for provider '10017681' for FundingType 'LEVY' and period '1799' 

    # Check Atom feed data for a type 1 'Published to Provider' event
    And   the ContractManagement.AtomFeedItem table contains one ItemType '1' event for contract number '[ContractNo]'
    And   the ItemType '1' event for contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema




    # Clear down the stub then inject and pull data for the third time
    Given there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS

    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42578 | INITIATED | 2016-12-07T18:03:36.3946 | 10017681   | 29003             |

    When  the Levy event data is pulled from the DAS agreement stub
   #And   the Levy contract is created in CRM for UKPRN '10017681'
    And   there is only one Levy contract in CRM for UKPRN '10017681' with a status of 'Draft'

    ## Check deliverable period count prior to approval
    #Then  there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

	# Before approval there should be a May-17 deliverable periods present
    Then  the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                         | 
    | 10017681 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships               | 
    | 10017681 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships               | 
    | 10017681 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships           | 
    | 10017681 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships           | 




    # Change the date 
    Given the override date is '09/02/2021'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

#    # Check deliverable period count after approval
#    Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
#
#    # Check deliverable period count after approval 
#    Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # After approval there should be a Feb-21 deliverable period for each of deliverables 1 through 14 for each allocation
    Then   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Feb-21   | DeliverableDescription                               | 
    | 10017681 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017681 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017681 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017681 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017681 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017681 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017681 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017681 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017681 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017681 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017681 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017681 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017681 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017681 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017681 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017681 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017681 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017681 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017681 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017681 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017681 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017681 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017681 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017681 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017681 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017681 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017681 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017681 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017681 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 09/02/2021        | ?               | ?             |
    | 10017681 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017681 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 09/02/2021          | ?                 |
    | 10017681 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 09/02/2021          | ?                 |

    # Check the dates in the PaaS PaymentSchedule.DeliverablePayment table 
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualValue |
    | [AllocRef_LEVY]  | 1             | 1               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 2               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 3               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 4               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 5               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 6               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 7               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 8               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 9               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 10              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 11              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 12              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 13              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_LEVY]  | 1             | 14              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
	#
    | [AllocRef_NLA]   | 1             | 1               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 2               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 3               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 4               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 5               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 6               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 7               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 8               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 9               | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 10              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 11              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 12              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 13              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |
    | [AllocRef_NLA]   | 1             | 14              | 202102 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?           |


	# Check Workflow History
    And   the following workflow history entries are present on the latest version of the contract
    | Action                                         | CompletedBy       | Previous Contract Owner | New Contract Owner | 
    | Confirm Receipt of Digital Signature           | CRM Integration   | ?                       | ?                  |
    | Document Published For Digital Sign Off        | CRM Integration   | ?                       | ?                  |
    | Skip Review and Internal Approval              | CRM Integration   | ?                       | ?                  |

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Feb-21   |
    | [ContractNo]   | [AllocRef_LEVY]    | 1               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 2               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 3               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 4               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 5               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 6               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 7               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 8               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 9               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 10              | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 11              | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 12              | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 13              | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 14              | 0.00      | 0.00     | 
    #
    | [ContractNo]   | [AllocRef_NLA]     | 1               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 2               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 3               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 4               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 5               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 6               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 7               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 8               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 9               | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 10              | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 11              | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 12              | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 13              | 0.00      | 0.00     | 
    | [ContractNo]   | [AllocRef_NLA]     | 14              | 0.00      | 0.00     | 

    # Check Atom feed data for a type 0 'Approved' event
    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for contract number '[ContractNo]'
    And   the ItemType '0' event for contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Clear down the stub then inject and pull data for the fourth and final time
    Given there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42585 | INITIATED | 2016-12-07T18:03:48.5473 | 10017681   | 29033             |

    When  the Levy event data is pulled from the DAS agreement stub
   #And   the Levy contract is created in CRM for UKPRN '10017681'
    And   there is only one Levy contract in CRM for UKPRN '10017681' with a status of 'Approved'


    # Tidy up
    Then  the override date is reset
	  
@AcceptanceTest @Complete 
@PublishNewLevyContract @ContractClosure
Scenario: A686 Create and approve a Levy contract in Mar 2018 then amend (bulk) and approve it in Jul 2018 without the start date changing. Check CRM, PaaS and RoATP anomalies report
    Given there is no Contract, Task or Workflow data for UKPRN '10017686'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017686'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017686'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no entries in the DCFS stub table
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017686'
    And   there are no DAS engagement events stored in FCS
    And   the Allocation Delivery Monitoring Service atom feed is empty

    # Change the date
    And   the override date is '01/05/2025'

	# Set RoATP data (needed for amendment checks)
	And   the following providers exist on RoATP
	| Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
	| 10017686 | 10017686 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    

    # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017686'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017686 Co Ltd' with UKPRN '10017686' and OrgId 'ORG0017686' and has 'FCS1 Test' as a manager
    And   UPIN '117686' is associated with UKPRN '10017686' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017686 | 117686 | 10017686 Co Ltd | 0              | Active |

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | ContractType      |
    | 47686 | INITIATED | 2018-03-01T09:31:29.1302 | 10017686   | ProviderAgreement |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017686'

    # Check contract creation
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017686 | 10017686 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017686 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017686 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
    | 10017686 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |


    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                  | 
    | 10017686 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships        | 
    | 10017686 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships        | 
    | 10017686 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017686 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017686'

    Then  there is only one Levy contract in CRM for UKPRN '10017686' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 

    # Retrieve parameters from CRM  
   #When  I retrieve the latest EFA contract details from CRM for provider '10017686' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017686' 
    And   I retrieve the latest contract details from CRM for provider '10017686' for FundingType 'LEVY' and period '1799' 

        # Copy\Save a named Sharepoint file to a named folder\filename
    Then Sharepoint file '10017686_[ContractNo]_v1.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as '10017686_[ContractNo]_v1.pdf'


    ## Check deliverable period count prior to approval
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Change the date
    Given the override date is '03/05/2025'

    # Approve v1 of the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    Then  the latest version of the contract has the following settings 
    | Status   | SubStatus | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Approved | Approved  | Yes           | Yes                 | 1                     |

    ## Check deliverable period count after approval 
    #Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
# 
#    # After approval there should be a Mar-20 deliverable period for each of deliverables 1 through 14 for each allocation
#    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
#    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Mar-20   | DeliverableDescription                               | 
#    | 10017686 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
#    | 10017686 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
#    | 10017686 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
#    | 10017686 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
#    | 10017686 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
#    | 10017686 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
#    | 10017686 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
#    | 10017686 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
#    | 10017686 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
#    | 10017686 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
#    | 10017686 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
#    | 10017686 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
#    | 10017686 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
#    | 10017686 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
#     
#    | 10017686 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
#    | 10017686 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
#    | 10017686 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
#    | 10017686 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
#    | 10017686 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
#    | 10017686 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
#    | 10017686 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
#    | 10017686 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
#    | 10017686 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
#    | 10017686 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
#    | 10017686 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
#    | 10017686 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
#    | 10017686 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
#    | 10017686 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 
#

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017686 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 03/05/2025        | ?               | ?             |
    | 10017686 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017686 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 03/05/2025          | ?                 |
    | 10017686 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 03/05/2025          | ?                 |




    # Change the date
    Given the override date is '12/06/2025'

    # Issue a contract amendment request against v1 to create v2 using the bulk mechanism
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017686 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Approved  | Variation     | No                       | No                    | Yes                          |

    Then  the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 2                     |

    # Copy\Save a named Sharepoint file to a named folder\filename
    Then Sharepoint file '10017686_[ContractNo]_v2.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as '10017686_[ContractNo]_v2.pdf'


    # Change the date
    Given the override date is '16/06/2025'
 
    # Approve v2 of the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2' 

    Then  the latest version of the contract has the following settings 
    | Status   | SubStatus | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Approved | Approved  | Yes           | Yes                 | 2                     |

    ## Check deliverable period count after approval
    #And   there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    ## After approval there should be a Mar-18 deliverable period for each of deliverables 1 through 12 (Not Jun-18)
    #And   the draft Levy contract deliverables details for the new Levy contract are as follows
    #| UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | Mar-20   | DeliverableDescription                           | 
    #| 10017686 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                 | 
    #| 10017686 | LEVY              | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                         | 
    #| 10017686 | LEVY              | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                         | 
    #| 10017686 | LEVY              | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support    | 
    #| 10017686 | LEVY              | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other               | 
    #| 10017686 | LEVY              | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers   | 
    #| 10017686 | LEVY              | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals | 
    #| 10017686 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                 | 
    #| 10017686 | LEVY              | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                         | 
    #| 10017686 | LEVY              | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                         | 
    #| 10017686 | LEVY              | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support    | 
    #| 10017686 | LEVY              | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other               | 
    #| 10017686 | LEVY              | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers   | 
    #| 10017686 | LEVY              | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals | 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017686 | [ContractNo]       | 2                     | 0                        | Approved         | Approved               | True          | True                | 03/05/2025        | ?               | Variation     |
    | 10017686 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved               | False         | False               | 03/05/2025        | ?               | ?             |
    | 10017686 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef   | AllocationStartDate | AllocationEndDate |
    | 10017686 | [ContractNo]       | 1                     | [AllocRef_LEVY] | 03/05/2025          | ?                 |
    | 10017686 | [ContractNo]       | 1                     | [AllocRef_NLA]  | 03/05/2025          | ?                 |

#
#
#    # Check the dates in the PaaS PaymentSchedule.DeliverablePayment table 
#    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
#    | AllocationNumber    | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
#    | [AllocRef_LEVY]     | 1             | 1               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 1             | 2               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 1             | 3               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 1             | 4               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 1             | 5               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 1             | 6               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 1             | 7               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 1             | 8               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 1             | 9               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 1             | 10              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 1             | 11              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 1             | 12              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 1             | 13              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 1             | 14              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 2             | 1               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 2             | 2               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 2             | 3               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 2             | 4               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 2             | 5               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 2             | 6               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 2             | 7               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 2             | 8               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 2             | 9               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 2             | 10              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 2             | 11              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 2             | 12              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 2             | 13              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_LEVY]     | 2             | 14              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    #
#    | [AllocRef_NLA]      | 1             | 1               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 1             | 2               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 1             | 3               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 1             | 4               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 1             | 5               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 1             | 6               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 1             | 7               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 1             | 8               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 1             | 9               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 1             | 10              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 1             | 11              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 1             | 12              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 1             | 13              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 1             | 14              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 2             | 1               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 2             | 2               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 2             | 3               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 2             | 4               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 2             | 5               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 2             | 6               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 2             | 7               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 2             | 8               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 2             | 9               | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 2             | 10              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 2             | 11              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 2             | 12              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 2             | 13              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |
#    | [AllocRef_NLA]      | 2             | 14              | 202003 | 2              | 0             | 0.00         | ?                    | ?                   | ?                      | ?                           | 0.00             | ?            | ?           |


    # Check that there is nothing on the RoATP Anomalies report for the provider
    And   the RoATP Anomalies report does not contain a record for provider '10017686'
	
	# Tidy up
    And   the override date is reset
  
   