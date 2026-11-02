Feature: CreateContractESF 26524

@AcceptanceTest @Withdrawn20211216
Scenario: A111 Create and approve an ESF contract with a contract number less than 5500. Amend contract and check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017111' 
    And   there are no terminated or closed allocations for UKPRN '10017111' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017111' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ESF-5486      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | ESF1420        |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017111' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017111 Co Ltd' with UKPRN '10017111' and OrgId 'ORG0017111' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017111' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017111 | 117111 | 10017111 Co Ltd | 0              | Active                | Yes           | AA017111      | ?             | 48 West Street         | ?                      | ?                      | ?                      | Watford                | Hertfordshire          | WD1 2DJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017111 |




    # Change the date
    Given the override date is '01/03/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017111 | 10017111 Co Ltd      | ESFA-5486            | ESIF-5486      | 1                     | 01/04/2019        | 31/12/2019      | 173220.00     | ESF Contract                       | Contract for Services                      | 1420   | New          | ORG0017111 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                             | AgreementNumber | ActivityDescription                | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017111 | ESIF-5486      | ESF-5486      | ESF 201420        | ESF1420                 | ESF                     | 01/04/2019          | 31/12/2019        | 173220.00       |                                         |            | ESF Allocation                                              | New          | Northamptonshire LEP                        | E37026       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017111    | 1.4 Active Inclusion                           | 111\SD\7111     | Health and Safety at Work          | IET                   | Less Developed | 1.02                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017111 | ESIF-5486      | ESF-5486      | 6               | 0                     | 14941.00  | 433.00   | 378.00   | 1525.00  | 1786.00  | 1984.00  | 1391.00  | 3170.00  | 551.00   | 3723.00  | CG01 Community Grant Payment                                    | New          |             |
    | 10017111 | ESIF-5486      | ESF-5486      | 13              | 0                     | 11088.00  | 648.00   | 2160.00  | 1836.00  | 396.00   | 540.00   | 2592.00  | 576.00   | 900.00   | 1440.00  | SD08 Specification Defined Deliverable (with Description)       | New          |             |
    | 10017111 | ESIF-5486      | ESF-5486      | 29              | 0                     | 40296.00  | 6256.00  | 5980.00  | 6808.00  | 4416.00  | 3312.00  | 4416.00  | 920.00   | 5244.00  | 2944.00  | SU11 Sustained Employment 6 Months                              | New          |             |
    | 10017111 | ESIF-5486      | ESF-5486      | 34              | 0                     | 18447.00  | 2706.00  | 2871.00  | 2376.00  | 825.00   | 2508.00  | 1254.00  | 363.00   | 3102.00  | 2442.00  | SU12 Sustained Unpaid Employment 6 Months                       | New          |             |
    | 10017111 | ESIF-5486      | ESF-5486      | 37              | 0                     | 88448.00  | 8960.00  | 12160.00 | 8064.00  | 11904.00 | 8704.00  | 9728.00  | 3840.00  | 12800.00 | 12288.00 | SU14 Sustained Apprenticeship 6 Months                          | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | 
    | 10017111 | ESIF-5486      | ESF-5486      | 13              | 36       | 308     | 18       | 60       | 51       | 11       | 15       | 72       | 16       | 25       | 40       |
    | 10017111 | ESIF-5486      | ESF-5486      | 29              | 92       | 438     | 68       | 65       | 74       | 48       | 36       | 48       | 10       | 57       | 32       |
    | 10017111 | ESIF-5486      | ESF-5486      | 34              | 33       | 559     | 82       | 87       | 72       | 25       | 76       | 38       | 11       | 94       | 74       |
    | 10017111 | ESIF-5486      | ESF-5486      | 37              | 128      | 691     | 70       | 95       | 63       | 93       | 68       | 76       | 30       | 100      | 96       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check that the Contract Deliverables have been created correctly in CRM, including the UnitCost and the PlannedVolume
    Then  the following Contract Deliverables exist in CRM
    | UKPRN    | ContractNumber  | ContractAllocationRef | DeliverableCode | DisplayOrder | ParentDeliverableCode | ContractDeliverableName                                    | ContractDeliverableDescription       | PlannedValue | PlannedVolume | UnitCost |
    | 10017111 | ESIF-5486       | ESF-5486              | 6               | 6            | ?                     | CG01 Community Grant Payment                               | ?                                    | 14941.00     | 0             | 0        |
    | 10017111 | ESIF-5486       | ESF-5486              | 13              | 13           | ?                     | SD06 Specification Designed Deliverable (with Description) | ?                                    | 11088.00     | 308           | 36       |
    | 10017111 | ESIF-5486       | ESF-5486              | 29              | 29           | ?                     | SU11 Sustained Employment 6 Months                         | ?                                    | 40296.00     | 438           | 92       |
    | 10017111 | ESIF-5486       | ESF-5486              | 34              | 34           | ?                     | SU21 Sustained Employment 12 Months                        | ?                                    | 18447.00     | 559           | 33       |
    | 10017111 | ESIF-5486       | ESF-5486              | 37              | 37           | ?                     | SU24 Sustained Apprenticeship 12 Months                    | ?                                    | 88448.00     | 691           | 128      |
    
	
	
	
	# Change the date
    Given the override date is '24/04/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'ESIF-5486' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-5486' and actual ContractNumber 'ESIF-5486'

    # Check that the contract is now approved
    Then  the latest version of contract 'ESIF-5486' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017111 | ESIF-5486          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2019        | 31/12/2019      | ?             |
    | 10017111 | ESFA-5486          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2019        | 31/12/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '45' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '45' deliverable period rows in CRM linked to the latest version of contract 'ESIF-5486'




    # Change the date
    Given the override date is '28/08/2019'

    # Bulk file to amend the contract. Some deliverables included in the file - and changed from above - but two excluded from the file (SU21 and SU24)
    And   there are no files prefixed '10017111' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 14082019095251 v3_A111' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 14082019095251 v3_A111' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'ESF ESF 1420 14082019095251 v3_A111' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 14082019095251 v3_A111.xlsx' exists in the Datafiles folder and UKPRN '10017111' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the contents of the Appendices  
	# Note: Heading CG01 Community Grant appears after its data but this is not visible in the actual document so t/a ok.
    And   the file named '10017111_' & 'ESIF-5486' & '_v2.pdf' created in Sharepoint location 'ESF-1420-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 - SUMMARY OF FUNDING
    Organisation Name: 10017111 Co Ltd
    UKPRN: 10017111
    Maximum
    Contract Ref Start Date End Date
    Contract Values
    ESF Allocation ESF-5486 01/04/2019 31/12/2019 £198,564
    Total Funding for this contract £198,564
    Education and Skills Funding Agency Appendix 1 Master Contract ref: ESFA-5486

    Funding Agreement ESF Allocation
    (Appendix 2)
    Northamptonshire LEP
    Provider: 10017111 Co Ltd UKPRN: 10017111
    Master Contract Ref: ESFA-5486 Start Date: 01/04/2019 End Date: 31/12/2019
    Contract Ref: ESF-5486 Tender Specification Ref: TSS_20125 Lot Ref: 00-1
    Specification Title: IET Agreement: 111\SD\7111
    LEP: Northamptonshire LEP
    Unit Cost Total Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019
    CG01 Community Grant Payment N/A £28,212 £3,595 £282 £2,268 £2,151 £4,614 £5,176 £5,601 £4,327 £198
    SD06 NVQ4 Applied Maths £71 £52,682 £5,183 £3,479 £8,591 £1,065 £10,650 £7,455 £3,692 £4,189 £8,378
    742 73 49 121 15 150 105 52 59 118
    SU11 Sustained Employment 6 £25 £10,775 £1,950 £3,725 £400 £125 £950 £1,175 £2,250 £50 £150
    Months
    431 78 149 16 5 38 47 90 2 6
    SU21 Sustained Employment 12 £33 £18,447 £2,706 £2,871 £2,376 £825 £2,508 £1,254 £363 £3,102 £2,442
    Months
    559 82 87 72 25 76 38 11 94 74
    SU24 Sustained Apprenticeship 12 £128 £88,448 £8,960 £12,160 £8,064 £11,904 £8,704 £9,728 £3,840 £12,800 £12,288
    Months
    691 70 95 63 93 68 76 30 100 96
    Total Funding £198,564 £22,394 £22,517 £21,699 £16,070 £27,426 £24,788 £15,746 £24,468 £23,456
    Ref (for internal use only):  ESIF-5486 v2
    Page 1 of 1 of this Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   #And   Sharepoint file '10017111_[ContractNo]_v2.pdf' in 'ESF-1420-Input-Appendices' is copied to 'Datafiles/Downloads' as '<filename2>.pdf'
    And   Sharepoint file '10017111_ESIF-5486_v2.pdf' in 'ESF-1420-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017111_ESIF-5486_v2.pdf'

    # Check that the Contract Deliverables have been created correctly in CRM, including the UnitCost and the PlannedVolume
    Then  the following Contract Deliverables exist in CRM
    | UKPRN    | ContractNumber  | ContractAllocationRef | DeliverableCode | DisplayOrder | ParentDeliverableCode | ContractDeliverableName                                    | ContractDeliverableDescription       | PlannedValue | PlannedVolume | UnitCost |
    | 10017111 | ESIF-5486       | ESF-5486              | 6               | 6            | ?                     | CG01 Community Grant Payment                               | ?                                    | 28212.00     | 0             | 0        |
    | 10017111 | ESIF-5486       | ESF-5486              | 13              | 13           | ?                     | SD06 Specification Designed Deliverable (with Description) | ?                                    | 52682.00     | 742           | 71       |
    | 10017111 | ESIF-5486       | ESF-5486              | 29              | 29           | ?                     | SU11 Sustained Employment 6 Months                         | ?                                    | 10775.00     | 431           | 25       |
    | 10017111 | ESIF-5486       | ESF-5486              | 34              | 34           | ?                     | SU21 Sustained Employment 12 Months                        | ?                                    | 18447.00     | 559           | 33       |
    | 10017111 | ESIF-5486       | ESF-5486              | 37              | 37           | ?                     | SU24 Sustained Apprenticeship 12 Months                    | ?                                    | 88448.00     | 691           | 128      |
    

    # Tidy Up
	And   the override date is reset
	   
@AcceptanceTest @Withdrawn20211216
Scenario: A126 Create and approve an ESF contract with a contract number greater than 5500. Amend contract and check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017126' 
    And   there are no terminated or closed allocations for UKPRN '10017126' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017126' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ESF-5508      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | ESF1420        |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017126' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017126 Co Ltd' with UKPRN '10017126' and OrgId 'ORG0017126' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017126' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017126 | 117126 | 10017126 Co Ltd | 0              | Active                | Yes           | AA017126      | ?             | 55 High Street         | ?                      | ?                      | ?                      | Watford                | Hertfordshire          | WD1 2DJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017126 |




    # Change the date
    Given the override date is '01/03/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017126 | 10017126 Co Ltd      | ESFA-5508            | ESIF-5508      | 1                     | 01/04/2019        | 31/12/2019      | 173220.00     | ESF Contract                       | Contract for Services                      | 1420   | New          | ORG0017126 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | LEPName                                     | LEPCode      | LotReference | TenderSpecificationReference  | TenderAwardReference          | InvestmentPriority                             | AgreementNumber | ActivityDescription                | SpecificationTitle    | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017126 | ESIF-5508      | ESF-5508      | ESF 201420        | ESF1420                 | ESF                     | 01/04/2019          | 31/12/2019        | 173220.00       |                                         |            | ESF Allocation                                              | New          | Northamptonshire LEP                        | E37026       | 00-1         | TSS_20125                     | 20125/23-415-00-1/10017126    | 1.4 Active Inclusion                           | 111\SD\7126     | Health and Safety at Work          | IET                   | Less Developed | 1.02                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017126 | ESIF-5508      | ESF-5508      | 6               | 0                     | 14941.00  | 433.00   | 378.00   | 1525.00  | 1786.00  | 1984.00  | 1391.00  | 3170.00  | 551.00   | 3723.00  | CG01 Community Grant Payment                                    | New          |             |
    | 10017126 | ESIF-5508      | ESF-5508      | 13              | 0                     | 11088.00  | 648.00   | 2160.00  | 1836.00  | 396.00   | 540.00   | 2592.00  | 576.00   | 900.00   | 1440.00  | SD08 Specification Defined Deliverable (with Description)       | New          |             |
    | 10017126 | ESIF-5508      | ESF-5508      | 29              | 0                     | 40296.00  | 6256.00  | 5980.00  | 6808.00  | 4416.00  | 3312.00  | 4416.00  | 920.00   | 5244.00  | 2944.00  | SU11 Sustained Employment 6 Months                              | New          |             |
    | 10017126 | ESIF-5508      | ESF-5508      | 34              | 0                     | 18447.00  | 2706.00  | 2871.00  | 2376.00  | 825.00   | 2508.00  | 1254.00  | 363.00   | 3102.00  | 2442.00  | SU12 Sustained Unpaid Employment 6 Months                       | New          |             |
    | 10017126 | ESIF-5508      | ESF-5508      | 37              | 0                     | 88448.00  | 8960.00  | 12160.00 | 8064.00  | 11904.00 | 8704.00  | 9728.00  | 3840.00  | 12800.00 | 12288.00 | SU14 Sustained Apprenticeship 6 Months                          | New          |             |

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Apr-19   | May-19   | Jun-19   | Jul-19   | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | 
    | 10017126 | ESIF-5508      | ESF-5508      | 13              | 36       | 308     | 18       | 60       | 51       | 11       | 15       | 72       | 16       | 25       | 40       |
    | 10017126 | ESIF-5508      | ESF-5508      | 29              | 92       | 438     | 68       | 65       | 74       | 48       | 36       | 48       | 10       | 57       | 32       |
    | 10017126 | ESIF-5508      | ESF-5508      | 34              | 33       | 559     | 82       | 87       | 72       | 25       | 76       | 38       | 11       | 94       | 74       |
    | 10017126 | ESIF-5508      | ESF-5508      | 37              | 128      | 691     | 70       | 95       | 63       | 93       | 68       | 76       | 30       | 100      | 96       |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check that the Contract Deliverables have been created correctly in CRM, including the UnitCost and the PlannedVolume
    Then  the following Contract Deliverables exist in CRM
    | UKPRN    | ContractNumber | ContractAllocationRef | DeliverableCode | DisplayOrder | ParentDeliverableCode | ContractDeliverableName                                    | ContractDeliverableDescription | PlannedValue | PlannedVolume | UnitCost |
    | 10017126 | ESIF-5508      | ESF-5508              | 6               | 6            | ?                     | CG01 Community Grant Payment                               | ?                              | 14941.00     | 0             | 0        |
    | 10017126 | ESIF-5508      | ESF-5508              | 13              | 13           | ?                     | SD06 Specification Designed Deliverable (with Description) | ?                              | 11088.00     | 308           | 36       |
    | 10017126 | ESIF-5508      | ESF-5508              | 29              | 29           | ?                     | SU11 Sustained Employment 6 Months                         | ?                              | 40296.00     | 438           | 92       |
    | 10017126 | ESIF-5508      | ESF-5508              | 34              | 34           | ?                     | SU21 Sustained Employment 12 Months                        | ?                              | 18447.00     | 559           | 33       |
    | 10017126 | ESIF-5508      | ESF-5508              | 37              | 37           | ?                     | SU24 Sustained Apprenticeship 12 Months                    | ?                              | 88448.00     | 691           | 128      |




    # Change the date
    Given the override date is '24/04/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'ESIF-5508' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-5508' and actual ContractNumber 'ESIF-5508'

    # Check that the contract is now approved
    Then  the latest version of contract 'ESIF-5508' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017126 | ESIF-5508          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2019        | 31/12/2019      | ?             |
    | 10017126 | ESFA-5508          | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2019        | 31/12/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '45' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '45' deliverable period rows in CRM linked to the latest version of contract 'ESIF-5508'




    # Change the date
    Given the override date is '28/08/2019'

    # Bulk file to amend the contract
    And   there are no files prefixed '10017126' in the Sharepoint 'ESF-1420-Input-Appendices' folder
    And   there are no files prefixed 'ESF ESF 1420 14082019095254 v3_A126' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 14082019095254 v3_A126' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'ESF ESF 1420 14082019095254 v3_A126' in the Sharepoint 'Reports' folder
    And   spreadsheet 'ESF ESF 1420 14082019095254 v3_A126.xlsx' exists in the Datafiles folder and UKPRN '10017126' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the contents of the Appendices
    And   the file named '10017126_' & 'ESIF-5508' & '_v2.pdf' created in Sharepoint location 'ESF-1420-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 - SUMMARY OF FUNDING
    Organisation Name: 10017126 Co Ltd
    UKPRN: 10017126
    Maximum
    Contract Ref Start Date End Date
    Contract Values
    ESF Allocation ESF-5508 01/04/2019 31/12/2019 £198,564
    Total Funding for this contract £198,564
    Education and Skills Funding Agency Appendix 1 Master Contract ref: ESFA-5508

    Funding Agreement ESF Allocation
    (Appendix 2)
    Northamptonshire LEP
    Provider: 10017126 Co Ltd UKPRN: 10017126
    Master Contract Ref: ESFA-5508 Start Date: 01/04/2019 End Date: 31/12/2019
    Contract Ref: ESF-5508 Tender Specification Ref: TSS_20125 Lot Ref: 00-1
    Specification Title: IET Agreement: 111\SD\7126
    LEP: Northamptonshire LEP
    Unit Cost Total Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019
    CG01 Community Grant Payment N/A £28,212 £3,595 £282 £2,268 £2,151 £4,614 £5,176 £5,601 £4,327 £198
    SD06 NVQ4 Applied Maths £71 £52,682 £5,183 £3,479 £8,591 £1,065 £10,650 £7,455 £3,692 £4,189 £8,378
    742 73 49 121 15 150 105 52 59 118
    SU11 Sustained Employment 6 £25 £10,775 £1,950 £3,725 £400 £125 £950 £1,175 £2,250 £50 £150
    Months
    431 78 149 16 5 38 47 90 2 6
    SU21 Sustained Employment 12 £33 £18,447 £2,706 £2,871 £2,376 £825 £2,508 £1,254 £363 £3,102 £2,442
    Months
    559 82 87 72 25 76 38 11 94 74
    SU24 Sustained Apprenticeship 12 £128 £88,448 £8,960 £12,160 £8,064 £11,904 £8,704 £9,728 £3,840 £12,800 £12,288
    Months
    691 70 95 63 93 68 76 30 100 96
    Total Funding £198,564 £22,394 £22,517 £21,699 £16,070 £27,426 £24,788 £15,746 £24,468 £23,456
    Ref (for internal use only):  ESIF-5508 v2
    Page 1 of 1 of this Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   #And   Sharepoint file '10017126_[ContractNo]_v2.pdf' in 'ESF-1420-Input-Appendices' is copied to 'Datafiles/Downloads' as '<filename2>.pdf'
    And   Sharepoint file '10017126_ESIF-5508_v2.pdf' in 'ESF-1420-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017126_ESIF-5508_v2.pdf'

    # Check that the Contract Deliverables have been created correctly in CRM, including the UnitCost and the PlannedVolume
    Then  the following Contract Deliverables exist in CRM
    | UKPRN    | ContractNumber  | ContractAllocationRef | DeliverableCode | DisplayOrder | ParentDeliverableCode | ContractDeliverableName                                    | ContractDeliverableDescription       | PlannedValue | PlannedVolume | UnitCost |
    | 10017126 | ESIF-5508       | ESF-5508              | 6               | 6            | ?                     | CG01 Community Grant Payment                               | ?                                    | 28212.00     | 0             | 0        |
    | 10017126 | ESIF-5508       | ESF-5508              | 13              | 13           | ?                     | SD06 Specification Designed Deliverable (with Description) | ?                                    | 52682.00     | 742           | 71       |
    | 10017126 | ESIF-5508       | ESF-5508              | 29              | 29           | ?                     | SU11 Sustained Employment 6 Months                         | ?                                    | 10775.00     | 431           | 25       |
    | 10017126 | ESIF-5508       | ESF-5508              | 34              | 34           | ?                     | SU21 Sustained Employment 12 Months                        | ?                                    | 18447.00     | 559           | 33       |
    | 10017126 | ESIF-5508       | ESF-5508              | 37              | 37           | ?                     | SU24 Sustained Apprenticeship 12 Months                    | ?                                    | 88448.00     | 691           | 128      |


    # Tidy Up
	And   the override date is reset
	   
	      