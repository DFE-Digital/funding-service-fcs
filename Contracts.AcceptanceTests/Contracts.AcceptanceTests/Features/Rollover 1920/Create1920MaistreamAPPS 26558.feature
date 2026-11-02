Feature: Create1920MaistreamAPPS 26558

@AcceptanceTest @Withdrawn20200604
@Long2Run @Long2Run67
Scenario: A621 Create and approve an 1819 Mainstream APPS contract. Create a 1920 Mainstream APPS contract with the same Master. Update draft then approve 1920 contract. Amend and approve 1920 contract. Run NFA. Check docs and CRM along the way
    Given there are no allocations marked as Under Termination for UKPRN '10017621' 
    And   there are no terminated or closed allocations for UKPRN '10017621' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017621' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | APPS-621      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017621' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017621 Co Ltd' with UKPRN '10017621' and OrgId 'ORG0017621' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017621' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017621 | 117621 | 10017621 Co Ltd | 0              | Active                | Yes           | AA017621      | ?             | 504 Bunyan Court       | Barbican               | London                 | ?                      | ?                      | ?                      | EC2Y 8DH  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017621 |



    # Change the date
    Given the override date is '01/07/2018'

    # Create contract for 1819 Mainstream APPS
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017621 | 10017621 Co Ltd      | ESFA-621             | MAIN-6211      | 1                     | 01/08/2018        | 31/07/2019      | 19998.00      |                                    | Contract for Services                      | 1819   | New          | ORG0017621 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017621 | MAIN-6211      | APPS-6211     | APPS              | APPS1819                | AY                      | 01/08/2018          | 31/07/2019        | 19998.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017621 | MAIN-6211      | APPS-6211     | 1               | 0                     | 19998.00  | 3570.00  | 3041.00  | 1910.00  | 620.00   | 788.00   | 2251.00  | 581.00   | 907.00   | 1895.00  | 2631.00  | 423.00   | 1381.00  | Apprenticeships Carry-In Total Funding                          | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-6211' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-621' and actual ContractNumber 'MAIN-6211'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-6211' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017621 | MAIN-6211          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017621 | ESFA-621           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '288' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '288' deliverable period rows in CRM linked to the latest version of contract 'MAIN-6211'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | APPS-6211       | 2240100          | Jul-19 | Reconciliation |



    # Change the date
    Given the override date is '01/07/2019'

    # Create contract for 1920 Mainstream APPS (with same Master as for the 1819 contract)
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017621 | 10017621 Co Ltd      | ESFA-621             | MAIN-6212      | 1                     | 01/08/2019        | 31/07/2020      | 29528.00      |                                    | Contract for Services                      | 1920   | New          | ORG0017621 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017621 | MAIN-6212      | APPS-6212     | APPS              | APPS1920                | AY                      | 01/08/2019          | 31/07/2020        | 29528.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017621 | MAIN-6212      | APPS-6212     | 1               | 0                     | 29528.00  | 3221.00  | 2153.00  | 2637.00  | 3151.00  | 626.00   | 2534.00  | 2479.00  | 3625.00  | 2904.00  | 3102.00  | 2509.00  | 587.00   | Apprenticeships Carry-In Total Funding                          | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'


    # Change the date
    Given the override date is '13/07/2019'

    # Bulk file to execute an Update Draft on the 1920 contract
    And   there are no files prefixed '10017621' in the Sharepoint 'MAIN-1920-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1920 16072019170019 v3_A621_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1920 16072019170019 v3_A621_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1920 16072019170019 v3_A621_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 1920 16072019170019 v3_A621_1.xlsx' exists in the Datafiles folder and UKPRN '10017621' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters 
   #And   I retrieve the latest EFA contract details from CRM for provider '10017621' for FundingType 'MAIN' and period '1920' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017621' for FundingType 'MAIN' and period '1920'

    # Check the contents of the Appendices
    And   a file for this contract exists in sharepoint location 'MAIN-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017621 Co Ltd UKPRN: 10017621
    Master Contract Number: ESFA-621
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Apprenticeships Carry-In APPS-6212 £40,259 £8,579 £48,838
    Total Funding for this contract: £48,838

    Funding Agreement Apprenticeships Carry-In
    Provider: 10017621 Co Ltd UKPRN: 10017621
    Master Contract Number: ESFA-621 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: APPS-6212
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Apprenticeships Carry-In £48,838 £2,100 £5,518 £7,439 £1,675 £6,792 £1,506 £7,301 £7,928 £3,936 £2,121 £1,728 £794
    Total Funding £48,838 £2,100 £5,518 £7,439 £1,675 £6,792 £1,506 £7,301 £7,928 £3,936 £2,121 £1,728 £794
    Ref (for internal use only):  MAIN-6212 v1
    Page 1 of 1 of this Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   #And   Sharepoint file '10017621_[ContractNo]_v1.pdf' in 'MAIN-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '<filename2>.pdf'
    And   Sharepoint file '10017621_MAIN-6212_v1.pdf' in 'MAIN-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017621_MAIN-6212_v1.pdf'




    # Change the date
    Given the override date is '19/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-6212' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-621' and actual ContractNumber 'MAIN-6212'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-6212' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017621 | MAIN-6212          | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017621 | MAIN-6212          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017621 | ESFA-621           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '288' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '288' deliverable period rows in CRM linked to the latest version of contract 'MAIN-6212'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | APPS-6212       | 2240100          | Jul-20 | Reconciliation |



    # Change the date
    Given the override date is '23/07/2019'

    # Bulk file to amend the 1920 contract
    And   there are no files prefixed '10017621' in the Sharepoint 'MAIN-1920-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1920 16072019170022 v3_A621_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1920 16072019170022 v3_A621_2' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1920 16072019170022 v3_A621_2' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 1920 16072019170022 v3_A621_2.xlsx' exists in the Datafiles folder and UKPRN '10017621' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters 
   #And   I retrieve the latest EFA contract details from CRM for provider '10017621' for FundingType 'MAIN' and period '1920' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017621' for FundingType 'MAIN' and period '1920'

    # Check the contents of the Appendices
    And   a file for this contract exists in sharepoint location 'MAIN-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017621 Co Ltd UKPRN: 10017621
    Master Contract Number: ESFA-621
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Apprenticeships Carry-In APPS-6212 £42,033 £8,953 £50,986
    Total Funding for this contract: £50,986

    Funding Agreement Apprenticeships Carry-In
    Provider: 10017621 Co Ltd UKPRN: 10017621
    Master Contract Number: ESFA-621 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: APPS-6212
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Apprenticeships Carry-In £50,986 £2,348 £5,900 £7,737 £1,708 £7,184 £1,420 £7,501 £8,235 £3,894 £1,966 £2,107 £986
    Total Funding £50,986 £2,348 £5,900 £7,737 £1,708 £7,184 £1,420 £7,501 £8,235 £3,894 £1,966 £2,107 £986
    Ref (for internal use only):  MAIN-6212 v2
    Page 1 of 1 of this Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   #And   Sharepoint file '10017621_[ContractNo]_v2.pdf' in 'MAIN-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '<filename2>.pdf'
    And   Sharepoint file '10017621_MAIN-6212_v2.pdf' in 'MAIN-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017621_MAIN-6212_v2.pdf'




    # Change the date
    Given the override date is '29/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'MAIN-6212' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-621' and actual ContractNumber 'MAIN-6212'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-6212' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017621 | MAIN-6212          | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017621 | MAIN-6212          | 1                     | 1                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017621 | MAIN-6212          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017621 | ESFA-621           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '288' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '288' deliverable period rows in CRM linked to the latest version of contract 'MAIN-6212'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | APPS-6211       | 2240100          | Jul-20 | Reconciliation |




    # Change the date
    Given the override date is '02/08/2019'

    # Issue a non-financial VARIATION amendment on v2 to create v3
   #When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'MAIN-6212' for a non-financial NOTIFICATION contract amendment
   When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'MAIN-6212' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017621 | MAIN-6212          | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017621 | MAIN-6212          | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017621 | MAIN-6212          | 1                     | 1                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017621 | MAIN-6212          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017621 | ESFA-621           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Retrieve parameters 
   #And   I retrieve the latest EFA contract details from CRM for provider '10017621' for FundingType 'MAIN' and period '1920' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017621' for FundingType 'MAIN' and period '1920'

    # Check the contents of the Appendices
    Then  a file for this contract exists in sharepoint location 'MAIN-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING 2019/20
    Organisation Name: 10017621 Co Ltd UKPRN: 10017621
    Master Contract Number: ESFA-621
    Allocation
    Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 2019/20 Total
    Apprenticeships Carry-In APPS-6212 £42,033 £8,953 £50,986
    Total Funding for this contract: £50,986

    Funding Agreement Apprenticeships Carry-In
    Provider: 10017621 Co Ltd UKPRN: 10017621
    Master Contract Number: ESFA-621 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: APPS-6212
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Apprenticeships Carry-In £50,986 £2,348 £5,900 £7,737 £1,708 £7,184 £1,420 £7,501 £8,235 £3,894 £1,966 £2,107 £986
    Total Funding £50,986 £2,348 £5,900 £7,737 £1,708 £7,184 £1,420 £7,501 £8,235 £3,894 £1,966 £2,107 £986
    Ref (for internal use only):  MAIN-6212 v3
    Page 1 of 1 of this Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   #And   Sharepoint file '10017621_[ContractNo]_v3.pdf' in 'MAIN-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '<filename2>.pdf'
    And   Sharepoint file '10017621_MAIN-6212_v3.pdf' in 'MAIN-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017621_MAIN-6212_v3.pdf'


	# Tidy Up
	And   the override date is reset
	    
		 