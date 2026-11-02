Feature: LevyAmendmentsAndPayments 20277

@AcceptanceTest @Complete
@PublishNewLevyContract @PaymentScheduleTests @PaymentGenerationAndTransmission @ContractClosure
@ADP
Scenario: A545 Create and approve a Levy contract. Amend (bulk) but don't approve (Notification and No). Consume actuals. Approve. Consume actuals. Check PaaS, ADP feed, docs and RoATP anomalies report
    Given there is no Contract, Task or Workflow data for UKPRN '10017545'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'NACRO' with UKPRN '10017545' and OrgId 'ORG0017545' and has 'FCS1 Test' as a manager
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017545'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017545'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no entries in the DCFS stub table
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017545'
    And   there are no DAS engagement events stored in FCS
    And   the Allocation Delivery Monitoring Service atom feed is empty
    And   the override date is '21/04/2017'
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Set RoATP data (needed for amendment checks)
    And   the following providers exist on RoATP
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
    | 10017545 | 10017545 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    


    # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017545'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017545 Co Ltd' with UKPRN '10017545' and OrgId 'ORG0017545' and has 'FCS1 Test' as a manager
    And   UPIN '117545' is associated with UKPRN '10017545' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017545 | 117545 | 10017545 Co Ltd | 0              | Active                | Yes           | AA017277      | ?             | 9 Bottisham Close      | Lower Earley           | ?                      | ?                      | Reading                | Berkshire              | RG6 4ED   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017545 |


    # Inject data into the stub
   #And   the following Levy event data is available in the DAS agreement stub
    And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation
    | Id    | Event     | CreatedOn                | ProviderId | ContractType      |
    | 17545 | INITIATED | 2017-02-16T09:31:29.1317 | 10017545   | ProviderAgreement |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017545'
    Then  there is only one Levy contract in CRM for UKPRN '10017545' with a status of 'Draft' 

    And wait '10' seconds

    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    #And   the latest version of the contract has the following settings 
    #| Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    #| Draft  | Internally Approved    | Yes           | No                  | 1                     | 

    # Retrieve parameters from CRM  
   #When  I retrieve the latest EFA contract details from CRM for provider '10017545' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017545' 
    And   I retrieve the latest contract details from CRM for provider '10017545' for FundingType 'LEVY' and period '1799' 

    # Publish the contract (This is needed because the injection step above leaves the contract in the wrong state)
    Given the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'




    # Check contract creation
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017545 | 10017545 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017545 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017545 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription              | 
    | 10017545 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships    | 
    | 10017545 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships    | 

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    ## Check deliverable period count prior to approval 
    #And   there are '2' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 



    
    # Change the date
    Given the override date is '01/05/2017'
    
    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017545 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/05/2017        | ?               | ?             |
    | 10017545 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |
    
    
    
    
    # Change the date
    Given the override date is '04/06/2017'

    # Pull DCFS PoI actuals for May 2017
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS01               | ORG0017545     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 417.41      |
    | APPS           | APPS01               | ORG0017545     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 421.21      |
    | APPS           | APPS01               | ORG0017545     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 546.55      |
    | APPS           | APPS01               | ORG0017545     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 0.00        |
    | APPS           | APPS01               | ORG0017545     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 267.05      |
    | APPS           | APPS01               | ORG0017545     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1168.10     |
    | APPS           | APPS01               | ORG0017545     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 228.41      |
    | APPS           | APPS01               | ORG0017545     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 0.00        |
    | APPS           | APPS01               | ORG0017545     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 260.74      |
    | APPS           | APPS01               | ORG0017545     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 0.00        |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table are against v1 of the contract
    Then  the PaymentSchedule.DeliverablePayment table contains the following values
    | AllocationNumber | VersionNumber | DeliverableCode | Period   | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | [AllocRef_LEVY]  | 1             | 2               | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 417.41                      | 417.41           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 3               | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 421.21                      | 421.21           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 4               | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 546.55                      | 546.55           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 5               | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 6               | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 267.05                      | 267.05           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 8               | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1168.10                     | 1168.10          | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 9               | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 228.41                      | 228.41           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 10              | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 11              | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 260.74                      | 260.74           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 12              | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |




    # Change the Date
    Given the override date is '12/06/2017'

    # Month-End is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Issue a contract amendment request on v1 to create v2 using the bulk mechanism
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017545 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Approved  | Notification  | No                       | Yes                   | Yes                          |

#    # The following approval step is no longer needed because the amendment is a Notification. As such, the contract will be auto-approved
#
#    # Approve v2 of the contract
#    And   the override date is '16/06/2017'
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check the CONTRACT version, status and dates in CRM.  Contract should have auto-approved
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017545 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/05/2017        | ?               | Notification  |
    | 10017545 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/05/2017        | ?               | ?             |
    | 10017545 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '14' deliverable period rows in CRM linked to the latest version of contract 'LEVY-545'
    #And   there are '14' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check the contract docs for v2 (Bulk, Notification, No)
    Then  the file named '10017545_[ContractNo]_v2.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order
    """
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by Andrew Thomas, Director of Funding and Financial Oversight
    Agreement number: [MasterContractNo]
    Department for Education Apprenticeships-Provider Agreement, July 2026, Version 4.6
    """



    

    # Change the date
    Given the override date is '04/07/2017'

    # Pull DCFS PoI actuals for June 2017
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS02               | ORG0017545     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 534.71      |
    | APPS           | APPS02               | ORG0017545     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 132.81      |
    | APPS           | APPS02               | ORG0017545     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 778.12      |
    | APPS           | APPS02               | ORG0017545     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 6.00        |
    | APPS           | APPS02               | ORG0017545     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 612.65      |
    | APPS           | APPS02               | ORG0017545     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 662.34      |
    | APPS           | APPS02               | ORG0017545     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 519.67      |
    | APPS           | APPS02               | ORG0017545     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 56.89       |
    | APPS           | APPS02               | ORG0017545     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 109.48      |
    | APPS           | APPS02               | ORG0017545     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 13.25       |


    And wait '15' seconds

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber    | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | [AllocRef_LEVY]     | 2             | 1               | 201705 | 2              | 0             | 0.00         | ?                    | 0.00                | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]     | 2             | 2               | 201705 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 417.41                      | 417.41           | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 2               | 201706 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 534.71                      | 534.71           | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 3               | 201705 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 421.21                      | 421.21           | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 3               | 201706 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 132.81                      | 132.81           | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 4               | 201705 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 546.55                      | 546.55           | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 4               | 201706 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 778.12                      | 778.12           | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 5               | 201705 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 5               | 201706 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 6.00                        | 6.00             | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 6               | 201705 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 267.05                      | 267.05           | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 6               | 201706 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 612.65                      | 612.65           | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 7               | 201705 | 2              | 0             | 0.00         | ?                    | 0.00                | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]     | 2             | 8               | 201705 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1168.10                     | 1168.10          | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 8               | 201706 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 662.34                      | 662.34           | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 9               | 201705 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 228.41                      | 228.41           | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 9               | 201706 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 519.67                      | 519.67           | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 10              | 201705 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 10              | 201706 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 56.89                       | 56.89            | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 11              | 201705 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 260.74                      | 260.74           | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 11              | 201706 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 109.48                      | 109.48           | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 12              | 201705 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 12              | 201706 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 13.25                       | 13.25            | ?            | 0.00        |
    | [AllocRef_LEVY]     | 2             | 13              | 201705 | 2              | 0             | 0.00         | ?                    | 0.00                | ?                      | ?                           | 0.00             | ?            | ?           |
    | [AllocRef_LEVY]     | 2             | 14              | 201705 | 2              | 0             | 0.00         | ?                    | 0.00                | ?                      | ?                           | 0.00             | ?            | ?           |


    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'LEVY-545'
    #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    
    # Display parameters
    And   message 'AllocRef_LEVY = [AllocRef_LEVY]' is written to the Output window    
    
    

    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check that certain ActualsUpdated rows are absent from the AllocationDelivery.AllocationDeliveryEntry table
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '2' event for version '2' of contract number '[ContractNo]' and allocation number '[AllocRef_LEVY]'
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '3' event for version '2' of contract number '[ContractNo]' and allocation number '[AllocRef_LEVY]'
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '4' event for version '2' of contract number '[ContractNo]' and allocation number '[AllocRef_LEVY]'

    # Check that the relevant events are on the ADP feed
    Then  the ADP feed includes the following values
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | ContractVersionNumber | SubVersionNumber | AllocationNumber | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    | NewContractAllocationApproved     | 0      | [ContractNo]   | 1                     | 0                | [AllocRef_LEVY]  | ?                         | ?                            |
    | AmendedContractAllocationApproved | 1      | [ContractNo]   | 2                     | 0                | [AllocRef_LEVY]  | ?                         | ?                            |

    # Check the ADP feed event header information
    And   the Allocation Delivery feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                        | CategoryLabel                        | Title                                                                                |
    | 10017545 | [ContractNo]   | 1               | 0                  | NewContractAllocationApproved       | New Contract Allocation Approved     | New Contract [ContractNo]: 1.0 with Allocation [AllocRef_LEVY] was Approved          |
    | 10017545 | [ContractNo]   | 2               | 0                  | AmendedContractAllocationApproved   | Amended Contract Allocation Approved | Amendment to Contract [ContractNo]: 2.0 with Allocation [AllocRef_LEVY] was Approved |

    # Check financials on the ADP feed
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
    | AmendedContractAllocationApproved | [ContractNo]       | 2             | [AllocRef_LEVY]  | 1               | 201705 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | [ContractNo]       | 2             | [AllocRef_LEVY]  | 7               | 201705 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
   
    # Check Planned data on the ADP feed
    And   the Allocation Delivery Monitoring Service atom feed contains the following Planned data
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume |
    | AmendedContractAllocationApproved | [ContractNo]       | 2             | [AllocRef_LEVY]  | 1               | 201705 | 0.00         | 0             |
    | AmendedContractAllocationApproved | [ContractNo]       | 2             | [AllocRef_LEVY]  | 7               | 201705 | 0.00         | 0             |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Complete 
@PublishNewLevyContract @PaymentScheduleTests @PaymentGenerationAndTransmission @ContractClosure
@ADP
Scenario: A546 Create and approve a Levy contract. Consume actuals. Amend (singleton) but don't approve. Consume actuals. Approve. Consume actuals. Check PaaS, ADP feed and RoATP anomalies report
    Given there is no Contract, Task or Workflow data for UKPRN '10017546'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'NACRO' with UKPRN '10017546' and OrgId 'ORG0017546' and has 'FCS1 Test' as a manager
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017546'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017546'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no entries in the DCFS stub table
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017546'
    And   there are no DAS engagement events stored in FCS
    And   the Allocation Delivery Monitoring Service atom feed is empty
    And   the override date is '21/04/2017'

    # Clear down subnominals from PaaS
    And   there is no Subnominal data for the following FSPs
    | FSP           |
    | LEVY1799      |
    | NONLEVY2019   |

	# Set RoATP data (needed for amendment checks)
	And   the following providers exist on RoATP
	| Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
	| 10017546 | 10017546 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    



    # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017546'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017546 Co Ltd' with UKPRN '10017546' and OrgId 'ORG0017546' and has 'FCS1 Test' as a manager
    And   UPIN '117546' is associated with UKPRN '10017546' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017546 | 117546 | 10017546 Co Ltd | 0              | Active |



    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
   #And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation
    | Id     | Event     | CreatedOn                | ProviderId | ContractType      |
    | 417546 | INITIATED | 2017-02-16T09:31:29.1317 | 10017546   | ProviderAgreement |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017546'
	Then  there is only one Levy contract in CRM for UKPRN '10017546' with a status of 'Draft' 

    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 

    # Retrieve parameters from CRM  
   #When  I retrieve the latest EFA contract details from CRM for provider '10017546' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017546' 
    And   I retrieve the latest contract details from CRM for provider '10017546' for FundingType 'LEVY' and period '1799' 




    # Check contract creation
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017546 | 10017546 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017546 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017546 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
    | 10017546 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |


    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                  | 
    | 10017546 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships        | 
    | 10017546 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships        | 
    | 10017546 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017546 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |




    # Change the date
    Given the override date is '04/05/2020'

	# Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017546 | [ContractNo]       | 1                     | 0                        | Approved         | Approved          | True          | True                | 04/05/2020        | ?               | ?             |
    | 10017546 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                 | False         | False               | 01/05/2017        | ?               | ?             |

    # There needs to be a slight delay between approval and consumption of actuals
    Then wait '20' seconds





	# Change the date
	Given the override date is '04/06/2020'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull DCFS PoI actuals for May 2020
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS37               | ORG0017546     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 417.41      |
    | APPS           | APPS37               | ORG0017546     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 421.21      |
    | APPS           | APPS37               | ORG0017546     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 546.55      |
    | APPS           | APPS37               | ORG0017546     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 0.00        |
    | APPS           | APPS37               | ORG0017546     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 267.05      |
    | APPS           | APPS37               | ORG0017546     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1168.10     |
    | APPS           | APPS37               | ORG0017546     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 228.41      |
    | APPS           | APPS37               | ORG0017546     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 0.00        |
    | APPS           | APPS37               | ORG0017546     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 260.74      |
    | APPS           | APPS37               | ORG0017546     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 0.00        |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table
    Then  the PaymentSchedule.DeliverablePayment table contains the following values
    | AllocationNumber | VersionNumber | DeliverableCode | Period   | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | [AllocRef_LEVY]  | 1             | 2               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 417.41                      | 417.41           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 3               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 421.21                      | 421.21           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 4               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 546.55                      | 546.55           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 5               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 6               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 267.05                      | 267.05           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 8               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1168.10                     | 1168.10          | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 9               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 228.41                      | 228.41           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 10              | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 11              | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 260.74                      | 260.74           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 12              | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |

    # Check AllocationDelivery.AllocationDeliveryEntry (ADP) feed for relevant events. 
    #   Note: 0=NewApproval, 1=AmendmentApproval, 2=ActualsReceived (Not used for LEVY), 3=PaymentPosted
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events 
    | AllocationDeliveryEntryCategory   | ADCode | AllocationNumber | ContractVersionNumber |
    | NewContractAllocationApproved     | 0      | [AllocRef_LEVY]  | 1                     |
    | NewContractAllocationApproved     | 0      | [AllocRef_NLA]   | 1                     |

    # Clear down RoATP data
    Given there is no data on RoATP for the following providers
    | Ukprn    |
    | 10017546 |

    # Issue a contract amendment request on v1 to create v2 using the singleton mechanism
   #When  a request is issued to amend the following Levy contract via Bulk
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017546 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Approved  | Variation     | No                       | Yes                          |

    Then  the latest version of the contract has the following settings 
    | Status   | SubStatus             | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft    | Published to Provider | Yes           | No                  | 2                     |

    # Check the RoATP Anomalies report for an entry for this contract (after attempting to amend the contract)
    And   the RoATP Anomalies report includes the following
    | Contract     | MasterContract     | Ukprn    | Version  | SubVersion  | Status           | Substatus              |
    | [ContractNo] | [MasterContractNo] | 10017546 | 2        | 0           | Draft            | Published to Provider  |




	# Change the date
    Given the override date is '04/07/2020'

	# Pull DCFS PoI actuals for June 2017
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS38               | ORG0017546     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 227.41      |
    | APPS           | APPS38               | ORG0017546     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 617.08      |
    | APPS           | APPS38               | ORG0017546     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 419.33      |
    | APPS           | APPS38               | ORG0017546     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 2.00        |
    | APPS           | APPS38               | ORG0017546     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 168.44      |
    | APPS           | APPS38               | ORG0017546     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 299.93      |
    | APPS           | APPS38               | ORG0017546     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 248.66      |
    | APPS           | APPS38               | ORG0017546     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 0.60        |
    | APPS           | APPS38               | ORG0017546     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 142.88      |
    | APPS           | APPS38               | ORG0017546     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 11.24       |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

	And   the Net Payments for a given version number are calculated as follows
    | ContractNumber   | AllocationRef   | VersionNumber | DeliverableCode | Jun-20   | 
    | [ContractNo]     | [AllocRef_LEVY] | 1             | 2               | 227.41   | 
    | [ContractNo]     | [AllocRef_LEVY] | 1             | 3               | 617.08   | 
    | [ContractNo]     | [AllocRef_LEVY] | 1             | 4               | 419.33   | 
    | [ContractNo]     | [AllocRef_LEVY] | 1             | 5               | 2.00     | 
    | [ContractNo]     | [AllocRef_LEVY] | 1             | 6               | 168.44   | 
    | [ContractNo]     | [AllocRef_LEVY] | 1             | 8               | 299.93   | 
    | [ContractNo]     | [AllocRef_LEVY] | 1             | 9               | 248.66   | 
    | [ContractNo]     | [AllocRef_LEVY] | 1             | 10              | 0.60     | 
    | [ContractNo]     | [AllocRef_LEVY] | 1             | 11              | 142.88   | 
    | [ContractNo]     | [AllocRef_LEVY] | 1             | 12              | 11.24    | 




    # Change the date
    Given the override date is '12/07/2020'
	
	# Month end is not running
	And   the PaaS MonthEndIsRunning indicator is set to 'False'

	# Approve the contract
	When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'
    
    Then  the latest version of the contract has the following settings 
    | Status   | SubStatus  | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Approved | Approved   | Yes           | Yes                 | 2                     |

    # There needs to be a slight delay between approval and consumption of actuals
    Then wait '20' seconds





    # Change the date
    Given the override date is '04/08/2020'

	# Pull DCFS PoI actuals for July 2020
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS39               | ORG0017546     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 425.01      |
    | APPS           | APPS39               | ORG0017546     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 188.32      |
    | APPS           | APPS39               | ORG0017546     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 674.23      |
    | APPS           | APPS39               | ORG0017546     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 35.01       |
    | APPS           | APPS39               | ORG0017546     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 115.43      |
    | APPS           | APPS39               | ORG0017546     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 404.51      |
    | APPS           | APPS39               | ORG0017546     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 857.67      |
    | APPS           | APPS39               | ORG0017546     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 100.06      |
    | APPS           | APPS39               | ORG0017546     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 353.28      |
    | APPS           | APPS39               | ORG0017546     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 207.11      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table
    Then  the PaymentSchedule.DeliverablePayment table contains the following values
    | AllocationNumber | VersionNumber | DeliverableCode | Period   | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | [AllocRef_LEVY]  | 1             | 2               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 417.41                      | 417.41           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 3               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 421.21                      | 421.21           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 4               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 546.55                      | 546.55           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 5               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 6               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 267.05                      | 267.05           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 8               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1168.10                     | 1168.10          | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 9               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 228.41                      | 228.41           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 10              | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 11              | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 260.74                      | 260.74           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 12              | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 2	             | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 417.41                      | 417.41           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 3               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 421.21                      | 421.21           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 4               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 546.55                      | 546.55           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 5               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 6               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 267.05                      | 267.05           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 8               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1168.10                     | 1168.10          | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 9               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 228.41                      | 228.41           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 10              | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 11              | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 260.74                      | 260.74           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 12              | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | 0.00        |
	#
	# The following PlannedValue and PlannedVolume nulls for 202006 are caused by inconsistencies in the storage of nulls and zeroes when processing approvals and actuals 
    | [AllocRef_LEVY]  | 2             | 2               | 202006   | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 227.41                      | 227.41           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 3               | 202006   | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 617.08                      | 617.08           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 4               | 202006   | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 419.33                      | 419.33           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 5               | 202006   | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 2.00                        | 2.00             | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 6               | 202006   | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 168.44                      | 168.44           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 8               | 202006   | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 299.93                      | 299.93           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 9               | 202006   | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 248.66                      | 248.66           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 10              | 202006   | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 0.60                        | 0.60             | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 11              | 202006   | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 142.88                      | 142.88           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 12              | 202006   | 2              | ?             | ?            | 0.00                 | 0.00                | 0.00                   | 11.24                       | 11.24            | ?            | 0.00        |
    #
	| [AllocRef_LEVY]  | 2             | 2               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 425.01                      | 425.01           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 3               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 188.32                      | 188.32           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 4               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 674.23                      | 674.23           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 5               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 35.01                       | 35.01            | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 6               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 115.43                      | 115.43           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 8               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 404.51                      | 404.51           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 9               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 857.67                      | 857.67           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 10              | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 100.06                      | 100.06           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 11              | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 353.28                      | 353.28           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 12              | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 207.11                      | 207.11           | ?            | 0.00        |





    # Check the RoATP Anomalies report for an entry for this contract 
    And   the RoATP Anomalies report includes the following
    | Contract     | MasterContract     | Ukprn    | Version  | SubVersion  | Status           | Substatus              |
    | [ContractNo] | [MasterContractNo] | 10017546 | 2        | 0           | Approved         | Approved               |



    # Display parameters
    And   message 'AllocRef_LEVY = [AllocRef_LEVY]' is written to the Output window    
    And   message 'AllocRef_NLA  = [AllocRef_NLA]' is written to the Output window    
    
    
    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check that certain ActualsUpdated rows are absent from the AllocationDelivery.AllocationDeliveryEntry table
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '2' event for version '2' of contract number '[ContractNo]' and allocation number '[AllocRef_LEVY]'
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '3' event for version '2' of contract number '[ContractNo]' and allocation number '[AllocRef_LEVY]'
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '4' event for version '2' of contract number '[ContractNo]' and allocation number '[AllocRef_LEVY]'
    #
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '2' event for version '2' of contract number '[ContractNo]' and allocation number '[AllocRef_NLA]'
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '3' event for version '2' of contract number '[ContractNo]' and allocation number '[AllocRef_NLA]'
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '4' event for version '2' of contract number '[ContractNo]' and allocation number '[AllocRef_NLA]'

    # Check that the relevant events are on the ADP feed
    Then  the ADP feed includes the following values
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | ContractVersionNumber | SubVersionNumber | AllocationNumber | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    | NewContractAllocationApproved     | 0      | [ContractNo]   | 1                     | 0                | [AllocRef_LEVY]  | ?                         | ?                            |
    | NewContractAllocationApproved     | 0      | [ContractNo]   | 1                     | 0                | [AllocRef_NLA]   | ?                         | ?                            |
    | AmendedContractAllocationApproved | 1      | [ContractNo]   | 2                     | 0                | [AllocRef_LEVY]  | ?                         | ?                            |
    | AmendedContractAllocationApproved | 1      | [ContractNo]   | 2                     | 0                | [AllocRef_NLA]   | ?                         | ?                            |

    # Check the ADP feed event header information
    And   the Allocation Delivery feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                        | CategoryLabel                        | Title                                                                                |
    | 10017546 | [ContractNo]   | 1               | 0                  | NewContractAllocationApproved       | New Contract Allocation Approved     | New Contract [ContractNo]: 1.0 with Allocation [AllocRef_LEVY] was Approved          |
    | 10017546 | [ContractNo]   | 1               | 0                  | NewContractAllocationApproved       | New Contract Allocation Approved     | New Contract [ContractNo]: 1.0 with Allocation [AllocRef_NLA] was Approved           |
    | 10017546 | [ContractNo]   | 2               | 0                  | AmendedContractAllocationApproved   | Amended Contract Allocation Approved | Amendment to Contract [ContractNo]: 2.0 with Allocation [AllocRef_LEVY] was Approved |
    | 10017546 | [ContractNo]   | 2               | 0                  | AmendedContractAllocationApproved   | Amended Contract Allocation Approved | Amendment to Contract [ContractNo]: 2.0 with Allocation [AllocRef_NLA] was Approved  |

    # Check financials on the ADP feed
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
    | AmendedContractAllocationApproved | [ContractNo]       | 2             | [AllocRef_LEVY]  | 1               | 202005 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | [ContractNo]       | 2             | [AllocRef_LEVY]  | 7               | 202005 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | AmendedContractAllocationApproved | [ContractNo]       | 2             | [AllocRef_NLA]   | 1               | 202005 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | AmendedContractAllocationApproved | [ContractNo]       | 2             | [AllocRef_NLA]   | 8               | 202005 | ?           | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |

    # Check Planned data on the ADP feed
    And   the Allocation Delivery Monitoring Service atom feed contains the following Planned data
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume |
    | AmendedContractAllocationApproved | [ContractNo]       | 2             | [AllocRef_LEVY]  | 1               | 202005 | 0.00         | 0             |
    | AmendedContractAllocationApproved | [ContractNo]       | 2             | [AllocRef_LEVY]  | 7               | 202005 | 0.00         | 0             |
    #
    | AmendedContractAllocationApproved | [ContractNo]       | 2             | [AllocRef_NLA]   | 1               | 202005 | 0.00         | 0             |
    | AmendedContractAllocationApproved | [ContractNo]       | 2             | [AllocRef_NLA]   | 8               | 202005 | 0.00         | 0             |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Complete 
@PublishNewLevyContract @PaymentScheduleTests @PaymentGenerationAndTransmission
Scenario: A547 Create a Levy contract. Withdraw and reissue. Approve. Consume actuals. Check PaaS and ADP feed
    Given there is no Contract, Task or Workflow data for UKPRN '10017547'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'NACRO' with UKPRN '10017547' and OrgId 'ORG0017547' and has 'FCS1 Test' as a manager
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017547'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017547'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no entries in the DCFS stub table
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017547'
    And   there are no DAS engagement events stored in FCS
    And   the Allocation Delivery Monitoring Service atom feed is empty
    And   the override date is '21/04/2017'

    # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017547'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017547 Co Ltd' with UKPRN '10017547' and OrgId 'ORG0017547' and has 'FCS1 Test' as a manager
    And   UPIN '117547' is associated with UKPRN '10017547' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017547 | 117547 | 10017547 Co Ltd | 0              | Active |

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id     | Event     | CreatedOn                | ProviderId | ContractType      |
    | 417547 | INITIATED | 2017-02-16T09:31:29.1317 | 10017547   | ProviderAgreement |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017547'
	Then  there is only one Levy contract in CRM for UKPRN '10017547' with a status of 'Draft' 

    # Retrieve parameters from CRM  
   #When  I retrieve the latest EFA contract details from CRM for provider '10017547' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017547' 
    When  I retrieve the latest contract details from CRM for provider '10017547' for FundingType 'LEVY' and period '1799' 




    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017547 | 10017547 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017547 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017547 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017547 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017547 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017547 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017547 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017547 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    ## Check deliverable period count prior to approval 
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 




    # Issue a contract withdrawal and reissue request to create v2
    When  a request is issued to withdraw and reissue the following draft Levy contract
    | UKPRN    | MasterContractNumber | ContractNumber | Version |
    | 10017547 | [MasterContractNo]   | [ContractNo]   | 1       |    

    Then  the latest version of the contract has the following settings 
    | Status   | SubStatus             | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft    | Published to Provider | Yes           | No                  | 2                     |
    



	# Change the date
	Given the override date is '01/05/2020'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    Then  the latest version of the contract has the following settings 
    | Status   | SubStatus | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Approved | Approved  | Yes           | Yes                 | 2                     |




    # Change the date 
	Given  the override date is '04/06/2020'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS
    
	# Pull DCFS PoI actuals for May 2020
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS37               | ORG0017547     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 337.41      |
    | APPS           | APPS37               | ORG0017547     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 477.21      |
    | APPS           | APPS37               | ORG0017547     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 546.95      |
    | APPS           | APPS37               | ORG0017547     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 21.98       |
    | APPS           | APPS37               | ORG0017547     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 456.15      |
    | APPS           | APPS37               | ORG0017547     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 309.23      |
    | APPS           | APPS37               | ORG0017547     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 903.45      |
    | APPS           | APPS37               | ORG0017547     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 1.25        |
    | APPS           | APPS37               | ORG0017547     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 400.50      |
    | APPS           | APPS37               | ORG0017547     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 212.30      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table
    Then  the PaymentSchedule.DeliverablePayment table contains the following values
    | AllocationNumber | VersionNumber | DeliverableCode | Period   | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | [AllocRef_LEVY]  | 2             | 2               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 337.41                      | 337.41           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 3               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 477.21                      | 477.21           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 4               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 546.95                      | 546.95           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 5               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 21.98                       | 21.98            | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 6               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 456.15                      | 456.15           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 8               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 309.23                      | 309.23           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 9               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 903.45                      | 903.45           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 10              | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1.25                        | 1.25             | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 11              | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 400.50                      | 400.50           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 2             | 12              | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 212.30                      | 212.30           | ?            | 0.00        |


    # Test Levy 'Actuals' in CM feed

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed


    # Check AllocationDelivery.AllocationDeliveryEntry (ADP) feed for relevant events. 
    #   Note: 0=NewApproval, 1=AmendmentApproval, 2=ActualsReceived (Not used for LEVY), 3=PaymentPosted
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events 
    | AllocationDeliveryEntryCategory   | ADCode | AllocationNumber | ContractVersionNumber |
    | AmendedContractAllocationApproved | 0      | [AllocRef]       | 2                     |


	# Tidy up
    Then  the override date is reset

@AcceptanceTest @Complete
@PublishNewLevyContract
Scenario: A244 Create and approve a Levy contract which is on RoATP. Change the Org status from 'Active' to 'Locked Restructure' then successfully amend the contract (bulk). Check CRM, docs and the RoATP report
    Given there is no Contract, Task or Workflow data for UKPRN '10017244'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017244'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017244'
   #And   there are no notifications of type 'Contract Closure Failed'
    And   there are no notifications in CRM of type 'Contract Closure Initiation Failed' for UKPRN '10017244'
    And   there are no notifications in CRM of type 'Contract Closure Failed' for UKPRN '10017244'
    And   there are no notifications in CRM of type 'Contract Closure Rejected' for UKPRN '10017244'
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017244'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017244'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS
   

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017244' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017244 Co Ltd' with UKPRN '10017244' and OrgId 'ORG0017244' and has 'FCS1 Test' as a manager 
 
    # Put data in the PaaS Organisation table (Organisation.Organisation) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017244 | 117244 | 10017244 Co Ltd | 0              | Locked Restructure    | Yes           | AA017244      | ?             | 71 London Road         | Sevenoaks              | Kent                   | ?                      | ?                      | ?                      | TN13 1AX  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017244 |


    # Set RoATP data (needed for amendment checks) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not.
    And   the following providers exist on RoATP
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
    | 10017244 | 10017244 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    

    # Change the date 
    And   the override date is '16/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 42864 | INITIATED | 2017-09-15T18:03:12.2539 | 10017244   | 28993             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017244'
    And   there is only one Levy contract in CRM for UKPRN '10017244' with a status of 'Draft'

    # Check the contract has been created ok
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017244 | 10017244 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017244 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017244 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
	| 10017244 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription              | 
    | 10017244 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships    | 
    | 10017244 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships    | 
	| 10017244 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017244 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |
    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

    And wait '5' seconds
    #And   the latest version of the contract has the following settings 
    #| Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    #| Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017244' for FundingType 'LEVY' and period '1799'

    ## Check deliverable period count prior to approval
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Change the date 
    Given the override date is '02/01/2021'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    ## Check deliverable period count after approval
    #Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # After approval there should be a Jan-21 deliverable period for each of deliverables 1 through 14 for each allocation
    Then   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Jan-21   | DeliverableDescription                               | 
    | 10017244 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017244 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017244 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017244 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017244 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017244 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017244 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017244 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017244 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017244 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017244 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017244 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017244 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017244 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017244 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017244 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017244 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017244 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017244 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017244 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017244 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017244 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017244 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017244 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017244 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017244 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017244 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017244 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017244 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 02/01/2021        | ?               | ?             |
    | 10017244 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017244 | [ContractNo]       | 1                     | [AllocRef]    | 02/01/2021          | ?                 |




	# Change the status of the provider in CRM from 'Active' to 'Locked Restructure' then amend the contract
	# Note: The status of the Org in CRM is not checked unless a bulk import file is being processed. As such, an
	#       Inactive status (eg Deleted) will be treated the same way as an Active status (eg Locked Restructure) 
	#       and the amendment will always succeed.

    # Change the date
    Given the override date is '16/03/2021'

	# Put data in the CRM Organisation table (J057)
    And   the following Organisations exist in CRM
    | OrgId      | UKPRN    | UPIN   | Name            | Status                | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | ORG0017244 | 10017244 | 117244 | 10017244 Co Ltd | Locked Restructure    | AA017244      | ?             | 71 London Road         | ?                      | ?                      | ?                      | Sevenoaks              | Kent                   | TN13 1AX  |



    # Issue a contract amendment request on v1 to create v2 using the bulk mechanism. This should succeed
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017244 | [MasterContractNo]   | [ContractNo]   | 2       | Approved | Approved  | Variation     | No                       | Yes                   | No                           |

    ## Check deliverable period count after successful amendment
    #Then  there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And wait '10' seconds
    #Then the latest version of the contract has the following settings 
    #| Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    #| Draft  | Published to Provider  | Yes           | No                  | 2                     |

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus     | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017244 | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider | True          | False               | 02/01/2021        | ?               | Variation     |
    | 10017244 | [ContractNo]       | 1                     | 0                        | Approved         | Approved              | False         | True                | 02/01/2021        | ?               | ?             |
    | 10017244 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                     | False         | False               | 01/05/2017        | ?               | ?             |

    # Check that there is nothing on the RoATP Anomalies report for the provider
    And   the RoATP Anomalies report does not contain a record for provider '10017244'

    And wait '10' seconds

    # Check Contract documentation [Amendment Letter but no Agreement] (16390)  
    And   the file named '10017244_[ContractNo]_v2.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
    """
    (C) The Department’s reference for this Variation is July 2026, Version 4.6
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by Andrew Thomas, Director of Funding and Financial Oversight
    Agreement number: [MasterContractNo]
    """

    # The Terms and Conditions (Agreement) document has not been added (ShouldMergeAmendmentTemplate=No) (29104)
    And   the pdf file does not contain the following text
    """
    Terms and Conditions
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017244_[ContractNo]_v2.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A244v2.pdf'

    # Approve the amended contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2' 

    # Check CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus     | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017244 | [ContractNo]       | 2                     | 0                        | Approved         | Approved              | True          | True                | 02/01/2021        | ?               | Variation     |
    | 10017244 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved              | False         | False               | 02/01/2021        | ?               | ?             |
    | 10017244 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                     | False         | False               | 01/05/2017        | ?               | ?             |



	# Tidy up
    And   the override date is reset

@AcceptanceTest @Complete 
@PublishNewLevyContract
Scenario: A245 Create and approve a Levy contract which is on RoATP. Remove provider from RoATP then attempt to (bulk) amend the contract (Notification and No). Check CRM and RoATP report
    Given there is no Contract, Task or Workflow data for UKPRN '10017245'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017245'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017245'
   #And   there are no notifications of type 'Contract Closure Failed'
    And   there are no notifications in CRM of type 'Contract Closure Initiation Failed' for UKPRN '10017245'
    And   there are no notifications in CRM of type 'Contract Closure Failed' for UKPRN '10017245'
    And   there are no notifications in CRM of type 'Contract Closure Rejected' for UKPRN '10017245'
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017245'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017245'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS
   
   # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017245'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017245 Co Ltd' with UKPRN '10017245' and OrgId 'ORG0017245' and has 'FCS1 Test' as a manager
    And   UPIN '117245' is associated with UKPRN '10017245' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017245 | 117245 | 10017245 Co Ltd | 0              | Active |

    # Set RoATP data (needed for amendment checks) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not.
    And   the following providers exist on RoATP
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
    | 10017245 | 10017245 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    

    # Change the date 
    And   the override date is '16/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 47264 | INITIATED | 2017-09-15T18:03:12.2539 | 10017245   | 72893             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017245'
    And   there is only one Levy contract in CRM for UKPRN '10017245' with a status of 'Draft'

    # Check the contract has been created ok
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017245 | 10017245 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017245 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017245 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
	| 10017245 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription				     | 
    | 10017245 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships	     | 
    | 10017245 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships		 | 
	| 10017245 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017245 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |
    
	And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Retrieve MasterContract, Contract and Allocation numbers for this contract
    And   '[MasterContractNo]' is the MasterContractNumber of the latest Levy contract held by UKPRN '10017245'
    And   '[ContractNo]' is the ContractNumber of the latest Levy contract held by UKPRN '10017245'
    And   '[AllocRef]' is the ContractAllocationNumber of the latest Levy contract held by UKPRN '10017245'

    ## Check deliverable period count prior to approval
    #And   there are '6' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'



    # Change the date 
    Given the override date is '02/03/2021'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    ## Check deliverable period count after approval
    #Then  there are '34' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # After approval there should be a Mar-21 deliverable period for each of deliverables 1 through 14 for each allocation
    Then   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | Mar-21   | DeliverableDescription                               | 
    | 10017245 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017245 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017245 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017245 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017245 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017245 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017245 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017245 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017245 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017245 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017245 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017245 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017245 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017245 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017245 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017245 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017245 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017245 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017245 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017245 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017245 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017245 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017245 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017245 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017245 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017245 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017245 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017245 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017245 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 02/03/2021        | ?               | ?             |
    | 10017245 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017245 | [ContractNo]       | 1                     | [AllocRef]    | 02/03/2021          | ?                 |

    # Change the date
    And   the override date is '21/04/2021'

    # Clear down RoATP data
	Given there is no data on RoATP for the following providers
	| Ukprn    |
	| 10017245 |

    # Issue a contract amendment request on v1 to create v2 using the bulk mechanism. This should fail because the provider is only a Supporting provider on RoATP
    When  a request is issued to amend the following Levy contract via Bulk
	| UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017245 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Approved  | Notification  | No                       | Yes                   | Yes                          |

    ## Check deliverable period count after failed amendment. There should still be 12 rows on the latest version of the contract (v1)
    #Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check CONTRACT version, status and dates in CRM have not changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus     | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017245 | [ContractNo]       | 1                     | 0                        | Approved         | Approved              | True          | True                | 02/03/2021        | ?               | ?             |
    | 10017245 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                     | False         | False               | 01/05/2017        | ?               | ?             |

    # Check the RoATP Anomalies report for an entry for this contract 
    And   the RoATP Anomalies report includes the following
    | Contract     | MasterContract     | Ukprn    | Version  | SubVersion  | Status           | Substatus              |
    | [ContractNo] | [MasterContractNo] | 10017245 | 1        | 0           | Approved         | Approved               |	

	# Tidy up
    And   the override date is reset

@AcceptanceTest @Complete
@PublishNewLevyContract
Scenario: A246 Create and approve a Levy contract which is on RoATP. Check docs. Amend v1 (bulk, Variation and No) and publish v2. Check docs. Attempt amendment of v2 (singleton, Variation and No) which should withdraw v2 and create a draft amendment v3. Check CRM and RoATP report(x2)
    Given there is no Contract, Task or Workflow data for UKPRN '10017246'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017246'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017246'
   #And   there are no notifications of type 'Contract Closure Failed'
    And   there are no notifications in CRM of type 'Contract Closure Initiation Failed' for UKPRN '10017246'
    And   there are no notifications in CRM of type 'Contract Closure Failed' for UKPRN '10017246'
    And   there are no notifications in CRM of type 'Contract Closure Rejected' for UKPRN '10017246'
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017246'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017246'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS
   
   # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017246'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017246 Co Ltd' with UKPRN '10017246' and OrgId 'ORG0017246' and has 'FCS1 Test' as a manager
    And   UPIN '117246' is associated with UKPRN '10017246' in the CRM Organisation table

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status     | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017246 | 117246 | 10017246 Co Ltd | 0              | Active     | Yes           | AA017246      | ?             | 301 Histon Road        | Cambridge              | ?                      | ?                      | ?                      | ?                      | CB4 3NF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017246 |   
   
   # Set RoATP data (needed for amendment checks) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not.
    And   the following providers exist on RoATP
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
    | 10017246 | 10017246 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    




    # Change the date 
    Given the override date is '16/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 36194 | INITIATED | 2017-09-15T18:03:12.2539 | 10017246   | 82253             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017246'
    And   there is only one Levy contract in CRM for UKPRN '10017246' with a status of 'Draft'

    # Check the contract has been created ok
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017246 | 10017246 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017246 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017246 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
	| 10017246 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription              | 
    | 10017246 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships    | 
    | 10017246 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships    |
	| 10017246 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017246 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

	# Retrieve parameters
	And   I retrieve the latest contract details from CRM for provider '10017246' for FundingType 'LEVY' and period '1799'

#    # Check the contract docs for v1 (Agreement Ts&Cs but no preceding letter)
#    And   the file named '10017246_[ContractNo]_v1.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
#    """
#    THIS AGREEMENT is made on the date the Agreement is digitally signed by the Training
#    Provider through the Manage Your Education and Skills Funding Service having
#    already been signed by the Department and is between:
#    10017246 Co Ltd THE SECRETARY OF STATE FOR
#    301 Histon Road EDUCATION
#    Cambridge DEPARTMENT FOR
#    CB4 3NF EDUCATION
#    AND
#    20 GREAT SMITH STREET
#    LONDON
#    Company No: AA017246 SW1P 3BT
#    UKPRN: 10017246
#    Referred to in this Agreement as “the Referred to in this Agreement as “the
#    Training Provider” Department”
#    “Expiry Date” means 31 July 2026 or such later date as is notified in writing by
#    Department for Education Apprenticeships-Provider Agreement, April 2025, Version 4.4
#    Department for Education
#    Department for Education - GOV.UK
#    63
#    """
#
#
#    # The Amendment Letter does not precede the Agreement\Ts&Cs (ShouldMergeAmendmentTemplate=No) (29104)
#    And   the pdf file does not contain the following text
#    """
#    Agreement number: [MasterContractNo] 
#    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017246_[ContractNo]_v1.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A246v1.pdf'

    ## Check deliverable period count prior to approval
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'





    # Change the date 
    Given the override date is '15/03/2021'

    # Approve v1 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    ## Check deliverable period count after approval
    #Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # After approval there should be a May-21 deliverable period for each of deliverables 1 through 14 for each allocation
    Then   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-21   | DeliverableDescription                               | 
    | 10017246 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017246 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017246 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017246 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017246 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017246 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017246 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017246 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017246 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017246 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017246 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017246 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017246 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017246 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017246 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017246 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017246 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017246 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017246 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017246 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017246 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017246 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017246 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017246 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017246 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017246 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017246 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017246 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017246 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 15/03/2021        | ?               | ?             |
    | 10017246 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |

    # Check ALLOCATION dates in CRM
    And   the following allocation values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | AllocationRef | AllocationStartDate | AllocationEndDate |
    | 10017246 | [ContractNo]       | 1                     | [AllocRef]    | 15/03/2021          | ?                 |




    # Change the date
    Given the override date is '21/04/2021'

	# Clear down contract docs
	And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017246'

    # Issue a contract amendment request against v1 to create v2 using the BULK mechanism. This should succeed
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination | ShouldMergeAmendmentTemplate |
    | 10017246 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Approved  | Variation     | No                       | Yes                   | Yes                          |
	
	## Check deliverable period count after contract amendment
 #   Then  there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    Then  the latest version of the contract has the following settings 
    | Status | SubStatus             | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider | Yes           | No                  | 2                     |

    # Check CONTRACT version, status and dates in CRM have not changed
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus     | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017246 | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider | True          | False               | 15/03/2021        | ?               | Variation     |
    | 10017246 | [ContractNo]       | 1                     | 0                        | Approved         | Approved              | False         | True                | 15/03/2021        | ?               | ?             |
    | 10017246 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                     | False         | False               | 01/05/2017        | ?               | ?             |

	# Retrieve parameters
	And   I retrieve the latest contract details from CRM for provider '10017246' for FundingType 'LEVY' and period '1799'

#    # Check the contract docs for v2 (Bulk, Variation, No) Amendment letter plus Agreement\Ts&Cs
#    And   the file named '10017246_[ContractNo]_v2.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order
#    """
#    THIS VARIATION is made on the date the Variation is digitally signed by the Training
#    Provider on the “Manage your education and skills funding service” (“the Variation
#    Date”).
#    BETWEEN: -
#    (1) THE SECRETARY OF STATE FOR EDUCATION DEPARTMENT FOR
#    EDUCATION 20 Great Smith Street London SW1P 3BT (“the Department”);
#    and
#    (2) 10017246 Co Ltd Company No: AA017246 (10017246) whose registered office
#    is situated at 301 Histon Road, Cambridge, CB4 3NF (“the Training
#    Provider”).
#    RECITALS: -
#    (A) The Department and the Training Provider entered into an Apprenticeship
#    Agreement for the provision of Apprenticeship Training with the Department’s
#    reference number of [MasterContractNo] ("Original Agreement").
#    (B) The Department and the Training Provider have agreed to vary the terms of the
#    Original Agreement as set out in this Variation.
#    (C) The Department’s reference for this Variation is October 2024, Version 4.4.
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    Agreement number: [MasterContractNo]
#
#    Terms and Conditions
#    THIS AGREEMENT is made on the date the Agreement is digitally signed by the Training
#    Provider through the Manage Your Education and Skills Funding Service having
#    already been signed by the Department and is between:
#    10017246 Co Ltd THE SECRETARY OF STATE FOR
#    301 Histon Road EDUCATION
#    Cambridge DEPARTMENT FOR
#    CB4 3NF EDUCATION
#    AND
#    20 GREAT SMITH STREET
#    LONDON
#    Company No: AA017246 SW1P 3BT
#    UKPRN: 10017246
#    Referred to in this Agreement as “the Referred to in this Agreement as “the
#    Training Provider” Department”
#    Department for Education Apprenticeships-Provider Agreement, April 2025, Version 4.4
#    Department for Education
#    Department for Education - GOV.UK
#    63
#    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017246_[ContractNo]_v2.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A246v2.pdf'

    # Check that there is nothing on the RoATP Anomalies report for the provider
    And   the RoATP Anomalies report does not contain a record for provider '10017246'
	


	# Change the date
    Given the override date is '22/04/2021'

	# Clear down contract docs
	And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017246'

    # Issue a contract amendment request on v2 to create v3 using the SINGLE mechanism. 
	#  This should withdraw v2 and issue v3 because the provider is still on RoATP
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status | SubStatus             | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017246 | [MasterContractNo]   | [ContractNo]   | 2       | Draft  | Published to Provider | Variation     | No                       | No                           |

    ## Check deliverable period count after contract amendment
    #Then  there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    Then the latest version of the contract has the following settings 
    | Status | SubStatus             | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider | Yes           | No                  | 3                     |

    # Check CONTRACT version, status and dates in CRM have not changed
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus     | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017246 | [ContractNo]       | 3                     | 0                        | Draft            | Published to Provider | True          | False               | 15/03/2021        | ?               | Variation     |
    | 10017246 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Agency   | False         | False               | 15/03/2021        | ?               | Variation     |
    | 10017246 | [ContractNo]       | 1                     | 0                        | Approved         | Approved              | False         | True                | 15/03/2021        | ?               | ?             |
    | 10017246 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                     | False         | False               | 01/05/2017        | ?               | ?             |

	# Retrieve parameters
	And   I retrieve the latest contract details from CRM for provider '10017246' for FundingType 'LEVY' and period '1799'

#    # Check the contract docs for v3 (Single, Variation, No) Amendment letter without Agreement\Ts&Cs
#    And   the file named '10017246_[ContractNo]_v3.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order
#    """
#    THIS VARIATION is made on the date the Variation is digitally signed by the Training
#    Provider on the “Manage your education and skills funding service” (“the Variation
#    Date”).
#    BETWEEN: -
#    (1) THE SECRETARY OF STATE FOR EDUCATION DEPARTMENT FOR
#    EDUCATION 20 Great Smith Street London SW1P 3BT (“the Department”);
#    and
#    (2) 10017246 Co Ltd Company No: AA017246 (10017246) whose registered office
#    is situated at 301 Histon Road, Cambridge, CB4 3NF (“the Training
#    Provider”).
#    RECITALS: -
#    (A) The Department and the Training Provider entered into an Apprenticeship
#    Agreement for the provision of Apprenticeship Training with the Department’s
#    reference number of [MasterContractNo] ("Original Agreement").
#    (B) The Department and the Training Provider have agreed to vary the terms of the
#    Original Agreement as set out in this Variation.
#    (C) The Department’s reference for this Variation is October 2024, Version 4.4.
#    SIGNED FOR AND ON BEHALF OF
#    THE SECRETARY OF STATE FOR EDUCATION
#    by David Withey, Chief Executive of the Education and Skills Funding Agency
#    Agreement number: [MasterContractNo]
#    """
#
#
#    # The Terms and Conditions document has not been added (ShouldMergeAmendmentTemplate=No) (29104)
#    And   the pdf file does not contain the following text
#    """
#    Terms and Conditions
#    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017246_[ContractNo]_v3.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A246v3.pdf'


    # Check that there is nothing on the RoATP Anomalies report for the provider
    And   the RoATP Anomalies report does not contain a record for provider '10017246'
	

	# Tidy up
    And   the override date is reset
  
@AcceptanceTest @Complete
@PublishNewLevyContract
Scenario: A247 Create a Levy contract for a provider on RoATP but do not approve. Attempt amendment of v1 (singleton) which should withdraw v1 and create a draft new v2. Check CRM, docs and RoATP report
    Given there is no Contract, Task or Workflow data for UKPRN '10017247'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017247'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017247'
   #And   there are no notifications of type 'Contract Closure Failed'
    And   there are no notifications in CRM of type 'Contract Closure Initiation Failed' for UKPRN '10017247'
    And   there are no notifications in CRM of type 'Contract Closure Failed' for UKPRN '10017247'
    And   there are no notifications in CRM of type 'Contract Closure Rejected' for UKPRN '10017247'
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017247'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017247'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS
   
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017247' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017247 Co Ltd' with UKPRN '10017247' and OrgId 'ORG0017247' and has 'FCS1 Test' as a manager 
 
    # Put data in the PaaS Organisation table (Organisation.Organisation) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017247 | 117247 | 10017247 Co Ltd | 0              | Provider Under Change | Yes           | AA017247      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017247 |



    # Set RoATP data (needed for amendment checks) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not.
    And   the following providers exist on RoATP
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
    | 10017247 | 10017247 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    

    # Change the date 
    And   the override date is '16/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 47264 | INITIATED | 2017-09-15T18:03:12.2539 | 10017247   | 72893             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017247'
    And   there is only one Levy contract in CRM for UKPRN '10017247' with a status of 'Draft'

    # Check the contract has been created ok
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017247 | 10017247 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017247 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017247 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |
	| 10017247 | NONLEVY           | NONLEVY2019             | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription              | 
    | 10017247 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships    | 
    | 10017247 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships    |
	| 10017247 | NONLEVY           | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships    | 
    | 10017247 | NONLEVY           | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships    |

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    # Retrieve MasterContract, Contract and Allocation numbers for this contract
    And   '[MasterContractNo]' is the MasterContractNumber of the latest Levy contract held by UKPRN '10017247'
    And   '[ContractNo]' is the ContractNumber of the latest Levy contract held by UKPRN '10017247'
    And   '[AllocRef]' is the ContractAllocationNumber of the latest Levy contract held by UKPRN '10017247'

    ## Check deliverable period count prior to approval
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus     | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017247 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider | True          | False               | 01/05/2017        | ?               | ?             |
    | 10017247 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                     | False         | False               | 01/05/2017        | ?               | ?             |




    # Change the date 
    Given the override date is '02/03/2018'

    # Issue a contract amendment request against v1 to create v2 using the singleton 
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status | SubStatus             | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017247 | [MasterContractNo]   | [ContractNo]   | 1       | Draft  | Published to Provider | Variation     | No                       | Yes                          |

    ## Check deliverable period count after failed amendment. There should still be 2 rows on the latest version of the contract
    #Then  there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    Then   the latest version of the contract has the following settings 
    | Status  | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft   | Published to Provider  | Yes           | No                  | 2                     |

    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus     | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017247 | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider | True          | False               | 01/05/2017        | ?               | Variation     |
    | 10017247 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Agency   | False         | False               | 01/05/2017        | ?               | ?             |
    | 10017247 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                     | False         | False               | 01/05/2017        | ?               | ?             |

    # Check that there is nothing on the RoATP Anomalies report for the provider
    And   the RoATP Anomalies report does not contain a record for provider '10017247'
	   

    # Check Contract documentation (16390)  Variation letter and Agreement(Ts&Cs)
    And   the file named '10017247_[ContractNo]_v2.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
    """
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by Andrew Thomas, Director of Funding and Financial Oversight
    Agreement number: [MasterContractNo]
    Department for Education Apprenticeships-Provider Agreement, July 2026, Version 4.6
    Department for Education
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017247_[ContractNo]_v2.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as 'A247v2.pdf'

	# Tidy up
    And   the override date is reset

@AcceptanceTest @Complete
@PublishNewLevyContract
Scenario: A248 Create a Levy contract for a provider on RoATP but do not approve. Remove provider from RoATP. Attempt (singleton) amendment of v1 which should withdraw v1 and create a v2. Check CRM, docs and RoATP report(2x)
    Given there is no Contract, Task or Workflow data for UKPRN '10017248'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017248'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017248'
   #And   there are no notifications of type 'Contract Closure Failed'
    And   there are no notifications in CRM of type 'Contract Closure Initiation Failed' for UKPRN '10017248'
    And   there are no notifications in CRM of type 'Contract Closure Failed' for UKPRN '10017248'
    And   there are no notifications in CRM of type 'Contract Closure Rejected' for UKPRN '10017248'
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017248'
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017248'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS
   

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017248' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017248 Co Ltd' with UKPRN '10017248' and OrgId 'ORG0017248' and has 'FCS1 Test' as a manager 
 
    # Put data in the PaaS Organisation table (Organisation.Organisation) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017248 | 117248 | 10017248 Co Ltd | 0              | Locked Restructure    | Yes           | AA017248      | ?             | 7 Amersham Hill        | ?                      | ?                      | ?                      | High Wycombe           | Buckinghamshire        | HP13 6NS  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017248 |


    # Set RoATP data (needed for amendment checks) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not.
    And   the following providers exist on RoATP
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
    | 10017248 | 10017248 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    




    # Change the date 
    Given the override date is '16/09/2017'

    # Inject data into the stub
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId |
    | 47264 | INITIATED | 2017-09-15T18:03:12.2539 | 10017248   | 72893             |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017248'
    And   there is only one Levy contract in CRM for UKPRN '10017248' with a status of 'Draft'

    # Retrieve parameters from CRM  
   #When  I retrieve the latest EFA contract details from CRM for provider '10017248' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017248' 
    And   I retrieve the latest contract details from CRM for provider '10017248' for FundingType 'LEVY' and period '1799' 




    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017248 | 10017248 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017248 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017248 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017248 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017248 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017248 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017248 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017248 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract
	Then  there is only one Levy contract in CRM for UKPRN '10017248' with a status of 'Draft' 

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |

    ## Check deliverable period count prior to approval
    #And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus     | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017248 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider | True          | False               | 01/05/2017        | ?               | ?             |
    | 10017248 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                     | False         | False               | 01/05/2017        | ?               | ?             |




    # Change the date 
    Given the override date is '16/03/2018'

    # Clear down RoATP data
	Given there is no data on RoATP for the following providers
	| Ukprn    |
	| 10017248 |

	# Check the RoATP Anomalies report for an entry for this contract (before attempting to amend the contract)
    Then  the RoATP Anomalies report includes the following
    | Contract     | MasterContract     | Ukprn    | Version  | SubVersion  | Status           | Substatus              |
    | [ContractNo] | [MasterContractNo] | 10017248 | 1        | 0           | Draft            | Published to Provider  |

	# Issue a contract amendment request against v1 using the singleton mechanism. This should withdraw v1 and issue v2 irrespective of the state of RoATP.
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status           | SubStatus              | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017248 | [MasterContractNo]   | [ContractNo]   | 1       | Draft            | Published to Provider  | Variation     | No                       | No                           |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017248 | [ContractNo]       | 2                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/05/2017        | ?               | Variation     |
    | 10017248 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Agency       | False         | False               | 01/05/2017        | ?               | ?             |
    | 10017248 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

	# Check the RoATP Anomalies report for an entry for this contract (after attempting to amend the contract)
    And   the RoATP Anomalies report includes the following
    | Contract     | MasterContract     | Ukprn    | Version  | SubVersion  | Status           | Substatus              |
    | [ContractNo] | [MasterContractNo] | 10017248 | 2        | 0           | Draft            | Published to Provider  |

    # Check the contract docs for v2 (Single, Variation, No)
    And   the file named '10017248_[ContractNo]_v2.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order
    """
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by Andrew Thomas, Director of Funding and Financial Oversight
    Agreement number: [MasterContractNo]
    """




    # The Terms and Conditions document has not been added (ShouldMergeAmendmentTemplate=No) (29104)
    And   the pdf file does not contain the following text
    """
    Terms and Conditions
    """


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20210512
Scenario: A289 Create and publish a Levy1799 contract. Don't approve. Trigger a Notification amendment (without adding the Non-Levy alloc). Amendment should not update contract
    Given there are no allocations marked as Under Termination for UKPRN '10017289' 
    And   there are no terminated or closed allocations for UKPRN '10017289' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017289' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017289' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017289' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017289' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017289' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table 
    And   there are no DAS engagement events stored in FCS 




    # Remove the provider from RoATP (ContractManagement.RoATPProvider)
    And   there is no data on RoATP for the following providers
    | Ukprn    |
    | 10017289 |

    # Add the provider to RoATP (ContractManagement.RoATPProvider)
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017289 | 10017289 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017289' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017289 Co Ltd' with UKPRN '10017289' and OrgId 'ORG0017289' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017289' 
 
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017289 | 117289 | 10017289 Co Ltd | 0              | Active                | Yes           | AA017289      | ?             | 2a King Edward St      | ?                      | ?                      | ?                      | Macclesfield           | Cheshire               | SK10 1AA  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017289 |

 

 
    # Change the date 
    Given the override date is '16/09/2017' 
 
    # Inject data into the stub 
    And   the following Levy event data is available in the DAS agreement stub 
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 42289 | INITIATED | 2017-09-15T18:03:12.2289 | 10017289   | 28289             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017289' 
    Then  there is only one Levy contract in CRM for UKPRN '10017289' with a status of 'Draft' 
 
    # Retrieve parameters from CRM 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017289' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017289' 
    When  I retrieve the latest contract details from CRM for provider '10017289' for FundingType 'LEVY' and period '1799' 
 
    # Check that the Contract Allocation has been created correctly in CRM
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType       |
    | 10017289 | [ContractNo]       | [AllocRef_LEVY]       | ?                             | 0.00            | ?             | ?                | 01/05/2017 | ?          | LEVY          | LEVY1799            | Contract Allocation |

    # Check that the Contract Deliverables have been created correctly in CRM
    Then  the following Contract Deliverables exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | DeliverableCode | DisplayOrder | ParentDeliverableCode | ContractDeliverableName               | ContractDeliverableDescription       | PlannedValue | PlannedVolume | UnitCost |
    | 10017289 | [ContractNo]       | [AllocRef_LEVY]       | 1               | 1            | ?                     | Total 16-18 Levy Apprenticeships      | ?                                    | 0.00         | 0             | 0        |
    | 10017289 | [ContractNo]       | [AllocRef_LEVY]       | 7               | 8            | ?                     | Total 16-18 Levy Apprenticeships      | ?                                    | 0.00         | 0             | 0        |

    # Check that the Contract Deliverable Periods have been created correctly in CRM
    Then  the following Contract Deliverable Periods exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | DeliverableCode | Year | Month | PeriodType | Period  | PeriodName | PlannedValue | PlannedVolume | PaymentPosted |
    | 10017289 | [ContractNo]       | [AllocRef_LEVY]       | 1               | 2017 | 05    | CM         | May-17  | May-17     | 0.00         | 0             | No            |
    | 10017289 | [ContractNo]       | [AllocRef_LEVY]       | 7               | 2017 | 05    | CM         | May-17  | May-17     | 0.00         | 0             | No            |

 
    And   there are no open tasks for the contract 
    And   there is no contract owner assigned to the latest version of the contract 
 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 

    # Check CONTRACT version, status and dates in CRM 
    And   the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017289 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider  | True          | False               | 01/05/2017        | ?               | ?             | 
    | 10017289 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 




    # Attempt a Notification amendment. This shouldn't update the contract because it is in the wrong state to be updated.
	# Note: If this had been a variation amendment then v1 would have been withdrawn and v2 issued to replace it published but not approved)
	
	# Change the date
	Given the override date is '01/08/2019'

	# Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
	
	# Issue a contract amendment request on v1 to create v2, without adding a NONLEVY2019 allocation. (Singleton, Notification and No)
   #When  a request is issued to amend the following Levy contract via Bulk
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus             | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017289 | [MasterContractNo]   | [ContractNo]   | 1       | Draft    | Published to Provider | Notification  | No                       | Yes                          | 

	And   wait '20' seconds

    # Retrieve parameters from CRM 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017289' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017289' 
    When  I retrieve the latest contract details from CRM for provider '10017289' for FundingType 'LEVY' and period '1799' 

    # Check CONTRACT version, status and dates in CRM. These should not have changed 
    Then  the following contract values are present in CRM 
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType | 
    | 10017289 | [ContractNo]       | 1                     | 0                        | Draft            | Published to Provider  | True          | False               | 01/05/2017        | ?               | ?             | 
    | 10017289 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             | 



	# Tidy Up
	And   the override date is reset 
	  
       