Feature: MoreLevyAmendmentsAndPayments 20716

@AcceptanceTest @Complete 
@PublishNewLevyContract @PaymentScheduleTests @PaymentGenerationAndTransmission @ContractClosure
@HighValue
Scenario: A708 Create a Levy contract. Withdraw and reissue twice. Approve. Amend (singleton) and approve. Consume actuals. Check PaaS, ADP feed and RoATP anomalies report
    Given there is no Contract, Task or Workflow data for UKPRN '10017708'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'NACRO' with UKPRN '10017708' and OrgId 'ORG0017708' and has 'FCS1 Test' as a manager
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017708'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017708'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no entries in the DCFS stub table
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017708'
    And   there are no DAS engagement events stored in FCS
    And   the Allocation Delivery Monitoring Service atom feed is empty
    And   the override date is '21/04/2017'

    # Set organisation and advisors in CRM
    And   there is no Organisation data for UKPRN '10017708'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017708 Co Ltd' with UKPRN '10017708' and OrgId 'ORG0017708' and has 'FCS1 Test' as a manager
    And   UPIN '117708' is associated with UKPRN '10017708' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017708 | 117708 | 10017708 Co Ltd | 0              | Active |

	# Set RoATP data (needed for amendment checks)
	And   the following providers exist on RoATP
	| Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |
	| 10017708 | 10017708 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 |    

    # Inject data into the stub
   #And   the following Levy event data is available in the DAS agreement stub
    And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation
    | Id    | Event     | CreatedOn                | ProviderId | ContractType      |
    | 47708 | INITIATED | 2017-02-16T09:31:29.1317 | 10017708   | ProviderAgreement |

    When  the Levy event data is pulled from the DAS agreement stub
    Then  there is only one Levy contract in CRM for UKPRN '10017708' with a status of 'Draft' 

    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
   # And   the latest version of the contract has the following settings 
    #| Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    #| Draft  | Internally Approved    | Yes           | No                  | 1                     | 

    # Retrieve parameters from CRM 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017708' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017708' 
    When  I retrieve the latest contract details from CRM for provider '10017708' for FundingType 'LEVY' and period '1799' 
 
    # Publish the contract (This is needed because the injection step above leaves the contract in the wrong state)
    Given the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'




    # Check contract creation
    Then  the draft contract header details for the new Levy contract are as follows
    | UKPRN    | LegalName            | FundingType | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      |
    | 10017708 | 10017708 Co Ltd      | LEVY        | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017708 |

    And   the draft Levy contract allocations details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period |
    | 10017708 | LEVY              | LEVY1799                | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   |

    And   the draft Levy contract deliverables details for the new Levy contract are as follows
    | UKPRN    | FundingStreamCode | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription              | 
    | 10017708 | LEVY              | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships    | 
    | 10017708 | LEVY              | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships    | 

    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |



    # Issue a contract withdrawal request for v1 and a reissue request to create v2
    When  a request is issued to withdraw and reissue the following draft Levy contract
    | UKPRN    | MasterContractNumber | ContractNumber | Version |
    | 10017708 | [MasterContractNo]   | [ContractNo]   | 1       |    

    Then  the latest version of the contract has the following settings 
    | Status   | SubStatus             | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft    | Published to Provider | Yes           | No                  | 2                     |

    # Issue a contract withdrawal request for v2 and a reissue request to create v3
    When  a request is issued to withdraw and reissue the following draft Levy contract
    | UKPRN    | MasterContractNumber | ContractNumber | Version |
    | 10017708 | [MasterContractNo]   | [ContractNo]   | 2       |    

    Then  the latest version of the contract has the following settings 
    | Status   | SubStatus             | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft    | Published to Provider | Yes           | No                  | 3                     |
   



    # Change the date
    Given the override date is '01/05/2017'

	# Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '3'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017708 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                  | True          | True                | 01/05/2017        | ?               | Variation     |
    | 10017708 | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Agency       | False         | False               | 01/05/2017        | ?               | Variation     |
    | 10017708 | [ContractNo]       | 1                     | 0                        | Withdrawn        | Withdrawn By Agency       | False         | False               | 01/05/2017        | ?               | ?             |
    | 10017708 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |




    # Clear down RoATP data
    Given there is no data on RoATP for the following providers
    | Ukprn    |
    | 10017708 |

    # Issue a contract amendment request against v3 to create v4 using the singleton mechanism
   #When  a request is issued to amend the following Levy contract
   #When  a request is issued to amend the following Levy contract via Bulk
    When  a request is issued to amend the following Levy contract via Single
	| UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017708 | [MasterContractNo]   | [ContractNo]   | 3       | Approved | Approved  | Variation     | No                       | Yes                          |

    Then  the latest version of the contract has the following settings 
    | Status   | SubStatus             | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft    | Published to Provider | Yes           | No                  | 4                     |

    # Approve the contract
    And   the override date is '03/05/2017'
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '4'


    # Retrieve parameters from CRM 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017708' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017708' 
    When  I retrieve the latest contract details from CRM for provider '10017708' for FundingType 'LEVY' and period '1799' 

    Then  the latest version of the contract has the following settings 
    | Status   | SubStatus  | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Approved | Approved   | Yes           | Yes                 | 4                     |




    # Change the date
    Given  the override date is '04/06/2017'

	# Pull DCFS PoI actuals for May 2017
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS01               | ORG0017708     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 337.41      |
    | APPS           | APPS01               | ORG0017708     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 477.21      |
    | APPS           | APPS01               | ORG0017708     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 546.95      |
    | APPS           | APPS01               | ORG0017708     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 21.98       |
    | APPS           | APPS01               | ORG0017708     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 456.15      |
    | APPS           | APPS01               | ORG0017708     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 309.23      |
    | APPS           | APPS01               | ORG0017708     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 903.45      |
    | APPS           | APPS01               | ORG0017708     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 1.25        |
    | APPS           | APPS01               | ORG0017708     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 400.50      |
    | APPS           | APPS01               | ORG0017708     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 212.30      |

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table
    Then  the PaymentSchedule.DeliverablePayment table contains the following values
    | AllocationNumber | VersionNumber | DeliverableCode | Period   | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | [AllocRef_LEVY]  | 4             | 2               | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 337.41                      | 337.41           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 4             | 3               | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 477.21                      | 477.21           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 4             | 4               | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 546.95                      | 546.95           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 4             | 5               | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 21.98                       | 21.98            | ?            | 0.00        |
    | [AllocRef_LEVY]  | 4             | 6               | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 456.15                      | 456.15           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 4             | 8               | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 309.23                      | 309.23           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 4             | 9               | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 903.45                      | 903.45           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 4             | 10              | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1.25                        | 1.25             | ?            | 0.00        |
    | [AllocRef_LEVY]  | 4             | 11              | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 400.50                      | 400.50           | ?            | 0.00        |
    | [AllocRef_LEVY]  | 4             | 12              | 201705   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 212.30                      | 212.30           | ?            | 0.00        |

    # Check AllocationDelivery.AllocationDeliveryEntry (ADP) feed for relevant events. 
    #   Note: 0=NewApproval, 1=AmendmentApproval, 2=ActualsReceived (Not used for LEVY), 3=PaymentPosted
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events 
    | AllocationDeliveryEntryCategory   | ADCode | AllocationNumber | ContractVersionNumber |
    | AmendedContractAllocationApproved | 0      | [AllocRef_LEVY]  | 3                     |
    | AmendedContractAllocationApproved | 0      | [AllocRef_LEVY]  | 4                     |

    # Check the RoATP Anomalies report for an entry for this contract
    And   the RoATP Anomalies report includes the following
    | Contract     | MasterContract     | Ukprn    | Version  | SubVersion  | Status           | Substatus              |
    | [ContractNo] | [MasterContractNo] | 10017708 | 4        | 0           | Approved         | Approved               |
	

	# Tidy up
    Then  the override date is reset
  