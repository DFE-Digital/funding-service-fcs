Feature: CreateProviderGrowthFund 34372

@AcceptanceTest @Withdrawn20231002
Scenario: A201 Bulk load a new HTE-PGF2122 contract. Publish and approve. Check docs, financials and CM feed
    Given there are no allocations marked as Under Termination for UKPRN '10017201' 
    And   there are no terminated or closed allocations for UKPRN '10017201' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017201' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017201' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017201' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | HTPG-201      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | HTE-PGF2122       |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017201'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017201' 
    And   there is no caseload advisor for UKPRN '10017201' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017201 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017201' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017201 Co Ltd' with UKPRN '10017201' and OrgId 'ORG0017201' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017201 | 117201 | 10017201 Co Ltd | 0              | Active                | Yes           | AA017201      | ?             | 9 The Avenue           | Bridge Road            | Bagholt                | ?                      | ?                      | Surrey                 | GU19 5AT  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017201 |





    # Change the date
    Given the override date is '01/08/2021'

    # Bulk file to create a New contract
    And   there are no files prefixed '10017201' in the Sharepoint 'HTE-PGF-2122-Input-Appendices' folder
    And   there are no files prefixed 'HTE-PGF FY 2122 19072021161501 v3_A201' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'HTE-PGF FY 2122 19072021161501 v3_A201' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'HTE-PGF FY 2122 19072021161501 v3_A201' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'HTE-PGF FY 2122 19072021161501 v3_A201' in the Sharepoint 'Reports' folder
    And   spreadsheet 'HTE-PGF FY 2122 19072021161501 v3_A201.xlsx' exists in the Datafiles folder and UKPRN '10017201' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017201' for FundingType 'HTE-PGF' and period '2122' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017201' for FundingType 'HTE-PGF' and period '2122'

    # Check the contents of the Appendices
    Then  the file named '10017201_[ContractNo]_v1.pdf' in Sharepoint location 'HTE-PGF-2122-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017201 Co Ltd UKPRN: 10017201
    Master Contract Number: [MasterContractNo] Start Date: 01/04/2021 End Date: 31/03/2022
    Contract Ref: [AllocRef_HTPG]
    Cash (£) Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    Higher Technical Education Provider Growth Fund - £16,841 £0 £0 £0 £0 £0 £16,841 £0 £0 £0 £0 £0 £0
    Capital
    Higher Technical Education Provider Growth Fund - £6,823 £0 £0 £0 £0 £0 £6,823 £0 £0 £0 £0 £0 £0
    Resource
    Total Funding £23,664 £0 £0 £0 £0 £0 £23,664 £0 £0 £0 £0 £0 £0
    Higher Technical Education Provider Growth Fund – [AllocRef_HTPG] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017201_[ContractNo]_v1.pdf' in 'HTE-PGF-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A201.pdf'

    # Display Sharepoint filename
    And   message '10017201_[ContractNo]_v1.pdf' is written to the Output window

  # And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

   
   
   
   
    # Publish and Approve the contract
    
    # Change the date
    Given the override date is '02/08/2021'
   
   # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017201 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017201 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_HTPG] | 2888888          | Mar-22 | Profile        |
    | [AllocRef_HTPG] | 100989           | Mar-22 | Profile        |



    # Check financials in CRM and PaaS

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | [ContractNo]   | [AllocRef_HTPG]    | 1               | 16841.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16841.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_HTPG]    | 2               | 6823.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6823.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | [ContractNo]   | [AllocRef_HTPG]    | 1               | 16841.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16841.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_HTPG]    | 2               | 6823.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 6823.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal | Apr-21    | May-21    | Jun-21    | Jul-21    | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    |
    | 10017201 | [ContractNo]   | [AllocRef_HTPG]    | 100989            | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 6823.00   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017201 | [ContractNo]   | [AllocRef_HTPG]    | 2888888           | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 16841.00  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 

    # Check the PROFILE subnominal aggregations in PaaS
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017201 | ORG0017201 | [AllocRef_HTPG]   | 2888888         | HTE-PGF2122                | 202109               | PROFILE         | CM             | False       | 16841.00        |
    | 10017201 | ORG0017201 | [AllocRef_HTPG]   | 100989          | HTE-PGF2122                | 202109               | PROFILE         | CM             | False       | 6823.00         |



    # CM Feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                       | DeliverableDescription   | 
    | 10017201 | [ContractNo]   | 1               | [AllocRef_HTPG] | 1               | 0                     | 16841.00     | 0             | 0        | HTE Provider Growth Fund - Capital    | ?                        |
    | 10017201 | [ContractNo]   | 1               | [AllocRef_HTPG] | 2               | 0                     | 6823.00      | 0             | 0        | HTE Provider Growth Fund - Resource   | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed


    # Tidy Up
    Given the override date is reset
        
@AcceptanceTest @Withdrawn20231002
Scenario: A202 Create and approve a HTE-PGF2122 contract. Amend and approve. NFA and approve. Check docs. CDA. Payment batch. Check financials and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017202' 
    And   there are no terminated or closed allocations for UKPRN '10017202' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017202' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017202' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017202' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | HTPG-202      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | HTPG-202      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | HTE-PGF2122       |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | HTEPGF-202     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017202'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017202' 
    And   there is no caseload advisor for UKPRN '10017202' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017202 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017202' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017202 Co Ltd' with UKPRN '10017202' and OrgId 'ORG0017202' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017202 | 117202 | 10017202 Co Ltd | 0              | Active                | Yes           | AA017202      | ?             | 27 Linford Wood        | Linford Forum          | Rockingham Drive       | Milton Keynes          | ?                      | ?                      | MK14 6LY  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017202 |





    # Change the date
    Given the override date is '24/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'HTEPGF-202'
    And   there are no details in ContractManagement.CreatedContract for 'HTEPGF-202'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017202 | 10017202 Co Ltd      | ESFA-202             | HTEPGF-202     | 1                     | 01/04/2021        | 31/03/2022      | 3771.00       |                                       | Contract for Services                      | 2122   | New          | ORG0017202 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017202 | HTEPGF-202     | HTPG-202      | HTE-PGF           | HTE-PGF2122             | FY                      | 01/04/2021          | 31/03/2022        | 3771.00         |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017202 | HTEPGF-202     | HTPG-202      | 1               | 0                     | 2433.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2433.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | HTE Provider Growth Fund - Capital                              | New          |             | 
    | 10017202 | HTEPGF-202     | HTPG-202      | 2               | 0                     | 1338.00   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1338.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | HTE Provider Growth Fund - Resource                             | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'HTEPGF-202'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-202' and actual ContractNumber 'HTEPGF-202'

    # Check that the contract is now approved
    Then  the latest version of contract 'HTEPGF-202' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017202 | HTEPGF-202         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017202 | ESFA-202           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |


   
   

    # Change the date
    Given the override date is '25/07/2021'

    # Bulk file to amend contract         
    And   there are no files prefixed '10017202' in the Sharepoint 'HTE-PGF-2122-Input-Appendices' folder
    And   there are no files prefixed 'HTE-PGF FY 2122 30072021085405 v3_A202' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'HTE-PGF FY 2122 30072021085405 v3_A202' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'HTE-PGF FY 2122 30072021085405 v3_A202' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'HTE-PGF FY 2122 30072021085405 v3_A202' in the Sharepoint 'Reports' folder
    And   spreadsheet 'HTE-PGF FY 2122 30072021085405 v3_A202.xlsx' exists in the Datafiles folder and UKPRN '10017202' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Check the contents of the Appendices
    Then  the file named '10017202_HTEPGF-202_v2.pdf' in Sharepoint location 'HTE-PGF-2122-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017202 Co Ltd UKPRN: 10017202
    Master Contract Number: ESFA-202 Start Date: 01/04/2021 End Date: 31/03/2022
    Contract Ref: HTPG-202
    Cash (£) Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    Higher Technical Education Provider Growth Fund - £15,614 £0 £0 £0 £0 £0 £15,614 £0 £0 £0 £0 £0 £0
    Capital
    Higher Technical Education Provider Growth Fund - £6,108 £0 £0 £0 £0 £0 £6,108 £0 £0 £0 £0 £0 £0
    Resource
    Total Funding £21,722 £0 £0 £0 £0 £0 £21,722 £0 £0 £0 £0 £0 £0
    Higher Technical Education Provider Growth Fund – HTPG-202 – Page 1 Ref (for internal use only):  HTEPGF-202 v2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017202_HTEPGF-202_v2.pdf' in 'HTE-PGF-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A202_v2.pdf'



 
 
    # Publish and approve
    
    # Change the date
    Given the override date is '26/07/2021'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'HTEPGF-202'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-202' and actual ContractNumber 'HTEPGF-202'

    # Check that the contract is now approved
    Then  the latest version of contract 'HTEPGF-202' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017202 | HTEPGF-202         | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017202 | HTEPGF-202         | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/04/2021        | 31/03/2022      | ?             |
    | 10017202 | ESFA-202           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |
 
 



    # Execute a NON-FINANCIAL amendment and check docs

    # Change the date
    Given the override date is '27/07/2021'

    # Issue a non-financial VARIATION amendment on v2 to create v3
   #When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'HTEPGF-202' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'HTEPGF-202' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017202 | HTEPGF-202         | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017202 | HTEPGF-202         | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017202 | HTEPGF-202         | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/04/2021        | 31/03/2022      | ?             |
    | 10017202 | ESFA-202           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |




    # Check docs (Only the version number changes)

    # Check the contents of the Appendices
    Then  the file named '10017202_HTEPGF-202_v3.pdf' in Sharepoint location 'HTE-PGF-2122-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017202 Co Ltd UKPRN: 10017202
    Master Contract Number: ESFA-202 Start Date: 01/04/2021 End Date: 31/03/2022
    Contract Ref: HTPG-202
    Cash (£) Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    Higher Technical Education Provider Growth Fund - £15,614 £0 £0 £0 £0 £0 £15,614 £0 £0 £0 £0 £0 £0
    Capital
    Higher Technical Education Provider Growth Fund - £6,108 £0 £0 £0 £0 £0 £6,108 £0 £0 £0 £0 £0 £0
    Resource
    Total Funding £21,722 £0 £0 £0 £0 £0 £21,722 £0 £0 £0 £0 £0 £0
    Higher Technical Education Provider Growth Fund – HTPG-202 – Page 1 Ref (for internal use only):  HTEPGF-202 v3
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   #And   Sharepoint file '10017734_[ContractNo]_v3.pdf' in 'NLG-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '<filename2>.pdf'
    And   Sharepoint file '10017202_HTEPGF-202_v3.pdf' in 'HTE-PGF-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A202_v3.pdf'




    
    # Publish and approve

    # Change the date
    Given the override date is '28/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'HTEPGF-202' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '3' actual MasterContractNumber 'ESFA-202' and actual ContractNumber 'HTEPGF-202'

    # Check that the contract is now approved
    Then  the latest version of contract 'HTEPGF-202' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017202 | HTEPGF-202         | 3                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017202 | HTEPGF-202         | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017202 | HTEPGF-202         | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/04/2021        | 31/03/2022      | ?             |
    | 10017202 | ESFA-202           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |


    # Check the deliverable count in CRM 
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'HTEPGF-202'

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Apr-21    | May-21    | Jun-21    | Jul-21    | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    |
    | 10017201 | HTEPGF-202     | HTPG-202           | 100989                   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 6108.00   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017201 | HTEPGF-202     | HTPG-202           | 2888888                  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 15614.00  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 





#    # CDA
#
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version A202.csv'
#
#    Then  the contracts are in the replicated CRM database as follows
#    | ContractNumber | ContractVersionNumber |
#    | HTEPGF-202     | 3                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod   | Version               | Suffix |
#    | HTE-PGF2122           | Latest Version        | A202   |
#
#    Then  a report named 'CDA Latest Version A202.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                             | DeliverableParent    | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | HTE-PGF2122             | 10017202 | 10017202 Co Ltd             |               |                             | HTPG-202                 | HTEPGF-202     | ESFA-202                | 01/04/2021                  | 31/03/2022                | 3                     | Approved       | Approved                |                                                      | HTE Provider Growth Fund - Capital      |                      | 9                 | 2021            | 2021/22       |              | 15614.00     |              |               |              | Yes                | 15614.00       |                  | 0.00                  | 0.00           | 15614.00        |             | No            |                   |        | 2888888           |                          |                   | Sep              |
#    | HTE-PGF2122             | 10017202 | 10017202 Co Ltd             |               |                             | HTPG-202                 | HTEPGF-202     | ESFA-202                | 01/04/2021                  | 31/03/2022                | 3                     | Approved       | Approved                |                                                      | HTE Provider Growth Fund - Resource     |                      | 9                 | 2021            | 2021/22       |              | 6108.00      |              |               |              | Yes                | 6108.00        |                  | 0.00                  | 0.00           | 6108.00         |             | No            |                   |        | 100989            |                          |                   | Sep              |





    # Payment Batch for HTE-PGF2122 (PoP)

    # Change the date
    Given the override date is '06/09/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'HTE-PGF2122' AccountingPaymentPeriod '202106' CensusEndDate '06/09/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | HTPG-202                 | 202109 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | HTE-PGF2122                | 202109               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | HTE-PGF2122                | 202109               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'HTE-PGF2122' PaymentPeriod '202106' CensusEndDate '06/09/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A202.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'HTE-PGF2122' PaymentPeriod '202106' CensusEndDate '06/09/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription   | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | HTPG                   | 2021          | 06             | 02          | ?       | HTPG-202      | 15614.00        | PROFILE          | HTE PGF Capital         | 2021-09-17 | 2021-04-01   | 2022-03-31 | ?              | 10017202 | 2888888    |
    | HTPG                   | 2021          | 06             | 02          | ?       | HTPG-202      | 6108.00         | PROFILE          | HTE PGF Resource        | 2021-09-17 | 2021-04-01   | 2022-03-31 | ?              | 10017202 | 100989     |


    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'HTE-PGF2122' AccountingPaymentPeriod '202106' and CensusEndDate '06/09/2021'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                 |
    | Payment Requests for Funding Stream Period HTE-PGF2122 for Payment Period 202106 have been generated as of Census End Date/Time 2021-09-06T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | HTE-PGF2122         | 202106        | 2021-09-06T22:00:00Z  | 2                | 21722.00   |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | HTPG      | 01/04/2021   | 31/03/2022 | 06/09/2021    | 17/09/2021 | 2021          | 06             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription    | AggregatedValue |
    | ORG0017202  | 10017202       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | HTPG-202   | 3       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2888888    | PROFILE        | HTE PGF Capital          | 15614.00        |
    | ORG0017202  | 10017202       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | HTPG-202   | 3       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100989     | PROFILE        | HTE PGF Resource         | 6108.00         |


    # Tidy Up
    Given the override date is reset
     
    