Feature: CappingSB-PAA2022 38417

@AcceptanceTest @Complete
Scenario: A583 Bulk load a new Bootcamps contract with an SB-PAA2022 allocation. Check SoF. Approve. Process actuals and check capping
    Given there is no Contract, Task or Workflow data for UKPRN '10017583' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017583' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | SB-PAA2022        |

    # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
    And   there is no Subnominal data in CRM for the following subnominal codes
    | SubnominalCode |
    | 101139         |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017583'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017583' 
    And   there is no caseload advisor for UKPRN '10017583' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017583 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017583' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017583 Co Ltd' with UKPRN '10017583' and OrgId 'ORG0017583' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017583 | 117583 | 10017583 Co Ltd | 0              | In Administration     | Yes           | AA017583      | ?             | 4 Denville Road        | Lemington Spa          | ?                      | ?                      | ?                      | ?                      | CV32 5UW  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017583 |





    # Bulk create an SB-PAA2022 contract with 3 deliverables
    
    # Change the date
    Given the override date is '02/07/2022'
    
    # Bulk file. New intent. Create SB contract with an SB-PAA allocation
    And   there are no files prefixed '10017583' in the Sharepoint 'SB-2022-Input-Appendices' folder
    And   there are no files prefixed 'SB SB 2022 27022023133439 v3_A583' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SB SB 2022 27022023133439 v3_A583' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SB SB 2022 27022023133439 v3_A583' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SB SB 2022 27022023133439 v3_A583' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SB SB 2022 27022023133439 v3_A583.xlsx' exists in the Datafiles folder and UKPRN '10017583' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

   #And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017583' for FundingType 'SB' and period '2022' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017583' for FundingType 'SB' and period '2022'

    # Check the contents of the SoF
    Then  the file named '10017583_[ContractNo]_v1.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017583 Co Ltd UKPRN: 10017583
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 30/09/2023
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £99,999.82
    of which Cloud Technician [AllocRef_SBA]-5 £55.59 434 £24,126.06
    of which Fast Track to Rail [AllocRef_SBA]-13 £83.44 643 £53,651.92
    of which Solar/Renewable Electrician [AllocRef_SBA]-17 £69.88 318 £22,221.84
    Total Funding for this contract: £99,999.82
    Summary of Funding – Page 1
    """




    # Publish and approve the contract

    # Change the date
    Given the override date is '04/07/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    Then  there are '42' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017583 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 30/09/2023      | ?             |
    | 10017583 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 30/09/2023      | ?             |

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_SBA]  | 101139           | Sep-23 | Reconciliation |

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-14    | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 5               | 24126.06  | 14675.76 | 9450.30  | 2445.96  | 1278.57  | 1556.52  | 2612.73  | 722.67   | 4058.07  | 1167.39  | 833.85   | 1222.98  | 2279.19  | 722.67   | 667.08   | 1445.34  | 3113.04  | 
    | [ContractNo]   | [AllocRef_SBA]     | 13              | 53651.92  | 32541.60 | 21110.32 | 6675.20  | 7342.72  | 5340.16  | 1835.68  | 2503.20  | 2753.52  | 1084.72  | 5006.40  | 5590.48  | 2169.44  | 4922.96  | 6007.68  | 1001.28  | 1418.48  | 
    | [ContractNo]   | [AllocRef_SBA]     | 17              | 22221.84  | 14185.64 | 8036.20  | 1257.84  | 1537.36  | 1467.48  | 1677.12  | 559.04   | 3284.36  | 2865.08  | 1537.36  | 489.16   | 1048.20  | 2166.28  | 1048.20  | 1187.96  | 2096.40  | 
    #                                                       £ 99999.82  £ 61403.00 £ 38596.82

    # Check the PLANNED VOLUMES in CRM on the latest approved contract
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 5               | 434       | 44       | 23       | 28       | 47       | 13       | 73       | 21       | 15       | 22       | 41       | 13       | 12       | 26       | 56       | 
    | [ContractNo]   | [AllocRef_SBA]     | 13              | 643       | 80       | 88       | 64       | 22       | 30       | 33       | 13       | 60       | 67       | 26       | 59       | 72       | 12       | 17       | 
    | [ContractNo]   | [AllocRef_SBA]     | 17              | 318       | 18       | 22       | 21       | 24       | 8        | 47       | 41       | 22       | 7        | 15       | 31       | 15       | 17       | 30       | 





    # Add actuals to the contract for August 2022

    # Change the date
    Given the override date is '04/09/2022'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2022
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202208 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 6464.04     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202208 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 8031.24     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202208 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 5441.78     |

    | ILR2022        | R01                  | ORG0017583     | CM             | 202209 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 8026.40     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202209 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 9894.80     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202209 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 9199.82     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202210 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 9358.28     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202210 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 8425.88     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202210 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 12788.91    |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202211 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 8829.68     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202211 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 9476.10     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202211 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 9807.54     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202212 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 7481.40     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202212 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 8138.69     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202212 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 7029.05     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202301 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 8429.65     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202301 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 9080.62     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202301 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 6905.77     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202302 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 5901.26     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202302 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 5387.04     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202302 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 7385.18     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202303 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 6081.30     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202303 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 3268.37     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202303 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 4789.35     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202304 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 5773.25     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202304 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 6329.77     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202304 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 1005.84     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202305 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 8871.67     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202305 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 1403.24     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202305 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 1491.81     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202306 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 8397.31     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202306 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 1192.09     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202306 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 1090.40     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202307 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 8344.82     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202307 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 1478.02     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202307 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 1409.67     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202308 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 5342.89     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202308 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 6640.62     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202308 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 5513.96     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202309 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 7626.87     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202309 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 1489.43     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202309 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 3677.83     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



    # Check financials in CRM
     
    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 5               | 6464.04   | 6464.04  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 13              | 8031.24   | 8031.24  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 17              | 5441.78   | 5441.78  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 5               | 6464.04   | 6464.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 13              | 8031.24   | 8031.24  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 17              | 5441.78   | 5441.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 5               | 6464.04   | 6464.04  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 13              | 8031.24   | 8031.24  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 17              | 5441.78   | 5441.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    # Net = Reconciliation because Total Reconciliation value is less than Profile for financial envelope 1 




    # Add actuals to the contract for September 2022

    # Change the date
    Given the override date is '04/10/2022'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2022
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202208 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 6464.04     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202208 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 8031.24     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202208 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 5441.78     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202209 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 8026.40     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202209 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 9894.80     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202209 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 9199.82     |

    | ILR2022        | R02                  | ORG0017583     | CM             | 202210 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 9358.28     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202210 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 8425.88     |
    | ILR2022        | R01                  | ORG0017583     | CM             | 202210 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 12788.91    |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202211 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 8829.68     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202211 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 9476.10     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202211 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 9807.54     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202212 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 7481.40     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202212 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 8138.69     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202212 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 7029.05     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202301 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 8429.65     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202301 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 9080.62     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202301 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 6905.77     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202302 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 5901.26     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202302 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 5387.04     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202302 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 7385.18     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202303 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 6081.30     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202303 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 3268.37     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202303 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 4789.35     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202304 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 5773.25     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202304 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 6329.77     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202304 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 1005.84     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202305 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 8871.67     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202305 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 1403.24     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202305 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 1491.81     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202306 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 8397.31     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202306 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 1192.09     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202306 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 1090.40     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202307 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 8344.82     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202307 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 1478.02     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202307 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 1409.67     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202308 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 5342.89     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202308 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 6640.62     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202308 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 5513.96     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202309 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 7626.87     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202309 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 1489.43     |
    | ILR2022        | R02                  | ORG0017583     | CM             | 202309 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 3677.83     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



    # Check financials in CRM

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 5               | 14490.44  | 6464.04  | 8026.40  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 13              | 17926.04  | 8031.24  | 9894.80  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 17              | 14641.60  | 5441.78  | 9199.82  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 5               | 14490.44  | 6464.04  | 8026.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 13              | 17926.04  | 8031.24  | 9894.80  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 17              | 14641.60  | 5441.78  | 9199.82  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 5               | 14490.44  | 6464.04  | 8026.40  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 13              | 17926.04  | 8031.24  | 9894.80  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 17              | 14641.60  | 5441.78  | 9199.82  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    # Net = Reconciliation because Total Reconciliation value is less than Profile for financial envelope 1 




    # Add actuals to the contract for October 2022

    # Change the date
    Given the override date is '04/11/2022'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Oct 2022
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202208 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 6464.04     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202208 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 8031.24     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202208 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 5441.78     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202209 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 8026.40     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202209 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 9894.80     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202209 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 9199.82     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202210 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 9358.28     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202210 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 8425.88     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202210 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 12788.91    |

    | ILR2022        | R03                  | ORG0017583     | CM             | 202211 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 8829.68     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202211 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 9476.10     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202211 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 9807.54     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202212 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 7481.40     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202212 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 8138.69     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202212 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 7029.05     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202301 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 8429.65     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202301 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 9080.62     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202301 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 6905.77     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202302 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 5901.26     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202302 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 5387.04     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202302 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 7385.18     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202303 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 6081.30     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202303 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 3268.37     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202303 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 4789.35     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202304 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 5773.25     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202304 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 6329.77     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202304 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 1005.84     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202305 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 8871.67     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202305 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 1403.24     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202305 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 1491.81     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202306 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 8397.31     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202306 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 1192.09     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202306 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 1090.40     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202307 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 8344.82     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202307 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 1478.02     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202307 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 1409.67     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202308 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 5342.89     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202308 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 6640.62     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202308 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 5513.96     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202309 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 5               | 0            | 7626.87     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202309 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 13              | 0            | 1489.43     |
    | ILR2022        | R03                  | ORG0017583     | CM             | 202309 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 17              | 0            | 3677.83     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service



    # Check financials in CRM

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 5               | 23848.72  | 6464.04  | 8026.40  | 9358.28  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 13              | 26351.92  | 8031.24  | 9894.80  | 8425.88  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 17              | 27430.51  | 5441.78  | 9199.82  | 12788.91 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #                                                       £ 77631.15

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 5               | 23848.72  | 6464.04  | 8026.40  | 9358.28  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 13              | 26351.92  | 8031.24  | 9894.80  | 8425.88  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 17              | 27430.51  | 5441.78  | 9199.82  | 12788.91 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                       £ 77631.15

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 5               | -4985.38  | 0.00     | 0.00     | -4985.38 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 13              | -5508.65  | 0.00     | 0.00     | -5508.65 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 17              | -5734.12  | 0.00     | 0.00     | -5734.12 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                       £ -16228.15
    #
    # Cap (-£16,228.15) is apportioned between the three Deliverables as follows ...
    # Deliverable Cap = Total Cap * Sum of Actuals for Deliverable / Sum of Actuals for all Deliverables
    #
    #  D5  Cap = -16228.15 * 23848.72 / 77631.15 = -4985.38
    #  D13 Cap = -16228.15 * 26351.92 / 77631.15 = -5508.65
    #  D17 Cap = -16228.15 * 27430.51 / 77631.15 = -5734.12
    
    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 5               | 18863.34  | 6464.04  | 8026.40  | 4372.90  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 13              | 20843.27  | 8031.24  | 9894.80  | 2917.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 17              | 21696.39  | 5441.78  | 9199.82  | 7054.79  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                       £ 61403.00 


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Complete
Scenario: A584 Bulk load a new Bootcamps contract with an SB2022 allocation. Approve. Amend to add 12mths. Approve. NFA. Check docs and financials
    Given there is no Contract, Task or Workflow data for UKPRN '10017584' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017584' 



    # Set the 'base' timestamp for each of the Bootcamps document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    Given the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_SB_2022-08-01.docx                          | 2022-06-21 12:00:00.000 | 
    | SB_W3_TAC_2022-08-01.docx                       | 2022-06-21 12:00:00.000 | 
    | SB_W3_S1_2022-08-01.docx                        | 2022-06-21 12:00:00.000 | 
    | SB-PAA_W3_S1_2022-08-01.docx                    | 2022-06-21 12:00:00.000 | 
    | SB_W3_S2_2022-08-01.docx                        | 2022-06-21 12:00:00.000 | 
    | SB-PAA_W3_S2_2022-08-01.docx                    | 2022-06-21 12:00:00.000 | 
    | SB_W3_S3ON_2022-08-01.docx                      | 2022-06-21 12:00:00.000 | 



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017584' 
    And   there is no caseload advisor for UKPRN '10017584' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017584 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017584' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017584 Co Ltd' with UKPRN '10017584' and OrgId 'ORG0017584' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017584 | 117584 | 10017584 Co Ltd | 0              | Active                | Yes           | AA017584      | ?             | 14 Elmfield West       | Millbrook Rd West      | ?                      | ?                      | Southampton            | Hampshire              | SO15 1JA  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017584 |





    # Change the date
    Given the override date is '28/06/2022'
    
    # Bulk file. New intent to create Bootcamps contract with an SB2022 allocation
    And   there are no files prefixed '10017584' in the Sharepoint 'SB-2022-Input-Appendices' folder
    And   there are no files prefixed 'SB SB 2022 01032023150859 v3_A584' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SB SB 2022 01032023150859 v3_A584' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SB SB 2022 01032023150859 v3_A584' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SB SB 2022 01032023150859 v3_A584' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SB SB 2022 01032023150859 v3_A584.xlsx' exists in the Datafiles folder and UKPRN '10017584' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017584' for FundingType 'SB' and period '2022'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3) (No FA)
    Then  the file named '10017584_[ContractNo]_v1.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017584 Co Ltd UKPRN: 10017584
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 30/09/2023
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £289,340.61
    of which Advanced Engineering and Materials Testing [AllocRef_SB]-1 £134.42 945 £127,026.90
    of which Extended Reality (Games) [AllocRef_SB]-129 £97.45 767 £74,744.15
    of which Coding Skills Bootcamp [AllocRef_SB]-196 £116.14 754 £87,569.56
    Total Funding for this contract: £289,340.61
    Summary of Funding – Page 1

    Agreement Type Contract for Services
    Funding Period 1 August 2022 to 30 September 2023
    Between the Secretary of State for Education
    And 10017584 Co Ltd
    Funding for Skills Bootcamps Wave 3
    Master Contract Number [MasterContractNo]
    ACCEPTANCE BY THE CONTRACTOR
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    Ceri D’Mello, Deputy Director, Head of Commercial – Skills Category Commercial Directorate,
    Operations Group
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service
    between:
    10017584 Co Ltd THE SECRETARY OF STATE FOR
    14 Elmfield West EDUCATION
    Millbrook Rd West DEPARTMENT FOR EDUCATION
    Southampton 20 GREAT SMITH STREET
    AND
    Hampshire LONDON
    SO15 1JA SW1P 3BT
    Company No: AA017584
    Hereinafter called Hereinafter called
    the “Contractor” the “DFE”
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 2
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 40
    
    Schedule 1
    The Specification
    Skills Bootcamps Wave 3 Schedule 1 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 1 Version 1 (August 2022) - Page 12
    
    Schedule 2
    Financials
    Skills Bootcamps Wave 3 Schedule 2 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 2 Version 1 (August 2022) - Page 4
    
    Schedule 3
    KPIs, Service Levels, Service Credits and Performance Measures
    Skills Bootcamps Wave 3 Schedule 3 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 7 Version 1 (August 2022) - Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017584_[ContractNo]_v1.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A584.pdf'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-06-28 09:12:35.000 |

   #And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'





    # Publish and approve the contract

    # Change the date
    Given the override date is '04/07/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    Then  there are '42' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017584 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 30/09/2023      | ?             |
    | 10017584 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 30/09/2023      | ?             |

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_SB]   | 101139           | Sep-23 | Reconciliation |





    # Bulk Amendment

    # Change the date
    Given the override date is '22/03/2023'
    
    # Bulk file. Extend contract and SB2022 allocation by 12mths with just the new deliverable periods in the file
    And   there are no files prefixed '10017584' in the Sharepoint 'SB-2022-Input-Appendices' folder
    And   there are no files prefixed 'SB SB 2022 01032023150902 v3_A584a' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SB SB 2022 01032023150902 v3_A584a' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SB SB 2022 01032023150902 v3_A584a' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SB SB 2022 01032023150902 v3_A584a' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SB SB 2022 01032023150902 v3_A584a.xlsx' exists in the Datafiles folder and UKPRN '10017584' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017584' for FundingType 'SB' and period '2022'

    # Check the contents of the Appendices (SoF only)
    Then  the file named '10017584_[ContractNo]_v2.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017584 Co Ltd UKPRN: 10017584
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 26/09/2024
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £436,498.26
    of which Advanced Engineering and Materials Testing [AllocRef_SB]-1 £134.42 1,433 £192,623.86
    of which Extended Reality (Games) [AllocRef_SB]-129 £97.45 1,132 £110,313.40
    of which Coding Skills Bootcamp [AllocRef_SB]-196 £116.14 1,150 £133,561.00
    Total Funding for this contract: £436,498.26
    Summary of Funding – Page 1
    """

    # There shouldn't be a TaC
    And   the pdf file does not contain the following text
    """
    Agreement Type Contract for Services
    """

    # There shouldn't be a Sch1 (Check footer)
    And   the pdf file does not contain the following text
    """
    Skills Bootcamps Wave 3 Schedule 1 Version 1 (August 2022) - Page 1
    """

    # There shouldn't be a Sch2 (Check footer)
    And   the pdf file does not contain the following text
    """
    Skills Bootcamps Wave 3 Schedule 2 Version 1 (August 2022) - Page 1
    """

    # There shouldn't be a Sch3 (Check footer)
    And   the pdf file does not contain the following text
    """
    Skills Bootcamps Wave 3 Schedule 3 Version 1 (August 2022) - Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017584_[ContractNo]_v2.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A584a.pdf'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2023-03-22 09:12:35.000 |

   #And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'





    # Publish and approve the contract

    # Change the date
    Given the override date is '23/03/2023'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    Then  there are '78' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017584 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 26/09/2024      | Variation     |
    | 10017584 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2022        | 30/09/2023      | ?             |
    | 10017584 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 30/09/2023      | ?             |

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_SB]   | 101139           | Sep-24 | Reconciliation |





    # Execute a NON-FINANCIAL amendment and check docs

    # Change the date
    Given the override date is '25/03/2023'
    
    # Update the timestamp on the TaC template to a date after contract v2 was created on 22/03/2023 (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    Given the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
 #  | SOF_SB_2022-08-01.docx                          | 2022-06-21 12:00:00.000 | 
    | SB_W3_TAC_2022-08-01.docx                       | 2023-03-24 12:00:00.000 | 
 #  | SB_W3_S1_2022-08-01.docx                        | 2022-06-21 12:00:00.000 | 
 #  | SB-PAA_W3_S1_2022-08-01.docx                    | 2022-06-21 12:00:00.000 | 
 #  | SB_W3_S2_2022-08-01.docx                        | 2022-06-21 12:00:00.000 | 
 #  | SB-PAA_W3_S2_2022-08-01.docx                    | 2022-06-21 12:00:00.000 | 
 #  | SB_W3_S3ON_2022-08-01.docx                      | 2022-06-21 12:00:00.000 | 


    # Issue a non-financial VARIATION amendment on v2 to create v3
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM. (A check that the contract has been created)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017584 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2022        | 26/09/2024      | Variation     |
    | 10017584 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2022        | 26/09/2024      | Variation     |
    | 10017584 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2022        | 30/09/2023      | ?             |
    | 10017584 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 30/09/2023      | ?             |

    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017584' for FundingType 'SB' and period '2022'

    # Check that the SoF and TaC have been generated
    Then  the file named '10017584_[ContractNo]_v3.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017584 Co Ltd UKPRN: 10017584
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 26/09/2024
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £436,498.26
    of which Advanced Engineering and Materials Testing [AllocRef_SB]-1 £134.42 1,433 £192,623.86
    of which Extended Reality (Games) [AllocRef_SB]-129 £97.45 1,132 £110,313.40
    of which Coding Skills Bootcamp [AllocRef_SB]-196 £116.14 1,150 £133,561.00
    Total Funding for this contract: £436,498.26
    Summary of Funding – Page 1

    Agreement Type Contract for Services
    Funding Period 1 August 2022 to 26 September 2024
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 1
    """

    # There shouldn't be a Sch1 (Check footer)
    And   the pdf file does not contain the following text
    """
    Skills Bootcamps Wave 3 Schedule 1 Version 1 (August 2022) - Page 1
    """

    # There shouldn't be a Sch2 (Check footer)
    And   the pdf file does not contain the following text
    """
    Skills Bootcamps Wave 3 Schedule 2 Version 1 (August 2022) - Page 1
    """

    # There shouldn't be a Sch3 (Check footer)
    And   the pdf file does not contain the following text
    """
    Skills Bootcamps Wave 3 Schedule 3 Version 1 (August 2022) - Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017584_[ContractNo]_v3.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A584b.pdf'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 3                     | 0                        | 2023-03-23 09:12:35.000 |


    # Tidy Up
    Given the override date is reset
   
    # Reset the 'base' timestamp for each of the Bootcamps document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_SB_2022-08-01.docx                          | 2022-06-21 12:00:00.000 | 
    | SB_W3_TAC_2022-08-01.docx                       | 2022-06-21 12:00:00.000 | 
    | SB_W3_S1_2022-08-01.docx                        | 2022-06-21 12:00:00.000 | 
    | SB-PAA_W3_S1_2022-08-01.docx                    | 2022-06-21 12:00:00.000 | 
    | SB_W3_S2_2022-08-01.docx                        | 2022-06-21 12:00:00.000 | 
    | SB-PAA_W3_S2_2022-08-01.docx                    | 2022-06-21 12:00:00.000 | 
    | SB_W3_S3ON_2022-08-01.docx                      | 2022-06-21 12:00:00.000 | 

