Feature: CreateProviderGrowthFund 36223

@AcceptanceTest @Withdrawn20220510
Scenario: A347 Bulk load a new HTE-PGF2223 contract. Publish and approve. Check docs, financials and CM feed
    Given there are no allocations marked as Under Termination for UKPRN '10017347' 
    And   there are no terminated or closed allocations for UKPRN '10017347' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017347' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017347' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017347' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | HTPG-347      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | HTE-PGF2122       |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017347'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017347' 
    And   there is no caseload advisor for UKPRN '10017347' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017347 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017347' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017347 Co Ltd' with UKPRN '10017347' and OrgId 'ORG0017347' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017347 | 117347 | 10017347 Co Ltd | 0              | Active                | Yes           | AA017347      | ?             | 9 The Grove            | Bridge Road            | Bagholt                | ?                      | ?                      | Surrey                 | GU19 5AT  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017347 |





    # Change the date
    Given the override date is '01/08/2022'

    # Bulk file to create a New contract
    And   there are no files prefixed '10017347' in the Sharepoint 'HTE-PGF-2223-Input-Appendices' folder
    And   there are no files prefixed 'HTE-PGF FY 2223 06042022134058 v3_A347' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'HTE-PGF FY 2223 06042022134058 v3_A347' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'HTE-PGF FY 2223 06042022134058 v3_A347' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'HTE-PGF FY 2223 06042022134058 v3_A347' in the Sharepoint 'Reports' folder
    And   spreadsheet 'HTE-PGF FY 2223 06042022134058 v3_A347.xlsx' exists in the Datafiles folder and UKPRN '10017347' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017347' for FundingType 'HTE-PGF' and period '2223' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017347' for FundingType 'HTE-PGF' and period '2223'

    # Check the contents of the Appendices
    Then  the file named '10017347_[ContractNo]_v1.pdf' in Sharepoint location 'HTE-PGF-2223-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017347 Co Ltd UKPRN: 10017347
    Master Contract Number: [MasterContractNo] Start Date: 01/09/2022 End Date: 31/03/2023
    Contract Ref: [AllocRef_HTPG]
    Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    Higher Technical Education Provider Growth Fund - £13,725 £13,725 £0 £0 £0 £0 £0 £0
    Capital
    Higher Technical Education Provider Growth Fund - £6,275 £6,275 £0 £0 £0 £0 £0 £0
    Resource
    Total Funding £20,000 £20,000 £0 £0 £0 £0 £0 £0
    Higher Technical Education Provider Growth Fund – [AllocRef_HTPG] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017347_[ContractNo]_v1.pdf' in 'HTE-PGF-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A347.pdf'

    # Display Sharepoint filename
    And   message '10017347_[ContractNo]_v1.pdf' is written to the Output window

  # And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

   
   
   
   
    # Publish and Approve the contract
    
    # Change the date
    Given the override date is '02/08/2022'
   
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
    | 10017347 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/09/2022        | 31/03/2023      | ?             |
    | 10017347 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/09/2022        | 31/03/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '14' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_HTPG] | 2888888          | Mar-23 | Profile        |
    | [AllocRef_HTPG] | 100989           | Mar-23 | Profile        |





    # Check financials in CRM and PaaS

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | [ContractNo]   | [AllocRef_HTPG]    | 1               | 13725.00  | 13725.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_HTPG]    | 2               | 6275.00   | 6275.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | [ContractNo]   | [AllocRef_HTPG]    | 1               | 13725.00  | 13725.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_HTPG]    | 2               | 6275.00   | 6275.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal  | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   |
    | 10017347 | [ContractNo]   | [AllocRef_HTPG]    | 2888888            | 13725.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 10017347 | [ContractNo]   | [AllocRef_HTPG]    | 100989             | 6275.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PROFILE subnominal aggregations in PaaS
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017347 | ORG0017347 | [AllocRef_HTPG]   | 2888888         | HTE-PGF2122                | 202209               | PROFILE         | CM             | False       | 13725.00        |
    | 10017347 | ORG0017347 | [AllocRef_HTPG]   | 100989          | HTE-PGF2122                | 202209               | PROFILE         | CM             | False       | 6275.00         |



    # CM Feed

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                       | DeliverableDescription   | 
    | 10017347 | [ContractNo]   | 1               | [AllocRef_HTPG] | 1               | 0                     | 13725.00     | 0             | 0        | HTE Provider Growth Fund - Capital    | ?                        |
    | 10017347 | [ContractNo]   | 1               | [AllocRef_HTPG] | 2               | 0                     | 6275.00      | 0             | 0        | HTE Provider Growth Fund - Resource   | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed


    # Tidy Up
    Given the override date is reset
        
@AcceptanceTest @Withdrawn20220510
Scenario: A348 Create and approve a HTE-PGF2223 contract. Amend and approve. NFA and approve. Check docs. CDA. Payment batch. Check financials and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017348' 
    And   there are no terminated or closed allocations for UKPRN '10017348' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017348' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017348' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017348' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | HTPG-348      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | HTPG-348      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | HTE-PGF2223       |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | HTEPGF-348     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017348'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017348' 
    And   there is no caseload advisor for UKPRN '10017348' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017348 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017348' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017348 Co Ltd' with UKPRN '10017348' and OrgId 'ORG0017348' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017348 | 117348 | 10017348 Co Ltd | 0              | Active                | Yes           | AA017348      | ?             | 27 Linford Wood        | Linford Forum          | Rockingham Drive       | Milton Keynes          | ?                      | ?                      | MK14 6LY  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017348 |





    # Change the date
    Given the override date is '24/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'HTEPGF-348'
    And   there are no details in ContractManagement.CreatedContract for 'HTEPGF-348'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription   | ContractType                            | Period | CRMIntent    | OrgId      |
    | 10017348 | 10017348 Co Ltd      | ESFA-348             | HTEPGF-348     | 1                     | 01/09/2022        | 31/03/2023      | 3771.00       |                       | Contract for Services                   | 2223   | New          | ORG0017348 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                | CRMIntent    | DeliveryOrg |
    | 10017348 | HTEPGF-348     | HTPG-348      | HTE-PGF           | HTE-PGF2223             | FY                      | 01/09/2022          | 31/03/2023        | 3771.00         |                                         |            |                                      | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | DeliverableDescription                | CRMIntent    | DeliveryOrg |
    | 10017348 | HTEPGF-348     | HTPG-348      | 1               | 0                     | 2433.00   | 2433.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | HTE Provider Growth Fund - Capital    | New          |             | 
    | 10017348 | HTEPGF-348     | HTPG-348      | 2               | 0                     | 1338.00   | 1338.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | HTE Provider Growth Fund - Resource   | New          |             | 

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'HTEPGF-348'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-348' and actual ContractNumber 'HTEPGF-348'

    # Check that the contract is now approved
    Then  the latest version of contract 'HTEPGF-348' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017348 | HTEPGF-348         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/09/2022        | 31/03/2023      | ?             |
    | 10017348 | ESFA-348           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/09/2022        | 31/03/2023      | ?             |


   
   

    # Change the date
    Given the override date is '25/07/2022'

    # Bulk file to amend contract         
    And   there are no files prefixed '10017348' in the Sharepoint 'HTE-PGF-2223-Input-Appendices' folder
    And   there are no files prefixed 'HTE-PGF FY 2223 06042022163425 v3_A348' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'HTE-PGF FY 2223 06042022163425 v3_A348' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'HTE-PGF FY 2223 06042022163425 v3_A348' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'HTE-PGF FY 2223 06042022163425 v3_A348' in the Sharepoint 'Reports' folder
    And   spreadsheet 'HTE-PGF FY 2223 06042022163425 v3_A348.xlsx' exists in the Datafiles folder and UKPRN '10017348' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Check the contents of the Appendices
    Then  the file named '10017348_HTEPGF-348_v2.pdf' in Sharepoint location 'HTE-PGF-2223-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017348 Co Ltd UKPRN: 10017348
    Master Contract Number: ESFA-348 Start Date: 01/09/2022 End Date: 31/03/2023
    Contract Ref: HTPG-348
    Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    Higher Technical Education Provider Growth Fund - £13,875 £13,875 £0 £0 £0 £0 £0 £0
    Capital
    Higher Technical Education Provider Growth Fund - £7,555 £7,555 £0 £0 £0 £0 £0 £0
    Resource
    Total Funding £21,430 £21,430 £0 £0 £0 £0 £0 £0
    Higher Technical Education Provider Growth Fund – HTPG-348 – Page 1 Ref (for internal use only):  HTEPGF-348 v2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017348_HTEPGF-348_v2.pdf' in 'HTE-PGF-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A348_v2.pdf'



 
 
    # Publish and approve
    
    # Change the date
    Given the override date is '26/07/2022'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'HTEPGF-348'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-348' and actual ContractNumber 'HTEPGF-348'

    # Check that the contract is now approved
    Then  the latest version of contract 'HTEPGF-348' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017348 | HTEPGF-348         | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/09/2022        | 31/03/2023      | Variation     |
    | 10017348 | HTEPGF-348         | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/09/2022        | 31/03/2023      | ?             |
    | 10017348 | ESFA-348           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/09/2022        | 31/03/2023      | ?             |
 
 



    # Execute a NON-FINANCIAL amendment and check docs

    # Change the date
    Given the override date is '27/07/2022'

    # Issue a non-financial VARIATION amendment on v2 to create v3
   #When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'HTEPGF-348' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'HTEPGF-348' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017348 | HTEPGF-348         | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/09/2022        | 31/03/2023      | Variation     |
    | 10017348 | HTEPGF-348         | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/09/2022        | 31/03/2023      | Variation     |
    | 10017348 | HTEPGF-348         | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/09/2022        | 31/03/2023      | ?             |
    | 10017348 | ESFA-348           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/09/2022        | 31/03/2023      | ?             |




    # Check docs (Only the version number changes)

    # Check the contents of the Appendices
    Then  the file named '10017348_HTEPGF-348_v3.pdf' in Sharepoint location 'HTE-PGF-2223-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017348 Co Ltd UKPRN: 10017348
    Master Contract Number: ESFA-348 Start Date: 01/09/2022 End Date: 31/03/2023
    Contract Ref: HTPG-348
    Cash (£) Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
    Higher Technical Education Provider Growth Fund - £13,875 £13,875 £0 £0 £0 £0 £0 £0
    Capital
    Higher Technical Education Provider Growth Fund - £7,555 £7,555 £0 £0 £0 £0 £0 £0
    Resource
    Total Funding £21,430 £21,430 £0 £0 £0 £0 £0 £0
    Higher Technical Education Provider Growth Fund – HTPG-348 – Page 1 Ref (for internal use only):  HTEPGF-348 v3
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   #And   Sharepoint file '10017734_[ContractNo]_v3.pdf' in 'NLG-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '<filename2>.pdf'
    And   Sharepoint file '10017348_HTEPGF-348_v3.pdf' in 'HTE-PGF-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A348_v3.pdf'




    
    # Publish and approve

    # Change the date
    Given the override date is '28/07/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'HTEPGF-348' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '3' actual MasterContractNumber 'ESFA-348' and actual ContractNumber 'HTEPGF-348'

    # Check that the contract is now approved
    Then  the latest version of contract 'HTEPGF-348' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017348 | HTEPGF-348         | 3                     | 0                        | Approved         | Approved                  | True          | True                | 01/09/2022        | 31/03/2023      | Variation     |
    | 10017348 | HTEPGF-348         | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/09/2022        | 31/03/2023      | Variation     |
    | 10017348 | HTEPGF-348         | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/09/2022        | 31/03/2023      | ?             |
    | 10017348 | ESFA-348           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/09/2022        | 31/03/2023      | ?             |


    # Check the deliverable count in CRM 
    And   there are '14' deliverable period rows in CRM linked to the latest version of contract 'HTEPGF-348'

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    |
    | 10017348 | HTEPGF-348     | HTPG-348           | 100989                   | 7555.00   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017348 | HTEPGF-348     | HTPG-348           | 2888888                  | 13875.00  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 





    # CDA

    # Run the CDA report
    Given there is no CDA report named 'CDA Latest Version A348.csv'

    Then  the contracts are in the replicated CRM database as follows
    | ContractNumber | ContractVersionNumber |
    | HTEPGF-348     | 3                     |

    When  the following CDA report is run
    | FundingStreamPeriod   | Version               | Suffix |
    | HTE-PGF2223           | Latest Version        | A348   |

    Then  a report named 'CDA Latest Version A348.csv' is created

    # Check the contents of the CDA report
    And   the following rows are present in the report
    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
    | HTE-PGF2223             | 10017348 | 10017348 Co Ltd             |               |                             | HTPG-348                 | HTEPGF-348     | ESFA-348                | 01/09/2022                  | 31/03/2023                | 3                     | Approved       | Approved                |                                                      | HTE Provider Growth Fund - Capital                              |                                                                 | 9                 | 2022            | 2022/23       |              | 13875        |              | 0             |              | Yes                | 13875.00       |                  | 0.00                  | 0.00           | 13875.00        |             | No            |                   |        | 2888888           |                          |                   | Sep              |
    | HTE-PGF2223             | 10017348 | 10017348 Co Ltd             |               |                             | HTPG-348                 | HTEPGF-348     | ESFA-348                | 01/09/2022                  | 31/03/2023                | 3                     | Approved       | Approved                |                                                      | HTE Provider Growth Fund - Capital                              |                                                                 | 10                | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888888           |                          |                   | Oct              |
    | HTE-PGF2223             | 10017348 | 10017348 Co Ltd             |               |                             | HTPG-348                 | HTEPGF-348     | ESFA-348                | 01/09/2022                  | 31/03/2023                | 3                     | Approved       | Approved                |                                                      | HTE Provider Growth Fund - Capital                              |                                                                 | 11                | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888888           |                          |                   | Nov              |
    | HTE-PGF2223             | 10017348 | 10017348 Co Ltd             |               |                             | HTPG-348                 | HTEPGF-348     | ESFA-348                | 01/09/2022                  | 31/03/2023                | 3                     | Approved       | Approved                |                                                      | HTE Provider Growth Fund - Capital                              |                                                                 | 12                | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888888           |                          |                   | Dec              |
    | HTE-PGF2223             | 10017348 | 10017348 Co Ltd             |               |                             | HTPG-348                 | HTEPGF-348     | ESFA-348                | 01/09/2022                  | 31/03/2023                | 3                     | Approved       | Approved                |                                                      | HTE Provider Growth Fund - Capital                              |                                                                 | 1                 | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888888           |                          |                   | Jan              |
    | HTE-PGF2223             | 10017348 | 10017348 Co Ltd             |               |                             | HTPG-348                 | HTEPGF-348     | ESFA-348                | 01/09/2022                  | 31/03/2023                | 3                     | Approved       | Approved                |                                                      | HTE Provider Growth Fund - Capital                              |                                                                 | 2                 | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888888           |                          |                   | Feb              |
    | HTE-PGF2223             | 10017348 | 10017348 Co Ltd             |               |                             | HTPG-348                 | HTEPGF-348     | ESFA-348                | 01/09/2022                  | 31/03/2023                | 3                     | Approved       | Approved                |                                                      | HTE Provider Growth Fund - Capital                              |                                                                 | 3                 | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2888888           |                          |                   | Mar              |
    | HTE-PGF2223             | 10017348 | 10017348 Co Ltd             |               |                             | HTPG-348                 | HTEPGF-348     | ESFA-348                | 01/09/2022                  | 31/03/2023                | 3                     | Approved       | Approved                |                                                      | HTE Provider Growth Fund - Resource                             |                                                                 | 9                 | 2022            | 2022/23       |              | 7555         |              | 0             |              | Yes                | 7555.00        |                  | 0.00                  | 0.00           | 7555.00         |             | No            |                   |        | 100989            |                          |                   | Sep              |
    | HTE-PGF2223             | 10017348 | 10017348 Co Ltd             |               |                             | HTPG-348                 | HTEPGF-348     | ESFA-348                | 01/09/2022                  | 31/03/2023                | 3                     | Approved       | Approved                |                                                      | HTE Provider Growth Fund - Resource                             |                                                                 | 10                | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100989            |                          |                   | Oct              |
    | HTE-PGF2223             | 10017348 | 10017348 Co Ltd             |               |                             | HTPG-348                 | HTEPGF-348     | ESFA-348                | 01/09/2022                  | 31/03/2023                | 3                     | Approved       | Approved                |                                                      | HTE Provider Growth Fund - Resource                             |                                                                 | 11                | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100989            |                          |                   | Nov              |
    | HTE-PGF2223             | 10017348 | 10017348 Co Ltd             |               |                             | HTPG-348                 | HTEPGF-348     | ESFA-348                | 01/09/2022                  | 31/03/2023                | 3                     | Approved       | Approved                |                                                      | HTE Provider Growth Fund - Resource                             |                                                                 | 12                | 2022            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100989            |                          |                   | Dec              |
    | HTE-PGF2223             | 10017348 | 10017348 Co Ltd             |               |                             | HTPG-348                 | HTEPGF-348     | ESFA-348                | 01/09/2022                  | 31/03/2023                | 3                     | Approved       | Approved                |                                                      | HTE Provider Growth Fund - Resource                             |                                                                 | 1                 | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100989            |                          |                   | Jan              |
    | HTE-PGF2223             | 10017348 | 10017348 Co Ltd             |               |                             | HTPG-348                 | HTEPGF-348     | ESFA-348                | 01/09/2022                  | 31/03/2023                | 3                     | Approved       | Approved                |                                                      | HTE Provider Growth Fund - Resource                             |                                                                 | 2                 | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100989            |                          |                   | Feb              |
    | HTE-PGF2223             | 10017348 | 10017348 Co Ltd             |               |                             | HTPG-348                 | HTEPGF-348     | ESFA-348                | 01/09/2022                  | 31/03/2023                | 3                     | Approved       | Approved                |                                                      | HTE Provider Growth Fund - Resource                             |                                                                 | 3                 | 2023            | 2022/23       |              | 0            |              | 0             |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100989            |                          |                   | Mar              |





    # Payment Batch for HTE-PGF2223 (PoP)

    # Change the date
    Given the override date is '06/09/2022 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'HTE-PGF2223' AccountingPaymentPeriod '202206' CensusEndDate '06/09/2022' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | HTPG-348                 | 202209 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | HTE-PGF2223                | 202209               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | HTE-PGF2223                | 202209               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'HTE-PGF2223' PaymentPeriod '202206' CensusEndDate '06/09/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A348.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'HTE-PGF2223' PaymentPeriod '202206' CensusEndDate '06/09/2022' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription   | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | HTPG                   | 2022          | 06             | 02          | ?       | HTPG-348      | 13875.00        | PROFILE          | HTE PGF Capital         | 2022-09-16 | 2022-04-01   | 2023-03-31 | ?              | 10017348 | 2888888    |
    | HTPG                   | 2022          | 06             | 02          | ?       | HTPG-348      | 7555.00         | PROFILE          | HTE PGF Resource        | 2022-09-16 | 2022-04-01   | 2023-03-31 | ?              | 10017348 | 100989     |


    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'HTE-PGF2223' AccountingPaymentPeriod '202206' and CensusEndDate '06/09/2022'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                 |
    | Payment Requests for Funding Stream Period HTE-PGF2223 for Payment Period 202206 have been generated as of Census End Date/Time 2022-09-06T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | HTE-PGF2223         | 202206        | 2022-09-06T22:00:00Z  | 2                | 21430.00   |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | HTPG      | 01/04/2022   | 31/03/2023 | 06/09/2022    | 16/09/2022 | 2022          | 06             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription    | AggregatedValue |
    | ORG0017348  | 10017348       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | HTPG-348   | 3       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2888888    | PROFILE        | HTE PGF Capital          | 13875.00        |
    | ORG0017348  | 10017348       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | HTPG-348   | 3       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100989     | PROFILE        | HTE PGF Resource         | 7555.00         |


    # Tidy Up
    Given the override date is reset
     
@AcceptanceTest @Complete
Scenario: A866 Bulk load an HTE-PGF2223 contract. Fail FSR-009
    Given there are no allocations marked as Under Termination for UKPRN '10017866' 
    And   there are no terminated or closed allocations for UKPRN '10017866' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017866' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017866' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017866' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017866'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017866' 
    And   there is no caseload advisor for UKPRN '10017866' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017866 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017866' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017866 Co Ltd' with UKPRN '10017866' and OrgId 'ORG0017866' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017866 | 117866 | 10017866 Co Ltd | 0              | Active                | Yes           | AA017866      | ?             | 56 Linford Wood        | Linford Forum          | Rockingham Drive       | Milton Keynes          | ?                      | ?                      | MK14 6LY  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017866 |





    # Change the date
    Given the override date is '25/07/2022'

    # Bulk file to amend contract         
   #And   there are no files prefixed '10017866' in the Sharepoint 'HTE-PGF-2223-Input-Appendices' folder
    And   there are no files prefixed 'HTE-PGF FY 2223 10052022125405 v3_A866' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'HTE-PGF FY 2223 10052022125405 v3_A866' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'HTE-PGF FY 2223 10052022125405 v3_A866' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'HTE-PGF FY 2223 10052022125405 v3_A866' in the Sharepoint 'Reports' folder
    And   spreadsheet 'HTE-PGF FY 2223 10052022125405 v3_A866.xlsx' exists in the Datafiles folder and UKPRN '10017866' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file failure should exist in the Sharepoint Reports folder
    
    # FSR-009
    And   the syntax report includes the phrase 'The combination of Funding Type, Period Type and Period is not a valid combination'

    # Tidy up
    And   the override date is reset 
      
