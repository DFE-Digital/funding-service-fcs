Feature: LevyDocs 31122

@AcceptanceTest @Complete
Scenario: A288 Create and approve a Levy contract with both allocs. Amend with ShouldMergeAmendmentTemplate set false then true. Check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017288' 
    And   there are no terminated or closed allocations for UKPRN '10017288' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017288' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017288' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017288' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017288' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017288' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table 
    And   there are no DAS engagement events stored in FCS 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017288' 
 
    # Clear down all subnominal data from PaaS for an FSP 
    And   there is no Subnominal data in PaaS for the following FSPs 
    | FSP            | 
    | LEVY1799       | 
    | NONLEVY2019    | 
 
 


    # Remove the provider from RoATP (ContractManagement.RoATPProvider) 
    And   there is no data on RoATP for the following providers 
    | Ukprn    | 
    | 10017288 | 
 
    # Add the provider to RoATP (ContractManagement.RoATPProvider) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017288 | 10017288 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017288' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017288 Co Ltd' with UKPRN '10017288' and OrgId 'ORG0017288' and has 'FCS1 Test' as a manager 
 
    # Put data in the PaaS Organisation table (Organisation.Organisation) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017288 | 117288 | 10017288 Co Ltd | 0              | Active                | Yes           | AA017288      | ?             | 1 College Place        | Derby                  | ?                      | ?                      | ?                      | ?                      | DE1 3DY   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017288 |

 
 
 
    # Change the date 
    Given the override date is '16/03/2020' 
 
    # Inject data into the stub to create a contract with two allocations
    And   the following Levy event data is available in the DAS agreement stub 
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 62288 | INITIATED | 2019-12-15T18:03:12.2288 | 10017288   | 28288             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017288' 
    Then  there is only one Levy contract in CRM for UKPRN '10017288' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 
 
    # Retrieve parameters from CRM 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017288' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017288' 
    And   I retrieve the latest contract details from CRM for provider '10017288' for FundingType 'LEVY' and period '1799' 
 
 
 
 
    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017288 | 10017288 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017288 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017288 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017288 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017288 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017288 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017288 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017288 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 
 
    And   there are no open tasks for the contract 
    And   there is no contract owner assigned to the latest version of the contract 
 
    ## Check deliverable period count prior to approval 
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
 
 
 
    # Check Contract documentation (16390) - One part: 'T&C_Levy_2017-05-01'
    And   a file named '10017288_' & '[ContractNo]' & '_v1.pdf' does not exist in sharepoint location 'LEVY-1799-Input-Appendices' 
    #And   the file named '10017288_[ContractNo]_v1.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order

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
    
    # Save a copy of the output 
    And   Sharepoint file '10017288_[ContractNo]_v1.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A288_v1.pdf' 
 
 
 
 
 
    # Variation amendment against draft contract with ShouldMergeAmendmentTemplate=No
    
    # Change the date
    Given the override date is '25/08/2020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    
    # Issue a contract amendment request on v1 to create v2. ShouldMergeAmendmentTemplate=No
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status | SubStatus             | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate | AllowUnderTermination |
    | 10017288 | [MasterContractNo]   | [ContractNo]   | 1       | Draft  | Published to Provider | Variation     | No                       | No                           | Yes                   |

    And   wait '20' seconds

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017288' for FundingType 'LEVY' and period '1799' 

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017288 | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/05/2017        | ?               | Variation     |
    | 10017288 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Agency       | False         | False               | 01/05/2017        | ?               | ?             |
    | 10017288 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check Contract documentation (16390) - One part: 'LEVY1799_Amendment' doc
    And   a file named '10017288_' & '[ContractNo]' & '_v2.pdf' does not exist in sharepoint location 'LEVY-1799-Input-Appendices' 
    #And   the file named '10017288_[ContractNo]_v2.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order
    #"""
    #(C) The Department’s reference for this Variation is January 2026, Version 4.5.
    #SIGNED FOR AND ON BEHALF OF
    #THE SECRETARY OF STATE FOR EDUCATION
    #by Andrew Thomas, Director of Funding and Financial Oversight
    #Agreement number: [MasterContractNo]
    #Department for Education Apprenticeships-Provider Agreement, January 2026, Version 4.5
    #Department for Education
    #Department for Education - GOV.UK
    #69
    #"""

    ## The Agreement doc is not included
    #And   the pdf file does not contain the following text
    #"""
    #Terms and Conditions
    #"""

    # Save a copy of the output 
    And   Sharepoint file '10017288_[ContractNo]_v2.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A288_v2.pdf' 




    # Variation amendment against draft contract with ShouldMergeAmendmentTemplate=Yes
    
    # Change the date
    Given the override date is '27/08/2020'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    
    # Issue a contract amendment request on v2 to create v3. ShouldMergeAmendmentTemplate=Yes
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status | SubStatus             | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate | AllowUnderTermination |
    | 10017288 | [MasterContractNo]   | [ContractNo]   | 2       | Draft  | Published to Provider | Variation     | No                       | Yes                          | Yes                   |

    And   wait '20' seconds

    # Retrieve parameters from CRM 
    When  I retrieve the latest contract details from CRM for provider '10017288' for FundingType 'LEVY' and period '1799' 

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017288 | [ContractNo]       | 3                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/05/2017        | ?               | Variation     |
    | 10017288 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Agency       | False         | False               | 01/05/2017        | ?               | Variation     |
    | 10017288 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Agency       | False         | False               | 01/05/2017        | ?               | ?             |
    | 10017288 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check Contract documentation (16390) - Two parts: 'LEVY1799_Amendment' then 'T&C_LEVY_2017-05-01' doc
    And   a file named '10017288_' & '[ContractNo]' & '_v3.pdf' does not exist in sharepoint location 'LEVY-1799-Input-Appendices' 
    And   the file named '10017288_[ContractNo]_v3.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order
    """
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by Andrew Thomas, Director of Funding and Financial Oversight
    Agreement number: [MasterContractNo]
    Department for Education Apprenticeships-Provider Agreement, July 2026, Version 4.6
    """

    # Save a copy of the output 
    And   Sharepoint file '10017288_[ContractNo]_v3.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A288_v3.pdf' 
    
    
    # Tidy Up
    And   the override date is reset  
       
