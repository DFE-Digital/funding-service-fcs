Feature: CheckESFTotalPlannedVolume 17506

@AcceptanceTest @Withdrawn20240103
Scenario: A486 Bulk upload a new ESF contract to CRM then check that the planned volume information is showing correctly in CRM and docs
    Given there are no allocations marked as Under Termination for UKPRN '10017486' 
    And   there are no terminated or closed allocations for UKPRN '10017486' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017486' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
	And   there are no master contracts in CRM for master contract number 'ESFA-7486'
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017486' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ESF-7486      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | ESF1420        |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017486' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017486 Co Ltd' with UKPRN '10017486' and OrgId 'ORG0017486' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017486' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017486 | 117486 | 10017486 Co Ltd | 0              | In Administration     | Yes           | AA017486      | ?             | 39 Brimfield Road      | Watts Wood             | ?                      | ?                      | Purfleet               | Essex                  | RM19 1RQ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017486 |




    # Change the date
    Given the override date is '01/06/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017486 | 10017486 Co Ltd      | ESFA-7486            | ESIF-7486      | 1                     | 01/07/2019        | 30/12/2019      | 13459.00      | ESF Contract                       | Contract for Services                      | 1420   | New          | ORG0017486 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName    | UoPCode    | AllocationDescription    | CRMIntent    | LEPName       | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                             | AgreementNumber | ActivityDescription                | SpecificationTitle          | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017486 | ESIF-7486      | ESF-7486      | ESF 201420        | ESF1420                 | ESF                     | 01/07/2019          | 30/12/2019        | 13459.00        |            |            | ESF Allocation           | New          | Humber LEP    | E37018       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017486    | 1.2 Sustainable integration of young people    | 111\SD\7486     | Ethinic support in the community   | SSW Apprenticeship Services | More Developed | 1.09                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017486 | ESIF-7486      | ESF-7486      | 3               | 0                     | 13459.00  | 652.00   | 2559.00  | 1522.00  | 2668.00  | 2930.00  | 3128.00  | NR01 Non Regulated Activity                                     | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'




    # Update draft to add deliverables 1 and 4 (which have volume details)

    # Change the date
    Given the override date is '23/07/2019'

    # Bulk file
    And   there are no files prefixed '10017486' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 24102019114254 v3_A486' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 24102019114254 v3_A486' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'ESF ESF 1420 24102019114254 v3_A486' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 24102019114254 v3_A486.xlsx' exists in the Datafiles folder and UKPRN '10017486' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the contents of the Appendices
    And   the file named '10017486_' & 'ESIF-7486' & '_v1.pdf' created in Sharepoint location 'ESF-1420-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 - SUMMARY OF FUNDING
    Organisation Name: 10017486 Co Ltd
    UKPRN: 10017486
    Maximum
    Contract Ref Start Date End Date
    Contract Values
    ESF Allocation ESF-7486 01/07/2019 30/12/2019 £85,647
    Total Funding for this contract £85,647
    Education and Skills Funding Agency Appendix 1 Master Contract ref: ESFA-7486

    Funding Agreement ESF Allocation
    (Appendix 2)
    Humber LEP
    Provider: 10017486 Co Ltd UKPRN: 10017486
    Master Contract Ref: ESFA-7486 Start Date: 01/07/2019 End Date: 30/12/2019
    Contract Ref: ESF-7486 Tender Specification Ref: TSS_20125 Lot Ref: 00-1
    Specification Title: SSW Apprenticeship Services Agreement: 111\SD\7486
    LEP: Humber LEP
    Unit Cost Total Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019
    ST01 Learner Assessment and Plan £50 £23,700 £1,250 £3,900 £3,450 £6,750 £2,400 £5,950
    474 25 78 69 135 48 119
    NR01 Non Regulated Activity N/A £13,459 £652 £2,559 £1,522 £2,668 £2,930 £3,128
    FS01 Additional Programme Cost £116 £48,488 £3,712 £1,972 £11,832 £12,412 £5,916 £12,644
    418 32 17 102 107 51 109
    Total Funding £85,647 £5,614 £8,431 £16,804 £21,830 £11,246 £21,722
    Ref (for internal use only):  ESIF-7486 v1
    Page 1 of 1 of this Funding Agreement
    """



    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017486 | ESIF-7486          | 1                     | 1                        | Draft            | Awaiting Documentation    | True          | False               | 01/07/2019        | 30/12/2019      | ?             |
    | 10017486 | ESIF-7486          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/07/2019        | 30/12/2019      | ?             |
    | 10017486 | ESFA-7486          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/07/2019        | 30/12/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '18' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '18' deliverable period rows in CRM linked to the latest version of contract 'ESIF-7486'




    # Retrieve parameters
    And   I retrieve the latest contract details from CRM for provider '10017486' for FundingType 'ESF' and period '1420'

    # Check the PLANNED VOLUMES on the draft contract in CRM
    And   the planned volume data recorded in CRM against the latest version of the contract is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   |
    | ESIF-7486      | ESF-7486        | 1               | 474       | 25       | 78       | 69       | 135      | 48       | 119      | 
    | ESIF-7486      | ESF-7486        | 3               | 0         | 0        | 0        | 0        | 0        | 0        | 0        | 
    | ESIF-7486      | ESF-7486        | 4               | 418       | 32       | 17       | 102      | 107      | 51       | 109      | 



    # Tidy up
    And   the override date is reset

