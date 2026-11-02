Feature: CreateTwoAllocationLevyContract 27021

@AcceptanceTest @Completed
Scenario: A088 Create and approve a new Levy contract with LEVY1799 and NONLEVY2019 allocations. Consume actuals. Check Docs, CRM and PaaS
    Given there are no allocations marked as Under Termination for UKPRN '10017088' 
    And   there are no terminated or closed allocations for UKPRN '10017088' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017088' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017088' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017088' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017088' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017088' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table 
    And   there are no DAS engagement events stored in FCS 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017088' 
 
    # Clear down all subnominal data from PaaS for an FSP 
    And   there is no Subnominal data in PaaS for the following FSPs 
    | FSP            | 
    | LEVY1799       | 
    | NONLEVY2019    | 
 
 
    # Remove the provider from RoATP (ContractManagement.RoATPProvider) 
    And   there is no data on RoATP for the following providers 
    | Ukprn    | 
    | 10017088 | 
 
    # Add the provider to RoATP (ContractManagement.RoATPProvider) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not.  
    And   the following providers exist on RoATP  
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |  
    | 10017088 | 10017088 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017088' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017088 Co Ltd' with UKPRN '10017088' and OrgId 'ORG0017088' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017088' 
 
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017088 | 117088 | 10017088 Co Ltd | 0              | In Administration     | Yes           | AA017088      | ?             | 105 Queens Road        | ?                      | ?                      | ?                      | Reading                | Berkshire              | RG1 4DA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017088 |

 
 
 
    # Change the date 
    Given the override date is '16/12/2019' 
 
    # Inject data into the stub to create both allocations (J093)
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 42088 | INITIATED | 2017-09-15T18:03:12.2088 | 10017088   | 28088             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017088' 
    Then  there is only one Levy contract in CRM for UKPRN '10017088' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 
 
    # Retrieve parameters from CRM  
   #When  I retrieve the latest EFA contract details from CRM for provider '10017088' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017088' 
    And   I retrieve the latest contract details from CRM for provider '10017088' for FundingType 'LEVY' and period '1799' 
 
    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017088 | 10017088 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017088 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017088 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017088 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 15              | 0                     | 0.00     | 0.00     | Total Levy Apprenticeship Unit        | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 15              | 0                     | 0.00     | 0.00     | Total Non-Levy Apprenticeship Unit    | 

 
    And   there are no open tasks for the contract 
    And   there is no contract owner assigned to the latest version of the contract 
 
    # Check deliverable period count prior to approval 
    And   there are '6' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # Check Contract documentation (16390) 
    And   a file named '10017088_' & '[ContractNo]' & '_v1.pdf' does not exist in sharepoint location 'LEVY-1799-Input-Appendices' 
 # # And   the generated ts&cs document in sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order   
 #   And   the file named '10017088_[ContractNo]_v1.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
 #   """ 
 #   Department for Education Apprenticeship Agreement for Training
 #   Providers
 #   Terms and Conditions
 #   THIS AGREEMENT is made on the date the Agreement is digitally signed by the Training
 #   Provider through the Manage Your Education and Skills Funding Service having
 #   already been signed by the Department and is between:
 #   10017088 Co Ltd THE SECRETARY OF STATE FOR
 #   105 Queens Road EDUCATION
 #   Reading DEPARTMENT FOR
 #   Berkshire EDUCATION
 #   AND
 #   RG1 4DA 20 GREAT SMITH STREET
 #   LONDON
 #   SW1P 3BT
 #   Company No: AA017088
 #   UKPRN: 10017088
 #   Referred to in this Agreement as “the Referred to in this Agreement as “the
 #   Training Provider” Department”
 #   “Expiry Date” means 31 July 2025 or such later date as is notified in writing by
 #   Department for Education Apprenticeship Agreement for Training Providers, Winter 2022, Version
 #   4.1
 #   Education & Skills Funding Agency
 #   Education and Skills Funding Agency - GOV.UK (www.gov.uk)
 #   56
 #   """
 #
 #   # The Amendment Letter is not included
 #   And   the pdf file does not contain the following text
 #   """
 #   Agreement number: [MasterContractNo] 
 #   """

    # Save a copy of the output 
    Then  Sharepoint file '10017088_[ContractNo]_v1.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as '10017088_LEVY-088_v1.pdf' 
 
 
 
 
    # Change the date 
    Given the override date is '03/03/2026' 
 
    # Approve the contract 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 
 
    # Check deliverable period count after approval 
    Then  there are '34' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # After approval there should be a Jun-20 deliverable period for each of deliverables 1 through 14 for each allocation 
    Then   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Mar-26   | DeliverableDescription                               | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 15              | 0                     | 0.00     | 0.00     | Total Levy Apprenticeship Unit                       | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 16              | 15                    | ?        | 0.00     | Apprenticeship Unit Funding Levy Adult               | 
    | 10017088 | LEVY              | [AllocRef_LEVY]     | 17              | 15                    | ?        | 0.00     | Apprenticeship Unit Funding Levy Adult Learning Support | 
     
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 15              | 0                     | 0.00     | 0.00     | Total Non-Levy Apprenticeship Unit                            |  
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 16              | 15                    | ?        | 0.00     | Apprenticeship Unit Funding Non-Levy Adult-Programme Funding  | 
    | 10017088 | NONLEVY           | [AllocRef_NLA]      | 17              | 15                    | ?        | 0.00     | Apprenticeship Unit Funding Non-Levy Adult-Learning Support   | 

 
    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017088 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 03/03/2026        | ?               | ?             | 
    | 10017088 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 
 
    # Check ALLOCATION dates in CRM 
    And   the following allocation values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | 
    | 10017088 | [ContractNo]       | 1                     | [AllocRef_LEVY]     | 03/03/2026          | ?                 | 
    | 10017088 | [ContractNo]       | 1                     | [AllocRef_NLA]      | 03/03/2026          | ?                 | 
 



    # Add PoI 'actuals' to the contract

    # Change the date
    Given the override date is '04/04/2026'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017088'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull DCFS PoI actuals from DC for Mar 2021
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | LEVY1799                | [AllocRef_LEVY]          |            | 2               | 0            | 574.02      |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | LEVY1799                | [AllocRef_LEVY]          |            | 3               | 0            | 119.43      |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | LEVY1799                | [AllocRef_LEVY]          |            | 4               | 0            | 1061.67     |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | LEVY1799                | [AllocRef_LEVY]          |            | 5               | 0            | 462.04      |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | LEVY1799                | [AllocRef_LEVY]          |            | 6               | 0            | 1092.23     |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | LEVY1799                | [AllocRef_LEVY]          |            | 8               | 0            | 170.22      |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | LEVY1799                | [AllocRef_LEVY]          |            | 9               | 0            | 643.04      |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | LEVY1799                | [AllocRef_LEVY]          |            | 10              | 0            | 1466.72     |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | LEVY1799                | [AllocRef_LEVY]          |            | 11              | 0            | 581.87      |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | LEVY1799                | [AllocRef_LEVY]          |            | 12              | 0            | 140.31      |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | LEVY1799                | [AllocRef_LEVY]          |            | 13              | 0            | 165.72      |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | LEVY1799                | [AllocRef_LEVY]          |            | 14              | 0            | 749.76      |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | LEVY1799                | [AllocRef_LEVY]          |            | 16              | 0            | 709.76      |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | LEVY1799                | [AllocRef_LEVY]          |            | 17              | 0            | 849.76      |
    #
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | NONLEVY2019             | [AllocRef_NLA]           |            | 2               | 0            | 1129.36     |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | NONLEVY2019             | [AllocRef_NLA]           |            | 3               | 0            | 857.96      |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | NONLEVY2019             | [AllocRef_NLA]           |            | 4               | 0            | 1082.47     |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | NONLEVY2019             | [AllocRef_NLA]           |            | 5               | 0            | 340.52      |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | NONLEVY2019             | [AllocRef_NLA]           |            | 6               | 0            | 1284.19     |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | NONLEVY2019             | [AllocRef_NLA]           |            | 7               | 0            | 1162.17     |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | NONLEVY2019             | [AllocRef_NLA]           |            | 9               | 0            | 1013.74     |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | NONLEVY2019             | [AllocRef_NLA]           |            | 10              | 0            | 1165.00     |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | NONLEVY2019             | [AllocRef_NLA]           |            | 11              | 0            | 105.82      |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | NONLEVY2019             | [AllocRef_NLA]           |            | 12              | 0            | 1162.06     |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | NONLEVY2019             | [AllocRef_NLA]           |            | 13              | 0            | 769.71      |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | NONLEVY2019             | [AllocRef_NLA]           |            | 14              | 0            | 180.26      |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | NONLEVY2019             | [AllocRef_NLA]           |            | 16              | 0            | 980.26      |
    | APPS           | APPS107               | ORG0017088     | CM             | 202603 | NONLEVY2019             | [AllocRef_NLA]           |            | 17              | 0            | 680.26      |



    Then wait '20' seconds

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


    # Check CRM financials for Levy

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Mar-26   |
    | [ContractNo]   | [AllocRef_LEVY]    | 1               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]    | 7               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]    | 15               | 0.00      | ?        | 


#    And   the Actuals Value Data is as follows
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Mar-26   | Mar-27   |
#    | [ContractNo]   | [AllocRef_LEVY]    | 2               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 3               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 4               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 5               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 6               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 8               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 9               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 10              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 11              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 12              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 13              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 14              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 16              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 17              | 0.00      | ?        | 0.00     | 
#

#
#    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
#    And   the Profile Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   |
#    | [ContractNo]   | [AllocRef_LEVY]    | 1               | 0.00      | ?        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 7               | 0.00      | ?        | 
#
#    And   the Profile Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Mar-21   |
#    | [ContractNo]   | [AllocRef_LEVY]    | 2               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 3               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 4               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 5               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 6               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 8               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 9               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 10              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 11              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 12              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 13              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 14              | 0.00      | ?        | 0.00     | 
#
#    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
#    And   the Balancing Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   |
#    | [ContractNo]   | [AllocRef_LEVY]    | 1               | 0.00      | ?        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 7               | 0.00      | ?        | 
#
#    And   the Balancing Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Mar-21   |
#    | [ContractNo]   | [AllocRef_LEVY]    | 2               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 3               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 4               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 5               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 6               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 8               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 9               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 10              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 11              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 12              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 13              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 14              | 0.00      | ?        | 0.00     | 
#
#    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
#    And   the Reconciliation Data is calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   |
#    | [ContractNo]   | [AllocRef_LEVY]    | 1               | 0.00      | ?        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 7               | 0.00      | ?        | 
#
#    And   the Reconciliation Data is calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Mar-21   |
#    | [ContractNo]   | [AllocRef_LEVY]    | 2               | 574.02    | ?        | 574.02   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 3               | 119.43    | ?        | 119.43   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 4               | 1061.67   | ?        | 1061.67  | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 5               | 462.04    | ?        | 462.04   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 6               | 1092.23   | ?        | 1092.23  | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 8               | 170.22    | ?        | 170.22   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 9               | 643.04    | ?        | 643.04   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 10              | 1466.72   | ?        | 1466.72  | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 11              | 581.87    | ?        | 581.87   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 12              | 140.31    | ?        | 140.31   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 13              | 165.72    | ?        | 165.72   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 14              | 749.76    | ?        | 749.76   | 
#
#    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
#    And   the Capping Amounts are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   |
#    | [ContractNo]   | [AllocRef_LEVY]    | 1               | 0.00      | ?        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 7               | 0.00      | ?        | 
#
#    And   the Capping Amounts are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Mar-21   |
#    | [ContractNo]   | [AllocRef_LEVY]    | 2               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 3               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 4               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 5               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 6               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 8               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 9               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 10              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 11              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 12              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 13              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 14              | 0.00      | ?        | 0.00     | 
#
#    # Check the NET AMOUNTS in CRM on the latest approved contract
#    And   the Net Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   |
#    | [ContractNo]   | [AllocRef_LEVY]    | 1               | 0.00      | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 7               | 0.00      | 0.00     | 
#
#    And   the Net Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Mar-21   |
#    | [ContractNo]   | [AllocRef_LEVY]    | 2               | 574.02    | 0.00     | 574.02   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 3               | 119.43    | 0.00     | 119.43   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 4               | 1061.67   | 0.00     | 1061.67  | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 5               | 462.04    | 0.00     | 462.04   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 6               | 1092.23   | 0.00     | 1092.23  | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 8               | 170.22    | 0.00     | 170.22   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 9               | 643.04    | 0.00     | 643.04   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 10              | 1466.72   | 0.00     | 1466.72  | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 11              | 581.87    | 0.00     | 581.87   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 12              | 140.31    | 0.00     | 140.31   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 13              | 165.72    | 0.00     | 165.72   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 14              | 749.76    | 0.00     | 749.76   | 
#
#    # Check the PLANNED VALUES in CRM on the latest approved contract
#    And   the Planned Values are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   |
#    | [ContractNo]   | [AllocRef_LEVY]    | 1               | 0.00      | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 7               | 0.00      | 0.00     | 
#
#    And   the Planned Values are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Mar-21   |
#    | [ContractNo]   | [AllocRef_LEVY]    | 2               | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 3               | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 4               | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 5               | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 6               | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 8               | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 9               | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 10              | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 11              | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 12              | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 13              | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 14              | 0.00      | 0.00     | 0.00     | 
#
#    # Check the PLANNED VOLUMES in CRM on the latest approved contract
#    And   the Planned Volumes are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   |
#    | [ContractNo]   | [AllocRef_LEVY]    | 1               | 0         | 0        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 7               | 0         | 0        | 
#
#    And   the Planned Volumes are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Mar-21   |
#    | [ContractNo]   | [AllocRef_LEVY]    | 2               | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 3               | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 4               | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 5               | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 6               | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 8               | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 9               | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 10              | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 11              | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 12              | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 13              | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 14              | 0         | 0        | 0        | 
#
#    # Check the ACTUAL VOLUMES in CRM on the latest approved contract
#    And   the Actuals Volume Data is as follows
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   |
#    | [ContractNo]   | [AllocRef_LEVY]    | 1               | 0         | ?        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 7               | 0         | ?        | 
#
#    And   the Actuals Volume Data is as follows
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Mar-21   |
#    | [ContractNo]   | [AllocRef_LEVY]    | 2               | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 3               | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 4               | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 5               | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 6               | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 8               | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 9               | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 10              | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 11              | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 12              | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 13              | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 14              | 0         | ?        | ?        | 
#
#
#


    Then wait '20' seconds


	# Check CRM financials for non-Levy

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Mar-26   |
    | [ContractNo]   | [AllocRef_NLA]     | 1               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]     | 8               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]     | 15              | 0.00      | ?        | 


#    And   the Actuals Value Data is as follows
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Mar-26   | Mar-27   |
#    | [ContractNo]   | [AllocRef_NLA]     | 2               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 3               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 4               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 5               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 6               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 7               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 9               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 10              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 11              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 12              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 13              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 14              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 16              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 17              | 0.00      | ?        | 0.00     | 
#

#
#    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
#    And   the Profile Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   |
#    | [ContractNo]   | [AllocRef_NLA]     | 1               | 0.00      | ?        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 8               | 0.00      | ?        | 
#
#    And   the Profile Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Mar-210   |
#    | [ContractNo]   | [AllocRef_NLA]     | 2               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 3               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 4               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 5               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 6               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 7               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 9               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 10              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 11              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 12              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 13              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 14              | 0.00      | ?        | 0.00     | 
#
#    # Check the BALANCING PAYMENTS in CRM on the latest approved contract
#    And   the Balancing Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   |
#    | [ContractNo]   | [AllocRef_NLA]     | 1               | 0.00      | ?        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 8               | 0.00      | ?        | 
#
#    And   the Balancing Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Mar-21   |
#    | [ContractNo]   | [AllocRef_NLA]     | 2               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 3               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 4               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 5               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 6               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 7               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 9               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 10              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 11              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 12              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 13              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 14              | 0.00      | ?        | 0.00     | 
#
#    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
#    And   the Reconciliation Data is calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   |
#    | [ContractNo]   | [AllocRef_NLA]     | 1               | 0.00      | ?        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 8               | 0.00      | ?        | 
#
#    And   the Reconciliation Data is calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Mar-21   |
#    | [ContractNo]   | [AllocRef_NLA]     | 2               | 1129.36   | ?        | 1129.36  | 
#    | [ContractNo]   | [AllocRef_NLA]     | 3               | 857.96    | ?        | 857.96   | 
#    | [ContractNo]   | [AllocRef_NLA]     | 4               | 1082.47   | ?        | 1082.47  | 
#    | [ContractNo]   | [AllocRef_NLA]     | 5               | 340.52    | ?        | 340.52   | 
#    | [ContractNo]   | [AllocRef_NLA]     | 6               | 1284.19   | ?        | 1284.19  | 
#    | [ContractNo]   | [AllocRef_NLA]     | 7               | 1162.17   | ?        | 1162.17  | 
#    | [ContractNo]   | [AllocRef_NLA]     | 9               | 1013.74   | ?        | 1013.74  | 
#    | [ContractNo]   | [AllocRef_NLA]     | 10              | 1165.00   | ?        | 1165.00  | 
#    | [ContractNo]   | [AllocRef_NLA]     | 11              | 105.82    | ?        | 105.82   | 
#    | [ContractNo]   | [AllocRef_NLA]     | 12              | 1162.06   | ?        | 1162.06  | 
#    | [ContractNo]   | [AllocRef_NLA]     | 13              | 769.71    | ?        | 769.71   | 
#    | [ContractNo]   | [AllocRef_NLA]     | 14              | 180.26    | ?        | 180.26   | 
#
#    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
#    And   the Capping Amounts are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   |
#    | [ContractNo]   | [AllocRef_NLA]     | 1               | 0.00      | ?        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 8               | 0.00      | ?        | 
#
#    And   the Capping Amounts are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Mar-21   |
#    | [ContractNo]   | [AllocRef_NLA]     | 2               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 3               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 4               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 5               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 6               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 7               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 9               | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 10              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 11              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 12              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 13              | 0.00      | ?        | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 14              | 0.00      | ?        | 0.00     | 
#
#    # Check the NET AMOUNTS in CRM on the latest approved contract
#    And   the Net Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   |
#    | [ContractNo]   | [AllocRef_NLA]     | 1               | 0.00      | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 8               | 0.00      | 0.00     | 
#
#    And   the Net Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Mar-21   |
#    | [ContractNo]   | [AllocRef_NLA]     | 2               | 1129.36   | 0.00     | 1129.36  | 
#    | [ContractNo]   | [AllocRef_NLA]     | 3               | 857.96    | 0.00     | 857.96   | 
#    | [ContractNo]   | [AllocRef_NLA]     | 4               | 1082.47   | 0.00     | 1082.47  | 
#    | [ContractNo]   | [AllocRef_NLA]     | 5               | 340.52    | 0.00     | 340.52   | 
#    | [ContractNo]   | [AllocRef_NLA]     | 6               | 1284.19   | 0.00     | 1284.19  | 
#    | [ContractNo]   | [AllocRef_NLA]     | 7               | 1162.17   | 0.00     | 1162.17  | 
#    | [ContractNo]   | [AllocRef_NLA]     | 9               | 1013.74   | 0.00     | 1013.74  | 
#    | [ContractNo]   | [AllocRef_NLA]     | 10              | 1165.00   | 0.00     | 1165.00  | 
#    | [ContractNo]   | [AllocRef_NLA]     | 11              | 105.82    | 0.00     | 105.82   | 
#    | [ContractNo]   | [AllocRef_NLA]     | 12              | 1162.06   | 0.00     | 1162.06  | 
#    | [ContractNo]   | [AllocRef_NLA]     | 13              | 769.71    | 0.00     | 769.71   | 
#    | [ContractNo]   | [AllocRef_NLA]     | 14              | 180.26    | 0.00     | 180.26   | 
#
#    # Check the PLANNED VALUES in CRM on the latest approved contract
#    And   the Planned Values are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   |
#    | [ContractNo]   | [AllocRef_NLA]     | 1               | 0.00      | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 8               | 0.00      | 0.00     | 
#
#    And   the Planned Values are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Mar-21   |
#    | [ContractNo]   | [AllocRef_NLA]     | 2               | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 3               | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 4               | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 5               | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 6               | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 7               | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 9               | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 10              | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 11              | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 12              | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 13              | 0.00      | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_NLA]     | 14              | 0.00      | 0.00     | 0.00     | 
#
#    # Check the PLANNED VOLUMES in CRM on the latest approved contract
#    And   the Planned Volumes are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   |
#    | [ContractNo]   | [AllocRef_NLA]     | 1               | 0         | 0        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 8               | 0         | 0        | 
#
#    And   the Planned Volumes are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Mar-21   |
#    | [ContractNo]   | [AllocRef_NLA]     | 2               | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 3               | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 4               | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 5               | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 6               | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 7               | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 9               | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 10              | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 11              | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 12              | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 13              | 0         | 0        | 0        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 14              | 0         | 0        | 0        | 
#
#    # Check the ACTUAL VOLUMES in CRM on the latest approved contract
#    And   the Actuals Volume Data is as follows
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   |
#    | [ContractNo]   | [AllocRef_NLA]     | 1               | 0         | ?        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 8               | 0         | ?        | 
#
#    And   the Actuals Volume Data is as follows
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jun-20   | Mar-21   |
#    | [ContractNo]   | [AllocRef_NLA]     | 2               | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 3               | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 4               | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 5               | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 6               | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 7               | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 9               | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 10              | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 11              | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 12              | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 13              | 0         | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_NLA]     | 14              | 0         | ?        | ?        | 
#

#
#
#	# Check Subnominal Aggregations in CRM for Levy and non-Levy
#   
#    # Check the RECONCILIATION subnominal aggregations in CRM 
#    Then  the Reconciliation Subnominal Amounts are calculated as follows
#    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Mar-21    |
#    | [ContractNo]   | [AllocRef_LEVY]    | 2240110                  | 574.02    | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 2240120                  | 119.43    | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 2240130                  | 1523.71   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 2240140                  | 1092.23   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 2240142                  | 165.72    | 
#	#
#    | [ContractNo]   | [AllocRef_LEVY]    | 2340110                  | 170.22    | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 2340120                  | 643.04    | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 2340130                  | 2048.59   | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 2340140                  | 140.31    | 
#    | [ContractNo]   | [AllocRef_LEVY]    | 2340142                  | 749.76    | 
#
#    # Check the RECONCILIATION subnominal aggregations in CRM 
#    Then  the Reconciliation Subnominal Amounts are calculated as follows
#    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Mar-21    |
#    | [ContractNo]   | [AllocRef_NLA]     | 2240200                  | 1129.36   | 
#    | [ContractNo]   | [AllocRef_NLA]     | 2240210                  | 857.96    | 
#    | [ContractNo]   | [AllocRef_NLA]     | 2240220                  | 1422.99   | 
#    | [ContractNo]   | [AllocRef_NLA]     | 2240230                  | 1284.19   | 
#    | [ContractNo]   | [AllocRef_NLA]     | 2240240                  | 1162.17   | 
#	#
#    | [ContractNo]   | [AllocRef_NLA]     | 2340200                  | 1013.74   | 
#    | [ContractNo]   | [AllocRef_NLA]     | 2340210                  | 1165.00   | 
#    | [ContractNo]   | [AllocRef_NLA]     | 2340220                  | 1267.88   | 
#    | [ContractNo]   | [AllocRef_NLA]     | 2340230                  | 769.71    | 
#    | [ContractNo]   | [AllocRef_NLA]     | 2340240                  | 180.26    | 
#
#
#
#
#    # Check payments in PaaS for Levy and non-Levy
#
#    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
#    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
#    | AllocationNumber    | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
#    | [AllocRef_LEVY]     | 1             | 2               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 574.02                      | 574.02           | ?            | 0.00        |
#    | [AllocRef_LEVY]     | 1             | 3               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 119.43                      | 119.43           | ?            | 0.00        |
#    | [AllocRef_LEVY]     | 1             | 4               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1061.67                     | 1061.67          | ?            | 0.00        |
#    | [AllocRef_LEVY]     | 1             | 5               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 462.04                      | 462.04           | ?            | 0.00        |
#    | [AllocRef_LEVY]     | 1             | 6               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1092.23                     | 1092.23          | ?            | 0.00        |
#    | [AllocRef_LEVY]     | 1             | 8               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 170.22                      | 170.22           | ?            | 0.00        |
#    | [AllocRef_LEVY]     | 1             | 9               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 643.04                      | 643.04           | ?            | 0.00        |
#    | [AllocRef_LEVY]     | 1             | 10              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1466.72                     | 1466.72          | ?            | 0.00        |
#    | [AllocRef_LEVY]     | 1             | 11              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 581.87                      | 581.87           | ?            | 0.00        |
#    | [AllocRef_LEVY]     | 1             | 12              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 140.31                      | 140.31           | ?            | 0.00        |
#    | [AllocRef_LEVY]     | 1             | 13              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 165.72                      | 165.72           | ?            | 0.00        |
#    | [AllocRef_LEVY]     | 1             | 14              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 749.76                      | 749.76           | ?            | 0.00        |
#    #
#    | [AllocRef_NLA]      | 1             | 2               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1129.36                     | 1129.36          | ?            | 0.00        |
#    | [AllocRef_NLA]      | 1             | 3               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 857.96                      | 857.96           | ?            | 0.00        |
#    | [AllocRef_NLA]      | 1             | 4               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1082.47                     | 1082.47          | ?            | 0.00        |
#    | [AllocRef_NLA]      | 1             | 5               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 340.52                      | 340.52           | ?            | 0.00        |
#    | [AllocRef_NLA]      | 1             | 6               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1284.19                     | 1284.19          | ?            | 0.00        |
#    | [AllocRef_NLA]      | 1             | 7               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1162.17                     | 1162.17          | ?            | 0.00        |
#    | [AllocRef_NLA]      | 1             | 9               | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1013.74                     | 1013.74          | ?            | 0.00        |
#    | [AllocRef_NLA]      | 1             | 10              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1165.00                     | 1165.00          | ?            | 0.00        |
#    | [AllocRef_NLA]      | 1             | 11              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 105.82                      | 105.82           | ?            | 0.00        |
#    | [AllocRef_NLA]      | 1             | 12              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1162.06                     | 1162.06          | ?            | 0.00        |
#    | [AllocRef_NLA]      | 1             | 13              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 769.71                      | 769.71           | ?            | 0.00        |
#    | [AllocRef_NLA]      | 1             | 14              | 202103 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 180.26                      | 180.26           | ?            | 0.00        |
#
#
#    # Check Subnominal Aggregations in PaaS for Levy and non-Levy
#	
#	# Check the RECONCILIATION subnominal aggregations in PaaS
#    And   the PaymentGeneration.SubnominalAggregation table contains the following values
#    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
#    | 10017088 | ORG0017088 | [AllocRef_LEVY]   | 2240110         | LEVY1799                   | 202103               | RECONCILIATION  | CM             | False       | 574.02          |
#    | 10017088 | ORG0017088 | [AllocRef_LEVY]   | 2240120         | LEVY1799                   | 202103               | RECONCILIATION  | CM             | False       | 119.43          |
#    | 10017088 | ORG0017088 | [AllocRef_LEVY]   | 2240130         | LEVY1799                   | 202103               | RECONCILIATION  | CM             | False       | 1523.71         |
#    | 10017088 | ORG0017088 | [AllocRef_LEVY]   | 2240140         | LEVY1799                   | 202103               | RECONCILIATION  | CM             | False       | 1092.23         |
#    | 10017088 | ORG0017088 | [AllocRef_LEVY]   | 2240142         | LEVY1799                   | 202103               | RECONCILIATION  | CM             | False       | 165.72          |
#    | 10017088 | ORG0017088 | [AllocRef_LEVY]   | 2340110         | LEVY1799                   | 202103               | RECONCILIATION  | CM             | False       | 170.22          |
#    | 10017088 | ORG0017088 | [AllocRef_LEVY]   | 2340120         | LEVY1799                   | 202103               | RECONCILIATION  | CM             | False       | 643.04          |
#    | 10017088 | ORG0017088 | [AllocRef_LEVY]   | 2340130         | LEVY1799                   | 202103               | RECONCILIATION  | CM             | False       | 2048.59         |
#    | 10017088 | ORG0017088 | [AllocRef_LEVY]   | 2340140         | LEVY1799                   | 202103               | RECONCILIATION  | CM             | False       | 140.31          |
#    | 10017088 | ORG0017088 | [AllocRef_LEVY]   | 2340142         | LEVY1799                   | 202103               | RECONCILIATION  | CM             | False       | 749.76          |
#    #
#    | 10017088 | ORG0017088 | [AllocRef_NLA]    | 2240200         | NONLEVY2019                | 202103               | RECONCILIATION  | CM             | False       | 1129.36         |
#    | 10017088 | ORG0017088 | [AllocRef_NLA]    | 2240210         | NONLEVY2019                | 202103               | RECONCILIATION  | CM             | False       | 857.96          |
#    | 10017088 | ORG0017088 | [AllocRef_NLA]    | 2240220         | NONLEVY2019                | 202103               | RECONCILIATION  | CM             | False       | 1422.99         |
#    | 10017088 | ORG0017088 | [AllocRef_NLA]    | 2240230         | NONLEVY2019                | 202103               | RECONCILIATION  | CM             | False       | 1284.19         |
#    | 10017088 | ORG0017088 | [AllocRef_NLA]    | 2240240         | NONLEVY2019                | 202103               | RECONCILIATION  | CM             | False       | 1162.17         |
#    | 10017088 | ORG0017088 | [AllocRef_NLA]    | 2340200         | NONLEVY2019                | 202103               | RECONCILIATION  | CM             | False       | 1013.74         |
#    | 10017088 | ORG0017088 | [AllocRef_NLA]    | 2340210         | NONLEVY2019                | 202103               | RECONCILIATION  | CM             | False       | 1165.00         |
#    | 10017088 | ORG0017088 | [AllocRef_NLA]    | 2340220         | NONLEVY2019                | 202103               | RECONCILIATION  | CM             | False       | 1267.88         |
#    | 10017088 | ORG0017088 | [AllocRef_NLA]    | 2340230         | NONLEVY2019                | 202103               | RECONCILIATION  | CM             | False       | 769.71          |
#    | 10017088 | ORG0017088 | [AllocRef_NLA]    | 2340240         | NONLEVY2019                | 202103               | RECONCILIATION  | CM             | False       | 180.26          |
#
#
#    # Check deliverable period count in CRM
#    And   there are '52' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




 # Payment Batch for LEVY1799 (PoA)

    # Change the date
    Given the override date is '10/04/2026 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'LEVY1799' AccountingPaymentPeriod '202512' CensusEndDate '10/04/2026' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber   | Period |
    | [AllocRef_LEVY]            | 202603 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | LEVY1799                   | 202603               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | LEVY1799                   | 202603               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'LEVY1799' PaymentPeriod '202512' CensusEndDate '10/04/2026' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A088_LEVY.xml'
#


 # Payment Batch for NONLEVY2019 (PoA)

    # Change the date
    Given the override date is '10/04/2026 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'NONLEVY2019' AccountingPaymentPeriod '202512' CensusEndDate '10/04/2026' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber   | Period |
    | [AllocRef_NLA]             | 202603 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | NONLEVY2019                | 202603               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | NONLEVY2019                | 202603               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'NONLEVY2019' PaymentPeriod '202512' CensusEndDate '10/04/2026' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A088_NONLEVY.xml'
#



    # Change the date
    Given the override date is '11/04/2026 09:05'
    
   #  Part 10: Create Consolidated Payment Summary rpt
   
   #  Set the override date, run the ESFA Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
   Given there are no files prefixed '2026-04 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder

   When  a Consolidated Payment Summary Report is created in Sharepoint for '11/04/2026'

    # Check the above report manually





    # Part 6: Create and check the contents of the CDA report
   
    # Change the date
    Given the override date is '12/04/2026'
    
    # Check the contents of the CDA report
    And   there is no CDA report named 'CDA Last Approved Version A088.csv'

    And   the following ADF Pipeline run

    #And   the following contracts are in the replicated CRM database
    #| ContractNumber  | ContractVersionNumber |
    #| [ContractNo]    | 3                     |

   #When  the following CDA reports are run
    When  the following CDA report is run
    | FundingStreamPeriod	        | Version               | Suffix |
    | NONLEVY2019                   | Last Approved         | A088   |

    Then  a report named 'CDA Last Approved Version A088.csv' is created

    # Check the contents of the CDA Report manually



    # Tidy Up
	And   the override date is reset

