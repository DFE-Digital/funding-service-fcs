Feature: Amend1920ALLFcontracts 25958

@AcceptanceTest @Withdrawn20230123
Scenario: A898 Create a new 1920 EDSK contract for ALLF without Delivery Orgs. Publish and approve. Execute a non-financial notification amendment then check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017898' 
    And   there are no terminated or closed allocations for UKPRN '10017898' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017898' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-898      |

    # Clear down the blob document archive and the associated ArchiveDocument control table (DocumentsDomain.ArchivedDocument)
    And   there is no data in the document archive or the associated control table



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017898' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017898 Co Ltd' with UKPRN '10017898' and OrgId 'ORG0017898' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017898 | 117898 | 10017898 Co Ltd | 0              | In Administration     | Yes           | AA017898      | ?             | 2 Buckingham Court     | Rectory Lane           | ?                      | ?                      | Loughton               | Essex                  | IG10 2QZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017898 |



    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                | Period | CRMIntent    | OrgId      |
    | 10017898 | 10017898 Co Ltd      | ESFA-898             | EDSK-898       | 1                     | 01/08/2019        | 31/07/2020      | 27368.00      |                                    | Contract for Services (ITP) | 1920   | New          | ORG0017898 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription              | CRMIntent    | DeliveryOrg |
    | 10017898 | EDSK-898       | ALLF-898      | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 31/07/2020        | 27368.00        |                                         |            |                                    | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription              | CRMIntent    | DeliveryOrg |
    | 10017898 | EDSK-898       | ALLF-898      | 5               | 0                     | 27368.00  | 71.00    | 3115.00  | 402.00   | 1138.00  | 3614.00  | 3589.00  | 2680.00  | 1707.00  | 3644.00  | 1534.00  | 2428.00  | 3446.00  | Advanced Learner Loans Facility     | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'




    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-898' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-898' and actual ContractNumber 'EDSK-898'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-898' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017898 | EDSK-898           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017898 | ESFA-898           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |




    # Execute a NON-FINANCIAL amendment and check docs. (25958)

	
    # Change the date
    Given the override date is '22/07/2019'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-898' for a non-financial NOTIFICATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-898' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017898 | EDSK-898           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | Notification  |
    | 10017898 | EDSK-898           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017898 | ESFA-898           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |



    # Retrieve parameters for the Contracting Org
   #Then  I retrieve the latest EFA contract details from CRM for provider '10017898' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017898'
    Then  I retrieve the latest contract details from CRM for provider '10017898' for FundingType 'EDSK' and period '1920'

    # Check the Summary of Funding document. This should be the same as the earlier version. 
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017898 Co Ltd UKPRN: 10017898
    Master Contract Number: ESFA-898
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility ALLF-898 £16,316 £11,052 £27,368
    Total Funding for this contract: £27,368
    Summary of Funding – Page 1
    """


    # There should not be a Main Terms and Conditions document
    And   the pdf file does not contain the following text
    """
    Agreement Type Contract for Services
    """

    # There should be no Funding Agreement documents
    And   the pdf file does not contain the following text
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    """

    # There should not be a Schedule 3 document
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
Scenario: A899 Create a new 1920 EDSK contract for ALLF with three Delivery Orgs none of which matches the Contracting Org. Publish and approve. Execute a non-financial notification amendment then check docs.
    Given there are no allocations marked as Under Termination for UKPRN '10017899' 
    And   there are no terminated or closed allocations for UKPRN '10017899' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017899' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

	# Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-8991     |
	| ALLF-8992     |
	| ALLF-8993     |

    # Clear down the blob document archive and the associated ArchiveDocument control table (DocumentsDomain.ArchivedDocument)
    And   there is no data in the document archive or the associated control table

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017899'
    And there is no Organisation data for UKPRN '10029426'
    And there is no Organisation data for UKPRN '10020019'
    And there is no Organisation data for UKPRN '10028542'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017899 Co Ltd' with UKPRN '10017899' and OrgId 'ORG0017899' and has 'FCS1 Test' as a manager 

    # Put the same Provider data in the CRM Organisation table J057
    And   the following Organisations exist in CRM
    | UKPRN    | UPIN   | Organisation ID | Name                            | Status                | CompanyNumber | CharityNumber | AddressLine1        | AddressLine2  | AddressLine3 | AddressLine4 | Town     | County    | Postcode |
    | 10017899 | 117899 | ORG0017899      | 10017899 Co Ltd                 | Provider Under Change | AA017899      | 17899         | 11 Kingsmead Square | Bath          | Avon         | ?            | ?        | ?         | BA1 2AB  |
    | 10029426 | 121585 | ORG0029426      | ABM TRAINING (UK) LTD           | In Administration     | ?             | ?             | 25 High Street      | Cobham        | Surrey       | ?            | ?        | ?         | KT11 3DH |
    | 10020019 | 121690 | ORG0020019      | EGLANTINE CATERING LIMITED      | Active                | AA121690      | 121690        | 2 Ambassador House  | Wolseley Road | ?            | ?            | Harrow   | Middlesex | HA3 5RT  |
    | 10028542 | 117899 | ORG0028542      | JHC SKILLS FOR BUSINESS LIMITED | Active                | AA140687      | ?             | 76 Moorfield Road   | Denham Green  | ?            | ?            | Uxbridge | Middlesex | UB9 5NF  |

    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                          | Period | CRMIntent    | OrgId      |
    | 10017899 | 10017899 Co Ltd      | ESFA-899             | EDSK-899       | 1                     | 01/08/2019        | 31/07/2020      | 69073.00      |                                    | Conditions of Funding (Grant) (Trust) | 1920   | New          | ORG0017899 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription             | CRMIntent    | DeliveryOrg |
    | 10017899 | EDSK-899       | ALLF-8991     | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 31/07/2020        | 25127.00        |                                         |            |                                   | New          | 10029426    |
    | 10017899 | EDSK-899       | ALLF-8992     | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 31/07/2020        | 23506.00        |                                         |            |                                   | New          | 10020019    |
    | 10017899 | EDSK-899       | ALLF-8993     | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 31/07/2020        | 20440.00        |                                         |            |                                   | New          | 10028542    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription              | CRMIntent    | DeliveryOrg |
    | 10017899 | EDSK-899       | ALLF-8991     | 5               | 0                     | 25127.00  | 2968.00  | 2311.00  | 3300.00  | 335.00   | 2810.00  | 2786.00  | 1877.00  | 903.00   | 2840.00  | 730.00   | 1624.00  | 2643.00  | Advanced Learner Loans Facility     | New          | 10029426    |
    | 10017899 | EDSK-899       | ALLF-8992     | 5               | 0                     | 23506.00  | 3031.00  | 698.00   | 293.00   | 3243.00  | 1796.00  | 2438.00  | 2477.00  | 2359.00  | 2714.00  | 1647.00  | 1148.00  | 1662.00  | Advanced Learner Loans Facility     | New          | 10020019    |
    | 10017899 | EDSK-899       | ALLF-8993     | 5               | 0                     | 20440.00  | 638.00   | 1878.00  | 875.00   | 1166.00  | 3009.00  | 1181.00  | 1982.00  | 1547.00  | 2851.00  | 2639.00  | 559.00   | 2115.00  | Advanced Learner Loans Facility     | New          | 10028542    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-899' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-899' and actual ContractNumber 'EDSK-899'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-899' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017899 | EDSK-899           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017899 | ESFA-899           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

 


    # Execute a NON-FINANCIAL amendment and check docs. (25958)

	
    # Change the date
    Given the override date is '26/07/2019'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-899' for a non-financial NOTIFICATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-899' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017899 | EDSK-899           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | Notification  |
    | 10017899 | EDSK-899           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017899 | ESFA-899           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |



    # Retrieve parameters for the Contracting Org
   #Then  I retrieve the latest EFA contract details from CRM for provider '10017899' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017899'
    Then  I retrieve the latest contract details from CRM for provider '10017899' for FundingType 'EDSK' and period '1920'

    # Check the Summary of Funding document. This should be the same as the earlier version. 
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017899 Co Ltd UKPRN: 10017899
    Master Contract Number: ESFA-899
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    ABM TRAINING (UK) LTD ALLF-8991 £17,290 £7,837 £25,127
    EGLANTINE CATERING LIMITED ALLF-8992 £16,335 £7,171 £23,506
    JHC SKILLS FOR BUSINESS LIMITED ALLF-8993 £12,276 £8,164 £20,440
    Total Funding for this contract: £69,073
    Summary of Funding – Page 1
    """



    # There should not be a Main Terms and Conditions document
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant)
    """

    # There should be no Funding Agreement documents
    And   the pdf file does not contain the following text
    """
	SCHEDULE 2 – ADVANCED LEARNER LOANS
    """

    # There should not be a Schedule 3 document
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20210702
Scenario: A251 Create and approve a new 1920 EDSK contract for ALLF with three Delivery Orgs none of which matches the Contracting Org. Bulk amend to change alloc dates within month. Check docs then approve. Bulk amend to change profile. Check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017251' 
    And   there are no terminated or closed allocations for UKPRN '10017251' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017251' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-2511     |
    | ALLF-2512     |
    | ALLF-2513     |

    # Clear down the blob document archive and the associated ArchiveDocument control table (DocumentsDomain.ArchivedDocument)
    And   there is no data in the document archive or the associated control table

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017251' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017251 Co Ltd' with UKPRN '10017251' and OrgId 'ORG0017251' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                                        | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017251 | 117251 | 10017251 Co Ltd                             | 0              | Active | Yes           | AA017251      | 17251         | 95 Church Way          | Iffley Village         | Oxford                 | ?                      | ?                      | ?                      | OX4 4EG   |   
    | 10020194 | 118245 | THE VIA PARTNERSHIP LIMITED                 | 0              | Active | Yes           | ?             | 118245        | ?                      | 4                      | Brindley Place         | ?                      | Birmingham             | ?                      | B1 2HZ    |
    | 10020198 | 119188 | CONSTRUCTION WORKS (HULL) LIMITED           | 0              | Active | Yes           | AA119188      | 119188        | 27-29 Anlaby Road      | ?                      | ?                      | ?                      | Hull                   | ?                      | HU1 2PG   |
    | 10020199 | 140188 | ALABARE CHRISTIAN CARE CENTRES              | 0              | Active | Yes           | AA140188      | 140188        | 2 Watt Road            | ?                      | ?                      | ?                      | Salisbury              | ?                      | SP2 7UD   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017251 | 
	| 10020194 |
    | 10020198 |
    | 10020199 |
	


	
	# Change the date
	Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription        | ContractType                            | Period | CRMIntent    | OrgId      |
    | 10017251 | 10017251 Co Ltd      | ESFA-251             | EDSK-251       | 1                     | 01/08/2019        | 31/07/2020      | 181868.00     |                            | Conditions of Funding (Grant) (College) | 1920   | New          | ORG0017251 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                 | CRMIntent    | DeliveryOrg |
    | 10017251 | EDSK-251       | ALLF-2511     | ALLF              | ALLF1920                | AY                      | 08/08/2019          | 15/07/2020        | 54084.00        |                                         |            |                                       | New          | 10020194    |
    | 10017251 | EDSK-251       | ALLF-2512     | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 23/07/2020        | 68991.00        |                                         |            |                                       | New          | 10020198    |
    | 10017251 | EDSK-251       | ALLF-2513     | ALLF              | ALLF1920                | AY                      | 15/08/2019          | 31/07/2020        | 58793.00        |                                         |            |                                       | New          | 10020199    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                 | CRMIntent    | DeliveryOrg |
    | 10017251 | EDSK-251       | ALLF-2511     | 5               | 0                     | 54084.00  | 6075.00  | 7583.00  | 6787.00  | 3337.00  | 5735.00  | 651.00   | 3729.00  | 6670.00  | 5800.00  | 4186.00  | 1076.00  | 2455.00  | Advanced Learner Loans Facility        | New          | 10020194    | 
    | 10017251 | EDSK-251       | ALLF-2512     | 5               | 0                     | 68991.00  | 7259.00  | 7004.00  | 7769.00  | 5476.00  | 4404.00  | 5508.00  | 2196.00  | 4181.00  | 4064.00  | 6527.00  | 7089.00  | 7514.00  | Advanced Learner Loans Facility        | New          | 10020198    | 
    | 10017251 | EDSK-251       | ALLF-2513     | 5               | 0                     | 58793.00  | 7231.00  | 3102.00  | 5427.00  | 4291.00  | 1860.00  | 7040.00  | 7401.00  | 2592.00  | 6956.00  | 7656.00  | 1828.00  | 3409.00  | Advanced Learner Loans Facility        | New          | 10020199    | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-251' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-251' and actual ContractNumber 'EDSK-251'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-251' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017251 | EDSK-251           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017251 | ESFA-251           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |




    # Bulk import to amend the contract changing the START DATE on ALLF-2511 and the END DATE on ALLF-2512. No changes to ALLF-2513 and no changes to any Profile values

    # Change the date
    Given the override date is '15/07/2019'

    # Amend the contract
    And   there are no files prefixed '10017251' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed '10017251' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 19032019111339 v3_A251_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 19032019111339 v3_A251_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 19032019111339 v3_A251_1.xlsx' exists in the Datafiles folder and UKPRN '10017251' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # The pdf produced should include a 'Summary of Funding' and two of the three 'Funding Agreements' but no 'Terms and Conditions' or 'Schedule 3' 

    # Retrieve parameters 
    And   I retrieve the latest EFA contract details from CRM for provider '10017251' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10020194'
   #And   I retrieve the latest contract details from CRM for provider '10017251' for FundingType 'EDSK' and period '1920'

    # 'Summary of Funding'    
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017251 Co Ltd UKPRN: 10017251
    Master Contract Number: ESFA-251
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    ALABARE CHRISTIAN CARE CENTRES ALLF-2513 £38,944 £19,849 £58,793
    CONSTRUCTION WORKS (HULL) LIMITED ALLF-2512 £43,797 £25,194 £68,991
    THE VIA PARTNERSHIP LIMITED ALLF-2511 £40,567 £13,517 £54,084
    Total Funding for this contract: £181,868
    Summary of Funding – Page 1
    """

    # 'Funding Agreement' for ALLF-2512 (10020198)
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: CONSTRUCTION WORKS (HULL) LIMITED UKPRN: 10020198
    Master Contract Number: ESFA-251 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: ALLF-2512
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £68,991 £7,259 £7,004 £7,769 £5,476 £4,404 £5,508 £2,196 £4,181 £4,064 £6,527 £7,089 £7,514
    Total Funding £68,991 £7,259 £7,004 £7,769 £5,476 £4,404 £5,508 £2,196 £4,181 £4,064 £6,527 £7,089 £7,514
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLF-2512 – Page 1 Ref (for internal use only):  EDSK-251 v2
    """

    # 'Funding Agreement' for ALLF-2511 (10020194)
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: THE VIA PARTNERSHIP LIMITED UKPRN: 10020194
    Master Contract Number: ESFA-251 Start Date: 12/08/2019 End Date: 15/07/2020
    Contract Ref: ALLF-2511
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £54,084 £6,075 £7,583 £6,787 £3,337 £5,735 £651 £3,729 £6,670 £5,800 £4,186 £1,076 £2,455
    Total Funding £54,084 £6,075 £7,583 £6,787 £3,337 £5,735 £651 £3,729 £6,670 £5,800 £4,186 £1,076 £2,455
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLF-2511 – Page 1 Ref (for internal use only):  EDSK-251 v2
    """

    # The 'Funding Agreement' for ALLF-2513 (10020199) should be missing
    And   the pdf file does not contain the following text
    """
    Provider: ALABARE CHRISTIAN CARE CENTRES UKPRN: 10020199
    """

    # The 'Terms and Conditions' should be missing
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    """

    # The 'Schedule 3' should be missing
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    # Check that the document parts are in the right order
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Provider: CONSTRUCTION WORKS (HULL) LIMITED UKPRN: 10020198
    Provider: THE VIA PARTNERSHIP LIMITED UKPRN: 10020194
    """

    # Save a copy of the output
   #Then  Sharepoint file '10017nnn_[ContractNo]_v1.pdf' in 'xxx-nnnn-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017nnn_[ContractNo]_v1.pdf'
    Then  Sharepoint file '10017251_EDSK-251_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017251_EDSK-251_v2.pdf'




    # Publish and approve v2

    # Change the date
    Given the override date is '18/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-251' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '21/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-251' and actual ContractNumber 'EDSK-251'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-251' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017251 | EDSK-251           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017251 | EDSK-251           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017251 | ESFA-251           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |




    # Bulk amendment to shuffle the profile values on ALLF-2512 but not change the total. Increase the profile value of ALLF-2513

    # Change the date
    Given the override date is '23/07/2019'

    # Amend the contract
    And   there are no files prefixed '10017251' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed '10017251' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 19032019111339 v3_A251_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 19032019111339 v3_A251_2' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 19032019111339 v3_A251_2.xlsx' exists in the Datafiles folder and UKPRN '10017251' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # The pdf produced should include a 'Summary of Funding' and two of the three 'Funding Agreements'
    #   but no 'Terms and Conditions' and no 'Schedule 3' 

    # Retrieve parameters 
    And   I retrieve the latest EFA contract details from CRM for provider '10017251' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10020194'
   #And   I retrieve the latest contract details from CRM for provider '10017251' for FundingType 'EDSK' and period '1920'

    # 'Summary of Funding'    
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017251 Co Ltd UKPRN: 10017251
    Master Contract Number: ESFA-251
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    ALABARE CHRISTIAN CARE CENTRES ALLF-2513 £38,944 £19,850 £58,794
    CONSTRUCTION WORKS (HULL) LIMITED ALLF-2512 £43,797 £25,194 £68,991
    THE VIA PARTNERSHIP LIMITED ALLF-2511 £40,567 £13,517 £54,084
    Total Funding for this contract: £181,869
    Summary of Funding – Page 1
    """

    # 'Funding Agreement' for ALLF-2513 (10020199). Profile increased by £1
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: ALABARE CHRISTIAN CARE CENTRES UKPRN: 10020199
    Master Contract Number: ESFA-251 Start Date: 15/08/2019 End Date: 31/07/2020
    Contract Ref: ALLF-2513
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £58,794 £7,231 £3,102 £5,427 £4,291 £1,860 £7,040 £7,401 £2,592 £6,956 £7,656 £1,828 £3,410
    Total Funding £58,794 £7,231 £3,102 £5,427 £4,291 £1,860 £7,040 £7,401 £2,592 £6,956 £7,656 £1,828 £3,410
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLF-2513 – Page 1 Ref (for internal use only):  EDSK-251 v3
    """

    # 'Funding Agreement' for ALLF-2512 (10020198). Profile values shuffled but total unchanged
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: CONSTRUCTION WORKS (HULL) LIMITED UKPRN: 10020198
    Master Contract Number: ESFA-251 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: ALLF-2512
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £68,991 £7,004 £7,259 £4,404 £7,769 £5,476 £5,508 £2,196 £4,181 £4,064 £6,527 £7,089 £7,514
    Total Funding £68,991 £7,004 £7,259 £4,404 £7,769 £5,476 £5,508 £2,196 £4,181 £4,064 £6,527 £7,089 £7,514
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLF-2512 – Page 1 Ref (for internal use only):  EDSK-251 v3
    """

    # The 'Funding Agreement' for ALLF-2513 (10020199) should be missing
    And   the pdf file does not contain the following text
    """
    Provider: THE VIA PARTNERSHIP LIMITED UKPRN: 10020194
    """

    # The 'Terms and Conditions' should be missing
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    """

    # The 'Schedule 3' should be missing
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    # Check that the document parts are in the right order
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
	Provider: ALABARE CHRISTIAN CARE CENTRES UKPRN: 10020199
    Provider: CONSTRUCTION WORKS (HULL) LIMITED UKPRN: 10020198
    """

    # Save a copy of the output
   #Then  Sharepoint file '10017nnn_[ContractNo]_v1.pdf' in 'xxx-nnnn-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017nnn_[ContractNo]_v1.pdf'
    Then  Sharepoint file '10017251_EDSK-251_v3.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017251_EDSK-251_v3.pdf'




    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017251 | EDSK-251           | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017251 | EDSK-251           | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017251 | EDSK-251           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017251 | ESFA-251           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20210702
Scenario: A252 Create and approve a new short 1920 EDSK contract for ALLF with four Delivery Orgs one of which matches the Contracting Org. Bulk amend to change just Contract Type. Check docs. Update draft amendment to add deliverable periods. Check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017252' 
    And   there are no terminated or closed allocations for UKPRN '10017252' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017252' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-2521     |
    | ALLF-2522     |
    | ALLF-2523     |
    | ALLF-2524     |

    # Clear down the blob document archive and the associated ArchiveDocument control table (DocumentsDomain.ArchivedDocument)
    And   there is no data in the document archive or the associated control table

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017252' 
	And   caseload advisor 'FCS2 Test' is assigned to provider '10017252 Co Ltd' with UKPRN '10017252' and OrgId 'ORG0017252' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                                | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1            | AddressLine2            | AddressLine3            | AddressLine4            | Town                   | County                 | Postcode  |
    | 10017252 | 117252 | 10017252 Co Ltd                     | 0              | Active                | Yes           | AA017252      | 17252         | 100 Harley Street       | London                  | ?                       | ?                       | ?                      | ?                      | BS32 8DT  |
    | 10021243 | 118360 | OXFORD HEALTH NHS FOUNDATION TRUST  | 0              | Active                | Yes           | ?             | ?             | Warneford Lane          | Headington              | ?                       | ?                       | Oxford                 | ?                      | OX3 7JX   |
    | 10021254 | 139924 | HIGHFIELDS COMMUNITY ASSOCIATION    | 0              | Active                | Yes           | 06078193      | 1118624       | 96 Melbourne Road       | ?                       | ?                       | ?                       | Leicester              | ?                      | LE2 0DS   |
    | 10021256 | 121667 | MERSEY CARE NHS FOUNDATION TRUST    | 0              | Active                | Yes           | ?             | ?             | Kings Business Park     | Kings Drive             | ?                       | ?                       | Prescot                | ?                      | L34 1PJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017252 | 
	| 10021243 |
	| 10021254 |
	| 10021256 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                | Period | CRMIntent    | OrgId      |
    | 10017252 | 10017252 Co Ltd      | ESFA-252             | EDSK-252       | 1                     | 01/08/2019        | 31/05/2020      | 147611.00     |                                    | Contract for Services (ITP) | 1920   | New          | ORG0017252 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                 | CRMIntent    | DeliveryOrg |
    | 10017252 | EDSK-252       | ALLF-2521     | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 31/05/2020        | 26751.00        |                                         |            |                                       | New          | 10017252    |
    | 10017252 | EDSK-252       | ALLF-2522     | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 31/05/2020        | 38422.00        |                                         |            |                                       | New          | 10021243    |
    | 10017252 | EDSK-252       | ALLF-2523     | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 31/05/2020        | 41718.00        |                                         |            |                                       | New          | 10021254    |
    | 10017252 | EDSK-252       | ALLF-2524     | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 31/05/2020        | 40720.00        |                                         |            |                                       | New          | 10021256    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | DeliverableDescription                 | CRMIntent    | DeliveryOrg |
    | 10017252 | EDSK-252       | ALLF-2521     | 5               | 0                     | 26751.00  | 3269.00  | 2610.00  | 859.00   | 4001.00  | 2525.00  | 1114.00  | 3237.00  | 4818.00  | 2185.00  | 2133.00  | Advanced Learner Loans Facility        | New          | 10017252    |
    | 10017252 | EDSK-252       | ALLF-2522     | 5               | 0                     | 38422.00  | 4491.00  | 7909.00  | 1879.00  | 4066.00  | 1232.00  | 3897.00  | 1741.00  | 2368.00  | 6327.00  | 4512.00  | Advanced Learner Loans Facility        | New          | 10021243    |
    | 10017252 | EDSK-252       | ALLF-2523     | 5               | 0                     | 41718.00  | 7261.00  | 6804.00  | 2335.00  | 5680.00  | 1486.00  | 2388.00  | 1794.00  | 3577.00  | 4066.00  | 6327.00  | Advanced Learner Loans Facility        | New          | 10021254    |
    | 10017252 | EDSK-252       | ALLF-2524     | 5               | 0                     | 40720.00  | 5564.00  | 7072.00  | 6275.00  | 2825.00  | 3112.00  | 5979.00  | 1106.00  | 4047.00  | 3177.00  | 1563.00  | Advanced Learner Loans Facility        | New          | 10021256    |



    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-252' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-252' and actual ContractNumber 'EDSK-252'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-252' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017252 | EDSK-252           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/05/2020      | ?             |
    | 10017252 | ESFA-252           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/05/2020      | ?             |

 


    # Bulk import to amend the contract changing just the Contract Type - from 'Contract for Services (ITP)' to 'Conditions of Funding (Grant) (Employer)'. No other changes

    # Change the date
    Given the override date is '15/07/2019'

    # Bulk import to amend the contract without changing anything at all
    And   there are no files prefixed '10017252' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed '10017252' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 19032019150200 v3_A252_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 19032019150200 v3_A252_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 19032019150200 v3_A252_1.xlsx' exists in the Datafiles folder and UKPRN '10017252' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # The pdf produced should contain just a 'Summary of Funding'. No 'Funding Agreements', 'Terms and Conditions' or 'Schedule 3' 

    # Retrieve parameters 
    And   I retrieve the latest EFA contract details from CRM for provider '10017252' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017252'
   #And   I retrieve the latest contract details from CRM for provider '10017252' for FundingType 'EDSK' and period '1920'

    # 'Summary of Funding'    
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017252 Co Ltd UKPRN: 10017252
    Master Contract Number: ESFA-252
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    10017252 Co Ltd ALLF-2521 £22,433 £4,318 £26,751
    HIGHFIELDS COMMUNITY ASSOCIATION ALLF-2523 £31,325 £10,393 £41,718
    MERSEY CARE NHS FOUNDATION TRUST ALLF-2524 £35,980 £4,740 £40,720
    OXFORD HEALTH NHS FOUNDATION TRUST ALLF-2522 £27,583 £10,839 £38,422
    Total Funding for this contract: £147,611
    Summary of Funding – Page 1
    """


    # The 'Funding Agreement' for ALLF-2521 (10017252) should be missing
    And   the pdf file does not contain the following text
    """
    Provider: 10017252 Co Ltd UKPRN: 10017252
    """

    # The 'Funding Agreement' for ALLF-2522 (10021243) should be missing
    And   the pdf file does not contain the following text
    """
    Provider: OXFORD HEALTH NHS FOUNDATION TRUST UKPRN: 10021243
    """

    # The 'Funding Agreement' for ALLF-2523 (10021254) should be missing
    And   the pdf file does not contain the following text
    """
    Provider: HIGHFIELDS COMMUNITY ASSOCIATION UKPRN: 10021254
    """

    # The 'Funding Agreement' for ALLF-2524 (10021256) should be missing
    And   the pdf file does not contain the following text
    """
    Provider: MERSEY CARE NHS FOUNDATION TRUST UKPRN: 10021256
    """

    # The 'Terms and Conditions' should be missing
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Employers) 
    """

    # The 'Schedule 3' should be missing
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED  
    """

    # Save a copy of the output
   #Then  Sharepoint file '10017nnn_[ContractNo]_v1.pdf' in 'xxx-nnnn-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017nnn_[ContractNo]_v1.pdf'
    Then  Sharepoint file '10017252_EDSK-252_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017252_EDSK-252_v2a.pdf'




    # Bulk update draft amendment to extend the expiry date of the contract and alllocations. Adding Deliverable Periods to all four allocations

    # Change the date
    Given the override date is '23/07/2019'

    # Bulk update draft amendment
    And   there are no files prefixed '10017252' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed '10017252' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 19032019150200 v3_A252_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 19032019150200 v3_A252_2' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 19032019150200 v3_A252_2.xlsx' exists in the Datafiles folder and UKPRN '10017252' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report



	# The pdf produced should contain a 'Summary of Funding' and all four 'Funding Agreements'. No 'Terms and Conditions' or 'Schedule 3' 

    # Retrieve parameters 
    And   I retrieve the latest EFA contract details from CRM for provider '10017252' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017252'
   #And   I retrieve the latest contract details from CRM for provider '10017252' for FundingType 'EDSK' and period '1920'

    # 'Summary of Funding'    
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017252 Co Ltd UKPRN: 10017252
    Master Contract Number: ESFA-252
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    10017252 Co Ltd ALLF-2521 £22,433 £10,536 £32,969
    HIGHFIELDS COMMUNITY ASSOCIATION ALLF-2523 £31,325 £13,928 £45,253
    MERSEY CARE NHS FOUNDATION TRUST ALLF-2524 £35,980 £18,927 £54,907
    OXFORD HEALTH NHS FOUNDATION TRUST ALLF-2522 £27,583 £18,143 £45,726
    Total Funding for this contract: £178,855
    Summary of Funding – Page 1
    """

    # 'Funding Agreement' for ALLF-2521 (10017252). Two deliverable periods added
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017252 Co Ltd UKPRN: 10017252
    Master Contract Number: ESFA-252 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: ALLF-2521
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £32,969 £3,269 £2,610 £859 £4,001 £2,525 £1,114 £3,237 £4,818 £2,185 £2,133 £179 £6,039
    Total Funding £32,969 £3,269 £2,610 £859 £4,001 £2,525 £1,114 £3,237 £4,818 £2,185 £2,133 £179 £6,039
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLF-2521 – Page 1 Ref (for internal use only):  EDSK-252 v2
    """

    # 'Funding Agreement' for ALLF-2523 (10021254). Two deliverable periods added
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: HIGHFIELDS COMMUNITY ASSOCIATION UKPRN: 10021254
    Master Contract Number: ESFA-252 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: ALLF-2523
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £45,253 £7,261 £6,804 £2,335 £5,680 £1,486 £2,388 £1,794 £3,577 £4,066 £6,327 £1,656 £1,879
    Total Funding £45,253 £7,261 £6,804 £2,335 £5,680 £1,486 £2,388 £1,794 £3,577 £4,066 £6,327 £1,656 £1,879
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLF-2523 – Page 1 Ref (for internal use only):  EDSK-252 v2
    """

    # 'Funding Agreement' for ALLF-2524 (10021256). Two deliverable periods added
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: MERSEY CARE NHS FOUNDATION TRUST UKPRN: 10021256
    Master Contract Number: ESFA-252 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: ALLF-2524
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £54,907 £5,564 £7,072 £6,275 £2,825 £3,112 £5,979 £1,106 £4,047 £3,177 £1,563 £6,404 £7,783
    Total Funding £54,907 £5,564 £7,072 £6,275 £2,825 £3,112 £5,979 £1,106 £4,047 £3,177 £1,563 £6,404 £7,783
    Schedule 2 – Advanced Learner Loans – Funding Agreement ALLF-2524 – Page 1 Ref (for internal use only):  EDSK-252 v2
    """

    # 'Funding Agreement' for ALLF-2522 (10021243). Two deliverable periods added
    And   the pdf file contains the following page lines in order
    """
    Funding Agreement Advanced Learner Loans Facility
    Provider: OXFORD HEALTH NHS FOUNDATION TRUST UKPRN: 10021243
    Master Contract Ref: ESFA-252 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: ALLF-2522
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £45,726 £4,491 £7,909 £1,879 £4,066 £1,232 £3,897 £1,741 £2,368 £6,327 £4,512 £4,119 £3,185
    Total Funding £45,726 £4,491 £7,909 £1,879 £4,066 £1,232 £3,897 £1,741 £2,368 £6,327 £4,512 £4,119 £3,185
    Ref (for internal use only):  EDSK-252 v2
    Page 1 of 1 of this Funding Agreement
    """


    # The 'Terms and Conditions' should be missing
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Employers) 
    """

    # The 'Schedule 3' should be missing
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED  
    """


    # Check that the document parts are in the right order
    And   the pdf file contains the following page lines in order
    """
	SUMMARY OF FUNDING 2019/20
	Provider: 10017252 Co Ltd UKPRN: 10017252
	Provider: HIGHFIELDS COMMUNITY ASSOCIATION UKPRN: 10021254
	Provider: MERSEY CARE NHS FOUNDATION TRUST UKPRN: 10021256
	Provider: OXFORD HEALTH NHS FOUNDATION TRUST UKPRN: 10021243
	"""

    # Save a copy of the output
   #Then  Sharepoint file '10017nnn_[ContractNo]_v1.pdf' in 'xxx-nnnn-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017nnn_[ContractNo]_v1.pdf'
    Then  Sharepoint file '10017252_EDSK-252_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017252_EDSK-252_v2b.pdf'




    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017252 | EDSK-252           | 2                     | 1                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017252 | EDSK-252           | 2                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/05/2020      | Variation     |
    | 10017252 | EDSK-252           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2019        | 31/05/2020      | ?             |
    | 10017252 | ESFA-252           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/05/2020      | ?             |


	# Tidy up
	And   the override date is reset
	   
@AcceptanceTest @Withdrawn20230123
Scenario: A259 Create and approve a new 1920 EDSK contract for ALLF with one Delivery Org which matches the Contracting Org. Bulk amend to add an allocation. Check docs. Update draft amendment to add another allocation. Check docs.
    Given there are no allocations marked as Under Termination for UKPRN '10017259' 
    And   there are no terminated or closed allocations for UKPRN '10017259' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017259' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-259      |


    # Clear down the blob document archive and the associated ArchiveDocument control table (DocumentsDomain.ArchivedDocument)
    And   there is no data in the document archive or the associated control table

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017259' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017259 Co Ltd' with UKPRN '10017259' and OrgId 'ORG0017259' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                                        | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017259 | 117259 | 10017259 Co Ltd                             | 0              | Active | Yes           | AA017259      | 17259         | 95 Church Way          | Iffley Village         | Oxford                 | ?                      | ?                      | ?                      | OX4 4EG   |   
    | 10021018 | 118211 | QDOS TRAINING LIMITED                       | 0              | Active | Yes           | AA118211      | 118211        | Byron House            | Commercial Street      | ?                      | ?                      | Mansfield              | NOTTINGHAMSHIRE        | NG18 1EE  |
    | 10021021 | 118760 | URBAN FUTURES LONDON LIMITED                | 0              | Active | Yes           | AA118760      | ?             | Unit A012              | The Business Centre    | 5 Clarendon Road       | ?                      | London                 | ?                      | N22 6XJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017259 |
	| 10021018 |
    | 10021021 |
	
	
	
	# Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription        | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017259 | 10017259 Co Ltd      | ESFA-259             | EDSK-259       | 1                     | 01/08/2019        | 31/07/2020      | 37984.00      |                            | Conditions of Funding (Grant) (College)    | 1920   | New          | ORG0017259 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                 | CRMIntent    | DeliveryOrg |
    | 10017259 | EDSK-259       | ALLF-259      | ALLF              | ALLF1920                | AY                      | 08/08/2019          | 15/07/2020        | 37984.00        |                                         |            |                                       | New          | 10017259    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                 | CRMIntent    | DeliveryOrg |
    | 10017259 | EDSK-259       | ALLF-259      | 5               | 0                     | 37984.00  | 3687.00  | 3028.00  | 1277.00  | 4419.00  | 2943.00  | 1531.00  | 3655.00  | 5236.00  | 2603.00  | 2551.00  | 597.00   | 6457.00  | Advanced Learner Loans Facility        | New          | 10017259    | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'



    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-259' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '06/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-259' and actual ContractNumber 'EDSK-259'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-259' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017259 | EDSK-259           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017259 | ESFA-259           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |




    # Bulk import to amend the contract adding an allocation for Delivery Org 10021018. No other changes

    # Change the date
    Given the override date is '08/07/2019'

    # Amend the contract
    And   there are no files prefixed '10017259' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed '10017259' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 20032019143347 v3_A259_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 20032019143347 v3_A259_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 20032019143347 v3_A259_1.xlsx' exists in the Datafiles folder and UKPRN '10017259' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # The pdf produced should include a 'Summary of Funding' plus a 'Funding Agreement' for QDOS, but no 'Terms and Conditions' or 'Schedule 3' 

    # Retrieve parameters 
    And   I retrieve the latest EFA contract details from CRM for provider '10017259' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10021018'
   #And   I retrieve the latest contract details from CRM for provider '10017259' for FundingType 'EDSK' and period '1920'

    # 'Summary of Funding'    
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017259 Co Ltd UKPRN: 10017259
    Master Contract Number: ESFA-259
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    10017259 Co Ltd ALLF-259 £25,776 £12,208 £37,984
    QDOS TRAINING LIMITED [AllocRef_ALLF] £25,776 £12,208 £37,984
    Total Funding for this contract: £75,968
    Summary of Funding – Page 1
    """


    # 'Funding Agreement' for new allocation, QDOS (10020198)
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: QDOS TRAINING LIMITED UKPRN: 10021018
    Master Contract Number: ESFA-259 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £37,984 £3,687 £3,028 £1,277 £4,419 £2,943 £1,531 £3,655 £5,236 £2,603 £2,551 £597 £6,457
    Total Funding £37,984 £3,687 £3,028 £1,277 £4,419 £2,943 £1,531 £3,655 £5,236 £2,603 £2,551 £597 £6,457
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  EDSK-259 v2
    """


    # The 'Funding Agreement' for ALLF-259 (10017259) should be missing
    And   the pdf file does not contain the following text
    """
    Provider: 10017259 Co Ltd UKPRN: 10017259
    """

    # The 'Terms and Conditions' should be missing
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    """

    # The 'Schedule 3' should be missing
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """


    # Check that the document parts are in the right order
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Provider: QDOS TRAINING LIMITED UKPRN: 10021018
    """

    # Save a copy of the output
   #Then  Sharepoint file '10017nnn_[ContractNo]_v1.pdf' in 'xxx-nnnn-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017nnn_[ContractNo]_v1.pdf'
    Then  Sharepoint file '10017259_EDSK-259_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017259_EDSK-259_v2a.pdf'




    # Bulk update draft amendment to add a contract allocation for Delivery Org 10021021 (URBAN FUTURES LONDON LIMITED). No other changes

    # Change the date
    Given the override date is '11/07/2019'

    # Amend the contract
    And   there are no files prefixed '10017259' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed '10017259' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 20032019143347 v3_A259_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 20032019143347 v3_A259_2' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 20032019143347 v3_A259_2.xlsx' exists in the Datafiles folder and UKPRN '10017259' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # The pdf produced should include a 'Summary of Funding' plus 'Funding Agreements' for QDOS and URBAN FUTURES. No other 'Funding Agreements' and no 'Terms and Conditions' or 'Schedule 3' 

    # Retrieve parameters for QDOS
    And   I retrieve the latest EFA contract details from CRM for provider '10017259' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10021018'
   #And   I retrieve the latest contract details from CRM for provider '10017259' for FundingType 'EDSK' and period '1920'

    # 'Summary of Funding' - from the perspective of QDOS
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017259 Co Ltd UKPRN: 10017259
    Master Contract Number: ESFA-259
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    10017259 Co Ltd ALLF-259 £25,776 £12,208 £37,984
    QDOS TRAINING LIMITED [AllocRef_ALLF] £25,776 £12,208 £37,984
    Total Funding for this contract: £114,710
    Summary of Funding – Page 1
    """

    # 'Funding Agreement' for QDOS (10021018)
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: QDOS TRAINING LIMITED UKPRN: 10021018
    Master Contract Number: ESFA-259 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £37,984 £3,687 £3,028 £1,277 £4,419 £2,943 £1,531 £3,655 £5,236 £2,603 £2,551 £597 £6,457
    Total Funding £37,984 £3,687 £3,028 £1,277 £4,419 £2,943 £1,531 £3,655 £5,236 £2,603 £2,551 £597 £6,457
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  EDSK-259 v2
    """
	
	# Retrieve parameters for URBAN FUTURES
    And   I retrieve the latest EFA contract details from CRM for provider '10017259' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10021021'
   #And   I retrieve the latest contract details from CRM for provider '10017259' for FundingType 'EDSK' and period '1920'

    # 'Summary of Funding' - from the prespective of URBAN FUTURES
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017259 Co Ltd UKPRN: 10017259
    Master Contract Number: ESFA-259
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    10017259 Co Ltd ALLF-259 £25,776 £12,208 £37,984
    URBAN FUTURES LONDON LIMITED [AllocRef_ALLF] £26,320 £12,422 £38,742
    Total Funding for this contract: £114,710
    Summary of Funding – Page 1
    """

    # 'Funding Agreement' for URBAN FUTURES (10021021)
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: URBAN FUTURES LONDON LIMITED UKPRN: 10021021
    Master Contract Number: ESFA-259 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Advanced Learner Loans Facility £38,742 £3,882 £3,117 £1,191 £4,625 £2,877 £1,689 £3,570 £5,369 £2,577 £2,520 £807 £6,518
    Total Funding £38,742 £3,882 £3,117 £1,191 £4,625 £2,877 £1,689 £3,570 £5,369 £2,577 £2,520 £807 £6,518
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  EDSK-259 v2
    """

    # The 'Funding Agreement' for ALLF-259 (10017259) should be missing
    And   the pdf file does not contain the following text
    """
    Provider: 10017259 Co Ltd UKPRN: 10017259
    """

    # The 'Terms and Conditions' should be missing
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant) (Colleges)
    """

    # The 'Schedule 3' should be missing
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

    # Check that the document parts are in the right order
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Provider: QDOS TRAINING LIMITED UKPRN: 10021018
	Provider: URBAN FUTURES LONDON LIMITED UKPRN: 10021021
    """

    # Save a copy of the output
   #Then  Sharepoint file '10017nnn_[ContractNo]_v1.pdf' in 'xxx-nnnn-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017nnn_[ContractNo]_v1.pdf'
    Then  Sharepoint file '10017259_EDSK-259_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017259_EDSK-259_v2b.pdf'



    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run123
Scenario: A276 Create an approved 1920 EDSK contract for ALLF with one Delivery Org which does not match the Contracting Org. Amend to add an allocation for the Delivery Org. Update draft 2x checking docs 2x. (DaveB test)
    Given there are no allocations marked as Under Termination for UKPRN '10017276' 
    And   there are no terminated or closed allocations for UKPRN '10017276' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017276' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 


    # Clear down the blob document archive and the associated ArchiveDocument control table (DocumentsDomain.ArchivedDocument)
    And   there is no data in the document archive or the associated control table

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017276' 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'TREE CLIMBING AND FISH TICKLING ASSOCIATION' with UKPRN '10017276' and OrgId 'ORG0017276' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                                        | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017276 | 117276 | TREE CLIMBING AND FISH TICKLING ASSOCIATION | 0              | Active | Yes           | ?             | 117276        | George Court           | 6 Bartholemews Walk    | ?                      | ?                      | Ely                    | ?                      | CB7 4JW   |
    | 10027651 | 125472 | TOTAL SUPPORT TRAINING LIMITED              | 0              | Active | Yes           | AA125472      | ?             | 87a High Street        | ?                      | ?                      | ?                      | Hemel Hempstead        | HERTFORDSHIRE          | HP1 3AH   |
    | 10027655 | 105969 | WASTING AWAY (NORTHAMPTON) LIMITED          | 0              | Active | Yes           | ?             | 105969        | 3-5 Wood Hill          | ?                      | ?                      | ?                      | Northampton            | ?                      | NN1 2DA   |
    | 10027693 | 121216 | ALL TRADES TRAINING LIMITED                 | 0              | Active | Yes           | ?             | 121216        | Chase Green House      | 42 Chase Side          | ?                      | ?                      | Enfield                | MIDDLESEX              | EN2 6NF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017276 |
	| 10027651 |
	| 10027655 |
	| 10027693 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName                                   | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription        | ContractType                       | Period | CRMIntent    | OrgId      |
    | 10017276 | TREE CLIMBING AND FISH TICKLING ASSOCIATION | ESFA-276             | EDSK-276       | 1                     | 01/08/2019        | 31/07/2020      | 37984.00      |                            | Conditions of Funding (Grant) (LA) | 1920   | New          | ORG0017276 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                 | CRMIntent    | DeliveryOrg |
    | 10017276 | EDSK-276       | ALLF-276      | ALLF              | ALLF1920                | AY                      | 08/08/2019          | 15/07/2020        | 37984.00        |                                         |            |                                       | New          | 10027651    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                 | CRMIntent    | DeliveryOrg |
    | 10017276 | EDSK-276       | ALLF-276      | 5               | 0                     | 37984.00  | 3687.00  | 3028.00  | 1277.00  | 4419.00  | 2943.00  | 1531.00  | 3655.00  | 5236.00  | 2603.00  | 2551.00  | 597.00   | 6457.00  | Advanced Learner Loans Facility        | New          | 10027651    | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'



    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-276' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '04/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-276' and actual ContractNumber 'EDSK-276'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-276' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017276 | EDSK-276           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017276 | ESFA-276           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |




    # Bulk import to amend v1 and create v2 ...
	#  1.  Add an allocation for Contracting Org 10017276, and 
	#  2.  Update the profile values on Delivery Org 10027651

    # Change the date
    Given the override date is '08/07/2019'

    # Amend the contract
    And   there are no files prefixed '10017276' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed '10017276' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 21032019135237 v3_A276_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 21032019135237 v3_A276_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 21032019135237 v3_A276_1.xlsx' exists in the Datafiles folder and UKPRN '10017276' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # The pdf produced should have a 'Summary of Funding' plus two 'Funding Agreements' 

    # Retrieve parameters 
    And   I retrieve the latest EFA contract details from CRM for provider '10017276' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017276'
   #And   I retrieve the latest contract details from CRM for provider '10017276' for FundingType 'EDSK' and period '1920'

    # 'Summary of Funding'    
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: TREE CLIMBING AND FISH TICKLING ASSOCIATION UKPRN: 10017276
    Master Contract Number: ESFA-276
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    TREE CLIMBING AND FISH TICKLING ASSOCIATION [AllocRef_ALLF] £19,576 £14,139 £33,715
    TOTAL SUPPORT TRAINING LIMITED ALLF-276 £19,437 £14,225 £33,662
    Total Funding for this contract: £67,377
    Summary of Funding – Page 1
    """



    # Should contain Funding Agreements for TREE CLIMBING then FISH TICKLING

    # 'Funding Agreement' aka Schedule 2
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: TREE CLIMBING AND FISH TICKLING ASSOCIATION UKPRN: 10017276
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: TOTAL SUPPORT TRAINING LIMITED UKPRN: 10027651
    """


    # The 'Terms and Conditions' should be missing
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant)
    """

    # The 'Schedule 3' should be missing
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED  
    """

	# Save a copy of the output
   #Then  Sharepoint file '10017251_[ContractNo]_v3.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017251_[ContractNo]_v3_1.pdf'
	Then  Sharepoint file '10017276_EDSK-276_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017276_EDSK-276_v2a.pdf'




    # Bulk import to update the amended contract. Revert the TOTAL SUPPORT profile to that on v1. No other change 

    # Change the date
    Given the override date is '10/07/2019'

    # Amend the contract
    And   there are no files prefixed '10017276' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed '10017276' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 21032019135237 v3_A276_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 21032019135237 v3_A276_2' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 21032019135237 v3_A276_2.xlsx' exists in the Datafiles folder and UKPRN '10017276' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # The pdf produced should have a 'Summary of Funding' and one 'Funding Agreement' 

    # Retrieve parameters 
    And   I retrieve the latest EFA contract details from CRM for provider '10017276' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017276'
   #And   I retrieve the latest contract details from CRM for provider '10017276' for FundingType 'EDSK' and period '1920'

    # 'Summary of Funding'    
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: TREE CLIMBING AND FISH TICKLING ASSOCIATION UKPRN: 10017276
    Master Contract Number: ESFA-276
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    TREE CLIMBING AND FISH TICKLING ASSOCIATION [AllocRef_ALLF] £19,576 £14,139 £33,715
    TOTAL SUPPORT TRAINING LIMITED ALLF-276 £25,776 £12,208 £37,984
    Total Funding for this contract: £71,699
    Summary of Funding – Page 1
    """

    # Should contain a 'Funding Agreement' for TOTAL SUPPORT

    # 'Funding Agreements'
    And   the pdf file contains the following page lines in order
    """
    Funding Agreement – Advanced Learner Loans Facility
    Provider: TOTAL SUPPORT TRAINING LIMITED UKPRN: 10027651
    """

    # But no 'Funding Agreement' for TREE CLIMBING
    And   the pdf file does not contain the following text
    """
    Provider: TREE CLIMBING AND FISH TICKLING UKPRN: 10017259
    """

    # The 'Terms and Conditions' should be missing
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant)
    """

    # The 'Schedule 3' should be missing
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

	# Save a copy of the output
   #Then  Sharepoint file '10017251_[ContractNo]_v3.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017251_[ContractNo]_v3_1.pdf'
	Then  Sharepoint file '10017276_EDSK-276_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017276_EDSK-276_v2b.pdf'




    # Bulk import to update the amended contract again. Update the profile for TOTAL SUPPORT and add new allocations for WASTING AWAY and ALL TRADES 

    # Change the date
    Given the override date is '12/07/2019'

    # Amend the contract
    And   there are no files prefixed '10017276' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed '10017276' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 21032019135237 v3_A276_3' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 21032019135237 v3_A276_3' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 21032019135237 v3_A276_3.xlsx' exists in the Datafiles folder and UKPRN '10017276' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # The pdf produced should have a 'Summary of Funding' and four 'Funding Agreements' 

    # Retrieve parameters 
    And   I retrieve the latest EFA contract details from CRM for provider '10017276' for FundingType 'EDSK' and period '1920' and Delivery Organisation '10017276'
   #And   I retrieve the latest contract details from CRM for provider '10017276' for FundingType 'EDSK' and period '1920'

    # 'Summary of Funding' (Parameter limitations mean the test can only check two of the allocations, plus the total)
    Then  a file for this contract exists in sharepoint location 'EDSK-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    SUMMARY OF FUNDING 2019/20
    Organisation Name: TREE CLIMBING AND FISH TICKLING ASSOCIATION UKPRN: 10017276
    Master Contract Number: ESFA-276
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Advanced Learner Loans Facility
    TREE CLIMBING AND FISH TICKLING ASSOCIATION [AllocRef_ALLF] £19,576 £14,139 £33,715
    TOTAL SUPPORT TRAINING LIMITED ALLF-276 £28,632 £18,924 £47,556
    Total Funding for this contract: £176,276
    Summary of Funding – Page 1
    """

    # Should contain four 'Funding Agreements': TREE CLIMBING then ALL TRADES, TOTAL SUPPORT and WASTING AWAY 

    # 'Funding Agreements'
    And   the pdf file contains the following page lines in order
    """
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: TREE CLIMBING AND FISH TICKLING ASSOCIATION UKPRN: 10017276
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: ALL TRADES TRAINING LIMITED UKPRN: 10027693
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: TOTAL SUPPORT TRAINING LIMITED UKPRN: 10027651
    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: WASTING AWAY (NORTHAMPTON) LIMITED UKPRN: 10027655
    """

    # The 'Terms and Conditions' should be missing
    And   the pdf file does not contain the following text
    """
    Agreement Type Conditions of Funding (Grant)
    """

    # The 'Schedule 3' should be missing
    And   the pdf file does not contain the following text
    """
    SCHEDULE 3: NOT USED
    """

	# Save a copy of the output
   #Then  Sharepoint file '10017251_[ContractNo]_v3.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017251_[ContractNo]_v3_1.pdf'
	Then  Sharepoint file '10017276_EDSK-276_v2.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017276_EDSK-276_v2c.pdf'

    # Tidy up
	And the override date is reset

