Feature: Create1920NCSContracts 25589

@AcceptanceTest @Withdrawn20230123
Scenario: A302 Create and approve an 1819 NCS contract then bulk load a new 1920 NCS contract with a linked Master. Check 1920 docs then publish and approve 1920 contract
    Given there are no allocations marked as Under Termination for UKPRN '10017302' 
    And   there are no terminated or closed allocations for UKPRN '10017302' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017302' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | NCSC-302      |
    | NCSV-302      |


    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017302'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017302 Co Ltd' with UKPRN '10017302' and OrgId 'ORG0017302' and has 'FCS1 Test' as a manager
    And   UPIN '117302' is associated with UKPRN '10017302' in the CRM Organisation table 
 
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017302 | 117302 | 10017302 Co Ltd | 0              | Active | Yes           | AA017302      | ?             | 23 Thimble Rd          | Camberwick Green       | ?                      | ?                      | Warwick                | Warwickshire           | CV35 8EP  |

    # Put data in the CRM Organisation table J057
    And   the following Organisations exist in CRM
    | UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017302 | 117302 | 10017302 Co Ltd | Active | AA017302      | ?             | 23 Thimble Rd          | Camberwick Green       | ?                      | ?                      | Warwick                | Warwickshire           | CV35 8EP  |
 



    # Create and approve an 1819 NCS contract with NCS-C1819 and NCS-DEV1819 allocations

    # Change the date
    Given the override date is '01/09/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017302 | 10017302 Co Ltd      | ESFA-302             | NCS-302        | 1                     | 01/10/2018        | 31/03/2019      | 48719.00      | West Midlands and Staffordshire    | Contract for Services | 1819   | New          | ORG0017302 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017302 | NCS-302        | NCSC-302      | NCS-C             | NCS-C1819               | NCS                     | 01/10/2018          | 31/03/2019        | 34999.00        | West Midlands and Staffordshire         | 0000000104 |                                                             | New          |             |
    | 10017302 | NCS-302        | NCSV-302      | NCS-DEV           | NCS-DEV1819             | NCS                     | 01/10/2018          | 31/03/2019        | 13720.00        | West Midlands and Staffordshire         | 0000000104 |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                   | CRMIntent    | DeliveryOrg |
    | 10017302 | NCS-302        | NCSC-302      | 1               | 0                     | 34999.00  | 7712.00  | 6220.00  | 8963.00  | 7154.00  | 3443.00  | 1507.00  | Total In The Community Funding           | New          |             |
    | 10017302 | NCS-302        | NCSC-302      | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service              | New          |             |
    | 10017302 | NCS-302        | NCSC-302      | 2               | 1                     | 10607.00  | 2923.00  | 1446.00  | 3161.00  | 734.00   | 1594.00  | 749.00   | Customer Satisfaction                    | New          |             |
    | 10017302 | NCS-302        | NCSC-302      | 3               | 1                     | 24392.00  | 4789.00  | 4774.00  | 5802.00  | 6420.00  | 1849.00  | 758.00   | Career Management and Jobs and Learning  | New          |             |
    | 10017302 | NCS-302        | NCSC-302      | 4               | 3                     | 12937.00  | 2642.00  | 2207.00  | 3512.00  | 3299.00  | 1219.00  | 58.00    | Career Management                        | New          |             |
    | 10017302 | NCS-302        | NCSC-302      | 5               | 3                     | 11455.00  | 2147.00  | 2567.00  | 2290.00  | 3121.00  | 630.00   | 700.00   | Jobs and Learning                        | New          |             |
    | 10017302 | NCS-302        | NCSV-302      | 1               | 0                     | 13720.00  | 0.00     | 0.00     | 0.00     | 4459.00  | 4459.00  | 4802.00  | 50 Plus Futures                          | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | DeliverableCode | AllocationRef | UnitCost | Total   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | 
    | 10017302 | NCS-302        | 6               | NCSC-302      | 0        | 373     | 18       | 87       | 87       | 43       | 58       | 80       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NCS-302' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-302' and actual ContractNumber 'NCS-302'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-302' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017302 | NCS-302            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/10/2018        | 31/03/2019      | ?             |
    | 10017302 | ESFA-302           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables (7 deliverables x 6 mths)
    And   there are '42' deliverable period rows in CRM linked to the latest version of contract 'NCS-302'




    # Bulk create a new linked 1920 NCS contract
	
	# Change the date
    Given the override date is '17/03/2019'

    # Clear down the CM feed
    And   the Contract Management atom feed is empty 

	# Bulk import to create a new 1920 NCS contract linked to the 1819 NCS contract through Master using intent 'New Amendment'
    And   there are no files prefixed '10017302' in the Sharepoint 'NCS-1920-Input-Appendices' folder
    And   there are no files prefixed 'NCS FY 1920 08022019124541 v3_A302' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NCS FY 1920 08022019124541 v3_A302' in the Sharepoint 'Reports' folder

    And   spreadsheet 'NCS FY 1920 08022019124541 v3_A302.xlsx' exists in the Datafiles folder and UKPRN '10017302' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters 
   #And   I retrieve the latest EFA contract details from CRM for provider '10017302' for FundingType 'NCS' and period '1920' and Delivery Organisation '10017302'
    And   I retrieve the latest contract details from CRM for provider '10017302' for FundingType 'NCS' and period '1920'

    # Check the contents of the Appendices
    And   a file for this contract exists in sharepoint location 'NCS-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SCHEDULE 6
    Maximum Contract Value and Target
    Customer Volumes
    Maximum Contract Value
    1. In this Schedule, where the context admits, defined terms shall have the
    meaning given to them in Clause 1 of the Terms and Conditions.
    2. This Schedule sets out the Maximum Contract Value for the supply of the
    Services under the Contract from 1 April 2019 – 31 March 2020.  Delivery
    against this Contract shall start on 1 October 2018. For the avoidance of doubt,
    the Prime Contractor may not seek to invoice the ESFA in respect of any
    services supplied prior to the Services Start Date of 1 October 2018.
    3. The Maximum Contract Value in the Area for the period 1 April 2019 – 31 March
    2020 is £87,079. The Maximum Contract Value must be allocated in
    accordance with the principles set out in the Funding Rules.
    4. The Maximum Contract Value has been calculated to include inflation during the
    Contract Period and will not be increased to reflect inflationary rate rises during
    the Contract Period.
    5. The Maximum Contract Value in the Area for the Contract Year starting on 1
    April 2020, and for each subsequent anniversary thereof, shall be as notified by
    the ESFA to the Prime Contractor as soon as is practicable at the beginning of
    each calendar year, with final allocations confirmed at the beginning of May
    each year.
    6. This Schedule supplements the obligations on the Prime Contractor in the
    Terms and Conditions and the Funding Rules.
    Target Customer Volumes
    7. The Target Customer Volumes are as follows:
    Contract Year Target Customer Volumes
    01/04/19 – 31/03/20 1,762
    01/04/20 – 31/03/21 TBC
    """

    # Save a copy of the output
   #Then  Sharepoint file '10017nnn_[ContractNo]_v1.pdf' in 'xxx-nnnn-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017nnn_[ContractNo]_v1.pdf'
    Then  Sharepoint file '10017302_[ContractNo]_v1.pdf' in 'NCS-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017302_[ContractNo]_v1.pdf'


    #And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'

    # Change the date
    And   the override date is '21/03/2019'
   
    # Inject an SFS contract approval message.
   #When  an AEB contract approval message is received from SFS for MasterContractNumber 'ESFA-302' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-302' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved in CRM
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017302 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2019        | 31/03/2020      | ?             |
    | 10017302 | ESFA-302           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable counts in CRM 
   #And   there are 'nnn' deliverable periods in CRM linked to the latest version of contract 'xxxx-302' and allocation 'xxxx-302' 
   #And   there are 'nnn' deliverable period rows in CRM linked to the latest version of contract 'xxxx-302' 
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 

    # Check deliverable data in the ContractManagement Legal feed
    Then  the Legal Contract CM feed contains the following '6' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef   | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                            | DeliverableDescription                                      | 
    | 10017302 | [ContractNo]   | 1               | [AllocRef_NCSC] | 1               | 0                     | 87079        | 0             | 0        | Total In The Community Funding             | ?                                                           |
    | 10017302 | [ContractNo]   | 1               | [AllocRef_NCSC] | 2               | 1                     | 27206        | 0             | 0        | Customer Satisfaction                      | ?                                                           |
    | 10017302 | [ContractNo]   | 1               | [AllocRef_NCSC] | 3               | 1                     | 59873        | 0             | 0        | Career Management and Jobs and Learning    | ?                                                           |
    | 10017302 | [ContractNo]   | 1               | [AllocRef_NCSC] | 4               | 3                     | 26949        | 0             | 0        | Career Management                          | ?                                                           |
    | 10017302 | [ContractNo]   | 1               | [AllocRef_NCSC] | 5               | 3                     | 32924        | 0             | 0        | Jobs and Learning                          | ?                                                           |
    | 10017302 | [ContractNo]   | 1               | [AllocRef_NCSC] | 6               | 0                     | 0            | 1762          | 0        | Customers Accessing Service                | ?                                                           |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run123
Scenario: A303SLD Create and approve an 1819 NCS contract and a new 1920 NCS contract with a linked Master. Publish and approve the 1920 contract then bulk amend and approve it. Consume actuals and create payment. Check CRM, Financials and feeds
    Given there are no allocations marked as Under Termination for UKPRN '10017303' 
    And   there are no terminated or closed allocations for UKPRN '10017303' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017303' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef  |
    | NCSC-3031      |
    | NCSV-3031      |
    | NCSC-3032      |

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017303' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017303 Co Ltd' with UKPRN '10017303' and OrgId 'ORG0017303' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017303 | 117303 | 10017303 Co Ltd | 0              | Provider Under Change | Yes           | AA017303      | ?             | 65a High Street        | Walton-on-Thames       | ?                      | ?                      | ?                      | ?                      | KT12 1DJ  |

    # Put the same Provider data in the CRM Organisation table J057
    And   the following Organisations exist in CRM
    | OrgId      | UKPRN    | UPIN   | Name            | Status                | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | ORG0017303 | 10017303 | 117303 | 10017303 Co Ltd | Provider Under Change | AA017303      | 17303         | 65a High Street        | Walton-on-Thames       | ?                      | ?                      | ?                      | ?                      | KT12 1DJ  |




    # Create and approve an 1819 NCS contract with NCS-C1819 and NCS-DEV1819 allocations

    # Change the date
    Given the override date is '01/09/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017303 | 10017303 Co Ltd      | ESFA-303             | NCS-3031       | 1                     | 01/10/2018        | 31/03/2019      | 48719.00      | South West and Oxfordshire         | Contract for Services | 1819   | New          | ORG0017303 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                            | UoPCode    | AllocationDescription          | CRMIntent    | DeliveryOrg |
    | 10017303 | NCS-3031       | NCSC-3031     | NCS-C             | NCS-C1819               | NCS                     | 01/10/2018          | 31/03/2019        | 34999.00        | South West and Oxfordshire         | 0000000108 |                                | New          |             |
    | 10017303 | NCS-3031       | NCSV-3031     | NCS-DEV           | NCS-DEV1819             | NCS                     | 01/10/2018          | 31/03/2019        | 13720.00        | South West and Oxfordshire         | 0000000108 |                                | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017303 | NCS-3031       | NCSC-3031     | 1               | 0                     | 34999.00  | 7712.00  | 6220.00  | 8963.00  | 7154.00  | 3443.00  | 1507.00  | Total In The Community Funding                                  | New          |             |
    | 10017303 | NCS-3031       | NCSC-3031     | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             |
    | 10017303 | NCS-3031       | NCSC-3031     | 2               | 1                     | 10607.00  | 2923.00  | 1446.00  | 3161.00  | 734.00   | 1594.00  | 749.00   | Customer Satisfaction                                           | New          |             |
    | 10017303 | NCS-3031       | NCSC-3031     | 3               | 1                     | 24392.00  | 4789.00  | 4774.00  | 5802.00  | 6420.00  | 1849.00  | 758.00   | Career Management and Jobs and Learning                         | New          |             |
    | 10017303 | NCS-3031       | NCSC-3031     | 4               | 3                     | 12937.00  | 2642.00  | 2207.00  | 3512.00  | 3299.00  | 1219.00  | 58.00    | Career Management                                               | New          |             |
    | 10017303 | NCS-3031       | NCSC-3031     | 5               | 3                     | 11455.00  | 2147.00  | 2567.00  | 2290.00  | 3121.00  | 630.00   | 700.00   | Jobs and Learning                                               | New          |             |
    | 10017303 | NCS-3031       | NCSV-3031     | 1               | 0                     | 13720.00  | 0.00     | 0.00     | 0.00     | 4459.00  | 4459.00  | 4802.00  | 50 Plus Futures                                                 | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | DeliverableCode | AllocationRef | UnitCost | Total   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | 
    | 10017303 | NCS-3031       | 6               | NCSC-3031     | 0        | 373     | 18       | 87       | 87       | 43       | 58       | 80       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/09/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NCS-3031' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/09/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-303' and actual ContractNumber 'NCS-3031'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-3031' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017303 | NCS-3031           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/10/2018        | 31/03/2019      | ?             |
    | 10017303 | ESFA-303           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables (7 deliverables x 6 mths)
    And   there are '42' deliverable period rows in CRM linked to the latest version of contract 'NCS-3031'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | NCSV-3031     | 2305330          | Mar-19 | Profile        |
    | NCSC-3031     | 2305310          | Mar-19 | Reconciliation |
    | NCSC-3031     | 2305310          | Mar-19 | Capping        |




    # Create and approve a 1920 NCS contract with the same Master as the 1819 NCS contract

    # Change the date
    Given the override date is '01/03/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017303 | 10017303 Co Ltd      | ESFA-303             | NCS-3032       | 1                     | 01/04/2019        | 31/03/2020      | 62120.00      |                                    | Contract for Services | 1920   | New          | ORG0017303 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017303 | NCS-3032       | NCSC-3032     | NCS-C             | NCS-C1920               | FY                      | 01/04/2019          | 31/03/2020        | 62120.00        | South West and Oxfordshire              | 0000000108 |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017303 | NCS-3032       | NCSC-3032     | 1               | 0                     | 62120.00  | 2761.00  | 6616.00  | 9107.00  | 7071.00  | 6528.00  | 2723.00  | 3033.00  | 5050.00  | 5420.00  | 7026.00  | 2210.00  | 4575.00  | Total In The Community Funding                                  | New          |             |
    | 10017303 | NCS-3032       | NCSC-3032     | 2               | 1                     | 19029.00  | 484.00   | 3182.00  | 3474.00  | 1616.00  | 771.00   | 588.00   | 153.00   | 1458.00  | 1245.00  | 2866.00  | 722.00   | 2470.00  | Customer Satisfaction                                           | New          |             |
    | 10017303 | NCS-3032       | NCSC-3032     | 3               | 1                     | 43091.00  | 2277.00  | 3434.00  | 5633.00  | 5455.00  | 5757.00  | 2135.00  | 2880.00  | 3592.00  | 4175.00  | 4160.00  | 1488.00  | 2105.00  | Career Management and Jobs and Learning                         | New          |             |
    | 10017303 | NCS-3032       | NCSC-3032     | 4               | 3                     | 20904.00  | 1401.00  | 1125.00  | 1955.00  | 2182.00  | 3235.00  | 1061.00  | 1164.00  | 1836.00  | 2538.00  | 2167.00  | 562.00   | 1678.00  | Career Management                                               | New          |             |
    | 10017303 | NCS-3032       | NCSC-3032     | 5               | 3                     | 22187.00  | 876.00   | 2309.00  | 3678.00  | 3273.00  | 2522.00  | 1074.00  | 1716.00  | 1756.00  | 1637.00  | 1993.00  | 926.00   | 427.00   | Jobs and Learning                                               | New          |             |
    | 10017303 | NCS-3032       | NCSC-3032     | 6               | 0                     | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Customers Accessing Service                                     | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | DeliverableCode | AllocationRef | UnitCost | Total   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | 
    | 10017303 | NCS-3032       | 6               | NCSC-3032     | 0        | 793     | 12       | 86       | 20       | 38       | 99       | 98       | 76       | 52       | 99       | 48       | 70       | 95       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/03/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NCS-3032' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/03/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-303' and actual ContractNumber 'NCS-3032'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-3032' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017303 | NCS-3032           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2019        | 31/03/2020      | ?             |
    | 10017303 | ESFA-303           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'NCS-3032'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | NCSC-3032     | 2305310          | Mar-20 | Reconciliation |
    | NCSC-3032     | 2305310          | Mar-20 | Capping        |




    # Bulk amend then publish and approve
	
	# Change the date
    Given the override date is '12/03/2019'

    # Amend the contract by bulk upload
    And   there are no files prefixed '10017303' in the Sharepoint 'NCS-1920-Input-Appendices' folder
    And   there are no files prefixed 'NCS FY 1920 13022019121314 v3_A303' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NCS FY 1920 13022019121314 v3_A303' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NCS FY 1920 13022019121314 v3_A303.xlsx' exists in the Datafiles folder and UKPRN '10017303' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Change the date
    Given the override date is '15/03/2019'

    # Publish the contract
    And   the latest version of contract 'NCS-3032' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-303' and actual ContractNumber 'NCS-3032'

    # Check that the contract is now approved
    Then  the latest version of contract 'NCS-3032' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017303 | NCS-3032           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2019        | 31/03/2020      | Variation     |
    | 10017303 | NCS-3032           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/04/2019        | 31/03/2020      | ?             |
    | 10017303 | ESFA-303           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/10/2018        | 31/03/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'NCS-3032'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code  | Period | Payment Type   |
    | NCSC-3032     | 2305310          | Mar-20 | Reconciliation |
    | NCSC-3032     | 2305310          | Mar-20 | Capping        |




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/07/2019'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Jun 2019 for NCSC-3032
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201904 | NCS-C1920               | NCSC-3032                | 0000000108 | 2               | 0            | 1709.65     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201904 | NCS-C1920               | NCSC-3032                | 0000000108 | 4               | 0            | 840.71      |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201904 | NCS-C1920               | NCSC-3032                | 0000000108 | 5               | 0            | 1073.09     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201905 | NCS-C1920               | NCSC-3032                | 0000000108 | 2               | 0            | 1592.98     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201905 | NCS-C1920               | NCSC-3032                | 0000000108 | 4               | 0            | 1501.05     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201905 | NCS-C1920               | NCSC-3032                | 0000000108 | 5               | 0            | 917.42      |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201906 | NCS-C1920               | NCSC-3032                | 0000000108 | 2               | 0            | 915.25      |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201906 | NCS-C1920               | NCSC-3032                | 0000000108 | 4               | 0            | 2374.63     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201906 | NCS-C1920               | NCSC-3032                | 0000000108 | 5               | 0            | 856.69      |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201907 | NCS-C1920               | NCSC-3032                | 0000000108 | 2               | 0            | 2473.66     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201907 | NCS-C1920               | NCSC-3032                | 0000000108 | 4               | 0            | 2102.06     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201907 | NCS-C1920               | NCSC-3032                | 0000000108 | 5               | 0            | 672.73      |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201908 | NCS-C1920               | NCSC-3032                | 0000000108 | 2               | 0            | 911.82      |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201908 | NCS-C1920               | NCSC-3032                | 0000000108 | 4               | 0            | 1184.95     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201908 | NCS-C1920               | NCSC-3032                | 0000000108 | 5               | 0            | 1463.13     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201909 | NCS-C1920               | NCSC-3032                | 0000000108 | 2               | 0            | 1929.67     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201909 | NCS-C1920               | NCSC-3032                | 0000000108 | 4               | 0            | 1745.52     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201909 | NCS-C1920               | NCSC-3032                | 0000000108 | 5               | 0            | 2195.30     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201910 | NCS-C1920               | NCSC-3032                | 0000000108 | 2               | 0            | 1022.72     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201910 | NCS-C1920               | NCSC-3032                | 0000000108 | 4               | 0            | 2303.95     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201910 | NCS-C1920               | NCSC-3032                | 0000000108 | 5               | 0            | 1888.54     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201911 | NCS-C1920               | NCSC-3032                | 0000000108 | 2               | 0            | 593.73      |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201911 | NCS-C1920               | NCSC-3032                | 0000000108 | 4               | 0            | 1470.02     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201911 | NCS-C1920               | NCSC-3032                | 0000000108 | 5               | 0            | 1959.25     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201912 | NCS-C1920               | NCSC-3032                | 0000000108 | 2               | 0            | 456.07      |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201912 | NCS-C1920               | NCSC-3032                | 0000000108 | 4               | 0            | 2315.86     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 201912 | NCS-C1920               | NCSC-3032                | 0000000108 | 5               | 0            | 2454.48     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 202001 | NCS-C1920               | NCSC-3032                | 0000000108 | 2               | 0            | 2078.48     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 202001 | NCS-C1920               | NCSC-3032                | 0000000108 | 4               | 0            | 1905.64     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 202001 | NCS-C1920               | NCSC-3032                | 0000000108 | 5               | 0            | 1470.40     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 202002 | NCS-C1920               | NCSC-3032                | 0000000108 | 2               | 0            | 1306.09     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 202002 | NCS-C1920               | NCSC-3032                | 0000000108 | 4               | 0            | 2402.86     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 202002 | NCS-C1920               | NCSC-3032                | 0000000108 | 5               | 0            | 2419.84     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 202003 | NCS-C1920               | NCSC-3032                | 0000000108 | 2               | 0            | 2290.84     |
    | NCS1920        | N11                  | ORG0017303     | CM             | 202003 | NCS-C1920               | NCSC-3032                | 0000000108 | 4               | 0            | 680.75      |
    | NCS1920        | N11                  | ORG0017303     | CM             | 202003 | NCS-C1920               | NCSC-3032                | 0000000108 | 5               | 0            | 1395.96     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service




    # Check CRM and PaaS

    # Check the ACTUAL VALUES in CRM
    Then  the Actuals Value Data is as follows
    | ContractNumber  | AllocationRef    | DeliverableCode | Total    | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | NCS-3032        | NCSC-3032        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 2               | 4217.88  | 1709.65  | 1592.98  | 915.25   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 4               | 4716.39  | 840.71   | 1501.05  | 2374.63  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 5               | 2847.20  | 1073.09  | 917.42   | 856.69   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber  | AllocationRef    | DeliverableCode | Total    | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | NCS-3032        | NCSC-3032        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 2               | 4217.88  | 0.00     | 0.00     | 4217.88  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 4               | 4716.39  | 0.00     | 0.00     | 4716.39  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 5               | 2847.20  | 0.00     | 0.00     | 2847.20  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the CAPPING AMOUNTS in CRM
    And   the Capping Amounts are calculated as follows 
    | ContractNumber  | AllocationRef    | DeliverableCode | Total    | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | NCS-3032        | NCSC-3032        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 4               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 5               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber  | AllocationRef    | DeliverableCode | Total    | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | NCS-3032        | NCSC-3032        | 1               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 2               | 4217.88  | 0.00     | 0.00     | 4217.88  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 3               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 4               | 4716.39  | 0.00     | 0.00     | 4716.39  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 5               | 2847.20  | 0.00     | 0.00     | 2847.20  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | NCS-3032        | NCSC-3032        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber  | AllocationRef    | DeliverableCode | Total    | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | NCS-3032        | NCSC-3032        | 1               | 62120.00 | 2761.00  | 6616.00  | 9107.00  | 7071.00  | 6528.00  | 2723.00  | 3033.00  | 5050.00  | 5420.00  | 7026.00  | 2210.00  | 4575.00  | 
    | NCS-3032        | NCSC-3032        | 2               | 19029.00 | 484.00   | 3182.00  | 3474.00  | 1616.00  | 771.00   | 588.00   | 153.00   | 1458.00  | 1245.00  | 2866.00  | 722.00   | 2470.00  | 
    | NCS-3032        | NCSC-3032        | 3               | 43091.00 | 2277.00  | 3434.00  | 5633.00  | 5455.00  | 5757.00  | 2135.00  | 2880.00  | 3592.00  | 4175.00  | 4160.00  | 1488.00  | 2105.00  | 
    | NCS-3032        | NCSC-3032        | 4               | 20904.00 | 1401.00  | 1125.00  | 1955.00  | 2182.00  | 3235.00  | 1061.00  | 1164.00  | 1836.00  | 2538.00  | 2167.00  | 562.00   | 1678.00  | 
    | NCS-3032        | NCSC-3032        | 5               | 22187.00 | 876.00   | 2309.00  | 3678.00  | 3273.00  | 2522.00  | 1074.00  | 1716.00  | 1756.00  | 1637.00  | 1993.00  | 926.00   | 427.00   | 
    | NCS-3032        | NCSC-3032        | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PLANNED VOLUMES in CRM
    And   the Planned Volumes are calculated as follows 
    | ContractNumber  | AllocationRef    | DeliverableCode | Total    | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   |
    | NCS-3032        | NCSC-3032        | 1               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-3032        | NCSC-3032        | 2               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-3032        | NCSC-3032        | 3               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-3032        | NCSC-3032        | 4               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-3032        | NCSC-3032        | 5               | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 0        | 
    | NCS-3032        | NCSC-3032        | 6               | 793      | 12       | 86       | 20       | 38       | 99       | 98       | 76       | 52       | 99       | 48       | 70       | 95       | 

    # Check the ACTUAL totals in CRM at deliverable level rather than deliverable period level (24295)
    And   the Actuals Data is stored in CRM at deliverable level against the last approved version of the contract as follows
    | ContractNumber | AllocationRef   | DeliverableCode | ActualValue | ActualVolume |
	| NCS-3032       | NCSC-3032       | 1               | 11781.47    | ?            |
    | NCS-3032       | NCSC-3032       | 2               | 4217.88     | 0            |
    | NCS-3032       | NCSC-3032       | 3               | 7563.59     | ?            |
    | NCS-3032       | NCSC-3032       | 4               | 4716.39     | 0            |
    | NCS-3032       | NCSC-3032       | 5               | 2847.20     | 0            |
    | NCS-3032       | NCSC-3032       | 6               | 0.00        | 0            |

    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | NCSC-3032        | 2             | 1               | 201904 | 2              | 0             | 2761.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-3032        | 2             | 2               | 201904 | 2              | 0             | 484.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1709.65     |
    | NCSC-3032        | 2             | 3               | 201904 | 2              | 0             | 2277.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-3032        | 2             | 4               | 201904 | 2              | 0             | 1401.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 840.71      |
    | NCSC-3032        | 2             | 5               | 201904 | 2              | 0             | 876.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1073.09     |
    | NCSC-3032        | 2             | 6               | 201904 | 2              | 12            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    #
    | NCSC-3032        | 2             | 1               | 201905 | 2              | 0             | 6616.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-3032        | 2             | 2               | 201905 | 2              | 0             | 3182.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1592.98     |
    | NCSC-3032        | 2             | 3               | 201905 | 2              | 0             | 3434.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-3032        | 2             | 4               | 201905 | 2              | 0             | 1125.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1501.05     |
    | NCSC-3032        | 2             | 5               | 201905 | 2              | 0             | 2309.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 917.42      |
    | NCSC-3032        | 2             | 6               | 201905 | 2              | 86            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    #
    | NCSC-3032        | 2             | 1               | 201906 | 2              | 0             | 9107.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-3032        | 2             | 2               | 201906 | 2              | 0             | 3474.00      | 0.00                 | 0.00                | 0.00                   | 4217.88                     | 4217.88          | 0            | 915.25      |
    | NCSC-3032        | 2             | 3               | 201906 | 2              | 0             | 5633.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | NCSC-3032        | 2             | 4               | 201906 | 2              | 0             | 1955.00      | 0.00                 | 0.00                | 0.00                   | 4716.39                     | 4716.39          | 0            | 2374.63     |
    | NCSC-3032        | 2             | 5               | 201906 | 2              | 0             | 3678.00      | 0.00                 | 0.00                | 0.00                   | 2847.20                     | 2847.20          | 0            | 856.69      |
    | NCSC-3032        | 2             | 6               | 201906 | 2              | 20            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    #
    | NCSC-3032        | 2             | 1               | 201907 | 2              | 0             | 7071.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 2               | 201907 | 2              | 0             | 1616.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 3               | 201907 | 2              | 0             | 5455.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 4               | 201907 | 2              | 0             | 2182.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 5               | 201907 | 2              | 0             | 3273.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 6               | 201907 | 2              | 38            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NCSC-3032        | 2             | 1               | 201908 | 2              | 0             | 6528.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 2               | 201908 | 2              | 0             | 771.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 3               | 201908 | 2              | 0             | 5757.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 4               | 201908 | 2              | 0             | 3235.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 5               | 201908 | 2              | 0             | 2522.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 6               | 201908 | 2              | 99            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NCSC-3032        | 2             | 1               | 201909 | 2              | 0             | 2723.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 2               | 201909 | 2              | 0             | 588.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 3               | 201909 | 2              | 0             | 2135.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 4               | 201909 | 2              | 0             | 1061.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 5               | 201909 | 2              | 0             | 1074.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 6               | 201909 | 2              | 98            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NCSC-3032        | 2             | 1               | 201910 | 2              | 0             | 3033.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 2               | 201910 | 2              | 0             | 153.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 3               | 201910 | 2              | 0             | 2880.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 4               | 201910 | 2              | 0             | 1164.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 5               | 201910 | 2              | 0             | 1716.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 6               | 201910 | 2              | 76            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NCSC-3032        | 2             | 1               | 201911 | 2              | 0             | 5050.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 2               | 201911 | 2              | 0             | 1458.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 3               | 201911 | 2              | 0             | 3592.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 4               | 201911 | 2              | 0             | 1836.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 5               | 201911 | 2              | 0             | 1756.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 6               | 201911 | 2              | 52            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NCSC-3032        | 2             | 1               | 201912 | 2              | 0             | 5420.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 2               | 201912 | 2              | 0             | 1245.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 3               | 201912 | 2              | 0             | 4175.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 4               | 201912 | 2              | 0             | 2538.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 5               | 201912 | 2              | 0             | 1637.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 6               | 201912 | 2              | 99            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NCSC-3032        | 2             | 1               | 202001 | 2              | 0             | 7026.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 2               | 202001 | 2              | 0             | 2866.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 3               | 202001 | 2              | 0             | 4160.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 4               | 202001 | 2              | 0             | 2167.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 5               | 202001 | 2              | 0             | 1993.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 6               | 202001 | 2              | 48            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NCSC-3032        | 2             | 1               | 202002 | 2              | 0             | 2210.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 2               | 202002 | 2              | 0             | 722.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 3               | 202002 | 2              | 0             | 1488.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 4               | 202002 | 2              | 0             | 562.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 5               | 202002 | 2              | 0             | 926.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 6               | 202002 | 2              | 70            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | NCSC-3032        | 2             | 1               | 202003 | 2              | 0             | 4575.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 2               | 202003 | 2              | 0             | 2470.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 3               | 202003 | 2              | 0             | 2105.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 4               | 202003 | 2              | 0             | 1678.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 5               | 202003 | 2              | 0             | 427.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSC-3032        | 2             | 6               | 202003 | 2              | 95            | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |





    # Payment Batch for NCS-C1920

    # Change the date
    Given the override date is '11/07/2019 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'NCS-C1920' AccountingPaymentPeriod '201903' CensusEndDate '11/07/2019' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaaS. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | NCSC-3032                | 201906 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | NCS-C1920                  | 201906               |                      | A              | NotStarted |

#   # Coda.AccountCode
#   And   the following configuration exists in the Account Codes table
#   | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#   | 10017303 | NCS-C1920                  | CODA303   | ?            | 01/08/1990           | 31/08/2020         |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | NCS-C1920                  | 201906               | Completed |

#   # File created in Maytech FTP folder for 'NCS In the Community 19-20'
#   And   Payment file 'NCSC20180311A.pay' is created in the FTP Folder
#
#   # Decrypt the payment file to the Output window and save a decrypted version to Datafiles/Downloads
#   Given there is an encrypted file called 'NCSC20180311A.pay' in the Maytech FTP folder decrypt it then save it to 'DataFiles/Downloads'




    # Check the feed

    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'NCS-C1920' AccountingPaymentPeriod '201903' and CensusEndDate '11/07/2019'

    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017303  | 10017303       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | NCSC-3032  | 2       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2305310    | RECONCILIATION | NCS Adult Core                | 11781.47        |


    # Tidy up
	And   the override date is reset

	 	 