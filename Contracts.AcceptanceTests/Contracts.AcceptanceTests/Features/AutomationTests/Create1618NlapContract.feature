Feature: Create1618NlapContract

@AcceptanceTest @Complete
@Long2Run @Long2Run123
Scenario Outline: S205 Bulk load a 6-alloc NLAP2018 contract ending in Mar 24. Bulk Amend to extend by 12mths. Consume actuals. Cap. Bulk amend financials to adjust Cap. Payment Batch. Check docs, financials and feed

    # 1. Bulk load a six-alloc NLAP contract. Check docs. Publish and approve
    # 2. Bulk amend to extend 16-18NLAP2018 and ANLAP2018 by 12mths. Check docs. Publish and approve
    # 3. Consume actuals for 24/25 and Cap
    # 4. Payment batch for Jan 25 then check financials and feed 

    Given there is no Contract, Task or Workflow data for UKPRN '<UKPRN>' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '<UKPRN>' 

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '<UKPRN>'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | <FSP1>            |
    | <FSP2>            |

    ## Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
    #And   there is no Subnominal data in CRM for the following subnominal codes
    #| SubnominalCode |
    #| 2240151        |
    #| 2240161        |
    #| 2240162        |
    #| 2340151        |
    #| 2340161        |
    #| 2340162        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '<UKPRN>'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '<UKPRN>' 
    And   there is no caseload advisor for UKPRN '<UKPRN>' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | <UKPRN>  | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '<UKPRN>' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '<UKPRN> Co Ltd' with UKPRN '<UKPRN>' and OrgId '<OrgId>' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber        | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | <UKPRN>  | <UPIN> | <UKPRN> Co Ltd  | 0              | Active                | Yes           | <CompanyNumber>      | ?             | 43 Hill Avenue         | Torr Head              | ?                      | ?                      | Amersham               | Buckinghamshire        | HP6 5BX   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | <UKPRN>  |





    # Part 1. Bulk load a six-alloc NLAP contract. Check docs. Publish and approve

    # Change the date
    Given the override date is '01/12/2017'

    ## Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    #And   the following NLAP NewStarts profile values exist in config
    #| UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
    #| <UKPRN>  | 750.00             | 1025.00            | 2050.00                              | 3175.00                              |


    # Bulk file
    And   there are no files prefixed '<UKPRN>' in the Sharepoint '<Sharepointfolder>' folder
    And   there are no files prefixed '<Bulkfile1>' in the Sharepoint 'Input' folder
    And   there are no files prefixed '<Bulkfile1>' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '<Bulkfile1>' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '<Bulkfile1>' in the Sharepoint 'Reports' folder
    And   spreadsheet '<Bulkfile1>.xlsx' exists in the Datafiles folder and UKPRN '<UKPRN>' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '<UKPRN>' for FundingType '<FundingType>' and period '<Period>'


    # Copy\Save a named Sharepoint file to a named folder\filename
    Then Sharepoint file '<UKPRN>_[ContractNo]_v1.pdf' in '<Sharepointfolder>' is copied to 'Datafiles/Downloads' as 'S205v1.pdf'



    # And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate          | ContractEndDate        | AmendmentType |
    | <UKPRN>  | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | <ContractStartDate>        | <ContractEndDate>      | ?             |
    | <UKPRN>  | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | <ContractStartDate>        | <ContractEndDate>      | ?             |

    ## Check that the CRM subnominals have been created before moving on
    #And   CRM subnominals have been created for the following allocations
    #| AllocationRef   | Subnominal Code  | Period   | Payment Type   |
    #| [AllocRef_YNLP] | 2240151          | <Period> | Reconciliation |
    #| [AllocRef_YNLP] | 2240161          | <Period> | Reconciliation |
    #| [AllocRef_YNLP] | 2240162          | <Period> | Reconciliation |
    #| [AllocRef_ANLP] | 2340151          | <Period> | Reconciliation |
    #| [AllocRef_ANLP] | 2340161          | <Period> | Reconciliation |
    #| [AllocRef_ANLP] | 2340162          | <Period> | Reconciliation |

    And wait '10' seconds

    

    # Part 2. Bulk amend to extend contract and both 2018 allocs by 12mths. Check docs. Publish and approve

    # Change the date
    Given the override date is '04/10/2026'

    ## Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    #And   the following NLAP NewStarts profile values exist in config
    #| UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
    #| <UKPRN>  | 750.00             | 1025.00            | 2050.00                              | 3175.00                              |


    # Bulk file to add 12mths to the contract and both of the 2018 allocs (Note: Bulk file includes [parameters])
    And   there are no files prefixed '<UKPRN>' in the Sharepoint '<Sharepointfolder>' folder
    And   there are no files prefixed '<Bulkfile2>' in the Sharepoint 'Input' folder
    And   there are no files prefixed '<Bulkfile2>' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '<Bulkfile2>' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '<Bulkfile2>' in the Sharepoint 'Reports' folder
    And   spreadsheet '<Bulkfile2>.xlsx' exists in the Datafiles folder and UKPRN '<UKPRN>' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '<UKPRN>' for FundingType '<FundingType>' and period '<Period>'


    # And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Copy\Save a named Sharepoint file to a named folder\filename
    Then Sharepoint file '<UKPRN>_[ContractNo]_v2.pdf' in '<Sharepointfolder>' is copied to 'Datafiles/Downloads' as 'S205v2.pdf'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN   | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate          | ContractEndDate         | AmendmentType |
    | <UKPRN> | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | <ContractStartDate>        | <ExtensionEndDate>      | Variation     |
    | <UKPRN> | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | <ContractStartDate>        | <ContractEndDate>       | ?             |
    | <UKPRN> | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | <ContractStartDate>        | <ContractEndDate>       | ?             |

    # Check that the CRM subnominals have been created before moving on
    #And   CRM subnominals have been created for the following allocations
    #| AllocationRef   | Subnominal Code  | Period   | Payment Type   |
    #| [AllocRef_YNLP] | 2240151          | <Period> | Reconciliation |
    #| [AllocRef_YNLP] | 2240161          | <Period> | Reconciliation |
    #| [AllocRef_YNLP] | 2240162          | <Period> | Reconciliation |
    #| [AllocRef_ANLP] | 2340151          | <Period> | Reconciliation |
    #| [AllocRef_ANLP] | 2340161          | <Period> | Reconciliation |
    #| [AllocRef_ANLP] | 2340162          | <Period> | Reconciliation |

    And wait '10' seconds


    ## Check the PLANNED VALUES in CRM for for NLAP2018 for Jan-22 onwards on the latest approved contract
    #And   the Planned Values are calculated as follows 
    #| ContractNumber | AllocationRef     | DeliverableCode | Total     | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | 
    #| [ContractNo]   | [AllocRef_ANLP]   | 1               | 108201.00 | 2224.00  | 5642.00  | 7563.00  | 3911.00  | 6916.00  | 3741.00  | 7426.00  | 2213.00  | 6172.00  | 2245.00  | 3964.00  | 3030.00  | 5832.00  | 3264.00  | 6746.00  | 
    #| [ContractNo]   | [AllocRef_YNLP]   | 1               | 108015.00 | 6067.00  | 5812.00  | 6577.00  | 4284.00  | 3212.00  | 4316.00  | 1004.00  | 2989.00  | 2872.00  | 5335.00  | 5897.00  | 6322.00  | 5048.00  | 919.00   | 3244.00  | 
   

   
  # Part 3. Consume actuals for 24/25 and Cap payment6    # Change the date6    Given the override date is '06/05/2025'6    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId6    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018041'6    # Clear down the stub6    And   there are no entries in the DCFS stub table6    # Month end is not running6    And   the PaaS MonthEndIsRunning indicator is set to 'False'6    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals6    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS6
    # Pull actuals from DC for Dec 2026
    And   the following closed collections are available in DCFS 
    | CollectionType          | CollectionReturnCode                    | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber   | UoPCode            | DeliverableCode                 | ActualVolume | ActualValue |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202508 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 2910.81     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202509 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 2789.56     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202510 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 2267.88     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202511 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 1893.71     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202512 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 1891.22     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202601 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 5149.45     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202602 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 6305.95     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202603 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 5746.14     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202604 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 8222.12     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202605 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 5746.14     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202606 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 8222.12     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202607 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 5746.14     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202608 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 8222.12     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202609 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 5746.14     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202610 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 5746.14     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202611 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 5746.14     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202612 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 5746.14     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202701 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 8222.12     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202702 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 5746.14     |
    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202703 | <FSP1>           | <ContractAllocationNumber1>          | <UoPCode>          | <DeliverableCode>               | 0            | 5746.14     |

#
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202508 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 2910.81     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202509 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 2789.56     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202510 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 2267.88     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202511 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 1893.71     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202512 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 1891.22     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202601 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 5149.45     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202602 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 6305.95     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202603 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 5746.14     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202604 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 8222.12     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202605 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 5746.14     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202606 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 8222.12     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202607 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 5746.14     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202608 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 8222.12     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202609 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 5746.14     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202610 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 5746.14     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202611 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 5746.14     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202612 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 5746.14     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202701 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 8222.12     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202702 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 5746.14     |
#    | <CollectionType>        | <CollectionReturnCode>                  | <OrgId>     | CM             | 202703 | <FSP2>           | [<ContractAllocationNumber2>]          | <UoPCode>          | <DeliverableCode>               | 0            | 5746.14     |
#

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then wait '30' seconds

#
#    # Check financials for Jan-22 to Mar-24

    ## Check the ACTUAL VALUES in CRM on the latest approved contract
    #Then  the Actuals Value Data is as follows
    #| ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-22   | Jun-23   | Jul-23   | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
    #| [ContractNo]   | [AllocRef_ANLP]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #| [ContractNo]   | [AllocRef_ANLP]    | 2               | 11995.26  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 3064.81  | 1211.23  | 1102.83  | 1128.38  | 5488.01  | ?        | ?        | ?        | 
    #| [ContractNo]   | [AllocRef_ANLP]    | 3               | 12045.58  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1935.85  | 1376.11  | 3222.56  | 1366.38  | 4144.68  | ?        | ?        | ?        | 
    #| [ContractNo]   | [AllocRef_ANLP]    | 4               | 14893.94  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 2598.53  | 2949.17  | 1396.12  | 1653.27  | 6296.85  | ?        | ?        | ?        | 
    #| [ContractNo]   | [AllocRef_ANLP]    | 5               | 17673.56  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 3855.66  | 1139.43  | 2389.76  | 1702.42  | 8586.29  | ?        | ?        | ?        | 
    ##
    #| [ContractNo]   | [AllocRef_YNLP]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #| [ContractNo]   | [AllocRef_YNLP]    | 2               | 12393.43  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 2910.81  | 2789.56  | 3161.18  | 1640.66  | 1891.22  | ?        | ?        | ?        | 
    #| [ContractNo]   | [AllocRef_YNLP]    | 3               | 9753.70   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1327.20  | 1396.59  | 1336.55  | 3139.64  | 2553.72  | ?        | ?        | ?        | 
    #| [ContractNo]   | [AllocRef_YNLP]    | 4               | 12371.94  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 2946.52  | 2471.51  | 2737.12  | 2753.16  | 1463.63  | ?        | ?        | ?        | 
    #| [ContractNo]   | [AllocRef_YNLP]    | 5               | 13182.69  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1395.62  | 1571.21  | 2267.88  | 1893.71  | 6054.27  | ?        | ?        | ?        | 

#    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
#    And   the Reconciliation Data is calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-22   | Jun-23   | Jul-23   | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
#    | [ContractNo]   | [AllocRef_ANLP]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ANLP]    | 2               | 11995.26  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 11995.26 | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ANLP]    | 3               | 12045.58  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12045.58 | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ANLP]    | 4               | 14893.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14893.94 | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ANLP]    | 5               | 17673.56  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 17673.56 | 0.00     | 0.00     | 0.00     | 
#    #
#    | [ContractNo]   | [AllocRef_YNLP]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_YNLP]    | 2               | 12393.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12393.43 | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_YNLP]    | 3               | 9753.70   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 9753.70  | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_YNLP]    | 4               | 12371.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12371.94 | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_YNLP]    | 5               | 13182.69  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13182.69 | 0.00     | 0.00     | 0.00     | 
#
#    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
#    And   the Capping Amounts are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-22   | Jun-23   | Jul-23   | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
#    | [ContractNo]   | [AllocRef_ANLP]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ANLP]    | 2               | -9627.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -9627.98 | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ANLP]    | 3               | -9668.36  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -9668.36 | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ANLP]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ANLP]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    #
#    | [ContractNo]   | [AllocRef_YNLP]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_YNLP]    | 2               | -2006.01  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2006.01 | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_YNLP]    | 3               | -1578.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1578.75 | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_YNLP]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_YNLP]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#
#    # Check the NET AMOUNTS in CRM on the latest approved contract
#    And   the Net Payments are calculated as follows 
#    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-22   | Jun-23   | Jul-23   | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
#    | [ContractNo]   | [AllocRef_ANLP]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ANLP]    | 2               | 2367.28   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2367.28  | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ANLP]    | 3               | 2377.22   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2377.22  | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ANLP]    | 4               | 14893.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14893.94 | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_ANLP]    | 5               | 17673.56  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 17673.56 | 0.00     | 0.00     | 0.00     | 
#    #
#    | [ContractNo]   | [AllocRef_YNLP]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_YNLP]    | 2               | 10387.42  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 10387.42 | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_YNLP]    | 3               | 8174.95   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8174.95  | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_YNLP]    | 4               | 12371.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12371.94 | 0.00     | 0.00     | 0.00     | 
#    | [ContractNo]   | [AllocRef_YNLP]    | 5               | 13182.69  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13182.69 | 0.00     | 0.00     | 0.00     | 
#
#
#    # Subnominal Aggregations
#
#    # Check the RECONCILIATION subnominal aggregations in CRM
#    And   the Reconciliation Subnominal Amounts are calculated as follows
#    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Sep-26    |
#    | <UKPRN> | [ContractNo]   | [AllocRef_ANLP]    | 2340151                  | 24040.84  | 
#    | <UKPRN> | [ContractNo]   | [AllocRef_ANLP]    | 2340161                  | 14893.94  | 
#    | <UKPRN> | [ContractNo]   | [AllocRef_ANLP]    | 2340162                  | 17673.56  | 
#    | <UKPRN> | [ContractNo]   | [AllocRef_YNLP]    | 2240151                  | 22147.13  | 
#    | <UKPRN> | [ContractNo]   | [AllocRef_YNLP]    | 2240161                  | 12371.94  | 
#    | <UKPRN> | [ContractNo]   | [AllocRef_YNLP]    | 2240162                  | 13182.69  | 
#
#    # Check the CAPPING subnominal aggregations in CRM
#    And   the Capping Subnominal Amounts are calculated as follows
#    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Sep-26    |
#    | <UKPRN> | [ContractNo]   | [AllocRef_ANLP]    | 2340151                  | -19296.34 | 
#    | <UKPRN> | [ContractNo]   | [AllocRef_YNLP]    | 2240151                  | -3584.76  | 
#
#
#


    # Part 5. Payment batch for Apr 25

    # Payment Batch stuff starts here for 16-18NLAP2018(PoA)

    # Change the date
    Given the override date is '<CensusEndDate> 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '<FSP1>' AccountingPaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    #And   the following allocation periods are present in the subnominal aggregation PaaS table
    #| ContractAllocationNumber              | Period          |
    #| [<ContractAllocationNumber1>]          | <PaymentPeriod> |

    And wait '10' seconds

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period          | Census End Date/Time | LinkCodeSuffix | Status     |
    | <FSP1>                     | <PaymentPeriod>               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period          | Status    |
    | <FSP1>                     | <PaymentPeriod>               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '<FSP1>' PaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S205_1.xml'

#    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    And   the Payment feed xml for FundingStreamPeriod '16-18NLAP2018' PaymentPeriod '202409' CensusEndDate '09/01/2025' and LinkCodeSuffix 'A' includes the following values
#    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    | YNLP                   | 2024          | 09             | 09          | ?       | [AllocRef_YNLP]   | -3584.76        | CAPPING          | 16-18 NLAP             | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | <UKPRN> | 2240151    |
#    | YNLP                   | 2024          | 09             | 09          | ?       | [AllocRef_YNLP]   | 22147.13        | RECONCILIATION   | 16-18 NLAP             | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | <UKPRN> | 2240151    |
#    | YNLP                   | 2024          | 09             | 09          | ?       | [AllocRef_YNLP]   | 12371.94        | RECONCILIATION   | 16-18 NLAP Employer    | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | <UKPRN> | 2240161    |
#    | YNLP                   | 2024          | 09             | 09          | ?       | [AllocRef_YNLP]   | 13182.69        | RECONCILIATION   | 16-18NonLevy AppsInd   | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | <UKPRN> | 2240162    |
#



#
#    # Payment Batch stuff starts here for ANLAP2018(PoA)
#
#    # Change the date
#    Given the override date is '<CensusEndDate> 22:05'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod '<FSP2>' AccountingPaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    #And   the following allocation periods are present in the subnominal aggregation PaaS table
#    #| ContractAllocationNumber               | Period |
#    #| [<ContractAllocationNumber2>]          | <PaymentPeriod> |
#
#
#    And wait '10' seconds
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period          | Census End Date/Time | LinkCodeSuffix | Status     |
#    | <FSP2>                     | <PaymentPeriod>               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period          | Status    |
#    | <FSP2>                     | <PaymentPeriod>               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod '<FSP2>' PaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S205_2.xml'

    ## Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    #And   the Payment feed xml for FundingStreamPeriod 'ANLAP2018' PaymentPeriod '202409' CensusEndDate '09/01/2025' and LinkCodeSuffix 'A' includes the following values
    #| FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    #| ANLP                   | 2024          | 09             | 09          | ?       | [AllocRef_ANLP]   | -19296.34       | CAPPING          | 19+ NLAP               | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | <UKPRN> | 2340151    |
    #| ANLP                   | 2024          | 09             | 09          | ?       | [AllocRef_ANLP]   | 24040.84        | RECONCILIATION   | 19+ NLAP               | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | <UKPRN> | 2340151    |
    #| ANLP                   | 2024          | 09             | 09          | ?       | [AllocRef_ANLP]   | 14893.94        | RECONCILIATION   | 19+ NLAP Employer      | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | <UKPRN> | 2340161    |
    #| ANLP                   | 2024          | 09             | 09          | ?       | [AllocRef_ANLP]   | 17673.56        | RECONCILIATION   | 19+NonLevy AppsInd     | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | <UKPRN> | 2340162    |



    # Part 10: Create Consolidated Payment Summary rpt
   
    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
    #Given the override date is '06/01/2023 10:00'

   # Change the date
   Given the override date is '10/10/2026'
   
   Given there are no files prefixed '2026-09 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
   
   When  a Consolidated Payment Summary Report is created in Sharepoint for '10/10/2026'
    # Check the above report manually

   
    # CDA
    
    # Run the CDA report
    Given the override date is '13/10/2026'
    Given there is no CDA report named 'CDA Latest Version S205.csv'
    And   the following ADF Pipeline run
    And   the following CDA report is run
    | FundingStreamPeriod           | Version               | Suffix |
    | <FSP1>, <FSP2>                | Latest Version        | S205   |

    Then  a report named 'CDA Latest Version S205.csv' is created
	# Check the above report manually



    # Tidy Up
    Given the override date is reset

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '<UKPRN>'


#   
Examples:
    | UKPRN   | LegalName           | UPIN  | OrgId      | CompanyNumber |  InitialOverrideDate |   AmendOverrideDate |   ExtensionEndDate  | FSP1          	    | FSP2          	|  PaymentPeriod | FinancialPeriod | CensusEndDate |  Period   |    Bulkfile1   						                    | Bulkfile2   						                    | FundingType | Sharepointfolder          | ContractStartDate | ContractEndDate | CollectionType | CollectionReturnCode  | ContractAllocationNumber1 | ContractAllocationNumber2 | UoPCode      |  DeliverableCode    |   
   #| 10019205| 10019205 Co Ltd     | 119205| ORG0019205 | AA019205      |  01/12/2017          |   04/10/2026        |   31/03/2027        | 16-18NLAP2018	        | ANLAP2018	        |  202609        | 202606          | 08/10/2026    |  2018     |    NLA NONLEVY 2018 01122023141343 v1_S205                 | NLA NONLEVY 2018 04102026141345 v2_S205	            | NLA         | NLA-2018-Input-Appendices | 01/01/2018        | 31/03/2026      | ILR2627        | R05                   | [AllocRef_YNLP]           | [AllocRef_ANLP]           |  ?           |  2                  |
    | 10019205| 10019205 Co Ltd     | 119205| ORG0019205 | AA019205      |  01/09/2023          |   04/10/2026        |   31/07/2027        | SB2023       	        |       	        |  202609        | 202606          | 08/10/2026    |  2023     |    SBD SB 2023 24082023094413 v1_S205                      | SBD SB 2023 24092026094413 v2_S205    	            | SBD         | SBD-2023-Input-Appendices | 01/09/2023        | 31/07/2026      | SB			 | SB30                  | [AllocRef_SBD]            |                           | R02C07       | 337                 |  


    