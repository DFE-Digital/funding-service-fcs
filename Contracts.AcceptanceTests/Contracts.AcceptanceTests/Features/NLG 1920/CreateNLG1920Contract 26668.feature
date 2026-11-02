Feature: CreateNLG1920Contract 26668

@AcceptanceTest @Withdrawn20230123
Scenario: A733 Bulk load a new NLG1920 contract with both deliverables. Check docs. Publish and approve. Check CRM and PaaS.
    Given there are no allocations marked as Under Termination for UKPRN '10017733' 
    And   there are no terminated or closed allocations for UKPRN '10017733' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017733' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | NLG1920        |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017733' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017733 Co Ltd' with UKPRN '10017733' and OrgId 'ORG0017733' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017733' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017733 | 117733 | 10017733 Co Ltd | 0              | Active                | Yes           | AA017733      | ?             | 17 Quantock Avenue     | Caversham Park         | ?                      | ?                      | Reading                | Berkshire              | RG4 6PY   |

#    # Put the same Provider data in the CRM Organisation table 
#    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
#    | UKPRN    |
#    | 10017733 |




    # Change the date
    Given the override date is '23/08/2019'

    # Bulk file
    And   there are no files prefixed '10017733' in the Sharepoint 'NLG-1920-Input-Appendices' folder
    And   there are no files prefixed 'NLG AY 1920 12082019092129 v3_A733' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLG AY 1920 12082019092129 v3_A733' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLG AY 1920 12082019092129 v3_A733' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLG AY 1920 12082019092129 v3_A733.xlsx' exists in the Datafiles folder and UKPRN '10017733' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Contract status is now at 'Awaiting Documentation'
	
	# Retrieve parameters from CRM
    And   I retrieve the latest contract details from CRM for provider '10017733' for FundingType 'NLG' and period '1920'

    # Check the contents of the Appendices
    And   the file named '10017733_' & '[ContractNo]' & '_v1.pdf' created in Sharepoint location 'NLG-1920-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017733 Co Ltd UKPRN: 10017733
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: [AllocRef_NLG]
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Principals Reference Group (PRG) £34,080 £2,699 £2,040 £289 £3,431 £1,955 £544 £2,667 £4,248 £1,615 £1,563 £7,560 £5,469
    National Leaders of Further Education (NLFE) £43,794 £1,680 £5,097 £7,019 £1,255 £6,371 £1,085 £6,881 £7,508 £3,516 £1,700 £1,308 £374
    Total Funding £77,874 £4,379 £7,137 £7,308 £4,686 £8,326 £1,629 £9,548 £11,756 £5,131 £3,263 £8,868 £5,843
    19/20 Non-learning Grants – [AllocRef_NLG] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017733_[ContractNo]_v1.pdf' in 'NLG-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017733_NONLG-733_v1.pdf'




	# Change the date
	Given the override date is '24/08/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract 'NONLG-733' is in a state of 'Published to Provider'
	And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-733' and actual ContractNumber 'NONLG-733'
	When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

    # Check that the contract is now approved
   #Then  the latest version of contract 'NONLG-733' is in status 'Approved'
	Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017733 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017733 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'NONLG-733'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    



	# Check financials in CRM and PaaS

    # Check the PROFILE PAYMENTS in CRM
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | [ContractNo]   | [AllocRef_NLG]  | 101             | 31381.00  | 0.00     | 2040.00  | 289.00   | 3431.00  | 1955.00  | 544.00   | 2667.00  | 4248.00  | 1615.00  | 1563.00  | 7560.00  | 5469.00  | 
    | [ContractNo]   | [AllocRef_NLG]  | 102             | 42114.00  | 0.00     | 5097.00  | 7019.00  | 1255.00  | 6371.00  | 1085.00  | 6881.00  | 7508.00  | 3516.00  | 1700.00  | 1308.00  | 374.00   | 

    # Check the BALANCING PAYMENTS in CRM
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | [ContractNo]   | [AllocRef_NLG]  | 101             | 2699.00   | 0.00     | 2699.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_NLG]  | 102             | 1680.00   | 0.00     | 1680.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | [ContractNo]   | [AllocRef_NLG]  | 101             | 34080.00  | 0.00     | 4739.00  | 289.00   | 3431.00  | 1955.00  | 544.00   | 2667.00  | 4248.00  | 1615.00  | 1563.00  | 7560.00  | 5469.00  | 
    | [ContractNo]   | [AllocRef_NLG]  | 102             | 43794.00  | 0.00     | 6777.00  | 7019.00  | 1255.00  | 6371.00  | 1085.00  | 6881.00  | 7508.00  | 3516.00  | 1700.00  | 1308.00  | 374.00   | 

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | [ContractNo]   | [AllocRef_NLG]  | 101             | 34080.00  | 2699.00  | 2040.00  | 289.00   | 3431.00  | 1955.00  | 544.00   | 2667.00  | 4248.00  | 1615.00  | 1563.00  | 7560.00  | 5469.00  | 
    | [ContractNo]   | [AllocRef_NLG]  | 102             | 43794.00  | 1680.00  | 5097.00  | 7019.00  | 1255.00  | 6371.00  | 1085.00  | 6881.00  | 7508.00  | 3516.00  | 1700.00  | 1308.00  | 374.00   | 


    # Check the PROFILE subnominal aggregations in PaaS
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208100         | NLG1920                    | 201908               | PROFILE         | CM             | False       | 0.00            |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208200         | NLG1920                    | 201908               | PROFILE         | CM             | False       | 0.00            |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208100         | NLG1920                    | 201909               | PROFILE         | CM             | False       | 4739.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208200         | NLG1920                    | 201909               | PROFILE         | CM             | False       | 6777.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208100         | NLG1920                    | 201910               | PROFILE         | CM             | False       | 289.00          |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208200         | NLG1920                    | 201910               | PROFILE         | CM             | False       | 7019.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208100         | NLG1920                    | 201911               | PROFILE         | CM             | False       | 3431.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208200         | NLG1920                    | 201911               | PROFILE         | CM             | False       | 1255.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208100         | NLG1920                    | 201912               | PROFILE         | CM             | False       | 1955.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208200         | NLG1920                    | 201912               | PROFILE         | CM             | False       | 6371.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208100         | NLG1920                    | 202001               | PROFILE         | CM             | False       | 544.00          |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208200         | NLG1920                    | 202001               | PROFILE         | CM             | False       | 1085.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208100         | NLG1920                    | 202002               | PROFILE         | CM             | False       | 2667.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208200         | NLG1920                    | 202002               | PROFILE         | CM             | False       | 6881.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208100         | NLG1920                    | 202003               | PROFILE         | CM             | False       | 4248.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208200         | NLG1920                    | 202003               | PROFILE         | CM             | False       | 7508.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208100         | NLG1920                    | 202004               | PROFILE         | CM             | False       | 1615.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208200         | NLG1920                    | 202004               | PROFILE         | CM             | False       | 3516.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208100         | NLG1920                    | 202005               | PROFILE         | CM             | False       | 1563.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208200         | NLG1920                    | 202005               | PROFILE         | CM             | False       | 1700.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208100         | NLG1920                    | 202006               | PROFILE         | CM             | False       | 7560.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208200         | NLG1920                    | 202006               | PROFILE         | CM             | False       | 1308.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208100         | NLG1920                    | 202007               | PROFILE         | CM             | False       | 5469.00         |
    | 10017733 | ORG0017733 | [AllocRef_NLG]    | 2208200         | NLG1920                    | 202007               | PROFILE         | CM             | False       | 374.00          |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
@Long2Run @Long2Run67
Scenario: A734 Create a new NLG1920 contract with one deliverable. Bulk update draft to add second deliverable. Publish and approve. Check CRM and PaaS. Amend and approve. Check docs and CRM. Non-financial variation amendment. Check docs and CRM
    Given there are no allocations marked as Under Termination for UKPRN '10017734' 
    And   there are no terminated or closed allocations for UKPRN '10017734' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017734' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | NLG1920        |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017734' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017734 Co Ltd' with UKPRN '10017734' and OrgId 'ORG0017734' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017734' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017734 | 117734 | 10017734 Co Ltd | 0              | Active                | Yes           | AA017734      | ?             | 10 Manor Walk          | Market Harborough      | Leicestershire         | ?                      | ?                      | ?                      | LE16 9PB  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017734 |




    # Change the date
    Given the override date is '20/08/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017734 | 10017734 Co Ltd      | ESFA-734             | NONLG-734      | 1                     | 01/08/2019        | 31/07/2020      | 22331.00      |                                    | Contract for Services                      | 1920   | New          | ORG0017734 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017734 | NONLG-734      | NLG-734       | NLG               | NLG1920                 | AY                      | 01/08/2019          | 31/07/2020        | 22331.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017734 | NONLG-734      | NLG-734       | 101             | 0                     | 22331.00  | 2427.00  | 1770.00  | 2758.00  | 3494.00  | 2269.00  | 2244.00  | 1335.00  | 362.00   | 2299.00  | 189.00   | 1083.00  | 2101.00  | Principals Reference Group (PRG)                                | New          |             |
   #| 10017734 | NONLG-734      | NLG-734       | 102             | 0                     | 27368.00  | 1133.00  | 2373.00  | 1370.00  | 1662.00  | 3505.00  | 2660.00  | 2477.00  | 2042.00  | 3347.00  | 3134.00  | 1054.00  | 2611.00  | National Leaders of Further Education (NLFE)                    | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM 
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'NONLG-734'




	# Update Draft Contract

    # Change the date
    Given the override date is '23/08/2019'

    # Bulk update draft to add a second deliverable and change the financials on the first
    And   there are no files prefixed '10017734' in the Sharepoint 'NLG-1920-Input-Appendices' folder
    And   there are no files prefixed 'NLG AY 1920 12082019134557 v3_A734' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLG AY 1920 12082019134557 v3_A734' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLG AY 1920 12082019134557 v3_A734' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLG AY 1920 12082019134557 v3_A734.xlsx' exists in the Datafiles folder and UKPRN '10017734' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report



    # Check docs

    # Check the contents of the Appendices
   #And   the file named '10017734_' & '[ContractNo]' & '_v1.pdf' created in Sharepoint location 'NLG-1920-Input-Appendices' contains the following lines in order
    And   the file named '10017734_' & 'NONLG-734' & '_v1.pdf' created in Sharepoint location 'NLG-1920-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017734 Co Ltd UKPRN: 10017734
    Master Contract Number: ESFA-734 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: NLG-734
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Principals Reference Group (PRG) £22,100 £0 £13,125 £0 £0 £8,975 £0 £0 £0 £0 £0 £0 £0
    National Leaders of Further Education (NLFE) £26,105 £0 £15,105 £0 £0 £11,000 £0 £0 £0 £0 £0 £0 £0
    Total Funding £48,205 £0 £28,230 £0 £0 £19,975 £0 £0 £0 £0 £0 £0 £0
    19/20 Non-learning Grants – NLG-734 – Page 1 Ref (for internal use only):  NONLG-734 v1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   #And   Sharepoint file '10017734_[ContractNo]_v1.pdf' in 'NLG-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '<filename2>.pdf'
    And   Sharepoint file '10017734_NONLG-734_v1.pdf' in 'NLG-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A734v1.pdf'




    # Change the date
    Given the override date is '24/08/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NONLG-734' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-734' and actual ContractNumber 'NONLG-734'

    # Check that the contract is now approved
    Then  the latest version of contract 'NONLG-734' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017734 | NONLG-734          | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017734 | NONLG-734          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017734 | ESFA-734           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM 
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'NONLG-734'




    # Check CRM and PaaS

    # Check the PROFILE PAYMENTS in CRM
    Then  the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | NONLG-734      | NLG-734         | 101             | 22100.00  | 0.00     | 13125.00 | 0.00     | 0.00     | 8975.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NONLG-734      | NLG-734         | 102             | 26105.00  | 0.00     | 15105.00 | 0.00     | 0.00     | 11000.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | NONLG-734      | NLG-734         | 101             | 22100.00  | 0.00     | 13125.00 | 0.00     | 0.00     | 8975.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NONLG-734      | NLG-734         | 102             | 26105.00  | 0.00     | 15105.00 | 0.00     | 0.00     | 11000.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

   # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   |
    | NONLG-734      | NLG-734         | 101             | 22100.00  | 0.00     | 13125.00 | 0.00     | 0.00     | 8975.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | NONLG-734      | NLG-734         | 102             | 26105.00  | 0.00     | 15105.00 | 0.00     | 0.00     | 11000.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 


    # Check the PROFILE subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017734 | ORG0017734 | NLG-734           | 2208100         | NLG1920                    | 201908               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208200         | NLG1920                    | 201908               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208100         | NLG1920                    | 201909               | PROFILE         | CM             | False       | 13125.00        |
    | 10017734 | ORG0017734 | NLG-734           | 2208200         | NLG1920                    | 201909               | PROFILE         | CM             | False       | 15105.00        |
    | 10017734 | ORG0017734 | NLG-734           | 2208100         | NLG1920                    | 201910               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208200         | NLG1920                    | 201910               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208100         | NLG1920                    | 201911               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208200         | NLG1920                    | 201911               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208100         | NLG1920                    | 201912               | PROFILE         | CM             | False       | 8975.00         |
    | 10017734 | ORG0017734 | NLG-734           | 2208200         | NLG1920                    | 201912               | PROFILE         | CM             | False       | 11000.00        |
    | 10017734 | ORG0017734 | NLG-734           | 2208100         | NLG1920                    | 202001               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208200         | NLG1920                    | 202001               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208100         | NLG1920                    | 202002               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208200         | NLG1920                    | 202002               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208100         | NLG1920                    | 202003               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208200         | NLG1920                    | 202003               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208100         | NLG1920                    | 202004               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208200         | NLG1920                    | 202004               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208100         | NLG1920                    | 202005               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208200         | NLG1920                    | 202005               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208100         | NLG1920                    | 202006               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208200         | NLG1920                    | 202006               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208100         | NLG1920                    | 202007               | PROFILE         | CM             | False       | 0.00            |
    | 10017734 | ORG0017734 | NLG-734           | 2208200         | NLG1920                    | 202007               | PROFILE         | CM             | False       | 0.00            |




	# Amend Contract

    # Change the date
    Given the override date is '25/08/2019'

    # Bulk amendment
    And   there are no files prefixed '10017734' in the Sharepoint 'NLG-1920-Input-Appendices' folder
    And   there are no files prefixed 'NLG AY 1920 12082019134558 v3_A734_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLG AY 1920 12082019134558 v3_A734_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLG AY 1920 12082019134558 v3_A734_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLG AY 1920 12082019134558 v3_A734_1.xlsx' exists in the Datafiles folder and UKPRN '10017734' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report



    # Check docs

    # Check the contents of the Appendices
   #And   the file named '10017734_' & '[ContractNo]' & '_v2.pdf' created in Sharepoint location 'NLG-1920-Input-Appendices' contains the following lines in order
    And   the file named '10017734_' & 'NONLG-734' & '_v2.pdf' created in Sharepoint location 'NLG-1920-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017734 Co Ltd UKPRN: 10017734
    Master Contract Number: ESFA-734 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: NLG-734
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Principals Reference Group (PRG) £22,100 £0 £13,125 £0 £0 £8,975 £0 £0 £0 £0 £0 £0 £0
    National Leaders of Further Education (NLFE) £26,105 £0 £15,105 £0 £0 £11,000 £0 £0 £0 £0 £0 £0 £0
    Total Funding £48,205 £0 £28,230 £0 £0 £19,975 £0 £0 £0 £0 £0 £0 £0
    19/20 Non-learning Grants – NLG-734 – Page 1 Ref (for internal use only):  NONLG-734 v2
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   #And   Sharepoint file '10017734_[ContractNo]_v2.pdf' in 'NLG-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '<filename2>.pdf'
    And   Sharepoint file '10017734_NONLG-734_v2.pdf' in 'NLG-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A734v2.pdf'




    # Change the date
    Given the override date is '28/08/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NONLG-734' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-734' and actual ContractNumber 'NONLG-734'

    # Check that the contract is now approved
    Then  the latest version of contract 'NONLG-734' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017734 | NONLG-734          | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017734 | NONLG-734          | 1                     | 1                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017734 | NONLG-734          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017734 | ESFA-734           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM 
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'NONLG-734'




    # Execute a NON-FINANCIAL amendment and check docs

    # Change the date
    Given the override date is '04/09/2019'

    # Issue a non-financial VARIATION amendment on v2 to create v3
   #When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'NONLG-734' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'NONLG-734' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017734 | NONLG-734          | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017734 | NONLG-734          | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017734 | NONLG-734          | 1                     | 1                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017734 | NONLG-734          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017734 | ESFA-734           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |




    # Check docs

    # Check the contents of the Appendices
   #And   the file named '10017734_' & '[ContractNo]' & '_v3.pdf' created in Sharepoint location 'NLG-1920-Input-Appendices' contains the following lines in order
    And   the file named '10017734_' & 'NONLG-734' & '_v3.pdf' created in Sharepoint location 'NLG-1920-Input-Appendices' contains the following lines in order
    """
    Annex H – Grant payment schedule
    Provider: 10017734 Co Ltd UKPRN: 10017734
    Master Contract Number: ESFA-734 Start Date: 01/08/2019 End Date: 31/07/2020
    Contract Ref: NLG-734
    Cash (£) Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020 Apr 2020 May 2020 Jun 2020 Jul 2020
    Principals Reference Group (PRG) £22,100 £0 £13,125 £0 £0 £8,975 £0 £0 £0 £0 £0 £0 £0
    National Leaders of Further Education (NLFE) £26,105 £0 £15,105 £0 £0 £11,000 £0 £0 £0 £0 £0 £0 £0
    Total Funding £48,205 £0 £28,230 £0 £0 £19,975 £0 £0 £0 £0 £0 £0 £0
    19/20 Non-learning Grants – NLG-734 – Page 1 Ref (for internal use only):  NONLG-734 v3
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
   #And   Sharepoint file '10017734_[ContractNo]_v3.pdf' in 'NLG-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '<filename2>.pdf'
    And   Sharepoint file '10017734_NONLG-734_v3.pdf' in 'NLG-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A734v3.pdf'




    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'NONLG-734' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '3' actual MasterContractNumber 'ESFA-734' and actual ContractNumber 'NONLG-734'

    # Check that the contract is now approved
    Then  the latest version of contract 'NONLG-734' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017734 | NONLG-734          | 3                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017734 | NONLG-734          | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017734 | NONLG-734          | 1                     | 1                        | Replaced         | Approved                  | False         | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017734 | NONLG-734          | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | ?             |
    | 10017734 | ESFA-734           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM 
   #And   there are '24' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'NONLG-734'

	# Tidy up
	And   the override date is reset
	   
	     