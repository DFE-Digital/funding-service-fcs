Feature: Year-End1819FundingClaimAdjustments 25755

@AcceptanceTest @Withdrawn20211005
@FundingClaim
@Long2Run @Long2Run45
Scenario: A557SLD Create and approve an 1819 AEB contract without a Delivery Org. Inject a Year End Funding Claim for AEB-LS1819 above the profile by more than the 3% tolerance. Put on hold then multiple changes to both Reconciliation value and ClaimAdjustment. Release from hold then publish. Check CRM and Feed
    Given there are no allocations marked as Under Termination for UKPRN '10017557' 
    And   there are no terminated or closed allocations for UKPRN '10017557' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017557' 
	And   there are no notifications of type 'Approval Received'
    And   there are no notifications of type 'Reconciliation Publication Failed'
	And   there are no notifications of type 'FCR Hold Failed'
	And   there are no notifications of type 'Held FCR Release Failed'
    And   there are no notifications of type 'FCR Allocation Update Failed'
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEBL-557      |

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Final         | 1718   |
    | Final         | 1819   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017557 |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEBL-557      |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017557' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017557 Co Ltd' with UKPRN '10017557' and OrgId 'ORG0017557' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status   | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017557 | 117557 | 10017557 Co Ltd | 0              | Active   | Yes           | AA017557      | ?             | 27 Linford Wood        | Linford Forum          | Rockingham Drive       | Milton Keynes          | ?                      | ?                      | MK14 6LY  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017557 |




    # Change the date
    Given the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017557 | 10017557 Co Ltd      | ESFA-557             | AEBP-557       | 1                     | 01/08/2018        | 31/07/2019      | 17235.00      |                                    | Contract for Services                      | 1819   | New          | ORG0017557 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017557 | AEBP-557       | AEBL-557      | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 17235.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017557 | AEBP-557       | AEBL-557      | 1               | 0                     | 17235.00  | 685.00   | 882.00   | 289.00   | 2068.00  | 3151.00  | 2622.00  | 1490.00  | 201.00   | 368.00   | 1831.00  | 3161.00  | 487.00   | Adult Education Budget - Learner Support                        | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-557' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-557' and actual ContractNumber 'AEBP-557'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-557' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017557 | AEBP-557           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017557 | ESFA-557           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'AEBP-557'




    # Populate stub with Claim data

    # Change the date
    Given the override date is '19/06/2019'

    #Set up claim data from DC for a 'Year End'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017557     | 10017557 | 3                  | Year End      | AY             | 1819   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017557     | 10017557 | 3                  | Year End      | AY             | 1819   | AEBL-557      | AEB-LS1819              |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017557     | 10017557 | 3                  | Year End      | AY             | 1819   | AEBL-557      | 2               | 4037.00     | 59.55         | 8.02            | 4104.57    |
    | ORG0017557     | 10017557 | 3                  | Year End      | AY             | 1819   | AEBL-557      | 3               | 3851.00     | 47.25         | 12.01           | 3910.26    |
    | ORG0017557     | 10017557 | 3                  | Year End      | AY             | 1819   | AEBL-557      | 4               | 3947.00     | 30.33         | 8.20            | 3985.53    |
    | ORG0017557     | 10017557 | 3                  | Year End      | AY             | 1819   | AEBL-557      | 5               | 3867.00     | 50.68         | 14.51           | 3932.19    |

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | 3                  | 17235.00     | 15932.55     | -1302.45                    | -1302.45            | 15932.55         | 0.00            | 15932.55                 | Draft      |

    Then  allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | AEBL-557      | 17235.00     | 15932.55     | -1302.45                    | -1302.45            | 15932.55         | 0.00            | ?                     | 15932.55                 | 427.05           |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017557 | 1819          | Year End         | AEB-LS1819          | AEBL-557      | AEB-LS1819           | 2               | 19+ Hardship                                           | 0.00         | 4104.57      |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | AEBL-557      | AEB-LS1819           | 3               | 20+ Childcare                                          | 0.00         | 3910.26      |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | AEBL-557      | AEB-LS1819           | 4               | Residential Access Fund                                | 0.00         | 3985.53      |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | AEBL-557      | AEB-LS1819           | 5               | Administration Expenditure                             | 0.00         | 3932.19      |




   	# FIRST update. No changes, ie the Final Reconciliation Value equals the Proposed Reconciliation Value and the Claim Adjustment is zero. 

    # Change the date 
    Given the override date is '21/06/2019'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither. In this case, neither
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | 
    | 10017557 | 1819          | Year End         | AEB-LS1819          | 3                  | AEBL-557      | 17235.00     | 15932.55     | -1302.45                    | -1302.45            | 15932.55         | 0.00            | ?                     | 

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | 3                  | 17235.00     | 15932.55     | -1302.45                    | -1302.45            | 15932.55         | 0.00            | 15932.55                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | AEBL-557      | 17235.00     | 15932.55     | -1302.45                    | -1302.45            | 15932.55         | 0.00            | ?                     | 15932.55                 | n/a              |



    # SECOND update. Amend the Final Reconciliation but leave the Claim Adjustment as zero. 
	
	# Change the date 
    Given the override date is '22/06/2019'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither. In this case, just the Final Reconciliation
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | 
    | 10017557 | 1819          | Year End         | AEB-LS1819          | 3                  | AEBL-557      | 17235.00     | 15932.55     | -1302.45                    | -1200.00            | 15932.55         | 0.00            | ?                     | 

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | 3                  | 17235.00     | 15932.55     | -1302.45                    | -1200.00            | 15932.55         | 0.00            | 15932.55                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | AEBL-557      | 17235.00     | 15932.55     | -1302.45                    | -1200.00            | 15932.55         | 0.00            | ?                     | 15932.55                 | n/a              |



	# Put the FCR on hold

	# Change the date 
    Given the override date is '23/06/2019'

	Given the following funding claim reconciliations have been put on hold
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | 3                  |




    # THIRD Update. Leave the Final Reconciliation as-is and set the Claim Adjustment to a non-zero value. 
	
	# Change the date 
    Given the override date is '24/06/2019'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither. In this case, just the Claim Adjustment
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | 
    | 10017557 | 1819          | Year End         | AEB-LS1819          | 3                  | AEBL-557      | 17235.00     | 15932.55     | -1302.45                    | -1200.00            | 15932.55         | -222.22         | Audit                 | 

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | 3                  | 17235.00     | 15932.55     | -1524.67                    | -1524.67            | 15932.55         | -222.22         | 15710.33                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | AEBL-557      | 17235.00     | 15932.55     | -1524.67                    | -1524.67            | 15932.55         | -222.22         | Audit                 | 15710.33                 | n/a              |



    # FOURTH Update. Change the Final Reconciliation again and change the Claim Adjustment to a different non-zero value. 
	
	# Change the date 
    Given the override date is '25/06/2019'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither. In this case, both
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | 
    | 10017557 | 1819          | Year End         | AEB-LS1819          | 3                  | AEBL-557      | 17235.00     | 15932.55     | -1524.67                    | -1750.00            | 15932.55         | -250.00         | Claim Error           | 

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | 3                  | 17235.00     | 15932.55     | -1552.45                    | -1750.00            | 15932.55         | -250.00         | 15682.55                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | AEBL-557      | 17235.00     | 15932.55     | -1552.45                    | -1750.00            | 15932.55         | -250.00         | Claim Error           | 15682.55                 | n/a              |



    # FIFTH Update. Return to the starting position ie, change the Final Reconciliation back to it's original value and set the Claim Adjustment to zero. 
	
	# Change the date 
    Given the override date is '26/06/2019'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither. In this case, both
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | 
    | 10017557 | 1819          | Year End         | AEB-LS1819          | 3                  | AEBL-557      | 17235.00     | 15932.55     | -1552.45                    | -1302.45            | 15932.55         | 0.00            | ?                     | 

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | 3                  | 17235.00     | 15932.55     | -1302.45                    | -1302.45            | 15932.55         | 0.00            | 15932.55                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | AEBL-557      | 17235.00     | 15932.55     | -1302.45                    | -1302.45            | 15932.55         | 0.00            | ?                     | 15932.55                 | n/a              |



	# Change the date
    Given the override date is '27/06/2019'

    # Remove the hold by changing the FCR back to its base state of Draft\Draft
    And   the following Funding Claim Reconciliations have a status of 'Draft' and a substatus of 'Draft'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | 3                  |

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '1819-YearEnd' and Allocation Group Code 'AEB-LS1819'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '1819-YearEnd' and Allocation Group Code 'AEB-LS1819'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | 3                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | 3                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017557 | 1819          | Year End         | AEB-LS1819          | 3                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                         | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017557 | AEBL-557         | 1819   | Year End      | Adult Education Budget - Learner Support 18/19              | 17235.00     | 15932.55     | -1302.45                    | -1302.45                 | 15932.55           | ?               | ?                     | 15932.55                 | 


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
@FundingClaim
Scenario: A558SLD Create and approve an 1819 Mainstream contract for AEBC1819. Adjust the Year End Claim value such that over-delivery occurs at recalculation. Check CRM.
    Given there are no allocations marked as Under Termination for UKPRN '10017558' 
    And   there are no terminated or closed allocations for UKPRN '10017558' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017558' 
	And   there are no notifications of type 'Approval Received'
    And   there are no notifications of type 'Reconciliation Publication Failed'
	And   there are no notifications of type 'FCR Hold Failed'
	And   there are no notifications of type 'Held FCR Release Failed'
    And   there are no notifications of type 'FCR Allocation Update Failed'
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEC-558       |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017558 |

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Final         | 1718   |
    | Final         | 1819   |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEC-558       |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017558' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017558 Co Ltd' with UKPRN '10017558' and OrgId 'ORG0017558' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017558' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017558 | 117558 | 10017558 Co Ltd | 0              | In Administration     | Yes           | AA017558      | ?             | 55 Fountain Place      | Loanhead               | Midlothian             | ?                      | ?                      | ?                      | EH20 9DT  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017558 |




    # Change the date
    Given the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017558 | 10017558 Co Ltd      | ESFA-558             | MAIN-558       | 1                     | 01/08/2018        | 31/07/2019      | 10000.00      |                                    | Contract for Services                      | 1819   | New          | ORG0017558 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017558 | MAIN-558       | AEC-558       | AEBC              | AEBC1819                | AY                      | 01/08/2018          | 31/07/2019        | 10000.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017558 | MAIN-558       | AEC-558       | 1               | 0                     | 10000.00  | 9499.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Adult Education Budget Total Funding                            | New          |             |
    | 10017558 | MAIN-558       | AEC-558       | 13              | 1                     | 499.00    | 499.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Community Learning                                              | New          |             |
    | 10017558 | MAIN-558       | AEC-558       | 14              | 1                     | 9501.00   | 9501.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Other AEB Funding                                               | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-558' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-558' and actual ContractNumber 'MAIN-558'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-558' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017558 | MAIN-558           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017558 | ESFA-558           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'MAIN-558'




	# Populate stub with Claim data

    # Change the date
    Given the override date is '19/06/2019'

    #Set up claim data from DC for a 'Year End'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017558     | 10017558 | 3                  | Year End      | AY             | 1819   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017558     | 10017558 | 3                  | Year End      | AY             | 1819   | AEC-558       | AEBC1819                |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017558     | 10017558 | 3                  | Year End      | AY             | 1819   | AEC-558       | 2               | 5000.00     | 0.00          | 0.00            | 5000.00    |
    | ORG0017558     | 10017558 | 3                  | Year End      | AY             | 1819   | AEC-558       | 3               | 1500.00     | 0.00          | 0.00            | 1500.00    |
    | ORG0017558     | 10017558 | 3                  | Year End      | AY             | 1819   | AEC-558       | 4               | 2500.00     | 0.00          | 0.00            | 2500.00    |
    | ORG0017558     | 10017558 | 3                  | Year End      | AY             | 1819   | AEC-558       | 5               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0017558     | 10017558 | 3                  | Year End      | AY             | 1819   | AEC-558       | 6               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0017558     | 10017558 | 3                  | Year End      | AY             | 1819   | AEC-558       | 7               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0017558     | 10017558 | 3                  | Year End      | AY             | 1819   | AEC-558       | 8               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0017558     | 10017558 | 3                  | Year End      | AY             | 1819   | AEC-558       | 9               | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0017558     | 10017558 | 3                  | Year End      | AY             | 1819   | AEC-558       | 10              | 0.00        | 0.00          | 0.00            | 0.00       |
    | ORG0017558     | 10017558 | 3                  | Year End      | AY             | 1819   | AEC-558       | 13              | 850.00      | 0.00          | 0.00            | 850.00     |

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

   # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017558 | 1819          | Year End         | AEBC1819            | 3                  | 10000.00     | 9850.00      | -501.00                     | -501.00             | 9499.00          | 0.00            | 9499.00                  | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017558 | 1819          | Year End         | AEBC1819            | AEC-558       | 10000.00     | 9850.00      | -501.00                     | -501.00             | 9499.00          | 0.00            | ?                     | 9499.00                  | 300.00           |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017558 | 1819          | Year End         | AEBC1819            | AEC-558       | AEBC1819_AS_LS       | 2               | 19-24 Traineeships Programme Funding                   | 0.00         | 5000.00      |
    | 10017558 | 1819          | Year End         | AEBC1819            | AEC-558       | AEBC1819_AS_LS       | 3               | 19-24 Traineeships Learning Support                    | 0.00         | 1500.00      |
    | 10017558 | 1819          | Year End         | AEBC1819            | AEC-558       | AEBC1819_AS_LS       | 4               | 19-24 Traineeships Learner Support                     | 0.00         | 2500.00      |
    | 10017558 | 1819          | Year End         | AEBC1819            | AEC-558       | AEBC1819_AS_LS       | 5               | Other Learning Programme Funding                       | 0.00         | 0.00         |
    | 10017558 | 1819          | Year End         | AEBC1819            | AEC-558       | AEBC1819_AS_LS       | 6               | Other Learning - Learning Support                      | 0.00         | 0.00         |
    | 10017558 | 1819          | Year End         | AEBC1819            | AEC-558       | AEBC1819_AS_LS       | 7               | Learner Support - 19+ Hardship                         | 0.00         | 0.00         |
    | 10017558 | 1819          | Year End         | AEBC1819            | AEC-558       | AEBC1819_AS_LS       | 8               | Learner Support - 20+ Childcare                        | 0.00         | 0.00         |
    | 10017558 | 1819          | Year End         | AEBC1819            | AEC-558       | AEBC1819_AS_LS       | 9               | Learner Support - Residential Access Fund              | 0.00         | 0.00         |
    | 10017558 | 1819          | Year End         | AEBC1819            | AEC-558       | AEBC1819_AS_LS       | 10              | Learner Support - Administration Expenditure           | 0.00         | 0.00         |
    | 10017558 | 1819          | Year End         | AEBC1819            | AEC-558       | AEBC1819_CL          | 13              | Community Learning                                     | 499.00       | 850.00       |




   # Change the date 
    Given the override date is '21/06/2019'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither. In this case, just the Claim adjustment value 
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017558 | 1819          | Year End         | AEBC1819            | 3                  | AEC-558       | 10000.00     | 9850.00      | -501.00                     | -501.00             | 9499.00          | 600.00          | Other                 |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017558 | 1819          | Year End         | AEBC1819            | 3                  | 10000.00     | 9850.00      | 99.00                       | 99.00               | 9499.00          | 600.00          | 10099.00                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017558 | 1819          | Year End         | AEBC1819            | AEC-558       | 10000.00     | 9850.00      | 99.00                       | 99.00               | 9499.00          | 600.00          | Other                 | 10099.00                 | 300.00           |


	# Tidy up
	And the override date is reset

@AcceptanceTest @Withdrawn20260521
@FundingClaim
@Long2Run @Long2Run45
Scenario: A559SLD Create and approve an 1819 AEB contract without a Delivery Org. Inject a Year End Funding Claim then adjust the Reconciliation value and include a Claim Adjustment. Amend contract. Recalc FCR. Check CRM 
    Given there are no allocations marked as Under Termination for UKPRN '10017559' 
    And   there are no terminated or closed allocations for UKPRN '10017559' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017559' 
    And   there are no notifications of type 'Approval Received'
	And   there are no notifications of type 'Amendment Approval'
    And   there are no notifications of type 'Reconciliation Publication Failed'
    And   there are no notifications of type 'FCR Hold Failed'
    And   there are no notifications of type 'Held FCR Release Failed'
    And   there are no notifications of type 'FCR Allocation Update Failed'
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEBL-559      |

    # Cleardown DEDs/SLD and PaaS
   #And   there is no data in the DEDS stub or PAAS tables for the following claim type and period
    And   there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Year End      | 1718   |
    | Year End      | 1819   |
    | Final         | 1718   |
    | Final         | 1819   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10017559 |

    # Cleardown FCR publications
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEBL-559      |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017559' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017559 Co Ltd' with UKPRN '10017559' and OrgId 'ORG0017559' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017559' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017559 | 117559 | 10017559 Co Ltd | 0              | Provider Under Change | Yes           | AA017559      | ?             | 52 Park Street         | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 3PT  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017559 |




    # Change the date
    Given the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017559 | 10017559 Co Ltd      | ESFA-559             | AEBP-559       | 1                     | 01/08/2018        | 31/07/2019      | 26756.00      |                                    | Contract for Services                      | 1819   | New          | ORG0017559 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017559 | AEBP-559       | AEBL-559      | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 26756.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017559 | AEBP-559       | AEBL-559      | 1               | 0                     | 26756.00  | 2195.00  | 3026.00  | 4535.00  | 1587.00  | 2131.00  | 2235.00  | 2907.00  | 891.00   | 520.00   | 2615.00  | 2749.00  | 1365.00  | Adult Education Budget - Learner Support                        | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-559' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '09/07/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-559' and actual ContractNumber 'AEBP-559'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-559' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017559 | AEBP-559           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017559 | ESFA-559           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'AEBP-559'

	# Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code | Period | Payment Type   |
    | AEBL-559      | 2372065         | Jul-19 | Profile        |
    | AEBL-559      | 2372075         | Jul-19 | Reconciliation | 




    # Populate stub with Claim data

    # Change the date
    Given the override date is '19/06/2019'

    #Set up claim data from DC for a 'Year End'
   #And   funding claim data is present in the DEDS stub as follows
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0017559     | 10017559 | 3                  | Year End      | AY             | 1819   | False         |

   #And   allocation data is present in the DEDS stub as follows 
    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0017559     | 10017559 | 3                  | Year End      | AY             | 1819   | AEBL-559      | AEB-LS1819              |

   #And   deliverable data is present in the DEDS stub as follows 
    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0017559     | 10017559 | 3                  | Year End      | AY             | 1819   | AEBL-559      | 2               | 6654.00     | 65.00         | 8.17            | 6727.17    |
    | ORG0017559     | 10017559 | 3                  | Year End      | AY             | 1819   | AEBL-559      | 3               | 6359.00     | 49.37         | 5.88            | 6414.25    |
    | ORG0017559     | 10017559 | 3                  | Year End      | AY             | 1819   | AEBL-559      | 4               | 5790.00     | 55.66         | 11.49           | 5857.15    |
    | ORG0017559     | 10017559 | 3                  | Year End      | AY             | 1819   | AEBL-559      | 5               | 5865.00     | 49.09         | 14.03           | 5928.12    |

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

    # Check the details in CRM
    Then  group claim data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017559 | 1819          | Year End         | AEB-LS1819          | 3                  | 26756.00     | 24926.69     | -1829.31                    | -1829.31            | 24926.69         | 0.00            | 24926.69                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017559 | 1819          | Year End         | AEB-LS1819          | AEBL-559      | 26756.00     | 24926.69     | -1829.31                    | -1829.31            | 24926.69         | 0.00            | ?                     | 24926.69                 | 682.68           |

    And   deliverable data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | DeliverableGroupCode | DeliverableCode | DeliverableName                                        | PlannedValue | ClaimedValue | 
    | 10017559 | 1819          | Year End         | AEB-LS1819          | AEBL-559      | AEB-LS1819           | 2               | 19+ Hardship                                           | 0.00         | 6727.17      |
    | 10017559 | 1819          | Year End         | AEB-LS1819          | AEBL-559      | AEB-LS1819           | 3               | 20+ Childcare                                          | 0.00         | 6414.25      |
    | 10017559 | 1819          | Year End         | AEB-LS1819          | AEBL-559      | AEB-LS1819           | 4               | Residential Access Fund                                | 0.00         | 5857.15      |
    | 10017559 | 1819          | Year End         | AEB-LS1819          | AEBL-559      | AEB-LS1819           | 5               | Administration Expenditure                             | 0.00         | 5928.12      |




    # Change the date 
    Given the override date is '21/06/2019'

    # User can update the Reconciliation value or introduce a Claim Adjustment or both or neither. In this case, both
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017559 | 1819          | Year End         | AEB-LS1819          | 3                  | AEBL-559      | 26756.00     | 24926.69     | -1829.31                    | -1000.00            | 24926.69         | 500.00          | Other                 |

    Then  group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017559 | 1819          | Year End         | AEB-LS1819          | 3                  | 26756.00     | 24926.69     | -1329.31                    | -1000.00            | 24926.69         | 500.00          | 25426.69                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017559 | 1819          | Year End         | AEB-LS1819          | AEBL-559      | 26756.00     | 24926.69     | -1329.31                    | -1000.00            | 24926.69         | 500.00          | Other                 | 25426.69                 | 802.68           |




    # Change the date
    Given the override date is '22/06/2019'

    # Bulk import to amend contract PRIOR to publishing the FCR. (Reduce planned value by £752 from £26,756 to £26,004)
    And   there are no files prefixed '10017559' in the Sharepoint 'AEB-1819-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1819 20052019081526 v3_A559' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1819 20052019081526 v3_A559' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1819 20052019081526 v3_A559.xlsx' exists in the Datafiles folder and UKPRN '10017559' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Change the date
    Given the override date is '23/06/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-559' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-559' and actual ContractNumber 'AEBP-559'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-559' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017559 | AEBP-559           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017559 | AEBP-559           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017559 | ESFA-559           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

	# Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code | Period | Payment Type   |
    | AEBL-559      | 2372065         | Jul-19 | Profile        |
    | AEBL-559      | 2372075         | Jul-19 | Reconciliation |


	# Check CRM Financials

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-559       | AEBL-559        | 1               | 26004.00  | 3547.00  | 2888.00  | 1137.00  | 2002.00  | 2803.00  | 1391.00  | 1044.00  | 5096.00  | 2463.00  | 2411.00  | 757.00   | 465.00   | 

    # Check the PROFILE PAYMENTS in CRM
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-559       | AEBL-559        | 1               | 25856.00  | 2195.00  | 3026.00  | 4535.00  | 1587.00  | 2131.00  | 2235.00  | 2907.00  | 891.00   | 520.00   | 2615.00  | 2749.00  | 465.00   | 

    # Check the BALANCING PAYMENTS in CRM
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-559       | AEBL-559        | 1               | 148.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 148.00   | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-559       | AEBL-559        | 1               | 26004.00  | 2195.00  | 3026.00  | 4535.00  | 1587.00  | 2131.00  | 2235.00  | 2907.00  | 891.00   | 520.00   | 2615.00  | 2749.00  | 613.00   | 





	# Check FCR values
    And   group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017559 | 1819          | Year End         | AEB-LS1819          | 3                  | 26004.00     | 24926.69     | -577.31                     | -1000.00            | 24926.69         | 500.00          | 25426.69                 | Draft      |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017559 | 1819          | Year End         | AEB-LS1819          | AEBL-559      | 26004.00     | 24926.69     | -577.31                     | -1000.00            | 24926.69         | 500.00          | Other                 | 25426.69                 | 802.68           |




    # Check for an 'Amendment Approval' notification
   #And   there are notifications of type 'Amendment Approval' owned by the user 'FCS2 Test' as follows
   #And   there are notifications of type 'Amendment Approval' owned by the 'Claim Editor Team' as follows
   #And   there are '0' notifications of type 'Amendment Approval' owned by user 'FCS2 Test' which match the following
   #And   there is '1' notification of type 'Amendment Approval' owned by user 'FCS2 Test' which match the following
   #And   there are '0' notifications of type 'Amendment Approval' owned by team 'Claim Editor Team' which match the following
    And   there is '1' notification of type 'Amendment Approval' owned by team 'Claim Editor Team' which matches the following
    | Status | NotificationName                                                                   | NotificationText                                  |
    | New    | Amendment Approval-Allocation AEBL-559 - Adult Education Budget - Learner Support  | AEBL-559 v2 (10017559: 10017559 Co Ltd) approved  |
   
    # Delete the notification prior to the next part of the test
	Given there are no notifications of type 'Amendment Approval'


	
	
	# Change the date
    Given the override date is '25/06/2019'

    # Check the current date against the Publication Close Date for the AGC
   #Then  the override date is after the Publication Close Date for Claim Reconciliation Code '1819-YearEnd' and Allocation Group Code 'AEB-LS1819'
    Then  the override date is before the Publication Close Date for Claim Reconciliation Code '1819-YearEnd' and Allocation Group Code 'AEB-LS1819'

    # Update Draft Claim Reconciliations to 'Published'
    When  the following funding claim reconciliations are changed to Publish in Progress
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017559 | 1819          | Year End         | AEB-LS1819          | 3                  |

   #Then  the following funding claim reconciliations will have a status of 'Published'
    Then  the following funding claim reconciliations will have a status 'Published' and a sub status 'Published'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017559 | 1819          | Year End         | AEB-LS1819          | 3                  |

    # Use Atom feed to inform downstream systems of claim reconciliation publication event
    And   the PerformanceManagement.AtomFeed contains ItemType '0' events which conform to the Corporate Funding Claim Reconciliation Schema for the following claims
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017559 | 1819          | Year End         | AEB-LS1819          | 3                  |

    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    And   the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                         | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 
    | 10017559 | AEBL-559         | 1819   | Year End      | Adult Education Budget - Learner Support 18/19              | 26004.00     | 24926.69     | -577.31                     | -1000.00                 | 24926.69           | 500.00          | Other                 | 25426.69                 |




    # Change the date
    Given the override date is '27/06/2019'

    # Bulk import to amend contract AFTER publishing the FCR. (Increase planned value by £858 from £26,004 to £26,862)
    And   there are no files prefixed '10017559' in the Sharepoint 'AEB-1819-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1819 20052019081527 v3_A559_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1819 20052019081527 v3_A559_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1819 20052019081527 v3_A559_1.xlsx' exists in the Datafiles folder and UKPRN '10017559' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Change the date
    Given the override date is '28/06/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-559' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '3' actual MasterContractNumber 'ESFA-559' and actual ContractNumber 'AEBP-559'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-559' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017559 | AEBP-559           | 3                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017559 | AEBP-559           | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017559 | AEBP-559           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017559 | ESFA-559           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




	# Check CRM Financials

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-559       | AEBL-559        | 1               | 26862.00  | 3535.00  | 2991.00  | 1353.00  | 2027.00  | 2755.00  | 1487.00  | 991.00   | 5315.00  | 2553.00  | 2613.00  | 699.00   | 543.00   | 

    # Check the PROFILE PAYMENTS in CRM
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-559       | AEBL-559        | 1               | 25934.00  | 2195.00  | 3026.00  | 4535.00  | 1587.00  | 2131.00  | 2235.00  | 2907.00  | 891.00   | 520.00   | 2615.00  | 2749.00  | 543.00   | 

    # Check the BALANCING PAYMENTS in CRM
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-559       | AEBL-559        | 1               | 928.00    | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 928.00   | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-559       | AEBL-559        | 1               | 26862.00  | 2195.00  | 3026.00  | 4535.00  | 1587.00  | 2131.00  | 2235.00  | 2907.00  | 891.00   | 520.00   | 2615.00  | 2749.00  | 1471.00  | 





	# Check FCR values. Only the status should have changed
    And   group claim data is present in the CRM funding claim reconciliation tables as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | AdjustedCappedClaimValue | Status     |
    | 10017559 | 1819          | Year End         | AEB-LS1819          | 3                  | 26004.00     | 24926.69     | -577.31                     | -1000.00            | 24926.69         | 500.00          | 25426.69                 | Published  |

    And   allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017559 | 1819          | Year End         | AEB-LS1819          | AEBL-559      | 26004.00     | 24926.69     | -577.31                     | -1000.00            | 24926.69         | 500.00          | Other                 | 25426.69                 | 802.68           |




    # A second 'Amendment Approval' notification should not have been generated. 
   #And   there are '0' notifications of type 'Amendment Approval' owned by user 'FCS2 Test' which match the following
   #And   there is '1' notification of type 'Amendment Approval' owned by user 'FCS2 Test' which match the following
   #And   there is '1' notification of type 'Amendment Approval' owned by team 'Claim Editor Team' which matches the following
    And   there are '0' notifications of type 'Amendment Approval' owned by team 'Claim Editor Team' which match the following
    | Status | NotificationName                                                                   | NotificationText                                  |
    | New    | Amendment Approval-Allocation AEBL-559 - Adult Education Budget - Learner Support  | AEBL-559 v2 (10017559: 10017559 Co Ltd) approved  |
	


	# Tidy up
    And   the override date is reset

	 