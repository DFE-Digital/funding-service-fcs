Feature: EDSKwithActuals 

@AcceptanceTest @WIthdrawn25072024
Scenario: A840 Bulk load a new 2223 EDSK contract with a 16-18TRN2223 alloc. Step through Tasks. Approve. Actuals and Payment batch. Check docs, CRM and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017840' 
    And   there are no terminated or closed allocations for UKPRN '10017840' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017840' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017840' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017840' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18TRN2223      |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017840'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017840' 
    And   there is no caseload advisor for UKPRN '10017840' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017840 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017840' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017840 Co Ltd' with UKPRN '10017840' and OrgId 'ORG0017840' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017840 | 117840 | 10017840 Co Ltd | 0              | Active                | Yes           | AA017840      | ?             | 13 Coniston Road       | ?                      | ?                      | ?                      | Chippenham             | Wiltshire              | SN14 0PX  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017840 |





    # Change the date
    Given the override date is '01/07/2022'

    # Bulk file (Intent = New)
    And   there are no files prefixed '10017840' in the Sharepoint 'EDSK-2223-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2223 29072022140709 v3_A840' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2223 29072022140709 v3_A840' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2223 29072022140709 v3_A840' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2223 29072022140709 v3_A840' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2223 29072022140709 v3_A840.xlsx' exists in the Datafiles folder and UKPRN '10017840' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    
#    # Retrieve parameters
#   #When  I retrieve the latest EFA contract details from CRM for provider '10017840' for FundingType 'EDSK' and period '2223' and Delivery Organisation '00000000'
#    When  I retrieve the latest contract details from CRM for provider '10017840' for FundingType 'EDSK' and period '2223'
#
#    # Check that the six document parts have beenb created in the right order
#    Then  the file named '10017840_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING 2022/23
#    Summary of Funding – Page 1
#
#    Agreement Type Conditions of Funding (Grant) (Colleges)
#    EDSK Version 2 (July 2022) Page 74
#
#    SCHEDULE 1: SPECIFICATION & MONITORING
#    16-18-YEAR-OLD TRAINEESHIPS SPECIFICATION
#    EDSK Schedule 1 – 16 to 18 Traineeships Version 1 (July 2022) – Page 7
#
#    SCHEDULE 2: PAYMENT
#    16-18-YEAR-OLD TRAINEESHIPS
#    EDSK Schedule 2 – 16 to 18 Traineeships Version 1 (July 2022) – Page 1
#
#    SCHEDULE 2 – 16 TO 18 TRAINEESHIPS
#    Funding Agreement – 16 to 18 Traineeships
#
#    SCHEDULE 3: NOT USED
#    EDSK Schedule 10 Version 2 (July 2022) – Page 5
#    """
#
#    # Contract is now at 'Draft\Awaiting Documentation'
#
#
#
    # Create dummy Ts&Cs files in Sharepoint from 'Contract.AcceptanceTests\Resources\DummyPdf.pdf'
    Given there are no files prefixed '10017840' in the Sharepoint 'EDSK-2223-Input-Terms And Conditions' folder
    And   a file with filename '10017840_[ContractNo]_11.pdf' is created in 'EDSK-2223-Input-Terms And Conditions'
#
#
#
#
#    # Step through the Tasks until draft contract reaches 'Published to Provider'
#    
#    # Change the date
#    Given the override date is '03/07/2022'
#
#    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
#    When  the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017840' is triggered by User 'FCS2 Test'
#    | Task                             | Owner                    |
#    | Initiate Document Merge          | Document Management Team |
#
#    # Check the current state of the Tasks for this contract
#    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017840'
#    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Review Contract Details          | 10017840 - 10017840 Co Ltd Please review the contract       | [ContractNo]   | FCS2 Test                 | Contract Advisers Team   | Open            | Not Started      |
#
#
#
#    # Change the date
#    Given the override date is '05/07/2022'
#
#    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
#    When  the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017840' is triggered by User 'FCS2 Test'
#    | Task                             | Owner                    |
#    | Review Contract Details          | FCS2 Test                |
#
#    # Check the current state of the Tasks for this contract
#    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017840'
#    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Internal Approval        | 10017840 - 10017840 Co Ltd                                  | [ContractNo]   | FCS1 Test                 | Contract Managers Team   | Open            | Not Started      |
#
#
#
#    # Change the date
#    Given the override date is '07/07/2022'
#
#    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
#    When  the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017840' is triggered by User 'FCS1 Test'
#    | Task                             | Owner                    |
#    | Confirm Internal Approval        | FCS1 Test                |
#
#    # Check the current state of the Tasks for this contract
#    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017840'
#    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Publication to Provider  | 10017840 - 10017840 Co Ltd                                  | [ContractNo]   | Lead Manager Team         | ?                        | Open            | Not Started      |
#
#
#
#    # Change the date
#    Given the override date is '09/07/2022'
#
#    # Complete an existing open Task (Confirm Publication to Provider -> End)
#    When  the following open Task currently linked to version '1' of contract '[ContractNo]' for provider '10017840' is triggered by User 'FCS2 Test'
#    | Task                             | Owner                    |
#    | Confirm Publication to Provider  | Lead Manager Team        |
#
#
#    # Check that the Tasks on the contract are all marked as completed
#    Then  the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017840'
#    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#    | Confirm Publication to Provider  | 10017840 - 10017840 Co Ltd                                  | [ContractNo]   | Lead Manager Team         | ?                        | Completed       | Completed        |
#    | Confirm Internal Approval        | 10017840 - 10017840 Co Ltd                                  | [ContractNo]   | FCS1 Test                 | Contract Managers Team   | Completed       | Completed        |
#    | Review Contract Details          | 10017840 - 10017840 Co Ltd Please review the contract       | [ContractNo]   | FCS2 Test                 | Contract Advisers Team   | Completed       | Completed        |
#    | Initiate Document Merge          | 10017840 - 10017840 Co Ltd Awaiting documentation           | [ContractNo]   | Document Management Team  | ?                        | Completed       | Completed        |
#
#    # Check the CONTRACT version, status and dates in CRM.
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber      | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10017840 | [ContractNo]        | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/08/2022        | 31/07/2023      | ?             |
#    | 10017840 | [MasterContractNo]  | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |
#
#
#
#
#
#    # Approve the contract
#
#    # Change the date
#    Given the override date is '11/07/2022'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#    # Check the CONTRACT version, status and dates in CRM.
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10017840 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
#    | 10017840 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |
#
#
#
#
#
#    # Add actuals to the contract for 16-18TRN2223
#
#    # Change the date
#    Given the override date is '04/10/2022'
#
#    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
#    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017840'
#
#    # Clear down the stub
#    And   there are no entries in the DCFS stub table
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
#    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS
#
#    # Pull actuals from DC for Sep 2022
#    And   the following closed collections are available in DCFS 
#    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202208 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 2               | 0            | 1242.51     |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202208 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 3               | 0            | 712.31      |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202209 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 2               | 0            | 268.51      |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202209 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 3               | 0            | 749.93      |
#    #
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202210 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 2               | 0            | 1465.04     |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202210 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 3               | 0            | 263.53      |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202211 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 2               | 0            | 1270.92     |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202211 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 3               | 0            | 337.03      |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202212 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 2               | 0            | 1483.34     |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202212 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 3               | 0            | 432.34      |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202301 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 2               | 0            | 405.91      |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202301 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 3               | 0            | 570.29      |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202302 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 2               | 0            | 681.32      |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202302 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 3               | 0            | 957.59      |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202303 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 2               | 0            | 1035.09     |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202303 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 3               | 0            | 1130.57     |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202304 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 2               | 0            | 719.54      |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202304 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 3               | 0            | 998.27      |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202305 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 2               | 0            | 759.54      |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202305 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 3               | 0            | 1480.23     |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202306 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 2               | 0            | 1414.05     |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202306 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 3               | 0            | 1496.86     |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202307 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 2               | 0            | 580.01      |
#    | ILR2223        | R02                  | ORG0017840     | CM             | 202307 | 16-18TRN2223            | [AllocRef_16TR]          | ?          | 3               | 0            | 882.64      |
#
#    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
#   #When  the FCT system polls the DCFS DEDS service
#    When  the FCT system polls the SLD service
#
#
#
#    # Check CRM and PaaS
#
#    # Check the ACTUAL VALUES in CRM on the latest approved contract
#    Then  the Actuals Value Data is as follows
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
#    | [ContractNo]   | [AllocRef_16TR]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_16TR]    | 2               | 1511.02   | 1242.51  | 268.51   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#    | [ContractNo]   | [AllocRef_16TR]    | 3               | 1462.24   | 712.31   | 749.93   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
#
#    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
#    And   the Reconciliation Data is calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
#    | [ContractNo]   | [AllocRef_16TR]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TR]    | 2               | 1511.02   | 0.00     | 1511.02  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TR]    | 3               | 1462.24   | 0.00     | 1462.24  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
#    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
#    And   the Capping Amounts are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
#    | [ContractNo]   | [AllocRef_16TR]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TR]    | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TR]    | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
#    # Check the NET AMOUNTS in CRM on the latest approved contract
#    And   the Net Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   |
#    | [ContractNo]   | [AllocRef_16TR]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TR]    | 2               | 1511.02   | 0.00     | 1511.02  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_16TR]    | 3               | 1462.24   | 0.00     | 1462.24  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
#
#    # Check the RECONCILIATION subnominal aggregations in CRM
#    And   the Reconciliation Subnominal Amounts are calculated as follows
#    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    | Apr-23    | May-23    | Jun-23    | Jul-23    |
#    | 10017840 | [ContractNo]   | [AllocRef_16TR]    | 2201300                  | 0.00      | 1511.02   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
#    | 10017840 | [ContractNo]   | [AllocRef_16TR]    | 2201350                  | 0.00      | 1462.24   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
#
#
#
#
#
#    # Payment Batch for 16-18TRN2223(PoA)
#
#    # Change the date
#    Given the override date is '10/10/2022 22:05'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod '16-18TRN2223' AccountingPaymentPeriod '202206' CensusEndDate '10/10/2022' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | [AllocRef_16TR]          | 202209 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | 16-18TRN2223               | 202209               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | 16-18TRN2223               | 202209               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod '16-18TRN2223' PaymentPeriod '202206' CensusEndDate '10/10/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A840.xml'
#
#    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    And   the Payment feed xml for FundingStreamPeriod '16-18TRN2223' PaymentPeriod '202206' CensusEndDate '10/10/2022' and LinkCodeSuffix 'A' includes the following values
#    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription   | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    | 16TR                   | 2022          | 06             | 10          | ?       | [AllocRef_16TR]   | 1511.02         | RECONCILIATION   | 16-18Traineeships       | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017840 | 2201300    |
#    | 16TR                   | 2022          | 06             | 10          | ?       | [AllocRef_16TR]   | 1462.24         | RECONCILIATION   | 16-18TraineeshipBurs    | 2022-10-20 | 2022-08-01   | 2023-07-31 | ?              | 10017840 | 2201350    |
#
#
#    # Tidy Up
#    Given the override date is reset
#

