Feature: Create1920AEBPcontracts 26143

@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run67
Scenario: A746 Create and approve an 1819 AEB contract. Execute a non-financial amendment and check docs. Approve. Bulk load a new 1920 AEB contract with same Master. Check docs. Approve. Bulk amend 1819 contract. Check docs. Execute a non-financial amendment and check docs.
    Given there are no allocations marked as Under Termination for UKPRN '10017746' 
    And   there are no terminated or closed allocations for UKPRN '10017746' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017746' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
	And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
	| AEBC-746      |
	| AEBL-746      |
    | AEBT-746      |
	
    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    Given there are no Sector-based Work Academies profile values in config for UKPRN '10017746'

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017746' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017746 Co Ltd' with UKPRN '10017746' and OrgId 'ORG0017746' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017746' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017746 | 117746 | 10017746 Co Ltd | 0              | Locked Restructure    | Yes           | AA017746      | ?             | 80 Lapins Lane         | Kingshill              | ?                      | ?                      | West Malling           | Kent                   | ME19 4LE  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017746 |




    # Change the date
    Given the override date is '01/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017746 | 10017746 Co Ltd      | ESFA-746             | AEBP-746       | 1                     | 01/08/2018        | 31/07/2019      | 75829.00      |                                    | Contract for Services                      | 1819   | New          | ORG0017746 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017746 | AEBP-746       | AEBC-746      | AEB-CL            | AEB-CL1819              | AY                      | 01/08/2018          | 31/07/2019        | 26688.00        |                                         |            |                                                             | New          |             |
    | 10017746 | AEBP-746       | AEBL-746      | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 23440.00        |                                         |            |                                                             | New          |             |
    | 10017746 | AEBP-746       | AEBT-746      | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 25701.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017746 | AEBP-746       | AEBC-746      | 1               | 0                     | 26688.00  | 916.00   | 892.00   | 3683.00  | 2710.00  | 946.00   | 2537.00  | 3431.00  | 748.00   | 3130.00  | 669.00   | 3367.00  | 3659.00  | Adult Education Budget - Community Learning                     | New          |             |
    | 10017746 | AEBP-746       | AEBL-746      | 1               | 0                     | 23440.00  | 2141.00  | 1296.00  | 1113.00  | 679.00   | 1983.00  | 1771.00  | 3391.00  | 1247.00  | 2996.00  | 3416.00  | 3139.00  | 268.00   | Adult Education Budget - Learner Support                        | New          |             |
    | 10017746 | AEBP-746       | AEBT-746      | 1               | 0                     | 25701.00  | 2466.00  | 3519.00  | 1345.00  | 1448.00  | 2120.00  | 2822.00  | 2451.00  | 846.00   | 1962.00  | 3297.00  | 1028.00  | 2397.00  | Adult Education - Traineeships and Other Learning Total Funding | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-746' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '05/07/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-746' and actual ContractNumber 'AEBP-746'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-746' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017746 | AEBP-746           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017746 | ESFA-746           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'AEBP-746'




    # Change the date
    Given the override date is '07/07/2018'
	
	# Non-Financial VARIATION amendment on v1 to create v2
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'AEBP-746' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017746 | AEBP-746           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017746 | AEBP-746           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017746 | ESFA-746           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

   # Retrieve parameters
   #Given I retrieve the latest EFA contract details from CRM for provider '10017746' for FundingType 'AEB' and period '1819' and Delivery Organisation '10017746'
    Given I retrieve the latest contract details from CRM for provider '10017746' for FundingType 'AEB' and period '1819'  

    # Check the docs
    Then  a file for this contract exists in sharepoint location 'AEB-1819-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017746 Co Ltd UKPRN: 10017746
    Master Contract Number: ESFA-746
    Allocation
    1 August 2018 to 31 July 2019 Contract Ref Aug 18 - Mar 19 Apr 19 - Jul 19 Total
    Adult Education Budget - Traineeships and Other Learning AEBT-746 £17,017 £8,684 £25,701
    Adult Education Budget - Community Learning AEBC-746 £15,863 £10,825 £26,688
    Adult Education Budget - Learner Support AEBL-746 £13,621 £9,819 £23,440
    Total: £75,829
    Total Funding for this contract: £75,829
    """

    # There should be no Funding Agreements for 1819
    And   the pdf file does not contain the following text
    """
    Master Contract Ref: ESFA-746 Start Date: 01/08/2018 End Date: 31/07/2019
    """

    # There should not be a zero value entry in the doc for Sector-based Work Academies. These are 2021+ (30680)
    And   the pdf file does not contain the following text
    """
    of which Sector-based Work Academies £0 £0 £0
    """


    # Save a copy of the output
   #And   Sharepoint file '10017nnn_[ContractNo]_vx.pdf' in 'xxx-nnnn-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017nnn_[ContractNo]_vx.pdf'
    And   Sharepoint file '10017746_AEBP-746_v2.pdf' in 'AEB-1819-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A746v2.pdf'




    # Change the date
    Given the override date is '13/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-746' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-746' and actual ContractNumber 'AEBP-746'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-746' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017746 | AEBP-746           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017746 | AEBP-746           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017746 | ESFA-746           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'AEBP-746'


    And   CRM subnominals have been created for the following allocations
	| AllocationRef | Subnominal Code  | Period | Payment Type   |
	| AEBC-746      | 2372060          | Aug-18 | Reconciliation |
	| AEBL-746      | 2372075          | Aug-18 | Reconciliation |
    | AEBT-746      | 2355800          | Aug-18 | Reconciliation |

    # Change the date
    Given the override date is '02/07/2019'
	
	# Bulk new amendment to add a 1920 AEBP contract with the same Master Contract number as the 1718 AEBP contract
    Given there are no files prefixed '10017746' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1920 26062019153314 v3_A746_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1920 26062019153314 v3_A746_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1920 26062019153314 v3_A746_1.xlsx' exists in the Datafiles folder and UKPRN '10017746' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

   # Retrieve parameters
   #Given I retrieve the latest EFA contract details from CRM for provider '10017746' for FundingType 'AEB' and period '1920' and Delivery Organisation '10017746'
    Given I retrieve the latest contract details from CRM for provider '10017746' for FundingType 'AEB' and period '1920'  

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017746 | [ContractNo]       | 1                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017746 | ESFA-746           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
	   	  
    # Check the docs
    Then  a file for this contract exists in sharepoint location 'AEB-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017746 Co Ltd UKPRN: 10017746
    Master Contract Number: ESFA-746
    Allocation
    1 August 2018 to 31 July 2019 Contract Ref Aug 18 - Mar 19 Apr 19 - Jul 19 Total
	Adult Education Budget - Traineeships and Other Learning AEBT-746 £17,017 £8,684 £25,701
    Adult Education Budget - Community Learning AEBC-746 £15,863 £10,825 £26,688
    Adult Education Budget - Learner Support AEBL-746 £13,621 £9,819 £23,440
    Total: £75,829
    Allocation
    1 August 2019 to 31 July 2020 Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 Total
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AEBR] £34,645 £7,885 £42,530
    ESFA AEB - Adult Skills [AllocRef_AEBA] £26,649 £19,540 £46,189
    ESFA AEB - Community Learning [AllocRef_AEBC] £44,040 £19,477 £63,517
    ESFA AEB - 19 to 24 Traineeships Learner Support [AllocRef_AETL] £41,434 £20,037 £61,471
    ESFA AEB - Adult Skills Learner Support [AllocRef_AEAL] £30,314 £21,567 £51,881
    Total: £265,588
    Total Funding for this contract: £341,417

    Funding Agreement ESFA-Funded Adult Education Budget - 19 to 24 Traineeships
    Provider: 10017746 Co Ltd UKPRN: 10017746
    Master Contract Number: ESFA-746 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AEBR]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - 19 to 24 Traineeships £42,530 £1,398 £4,816 £6,737 £974 £6,090 £804 £6,600 £7,226 £3,235 £1,419 £1,027 £2,204
    Total Funding £42,530 £1,398 £4,816 £6,737 £974 £6,090 £804 £6,600 £7,226 £3,235 £1,419 £1,027 £2,204
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - Adult Skills
    Provider: 10017746 Co Ltd UKPRN: 10017746
    Master Contract Number: ESFA-746 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AEBA]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills £46,189 £713 £257 £3,739 £7,083 £2,889 £3,791 £3,197 £4,980 £5,469 £7,730 £3,059 £3,282
    Total Funding £46,189 £713 £257 £3,739 £7,083 £2,889 £3,791 £3,197 £4,980 £5,469 £7,730 £3,059 £3,282
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - Community Learning
    Provider: 10017746 Co Ltd UKPRN: 10017746
    Master Contract Number: ESFA-746 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AEBC]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Community Learning £63,517 £7,290 £7,035 £7,799 £5,506 £4,434 £5,538 £2,226 £4,212 £4,095 £6,557 £7,120 £1,705
    Total Funding £63,517 £7,290 £7,035 £7,799 £5,506 £4,434 £5,538 £2,226 £4,212 £4,095 £6,557 £7,120 £1,705
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - 19 to 24 Traineeships Learner Support
    Provider: 10017746 Co Ltd UKPRN: 10017746
    Master Contract Number: ESFA-746 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AETL]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - 19 to 24 Traineeships Learner Support £61,471 £7,632 £6,973 £5,222 £413 £6,888 £5,476 £7,600 £1,230 £6,548 £6,496 £4,542 £2,451
    Total Funding £61,471 £7,632 £6,973 £5,222 £413 £6,888 £5,476 £7,600 £1,230 £6,548 £6,496 £4,542 £2,451
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - Adult Skills Learner Support
    Provider: 10017746 Co Ltd UKPRN: 10017746
    Master Contract Number: ESFA-746 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AEAL]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills Learner Support £51,881 £7,462 £1,020 £223 £4,724 £7,748 £2,664 £5,742 £731 £7,812 £6,199 £3,088 £4,468
    Total Funding £51,881 £7,462 £1,020 £223 £4,724 £7,748 £2,664 £5,742 £731 £7,812 £6,199 £3,088 £4,468
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """

    # There should not be any Funding Agreements for 1819
    And   the pdf file does not contain the following text
    """
    Master Contract Ref: ESFA-746 Start Date: 01/08/2018 End Date: 31/07/2019
    """

    # There should not be a zero value entry in the doc for Sector-based Work Academies. These are 2021+ (30680)
    And   the pdf file does not contain the following text
    """
    of which Sector-based Work Academies £0 £0 £0
    """


    # Save a copy of the output
   #And   Sharepoint file '10017746_AEBP-746_v1.pdf' in 'AEB-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017746_AEB-746_v1.pdf'
    And   Sharepoint file '10017746_[ContractNo]_v1.pdf' in 'AEB-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A746v1.pdf'




    # Change the date
    Given the override date is '04/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
	And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-746' and actual ContractNumber 'AEBP-746'
   #When  an AEB contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
   #Then  the latest version of contract 'AEBP-746' is in status 'Approved'
	Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017746 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017746 | ESFA-746           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '108 deliverable period rows in CRM linked to the latest version of contract number 'AEBP-746'
    And   there are '108' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Change the date
    Given the override date is '15/07/2019'
	
	# Bulk amend the 1819 AEBP contract to create v3
    Given there are no files prefixed '10017746' in the Sharepoint 'AEB-1819-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1819 26062019171901 v3_A746' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1819 26062019171901 v3_A746' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1819 26062019171901 v3_A746_2.xlsx' exists in the Datafiles folder and UKPRN '10017746' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017746 | AEBP-746           | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017746 | AEBP-746           | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017746 | AEBP-746           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017746 | ESFA-746           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




   # Retrieve parameters for 1819
   #Given I retrieve the latest EFA contract details from CRM for provider '10017746' for FundingType 'AEB' and period '1819' and Delivery Organisation '10017746'
    Given I retrieve the latest contract details from CRM for provider '10017746' for FundingType 'AEB' and period '1819'  

    # Check the Summary of Funding and Funding Agreement data for 1819
    Then  a file for this contract exists in sharepoint location 'AEB-1819-Input-Appendices'
	And   the pdf file contains the following page lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017746 Co Ltd UKPRN: 10017746
    Master Contract Number: ESFA-746
    Allocation
    1 August 2018 to 31 July 2019 Contract Ref Aug 18 - Mar 19 Apr 19 - Jul 19 Total
    Adult Education Budget - Traineeships and Other Learning AEBT-746 £31,120 £20,721 £51,841
    Adult Education Budget - Community Learning AEBC-746 £18,129 £21,928 £40,057
    Adult Education Budget - Learner Support AEBL-746 £22,479 £15,591 £38,070
    Total: £129,968
    Total Funding for this contract: £395,556

    Funding Agreement Adult Education Budget - Traineeships and Other Learning
    Provider: 10017746 Co Ltd UKPRN: 10017746
    Master Contract Ref: ESFA-746 Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: AEBT-746
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Adult Education - Traineeships and Other Learning £51,841 £7,095 £4,527 £58 £3,402 £7,160 £111 £7,467 £1,300 £1,789 £4,050 £7,330 £7,552
    Total Funding £51,841 £7,095 £4,527 £58 £3,402 £7,160 £111 £7,467 £1,300 £1,789 £4,050 £7,330 £7,552
    Ref (for internal use only):  AEBP-746 v3
    Page 1 of 1 of this Funding Agreement

    Funding Agreement Adult Education Budget - Community Learning
    Provider: 10017746 Co Ltd UKPRN: 10017746
    Master Contract Ref: ESFA-746 Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: AEBC-746
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Adult Education Budget - Community Learning £40,057 £2,265 £1,606 £7,806 £2,997 £1,521 £110 £121 £1,703 £7,021 £6,968 £5,015 £2,924
    Total Funding £40,057 £2,265 £1,606 £7,806 £2,997 £1,521 £110 £121 £1,703 £7,021 £6,968 £5,015 £2,924
    Ref (for internal use only):  AEBP-746 v3
    Page 1 of 1 of this Funding Agreement

    Funding Agreement Adult Education Budget - Learner Support
    Provider: 10017746 Co Ltd UKPRN: 10017746
    Master Contract Ref: ESFA-746 Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: AEBL-746
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Adult Education Budget - Learner Support £38,070 £3,853 £7,271 £1,241 £3,428 £594 £3,259 £1,103 £1,730 £5,689 £3,874 £3,481 £2,547
    Total Funding £38,070 £3,853 £7,271 £1,241 £3,428 £594 £3,259 £1,103 £1,730 £5,689 £3,874 £3,481 £2,547
    Ref (for internal use only):  AEBP-746 v3
    Page 1 of 1 of this Funding Agreement
    """




   # Retrieve parameters for 1920
   #Given I retrieve the latest EFA contract details from CRM for provider '10017746' for FundingType 'AEB' and period '1920' and Delivery Organisation '10017746'
    Given I retrieve the latest contract details from CRM for provider '10017746' for FundingType 'AEB' and period '1920'  

    # Check the Summary of Funding data for 1920 in the 1819 AEB Sharepoint folder
	Then  the pdf file contains the following page lines in order
	"""
	Allocation
    1 August 2019 to 31 July 2020 Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 Total
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AEBR] £34,645 £7,885 £42,530
    ESFA AEB - Adult Skills [AllocRef_AEBA] £26,649 £19,540 £46,189
    ESFA AEB - Community Learning [AllocRef_AEBC] £44,040 £19,477 £63,517
    ESFA AEB - 19 to 24 Traineeships Learner Support [AllocRef_AETL] £41,434 £20,037 £61,471
    ESFA AEB - Adult Skills Learner Support [AllocRef_AEAL] £30,314 £21,567 £51,881
    Total: £265,588
	"""

    # There should not be a zero value entry in the doc for Sector-based Work Academies. These are 2021+ (30680)
    And   the pdf file does not contain the following text
    """
    of which Sector-based Work Academies £0 £0 £0
    """
    
    
    # Save a copy of the output
   #And   Sharepoint file '10017nnn_[ContractNo]_vx.pdf' in 'xxx-nnnn-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017nnn_[ContractNo]_vx.pdf'
    And   Sharepoint file '10017746_AEBP-746_v3.pdf' in 'AEB-1819-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A746v3.pdf'




    # Change the date
    Given the override date is '19/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
	And   the latest version of contract 'AEBP-746' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for version '3' actual MasterContractNumber 'ESFA-746' and actual ContractNumber 'AEBP-746'
   #When  an AEB contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '3'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-746' and ContractNumber 'AEBP-746' and Version '3'

    # Check that the contract is now approved
   #Then  the latest version of contract 'AEBP-746' is in status 'Approved'
	Then  the latest version of contract 'AEBP-746' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017746 | AEBP-746           | 3                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017746 | AEBP-746           | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017746 | AEBP-746           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017746 | ESFA-746           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Non-Financial VARIATION amendment on v3 of the 1819 contract to create v4
   #When  a request is raised by advisor 'FCS2 Test' against version '3' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '3' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '3' subversion '0' of contract 'AEBP-746' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017746 | AEBP-746           | 4                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017746 | AEBP-746           | 3                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017746 | AEBP-746           | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017746 | AEBP-746           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017746 | ESFA-746           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |


   # Retrieve parameters for 1819
   #Given I retrieve the latest EFA contract details from CRM for provider '10017746' for FundingType 'AEB' and period '1819' and Delivery Organisation '10017746'
    Given I retrieve the latest contract details from CRM for provider '10017746' for FundingType 'AEB' and period '1819'  

    # Check the Summary of Funding data for 1819
	Then  a file for this contract exists in sharepoint location 'AEB-1819-Input-Appendices'
	And   the pdf file contains the following page lines in order
	"""
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017746 Co Ltd UKPRN: 10017746
    Master Contract Number: ESFA-746
    Allocation
    1 August 2018 to 31 July 2019 Contract Ref Aug 18 - Mar 19 Apr 19 - Jul 19 Total
    Adult Education Budget - Traineeships and Other Learning AEBT-746 £31,120 £20,721 £51,841
    Adult Education Budget - Community Learning AEBC-746 £18,129 £21,928 £40,057
    Adult Education Budget - Learner Support AEBL-746 £22,479 £15,591 £38,070
    Total: £129,968
	Total Funding for this contract: £395,556
	"""

   # Retrieve parameters for 1920
   #Given I retrieve the latest EFA contract details from CRM for provider '10017746' for FundingType 'AEB' and period '1920' and Delivery Organisation '10017746'
    Given I retrieve the latest contract details from CRM for provider '10017746' for FundingType 'AEB' and period '1920'  

    # Check the Summary of Funding data for 1920
	Then  the pdf file contains the following page lines in order
	"""
	Allocation
    1 August 2019 to 31 July 2020 Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 Total
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AEBR] £34,645 £7,885 £42,530
    ESFA AEB - Adult Skills [AllocRef_AEBA] £26,649 £19,540 £46,189
    ESFA AEB - Community Learning [AllocRef_AEBC] £44,040 £19,477 £63,517
    ESFA AEB - 19 to 24 Traineeships Learner Support [AllocRef_AETL] £41,434 £20,037 £61,471
    ESFA AEB - Adult Skills Learner Support [AllocRef_AEAL] £30,314 £21,567 £51,881
    Total: £265,588
	"""

    # There should not be a zero value entry in the doc for Sector-based Work Academies. These are 2021+ (30680)
    And   the pdf file does not contain the following text
    """
    of which Sector-based Work Academies £0 £0 £0
    """


    # Tidy up
    And   the override date is reset 

@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run67
Scenario: A747 Create and approve a 1718 AEBP contract. Create draft 1819 AEBP contract then update draft and check docs. Approve. Create draft 1920 AEBP contract then update draft and check docs. Approve. Amend 1819. Fail: MBR-005
    Given there are no allocations marked as Under Termination for UKPRN '10017747' 
    And   there are no terminated or closed allocations for UKPRN '10017747' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017747' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    Given there are no Sector-based Work Academies profile values in config for UKPRN '10017747'



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017747' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017747 Co Ltd' with UKPRN '10017747' and OrgId 'ORG0017747' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017747' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017747 | 117747 | 10017747 Co Ltd | 0              | Provider Under Change | Yes           | AA017747      | ?             | 8 Beaumont Gate        | Shenley Hill           | ?                      | ?                      | Radlett                | Hertfordshire          | WD7 7AR   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017747 |




    # Change the date
    Given the override date is '01/10/2017'

    # Create contract for 1718 AEBP
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017747 | 10017747 Co Ltd      | ESFA-747             | AEBP-7471      | 1                     | 01/11/2017        | 31/07/2018      | 46807.00      |                                    | Contract for Services                      | 1718   | New          | ORG0017747 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017747 | AEBP-7471      | AEBC-7471     | AEB-CL            | AEB-CL1718              | AY                      | 01/11/2017          | 31/07/2018        | 21205.00        |                                         |            |                                                             | New          |             |
    | 10017747 | AEBP-7471      | AEBL-7471     | AEB-LS            | AEB-LS1718              | AY                      | 01/11/2017          | 31/07/2018        | 14497.00        |                                         |            |                                                             | New          |             |
    | 10017747 | AEBP-7471      | AEBT-7471     | AEB-TOL           | AEB-TOL1718             | AY                      | 01/11/2017          | 31/07/2018        | 11105.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017747 | AEBP-7471      | AEBC-7471     | 1               | 0                     | 21205.00  | 3218.00  | 3193.00  | 2284.00  | 1311.00  | 3248.00  | 1138.00  | 2032.00  | 3050.00  | 1731.00  | Adult Education Budget - Community Learning                     | New          |             |
    | 10017747 | AEBP-7471      | AEBL-7471     | 1               | 0                     | 14497.00  | 654.00   | 3352.00  | 3643.00  | 1785.00  | 940.00   | 758.00   | 323.00   | 1627.00  | 1415.00  | Adult Education Budget - Learner Support                        | New          |             |
    | 10017747 | AEBP-7471      | AEBT-7471     | 1               | 0                     | 11105.00  | 805.00   | 2362.00  | 410.00   | 829.00   | 553.00   | 1383.00  | 1611.00  | 2663.00  | 489.00   | Adult Education - Traineeships and Other Learning Total Funding | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/10/2017'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-7471' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  an AEB contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-747' and actual ContractNumber 'AEBP-7471'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-7471' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017747 | AEBP-7471          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/11/2017        | 31/07/2018      | ?             |
    | 10017747 | ESFA-747           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/11/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'AEBP-7471'




    # Change the date
    Given the override date is '01/07/2018'

    # Create contract for 1819 AEBP
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent     | OrgId      |
    | 10017747 | 10017747 Co Ltd      | ESFA-747             | AEBP-7472      | 1                     | 01/08/2018        | 31/07/2019      | 68332.00      |                                    | Contract for Services                      | 1819   | New Amendment | ORG0017747 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017747 | AEBP-7472      | AEBC-7472     | AEB-CL            | AEB-CL1819              | AY                      | 01/08/2018          | 31/07/2019        | 17699.00        |                                         |            |                                                             | New          |             |
    | 10017747 | AEBP-7472      | AEBL-7472     | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 24872.00        |                                         |            |                                                             | New          |             |
    | 10017747 | AEBP-7472      | AEBT-7472     | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 25761.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017747 | AEBP-7472      | AEBC-7472     | 1               | 0                     | 17699.00  | 1597.00  | 2016.00  | 1740.00  | 2570.00  | 79.00    | 1132.00  | 1676.00  | 1779.00  | 2451.00  | 435.00   | 64.00    | 2160.00  | Adult Education Budget - Community Learning                     | New          |             |
    | 10017747 | AEBP-7472      | AEBL-7472     | 1               | 0                     | 24872.00  | 437.00   | 2755.00  | 3204.00  | 872.00   | 1450.00  | 699.00   | 2952.00  | 2611.00  | 2651.00  | 2532.00  | 2888.00  | 1821.00  | Adult Education Budget - Learner Support                        | New          |             |
    | 10017747 | AEBP-7472      | AEBT-7472     | 1               | 0                     | 25761.00  | 3689.00  | 502.00   | 1678.00  | 3585.00  | 3530.00  | 976.00   | 255.00   | 452.00   | 3560.00  | 1638.00  | 3704.00  | 2192.00  | Adult Education - Traineeships and Other Learning Total Funding | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'




    # Upsert the provider config values for Sector-based Work Academies for a specific UKPRN and FSP (DocumentsDomain.ContractReferenceConfig) (30680)
    #   These details should not appear in the doc
    Given the following Sector-based Work Academies profile values exist in config
    | UKPRN    | FSPCode       | Aug20-Mar21 | Apr21-Jul21 |
    | 10017747 | AEB-AS2021    | 2000.00     | 500.00      |
    
    
    
    # Change the date
    Given the override date is '05/07/2018'
	
    # Bulk update draft the 1819 AEBP contract
    Given there are no files prefixed '10017747' in the Sharepoint 'AEB-1819-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1819 27062019092011 v3_A747_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1819 27062019092011 v3_A747_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1819 27062019092011 v3_A747_1.xlsx' exists in the Datafiles folder and UKPRN '10017747' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017747 | AEBP-7472          | 1                     | 1                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017747 | AEBP-7472          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    #
    | 10017747 | AEBP-7471          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/11/2017        | 31/07/2018      | ?             |
    | 10017747 | ESFA-747           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/11/2017        | 31/07/2018      | ?             |

   # Retrieve parameters
   #Given I retrieve the latest EFA contract details from CRM for provider '10017747' for FundingType 'AEB' and period '1819' and Delivery Organisation '10017747'
    Given I retrieve the latest contract details from CRM for provider '10017747' for FundingType 'AEB' and period '1819'  

    # Check the docs
    Then  a file for this contract exists in sharepoint location 'AEB-1819-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017747 Co Ltd UKPRN: 10017747
    Master Contract Number: ESFA-747
	Allocation
    1 November 2017 to 31 July 2018 Contract Ref Nov 17 - Mar 18 Apr 18 - Jul 18 Total
	Adult Education Budget - Traineeships and Other Learning AEBT-7471 £4,959 £6,146 £11,105
    Adult Education Budget - Community Learning AEBC-7471 £13,254 £7,951 £21,205
    Adult Education Budget - Learner Support AEBL-7471 £10,374 £4,123 £14,497
    Total: £46,807
    Allocation
    1 August 2018 to 31 July 2019 Contract Ref Aug 18 - Mar 19 Apr 19 - Jul 19 Total
    Adult Education Budget - Traineeships and Other Learning AEBT-7472 £39,415 £13,997 £53,412
    Adult Education Budget - Community Learning AEBC-7472 £42,810 £20,724 £63,534
    Adult Education Budget - Learner Support AEBL-7472 £41,921 £17,361 £59,282
    Total: £176,228
	Total Funding for this contract: £223,035
    
    Funding Agreement Adult Education Budget - Traineeships and Other Learning
    Provider: 10017747 Co Ltd UKPRN: 10017747
    Master Contract Ref: ESFA-747 Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: AEBT-7472
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Adult Education - Traineeships and Other Learning £53,412 £3,303 £2,846 £6,328 £1,722 £5,479 £6,381 £5,786 £7,570 £108 £2,369 £5,649 £5,871
    Total Funding £53,412 £3,303 £2,846 £6,328 £1,722 £5,479 £6,381 £5,786 £7,570 £108 £2,369 £5,649 £5,871
    Ref (for internal use only):  AEBP-7472 v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement Adult Education Budget - Community Learning
    Provider: 10017747 Co Ltd UKPRN: 10017747
    Master Contract Ref: ESFA-747 Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: AEBC-7472
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Adult Education Budget - Community Learning £63,534 £7,804 £7,145 £5,394 £585 £7,060 £5,648 £7,772 £1,402 £6,720 £6,667 £4,714 £2,623
    Total Funding £63,534 £7,804 £7,145 £5,394 £585 £7,060 £5,648 £7,772 £1,402 £6,720 £6,667 £4,714 £2,623
    Ref (for internal use only):  AEBP-7472 v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement Adult Education Budget - Learner Support
    Provider: 10017747 Co Ltd UKPRN: 10017747
    Master Contract Ref: ESFA-747 Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: AEBL-7472
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Adult Education Budget - Learner Support £59,282 £320 £3,738 £5,659 £7,846 £5,012 £7,677 £5,521 £6,148 £2,156 £341 £7,899 £6,965
    Total Funding £59,282 £320 £3,738 £5,659 £7,846 £5,012 £7,677 £5,521 £6,148 £2,156 £341 £7,899 £6,965
    Ref (for internal use only):  AEBP-7472 v1
    Page 1 of 1 of this Funding Agreement
    """

    # There shouldn't be a zero value entry in the doc for Sector-based Work Academies. These are 2021+ (30680)
    And   the pdf file does not contain the following text
    """
    of which Sector-based Work Academies £0 £0 £0
    """

    # There should not be an entry in the doc for Sector-based Work Academies. These are 2021+ (30680)
    And   the pdf file does not contain the following text
    """
    of which Sector-based Work Academies £2,000 £500 £2,500
    """

    # Save a copy of the output
   #And   Sharepoint file '10017nnn_[ContractNo]_vx.pdf' in 'xxx-nnnn-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017nnn_[ContractNo]_vx.pdf'
    And   Sharepoint file '10017747_AEBP-7472_v1.pdf' in 'AEB-1819-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A7472v1.pdf'




    # Change the date
    Given the override date is '09/07/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
	And   the latest version of contract 'AEBP-7472' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  an AEB contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-747' and actual ContractNumber 'AEBP-7472'

    # Check that the contract is now approved
   #Then  the latest version of contract '[ContractNo]' is in status 'Approved'
    Then  the latest version of contract 'AEBP-7472' is in status 'Approved'


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017747 | AEBP-7472          | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017747 | AEBP-7472          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    #
	| 10017747 | AEBP-7471          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/11/2017        | 31/07/2018      | ?             |
    | 10017747 | ESFA-747           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/11/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract number 'AEBP-7472'

	


    # Change the date
    Given the override date is '01/07/2019'

    # Create contract for 1920 AEBP
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent      | OrgId      |
    | 10017747 | 10017747 Co Ltd      | ESFA-747             | AEBP-7473      | 1                     | 01/08/2019        | 31/07/2020      | 116781.00     |                                    | Contract for Services                      | 1920   | New Amendment  | ORG0017747 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017747 | AEBP-7473      | AEAL-7473     | AEB-ASLS          | AEB-ASLS1920            | AY                      | 01/08/2019          | 31/07/2020        | 24998.00        |                                         |            |                                                             | New          |             |
    | 10017747 | AEBP-7473      | AEBA-7473     | AEB-AS            | AEB-AS1920              | AY                      | 01/08/2019          | 31/07/2020        | 26869.00        |                                         |            |                                                             | New          |             |
    | 10017747 | AEBP-7473      | AEBC-7473     | AEB-CL            | AEB-CL1920              | AY                      | 01/08/2019          | 31/07/2020        | 22039.00        |                                         |            |                                                             | New          |             |
    | 10017747 | AEBP-7473      | AEBR-7473     | AEB-19TRN         | AEB-19TRN1920           | AY                      | 01/08/2019          | 31/07/2020        | 20127.00        |                                         |            |                                                             | New          |             |
    | 10017747 | AEBP-7473      | AETL-7473     | AEB-19TRLS        | AEB-19TRLS1920          | AY                      | 01/08/2019          | 31/07/2020        | 22748.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017747 | AEBP-7473      | AEAL-7473     | 1               | 0                     | 24998.00  | 241.00   | 1832.00  | 2726.00  | 3744.00  | 2425.00  | 3665.00  | 2662.00  | 2954.00  | 1096.00  | 251.00   | 68.00    | 3334.00  | Adult Education Budget - Adult Skills Learner Support           | New          |             |
    | 10017747 | AEBP-7473      | AEBA-7473     | 1               | 0                     | 26869.00  | 2322.00  | 2109.00  | 3730.00  | 1585.00  | 3334.00  | 53.00    | 3478.00  | 607.00   | 834.00   | 1887.00  | 3413.00  | 3517.00  | Adult Skills Total Funding                                      | New          |             |
    | 10017747 | AEBP-7473      | AEBC-7473     | 1               | 0                     | 22039.00  | 1641.00  | 2343.00  | 1973.00  | 367.00   | 1483.00  | 2818.00  | 549.00   | 1918.00  | 1513.00  | 762.00   | 3015.00  | 3657.00  | Adult Education Budget - Community Learning                     | New          |             |
    | 10017747 | AEBP-7473      | AEBR-7473     | 1               | 0                     | 20127.00  | 2072.00  | 1953.00  | 2309.00  | 1241.00  | 743.00   | 1256.00  | 3416.00  | 639.00   | 584.00   | 1731.00  | 1993.00  | 2190.00  | 19-24 Traineeships Total Funding                                | New          |             |
    | 10017747 | AEBP-7473      | AETL-7473     | 1               | 0                     | 22748.00  | 2981.00  | 1059.00  | 2141.00  | 1612.00  | 481.00   | 2892.00  | 3060.00  | 822.00   | 2853.00  | 3179.00  | 466.00   | 1202.00  | Adult Education Budget - 19-24 Traineeships Learner Support     | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'
   
    # Change the date
    Given the override date is '05/07/2019'
	
    # Bulk update draft the 1920 AEBP contract
	Given there are no files prefixed '10017747' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1920 27062019094711 v3_A747_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1920 27062019094711 v3_A747_2' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1920 27062019094711 v3_A747_2.xlsx' exists in the Datafiles folder and UKPRN '10017747' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017747 | AEBP-7473          | 1                     | 1                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017747 | AEBP-7473          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | ?             |
    #
	| 10017747 | AEBP-7472          | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017747 | AEBP-7472          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    #
	| 10017747 | AEBP-7471          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/11/2017        | 31/07/2018      | ?             |
    | 10017747 | ESFA-747           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/11/2017        | 31/07/2018      | ?             |



   # Retrieve parameters
   #Given I retrieve the latest EFA contract details from CRM for provider '10017747' for FundingType 'AEB' and period '1920' and Delivery Organisation '10017747'
    Given I retrieve the latest contract details from CRM for provider '10017747' for FundingType 'AEB' and period '1920'  

    # Check the docs
    Then  a file for this contract exists in sharepoint location 'AEB-1920-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017747 Co Ltd UKPRN: 10017747
    Master Contract Number: ESFA-747
    Allocation
    1 November 2017 to 31 July 2018 Contract Ref Nov 17 - Mar 18 Apr 18 - Jul 18 Total
    Adult Education Budget - Traineeships and Other Learning AEBT-7471 £4,959 £6,146 £11,105
    Adult Education Budget - Community Learning AEBC-7471 £13,254 £7,951 £21,205
    Adult Education Budget - Learner Support AEBL-7471 £10,374 £4,123 £14,497
    Total: £46,807
    Allocation
    1 August 2018 to 31 July 2019 Contract Ref Aug 18 - Mar 19 Apr 19 - Jul 19 Total
    Adult Education Budget - Traineeships and Other Learning AEBT-7472 £39,415 £13,997 £53,412
    Adult Education Budget - Community Learning AEBC-7472 £42,810 £20,724 £63,534
    Adult Education Budget - Learner Support AEBL-7472 £41,921 £17,361 £59,282
    Total: £176,228
    Allocation
    1 August 2019 to 31 July 2020 Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 Total
    ESFA AEB - 19 to 24 Traineeships AEBR-7473 £39,958 £8,429 £48,387
    ESFA AEB - Adult Skills AEBA-7473 £42,479 £19,505 £61,984
    ESFA AEB - Community Learning AEBC-7473 £38,849 £26,695 £65,544
    ESFA AEB - 19 to 24 Traineeships Learner Support AETL-7473 £24,944 £11,794 £36,738
    ESFA AEB - Adult Skills Learner Support AEAL-7473 £28,636 £19,478 £48,114
    Total: £260,767
    Total Funding for this contract: £483,802

    Funding Agreement ESFA-Funded Adult Education Budget - 19 to 24 Traineeships
    Provider: 10017747 Co Ltd UKPRN: 10017747
    Master Contract Number: ESFA-747 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: AEBR-7473
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - 19 to 24 Traineeships £48,387 £2,063 £5,480 £7,401 £1,638 £6,754 £1,468 £7,264 £7,890 £3,899 £2,083 £1,691 £756
    Total Funding £48,387 £2,063 £5,480 £7,401 £1,638 £6,754 £1,468 £7,264 £7,890 £3,899 £2,083 £1,691 £756
    Ref (for internal use only):  AEBP-7473 v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - Adult Skills
    Provider: 10017747 Co Ltd UKPRN: 10017747
    Master Contract Number: ESFA-747 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: AEBA-7473
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills £61,984 £4,680 £4,223 £7,705 £3,098 £6,856 £7,758 £7,163 £996 £1,485 £3,746 £7,026 £7,248
    Total Funding £61,984 £4,680 £4,223 £7,705 £3,098 £6,856 £7,758 £7,163 £996 £1,485 £3,746 £7,026 £7,248
    Ref (for internal use only):  AEBP-7473 v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - Community Learning
    Provider: 10017747 Co Ltd UKPRN: 10017747
    Master Contract Number: ESFA-747 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: AEBC-7473
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Community Learning £65,544 £7,635 £7,380 £193 £5,851 £4,779 £5,883 £2,571 £4,557 £4,439 £6,902 £7,465 £7,889
    Total Funding £65,544 £7,635 £7,380 £193 £5,851 £4,779 £5,883 £2,571 £4,557 £4,439 £6,902 £7,465 £7,889
    Ref (for internal use only):  AEBP-7473 v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - 19 to 24 Traineeships Learner Support
    Provider: 10017747 Co Ltd UKPRN: 10017747
    Master Contract Number: ESFA-747 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: AETL-7473
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - 19 to 24 Traineeships Learner Support £36,738 £1,595 £936 £7,136 £2,327 £851 £7,391 £1,563 £3,145 £512 £459 £6,457 £4,366
    Total Funding £36,738 £1,595 £936 £7,136 £2,327 £851 £7,391 £1,563 £3,145 £512 £459 £6,457 £4,366
    Ref (for internal use only):  AEBP-7473 v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - Adult Skills Learner Support
    Provider: 10017747 Co Ltd UKPRN: 10017747
    Master Contract Number: ESFA-747 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: AEAL-7473
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills Learner Support £48,114 £1,602 £3,110 £2,314 £6,815 £1,262 £4,129 £7,207 £2,197 £1,327 £7,664 £4,554 £5,933
    Total Funding £48,114 £1,602 £3,110 £2,314 £6,815 £1,262 £4,129 £7,207 £2,197 £1,327 £7,664 £4,554 £5,933
    Ref (for internal use only):  AEBP-7473 v1
    Page 1 of 1 of this Funding Agreement
    """

    # There shouldn't be a zero value entry in the doc for Sector-based Work Academies. These are 2021+ (30680)
    And   the pdf file does not contain the following text
    """
    of which Sector-based Work Academies £0 £0 £0
    """

    # There should not be an entry in the doc for Sector-based Work Academies. These are 2021+ (30680)
    And   the pdf file does not contain the following text
    """
    of which Sector-based Work Academies £2,000 £500 £2,500
    """


    # Save a copy of the output
   #And   Sharepoint file '10017nnn_[ContractNo]_vx.pdf' in 'xxx-nnnn-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017nnn_[ContractNo]_vx.pdf'
    And   Sharepoint file '10017747_AEBP-7473_v1.pdf' in 'AEB-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A7473v1.pdf'




    # Change the date
    Given the override date is '22/07/2019'
	
    # Bulk amend the 1819 AEBP contract to create a draft v2
    Given there are no files prefixed '10017747' in the Sharepoint 'AEB-1819-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1819 27062019100557 v3_A747_3' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1819 27062019100557 v3_A747_3' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1819 27062019100557 v3_A747_3.xlsx' exists in the Datafiles folder and UKPRN '10017747' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
  # And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # MBR-005 (26146)
    And   '[Contract] This Master Contract cannot have more than one associated Contract in a draft status at the same time' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the CONTRACT version, status and dates in CRM. This should not have changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017747 | AEBP-7473          | 1                     | 1                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017747 | AEBP-7473          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | ?             |
    #
	| 10017747 | AEBP-7472          | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017747 | AEBP-7472          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    #
	| 10017747 | AEBP-7471          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/11/2017        | 31/07/2018      | ?             |
    | 10017747 | ESFA-747           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/11/2017        | 31/07/2018      | ?             |


    # Tidy Up
    Given the override date is reset

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017747'

@AcceptanceTest @Withdrawn20200717
Scenario: A748 Bulk create a short 1718 AEBP contract. Check docs
    Given there are no allocations marked as Under Termination for UKPRN '10017748' 
    And   there are no terminated or closed allocations for UKPRN '10017748' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017748' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017748' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017748 Co Ltd' with UKPRN '10017748' and OrgId 'ORG0017748' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017748' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status    | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017748 | 117748 | 10017748 Co Ltd | 0              | Active    | Yes           | AA017748      | ?             | 3 Merchants Place      | ?                      | ?                      | ?                      | Reading                | Berkshire              | RG1 1DP   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017748 |




    # Change the date
    Given the override date is '17/12/2017'

    # Bulk load a new 1718 AEB contract 1/2/18 to 31/04/18
    And   there are no files prefixed '10017748' in the Sharepoint 'AEB-1718-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1718 04072019152333 v3_A748' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1718 04072019152333 v3_A748' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1718 04072019152333 v3_A748' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1718 04072019152333 v3_A748.xlsx' exists in the Datafiles folder and UKPRN '10017748' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #Given I retrieve the latest EFA contract details from CRM for provider '10017748' for FundingType 'AEB' and period '1718' and Delivery Organisation '10017748'
    Given I retrieve the latest contract details from CRM for provider '10017748' for FundingType 'AEB' and period '1718'  

    # Check the Summary of Funding
    Then  a file for this contract exists in sharepoint location 'AEB-1718-Input-Appendices'
    And   the pdf file contains the following page lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017748 Co Ltd UKPRN: 10017748
    Master Contract Number: [MasterContractNo]
    Allocation
    1 November 2017 to 31 July 2018 Contract Ref Nov 17 - Mar 18 Apr 18 - Jul 18 Total
    Adult Education Budget - Traineeships and Other Learning [AllocRef_AEBT] £9,770 £5,155 £14,925
    Adult Education Budget - Community Learning [AllocRef_AEBC] £2,991 £7,366 £10,357
    Adult Education Budget - Learner Support [AllocRef_AEBL] £6,000 £850 £6,850
    Total: £32,132
    Total Funding for this contract: £32,132
    """
	
    # Change the date
    Given the override date is '03/01/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  an AEB contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
   #When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-747' and actual ContractNumber 'AEBP-7471'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'


	# Tidy up
	And   the override date is reset

@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run67
Scenario: A749 Create and approve a 1920 EDSK contract with PoP allocations. Generate PoP payments. Check CRM, PaaS, CDA and payment feed
    Given there are no allocations marked as Under Termination for UKPRN '10017749' 
    And   there are no terminated or closed allocations for UKPRN '10017749' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017749' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS for an Allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16ED-749      |
    | AECT-749      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | 1619ED1920     |
    | AEBC-19TRN1920 |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017749' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017749 Co Ltd' with UKPRN '10017749' and OrgId 'ORG0017749' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017749' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status     | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017749 | 117749 | 10017749 Co Ltd | 0              | Active     | Yes           | AA017749      | ?             | 60 Wolf Lane           | ?                      | ?                      | ?                      | Windsor                | Berkshire              | SL4 4YZ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017749 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017749 | 10017749 Co Ltd      | ESFA-749             | EDSK-749       | 1                     | 01/08/2019        | 31/07/2020      | 34358.33      |                                    | Conditions of Funding (Grant) (Employer)   | 1920   | New          | ORG0017749 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017749 | EDSK-749       | 16ED-749      | 1619ED            | 1619ED1920              | AY                      | 01/08/2019          | 31/07/2020        | 12266.33        |                                         |            |                                                             | New          |             |
    | 10017749 | EDSK-749       | AECT-749      | AEBC-19TRN        | AEBC-19TRN1920          | AY                      | 01/08/2019          | 31/07/2020        | 22092.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017749 | EDSK-749       | 16ED-749      | 124             | 0                     | 4436.02   | 0.00     | 3341.96  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1094.06  | 0.00     | 0.00     | SSF Programme Funding                                           | New          |             |
    | 10017749 | EDSK-749       | 16ED-749      | 125             | 0                     | 3536.16   | 0.00     | 0.00     | 444.58   | 0.00     | 1429.83  | 1661.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | Young Offenders Institute                                       | New          |             |
    | 10017749 | EDSK-749       | 16ED-749      | 20              | 0                     | 4294.15   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 206.52   | 1190.25  | 2643.88  | 0.00     | 0.00     | 253.50   | 0.00     | 16-19 Programme Funding                                         | New          |             |
    | 10017749 | EDSK-749       | AECT-749      | 1               | 0                     | 22092.00  | 533.00   | 509.00   | 3300.00  | 2327.00  | 563.00   | 2154.00  | 3048.00  | 365.00   | 2747.00  | 286.00   | 2984.00  | 3276.00  | 19-24 Traineeships Total Funding                                | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-749' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-749' and actual ContractNumber 'EDSK-749'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-749' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017749 | EDSK-749           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017749 | ESFA-749           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '72' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'EDSK-749'



    # Check the PoP allocation data in CRM and PaaS for the two PoP allocations

    # Check the PROFILE PAYMENTS in CRM
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-749       | 16ED-749        | 124             | 4436.02   | 0.00     | 3341.96  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1094.06  | 0.00     | 0.00     | 
    | EDSK-749       | 16ED-749        | 125             | 3536.16   | 0.00     | 0.00     | 444.58   | 0.00     | 1429.83  | 1661.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-749       | 16ED-749        | 20              | 4294.15   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 206.52   | 1190.25  | 2643.88  | 0.00     | 0.00     | 253.50   | 0.00     | 
    #
    | EDSK-749       | AECT-749        | 1               | 22092.00  | 533.00   | 509.00   | 3300.00  | 2327.00  | 563.00   | 2154.00  | 3048.00  | 365.00   | 2747.00  | 286.00   | 2984.00  | 3276.00  | 
    | EDSK-749       | AECT-749        | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-749       | AECT-749        | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | EDSK-749       | 16ED-749        | 124             | 4436.02   | 0.00     | 3341.96  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 1094.06  | 0.00     | 0.00     | 
    | EDSK-749       | 16ED-749        | 125             | 3536.16   | 0.00     | 0.00     | 444.58   | 0.00     | 1429.83  | 1661.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-749       | 16ED-749        | 20              | 4294.15   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 206.52   | 1190.25  | 2643.88  | 0.00     | 0.00     | 253.50   | 0.00     | 
    #
    | EDSK-749       | AECT-749        | 1               | 22092.00  | 533.00   | 509.00   | 3300.00  | 2327.00  | 563.00   | 2154.00  | 3048.00  | 365.00   | 2747.00  | 286.00   | 2984.00  | 3276.00  | 
    | EDSK-749       | AECT-749        | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-749       | AECT-749        | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | 16ED-749         | 1             | 124             | 201908 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 125             | 201908 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 20              | 201908 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 124             | 201909 | 2              | 0             | 3341.96      | 3341.96              | 0.00                | 0.00                   | 0.00                        | 3341.96          | ?            | ?           |
    | 16ED-749         | 1             | 125             | 201909 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 20              | 201909 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 124             | 201910 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 125             | 201910 | 2              | 0             | 444.58       | 444.58               | 0.00                | 0.00                   | 0.00                        | 444.58           | ?            | ?           |
    | 16ED-749         | 1             | 20              | 201910 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 124             | 201911 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 125             | 201911 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 20              | 201911 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 124             | 201912 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 125             | 201912 | 2              | 0             | 1429.83      | 1429.83              | 0.00                | 0.00                   | 0.00                        | 1429.83          | ?            | ?           |
    | 16ED-749         | 1             | 20              | 201912 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 124             | 202001 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 125             | 202001 | 2              | 0             | 1661.75      | 1661.75              | 0.00                | 0.00                   | 0.00                        | 1661.75          | ?            | ?           |
    | 16ED-749         | 1             | 20              | 202001 | 2              | 0             | 206.52       | 206.52               | 0.00                | 0.00                   | 0.00                        | 206.52           | ?            | ?           |
    | 16ED-749         | 1             | 124             | 202002 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 125             | 202002 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 20              | 202002 | 2              | 0             | 1190.25      | 1190.25              | 0.00                | 0.00                   | 0.00                        | 1190.25          | ?            | ?           |
    | 16ED-749         | 1             | 124             | 202003 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 124             | 202003 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 20              | 202003 | 2              | 0             | 2643.88      | 2643.88              | 0.00                | 0.00                   | 0.00                        | 2643.88          | ?            | ?           |
    | 16ED-749         | 1             | 124             | 202004 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 125             | 202004 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 20              | 202004 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 124             | 202005 | 2              | 0             | 1094.06      | 1094.06              | 0.00                | 0.00                   | 0.00                        | 1094.06          | ?            | ?           |
    | 16ED-749         | 1             | 125             | 202005 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 20              | 202005 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 124             | 202006 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 125             | 202006 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 20              | 202006 | 2              | 0             | 253.50       | 253.50               | 0.00                | 0.00                   | 0.00                        | 253.50           | ?            | ?           |
    | 16ED-749         | 1             | 124             | 202007 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 125             | 202007 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | 16ED-749         | 1             | 20              | 202007 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    #
    | AECT-749         | 1             | 1               | 201908 | 2              | 0             | 533.00       | 533.00               | 0.00                | 0.00                   | 0.00                        | 533.00           | ?            | ?           |
    | AECT-749         | 1             | 2               | 201908 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 3               | 201908 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 1               | 201909 | 2              | 0             | 509.00       | 509.00               | 0.00                | 0.00                   | 0.00                        | 509.00           | ?            | ?           |
    | AECT-749         | 1             | 2               | 201909 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 3               | 201909 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 1               | 201910 | 2              | 0             | 3300.00      | 3300.00              | 0.00                | 0.00                   | 0.00                        | 3300.00          | ?            | ?           |
    | AECT-749         | 1             | 2               | 201910 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 3               | 201910 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 1               | 201911 | 2              | 0             | 2327.00      | 2327.00              | 0.00                | 0.00                   | 0.00                        | 2327.00          | ?            | ?           |
    | AECT-749         | 1             | 2               | 201911 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 3               | 201911 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 1               | 201912 | 2              | 0             | 563.00       | 563.00               | 0.00                | 0.00                   | 0.00                        | 563.00           | ?            | ?           |
    | AECT-749         | 1             | 2               | 201912 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 3               | 201912 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 1               | 202001 | 2              | 0             | 2154.00      | 2154.00              | 0.00                | 0.00                   | 0.00                        | 2154.00          | ?            | ?           |
    | AECT-749         | 1             | 2               | 202001 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 3               | 202001 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 1               | 202002 | 2              | 0             | 3048.00      | 3048.00              | 0.00                | 0.00                   | 0.00                        | 3048.00          | ?            | ?           |
    | AECT-749         | 1             | 2               | 202002 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 3               | 202002 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 1               | 202003 | 2              | 0             | 365.00       | 365.00               | 0.00                | 0.00                   | 0.00                        | 365.00           | ?            | ?           |
    | AECT-749         | 1             | 2               | 202003 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 3               | 202003 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 1               | 202004 | 2              | 0             | 2747.00      | 2747.00              | 0.00                | 0.00                   | 0.00                        | 2747.00          | ?            | ?           |
    | AECT-749         | 1             | 2               | 202004 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 3               | 202004 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 1               | 202005 | 2              | 0             | 286.00       | 286.00               | 0.00                | 0.00                   | 0.00                        | 286.00           | ?            | ?           |
    | AECT-749         | 1             | 2               | 202005 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 3               | 202005 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 1               | 202006 | 2              | 0             | 2984.00      | 2984.00              | 0.00                | 0.00                   | 0.00                        | 2984.00          | ?            | ?           |
    | AECT-749         | 1             | 2               | 202006 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 3               | 202006 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 1               | 202007 | 2              | 0             | 3276.00      | 3276.00              | 0.00                | 0.00                   | 0.00                        | 3276.00          | ?            | ?           |
    | AECT-749         | 1             | 2               | 202007 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | AECT-749         | 1             | 3               | 202007 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |

    # Check the PROFILE subnominal aggregations in PaaS
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017749 | ORG0017749 | 16ED-749          | 2481870         | 1619ED1920                 | 201908               | PROFILE         | CM             | False       | 0.00            |
    | 10017749 | ORG0017749 | 16ED-749          | 2481870         | 1619ED1920                 | 201909               | PROFILE         | CM             | False       | 3341.96         |
    | 10017749 | ORG0017749 | 16ED-749          | 2481870         | 1619ED1920                 | 201910               | PROFILE         | CM             | False       | 0.00            |
    | 10017749 | ORG0017749 | 16ED-749          | 2481870         | 1619ED1920                 | 201911               | PROFILE         | CM             | False       | 0.00            |
    | 10017749 | ORG0017749 | 16ED-749          | 2481870         | 1619ED1920                 | 201912               | PROFILE         | CM             | False       | 0.00            |
    | 10017749 | ORG0017749 | 16ED-749          | 2481870         | 1619ED1920                 | 202001               | PROFILE         | CM             | False       | 0.00            |
    | 10017749 | ORG0017749 | 16ED-749          | 2481870         | 1619ED1920                 | 202002               | PROFILE         | CM             | False       | 0.00            |
    | 10017749 | ORG0017749 | 16ED-749          | 2481870         | 1619ED1920                 | 202003               | PROFILE         | CM             | False       | 0.00            |
    | 10017749 | ORG0017749 | 16ED-749          | 2481870         | 1619ED1920                 | 202004               | PROFILE         | CM             | False       | 0.00            |
    | 10017749 | ORG0017749 | 16ED-749          | 2481870         | 1619ED1920                 | 202005               | PROFILE         | CM             | False       | 1094.06         |
    | 10017749 | ORG0017749 | 16ED-749          | 2481870         | 1619ED1920                 | 202006               | PROFILE         | CM             | False       | 0.00            |
    | 10017749 | ORG0017749 | 16ED-749          | 2481870         | 1619ED1920                 | 202007               | PROFILE         | CM             | False       | 0.00            |
    #
    | 10017749 | ORG0017749 | 16ED-749          | 2601011         | 1619ED1920                 | 201908               | PROFILE         | CM             | False       | 0.00            |
    | 10017749 | ORG0017749 | 16ED-749          | 2601011         | 1619ED1920                 | 201909               | PROFILE         | CM             | False       | 0.00            |
    | 10017749 | ORG0017749 | 16ED-749          | 2601011         | 1619ED1920                 | 201910               | PROFILE         | CM             | False       | 444.58          |
    | 10017749 | ORG0017749 | 16ED-749          | 2601011         | 1619ED1920                 | 201911               | PROFILE         | CM             | False       | 0.00            |
    | 10017749 | ORG0017749 | 16ED-749          | 2601011         | 1619ED1920                 | 201912               | PROFILE         | CM             | False       | 1429.83         |
    | 10017749 | ORG0017749 | 16ED-749          | 2601011         | 1619ED1920                 | 202001               | PROFILE         | CM             | False       | 1661.75         |
    | 10017749 | ORG0017749 | 16ED-749          | 2601011         | 1619ED1920                 | 202002               | PROFILE         | CM             | False       | 0.00            |
    | 10017749 | ORG0017749 | 16ED-749          | 2601011         | 1619ED1920                 | 202003               | PROFILE         | CM             | False       | 0.00            |
    | 10017749 | ORG0017749 | 16ED-749          | 2601011         | 1619ED1920                 | 202004               | PROFILE         | CM             | False       | 0.00            |
    | 10017749 | ORG0017749 | 16ED-749          | 2601011         | 1619ED1920                 | 202005               | PROFILE         | CM             | False       | 0.00            |
    | 10017749 | ORG0017749 | 16ED-749          | 2601011         | 1619ED1920                 | 202006               | PROFILE         | CM             | False       | 0.00            |
    | 10017749 | ORG0017749 | 16ED-749          | 2601011         | 1619ED1920                 | 202007               | PROFILE         | CM             | False       | 0.00            |
    #
    | 10017749 | ORG0017749 | AECT-749          | 2355700         | AEBC-19TRN1920             | 201908               | PROFILE         | CM             | False       | 533.00          |
    | 10017749 | ORG0017749 | AECT-749          | 2355700         | AEBC-19TRN1920             | 201909               | PROFILE         | CM             | False       | 509.00          |
    | 10017749 | ORG0017749 | AECT-749          | 2355700         | AEBC-19TRN1920             | 201910               | PROFILE         | CM             | False       | 3300.00         |
    | 10017749 | ORG0017749 | AECT-749          | 2355700         | AEBC-19TRN1920             | 201911               | PROFILE         | CM             | False       | 2327.00         |
    | 10017749 | ORG0017749 | AECT-749          | 2355700         | AEBC-19TRN1920             | 201912               | PROFILE         | CM             | False       | 563.00          |
    | 10017749 | ORG0017749 | AECT-749          | 2355700         | AEBC-19TRN1920             | 202001               | PROFILE         | CM             | False       | 2154.00         |
    | 10017749 | ORG0017749 | AECT-749          | 2355700         | AEBC-19TRN1920             | 202002               | PROFILE         | CM             | False       | 3048.00         |
    | 10017749 | ORG0017749 | AECT-749          | 2355700         | AEBC-19TRN1920             | 202003               | PROFILE         | CM             | False       | 365.00          |
    | 10017749 | ORG0017749 | AECT-749          | 2355700         | AEBC-19TRN1920             | 202004               | PROFILE         | CM             | False       | 2747.00         |
    | 10017749 | ORG0017749 | AECT-749          | 2355700         | AEBC-19TRN1920             | 202005               | PROFILE         | CM             | False       | 286.00          |
    | 10017749 | ORG0017749 | AECT-749          | 2355700         | AEBC-19TRN1920             | 202006               | PROFILE         | CM             | False       | 2984.00         |
    | 10017749 | ORG0017749 | AECT-749          | 2355700         | AEBC-19TRN1920             | 202007               | PROFILE         | CM             | False       | 3276.00         |




#    # Run the CDA report for 1619ED1920
#    Given there is no CDA report named 'CDA Last Approved Version A749b.csv'
#    
#    When  the following CDA report is run
#    | FundingStreamPeriod | Version               | Suffix |
#    | 1619ED1920          | Last Approved Version | A749b  |
#
#    Then  a report named 'CDA Last Approved Version A749b.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | SSF Programme Funding                                           |                                                                 | 8                 | 2019            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2481870           |                          |                   | Aug              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Young Offenders Institute                                       |                                                                 | 8                 | 2019            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2601011           |                          |                   | Aug              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-19 Programme Funding                                         |                                                                 | 8                 | 2019            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2203000           |                          |                   | Aug              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | SSF Programme Funding                                           |                                                                 | 9                 | 2019            | 2019/20       |              | 3341.96      |              |               |              | Yes                | 3341.96        | 0.00             | 0.00                  | 0.00           | 3341.96         |             | No            |                   |        | 2481870           |                          |                   | Sep              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Young Offenders Institute                                       |                                                                 | 9                 | 2019            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2601011           |                          |                   | Sep              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-19 Programme Funding                                         |                                                                 | 9                 | 2019            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2203000           |                          |                   | Sep              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-19 Programme Funding                                         |                                                                 | 10                | 2019            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2203000           |                          |                   | Oct              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Young Offenders Institute                                       |                                                                 | 10                | 2019            | 2019/20       |              | 444.58       |              |               |              | Yes                | 444.58         | 0.00             | 0.00                  | 0.00           | 444.58          |             | No            |                   |        | 2601011           |                          |                   | Oct              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | SSF Programme Funding                                           |                                                                 | 10                | 2019            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2481870           |                          |                   | Oct              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Young Offenders Institute                                       |                                                                 | 11                | 2019            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2601011           |                          |                   | Nov              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-19 Programme Funding                                         |                                                                 | 11                | 2019            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2203000           |                          |                   | Nov              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | SSF Programme Funding                                           |                                                                 | 11                | 2019            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2481870           |                          |                   | Nov              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | SSF Programme Funding                                           |                                                                 | 12                | 2019            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2481870           |                          |                   | Dec              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-19 Programme Funding                                         |                                                                 | 12                | 2019            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2203000           |                          |                   | Dec              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Young Offenders Institute                                       |                                                                 | 12                | 2019            | 2019/20       |              | 1429.83      |              |               |              | Yes                | 1429.83        | 0.00             | 0.00                  | 0.00           | 1429.83         |             | No            |                   |        | 2601011           |                          |                   | Dec              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | SSF Programme Funding                                           |                                                                 | 1                 | 2020            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2481870           |                          |                   | Jan              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Young Offenders Institute                                       |                                                                 | 1                 | 2020            | 2019/20       |              | 1661.75      |              |               |              | Yes                | 1661.75        | 0.00             | 0.00                  | 0.00           | 1661.75         |             | No            |                   |        | 2601011           |                          |                   | Jan              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-19 Programme Funding                                         |                                                                 | 1                 | 2020            | 2019/20       |              | 206.52       |              |               |              | Yes                | 206.52         | 0.00             | 0.00                  | 0.00           | 206.52          |             | No            |                   |        | 2203000           |                          |                   | Jan              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Young Offenders Institute                                       |                                                                 | 2                 | 2020            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2601011           |                          |                   | Feb              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | SSF Programme Funding                                           |                                                                 | 2                 | 2020            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2481870           |                          |                   | Feb              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-19 Programme Funding                                         |                                                                 | 2                 | 2020            | 2019/20       |              | 1190.25      |              |               |              | Yes                | 1190.25        | 0.00             | 0.00                  | 0.00           | 1190.25         |             | No            |                   |        | 2203000           |                          |                   | Feb              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Young Offenders Institute                                       |                                                                 | 3                 | 2020            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2601011           |                          |                   | Mar              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | SSF Programme Funding                                           |                                                                 | 3                 | 2020            | 2019/20       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2481870           |                          |                   | Mar              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-19 Programme Funding                                         |                                                                 | 3                 | 2020            | 2019/20       |              | 2643.88      |              |               |              | Yes                | 2643.88        | 0.00             | 0.00                  | 0.00           | 2643.88         |             | No            |                   |        | 2203000           |                          |                   | Mar              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Young Offenders Institute                                       |                                                                 | 4                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2601011           |                          |                   | Apr              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-19 Programme Funding                                         |                                                                 | 4                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2203000           |                          |                   | Apr              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | SSF Programme Funding                                           |                                                                 | 4                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2481870           |                          |                   | Apr              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | SSF Programme Funding                                           |                                                                 | 5                 | 2020            | 2020/21       |              | 1094.06      |              |               |              | Yes                | 1094.06        | 0.00             | 0.00                  | 0.00           | 1094.06         |             | No            |                   |        | 2481870           |                          |                   | May              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-19 Programme Funding                                         |                                                                 | 5                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2203000           |                          |                   | May              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Young Offenders Institute                                       |                                                                 | 5                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2601011           |                          |                   | May              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Young Offenders Institute                                       |                                                                 | 6                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2601011           |                          |                   | Jun              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | SSF Programme Funding                                           |                                                                 | 6                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2481870           |                          |                   | Jun              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-19 Programme Funding                                         |                                                                 | 6                 | 2020            | 2020/21       |              | 253.5        |              |               |              | Yes                | 253.50         | 0.00             | 0.00                  | 0.00           | 253.50          |             | No            |                   |        | 2203000           |                          |                   | Jun              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | Young Offenders Institute                                       |                                                                 | 7                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2601011           |                          |                   | Jul              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | SSF Programme Funding                                           |                                                                 | 7                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2481870           |                          |                   | Jul              |
#    | 1619ED1920              | 10017749 | 10017749 Co Ltd             |               |                             | 16ED-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 16-19 Programme Funding                                         |                                                                 | 7                 | 2020            | 2020/21       |              | 0            |              |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        | 2203000           |                          |                   | Jul              |
#
#
#
#
#    # Run the CDA report for AEBC-19TRN1920
#    Given there is no CDA report named 'CDA Last Approved Version A749c.csv'
#    
#    When  the following CDA report is run
#    | FundingStreamPeriod | Version               | Suffix |
#    | AEBC-19TRN1920      | Last Approved Version | A749c  |
#
#    Then  a report named 'CDA Last Approved Version A749c.csv' is created
#                    
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                |                                                                 | 8                 | 2019            | 2019/20       |              | 533          |              |               |              | Yes                | 533.00         | 0.00             | 0.00                  | 0.00           | 533.00          |             | No            |                   |        | 2355700           | 2355775                  |                   | Aug              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                |                                                                 | 9                 | 2019            | 2019/20       |              | 509          |              |               |              | Yes                | 509.00         | 0.00             | 0.00                  | 0.00           | 509.00          |             | No            |                   |        | 2355700           | 2355775                  |                   | Sep              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                |                                                                 | 10                | 2019            | 2019/20       |              | 3300         |              |               |              | Yes                | 3300.00        | 0.00             | 0.00                  | 0.00           | 3300.00         |             | No            |                   |        | 2355700           | 2355775                  |                   | Oct              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                |                                                                 | 11                | 2019            | 2019/20       |              | 2327         |              |               |              | Yes                | 2327.00        | 0.00             | 0.00                  | 0.00           | 2327.00         |             | No            |                   |        | 2355700           | 2355775                  |                   | Nov              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                |                                                                 | 12                | 2019            | 2019/20       |              | 563          |              |               |              | Yes                | 563.00         | 0.00             | 0.00                  | 0.00           | 563.00          |             | No            |                   |        | 2355700           | 2355775                  |                   | Dec              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                |                                                                 | 1                 | 2020            | 2019/20       |              | 2154         |              |               |              | Yes                | 2154.00        | 0.00             | 0.00                  | 0.00           | 2154.00         |             | No            |                   |        | 2355700           | 2355775                  |                   | Jan              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                |                                                                 | 2                 | 2020            | 2019/20       |              | 3048         |              |               |              | Yes                | 3048.00        | 0.00             | 0.00                  | 0.00           | 3048.00         |             | No            |                   |        | 2355700           | 2355775                  |                   | Feb              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                |                                                                 | 3                 | 2020            | 2019/20       |              | 365          |              |               |              | Yes                | 365.00         | 0.00             | 0.00                  | 0.00           | 365.00          |             | No            |                   |        | 2355700           | 2355775                  |                   | Mar              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                |                                                                 | 4                 | 2020            | 2020/21       |              | 2747         |              |               |              | Yes                | 2747.00        | 0.00             | 0.00                  | 0.00           | 2747.00         |             | No            |                   |        | 2355700           | 2355775                  |                   | Apr              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                |                                                                 | 5                 | 2020            | 2020/21       |              | 286          |              |               |              | Yes                | 286.00         | 0.00             | 0.00                  | 0.00           | 286.00          |             | No            |                   |        | 2355700           | 2355775                  |                   | May              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                |                                                                 | 6                 | 2020            | 2020/21       |              | 2984         |              |               |              | Yes                | 2984.00        | 0.00             | 0.00                  | 0.00           | 2984.00         |             | No            |                   |        | 2355700           | 2355775                  |                   | Jun              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                |                                                      | 19-24 Traineeships Total Funding                                |                                                                 | 7                 | 2020            | 2020/21       |              | 3276         |              |               |              | Yes                | 3276.00        | 0.00             | 0.00                  | 0.00           | 3276.00         |             | No            |                   |        | 2355700           | 2355775                  |                   | Jul              |
#    #
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships Total Funding                                | 8                 | 2019            | 2019/20       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships Total Funding                                | 9                 | 2019            | 2019/20       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships Total Funding                                | 10                | 2019            | 2019/20       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships Total Funding                                | 11                | 2019            | 2019/20       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships Total Funding                                | 12                | 2019            | 2019/20       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships Total Funding                                | 1                 | 2020            | 2019/20       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships Total Funding                                | 2                 | 2020            | 2019/20       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships Total Funding                                | 3                 | 2020            | 2019/20       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships Total Funding                                | 4                 | 2020            | 2020/21       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships Total Funding                                | 5                 | 2020            | 2020/21       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships Total Funding                                | 6                 | 2020            | 2020/21       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Learning Support                  | 19-24 Traineeships Learning Support                             | 19-24 Traineeships Total Funding                                | 7                 | 2020            | 2020/21       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    #
#	 | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships Total Funding                                | 8                 | 2019            | 2019/20       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships Total Funding                                | 9                 | 2019            | 2019/20       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships Total Funding                                | 10                | 2019            | 2019/20       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships Total Funding                                | 11                | 2019            | 2019/20       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships Total Funding                                | 12                | 2019            | 2019/20       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships Total Funding                                | 1                 | 2020            | 2019/20       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships Total Funding                                | 2                 | 2020            | 2019/20       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships Total Funding                                | 3                 | 2020            | 2019/20       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships Total Funding                                | 4                 | 2020            | 2020/21       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships Total Funding                                | 5                 | 2020            | 2020/21       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships Total Funding                                | 6                 | 2020            | 2020/21       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | AEBC-19TRN1920          | 10017749 | 10017749 Co Ltd             |               |                             | AECT-749                 | EDSK-749       | ESFA-749                | 01/08/2019                  | 31/07/2020                | 1                     | Approved       | Approved                | 19-24 Traineeships Programme Funding                 | 19-24 Traineeships Programme Funding                            | 19-24 Traineeships Total Funding                                | 7                 | 2020            | 2020/21       |              | 0            |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |



    # Change the date
    Given the override date is '06/02/2020 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEBC-19TRN1920' AccountingPaymentPeriod '201911' CensusEndDate '06/02/2020' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | AECT-749                 | 202002 |

    # PaymentGeneration.PaymentTimetable
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEBC-19TRN1920             | 202002               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEBC-19TRN1920             | 202002               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEBC-19TRN1920' PaymentPeriod '201911' CensusEndDate '06/02/2020' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A749_AECT.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    Then  the Payment feed xml for FundingStreamPeriod 'AEBC-19TRN1920' PaymentPeriod '201911' CensusEndDate '06/02/2020' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AECT                   | 2019          | 11             | 06          | ?       | AECT-749      | 3048.00         | PROFILE          | 19-24TrnGrant                      | 2020-02-20 | 2019-08-01   | 2020-07-31 | ?              | 10017749 | 2355700    |

    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'AEBC-19TRN1920' AccountingPaymentPeriod '201911' and CensusEndDate '06/02/2020'

    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                    |
    | Payment Requests for Funding Stream Period AEBC-19TRN1920 for Payment Period 201911 have been generated as of Census End Date/Time 2020-02-06T22:00:00Z. |

    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate        | PaymentLineCount | TotalValue |
    | AEBC-19TRN1920      | 201911        | 2020-02-06T22:00:00Z | 1                | 3048.00    |

    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | AECT      | 01/08/2019   | 31/07/2020 | 06/02/2020    | 20/02/2020 | 2019          | 11             |

    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017749  | 10017749       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AECT-749   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2355700    | PROFILE        | 19-24TrnGrant                 | 3048.00         |


    # Tidy up
    And the override date is reset
 
