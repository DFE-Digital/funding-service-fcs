Feature: Create2021FECAcontracts 30502

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run45
Scenario: A568 Bulk load a new 2021 FECA contract. Check docs then publish and approve. Non-financial amendment then check docs. Check CRM and financials
    Given there are no allocations marked as Under Termination for UKPRN '10017568' 
    And   there are no terminated or closed allocations for UKPRN '10017568' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017568' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017568' 

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | FECA2021          |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017568' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017568 Co Ltd' with UKPRN '10017568' and OrgId 'ORG0017568' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017568' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017568 | 117568 | 10017568 Co Ltd | 0              | Active                | Yes           | AA017568      | ?             | 504 Bunyan Court       | Barbican               | London                 | ?                      | ?                      | ?                      | EC2Y 8DH  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017568 |




    # Change the date 
    Given the override date is '22/07/2020'
    
    # Bulk file
    And   there are no files prefixed '10017568' in the Sharepoint 'FECA-2021-Input-Appendices' folder
    And   there are no files prefixed 'FECA FY 2021 21072020105429 v3_A568' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'FECA FY 2021 21072020105429 v3_A568' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'FECA FY 2021 21072020105429 v3_A568' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'FECA FY 2021 21072020105429 v3_A568' in the Sharepoint 'Reports' folder
    And   spreadsheet 'FECA FY 2021 21072020105429 v3_A568.xlsx' exists in the Datafiles folder and UKPRN '10017568' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017568' for FundingType 'FECA' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017568' for FundingType 'FECA' and period '2021'

    # Check the contents of the Appendices
    Then  the file named '10017568_[ContractNo]_v1.pdf' in Sharepoint location 'FECA-2021-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017568 Co Ltd UKPRN: 10017568
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/03/2021
    Contract Ref: [AllocRef_FECA]
    Cash (£) Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    Further Education Condition Allocation £1,676,736 £0 £1,676,736 £0 £0 £0 £0 £0 £0
    Total Funding £1,676,736 £0 £1,676,736 £0 £0 £0 £0 £0 £0
    Further Education Condition Allocation – [AllocRef_FECA] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017568_[ContractNo]_v1.pdf' in 'FECA-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A568.pdf'




    # Change the date 
    Given the override date is '26/07/2020'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017568 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/03/2021      | ?             |
    | 10017568 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '8' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_FECA] | 2410100          | Mar-21 | Profile        |




#    # CDA Report
#
#    # Run the CDA report for FECA2021
#    Given there is no CDA report named 'CDA Last Approved Version A568.csv'
#
#    Then  the contracts are in the replicated CRM database as follows
#    | ContractNumber | ContractVersionNumber |
#    | [ContractNo]   | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod | Version               | Suffix    |
#    | FECA2021            | Last Approved Version | A568      |
#
#    Then  a report named 'CDA Last Approved Version A568.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus   | DeliverableDescription  | Deliverable               | DeliverableParent   | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | FECA2021                | 10017568 | 10017568 Co Ltd             |               |                             | [AllocRef_FECA]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/03/2021                | 1                     | Approved       | Approved            |                         | FE Condition Allocation   |                     | 8                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2410100           |                          |                   | Aug              |
#    | FECA2021                | 10017568 | 10017568 Co Ltd             |               |                             | [AllocRef_FECA]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/03/2021                | 1                     | Approved       | Approved            |                         | FE Condition Allocation   |                     | 9                 | 2020            | 2020/21       |              | 1676736      |              |               |              | Yes                | 1676736.00     |                  | 0.00                  | 0.00           | 1676736.00      |             | No            |                   |        | 2410100           |                          |                   | Sep              |
#    | FECA2021                | 10017568 | 10017568 Co Ltd             |               |                             | [AllocRef_FECA]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/03/2021                | 1                     | Approved       | Approved            |                         | FE Condition Allocation   |                     | 10                | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2410100           |                          |                   | Oct              |
#    | FECA2021                | 10017568 | 10017568 Co Ltd             |               |                             | [AllocRef_FECA]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/03/2021                | 1                     | Approved       | Approved            |                         | FE Condition Allocation   |                     | 11                | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2410100           |                          |                   | Nov              |
#    | FECA2021                | 10017568 | 10017568 Co Ltd             |               |                             | [AllocRef_FECA]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/03/2021                | 1                     | Approved       | Approved            |                         | FE Condition Allocation   |                     | 12                | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2410100           |                          |                   | Dec              |
#    | FECA2021                | 10017568 | 10017568 Co Ltd             |               |                             | [AllocRef_FECA]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/03/2021                | 1                     | Approved       | Approved            |                         | FE Condition Allocation   |                     | 1                 | 2021            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2410100           |                          |                   | Jan              |
#    | FECA2021                | 10017568 | 10017568 Co Ltd             |               |                             | [AllocRef_FECA]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/03/2021                | 1                     | Approved       | Approved            |                         | FE Condition Allocation   |                     | 2                 | 2021            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2410100           |                          |                   | Feb              |
#    | FECA2021                | 10017568 | 10017568 Co Ltd             |               |                             | [AllocRef_FECA]          | [ContractNo]   | [MasterContractNo]      | 01/08/2020                  | 31/03/2021                | 1                     | Approved       | Approved            |                         | FE Condition Allocation   |                     | 3                 | 2021            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           |                  | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2410100           |                          |                   | Mar              |




    # Execute a NON-FINANCIAL amendment and check docs

    # Change the date
    Given the override date is '01/08/2020'

    # Issue a non-financial amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017568 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/03/2021      | Variation     |
    | 10017568 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/03/2021      | ?             |
    | 10017568 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/03/2021      | ?             |

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017568' for FundingType 'FECA' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017568' for FundingType 'FECA' and period '2021'

    # Check the contents of the Appendices. Summary of Funding, yes. Funding Agreements, no. 
    Then  the file named '10017568_[ContractNo]_v2.pdf' in Sharepoint location 'FECA-2021-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017568 Co Ltd UKPRN: 10017568
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/03/2021
    Contract Ref: [AllocRef_FECA]
    Cash (£) Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    Further Education Condition Allocation £1,676,736 £0 £1,676,736 £0 £0 £0 £0 £0 £0
    Total Funding £1,676,736 £0 £1,676,736 £0 £0 £0 £0 £0 £0
    Further Education Condition Allocation – [AllocRef_FECA] – Page 1 Ref (for internal use only):  [ContractNo] v2
    """




    # Change the date 
    Given the override date is '03/08/2020'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017568 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/03/2021      | Variation     |
    | 10017568 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/03/2021      | ?             |
    | 10017568 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '8' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_FECA] | 2410100          | Mar-21 | Profile        |




    # Check CRM financials

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    Then  the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total      | Aug-20   | Sep-20     | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | [ContractNo]   | [AllocRef_FECA]    | 1               | 1676736.00 | 0.00     | 1676736.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total      | Aug-20   | Sep-20     | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | [ContractNo]   | [AllocRef_FECA]    | 1               | 1676736.00 | 0.00     | 1676736.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total      | Aug-20   | Sep-20     | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   |
    | [ContractNo]   | [AllocRef_FECA]    | 1               | 1676736.00 | 0.00     | 1676736.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
Scenario: A569 Create and approve a new 2021 FECA contract. Create PoP payment. Check CRM, CDA, Financials and feed
    Given there are no allocations marked as Under Termination for UKPRN '10017569' 
    And   there are no terminated or closed allocations for UKPRN '10017569' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017569' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017569' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | FECA-569      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | FECA-569      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | FECA2021          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | FEC-569        | 1                     | 0                        |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017569' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017569 Co Ltd' with UKPRN '10017569' and OrgId 'ORG0017569' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017569' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017569 | 117569 | 10017569 Co Ltd | 0              | Provider Under Change | Yes           | AA017569      | ?             | 3 Egremont Street      | ?                      | ?                      | ?                      | Ely                    | Cambridge              | CB6 1AE   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017569 |




    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                        | Period | CRMIntent    | OrgId      |
    | 10017569 | 10017569 Co Ltd      | ESFA-569             | FEC-569        | 1                     | 01/08/2020        | 31/03/2021      | 91236.00      |                                       | Non-learning Grant                  | 2021   | New          | ORG0017569 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                | UoPCode    | AllocationDescription              | CRMIntent    | DeliveryOrg |
    | 10017569 | FEC-569        | FECA-569      | FECA              | FECA2021                | FY                      | 01/08/2020          | 31/03/2021        | 91236.00        |                                        |            |                                    | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | DeliverableDescription       | CRMIntent  | DeliveryOrg |
    | 10017569 | FEC-569        | FECA-569      | 1               | 0                     | 91236.00  | 0.00     | 91236.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | FE Condition Allocation      | New        |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | FEC-569        | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'FEC-569' is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'FEC-569'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-569' and actual ContractNumber 'FEC-569'

    # Check that the contract is now approved
    Then  the latest version of contract 'FEC-569' is showing as 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017569 | FEC-569            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/03/2021      | ?             |
    | 10017569 | ESFA-569           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/03/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '8' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '8' deliverable period rows in CRM linked to the latest version of contract 'FEC-569'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | FECA-569        | 2410100          | Mar-21 | Profile        |




    # Payment Batch for FECA2021


    # Change the date
    Given the override date is '04/09/2020 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'FECA2021' AccountingPaymentPeriod '202006' CensusEndDate '04/09/2020' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | FECA-569                 | 202009 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | FECA2021                   | 202009               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | FECA2021                   | 202009               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'FECA2021' PaymentPeriod '202006' CensusEndDate '04/09/2020' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A569.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'FECA2021' PaymentPeriod '202006' CensusEndDate '04/09/2020' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType | SubnominalDescription | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | FECA                   | 2020          | 06             | 04          | ?       | FECA-569      | 91236.00        | PROFILE     | FEConditionsCapital   | 2020-09-18 | 2020-04-01   | 2021-03-31 | ?              | 10017569 | 2410100    |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'FECA2021' AccountingPaymentPeriod '202006' and CensusEndDate '04/09/2020'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                              |
    | Payment Requests for Funding Stream Period FECA2021 for Payment Period 202006 have been generated as of Census End Date/Time 2020-09-04T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | FECA2021            | 202006        | 2020-09-04T22:00:00Z  | 1                | 91236.00   |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | FECA      | 01/04/2020   | 31/03/2021 | 04/09/2020    | 18/09/2020 | 2020          | 06             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017569  | 10017569       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | FECA-569   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2410100    | PROFILE        | FEConditionsCapital           | 91236.00        |


    # Tidy Up
    And   the override date is reset

      