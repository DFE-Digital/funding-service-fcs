Feature: LevyPaymentFileCreation

@AcceptanceTest @Withdrawn20200420
@PublishNewLevyContract @PaymentScheduleTests @PaymentGenerationAndTransmission
@HighValue 
Scenario: A105 Create and approve a Levy contract with one alloc. Consume actuals. Run payment batch. Check Payment feed, CRM, PaaS and ADP feed. Notification amendment to add NONLEVY2019 alloc. Check docs. Terminate (without amendment) and confirm. Consume and reject payment instructions post-termination. Check CRM and PaaS
    Given there are no allocations marked as Under Termination for UKPRN '10017105' 
    And   there are no terminated or closed allocations for UKPRN '10017105' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017105' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017105' 
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017105' 
   #And   there are no notifications of type 'Contract Amendment Failed' 
    And   there are no notifications in CRM of type 'Contract Amendment Failed' for UKPRN '10017105' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017105' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
    And   there is no Levy event data in the DAS agreement stub 
    And   there are no entries in the DCFS stub table 
    And   there are no DAS engagement events stored in FCS 
	And   the Allocation Delivery Monitoring Service atom feed is empty
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017105' 
 

    # Clear down all subnominal data from PaaS for an FSP 
    And   there is no Subnominal data in PaaS for the following FSPs 
    | FSP            | 
    | LEVY1799       | 
    | NONLEVY2019    | 
 
 


    # Remove the provider from RoATP (ContractManagement.RoATPProvider) 
    And   there is no data on RoATP for the following providers 
    | Ukprn    | 
    | 10017105 | 
 
    # Add the provider to RoATP (ContractManagement.RoATPProvider) 
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not.  
    And   the following providers exist on RoATP  
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  |  
    | 10017105 | 10017105 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 
 



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017105' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017105 Co Ltd' with UKPRN '10017105' and OrgId 'ORG0017105' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017105' 
 
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017105 | 117105 | 10017105 Co Ltd | 0              | Active                | Yes           | AA017105      | ?             | 57a Bridge Street Row  | Chester                | ?                      | ?                      | ?                      | ?                      | CH1 1NW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017105 |




    # Change the date 
    Given the override date is '01/05/2017' 
 
    # Inject data into the stub 
   #And   the following Levy event data is available in the DAS agreement stub 
	And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 42105 | INITIATED | 2017-05-01T18:03:12.2105 | 10017105   | 28105             | 
 
    When  the Levy event data is pulled from the DAS agreement stub 
    And   the Levy contract is created in CRM for UKPRN '10017105' 
    Then  there is only one Levy contract in CRM for UKPRN '10017105' with a status of 'Draft' 

    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Internally Approved    | Yes           | No                  | 1                     | 

    # Retrieve parameters from CRM 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017105' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017105' 
    When  I retrieve the latest contract details from CRM for provider '10017105' for FundingType 'LEVY' and period '1799' 
 
	# Publish the contract (This is needed because the injection step above leaves the contract in the wrong state)
    Given the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'




    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017105 | 10017105 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017105 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017105 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017105 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017105 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
 
    # Check deliverable period count prior to approval 
    And   there are '2' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 





	# Change the date
	Given the override date is '02/05/2017'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check the deliverable count in CRM
    Then  there are '14' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check version and status values in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017105 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 02/05/2017        | ?               | ?             |
    | 10017105 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |




    # Amend the contract to add a NONLEVY2019 allocation
	
	# Change the date
	Given the override date is '01/08/2019'

	# Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
	
	# Issue a contract amendment request on v1 to create v2, adding a NONLEVY2019 allocation. Singleton mechanism
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate |
    | 10017105 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Approved  | Notification  | Yes                      | Yes                          |

    # Check the CONTRACT version, status and dates in CRM.  Contract should have auto-approved
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017105 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 02/05/2017        | ?               | Notification  |
    | 10017105 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 02/05/2017        | ?               | ?             |
    | 10017105 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017105' for FundingType 'LEVY' and period '1799'

    # Check the contract docs for v2
    And   the file named '10017105_[ContractNo]_v2.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order
    """
    THIS AGREEMENT is made on the date the Agreement is digitally signed by the Training
    Provider on the Manage your education and skills funding service and shall be deemed to be
    effective from 9 January 2020 (“the effective date”).
    BETWEEN: -
    (1) THE SECRETARY OF STATE FOR EDUCATION acting through the Education and
    Skills Funding Agency an Executive Agency of the Department for Education of
    Cheylesmore House, Quinton Road, Coventry, CV1 2WT (“the ESFA"); and
    (2) 10017105 Co Ltd Company No: AA017105 (10017105) whose registered office is
    situated at 57a Bridge Street Row, Chester, CH1 1NW ("the Training Provider").
    RECITALS: -
    (A) The ESFA and the Training Provider entered into an Apprenticeship Agreement for the
    Provision of Levy-funded Apprenticeship Training with the ESFA’s reference number of
    ESFA-105 ("Original Agreement").
    (B) The ESFA and the Training Provider have agreed to vary the terms of the Original
    Agreement as set out in this Agreement.
    (C) The ESFA’s reference number for this Variation Agreement is template version 4.
   
    For use of the Apprenticeship Service to access funded apprenticeship training
    """


	# Change the date
	Given the override date is '07/06/2019'

    # Pull DCFS PoI actuals for May 2019
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS31               | ORG0017105     | CM             | 201905 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | -417.41     |
    | APPS           | APPS31               | ORG0017105     | CM             | 201905 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | -421.21     |
    | APPS           | APPS31               | ORG0017105     | CM             | 201905 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | -105.55     |
    | APPS           | APPS31               | ORG0017105     | CM             | 201905 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 0.00        |
    | APPS           | APPS31               | ORG0017105     | CM             | 201905 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | -267.05     |
    | APPS           | APPS31               | ORG0017105     | CM             | 201905 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1168.10     |
    | APPS           | APPS31               | ORG0017105     | CM             | 201905 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 228.41      |
    | APPS           | APPS31               | ORG0017105     | CM             | 201905 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 0.00        |
    | APPS           | APPS31               | ORG0017105     | CM             | 201905 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 260.74      |
    | APPS           | APPS31               | ORG0017105     | CM             | 201905 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 0.00        |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service




	# Change the date
    Given the override date is '07/06/2019 22:05'

	# Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014) 
	# Note: PaymentPeriod is the accounting year and month, eg for April 2019 the value would be 201901 not 201904
    And   there is no data in the Payment feed for FundingStreamPeriod 'LEVY1799' PaymentPeriod '201902' CensusEndDate '07/06/2019' and LinkCodeSuffix 'A'
    And   there is no data in the Payment feed for FundingStreamPeriod 'LEVY1799' PaymentPeriod '201902' CensusEndDate '07/06/2019' and LinkCodeSuffix 'B'
    And   there is no data in the Payment feed for FundingStreamPeriod 'LEVY1799' PaymentPeriod '201902' CensusEndDate '07/06/2019' and LinkCodeSuffix 'C'
    And   there is no data in the Payment feed for FundingStreamPeriod 'LEVY1799' PaymentPeriod '201902' CensusEndDate '07/06/2019' and LinkCodeSuffix 'D'
	
	# This bit checks that there is something in PaaS. In essence, a 'wait' before proceeding with the batch
	And   the following allocation periods are present in the subnominal aggregation PaaS table
	| ContractAllocationNumber | Period |
	| [AllocRef_LEVY]          | 201905 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
	And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | LEVY1799                   | 201905               |                      | A              | NotStarted |
   
    When  the Payment Generation Batch run is started

	# PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | LEVY1799                   | 201905               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'LEVY1799' PaymentPeriod '201902' CensusEndDate '07/06/2019' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A105.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'LEVY1799' PaymentPeriod '201902' CensusEndDate '07/06/2019' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | LEVY                   | 2019          | 02             | 07          | ?       | [AllocRef_LEVY]  | -417.41         | RECONCILIATION   | 16-18Levy LevyFunded               | 2019-06-17 | 2017-05-01   | 2099-12-31 | ?              | 10017105 | 2240110    |
    | LEVY                   | 2019          | 02             | 07          | ?       | [AllocRef_LEVY]  | -421.21         | RECONCILIATION   | 16-18Levy CoInvested               | 2019-06-17 | 2017-05-01   | 2099-12-31 | ?              | 10017105 | 2240120    |
    | LEVY                   | 2019          | 02             | 07          | ?       | [AllocRef_LEVY]  | -105.55         | RECONCILIATION   | 16-18Levy AgencyFund               | 2019-06-17 | 2017-05-01   | 2099-12-31 | ?              | 10017105 | 2240130    |
    | LEVY                   | 2019          | 02             | 07          | ?       | [AllocRef_LEVY]  | -267.05         | RECONCILIATION   | 16-18Levy Employer                 | 2019-06-17 | 2017-05-01   | 2099-12-31 | ?              | 10017105 | 2240140    |
    | LEVY                   | 2019          | 02             | 07          | ?       | [AllocRef_LEVY]  | 1168.10         | RECONCILIATION   | 19+Levy LevyFunded                 | 2019-06-17 | 2017-05-01   | 2099-12-31 | ?              | 10017105 | 2340110    |
    | LEVY                   | 2019          | 02             | 07          | ?       | [AllocRef_LEVY]  | 228.41          | RECONCILIATION   | 19+Levy CoInvested                 | 2019-06-17 | 2017-05-01   | 2099-12-31 | ?              | 10017105 | 2340120    |
    | LEVY                   | 2019          | 02             | 07          | ?       | [AllocRef_LEVY]  | 260.74          | RECONCILIATION   | 19+Levy AgencyFund                 | 2019-06-17 | 2017-05-01   | 2099-12-31 | ?              | 10017105 | 2340130    |
	 
    # Check AllocationDelivery.AllocationDeliveryEntry (ADP) feed for certain events. [Type0=NewApproval, Type1=AmendmentApproval, Type2=Actuals and Type3=Payments]
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events 
    | AllocationDeliveryEntryCategory   | ADCode | AllocationNumber | ContractVersionNumber |
    | NewContractAllocationApproved     | 0      | [AllocRef_LEVY]  | 1                     |
    | AmendedContractAllocationApproved | 1      | [AllocRef_LEVY]  | 2                     |
   #| ContractAllocationActualsReceived | 2      | [AllocRef_LEVY]  | 2                     |
    | ContractAllocationPaymentReceived | 3      | [AllocRef_LEVY]  | 2                     |




    # Initiate a TERMINATION

    # Change the date
    Given the override date is '03/08/2019'

    # Retrieve parameters from CRM 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017105' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017105' 
    When  I retrieve the latest contract details from CRM for provider '10017105' for FundingType 'LEVY' and period '1799' 

    # Request termination of the contract via the CRM SDK
    When  CRM user 'FCS8 Test' initiates contract termination for Contract '[ContractNo]' Version '2' SubVersion '0' with the following options
    | DefaultStopNewStartsDate | ContractTerminationDate | TerminationReason       | TerminationComments     |
    | 02/08/2019               | 02/08/2019              | Notice from Provider    | Company sold            |

    And   with the following allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | [AllocRef_LEVY]  | 02/08/2019                  | 02/08/2019                |
    | [AllocRef_NLA]   | 02/08/2019                  | 02/08/2019                |

	# Use either the CRM UI (slow) or the SDK (fast) to request manager approval
#   And   the user forwards the termination request for manager approval via UI
    And   the user forwards the termination request for manager approval via SDK

    # Create a new Task. (Only needed where termination initiation is via SDK)
    Given the following Tasks are created against version '2' of contract '[ContractNo]' for UKPRN '10017105'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017105 - 10017105 Co Ltd     | [ContractNo]   | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                        | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017105 | [ContractNo]       | 2                     | 0                        | Approved         | Awaiting Termination Initiation Approval | True          | True                | 02/05/2017        | ?               | Notification  |
    | 10017105 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                 | False         | False               | 02/05/2017        | ?               | ?             |
    | 10017105 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                                        | False         | False               | 01/05/2017        | ?               | ?             |




    # Approve the Termination initiation

    # Change the date
    Given the override date is '04/08/2019'

    # Complete an existing open Task to approve the initiation of the termination
    When the following open Task currently linked to version '2' of contract '[ContractNo]' for provider '10017105' is triggered by User 'FCS5 Test'
    | Task                                       | Owner         |
    | Confirm Termination Initiation Approval    | FCS5 Test     |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus    | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017105 | [ContractNo]       | 2                     | 0                        | Approved         | Under Termination    | True          | True                | 02/05/2017        | ?               | Notification  |
    | 10017105 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved             | False         | False               | 02/05/2017        | ?               | ?             |
    | 10017105 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                    | False         | False               | 01/05/2017        | ?               | ?             |




    # Complete the Termination

    # Change the date
    Given the override date is '05/08/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Manager COMPLETES termination (23893)
#   When  CRM user 'FCS8 Test' completes the termination request for Contract '[ContractNo]' Version '2' SubVersion '0' via UI
    When  CRM user 'FCS8 Test' completes the termination request for Contract '[ContractNo]' Version '2' SubVersion '0' via SDK

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus    | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017105 | [ContractNo]       | 2                     | 0                        | Closed           | Terminated           | True          | True                | 02/05/2017        | 02/08/2019      | Notification  |
    | 10017105 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved             | False         | False               | 02/05/2017        | ?               | ?             |
    | 10017105 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                    | False         | False               | 01/05/2017        | ?               | ?             |





	# Consume payment instructions after the termination date. These should be ignored (23975)

    # Check the deliverable period count in CRM BEFORE pulling data for Oct 2019
    And   there are '38' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check the RECONCILIATION AMOUNTS in CRM BEFORE pulling data for Oct 2019
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | May-17   |
    | [ContractNo]   | [AllocRef_LEVY] | 1               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 7               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 13              | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 14              | 0.00      | ?        | 

    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | May-17   | May-19   |
    | [ContractNo]   | [AllocRef_LEVY] | 2               | -417.41   | ?        | -417.41  | 
    | [ContractNo]   | [AllocRef_LEVY] | 3               | -421.21   | ?        | -421.21  | 
    | [ContractNo]   | [AllocRef_LEVY] | 4               | -105.55   | ?        | -105.55  | 
    | [ContractNo]   | [AllocRef_LEVY] | 5               | 0.00      | ?        | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY] | 6               | -267.05   | ?        | -267.05  | 
    | [ContractNo]   | [AllocRef_LEVY] | 8               | 1168.10   | ?        | 1168.10  | 
    | [ContractNo]   | [AllocRef_LEVY] | 9               | 228.41    | ?        | 228.41   | 
    | [ContractNo]   | [AllocRef_LEVY] | 10              | 0.00      | ?        | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY] | 11              | 260.74    | ?        | 260.74   | 
    | [ContractNo]   | [AllocRef_LEVY] | 12              | 0.00      | ?        | 0.00     | 

    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   |
    | [ContractNo]   | [AllocRef_NLA]  | 1               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 2               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 3               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 4               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 5               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 6               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 7               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 8               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 9               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 10              | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 11              | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 12              | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 13              | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 14              | 0.00      | ?        | 




    # Change the date
    And   the override date is '04/11/2019'

    # Pull DCFS PoI actuals for Oct 2019 for both LEVY and NONLEVY allocations. Both should be ignored
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS38               | ORG0017105     | CM             | 201910 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 616.41      |
    | APPS           | APPS38               | ORG0017105     | CM             | 201910 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 3614.50     |
    | APPS           | APPS38               | ORG0017105     | CM             | 201910 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 1052.22     |
    | APPS           | APPS38               | ORG0017105     | CM             | 201910 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 608.25      |
    | APPS           | APPS38               | ORG0017105     | CM             | 201910 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 0.00        |
    | APPS           | APPS38               | ORG0017105     | CM             | 201910 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | -5.00       |
	#
    | APPS           | APPS38               | ORG0017105     | CM             | 201910 | LEVY1799                | [AllocRef_NLA]           |         | 3               | 0            | 615.56      |
    | APPS           | APPS38               | ORG0017105     | CM             | 201910 | LEVY1799                | [AllocRef_NLA]           |         | 4               | 0            | 408.20      |
    | APPS           | APPS38               | ORG0017105     | CM             | 201910 | LEVY1799                | [AllocRef_NLA]           |         | 7               | 0            | 1052.22     |
    | APPS           | APPS38               | ORG0017105     | CM             | 201910 | LEVY1799                | [AllocRef_NLA]           |         | 9               | 0            | -85.75      |
    | APPS           | APPS38               | ORG0017105     | CM             | 201910 | LEVY1799                | [AllocRef_NLA]           |         | 13              | 0            | 757.08      |
    | APPS           | APPS38               | ORG0017105     | CM             | 201910 | LEVY1799                | [AllocRef_NLA]           |         | 14              | 0            | 0.01        |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the deliverable period count in CRM AFTER pulling data for Oct 2019. This should not have changed
    Then  there are '38' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check the RECONCILIATION AMOUNTS in CRM AFTER pulling data for Oct 2019. They should not have changed
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | May-17   |
    | [ContractNo]   | [AllocRef_LEVY] | 1               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 7               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 13              | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_LEVY] | 14              | 0.00      | ?        | 

    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | May-17   | May-19   |
    | [ContractNo]   | [AllocRef_LEVY] | 2               | -417.41   | ?        | -417.41  | 
    | [ContractNo]   | [AllocRef_LEVY] | 3               | -421.21   | ?        | -421.21  | 
    | [ContractNo]   | [AllocRef_LEVY] | 4               | -105.55   | ?        | -105.55  | 
    | [ContractNo]   | [AllocRef_LEVY] | 5               | 0.00      | ?        | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY] | 6               | -267.05   | ?        | -267.05  | 
    | [ContractNo]   | [AllocRef_LEVY] | 8               | 1168.10   | ?        | 1168.10  | 
    | [ContractNo]   | [AllocRef_LEVY] | 9               | 228.41    | ?        | 228.41   | 
    | [ContractNo]   | [AllocRef_LEVY] | 10              | 0.00      | ?        | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY] | 11              | 260.74    | ?        | 260.74   | 
    | [ContractNo]   | [AllocRef_LEVY] | 12              | 0.00      | ?        | 0.00     | 

    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   |
    | [ContractNo]   | [AllocRef_NLA]  | 1               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 2               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 3               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 4               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 5               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 6               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 7               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 8               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 9               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 10              | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 11              | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 12              | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 13              | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]  | 14              | 0.00      | ?        | 


	# Tidy up
	And   the override date is reset

@AcceptanceTest @Withdrawn20200420
@PublishNewLevyContract @PaymentScheduleTests @PaymentGenerationAndTransmission
Scenario: A106 Create and approve a Levy contract. Consume actuals. Run payment batch. Check .ERR payment files, CRM, PaaS, ADP feed and Payment feed
    Given there is no Contract, Task or Workflow data for UKPRN '10017106'
   #And   Files are deleted from PTS Sharepoint folder
   #And   Files and folder are deleted from FTP Server
	And   caseload advisor 'FCS2 Test' is assigned to provider '10017106 Co Ltd' with UKPRN '10017106' and OrgId 'ORG0017106' and has 'FCS1 Test' as a manager
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017106'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017106'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no entries in the DCFS stub table
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017106'
    And   there are no DAS engagement events stored in FCS
    And   the Allocation Delivery Monitoring Service atom feed is empty
    And   the override date is reset




	# Remove the provider from RoATP (ContractManagement.RoATPProvider)
    And   there is no data on RoATP for the following providers
    | Ukprn    |
    | 10017106 |

    # Add the provider to RoATP (ContractManagement.RoATPProvider)
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017106 | 10017106 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 




    # Inject data into the stub (16104)
   #And   the following Levy event data is available in the DAS agreement stub
    And   the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation
    | Id    | Event     | CreatedOn                | ProviderId | ContractType      |
    | 43852 | INITIATED | 2017-02-16T09:31:29.1317 | 10017106   | ProviderAgreement |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017106'
    Then  there is only one Levy contract in CRM for UKPRN '10017106' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Internally Approved    | Yes           | No                  | 1                     | 

    # Retrieve parameters from CRM  
   #When  I retrieve the latest EFA contract details from CRM for provider '10017106' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017088' 
    And   I retrieve the latest contract details from CRM for provider '10017106' for FundingType 'LEVY' and period '1799' 

    # Publish the contract (This is needed because the injection step above leaves the contract in the wrong state)
    Given the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'




    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017106 | 10017106 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017106 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017106 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017106 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017106 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
 
    # Check deliverable period count prior to approval 
    And   there are '2' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 




	# Change the date
	Given the override date is '02/05/2017'

    # Approve the contract
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check the deliverable count in CRM
    Then  there are '14' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check version and status values in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus      | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017106 | [ContractNo]       | 1                     | 0                        | Approved         | Approved               | True          | True                | 02/05/2017        | ?               | ?             |
    | 10017106 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                      | False         | False               | 01/05/2017        | ?               | ?             |




	# Change the date
	Given  the override date is '07/06/2017'

    # Pull DCFS PoI actuals for May 2017
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS01               | ORG0017106     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 417.41      |
    | APPS           | APPS01               | ORG0017106     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 421.21      |
    | APPS           | APPS01               | ORG0017106     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 106.55      |
    | APPS           | APPS01               | ORG0017106     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 0.00        |
    | APPS           | APPS01               | ORG0017106     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 267.05      |
    | APPS           | APPS01               | ORG0017106     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1168.10     |
    | APPS           | APPS01               | ORG0017106     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 228.41      |
    | APPS           | APPS01               | ORG0017106     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 0.00        |
    | APPS           | APPS01               | ORG0017106     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 260.74      |
    | APPS           | APPS01               | ORG0017106     | CM             | 201705 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 0.00        |
    #
	| APPS           | APPS01               | ORG0017106     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 0.00        |
    | APPS           | APPS01               | ORG0017106     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 773.25      |
    | APPS           | APPS01               | ORG0017106     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 1192.86     |
    | APPS           | APPS01               | ORG0017106     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 1322.41     |
    | APPS           | APPS01               | ORG0017106     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 1115.85     |
    | APPS           | APPS01               | ORG0017106     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1353.98     |
    | APPS           | APPS01               | ORG0017106     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 1121.85     |
    | APPS           | APPS01               | ORG0017106     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 605.32      |
    | APPS           | APPS01               | ORG0017106     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 759.83      |
    | APPS           | APPS01               | ORG0017106     | CM             | 201706 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 329.56      |
    #
	| APPS           | APPS01               | ORG0017106     | CM             | 201707 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 0.00        |
    | APPS           | APPS01               | ORG0017106     | CM             | 201707 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 0.00        |
    | APPS           | APPS01               | ORG0017106     | CM             | 201707 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 0.00        |
    | APPS           | APPS01               | ORG0017106     | CM             | 201707 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 559.64      |
    | APPS           | APPS01               | ORG0017106     | CM             | 201707 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 324.57      |
    | APPS           | APPS01               | ORG0017106     | CM             | 201707 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1295.61     |
    | APPS           | APPS01               | ORG0017106     | CM             | 201707 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 1264.76     |
    | APPS           | APPS01               | ORG0017106     | CM             | 201707 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 0.00        |
    | APPS           | APPS01               | ORG0017106     | CM             | 201707 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | -114.50     |
    | APPS           | APPS01               | ORG0017106     | CM             | 201707 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 187.84      |
    #
	| APPS           | APPS01               | ORG0017106     | CM             | 201708 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 0.00        |
    | APPS           | APPS01               | ORG0017106     | CM             | 201708 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 1479.52     |
    | APPS           | APPS01               | ORG0017106     | CM             | 201708 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 717.72      |
    | APPS           | APPS01               | ORG0017106     | CM             | 201708 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 162.31      |
    | APPS           | APPS01               | ORG0017106     | CM             | 201708 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 19.98       |
    | APPS           | APPS01               | ORG0017106     | CM             | 201708 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 0.00        |
    | APPS           | APPS01               | ORG0017106     | CM             | 201708 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | -50.01      |
    | APPS           | APPS01               | ORG0017106     | CM             | 201708 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 877.86      |
    | APPS           | APPS01               | ORG0017106     | CM             | 201708 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 285.82      |
    | APPS           | APPS01               | ORG0017106     | CM             | 201708 | LEVY1799                | [AllocRef]               |         | 12              | 0            | 0.00        |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Run the payment batch. Check contents of payment file. Check ADP feed 
    Given the override date is '07/06/2017 22:05'
    And   there is no data in the Payment feed for FundingStreamPeriod 'LEVY1799 ' PaymentPeriod '201702' CensusEndDate '07/06/2017' and LinkCodeSuffix 'A'
    
    # This bit checks that there is something in PaaS. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_LEVY]          | 201705 |

    # PaymentGeneration.PaymentTimetable
    And   the below configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | LEVY1799                   | 201705               |                      | A              | NotStarted |

#   # Coda.AccountCode
#   And   the below configuration exists in the Account Codes table
#   | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#   | 10017106 | LEVY1799                   | CODA160   | 8115000      | 01/08/1990           | 31/08/2017         |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | LEVY1799                   | 201705               | Completed |

#    # File created in Maytech FTP folder for 'Apprenticeship Levy'
#    Then  Payment file 'LEVY20170207A.err' is created in the FTP Folder
#
#    # Decrypt the payment file to the Output window and save a decrypted version to Datafiles/Downloads
#    Given there is an encrypted file called 'LEVY20170207A.err' in the Maytech FTP folder decrypt it then save it to 'DataFiles/Downloads'
#
#    Then  the following details are present in payment file 'LEVY20170207A.err'
#    | LinkCode    | CompanyCode | Element1 | Element2 | Element3 | Element4 | Element5 | Element6   | Element7 | Element8 | Year | Period | Date       | Amount   | Dc   | LineType | Doc     | Desc                            | DueDate    | Tax | Extref1                       | Extref2     | Extref3      | Extref4 | Extref5  | Extref6 | Num   | DocLineNo |
#    | LEVY170207A | SFA         | AAA40    | +        | 8115000  | PZZZ99   | 02       | [AllocRef] | ?        | ?        | 2017 | 02     | 07/06/2017 | 417.41   | 160  | 157      | LEVYR   | 16-18Levy LevyFunded Rec Jun17  | 15/06/2017 | ?   | LEVY RECONCILIATION 2017/99   | LEVY170207A | ?            | CODA account code missing | 10017106 | 2240110 | 1     | 1         |
#    | LEVY170207A | SFA         | AAA40    | +        | 2240110  | 5000     | 02       | [AllocRef] | ?        | ?        | 2017 | 02     | 07/06/2017 | 417.41   | 161  | 158      | LEVYR   | 16-18Levy LevyFunded Rec Jun17  | 15/06/2017 | VIO | LEVY RECONCILIATION 2017/99   | LEVY170207A | ?            | CODA account code missing | 10017106 | PZZZ99  | 1     | 2         |
#    | LEVY170207A | SFA         | AAA40    | +        | 8115000  | PZZZ99   | 02       | [AllocRef] | ?        | ?        | 2017 | 02     | 07/06/2017 | 421.21   | 160  | 157      | LEVYR   | 16-18Levy CoInvested Rec Jun17  | 15/06/2017 | ?   | LEVY RECONCILIATION 2017/99   | LEVY170207A | ?            | CODA account code missing | 10017106 | 2240120 | 2     | 1         |
#    | LEVY170207A | SFA         | AAA40    | +        | 2240120  | 5000     | 02       | [AllocRef] | ?        | ?        | 2017 | 02     | 07/06/2017 | 421.21   | 161  | 158      | LEVYR   | 16-18Levy CoInvested Rec Jun17  | 15/06/2017 | VIO | LEVY RECONCILIATION 2017/99   | LEVY170207A | ?            | CODA account code missing | 10017106 | PZZZ99  | 2     | 2         |
#    | LEVY170207A | SFA         | AAA40    | +        | 8115000  | PZZZ99   | 02       | [AllocRef] | ?        | ?        | 2017 | 02     | 07/06/2017 | 106.55   | 160  | 157      | LEVYR   | 16-18Levy AgencyFund Rec Jun17  | 15/06/2017 | ?   | LEVY RECONCILIATION 2017/99   | LEVY170207A | ?            | CODA account code missing | 10017106 | 2240130 | 3     | 1         |
#    | LEVY170207A | SFA         | AAA40    | +        | 2240130  | 5000     | 02       | [AllocRef] | ?        | ?        | 2017 | 02     | 07/06/2017 | 106.55   | 161  | 158      | LEVYR   | 16-18Levy AgencyFund Rec Jun17  | 15/06/2017 | VIO | LEVY RECONCILIATION 2017/99   | LEVY170207A | ?            | CODA account code missing | 10017106 | PZZZ99  | 3     | 2         |
#    | LEVY170207A | SFA         | AAA40    | +        | 8115010  | PZZZ99   | 02       | [AllocRef] | ?        | ?        | 2017 | 02     | 07/06/2017 | 267.05   | 160  | 157      | LEVYR   | 16-18Levy Employer Rec Jun17    | 15/06/2017 | ?   | LEVY RECONCILIATION 2017/99   | LEVY170207A | ?            | CODA account code missing | 10017106 | 2240140 | 4     | 1         |
#    | LEVY170207A | SFA         | AAA40    | +        | 2240140  | 5000     | 02       | [AllocRef] | ?        | ?        | 2017 | 02     | 07/06/2017 | 267.05   | 161  | 158      | LEVYR   | 16-18Levy Employer Rec Jun17    | 15/06/2017 | VIO | LEVY RECONCILIATION 2017/99   | LEVY170207A | ?            | CODA account code missing | 10017106 | PZZZ99  | 4     | 2         |
#    | LEVY170207A | SFA         | AAA40    | +        | 8115000  | PZZZ99   | 02       | [AllocRef] | ?        | ?        | 2017 | 02     | 07/06/2017 | 1168.10  | 160  | 157      | LEVYR   | 19+Levy LevyFunded Rec Jun17    | 15/06/2017 | ?   | LEVY RECONCILIATION 2017/99   | LEVY170207A | ?            | CODA account code missing | 10017106 | 2340110 | 5     | 1         |
#    | LEVY170207A | SFA         | AAA40    | +        | 2340110  | 5000     | 02       | [AllocRef] | ?        | ?        | 2017 | 02     | 07/06/2017 | 1168.10  | 161  | 158      | LEVYR   | 19+Levy LevyFunded Rec Jun17    | 15/06/2017 | VIO | LEVY RECONCILIATION 2017/99   | LEVY170207A | ?            | CODA account code missing | 10017106 | PZZZ99  | 5     | 2         |
#    | LEVY170207A | SFA         | AAA40    | +        | 8115000  | PZZZ99   | 02       | [AllocRef] | ?        | ?        | 2017 | 02     | 07/06/2017 | 228.41   | 160  | 157      | LEVYR   | 19+Levy CoInvested Rec Jun17    | 15/06/2017 | ?   | LEVY RECONCILIATION 2017/99   | LEVY170207A | ?            | CODA account code missing | 10017106 | 2340120 | 6     | 1         |
#    | LEVY170207A | SFA         | AAA40    | +        | 2340120  | 5000     | 02       | [AllocRef] | ?        | ?        | 2017 | 02     | 07/06/2017 | 228.41   | 161  | 158      | LEVYR   | 19+Levy CoInvested Rec Jun17    | 15/06/2017 | VIO | LEVY RECONCILIATION 2017/99   | LEVY170207A | ?            | CODA account code missing | 10017106 | PZZZ99  | 6     | 2         |
#    | LEVY170207A | SFA         | AAA40    | +        | 8115000  | PZZZ99   | 02       | [AllocRef] | ?        | ?        | 2017 | 02     | 07/06/2017 | 260.74   | 160  | 157      | LEVYR   | 19+Levy AgencyFund Rec Jun17    | 15/06/2017 | ?   | LEVY RECONCILIATION 2017/99   | LEVY170207A | ?            | CODA account code missing | 10017106 | 2340130 | 7     | 1         |
#    | LEVY170207A | SFA         | AAA40    | +        | 2340130  | 5000     | 02       | [AllocRef] | ?        | ?        | 2017 | 02     | 07/06/2017 | 260.74   | 161  | 158      | LEVYR   | 19+Levy AgencyFund Rec Jun17    | 15/06/2017 | VIO | LEVY RECONCILIATION 2017/99   | LEVY170207A | ?            | CODA account code missing | 10017106 | PZZZ99  | 7     | 2         |

   # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'LEVY1799' PaymentPeriod '201702' CensusEndDate '07/06/2017' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A794.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'LEVY1799' PaymentPeriod '201702' CensusEndDate '07/06/2017' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef   | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | LEVY                   | 2017          | 02             | 07          | ?       | [AllocRef_LEVY] | 417.41          | RECONCILIATION   | 16-18Levy LevyFunded               | 2017-06-15 | 2017-05-01   | 2099-12-31 | ?              | 10017106 | 2240110    |
    | LEVY                   | 2017          | 02             | 07          | ?       | [AllocRef_LEVY] | 421.21          | RECONCILIATION   | 16-18Levy CoInvested               | 2017-06-15 | 2017-05-01   | 2099-12-31 | ?              | 10017106 | 2240120    |
    | LEVY                   | 2017          | 02             | 07          | ?       | [AllocRef_LEVY] | 106.55          | RECONCILIATION   | 16-18Levy AgencyFund               | 2017-06-15 | 2017-05-01   | 2099-12-31 | ?              | 10017106 | 2240130    |
    | LEVY                   | 2017          | 02             | 07          | ?       | [AllocRef_LEVY] | 267.05          | RECONCILIATION   | 16-18Levy Employer                 | 2017-06-15 | 2017-05-01   | 2099-12-31 | ?              | 10017106 | 2240140    |
    | LEVY                   | 2017          | 02             | 07          | ?       | [AllocRef_LEVY] | 1168.10         | RECONCILIATION   | 19+Levy LevyFunded                 | 2017-06-15 | 2017-05-01   | 2099-12-31 | ?              | 10017106 | 2340110    |
    | LEVY                   | 2017          | 02             | 07          | ?       | [AllocRef_LEVY] | 228.41          | RECONCILIATION   | 19+Levy CoInvested                 | 2017-06-15 | 2017-05-01   | 2099-12-31 | ?              | 10017106 | 2340120    |
    | LEVY                   | 2017          | 02             | 07          | ?       | [AllocRef_LEVY] | 260.74          | RECONCILIATION   | 19+Levy AgencyFund                 | 2017-06-15 | 2017-05-01   | 2099-12-31 | ?              | 10017106 | 2340130    |

    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'LEVY1799' AccountingPaymentPeriod '201702' and CensusEndDate '07/06/2017'

    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                              |
    | Payment Requests for Funding Stream Period LEVY1799 for Payment Period 201702 have been generated as of Census End Date/Time 2017-06-07T22:00:00Z. |

	 And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate        | PaymentLineCount | TotalValue |
    | LEVY1799            | 201702        | 2017-06-07T22:00:00Z | 7                | 2869.47    |

	And   the Payment feed item PaymentPeriod details are as follows
	| Agency | FSSC | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
	| ESFA   | LEVY | 01/05/2017   | 31/12/2099 | 07/06/2017    | 15/06/2017 | 2017          | 02             |

    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef        | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017106  | 10017106       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_LEVY] | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240110    | RECONCILIATION | 16-18Levy LevyFunded          | 417.41          |
    | ORG0017106  | 10017106       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_LEVY] | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240120    | RECONCILIATION | 16-18Levy CoInvested          | 421.21          |
    | ORG0017106  | 10017106       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_LEVY] | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240130    | RECONCILIATION | 16-18Levy AgencyFund          | 106.55          |
    | ORG0017106  | 10017106       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_LEVY] | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240140    | RECONCILIATION | 16-18Levy Employer            | 267.05          |
    | ORG0017106  | 10017106       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_LEVY] | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340110    | RECONCILIATION | 19+Levy LevyFunded            | 1168.10         |
    | ORG0017106  | 10017106       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_LEVY] | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340120    | RECONCILIATION | 19+Levy CoInvested            | 228.41          |
    | ORG0017106  | 10017106       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | [AllocRef_LEVY] | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340130    | RECONCILIATION | 19+Levy AgencyFund            | 260.74          |

    # Check AllocationDelivery.AllocationDeliveryEntry (ADP) feed for approvals(0), actuals(2) and payment(3) events
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events 
    | AllocationDeliveryEntryCategory   | ADCode | AllocationNumber | ContractVersionNumber |
    | NewContractAllocationApproved     | 0      | [AllocRef_LEVY]  | 1                     |
   #| ContractAllocationActualsReceived | 2      | [AllocRef_LEVY]  | 1                     |
    | ContractAllocationPaymentReceived | 3      | [AllocRef_LEVY]  | 1                     |


	# Tidy Up
    And   the override date is reset

