Feature: Create1819LoansContractsA 22283

@AcceptanceTest @Withdrawn20210702
@Long2Run @Long2Run67
Scenario: A629 Create and approve an 1819 Mainstream contract with 16-18TRN (PoA), AEBC (PoP) and APPS (PoA) allocations. Bulk amend then update draft. Step through Tasks until Published then approve. Consume actuals for APPS21 and R06. Create PoP and PoA payment files. Check CRM, Tasks, Financials, PaaS and Payment Feed
    Given there is no Contract, Task or Workflow data for UKPRN '10017629' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017629' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16TR-629      |
    | AEC-629       |
    | APPS-629      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data for the following FSPs
    | FSP           |
    | 16-18TRN1819  |
    | AEBC1819      |
    | APPS1819      |

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for this provider
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017629'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017629' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017629 Co Ltd' with UKPRN '10017629' and OrgId 'ORG0017629' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017629' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017629 | 117629 | 10017629 Co Ltd | 0              | In Administration     | Yes           | AA017629      | ?             | 49 Send Barns Lane     | Send                   | Woking                 | ?                      | ?                      | Surrey                 | GU23 7BS  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017629 |




    # Change the date
    Given the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017629 | 10017629 Co Ltd      | ESFA-629             | MAIN-629       | 1                     | 01/08/2018        | 31/07/2019      | 110395.00     |                                | Contract for Services | 1819   | New          | ORG0017629 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017629 | MAIN-629       | 16TR-629      | 16-18TRN          | 16-18TRN1819            | AY                      | 01/08/2018          | 31/07/2019        | 40447.00        |                         |            |                                                             | New          |             |
    | 10017629 | MAIN-629       | AEC-629       | AEBC              | AEBC1819                | AY                      | 01/08/2018          | 31/07/2019        | 47780.00        |                         |            |                                                             | New          |             |
    | 10017629 | MAIN-629       | APPS-629      | APPS              | APPS1819                | AY                      | 01/08/2018          | 31/07/2019        | 22168.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017629 | MAIN-629       | 16TR-629      | 1               | 0                     | 40447.00  | 1675.00  | 5803.00  | 1688.00  | 3568.00  | 4804.00  | 2209.00  | 4346.00  | 3308.00  | 2799.00  | 3637.00  | 876.00   | 5734.00  | Total 16-18 Traineeships Funding                                | New          |             |
    | 10017629 | MAIN-629       | 16TR-629      | 2               | 1                     | 24699.00  | 876.00   | 2213.00  | 1395.00  | 3291.00  | 1819.00  | 755.00   | 2581.00  | 2816.00  | 2322.00  | 2944.00  | 648.00   | 3039.00  | 16-18 Traineeships Programme Funding                            | New          |             |
    | 10017629 | MAIN-629       | 16TR-629      | 3               | 1                     | 15748.00  | 799.00   | 3590.00  | 293.00   | 277.00   | 2985.00  | 1454.00  | 1765.00  | 492.00   | 477.00   | 693.00   | 228.00   | 2695.00  | 16-18 Traineeships Bursary Funding                              | New          |             |
    | 10017629 | MAIN-629       | AEC-629       | 1               | 0                     | 47780.00  | 2130.00  | 3771.00  | 2389.00  | 2850.00  | 6508.00  | 5854.00  | 4152.00  | 4987.00  | 5578.00  | 1452.00  | 3767.00  | 4342.00  | Adult Education Budget Total Funding                            | New          |             |
    | 10017629 | MAIN-629       | AEC-629       | 13              | 1                     | 25619.00  | 2022.00  | 2126.00  | 852.00   | 1782.00  | 2812.00  | 2834.00  | 1526.00  | 3392.00  | 2810.00  | 377.00   | 2398.00  | 2688.00  | Community Learning                                              | New          |             |
    | 10017629 | MAIN-629       | AEC-629       | 14              | 1                     | 22161.00  | 108.00   | 1645.00  | 1537.00  | 1068.00  | 3696.00  | 3020.00  | 2626.00  | 1595.00  | 2768.00  | 1075.00  | 1369.00  | 1654.00  | Other AEB Funding                                               | New          |             |
    | 10017629 | MAIN-629       | APPS-629      | 1               | 0                     | 22168.00  | 3547.00  | 499.00   | 2440.00  | 1337.00  | 436.00   | 736.00   | 337.00   | 1651.00  | 3600.00  | 2056.00  | 1879.00  | 3650.00  | Apprenticeships Carry-In Total Funding                          | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract 'MAIN-629' is in a state of 'Published to Provider'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-629' and actual ContractNumber 'MAIN-629'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-629' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017629 | MAIN-629           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017629 | ESFA-629           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 16TR-629        | 2201300          | Jul-19 | Reconciliation |
  # | AEC-629         | 2371075          | Jul-19 | Reconciliation |
  # | APPS-629        | 2240100          | Jul-19 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed
    Then  the Legal Contract CM feed contains the following '7' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                         | DeliverableDescription    | 
    | 10017629 | MAIN-629       | 1               | 16TR-629      | 1               | 0                     | 40447        | 0             | 0        | Total 16-18 Traineeships Funding        | ?                         |
    | 10017629 | MAIN-629       | 1               | 16TR-629      | 2               | 1                     | 24699        | 0             | 0        | 16-18 Traineeships Programme Funding    | ?                         |
    | 10017629 | MAIN-629       | 1               | 16TR-629      | 3               | 1                     | 15748        | 0             | 0        | 16-18 Traineeships Bursary Funding      | ?                         |
    | 10017629 | MAIN-629       | 1               | AEC-629       | 1               | 0                     | 47780        | 0             | 0        | Adult Education Budget Total Funding    | ?                         |
    | 10017629 | MAIN-629       | 1               | AEC-629       | 13              | 1                     | 25619        | 0             | 0        | Community Learning                      | ?                         |
    | 10017629 | MAIN-629       | 1               | AEC-629       | 14              | 1                     | 22161        | 0             | 0        | Other AEB Funding                       | ?                         |
    | 10017629 | MAIN-629       | 1               | APPS-629      | 1               | 0                     | 22168        | 0             | 0        | Apprenticeships Carry-In Total Funding  | ?                         |




    # Change the date
    Given the override date is '04/07/2018'

    # Bulk import to amend the contract and create v2
    And   there are no files prefixed '10017629_MAIN' in the Sharepoint 'MAIN-1819-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1819 04052018134002 v2_A629_0' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1819 04052018134002 v2_A629_0' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 1819 04052018134002 v2_A629_0.xlsx' exists in the Datafiles folder and UKPRN '10017629' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Change the date
    Given the override date is '06/07/2018'

    # Bulk import to do an update draft on v2 of the Mainstream contract
    And   there are no files prefixed 'MAIN AY 1819 04052018134016 v2_A629' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1819 04052018134016 v2_A629' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 1819 04052018134016 v2_A629.xlsx' exists in the Datafiles folder and UKPRN '10017629' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

#   # Create a dummy Appendix file containing just the word 'Appendices'
#   Given there are no files prefixed '10017629_MAIN-629' in the Sharepoint 'MAIN-1819-Input-Appendices' folder
#   And   a file with filename '10017629_MAIN-629_v1.pdf' is created in 'MAIN-1819-Input-Appendices'

    # Create two dummy Terms and Conditions files. Each has just one page containing just the work 'Appendices'
    Given there are no files prefixed '10017629_MAIN-629' in the Sharepoint 'MAIN-1819-Input-Terms And Conditions' folder
    And   a file with filename '10017629_MAIN-629_11.pdf' is created in 'MAIN-1819-Input-Terms And Conditions'
    And   a file with filename '10017629_MAIN-629_61.pdf' is created in 'MAIN-1819-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '2' of contract 'MAIN-629' for provider '10017629' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract 'MAIN-629' for provider '10017629'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017629 - 10017629 Co Ltd Please review the contract       | MAIN-629       | FCS2 Test                | Contract Advisers Team   | Open            | Not Started      |


    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '2' of contract 'MAIN-629' for provider '10017629' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract 'MAIN-629' for provider '10017629'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017629 - 10017629 Co Ltd                                  | MAIN-629       | FCS1 Test                | Contract Managers Team   | Open            | Not Started      |


    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When  the following open Task currently linked to version '2' of contract 'MAIN-629' for provider '10017629' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract 'MAIN-629' for provider '10017629'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017629 - 10017629 Co Ltd                                  | MAIN-629       | Lead Manager Team         | ?                        | Open            | Not Started      |


    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When  the following open Task currently linked to version '2' of contract 'MAIN-629' for provider '10017629' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |


    # Check that the Tasks on the contract are all marked as completed
    Then  the following Tasks are present against version '2' of contract 'MAIN-629' for provider '10017629'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017629 - 10017629 Co Ltd                                  | MAIN-629       | Lead Manager Team         | ?                        | Completed       | Completed        |
    | Confirm Internal Approval        | 10017629 - 10017629 Co Ltd                                  | MAIN-629       | FCS1 Test                | Contract Managers Team   | Completed       | Completed        |
    | Review Contract Details          | 10017629 - 10017629 Co Ltd Please review the contract       | MAIN-629       | FCS2 Test                | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017629 - 10017629 Co Ltd Awaiting documentation           | MAIN-629       | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017629 | MAIN-629           | 2                     | 1                        | Draft            | Published to Provider     | True          | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017629 | MAIN-629           | 2                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017629 | MAIN-629           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017629 | ESFA-629           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Change the date
    Given the override date is '09/07/2018'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-629' and actual ContractNumber 'MAIN-629'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-629' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017629 | MAIN-629           | 2                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017629 | MAIN-629           | 2                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017629 | MAIN-629           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017629 | ESFA-629           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '420' deliverable period rows in CRM linked to the latest version of contract 'MAIN-629'

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-629       | 16TR-629        | 1               | 70155.00 | 8658.00  | 5425.00  | 5530.00  | 3898.00  | 6165.00  | 6945.00  | 6925.00  | 3350.00  | 4176.00  | 7963.00  | 6502.00  | 4618.00  | 
    | MAIN-629       | 16TR-629        | 2               | 37004.00 | 4646.00  | 4236.00  | 3145.00  | 151.00   | 4183.00  | 3304.00  | 4626.00  | 660.00   | 3972.00  | 3939.00  | 2722.00  | 1420.00  | 
    | MAIN-629       | 16TR-629        | 3               | 33151.00 | 4012.00  | 1189.00  | 2385.00  | 3747.00  | 1982.00  | 3641.00  | 2299.00  | 2690.00  | 204.00   | 4024.00  | 3780.00  | 3198.00  | 
    | MAIN-629       | AEC-629         | 1               | 52021.00 | 5422.00  | 6077.00  | 2798.00  | 7682.00  | 1614.00  | 3961.00  | 5508.00  | 3498.00  | 3261.00  | 3663.00  | 3770.00  | 4767.00  | 
    | MAIN-629       | AEC-629         | 13              | 21167.00 | 3937.00  | 3653.00  | 870.00   | 2952.00  | 341.00   | 903.00   | 533.00   | 1643.00  | 1948.00  | 3355.00  | 447.00   | 585.00   | 
    | MAIN-629       | AEC-629         | 14              | 30854.00 | 1485.00  | 2424.00  | 1928.00  | 4730.00  | 1273.00  | 3058.00  | 4975.00  | 1855.00  | 1313.00  | 308.00   | 3323.00  | 4182.00  | 
    | MAIN-629       | APPS-629        | 1               | 36433.00 | 3313.00  | 868.00   | 1938.00  | 1356.00  | 3102.00  | 2817.00  | 4985.00  | 2117.00  | 4457.00  | 3703.00  | 3333.00  | 4444.00  | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualValue |
    | 16TR-629         | 2             | 1               | 201808 | 2              | 0             | 8658.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 1               | 201809 | 2              | 0             | 5425.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 1               | 201810 | 2              | 0             | 5530.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 1               | 201811 | 2              | 0             | 3898.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 1               | 201812 | 2              | 0             | 6165.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 1               | 201901 | 2              | 0             | 6945.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 1               | 201902 | 2              | 0             | 6925.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 1               | 201903 | 2              | 0             | 3350.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 1               | 201904 | 2              | 0             | 4176.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 1               | 201905 | 2              | 0             | 7963.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 1               | 201906 | 2              | 0             | 6502.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 1               | 201907 | 2              | 0             | 4618.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | 16TR-629         | 2             | 2               | 201808 | 2              | 0             | 4646.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 2               | 201809 | 2              | 0             | 4236.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 2               | 201810 | 2              | 0             | 3145.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 2               | 201811 | 2              | 0             | 151.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 2               | 201812 | 2              | 0             | 4183.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 2               | 201901 | 2              | 0             | 3304.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 2               | 201902 | 2              | 0             | 4626.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 2               | 201903 | 2              | 0             | 660.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 2               | 201904 | 2              | 0             | 3972.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 2               | 201905 | 2              | 0             | 3939.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 2               | 201906 | 2              | 0             | 2722.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 2               | 201907 | 2              | 0             | 1420.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									      
    | 16TR-629         | 2             | 3               | 201808 | 2              | 0             | 4012.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 3               | 201809 | 2              | 0             | 1189.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 3               | 201810 | 2              | 0             | 2385.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 3               | 201811 | 2              | 0             | 3747.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 3               | 201812 | 2              | 0             | 1982.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 3               | 201901 | 2              | 0             | 3641.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 3               | 201902 | 2              | 0             | 2299.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 3               | 201903 | 2              | 0             | 2690.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 3               | 201904 | 2              | 0             | 204.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 3               | 201905 | 2              | 0             | 4024.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 3               | 201906 | 2              | 0             | 3780.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | 16TR-629         | 2             | 3               | 201907 | 2              | 0             | 3198.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #																																																									     
    | AEC-629          | 2             | 1               | 201808 | 2              | 0             | 5422.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEC-629          | 2             | 1               | 201809 | 2              | 0             | 6077.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEC-629          | 2             | 1               | 201810 | 2              | 0             | 2798.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEC-629          | 2             | 1               | 201811 | 2              | 0             | 7682.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEC-629          | 2             | 1               | 201812 | 2              | 0             | 1614.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEC-629          | 2             | 1               | 201901 | 2              | 0             | 3961.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEC-629          | 2             | 1               | 201902 | 2              | 0             | 5508.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEC-629          | 2             | 1               | 201903 | 2              | 0             | 3498.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEC-629          | 2             | 1               | 201904 | 2              | 0             | 3261.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEC-629          | 2             | 1               | 201905 | 2              | 0             | 3663.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEC-629          | 2             | 1               | 201906 | 2              | 0             | 3770.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEC-629          | 2             | 1               | 201907 | 2              | 0             | 4767.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    #
    | AEC-629          | 2             | 13              | 201808 | 2              | 0             | 3937.00      | 3937.00              | 0.00                | 0.00                   | 0.00                        | 3937.00          | ?           |
    | AEC-629          | 2             | 13              | 201809 | 2              | 0             | 3653.00      | 3653.00              | 0.00                | 0.00                   | 0.00                        | 3653.00          | ?           |
    | AEC-629          | 2             | 13              | 201810 | 2              | 0             | 870.00       | 870.00               | 0.00                | 0.00                   | 0.00                        | 870.00           | ?           |
    | AEC-629          | 2             | 13              | 201811 | 2              | 0             | 2952.00      | 2952.00              | 0.00                | 0.00                   | 0.00                        | 2952.00          | ?           |
    | AEC-629          | 2             | 13              | 201812 | 2              | 0             | 341.00       | 341.00               | 0.00                | 0.00                   | 0.00                        | 341.00           | ?           |
    | AEC-629          | 2             | 13              | 201901 | 2              | 0             | 903.00       | 903.00               | 0.00                | 0.00                   | 0.00                        | 903.00           | ?           |
    | AEC-629          | 2             | 13              | 201902 | 2              | 0             | 533.00       | 533.00               | 0.00                | 0.00                   | 0.00                        | 533.00           | ?           |
    | AEC-629          | 2             | 13              | 201903 | 2              | 0             | 1643.00      | 1643.00              | 0.00                | 0.00                   | 0.00                        | 1643.00          | ?           |
    | AEC-629          | 2             | 13              | 201904 | 2              | 0             | 1948.00      | 1948.00              | 0.00                | 0.00                   | 0.00                        | 1948.00          | ?           |
    | AEC-629          | 2             | 13              | 201905 | 2              | 0             | 3355.00      | 3355.00              | 0.00                | 0.00                   | 0.00                        | 3355.00          | ?           |
    | AEC-629          | 2             | 13              | 201906 | 2              | 0             | 447.00       | 447.00               | 0.00                | 0.00                   | 0.00                        | 447.00           | ?           |
    | AEC-629          | 2             | 13              | 201907 | 2              | 0             | 585.00       | 585.00               | 0.00                | 0.00                   | 0.00                        | 585.00           | ?           |
    #																																																									      
    | AEC-629          | 2             | 14              | 201808 | 2              | 0             | 1485.00      | 1485.00              | 0.00                | 0.00                   | 0.00                        | 1485.00          | ?           |
    | AEC-629          | 2             | 14              | 201809 | 2              | 0             | 2424.00      | 2424.00              | 0.00                | 0.00                   | 0.00                        | 2424.00          | ?           |
    | AEC-629          | 2             | 14              | 201810 | 2              | 0             | 1928.00      | 1928.00              | 0.00                | 0.00                   | 0.00                        | 1928.00          | ?           |
    | AEC-629          | 2             | 14              | 201811 | 2              | 0             | 4730.00      | 4730.00              | 0.00                | 0.00                   | 0.00                        | 4730.00          | ?           |
    | AEC-629          | 2             | 14              | 201812 | 2              | 0             | 1273.00      | 1273.00              | 0.00                | 0.00                   | 0.00                        | 1273.00          | ?           |
    | AEC-629          | 2             | 14              | 201901 | 2              | 0             | 3058.00      | 3058.00              | 0.00                | 0.00                   | 0.00                        | 3058.00          | ?           |
    | AEC-629          | 2             | 14              | 201902 | 2              | 0             | 4975.00      | 4975.00              | 0.00                | 0.00                   | 0.00                        | 4975.00          | ?           |
    | AEC-629          | 2             | 14              | 201903 | 2              | 0             | 1855.00      | 1855.00              | 0.00                | 0.00                   | 0.00                        | 1855.00          | ?           |
    | AEC-629          | 2             | 14              | 201904 | 2              | 0             | 1313.00      | 1313.00              | 0.00                | 0.00                   | 0.00                        | 1313.00          | ?           |
    | AEC-629          | 2             | 14              | 201905 | 2              | 0             | 308.00       | 308.00               | 0.00                | 0.00                   | 0.00                        | 308.00           | ?           |
    | AEC-629          | 2             | 14              | 201906 | 2              | 0             | 3323.00      | 3323.00              | 0.00                | 0.00                   | 0.00                        | 3323.00          | ?           |
    | AEC-629          | 2             | 14              | 201907 | 2              | 0             | 4182.00      | 4182.00              | 0.00                | 0.00                   | 0.00                        | 4182.00          | ?           |
    #																																																									      
    | APPS-629         | 2             | 1               | 201808 | 2              | 0             | 3313.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-629         | 2             | 1               | 201809 | 2              | 0             | 868.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-629         | 2             | 1               | 201810 | 2              | 0             | 1938.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-629         | 2             | 1               | 201811 | 2              | 0             | 1356.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-629         | 2             | 1               | 201812 | 2              | 0             | 3102.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-629         | 2             | 1               | 201901 | 2              | 0             | 2817.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-629         | 2             | 1               | 201902 | 2              | 0             | 4985.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-629         | 2             | 1               | 201903 | 2              | 0             | 2117.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-629         | 2             | 1               | 201904 | 2              | 0             | 4457.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-629         | 2             | 1               | 201905 | 2              | 0             | 3703.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-629         | 2             | 1               | 201906 | 2              | 0             | 3333.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | APPS-629         | 2             | 1               | 201907 | 2              | 0             | 4444.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |

    # Check the PROFILE subnominal aggregations in PaaS
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017629 | ORG0017629 | AEC-629           | 2371010         | AEBC1819                   | 201808               | PROFILE         | CM             | False       | 5422.00         |
    | 10017629 | ORG0017629 | AEC-629           | 2371010         | AEBC1819                   | 201809               | PROFILE         | CM             | False       | 6077.00         |
    | 10017629 | ORG0017629 | AEC-629           | 2371010         | AEBC1819                   | 201810               | PROFILE         | CM             | False       | 2798.00         |
    | 10017629 | ORG0017629 | AEC-629           | 2371010         | AEBC1819                   | 201811               | PROFILE         | CM             | False       | 7682.00         |
    | 10017629 | ORG0017629 | AEC-629           | 2371010         | AEBC1819                   | 201812               | PROFILE         | CM             | False       | 1614.00         |
    | 10017629 | ORG0017629 | AEC-629           | 2371010         | AEBC1819                   | 201901               | PROFILE         | CM             | False       | 3961.00         |
    | 10017629 | ORG0017629 | AEC-629           | 2371010         | AEBC1819                   | 201902               | PROFILE         | CM             | False       | 5508.00         |
    | 10017629 | ORG0017629 | AEC-629           | 2371010         | AEBC1819                   | 201903               | PROFILE         | CM             | False       | 3498.00         |
    | 10017629 | ORG0017629 | AEC-629           | 2371010         | AEBC1819                   | 201904               | PROFILE         | CM             | False       | 3261.00         |
    | 10017629 | ORG0017629 | AEC-629           | 2371010         | AEBC1819                   | 201905               | PROFILE         | CM             | False       | 3663.00         |
    | 10017629 | ORG0017629 | AEC-629           | 2371010         | AEBC1819                   | 201906               | PROFILE         | CM             | False       | 3770.00         |
    | 10017629 | ORG0017629 | AEC-629           | 2371010         | AEBC1819                   | 201907               | PROFILE         | CM             | False       | 4767.00         |

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Run the payment batch to create AEBC (PoP) payment files
    Given the override date is '03/08/2018 22:05'
    
	# Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
	And   there is no data in the Payment feed for FundingStreamPeriod 'AEBC1819' AccountingPaymentPeriod '201805' CensusEndDate '03/08/2018' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaaS. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | AEC-629                  | 201808 |

    # PaymentGeneration.PaymentTimetable
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEBC1819                   | 201808               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEBC1819                   | 201808               | Completed |

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEBC1819' PaymentPeriod '201805' CensusEndDate '03/08/2018' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AECO                   | 2018          | 05             | 03          | ?       | AEC-629       | 5422.00         | PROFILE          | Adult Education Budg               | 2018-08-15 | 2018-08-01   | 2019-07-31 | ?              | 10017629 | 2371010    |

    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'AEBC1819' AccountingPaymentPeriod '201805' and CensusEndDate '03/08/2018'

    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                              |
    | Payment Requests for Funding Stream Period AEBC1819 for Payment Period 201805 have been generated as of Census End Date/Time 2018-08-03T22:00:00Z. |

    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate        | PaymentLineCount | TotalValue |
    | AEBC1819            | 201805        | 2018-08-03T22:00:00Z | 1                | 5422.00    |

    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | AECO      | 01/08/2018   | 31/07/2019 | 03/08/2018    | 15/08/2018 | 2018          | 05             |

    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017629  | 10017629       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEC-629    | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2371010    | PROFILE        | Adult Education Budg          | 5422.00         |




    # Change the date
    Given the override date is '04/02/2019'

    # Clear down the DEDS
    And   there are no entries in the DCFS stub table 

    # Month End is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    # Pull actuals from DC for Jan 2019
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS21               | ORG0017629     | CM             | 201808 | APPS1819                | APPS-629                 |            | 8               | 0            | 1087.77     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201808 | APPS1819                | APPS-629                 |            | 9               | 0            | 846.79      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201808 | APPS1819                | APPS-629                 |            | 10              | 0            | 911.33      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201808 | APPS1819                | APPS-629                 |            | 22              | 0            | 505.39      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201808 | APPS1819                | APPS-629                 |            | 23              | 0            | 522.73      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201808 | APPS1819                | APPS-629                 |            | 24              | 0            | 1184.64     |
    #
    | APPS           | APPS21               | ORG0017629     | CM             | 201809 | APPS1819                | APPS-629                 |            | 8               | 0            | 119.62      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201809 | APPS1819                | APPS-629                 |            | 9               | 0            | 1165.02     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201809 | APPS1819                | APPS-629                 |            | 10              | 0            | 1240.29     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201809 | APPS1819                | APPS-629                 |            | 22              | 0            | 1092.66     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201809 | APPS1819                | APPS-629                 |            | 23              | 0            | 163.49      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201809 | APPS1819                | APPS-629                 |            | 24              | 0            | 679.64      |
    #
    | APPS           | APPS21               | ORG0017629     | CM             | 201810 | APPS1819                | APPS-629                 |            | 8               | 0            | 1307.67     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201810 | APPS1819                | APPS-629                 |            | 9               | 0            | 1206.67     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201810 | APPS1819                | APPS-629                 |            | 10              | 0            | 622.95      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201810 | APPS1819                | APPS-629                 |            | 22              | 0            | 1446.74     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201810 | APPS1819                | APPS-629                 |            | 23              | 0            | 1320.03     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201810 | APPS1819                | APPS-629                 |            | 24              | 0            | 178.73      |
    #
    | APPS           | APPS21               | ORG0017629     | CM             | 201811 | APPS1819                | APPS-629                 |            | 8               | 0            | 1429.38     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201811 | APPS1819                | APPS-629                 |            | 9               | 0            | 609.62      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201811 | APPS1819                | APPS-629                 |            | 10              | 0            | 834.82      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201811 | APPS1819                | APPS-629                 |            | 22              | 0            | 1173.96     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201811 | APPS1819                | APPS-629                 |            | 23              | 0            | 174.90      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201811 | APPS1819                | APPS-629                 |            | 24              | 0            | 929.44      |
    #
    | APPS           | APPS21               | ORG0017629     | CM             | 201812 | APPS1819                | APPS-629                 |            | 8               | 0            | 756.18      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201812 | APPS1819                | APPS-629                 |            | 9               | 0            | 517.43      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201812 | APPS1819                | APPS-629                 |            | 10              | 0            | 971.78      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201812 | APPS1819                | APPS-629                 |            | 22              | 0            | 1006.95     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201812 | APPS1819                | APPS-629                 |            | 23              | 0            | 469.31      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201812 | APPS1819                | APPS-629                 |            | 24              | 0            | 491.08      |
    #
    | APPS           | APPS21               | ORG0017629     | CM             | 201901 | APPS1819                | APPS-629                 |            | 8               | 0            | 1261.73     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201901 | APPS1819                | APPS-629                 |            | 9               | 0            | 1254.45     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201901 | APPS1819                | APPS-629                 |            | 10              | 0            | 924.83      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201901 | APPS1819                | APPS-629                 |            | 22              | 0            | 1480.54     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201901 | APPS1819                | APPS-629                 |            | 23              | 0            | 1375.35     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201901 | APPS1819                | APPS-629                 |            | 24              | 0            | 417.61      |
    #
    | APPS           | APPS21               | ORG0017629     | CM             | 201902 | APPS1819                | APPS-629                 |            | 8               | 0            | 1073.16     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201902 | APPS1819                | APPS-629                 |            | 9               | 0            | 1472.01     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201902 | APPS1819                | APPS-629                 |            | 10              | 0            | 441.50      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201902 | APPS1819                | APPS-629                 |            | 22              | 0            | 847.42      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201902 | APPS1819                | APPS-629                 |            | 23              | 0            | 248.91      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201902 | APPS1819                | APPS-629                 |            | 24              | 0            | 1499.19     |
    #
    | APPS           | APPS21               | ORG0017629     | CM             | 201903 | APPS1819                | APPS-629                 |            | 8               | 0            | 1046.65     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201903 | APPS1819                | APPS-629                 |            | 9               | 0            | 121.98      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201903 | APPS1819                | APPS-629                 |            | 10              | 0            | 905.26      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201903 | APPS1819                | APPS-629                 |            | 22              | 0            | 240.07      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201903 | APPS1819                | APPS-629                 |            | 23              | 0            | 244.23      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201903 | APPS1819                | APPS-629                 |            | 24              | 0            | 1218.44     |
    #
    | APPS           | APPS21               | ORG0017629     | CM             | 201904 | APPS1819                | APPS-629                 |            | 8               | 0            | 498.27      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201904 | APPS1819                | APPS-629                 |            | 9               | 0            | 163.90      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201904 | APPS1819                | APPS-629                 |            | 10              | 0            | 514.08      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201904 | APPS1819                | APPS-629                 |            | 22              | 0            | 634.81      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201904 | APPS1819                | APPS-629                 |            | 23              | 0            | 521.36      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201904 | APPS1819                | APPS-629                 |            | 24              | 0            | 1428.00     |
    #
    | APPS           | APPS21               | ORG0017629     | CM             | 201905 | APPS1819                | APPS-629                 |            | 8               | 0            | 1471.77     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201905 | APPS1819                | APPS-629                 |            | 9               | 0            | 661.92      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201905 | APPS1819                | APPS-629                 |            | 10              | 0            | 489.59      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201905 | APPS1819                | APPS-629                 |            | 22              | 0            | 324.61      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201905 | APPS1819                | APPS-629                 |            | 23              | 0            | 327.95      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201905 | APPS1819                | APPS-629                 |            | 24              | 0            | 1005.22     |
    #
    | APPS           | APPS21               | ORG0017629     | CM             | 201906 | APPS1819                | APPS-629                 |            | 8               | 0            | 674.10      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201906 | APPS1819                | APPS-629                 |            | 9               | 0            | 677.87      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201906 | APPS1819                | APPS-629                 |            | 10              | 0            | 1097.82     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201906 | APPS1819                | APPS-629                 |            | 22              | 0            | 556.69      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201906 | APPS1819                | APPS-629                 |            | 23              | 0            | 986.45      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201906 | APPS1819                | APPS-629                 |            | 24              | 0            | 390.58      |
    #
    | APPS           | APPS21               | ORG0017629     | CM             | 201907 | APPS1819                | APPS-629                 |            | 8               | 0            | 360.42      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201907 | APPS1819                | APPS-629                 |            | 9               | 0            | 916.70      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201907 | APPS1819                | APPS-629                 |            | 10              | 0            | 213.00      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201907 | APPS1819                | APPS-629                 |            | 22              | 0            | 741.16      |
    | APPS           | APPS21               | ORG0017629     | CM             | 201907 | APPS1819                | APPS-629                 |            | 23              | 0            | 1368.03     |
    | APPS           | APPS21               | ORG0017629     | CM             | 201907 | APPS1819                | APPS-629                 |            | 24              | 0            | 465.91      |
    #
    | ILR1819        | R06                  | ORG0017629     | CM             | 201808 | APPS1819                | APPS-629                 |            | 2               | 0            | 1199.30     |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201808 | APPS1819                | APPS-629                 |            | 3               | 0            | 630.46      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201808 | APPS1819                | APPS-629                 |            | 4               | 0            | 505.53      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201808 | APPS1819                | APPS-629                 |            | 19              | 0            | 1382.63     |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201808 | APPS1819                | APPS-629                 |            | 20              | 0            | 702.36      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201808 | APPS1819                | APPS-629                 |            | 21              | 0            | 1049.13     |
    #
    | ILR1819        | R06                  | ORG0017629     | CM             | 201809 | APPS1819                | APPS-629                 |            | 2               | 0            | 803.44      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201809 | APPS1819                | APPS-629                 |            | 3               | 0            | 819.23      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201809 | APPS1819                | APPS-629                 |            | 4               | 0            | 748.17      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201809 | APPS1819                | APPS-629                 |            | 19              | 0            | 764.24      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201809 | APPS1819                | APPS-629                 |            | 20              | 0            | 460.17      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201809 | APPS1819                | APPS-629                 |            | 21              | 0            | 980.25      |
    #
    | ILR1819        | R06                  | ORG0017629     | CM             | 201810 | APPS1819                | APPS-629                 |            | 2               | 0            | 858.90      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201810 | APPS1819                | APPS-629                 |            | 3               | 0            | 318.82      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201810 | APPS1819                | APPS-629                 |            | 4               | 0            | 1413.97     |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201810 | APPS1819                | APPS-629                 |            | 19              | 0            | 203.53      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201810 | APPS1819                | APPS-629                 |            | 20              | 0            | 247.63      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201810 | APPS1819                | APPS-629                 |            | 21              | 0            | 564.37      |
    #
    | ILR1819        | R06                  | ORG0017629     | CM             | 201811 | APPS1819                | APPS-629                 |            | 2               | 0            | 279.55      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201811 | APPS1819                | APPS-629                 |            | 3               | 0            | 100.33      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201811 | APPS1819                | APPS-629                 |            | 4               | 0            | 851.51      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201811 | APPS1819                | APPS-629                 |            | 19              | 0            | 842.30      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201811 | APPS1819                | APPS-629                 |            | 20              | 0            | 225.49      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201811 | APPS1819                | APPS-629                 |            | 21              | 0            | 1160.82     |
    #
    | ILR1819        | R06                  | ORG0017629     | CM             | 201812 | APPS1819                | APPS-629                 |            | 2               | 0            | 662.58      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201812 | APPS1819                | APPS-629                 |            | 3               | 0            | 746.62      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201812 | APPS1819                | APPS-629                 |            | 4               | 0            | 789.03      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201812 | APPS1819                | APPS-629                 |            | 19              | 0            | 482.12      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201812 | APPS1819                | APPS-629                 |            | 20              | 0            | 1043.11     |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201812 | APPS1819                | APPS-629                 |            | 21              | 0            | 459.28      |
    #
    | ILR1819        | R06                  | ORG0017629     | CM             | 201901 | APPS1819                | APPS-629                 |            | 2               | 0            | 225.85      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201901 | APPS1819                | APPS-629                 |            | 3               | 0            | 143.33      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201901 | APPS1819                | APPS-629                 |            | 4               | 0            | 551.80      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201901 | APPS1819                | APPS-629                 |            | 19              | 0            | 1156.87     |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201901 | APPS1819                | APPS-629                 |            | 20              | 0            | 1399.04     |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201901 | APPS1819                | APPS-629                 |            | 21              | 0            | 563.42      |
    #
    | ILR1819        | R06                  | ORG0017629     | CM             | 201902 | APPS1819                | APPS-629                 |            | 2               | 0            | 860.12      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201902 | APPS1819                | APPS-629                 |            | 3               | 0            | 212.96      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201902 | APPS1819                | APPS-629                 |            | 4               | 0            | 988.12      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201902 | APPS1819                | APPS-629                 |            | 19              | 0            | 140.44      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201902 | APPS1819                | APPS-629                 |            | 20              | 0            | 583.55      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201902 | APPS1819                | APPS-629                 |            | 21              | 0            | 866.74      |
    #
    | ILR1819        | R06                  | ORG0017629     | CM             | 201903 | APPS1819                | APPS-629                 |            | 2               | 0            | 1392.14     |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201903 | APPS1819                | APPS-629                 |            | 3               | 0            | 853.55      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201903 | APPS1819                | APPS-629                 |            | 4               | 0            | 668.99      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201903 | APPS1819                | APPS-629                 |            | 19              | 0            | 860.45      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201903 | APPS1819                | APPS-629                 |            | 20              | 0            | 1240.53     |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201903 | APPS1819                | APPS-629                 |            | 21              | 0            | 857.28      |
    #
    | ILR1819        | R06                  | ORG0017629     | CM             | 201904 | APPS1819                | APPS-629                 |            | 2               | 0            | 698.55      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201904 | APPS1819                | APPS-629                 |            | 3               | 0            | 812.70      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201904 | APPS1819                | APPS-629                 |            | 4               | 0            | 418.89      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201904 | APPS1819                | APPS-629                 |            | 19              | 0            | 608.84      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201904 | APPS1819                | APPS-629                 |            | 20              | 0            | 1326.37     |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201904 | APPS1819                | APPS-629                 |            | 21              | 0            | 769.22      |
    #
    | ILR1819        | R06                  | ORG0017629     | CM             | 201905 | APPS1819                | APPS-629                 |            | 2               | 0            | 366.88      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201905 | APPS1819                | APPS-629                 |            | 3               | 0            | 1057.69     |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201905 | APPS1819                | APPS-629                 |            | 4               | 0            | 1146.38     |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201905 | APPS1819                | APPS-629                 |            | 19              | 0            | 267.36      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201905 | APPS1819                | APPS-629                 |            | 20              | 0            | 261.65      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201905 | APPS1819                | APPS-629                 |            | 21              | 0            | 343.28      |
    #
    | ILR1819        | R06                  | ORG0017629     | CM             | 201906 | APPS1819                | APPS-629                 |            | 2               | 0            | 167.36      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201906 | APPS1819                | APPS-629                 |            | 3               | 0            | 1100.75     |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201906 | APPS1819                | APPS-629                 |            | 4               | 0            | 846.23      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201906 | APPS1819                | APPS-629                 |            | 19              | 0            | 121.95      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201906 | APPS1819                | APPS-629                 |            | 20              | 0            | 703.60      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201906 | APPS1819                | APPS-629                 |            | 21              | 0            | 662.77      |
    #
    | ILR1819        | R06                  | ORG0017629     | CM             | 201907 | APPS1819                | APPS-629                 |            | 2               | 0            | 485.41      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201907 | APPS1819                | APPS-629                 |            | 3               | 0            | 1479.53     |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201907 | APPS1819                | APPS-629                 |            | 4               | 0            | 1223.63     |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201907 | APPS1819                | APPS-629                 |            | 19              | 0            | 359.56      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201907 | APPS1819                | APPS-629                 |            | 20              | 0            | 208.75      |
    | ILR1819        | R06                  | ORG0017629     | CM             | 201907 | APPS1819                | APPS-629                 |            | 21              | 0            | 705.86      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check MonitoringDeliverables.HeldReportedActualGroup. Is the data showing as unprocessed ?
    Then  there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017629' and Collection 'R06' marked as unprocessed
    And   there is '1' row on table HeldReportedActualGroup for FSP 'APPS1819' OrgId 'ORG0017629' and Collection 'APPS21' marked as unprocessed
	
	# Mark MonthEnd as closed and launch the process which checks and, if appropriate, consumes the held actuals
	When  MonthEnd processing has completed and the processing of held data is triggered

   # Check the ACTUAL VALUES in CRM
   #Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-629       | APPS-629        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-629       | APPS-629        | 2               | 4029.62  | 1199.30  | 803.44   | 858.90   | 279.55   | 662.58   | 225.85   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-629       | APPS-629        | 3               | 2758.79  | 630.46   | 819.23   | 318.82   | 100.33   | 746.62   | 143.33   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-629       | APPS-629        | 4               | 4860.01  | 505.53   | 748.17   | 1413.97  | 851.51   | 789.03   | 551.80   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-629       | APPS-629        | 8               | 5962.35  | 1087.77  | 119.62   | 1307.67  | 1429.38  | 756.18   | 1261.73  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-629       | APPS-629        | 9               | 5599.98  | 846.79   | 1165.02  | 1206.67  | 609.62   | 517.43   | 1254.45  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-629       | APPS-629        | 10              | 5506.00  | 911.33   | 1240.29  | 622.95   | 834.82   | 971.78   | 924.83   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-629       | APPS-629        | 19              | 4831.69  | 1382.63  | 764.24   | 203.53   | 842.30   | 482.12   | 1156.87  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-629       | APPS-629        | 20              | 4077.80  | 702.36   | 460.17   | 247.63   | 225.49   | 1043.11  | 1399.04  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-629       | APPS-629        | 21              | 4777.27  | 1049.13  | 980.25   | 564.37   | 1160.82  | 459.28   | 563.42   | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-629       | APPS-629        | 22              | 6706.24  | 505.39   | 1092.66  | 1446.74  | 1173.96  | 1006.95  | 1480.54  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-629       | APPS-629        | 23              | 4025.81  | 522.73   | 163.49   | 1320.03  | 174.90   | 469.31   | 1375.35  | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-629       | APPS-629        | 24              | 3881.14  | 1184.64  | 679.64   | 178.73   | 929.44   | 491.08   | 417.61   | ?        | ?        | ?        | ?        | ?        | ?        | 




    # Payment Batch stuff for APPS1819

    # Change the date
    Given the override date is '07/02/2019 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'APPS1819' AccountingPaymentPeriod '201810' CensusEndDate '07/02/2019' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaaS. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | APPS-629                 | 201901 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | APPS1819                   | 201901               |                      | A              | NotStarted |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | APPS1819                   | 201901               | Completed |




    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'APPS1819' AccountingPaymentPeriod '201810' and CensusEndDate '07/02/2019'

    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                              |
    | Payment Requests for Funding Stream Period APPS1819 for Payment Period 201810 have been generated as of Census End Date/Time 2019-02-07T22:00:00Z. |

    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate        | PaymentLineCount | TotalValue |
    | APPS1819            | 201810        | 2019-02-07T22:00:00Z | 11               | 20496.00   |

    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | APPS      | 01/08/2018   | 31/07/2019 | 07/02/2019    | 15/02/2019 | 2018          | 10             |

    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017629  | 10017629       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-629   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240100    | CAPPING        | 16-18 Apps                    | -9927.32        |
    | ORG0017629  | 10017629       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-629   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240100    | RECONCILIATION | 16-18 Apps                    | 11648.42        |
    | ORG0017629  | 10017629       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-629   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240150    | CAPPING        | 16-18NonLevy Apps             | -9853.95        |
    | ORG0017629  | 10017629       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-629   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240150    | RECONCILIATION | 16-18NonLevy Apps             | 11562.33        |
    | ORG0017629  | 10017629       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-629   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2240160    | RECONCILIATION | 16-18NonLevy AppsEmp          | 5506.00         |
    | ORG0017629  | 10017629       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-629   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340100    | CAPPING        | 19+ Apps                      | -7593.08        |
    | ORG0017629  | 10017629       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-629   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340100    | RECONCILIATION | 19+ Apps                      | 8909.49         |
    | ORG0017629  | 10017629       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-629   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340150    | CAPPING        | 19+NonLevy Apps               | -9146.35        |
    | ORG0017629  | 10017629       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-629   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340150    | RECONCILIATION | 19+NonLevy Apps               | 10732.05        |
    | ORG0017629  | 10017629       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-629   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340160    | RECONCILIATION | 19+NonLevy AppsEmp            | 3881.14         |
    | ORG0017629  | 10017629       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | APPS-629   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2340170    | RECONCILIATION | 19+ Apps Tblz Emp             | 4777.27         |



    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20210702
@Long2Run @Long2Run67
Scenario: A630 Create an 1819 procured AEB contract with AEB-CL (PoP), AEB-LS (PoP) and AEB-TOL (PoA) allocations. Bulk update draft. Step through Tasks until Published then approve. Create PoP payment files. Consume Actuals. Create PoA payment files. Check CRM, Tasks, Financials, PaaS, ADP feed and Payment feed
    Given there is no Contract, Task or Workflow data for UKPRN '10017630' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AEBC-630      |
    | AEBL-630      |
    | AEBT-630      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017630' 
    And   caseload advisor 'FCS2 TEST' is assigned to provider '10017630 Co Ltd' with UKPRN '10017630' and OrgId 'ORG0017630' and has 'FCS1 TEST' as a manager 
    And   UPIN '117630' is associated with UKPRN '10017630' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017630 | 117630 | 10017630 Co Ltd | 0              | Active | Yes           | AA017630      | ?             | 




    # Change the date
    Given the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017630 | 10017630 Co Ltd      | ESFA-630             | AEBP-630       | 1                     | 01/08/2018        | 31/07/2019      | 58706.00      |                                | Contract for Services | 1819   | New          | ORG0017630 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017630 | AEBP-630       | AEBC-630      | AEB-CL            | AEB-CL1819              | AY                      | 01/08/2018          | 31/07/2019        | 17183.00        |                         |            |                                                             | New          |             |
    | 10017630 | AEBP-630       | AEBL-630      | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 20502.00        |                         |            |                                                             | New          |             |
    | 10017630 | AEBP-630       | AEBT-630      | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 21021.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017630 | AEBP-630       | AEBC-630      | 1               | 0                     | 17183.00  | 952.00   | 2025.00  | 443.00   | 3748.00  | 2552.00  | 108.00   | 2178.00  | 420.00   | 431.00   | 3006.00  | 1102.00  | 218.00   | Adult Education Budget - Community Learning                     | New          |             |
    | 10017630 | AEBP-630       | AEBL-630      | 1               | 0                     | 20502.00  | 1144.00  | 1463.00  | 1163.00  | 3560.00  | 3676.00  | 1535.00  | 1079.00  | 643.00   | 652.00   | 2443.00  | 1567.00  | 1577.00  | Adult Education Budget - Learner Support                        | New          |             |
    | 10017630 | AEBP-630       | AEBT-630      | 1               | 0                     | 21021.00  | 2687.00  | 1257.00  | 2393.00  | 818.00   | 738.00   | 2209.00  | 348.00   | 1744.00  | 3402.00  | 1017.00  | 2956.00  | 1452.00  | Adult Education - Traineeships and Other Learning Total Funding | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '04/07/2018'

    # Bulk import to do an update draft on the AEB contract
    And   there are no files prefixed '10017630_AEB' in the Sharepoint 'AEB-1819-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1819 04052018093716 v2_A630' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1819 04052018093716 v2_A630' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1819 04052018093716 v2_A630.xlsx' exists in the Datafiles folder and UKPRN '10017630' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

#   # Create a dummy Appendix file containing just the word 'Appendices'
#   Given there are no files prefixed '10017630_AEBP-630' in the Sharepoint 'AEB-1819-Input-Appendices' folder
#   And   a file with filename '10017630_AEBP-630_v1.pdf' is created in 'AEB-1819-Input-Appendices'

    # Create two dummy Terms and Conditions files. Each has just one page containing just the work 'Appendices'
    Given there are no files prefixed '10017630_AEBP-630' in the Sharepoint 'AEB-1819-Input-Terms And Conditions' folder
    And   a file with filename '10017630_AEBP-630_11.pdf' is created in 'AEB-1819-Input-Terms And Conditions'
    And   a file with filename '10017630_AEBP-630_61.pdf' is created in 'AEB-1819-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '1' of contract 'AEBP-630' for provider '10017630' is triggered by User 'FCS2 TEST'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'AEBP-630' for provider '10017630'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017630 - 10017630 Co Ltd Please review the contract       | AEBP-630       | FCS2 Test                | Contract Advisers Team   | Open            | Not Started      |


    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '1' of contract 'AEBP-630' for provider '10017630' is triggered by User 'FCS2 TEST'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 TEST                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'AEBP-630' for provider '10017630'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017630 - 10017630 Co Ltd                                  | AEBP-630       | FCS1 TEST                 | Contract Managers Team   | Open            | Not Started      |


    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When  the following open Task currently linked to version '1' of contract 'AEBP-630' for provider '10017630' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 TEST                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'AEBP-630' for provider '10017630'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017630 - 10017630 Co Ltd                                  | AEBP-630       | Lead Manager Team         | ?                        | Open            | Not Started      |


    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When  the following open Task currently linked to version '1' of contract 'AEBP-630' for provider '10017630' is triggered by User 'FCS2 TEST'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |


    # Check that the Tasks on the contract are all marked as completed
    Then  the following Tasks are present against version '1' of contract 'AEBP-630' for provider '10017630'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017630 - 10017630 Co Ltd                                  | AEBP-630       | Lead Manager Team         | ?                        | Completed       | Completed        |
    | Confirm Internal Approval        | 10017630 - 10017630 Co Ltd                                  | AEBP-630       | FCS1 TEST                 | Contract Managers Team   | Completed       | Completed        |
    | Review Contract Details          | 10017630 - 10017630 Co Ltd Please review the contract       | AEBP-630       | FCS2 TEST                 | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017630 - 10017630 Co Ltd Awaiting documentation           | AEBP-630       | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017630 | AEBP-630           | 1                     | 1                        | Draft            | Published to Provider     | True          | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017630 | AEBP-630           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017630 | ESFA-630           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Change the date
    Given the override date is '09/07/2018'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-630' and actual ContractNumber 'AEBP-630'

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017630 | AEBP-630           | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017630 | AEBP-630           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017630 | ESFA-630           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'AEBP-630'

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-630       | AEBC-630        | 1               | 23541.00 | 1461.00  | 1051.00  | 4912.00  | 1917.00  | 998.00   | 119.00   | 1441.00  | 2426.00  | 787.00   | 754.00   | 4489.00  | 3186.00  | 
    | AEBP-630       | AEBL-630        | 1               | 25845.00 | 1752.00  | 3881.00  | 126.00   | 1488.00  | 4674.00  | 1382.00  | 4991.00  | 430.00   | 2896.00  | 1765.00  | 1521.00  | 939.00   | 
    | AEBP-630       | AEBT-630        | 1               | 26259.00 | 1061.00  | 776.00   | 2945.00  | 76.00    | 2416.00  | 2977.00  | 2607.00  | 3718.00  | 4022.00  | 479.00   | 2522.00  | 2660.00  | 
    | AEBP-630       | AEBT-630        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-630       | AEBT-630        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-630       | AEBT-630        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-630       | AEBT-630        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP-630       | AEBT-630        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualValue |
    | AEBC-630         | 1             | 1               | 201808 | 2              | 0             | 1461.00      | 1461.00              | 0.00                | 0.00                   | 0.00                        | 1461.00          | ?           |
    | AEBC-630         | 1             | 1               | 201809 | 2              | 0             | 1051.00      | 1051.00              | 0.00                | 0.00                   | 0.00                        | 1051.00          | ?           |
    | AEBC-630         | 1             | 1               | 201810 | 2              | 0             | 4912.00      | 4912.00              | 0.00                | 0.00                   | 0.00                        | 4912.00          | ?           |
    | AEBC-630         | 1             | 1               | 201811 | 2              | 0             | 1917.00      | 1917.00              | 0.00                | 0.00                   | 0.00                        | 1917.00          | ?           |
    | AEBC-630         | 1             | 1               | 201812 | 2              | 0             | 998.00       | 998.00               | 0.00                | 0.00                   | 0.00                        | 998.00           | ?           |
    | AEBC-630         | 1             | 1               | 201901 | 2              | 0             | 119.00       | 119.00               | 0.00                | 0.00                   | 0.00                        | 119.00           | ?           |
    | AEBC-630         | 1             | 1               | 201902 | 2              | 0             | 1441.00      | 1441.00              | 0.00                | 0.00                   | 0.00                        | 1441.00          | ?           |
    | AEBC-630         | 1             | 1               | 201903 | 2              | 0             | 2426.00      | 2426.00              | 0.00                | 0.00                   | 0.00                        | 2426.00          | ?           |
    | AEBC-630         | 1             | 1               | 201904 | 2              | 0             | 787.00       | 787.00               | 0.00                | 0.00                   | 0.00                        | 787.00           | ?           |
    | AEBC-630         | 1             | 1               | 201905 | 2              | 0             | 754.00       | 754.00               | 0.00                | 0.00                   | 0.00                        | 754.00           | ?           |
    | AEBC-630         | 1             | 1               | 201906 | 2              | 0             | 4489.00      | 4489.00              | 0.00                | 0.00                   | 0.00                        | 4489.00          | ?           |
    | AEBC-630         | 1             | 1               | 201907 | 2              | 0             | 3186.00      | 3186.00              | 0.00                | 0.00                   | 0.00                        | 3186.00          | ?           |
	#																																																									      
    | AEBL-630         | 1             | 1               | 201808 | 2              | 0             | 1752.00      | 1752.00              | 0.00                | 0.00                   | 0.00                        | 1752.00          | ?           |
    | AEBL-630         | 1             | 1               | 201809 | 2              | 0             | 3881.00      | 3881.00              | 0.00                | 0.00                   | 0.00                        | 3881.00          | ?           |
    | AEBL-630         | 1             | 1               | 201810 | 2              | 0             | 126.00       | 126.00               | 0.00                | 0.00                   | 0.00                        | 126.00           | ?           |
    | AEBL-630         | 1             | 1               | 201811 | 2              | 0             | 1488.00      | 1488.00              | 0.00                | 0.00                   | 0.00                        | 1488.00          | ?           |
    | AEBL-630         | 1             | 1               | 201812 | 2              | 0             | 4674.00      | 4674.00              | 0.00                | 0.00                   | 0.00                        | 4674.00          | ?           |
    | AEBL-630         | 1             | 1               | 201901 | 2              | 0             | 1382.00      | 1382.00              | 0.00                | 0.00                   | 0.00                        | 1382.00          | ?           |
    | AEBL-630         | 1             | 1               | 201902 | 2              | 0             | 4991.00      | 4991.00              | 0.00                | 0.00                   | 0.00                        | 4991.00          | ?           |
    | AEBL-630         | 1             | 1               | 201903 | 2              | 0             | 430.00       | 430.00               | 0.00                | 0.00                   | 0.00                        | 430.00           | ?           |
    | AEBL-630         | 1             | 1               | 201904 | 2              | 0             | 2896.00      | 2896.00              | 0.00                | 0.00                   | 0.00                        | 2896.00          | ?           |
    | AEBL-630         | 1             | 1               | 201905 | 2              | 0             | 1765.00      | 1765.00              | 0.00                | 0.00                   | 0.00                        | 1765.00          | ?           |
    | AEBL-630         | 1             | 1               | 201906 | 2              | 0             | 1521.00      | 1521.00              | 0.00                | 0.00                   | 0.00                        | 1521.00          | ?           |
    | AEBL-630         | 1             | 1               | 201907 | 2              | 0             | 939.00       | 939.00               | 0.00                | 0.00                   | 0.00                        | 939.00           | ?           |
    #																																																									      
    | AEBT-630         | 1             | 1               | 201808 | 2              | 0             | 1061.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEBT-630         | 1             | 1               | 201809 | 2              | 0             | 776.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEBT-630         | 1             | 1               | 201810 | 2              | 0             | 2945.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEBT-630         | 1             | 1               | 201811 | 2              | 0             | 76.00        | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEBT-630         | 1             | 1               | 201812 | 2              | 0             | 2416.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEBT-630         | 1             | 1               | 201901 | 2              | 0             | 2977.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEBT-630         | 1             | 1               | 201902 | 2              | 0             | 2607.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEBT-630         | 1             | 1               | 201903 | 2              | 0             | 3718.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEBT-630         | 1             | 1               | 201904 | 2              | 0             | 4022.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEBT-630         | 1             | 1               | 201905 | 2              | 0             | 479.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEBT-630         | 1             | 1               | 201906 | 2              | 0             | 2522.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |
    | AEBT-630         | 1             | 1               | 201907 | 2              | 0             | 2660.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?           |

    # Check the PROFILE subnominal aggregations in PaaS
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017630 | ORG0017630 | AEBC-630          | 2372030         | AEB-CL1819                 | 201808               | PROFILE         | CM             | False       | 1461.00         |
    | 10017630 | ORG0017630 | AEBC-630          | 2372030         | AEB-CL1819                 | 201809               | PROFILE         | CM             | False       | 1051.00         |
    | 10017630 | ORG0017630 | AEBC-630          | 2372030         | AEB-CL1819                 | 201810               | PROFILE         | CM             | False       | 4912.00         |
    | 10017630 | ORG0017630 | AEBC-630          | 2372030         | AEB-CL1819                 | 201811               | PROFILE         | CM             | False       | 1917.00         |
    | 10017630 | ORG0017630 | AEBC-630          | 2372030         | AEB-CL1819                 | 201812               | PROFILE         | CM             | False       | 998.00          |
    | 10017630 | ORG0017630 | AEBC-630          | 2372030         | AEB-CL1819                 | 201901               | PROFILE         | CM             | False       | 119.00          |
    | 10017630 | ORG0017630 | AEBC-630          | 2372030         | AEB-CL1819                 | 201902               | PROFILE         | CM             | False       | 1441.00         |
    | 10017630 | ORG0017630 | AEBC-630          | 2372030         | AEB-CL1819                 | 201903               | PROFILE         | CM             | False       | 2426.00         |
    | 10017630 | ORG0017630 | AEBC-630          | 2372030         | AEB-CL1819                 | 201904               | PROFILE         | CM             | False       | 787.00          |
    | 10017630 | ORG0017630 | AEBC-630          | 2372030         | AEB-CL1819                 | 201905               | PROFILE         | CM             | False       | 754.00          |
    | 10017630 | ORG0017630 | AEBC-630          | 2372030         | AEB-CL1819                 | 201906               | PROFILE         | CM             | False       | 4489.00         |
    | 10017630 | ORG0017630 | AEBC-630          | 2372030         | AEB-CL1819                 | 201907               | PROFILE         | CM             | False       | 3186.00         |
	#
    | 10017630 | ORG0017630 | AEBL-630          | 2372065         | AEB-LS1819                 | 201808               | PROFILE         | CM             | False       | 1752.00         |
    | 10017630 | ORG0017630 | AEBL-630          | 2372065         | AEB-LS1819                 | 201809               | PROFILE         | CM             | False       | 3881.00         |
    | 10017630 | ORG0017630 | AEBL-630          | 2372065         | AEB-LS1819                 | 201810               | PROFILE         | CM             | False       | 126.00          |
    | 10017630 | ORG0017630 | AEBL-630          | 2372065         | AEB-LS1819                 | 201811               | PROFILE         | CM             | False       | 1488.00         |
    | 10017630 | ORG0017630 | AEBL-630          | 2372065         | AEB-LS1819                 | 201812               | PROFILE         | CM             | False       | 4674.00         |
    | 10017630 | ORG0017630 | AEBL-630          | 2372065         | AEB-LS1819                 | 201901               | PROFILE         | CM             | False       | 1382.00         |
    | 10017630 | ORG0017630 | AEBL-630          | 2372065         | AEB-LS1819                 | 201902               | PROFILE         | CM             | False       | 4991.00         |
    | 10017630 | ORG0017630 | AEBL-630          | 2372065         | AEB-LS1819                 | 201903               | PROFILE         | CM             | False       | 430.00          |
    | 10017630 | ORG0017630 | AEBL-630          | 2372065         | AEB-LS1819                 | 201904               | PROFILE         | CM             | False       | 2896.00         |
    | 10017630 | ORG0017630 | AEBL-630          | 2372065         | AEB-LS1819                 | 201905               | PROFILE         | CM             | False       | 1765.00         |
    | 10017630 | ORG0017630 | AEBL-630          | 2372065         | AEB-LS1819                 | 201906               | PROFILE         | CM             | False       | 1521.00         |
    | 10017630 | ORG0017630 | AEBL-630          | 2372065         | AEB-LS1819                 | 201907               | PROFILE         | CM             | False       | 939.00          |

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Run the payment batch to create AEB-CL (PoP) and AEB-LS (PoP) payment files in Maytech's FTP site
    Given the override date is '03/08/2018 22:05'

	# Delete specific rows from the PaymentGeneration.PaymentBatchFeedItem (19014)
	And   there is no data in the Payment feed for FundingStreamPeriod 'AEB-CL1819' AccountingPaymentPeriod '201805' CensusEndDate '03/08/2018' and LinkCodeSuffix 'A'
	And   there is no data in the Payment feed for FundingStreamPeriod 'AEB-LS1819' AccountingPaymentPeriod '201805' CensusEndDate '03/08/2018' and LinkCodeSuffix 'A'
    
    # This bit checks that there is something in PaaS. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | AEBC-630                 | 201808 |
    | AEBL-630                 | 201808 |

    # PaymentGeneration.PaymentTimetable
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEB-CL1819                 | 201808               |                      | A              | NotStarted |
    | AEB-LS1819                 | 201808               |                      | A              | NotStarted |

#    # Coda.AccountCode
#    And   the following configuration exists in the Account Codes table
#    | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#    | 10017630 | AEB-CL1819                 | CODC630   | 8115000      | 01/08/1990           | 31/08/2020         |
#    | 10017630 | AEB-LS1819                 | CODL630   | 8115000      | 01/08/1990           | 31/08/2020         |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEB-CL1819                 | 201808               | Completed |
    | AEB-LS1819                 | 201808               | Completed |

#    # File created in Maytech FTP folder for 'Adult Education Budget - Community Learning'
#    Then  Payment file 'AEBC20180503A.pay' is created in the FTP Folder
#
#    # Decrypt the payment file to the Output window and save a decrypted version to Datafiles/Downloads
#    Given there is an encrypted file called 'AEBC20180503A.pay' in the Maytech FTP folder decrypt it then save it to 'DataFiles/Downloads'
#
#    Then  the following details are present in payment file 'AEBC20180503A.pay'
#    | LinkCode    | CompanyCode | Element1 | Element2 | Element3 | Element4 | Element5 | Element6 | Element7 | Element8 | Year | Period | Date       | Amount   | Dc   | LineType | Doc     | Desc                            | DueDate    | Tax | Extref1                       | Extref2     | Extref3 | Extref4 | Extref5  | Extref6 | Num   | DocLineNo |
#    | AEBC180503A | SFA         | AAA40    | +        | 8115000  | CODC630  | 02       | AEBC-630 | ?        | ?        | 2018 | 05     | 03/08/2018 | 1461.00  | 160  | 157      | AEBCP   | AEB Community Learng Prf Aug18  | 15/08/2018 | ?   | AEBC PROFILE 2018/19          | AEBC180503A | ?       | ?       | 10017630 | 2372030 | 1     | 1         |
#    | AEBC180503A | SFA         | AAA40    | +        | 2372030  | 5000     | 02       | AEBC-630 | ?        | ?        | 2018 | 05     | 03/08/2018 | 1461.00  | 161  | 158      | AEBCP   | AEB Community Learng Prf Aug18  | 15/08/2018 | VIO | AEBC PROFILE 2018/19          | AEBC180503A | ?       | ?       | 10017630 | CODC630 | 1     | 2         |
#
#    # File created in Maytech FTP folder for 'Adult Education Budget - Learner Support'
#    And   Payment file 'AEBC20180503A.pay' is created in the FTP Folder

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-CL1819' PaymentPeriod '201805' CensusEndDate '03/08/2018' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A630.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-CL1819' PaymentPeriod '201805' CensusEndDate '03/08/2018' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AEBC                   | 2018          | 05             | 03          | ?       | AEBC-630      | 1461.00         | PROFILE          | AEB Community Learng               | 2018-08-15 | 2018-08-01   | 2019-07-31 | ?              | 10017630 | 2372030    |

#    # Decrypt the payment file to the Output window and save a decrypted version to Datafiles/Downloads
#    Given there is an encrypted file called 'AEBL20180503A.pay' in the Maytech FTP folder decrypt it then save it to 'DataFiles/Downloads'
#
#    Then  the following details are present in payment file 'AEBL20180503A.pay'
#    | LinkCode    | CompanyCode | Element1 | Element2 | Element3 | Element4 | Element5 | Element6 | Element7 | Element8 | Year | Period | Date       | Amount   | Dc   | LineType | Doc     | Desc                            | DueDate    | Tax | Extref1                       | Extref2     | Extref3 | Extref4 | Extref5  | Extref6 | Num   | DocLineNo |
#    | AEBL180503A | SFA         | AAA40    | +        | 8115000  | CODL630  | 02       | AEBL-630 | ?        | ?        | 2018 | 05     | 03/08/2018 | 1752.00  | 160  | 157      | AEBLP   | AEB Learner Support Prf Aug18   | 15/08/2018 | ?   | AEBL PROFILE 2018/19          | AEBL180503A | ?       | ?       | 10017630 | 2372065 | 1     | 1         |
#    | AEBL180503A | SFA         | AAA40    | +        | 2372065  | 5000     | 02       | AEBL-630 | ?        | ?        | 2018 | 05     | 03/08/2018 | 1752.00  | 161  | 158      | AEBLP   | AEB Learner Support Prf Aug18   | 15/08/2018 | VIO | AEBL PROFILE 2018/19          | AEBL180503A | ?       | ?       | 10017630 | CODL630 | 1     | 2         |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-LS1819' PaymentPeriod '201805' CensusEndDate '03/08/2018' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A630.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-LS1819' PaymentPeriod '201805' CensusEndDate '03/08/2018' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AEBL                   | 2018          | 05             | 03          | ?       | AEBL-630      | 1752.00         | PROFILE          | AEB Learner Support                | 2018-08-15 | 2018-08-01   | 2019-07-31 | ?              | 10017630 | 2372065    |
	
    # Change the date
    Given the override date is '04/11/2018'

    # Pull actuals from DC for Oct 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201808 | AEB-TOL1819             | AEBT-630                 |            | 2               | 0            | 1793.32     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201808 | AEB-TOL1819             | AEBT-630                 |            | 3               | 0            | 1380.22     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201808 | AEB-TOL1819             | AEBT-630                 |            | 4               | 0            | 1490.85     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201808 | AEB-TOL1819             | AEBT-630                 |            | 5               | 0            | 794.95      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201808 | AEB-TOL1819             | AEBT-630                 |            | 6               | 0            | 824.67      |
    #
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201809 | AEB-TOL1819             | AEBT-630                 |            | 2               | 0            | 1959.38     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201809 | AEB-TOL1819             | AEBT-630                 |            | 3               | 0            | 133.64      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201809 | AEB-TOL1819             | AEBT-630                 |            | 4               | 0            | 1925.74     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201809 | AEB-TOL1819             | AEBT-630                 |            | 5               | 0            | 2054.78     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201809 | AEB-TOL1819             | AEBT-630                 |            | 6               | 0            | 1801.69     |
    #
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201810 | AEB-TOL1819             | AEBT-630                 |            | 2               | 0            | 208.84      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201810 | AEB-TOL1819             | AEBT-630                 |            | 3               | 0            | 1093.68     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201810 | AEB-TOL1819             | AEBT-630                 |            | 4               | 0            | 2170.29     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201810 | AEB-TOL1819             | AEBT-630                 |            | 5               | 0            | 1997.15     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201810 | AEB-TOL1819             | AEBT-630                 |            | 6               | 0            | 996.49      |
    #
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201811 | AEB-TOL1819             | AEBT-630                 |            | 2               | 0            | 2408.69     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201811 | AEB-TOL1819             | AEBT-630                 |            | 3               | 0            | 2191.47     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201811 | AEB-TOL1819             | AEBT-630                 |            | 4               | 0            | 234.96      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201811 | AEB-TOL1819             | AEBT-630                 |            | 5               | 0            | 2378.94     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201811 | AEB-TOL1819             | AEBT-630                 |            | 6               | 0            | 973.64      |
    #
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201812 | AEB-TOL1819             | AEBT-630                 |            | 2               | 0            | 1359.68     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201812 | AEB-TOL1819             | AEBT-630                 |            | 3               | 0            | 1941.07     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201812 | AEB-TOL1819             | AEBT-630                 |            | 4               | 0            | 228.41      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201812 | AEB-TOL1819             | AEBT-630                 |            | 5               | 0            | 1521.90     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201812 | AEB-TOL1819             | AEBT-630                 |            | 6               | 0            | 1224.88     |
    #
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201901 | AEB-TOL1819             | AEBT-630                 |            | 2               | 0            | 815.60      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201901 | AEB-TOL1819             | AEBT-630                 |            | 3               | 0            | 1594.47     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201901 | AEB-TOL1819             | AEBT-630                 |            | 4               | 0            | 1654.77     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201901 | AEB-TOL1819             | AEBT-630                 |            | 5               | 0            | 733.10      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201901 | AEB-TOL1819             | AEBT-630                 |            | 6               | 0            | 770.42      |
    #
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201902 | AEB-TOL1819             | AEBT-630                 |            | 2               | 0            | 2091.53     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201902 | AEB-TOL1819             | AEBT-630                 |            | 3               | 0            | 2079.05     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201902 | AEB-TOL1819             | AEBT-630                 |            | 4               | 0            | 1513.99     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201902 | AEB-TOL1819             | AEBT-630                 |            | 5               | 0            | 2466.63     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201902 | AEB-TOL1819             | AEBT-630                 |            | 6               | 0            | 2286.32     |
    #
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201903 | AEB-TOL1819             | AEBT-630                 |            | 2               | 0            | 644.48      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201903 | AEB-TOL1819             | AEBT-630                 |            | 3               | 0            | 1768.28     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201903 | AEB-TOL1819             | AEBT-630                 |            | 4               | 0            | 2452.01     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201903 | AEB-TOL1819             | AEBT-630                 |            | 5               | 0            | 685.43      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201903 | AEB-TOL1819             | AEBT-630                 |            | 6               | 0            | 1381.30     |
    #
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201904 | AEB-TOL1819             | AEBT-630                 |            | 2               | 0            | 355.28      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201904 | AEB-TOL1819             | AEBT-630                 |            | 3               | 0            | 2498.60     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201904 | AEB-TOL1819             | AEBT-630                 |            | 4               | 0            | 1722.82     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201904 | AEB-TOL1819             | AEBT-630                 |            | 5               | 0            | 137.68      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201904 | AEB-TOL1819             | AEBT-630                 |            | 6               | 0            | 1480.44     |
    #
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201905 | AEB-TOL1819             | AEBT-630                 |            | 2               | 0            | 340.12      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201905 | AEB-TOL1819             | AEBT-630                 |            | 3               | 0            | 347.25      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201905 | AEB-TOL1819             | AEBT-630                 |            | 4               | 0            | 2017.33     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201905 | AEB-TOL1819             | AEBT-630                 |            | 5               | 0            | 782.75      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201905 | AEB-TOL1819             | AEBT-630                 |            | 6               | 0            | 209.55      |
    #
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201906 | AEB-TOL1819             | AEBT-630                 |            | 2               | 0            | 809.85      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201906 | AEB-TOL1819             | AEBT-630                 |            | 3               | 0            | 1016.82     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201906 | AEB-TOL1819             | AEBT-630                 |            | 4               | 0            | 822.33      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201906 | AEB-TOL1819             | AEBT-630                 |            | 5               | 0            | 2376.58     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201906 | AEB-TOL1819             | AEBT-630                 |            | 6               | 0            | 2451.60     |
    #
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201907 | AEB-TOL1819             | AEBT-630                 |            | 2               | 0            | 1063.30     |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201907 | AEB-TOL1819             | AEBT-630                 |            | 3               | 0            | 767.87      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201907 | AEB-TOL1819             | AEBT-630                 |            | 4               | 0            | 485.06      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201907 | AEB-TOL1819             | AEBT-630                 |            | 5               | 0            | 490.77      |
    | AEB1819        | AEB05                | ORG0017630     | CM             | 201907 | AEB-TOL1819             | AEBT-630                 |            | 6               | 0            | 1651.81     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUALS in CRM
    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-630       | AEBT-630        | 1               | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 2               | 3961.54  | 1793.32  | 1959.38  | 208.84   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 3               | 2607.54  | 1380.22  | 133.64   | 1093.68  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 4               | 5586.88  | 1490.85  | 1925.74  | 2170.29  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 5               | 4846.88  | 794.95   | 2054.78  | 1997.15  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 6               | 3622.85  | 824.67   | 1801.69  | 996.49   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-630       | AEBT-630        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 2               | 3961.54  | 0.00     | 0.00     | 3961.54  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 3               | 2607.54  | 0.00     | 0.00     | 2607.54  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 4               | 5586.88  | 0.00     | 0.00     | 5586.88  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 5               | 4846.88  | 0.00     | 0.00     | 4846.88  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 6               | 3622.85  | 0.00     | 0.00     | 3622.85  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-630       | AEBT-630        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 2               | -777.82  | 0.00     | 0.00     | -777.82  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 3               | -511.97  | 0.00     | 0.00     | -511.97  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 4               | -1096.94 | 0.00     | 0.00     | -1096.94 | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 5               | -951.65  | 0.00     | 0.00     | -951.65  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 6               | -711.32  | 0.00     | 0.00     | -711.32  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | AEBP-630       | AEBT-630        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 2               | 3183.72  | 0.00     | 0.00     | 3183.72  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 3               | 2095.57  | 0.00     | 0.00     | 2095.57  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 4               | 4489.94  | 0.00     | 0.00     | 4489.94  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 5               | 3895.23  | 0.00     | 0.00     | 3895.23  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP-630       | AEBT-630        | 6               | 2911.53  | 0.00     | 0.00     | 2911.53  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Change the date
    Given the override date is '07/11/2018 22:05'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEB-TOL1819' AccountingPaymentPeriod '201807' CensusEndDate '07/11/2018' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaaS. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | AEBT-630                 | 201810 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEB-TOL1819                | 201810               |                      | A              | NotStarted |

#    # Coda.AccountCode
#    And   the following configuration exists in the Account Codes table
#    | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#    | 10017630 | AEB-TOL1819                | CODA630   | 8115000      | 01/08/1990           | 31/08/2020         |
    
    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEB-TOL1819                | 201810               | Completed |

#    # File created in Maytech FTP folder for 'Adult Education Budget - Traineeships and Other Learning'
#    And   Payment file 'AEBT20180707A.pay' is created in the FTP Folder
#
#    # Decrypt the payment file to the Output window and save a decrypted version to Datafiles/Downloads
#    Given there is an encrypted file called 'AEBT20180707A.pay' in the Maytech FTP folder decrypt it then save it to 'DataFiles/Downloads'
#
#    Then  the following details are present in payment file 'AEBT20180707A.pay'
#    | LinkCode    | CompanyCode | Element1 | Element2 | Element3 | Element4 | Element5 | Element6   | Element7 | Element8 | Year | Period | Date       | Amount   | Dc   | LineType | Doc     | Desc                            | DueDate    | Tax | Extref1                       | Extref2     | Extref3      | Extref4 | Extref5  | Extref6 | Num   | DocLineNo |
#    | AEBT180707A | SFA         | AAA40    | +        | 8115000  | CODA630  | 02       | AEBT-630   | ?        | ?        | 2018 | 07     | 07/11/2018 | 3961.54  | 160  | 157      | AEBTR   | 19-24 Traineeships Rec Nov18    | 15/11/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180707A | ?            | ?       | 10017630 | 2355800 | 1     | 1         |
#    | AEBT180707A | SFA         | AAA40    | +        | 2355800  | 5000     | 02       | AEBT-630   | ?        | ?        | 2018 | 07     | 07/11/2018 | 3961.54  | 161  | 158      | AEBTR   | 19-24 Traineeships Rec Nov18    | 15/11/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180707A | ?            | ?       | 10017630 | CODA630 | 1     | 2         |
#    | AEBT180707A | SFA         | AAA40    | +        | 8115000  | CODA630  | 02       | AEBT-630   | ?        | ?        | 2018 | 07     | 07/11/2018 | 2386.73  | 161  | 157      | AEBTC   | AEB 19-24 Traineeshp Cap Nov18  | 15/11/2018 | ?   | AEBT PAYMENT CAP 2018/19      | AEBT180707A | ?            | ?       | 10017630 | 2355816 | 2     | 1         |
#    | AEBT180707A | SFA         | AAA40    | +        | 2355816  | 5000     | 02       | AEBT-630   | ?        | ?        | 2018 | 07     | 07/11/2018 | 2386.73  | 160  | 158      | AEBTC   | AEB 19-24 Traineeshp Cap Nov18  | 15/11/2018 | VIO | AEBT PAYMENT CAP 2018/19      | AEBT180707A | ?            | ?       | 10017630 | CODA630 | 2     | 2         |
#    | AEBT180707A | SFA         | AAA40    | +        | 8115000  | CODA630  | 02       | AEBT-630   | ?        | ?        | 2018 | 07     | 07/11/2018 | 2607.54  | 160  | 157      | AEBTR   | 19-24TraineeshpsLngS Rec Nov18  | 15/11/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180707A | ?            | ?       | 10017630 | 2355860 | 3     | 1         |
#    | AEBT180707A | SFA         | AAA40    | +        | 2355860  | 5000     | 02       | AEBT-630   | ?        | ?        | 2018 | 07     | 07/11/2018 | 2607.54  | 161  | 158      | AEBTR   | 19-24TraineeshpsLngS Rec Nov18  | 15/11/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180707A | ?            | ?       | 10017630 | CODA630 | 3     | 2         |
#    | AEBT180707A | SFA         | AAA40    | +        | 8115000  | CODA630  | 02       | AEBT-630   | ?        | ?        | 2018 | 07     | 07/11/2018 | 5586.88  | 160  | 157      | AEBTR   | 19-24TraineeshpsLnrS Rec Nov18  | 15/11/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180707A | ?            | ?       | 10017630 | 2355865 | 4     | 1         |
#    | AEBT180707A | SFA         | AAA40    | +        | 2355865  | 5000     | 02       | AEBT-630   | ?        | ?        | 2018 | 07     | 07/11/2018 | 5586.88  | 161  | 158      | AEBTR   | 19-24TraineeshpsLnrS Rec Nov18  | 15/11/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180707A | ?            | ?       | 10017630 | CODA630 | 4     | 2         |
#    | AEBT180707A | SFA         | AAA40    | +        | 8115000  | CODA630  | 02       | AEBT-630   | ?        | ?        | 2018 | 07     | 07/11/2018 | 4846.88  | 160  | 157      | AEBTR   | AEB Other Learning Rec Nov18    | 15/11/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180707A | ?            | ?       | 10017630 | 2372010 | 5     | 1         |
#    | AEBT180707A | SFA         | AAA40    | +        | 2372010  | 5000     | 02       | AEBT-630   | ?        | ?        | 2018 | 07     | 07/11/2018 | 4846.88  | 161  | 158      | AEBTR   | AEB Other Learning Rec Nov18    | 15/11/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180707A | ?            | ?       | 10017630 | CODA630 | 5     | 2         |
#    | AEBT180707A | SFA         | AAA40    | +        | 8115000  | CODA630  | 02       | AEBT-630   | ?        | ?        | 2018 | 07     | 07/11/2018 | 1662.97  | 161  | 157      | AEBTC   | AEB Other Learning Cap Nov18    | 15/11/2018 | ?   | AEBT PAYMENT CAP 2018/19      | AEBT180707A | ?            | ?       | 10017630 | 2372016 | 6     | 1         |
#    | AEBT180707A | SFA         | AAA40    | +        | 2372016  | 5000     | 02       | AEBT-630   | ?        | ?        | 2018 | 07     | 07/11/2018 | 1662.97  | 160  | 158      | AEBTC   | AEB Other Learning Cap Nov18    | 15/11/2018 | VIO | AEBT PAYMENT CAP 2018/19      | AEBT180707A | ?            | ?       | 10017630 | CODA630 | 6     | 2         |
#    | AEBT180707A | SFA         | AAA40    | +        | 8115000  | CODA630  | 02       | AEBT-630   | ?        | ?        | 2018 | 07     | 07/11/2018 | 3622.85  | 160  | 157      | AEBTR   | AEB OthLearning LngS Rec Nov18  | 15/11/2018 | ?   | AEBT RECONCILIATION 2018/19   | AEBT180707A | ?            | ?       | 10017630 | 2372060 | 7     | 1         |
#    | AEBT180707A | SFA         | AAA40    | +        | 2372060  | 5000     | 02       | AEBT-630   | ?        | ?        | 2018 | 07     | 07/11/2018 | 3622.85  | 161  | 158      | AEBTR   | AEB OthLearning LngS Rec Nov18  | 15/11/2018 | VIO | AEBT RECONCILIATION 2018/19   | AEBT180707A | ?            | ?       | 10017630 | CODA630 | 7     | 2         |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-TOL1819' PaymentPeriod '201807' CensusEndDate '07/11/2018' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A630.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-TOL1819' PaymentPeriod '201807' CensusEndDate '07/11/2018' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AEBT                   | 2018          | 07             | 07          | ?       | AEBT-630      | 3961.54         | RECONCILIATION   | 19-24 Traineeships                 | 2018-11-15 | 2018-08-01   | 2019-07-31 | ?              | 10017630 | 2355800    |
    | AEBT                   | 2018          | 07             | 07          | ?       | AEBT-630      | -2386.73        | CAPPING          | AEB 19-24 Traineeshp               | 2018-11-15 | 2018-08-01   | 2019-07-31 | ?              | 10017630 | 2355816    |
    | AEBT                   | 2018          | 07             | 07          | ?       | AEBT-630      | 2607.54         | RECONCILIATION   | 19-24TraineeshpsLngS               | 2018-11-15 | 2018-08-01   | 2019-07-31 | ?              | 10017630 | 2355860    |
    | AEBT                   | 2018          | 07             | 07          | ?       | AEBT-630      | 5586.88         | RECONCILIATION   | 19-24TraineeshpsLnrS               | 2018-11-15 | 2018-08-01   | 2019-07-31 | ?              | 10017630 | 2355865    |
    | AEBT                   | 2018          | 07             | 07          | ?       | AEBT-630      | 4846.88         | RECONCILIATION   | AEB Other Learning                 | 2018-11-15 | 2018-08-01   | 2019-07-31 | ?              | 10017630 | 2372010    |
    | AEBT                   | 2018          | 07             | 07          | ?       | AEBT-630      | -1662.97        | CAPPING          | AEB Other Learning                 | 2018-11-15 | 2018-08-01   | 2019-07-31 | ?              | 10017630 | 2372016    |
    | AEBT                   | 2018          | 07             | 07          | ?       | AEBT-630      | 3622.85         | RECONCILIATION   | AEB OthLearning LngS               | 2018-11-15 | 2018-08-01   | 2019-07-31 | ?              | 10017630 | 2372060    |


    # Tidy up
    And   the override date is reset

