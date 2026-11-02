@#Feature6323_Retain_Actuals_Audit_Trail_(6323)
@RetainActualsAuditTrail
Feature: RetainActualsAuditTrail
	As an Allocations Manager, I want to retain the Actuals position at month end 
	after all processing jobs have completed, so that I can provide a picture of the 
	actuals to wider stakeholders (including audit, and the P&P report) if required 
	without having to manually calculate the position.

# Test coverage provided by B005/B006 now added to A765

@AcceptanceTest @Superceded
@RetainActualsAuditTrail
Scenario: B005 Confirm Actuals Audit Trail is stored correctly
Given there is no Contract, Task or Workflow data for UKPRN '10017499' 
And An approved contract 'Main-17499' for Ukprn '10017499' with Allocation '16AP-17499' exists in Dynamics CRM
And there are no entries in the DCFS stub table
And there are no entries in the summarised actuals PaaS table
And the following data is available in the Monitoring Deliverable Repository
| OrganisationId | UKPRN    | Contract Number | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode| DeliverableCode | Contract Version | Contract sub version | AllocationStartDate | AllocationEndDate |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201508 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201509 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201510 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201511 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201512 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201601 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201602 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201603 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201604 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201605 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201606 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201607 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
And the following closed collections are available in DCFS
| CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201508 | 24+ALLBC1516            |                          |         | 2               | 1            | 10.00       |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201509 | 24+ALLBC1516            |                          |         | 2               | 1            | 20.00       |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201510 | 24+ALLBC1516            |                          |         | 2               | 1            | 30.00       |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201511 | 24+ALLBC1516            |                          |         | 2               | 1            | 40.00       |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201512 | 24+ALLBC1516            |                          |         | 2               | 1            | 50.00       |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201601 | 24+ALLBC1516            |                          |         | 2               | 1            | 60.00       |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201602 | 24+ALLBC1516            |                          |         | 2               | 1            | 70.00       |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201603 | 24+ALLBC1516            |                          |         | 2               | 1            | 80.00       |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201604 | 24+ALLBC1516            |                          |         | 2               | 1            | 90.00       |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201605 | 24+ALLBC1516            |                          |         | 2               | 1            | 100.00      |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201606 | 24+ALLBC1516            |                          |         | 2               | 1            | 110.00      |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201607 | 24+ALLBC1516            |                          |         | 2               | 1            | 120.00      | 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

Then the following Actuals are stored in FCT for processing
| OrganisationId | PeriodTypeCode | Period  | FundingStreamPeriodCode| ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue | 
| ORG0017499     | CM             | 201508  |    24+ALLBC1516        |                          |         | 2               |      1       | 10.00       | 
| ORG0017499     | CM             | 201509  |    24+ALLBC1516        |                          |         | 2               |      1       | 20.00       | 
| ORG0017499     | CM             | 201510  |    24+ALLBC1516        |                          |         | 2               |      1       | 30.00       | 
| ORG0017499     | CM             | 201511  |    24+ALLBC1516        |                          |         | 2               |      1       | 40.00       | 
| ORG0017499     | CM             | 201512  |    24+ALLBC1516        |                          |         | 2               |      1       | 50.00       | 
| ORG0017499     | CM             | 201601  |    24+ALLBC1516        |                          |         | 2               |      1       | 60.00       | 
| ORG0017499     | CM             | 201602  |    24+ALLBC1516        |                          |         | 2               |      1       | 70.00       | 
| ORG0017499     | CM             | 201603  |    24+ALLBC1516        |                          |         | 2               |      1       | 80.00       | 
| ORG0017499     | CM             | 201604  |    24+ALLBC1516        |                          |         | 2               |      1       | 90.00       | 
| ORG0017499     | CM             | 201605  |    24+ALLBC1516        |                          |         | 2               |      1       | 100.00      | 
| ORG0017499     | CM             | 201606  |    24+ALLBC1516        |                          |         | 2               |      1       | 110.00      | 
| ORG0017499     | CM             | 201607  |    24+ALLBC1516        |                          |         | 2               |      1       | 120.00      | 
# We are yet to understand if PAYCALC will need to consume the enrished data & in what shape?
And the following are stored in the Data Store
| CurrentPeriod | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | AllocationStartDate | AllocationEndDate | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | CollectionType | AllocationNumber | UopCode | DeliverableCode | ActualVolume | ActualValue | ParentDeliverableCode |
| 201509        | 10017499 | Main-17499     | 1               | 1                  | 01/08/2015          | 31/07/2016        | RO1                  | ORG0017499     | CM             | 201508 | 24+ALLBC1516            | ILR1516        | 16AP-17499       |         | 2               | 1            | 10.00       | 1                     |
| 201509        | 10017499 | Main-17499     | 1               | 1                  | 01/08/2015          | 31/07/2016        | RO1                  | ORG0017499     | CM             | 201509 | 24+ALLBC1516            | ILR1516        | 16AP-17499       |         | 2               | 1            | 20.00       | 1                     |

@AcceptanceTest @Superceded
@RetainActualsAuditTrail
Scenario: B006 Confirm Actuals Audit Trail is stored correctly when second poll occurs
Given there is no Contract, Task or Workflow data for UKPRN '10017499' 
And An approved contract 'Main-17499' for Ukprn '10017499' with Allocation '16AP-17499' exists in Dynamics CRM
And there are no entries in the DCFS stub table
And there are no entries in the summarised actuals PaaS table
And the following data is available in the Monitoring Deliverable Repository
| OrganisationId | UKPRN    | Contract Number | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode| DeliverableCode | Contract Version | Contract sub version | AllocationStartDate | AllocationEndDate |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201508 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201509 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201510 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201511 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201512 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201601 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201602 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201603 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201604 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201605 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201606 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
| ORG0017499     | 10017499 | Main-17499      | CM             | 201607 | 24+ALLBC1516            | 16AP-17499               |	      | 2               | 1                | 1                    | 01/08/2015          | 31/07/2016        |
And the following closed collections are available in DCFS
| CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201508 | 24+ALLBC1516            |                          |         | 2               | 1            | 10.00       |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201509 | 24+ALLBC1516            |                          |         | 2               | 1            | 20.00       |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201510 | 24+ALLBC1516            |                          |         | 2               | 1            | 30.00       |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201511 | 24+ALLBC1516            |                          |         | 2               | 1            | 40.00       |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201512 | 24+ALLBC1516            |                          |         | 2               | 1            | 50.00       |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201601 | 24+ALLBC1516            |                          |         | 2               | 1            | 60.00       |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201602 | 24+ALLBC1516            |                          |         | 2               | 1            | 70.00       |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201603 | 24+ALLBC1516            |                          |         | 2               | 1            | 80.00       |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201604 | 24+ALLBC1516            |                          |         | 2               | 1            | 90.00       |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201605 | 24+ALLBC1516            |                          |         | 2               | 1            | 100.00      |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201606 | 24+ALLBC1516            |                          |         | 2               | 1            | 110.00      |
| ILR1516        | RO1                  | ORG0017499     | CM             | 201607 | 24+ALLBC1516            |                          |         | 2               | 1            | 120.00      | 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

Then the following Actuals are stored in FCT for processing
| OrganisationId | PeriodTypeCode | Period  | FundingStreamPeriodCode| ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue | 
| ORG0017499     | CM             | 201508  |    24+ALLBC1516        |                          |         | 2               |      1       | 10.00       | 
| ORG0017499     | CM             | 201509  |    24+ALLBC1516        |                          |         | 2               |      1       | 20.00       | 
| ORG0017499     | CM             | 201510  |    24+ALLBC1516        |                          |         | 2               |      1       | 30.00       | 
| ORG0017499     | CM             | 201511  |    24+ALLBC1516        |                          |         | 2               |      1       | 40.00       | 
| ORG0017499     | CM             | 201512  |    24+ALLBC1516        |                          |         | 2               |      1       | 50.00       | 
| ORG0017499     | CM             | 201601  |    24+ALLBC1516        |                          |         | 2               |      1       | 60.00       | 
| ORG0017499     | CM             | 201602  |    24+ALLBC1516        |                          |         | 2               |      1       | 70.00       | 
| ORG0017499     | CM             | 201603  |    24+ALLBC1516        |                          |         | 2               |      1       | 80.00       | 
| ORG0017499     | CM             | 201604  |    24+ALLBC1516        |                          |         | 2               |      1       | 90.00       | 
| ORG0017499     | CM             | 201605  |    24+ALLBC1516        |                          |         | 2               |      1       | 100.00      | 
| ORG0017499     | CM             | 201606  |    24+ALLBC1516        |                          |         | 2               |      1       | 110.00      | 
| ORG0017499     | CM             | 201607  |    24+ALLBC1516        |                          |         | 2               |      1       | 120.00      | 
# We are yet to understand if PAYCALC will need to consume the enrished data & in what shape?
#And the following are stored in the Data Store
And the AllocationDeliverablePeriodActualAudit table includes the following
| UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | AllocationStartDate | AllocationEndDate | CollectionReturnCode | OrganisationId | PeriodTypeCode | CurrentPeriod | Period | FundingStreamPeriodCode | CollectionType | AllocationNumber | UopCode | DeliverableCode | ActualVolume | ActualValue | ParentDeliverableCode |
| 10017499 | Main-17499     | 1               | 1                  | 01/08/2015          | 31/07/2016        | RO1                  | ORG0017499     | CM             | 201509        | 201508 | 24+ALLBC1516            | ILR1516        | 16AP-17499       |         | 2               | 1            | 10.00       | 1                  |
| 10017499 | Main-17499     | 1               | 1                  | 01/08/2015          | 31/07/2016        | RO1                  | ORG0017499     | CM             | 201509        | 201509 | 24+ALLBC1516            | ILR1516        | 16AP-17499       |         | 2               | 1            | 20.00       | 1                  |
And the DEDS stub is cleared
And the override date is changed to	'04/11/2015'	
And the following closed collections are available in DCFS
| CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
| ILR1516        | RO2                  | ORG0017499     | CM             | 201508 | 24+ALLBC1516            |                          |         | 2               | 1            | 15.00       |
| ILR1516        | RO2                  | ORG0017499     | CM             | 201509 | 24+ALLBC1516            |                          |         | 2               | 1            | 25.00       |
| ILR1516        | RO2                  | ORG0017499     | CM             | 201510 | 24+ALLBC1516            |                          |         | 2               | 1            | 30.00       |
| ILR1516        | RO2                  | ORG0017499     | CM             | 201511 | 24+ALLBC1516            |                          |         | 2               | 1            | 40.00       |
| ILR1516        | RO2                  | ORG0017499     | CM             | 201512 | 24+ALLBC1516            |                          |         | 2               | 1            | 50.00       |
| ILR1516        | RO2                  | ORG0017499     | CM             | 201601 | 24+ALLBC1516            |                          |         | 2               | 1            | 60.00       |
| ILR1516        | RO2                  | ORG0017499     | CM             | 201602 | 24+ALLBC1516            |                          |         | 2               | 1            | 70.00       |
| ILR1516        | RO2                  | ORG0017499     | CM             | 201603 | 24+ALLBC1516            |                          |         | 2               | 1            | 80.00       |
| ILR1516        | RO2                  | ORG0017499     | CM             | 201604 | 24+ALLBC1516            |                          |         | 2               | 1            | 90.00       |
| ILR1516        | RO2                  | ORG0017499     | CM             | 201605 | 24+ALLBC1516            |                          |         | 2               | 1            | 100.00      |
| ILR1516        | RO2                  | ORG0017499     | CM             | 201606 | 24+ALLBC1516            |                          |         | 2               | 1            | 110.00      |
| ILR1516        | RO2                  | ORG0017499     | CM             | 201607 | 24+ALLBC1516            |                          |         | 2               | 1            | 120.00      | 

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

#Then the following are stored in the Data Store
Then the AllocationDeliverablePeriodActualAudit table includes the following
| UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | AllocationStartDate | AllocationEndDate | CollectionReturnCode | OrganisationId | PeriodTypeCode | CurrentPeriod | Period | FundingStreamPeriodCode | CollectionType | AllocationNumber | UopCode | DeliverableCode | ActualVolume | ActualValue | ParentDeliverableCode |
| 10017499 | Main-17499     | 1               | 1                  | 01/08/2015          | 31/07/2016        | RO1                  | ORG0017499     | CM             | 201509        | 201508 | 24+ALLBC1516            | ILR1516        | 16AP-17499       |         | 2               | 1            | 10.00       | 1                  |
| 10017499 | Main-17499     | 1               | 1                  | 01/08/2015          | 31/07/2016        | RO1                  | ORG0017499     | CM             | 201509        | 201509 | 24+ALLBC1516            | ILR1516        | 16AP-17499       |         | 2               | 1            | 20.00       | 1                  |
| 10017499 | Main-17499     | 1               | 1                  | 01/08/2015          | 31/07/2016        | RO2                  | ORG0017499     | CM             | 201510        | 201508 | 24+ALLBC1516            | ILR1516        | 16AP-17499       |         | 2               | 1            | 15.00       | 1                  |
| 10017499 | Main-17499     | 1               | 1                  | 01/08/2015          | 31/07/2016        | RO2                  | ORG0017499     | CM             | 201510        | 201509 | 24+ALLBC1516            | ILR1516        | 16AP-17499       |         | 2               | 1            | 25.00       | 1                  |
| 10017499 | Main-17499     | 1               | 1                  | 01/08/2015          | 31/07/2016        | RO2                  | ORG0017499     | CM             | 201510        | 201510 | 24+ALLBC1516            | ILR1516        | 16AP-17499       |         | 2               | 1            | 30.00       | 1                  |
 