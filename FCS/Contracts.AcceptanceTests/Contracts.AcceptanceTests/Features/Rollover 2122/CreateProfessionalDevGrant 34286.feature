Feature: CreateProfessionalDevGrant 34286

@AcceptanceTest @Withdrawn20231002
Scenario: A156 Bulk load a new FE-PDGP2122 contract. Publish and approve. Check docs, financials and CM feed
    Given there are no allocations marked as Under Termination for UKPRN '10017156' 
    And   there are no terminated or closed allocations for UKPRN '10017156' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017156' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017156' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017156' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | PDGP-156      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | FE-PDGP2122       |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017156'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017156' 
    And   there is no caseload advisor for UKPRN '10017156' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017156 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017156' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017156 Co Ltd' with UKPRN '10017156' and OrgId 'ORG0017156' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017156 | 117156 | 10017156 Co Ltd | 0              | Active                | Yes           | AA017156      | ?             | 1 Station Buildings    | Bridge Road            | Bagholt                | ?                      | ?                      | Surrey                 | GU19 5AT  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017156 |





    # Change the date
    Given the override date is '01/08/2021'

    # Bulk file to create a New contract
    And   there are no files prefixed '10017156' in the Sharepoint 'FE-PDGP-2122-Input-Appendices' folder
    And   there are no files prefixed 'FE-PDGP FY 2122 20072021092122 v3_A156' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'FE-PDGP FY 2122 20072021092122 v3_A156' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'FE-PDGP FY 2122 20072021092122 v3_A156' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'FE-PDGP FY 2122 20072021092122 v3_A156' in the Sharepoint 'Reports' folder
    And   spreadsheet 'FE-PDGP FY 2122 20072021092122 v3_A156.xlsx' exists in the Datafiles folder and UKPRN '10017156' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017156' for FundingType 'FE-PDGP' and period '2122' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017156' for FundingType 'FE-PDGP' and period '2122'

    # Check the contents of the Appendices
    Then  the file named '10017156_[ContractNo]_v1.pdf' in Sharepoint location 'FE-PDGP-2122-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017156 Co Ltd UKPRN: 10017156
    Master Contract Number: [MasterContractNo] Start Date: 01/04/2021 End Date: 31/03/2022
    Contract Ref: [AllocRef_PDGP]
    Cash (£) Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    Further Education Professional Development Grants £10,000 £0 £0 £0 £0 £0 £0 £3,561 £0 £0 £6,439 £0 £0
    Pilot
    Total Funding £10,000 £0 £0 £0 £0 £0 £0 £3,561 £0 £0 £6,439 £0 £0
    Further Education Professional Development Grants Pilot – [AllocRef_PDGP] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017156_[ContractNo]_v1.pdf' in 'FE-PDGP-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A156.pdf'
   #And   Sharepoint file '<filename1.pdf>' in 'FE-PDGP-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A156.pdf'

    # Display Sharepoint filename
    And   message '10017156_[ContractNo]_v1.pdf' is written to the Output window

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
    | 10017156 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017156 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_PDGP] | 100992           | Mar-22 | Profile        |




    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | [ContractNo]   | [AllocRef_PDGP]    | 1               | 10000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3561.00  | 0.00     | 0.00     | 6439.00  | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | [ContractNo]   | [AllocRef_PDGP]    | 1               | 10000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 3561.00  | 0.00     | 0.00     | 6439.00  | 0.00     | 0.00     | 


    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal  | Apr-21    | May-21    | Jun-21    | Jul-21    | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    |
    | 10017156 | [ContractNo]   | [AllocRef_PDGP]    | 100992             | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 3561.00   | 0.00      | 0.00      | 6439.00   | 0.00      | 0.00      | 



    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                           | DeliverableDescription   | 
    | 10017156 | [ContractNo]   | 1               | [AllocRef_PDGP] | 1               | 0                     | 10000.00     | 0             | 0        | FE Professional Development Grants Pilot  | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed


    # Tidy Up
    Given the override date is reset
        
@AcceptanceTest @Withdrawn20231002
Scenario: A157 Create and approve a FE-PDGP2122 contract. Amend and approve. Check docs. CDA. Payment batch. Check financials and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017157' 
    And   there are no terminated or closed allocations for UKPRN '10017157' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017157' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017157' 
 
#    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
#    Given there is no data in the ContractManagement.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017157' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | PDGP-157      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | PDGP-157      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | FE-PDGP2122       |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | FEPDGP-157     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017157'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017157' 
    And   there is no caseload advisor for UKPRN '10017157' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017157 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017157' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017157 Co Ltd' with UKPRN '10017157' and OrgId 'ORG0017157' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017157 | 117157 | 10017157 Co Ltd | 0              | Active                | Yes           | AA017157      | ?             | 17 Wood Street         | ?                      | ?                      | ?                      | Barnet                 | Hertfordshire          | EN5 4AT   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017157 |





    # Change the date
    Given the override date is '01/09/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'FEPDGP-157'
    And   there are no details in ContractManagement.CreatedContract for 'FEPDGP-157'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017157 | 10017157 Co Ltd      | ESFA-157             | FEPDGP-157     | 1                     | 01/04/2021        | 31/03/2022      | 12023.00      |                                       | Contract for Services                      | 2122   | New          | ORG0017157 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017157 | FEPDGP-157     | PDGP-157      | FE-PDGP           | FE-PDGP2122             | FY                      | 01/04/2021          | 31/03/2022        | 12023.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017157 | FEPDGP-157     | PDGP-157      | 1               | 0                     | 12023.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1355.00  | 0.00     | 0.00     | 10668.00 | 0.00     | 0.00     | FE Professional Development Grants Pilot                        | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | FEPDGP-157     | 1                     | 0                        | 2021-09-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'FEPDGP-157'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-157' and actual ContractNumber 'FEPDGP-157'

    # Check that the contract is now approved
    Then  the latest version of contract 'FEPDGP-157' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017157 | FEPDGP-157         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | ?             |
    | 10017157 | ESFA-157           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'FEPDGP-157' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'FEPDGP-157'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | PDGP-157        | 100992           | Mar-22 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                           | DeliverableDescription   | 
    | 10017157 | FEPDGP-157     | 1               | PDGP-157      | 1               | 0                     | 12023.00     | 0             | 0        | FE Professional Development Grants Pilot  | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'FEPDGP-157' agree with the most recent entry for this contract in the ContractManagement feed





    # Amend contract

    # Change the date
    Given the override date is '11/09/2021'


    # Bulk file
    And   there are no files prefixed '10017157' in the Sharepoint 'FE-PDGP-2122-Input-Appendices' folder
    And   there are no files prefixed 'FE-PDGP FY 2122 01092021115945 v3_A157' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'FE-PDGP FY 2122 01092021115945 v3_A157' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'FE-PDGP FY 2122 01092021115945 v3_A157' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'FE-PDGP FY 2122 01092021115945 v3_A157' in the Sharepoint 'Reports' folder
    And   spreadsheet 'FE-PDGP FY 2122 01092021115945 v3_A157.xlsx' exists in the Datafiles folder and UKPRN '10017157' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017157' for FundingType 'FE-PDGP' and period '2122'

    # Check the contents of the Appendices
    Then  the file named '10017157_FEPDGP-157_v2.pdf' in Sharepoint location 'FE-PDGP-2122-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017157 Co Ltd UKPRN: 10017157
    Master Contract Number: ESFA-157 Start Date: 01/04/2021 End Date: 31/03/2022
    Contract Ref: PDGP-157
    Cash (£) Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
    Further Education Professional Development Grants £28,000 £0 £0 £0 £0 £0 £0 £16,583 £0 £0 £11,417 £0 £0
    Pilot
    Total Funding £28,000 £0 £0 £0 £0 £0 £0 £16,583 £0 £0 £11,417 £0 £0
    Further Education Professional Development Grants Pilot – PDGP-157 – Page 1 Ref (for internal use only):  FEPDGP-157 v2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017157_FEPDGP-157_v2.pdf' in 'FE-PDGP-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A157.pdf'
  




    # Publish and approve contract v2 

    # Change the date
    Given the override date is '16/09/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'FEPDGP-157'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-157' and actual ContractNumber 'FEPDGP-157'

    # Check that the contract is now approved
    Then  the latest version of contract 'FEPDGP-157' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017157 | FEPDGP-157         | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2021        | 31/03/2022      | Variation     |
    | 10017157 | FEPDGP-157         | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/04/2021        | 31/03/2022      | ?             |
    | 10017157 | ESFA-157           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2021        | 31/03/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'FEPDGP-157' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'FEPDGP-157'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | PDGP-157        | 100992           | Mar-22 | Profile        |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '1' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                           | DeliverableDescription   | 
    | 10017157 | FEPDGP-157     | 2               | PDGP-157      | 1               | 0                     | 28000.00     | 0             | 0        | FE Professional Development Grants Pilot  | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'FEPDGP-157' agree with the most recent entry for this contract in the ContractManagement feed





#    # CDA
#
#    # Change the date 
#    Given the override date is '20/09/2021'
#  
#    # Check the contents of the CDA report
#    Given there is no CDA report named 'CDA Last Approved Version A157.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | FEPDGP-157     | 2                     |
#
#   #When  the following CDA reports are run
#    When  the following CDA report is run
#    | FundingStreamPeriod  | Version               | Suffix |
#    | FE-PDGP2122          | Last Approved Version | A157   |
#
#    Then  a report named 'CDA Last Approved Version A157.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription    | Deliverable                                 | DeliverableParent   | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | FE-PDGP2122             | 10017157 | 10017157 Co Ltd             |               |                             | PDGP-157                 | FEPDGP-157     | ESFA-157                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                           | FE Professional Development Grants Pilot    |                     | 4                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100992            |                          |                   | Apr              |
#    | FE-PDGP2122             | 10017157 | 10017157 Co Ltd             |               |                             | PDGP-157                 | FEPDGP-157     | ESFA-157                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                           | FE Professional Development Grants Pilot    |                     | 5                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100992            |                          |                   | May              |
#    | FE-PDGP2122             | 10017157 | 10017157 Co Ltd             |               |                             | PDGP-157                 | FEPDGP-157     | ESFA-157                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                           | FE Professional Development Grants Pilot    |                     | 6                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100992            |                          |                   | Jun              |
#    | FE-PDGP2122             | 10017157 | 10017157 Co Ltd             |               |                             | PDGP-157                 | FEPDGP-157     | ESFA-157                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                           | FE Professional Development Grants Pilot    |                     | 7                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100992            |                          |                   | Jul              |
#    | FE-PDGP2122             | 10017157 | 10017157 Co Ltd             |               |                             | PDGP-157                 | FEPDGP-157     | ESFA-157                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                           | FE Professional Development Grants Pilot    |                     | 8                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                |                |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100992            |                          |                   | Aug              |
#    | FE-PDGP2122             | 10017157 | 10017157 Co Ltd             |               |                             | PDGP-157                 | FEPDGP-157     | ESFA-157                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                           | FE Professional Development Grants Pilot    |                     | 9                 | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100992            |                          |                   | Sep              |
#    | FE-PDGP2122             | 10017157 | 10017157 Co Ltd             |               |                             | PDGP-157                 | FEPDGP-157     | ESFA-157                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                           | FE Professional Development Grants Pilot    |                     | 10                | 2021            | 2021/22       |              | 16583        |              |               |              | Yes                | 16583.00       | 0.00             | 0.00                  | 0.00           | 16583.00        |             | No            |                   |        | 100992            |                          |                   | Oct              |
#    | FE-PDGP2122             | 10017157 | 10017157 Co Ltd             |               |                             | PDGP-157                 | FEPDGP-157     | ESFA-157                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                           | FE Professional Development Grants Pilot    |                     | 11                | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100992            |                          |                   | Nov              |
#    | FE-PDGP2122             | 10017157 | 10017157 Co Ltd             |               |                             | PDGP-157                 | FEPDGP-157     | ESFA-157                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                           | FE Professional Development Grants Pilot    |                     | 12                | 2021            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100992            |                          |                   | Dec              |
#    | FE-PDGP2122             | 10017157 | 10017157 Co Ltd             |               |                             | PDGP-157                 | FEPDGP-157     | ESFA-157                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                           | FE Professional Development Grants Pilot    |                     | 1                 | 2022            | 2021/22       |              | 11417        |              |               |              | Yes                | 11417.00       |                  | 0.00                  | 0.00           | 11417.00        |             | No            |                   |        | 100992            |                          |                   | Jan              |
#    | FE-PDGP2122             | 10017157 | 10017157 Co Ltd             |               |                             | PDGP-157                 | FEPDGP-157     | ESFA-157                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                           | FE Professional Development Grants Pilot    |                     | 2                 | 2022            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100992            |                          |                   | Feb              |
#    | FE-PDGP2122             | 10017157 | 10017157 Co Ltd             |               |                             | PDGP-157                 | FEPDGP-157     | ESFA-157                | 01/04/2021                  | 31/03/2022                | 2                     | Approved       | Approved                |                           | FE Professional Development Grants Pilot    |                     | 3                 | 2022            | 2021/22       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 100992            |                          |                   | Mar              |





    # Payment Batch for FE-PDGP2122

    # Change the date
    Given the override date is '04/10/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'FE-PDGP2122' AccountingPaymentPeriod '202107' CensusEndDate '04/10/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | PDGP-157                 | 202110 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | FE-PDGP2122                | 202110               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | FE-PDGP2122                | 202110               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'FE-PDGP2122' PaymentPeriod '202107' CensusEndDate '04/10/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A157.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'FE-PDGP2122' PaymentPeriod '202107' CensusEndDate '04/10/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription   | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | PDGP                   | 2021          | 07             | 04          | ?       | PDGP-157      | 16583.00        | PROFILE          | FE PDG                  | 2021-10-18 | 2021-04-01   | 2022-03-31 | ?              | 10017157 | 100992     |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'FE-PDGP2122' AccountingPaymentPeriod '202107' and CensusEndDate '04/10/2021'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                 |
    | Payment Requests for Funding Stream Period FE-PDGP2122 for Payment Period 202107 have been generated as of Census End Date/Time 2021-10-04T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | FE-PDGP2122         | 202107        | 2021-10-04T22:00:00Z  | 1                | 16583.00   |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | PDGP      | 01/04/2021   | 31/03/2022 | 04/10/2021    | 18/10/2021 | 2021          | 07             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription  | AggregatedValue |
    | ORG0017157  | 10017157       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | PDGP-157   | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100992     | PROFILE        | FE PDG                 | 16583.00        |





    # Check financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | FEPDGP-157     | PDGP-157           | 1               | 28000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16583.00 | 0.00     | 0.00     | 11417.00 | 0.00     | 0.00     | 
  
    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | FEPDGP-157     | PDGP-157           | 1               | 28000.00  | ?        | ?        | ?        | ?        | ?        | 0.00     | 16583.00 | 0.00     | 0.00     | 11417.00 | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Apr-21   | May-21   | Jun-21   | Jul-21   | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   |
    | FEPDGP-157     | PDGP-157           | 1               | 28000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16583.00 | 0.00     | 0.00     | 11417.00 | 0.00     | 0.00     | 


    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef  | ProfileSubnominal    | Apr-21    | May-21    | Jun-21    | Jul-21    | Aug-21    | Sep-21    | Oct-21    | Nov-21    | Dec-21    | Jan-22    | Feb-22    | Mar-22    |
    | 10017157 | FEPDGP-157     | PDGP-157       | 100992               | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 16583.00  | 0.00      | 0.00      | 11417.00  | 0.00      | 0.00      | 



    # Tidy Up
    Given the override date is reset
       
  