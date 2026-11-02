Feature: Funding Claim Payment Calculation for Amendments Test


@FundingClaimPaymentCalculation
@DoNotRun_7Mar2024
Scenario: D539 Scenario 3a for Funding claim reconciliation (CL) Payment calculation when Receiving Claim, Publish Reconciliation, Approve Contract Amendment vary down to claim in same payment period

Given there is no payment schedule data for contract 'MAIN-9008' version '1'
And the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 10019008 | MAIN-9008      | CL-9008       | CL                | CL1516                  | AY                      | 01/08/2015          | 31/07/2016        | 

And the following deliverable payments information exists in the deliverable payments table

| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount |
| CL-9008          | 1             | 1               | 201508 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9008          | 1             | 1               | 201509 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9008          | 1             | 1               | 201510 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9008          | 1             | 1               | 201511 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9008          | 1             | 1               | 201512 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9008          | 1             | 1               | 201601 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9008          | 1             | 1               | 201602 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9008          | 1             | 1               | 201603 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9008          | 1             | 1               | 201604 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9008          | 1             | 1               | 201605 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9008          | 1             | 1               | 201606 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9008          | 1             | 1               | 201607 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |

																																										
And allocation data is present in the calculated funding claim reconciliations as follows
| UKPRN    | FundingPeriod | ClaimTypeName | AllocationRef | FundingStreamPeriodCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
| 10019008 | 1516          | Final         | CL-9008       | CL1516                  | 1000         | 1000         | 1000             | 0                           | 900                 |

And   the calculation date is '04/12/2016'	

And the following funding claims reconciliations are published 
| UKPRN    | FundingPeriod | ClaimTypeName | AllocationRef |
| 10019008 | 1516          | Final         | CL-9008       |

And the Deliverable Payments are as follows
| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount |
| CL-9008          | 1             | 1               | 201612 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 900                         | 900              |

And the override date is '04/12/2016'

When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16  | Feb-16  | Mar-16  | Apr-16  | May-16  | Jun-16  | Jul-16  |
 | MAIN-9008      | CL-9008       | 1               | 0                     | 100.00 | 100.00  | 100.00  | 100.00  | 100.00  | 100.00  | 100.00  | 100.00  | 50.00   | 50.00   | 50.00   | 0.00    |
 
Then the Deliverable Payments are as follows
| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount |
| CL-9008          | 2             | 1               | 201508 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9008          | 2             | 1               | 201509 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9008          | 2             | 1               | 201510 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9008          | 2             | 1               | 201511 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9008          | 2             | 1               | 201512 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9008          | 2             | 1               | 201601 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9008          | 2             | 1               | 201602 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9008          | 2             | 1               | 201603 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9008          | 2             | 1               | 201604 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9008          | 2             | 1               | 201605 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9008          | 2             | 1               | 201606 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9008          | 2             | 1               | 201607 | 2              | 0              | 0            | 50                   | 0                   | 0                      | 0                           | 50               |


@FundingClaimPaymentCalculation
@IntegrationTest 
Scenario: D541 Scenario 3b for Funding claim reconciliation (CL) Payment calculation when Receiving Claim,  Approve Contract Amendment vary down , Publish Reconciliation in subsequent payment period

Given there is no payment schedule data for contract 'MAIN-9009' version '1'
And the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 10019008 | MAIN-9009      | CL-9009       | CL                | CL1516                  | AY                      | 01/08/2015          | 31/07/2016        | 

And the following deliverable payments information exists in the deliverable payments table

| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount |
| CL-9009          | 1             | 1               | 201508 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201509 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201510 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201511 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201512 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201601 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201602 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201603 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201604 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9009          | 1             | 1               | 201605 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9009          | 1             | 1               | 201606 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9009          | 1             | 1               | 201607 | 2              | 0              | 0            | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9009          | 1             | 1               | 201612 | 2              | 0              | 0            | 0                    | 0                   | -50                    | 0                           | -50              |																																										

And allocation data is present in the calculated funding claim reconciliations as follows
| UKPRN    | FundingPeriod | ClaimTypeName | AllocationRef | FundingStreamPeriodCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
| 10019008 | 1516          | Final         | CL-9009       | CL1516                  | 1000         | 1000         | 1000             | 0                           | 900                 |

And the calculation date is '10/01/2017'

When  the following funding claims reconciliations are published 
| UKPRN    | FundingPeriod | ClaimTypeName | AllocationRef |
| 10019008 | 1516          | Final         | CL-9009       |

Then the Deliverable Payments are as follows
| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount |
| CL-9009          | 1             | 1               | 201508 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201509 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201510 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201511 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201512 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201601 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201602 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201603 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201604 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9009          | 1             | 1               | 201605 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9009          | 1             | 1               | 201606 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9009          | 1             | 1               | 201607 | 2              | 0              | 0            | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9009          | 1             | 1               | 201612 | 2              | 0              | 0            | 0                    | 0                   | -50                    | 0                           | -50              |																																										
| CL-9009          | 1             | 1               | 201702 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 900                         | 900              |

@FundingClaimPaymentCalculation
@Superseded
Scenario: D542 Scenario 3c for Funding claim reconciliation (CL) Payment calculation when Receiving Claim, Publish Reconciliation, Approve Contract Amendment keeping allocation planned values same as previous version in subsequent period

Given there is no payment schedule data for contract 'MAIN-9010' version '1'
And the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 10019010 | MAIN-9010      | CL-9010       | CL                | CL1516                  | AY                      | 01/08/2015          | 31/07/2016        | 

And the following deliverable payments information exists in the deliverable payments table

| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount |
| CL-9010          | 1             | 1               | 201508 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9010          | 1             | 1               | 201509 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9010          | 1             | 1               | 201510 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9010          | 1             | 1               | 201511 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9010          | 1             | 1               | 201512 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9010          | 1             | 1               | 201601 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9010          | 1             | 1               | 201602 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9010          | 1             | 1               | 201603 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9010          | 1             | 1               | 201604 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9010          | 1             | 1               | 201605 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9010          | 1             | 1               | 201606 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9010          | 1             | 1               | 201607 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |

																																										
And allocation data is present in the calculated funding claim reconciliations as follows
| UKPRN    | FundingPeriod | ClaimTypeName | AllocationRef | FundingStreamPeriodCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
| 10019010 | 1516          | Final         | CL-9010       | CL1516                  | 1000         | 1000         | 1000             | 0                           | 900                 |

And   the calculation date is '04/12/2016'	

And the following funding claims reconciliations are published 
| UKPRN    | FundingPeriod | ClaimTypeName | AllocationRef |
| 10019010 | 1516          | Final         | CL-9010       |

And the Deliverable Payments are as follows
| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount |
| CL-9010          | 1             | 1               | 201612 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 900                         | 900              |

And the override date is '10/01/2017'
#amended but no change in profile
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16  | Feb-16  | Mar-16  | Apr-16  | May-16  | Jun-16  | Jul-16  |
 | MAIN-9010      | CL-9010       | 1               | 0                     | 100.00 | 100.00  | 100.00  | 100.00  | 100.00  | 100.00  | 100.00  | 100.00  | 50.00   | 50.00   | 50.00   | 50.00   |
 
Then the Deliverable Payments are as follows
| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount |
| CL-9010          | 2             | 1               | 201508 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9010          | 2             | 1               | 201509 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9010          | 2             | 1               | 201510 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9010          | 2             | 1               | 201511 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9010          | 2             | 1               | 201512 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9010          | 2             | 1               | 201601 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9010          | 2             | 1               | 201602 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9010          | 2             | 1               | 201603 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9010          | 2             | 1               | 201604 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9010          | 2             | 1               | 201605 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9010          | 2             | 1               | 201606 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9010          | 2             | 1               | 201607 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9010          | 2             | 1               | 201612 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 900                         | 900              |
And the Deliverable Payments do not contain the following
| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | 
| CL-9010          | 2             | 1               | 201702 | 2              | 0              | 0            | 0                    | 0                   | 0                      | -900                        | -900             |


@FundingClaimPaymentCalculation
@Superseded
Scenario: D543 Scenario 3d for Funding claim reconciliation (CL) Payment calculation when Receiving Claim, Publish Reconciliation, Approve Contract Amendment keeping allocation planned values same as previous version in same period

Given there is no payment schedule data for contract 'MAIN-9011' version '1'
And the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 10019011 | MAIN-9011      | CL-9011       | CL                | CL1516                  | AY                      | 01/08/2015          | 31/07/2016        | 

And the following deliverable payments information exists in the deliverable payments table

| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount |
| CL-9011          | 1             | 1               | 201508 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9011          | 1             | 1               | 201509 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9011          | 1             | 1               | 201510 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9011          | 1             | 1               | 201511 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9011          | 1             | 1               | 201512 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9011          | 1             | 1               | 201601 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9011          | 1             | 1               | 201602 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9011          | 1             | 1               | 201603 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9011          | 1             | 1               | 201604 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9011          | 1             | 1               | 201605 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9011          | 1             | 1               | 201606 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9011          | 1             | 1               | 201607 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |

																																										
And allocation data is present in the calculated funding claim reconciliations as follows
| UKPRN    | FundingPeriod | ClaimTypeName | AllocationRef | FundingStreamPeriodCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
| 10019011 | 1516          | Final         | CL-9011       | CL1516                  | 1000         | 1000         | 1000             | 0                           | 900                 |

And   the calculation date is '04/12/2016'	

And the following funding claims reconciliations are published 
| UKPRN    | FundingPeriod | ClaimTypeName | AllocationRef |
| 10019011 | 1516          | Final         | CL-9011       |

And the Deliverable Payments are as follows
| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount |
| CL-9011          | 1             | 1               | 201612 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 900                         | 900              |

And the override date is '04/12/2016'
#amended but no change in profile
When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16  | Feb-16  | Mar-16  | Apr-16  | May-16  | Jun-16  | Jul-16  |
 | MAIN-9011      | CL-9011       | 1               | 0                     | 100.00 | 100.00  | 100.00  | 100.00  | 100.00  | 100.00  | 100.00  | 100.00  | 50.00   | 50.00   | 50.00   | 50.00   |
 
Then the Deliverable Payments are as follows
| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount |
| CL-9011          | 2             | 1               | 201508 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9011          | 2             | 1               | 201509 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9011          | 2             | 1               | 201510 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9011          | 2             | 1               | 201511 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9011          | 2             | 1               | 201512 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9011          | 2             | 1               | 201601 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9011          | 2             | 1               | 201602 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9011          | 2             | 1               | 201603 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9011          | 2             | 1               | 201604 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9011          | 2             | 1               | 201605 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9011          | 2             | 1               | 201606 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9011          | 2             | 1               | 201607 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9011          | 2             | 1               | 201612 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 900                         | 900              |
And the Deliverable Payments do not contain the following
| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | 
| CL-9011          | 2             | 1               | 201702 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |


@FundingClaimPaymentCalculation
@DoNotRun_7Mar2024
Scenario: D544 Scenario 6 Funding claim reconciliation Payment calculation when Receiving Claim, Publish Reconciliation, Approve Contract Amendment, vary up in subsequent payment period

Given there is no payment schedule data for contract 'MAIN-9009' version '1'
And the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 10019009 | MAIN-9009      | CL-9009       | CL                | CL1516                  | AY                      | 01/08/2015          | 31/07/2016        | 

And the following deliverable payments information exists in the deliverable payments table
| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount |
| CL-9009          | 1             | 1               | 201508 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201509 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201510 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201511 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201512 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201601 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201602 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201603 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 1             | 1               | 201604 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9009          | 1             | 1               | 201605 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9009          | 1             | 1               | 201606 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9009          | 1             | 1               | 201607 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |

																																										
And allocation data is present in the calculated funding claim reconciliations as follows
| UKPRN    | FundingPeriod | ClaimTypeName | AllocationRef | FundingStreamPeriodCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
| 10019009 | 1516          | Final         | CL-9009       | CL1516                  | 1000         | 1000         | 1000             | 0                           | 1001                |

And   the calculation date is '04/12/2016'	

And the following funding claims reconciliations are published 
| UKPRN    | FundingPeriod | ClaimTypeName | AllocationRef |
| 10019009 | 1516          | Final         | CL-9009       |

And the Deliverable Payments are as follows
| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount |
| CL-9009          | 1             | 1               | 201612 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 1001                        | 1001             |

And the override date is '04/01/2017'

When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16  | Feb-16  | Mar-16  | Apr-16  | May-16  | Jun-16  | Jul-16  |
 | MAIN-9009      | CL-9009       | 1               | 0                     | 100.00 | 100.00  | 100.00  | 100.00  | 100.00  | 100.00  | 100.00  | 100.00  | 50.00   | 50.00   | 51.00   | 50.00   |
 
Then the Deliverable Payments are as follows
| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount |
| CL-9009          | 2             | 1               | 201508 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 2             | 1               | 201509 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 2             | 1               | 201510 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 2             | 1               | 201511 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 2             | 1               | 201512 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 2             | 1               | 201601 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 2             | 1               | 201602 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 2             | 1               | 201603 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9009          | 2             | 1               | 201604 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9009          | 2             | 1               | 201605 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9009          | 2             | 1               | 201606 | 2              | 0              | 51           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9009          | 2             | 1               | 201607 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9009          | 2             | 1               | 201612 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 1001                        | 1001             |

@FundingClaimPaymentCalculation
@DoNotRun_7Mar2024
Scenario: D540 Scenario 3a for Funding claim reconciliation Payment calculation (ALLC, ASC, CL, DLS) when Receiving Claim, Publish Reconciliation, Approve Contract Amendment varying down to claim in same payment period

Given there is no payment schedule data for contract 'MAIN-9007' version '1'
And the approved contract allocations details for the latest version of the contract are as follows
 | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | 
 | 10019007 | MAIN-9007      | ALLC-9007     | 24+ ALLBC         | 24+ALLBC1516            | AY                      | 01/08/2015          | 31/07/2016        | 
 | 10019007 | MAIN-9007      | ASC-9007      | ASC               | ASC1516                 | AY                      | 01/08/2015          | 31/07/2016        | 
 | 10019007 | MAIN-9007      | DLS-9007      | DLS               | DLS1516                 | AY                      | 01/08/2015          | 31/07/2016        | 
 | 10019007 | MAIN-9007      | CL-9007       | CL                | CL1516                  | AY                      | 01/08/2015          | 31/07/2016        | 

And the following deliverable payments information exists in the deliverable payments table

| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount |
| ALLC-9007        | 1             | 1               | 201508 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| ALLC-9007        | 1             | 1               | 201509 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| ALLC-9007        | 1             | 1               | 201510 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| ALLC-9007        | 1             | 1               | 201511 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| ALLC-9007        | 1             | 1               | 201512 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| ALLC-9007        | 1             | 1               | 201601 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| ALLC-9007        | 1             | 1               | 201602 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| ALLC-9007        | 1             | 1               | 201603 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| ALLC-9007        | 1             | 1               | 201604 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| ALLC-9007        | 1             | 1               | 201605 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| ALLC-9007        | 1             | 1               | 201606 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| ALLC-9007        | 1             | 1               | 201607 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| ALLC-9007        | 1             | 2               | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 2               | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 2               | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 2               | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 2               | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 2               | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 2               | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 2               | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 2               | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 2               | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 2               | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 2               | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 3               | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 3               | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 3               | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 3               | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 3               | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 3               | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 3               | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 3               | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 3               | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 3               | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 3               | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 3               | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 4               | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 4               | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 4               | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 4               | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 4               | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 4               | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 4               | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 4               | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 4               | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 4               | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 4               | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ALLC-9007        | 1             | 4               | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 1               | 201508 | 2              | 0              | 200          | 200                  | 0                   | 0                      | 0                           | 200              |
| ASC-9007         | 1             | 1               | 201509 | 2              | 0              | 200          | 200                  | 0                   | 0                      | 0                           | 200              |
| ASC-9007         | 1             | 1               | 201510 | 2              | 0              | 200          | 200                  | 0                   | 0                      | 0                           | 200              |
| ASC-9007         | 1             | 1               | 201511 | 2              | 0              | 200          | 200                  | 0                   | 0                      | 0                           | 200              |
| ASC-9007         | 1             | 1               | 201512 | 2              | 0              | 200          | 200                  | 0                   | 0                      | 0                           | 200              |
| ASC-9007         | 1             | 1               | 201601 | 2              | 0              | 200          | 200                  | 0                   | 0                      | 0                           | 200              |
| ASC-9007         | 1             | 1               | 201602 | 2              | 0              | 300          | 300                  | 0                   | 0                      | 0                           | 300              |
| ASC-9007         | 1             | 1               | 201603 | 2              | 0              | 300          | 300                  | 0                   | 0                      | 0                           | 300              |
| ASC-9007         | 1             | 1               | 201604 | 2              | 0              | 300          | 300                  | 0                   | 0                      | 0                           | 300              |
| ASC-9007         | 1             | 1               | 201605 | 2              | 0              | 300          | 300                  | 0                   | 0                      | 0                           | 300              |
| ASC-9007         | 1             | 1               | 201606 | 2              | 0              | 300          | 300                  | 0                   | 0                      | 0                           | 300              |
| ASC-9007         | 1             | 1               | 201607 | 2              | 0              | 300          | 300                  | 0                   | 0                      | 0                           | 300              |
| ASC-9007         | 1             | 2               | 201508 | 2              | 0              | 90           | 90                   | 0                   | 0                      | 0                           | 90               |
| ASC-9007         | 1             | 2               | 201509 | 2              | 0              | 90           | 90                   | 0                   | 0                      | 0                           | 90               |
| ASC-9007         | 1             | 2               | 201510 | 2              | 0              | 90           | 90                   | 0                   | 0                      | 0                           | 90               |
| ASC-9007         | 1             | 2               | 201511 | 2              | 0              | 90           | 90                   | 0                   | 0                      | 0                           | 90               |
| ASC-9007         | 1             | 2               | 201512 | 2              | 0              | 90           | 90                   | 0                   | 0                      | 0                           | 90               |
| ASC-9007         | 1             | 2               | 201601 | 2              | 0              | 90           | 90                   | 0                   | 0                      | 0                           | 90               |
| ASC-9007         | 1             | 2               | 201602 | 2              | 0              | 130          | 130                  | 0                   | 0                      | 0                           | 130              |
| ASC-9007         | 1             | 2               | 201603 | 2              | 0              | 130          | 130                  | 0                   | 0                      | 0                           | 130              |
| ASC-9007         | 1             | 2               | 201604 | 2              | 0              | 130          | 130                  | 0                   | 0                      | 0                           | 130              |
| ASC-9007         | 1             | 2               | 201605 | 2              | 0              | 130          | 130                  | 0                   | 0                      | 0                           | 130              |
| ASC-9007         | 1             | 2               | 201606 | 2              | 0              | 130          | 130                  | 0                   | 0                      | 0                           | 130              |
| ASC-9007         | 1             | 2               | 201607 | 2              | 0              | 130          | 130                  | 0                   | 0                      | 0                           | 130              |
| ASC-9007         | 1             | 3               | 201508 | 2              | 0              | 110          | 110                  | 0                   | 0                      | 0                           | 110              |
| ASC-9007         | 1             | 3               | 201509 | 2              | 0              | 110          | 110                  | 0                   | 0                      | 0                           | 110              |
| ASC-9007         | 1             | 3               | 201510 | 2              | 0              | 110          | 110                  | 0                   | 0                      | 0                           | 110              |
| ASC-9007         | 1             | 3               | 201511 | 2              | 0              | 110          | 110                  | 0                   | 0                      | 0                           | 110              |
| ASC-9007         | 1             | 3               | 201512 | 2              | 0              | 110          | 110                  | 0                   | 0                      | 0                           | 110              |
| ASC-9007         | 1             | 3               | 201601 | 2              | 0              | 110          | 110                  | 0                   | 0                      | 0                           | 110              |
| ASC-9007         | 1             | 3               | 201602 | 2              | 0              | 170          | 170                  | 0                   | 0                      | 0                           | 170              |
| ASC-9007         | 1             | 3               | 201603 | 2              | 0              | 170          | 170                  | 0                   | 0                      | 0                           | 170              |
| ASC-9007         | 1             | 3               | 201604 | 2              | 0              | 170          | 170                  | 0                   | 0                      | 0                           | 170              |
| ASC-9007         | 1             | 3               | 201605 | 2              | 0              | 170          | 170                  | 0                   | 0                      | 0                           | 170              |
| ASC-9007         | 1             | 3               | 201606 | 2              | 0              | 170          | 170                  | 0                   | 0                      | 0                           | 170              |
| ASC-9007         | 1             | 3               | 201607 | 2              | 0              | 170          | 170                  | 0                   | 0                      | 0                           | 170              |
| ASC-9007         | 1             | 4               | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 4               | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 4               | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 4               | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 4               | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 4               | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 4               | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 4               | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 4               | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 4               | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 4               | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 4               | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 5               | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 5               | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 5               | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 5               | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 5               | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 5               | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 5               | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 5               | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 5               | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 5               | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 5               | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 5               | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 6               | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 6               | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 6               | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 6               | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 6               | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 6               | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 6               | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 6               | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 6               | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 6               | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 6               | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 6               | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 7               | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 7               | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 7               | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 7               | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 7               | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 7               | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 7               | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 7               | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 7               | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 7               | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 7               | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 7               | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 8               | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 8               | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 8               | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 8               | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 8               | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 8               | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 8               | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 8               | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 8               | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 8               | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 8               | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 8               | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 9               | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 9               | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 9               | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 9               | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 9               | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 9               | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 9               | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 9               | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 9               | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 9               | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 9               | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 9               | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 10              | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 10              | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 10              | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 10              | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 10              | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 10              | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 10              | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 10              | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 10              | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 10              | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 10              | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 10              | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 11              | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 11              | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 11              | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 11              | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 11              | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 11              | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 11              | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 11              | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 11              | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 11              | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 11              | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 11              | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 12              | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 12              | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 12              | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 12              | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 12              | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 12              | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 12              | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 12              | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 12              | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 12              | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 12              | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 12              | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 13              | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 13              | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 13              | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 13              | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 13              | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 13              | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 13              | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 13              | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 13              | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 13              | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 13              | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 13              | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 14              | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 14              | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 14              | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 14              | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 14              | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 14              | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 14              | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 14              | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 14              | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 14              | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 14              | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 14              | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 15              | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 15              | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 15              | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 15              | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 15              | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 15              | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 15              | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 15              | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 15              | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 15              | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 15              | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 15              | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 16              | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 16              | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 16              | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 16              | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 16              | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 16              | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 16              | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 16              | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 16              | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 16              | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 16              | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 16              | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 17              | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 17              | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 17              | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 17              | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 17              | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 17              | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 17              | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 17              | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 17              | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 17              | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 17              | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 17              | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 18              | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 18              | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 18              | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 18              | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 18              | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 18              | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 18              | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 18              | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 18              | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 18              | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 18              | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 18              | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 19              | 201508 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 19              | 201509 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 19              | 201510 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 19              | 201511 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 19              | 201512 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 19              | 201601 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 19              | 201602 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 19              | 201603 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 19              | 201604 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 19              | 201605 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 19              | 201606 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| ASC-9007         | 1             | 19              | 201607 | 2              | 0              | 0            | 0                    | 0                   | 0                      | 0                           | 0                |
| CL-9007          | 1             | 1               | 201508 | 2              | 0              | 100          | 100                  | 0                   | 0                     | 0                           | 100              |
| CL-9007          | 1             | 1               | 201509 | 2              | 0              | 100          | 100                  | 0                   | 0                     | 0                           | 100              |
| CL-9007          | 1             | 1               | 201510 | 2              | 0              | 100          | 100                  | 0                   | 0                     | 0                           | 100              |
| CL-9007          | 1             | 1               | 201511 | 2              | 0              | 100          | 100                  | 0                   | 0                     | 0                           | 100              |
| CL-9007          | 1             | 1               | 201512 | 2              | 0              | 100          | 100                  | 0                   | 0                     | 0                           | 100              |
| CL-9007          | 1             | 1               | 201601 | 2              | 0              | 100          | 100                  | 0                   | 0                     | 0                           | 100              |
| CL-9007          | 1             | 1               | 201602 | 2              | 0              | 100          | 100                  | 0                   | 0                     | 0                           | 100              |
| CL-9007          | 1             | 1               | 201603 | 2              | 0              | 100          | 100                  | 0                   | 0                     | 0                           | 100              |
| CL-9007          | 1             | 1               | 201604 | 2              | 0              | 50           | 50                   | 0                   | 0                     | 0                           | 50               |
| CL-9007          | 1             | 1               | 201605 | 2              | 0              | 50           | 50                   | 0                   | 0                     | 0                           | 50               |
| CL-9007          | 1             | 1               | 201606 | 2              | 0              | 50           | 50                   | 0                   | 0                     | 0                           | 50               |
| CL-9007          | 1             | 1               | 201607 | 2              | 0              | 50           | 50                   | 0                   | 0                     | 0                           | 50               |
| DLS-9007         | 1             | 1               | 201508 | 2              | 0              | 150          | 150                  | 0                   | 0                     | 0                           | 150              |
| DLS-9007         | 1             | 1               | 201509 | 2              | 0              | 150          | 150                  | 0                   | 0                     | 0                           | 150              |
| DLS-9007         | 1             | 1               | 201510 | 2              | 0              | 150          | 150                  | 0                   | 0                     | 0                           | 150              |
| DLS-9007         | 1             | 1               | 201511 | 2              | 0              | 150          | 150                  | 0                   | 0                     | 0                           | 150              |
| DLS-9007         | 1             | 1               | 201512 | 2              | 0              | 150          | 150                  | 0                   | 0                     | 0                           | 150              |
| DLS-9007         | 1             | 1               | 201601 | 2              | 0              | 150          | 150                  | 0                   | 0                     | 0                           | 150              |
| DLS-9007         | 1             | 1               | 201602 | 2              | 0              | 150          | 150                  | 0                   | 0                     | 0                           | 150              |
| DLS-9007         | 1             | 1               | 201603 | 2              | 0              | 150          | 150                  | 0                   | 0                     | 0                           | 150              |
| DLS-9007         | 1             | 1               | 201604 | 2              | 0              | 150          | 150                  | 0                   | 0                     | 0                           | 150              |
| DLS-9007         | 1             | 1               | 201605 | 2              | 0              | 150          | 150                  | 0                   | 0                     | 0                           | 150              |
| DLS-9007         | 1             | 1               | 201606 | 2              | 0              | 150          | 150                  | 0                   | 0                     | 0                           | 150              |
| DLS-9007         | 1             | 1               | 201607 | 2              | 0              | 350          | 350                  | 0                   | 0                     | 0                           | 350              |
| DLS-9007         | 1             | 2               | 201508 | 2              | 0              | 50           | 50                   | 0                   | 0                     | 0                           | 50               |
| DLS-9007         | 1             | 2               | 201509 | 2              | 0              | 50           | 50                   | 0                   | 0                     | 0                           | 50               |
| DLS-9007         | 1             | 2               | 201510 | 2              | 0              | 50           | 50                   | 0                   | 0                     | 0                           | 50               |
| DLS-9007         | 1             | 2               | 201511 | 2              | 0              | 50           | 50                   | 0                   | 0                     | 0                           | 50               |
| DLS-9007         | 1             | 2               | 201512 | 2              | 0              | 50           | 50                   | 0                   | 0                     | 0                           | 50               |
| DLS-9007         | 1             | 2               | 201601 | 2              | 0              | 50           | 50                   | 0                   | 0                     | 0                           | 50               |
| DLS-9007         | 1             | 2               | 201602 | 2              | 0              | 50           | 50                   | 0                   | 0                     | 0                           | 50               |
| DLS-9007         | 1             | 2               | 201603 | 2              | 0              | 50           | 50                   | 0                   | 0                     | 0                           | 50               |
| DLS-9007         | 1             | 2               | 201604 | 2              | 0              | 50           | 50                   | 0                   | 0                     | 0                           | 50               |
| DLS-9007         | 1             | 2               | 201605 | 2              | 0              | 50           | 50                   | 0                   | 0                     | 0                           | 50               |
| DLS-9007         | 1             | 2               | 201606 | 2              | 0              | 50           | 50                   | 0                   | 0                     | 0                           | 50               |
| DLS-9007         | 1             | 2               | 201607 | 2              | 0              | 100          | 100                  | 0                   | 0                     | 0                           | 100              |
| DLS-9007         | 1             | 3               | 201508 | 2              | 0              | 20           | 20                   | 0                   | 0                     | 0                           | 20               |
| DLS-9007         | 1             | 3               | 201509 | 2              | 0              | 20           | 20                   | 0                   | 0                     | 0                           | 20               |
| DLS-9007         | 1             | 3               | 201510 | 2              | 0              | 20           | 20                   | 0                   | 0                     | 0                           | 20               |
| DLS-9007         | 1             | 3               | 201511 | 2              | 0              | 20           | 20                   | 0                   | 0                     | 0                           | 20               |
| DLS-9007         | 1             | 3               | 201512 | 2              | 0              | 20           | 20                   | 0                   | 0                     | 0                           | 20               |
| DLS-9007         | 1             | 3               | 201601 | 2              | 0              | 20           | 20                   | 0                   | 0                     | 0                           | 20               |
| DLS-9007         | 1             | 3               | 201602 | 2              | 0              | 20           | 20                   | 0                   | 0                     | 0                           | 20               |
| DLS-9007         | 1             | 3               | 201603 | 2              | 0              | 20           | 20                   | 0                   | 0                     | 0                           | 20               |
| DLS-9007         | 1             | 3               | 201604 | 2              | 0              | 20           | 20                   | 0                   | 0                     | 0                           | 20               |
| DLS-9007         | 1             | 3               | 201605 | 2              | 0              | 20           | 20                   | 0                   | 0                     | 0                           | 20               |
| DLS-9007         | 1             | 3               | 201606 | 2              | 0              | 20           | 20                   | 0                   | 0                     | 0                           | 20               |
| DLS-9007         | 1             | 3               | 201607 | 2              | 0              | 20           | 20                   | 0                   | 0                     | 0                           | 20               |
| DLS-9007         | 1             | 4               | 201508 | 2              | 0              | 80           | 80                   | 0                   | 0                     | 0                           | 80               |
| DLS-9007         | 1             | 4               | 201509 | 2              | 0              | 80           | 80                   | 0                   | 0                     | 0                           | 80               |
| DLS-9007         | 1             | 4               | 201510 | 2              | 0              | 80           | 80                   | 0                   | 0                     | 0                           | 80               |
| DLS-9007         | 1             | 4               | 201511 | 2              | 0              | 80           | 80                   | 0                   | 0                     | 0                           | 80               |
| DLS-9007         | 1             | 4               | 201512 | 2              | 0              | 80           | 80                   | 0                   | 0                     | 0                           | 80               |
| DLS-9007         | 1             | 4               | 201601 | 2              | 0              | 80           | 80                   | 0                   | 0                     | 0                           | 80               |
| DLS-9007         | 1             | 4               | 201602 | 2              | 0              | 80           | 80                   | 0                   | 0                     | 0                           | 80               |
| DLS-9007         | 1             | 4               | 201603 | 2              | 0              | 80           | 80                   | 0                   | 0                     | 0                           | 80               |
| DLS-9007         | 1             | 4               | 201604 | 2              | 0              | 80           | 80                   | 0                   | 0                     | 0                           | 80               |
| DLS-9007         | 1             | 4               | 201605 | 2              | 0              | 80           | 80                   | 0                   | 0                     | 0                           | 80               |
| DLS-9007         | 1             | 4               | 201606 | 2              | 0              | 80           | 80                   | 0                   | 0                     | 0                           | 80               |
| DLS-9007         | 1             | 4               | 201607 | 2              | 0              | 230          | 230                  | 0                   | 0                     | 0                           | 230              |

																																										
And allocation data is present in the calculated funding claim reconciliations as follows
| UKPRN    | FundingPeriod | ClaimTypeName | AllocationRef | FundingStreamPeriodCode | PlannedValue | ClaimedValue | CappedClaimValue | ProposedReconciliationValue | ReconciliationValue |
| 10019007 | 1516          | Final         | CL-9007       | CL1516                  | 1000         | 1000         | 1000             | 0                           | -900                |
| 10019007 | 1516          | Final         | ALLC-9007     | 24+ALLBC1516            | 1000         | 3000         | 3000             | 0                           | -950                |
| 10019007 | 1516          | Final         | ASC-9007      | ASC1516                 | 3000         | 3000         | 3000             | 0                           | -1001               |
| 10019007 | 1516          | Final         | DLS-9007      | DLS1516                 | 2000         | 3000         | 3000             | 0                           | -1001               | 

And   the calculation date is '04/12/2016'	

And the following funding claims reconciliations are published 
| UKPRN    | FundingPeriod | ClaimTypeName | AllocationRef |
| 10019007 | 1516          | Final         | CL-9007       |
| 10019007 | 1516          | Final         | ALLC-9007     |
| 10019007 | 1516          | Final         | ASC-9007      |
| 10019007 | 1516          | Final         | DLS-9007      |

And the Deliverable Payments are as follows
| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount |
| ALLC-9007        | 1             | 1               | 201612 | 2              | 0              | 0            | 0                    | 0                   | 0                      | -950                        | -950             |
| ASC-9007         | 1             | 2               | 201612 | 2              | 0              | 0            | 0                    | 0                   | 0                      | -440.44                     | -440.44          |
| ASC-9007         | 1             | 3               | 201612 | 2              | 0              | 0            | 0                    | 0                   | 0                      | -560.56                     | -560.56          |
| CL-9007          | 1             | 1               | 201612 | 2              | 0              | 0            | 0                    | 0                   | 0                      | -900                        | -900             |
| DLS-9007         | 1             | 2               | 201612 | 2              | 0              | 0            | 0                    | 0                   | 0                      | -325.32                     | -325.32          |
| DLS-9007         | 1             | 3               | 201612 | 2              | 0              | 0            | 0                    | 0                   | 0                      | -120.12                     | -120.12          |
| DLS-9007         | 1             | 4               | 201612 | 2              | 0              | 0            | 0                    | 0                   | 0                      | -555.56                     | -555.56          | 

And the override date is '04/12/2016'

When the contract is amended as follows
 | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15  | Oct-15  | Nov-15  | Dec-15  | Jan-16  | Feb-16  | Mar-16  | Apr-16  | May-16  | Jun-16  | Jul-16  |
 | MAIN-9007      | ALLC-9007     | 1               | 0                     | 100.00 | 100.00  | 100.00  | 100.00  | 100.00  | 100.00  | 100.00  | 50.00   | 50.00   | 50.00   | 50.00   | 50.00   |
 | MAIN-9007      | ASC-9007      | 1               | 0                     | 180.00 | 180.00  | 160.00  | 160.00  | 160.00  | 160.00  | 180.00  | 180.00  | 180.00  | 180.00  | 180.00  | 99.00   |
 | MAIN-9007      | ASC-9007      | 2               | 1                     | 70.00  | 70.00   | 70.00   | 70.00   | 70.00   | 70.00   | 80.00   | 80.00   | 80.00   | 80.00   | 80.00   | 55.85   |
 | MAIN-9007      | ASC-9007      | 3               | 1                     | 110.00 | 110.00  | 90.00   | 90.00   | 90.00   | 90.00   | 100.00  | 100.00  | 100.00  | 100.00  | 100.00  | 43.15   |
 | MAIN-9007      | CL-9007       | 1               | 0                     | 100.00 | 100.00  | 100.00  | 100.00  | 100.00  | 100.00  | 100.00  | 50.00   | 50.00   | 50.00   | 50.00   | 50.00   |
 | MAIN-9007      | DLS-9007      | 1               | 0                     | 74.00  | 75.00   | 75.00   | 75.00   | 75.00   | 75.00   | 75.00   | 75.00   | 75.00   | 75.00   | 75.00   | 175.00  |
 | MAIN-9007      | DLS-9007      | 2               | 1                     | 24.00  | 25.00   | 25.00   | 25.00   | 25.00   | 25.00   | 25.00   | 25.00   | 25.00   | 25.00   | 25.00   | 50.00   |
 | MAIN-9007      | DLS-9007      | 3               | 1                     | 10.00  | 10.00   | 10.00   | 10.00   | 10.00   | 10.00   | 10.00   | 10.00   | 10.00   | 10.00   | 10.00   | 10.00   |
 | MAIN-9007      | DLS-9007      | 4               | 1                     | 40.00  | 40.00   | 40.00   | 40.00   | 40.00   | 40.00   | 40.00   | 40.00   | 40.00   | 40.00   | 40.00   | 115.00  |

Then the Deliverable Payments are as follows
| AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolumne | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount |
| ALLC-9007        | 2             | 1               | 201508 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| ALLC-9007        | 2             | 1               | 201509 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| ALLC-9007        | 2             | 1               | 201510 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| ALLC-9007        | 2             | 1               | 201511 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| ALLC-9007        | 2             | 1               | 201512 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| ALLC-9007        | 2             | 1               | 201601 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| ALLC-9007        | 2             | 1               | 201602 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| ALLC-9007        | 2             | 1               | 201603 | 2              | 0              | 50           | 100                  | 0                   | 0                      | 0                           | 100              |
| ALLC-9007        | 2             | 1               | 201604 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| ALLC-9007        | 2             | 1               | 201605 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| ALLC-9007        | 2             | 1               | 201606 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| ALLC-9007        | 2             | 1               | 201607 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| ASC-9007         | 2             | 2               | 201508 | 2              | 0              | 70           | 90                   | 0                   | 0                      | 0                           | 90               |
| ASC-9007         | 2             | 2               | 201509 | 2              | 0              | 70           | 90                   | 0                   | 0                      | 0                           | 90               |
| ASC-9007         | 2             | 2               | 201510 | 2              | 0              | 70           | 90                   | 0                   | 0                      | 0                           | 90               |
| ASC-9007         | 2             | 2               | 201511 | 2              | 0              | 70           | 90                   | 0                   | 0                      | 0                           | 90               |
| ASC-9007         | 2             | 2               | 201512 | 2              | 0              | 70           | 90                   | 0                   | 0                      | 0                           | 90               |
| ASC-9007         | 2             | 2               | 201601 | 2              | 0              | 70           | 90                   | 0                   | 0                      | 0                           | 90               |
| ASC-9007         | 2             | 2               | 201602 | 2              | 0              | 80           | 130                  | 0                   | 0                      | 0                           | 130              |
| ASC-9007         | 2             | 2               | 201603 | 2              | 0              | 80           | 130                  | 0                   | 0                      | 0                           | 130              |
| ASC-9007         | 2             | 2               | 201604 | 2              | 0              | 80           | 130                  | 0                   | 0                      | 0                           | 130              |
| ASC-9007         | 2             | 2               | 201605 | 2              | 0              | 80           | 130                  | 0                   | 0                      | 0                           | 130              |
| ASC-9007         | 2             | 2               | 201606 | 2              | 0              | 80           | 130                  | 0                   | 0                      | 0                           | 130              |
| ASC-9007         | 2             | 2               | 201607 | 2              | 0              | 55.85        | 130                  | 0                   | 0                      | 0                           | 130              |
| ASC-9007         | 2             | 3               | 201508 | 2              | 0              | 110          | 110                  | 0                   | 0                      | 0                           | 110              |
| ASC-9007         | 2             | 3               | 201509 | 2              | 0              | 110          | 110                  | 0                   | 0                      | 0                           | 110              |
| ASC-9007         | 2             | 3               | 201510 | 2              | 0              | 90           | 110                  | 0                   | 0                      | 0                           | 110              |
| ASC-9007         | 2             | 3               | 201511 | 2              | 0              | 90           | 110                  | 0                   | 0                      | 0                           | 110              |
| ASC-9007         | 2             | 3               | 201512 | 2              | 0              | 90           | 110                  | 0                   | 0                      | 0                           | 110              |
| ASC-9007         | 2             | 3               | 201601 | 2              | 0              | 90           | 110                  | 0                   | 0                      | 0                           | 110              |
| ASC-9007         | 2             | 3               | 201602 | 2              | 0              | 100          | 170                  | 0                   | 0                      | 0                           | 170              |
| ASC-9007         | 2             | 3               | 201603 | 2              | 0              | 100          | 170                  | 0                   | 0                      | 0                           | 170              |
| ASC-9007         | 2             | 3               | 201604 | 2              | 0              | 100          | 170                  | 0                   | 0                      | 0                           | 170              |
| ASC-9007         | 2             | 3               | 201605 | 2              | 0              | 100          | 170                  | 0                   | 0                      | 0                           | 170              |
| ASC-9007         | 2             | 3               | 201606 | 2              | 0              | 100          | 170                  | 0                   | 0                      | 0                           | 170              |
| ASC-9007         | 2             | 3               | 201607 | 2              | 0              | 43.15        | 170                  | 0                   | 0                      | 0                           | 170              |
| CL-9007          | 2             | 1               | 201508 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9007          | 2             | 1               | 201509 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9007          | 2             | 1               | 201510 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9007          | 2             | 1               | 201511 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9007          | 2             | 1               | 201512 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9007          | 2             | 1               | 201601 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9007          | 2             | 1               | 201602 | 2              | 0              | 100          | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9007          | 2             | 1               | 201603 | 2              | 0              | 50           | 100                  | 0                   | 0                      | 0                           | 100              |
| CL-9007          | 2             | 1               | 201604 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9007          | 2             | 1               | 201605 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9007          | 2             | 1               | 201606 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| CL-9007          | 2             | 1               | 201607 | 2              | 0              | 50           | 50                   | 0                   | 0                      | 0                           | 50               |
| DLS-9007         | 2             | 2               | 201508 | 2              | 0              | 24           | 50                   | 0                   | 0                      | 0                           | 50               |
| DLS-9007         | 2             | 2               | 201509 | 2              | 0              | 25           | 50                   | 0                   | 0                      | 0                           | 50               |
| DLS-9007         | 2             | 2               | 201510 | 2              | 0              | 25           | 50                   | 0                   | 0                      | 0                           | 50               |
| DLS-9007         | 2             | 2               | 201511 | 2              | 0              | 25           | 50                   | 0                   | 0                      | 0                           | 50               |
| DLS-9007         | 2             | 2               | 201512 | 2              | 0              | 25           | 50                   | 0                   | 0                      | 0                           | 50               |
| DLS-9007         | 2             | 2               | 201601 | 2              | 0              | 25           | 50                   | 0                   | 0                      | 0                           | 50               |
| DLS-9007         | 2             | 2               | 201602 | 2              | 0              | 25           | 50                   | 0                   | 0                      | 0                           | 50               |
| DLS-9007         | 2             | 2               | 201603 | 2              | 0              | 25           | 50                   | 0                   | 0                      | 0                           | 50               |
| DLS-9007         | 2             | 2               | 201604 | 2              | 0              | 25           | 50                   | 0                   | 0                      | 0                           | 50               |
| DLS-9007         | 2             | 2               | 201605 | 2              | 0              | 25           | 50                   | 0                   | 0                      | 0                           | 50               |
| DLS-9007         | 2             | 2               | 201606 | 2              | 0              | 25           | 50                   | 0                   | 0                      | 0                           | 50               |
| DLS-9007         | 2             | 2               | 201607 | 2              | 0              | 50           | 100                  | 0                   | 0                      | 0                           | 100              |
| DLS-9007         | 2             | 3               | 201508 | 2              | 0              | 10           | 20                   | 0                   | 0                      | 0                           | 20               |
| DLS-9007         | 2             | 3               | 201509 | 2              | 0              | 10           | 20                   | 0                   | 0                      | 0                           | 20               |
| DLS-9007         | 2             | 3               | 201510 | 2              | 0              | 10           | 20                   | 0                   | 0                      | 0                           | 20               |
| DLS-9007         | 2             | 3               | 201511 | 2              | 0              | 10           | 20                   | 0                   | 0                      | 0                           | 20               |
| DLS-9007         | 2             | 3               | 201512 | 2              | 0              | 10           | 20                   | 0                   | 0                      | 0                           | 20               |
| DLS-9007         | 2             | 3               | 201601 | 2              | 0              | 10           | 20                   | 0                   | 0                      | 0                           | 20               |
| DLS-9007         | 2             | 3               | 201602 | 2              | 0              | 10           | 20                   | 0                   | 0                      | 0                           | 20               |
| DLS-9007         | 2             | 3               | 201603 | 2              | 0              | 10           | 20                   | 0                   | 0                      | 0                           | 20               |
| DLS-9007         | 2             | 3               | 201604 | 2              | 0              | 10           | 20                   | 0                   | 0                      | 0                           | 20               |
| DLS-9007         | 2             | 3               | 201605 | 2              | 0              | 10           | 20                   | 0                   | 0                      | 0                           | 20               |
| DLS-9007         | 2             | 3               | 201606 | 2              | 0              | 10           | 20                   | 0                   | 0                      | 0                           | 20               |
| DLS-9007         | 2             | 3               | 201607 | 2              | 0              | 10           | 20                   | 0                   | 0                      | 0                           | 20               |
| DLS-9007         | 2             | 4               | 201508 | 2              | 0              | 40           | 80                   | 0                   | 0                      | 0                           | 80               |
| DLS-9007         | 2             | 4               | 201509 | 2              | 0              | 40           | 80                   | 0                   | 0                      | 0                           | 80               |
| DLS-9007         | 2             | 4               | 201510 | 2              | 0              | 40           | 80                   | 0                   | 0                      | 0                           | 80               |
| DLS-9007         | 2             | 4               | 201511 | 2              | 0              | 40           | 80                   | 0                   | 0                      | 0                           | 80               |
| DLS-9007         | 2             | 4               | 201512 | 2              | 0              | 40           | 80                   | 0                   | 0                      | 0                           | 80               |
| DLS-9007         | 2             | 4               | 201601 | 2              | 0              | 40           | 80                   | 0                   | 0                      | 0                           | 80               |
| DLS-9007         | 2             | 4               | 201602 | 2              | 0              | 40           | 80                   | 0                   | 0                      | 0                           | 80               |
| DLS-9007         | 2             | 4               | 201603 | 2              | 0              | 40           | 80                   | 0                   | 0                      | 0                           | 80               |
| DLS-9007         | 2             | 4               | 201604 | 2              | 0              | 40           | 80                   | 0                   | 0                      | 0                           | 80               |
| DLS-9007         | 2             | 4               | 201605 | 2              | 0              | 40           | 80                   | 0                   | 0                      | 0                           | 80               |
| DLS-9007         | 2             | 4               | 201606 | 2              | 0              | 40           | 80                   | 0                   | 0                      | 0                           | 80               |
| DLS-9007         | 2             | 4               | 201607 | 2              | 0              | 115          | 230                  | 0                   | 0                      | 0                           | 230              |
