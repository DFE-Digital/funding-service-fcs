Feature: AEBP1920FundingAgreements 26148

@AcceptanceTest @Withdrawn20231002
@Long2Run @Long2Run123
Scenario: A176 Create and approve a 1718 AEBP contract. Create a draft 1819 AEBP contract. Bulk update draft 1819. Approve 1819. Non-Financial notification amendment on 1819. Bulk amend and approve 1819. New Amendment for 1920 AEBP. Check CRM and docs.
    Given there are no allocations marked as Under Termination for UKPRN '10017176' 
    And   there are no terminated or closed allocations for UKPRN '10017176' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017176' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | AEB-CL1718     |
    | AEB-LS1718     |
    | AEB-TOL1718    |
	#
    | AEB-CL1819     |
    | AEB-LS1819     |
    | AEB-TOL1819    |
    #
	| AEB-19TRLS1920 |
    | AEB-19TRN1920  |
    | AEB-ASLS1920   |
    | AEB-CL1920     |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017176' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017176 Co Ltd' with UKPRN '10017176' and OrgId 'ORG0017176' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017176' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017176 | 117176 | 10017176 Co Ltd | 0              | Active                | Yes           | AA017176      | ?             | 19 Watling Street      | Canterbury             | Kent                   | ?                      | ?                      | ?                      | CT1 2UA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017176 |




	# Create and approve a 1718 AEBP contract

    # Change the date
    Given the override date is '06/01/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017176 | 10017176 Co Ltd      | ESFA-176             | AEBP-1761      | 1                     | 01/01/2018        | 31/07/2018      | 36815.00      |                                    | Contract for Services                      | 1718   | New          | ORG0017176 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017176 | AEBP-1761      | AEBC-1761     | AEB-CL            | AEB-CL1718              | AY                      | 01/01/2018          | 31/07/2018        | 12475.00        |                                         |            |                                                             | New          |             |
    | 10017176 | AEBP-1761      | AEBL-1761     | AEB-LS            | AEB-LS1718              | AY                      | 01/01/2018          | 31/07/2018        | 9851.00         |                                         |            |                                                             | New          |             |
    | 10017176 | AEBP-1761      | AEBT-1761     | AEB-TOL           | AEB-TOL1718             | AY                      | 01/01/2018          | 31/07/2018        | 14489.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017176 | AEBP-1761      | AEBC-1761     | 1               | 0                     | 12475.00  | 539.00   | 514.00   | 3306.00  | 2333.00  | 569.00   | 2160.00  | 3054.00  | Adult Education Budget - Community Learning                     | New          |             |
    | 10017176 | AEBP-1761      | AEBL-1761     | 1               | 0                     | 9851.00   | 1695.00  | 375.00   | 1616.00  | 612.00   | 904.00   | 2747.00  | 1902.00  | Adult Education Budget - Learner Support                        | New          |             |
    | 10017176 | AEBP-1761      | AEBT-1761     | 1               | 0                     | 14489.00  | 1829.00  | 1394.00  | 2699.00  | 2486.00  | 406.00   | 1963.00  | 3712.00  | Adult Education - Traineeships and Other Learning Total Funding | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-1761' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/01/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-176' and actual ContractNumber 'AEBP-1761'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-1761' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017176 | AEBP-1761          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/07/2018      | ?             |
    | 10017176 | ESFA-176           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '56' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '56' deliverable period rows in CRM linked to the latest version of contract 'AEBP-1761'




	# Create a draft 1819 AEBP contract 

    # Change the date
    Given the override date is '05/08/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017176 | 10017176 Co Ltd      | ESFA-176             | AEBP-1762      | 1                     | 01/08/2018        | 31/07/2019      | 39873.00      |                                    | Contract for Services                      | 1819   | New          | ORG0017176 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017176 | AEBP-1762      | AEBC-1762     | AEB-CL            | AEB-CL1819              | AY                      | 01/08/2018          | 31/07/2019        | 18348.00        |                                         |            |                                                             | New          |             |
    | 10017176 | AEBP-1762      | AEBL-1762     | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 21525.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017176 | AEBP-1762      | AEBC-1762     | 1               | 0                     | 18348.00  | 856.00   | 1592.00  | 3084.00  | 342.00   | 3134.00  | 2160.00  | 396.00   | 1987.00  | 1898.00  | 199.00   | 2580.00  | 120.00   | Adult Education Budget - Community Learning                     | New          |             |
    | 10017176 | AEBP-1762      | AEBL-1762     | 1               | 0                     | 21525.00  | 269.00   | 561.00   | 2404.00  | 576.00   | 1376.00  | 941.00   | 2246.00  | 2033.00  | 3654.00  | 1510.00  | 3259.00  | 2696.00  | Adult Education Budget - Learner Support                        | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'




    # Bulk update draft 1819 contract and check docs

	# Change the date
    Given the override date is '17/08/2018'

    # Bulk file to add a TOL allocation and change all financials.  All three 1819 Funding Agreements should be produced. No Funding Agreements for 1718
    And   there are no files prefixed '10017176' in the Sharepoint 'AEB-1819-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1819 30082019115611 v3_A176_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1819 30082019115611 v3_A176_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1819 30082019115611 v3_A176_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1819 30082019115611 v3_A176_1.xlsx' exists in the Datafiles folder and UKPRN '10017176' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017176' for FundingType 'AEB' and period '1819' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017176' for FundingType 'AEB' and period '1819'

    # Check the contents of the Appendices
   #And   the file named '10017176_' & '[ContractNo]' & '_v1.pdf' created in Sharepoint location 'AEB-1819-Input-Appendices' contains the following lines in order
   #And   the file named '10017176_' & 'AEBP-1762' & '_v1.pdf' created in Sharepoint location 'AEB-1819-Input-Appendices' contains the following lines in order
    Then  the file named '10017176_AEBP-1762_v1.pdf' in Sharepoint location 'AEB-1819-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017176 Co Ltd UKPRN: 10017176
    Master Contract Number: ESFA-176
    Allocation
    1 November 2017 to 31 July 2018 Contract Ref Nov 17 - Mar 18 Apr 18 - Jul 18 Total
    Adult Education Budget - Traineeships and Other Learning AEBT-1761 £5,922 £8,567 £14,489
    Adult Education Budget - Community Learning AEBC-1761 £4,359 £8,116 £12,475
    Adult Education Budget - Learner Support AEBL-1761 £3,686 £6,165 £9,851
    Total: £36,815
    Allocation
    1 August 2018 to 31 July 2019 Contract Ref Aug 18 - Mar 19 Apr 19 - Jul 19 Total
    Adult Education Budget - Traineeships and Other Learning [AllocRef_AEBT] £27,188 £18,888 £46,076
    Adult Education Budget - Community Learning AEBC-1762 £19,982 £17,262 £37,244
    Adult Education Budget - Learner Support AEBL-1762 £36,814 £18,783 £55,597
    Total: £138,917
    Total Funding for this contract: £175,732

    Funding Agreement Adult Education Budget - Traineeships and Other Learning
    Provider: 10017176 Co Ltd UKPRN: 10017176
    Master Contract Ref: ESFA-176 Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: [AllocRef_AEBT]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Adult Education - Traineeships and Other Learning £46,076 £1,550 £938 £3,575 £6,920 £2,726 £3,628 £3,034 £4,817 £5,306 £7,567 £2,896 £3,119
    Total Funding £46,076 £1,550 £938 £3,575 £6,920 £2,726 £3,628 £3,034 £4,817 £5,306 £7,567 £2,896 £3,119
    Ref (for internal use only):  AEBP-1762 v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement Adult Education Budget - Community Learning
    Provider: 10017176 Co Ltd UKPRN: 10017176
    Master Contract Ref: ESFA-176 Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: AEBC-1762
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Adult Education Budget - Community Learning £37,244 £2,963 £2,304 £552 £3,695 £2,219 £807 £2,930 £4,512 £1,879 £1,826 £7,824 £5,733
    Total Funding £37,244 £2,963 £2,304 £552 £3,695 £2,219 £807 £2,930 £4,512 £1,879 £1,826 £7,824 £5,733
    Ref (for internal use only):  AEBP-1762 v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement Adult Education Budget - Learner Support
    Provider: 10017176 Co Ltd UKPRN: 10017176
    Master Contract Ref: ESFA-176 Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: AEBL-1762
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Adult Education Budget - Learner Support £55,597 £6,639 £2,106 £4,027 £6,214 £3,379 £6,044 £3,889 £4,516 £524 £6,659 £6,267 £5,333
    Total Funding £55,597 £6,639 £2,106 £4,027 £6,214 £3,379 £6,044 £3,889 £4,516 £524 £6,659 £6,267 £5,333
    Ref (for internal use only):  AEBP-1762 v1
    Page 1 of 1 of this Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   #And   Sharepoint file '10017176_[ContractNo]_v1.pdf' in 'AEB-1819-Input-Appendices' is copied to 'Datafiles/Downloads' as '<filename2>.pdf'
    And   Sharepoint file '10017176_AEBP-1762_v1.pdf' in 'AEB-1819-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017176_AEBP-1762_v1.pdf'	  




	# Publish and approve 1819 AEBP contract v1

	# Change the date
	Given the override date is '19/08/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-1762' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-176' and actual ContractNumber 'AEBP-1762'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-1762' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017176 | AEBP-1762          | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017176 | AEBP-1762          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    #
	| 10017176 | AEBP-1761          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/07/2018      | ?             |
    | 10017176 | ESFA-176           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'AEBP-1762'




	# Execute a NON-FINANCIAL amendment on 1819 AEBP and check docs

	# Change the date
	Given the override date is '21/08/2018'

	# Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced. No Funding Agreements.
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '1' of contract 'AEBP-1762' for a non-financial VARIATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '1' of contract 'AEBP-1762' for a non-financial NOTIFICATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017176 | AEBP-1762          | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2018        | 31/07/2019      | Notification  |
    | 10017176 | AEBP-1762          | 1                     | 1                        | Approved         | Approved                  | False         | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017176 | AEBP-1762          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    #
	| 10017176 | AEBP-1761          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/07/2018      | ?             |
    | 10017176 | ESFA-176           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/07/2018      | ?             |

#    # Retrieve parameters for the Contracting Org
#   #And  I retrieve the latest EFA contract details from CRM for provider '10017176' for FundingType 'AEB' and period '1819' and Delivery Organisation '10017176'
#   And   I retrieve the latest contract details from CRM for provider '10017176' for FundingType 'AEB' and period '1819'

    # Check the contents of the Appendices. Summary of Funding, yes. Funding Agreements, no. 
    And   the file named '10017176_' & 'AEBP-1762' & '_v2.pdf' created in Sharepoint location 'AEB-1819-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017176 Co Ltd UKPRN: 10017176
    Master Contract Number: ESFA-176
    Allocation
    1 November 2017 to 31 July 2018 Contract Ref Nov 17 - Mar 18 Apr 18 - Jul 18 Total
    Adult Education Budget - Traineeships and Other Learning AEBT-1761 £5,922 £8,567 £14,489
    Adult Education Budget - Community Learning AEBC-1761 £4,359 £8,116 £12,475
    Adult Education Budget - Learner Support AEBL-1761 £3,686 £6,165 £9,851
    Total: £36,815
    Allocation
    1 August 2018 to 31 July 2019 Contract Ref Aug 18 - Mar 19 Apr 19 - Jul 19 Total
    Adult Education Budget - Traineeships and Other Learning [AllocRef_AEBT] £27,188 £18,888 £46,076
    Adult Education Budget - Community Learning AEBC-1762 £19,982 £17,262 £37,244
    Adult Education Budget - Learner Support AEBL-1762 £36,814 £18,783 £55,597
    Total: £138,917
    Total Funding for this contract: £175,732
    """

    # There should be no Funding Agreements for 1718
    And   the pdf file does not contain the following text
    """
    Master Contract Ref: ESFA-176 Start Date: 01/08/2017 End Date: 31/07/2018
    """

    # There should be no Funding Agreements for 1819
    And   the pdf file does not contain the following text
    """
    Master Contract Ref: ESFA-176 Start Date: 01/08/2018 End Date: 31/07/2019
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   #And   Sharepoint file '10017176_[ContractNo]_v2.pdf' in 'AEB-1819-Input-Appendices' is copied to 'Datafiles/Downloads' as '<filename2>.pdf'
    And   Sharepoint file '10017176_AEBP-1762_v2.pdf' in 'AEB-1819-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017176_AEBP-1762_v2.pdf'	  




	# Publish and approve 1819 AEBP contract v2

	# Change the date
	Given the override date is '24/08/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-1762' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-176' and actual ContractNumber 'AEBP-1762'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-1762' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017176 | AEBP-1762          | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | Notification  |
    | 10017176 | AEBP-1762          | 1                     | 1                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017176 | AEBP-1762          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    #
	| 10017176 | AEBP-1761          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/07/2018      | ?             |
    | 10017176 | ESFA-176           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'AEBP-1762'




    # Bulk amend 1819 contract and check docs

	# Change the date
    Given the override date is '27/08/2018'

    # Bulk file to change AEB-CL1819 allocation end-date by one day from 31/07/2019 to 30/07/2019
    And   there are no files prefixed '10017176' in the Sharepoint 'AEB-1819-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1819 30082019115612 v3_A176_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1819 30082019115612 v3_A176_2' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1819 30082019115612 v3_A176_2' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1819 30082019115612 v3_A176_2.xlsx' exists in the Datafiles folder and UKPRN '10017176' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

#    # Retrieve parameters
#   #And   I retrieve the latest EFA contract details from CRM for provider '10017176' for FundingType 'AEB' and period '1819' and Delivery Organisation '00000000'
#    And   I retrieve the latest contract details from CRM for provider '10017176' for FundingType 'AEB' and period '1819'

    # Check the contents of the Appendices
   #And   a file for this contract exists in sharepoint location 'AEB-1819-Input-Appendices'
   #And   the pdf file contains the following page lines in order
   #And   the file named '10017176_' & '[ContractNo]' & '_v3.pdf' created in Sharepoint location 'AEB-1819-Input-Appendices' contains the following lines in order
    And   the file named '10017176_' & 'AEBP-1762' & '_v3.pdf' created in Sharepoint location 'AEB-1819-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017176 Co Ltd UKPRN: 10017176
    Master Contract Number: ESFA-176
    Allocation
    1 November 2017 to 31 July 2018 Contract Ref Nov 17 - Mar 18 Apr 18 - Jul 18 Total
    Adult Education Budget - Traineeships and Other Learning AEBT-1761 £5,922 £8,567 £14,489
    Adult Education Budget - Community Learning AEBC-1761 £4,359 £8,116 £12,475
    Adult Education Budget - Learner Support AEBL-1761 £3,686 £6,165 £9,851
    Total: £36,815
    Allocation
    1 August 2018 to 31 July 2019 Contract Ref Aug 18 - Mar 19 Apr 19 - Jul 19 Total
    Adult Education Budget - Traineeships and Other Learning [AllocRef_AEBT] £27,188 £18,888 £46,076
    Adult Education Budget - Community Learning AEBC-1762 £19,982 £17,262 £37,244
    Adult Education Budget - Learner Support AEBL-1762 £36,814 £18,783 £55,597
    Total: £138,917
    Total Funding for this contract: £175,732

    Funding Agreement Adult Education Budget - Community Learning
    Provider: 10017176 Co Ltd UKPRN: 10017176
    Master Contract Ref: ESFA-176 Start Date: 01/08/2018 End Date: 30/07/2019
    Contract Ref: AEBC-1762
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Adult Education Budget - Community Learning £37,244 £2,963 £2,304 £552 £3,695 £2,219 £807 £2,930 £4,512 £1,879 £1,826 £7,824 £5,733
    Total Funding £37,244 £2,963 £2,304 £552 £3,695 £2,219 £807 £2,930 £4,512 £1,879 £1,826 £7,824 £5,733
    Ref (for internal use only):  AEBP-1762 v3
    Page 1 of 1 of this Funding Agreement
    """

    # There shouldn't be any 1718 Funding Agreements
    And   the pdf file does not contain the following text
    """
    Master Contract Ref: ESFA-176 Start Date: 01/08/2017 End Date: 31/07/2018
    """

    # There shouldn't be 1819 Funding Agreements for 'Traineeships and Other Learning' or 'Learner Support'
    And   the pdf file does not contain the following text
    """
    Funding Agreement Adult Education Budget - Traineeships and Other Learning
    """

	And   the pdf file does not contain the following text
    """
    Funding Agreement Adult Education Budget - Learner Support
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   #And   Sharepoint file '10017176_[ContractNo]_v3.pdf' in 'AEB-1819-Input-Appendices' is copied to 'Datafiles/Downloads' as '<filename2>.pdf'
    And   Sharepoint file '10017176_AEBP-1762_v3.pdf' in 'AEB-1819-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017176_AEBP-1762_v3.pdf'	
	



	# Publish and approve 1819 AEBP contract v3

	# Change the date
	Given the override date is '29/08/2018'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-1762' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '3' actual MasterContractNumber 'ESFA-176' and actual ContractNumber 'AEBP-1762'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-1762' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017176 | AEBP-1762          | 3                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017176 | AEBP-1762          | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | Notification  |
    | 10017176 | AEBP-1762          | 1                     | 1                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017176 | AEBP-1762          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2018        | 31/07/2019      | ?             |
    #
	| 10017176 | AEBP-1761          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/07/2018      | ?             |
    | 10017176 | ESFA-176           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'AEBP-1762'




    # Bulk import a 'New Amendment' 1920 contract with the same Master as 1718 and 1819. Check docs

	# Change the date
    Given the override date is '06/08/2019'

    # Bulk 'New Amendment' to add 5-allocation 1920 AEBP contract
    And   there are no files prefixed '10017176' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1920 30082019115613 v3_A176_3' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1920 30082019115613 v3_A176_3' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1920 30082019115613 v3_A176_3' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1920 30082019115613 v3_A176_3.xlsx' exists in the Datafiles folder and UKPRN '10017176' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017176' for FundingType 'AEB' and period '1920' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017176' for FundingType 'AEB' and period '1920'




    # Check the contents of the Appendices
   #And   the file named '10017176_' & 'AEBP-1762' & '_v1.pdf' created in Sharepoint location 'AEB-1920-Input-Appendices' contains the following lines in order
    And   the file named '10017176_' & '[ContractNo]' & '_v1.pdf' created in Sharepoint location 'AEB-1920-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017176 Co Ltd UKPRN: 10017176
    Master Contract Number: ESFA-176
    Allocation
    1 November 2017 to 31 July 2018 Contract Ref Nov 17 - Mar 18 Apr 18 - Jul 18 Total
    Adult Education Budget - Traineeships and Other Learning AEBT-1761 £5,922 £8,567 £14,489
    Adult Education Budget - Community Learning AEBC-1761 £4,359 £8,116 £12,475
    Adult Education Budget - Learner Support AEBL-1761 £3,686 £6,165 £9,851
    Total: £36,815
    Allocation
    1 August 2018 to 31 July 2019 Contract Ref Aug 18 - Mar 19 Apr 19 - Jul 19 Total
    Adult Education Budget - Traineeships and Other Learning [AllocRef_AEBT] £27,188 £18,888 £46,076
    Adult Education Budget - Community Learning AEBC-1762 £19,982 £17,262 £37,244
    Adult Education Budget - Learner Support AEBL-1762 £36,814 £18,783 £55,597
    Total: £138,917
    Allocation
    1 August 2019 to 31 July 2020 Contract Ref Aug 19 - Mar 20 Apr 20 - Jul 20 Total
    ESFA AEB - 19 to 24 Traineeships [AllocRef_AEBR] £23,161 £15,933 £39,094
    ESFA AEB - Adult Skills [AllocRef_AEBA] £39,578 £14,078 £53,656
    ESFA AEB - Community Learning [AllocRef_AEBC] £28,941 £13,792 £42,733
    ESFA AEB - 19 to 24 Traineeships Learner Support [AllocRef_AETL] £25,938 £12,291 £38,229
    ESFA AEB - Adult Skills Learner Support [AllocRef_AEAL] £20,713 £15,516 £36,229
    Total: £209,941
    Total Funding for this contract: £385,673

    Funding Agreement ESFA-Funded Adult Education Budget - 19 to 24 Traineeships
    Provider: 10017176 Co Ltd UKPRN: 10017176
    Master Contract Number: ESFA-176 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AEBR]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - 19 to 24 Traineeships £39,094 £3,938 £7,356 £1,326 £3,514 £679 £3,344 £1,189 £1,815 £5,775 £3,959 £3,567 £2,632
    Total Funding £39,094 £3,938 £7,356 £1,326 £3,514 £679 £3,344 £1,189 £1,815 £5,775 £3,959 £3,567 £2,632
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - Adult Skills
    Provider: 10017176 Co Ltd UKPRN: 10017176
    Master Contract Number: ESFA-176 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AEBA]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills £53,656 £3,323 £2,867 £6,349 £1,742 £5,499 £6,401 £5,807 £7,590 £128 £2,389 £5,669 £5,892
    Total Funding £53,656 £3,323 £2,867 £6,349 £1,742 £5,499 £6,401 £5,807 £7,590 £128 £2,389 £5,669 £5,892
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - Community Learning
    Provider: 10017176 Co Ltd UKPRN: 10017176
    Master Contract Number: ESFA-176 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AEBC]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Community Learning £42,733 £2,421 £2,166 £2,930 £637 £7,516 £669 £5,308 £7,294 £7,177 £1,689 £2,251 £2,675
    Total Funding £42,733 £2,421 £2,166 £2,930 £637 £7,516 £669 £5,308 £7,294 £7,177 £1,689 £2,251 £2,675
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - 19 to 24 Traineeships Learner Support
    Provider: 10017176 Co Ltd UKPRN: 10017176
    Master Contract Number: ESFA-176 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AETL]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - 19 to 24 Traineeships Learner Support £38,229 £3,707 £3,048 £1,297 £4,439 £2,963 £1,552 £3,675 £5,257 £2,624 £2,571 £618 £6,478
    Total Funding £38,229 £3,707 £3,048 £1,297 £4,439 £2,963 £1,552 £3,675 £5,257 £2,624 £2,571 £618 £6,478
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement

    Funding Agreement ESFA-Funded Adult Education Budget - Adult Skills Learner Support
    Provider: 10017176 Co Ltd UKPRN: 10017176
    Master Contract Number: ESFA-176 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_AEAL]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    ESFA AEB - Adult Skills Learner Support £36,229 £612 £2,120 £1,323 £5,824 £272 £3,139 £6,217 £1,206 £336 £6,674 £3,563 £4,943
    Total Funding £36,229 £612 £2,120 £1,323 £5,824 £272 £3,139 £6,217 £1,206 £336 £6,674 £3,563 £4,943
    Ref (for internal use only):  [ContractNo] v1
    Page 1 of 1 of this Funding Agreement
    """

    # There shouldn't be any 1718 Funding Agreements
    And   the pdf file does not contain the following text
    """
    Master Contract Ref: ESFA-176 Start Date: 01/08/2017 End Date: 31/07/2018
    """
	
	# There shouldn't be any 1819 Funding Agreements
	And   the pdf file does not contain the following text
    """
    Master Contract Ref: ESFA-176 Start Date: 01/08/2018 End Date: 31/07/2019
    """


	# Tidy up
	And   the override date is reset

